## MLM analysis of the object recognition memory by PE level test on PREMUP-three.
# Author: Javier Ortiz-Tudela (Goethe Uni)
# Started on: 21.01.20
# Last updated on: 26.04.20

## Load libraries
library(ggpubr)
library(rstatix)
library(lme4)
#library(lmerTest)
#library(gridExtra)
library(dplyr)
library(tidyr)

## Set directories
if(Sys.info()["sysname"]=="Linux"){
  data_dir <- "/home/javier/pepe/2_Analysis_Folder/PIVOTAL/PREMUP/premup-three/outputs/group_level/share/"
  out_dir <- "/home/javier/pepe/2_Analysis_Folder/PIVOTAL/PREMUP/premup-three/outputs/group_level/" 
}else{
  data_dir <- "/Users/javierortiz/Documents/pepe2/2_Analysis_Folder/PIVOTAL/PREMUP/premup-three/outputs/group_level/share/"
  out_dir <- "/Users/javierortiz/Documents/pepe2 /2_Analysis_Folder/PIVOTAL/PREMUP/premup-three/outputs/group_level/"
}
setwd(out_dir)
## Read-in the data
full_name <- paste(data_dir, "group_task-rec.csv", sep="")
  
# Since the data is in a CSV file, you can read it with the csvread function.
temp <- read.csv2(full_name, sep=";")
  
# The data file contains a lot of information that we will not need now.
data <- subset(x = temp,
               select = c("participant", "session", "fillers", "id_acc", "PE_level", "OvsN", "scn_condition"))

# In order to simplify further steps we can remove the "new" and filler trials.
data <- data[!is.na(data$OvsN),]
data <- data[data$OvsN==1,]
data <- data[data$fillers==0,]

# Remove bad subjects. See premup-three_overall_recognition.html to see how this is calculated
bad_subs <- c(3,13,38,36,39,41,42,43,47,48,52,58,60,61,65,68,69,71,72)
data <- data %>% 
  filter(!participant %in% bad_subs)

## Stats
# First convert the categorical variable into a factor. This is R terminology.
data$PE_level<-as.factor(data$PE_level)
data$session <- as.factor(data$session)
data$id_acc <- as.numeric(data$id_acc)

# First we can create a plot to visually inspect the pattern of our participants.
ggplot(data, aes(y=id_acc, x = PE_level))+
  geom_bar(stat="summary") + 
  facet_grid(cols = vars(session))

# We can check averages
agg_data <- data %>% 
  group_by(participant, session, PE_level) %>% 
  summarise(id_acc = mean(id_acc), scn_condition = mean(scn_condition))

# Convert to wide
wide <- agg_data %>%
  filter(session ==1) %>% 
  select(participant, session, PE_level, id_acc) %>% 
  pivot_wider(names_from = c(session,PE_level), values_from = c(id_acc))
write.csv(wide, file = paste(out_dir, "group_task-rec_wide.csv", sep=""))

# Run GLMM
# Maximal model
max_model<-glmer(id_acc~PE_level * session + (PE_level | participant), data = data, family = binomial, 
                 control=glmerControl(optimizer="bobyqa",optCtrl=list(maxfun=100000)))

# Reduced model (-1)
red_model1 <-glmer(id_acc~PE_level * session + (1 | participant), data = data, family = binomial, 
                 control=glmerControl(optimizer="bobyqa",optCtrl=list(maxfun=100000)))

# Now we can compare the models. There is no significant decrease but since there are no random effects left to reduce,
# we accept red_model1.
anova(max_model, red_model1)

# Create summary table for the model selection process
source('/home/javier/git_repos/premup/analysis/report_LMM.R')
tested_models <- c(max_model,red_model1)
model_names <- c("Maximal model","Reduced 1")
against_models <- c(1)
report_title <- "Experiment 3. Object recognition"
report_table <- report_LMM(tested_models, model_names,against_models,report_title)

# We can explore this model wih "Anova" (capital A)
Anova(red_model1)
summary(red_model1)

# We test for linear and/or quadratic components of the PE_level effect
# Define linear
linear_comp <-c(-2,-1,0,1,2)

# Define quadratic
quadratic_comp <-c(2,-1,-2,-1,2)

# Some R magic
contrasts(data$PE_level, how.many = 2)<-cbind(linear_comp, quadratic_comp)

# Re-fit the model
GLMM_contr<-glmer(id_acc~PE_level * session +(1|participant), data = data, family = binomial)
summary(GLMM_contr)
GLMM_contr<-glmer(id_acc~PE_level + session +(1|participant), data = data, family = binomial)

# Box plot
agg_data$PE_level <- as.factor(agg_data$PE_level)
sess_lab <- c("Immediate", "Delayed")
names(sess_lab) <- c("1", "2")
ggplot(data = agg_data,
       aes(x = PE_level, y = id_acc, color = factor(scn_condition))) +
  geom_boxplot() + 
  geom_jitter(shape=10, position=position_jitter(0.2)) +
  facet_grid(cols = vars(session), labeller = labeller(session = sess_lab)) + 
  ylab("Hit rates") + 
  ylim(c(0,.8)) +
  xlab("PE strength") +
  theme(legend.position = "top") +
  scale_color_discrete(name = "Context type", labels= c("Flat prior", "Weak prior", "Strong prior"))

# Attempts at making spaghetti plot
ggplot(data = agg_data, 
       aes(x = PE_level, y = id_acc, group = factor(participant), color = factor(participant))) +
  geom_line(stat="smooth", method= "lm", formula = y~ poly(x,2), alpha = 0.5) +
  facet_grid(cols = vars(session)) + 
  ylim(c(0,1))+ 
  ylab("Hit rate") + 
  labs(title = paste("Hit rate by session"))
