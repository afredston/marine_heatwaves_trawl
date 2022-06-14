#This code calculates the turnover component of beta diversity using both occurrence and 
#biomass data from the 'biomass_time.csv'
#It can output a table with survey, year, jaccard_dissimilarity_turnover,bray_dissimilarity_turnover,
#jaccard_dissimilarity_nestedness, bray_dissimilarity_nestedness,
#jaccard_dissimilarity_total, bray_dissimilarity_total,and  delta_richness  between the previous year and given year
#Contact Zoë Kitchel for questions
########
# load packages
########

library(here)
library(lubridate) # for standardizing date format of MHW data
library(tidyverse)
library(data.table)
library(betapart)

########
# load data (run most recently on June 2, 2022 by Zoë)
########
#bring in biomass_time data (prepped on annotate)
biomass_time <- fread(here("processed-data","biomass_time.csv"))

#delete any observations not identified to species
biomass_time <- biomass_time[grepl(" ",biomass_time$accepted_name)][,#this deletes any accepted_name values without a space, and therefore only a genus with no species 
         ref_yr := paste0(survey,"-",startmonth,"-",year)] #at the same time, add ref_yr code

#survey names
survey_names <- sort(unique(biomass_time$survey))

biomass_time_temporal_beta <- unique(biomass_time[,.(survey,year,ref_yr)])

biomass_time_temporal_beta <- biomass_time_temporal_beta[
  ,jaccard_dissimilarity_turnover := as.numeric()][
    ,bray_dissimilarity_turnover := as.numeric()][
      ,jaccard_dissimilarity_nestedness := as.numeric()][
        ,bray_dissimilarity_nestedness := as.numeric()][
      ,jaccard_dissimilarity_total := as.numeric()][
        ,bray_dissimilarity_total := as.numeric()][
          , jaccard_dissimilarity_total_compare_first_year := as.numeric()][
            , bray_dissimilarity_total_compare_first_year := as.numeric()][
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
  survey_years <- sort(unique(biomass_time_survey$year)) #develop a list of years
  
  #cycle through years
  for (j in 1:length(survey_years)) { #for  each year calculate 
    if(j == 1) {
      biomass_time_temporal_beta[survey == survey_names[i] & year == survey_years[i] & ref_yr == ref_yr[i],
                                 c(
                                   "jaccard_dissimilarity_turnover",
                                   "bray_dissimilarity_turnover",
                                   "jaccard_dissimilarity_nestedness",
                                   "bray_dissimilarity_nestedness",
                                   "jaccard_dissimilarity_total",
                                   "jaccard_dissimilarity_total_compare_first_year",
                                   "bray_dissimilarity_total_compare_first_year",
                                   "bray_dissimilarity_total",
                                   "delta_richness","richness_percent_change") := NA]
      
    } else {
      #subset current year
      biomass_time_survey_year <- biomass_time_survey[year == survey_years[j],]
      
      #reclassify all values > 0 --> 1
      biomass_time_survey_year.occurrence <- biomass_time_survey_year[,pres_abs := ifelse(wtcpue_mean > 0,1,wtcpue_mean)]
      
      #subset previous year
      biomass_time_survey_year_prev <- biomass_time_survey[year == survey_years[j-1],]
      
      #subset first year
      biomass_time_survey_year_ONE <- biomass_time_survey[year == survey_years[1],]
      
      #reclassify all values > 0 --> 1
      biomass_time_survey_year_prev.occurrence <- biomass_time_survey_year_prev[,pres_abs := ifelse(wtcpue_mean > 0,1,wtcpue_mean)]
      biomass_time_survey_year_ONE.occurrence <- biomass_time_survey_year_ONE[,pres_abs := ifelse(wtcpue_mean > 0,1,wtcpue_mean)]
      
      #make current year into community matrix for abundance data
      biomass_time_survey_year.w <- dcast(biomass_time_survey_year, year ~ accepted_name, value.var = "wtcpue_mean") 
      rownames(biomass_time_survey_year.w) <- biomass_time_survey_year.w$year #name rows
      biomass_time_survey_year.w[,year := NULL] #delete year column
      
      #make current year into community matrix for occurrence data
      biomass_time_survey_year.occurrence.w <- dcast(biomass_time_survey_year.occurrence, year ~ accepted_name, value.var = "pres_abs") 
      rownames(biomass_time_survey_year.occurrence.w) <- biomass_time_survey_year.occurrence.w$year #name rows
      biomass_time_survey_year.occurrence.w[,year := NULL] #delete year column
      
      #make first year into community matrix for occurrence data
      biomass_time_survey_year_ONE.occurrence.w <- dcast(biomass_time_survey_year_ONE.occurrence, year ~ accepted_name, value.var = "pres_abs") 
      rownames(biomass_time_survey_year_ONE.occurrence.w) <- biomass_time_survey_year_ONE.occurrence.w$year #name rows
      biomass_time_survey_year_ONE.occurrence.w[,year := NULL] #delete year column
      
      #make first year into community matrix for biomass data
      biomass_time_survey_year_ONE.w <- dcast(biomass_time_survey_year_ONE, year ~ accepted_name, value.var = "pres_abs") 
      rownames(biomass_time_survey_year_ONE.w) <- biomass_time_survey_year_ONE.w$year #name rows
      biomass_time_survey_year_ONE.w[,year := NULL] #delete year column
      
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
      
      #calculate temporal change in community composition using beta.pair using occurrence data (jaccard)
      jaccard_dissimilarity <- beta.pair(rbind(biomass_time_survey_year_prev.occurrence.w, biomass_time_survey_year.occurrence.w),  index.family = "jaccard")

      #calculate temporal change to first year in community composition using beta.pair using occurrence data (jaccard)
      jaccard_dissimilarity.yearone <- beta.pair(rbind(biomass_time_survey_year_ONE.occurrence.w, biomass_time_survey_year.occurrence.w),  index.family = "jaccard")
      
      #calculate temporal change to first year in community composition using beta.pair using occurrence data (bray)
      bray_dissimilarity.yearone <- beta.pair.abund(rbind(biomass_time_survey_year_ONE.w, biomass_time_survey_year.w),  index.family = "bray")
      

      #raw richness
      richness <- sum(biomass_time_survey_year[,pres_abs]) #current year
      richness_prev <- sum(biomass_time_survey_year_prev[,pres_abs]) #previous year
      
      #populate data table
      biomass_time_temporal_beta[(survey == survey_names[i] & year == survey_years[j]), "jaccard_dissimilarity_turnover"] <- jaccard_dissimilarity[[1]]
      biomass_time_temporal_beta[(survey == survey_names[i] & year == survey_years[j]), "bray_dissimilarity_turnover"] <- bray_dissimilarity[[1]]
      biomass_time_temporal_beta[(survey == survey_names[i] & year == survey_years[j]), "jaccard_dissimilarity_nestedness"] <- jaccard_dissimilarity[[2]]
      biomass_time_temporal_beta[(survey == survey_names[i] & year == survey_years[j]), "bray_dissimilarity_nestedness"] <- bray_dissimilarity[[2]]
      biomass_time_temporal_beta[(survey == survey_names[i] & year == survey_years[j]), "jaccard_dissimilarity_total"] <- jaccard_dissimilarity[[3]]
      biomass_time_temporal_beta[(survey == survey_names[i] & year == survey_years[j]), "bray_dissimilarity_total"] <- bray_dissimilarity[[3]]
      biomass_time_temporal_beta[(survey == survey_names[i] & year == survey_years[j]), "jaccard_dissimilarity_total_compare_first_year"] <- jaccard_dissimilarity.yearone[[3]]
      biomass_time_temporal_beta[(survey == survey_names[i] & year == survey_years[j]), "bray_dissimilarity_total_compare_first_year"] <- bray_dissimilarity.yearone[[3]]
      biomass_time_temporal_beta[(survey == survey_names[i] & year == survey_years[j]), "delta_richness"] <- richness-richness_prev
      biomass_time_temporal_beta[(survey == survey_names[i] & year == survey_years[j]), "richness_percent_change"] <- (richness-richness_prev)/richness_prev
      
    }
    print(paste0(survey_names[i],": ",survey_years[j]))
  }
  
  
}

fwrite(biomass_time_temporal_beta, file = here::here("processed-data","survey_temporal_beta_diversity.csv"))

#helpful plots of nestedness versus turnover versus total dissimilarity

#wide form to long form 
biomass_time_temporal_beta.l <- melt(biomass_time_temporal_beta, id.vars = 1:3, measure.vars = 4:13,
                                     variable.name = "beta_diversity_metric")

#reorder levels
#key column
biomass_time_temporal_beta.l[grepl(pattern = "jaccard", x = beta_diversity_metric) == T,type := "jaccard"][
  grepl(pattern = "bray", x = beta_diversity_metric) == T,type := "bray"][
    grepl(pattern = "richness", x = beta_diversity_metric) == T,type := "richness"]

biomass_time_temporal_beta.l[,beta_diversity_metric := factor(beta_diversity_metric, levels = 
                                                                c("jaccard_dissimilarity_turnover","jaccard_dissimilarity_nestedness","jaccard_dissimilarity_total","jaccard_dissimilarity_total_compare_first_year",
                                                                  "bray_dissimilarity_turnover","bray_dissimilarity_nestedness" , "bray_dissimilarity_total",    "bray_dissimilarity_total_compare_first_year" ,   
                                                                  "delta_richness","richness_percent_change"))]

#plot metrics over time
beta_diversity_metric_year <- ggplot(data = biomass_time_temporal_beta.l[type != "richness",]) +
  geom_line(aes(x = as.numeric(year), y = value, color = beta_diversity_metric), size = 0.5) +
  scale_color_manual(values = c("#0825DC","#A6AFEA","#098EDB","black","#B50E0E","#EF8E8E","#B50E62","black")) +
  facet_wrap(~survey+type, scales = "free") +
  theme_classic()

richness_metric_year <- ggplot(data = biomass_time_temporal_beta.l[type == "richness",]) +
  geom_line(aes(x = as.numeric(year), y = value)) +
  facet_wrap(~survey, scales = "free") +
  theme_classic()

ggsave(beta_diversity_metric_year, file = "beta_diversity_metric_year.jpg", path = "figures/beta_diversity", width = 15, height = 9, unit = "in")
ggsave(richness_metric_year, file = "richness_metric_year.jpg", path = "figures/beta_diversity", width = 10, height = 4, unit = "in")

