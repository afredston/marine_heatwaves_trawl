#This code explores relationships between turnover, richness, and MHWs
#Specifically, these figures compare heat wave intensity with the 
#turnover component of beta diversity between previous year and  given year
#(measured with bray curtis dissimilarity)
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
survey_CTI_with_MHWs <- fread(here::here("processed-data","survey_CTI_with_MHWs.csv"))

#only sst metrics
survey_CTI_with_MHWs.sst <- survey_CTI_with_MHWs[metric == "sst"]

#match codes
region <- c("aleutian_islands" ,"bits" ,"eastern_bering_sea" ,"evhoe" ,
            "fr_cgfs", "gulf_of_alaska" ,"gulf_of_mexico" ,"ie_igfs" ,
            "norbts" ,"northeast", "ns_ibts" ,"pt_ibts" ,"rockall" ,
            "scotian_shelf" ,"southeast", "swc_ibts" ,"west_coast_annual",
            "west_coast_triennial")

survey <- c("AI" ,"BITS" ,"EBS" ,"EVHOE" ,
            "FR-CGFS", "GOA" ,"GMEX" ,"IE-IGFS" ,
            "Nor-BTS" ,"NEUS", "NS-IBTS" ,"PT-IBTS" ,"ROCKALL" ,
            "SCS" ,"SEUS", "SWC-IBTS" ,"WCANN",
            "WCTRI")

match_codes <- data.table(region = region, survey = survey)

#merge codes with diversities
survey_temporal_beta_diversity <- match_codes[survey_temporal_beta_diversity, on = "survey"]

#merge MHWs and CTI with temporal beta diversity

survey_CTI_temporal_diversity_with_MHWs <- survey_temporal_beta_diversity[survey_CTI_with_MHWs.sst, on = c("year","region")]

#add in the number of mhw events to give sense of sample size
survey_CTI_temporal_diversity_with_MHWs[,N := .N,.(region,mhwYesNo)]

head(survey_CTI_temporal_diversity_with_MHWs)

#add in bray dissimilarity turnover values and delta_richness values that are scaled by region

survey_CTI_temporal_diversity_with_MHWs[,bray_dissimilarity_turnover_scaled_by_region :=
                                          scale(bray_dissimilarity_turnover),region][,
                                          delta_richness_scaled_by_region :=
                                          scale(delta_richness),region]


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

#jaccard_turnover_boxplot_MHWs <- ggplot(survey_CTI_temporal_diversity_with_MHWs[complete.cases(mhwYesNo),], aes(x = mhwYesNo, y = jaccard_dissimilarity_turnover)) +
#  geom_boxplot() +
#  labs(x = "MHW?", y = "Jaccard Dissimilarity Turnover Component") +
#  annotate("text",
#           x = 1:length(table(survey_CTI_temporal_diversity_with_MHWs$mhwYesNo)),
#           y = aggregate(jaccard_dissimilarity_turnover ~ mhwYesNo, survey_CTI_temporal_diversity_with_MHWs, median)[ , 2],
#           label = table(survey_CTI_temporal_diversity_with_MHWs$mhwYesNo),
#           col = "red",
#           vjust = - 1) +
#  theme_classic()
#
#ggsave(jaccard_turnover_boxplot_MHWs, path = here::here("figures","beta_diversity"), filename = "jaccard_turnover_boxplot_MHWs.jpg", width = 10, height = 4)

#unscaled
bray_turnover_boxplot_MHWs <- ggplot(survey_CTI_temporal_diversity_with_MHWs[complete.cases(mhwYesNo),], aes(x = mhwYesNo, y = bray_dissimilarity_turnover)) +
  geom_boxplot() +
  labs(x = "MHW?", y = "Bray Dissimilarity Turnover Component") +
  annotate("text",
           x = 1:length(table(survey_CTI_temporal_diversity_with_MHWs$mhwYesNo)),
           y = aggregate(bray_dissimilarity_turnover ~ mhwYesNo, survey_CTI_temporal_diversity_with_MHWs, median)[ , 2],
           label = table(survey_CTI_temporal_diversity_with_MHWs$mhwYesNo),
           col = "red",
           vjust = - 1) +
  theme_classic()

ggsave(bray_turnover_boxplot_MHWs, path = here::here("figures","beta_diversity"), filename = "bray_turnover_boxplot_MHWs.jpg", width = 10, height = 4)


delta_richness_boxplot_MHWs <- ggplot(survey_CTI_temporal_diversity_with_MHWs[complete.cases(mhwYesNo),], aes(x = mhwYesNo, y = delta_richness)) +
  geom_boxplot() +
  labs(x = "MHW?", y = "Delta Richness") +
  annotate("text",
           x = 1:length(table(survey_CTI_temporal_diversity_with_MHWs$mhwYesNo)),
           y = aggregate(delta_richness ~ mhwYesNo, survey_CTI_temporal_diversity_with_MHWs, median)[ , 2],
           label = table(survey_CTI_temporal_diversity_with_MHWs$mhwYesNo),
           col = "red",
           vjust = - 1) +
  theme_classic()

ggsave(delta_richness_boxplot_MHWs, path = here::here("figures","beta_diversity"), filename = "delta_richness_boxplot_MHWs.jpg", width = 10, height = 4)

#scaled
bray_turnover_boxplot_MHWs_scaled <- ggplot(survey_CTI_temporal_diversity_with_MHWs[complete.cases(mhwYesNo),], aes(x = mhwYesNo, y = bray_dissimilarity_turnover_scaled_by_region)) +
  geom_boxplot() +
  labs(x = "MHW?", y = "Bray Dissimilarity Turnover Component\nScaled within Regions") +
  annotate("text",
           x = 1:length(table(survey_CTI_temporal_diversity_with_MHWs$mhwYesNo)),
           y = aggregate(bray_dissimilarity_turnover_scaled_by_region ~ mhwYesNo, survey_CTI_temporal_diversity_with_MHWs, median)[ , 2],
           label = table(survey_CTI_temporal_diversity_with_MHWs$mhwYesNo),
           col = "red",
           vjust = - 1) +
  theme_classic()

ggsave(bray_turnover_boxplot_MHWs_scaled, path = here::here("figures","beta_diversity"), filename = "bray_turnover_boxplot_MHWs_scaled.jpg", width = 10, height = 4)


delta_richness_boxplot_MHWs_scaled <- ggplot(survey_CTI_temporal_diversity_with_MHWs[complete.cases(mhwYesNo),], aes(x = mhwYesNo, y = delta_richness_scaled_by_region)) +
  geom_boxplot() +
  labs(x = "MHW?", y = "Delta Richness\nScaled within Region") +
  annotate("text",
           x = 1:length(table(survey_CTI_temporal_diversity_with_MHWs$mhwYesNo)),
           y = aggregate(delta_richness_scaled_by_region ~ mhwYesNo, survey_CTI_temporal_diversity_with_MHWs, median)[ , 2],
           label = table(survey_CTI_temporal_diversity_with_MHWs$mhwYesNo),
           col = "red",
           vjust = - 1) +
  theme_classic()

ggsave(delta_richness_boxplot_MHWs_scaled, path = here::here("figures","beta_diversity"), filename = "delta_richness_boxplot_MHWs_scaled.jpg", width = 10, height = 4)



#box plot by survey

#jaccard_turnover_boxplot_MHWs_survey <- ggplot(survey_CTI_temporal_diversity_with_MHWs[complete.cases(mhwYesNo),], aes(x = mhwYesNo, y = jaccard_dissimilarity_turnover)) +
#  geom_boxplot() +
#  labs(x = "MHW?", y = "Jaccard Dissimilarity Turnover Component") +
#  facet_wrap(~region) +
#  theme_classic()
#
#ggsave(jaccard_turnover_boxplot_MHWs_survey, path = here::here("figures","beta_diversity"), filename = "jaccard_turnover_boxplot_MHWs_survey.jpg", width = 10, height = 4)

#unscaled
bray_turnover_boxplot_MHWs_survey <- ggplot(survey_CTI_temporal_diversity_with_MHWs[complete.cases(mhwYesNo),], aes(x = mhwYesNo, y = bray_dissimilarity_turnover)) +
  geom_boxplot() +
  labs(x = "MHW?", y = "Bray Dissimilarity Turnover Component") +
  facet_wrap(~region) +
  theme_classic()

ggsave(bray_turnover_boxplot_MHWs_survey, path = here::here("figures","beta_diversity"), filename = "bray_turnover_boxplot_MHWs_survey.jpg", width = 10, height = 4)


delta_richness_boxplot_MHWs <- ggplot(survey_CTI_temporal_diversity_with_MHWs[complete.cases(mhwYesNo),], aes(x = mhwYesNo, y = delta_richness)) +
  geom_boxplot() +
  labs(x = "MHW?", y = "Delta Richness") +
  facet_wrap(~region) +
  theme_classic()

ggsave(delta_richness_boxplot_MHWs, path = here::here("figures","beta_diversity"), filename = "delta_richness_boxplot_MHWs_survey.jpg", width = 10, height = 10)

#scaled
bray_turnover_boxplot_MHWs_survey_scaled <- ggplot(survey_CTI_temporal_diversity_with_MHWs[complete.cases(mhwYesNo),], aes(x = mhwYesNo, y = bray_dissimilarity_turnover_scaled_by_region)) +
  geom_boxplot() +
  labs(x = "MHW?", y = "Bray Dissimilarity Turnover Component") +
  facet_wrap(~region) +
  theme_classic()

ggsave(bray_turnover_boxplot_MHWs_survey_scaled, path = here::here("figures","beta_diversity"), filename = "bray_turnover_boxplot_MHWs_survey_scaled.jpg", width = 10, height = 4)


delta_richness_boxplot_MHWs_scaled <- ggplot(survey_CTI_temporal_diversity_with_MHWs[complete.cases(mhwYesNo),], aes(x = mhwYesNo, y = delta_richness_scaled_by_region)) +
  geom_boxplot() +
  labs(x = "MHW?", y = "Delta Richness") +
  facet_wrap(~region) +
  theme_classic()

ggsave(delta_richness_boxplot_MHWs_scaled, path = here::here("figures","beta_diversity"), filename = "delta_richness_boxplot_MHWs_survey_scaled.jpg", width = 10, height = 10)


###########################
###### Heat Wave Cumulative Mean Intensity
###########################  

#anomIntC (Cumulative Mean Intensity) versus percent change in richness

delta_richness_cum_mean_int <- ggplot(survey_CTI_temporal_diversity_with_MHWs, aes(x = anomIntC, y = richness_percent_change)) +
  labs(x = "Cumulative Mean Intensity", y = "Percent Change in Richness") +
  geom_hline(yintercept = 0) +
  geom_text(data = survey_CTI_temporal_diversity_with_MHWs[anomIntC > 1 | abs(richness_percent_change) > 0.5,], aes(label=ref_year),hjust="inward", vjust=2, size = 2, check_overlap = T) +
  geom_point(alpha = 0.5, aes(color = mhwYesNo)) +
  geom_spline(nknots = 15, color = "gray28", alpha = 0.7, linetype = "longdash") +
  theme_classic()

ggsave(delta_richness_cum_mean_int, path = here::here("figures","beta_diversity"), filename = "delta_richness_cum_mean_int.jpg", width = 10, height = 4)

#anomIntC (Cumulative Mean Intensity) versus dissimilarity

#jaccard_turnover_cum_mean_int <- ggplot(survey_CTI_temporal_diversity_with_MHWs, aes(x = anomIntC, y = jaccard_dissimilarity_turnover)) +
#  geom_point(alpha = 0.5, aes(color = mhwYesNo)) +
#  labs(x = "Cumulative Mean Intensity", y = "Jaccard Dissimilarity Turnover Component") +
#  geom_text(data = survey_CTI_temporal_diversity_with_MHWs[anomIntC > 1 | jaccard_dissimilarity_turnover > 0.4 | jaccard_dissimilarity_turnover < 0.05,], aes(label=ref_year),hjust="inward", vjust=2, size = 2, position = "dodge") +
#  #     geom_hline(yintercept = mean(survey_CTI_temporal_diversity_with_MHWs$jaccard_dissimilarity_turnover, na.rm = T)) +
#  geom_spline(nknots = 15, color = "gray28", alpha = 0.7, linetype = "longdash") +
#  theme_classic()
#
#ggsave(jaccard_turnover_cum_mean_int, path = here::here("figures","beta_diversity"), filename = "jaccard_turnover_cum_mean_int.jpg", width = 10, height = 4)

#unscaled
bray_turnover_cum_mean_int <- ggplot(survey_CTI_temporal_diversity_with_MHWs, aes(x = anomIntC, y = bray_dissimilarity_turnover)) +
  geom_point(alpha = 0.5, aes(color = mhwYesNo)) +
  labs(x = "Cumulative Mean Intensity", y = "Bray Dissimilarity Turnover Component") +
  geom_text(data = survey_CTI_temporal_diversity_with_MHWs[anomIntC > 1 | bray_dissimilarity_turnover > 0.35 | bray_dissimilarity_turnover < 0.01,], aes(label=ref_year),hjust="inward", vjust=2, size = 2) +
  #     geom_hline(yintercept = mean(survey_CTI_temporal_diversity_with_MHWs$bray_dissimilarity_turnover, na.rm = T)) +
  geom_spline(nknots = 15, color = "gray28", alpha = 0.7, linetype = "longdash") +
  theme_classic()

ggsave(bray_turnover_cum_mean_int, path = here::here("figures","beta_diversity"), filename = "bray_turnover_cum_mean_int.jpg", width = 10, height = 4)

#scaled
bray_turnover_cum_mean_int_scaled <- ggplot(survey_CTI_temporal_diversity_with_MHWs, aes(x = anomIntC, y = bray_dissimilarity_turnover_scaled_by_region)) +
  geom_point(alpha = 0.5, aes(color = mhwYesNo)) +
  labs(x = "Cumulative Mean Intensity", y = "Bray Dissimilarity Turnover Component\nScaled within Region") +
  geom_text(data = survey_CTI_temporal_diversity_with_MHWs[anomIntC > 1 | bray_dissimilarity_turnover_scaled_by_region > 2 | bray_dissimilarity_turnover_scaled_by_region < -1.75,], aes(label=ref_year),hjust="inward", vjust=2, size = 2) +
  #     geom_hline(yintercept = mean(survey_CTI_temporal_diversity_with_MHWs$bray_dissimilarity_turnover, na.rm = T)) +
  geom_spline(nknots = 15, color = "gray28", alpha = 0.7, linetype = "longdash") +
  theme_classic()

ggsave(bray_turnover_cum_mean_int_scaled, path = here::here("figures","beta_diversity"), filename = "bray_turnover_cum_mean_int_scaled.jpg", width = 10, height = 4)


###########################
###### Heat Wave Length
###########################    

#anomDays versus richness percent change

delta_richness_anomaly_days <- ggplot(survey_CTI_temporal_diversity_with_MHWs, aes(x = anomDays, y = richness_percent_change)) +
  geom_point(alpha = 0.5, aes(color = mhwYesNo)) +
  geom_hline(yintercept = 0) +
  geom_text(data = survey_CTI_temporal_diversity_with_MHWs[anomDays > 100 | abs(richness_percent_change) > 0.5,], aes(label=ref_year),hjust="inward", vjust=2, size = 2) +
  labs(x = "Anomaly Days", y = "Percent Change Richness") +
  geom_spline(nknots = 15, color = "gray28", alpha = 0.7, linetype = "longdash") +
  theme_classic()

ggsave(delta_richness_anomaly_days, path = here::here("figures","beta_diversity"), filename = "delta_richness_anomaly_days.jpg", width = 10, height = 4)


#anomDays versus dissimilarity

#jaccard_turnover_anomaly_days <- ggplot(survey_CTI_temporal_diversity_with_MHWs, aes(x = anomDays, y = jaccard_dissimilarity_turnover)) +
#  geom_point(alpha = 0.5, aes(color = mhwYesNo)) +
#  labs(x = "Anomaly Days", y = "Jaccard Dissimilarity Turnover Component") +
#  geom_text(data = survey_CTI_temporal_diversity_with_MHWs[anomDays > 100 | jaccard_dissimilarity_turnover > 0.4 | jaccard_dissimilarity_turnover < 0.05,], aes(label=ref_year),hjust="inward", vjust=2, size = 2) +
#  #   geom_hline(yintercept = mean(survey_CTI_temporal_diversity_with_MHWs$jaccard_dissimilarity_turnover, na.rm = T)) +
#  geom_spline(nknots = 15, color = "gray28", alpha = 0.7, linetype = "longdash") +
#  theme_classic()
#
#ggsave(jaccard_turnover_anomaly_days, path = here::here("figures","beta_diversity"), filename = "jaccard_turnover_anomaly_days.jpg", width = 10, height = 4)

#unscaled
bray_turnover_anomaly_days <- ggplot(survey_CTI_temporal_diversity_with_MHWs, aes(x = anomDays, y = bray_dissimilarity_turnover)) +
  geom_point(alpha = 0.5, aes(color = mhwYesNo)) +
  labs(x = "Anomaly Days", y = "Bray Dissimilarity Turnover Component") +
  geom_text(data = survey_CTI_temporal_diversity_with_MHWs[anomDays > 100 | bray_dissimilarity_turnover > 0.4,], aes(label=ref_year),hjust="inward", vjust=2, size = 2) +
  #   geom_hline(yintercept = mean(survey_CTI_temporal_diversity_with_MHWs$bray_dissimilarity_turnover, na.rm = T)) +
  geom_spline(nknots = 15, color = "gray28", alpha = 0.7, linetype = "longdash") +
  theme_classic()

ggsave(bray_turnover_anomaly_days, path = here::here("figures","beta_diversity"), filename = "bray_turnover_anomaly_days.jpg", width = 10, height = 4)

#scaled
bray_turnover_anomaly_days_scaled <- ggplot(survey_CTI_temporal_diversity_with_MHWs, aes(x = anomDays, y = bray_dissimilarity_turnover_scaled_by_region)) +
  geom_point(alpha = 0.5, aes(color = mhwYesNo)) +
  labs(x = "Anomaly Days", y = "Bray Dissimilarity Turnover Component\nScaled within Region") +
  geom_text(data = survey_CTI_temporal_diversity_with_MHWs[anomDays > 100 | bray_dissimilarity_turnover_scaled_by_region > 2 | bray_dissimilarity_turnover_scaled_by_region < -1.8,], aes(label=ref_year),hjust="inward", vjust=2, size = 2) +
  #   geom_hline(yintercept = mean(survey_CTI_temporal_diversity_with_MHWs$bray_dissimilarity_turnover, na.rm = T)) +
  geom_spline(nknots = 15, color = "gray28", alpha = 0.7, linetype = "longdash") +
  theme_classic()

ggsave(bray_turnover_anomaly_days_scaled, path = here::here("figures","beta_diversity"), filename = "bray_turnover_anomaly_days_scaled.jpg", width = 10, height = 4)



###########################
###### Heat Wave Severity
###########################    

#anomSev versus percent change richness
delta_richness_severity <- ggplot(survey_CTI_temporal_diversity_with_MHWs, aes(x = anomSev, y = richness_percent_change)) +
  geom_point(alpha = 0.5, aes(color = mhwYesNo)) +
  geom_hline(yintercept = 0) +
  geom_text(data = survey_CTI_temporal_diversity_with_MHWs[anomSev > 85 | abs(richness_percent_change) > 0.5,], aes(label=ref_year),hjust="inward", vjust=2, size = 2) +
  labs(x = "Heat Wave Severity", y = "Percent Change Richness") +
  #   geom_hline(yintercept = mean(survey_CTI_temporal_diversity_with_MHWs$jaccard_dissimilarity_turnover, na.rm = T)) +
  geom_spline(nknots = 15, color = "gray28", alpha = 0.7, linetype = "longdash") +
  theme_classic()

ggsave(delta_richness_severity, path = here::here("figures","beta_diversity"), filename = "delta_richness_severity.jpg", width = 10, height = 4)


#anomSev versus dissimilarity
#jaccard_turnover_severity <- ggplot(survey_CTI_temporal_diversity_with_MHWs, aes(x = anomSev, y = jaccard_dissimilarity_turnover)) +
#  geom_point(alpha = 0.5, aes(color = mhwYesNo)) +
#  geom_text(data = survey_CTI_temporal_diversity_with_MHWs[anomSev > 85 | jaccard_dissimilarity_turnover > 0.4 | jaccard_dissimilarity_turnover < 0.05,], aes(label=ref_year),hjust="inward", vjust=2, size = 2) +
#  labs(x = "Heat Wave Severity", y = "Jaccard Dissimilarity Turnover Component") +
#  #   geom_hline(yintercept = mean(survey_CTI_temporal_diversity_with_MHWs$jaccard_dissimilarity_turnover, na.rm = T)) +
#  geom_spline(nknots = 15, color = "gray28", alpha = 0.7, linetype = "longdash") +
#  theme_classic()
#
#ggsave(jaccard_turnover_severity, path = here::here("figures","beta_diversity"), filename = "jaccard_turnover_severity.jpg", width = 10, height = 4)

#unscaled
bray_turnover_severity <- ggplot(survey_CTI_temporal_diversity_with_MHWs, aes(x = anomSev, y = bray_dissimilarity_turnover)) +
  geom_point(alpha = 0.5, aes(color = mhwYesNo)) +
  geom_text(data = survey_CTI_temporal_diversity_with_MHWs[anomSev > 85 | bray_dissimilarity_turnover > 0.4,], aes(label=ref_year),hjust="inward", vjust=2, size = 2) +
  labs(x = "Heat Wave Severity", y = "Bray Dissimilarity Turnover Component") +
  #   geom_hline(yintercept = mean(survey_CTI_temporal_diversity_with_MHWs$bray_dissimilarity_turnover, na.rm = T)) +
  geom_spline(nknots = 15, color = "gray28", alpha = 0.7, linetype = "longdash") +
  theme_classic()

ggsave(bray_turnover_severity, path = here::here("figures","beta_diversity"), filename = "bray_turnover_severity.jpg", width = 10, height = 4)

#scaled
bray_turnover_severity_scaled <- ggplot(survey_CTI_temporal_diversity_with_MHWs, aes(x = anomSev, y = bray_dissimilarity_turnover_scaled_by_region)) +
  geom_point(alpha = 0.5, aes(color = mhwYesNo)) +
  geom_text(data = survey_CTI_temporal_diversity_with_MHWs[anomSev > 85 | bray_dissimilarity_turnover_scaled_by_region > 0.4,], aes(label=ref_year),hjust="inward", vjust=2, size = 2) +
  labs(x = "Heat Wave Severity", y = "Bray Dissimilarity Turnover Component\nScaled within Region") +
  #   geom_hline(yintercept = mean(survey_CTI_temporal_diversity_with_MHWs$bray_dissimilarity_turnover, na.rm = T)) +
  geom_spline(nknots = 15, color = "gray28", alpha = 0.7, linetype = "longdash") +
  theme_classic()

ggsave(bray_turnover_severity_scaled, path = here::here("figures","beta_diversity"), filename = "bray_turnover_severity_scaled.jpg", width = 10, height = 4)






###############
### TOTAL DISSIMILARITY
###############


#############
##Heat wave versus no heatwave
#############


##compare yes or no heatwave with temporal diversity metric 
##box plot
#jaccard_total_boxplot_MHWs <- ggplot(survey_CTI_temporal_diversity_with_MHWs[complete.cases(mhwYesNo),], aes(x = mhwYesNo, y = jaccard_dissimilarity_total)) +
#  geom_boxplot() +
#  labs(x = "MHW?", y = "Jaccard Dissimilarity Total") +
#  annotate("text",
#           x = 1:length(table(survey_CTI_temporal_diversity_with_MHWs$mhwYesNo)),
#           y = aggregate(jaccard_dissimilarity_total ~ mhwYesNo, survey_CTI_temporal_diversity_with_MHWs, median)[ , 2],
#           label = table(survey_CTI_temporal_diversity_with_MHWs$mhwYesNo),
#           col = "red",
#           vjust = - 1) +
#  theme_classic()
#
#ggsave(jaccard_total_boxplot_MHWs, path = here::here("figures","beta_diversity"), filename = "jaccard_total_boxplot_MHWs.jpg", width = 10, height = 4)
#
#bray_total_boxplot_MHWs <- ggplot(survey_CTI_temporal_diversity_with_MHWs[complete.cases(mhwYesNo),], aes(x = mhwYesNo, y = bray_dissimilarity_total)) +
#  geom_boxplot() +
#  labs(x = "MHW?", y = "Bray Dissimilarity Total") +
#  annotate("text",
#           x = 1:length(table(survey_CTI_temporal_diversity_with_MHWs$mhwYesNo)),
#           y = aggregate(bray_dissimilarity_total ~ mhwYesNo, survey_CTI_temporal_diversity_with_MHWs, median)[ , 2],
#           label = table(survey_CTI_temporal_diversity_with_MHWs$mhwYesNo),
#           col = "red",
#           vjust = - 1) +
#  theme_classic()
#
#ggsave(bray_total_boxplot_MHWs, path = here::here("figures","beta_diversity"), filename = "bray_total_boxplot_MHWs.jpg", width = 10, height = 4)
#
##box plot by survey
#jaccard_total_boxplot_MHWs_survey <- ggplot(survey_CTI_temporal_diversity_with_MHWs[complete.cases(mhwYesNo),], aes(x = mhwYesNo, y = jaccard_dissimilarity_total)) +
#  geom_boxplot() +
#  labs(x = "MHW?", y = "Jaccard Dissimilarity Total") +
#  facet_wrap(~region) +
#  theme_classic()
#
#ggsave(jaccard_total_boxplot_MHWs_survey, path = here::here("figures","beta_diversity"), filename = "jaccard_total_boxplot_MHWs_survey.jpg", width = 10, height = 4)
#
#
#bray_total_boxplot_MHWs_survey <- ggplot(survey_CTI_temporal_diversity_with_MHWs[complete.cases(mhwYesNo),], aes(x = mhwYesNo, y = bray_dissimilarity_total)) +
#  geom_boxplot() +
#  labs(x = "MHW?", y = "Bray Dissimilarity Total") +
#  facet_wrap(~region) +
#  theme_classic()
#
#ggsave(bray_total_boxplot_MHWs_survey, path = here::here("figures","beta_diversity"), filename = "bray_total_boxplot_MHWs_survey.jpg", width = 10, height = 10)
#
#
#delta_richness_boxplot_MHWs <- ggplot(survey_CTI_temporal_diversity_with_MHWs[complete.cases(mhwYesNo),], aes(x = mhwYesNo, y = delta_richness)) +
#  geom_boxplot() +
#  labs(x = "MHW?", y = "Delta Richness") +
#  facet_wrap(~region) +
#  theme_classic()
#
#ggsave(delta_richness_boxplot_MHWs, path = here::here("figures","beta_diversity"), filename = "delta_richness_boxplot_MHWs_survey.jpg", width = 10, height = 4)
#
#
############################
####### Heat Wave Cumulative Mean Intensity
############################  
#
##anomIntC (Cumulative Mean Intensity) versus dissimilarity
##jaccard_total_cum_mean_int <- ggplot(survey_CTI_temporal_diversity_with_MHWs, aes(x = anomIntC, y = jaccard_dissimilarity_total)) +
##  geom_point(alpha = 0.5, aes(color = mhwYesNo)) +
#  labs(x = "Cumulative Mean Intensity", y = "Jaccard Dissimilarity Total") +
#  geom_text(data = survey_CTI_temporal_diversity_with_MHWs[anomIntC > 1 | abs(richness_percent_change) > 0.5,], aes(label=ref_year),hjust="inward", vjust=2, size = 2) +
#  #     geom_hline(yintercept = mean(survey_CTI_temporal_diversity_with_MHWs$jaccard_dissimilarity_total, na.rm = T)) +
#  theme_classic()
#
#ggsave(jaccard_total_cum_mean_int, path = here::here("figures","beta_diversity"), filename = "jaccard_total_cum_mean_int.jpg", width = 10, height = 4)
#
#
#bray_total_cum_mean_int <- ggplot(survey_CTI_temporal_diversity_with_MHWs, aes(x = anomIntC, y = bray_dissimilarity_total)) +
#  geom_point(alpha = 0.5, aes(color = mhwYesNo)) +
#  labs(x = "Cumulative Mean Intensity", y = "Bray Dissimilarity Total") +
#  geom_text(data = survey_CTI_temporal_diversity_with_MHWs[anomIntC > 1 | abs(richness_percent_change) > 0.5,], aes(label=ref_year),hjust="inward", vjust=2, size = 2) +
#  #     geom_hline(yintercept = mean(survey_CTI_temporal_diversity_with_MHWs$bray_dissimilarity_total, na.rm = T)) +
#  theme_classic()
#
#ggsave(bray_total_cum_mean_int, path = here::here("figures","beta_diversity"), filename = "bray_total_cum_mean_int.jpg", width = 10, height = 4)


###########################
###### Heat Wave Length
###########################    

#anomDays versus dissimilarity
#jaccard_total_anomaly_days <- ggplot(survey_CTI_temporal_diversity_with_MHWs, aes(x = anomDays, y = jaccard_dissimilarity_total)) +
#  geom_point(alpha = 0.5, aes(color = mhwYesNo)) +
#  labs(x = "Anomaly Days", y = "Jaccard Dissimilarity Total") +
#  geom_text(data = survey_CTI_temporal_diversity_with_MHWs[anomDays > 100 | abs(richness_percent_change) > 0.5,], aes(label=ref_year),hjust="inward", vjust=2, size = 2) +
#  #   geom_hline(yintercept = mean(survey_CTI_temporal_diversity_with_MHWs$jaccard_dissimilarity_total, na.rm = T)) +
#  theme_classic()
#
#ggsave(jaccard_total_anomaly_days, path = here::here("figures","beta_diversity"), filename = "jaccard_total_anomaly_days.jpg", width = 10, height = 4)
#
#
#bray_total_anomaly_days <- ggplot(survey_CTI_temporal_diversity_with_MHWs, aes(x = anomDays, y = bray_dissimilarity_total)) +
#  geom_point(alpha = 0.5, aes(color = mhwYesNo)) +
#  labs(x = "Anomaly Days", y = "Bray Dissimilarity Total") +
#  geom_text(data = survey_CTI_temporal_diversity_with_MHWs[anomDays > 100 | abs(richness_percent_change) > 0.5,], aes(label=ref_year),hjust="inward", vjust=2, size = 2) +
#  #   geom_hline(yintercept = mean(survey_CTI_temporal_diversity_with_MHWs$bray_dissimilarity_total, na.rm = T)) +
#  theme_classic()
#
#ggsave(bray_total_anomaly_days, path = here::here("figures","beta_diversity"), filename = "bray_total_anomaly_days.jpg", width = 10, height = 4)


###########################
###### Heat Wave Severity
###########################    

##anomSev versus dissimilarity
#jaccard_total_severity <- ggplot(survey_CTI_temporal_diversity_with_MHWs, aes(x = anomSev, y = jaccard_dissimilarity_total)) +
#  geom_point(alpha = 0.5, aes(color = mhwYesNo)) +
#  geom_text(data = survey_CTI_temporal_diversity_with_MHWs[anomSev > 85 | abs(richness_percent_change) > 0.5,], aes(label=ref_year),hjust="inward", vjust=2, size = 2) +
#  labs(x = "Heat Wave Severity", y = "Jaccard Dissimilarity Total") +
#  #   geom_hline(yintercept = mean(survey_CTI_temporal_diversity_with_MHWs$jaccard_dissimilarity_total, na.rm = T)) +
#  theme_classic()
#
#ggsave(jaccard_total_severity, path = here::here("figures","beta_diversity"), filename = "jaccard_total_severity.jpg", width = 10, height = 4)
#
#
#bray_total_severity <- ggplot(survey_CTI_temporal_diversity_with_MHWs, aes(x = anomSev, y = bray_dissimilarity_total)) +
#  geom_point(alpha = 0.5, aes(color = mhwYesNo)) +
#  geom_text(data = survey_CTI_temporal_diversity_with_MHWs[anomSev > 85 | abs(richness_percent_change) > 0.5,], aes(label=ref_year),hjust="inward", vjust=2, size = 2) +
#  labs(x = "Heat Wave Severity", y = "Bray Dissimilarity Total") +
#  #   geom_hline(yintercept = mean(survey_CTI_temporal_diversity_with_MHWs$bray_dissimilarity_total, na.rm = T)) +
#  theme_classic()
#
#ggsave(bray_total_severity, path = here::here("figures","beta_diversity"), filename = "bray_total_severity.jpg", width = 10, height = 4)

#######################
#Diverging Bars
#######################
#Anomaly Days
#######################
#sort by anomaly days

setkey(survey_CTI_temporal_diversity_with_MHWs, anomDays)
#make a factor to retain in plot
survey_CTI_temporal_diversity_with_MHWs[, ref_year := as.factor(ref_year)]

#color by increase or decrease in richness
survey_CTI_temporal_diversity_with_MHWs[,richness_direction := as.factor(ifelse(richness_percent_change > 0, "Increase",
                                                                                ifelse(richness_percent_change < 0, "Decrease","No Change")))]

#plot
anomalydays_divbar <- ggplot(survey_CTI_temporal_diversity_with_MHWs[complete.cases(survey_CTI_temporal_diversity_with_MHWs[,richness_percent_change])], aes(x=reorder(ref_year,anomDays), y=anomDays)) + 
  geom_bar(stat='identity',fill = "black")  +
  labs(x = "Reference Year-Region", y = "Anomaly Days") + 
  coord_flip() +
  theme_classic() +
  theme(axis.ticks.y = element_blank())


################
#% change Richness
#################

#plot
richness_divbar <- ggplot(survey_CTI_temporal_diversity_with_MHWs[complete.cases(survey_CTI_temporal_diversity_with_MHWs[,richness_percent_change])], aes(x=reorder(ref_year,anomDays), y=richness_percent_change, label = richness_direction)) + 
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
bray_dissim_divbar <- ggplot(survey_CTI_temporal_diversity_with_MHWs[complete.cases(survey_CTI_temporal_diversity_with_MHWs[,richness_percent_change])], aes(x=reorder(ref_year,anomDays), y=bray_dissimilarity_turnover)) + 
  geom_bar(stat='identity', fill = "black")  +
  labs(x = "Reference Year-Region", y = "Bray Curtis Turnover Dissimilarity\nYear t versus t-1") + 
  coord_flip() +
  ylim(0,1) +
  theme_classic() +
  theme(axis.ticks.y = element_blank())

#scaled
#plot
bray_dissim_divbar_scaled <- ggplot(survey_CTI_temporal_diversity_with_MHWs[complete.cases(survey_CTI_temporal_diversity_with_MHWs[,richness_percent_change])], aes(x=reorder(ref_year,anomDays), y=bray_dissimilarity_turnover_scaled_by_region)) + 
  geom_bar(stat='identity', fill = "black")  +
  labs(x = "Reference Year-Region", y = "Bray Curtis Turnover Dissimilarity\nYear t versus t-1, Scaled by Region") + 
  coord_flip() +
  ylim(0,1) +
  theme_classic() +
  theme(axis.ticks.y = element_blank())

################
#Jaccard diversity
#################

#plot


#jaccard_dissim_divbar <- ggplot(survey_CTI_temporal_diversity_with_MHWs[complete.cases(survey_CTI_temporal_diversity_with_MHWs[,richness_percent_change])], aes(x=reorder(ref_year,anomDays), y=jaccard_dissimilarity_turnover, label = richness_direction)) + 
#  geom_bar(stat='identity', fill = "black")  +
#  labs(x = "Reference Year-Region", y = "Jaccard Turnover Dissimilarity\nYear t versus t-1") + 
#  coord_flip() +
#  ylim(0,1) +
#  theme_classic() +
#  theme(axis.ticks.y = element_blank())


##############
#merge anomaly days and richness change
##############
##############

#unscaled
diverging_bars <- plot_grid(anomalydays_divbar + theme(legend.position = "none", axis.text.y = element_text(size = 1)),
          richness_divbar + theme(legend.position = "none", axis.text.y = element_blank(), axis.title.y = element_blank()),
          bray_dissim_divbar + theme(legend.position = "none", axis.text.y = element_blank(), axis.title.y = element_blank()),
       #   jaccard_dissim_divbar + theme(legend.position = "none", axis.text.y = element_blank(), axis.title.y = element_blank()),
          nrow = 1, ncol = 3, align = "h")

diverging_bars_legend <- get_legend(richness_divbar)

diverging_bars_wlegend <- plot_grid(diverging_bars_legend, diverging_bars, ncol = 1, rel_heights = c(1,10))

ggsave(diverging_bars_wlegend, path = here::here("figures","beta_diversity"),
       filename = "diverging_bars_wlegend.pdf",height = 10, width = 10, unit = "in")

#scaled
diverging_bars_scaled <- plot_grid(anomalydays_divbar + theme(legend.position = "none", axis.text.y = element_text(size = 1)),
                            richness_divbar + theme(legend.position = "none", axis.text.y = element_blank(), axis.title.y = element_blank()),
                            bray_dissim_divbar_scaled + theme(legend.position = "none", axis.text.y = element_blank(), axis.title.y = element_blank()),
                            #   jaccard_dissim_divbar + theme(legend.position = "none", axis.text.y = element_blank(), axis.title.y = element_blank()),
                            nrow = 1, ncol = 3, align = "h")

diverging_bars_legend_scaled <- get_legend(richness_divbar)

diverging_bars_wlegend_scaled <- plot_grid(diverging_bars_legend, diverging_bars, ncol = 1, rel_heights = c(1,10))

ggsave(diverging_bars_wlegend_scaled, path = here::here("figures","beta_diversity"),
       filename = "diverging_bars_wlegend_scaled.pdf",height = 10, width = 10, unit = "in")


