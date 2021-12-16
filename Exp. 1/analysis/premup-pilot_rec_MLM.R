## MLM analysis of the object recognition memory by PE level test on PREMUP-three.
# Author: Javier Ortiz-Tudela (Goethe Uni)
# Started on: 21.01.20
# Last updated on: 09.04.20

## Load libraries
library(ggpubr)
library(rstatix)
library(lme4)
library(lmerTest)
library(gridExtra)
library(dplyr)

## Set directories
if(Sys.info()["sysname"]=="Linux"){
  data_dir <- "/home/javier/pepe/2_Analysis_Folder/PIVOTAL/PREMUP/premup-pilot/outputs/group_level/share/"
  out_dir <- "/home/javier/pepe/2_Analysis_Folder/PIVOTAL/PREMUP/premup-pilot/outputs/group_level/" 
}else{
  data_dir <- "/Users/javierortiz/Documents/pepe3/2_Analysis_Folder/PIVOTAL/PREMUP/premup-pilot/outputs/group_level/share/"
  out_dir <- "/Users/javierortiz/Documents/pepe3/2_Analysis_Folder/PIVOTAL/PREMUP/premup-pilot/outputs/group_level/"
}
setwd(out_dir)
## Read-in the data
full_name <- paste(data_dir, "group_task-rec.csv", sep="")
  
# Since the data is in a CSV file, you can read it with the csvread function.
temp <- read.csv2(full_name, sep=";")
  
# The data file contains a lot of information that we will not need now.
data <- subset(x = temp,
               select = c("participant", "session", "fillers", "scn_condition", "id_acc", "PE_level", "OvsN", "contingency"))

# In order to simplify further steps we can remove the "new" and filler trials.
data <- data[data$OvsN==1,]
data <- data[data$fillers==0,]

# Remove bad subjects only for session 1. See premup-pilot_overall_recognition to see how this is calculated
poor_performers = c(7, 16, 19, 20, 23)
data <- data %>% 
  filter(!(participant %in% poor_performers))

## Stats
# First convert the categorical variable into a factor. This is R terminology.
data$PE_level<-as.factor(data$PE_level)
data$contingency<-as.factor(data$contingency)
data$id_acc <- as.numeric(data$id_acc)
data$session <- as.factor(data$session)

# First we can create a plot to visually inspect the pattern of our participants.
ggplot(data, aes(y=id_acc, x = PE_level, color = PE_level))+
  geom_bar(stat="summary") + 
  facet_grid(cols = vars(session))

# We can check averages
agg_data <- data %>% 
  group_by(participant, session, PE_level) %>% 
  summarise(id_acc = mean(id_acc), scn_condition = mean(scn_condition))

# Convert to wide
wide <- agg_data %>%
  select(participant, session, PE_level, id_acc) %>% 
  pivot_wider(names_from = c(session,PE_level), values_from = c(id_acc))
write.csv(wide, file = paste(out_dir, "group_task-rec_wide.csv", sep=""))

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

# Since we have a significant decrease in model fit, we accept red_model2b. This next bit creates the report.
source('/home/javier/git_repos/premup/analysis/report_LMM.R')
tested_models <- list(max_model, red_model1, red_model2a, red_model2b, red_model3)
model_names <- c("Maximal", "Reduced 1", "Reduced 2a", "Reduced 2b", "Reduced 3")
against_models <- c(1, 2, 2, 3)
report_title <- "Experiment 1. Object recognition"
report_LMM(tested_models, model_names, against_models,report_title)

# We can now explore this model wih "Anova" (capital A)
Anova(red_model2b)

# Exponentiating the beta estimates gives you the effect size (exp(x)= odds ratio -OR-). We need summary to get the estimate
summary(red_model2b)

# Since the interaction is significant, we can test for linear and/or quadratic components in each session
# Define linear
linear_comp <-c(-1,0,1)

# Define quadratic
quadratic_comp <-c(1,-2,1)

# Some R magic
contrasts(data$PE_level)<-cbind(linear_comp, quadratic_comp)

# refit the model
GLMM_contr<-glmer(id_acc~PE_level * session +(session|participant), data = data, family = binomial)
summary(GLMM_contr)

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

# Attempts at making spaghetti plot
ggplot(data = gd, 
       aes(x = PE_level, y = id_acc, group = factor(participant), color = factor(participant))) +
  geom_line(stat="smooth", method= "lm", formula = y~ poly(x,2), alpha = 0.5) +
  facet_grid(cols = vars(session)) + 
  ylim(c(0,1))+ 
  ylab("Hit rate") + 
  labs(title = paste("Hit rate by session"))
