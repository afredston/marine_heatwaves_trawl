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
