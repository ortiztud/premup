## MLM analysis of the object recognition memory test on PREMUP-three.
# Author: Javier Ortiz-Tudela (Goethe Uni)
# Started on: 21.01.20
# Last updated on: 21.01.20

## Load libraries
library(ggpubr)
library(rstatix)
library(lme4)
library(lmerTest)
library(gridExtra)

## Set directories
if(Sys.info()["sysname"]=="Linux"){
  data_dir <- "/home/javier/pepe/2_Analysis_Folder/PIVOTAL/PREMUP/premup-three/outputs/group_level/share/"
  out_dir <- "/home/javier/pepe/2_Analysis_Folder/PIVOTAL/PREMUP/premup-three/outputs/group_level/share/" 
}else{
  data_dir <- "/Users/javierortiz/Documents/pepe2/2_Analysis_Folder/PIVOTAL/PREMUP/premup-three/outputs/group_level/share/"
  out_dir <- "/Users/javierortiz/Documents/pepe2/2_Analysis_Folder/PIVOTAL/PREMUP/premup-three/outputs/group_level/share/"
}

## Read-in the data
full_name <- paste(data_dir, "group_task-rec", ".csv", sep="")

# Since the data is in a CSV file, you can read it with the csvread function.
full_data <- read.csv2(full_name, sep=";")


# The data file contains a lot of information that we will not need now.
data <- subset(x = full_data,
               subset = !is.na(full_data$participant),
               select = c("participant", "PE_level", "OvsN", "id_acc", "cond_assoc", "session"))

# Remove bad subjects. See premup-pilot_overall_recognition.html to see how this is calculated
bad_subs <- c(3,13,38,36,39,41,42,43,47,48,52,58,60,61,65,68,69,71,72)
data <- data %>% 
  filter(!participant %in% bad_subs)

# In order to simplify further steps we can remove the "new" trials.
data <- data[data$OvsN==1,]

# Let's first check whether we have above chance performance
plot_data <- data[data$session==1 & !is.na(data$cond_assoc),]
temp <- aggregate(x=plot_data, by = list(plot_data$participant), FUN=mean)
ggboxplot(temp, x = 1, y = "cond_assoc", xlab = "",
          color="white", ylab = "scn assoc (conditional)")+ ylim(c(0,.5)) + geom_violin(trim=F) +
  stat_summary(fun=median, geom="point", size=5, color="red") 
t.test(temp$cond_assoc, mu=.25)

# Let's first check whether we have above chance performance
plot_data <- data[data$session==2 & !is.na(data$cond_assoc),]
temp <- aggregate(x=plot_data, by = list(plot_data$participant), FUN=mean)
ggboxplot(temp, x = 1, y = "cond_assoc", xlab = "",
          color="white", ylab = "scn assoc (conditional)")+ ylim(c(0,.5)) + geom_violin(trim=F) +
  stat_summary(fun=median, geom="point", size=5, color="red") 
t.test(temp$cond_assoc, mu=.25)

# We only have above chance performance in session 1. Thus, I will only look at association responses in session 1.
## Traditional stats
#aggregate
plot_data <- data[!is.na(data$cond_assoc),]
plot_data$cond_assoc[plot_data$id_acc==0] <- 0
PE_mem <- aggregate(x = plot_data, by = list(plot_data$participant, plot_data$PE_level), FUN = "mean")
PE_mem <- subset(x = PE_mem,
                 select = c("participant", "PE_level", "cond_assoc", "session"))
bxp <- ggboxplot(PE_mem, x = "PE_level", y = "cond_assoc", add = "point", 
                 fill = "PE_level", 
                 facet.by = "session", panel.labs = list(session = c("Immediate", "Delayed")),
                 ylab = "scn assoc (conditional)", xlab = "PE strength",
                 palette = c("#4cb6f6","#67f063","#f07863","#67f063", "#4cb6f6"),
                 legend = "none")

bxp

# Run anova
sess_data <- PE_mem %>% filter(session ==1)
res.aov <- anova_test(data = sess_data, dv = cond_assoc, wid = participant, within = PE_level)
get_anova_table(res.aov)
# Pair-wise comparsions
sess_data <- sess_data[!is.na(sess_data$cond_assoc),]
pwc <- sess_data %>%
  pairwise_t_test(cond_assoc ~ PE_level, paired = T,p.adjust.method = "bonferroni")
pwc

# Run mixed model. For a break down of the formula, see Francesco's pdf here https://gitlab.com/Soph87/LISCOlab/-/blob/master/MLM%20Analysis/Description%20formula.pdf
sess_data <- data %>% filter(session ==1)
sess_data$PE_level <- as.factor(sess_data$PE_level)
max_model<-glmer(cond_assoc~PE_level + (PE_level | participant), data = data, family = binomial, 
                 control=glmerControl(optimizer="bobyqa",optCtrl=list(maxfun=100000)))

# Reduced model (-1)
red_model1 <-glmer(cond_assoc~PE_level + (1 | participant), data = data, family = binomial, 
                   control=glmerControl(optimizer="bobyqa",optCtrl=list(maxfun=100000)))

# Now we can compare the models. Since there is no significant decrease, we have to reduce more.
anova(max_model, red_model1)

# This next bit creates the report.
#source('/home/javier/git_repos/premup/analysis/report_LMM.R')
source('/Users/javierortiz/git_repos/premup/analysis/report_LMM.R')

tested_models <- list(max_model, red_model1)
model_names <- c("Maximal", "red_model1")
against_models <- c(1)
report_table <- report_LMM(tested_models, model_names, against_models)
report_table %>%
  add_header_above(c("Experiment 2a. Object recognition" = 3, " " = 8))

# Since there was no decrease in significance, but there's no further random slopes to decrease
# further, we select the red_model1.
summary(red_model1)
Anova(red_model1)

# Attempts at making spaghetti plot
ggplot(data = sess_data, 
       aes(x = PE_level, y = cond_assoc, group = factor(participant), color = factor(participant))) +
  geom_line(stat="smooth", method= "lm", formula = y~ poly(x,2), alpha = 0.5) +
  ylim(c(0,1))+ 
  ylab("Cond assoc") + 
  labs(title = paste("Scene association (conditional to object recognition)"))

