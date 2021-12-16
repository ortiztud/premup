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
  data_dir <- "/home/javier/pepe/2_Analysis_Folder/PIVOTAL/PREMUP/premup-pilot/outputs/group_level/share/"
  out_dir <- "/home/javier/pepe/2_Analysis_Folder/PIVOTAL/PREMUP/premup-pilot/outputs/group_level/share/" 
}else{
  data_dir <- "/Users/javierortiz/Documents/pepe/2_Analysis_Folder/PIVOTAL/PREMUP/premup-pilot/outputs/group_level/share/"
  out_dir <- "/Users/javierortiz/Documents/pepe/2_Analysis_Folder/PIVOTAL/PREMUP/premup-pilot/outputs/group_level/share/"
}

## Read-in the data
full_name <- paste(data_dir, "group_task-rec.csv", sep="")

# Since the data is in a CSV file, you can read it with the csvread function.
temp <- read.csv2(full_name, sep=";")

# The data file contains a lot of information that we will not need now.
data <- subset(x = temp,
               select = c("participant", "PE_level", "OvsN", "id_acc", "cond_assoc", "session"))

# Remove bad subjects. See premup-pilot_overall_recognition to see how this is calculated
a = c(1, 2, 3, 9, 16, 19, 27,  7)
for(cSub in a){
  data <- data[data$participant!=cSub,]
}

# In order to simplify further steps we can remove the "new" and filler trials.
data <- data[data$OvsN==1,]


# Let's first check whether we have above chance performance
plot_data <- data[data$session==1 & !is.na(data$cond_assoc),]
temp <- aggregate(x=plot_data, by = list(plot_data$participant), FUN=mean)
ggboxplot(temp, x = 1, y = "cond_assoc",  xlab = "",
          color="white",ylab = "scn assoc (conditional)")+ ylim(c(0,1)) + geom_violin(trim=F) +
  stat_summary(fun=median, geom="point", size=5, color="red") 
t.test(temp$cond_assoc, mu=.25, alternative = "greater")


# Let's first check whether we have above chance performance (delayed)
plot_data <- data[data$session==2 & !is.na(data$cond_assoc),]
temp <- aggregate(x=plot_data, by = list(plot_data$participant), FUN=mean)
ggboxplot(temp, x = 1, y = "cond_assoc", 
          color="white") + geom_violin(trim=F) +
  stat_summary(fun=median, geom="point", size=5, color="red") 
t.test(temp$cond_assoc, mu=.25, alternative = "greater")


plot_data <- data[!is.na(data$cond_assoc),]
plot_data$cond_assoc[plot_data$id_acc==0] <- 0
PE_mem <- aggregate(x = plot_data, by = list(plot_data$participant, plot_data$session, plot_data$PE_level), FUN = "mean")
PE_mem <- subset(x = PE_mem,
                 select = c("participant", "PE_level", "cond_assoc", "session"))
bxp <- ggboxplot(PE_mem, x = "PE_level", y = "cond_assoc", add = "point", 
                 fill = "PE_level", 
                 facet.by = "session", panel.labs = list(session = c("Immediate", "Delayed")),
                 ylab = "scn assoc (conditional)", xlab = "PE strength",
                 palette = c("#4cb6f6","#f07863", "#4cb6f6"),
                 legend = "none")

bxp
## Traditional stats

# Run anova
res.aov <- anova_test(data = PE_mem, dv = cond_assoc, wid = participant,  within = c(session,PE_level))
get_anova_table(res.aov)

# Pair-wise comparsions
pwc <- PE_mem %>%
  pairwise_t_test(cond_assoc ~ PE_level, paired = TRUE,p.adjust.method = "bonferroni")
pwc

data$PE_level <- as.factor(data$PE_level)
data$session <- as.factor(data$session)
# Run GLMM.
# Maximal model
max_model<-glmer(cond_assoc~PE_level * session + (PE_level * session | participant), data = data, family = binomial, 
                 control=glmerControl(optimizer="bobyqa",optCtrl=list(maxfun=100000)))

# Reduced model (-1)
red_model1 <-glmer(cond_assoc~PE_level * session + (PE_level + session | participant), data = data, family = binomial, 
                   control=glmerControl(optimizer="bobyqa",optCtrl=list(maxfun=100000)))

# Now we can compare the models. Since there is no significant decrease, we have to reduce more.
anova(max_model, red_model1)

# Since we have a significant decrease in model fit, we accept red_model1. This next bit creates the report.
source('/home/javier/git_repos/premup/analysis/report_LMM.R')
tested_models <- list(max_model, red_model1)
model_names <- c("Maximal", "Reduced 1")
against_models <- c(1)
report_table <- report_LMM(tested_models, model_names, against_models)
report_table %>%
  add_header_above(c("Experiment 1. Object - Scene association" = 3, " " = 8))

# We can explore this model wih "Anova" (capital A)
Anova(red_model1)

# Exponentiating the beta estimates gives you the effect size (exp(x)= odds ratio -OR-). We need summary to get the estimate
summary(red_model1)
