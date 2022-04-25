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
library(dggridR) # for spatial footprint standardization
library(gridExtra)
here <- here::here
#########
# Raw data
#########

raw <- fread(here("raw-data","FISHGLOB_public_v1.1_clean.csv"))

##############
# trim datasets
##############

# in what years was each sampled, and with how many samples? 
# year_freq <- raw[, by=.(survey, year), .(nhaul = length(unique(haul_id)))][order(survey, year)][, interval := year - lag(year), by=survey]

# trim out surveys that are sampled inconsistently, rarely (more than 2 year intervals) and/or CPUE has been immensely variable based on the summary plots in FISHGLOB. 
bad_surveys <- c('GSL-N','ROCKALL','AI','WCTRI','DFO-SOG') # gsl-n has very odd cpue patterns as seen in the fishglob summary pdf and the rest are sampled inconsistently/rarely
raw <- raw[!survey %in% bad_surveys]

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
gsl_s_hauls_del <-  unique(raw[survey=='GSL-S' & year < 1985, haul_id]) # GSL-S is also missing 2003 data which shouldn't be an issue, just introduces one 2-year gap 
neus_hauls_del <- unique(raw[survey=='NEUS' & (year < 1968 | year > 2019), haul_id])
nigfs_hauls_del <- unique(raw[survey=='NIGFS' & year < 2009, haul_id])
nor_bts_hauls_del <- c(unique(raw[survey=='Nor-BTS' & year < 1981, haul_id]), unique(raw[survey=='Nor-BTS' & year > 2005, haul_id]), unique(raw[survey=='Nor-BTS' & latitude<68, haul_id])) # rest of the time-series has a lot of fluctuation and very few hauls. latitude cutoff to exclude the norwegian sea, which is rarely sampled, and focus on the barents sea 
ns_ibts_hauls_del <- unique(raw[survey=='NS-IBTS' & year < 1980, haul_id]) # this is a somewhat arbitrary cutoff -- hauls/yr just increases linearly with time here -- but at least we're discarding the years with very few hauls
pt_ibts_hauls_del <- unique(raw[survey=='PT-IBTS' & year %in% c(2002, 2018), haul_id]) # also missing 2012 data, shouldn't be an issue, just introduces one 2-year gap 
scs_hauls_del <- unique(raw[survey=='SCS' & (year < 1979 | year > 2017), haul_id])
seus_hauls_del <- unique(raw[survey=='SEUS' & year < 1990, haul_id])
swc_ibts_hauls_del <- unique(raw[survey=='SWC-IBTS' & (year < 1990), haul_id])
# wctri_hauls_del <- unique(raw[survey=='WCTRI' & year == 2004, haul_id]) # this year overlapped with the WCANN survey (which started in 2003), drop it to avoid double-counting 
goa_hauls_del <- unique(raw[survey=='GOA' & year < 1999, haul_id]) #drop triennial years before it became a biennial survey

# collate list and add in other problematic hauls
bad_hauls <- c(bad_hauls, bits_hauls_del, evhoe_hauls_del, gmex_hauls_del, gsl_s_hauls_del, neus_hauls_del, nigfs_hauls_del, nor_bts_hauls_del, ns_ibts_hauls_del, pt_ibts_hauls_del, scs_hauls_del, seus_hauls_del, swc_ibts_hauls_del,goa_hauls_del, "EVHOE 2019 4 FR 35HT GOV X0510 64", neus_bad_hauls) #add EVHOE long haul (24 hours; EVHOE 2019 4 FR 35HT GOV X0510 64) to bad hauls

# trim out surveys shorter than 10 years, taking into account the data trimming above 
short_surveys <- unique(copy(haul_info)[!haul_id %in% bad_hauls][, .(survey, year)])[, .N, by=.(survey)][N < 10]$survey 

# trim out bad hauls before going further 
haul_info <- haul_info[!haul_id %in% bad_hauls]
haul_info <- haul_info[!survey %in% short_surveys]
raw <- copy(raw)[haul_id %in% haul_info$haul_id]

# TRIM TO MOST FREQUENTLY SAMPLED SEASON

# here, we trim all surveys to the most consistently sampled months (3, representing one season) and calculate their start months for pairing with MHW data

# most are from the supplementary material for Maureaud et al. 10.1098/rspb.2019.1189
# the rest are from the data itself and pers. comm. A. Maureaud
mon_freq <- raw[, by=.(survey, month), .(nhaul = length(unique(haul_id)))]

# pers. comm. A. Maureaud re: work by L. Pecuchet and R. Frelat
#baltic
bits_raw <- raw[survey=='BITS'& month %in% c(2, 3)][,startmonth := min(month)] 
ebs_raw <- raw[survey=='EBS'& month %in% seq(6,8,1)][,startmonth := min(month)] 
evhoe_raw <- raw[survey=='EVHOE'& month %in% c(10, 11, 12)][,startmonth := min(month)] 
fr_cgfs_raw <- raw[survey=='FR-CGFS'& month %in% c(10, 11, 12)][,startmonth := min(month)] 
gmex_raw <-raw[survey=='GMEX' & month %in% seq(6,8, 1)][,startmonth := min(month)] 
goa_raw <-raw[survey=='GOA' & month %in% seq(5,7, 1)][,startmonth := min(month)] 
ie_igfs_raw <- raw[survey=='IE-IGFS'& month %in% c(10, 11, 12)][,startmonth := min(month)] 
ns_ibts_raw <- raw[survey=='NS-IBTS'& month %in% c(1, 2, 3)][,startmonth := min(month)] 
neus_raw <-raw[survey=='NEUS' & month %in% seq(9, 11, 1)][,startmonth := min(month)] 
nigfs_raw <-raw[survey=='NIGFS' & month %in% seq(10,11, 1)][,startmonth := min(month)] # basically a toss-up here between fall and spring, doing fall to be more distinct from other uk surveys
nor_bts_raw <-raw[survey=='Nor-BTS' & month %in% seq(8, 10, 1)][,startmonth := min(month)] # also a toss-up, but I'm keeping fall because there is some spatial overlap with ns-ibts, so this keeps them more distinct 
scs_raw <-raw[survey=='SCS' & month %in% seq(6,8, 1)][,startmonth := min(month)] 
seus_raw <-raw[survey=='SEUS' & month %in% seq(4,5, 1)][,startmonth := min(month)] # approx equal hauls in spring, summer, and fall; keeping spring because we don't have many spring surveys 
swc_ibts_raw <-raw[survey=='SWC-IBTS' & month %in% c(1, 2, 3)][,startmonth := min(month)] 

# trim these surveys out of raw, leaving only the surveys that didn't need trimming because they only have samples in 3 or fewer months (be careful that those surveys aren't winter surveys including Dec and Jan, in which case the startmonth code below will be wrong -- in this case they're all summer/fall surveys)
raw <- raw[!survey %in% c('BITS','EBS','EVHOE','FR-CGFS','GMEX','GOA','IE-IGFS','NS-IBTS','NEUS','NIGFS','Nor-BTS','SCS','SEUS','SWC-IBTS')]

# get start months for remaining surveys
raw[,startmonth := min(month), by=survey]

# add special cases back in 
raw <- rbind(raw, bits_raw, ebs_raw, evhoe_raw, fr_cgfs_raw, gmex_raw, goa_raw, ie_igfs_raw, ns_ibts_raw, neus_raw, nigfs_raw, nor_bts_raw, scs_raw, seus_raw, swc_ibts_raw)

# update haulinfo 
haul_info <- copy(haul_info)[haul_id %in% raw$haul_id]
# haul_info %<>% merge(unique(raw[,.(survey, startmonth)]), all.x=TRUE, by="survey") # this gets added to raw so don't need to put it in haul_info, they're merged at the end anyway

# STANDARDIZE SURVEY FOOTPRINTS 

FishGlob <- copy(raw)[,longitude_s := ifelse(longitude > 180,(longitude-360),(longitude))]

#delete if NA for longitude or latitude
FishGlob <- FishGlob[complete.cases(FishGlob[,.(longitude, latitude)])]
FishGlob_nor <- FishGlob[survey=='Nor-BTS']
FishGlob_else <- FishGlob[!survey=='Nor-BTS']
rm(FishGlob)

#set up grid
dggs8 <- dgconstruct(res = 8, metric = T) #with res = 8, we will need at least 3 observations per year within 7,774.2 km^2 (roughly size of some NEUS strata)
dggs7 <- dgconstruct(res = 7, metric = T) # for Norway only 

#pull out unique lat lons and get grid cells
unique_latlon_nor <- unique(FishGlob_nor[,.(latitude, longitude_s)])
unique_latlon_else <- unique(FishGlob_else[,.(latitude, longitude_s)])
unique_latlon_else[,cell := dgGEO_to_SEQNUM(dggs8, longitude_s, latitude)] #get corresponding grid cells for this region/survey combo
unique_latlon_nor[,cell := dgGEO_to_SEQNUM(dggs7, longitude_s, latitude)] #get corresponding grid cells for this region/survey combo

#find cell centers
cellcenters_else <- dgSEQNUM_to_GEO(dggs8, unique_latlon_else[,cell])
cellcenters_nor <- dgSEQNUM_to_GEO(dggs7, unique_latlon_nor[,cell])

#linking cell centers to unique_latlon
unique_latlon_else[,cell_center_longitude_s := cellcenters_else$lon_deg][,cell_center_latitude:= cellcenters_else$lat_deg]
unique_latlon_nor[,cell_center_longitude_s := cellcenters_nor$lon_deg][,cell_center_latitude:= cellcenters_nor$lat_deg]

#link centers back to main data table
FishGlob_else.dg <- merge(FishGlob_else, unique_latlon_else, by = c("latitude", "longitude_s"), all.x = TRUE)
FishGlob_else.dg$dggs <- "8"
FishGlob_nor.dg <- merge(FishGlob_nor, unique_latlon_nor, by = c("latitude", "longitude_s"), all.x = TRUE)
FishGlob_nor.dg$dggs <- "7"

FishGlob.dg <- rbind(FishGlob_else.dg, FishGlob_nor.dg)

# check that they have the same number of rows and replace raw with the data.table that has spatial standardization columns
if(nrow(FishGlob.dg==nrow(raw))){
  raw <- copy(FishGlob.dg)
  rm(FishGlob.dg)
}

# make a list of all unique year x cell x survey 

# iterate over regions because some surveys fall in the same cells 
survs <- raw[, unique(survey)]
year_cell_count.dt <- NULL
for(i in 1:length(survs)) {
  tmp <- raw[survey==survs[i]]
  cell_years <- as.data.table(expand.grid(cell = unique(tmp$cell), 
                                          year = unique(tmp$year)))
  cell_years$survey <- survs[i]
  year_cell_count.dt <- rbind(year_cell_count.dt, cell_years)
}

# calc num hauls per year x cell x survey, then merge to full list
temp <- raw[, .(nhaul = length(unique(haul_id))), by = .(cell, year, survey)]
year_cell_count.dt <- merge(year_cell_count.dt, temp, all.x = TRUE)
year_cell_count.dt[is.na(nhaul), nhaul := 0] # fill in for year x cell x survey that aren't present
# year_cell_count.dt[, years_sampled := uniqueN(year[nhaul>0]), by=.(survey, cell)] # count up years when there were samples 
# year_cell_count.dt[, prop_sampled := years_sampled / length(unique(year)), by=survey]
# year_cell_count.dt[, years_missing := length(unique(year)) - years_sampled, by=survey]
# year_cell_count.dt[, survcell := paste0(survey, cell)]
# length(unique(year_cell_count.dt$survcell)) # 1159
# moop <- copy(year_cell_count.dt)[prop_sampled>=0.9]

year_cell_count.dt[, max_years := length(unique(year)), by=survey]
year_cell_count_summ <- year_cell_count.dt[nhaul>0, .(sampled_years = length(unique(year))), by=c("cell","survey","max_years")]
year_cell_count_summ[, prop_sampled := sampled_years / max_years]
ggplot(year_cell_count.dt[, .(nhauls = sum(nhaul)), by=c("year","survey")]) +
  geom_line(aes(x=year, y=nhauls)) +
  facet_wrap(~survey)

# figure out how many cells would be dropped by trimming to those sampled in every year 
trim.dt <- NULL
for(i in 1:length(survs)){
  summtmp <- year_cell_count_summ[survey==survs[i]]
  dttmp <- year_cell_count.dt[survey==survs[i]]
 # print(paste0("In region ",survs[i]," keeping cells sampled in 100% of years would keep ",length(unique(summtmp[prop_sampled==1]$cell))," of ",length(unique(summtmp$cell))," cells and ",sum(dttmp[cell %in% summtmp[prop_sampled==1]$cell]$nhaul)," of ",sum(dttmp$nhaul)," hauls"))
  year_cell_count.dt[survey == survs[i] & cell %in% summtmp[prop_sampled==1]$cell, keep_100 := TRUE]
  year_cell_count.dt[survey == survs[i] & !cell %in% summtmp[prop_sampled==1]$cell, keep_100 := FALSE]
  year_cell_count.dt[survey == survs[i] & cell %in% summtmp[prop_sampled>=0.95]$cell, keep_95 := TRUE]
  year_cell_count.dt[survey == survs[i] & !cell %in% summtmp[prop_sampled>=0.95]$cell, keep_95 := FALSE]
  year_cell_count.dt[survey == survs[i] & cell %in% summtmp[prop_sampled>=0.9]$cell, keep_90 := TRUE]
  year_cell_count.dt[survey == survs[i] & !cell %in% summtmp[prop_sampled>=0.9]$cell, keep_90 := FALSE] 
  trim.dt <- rbind(trim.dt, copy(year_cell_count.dt[survey==survs[i]])[, .(ncells = length(unique(cell)), nyears = length(unique(year)), 
                                                            prop_cells_100 = length(unique(summtmp[prop_sampled==1]$cell))/length(unique(cell)),
                                                            prop_cells_95 = length(unique(summtmp[prop_sampled>=0.95]$cell))/length(unique(cell)),
                                                            prop_cells_90 = length(unique(summtmp[prop_sampled>=0.9]$cell))/length(unique(cell)),
                                                            prop_hauls_100 = sum(year_cell_count.dt[survey==survs[i] & cell %in% summtmp[prop_sampled==1]$cell]$nhaul)/sum(nhaul),
                                                            prop_hauls_95 = sum(year_cell_count.dt[survey==survs[i] & cell %in% summtmp[prop_sampled>=0.95]$cell]$nhaul)/sum(nhaul),
                                                            prop_hauls_90 = sum(year_cell_count.dt[survey==survs[i] & cell %in% summtmp[prop_sampled>=0.9]$cell]$nhaul)/sum(nhaul)),by=survey])
}

# explore Norway missingness 
# boop <- FishGlob_nor.dg[, .(nhaul = length(unique(haul_id))), by=.(cell_center_longitude_s, cell_center_latitude, cell)]
# boop <- merge(boop, summtmp, by="cell", all.x=TRUE)
# ggplot() + geom_point(data=boop, aes(x=cell_center_longitude_s, y=cell_center_latitude, fill=nhaul, color=nhaul),size=1) + scale_color_viridis_c() + scale_fill_viridis_c() + geom_polygon(data=map_data("world"), aes(x=long, y=lat,group=group)) + coord_cartesian(xlim=c(-21, 71), ylim=c(60, 85))
# moop <- year_cell_count.dt[survey=='Nor-BTS']
# moop %<>% merge(., unique(unique_latlon_nor[, .(cell, cell_center_longitude_s, cell_center_latitude)]), by="cell", keep.x='TRUE')
# moop[.(nhaul = 0, to = NA), on = "nhaul", nhaul := i.to] # recode zeros to NAs for plotting
# ggplot() + geom_point(data=moop, aes(x=cell_center_longitude_s, y=cell_center_latitude, fill=nhaul),size=1.5, shape=21) + geom_polygon(data=map_data("world"), aes(x=long, y=lat,group=group)) + coord_cartesian(xlim=c(-21, 71), ylim=c(60, 85)) + facet_wrap(~year) + scale_fill_gradient(low="lightskyblue",high="firebrick3", na.value="white")
# 

# loop through each survey. Couldn't figure out how to do this without a loop.
# plots <- vector('list', length(survs))
# for(i in 1:length(survs)){
#   # trim to this survey
#   thisyearcellcount <- year_cell_count.dt[survey == survs[i],]
# 
#   # calculate the most to least sampled cells and years
#   year_order <- thisyearcellcount[nhaul >0, .(ncell = length(unique(cell))),
#                                   by = year][ncell >0,][order(ncell),]
#   cell_order <- thisyearcellcount[nhaul > 0, .(nyear = length(unique(year))),
#                                   by = cell][nyear >0,][order(nyear),]
# 
#   # set the factor order by ave number of hauls
#   thisyearcellcount[, year := factor(year, levels = year_order$year)]
#   thisyearcellcount[, cell := factor(cell, levels = cell_order$cell)]
# 
#   # calculate num missing cells x years for different thresholds. slow.
#   cutoffs <- data.table(expand.grid(year = levels(thisyearcellcount$year), cell = levels(thisyearcellcount$cell)))
#   cutoffs[, ':='(ntot = NA_integer_, nmiss = NA_integer_, nkeep = NA_integer_)]
#   nyr <- length(unique(cutoffs$year))
#   ncl <- length(unique(cutoffs$cell))
#   for(j in 1:nyr){
#     for(k in 1:ncl){
#       # ranks cell*year combinations by missingness 
#       thisntot <- thisyearcellcount[cell %in% levels(cell)[k:ncl] & year %in% levels(year)[j:nyr], .N]
#       thisnmiss <- thisyearcellcount[cell %in% levels(cell)[k:ncl] & year %in% levels(year)[j:nyr], sum(nhaul == 0)]
#       thisnkeep <- thisyearcellcount[cell %in% levels(cell)[k:ncl] & year %in% levels(year)[j:nyr], sum(nhaul > 0)]
#       cutoffs[cell == thisyearcellcount[, levels(cell)[k]] &
#                 year == thisyearcellcount[,levels(year)[j]],
#               ':='(ntot = thisntot, nmiss = thisnmiss, nkeep = thisnkeep)]
#     }
#   }
# 
#   # choose a threshold
#   chosencutoffs0 <- cutoffs[nmiss==0,][nkeep == max(nkeep),] # based on nothing missing
#   chosencutoffs02 <- cutoffs[nmiss/ntot < 0.02,][nkeep == max(nkeep),] # based on <2% missing
# 
# 
# # print out the cells and years to keep
# print(paste0('For ', survs[i], ' 0% missing'))
# print(paste0('Keep these years:',
#              paste0(thisyearcellcount[, levels(year)[(as.numeric(chosencutoffs0$year)+1):nyr]], collapse=',')))
# print(paste0('Keep these cells:',
#              paste0(thisyearcellcount[, levels(cell)[(as.numeric(chosencutoffs0$cell)+1):ncl]], collapse = ',')))
# print(paste0('Drop these years:',
#              paste0(thisyearcellcount[, levels(year)[1:as.numeric(chosencutoffs0$year)]], collapse=',')))
# print(paste0('Drop these cells:',
#              paste0(thisyearcellcount[, levels(cell)[1:as.numeric(chosencutoffs0$cell)]], collapse = ',')))
# 
# print(paste0('For ', survs[i], ' 2% missing'))
# print(paste0('Keep these years:',
#              paste0(thisyearcellcount[, levels(year)[(as.numeric(chosencutoffs02$year)+1):nyr]], collapse = ',')))
# print(paste0('Keep these cells:',
#              paste0(thisyearcellcount[, levels(cell)[(as.numeric(chosencutoffs02$cell)+1):ncl]], collapse = ',')))
# print(paste0('Drop these years:',
#              paste0(thisyearcellcount[, levels(year)[1:as.numeric(chosencutoffs02$year)]], collapse=',')))
# print(paste0('Drop these cells:',
#              paste0(thisyearcellcount[, levels(cell)[1:as.numeric(chosencutoffs02$cell)]], collapse = ',')))
# 
#   #make plot
#   plots[[i]] <- ggplot(thisyearcellcount[nhaul > 0,], aes(year, cell, color = nhaul)) +
#     geom_point() +
#     theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1, size = 4),
#           axis.text.y = element_text(size = 5)) +
#     labs(title = survs[i]) +
#     geom_vline(xintercept = chosencutoffs0[, as.numeric(year)], color = 'red') +
#     geom_hline(yintercept = chosencutoffs0[, as.numeric(cell)], color = 'red') +
#     geom_vline(xintercept = chosencutoffs02[, as.numeric(year)], color = 'purple') +
#     geom_hline(yintercept = chosencutoffs02[, as.numeric(cell)], color = 'purple')
# }

# plots
#do.call("grid.arrange", c(plots, ncol=5))

##########
# cut down raw to the good hauls in haul_info, and expand with zeros
##########
haul_info %<>% merge(unique(raw[,.(haul_id, cell)]), by="haul_id", all.x=TRUE) # add cell column; could add other cell attributes here if wanted
haul_info %<>% merge(year_cell_count.dt, by=c("cell","year","survey"), all.x=TRUE) # get keep_90 column
haul_info <- haul_info[keep_90==TRUE] # get hauls that pass spatial standardization filter 

raw <- copy(raw)[, .(survey, haul_id, wgt_cpue, accepted_name, startmonth)][haul_id %in% haul_info$haul_id] # trim to only taxon-level data for speed (but note there is a full taxonomy available, and other catch data), and to hauls in haul_info

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
fwrite(trim.dt, here("processed-data","spatial_standardization_summary.csv"))
