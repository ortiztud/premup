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
               select = c("participant", "PE_level", "OvsN", "id_acc", "cond_loc", "session"))

# Remove bad subjects. See premup-pilot_overall_recognition.html to see how this is calculated
bad_subs <- c(3,13,38,36,39,41,42,43,47,48,52,58,60,61,65,68,69,71,72)
data <- data %>% 
  filter(!participant %in% bad_subs)

# In order to simplify further steps we can remove the "new" trials.
data <- data[data$OvsN==1,]

# Let's first check whether we have above chance performance
plot_data <- data[data$session==1 & !is.na(data$cond_loc),]
temp <- aggregate(x=plot_data, by = list(plot_data$participant), FUN=mean)
ggboxplot(temp, x = 1, y = "cond_loc", xlab = "",
          color="white", ylab = "scn assoc (conditional)")+ ylim(c(0,.8)) + geom_violin(trim=F) +
  stat_summary(fun=median, geom="point", size=5, color="red") + geom_hline(yintercept =.25, linetype="dashed", color = "red")
t.test(temp$cond_loc, mu=.25)

# Let's first check whether we have above chance performance
plot_data <- data[data$session==2 & !is.na(data$cond_loc),]
temp <- aggregate(x=plot_data, by = list(plot_data$participant), FUN=mean)
ggboxplot(temp, x = 1, y = "cond_loc", xlab = "",
          color="white", ylab = "scn assoc (conditional)")+ ylim(c(0,.8)) + geom_violin(trim=F) +
  stat_summary(fun=median, geom="point", size=5, color="red")  + geom_hline(yintercept =.25, linetype="dashed", color = "red")
t.test(temp$cond_loc, mu=.25)

## Traditional stats
#aggregate
plot_data <- data[!is.na(data$cond_loc),]
plot_data$cond_loc[plot_data$id_acc==0] <- 0
PE_mem <- aggregate(x = plot_data, by = list(plot_data$participant, plot_data$PE_level), FUN = "mean")
PE_mem <- subset(x = PE_mem,
                 select = c("participant", "PE_level", "cond_loc", "session"))
bxp <- ggboxplot(PE_mem, x = "PE_level", y = "cond_loc", add = "point", 
                 fill = "PE_level", 
                 facet.by = "session", panel.labs = list(session = c("Immediate", "Delayed")),
                 ylab = "location mem (conditional)", xlab = "PE strength",
                 palette = c("#4cb6f6","#67f063","#f07863","#67f063", "#4cb6f6"),
                 legend = "none")

bxp

# Run anova

res.aov <- anova_test(data = PE_mem, dv = cond_loc, wid = participant, between = session,within = PE_level)
get_anova_table(res.aov)
# Pair-wise comparsions
pwc <- PE_mem %>%
  pairwise_t_test(cond_loc ~ PE_level, paired = F,p.adjust.method = "bonferroni")
pwc
pwc <- PE_mem %>%
  pairwise_t_test(cond_loc ~ session, paired = F,p.adjust.method = "bonferroni")
pwc

# Run GLMM
data$PE_level <- as.factor(data$PE_level)
data$session <- as.factor(data$session)

# Maximal model
max_model<-glmer(cond_loc~PE_level * session + (PE_level | participant), data = data, family = binomial, 
                 control=glmerControl(optimizer="bobyqa",optCtrl=list(maxfun=100000)))

# Reduced model (-1)
red_model1 <-glmer(cond_loc~PE_level * session + (1 | participant), data = data, family = binomial, 
                   control=glmerControl(optimizer="bobyqa",optCtrl=list(maxfun=100000)))

# Now we can compare the models. Since there is no significant decrease, we have to reduce more.
anova(max_model, red_model1)

# Since we have a significant decrease in model fit, we accept red_model2: two main effects but no interaction. We can explore this model wih "Anova" (capital A)
Anova(red_model1)
summary(red_model1)

# Define linear
linear_comp <-c(-2,-1,0,1,2)
# Define quadratic
quadratic_comp <-c(2,-1,-2,-1,2)

# Some R magic
data$PE_level <- as.factor(data$PE_level)
contrasts(data$PE_level, how.many = 2)<-cbind(linear_comp, quadratic_comp)

# Re-fit the model
GLMM_contr<-glmer(cond_loc~PE_level + session +(1|participant), data = data, family = binomial)
summary(GLMM_contr)

# Attempts at making spaghetti plot
plot_data <- data[!is.na(data$cond_loc),]
ggplot(data = plot_data, 
       aes(x = PE_level, y = cond_loc, group = factor(participant), color = factor(participant))) +
  geom_line(stat="smooth", method= "lm", formula = y~ poly(x,2), alpha = 0.5) +
  ylim(c(0,1))+ 
  ylab("Cond location") + 
  labs(title = paste("Location memory (conditional to object recognition)"))
