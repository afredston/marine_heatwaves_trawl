#This code explores relationships between turnover, richness, and MHWs
#Specifically, these figures compare heat wave intensity with the 
#turnover and nestedness components of beta diversity between previous year and  given year
#(measured with bray curtis dissimilarity and jaccard dissimilarity)
#Contact Zoë Kitchel for questions
########
# load packages
########
 
####
###

library(here)
library(lubridate) # for standardizing date format of MHW data
library(tidyverse)
library(data.table)
library(betapart)
library(ggformula) #splines
library(ggrepel)
library(cowplot)
library(ggpubr)

########
# load data
########

survey_temporal_beta_diversity <- fread(here::here("processed-data","survey_temporal_beta_diversity.csv"))

#MHW metrics
# marine heatwave data for joining with survey data
mhw_summary_sat_sst_5_day <- read_csv(here("processed-data","mhw_satellite_sst_5_day_threshold.csv")) # MHW summary stats from satellite SST record, defining MHWs as events >=5 days
mhw_summary_sat_sst_5_day <- data.table(mhw_summary_sat_sst_5_day)

#merge MHWs with temporal beta diversity

survey_temporal_diversity_with_MHWs <- survey_temporal_beta_diversity[mhw_summary_sat_sst_5_day, on = c("ref_yr")]

#add in the number of mhw events to give sense of sample size
survey_temporal_diversity_with_MHWs[,N := .N,.(survey,mhw_yes_no)]

head(survey_temporal_diversity_with_MHWs)

#add in bray and jaccard dissimilarity turnover values, dissimilarity nestedness values and delta_richness values that are scaled by region

survey_temporal_diversity_with_MHWs[,bray_dissimilarity_turnover_scaled_by_survey :=
                                          scale(bray_dissimilarity_turnover),survey][,
                                          bray_dissimilarity_nestedness_scaled_by_survey :=
                                           scale(bray_dissimilarity_nestedness),survey][,
                                                                                        
                                          jaccard_dissimilarity_turnover_scaled_by_survey :=
                                              scale(jaccard_dissimilarity_turnover),survey][,
                                               jaccard_dissimilarity_nestedness_scaled_by_survey :=
                                                 scale(jaccard_dissimilarity_nestedness),survey][,
                                                                                                 
                                          delta_richness_scaled_by_survey :=
                                          scale(delta_richness),survey]


###############
### TURNOVER ONLY
###############
#Helpful definition for components of beta diversity
#"In addition, beta diversity can be driven by two distinct phenomena: nesting and turnover.
#Nesting occurs when habitats with low richness host part of the species of richer habitats,
#which reflects a non-random process of disaggregation of assemblages.
#Turnover is a process of substitution of species by environmental selection or historical and spatial restriction." Coehlo et al. 2018

#############
##Heat wave versus no heatwave
#############

#compare yes or no heatwave with temporal diversity metric 
#box plot

jaccard_turnover_boxplot_MHWs <- ggplot(survey_temporal_diversity_with_MHWs[complete.cases(mhw_yes_no),], aes(x = mhw_yes_no, y = jaccard_dissimilarity_turnover)) +
  geom_boxplot() +
  labs(x = "MHW?", y = "Jaccard Dissimilarity Turnover Component") +
  annotate("text",
           x = 1:length(table(survey_temporal_diversity_with_MHWs$mhw_yes_no)),
           y = aggregate(jaccard_dissimilarity_turnover ~ mhw_yes_no, survey_temporal_diversity_with_MHWs, median)[ , 2],
           label = table(survey_temporal_diversity_with_MHWs$mhw_yes_no),
           col = "red",
           vjust = - 1) +
  theme_classic()

ggsave(jaccard_turnover_boxplot_MHWs, path = here::here("figures","beta_diversity"), filename = "jaccard_turnover_boxplot_MHWs.jpg", width = 10, height = 4)

#Is there a significant difference in jaccard_dissimilarity_turnover between MHW and MHW years and MHW to non-MHW years?
#unpaired two-samples t-test
t.test(survey_temporal_diversity_with_MHWs[mhw_yes_no == "yes",jaccard_dissimilarity_turnover], survey_temporal_diversity_with_MHWs[mhw_yes_no == "no",jaccard_dissimilarity_turnover],
       alternative = "two.sided", var.equal = FALSE)

#no sufficient evidence to say they are different, but more variation in MHW years



#unscaled
bray_turnover_boxplot_MHWs <- ggplot(survey_temporal_diversity_with_MHWs[complete.cases(mhw_yes_no),], aes(x = mhw_yes_no, y = bray_dissimilarity_turnover)) +
  geom_boxplot() +
  labs(x = "MHW?", y = "Bray Dissimilarity Turnover Component") +
  annotate("text",
           x = 1:length(table(survey_temporal_diversity_with_MHWs$mhw_yes_no)),
           y = aggregate(bray_dissimilarity_turnover ~ mhw_yes_no, survey_temporal_diversity_with_MHWs, median)[ , 2],
           label = table(survey_temporal_diversity_with_MHWs$mhw_yes_no),
           col = "red",
           vjust = - 1) +
  theme_classic()

ggsave(bray_turnover_boxplot_MHWs, path = here::here("figures","beta_diversity"), filename = "bray_turnover_boxplot_MHWs.jpg", width = 10, height = 4)

#Is there a significant difference in bray_dissimilarity_turnover between MHW and MHW years and MHW to non-MHW years?
#unpaired two-samples t-test
t.test(survey_temporal_diversity_with_MHWs[mhw_yes_no == "yes",bray_dissimilarity_turnover], survey_temporal_diversity_with_MHWs[mhw_yes_no == "no",bray_dissimilarity_turnover],
       alternative = "two.sided", var.equal = FALSE)


delta_richness_boxplot_MHWs <- ggplot(survey_temporal_diversity_with_MHWs[complete.cases(mhw_yes_no),], aes(x = mhw_yes_no, y = delta_richness)) +
  geom_boxplot() +
  labs(x = "MHW?", y = "Delta Richness") +
  annotate("text",
           x = 1:length(table(survey_temporal_diversity_with_MHWs$mhw_yes_no)),
           y = aggregate(delta_richness ~ mhw_yes_no, survey_temporal_diversity_with_MHWs, median)[ , 2],
           label = table(survey_temporal_diversity_with_MHWs$mhw_yes_no),
           col = "red",
           vjust = - 1) +
  theme_classic()

ggsave(delta_richness_boxplot_MHWs, path = here::here("figures","beta_diversity"), filename = "delta_richness_boxplot_MHWs.jpg", width = 10, height = 4)

#Is there a significant difference in bray_dissimilarity_turnover between MHW and MHW years and MHW to non-MHW years?
#unpaired two-samples t-test
t.test(survey_temporal_diversity_with_MHWs[mhw_yes_no == "yes",delta_richness], survey_temporal_diversity_with_MHWs[mhw_yes_no == "no",delta_richness],
       alternative = "two.sided", var.equal = FALSE)

#scaled
bray_turnover_boxplot_MHWs_scaled <- ggplot(survey_temporal_diversity_with_MHWs[complete.cases(mhw_yes_no),], aes(x = mhw_yes_no, y = bray_dissimilarity_turnover_scaled_by_survey)) +
  geom_boxplot() +
  labs(x = "MHW?", y = "Bray Dissimilarity Turnover Component\nScaled within Regions") +
  annotate("text",
           x = 1:length(table(survey_temporal_diversity_with_MHWs$mhw_yes_no)),
           y = aggregate(bray_dissimilarity_turnover_scaled_by_survey ~ mhw_yes_no, survey_temporal_diversity_with_MHWs, median)[ , 2],
           label = table(survey_temporal_diversity_with_MHWs$mhw_yes_no),
           col = "red",
           vjust = - 1) +
  theme_classic()

ggsave(bray_turnover_boxplot_MHWs_scaled, path = here::here("figures","beta_diversity"), filename = "bray_turnover_boxplot_MHWs_scaled.jpg", width = 10, height = 4)

jaccard_turnover_boxplot_MHWs_scaled <- ggplot(survey_temporal_diversity_with_MHWs[complete.cases(mhw_yes_no),], aes(x = mhw_yes_no, y = jaccard_dissimilarity_turnover_scaled_by_survey)) +
  geom_boxplot() +
  labs(x = "MHW?", y = "Jaccard Dissimilarity Turnover Component\nScaled within Regions") +
  annotate("text",
           x = 1:length(table(survey_temporal_diversity_with_MHWs$mhw_yes_no)),
           y = aggregate(jaccard_dissimilarity_turnover_scaled_by_survey ~ mhw_yes_no, survey_temporal_diversity_with_MHWs, median)[ , 2],
           label = table(survey_temporal_diversity_with_MHWs$mhw_yes_no),
           col = "red",
           vjust = - 1) +
  theme_classic()

ggsave(jaccard_turnover_boxplot_MHWs_scaled, path = here::here("figures","beta_diversity"), filename = "jaccard_turnover_boxplot_MHWs_scaled.jpg", width = 10, height = 4)


delta_richness_boxplot_MHWs_scaled <- ggplot(survey_temporal_diversity_with_MHWs[complete.cases(mhw_yes_no),], aes(x = mhw_yes_no, y = delta_richness_scaled_by_survey)) +
  geom_boxplot() +
  labs(x = "MHW?", y = "Delta Richness\nScaled within Region") +
  annotate("text",
           x = 1:length(table(survey_temporal_diversity_with_MHWs$mhw_yes_no)),
           y = aggregate(delta_richness_scaled_by_survey ~ mhw_yes_no, survey_temporal_diversity_with_MHWs, median)[ , 2],
           label = table(survey_temporal_diversity_with_MHWs$mhw_yes_no),
           col = "red",
           vjust = - 1) +
  theme_classic()

ggsave(delta_richness_boxplot_MHWs_scaled, path = here::here("figures","beta_diversity"), filename = "delta_richness_boxplot_MHWs_scaled.jpg", width = 10, height = 4)



#box plot by survey

#unscaled
jaccard_turnover_boxplot_MHWs_survey <- ggplot(survey_temporal_diversity_with_MHWs[complete.cases(mhw_yes_no),],
                                               aes(x = mhw_yes_no, y = jaccard_dissimilarity_turnover)) +
  geom_boxplot() +
  labs(x = "MHW?", y = "Jaccard Dissimilarity Turnover Component") +
  facet_wrap(~survey) +
  theme_classic()

ggsave(jaccard_turnover_boxplot_MHWs_survey, path = here::here("figures","beta_diversity"), filename = "jaccard_turnover_boxplot_MHWs_survey.jpg", width = 10, height = 10)

#here, we see possibly significant difference for NEUS, let's look closer
  #"I'd guess the NEUS one is driven by 2012 and maybe 2016, but let's check! I'll put a note in the draft." Alexa
  t.test(survey_temporal_diversity_with_MHWs[survey == "NEUS" & mhw_yes_no == "yes",]$jaccard_dissimilarity_turnover,
         survey_temporal_diversity_with_MHWs[survey == "NEUS" & mhw_yes_no == "no",]$jaccard_dissimilarity_turnover)
  #p = 0.015
  
  #what if we exclude 2011?
  t.test(survey_temporal_diversity_with_MHWs[survey == "NEUS" & mhw_yes_no == "yes" & ref_yr != "NEUS-9-2011",]$jaccard_dissimilarity_turnover,
         survey_temporal_diversity_with_MHWs[survey == "NEUS" & mhw_yes_no == "no" & ref_yr != "NEUS-9-2011",]$jaccard_dissimilarity_turnover)
  #p  = 0.017
  
  #what if we exclude 2012?
  t.test(survey_temporal_diversity_with_MHWs[survey == "NEUS" & mhw_yes_no == "yes" & ref_yr != "NEUS-9-2012",]$jaccard_dissimilarity_turnover,
         survey_temporal_diversity_with_MHWs[survey == "NEUS" & mhw_yes_no == "no" & ref_yr != "NEUS-9-2012",]$jaccard_dissimilarity_turnover)
  #p  = 0.015
  
  #what if we exclude 2016?
  t.test(survey_temporal_diversity_with_MHWs[survey == "NEUS" & mhw_yes_no == "yes" & ref_yr != "NEUS-9-2016",]$jaccard_dissimilarity_turnover,
         survey_temporal_diversity_with_MHWs[survey == "NEUS" & mhw_yes_no == "no" & ref_yr != "NEUS-9-2016",]$jaccard_dissimilarity_turnover)
  #p = 0.020
  
  #what if we exclude 2017?
  t.test(survey_temporal_diversity_with_MHWs[survey == "NEUS" & mhw_yes_no == "yes" & ref_yr != "NEUS-9-2017",]$jaccard_dissimilarity_turnover,
         survey_temporal_diversity_with_MHWs[survey == "NEUS" & mhw_yes_no == "no" & ref_yr != "NEUS-9-2017",]$jaccard_dissimilarity_turnover)
  #p = 0.024
  
#unscaled
bray_turnover_boxplot_MHWs_survey <- ggplot(survey_temporal_diversity_with_MHWs[complete.cases(mhw_yes_no),], aes(x = mhw_yes_no, y = bray_dissimilarity_turnover)) +
  geom_boxplot() +
  labs(x = "MHW?", y = "Bray Dissimilarity Turnover Component") +
  facet_wrap(~survey) +
  theme_classic()

ggsave(bray_turnover_boxplot_MHWs_survey, path = here::here("figures","beta_diversity"), filename = "bray_turnover_boxplot_MHWs_survey.jpg", width = 10, height = 10)

#some surprising patterns jump out here when you look at individual regions
  #For portugal, non MHW years exhibit higher dissimilarity than MHW years
  #For nor-bts, much higher variance in dissimilarity in MHW years

delta_richness_boxplot_MHWs <- ggplot(survey_temporal_diversity_with_MHWs[complete.cases(mhw_yes_no),], aes(x = mhw_yes_no, y = delta_richness)) +
  geom_boxplot() +
  labs(x = "MHW?", y = "Delta Richness") +
  facet_wrap(~survey) +
  theme_classic()

#cool observation
  #For GOA, more likely to gain spp in MHW years and lose species in non-MHW years

ggsave(delta_richness_boxplot_MHWs, path = here::here("figures","beta_diversity"), filename = "delta_richness_boxplot_MHWs_survey.jpg", width = 10, height = 10)

#scaled
jaccard_turnover_boxplot_MHWs_survey_scaled <- ggplot(survey_temporal_diversity_with_MHWs[complete.cases(mhw_yes_no),], aes(x = mhw_yes_no, y = jaccard_dissimilarity_turnover_scaled_by_survey)) +
  geom_boxplot() +
  labs(x = "MHW?", y = "Bray Dissimilarity Turnover Component") +
  facet_wrap(~region) +
  theme_classic()

ggsave(jaccard_turnover_boxplot_MHWs_survey_scaled, path = here::here("figures","beta_diversity"), filename = "jaccard_turnover_boxplot_MHWs_survey_scaled.jpg", width = 10, height = 4)


bray_turnover_boxplot_MHWs_survey_scaled <- ggplot(survey_temporal_diversity_with_MHWs[complete.cases(mhw_yes_no),], aes(x = mhw_yes_no, y = bray_dissimilarity_turnover_scaled_by_survey)) +
  geom_boxplot() +
  labs(x = "MHW?", y = "Bray Dissimilarity Turnover Component") +
  facet_wrap(~region) +
  theme_classic()

ggsave(bray_turnover_boxplot_MHWs_survey_scaled, path = here::here("figures","beta_diversity"), filename = "bray_turnover_boxplot_MHWs_survey_scaled.jpg", width = 10, height = 4)


delta_richness_boxplot_MHWs_scaled <- ggplot(survey_temporal_diversity_with_MHWs[complete.cases(mhw_yes_no),], aes(x = mhw_yes_no, y = delta_richness_scaled_by_survey)) +
  geom_boxplot() +
  labs(x = "MHW?", y = "Delta Richness") +
  facet_wrap(~region) +
  theme_classic()

ggsave(delta_richness_boxplot_MHWs_scaled, path = here::here("figures","beta_diversity"), filename = "delta_richness_boxplot_MHWs_survey_scaled.jpg", width = 10, height = 10)


###########################
###### Heat Wave Cumulative Mean Intensity
###########################  

#anom_int (Cumulative Mean Intensity) versus percent change in richness

delta_richness_cum_mean_int <- ggplot(survey_temporal_diversity_with_MHWs, aes(x = anom_int, y = richness_percent_change)) +
  labs(x = "Cumulative Mean Intensity", y = "Percent Change in Richness") +
  geom_hline(yintercept = 0) +
  geom_text(data = survey_temporal_diversity_with_MHWs[anom_int > 1 | abs(richness_percent_change) > 0.5,], aes(label=ref_yr),hjust="inward", vjust=2, size = 2, check_overlap = T) +
  geom_point(alpha = 0.5, aes(color = mhw_yes_no)) +
  geom_spline(nknots = 15, color = "gray28", alpha = 0.7, linetype = "longdash") +
  theme_classic()

ggsave(delta_richness_cum_mean_int, path = here::here("figures","beta_diversity"), filename = "delta_richness_cum_mean_int.jpg", width = 10, height = 4)

#anom_int (Cumulative Mean Intensity) versus jaccard dissimilarity
#unscaled
jaccard_turnover_cum_mean_int <- ggplot(survey_temporal_diversity_with_MHWs, aes(x = anom_int, y = jaccard_dissimilarity_turnover)) +
  geom_point(alpha = 0.5, aes(color = mhw_yes_no)) +
  labs(x = "Cumulative Mean Intensity", y = "Jaccard Dissimilarity Turnover Component") +
  geom_text(data = survey_temporal_diversity_with_MHWs[anom_int > 1 | jaccard_dissimilarity_turnover > 0.4 | jaccard_dissimilarity_turnover < 0.05,], aes(label=ref_yr),hjust="inward", vjust=2, size = 2, position = "dodge") +
  #     geom_hline(yintercept = mean(survey_temporal_diversity_with_MHWs$jaccard_dissimilarity_turnover, na.rm = T)) +
  geom_spline(nknots = 15, color = "gray28", alpha = 0.7, linetype = "longdash") +
  theme_classic()

ggsave(jaccard_turnover_cum_mean_int, path = here::here("figures","beta_diversity"), filename = "jaccard_turnover_cum_mean_int.jpg", width = 10, height = 4)

#anom_int (Cumulative Mean Intensity) versus Bray dissimilarity

bray_turnover_cum_mean_int <- ggplot(survey_temporal_diversity_with_MHWs, aes(x = anom_int, y = bray_dissimilarity_turnover)) +
  geom_point(alpha = 0.5, aes(color = mhw_yes_no)) +
  labs(x = "Cumulative Mean Intensity", y = "Bray Dissimilarity Turnover Component") +
  geom_text(data = survey_temporal_diversity_with_MHWs[anom_int > 1 | bray_dissimilarity_turnover > 0.35 | bray_dissimilarity_turnover < 0.01,], aes(label=ref_yr),hjust="inward", vjust=2, size = 2) +
  #     geom_hline(yintercept = mean(survey_temporal_diversity_with_MHWs$bray_dissimilarity_turnover, na.rm = T)) +
  geom_spline(nknots = 15, color = "gray28", alpha = 0.7, linetype = "longdash") +
  theme_classic()

ggsave(bray_turnover_cum_mean_int, path = here::here("figures","beta_diversity"), filename = "bray_turnover_cum_mean_int.jpg", width = 10, height = 4)

#scaled
jaccard_turnover_cum_mean_int_scaled <- ggplot(survey_temporal_diversity_with_MHWs, aes(x = anom_int, y = jaccard_dissimilarity_turnover_scaled_by_survey)) +
  geom_point(alpha = 0.5, aes(color = mhw_yes_no)) +
  labs(x = "Cumulative Mean Intensity", y = "Bray Dissimilarity Turnover Component\nScaled within Region") +
  geom_text(data = survey_temporal_diversity_with_MHWs[anom_int > 1 | jaccard_dissimilarity_turnover_scaled_by_survey > 2 | jaccard_dissimilarity_turnover_scaled_by_survey < -1.75,], aes(label=ref_yr),hjust="inward", vjust=2, size = 2) +
  #     geom_hline(yintercept = mean(survey_temporal_diversity_with_MHWs$jaccard_dissimilarity_turnover, na.rm = T)) +
  geom_spline(nknots = 15, color = "gray28", alpha = 0.7, linetype = "longdash") +
  theme_classic()

ggsave(jaccard_turnover_cum_mean_int_scaled, path = here::here("figures","beta_diversity"), filename = "jaccard_turnover_cum_mean_int_scaled.jpg", width = 10, height = 4)


bray_turnover_cum_mean_int_scaled <- ggplot(survey_temporal_diversity_with_MHWs, aes(x = anom_int, y = bray_dissimilarity_turnover_scaled_by_survey)) +
  geom_point(alpha = 0.5, aes(color = mhw_yes_no)) +
  labs(x = "Cumulative Mean Intensity", y = "Bray Dissimilarity Turnover Component\nScaled within Region") +
  geom_text(data = survey_temporal_diversity_with_MHWs[anom_int > 1 | bray_dissimilarity_turnover_scaled_by_survey > 2 | bray_dissimilarity_turnover_scaled_by_survey < -1.75,], aes(label=ref_yr),hjust="inward", vjust=2, size = 2) +
  #     geom_hline(yintercept = mean(survey_temporal_diversity_with_MHWs$bray_dissimilarity_turnover, na.rm = T)) +
  geom_spline(nknots = 15, color = "gray28", alpha = 0.7, linetype = "longdash") +
  theme_classic()

ggsave(bray_turnover_cum_mean_int_scaled, path = here::here("figures","beta_diversity"), filename = "bray_turnover_cum_mean_int_scaled.jpg", width = 10, height = 4)


###########################
###### Heat Wave Length
###########################    

#anom_days versus richness percent change

delta_richness_anomaly_days <- ggplot(survey_temporal_diversity_with_MHWs, aes(x = anom_days, y = richness_percent_change)) +
  geom_point(alpha = 0.5, aes(color = mhw_yes_no)) +
  geom_hline(yintercept = 0) +
  geom_text(data = survey_temporal_diversity_with_MHWs[anom_days > 100 | abs(richness_percent_change) > 0.5,], aes(label=ref_yr),hjust="inward", vjust=2, size = 2) +
  labs(x = "Anomaly Days", y = "Percent Change Richness") +
  geom_spline(nknots = 15, color = "gray28", alpha = 0.7, linetype = "longdash") +
  theme_classic()

ggsave(delta_richness_anomaly_days, path = here::here("figures","beta_diversity"), filename = "delta_richness_anomaly_days.jpg", width = 10, height = 4)


#anom_days versus dissimilarity
#unscaled
jaccard_turnover_anomaly_days <- ggplot(survey_temporal_diversity_with_MHWs, aes(x = anom_days, y = jaccard_dissimilarity_turnover)) +
  geom_point(alpha = 0.5, aes(color = mhw_yes_no)) +
  labs(x = "Anomaly Days", y = "Jaccard Dissimilarity Turnover Component") +
  geom_text(data = survey_temporal_diversity_with_MHWs[anom_days > 100 | jaccard_dissimilarity_turnover > 0.4 | jaccard_dissimilarity_turnover < 0.05,], aes(label=ref_yr),hjust="inward", vjust=2, size = 2) +
  #   geom_hline(yintercept = mean(survey_temporal_diversity_with_MHWs$jaccard_dissimilarity_turnover, na.rm = T)) +
  geom_spline(nknots = 15, color = "gray28", alpha = 0.7, linetype = "longdash") +
  theme_classic()

ggsave(jaccard_turnover_anomaly_days, path = here::here("figures","beta_diversity"), filename = "jaccard_turnover_anomaly_days.jpg", width = 10, height = 4)


bray_turnover_anomaly_days <- ggplot(survey_temporal_diversity_with_MHWs, aes(x = anom_days, y = bray_dissimilarity_turnover)) +
  geom_point(alpha = 0.5, aes(color = mhw_yes_no)) +
  labs(x = "Anomaly Days", y = "Bray Dissimilarity Turnover Component") +
  geom_text(data = survey_temporal_diversity_with_MHWs[anom_days > 100 | bray_dissimilarity_turnover > 0.4,], aes(label=ref_yr),hjust="inward", vjust=2, size = 2) +
  #   geom_hline(yintercept = mean(survey_temporal_diversity_with_MHWs$bray_dissimilarity_turnover, na.rm = T)) +
  geom_spline(nknots = 15, color = "gray28", alpha = 0.7, linetype = "longdash") +
  theme_classic()

ggsave(bray_turnover_anomaly_days, path = here::here("figures","beta_diversity"), filename = "bray_turnover_anomaly_days.jpg", width = 10, height = 4)

#interesting contrast between jaccard and bray here
    #with jaccard, higher dissimilarity for longest heatwaves
    #with bray, slightly lower dissimilarity for longest heatwaves

#scaled
jaccard_turnover_anomaly_days_scaled <- ggplot(survey_temporal_diversity_with_MHWs, aes(x = anom_days, y = jaccard_dissimilarity_turnover_scaled_by_survey)) +
  geom_point(alpha = 0.5, aes(color = mhw_yes_no)) +
  labs(x = "Anomaly Days", y = "Bray Dissimilarity Turnover Component\nScaled within Region") +
  geom_text(data = survey_temporal_diversity_with_MHWs[anom_days > 100 | jaccard_dissimilarity_turnover_scaled_by_survey > 2 | jaccard_dissimilarity_turnover_scaled_by_survey < -1.8,], aes(label=ref_yr),hjust="inward", vjust=2, size = 2) +
  #   geom_hline(yintercept = mean(survey_temporal_diversity_with_MHWs$jaccard_dissimilarity_turnover, na.rm = T)) +
  geom_spline(nknots = 15, color = "gray28", alpha = 0.7, linetype = "longdash") +
  theme_classic()

ggsave(jaccard_turnover_anomaly_days_scaled, path = here::here("figures","beta_diversity"), filename = "jaccard_turnover_anomaly_days_scaled.jpg", width = 10, height = 4)


bray_turnover_anomaly_days_scaled <- ggplot(survey_temporal_diversity_with_MHWs, aes(x = anom_days, y = bray_dissimilarity_turnover_scaled_by_survey)) +
  geom_point(alpha = 0.5, aes(color = mhw_yes_no)) +
  labs(x = "Anomaly Days", y = "Bray Dissimilarity Turnover Component\nScaled within Region") +
  geom_text(data = survey_temporal_diversity_with_MHWs[anom_days > 100 | bray_dissimilarity_turnover_scaled_by_survey > 2 | bray_dissimilarity_turnover_scaled_by_survey < -1.8,], aes(label=ref_yr),hjust="inward", vjust=2, size = 2) +
  #   geom_hline(yintercept = mean(survey_temporal_diversity_with_MHWs$bray_dissimilarity_turnover, na.rm = T)) +
  geom_spline(nknots = 15, color = "gray28", alpha = 0.7, linetype = "longdash") +
  theme_classic()

ggsave(bray_turnover_anomaly_days_scaled, path = here::here("figures","beta_diversity"), filename = "bray_turnover_anomaly_days_scaled.jpg", width = 10, height = 4)



###########################
###### Heat Wave Severity
###########################    

#anom_sev versus percent change richness
delta_richness_severity <- ggplot(survey_temporal_diversity_with_MHWs, aes(x = anom_sev, y = richness_percent_change)) +
  geom_point(alpha = 0.5, aes(color = mhw_yes_no)) +
  geom_hline(yintercept = 0) +
  geom_text(data = survey_temporal_diversity_with_MHWs[anom_sev > 85 | abs(richness_percent_change) > 0.5,], aes(label=ref_yr),hjust="inward", vjust=2, size = 2) +
  labs(x = "Heat Wave Severity", y = "Percent Change Richness") +
  #   geom_hline(yintercept = mean(survey_temporal_diversity_with_MHWs$jaccard_dissimilarity_turnover, na.rm = T)) +
  geom_spline(nknots = 15, color = "gray28", alpha = 0.7, linetype = "longdash") +
  theme_classic()

ggsave(delta_richness_severity, path = here::here("figures","beta_diversity"), filename = "delta_richness_severity.jpg", width = 10, height = 4)


#anom_sev versus dissimilarity
#unscaled
jaccard_turnover_severity <- ggplot(survey_temporal_diversity_with_MHWs, aes(x = anom_sev, y = jaccard_dissimilarity_turnover)) +
  geom_point(alpha = 0.5, aes(color = mhw_yes_no)) +
  geom_text(data = survey_temporal_diversity_with_MHWs[anom_sev > 85 | jaccard_dissimilarity_turnover > 0.4 | jaccard_dissimilarity_turnover < 0.05,], aes(label=ref_yr),hjust="inward", vjust=2, size = 2) +
  labs(x = "Heat Wave Severity", y = "Jaccard Dissimilarity Turnover Component") +
  #   geom_hline(yintercept = mean(survey_temporal_diversity_with_MHWs$jaccard_dissimilarity_turnover, na.rm = T)) +
  geom_spline(nknots = 15, color = "gray28", alpha = 0.7, linetype = "longdash") +
  theme_classic()

ggsave(jaccard_turnover_severity, path = here::here("figures","beta_diversity"), filename = "jaccard_turnover_severity.jpg", width = 10, height = 4)


bray_turnover_severity <- ggplot(survey_temporal_diversity_with_MHWs, aes(x = anom_sev, y = bray_dissimilarity_turnover)) +
  geom_point(alpha = 0.5, aes(color = mhw_yes_no)) +
  geom_text(data = survey_temporal_diversity_with_MHWs[anom_sev > 85 | bray_dissimilarity_turnover > 0.4,], aes(label=ref_yr),hjust="inward", vjust=2, size = 2) +
  labs(x = "Heat Wave Severity", y = "Bray Dissimilarity Turnover Component") +
  #   geom_hline(yintercept = mean(survey_temporal_diversity_with_MHWs$bray_dissimilarity_turnover, na.rm = T)) +
  geom_spline(nknots = 15, color = "gray28", alpha = 0.7, linetype = "longdash") +
  theme_classic()

ggsave(bray_turnover_severity, path = here::here("figures","beta_diversity"), filename = "bray_turnover_severity.jpg", width = 10, height = 4)

#scaled
jaccard_turnover_severity_scaled <- ggplot(survey_temporal_diversity_with_MHWs, aes(x = anom_sev, y = jaccard_dissimilarity_turnover_scaled_by_survey)) +
  geom_point(alpha = 0.5, aes(color = mhw_yes_no)) +
  geom_text(data = survey_temporal_diversity_with_MHWs[anom_sev > 85 | jaccard_dissimilarity_turnover_scaled_by_survey > 0.4,], aes(label=ref_yr),hjust="inward", vjust=2, size = 2) +
  labs(x = "Heat Wave Severity", y = "Bray Dissimilarity Turnover Component\nScaled within Region") +
  #   geom_hline(yintercept = mean(survey_temporal_diversity_with_MHWs$jaccard_dissimilarity_turnover, na.rm = T)) +
  geom_spline(nknots = 15, color = "gray28", alpha = 0.7, linetype = "longdash") +
  theme_classic()

ggsave(jaccard_turnover_severity_scaled, path = here::here("figures","beta_diversity"), filename = "jaccard_turnover_severity_scaled.jpg", width = 10, height = 4)



bray_turnover_severity_scaled <- ggplot(survey_temporal_diversity_with_MHWs, aes(x = anom_sev, y = bray_dissimilarity_turnover_scaled_by_survey)) +
  geom_point(alpha = 0.5, aes(color = mhw_yes_no)) +
  geom_text(data = survey_temporal_diversity_with_MHWs[anom_sev > 85 | bray_dissimilarity_turnover_scaled_by_survey > 0.4,], aes(label=ref_yr),hjust="inward", vjust=2, size = 2) +
  labs(x = "Heat Wave Severity", y = "Bray Dissimilarity Turnover Component\nScaled within Region") +
  #   geom_hline(yintercept = mean(survey_temporal_diversity_with_MHWs$bray_dissimilarity_turnover, na.rm = T)) +
  geom_spline(nknots = 15, color = "gray28", alpha = 0.7, linetype = "longdash") +
  theme_classic()

ggsave(bray_turnover_severity_scaled, path = here::here("figures","beta_diversity"), filename = "bray_turnover_severity_scaled.jpg", width = 10, height = 4)






##############
## NESTED DISSIMILARITY
##############
############
#Heat wave versus no heatwave
############
#compare yes or no heatwave with temporal diversity metric 
#box plot
jaccard_nestedness_boxplot_MHWs <- ggplot(survey_temporal_diversity_with_MHWs[complete.cases(mhw_yes_no),], aes(x = mhw_yes_no, y = jaccard_dissimilarity_nestedness)) +
  geom_boxplot() +
  labs(x = "MHW?", y = "Jaccard Dissimilarity Nestedness") +
  annotate("text",
           x = 1:length(table(survey_temporal_diversity_with_MHWs$mhw_yes_no)),
           y = aggregate(jaccard_dissimilarity_nestedness ~ mhw_yes_no, survey_temporal_diversity_with_MHWs, median)[ , 2],
           label = table(survey_temporal_diversity_with_MHWs$mhw_yes_no),
           col = "red",
           vjust = - 1) +
  theme_classic()

ggsave(jaccard_nestedness_boxplot_MHWs, path = here::here("figures","beta_diversity"), filename = "jaccard_nestedness_boxplot_MHWs.jpg", width = 10, height = 4)

#Is there a significant difference in jaccard_dissimilarity_nestedness between MHW and MHW years and MHW to non-MHW years?
#unpaired two-samples t-test
t.test(survey_temporal_diversity_with_MHWs[mhw_yes_no == "yes",jaccard_dissimilarity_nestedness], survey_temporal_diversity_with_MHWs[mhw_yes_no == "no",jaccard_dissimilarity_nestedness],
       alternative = "two.sided", var.equal = FALSE)
#no significant difference

bray_nestedness_boxplot_MHWs <- ggplot(survey_temporal_diversity_with_MHWs[complete.cases(mhw_yes_no),], aes(x = mhw_yes_no, y = bray_dissimilarity_nestedness)) +
  geom_boxplot() +
  labs(x = "MHW?", y = "Bray Dissimilarity Nestedness") +
  annotate("text",
           x = 1:length(table(survey_temporal_diversity_with_MHWs$mhw_yes_no)),
           y = aggregate(bray_dissimilarity_nestedness ~ mhw_yes_no, survey_temporal_diversity_with_MHWs, median)[ , 2],
           label = table(survey_temporal_diversity_with_MHWs$mhw_yes_no),
           col = "red",
           vjust = - 1) +
  theme_classic()

ggsave(bray_nestedness_boxplot_MHWs, path = here::here("figures","beta_diversity"), filename = "bray_nestedness_boxplot_MHWs.jpg", width = 10, height = 4)

#Is there a significant difference in bray_dissimilarity_nestedness between MHW and MHW years and MHW to non-MHW years?
#unpaired two-samples t-test
t.test(survey_temporal_diversity_with_MHWs[mhw_yes_no == "yes",bray_dissimilarity_nestedness], survey_temporal_diversity_with_MHWs[mhw_yes_no == "no",bray_dissimilarity_nestedness],
       alternative = "two.sided", var.equal = FALSE)
#no significant difference

#box plot by survey
jaccard_nestedness_boxplot_MHWs_survey <- ggplot(survey_temporal_diversity_with_MHWs[complete.cases(mhw_yes_no),], aes(x = mhw_yes_no, y = jaccard_dissimilarity_nestedness)) +
  geom_boxplot() +
  labs(x = "MHW?", y = "Jaccard Dissimilarity Nestedness") +
  facet_wrap(~survey) +
  theme_classic()

ggsave(jaccard_nestedness_boxplot_MHWs_survey, path = here::here("figures","beta_diversity"), filename = "jaccard_nestedness_boxplot_MHWs_survey.jpg", width = 10, height = 10)

#interesting observations
  #higher dissimilarity in nestedness for non-heatwave years for DFO-QCS
  #let's dig into this
  queen_charlotte_sound_data <- survey_temporal_diversity_with_MHWs[survey  == "DFO-QCS",]
  #5/10 years are heatwave years,  so not super robust


bray_nestedness_boxplot_MHWs_survey <- ggplot(survey_temporal_diversity_with_MHWs[complete.cases(mhw_yes_no),], aes(x = mhw_yes_no, y = bray_dissimilarity_nestedness)) +
  geom_boxplot() +
  labs(x = "MHW?", y = "Bray Dissimilarity Nestedness") +
  facet_wrap(~survey) +
  theme_classic()

ggsave(bray_nestedness_boxplot_MHWs_survey, path = here::here("figures","beta_diversity"), filename = "bray_nestedness_boxplot_MHWs_survey.jpg", width = 10, height = 10)

#interesting observations
  #higher nestedness dissimilarity for portugal in heatwave years than non heatwave years
  #let's dig into this
  portugal_data <- survey_temporal_diversity_with_MHWs[survey  == "PT-IBTS",]
  #3/12 years are non heatwave years, so not super robust
  
  #lower nestedness dissimilarity for ireland in heatwave years than non heatwave years
  #let's dig into this
  ireland_data <- survey_temporal_diversity_with_MHWs[survey  == "NIGFS",]
  #4/10 years are heatwave years,  so not super robust

###########################
###### Heat Wave Cumulative Mean Intensity
###########################  

#anom_int (Cumulative Mean Intensity) versus dissimilarity
jaccard_nestedness_cum_mean_int <- ggplot(survey_temporal_diversity_with_MHWs, aes(x = anom_int, y = jaccard_dissimilarity_nestedness)) +
  geom_point(alpha = 0.5, aes(color = mhw_yes_no)) +
  labs(x = "Cumulative Mean Intensity", y = "Jaccard Dissimilarity Nestedness") +
  geom_text(data = survey_temporal_diversity_with_MHWs[anom_int > 1 | abs(richness_percent_change) > 0.5,], aes(label=ref_yr),hjust="inward", vjust=2, size = 2) +
   #    geom_hline(yintercept = mean(survey_temporal_diversity_with_MHWs$jaccard_dissimilarity_nestedness, na.rm = T)) +
  theme_classic()

ggsave(jaccard_nestedness_cum_mean_int, path = here::here("figures","beta_diversity"), filename = "jaccard_nestedness_cum_mean_int.jpg", width = 10, height = 4)


bray_nestedness_cum_mean_int <- ggplot(survey_temporal_diversity_with_MHWs, aes(x = anom_int, y = bray_dissimilarity_nestedness)) +
  geom_point(alpha = 0.5, aes(color = mhw_yes_no)) +
  labs(x = "Cumulative Mean Intensity", y = "Bray Dissimilarity Nestedness") +
  geom_text(data = survey_temporal_diversity_with_MHWs[anom_int > 1 | abs(richness_percent_change) > 0.5,], aes(label=ref_yr),hjust="inward", vjust=2, size = 2) +
  #     geom_hline(yintercept = mean(survey_temporal_diversity_with_MHWs$bray_dissimilarity_nestedness, na.rm = T)) +
  theme_classic()

ggsave(bray_nestedness_cum_mean_int, path = here::here("figures","beta_diversity"), filename = "bray_nestedness_cum_mean_int.jpg", width = 10, height = 4)
##########################
##### Heat Wave Length
##########################    
#anom_days versus dissimilarity
jaccard_nestedness_anomaly_days <- ggplot(survey_temporal_diversity_with_MHWs, aes(x = anom_days, y = jaccard_dissimilarity_nestedness)) +
  geom_point(alpha = 0.5, aes(color = mhw_yes_no)) +
  labs(x = "Anomaly Days", y = "Jaccard Dissimilarity Nestedness") +
  geom_text(data = survey_temporal_diversity_with_MHWs[anom_days > 100 | abs(richness_percent_change) > 0.5,], aes(label=ref_yr),hjust="inward", vjust=2, size = 2) +
  #   geom_hline(yintercept = mean(survey_temporal_diversity_with_MHWs$jaccard_dissimilarity_nestedness, na.rm = T)) +
  theme_classic()

ggsave(jaccard_nestedness_anomaly_days, path = here::here("figures","beta_diversity"), filename = "jaccard_nestedness_anomaly_days.jpg", width = 10, height = 4)


bray_nestedness_anomaly_days <- ggplot(survey_temporal_diversity_with_MHWs, aes(x = anom_days, y = bray_dissimilarity_nestedness)) +
  geom_point(alpha = 0.5, aes(color = mhw_yes_no)) +
  labs(x = "Anomaly Days", y = "Bray Dissimilarity Nestedness") +
  geom_text(data = survey_temporal_diversity_with_MHWs[anom_days > 100 | abs(richness_percent_change) > 0.5,], aes(label=ref_yr),hjust="inward", vjust=2, size = 2) +
  #   geom_hline(yintercept = mean(survey_temporal_diversity_with_MHWs$bray_dissimilarity_nestedness, na.rm = T)) +
  theme_classic()

ggsave(bray_nestedness_anomaly_days, path = here::here("figures","beta_diversity"), filename = "bray_nestedness_anomaly_days.jpg", width = 10, height = 4)
##########################
##### Heat Wave Severity
##########################    
#anom_sev versus dissimilarity
jaccard_nestedness_severity <- ggplot(survey_temporal_diversity_with_MHWs, aes(x = anom_sev, y = jaccard_dissimilarity_nestedness)) +
  geom_point(alpha = 0.5, aes(color = mhw_yes_no)) +
  geom_text(data = survey_temporal_diversity_with_MHWs[anom_sev > 85 | abs(richness_percent_change) > 0.5,], aes(label=ref_yr),hjust="inward", vjust=2, size = 2) +
  labs(x = "Heat Wave Severity", y = "Jaccard Dissimilarity Nestedness") +
  #   geom_hline(yintercept = mean(survey_temporal_diversity_with_MHWs$jaccard_dissimilarity_nestedness, na.rm = T)) +
  theme_classic()

ggsave(jaccard_nestedness_severity, path = here::here("figures","beta_diversity"), filename = "jaccard_nestedness_severity.jpg", width = 10, height = 4)


bray_nestedness_severity <- ggplot(survey_temporal_diversity_with_MHWs, aes(x = anom_sev, y = bray_dissimilarity_nestedness)) +
  geom_point(alpha = 0.5, aes(color = mhw_yes_no)) +
  geom_text(data = survey_temporal_diversity_with_MHWs[anom_sev > 85 | abs(richness_percent_change) > 0.5,], aes(label=ref_yr),hjust="inward", vjust=2, size = 2) +
  labs(x = "Heat Wave Severity", y = "Bray Dissimilarity Nestedness") +
  #   geom_hline(yintercept = mean(survey_temporal_diversity_with_MHWs$bray_dissimilarity_nestedness, na.rm = T)) +
  theme_classic()

ggsave(bray_nestedness_severity, path = here::here("figures","beta_diversity"), filename = "bray_nestedness_severity.jpg", width = 10, height = 4)

#######################
#Diverging Bars
#######################
#Anomaly Days
#######################
#sort by anomaly days

setkey(survey_temporal_diversity_with_MHWs, anom_days)
#make a factor to retain in plot
survey_temporal_diversity_with_MHWs[, ref_yr := as.factor(ref_yr)]

#color by increase or decrease in richness
survey_temporal_diversity_with_MHWs[,richness_direction := as.factor(ifelse(richness_percent_change > 0, "Increase",
                                                                                ifelse(richness_percent_change < 0, "Decrease","No Change")))]

#plot
anomalydays_divbar <- ggplot(survey_temporal_diversity_with_MHWs[complete.cases(survey_temporal_diversity_with_MHWs[,richness_percent_change])], aes(x=reorder(ref_yr,anom_days), y=anom_days)) + 
  geom_bar(stat='identity',fill = "black")  +
  labs(x = "Reference Year-Region", y = "Anomaly Days") + 
  coord_flip() +
  theme_classic() +
  theme(axis.ticks.y = element_blank())


################
#% change Richness
#################

#plot
richness_divbar <- ggplot(survey_temporal_diversity_with_MHWs[complete.cases(survey_temporal_diversity_with_MHWs[,richness_percent_change])], aes(x=reorder(ref_yr,anom_days), y=richness_percent_change, label = richness_direction)) + 
  geom_bar(aes(fill = richness_direction),stat='identity')  +
  scale_fill_manual(name="Direction of Richness Change", 
                    labels= c("Decrease" , "Increase",  ""),
                    values = c("darkgoldenrod","plum3","#FFFFFF")) +
  labs(x = "Reference Year-Region", y = "Percent Change Richness\nYear t versus t-1") + 
  coord_flip() +
  theme_classic() +
  theme(legend.position = "top",
        axis.ticks.y = element_blank())

################
#Bray Diversity
#################

#plot
#unscaled
bray_dissim_divbar <- ggplot(survey_temporal_diversity_with_MHWs[complete.cases(survey_temporal_diversity_with_MHWs[,richness_percent_change])], aes(x=reorder(ref_yr,anom_days), y=bray_dissimilarity_turnover)) + 
  geom_bar(stat='identity', fill = "black")  +
  labs(x = "Reference Year-Region", y = "Bray Curtis Turnover Dissimilarity\nYear t versus t-1") + 
  coord_flip() +
  ylim(0,1) +
  theme_classic() +
  theme(axis.ticks.y = element_blank())

#scaled
#plot
bray_dissim_divbar_scaled <- ggplot(survey_temporal_diversity_with_MHWs[complete.cases(survey_temporal_diversity_with_MHWs[,richness_percent_change])], aes(x=reorder(ref_yr,anom_days), y=bray_dissimilarity_turnover_scaled_by_survey)) + 
  geom_bar(stat='identity', fill = "black")  +
  labs(x = "Reference Year-Region", y = "Bray Curtis Turnover Dissimilarity\nYear t versus t-1, Scaled by Region") + 
  coord_flip() +
  ylim(-1,1) +
  theme_classic() +
  theme(axis.ticks.y = element_blank())

################
#Jaccard diversity
#################

#plot


jaccard_dissim_divbar <- ggplot(survey_temporal_diversity_with_MHWs[complete.cases(survey_temporal_diversity_with_MHWs[,richness_percent_change])], aes(x=reorder(ref_yr,anom_days), y=jaccard_dissimilarity_turnover, label = richness_direction)) + 
  geom_bar(stat='identity', fill = "black")  +
  labs(x = "Reference Year-Region", y = "Jaccard Turnover Dissimilarity\nYear t versus t-1") + 
  coord_flip() +
  ylim(0,1) +
  theme_classic() +
  theme(axis.ticks.y = element_blank())

#scaled
#plot
jaccard_dissim_divbar_scaled <- ggplot(survey_temporal_diversity_with_MHWs[complete.cases(survey_temporal_diversity_with_MHWs[,richness_percent_change])], aes(x=reorder(ref_yr,anom_days), y=jaccard_dissimilarity_turnover_scaled_by_survey)) + 
  geom_bar(stat='identity', fill = "black")  +
  labs(x = "Reference Year-Region", y = "Jaccard Curtis Turnover Dissimilarity\nYear t versus t-1, Scaled by Region") + 
  coord_flip() +
  ylim(-1,1) +
  theme_classic() +
  theme(axis.ticks.y = element_blank())


##############
#merge anomaly days and richness change
##############

#unscaled
diverging_bars <- plot_grid(anomalydays_divbar + theme(legend.position = "none", axis.text.y = element_text(size = 1)),
          richness_divbar + theme(legend.position = "none", axis.text.y = element_blank(), axis.title.y = element_blank()),
          bray_dissim_divbar + theme(legend.position = "none", axis.text.y = element_blank(), axis.title.y = element_blank()),
          jaccard_dissim_divbar + theme(legend.position = "none", axis.text.y = element_blank(), axis.title.y = element_blank()),
          nrow = 1, ncol = 4, align = "h")

diverging_bars_legend <- get_legend(richness_divbar)

diverging_bars_wlegend <- plot_grid(diverging_bars_legend, diverging_bars, ncol = 1, rel_heights = c(1,10))

ggsave(diverging_bars_wlegend, path = here::here("figures","beta_diversity"),
       filename = "diverging_bars_wlegend.pdf",height = 10, width = 13, unit = "in")

#scaled
diverging_bars_scaled <- plot_grid(anomalydays_divbar + theme(legend.position = "none", axis.text.y = element_text(size = 1)),
                            richness_divbar + theme(legend.position = "none", axis.text.y = element_blank(), axis.title.y = element_blank()),
                            bray_dissim_divbar_scaled + theme(legend.position = "none", axis.text.y = element_blank(), axis.title.y = element_blank()),
                            jaccard_dissim_divbar_scaled + theme(legend.position = "none", axis.text.y = element_blank(), axis.title.y = element_blank()),
                            nrow = 1, ncol = 4, align = "h")

diverging_bars_legend_scaled <- get_legend(richness_divbar)

diverging_bars_wlegend_scaled <- plot_grid(diverging_bars_legend_scaled, diverging_bars_scaled, ncol = 1, rel_heights = c(1,10))

ggsave(diverging_bars_wlegend_scaled, path = here::here("figures","beta_diversity"),
       filename = "diverging_bars_wlegend_scaled.pdf",height = 10, width = 13, unit = "in")


#Out of curiousity, what's the highest  scaled value of dissimilarity we find?
#when does it happen?
View(survey_temporal_diversity_with_MHWs)

####################
#######Comparisons
###################
#EBS 

#Alabia et al. 2021 (GCB)
#make figure 1 (Beta versus Time)
ggplot(survey_temporal_diversity_with_MHWs[survey == "EBS" ,]) +
  geom_line(aes(x = year, y = jaccard_dissimilarity_total_compare_first_year)) +
  theme_classic()

#linear model?
jaccard_total_mod <- lm(jaccard_dissimilarity_total_compare_first_year~year,
                        data = survey_temporal_diversity_with_MHWs[survey == "EBS" ,])
summary(jaccard_total_mod)




ggplot(survey_temporal_diversity_with_MHWs[survey == "SWC-IBTS" ,]) +
  geom_line(aes(x = year, y = jaccard_dissimilarity_total_compare_first_year)) +
  theme_classic()

#linear model?
jaccard_total_mod <- lm(jaccard_dissimilarity_total_compare_first_year~year, data = survey_temporal_diversity_with_MHWs[survey == "SWC-IBTS" ,])
summary(jaccard_total_mod)

#Karnauskas et al. 2015 (GCB)
#Compare to this claim, "Further analysis of fishery landings composition data 
        #indicates a major shift in the late 1970s coincident with the advent of 
        #US national fisheries management policy, as well as significant shifts
        #in the mid-1960s and the mid-1990s."

ggplot(survey_temporal_diversity_with_MHWs[survey == "GMEX" ,]) +
  geom_line(aes(x = year, y = jaccard_dissimilarity_total)) +
  theme_classic()

ggplot(survey_temporal_diversity_with_MHWs[survey == "GMEX" ,]) +
  geom_line(aes(x = year, y = jaccard_dissimilarity_total_compare_first_year)) +
  theme_classic()

