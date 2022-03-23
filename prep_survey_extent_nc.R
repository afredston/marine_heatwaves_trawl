# code to generate a netcdf file with trawl survey footprints for comparison with MHW data 

library(ncdf4) # see https://pjbartlein.github.io/REarthSysSci/netCDF.html#create-and-write-a-netcdf-file
library(here)
library(tidyverse)
# pull in data
haul_info <- read.csv(here("processed-data","haul_info.csv")) 

# set up global 0.25x0.25 grid
nlon <- 360/0.25
nlat <- 180/0.25
dlon <- 360.0/nlon
dlat <- 180.0/nlat
worldlon <- seq(-180.0+(dlon/2),+180.0-(dlon/2),by=dlon)
worldlat <- seq(-90.0+(dlat/2),+90.0-(dlat/2),by=dlat)

# get every possible combo of grid cells
worlddf <- expand_grid(worldlon, worldlat) 
colnames(worlddf) <- c('lon','lat')

worlddf$coords <- paste0(worlddf$lon,",",worlddf$lat)

# get survey coordinates 
surveycoords <- haul_info %>% 
  select(latitude, longitude, survey) %>% 
  distinct() %>% 
  mutate(lat_round = floor(latitude*4)/4 + 0.125,
         lon_round = floor(longitude*4)/4 + 0.125) %>% 
  select(lon_round, lat_round, survey) %>% 
  distinct() %>% 
  mutate(coords=paste0(lon_round,",",lat_round)) %>% 
  select(coords, survey) %>%
  arrange(survey) %>%
  mutate(surveyID=as.numeric(factor(survey)))
write.csv(surveycoords, here("processed-data","survey_coordinates.csv"))
# save which region corresponds to which code
surveyIDs <- surveycoords %>%   
  select(surveyID, survey) %>% 
  distinct() # alphabetical ordering 
write.csv(surveyIDs,here("processed-data","trawl_survey_codes.csv"))

# merge with world coordinates 
worldsurvey <- worlddf %>% 
  left_join(surveycoords %>% select(-survey),by="coords") %>% 
  select(-coords) %>% 
  replace_na(list(surveyID=0)) # replace NAs with FALSE 

# set up nc file
ncfile <- here("processed-data","survey_extent.nc")
tunits <- "days since 1970-01-01 00:00:00.0 -0:00" 
tdummy <- "1546300800" # one time variable: january 1, 2019 -- since most of/all of our data are current through 2018

londim <- ncdim_def("lon","degrees_east",as.double(worldlon)) 
latdim <- ncdim_def("lat","degrees_north",as.double(worldlat)) 
timedim <- ncdim_def("time",tunits,as.double(tdummy))
tmp_df03 <- worldsurvey # for ease of following the linked example above
nobs <- dim(tmp_df03)[1]

# define variables
fillvalue <- 1e32
dlname <- "survey_presence"
surv_def <- ncvar_def("survey","IDs",list(londim,latdim,timedim),fillvalue,dlname,prec="single") # define survey variable
surv_array3 <- array(fillvalue, dim=c(nlon,nlat)) # create array to hold survey data 

# populate array with data 
for(i in 1:nobs) {
  
  # figure out location in the target array of the values in each row of the data frame
  j <- which.min(abs(worldlon-tmp_df03$lon[i]))
  k <- which.min(abs(worldlat-tmp_df03$lat[i]))
  
  # copy data from the data frame to array
  surv_array3[j,k] <- (tmp_df03$surveyID[i])
}

# create netCDF file and put arrays - will throw an error if file exists
ncout <- nc_create(ncfile,list(surv_def),force_v4=TRUE)

# put variables
ncvar_put(ncout,surv_def,surv_array3)

# put additional attributes into dimension and data variables
ncatt_put(ncout,"lon","axis","X")
ncatt_put(ncout,"lat","axis","Y")
ncatt_put(ncout,"time","axis","T")

# write out
nc_close(ncout)

# netcdf test 
# ncin <- nc_open(ncfile)
# dname <- "survey"
# lon <- ncvar_get(ncin,"lon")
# nlon <- dim(lon)
# lat <- ncvar_get(ncin,"lat")
# nlat <- dim(lat)
# time <- ncvar_get(ncin,"time")
# tunits <- ncatt_get(ncin,"time","units")
# nt <- dim(time)
# tmp_array <- ncvar_get(ncin,dname)
# image(lon, lat, tmp_array)