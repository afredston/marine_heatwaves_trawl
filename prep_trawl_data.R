# this script imports the FISHGLOB trawl datasets and reshapes them
# it also does a significant amount of manual data cleaning. the raw datasets are described and visualized here: https://github.com/AquaAuma/fishglob
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

raw <- fread(here("raw-data","FISHGLOB_public_v1.1_clean.csv"))

##############
# trim datasets
##############
# based on the summary plots in FISHGLOB, there are a few surveys where CPUE has been immensely variable and can't be used as an index of interannual variation in biomass. a lot more surveys and years are trimmed out below, but here, we're just getting rid of a few that are obviously not usable for our questions. 
bad_surveys <- c('GSL-N')
raw <- raw[!survey %in% bad_surveys]

standardize_footprints <-  TRUE # this is a conservative approach because I only keep the strata or stat_rec that have been surveyed in most/all years in a given region. may be replaced by more nuanced fishglob methods by the working group. this is really just a placeholder, and has its issues, e.g., it should really happen after the trimming by season. 
missingness <- 0.3 # what proportion of years do we tolerate missing before omitting the sampling subregion?
nor_placeholder <- unique(copy(raw)[survey=="Nor-BTS"]$haul_id)

# get haul-level data
haul_info <- copy(raw)[, .(survey, country, haul_id, year, month, latitude, longitude, depth)] %>% unique() # lots of other useful data in here, just trimming for speed 

# FILTER OUT BAD HAULS 

#for northeast, we are going to delete any hauls before 2009 that are outside of +/- 5 minutes of 30 minutes and 2009 forward that are outside of +/- 5 minutes of 20 minutes
neus_bad_hauls <- unique(raw[(survey == "NEUS" & year < 2009 & (haul_dur < 0.42 | haul_dur > 0.58)) | (survey == "NEUS" & year >= 2009 & (haul_dur < 0.25  | haul_dur > 0.42)),haul_id])
#this removes 315 hauls from 36792 total hauls (0.85%)

#calculate wgt_cpue (km^2 avg from sean Lucey) and wgt_h (all biomass values calibrated to standard pre 2009 30 minute tow)
raw[survey == "NEUS", wgt_h := wgt/0.5][survey == "NEUS", wgt_cpue := wgt/0.0384][survey == "NEUS", num_h := num/0.5][survey == "NEUS", num_cpue := num/0.0384]

# find duplicated hauls
bad_hauls <- (copy(haul_info)[, .N, by=.(haul_id)][ N > 1 ])$haul_id

# manually trim out years without enough data (usually the first start year(s)) if needed; see pdf summaries in FISHGLOB repository for details. note that this may cause discontinuities in time-series, which are resolved in the temperature analysis -- each survey is only compared to the preceding one and to the preceding 12 months of temperature data.
# as a rule of thumb, changes within 25% or so of the mean number of hauls are fine, or surveys with a lot of interannual fluctuation in number of hauls in general (like GOA); here we're just dropping obvious cases where chunks of the time-series are different, e.g., in BITS every year after 2000 has >400 hauls and most of the earlier years are <50 
# note that many of these earlier years would be trimmed out anyway when we match them to the temperature data, but those filters are still included here for the sake of completeness 
bits_hauls_del <- unique(raw[survey=='BITS' & year <= 2000, haul_id])
evhoe_hauls_del <- unique(raw[survey=='EVHOE' & year == 2017, haul_id]) 
fr_cgfs_hauls_del <- unique(raw[survey=='FR-CGFS' & year >= 2015, haul_id]) # in/after 2015 the number of hauls goes way down and the CPUE goes way up
gmex_hauls_del <- unique(raw[survey=='GMEX' & year %in% c(1987,2020), haul_id]) # first and last years
gsl_s_hauls_del <-  unique(raw[survey=='GSL-S' & year < 1985, haul_id])
neus_hauls_del <- unique(raw[survey=='NEUS' & (year < 1968 | year > 2019), haul_id])
nigfs_hauls_del <- unique(raw[survey=='NIGFS' & year < 2009, haul_id])
nor_bts_hauls_del <- unique(raw[survey=='Nor-BTS' & year == 1980, haul_id]) # rest of the time-series has a lot of fluctuation too
ns_ibts_hauls_del <- unique(raw[survey=='NS-IBTS' & year < 1980, haul_id]) # this is a somewhat arbitrary cutoff -- hauls/yr just increases linearly with time here -- but at least we're discarding the years with very few hauls
pt_ibts_hauls_del <- unique(raw[survey=='PT-IBTS' & year %in% c(2002, 2018), haul_id])
scs_hauls_del <- unique(raw[survey=='SCS' & (year < 1979 | year > 2017), haul_id])
seus_hauls_del <- unique(raw[survey=='SEUS' & year < 1990, haul_id])
swc_ibts_hauls_del <- unique(raw[survey=='SWC-IBTS' & (year < 1990 | year == 2010), haul_id])
wctri_hauls_del <- unique(raw[survey=='WCTRI' & year == 2004, haul_id]) # this year overlapped with the WCANN survey (which started in 2003), drop it to avoid double-counting 

# collate list and add in other problematic hauls
bad_hauls <- c(bad_hauls, bits_hauls_del, evhoe_hauls_del, gmex_hauls_del, gsl_s_hauls_del, neus_hauls_del, nigfs_hauls_del, nor_bts_hauls_del, ns_ibts_hauls_del, pt_ibts_hauls_del, scs_hauls_del, seus_hauls_del, swc_ibts_hauls_del, wctri_hauls_del, "EVHOE 2019 4 FR 35HT GOV X0510 64") #add EVHOE long haul (24 hours; EVHOE 2019 4 FR 35HT GOV X0510 64) to bad hauls

# trim out surveys shorter than 10 years, taking into account the data trimming above 
short_surveys <- unique(copy(haul_info)[!haul_id %in% bad_hauls][, .(survey, year)])[, .N, by=.(survey)][N < 10]$survey 

if(standardize_footprints==TRUE){
  # STANDARDIZE SURVEY FOOTPRINTS
  stat_strat <- unique(copy(raw)[, .(survey, stat_rec, station, stratum)])
  
  # visually inspect each of the following and pick the one that makes the most sense for each region
  # where possible, avoid using station, unless it's the only column that varies for a region
  # (station often refers to subsamples within a stratum, and we don't care about preserving those over time)
  unique(copy(stat_strat)[, .(survey,stat_rec)])[, .N, by=.(survey)]
  unique(copy(stat_strat)[, .(survey,stratum)])[, .N, by=.(survey)]
  unique(copy(stat_strat)[, .(survey,station)])[, .N, by=.(survey)] 
  
  # manually generate lists of regions that use strata vs. fixed stations
  # if FISHGLOB is updated, revisit this to ensure each survey really has values in these columns
  ls_strata <- c('AI','NEUS','EBS','GMEX','GOA','NEUS','SCS','SEUS','WCANN','WCTRI')
  ls_stat_rec <- c('BITS','EVHOE','FR-CGFS','IE-IGFS','NIGFS','NS-IBTS','PT-IBTS','ROCKALL','SWC-IBTS')
  
  keep_strata <- NULL
  for(i in unique(ls_strata)){
    # get the survey's sampled strata 
    tmp_strata <- unique(copy(raw)[, .(survey, station, stratum, haul_id, year)])[survey==i]
    tmp_strata[,ID:=paste0(year, "-", stratum)]
    
    # get all combinations of strata / years and identify which strata were sampled every year 
    tmp_strata_all <- as.data.table(expand.grid(stratum=unique(tmp_strata[,stratum]), year=unique(tmp_strata[,year]))) # get all combinations 
    tmp_strata_all[,ID:=paste0(year, "-", stratum)] # make a year-stratum ID
    tmp_strata_all$test <- ifelse(tmp_strata_all$ID %in% unique(tmp_strata$ID),"present","absent") # denote whether that year-stratum was sampled 
    tmp_strata_all <- copy(tmp_strata_all)[, .(test, year, stratum)][test=="present"] # count up how many times each stratum was sampled 
    tmp_strata_all[,N := length(year), by=.(stratum)]
    tmp_strata_keep <- tmp_strata_all[N > floor(max(N) * (1 - missingness))]  
    # length(unique(tmp_strata_keep$stratum)) / length(unique(tmp_strata_all$stratum)) # what fraction of the total strata are kept?
    tmp_strata <- tmp_strata[stratum %in% tmp_strata_keep$stratum] #trim down to the kept strata
    tmp_strata$station <- NULL # overwrite to avoid confusion
    keep_strata <- rbind(keep_strata, tmp_strata)
  }
  
  # same thing for regions that use stat_recs
  keep_stat_recs <- NULL
  for(i in unique(ls_stat_rec)){
    tmp_stat_recs <- unique(copy(raw)[, .(survey, stat_rec, stratum, haul_id, year)])[survey==i]
    tmp_stat_recs[,ID:=paste0(year, "-", stat_rec)]
    tmp_stat_recs_all <- as.data.table(expand.grid(stat_rec=unique(tmp_stat_recs[,stat_rec]), year=unique(tmp_stat_recs[,year]))) 
    tmp_stat_recs_all[,ID:=paste0(year, "-", stat_rec)] 
    tmp_stat_recs_all$test <- ifelse(tmp_stat_recs_all$ID %in% unique(tmp_stat_recs$ID),"present","absent") 
    tmp_stat_recs_all <- copy(tmp_stat_recs_all)[, .(test, year, stat_rec)][test=="present"] 
    tmp_stat_recs_all[,N := length(year), by=.(stat_rec)]
    tmp_stat_recs_keep <- tmp_stat_recs_all[N > floor(max(N) * (1 - missingness))]  
    length(unique(tmp_stat_recs_keep$stat_rec)) / length(unique(tmp_stat_recs_all$stat_rec)) 
    tmp_stat_recs <- tmp_stat_recs[stat_rec %in% tmp_stat_recs_keep$stat_rec] 
    tmp_stat_recs$stratum <- NULL # 
    keep_stat_recs <- rbind(keep_stat_recs, tmp_stat_recs)
  }
  
} # end spatial trimming 

##########
# cut down raw to the good hauls in haul_info, and expand with zeros
##########
# sequentially filter out bad hauls
haul_info <- haul_info[haul_id %in% keep_stat_recs$haul_id | haul_id %in% keep_strata$haul_id | haul_id %in% nor_placeholder]
haul_info <- haul_info[!haul_id %in% bad_hauls]
haul_info <- haul_info[!survey %in% short_surveys]
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
raw_zeros <- copy(raw_zeros)[is.na(wgt_cpue), wgt_cpue := 0][wgt_cpue<Inf] # replace NAs with 0s
 
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
neus_raw_zeros <-raw_zeros[survey=='NEUS' & month %in% seq(9, 12, 1)][,startmonth := min(month)] 
nigfs_raw_zeros <-raw_zeros[survey=='NIGFS' & month %in% seq(10,11, 1)][,startmonth := min(month)] # basically a toss-up here between fall and spring, doing fall to be more distinct from other uk surveys
nor_bts_raw_zeros <-raw_zeros[survey=='Nor-BTS' & month %in% seq(8, 12, 1)][,startmonth := min(month)] # also a toss-up, but I'm keeping fall because there is some spatial overlap with ns-ibts, so this keeps them more distinct 
scs_raw_zeros <-raw_zeros[survey=='SCS' & month %in% seq(6,8, 1)][,startmonth := min(month)] 
gmex_raw_zeros <-raw_zeros[survey=='GMEX' & month %in% seq(6,8, 1)][,startmonth := min(month)] 
seus_raw_zeros <-raw_zeros[survey=='SEUS' & month %in% seq(7,10, 1)][,startmonth := min(month)] 

raw_zeros <- raw_zeros[!survey %in% c('BITS','EVHOE','FR-CGFS','IE-IGFS','NS-IBTS','SWC-IBTS','NEUS','NIGFS','Nor-BTS','SCS','GMEX','SEUS')]

# get start months for each survey 
start_months <- haul_info[,.(startmonth = min(month)), by=survey][, .(survey, startmonth)]

# join only the non-special case start months to raw_zeros 
raw_zeros %<>% merge(start_months, all.x=TRUE, by="survey") 

# add special cases back in 
raw_zeros <- rbind(raw_zeros, bits_raw_zeros, evhoe_raw_zeros, fr_cgfs_raw_zeros, ie_igfs_raw_zeros, ns_ibts_raw_zeros, swc_ibts_raw_zeros, neus_raw_zeros,nigfs_raw_zeros,nor_bts_raw_zeros, scs_raw_zeros,gmex_raw_zeros,seus_raw_zeros)

# are there any regions missing a lot of depth data?
# tmp <- copy(raw_zeros)[is.na(depth)]
# tmp_ls <- unique(tmp$survey)
# for(i in tmp_ls){
#   print("fraction of hauls missing depth is ")
#   print(length(tmp[survey==i]$haul_id)/length(raw_zeros[survey==i]$haul_id))
# }
# all way less than 1%, should be fine to run the below with na.rm

# calculate species-level mean CPUE in every year and region
raw_cpue <- raw_zeros[,.(wtcpue_mean = mean(wgt_cpue)), by=c("survey", "accepted_name", "year","startmonth")] 
raw_depth <- raw_zeros[,.(depth_mean = weighted.mean(depth, w=wgt_cpue, na.rm=TRUE)), by=c("survey", "accepted_name", "year","startmonth")] # note that this will be NA for species never observed in that year 

raw_cpue %<>% merge(raw_depth, all.x=TRUE, by=c("survey", "accepted_name", "year","startmonth"))
# get year interval -- how often is survey conducted?
# intervals <- copy(raw_cpue)
# intervals <- unique(intervals[,.(survey, year)])
# intervals <- intervals[order(year)][,year_interval := year - shift(year, n=1, type="lag"), by=.(survey)]

#########
# Write out processed biomass data
#########
fwrite(raw_cpue, here("processed-data","biomass_time.csv"))
fwrite(haul_info, here("processed-data","haul_info.csv"))
