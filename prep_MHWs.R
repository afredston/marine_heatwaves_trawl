# PLEASE CHECK EACH DF MANUALLY WHEN NEW REGIONS ARE INCORPORATED to be sure the lag calculations are working correctly and the region names were harmonized!

# this script does two things:
# reshapes the marine heatwave anomaly data and matches it with survey month*years
# calculates aggregated biomass and community composition metrics for the survey data 

########
# load packages
########

library(here)
library(lubridate)
library(tidyverse)
library(magrittr)
library(data.table)
########
# load data
########
# load FISHGLOB trawl data
cpue <- read_csv(here("processed-data","biomass_time.csv"))%>%
  filter(year < 2020)

sat_sst_raw <- read.delim(here("raw-data","MHW_95P_surveys_satellite_surf.csv"), sep=";") 

sat_sst_raw_nod <- read.delim(here("raw-data","MHW_95P_surveys_satellite_surf_no_detrend.csv"), sep=";") 

# reshape MHW data, and fix some inconsistencies in region names (match MHWs to FISHGLOB)
sat_sst <- sat_sst_raw %>% 
  rename("dateRaw"=X) %>% 
  pivot_longer(cols=2:ncol(sat_sst_raw), names_to="survey", values_to="anom") %>% 
  mutate(survey = gsub('_','-',survey),
         survey = toupper(survey),
         survey = recode(survey, 
                         "BALTIC-SEA" = "BITS",
                         "BRITISH-COLUMBIA" = "DFO-QCS", 
                         "EASTERN-BERING-SEA" = "EBS",
                         "GULF-OF-MEXICO" = "GMEX",
                         "GULF-OF-ALASKA" = "GOA",
                         "NOR-BTS" = "Nor-BTS",
                         "SCOTIAN-SHELF" = "SCS",
                         "SOUTHEAST" = "SEUS",
                         "WEST-COAST" = "WCANN"))

sat_sst_nod <- sat_sst_raw_nod %>% 
  rename("dateRaw"=X) %>% 
  pivot_longer(cols=2:ncol(sat_sst_raw_nod), names_to="survey", values_to="anom") %>% 
  mutate(survey = gsub('_','-',survey),
         survey = toupper(survey),
         survey = recode(survey, 
                         "BALTIC-SEA" = "BITS",
                         "BRITISH-COLUMBIA" = "DFO-QCS", 
                         "EASTERN-BERING-SEA" = "EBS",
                         "GULF-OF-MEXICO" = "GMEX",
                         "GULF-OF-ALASKA" = "GOA",
                         "NOR-BTS" = "Nor-BTS",
                         "SCOTIAN-SHELF" = "SCS",
                         "SOUTHEAST" = "SEUS",
                         "WEST-COAST" = "WCANN"))

# soda_sst_raw <- read.delim(here("raw-data","MHW_95P_surveys_soda_surf.csv"), sep=";")
# soda_sst <- soda_sst_raw %>% 
#   rename("dateRaw"=X) %>% 
#   pivot_longer(cols=2:ncol(soda_sst_raw), names_to="survey", values_to="anom")%>% 
#   filter(!survey=="s_georg") %>% 
#   mutate(survey = toupper(survey),
#          survey = gsub('_','-',survey),
#          survey = recode(survey, "AL" = "AI","NOR-BTS" = "Nor-BTS", "ROCALL" = "ROCKALL"))
# 
# soda_sbt_raw <- read.delim(here("raw-data","MHW_95P_surveys_soda_btm.csv"), sep=";")
# soda_sbt <- soda_sbt_raw %>% 
#   rename("dateRaw"=X) %>% 
#   pivot_longer(cols=2:ncol(soda_sbt_raw), names_to="survey", values_to="anom")%>% 
#   filter(!survey=="s_georg") %>% 
#   mutate(survey = toupper(survey),
#          survey = gsub('_','-',survey),
#          survey = recode(survey, "AL" = "AI","NOR-BTS" = "Nor-BTS", "ROCALL" = "ROCKALL"))

maxyr <- max(cpue$year)

cti <- read_csv(here("raw-data/6855203","mxesr.csv")) %>%  # https://figshare.com/articles/dataset/Species_Temperature_Index_and_thermal_range_information_forNorth_Pacific_and_North_Atlantic_plankton_and_bottom_trawl_species/6855203/1
  select(-`...1`) %>% # get rid of an unneeded column and some duplicated rows
  distinct()

########
# match surveys to dates
########

# The goal of this part of code is to match each survey (noting that they start at different times of year in different regions, and don't all happen each year) to MHW data from only the 365 days preceding the survey in that region. H/t @GracoRoza and @KivaOken for this solution

# step 1: get a dataframe of the survey start months
survey_start_times <- cpue %>% 
  mutate(month_year = paste0(startmonth,"-",year)) %>%
  select(survey, year, month_year) %>%
  distinct() %>%
  mutate(ref_yr = paste0(survey,"-",month_year), # get unique survey identifier ("reference year")
         survey_date = dmy(paste0('01-',month_year))# get earliest possible survey start date
  ) 

# step 2: expand this out to all possible months, tracking which reference year they belong to
# get all month*year combinations for each survey and denote which reference year (12-month period custom to each region based on when survey began) each belongs to 
sat_sst_ref_yrs <- expand.grid(month=seq(1, 12, 1), year=seq(1982, maxyr, 1), survey=unique(survey_start_times$survey)) %>% # get a factorial combo of every possible month*year; have to start in 1982 even though we can't use surveys before 1983 because we need to match to env data from 1982
  mutate(survey = as.character(survey),
         survey_month_year = paste0(survey,"-",month,"-",year)) %>% # create unique identifier
  mutate(ref_yr_prep = ifelse(survey_month_year %in% survey_start_times[survey_start_times$year>1982,]$ref_yr, survey_month_year, NA), # create a new column that only has a value when the month*year matches an actual survey (the "reference year")
         month_year = paste0(month,"-",year)) %>% 
  group_by(survey) %>% 
  fill(ref_yr_prep, .direction="up") %>%  # fill in each survey with the survey to which env data from each month*year should correspond. this is correct for all month*year combinations EXCEPT the month of the survey; e.g. 05-2010 should be matched to the survey from 05-2011 not 05-2010 
  group_by(survey) %>% 
  arrange(year) %>% 
  mutate(ref_yr = ifelse(survey_month_year==ref_yr_prep, lead(ref_yr_prep), ref_yr_prep)) %>%  # reassign the months in which a survey was conducted to the following ref_yr 
  select(ref_yr, survey, month_year) %>% 
  ungroup() %>% 
  left_join(survey_start_times %>% select(ref_yr, survey_date) %>% distinct(), by="ref_yr") # add back in the survey start dates 
# note that this works for both OISST data files 

# note start in 1980 for SODA (works for both SST and SBT SODA)
# soda_ref_yrs <- expand.grid(month=seq(1, 12, 1), year=seq(1980, maxyr, 1), survey=unique(survey_start_times$survey))  %>%
#   mutate(survey = as.character(survey),
#          survey_month_year = paste0(survey,"-",month,"-",year)) %>% 
#   mutate(ref_yr_prep = ifelse(survey_month_year %in% survey_start_times[survey_start_times$year>1980,]$ref_yr, survey_month_year, NA), 
#          month_year = paste0(month,"-",year)) %>% 
#   group_by(survey) %>% 
#   fill(ref_yr_prep, .direction="up") %>%  
#   group_by(survey) %>% 
#   arrange(year) %>% 
#   mutate(ref_yr = ifelse(survey_month_year==ref_yr_prep, lead(ref_yr_prep), ref_yr_prep)) %>% 
#   select(ref_yr, survey, month_year) %>% 
#   ungroup() %>% 
#   left_join(survey_start_times %>% select(ref_yr, survey_date) %>% distinct(), by="ref_yr") 

# step 3: join this list of all months to the MHW data and then calculate statistics based on survey-years 
mhw_sat_sst <- sat_sst %>% 
  mutate(date = dmy(dateRaw), # standardize date formats
         year = year(date),
         month = month(date),
         month_year = paste0(month,"-",year)
  ) %>% 
  select(-dateRaw) %>% 
  filter(str_detect(date, '-02-29', negate=TRUE), # get rid of leap days 
    survey %in% unique(survey_start_times$survey)) %>% 
  left_join(sat_sst_ref_yrs, by=c('survey','month_year')) %>% # note that because this is a left_join, and the mhw data starts at 1982, sometimes a ref_yr is matched with many years of data preceding the survey -- this is corrected below when we keep only dates a certain lag value before the survey
  filter(!is.na(ref_yr)) 
# confirm that there are no ref_yrs matched with <365 days of data
tmp <- mhw_sat_sst %>% group_by(ref_yr) %>% summarise(n=length(anom))
if(min(tmp$n) < 365){ 
  bad_ref_yrs <- tmp %>% filter(n<=365) %>% pull(ref_yr)
  mhw_sat_sst %<>% filter(!ref_yr %in% bad_ref_yrs)
}
mhw_sat_sst %<>%
  mutate(date_lag = survey_date - date) %>% # how many days before the survey was the SST observation?
  filter(date_lag < 365,
         date_lag >= 0) # only keep SST data within 365 days of a survey for each region

mhw_sat_sst_nod <- sat_sst_nod %>% 
  mutate(date = dmy(dateRaw), # standardize date formats
         year = year(date),
         month = month(date),
         month_year = paste0(month,"-",year)
  ) %>% 
  select(-dateRaw) %>% 
  filter(str_detect(date, '-02-29', negate=TRUE), # get rid of leap days 
         survey %in% unique(survey_start_times$survey)) %>% 
  left_join(sat_sst_ref_yrs, by=c('survey','month_year')) %>% # note that because this is a left_join, and the mhw data starts at 1982, sometimes a ref_yr is matched with many years of data preceding the survey -- this is corrected below when we keep only dates a certain lag value before the survey
  filter(!is.na(ref_yr)) 
# confirm that there are no ref_yrs matched with <365 days of data 
tmp <- mhw_sat_sst_nod %>% group_by(ref_yr) %>% summarise(n=length(anom))
if(min(tmp$n) < 365){ 
  bad_ref_yrs <- tmp %>% filter(n<=365) %>% pull(ref_yr)
  mhw_sat_sst_nod %<>% filter(!ref_yr %in% bad_ref_yrs)
}
mhw_sat_sst_nod %<>%
  mutate(date_lag = survey_date - date) %>% # how many days before the survey was the SST observation?
  filter(date_lag < 365,
         date_lag >= 0) # only keep SST data within 365 days of a survey for each region


# repeat for SODA 
# mhw_soda_sbt <- soda_sbt %>% 
#   mutate(date = dmy(dateRaw),
#          year = year(date),
#          month = month(date),
#          month_year = paste0(month,"-",year)) %>% 
#   #    anom=replace_na(anom, 0)) 
#   select(-dateRaw) %>% 
#   filter(survey %in% unique(survey_start_times$survey)) %>% 
#   left_join(soda_ref_yrs, by=c('survey','month_year'))%>% 
#   filter(!is.na(ref_yr)) 
# tmp <- mhw_soda_sbt %>% group_by(ref_yr) %>% summarise(n=length(anom)) # currently all the bad ref_yrs are too recent (post-2017)
# if(min(tmp$n) < 12){
#   bad_ref_yrs <- tmp %>% filter(n<12) %>% pull(ref_yr)
#   mhw_soda_sbt %<>% filter(!ref_yr %in% bad_ref_yrs)
# }
# mhw_soda_sbt %<>% mutate(date_lag = survey_date - date) %>% 
#   filter(date_lag < 365,
#          date_lag >= 0) 
# 
# mhw_soda_sst <- soda_sst %>% 
#   mutate(date = dmy(dateRaw),
#          year = year(date),
#          month = month(date),
#          month_year = paste0(month,"-",year)) %>% 
#   select(-dateRaw) %>% 
#   filter(survey %in% unique(survey_start_times$survey)) %>% 
#   left_join(soda_ref_yrs, by=c('survey','month_year'))%>% 
#   filter(!is.na(ref_yr)) 
# tmp <- mhw_soda_sst %>% group_by(ref_yr) %>% summarise(n=length(anom)) 
# if(min(tmp$n) < 12){
#   bad_ref_yrs <- tmp %>% filter(n<12) %>% pull(ref_yr)
#   mhw_soda_sst %<>% filter(!ref_yr %in% bad_ref_yrs)
# }
# mhw_soda_sst %<>% mutate(date_lag = survey_date - date) %>% 
#   filter(date_lag < 365,
#          date_lag >= 0) 
########
# make summary datasets 
########

#Make different summary datasets of survey data + MHW data

# Make summary datasets with MHW data
# generate two different satellite data outputs, using different definitions of a heatwave (any anomaly, or a 5-day continuous one)

# prep MHW for merging with surveys
mhw_summary_sat_sst_any <- mhw_sat_sst %>% 
  group_by(ref_yr) %>% 
  arrange(date) %>% 
  summarise(
    anom_days = sum(anom>0, na.rm=TRUE),# count number of non-NA anomaly days 
    anom_sev = sum(anom, na.rm=TRUE), # add up total anomaly values
    anom_int = anom_sev / anom_days # calculate mean intensity for every survey*year 
  ) %>% 
  group_by(ref_yr) %>% 
  mutate(mhw_yes_no = ifelse(anom_days>0, "yes", "no")) %>% 
  ungroup() %>% 
  mutate(anom_int = replace_na(anom_int, 0)) # replacing NAs in anom_int that came from dividing by 0 with 0s

# trimming anomalies to only use those from events with a duration of >=5 days
mhw_sat_sst_5_day_prep <- NULL
for(i in unique(survey_start_times$survey)){
  tmp <- mhw_sat_sst%>% 
    filter(survey==i) %>% 
    mutate(yn = ifelse(is.na(anom),0,1)) %>% 
    group_by(ref_yr, yn) %>% 
    arrange(date) 
  tmp <- transform(tmp, counter = ave(yn, rleid(ref_yr, yn), FUN=sum)) 
  # count up the number of sequential mhw-days and put the sum in a column 
  # https://coderedirect.com/questions/412211/r-count-consecutive-occurrences-of-values-in-a-single-column-and-by-group -- couldn't get this to work with dplyr functions
  mhw_sat_sst_5_day_prep <- bind_rows(mhw_sat_sst_5_day_prep, tmp)
  }

mhw_summary_sat_sst_nod_any <- mhw_sat_sst_nod %>% 
  group_by(ref_yr) %>% 
  arrange(date) %>% 
  summarise(
    anom_days = sum(anom>0, na.rm=TRUE),# count number of non-NA anomaly days 
    anom_sev = sum(anom, na.rm=TRUE), # add up total anomaly values
    anom_int = anom_sev / anom_days # calculate mean intensity for every survey*year 
  ) %>% 
  group_by(ref_yr) %>% 
  mutate(mhw_yes_no = ifelse(anom_days>0, "yes", "no")) %>% 
  ungroup() %>% 
  mutate(anom_int = replace_na(anom_int, 0)) # replacing NAs in anom_int that came from dividing by 0 with 0s

mhw_sat_sst_5_day_nod_prep <- NULL
for(i in unique(survey_start_times$survey)){
  tmp <- mhw_sat_sst_nod%>% 
    filter(survey==i) %>% 
    mutate(yn = ifelse(is.na(anom),0,1)) %>% 
    group_by(ref_yr, yn) %>% 
    arrange(date) 
  tmp <- transform(tmp, counter = ave(yn, rleid(ref_yr, yn), FUN=sum)) 
  # count up the number of sequential mhw-days and put the sum in a column 
  # https://coderedirect.com/questions/412211/r-count-consecutive-occurrences-of-values-in-a-single-column-and-by-group -- couldn't get this to work with dplyr functions
  mhw_sat_sst_5_day_nod_prep <- bind_rows(mhw_sat_sst_5_day_nod_prep, tmp)
}

# how many distinct MHWs per year? (for main text stats)
sst_5_day_mhws_per_yr <- mhw_sat_sst_5_day_prep %>% 
  group_by(ref_yr) %>% 
  mutate(anom = ifelse(counter >= 5, anom, NA),# overwrite anom values that aren't part of a >=5 day event
         anom_na = !is.na(anom), # create true/false column
         n_mhw = sum(rle(anom_na)$values) # count lengths of discrete TRUE sequences by ref_yr
         ) %>% 
  select(survey, ref_yr, n_mhw) %>% 
  distinct()
write.csv(sst_5_day_mhws_per_yr, file = here("processed-data","total_number_mhws.csv"))
sum(sst_5_day_mhws_per_yr$n_mhw)

mhw_summary_sat_sst_5_day <- mhw_sat_sst_5_day_prep %>% 
  group_by(ref_yr) %>% 
  mutate(anom = ifelse(counter >= 5, anom, NA))%>%  # overwrite anom values that aren't part of a >=5 day event
  summarise(
    anom_days = sum(anom>0, na.rm=TRUE),
    anom_sev = sum(anom, na.rm=TRUE), 
    anom_int = anom_sev / anom_days 
  )%>% 
  group_by(ref_yr) %>% 
  mutate(mhw_yes_no = ifelse(anom_days>0, "yes", "no")) %>% 
  ungroup() %>% 
  mutate(anom_int = replace_na(anom_int, 0))  

mhw_summary_sat_sst_5_day_nod <- mhw_sat_sst_5_day_nod_prep %>% 
  group_by(ref_yr) %>% 
  mutate(anom = ifelse(counter >= 5, anom, NA))%>%  # overwrite anom values that aren't part of a >=5 day event
  summarise(
    anom_days = sum(anom>0, na.rm=TRUE),
    anom_sev = sum(anom, na.rm=TRUE), 
    anom_int = anom_sev / anom_days 
  )%>% 
  group_by(ref_yr) %>% 
  mutate(mhw_yes_no = ifelse(anom_days>0, "yes", "no")) %>% 
  ungroup() %>% 
  mutate(anom_int = replace_na(anom_int, 0))  

# mhw_summary_soda_sst <- mhw_soda_sst %>% 
#   group_by(ref_yr) %>% 
#   arrange(date) %>% 
#   summarise(
#     anomMonths = sum(anom>0, na.rm=TRUE), 
#     anom_sev = sum(anom, na.rm=TRUE),
#     anom_int = anom_sev / anomMonths # not comparable to anom_int from daily data!
#   ) %>% 
#   group_by(ref_yr) %>% 
#   mutate(mhw_yes_no = ifelse(anomMonths>0, "yes", "no")) %>% 
#   ungroup() %>% 
#   mutate(anom_int = replace_na(anom_int, 0)) 
# 
# mhw_summary_soda_sbt <- mhw_soda_sbt %>% 
#   group_by(ref_yr) %>% 
#   arrange(date) %>% 
#   summarise(
#     anomMonths = sum(anom>0, na.rm=TRUE), 
#     anom_sev = sum(anom, na.rm=TRUE),
#     anom_int = anom_sev / anomMonths # not comparable to anom_int from daily data!
#   ) %>% 
#   group_by(ref_yr) %>% 
#   mutate(mhw_yes_no = ifelse(anomMonths>0, "yes", "no")) %>% 
#   ungroup() %>% 
#   mutate(anom_int = replace_na(anom_int, 0)) 

# 
# # datasets based on calendar year -- use only for characterizing regional MHWs, not for comparing to trawl data -- BE CAREFUL ABOUT MERGING THE DATASETS GENERATED BELOW THIS LINE WITH THE SURVEYS!
# mhw_calendar_sat_sst_any <- sat_sst %>% 
#   mutate(date = dmy(dateRaw)) %>% # standardize date formats
#   select(-dateRaw) %>% 
#   mutate(year = year(date)) %>% 
#   group_by(survey, year) %>% 
#   summarise(
#     anom_days = sum(anom>0, na.rm=TRUE),# count number of non-NA anomaly days 
#     anom_sev = sum(anom, na.rm=TRUE), # add up total anomaly values
#     anom_int = anom_sev / anom_days # calculate mean intensity for every survey*year 
#   ) %>% 
#   group_by(survey, year) %>% 
#   mutate(mhw_yes_no = ifelse(anom_days>0, "yes", "no")) %>% 
#   ungroup() %>% 
#   mutate(anom_int = replace_na(anom_int, 0)) # replacing NAs in anom_int that came from dividing by 0 with 0s
# 
# # almost same code as above -- replacing ref_yr with calendar year
# mhw_calendar_sat_sst_5_day_prep <- NULL
# for(i in unique(survey_start_times$survey)){
#   tmp <- sat_sst %>% 
#     mutate(date = dmy(dateRaw)) %>%
#     select(-dateRaw) %>% 
#     mutate(year = year(date)) %>% 
#     filter(survey==i) %>% 
#     mutate(yn = ifelse(is.na(anom),0,1)) %>% 
#     group_by(year, yn) %>% 
#     arrange(date) 
#   tmp <- transform(tmp, counter = ave(yn, rleid(year, yn), FUN=sum)) 
#   mhw_calendar_sat_sst_5_day_prep <- bind_rows(mhw_calendar_sat_sst_5_day_prep, tmp)
# }
# 
# mhw_calendar_sat_sst_5_day <- mhw_calendar_sat_sst_5_day_prep %>% 
#   group_by(survey, year) %>% 
#   mutate(anom = ifelse(counter >= 5, anom, NA))%>%
#   summarise(
#     anom_days = sum(anom>0, na.rm=TRUE),
#     anom_sev = sum(anom, na.rm=TRUE), 
#     anom_int = anom_sev / anom_days, 
#     mhw_yes_no = ifelse(anom_days>0, "yes", "no")
#   ) %>% 
#   ungroup() %>% 
#   mutate(anom_int = replace_na(anom_int, 0))  
# 
# mhw_calendar_soda_sst <- soda_sst %>% 
#   mutate(date = dmy(dateRaw)) %>% 
#   select(-dateRaw) %>% 
#   mutate(year = year(date)) %>% 
#   group_by(survey, year) %>% 
#   summarise(anom_months = sum(anom>0, na.rm=TRUE),
#             anom_sev = sum(anom, na.rm=TRUE), 
#             anom_int = anom_sev / anom_months,
#             mhw_yes_no = ifelse(anom_months>0, "yes", "no")
#   )  %>% 
#   ungroup() %>% 
#   mutate(anom_int = replace_na(anom_int, 0))
# 
# mhw_calendar_soda_sbt <- soda_sbt %>% 
#   mutate(date = dmy(dateRaw)) %>% 
#   select(-dateRaw) %>% 
#   mutate(year = year(date)) %>% 
#   group_by(survey, year) %>% 
#   summarise(anom_months = sum(anom>0, na.rm=TRUE),
#             anom_sev = sum(anom, na.rm=TRUE), 
#             anom_int = anom_sev / anom_months,
#             mhw_yes_no = ifelse(anom_months>0, "yes", "no")
#   )  %>% 
#   ungroup() %>% 
#   mutate(anom_int = replace_na(anom_int, 0))

########
# CTI and CPUE data
########

# stats pooled across all species 
# no MHWs yet, just biomass stats
survey_summary <- cpue %>% 
  left_join(survey_start_times, by=c('survey','year')) %>% 
  filter(!is.na(ref_yr)) %>% # keep only the rows assigned to a ref_yr (will also filter out the ea'rly trawl data)
  group_by(ref_yr, survey, year) %>% 
  summarise(wt_mt = sum(wtcpue_mean) / 1000,
            wt_mt_med = sum(wtcpue_median),
            num = sum(numcpue_mean), 
            num_med = sum(numcpue_median), 
            depth_wt = weighted.mean(depth_mean, w=wtcpue_mean, na.rm=TRUE)) %>% # get total weight across all species for the survey*year
  group_by(survey) %>% 
  arrange(year) %>% 
  mutate(#wt_mt_diff = wt_mt - lag(wt_mt), # calculate first difference (delta from last year surveyed--not always a one-year lag though!)
     #    wt_mt_diff_prop = (wt_mt_diff / lag(wt_mt)), # calculate proportional change
     #    wt_mt_anom = wt_mt - mean(wt_mt), # subtract mean over all years within the survey
    #     wt_mt_anom_prop = (wt_mt_anom / mean(wt_mt)), # get proportional difference of anomaly relative to mean
     #    wt_mt_z = (wt_mt - mean(wt_mt)) / sd(wt_mt), # calculate Z-score
         wt_mt_log = log(wt_mt / lag(wt_mt)), # calculate log ratio
         wt_mt_log_med = log(wt_mt_med / lag(wt_mt_med)),
         num_log = log(num / lag(num)),
         num_log_med = log(num_med / lag(num_med)),
         depth_wt_log = log(depth_wt / lag(depth_wt))
  )  %>% 
  ungroup()

# species-level stats
survey_spp_summary <- cpue %>% 
  mutate(wt_mt = wtcpue_mean/1000,
         wt_mt_med = wtcpue_median/1000) %>% 
  select(-wtcpue_mean, wtcpue_median) %>% 
  left_join(survey_start_times, by=c('survey','year')) %>% 
  filter(!is.na(ref_yr)) %>%
  group_by(survey, accepted_name) %>% 
  arrange(year) %>% 
  mutate(#wt_mt_diff = wt_mt - lag(wt_mt), 
        # wt_mt_diff_prop = (wt_mt_diff / lag(wt_mt)),
        # wt_mt_diff_prop_abs = abs(wt_mt_diff_prop), 
        # wt_mt_diff_prop_abs_log = log(wt_mt_diff_prop_abs),
        # wt_mt_anom = wt_mt - mean(wt_mt),
        # wt_mt_anom_prop = (wt_mt_anom / mean(wt_mt)), 
        # wt_mt_z = (wt_mt - mean(wt_mt)) / sd(wt_mt),
         wt_mt_log = log(wt_mt / lag(wt_mt)),
         wt_mt_log_med = log(wt_mt_med / lag(wt_mt_med)),
         num_log = log(numcpue_mean / lag(numcpue_mean)),
         num_log_med = log(numcpue_median / lag(numcpue_median)),
         depth_wt_log = log(depth_mean / lag(depth_mean))
  )  %>% 
  ungroup()
# ignore warning message about NAs being produced in the depth column; this is a feature, not a bug! (we want it to show NA when the species wasn't recorded)

# now add STI/CTI to the survey dataframes where available

cti_spp_prep <- cti %>% 
  select(speciesName, hadsstwannp50) %>% # keep only the species with CTIs, and use the hadsstwannp50 index (see dataset description in source file for CTI data)
  distinct()%>% 
  rename('STI' = hadsstwannp50,
         'accepted_name' =speciesName)  %>% 
  filter(accepted_name %in% unique(survey_spp_summary$accepted_name))

length(unique(survey_spp_summary$accepted_name)) 
length(unique(cti_spp_prep$accepted_name))
  
survey_spp_summary_cti <- survey_spp_summary %>% 
  left_join(cti_spp_prep) 

cti_prep <- survey_spp_summary_cti %>% 
  filter(!is.na(STI)) %>% 
  group_by(ref_yr) %>% 
  summarise(CTI = weighted.mean(STI, w=wt_mt))

survey_summary_cti <- survey_summary %>% 
  inner_join(cti_prep, by="ref_yr") %>% 
  group_by(survey) %>% 
  arrange(year) %>% 
  mutate(cti_diff = CTI - lag(CTI),
         cti_log = log(CTI / lag(CTI))) %>% 
  filter(!is.na(CTI))
########
# write out dataframes 
########

# trawl and cti datasets
write_csv(survey_summary_cti, here("processed-data","survey_biomass_with_CTI.csv"))
write_csv(survey_spp_summary_cti, here("processed-data","species_biomass_with_CTI.csv"))
write_csv(survey_start_times, here("processed-data","survey_start_times.csv"))

# MHWs paired with ref_years
write_csv(mhw_summary_sat_sst_any, here("processed-data","MHW_satellite_sst.csv"))
write_csv(mhw_summary_sat_sst_5_day, here("processed-data","MHW_satellite_sst_5_day_threshold.csv"))
write_csv(mhw_summary_sat_sst_nod_any, here("processed-data","MHW_satellite_sst_no_detrending.csv"))
write_csv(mhw_summary_sat_sst_5_day_nod, here("processed-data","MHW_satellite_sst_5_day_threshold_no_detrending.csv"))
#write_csv(mhw_summary_soda_sst, here("processed-data","MHW_soda_sst.csv"))
#write_csv(mhw_summary_soda_sbt, here("processed-data","MHW_soda_sbt.csv"))

# calendar year datasets -- for summary statistics and plots only, no trawl data analysis
# write_csv(mhw_calendar_sat_sst_5_day, here("processed-data","MHW_calendar_year_satellite_sst_5_day_threshold.csv"))
# write_csv(mhw_calendar_soda_sst, here("processed-data","MHW_calendar_year_soda_sst.csv"))
# write_csv(mhw_calendar_soda_sbt, here("processed-data","MHW_calendar_year_soda_sbt.csv"))
