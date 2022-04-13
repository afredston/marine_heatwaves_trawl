# load packages
library(tidyverse)
library(lubridate)
set.seed=10

# make survey dfs
ai_dat <- data.frame("year" = c(1983, 1986, 1991, 1994, 1997), "region" = "aleutian_islands", "startmonth" = 5)
ebs_dat <- data.frame("year" = seq(1983, 1999, 1), "region" = "eastern_bering_sea", "startmonth" = 5)

# join and create what will become ref_year column
surv_dat <- rbind(ai_dat, ebs_dat) %>% 
  mutate(month_year = paste0(startmonth,"-",year)) %>%
  select(region, month_year) %>%
  distinct() %>%
  mutate(region_month_year = paste0(region,"-",month_year))

# expand out to all possible month*year combinations for joining with temperature
surv_dat_exploded <- expand.grid(month=seq(1, 12, 1), year=seq(1982, 2000, 1), region=c('aleutian_islands','eastern_bering_sea')) %>% # get a factorial combo of every possible month*year; have to start in 1982 even though we can't use surveys before 1983 because we need to match to temperature data from 1982
  mutate(region_month_year = paste0(region,"-",month,"-",year)) %>% # create unique identifier
  mutate(ref_year = ifelse(region_month_year %in% surv_dat$region_month_year, region_month_year, NA),
         month_year = paste0(month,"-",year)) %>% 
  select(region, month_year, ref_year) %>% 
  distinct() %>% 
  group_by(region) %>% 
  fill(ref_year, .direction="up") %>%  # fill in each region with the survey to which env data from each month*year should correspond
  ungroup() 

# make temperature dataset and join in survey ref_year column 
temp_dat <- data.frame(expand.grid(date=seq(ymd("1982-01-01"), ymd("1999-12-31"), "days"), region=c('aleutian_islands','eastern_bering_sea'))) %>% 
  mutate(temperature = rnorm(nrow(.), 10, 5),  # fill in with fake data
         year = year(date),
         month = month(date),
         month_year = paste0(month,"-",year)) %>% 
  left_join(surv_dat_exploded, by=c('region','month_year')) %>% 
  filter(!is.na(ref_year))# get rid of dates that are after any ref_year
