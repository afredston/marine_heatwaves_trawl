#This code calculates the turnover component of beta diversity using occurrence and biomass data from the 'biomass_time.csv'
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

biomass_time <- fread(here("processed-data","biomass_time.csv")) #for some reason NEUS has zero biomass here, CHECK

#delete any observations not to species
biomass_time <- biomass_time[grepl(" ",biomass_time$accepted_name)]

#survey names
survey_names <- sort(unique(biomass_time$survey))

biomass_time_temporal_beta <- unique(biomass_time[,.(survey,year)])

biomass_time_temporal_beta <- biomass_time_temporal_beta[
  ,jaccard_dissimilarity_turnover := as.numeric()][
  ,bray_dissimilarity_turnover := as.numeric()][
    ,jaccard_dissimilarity_total := as.numeric()][
      ,bray_dissimilarity_total := as.numeric()][
    , delta_richness := as.numeric()][
      ,richness_percent_change := as.numeric()
    ]

#ensure order of data table is correct
setkey(biomass_time_temporal_beta, survey, year)

#cycle through by survey and then year

for (i in 1:length(survey_names)) {
  #subset to a single survey
  biomass_time_survey <- biomass_time[survey == survey_names[i],]
  
  #years
  survey_years <- sort(unique(biomass_time_survey$year))
  
  #cycle through years
  for (j in 1:length(survey_years)) {
    if(j == 1) {
      biomass_time_temporal_beta[survey == survey_names[i] & year == survey_years[i],
                                 c("jaccard_dissimilarity_turnover","bray_dissimilarity_turnover",
                                   "jaccard_dissimilarity_total", "bray_dissimilarity_total",
                                   "delta_richness") := NA]

    } else {
      #subset current year
      biomass_time_survey_year <- biomass_time_survey[year == survey_years[j],]
      
        #all values >0 to 1
        biomass_time_survey_year.occurrence <- biomass_time_survey_year[,pres_abs := ifelse(wtcpue_mean > 0,1,wtcpue_mean)]
        
      #subset previous year
      biomass_time_survey_year_prev <- biomass_time_survey[year == survey_years[j-1],]
      
        #all values >0 to 1
        biomass_time_survey_year_prev.occurrence <- biomass_time_survey_year_prev[,pres_abs := ifelse(wtcpue_mean > 0,1,wtcpue_mean)]
        
      
      #make current year into community matrix for abundance data
      biomass_time_survey_year.w <- dcast(biomass_time_survey_year, year ~ accepted_name, value.var = "wtcpue_mean") 
      rownames(biomass_time_survey_year.w) <- biomass_time_survey_year.w$year #name rows
      biomass_time_survey_year.w[,year := NULL] #delete year column
      
      #make current year into community matrix for occurrence data
      biomass_time_survey_year.occurrence.w <- dcast(biomass_time_survey_year.occurrence, year ~ accepted_name, value.var = "pres_abs") 
      rownames(biomass_time_survey_year.occurrence.w) <- biomass_time_survey_year.occurrence.w$year #name rows
      biomass_time_survey_year.occurrence.w[,year := NULL] #delete year column
      
      #make previous year into community matrix for abundance data
      biomass_time_survey_year_prev.w <- dcast(biomass_time_survey_year_prev, year ~ accepted_name, value.var = "wtcpue_mean")
      rownames(biomass_time_survey_year_prev.w) <- biomass_time_survey_year_prev.w$year #name rows
      biomass_time_survey_year_prev.w[,year := NULL] #delete year column
      
      #make previous year into community matrix for occurrence data
      biomass_time_survey_year_prev.occurrence.w <- dcast(biomass_time_survey_year_prev.occurrence, year ~ accepted_name, value.var = "pres_abs")
      rownames(biomass_time_survey_year_prev.occurrence.w) <- biomass_time_survey_year_prev.occurrence.w$year #name rows
      biomass_time_survey_year_prev.occurrence.w[,year := NULL] #delete year column
      
      
      #calculate temporal change in community composition using beta.temp using abundance data (bray)
      bray_dissimilarity <- beta.pair.abund(rbind(biomass_time_survey_year_prev.w, biomass_time_survey_year.w),  index.family = "bray")
      
      #calculate temporal change in community composition using beta.temp using occurrence data (jaccard)
      jaccard_dissimilarity <- beta.pair(rbind(biomass_time_survey_year_prev.occurrence.w, biomass_time_survey_year.occurrence.w),  index.family = "jaccard")
      
      #richness
      richness <- sum(biomass_time_survey_year[,pres_abs])
      richness_prev <- sum(biomass_time_survey_year_prev[,pres_abs])
      
    #populate data table
      biomass_time_temporal_beta[(survey == survey_names[i] & year == survey_years[j]), "jaccard_dissimilarity_turnover"] <- jaccard_dissimilarity[[1]]
      biomass_time_temporal_beta[(survey == survey_names[i] & year == survey_years[j]), "bray_dissimilarity_turnover"] <- bray_dissimilarity[[1]]
      biomass_time_temporal_beta[(survey == survey_names[i] & year == survey_years[j]), "jaccard_dissimilarity_total"] <- jaccard_dissimilarity[[3]]
      biomass_time_temporal_beta[(survey == survey_names[i] & year == survey_years[j]), "bray_dissimilarity_total"] <- bray_dissimilarity[[3]]
      biomass_time_temporal_beta[(survey == survey_names[i] & year == survey_years[j]), "delta_richness"] <- richness-richness_prev
      biomass_time_temporal_beta[(survey == survey_names[i] & year == survey_years[j]), "richness_percent_change"] <- (richness-richness_prev)/richness_prev
      
      }
  print(paste0(survey_names[i],": ",survey_years[j]))
  }
  
  
}

fwrite(biomass_time_temporal_beta, file = here::here("processed-data","survey_temporal_beta_diversity.csv"))
