## MLM analysis of the object recognition memory by PE level test on PREMUP-three.
# Author: Javier Ortiz-Tudela (Goethe Uni)
# Started on: 21.01.20
# Last updated on: 26.04.20

## Load libraries
library(ggpubr)
library(rstatix)
library(lme4)
library(lmerTest)
#library(gridExtra)
library(dplyr)

## Set directories
if(Sys.info()["sysname"]=="Linux"){
  data_dir <- "/home/javier/pepe/2_Analysis_Folder/PIVOTAL/PREMUP/premup-flat/outputs/group_level/share/"
  out_dir <- "/home/javier/pepe/2_Analysis_Folder/PIVOTAL/PREMUP/premup-flat/outputs/group_level/" 
}else{
  data_dir <- "/Users/javierortiz/Documents/pepe/2_Analysis_Folder/PIVOTAL/PREMUP/premup-flat/outputs/group_level/share/"
  out_dir <- "/Users/javierortiz/Documents/pepe/2_Analysis_Folder/PIVOTAL/PREMUP/premup-flat/outputs/group_level/"
}
setwd(out_dir)
## Read-in the data
full_name <- paste(data_dir, "group_task-rec.csv", sep="")
  
# Since the data is in a CSV file, you can read it with the csvread function.
temp <- read.csv2(full_name, sep=";")
  
# The data file contains a lot of information that we will not need now.
data <- subset(x = temp,
               select = c("participant", "session", "id_acc", "enc_trialN", "PE_level", "OvsN", "scn_condition"))

# Remove bad subjects. See premup-pilot_overall_recognition.html to see how this is calculated
bad_subs <- c(9,39,7)
data <- data %>% 
  filter(!participant %in% bad_subs)

# In order to simplify further steps we can remove the "new" and filler trials.
data <- data[!is.na(data$OvsN),]
data <- data[data$OvsN==1,]
data <- data[!is.na(data$enc_trialN),]

# Code for two halves
data$halves[data$enc_trialN<81] <- 1
data$halves[data$enc_trialN>80] <- 2

## Stats
# First convert the categorical variable into a factor. This is R terminology.
data$PE_level<-as.factor(data$PE_level)
data$id_acc <- as.numeric(data$id_acc)
data$session <- as.factor(data$session)
data$halves <- as.factor(data$halves)

# We can check averages
gd <- data %>% 
  group_by(participant, session, PE_level) %>% 
  summarise(id_acc = mean(id_acc), scn_condition = mean(scn_condition))

# Run GLMM 
# Maximal model
max_model<-glmer(id_acc~PE_level * session + (PE_level * session | participant), data = data, family = binomial, 
                 control=glmerControl(optimizer="bobyqa",optCtrl=list(maxfun=100000)))

# Reduced model (-1)
red_model1 <-glmer(id_acc~PE_level * session + (PE_level + session | participant), data = data, family = binomial, 
                   control=glmerControl(optimizer="bobyqa",optCtrl=list(maxfun=100000)))

# Now we can compare the models. Since there is no significant decrease, we have to reduce more.
anova(max_model, red_model1)

# Reduced model (-2a)
red_model2a <-glmer(id_acc~PE_level * session + (PE_level | participant), data = data, family = binomial, 
                    control=glmerControl(optimizer="bobyqa",optCtrl=list(maxfun=100000)))

# Reduced model (-2b)
red_model2b <-glmer(id_acc~PE_level * session + (session | participant), data = data, family = binomial, 
                    control=glmerControl(optimizer="bobyqa",optCtrl=list(maxfun=100000)))

# Now we compare the two new -2 reduced models. 
anova(red_model1, red_model2a)
anova(red_model1, red_model2b)

# Since there is only significant decrease for 2a, we accept 2b and reduce once more to get the final contrast in which we test 2b and observe a decrease in fit.
# Reduced model (-3)
red_model3 <-glmer(id_acc~PE_level * session + (1 | participant), data = data, family= binomial,
                   control=glmerControl(optimizer="bobyqa",optCtrl=list(maxfun=100000)))

# Now we compare the new -3 reduced model with the -2 model.
anova(red_model2b, red_model3)

# Since we have a significant decrease in model fit, we accept red_model2b. Now we can test the main effects with Anova (capital A)
Anova(red_model2b)

# Exponentiating the beta estimates gives you the effect size (exp(x)= odds ratio -OR-). We need summary to get the estimate
summary(red_model2b)

# Create summary table for the model selection process
source('/home/javier/git_repos/premup/analysis/report_LMM.R')
tested_models <- c(max_model,red_model1)
model_names <- c("Maximal model","Reduced 1")
against_models <- c(1)
report_title <- "Experiment 2b. Object recognition"
report_table <- report_LMM(tested_models, model_names,against_models,report_title)

# Box plot
sess_lab <- c("Immediate", "Delayed")
names(sess_lab) <- c("1", "2")
ggplot(data = gd,
       aes(x = PE_level, y = id_acc, color = factor(scn_condition))) +
  geom_boxplot() + 
  geom_jitter(shape=10, position=position_jitter(0.2)) +
  facet_grid(cols = vars(session), labeller = labeller(session = sess_lab)) + 
  ylab("Hit rates") + 
  ylim(c(0,.8)) +
  xlab("PE strength") +
  theme(legend.position = "top") +
 scale_color_discrete(name = "Context type", labels= c("Flat prior", "Strong prior"))
