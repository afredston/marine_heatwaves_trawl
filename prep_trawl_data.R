# this script imports the FISHGLOB trawl datasets and reshapes them
# it uses data.table for fast data wrangling. for questions about the script contact Alexa Fredston
# on some personal machines, you may exceed your memory with some of these dataframes, which are very large
# this script was run on a remote server 
# most of it runs programmatically but if the source data are updated it's very important to revisit the filters in this document especially how surveys are trimmed to seasons
#########
# Load packages
#########
library(here)
library(lubridate)
library(data.table)
library(magrittr)
here <- here::here
#########
# Raw data
#########

raw <- fread(here("raw-data","FISHGLOB_public_v1.1_clean.csv"))[phylum=="Chordata"][!survey=='S-GEORG'][!survey=='GIN'] # shouldn't be any inverts, just checking

#for northeast, we are going to delete any hauls before 2009 that are outside of +/- 5 minutes of 30 minutes and 2009 forward that are outside of +/- 5 minutes of 20 minutes
neus_bad_hauls <- unique(raw[(survey == "NEUS" & year < 2009 & (haul_dur < 0.42 | haul_dur > 0.58)) | (survey == "NEUS" & year >= 2009 & (haul_dur < 0.25  | haul_dur > 0.42)),haul_id])
#this removes 315 hauls from 36792 total hauls (0.85%)

#calculate wgt_cpue (km^2 avg from sean Lucey) and wgt_h (all biomass values calibrated to standard pre 2009 30 minute tow)
raw[survey == "NEUS", wgt_h := wgt/0.5][survey == "NEUS", wgt_cpue := wgt/0.0384][survey == "NEUS", num_h := num/0.5][survey == "NEUS", num_cpue := num/0.0384]


# get haul-level data
haul_info <- copy(raw)[, .(survey, country, haul_id, year, month, latitude, longitude)] %>% unique() # lots of other useful data in here like depth, just trimming for speed 
bad_hauls <- (copy(haul_info)[, .N, by=.(haul_id)][ N > 1 ])$haul_id # find duplicated hauls
bad_hauls <- c(bad_hauls, "EVHOE 2019 4 FR 35HT GOV X0510 64") #add EVHOE long haul (24 hours; EVHOE 2019 4 FR 35HT GOV X0510 64) to bad hauls
GSLN_hauls_delete <- unique(raw[survey == "GSL-N" & year < 1987,haul_id])#get rid of hauls before 1987 for GSL-N because there are only biomass data for 2 species in 1984, and then no biomass data for 2 years
bad_hauls <- c(bad_hauls, GSLN_hauls_delete, neus_bad_hauls)
short_surveys <- unique(copy(haul_info)[, .(survey, year)])[, .N, by=.(survey)][N < 10]$survey # get surveys with less than ten years of data to trim out 
haul_info <- haul_info[!haul_id %in% bad_hauls][!survey %in% short_surveys] # filter out bad hauls
length(unique(haul_info$haul_id))==nrow(haul_info) # check that every haul is listed exactly once 
raw <- copy(raw)[, .(survey, haul_id, wgt_cpue, accepted_name)][haul_id %in% haul_info$haul_id] # trim to only taxon-level data for speed (but note there is a full taxonomy available, and other catch data), and to hauls in haul_info

# get expanded grid for each region
raw_zeros <- NULL
for(i in unique(raw$survey)){
  tmp1 <- raw[survey==i]
  tmp2 <- as.data.table(expand.grid(haul_id=unique(tmp1[,haul_id]), accepted_name=unique(tmp1[,accepted_name])))
  tmp2$survey <- i
  raw_zeros <- rbind(raw_zeros, tmp2)
}

# expand raw to have true absences
raw_zeros %<>%
  # left-join haul info to all spp*haul rows
  merge(haul_info, all.x=TRUE, by=c("haul_id","survey")) %>%
  # left-join actual obs data to all spp*haul rows
  merge(raw, all.x=TRUE, by=c("survey", "haul_id", "accepted_name"))  
raw_zeros <- copy(raw_zeros)[is.na(wgt_cpue), wgt_cpue := 0][wgt_cpue<Inf]
 

# Check that the spatial domain of each region is fixed over time 

# namer_coords <- unique(namer_raw_zeros[,.(lat, lon, region, year)])[,lat_round := (round(lat/0.25)*0.25)][,lon_round := (round(lon/0.25)*0.25)][,coords_round := paste0(lon_round, ", ", lat_round)]
# 
# namer_coords_expand <- NULL
# for(i in unique(namer_coords$region)) {
#   # get all possible quarter-cells per region 
#   regdat <- namer_coords[region==i]
#   expdat <- as.data.table(expand.grid(coords_round = unique(regdat$coords_round), year=unique(regdat$year)))
#   expdat$region <- i
#   
#   # get the number of years each one was surveyed 
#   survdat <- unique(namer_coords[region==i][,.(year, coords_round)])
#   survdat$surveyed <- 1
#   
#   expdat <- merge(expdat, survdat, all.x=TRUE)
#   expdat <- expdat[is.na(surveyed), surveyed := 0]
#   
#   namer_coords_expand <- rbind(namer_coords_expand, expdat)
# }
# 
# namer_coords_expand[,coords_n := sum(surveyed), by=.(region, coords_round)][,coords_prop := coords_n / max(coords_n), by=region]
# 
# ggplot(namer_coords_expand, aes(x=coords_prop)) +
#   geom_histogram() + 
#   facet_wrap(~region, scales="free_y")

#########
# Tidy data
#########
# deal with start months 

# setDT(raw_zeros)[, survey := stringr::str_replace_all(survey, c(' Summer'="",' Fall'="",' Winter'="",' Spring'=""))] # pool seasons for multi-season surveys

# NEED TO EXPLORE START MONTHS FOR NEW SURVEYS LIKE CANADA 

# here, we split up some of the Europe surveys to select only the fall / winter surveys and correctly assign start months # most are from the supplementary material for Maureaud et al. 10.1098/rspb.2019.1189
# the rest are from the data itself and pers. comm. A. Maureaud
# pers. comm. A. Maureaud re: work by L. Pecuchet and R. Frelat
#baltic
bits_raw_zeros <- raw_zeros[survey=='BITS'& month %in% c(2, 3)][,startmonth := min(month)] 
# bay of biscay
evhoe_raw_zeros <- raw_zeros[survey=='EVHOE'& month %in% c(10, 11, 12)][,startmonth := min(month)] 
# east english channel 
fr_cgfs_raw_zeros <- raw_zeros[survey=='FR-CGFS'& month %in% c(10, 11, 12)][,startmonth := min(month)] 
# ireland
ie_igfs_raw_zeros <- raw_zeros[survey=='IE-IGFS'& month %in% c(10, 11, 12)][,startmonth := min(month)] 
# north sea
ns_ibts_raw_zeros <- raw_zeros[survey=='NS-IBTS'& month %in% c(1, 2, 3)][,startmonth := min(month)] 
# scottish west coast
swc_ibts_raw_zeros <-raw_zeros[survey=='SWC-IBTS' & month %in% c(1, 2, 3)][,startmonth := min(month)] 

# many other surveys also have tows throughout the year; I'm cropping them manually to one season here
# pick the season with the most hauls, no more than 4 months, except the regions with fully seasonal surveys that occasionally start slightly earlier / end slightly later than a 4-month window like wcann
s_georg_raw_zeros <-raw_zeros[survey=='S-GEORG' & month %in% c(1, 2,3, 4)][,startmonth := min(month)] 
dfo_nf_raw_zeros <-raw_zeros[survey=='DFO-NF' & month %in% c(9,10,11,12)][,startmonth := min(month)] 
gsl_n_raw_zeros <-raw_zeros[survey=='GSL-N' & month %in% seq(7, 10, 1)][,startmonth := min(month)] 
neus_raw_zeros <-raw_zeros[survey=='NEUS' & month %in% seq(9, 12, 1)][,startmonth := min(month)] 
nigfs_raw_zeros <-raw_zeros[survey=='NIGFS' & month %in% seq(10,11, 1)][,startmonth := min(month)] # basically a toss-up here between fall and spring, doing fall to be more distinct from other uk surveys
nor_bts_raw_zeros <-raw_zeros[survey=='Nor-BTS' & month %in% seq(8, 12, 1)][,startmonth := min(month)] # also a toss-up, but I'm keeping fall because there is some spatial overlap with ns-ibts, so this keeps them more distinct 
nz_raw_zeros <-raw_zeros[survey=='NZ' & month %in% c(11,12,1)][,startmonth := 11] # manually coding start month because this "wraps around" the year, but the start month is not january!
scs_raw_zeros <-raw_zeros[survey=='SCS' & month %in% seq(6,8, 1)][,startmonth := min(month)] 
gmex_raw_zeros <-raw_zeros[survey=='GMEX' & month %in% seq(6,8, 1)][,startmonth := min(month)] 
seus_raw_zeros <-raw_zeros[survey=='SEUS' & month %in% seq(7,10, 1)][,startmonth := min(month)] 

raw_zeros <- raw_zeros[!survey %in% c('BITS','EVHOE','FR-CGFS','IE-IGFS','NS-IBTS','SWC-IBTS','S-GEORG','DFO-NF','GSL-N','NEUS','NIGFS','Nor-BTS','NZ','SCS','GMEX','SEUS')]

# get start months for each survey 
start_months <- haul_info[,.(startmonth = min(month)), by=survey][, .(survey, startmonth)]

# join only the non-special case start months to raw_zeros 
raw_zeros %<>% merge(start_months, all.x=TRUE, by="survey") 

# add special cases back in 
raw_zeros <- rbind(raw_zeros, bits_raw_zeros, evhoe_raw_zeros, fr_cgfs_raw_zeros, ie_igfs_raw_zeros, ns_ibts_raw_zeros, swc_ibts_raw_zeros, s_georg_raw_zeros, dfo_nf_raw_zeros, gsl_n_raw_zeros, neus_raw_zeros,nigfs_raw_zeros,nor_bts_raw_zeros,nz_raw_zeros, scs_raw_zeros,gmex_raw_zeros,seus_raw_zeros)

# calculate species-level mean CPUE in every year and region
raw_cpue <- raw_zeros[,.(wtcpue_mean = mean(wgt_cpue)), by=c("survey", "accepted_name", "year","startmonth")] 

# get year interval -- how often is survey conducted?
intervals <- copy(raw_cpue)
intervals <- unique(intervals[,.(survey, year)])
intervals <- intervals[order(year)][,year_interval := year - shift(year, n=1, type="lag"), by=.(survey)]

#########
# Write out processed biomass data
#########
fwrite(raw_cpue, here("processed-data","biomass_time.csv"))
fwrite(haul_info, here("processed-data","haul_info.csv"))

