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
  data_dir <- "/home/javier/pepe/2_Analysis_Folder/PIVOTAL/PREMUP/premup-priors/outputs/group_level/share/"
  out_dir <- "/home/javier/pepe/2_Analysis_Folder/PIVOTAL/PREMUP/premup-priors/outputs/group_level/share/" 
}else{
  data_dir <- "/Users/javierortiz/Documents/pepe/2_Analysis_Folder/PIVOTAL/PREMUP/premup-priors/outputs/group_level/share/"
  out_dir <- "/Users/javierortiz/Documents/pepe/2_Analysis_Folder/PIVOTAL/PREMUP/premup-priors/outputs/group_level/share/"
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
bad_subs <- c(18,21,39)
data <- data %>% 
  filter(!participant %in% bad_subs)

# In order to simplify further steps we can remove the "new" trials.
data <- data[data$OvsN==1,]

# Let's first check whether we have above chance performance
plot_data <- data[data$session==1 & !is.na(data$cond_assoc),]
temp <- aggregate(x=plot_data, by = list(plot_data$participant), FUN=mean)
ggboxplot(temp, x = 1, y = "cond_assoc", xlab = "",
          color="white", ylab = "scn assoc (conditional)")+ ylim(c(0,.5)) + geom_violin(trim=F) +
  stat_summary(fun=median, geom="point", size=5, color="red") + geom_hline(yintercept =.25, linetype="dashed", color = "red")
t.test(temp$cond_assoc, mu=.25)

# Let's first check whether we have above chance performance
plot_data <- data[data$session==2 & !is.na(data$cond_assoc),]
temp <- aggregate(x=plot_data, by = list(plot_data$participant), FUN=mean)
ggboxplot(temp, x = 1, y = "cond_assoc", xlab = "",
          color="white", ylab = "scn assoc (conditional)")+ ylim(c(0,.5)) + geom_violin(trim=F) +
  stat_summary(fun=median, geom="point", size=5, color="red") + geom_hline(yintercept =.25, linetype="dashed", color = "red")
t.test(temp$cond_assoc, mu=.25)

# Performance in both sessions is at chance. I will stop here

# Run anova
res.aov <- anova_test(data = PE_mem, dv = cond_assoc, wid = participant, within = PE_level)
get_anova_table(res.aov)

