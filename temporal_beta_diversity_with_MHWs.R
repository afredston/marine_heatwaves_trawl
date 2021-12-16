#This code explores relationships between turnover, richness, and MHWs
#Contact Zoe Kitchel for questions
########
# load packages
########

library(here)
library(lubridate) # for standardizing date format of MHW data
library(tidyverse)
library(data.table)
library(betapart)

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

#compare yes or no heatwave with temporal diversity metric 
  #box plot
    ggplot(survey_CTI_temporal_diversity_with_MHWs[complete.cases(mhwYesNo),], aes(x = mhwYesNo, y = jaccard_dissimilarity)) +
      geom_boxplot() +
      annotate("text",
               x = 1:length(table(survey_CTI_temporal_diversity_with_MHWs$mhwYesNo)),
               y = aggregate(jaccard_dissimilarity ~ mhwYesNo, survey_CTI_temporal_diversity_with_MHWs, median)[ , 2],
               label = table(survey_CTI_temporal_diversity_with_MHWs$mhwYesNo),
               col = "red",
               vjust = - 1) +
      theme_classic()
    
    ggplot(survey_CTI_temporal_diversity_with_MHWs[complete.cases(mhwYesNo),], aes(x = mhwYesNo, y = bray_dissimilarity)) +
      geom_boxplot() +
      annotate("text",
               x = 1:length(table(survey_CTI_temporal_diversity_with_MHWs$mhwYesNo)),
               y = aggregate(bray_dissimilarity ~ mhwYesNo, survey_CTI_temporal_diversity_with_MHWs, median)[ , 2],
               label = table(survey_CTI_temporal_diversity_with_MHWs$mhwYesNo),
               col = "red",
               vjust = - 1) +
      theme_classic()
    
    ggplot(survey_CTI_temporal_diversity_with_MHWs[complete.cases(mhwYesNo),], aes(x = mhwYesNo, y = delta_richness)) +
      geom_boxplot() +
      annotate("text",
               x = 1:length(table(survey_CTI_temporal_diversity_with_MHWs$mhwYesNo)),
               y = aggregate(delta_richness ~ mhwYesNo, survey_CTI_temporal_diversity_with_MHWs, median)[ , 2],
               label = table(survey_CTI_temporal_diversity_with_MHWs$mhwYesNo),
               col = "red",
               vjust = - 1) +
      theme_classic()
    
    #box plot by region
    ggplot(survey_CTI_temporal_diversity_with_MHWs[complete.cases(mhwYesNo),], aes(x = mhwYesNo, y = jaccard_dissimilarity)) +
      geom_boxplot() +
      facet_wrap(~region) +
      theme_classic()
    
    ggplot(survey_CTI_temporal_diversity_with_MHWs[complete.cases(mhwYesNo),], aes(x = mhwYesNo, y = bray_dissimilarity)) +
      geom_boxplot() +
      facet_wrap(~region) +
      theme_classic()
    
    ggplot(survey_CTI_temporal_diversity_with_MHWs[complete.cases(mhwYesNo),], aes(x = mhwYesNo, y = delta_richness)) +
      geom_boxplot() +
      facet_wrap(~region) +
      theme_classic()
    
   ###########################
   ###### Heat Wave Cumulative Mean Intensity
   ###########################  
    
      #anomIntC (Cumulative Mean Intensity) versus percent change in richness
    ggplot(survey_CTI_temporal_diversity_with_MHWs[mhwYesNo == "yes",], aes(x = anomIntC, y = richness_percent_change)) +
      geom_point() +
      theme_classic()
    
       #anomIntC (Cumulative Mean Intensity) versus dissimilarity
    ggplot(survey_CTI_temporal_diversity_with_MHWs[mhwYesNo == "yes",], aes(x = anomIntC, y = jaccard_dissimilarity)) +
      geom_point() +
 #     geom_hline(yintercept = mean(survey_CTI_temporal_diversity_with_MHWs$jaccard_dissimilarity, na.rm = T)) +
      theme_classic()
    
    ggplot(survey_CTI_temporal_diversity_with_MHWs[mhwYesNo == "yes",], aes(x = anomIntC, y = bray_dissimilarity)) +
      geom_point() +
 #     geom_hline(yintercept = mean(survey_CTI_temporal_diversity_with_MHWs$bray_dissimilarity, na.rm = T)) +
      theme_classic()
    
  ###########################
  ###### Heat Wave Length
  ###########################    
    
    #anomDays versus richness percent change
    ggplot(survey_CTI_temporal_diversity_with_MHWs[mhwYesNo == "yes",], aes(x = anomDays, y = richness_percent_change)) +
      geom_point() +
      theme_classic()
    
    #anomDays versus dissimilarity
    ggplot(survey_CTI_temporal_diversity_with_MHWs[mhwYesNo == "yes",], aes(x = anomDays, y = jaccard_dissimilarity)) +
      geom_point() +
   #   geom_hline(yintercept = mean(survey_CTI_temporal_diversity_with_MHWs$jaccard_dissimilarity, na.rm = T)) +
      theme_classic()
    
    ggplot(survey_CTI_temporal_diversity_with_MHWs[mhwYesNo == "yes",], aes(x = anomDays, y = bray_dissimilarity)) +
      geom_point() +
   #   geom_hline(yintercept = mean(survey_CTI_temporal_diversity_with_MHWs$bray_dissimilarity, na.rm = T)) +
      theme_classic()
    
  ###########################
  ###### Heat Wave Severity
  ###########################    
    
    #anomSev versus percent change richness
    ggplot(survey_CTI_temporal_diversity_with_MHWs[mhwYesNo == "yes",], aes(x = anomSev, y = richness_percent_change)) +
      geom_point() +
      #   geom_hline(yintercept = mean(survey_CTI_temporal_diversity_with_MHWs$jaccard_dissimilarity, na.rm = T)) +
      theme_classic()
    
    #anomSev versus dissimilarity
    ggplot(survey_CTI_temporal_diversity_with_MHWs[mhwYesNo == "yes",], aes(x = anomSev, y = jaccard_dissimilarity)) +
      geom_point() +
      #   geom_hline(yintercept = mean(survey_CTI_temporal_diversity_with_MHWs$jaccard_dissimilarity, na.rm = T)) +
      theme_classic()
    
    ggplot(survey_CTI_temporal_diversity_with_MHWs[mhwYesNo == "yes",], aes(x = anomSev, y = bray_dissimilarity)) +
      geom_point() +
      geom_label(aes(label = ref_year), size = 2, hjust = 1) +
      #   geom_hline(yintercept = mean(survey_CTI_temporal_diversity_with_MHWs$bray_dissimilarity, na.rm = T)) +
      theme_classic()
    