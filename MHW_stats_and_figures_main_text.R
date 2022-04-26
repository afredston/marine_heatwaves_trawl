###########
# load data and packages
###########

# general data wrangling 
library(tidyverse)
library(here)
library(lubridate) # for standardizing date format of MHW data
library(data.table)
library(googledrive)

# formatting 
# library(kableExtra)
library(gridExtra)
library(patchwork)
library(cowplot)
library(pals)
library(ggforce)

# modeling 
library(broom)
library(pwr)
library(mgcv)
library(lme4)

# making maps 
library(sf)
library(rnaturalearth)
library(ggrepel)
library(rgdal)
library(raster)
library(sp)
library(rnaturalearthdata)
library(rgeos)
library(geosphere)  #to calculate distance between lat lon of grid cells
library(concaveman)
library("robinmap")

#library(mcp)
#library(rjags)
#library(segmented)
# load data
#library(knitr)
select <- dplyr::select

# marine heatwave data for joining with survey data
mhw_summary_sat_sst_any <- read_csv(here("processed-data","mhw_satellite_sst.csv")) # MHW summary stats from satellite SST record, using any anomaly as a MHW
mhw_summary_sat_sst_5_day <- read_csv(here("processed-data","mhw_satellite_sst_5_day_threshold.csv")) # MHW summary stats from satellite SST record, defining MHWs as events >=5 days
mhw_summary_soda_sst <-  read_csv(here("processed-data","mhw_soda_sst.csv")) # modeled SST from SODA
mhw_summary_soda_sbt <-  read_csv(here("processed-data","mhw_soda_sbt.csv")) # modeled SBT from SODA

# calendar year MHW data for plotting
# mhw_cal_yr_sat_sst_5_day <- read_csv(here("processed-data","MHW_calendar_year_satellite_sst_5_day_threshold.csv"))
# mhw_cal_yr_soda_sst <- read_csv(here("processed-data","MHW_calendar_year_soda_sst.csv"))
# mhw_cal_yr_soda_sbt <- read_csv(here("processed-data","MHW_calendar_year_soda_sbt.csv"))

# survey data 
survey_summary <-read_csv(here("processed-data","survey_biomass_with_CTI.csv"))
survey_spp_summary <- read_csv(here("processed-data","species_biomass_with_CTI.csv")) %>% 
  rename('spp'=accepted_name)
survey_start_times <- read_csv(here("processed-data","survey_start_times.csv"))
coords_dat <- read_csv(here("processed-data","survey_coordinates.csv"))
haul_info <- read_csv(here("processed-data","haul_info.csv")) %>% filter(!survey=='AI')
med_lat <- haul_info %>% group_by(survey) %>% summarise(med_lat = median(latitude))
survey_names <- data.frame(survey=c("BITS",'DFO-QCS',  "EBS","EVHOE","FR-CGFS","GMEX", "GOA",'GSL-S',  "IE-IGFS", "NEUS",  "NIGFS", "Nor-BTS",  "NS-IBTS", 
                                    "PT-IBTS","SCS",
                                    "SEUS",  "SWC-IBTS","WCANN"), title=c('Baltic Sea','Queen Charlotte Sound','Eastern Bering Sea','France','English Channel','Gulf of Mexico','Gulf of Alaska','Gulf of Saint Lawrence','Ireland','Northeast US','Northern Ireland','Norway','North Sea','Portugal','Maritimes','Southeast US','Scotland','West Coast US'))

# map data 
haul_info_map <- fread(here::here("processed-data","haul_info.csv"))[!survey=='AI']

######
# stats 
######

# T-tests and power analysis

wt_no_mhw <- survey_summary %>% 
  inner_join(mhw_summary_sat_sst_5_day, by="ref_yr") %>% 
  filter(mhw_yes_no == "no", !is.na(wt_mt_log)) %>%
  pull(wt_mt_log)
wt_mhw <- survey_summary %>% 
  inner_join(mhw_summary_sat_sst_5_day, by="ref_yr") %>% 
  filter(mhw_yes_no == "yes", !is.na(wt_mt_log)) %>%
  pull(wt_mt_log)
t.test(wt_mhw, wt_no_mhw)
pwr.t2n.test(n1 = length(wt_mhw), n2= length(wt_no_mhw), d = 0.1, sig.level = 0.05, power = NULL, alternative="two.sided")
pwr.t.test(n = NULL, d = 0.1, sig.level = 0.05, power = 0.8, type="one.sample") 
pwr.t.test(n = 200, d = NULL, sig.level = 0.05, power = 0.8, type="one.sample") 

cti_no_mhw <- survey_summary %>% 
  inner_join(mhw_summary_sat_sst_5_day, by="ref_yr") %>% 
  filter(mhw_yes_no == "no", !is.na(cti_log)) %>%
  pull(cti_log)
cti_mhw <- survey_summary %>% 
  inner_join(mhw_summary_sat_sst_5_day, by="ref_yr") %>% 
  filter(mhw_yes_no == "yes", !is.na(cti_log)) %>%
  pull(cti_log)
t.test(cti_no_mhw, cti_mhw)


# models to explain biomass and CTI change 

modeldat <- survey_summary %>% 
  inner_join(mhw_summary_sat_sst_5_day, by="ref_yr") %>% 
  filter(!is.na(wt_mt_log), !is.na(anom_days)) %>% 
  left_join(med_lat) %>% 
  mutate(
    wt_mt_log_scale = as.numeric(scale(wt_mt_log, center=TRUE, scale=TRUE)),
    cti_log_scale =  as.numeric(scale(cti_log, center=TRUE, scale=TRUE)),
    anom_days_scale =  as.numeric(scale(anom_days, center=TRUE, scale=TRUE)),
    med_lat_scale =  as.numeric(scale(med_lat, center=TRUE, scale=TRUE)),
    depth_wt_scale =  as.numeric(scale(depth_wt, center=TRUE, scale=TRUE))
  )

# models of biomass and MHWs to compare 

# LM of MHW duration on biomass
wt_lm <- lm(wt_mt_log_scale ~ anom_days_scale, data = modeldat)

# LMEM of MHW duration on biomass
wt_lme <- lmer(wt_mt_log_scale ~ anom_days_scale + 1|survey, data = modeldat)

# GAM of MHW duration on biomass
wt_gam <- gam(wt_mt_log_scale ~ s(anom_days_scale), data = modeldat )

# GAM of MHW duration on biomass with a random effect
wt_gam_re <- gam(wt_mt_log_scale ~ s(anom_days_scale) + s(survey, bs="re"), data = modeldat  %>% mutate(survey = as.factor(survey)))

# lagged effects of MHW duration on biomass 
lags <- modeldat %>% 
  group_by(survey) %>% 
  arrange(year) %>% 
  mutate(lag1 = lag(anom_days_scale, 1),
         lag2 = lag(anom_days_scale, 2),
         lag3 = lag(anom_days_scale, 3),
         lag4 = lag(anom_days_scale, 4)) %>% 
  ungroup() %>% 
  select(wt_mt_log_scale, anom_days_scale, lag1, lag2, lag3, lag4)

mlag0 <- function(dat){
  gam( wt_mt_log_scale ~ s(as.matrix(dat)[,2:2]), data=dat ) # regular GAM
}
mlag1 <- function(dat){
  gam( wt_mt_log_scale ~ s(as.matrix(dat)[,2:3]), data=dat )
}
mlag2 <- function(dat){
  gam( wt_mt_log_scale ~ s(as.matrix(dat)[,2:4]), data=dat )
}
mlag3 <- function(dat){
  gam( wt_mt_log_scale ~ s(as.matrix(dat)[,2:5]), data=dat )
}
mlag4 <- function(dat){
  gam( wt_mt_log_scale ~ s(as.matrix(dat)[,2:6]), data=dat )
}
wt_gam_lag1 = mlag1(lags)
wt_gam_lag2 = mlag2(lags)
wt_gam_lag3 = mlag3(lags)
wt_gam_lag4 = mlag4(lags)

# breakpoint regression 
model = list(
  wt_mt_log_scale ~ 1 + anom_days_scale,
  ~ 0 +anom_days_scale
)
wt_bp = mcp(model, data=modeldat)

# compare all biomass models 
AIC(wt_lm, wt_lme, wt_gam, wt_gam_re, wt_gam_lag1, wt_gam_lag2, wt_gam_lag3, wt_gam_lag4)

# lagged effects of MHW duration on biomass, by survey 
wt_gam_lag_surv <- NULL
for(i in unique(modeldat$survey)){
  tmp <- modeldat %>% 
    filter(survey==i) %>% 
    arrange(year) %>% 
    mutate(lag1 = lag(anom_days_scale, 1),
           lag2 = lag(anom_days_scale, 2),
           lag3 = lag(anom_days_scale, 3)) %>% 
    ungroup() %>% 
    select(wt_mt_log_scale, anom_days_scale, lag1, lag2, lag3)
  
  # manual stop for regions where GAM throws this error without decreasing df:
  #  Error in smooth.construct.tp.smooth.spec(object, dk$data, dk$knots) : 
  # A term has fewer unique covariate combinations than specified maximum degrees of freedom 
  if(i %in% c('FR-CGFS','GOA','DFO-QCS','WCANN','PT-IBTS','NIGFS')){
    tmp0 <- cbind(glance(  gam( wt_mt_log_scale ~ s(as.matrix(tmp)[,2:2], k=3), data=tmp )
    ), 'survey'=i,'model'='mlag0',kreduce = TRUE)    
    tmp1 <- cbind(glance(  gam( wt_mt_log_scale ~ s(as.matrix(tmp)[,2:3], k=3), data=tmp )
    ), 'survey'=i,'model'='mlag1',kreduce = TRUE)    
    tmp2 <- cbind(glance(  gam( wt_mt_log_scale ~ s(as.matrix(tmp)[,2:4], k=3), data=tmp )
    ), 'survey'=i,'model'='mlag2',kreduce = TRUE)    
    tmp3 <- cbind(glance(  gam( wt_mt_log_scale ~ s(as.matrix(tmp)[,2:5], k=3), data=tmp )
    ), 'survey'=i,'model'='mlag3',kreduce = TRUE)
  } else{
    
    tmp0 <- cbind(glance(mlag0(tmp)), 'survey'=i,'model'='mlag0',kreduce = FALSE)
    tmp1 <- cbind(glance(mlag1(tmp)), 'survey'=i,'model'='mlag1',kreduce = FALSE)
    tmp2 <- cbind(glance(mlag2(tmp)), 'survey'=i,'model'='mlag2',kreduce = FALSE)
    tmp3 <- cbind(glance(mlag3(tmp)), 'survey'=i,'model'='mlag3',kreduce = FALSE)
  }
  wt_gam_lag_surv <- rbind(wt_gam_lag_surv, tmp0, tmp1, tmp2, tmp3)
}
ggplot(wt_gam_lag_surv) +
  geom_col(aes(x=survey, y=AIC, color=model, group=model, fill=model), position="dodge") +
  scale_color_brewer(palette=8, type="seq") + 
  scale_fill_brewer(palette=8, type="seq") +
  theme_bw()
write_csv(wt_gam_lag_surv, here('processed-data','lag_gam_summary.csv'))

# LM of MHW duration on CTI (MHW-years only)
summary(lm(cti_log_scale ~ anom_days_scale, data = modeldat %>% filter(!is.na(cti_log_scale), mhw_yes_no=="yes") ))

# LMEM of MHW duration on CTI (MHW-years only)
summary(lmer(cti_log_scale ~ anom_days_scale + 1|survey, data = modeldat %>% filter(!is.na(cti_log_scale), mhw_yes_no=="yes")))

# LM of MHW duration on depth (MHW-years only)
summary(lm(depth_wt_scale ~ anom_days_scale, data = modeldat %>% filter(mhw_yes_no=="yes")))

# LM of MHW duration + latitude on biomass 
summary(lm(wt_mt_log_scale ~ anom_days_scale + med_lat_scale + med_lat_scale * anom_days_scale, data = modeldat))
summary(lm(wt_mt_log_scale ~ anom_days_scale + med_lat_scale, data = modeldat))

# Define the model
# model = list(
#   wt_mt_log ~ 1 + anom_days, 
#   ~ 0 +anom_days
# )
# fit = mcp(model, data=modeldat)
# 
# plot(fit)
# 
# model_null = list(
#   wt_mt_log ~ 1 + anom_days
# )
# fit_null = mcp(model_null, data=modeldat)
# plot(fit_null)
# 
# fit$loo = loo(fit)
# fit_null$loo = loo(fit_null)
# 
# loo::loo_compare(fit$loo, fit_null$loo)
# 
# my.lm <- lm(wt_mt_log ~ anom_days, data = modeldat)
# my.seg1 <- segmented(my.lm, seg.Z = ~ anom_days, npsi=1)
# # my.seg2 <- segmented(my.lm, seg.Z = ~ anom_days, npsi=2)
# # my.seg3 <- segmented(my.lm, seg.Z = ~ anom_int, psi = c(0.25, 0.5, 0.75), npsi=3)
# # AIC(my.lm, my.seg1, my.seg2, my.seg3)
# AIC(my.lm, my.seg1)$AIC - min(AIC(my.lm, my.seg1)$AIC)
# # 
# my.fitted <- fitted(my.seg1)
# my.model <- data.frame(anom_days = modeldat$anom_days, wt_mt_log = my.fitted)
# 
# my.lm.abs <- lm(abs(wt_mt_log) ~ anom_days, data = modeldat)
# my.seg1.abs <- segmented(my.lm.abs, seg.Z = ~ anom_days, npsi=1)
# my.fitted.abs <- fitted(my.seg1.abs)
# my.model.abs <- data.frame(anom_days = modeldat$anom_days, wt_mt_log_abs = my.fitted.abs)
# 
# my.lm.int <- lm(wt_mt_log ~ anom_int, data = modeldat)
# my.seg1.int <- segmented(my.lm.int, seg.Z = ~ anom_int, npsi=1)
# my.fitted.int <- fitted(my.seg1.int)
# my.model.int <- data.frame(anom_int = modeldat$anom_int, wt_mt_log = my.fitted.int)
# AIC(my.lm.int, my.seg1.int)
# 
# 
# my.lm.cti <- lm(cti_log ~ anom_days, data = modeldat)
# my.seg1.cti <- segmented(my.lm.cti, seg.Z = ~ anom_days, npsi=1)
# my.fitted.cti <- fitted(my.seg1.cti)
# my.model.cti <- data.frame(anom_days = modeldat$anom_days, cti_log = my.fitted.cti)
# AIC(my.lm.cti, my.seg1.cti)


######
# figures
######

# map
# get MHW columns 
map_prep <- mhw_summary_sat_sst_5_day %>% 
  group_by(survey) %>% 
  summarise(class = ifelse(max(anom_days<50)))

#if positive, subtract 360
haul_info_map[,longitude_s := ifelse(longitude > 150,(longitude-360),(longitude))]

#delete if NA for longitude or latitude
haul_info_map.r <- haul_info_map[complete.cases(haul_info_map[,.(longitude, latitude)])]

haul_info.r.split <- split(haul_info_map.r, haul_info_map.r$survey)
haul_info.r.split.sf <- lapply(haul_info.r.split, st_as_sf, coords = c("longitude", "latitude"))
haul_info.r.split.concave <- lapply(haul_info.r.split.sf, concaveman, concavity = 3, length_threshold = 2)
haul_info.r.split.concave.binded <- do.call('rbind', haul_info.r.split.concave)
haul_info.r.split.concave.binded.spdf <- as_Spatial(haul_info.r.split.concave.binded)

haul_info.r.split.concave.binded.spdf$survey <- levels(as.factor(haul_info_map.r[!haul_info_map.r$survey=='AI',]$survey))

# get other objects needed for map plot 
survey_palette <- c("#AAF400","#B5EFB5","#F6222E","#FE00FA", 
                    "#16FF32","#3283FE","#FEAF16","#B00068", 
                    "#1CFFCE","#90AD1C","#2ED9FF","#DEA0FD", 
                    "#AA0DFE","#F8A19F","#325A9B","#C4451C", 
                    "#1C8356","#66B0FF")
x_lines <- seq(-120,180, by = 60)

data("wrld_simpl", package = "maptools")                                                                            
wm_polar <- crop(wrld_simpl, extent(-180, 180, 22, 90))  

survey_regions_polar_polygon <- ggplot() +
  geom_polygon(data = haul_info.r.split.concave.binded.spdf,
               aes(x = long, y = lat, group = group, fill = group, color = group),
               alpha = 0.8) +
  scale_color_manual(values = survey_palette) +
  scale_fill_manual(values = survey_palette)  +
  geom_polygon(data = wm_polar, aes(x = long, y = lat, group = group), fill = "azure4", 
               # colour = "black"
               #,
               # alpha = 0.8
  ) +
  
  # Adds axes
  geom_hline(aes(yintercept = 22), size = 1)  +
  geom_segment(aes(y = 22, yend = 90, x = x_lines, xend = x_lines), linetype = "dashed", alpha = 0.3) +
  
  # Convert to polar coordinates
  coord_map("ortho", orientation = c(50, -50, -20)) +
  scale_y_continuous(breaks = seq(0, 90, by = 5), labels = NULL) +
  
  #axis
  geom_text(aes(x = x_lines, y = 15, label = c("120°W", "60°W", "0°", "60°E", "120°E", "180°W"))) +
  
  # Change theme to remove axes and ticks
  theme_classic() +
  theme(axis.text = element_blank(), axis.title = element_blank(),
        axis.line = element_blank(), axis.ticks = element_blank(),
        legend.position = "none")

#save global map
ggsave(survey_regions_polar_polygon, path = here::here("figures"),
       filename = "survey_regions_polar_polygon.jpg",height = 5, width = 6, unit = "in")

# map color-coded by MHW duration and biomass response 
# check that there are no years tied for longest MHWs
survey_summary %>% 
  left_join(mhw_summary_sat_sst_5_day) %>% 
  group_by(survey) %>% 
  summarise(max_mhw=max(anom_days, na.rm = TRUE)) %>% 
  arrange(survey)

# generate columns for map fill
mapfill <- survey_summary %>% 
  left_join(mhw_summary_sat_sst_5_day) %>% 
  group_by(survey) %>% 
  mutate(max_mhw=max(anom_days, na.rm = TRUE),
         sd = sd(wt_mt_log, na.rm=TRUE)) %>% 
  filter(anom_days == max_mhw) %>% 
  mutate(case = case_when(
    abs(wt_mt_log) < 0.1 & anom_days<50 ~ "low_null",
    abs(wt_mt_log) < 0.1 & anom_days>=50 ~ "high_null",
    wt_mt_log >= 0.1 & anom_days<50 ~ "low_gain",
    wt_mt_log >= 0.1 & anom_days>=50 ~ "high_gain",
    wt_mt_log <= -0.1 & anom_days<50 ~ "low_loss",
    wt_mt_log <= -0.1 & anom_days>=50 ~ "high_loss"))

# generate filled map 

haul_info_map2 <- merge(copy(haul_info_map), mapfill, all.x=TRUE, by=c("survey","year")) # get columns for map fill 

#if positive, subtract 360
haul_info_map2[,longitude_s := ifelse(longitude > 150,(longitude-360),(longitude))]

#delete if NA for longitude or latitude
haul_info_map2 <- haul_info_map2[complete.cases(haul_info_map2[,.(longitude, latitude)])]

# split_prep <- split(haul_info_map2, haul_info_map2$case)
# split_sf <- lapply(split_prep, st_as_sf, coords = c("longitude", "latitude"))
# split_conc <- lapply(split_sf, concaveman, concavity = 3, length_threshold = 2)

prep_sf <- st_as_sf(haul_info_map2, coords = c("longitude", "latitude"))
prep_conc <- concaveman(prep_sf, concavity=3, length_threshold=2)
prep_conc_sf <- as(prep_conc, "sf")
haul_info.r.split.concave.binded.spdf <- as_Spatial(haul_info.r.split.concave.binded)
prep_conc_sf$survey <- levels(as.factor(haul_info_map2$case))

boop <- st_as_sf(haul_info.r.split.concave.binded.spdf) %>% 
  left_join(mapfill)

ggplot() + 
  geom_sf(boop, mapping=aes(fill=survey, color=survey, group=survey, geometry=geometry)) +
  geom_polygon(data = wm_polar, aes(x = long, y = lat, group = group), fill = "azure4", 
               # colour = "black"
               #,
               # alpha = 0.8
  ) +
  
  # Adds axes
  geom_hline(aes(yintercept = 22), size = 1)  +
  geom_segment(aes(y = 22, yend = 90, x = x_lines, xend = x_lines), linetype = "dashed", alpha = 0.3) +
  
  # Convert to polar coordinates
  coord_map("ortho", orientation = c(50, -50, -20)) +
  scale_y_continuous(breaks = seq(0, 90, by = 5), labels = NULL)
# generate many small panels for Fig 1
for(reg in survey_names$survey) {
  tmp <- mhw_summary_sat_sst_5_day %>% 
    left_join(survey_summary %>% select(ref_yr, survey, year) %>% distinct()) %>% 
    left_join(survey_names) %>% 
    left_join(haul_info %>% group_by(survey,year) %>% summarise(n=n())) %>% 
    filter(survey==reg)
  coeff = 5 
  tmpplot <- ggplot(tmp) +
    geom_col(aes(x=year, y=n / coeff), color="gray85", fill="gray85") +
    geom_line(aes(x=year, y=anom_days, color=anom_days), size=1) + 
    scale_color_gradient(low="#1e03cd", high="#b80d06") +
    scale_y_continuous(sec.axis = sec_axis(~ . * coeff, name = "Sampling events"))+
    labs(title=tmp$title) +
    theme_bw()  +
    theme(legend.position = "none",
          axis.title.x=element_blank(),
          axis.title.y=element_blank(),
          panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          axis.text.x=element_text(angle = 45, vjust=1),
          #    axis.title.x=element_text(vjust=5),
          #    plot.title.position = "plot",
          plot.title = element_text(hjust=0.3, vjust = -7)
    )+
    NULL
  ggsave(tmpplot, filename=here("figures",paste0("inset_timeseries_",reg,".png")), height=2.5, width=3, scale=0.7, dpi=160)
  plot_crop(here("figures",paste0("inset_timeseries_",reg,".png")))
}

gg_mhw_biomass_hist <- survey_summary %>% 
  inner_join(mhw_summary_sat_sst_5_day, by="ref_yr") %>% # get MHW data matched to surveys
  mutate(mhw_yes_no = recode(mhw_yes_no, no="No Marine Heatwave", yes="Marine Heatwave")) %>% 
  ggplot(aes(x=wt_mt_log, group=mhw_yes_no, fill=mhw_yes_no, color=mhw_yes_no)) +
  geom_freqpoly(binwidth=0.1, alpha=0.8, size=2) +
  scale_color_manual(values=c("#E31A1C","#1F78B4")) +
  scale_fill_manual(values=c("#E31A1C","#1F78B4")) +
  theme_bw() + 
  labs(x="Biomass log ratio", y="Frequency") +
  theme(legend.position = "none",
        legend.title = element_blank(),
        panel.grid.major = element_blank(), panel.grid.minor = element_blank()
  )


lm.dat1 <- survey_summary %>% 
  inner_join(mhw_summary_sat_sst_5_day, by="ref_yr") %>% 
  filter(anom_days>0)
lm.final1 <- lm(wt_mt_log ~ anom_days, data = lm.dat1)
lm.predict1 <- data.frame(wt_mt_log = predict(lm.final1, lm.dat1), anom_days=lm.dat1$anom_days)

gg_mhw_biomass_point_final <- survey_summary %>% 
  inner_join(mhw_summary_sat_sst_5_day, by="ref_yr") %>% # get MHW data matched to surveys
  ggplot(aes(x=anom_days, y=wt_mt_log, group = mhw_yes_no)) +
  geom_point() +
  geom_smooth(method="lm", color = "gray35") +
  # geom_smooth(data = lm.dat1, method="lm", formula = wt_mt_log ~ anom_days, inherit.aes = FALSE, aes(x=anom_days, y=wt_mt_log)) + 
  #  geom_line(data=lm.predict1, aes(x=anom_days, y=wt_mt_log), color="darkgrey", size=1, inherit.aes = FALSE) +
  theme_bw() + 
  coord_cartesian(clip = "off") +
  labs(x="Marine heatwave duration (days)", y="Biomass log ratio") +
  geom_hline(aes(yintercept=0), linetype="dashed", color="black") +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
gg_mhw_biomass_point_final


gg_mhw_biomass_box <- survey_summary %>% 
  inner_join(mhw_summary_sat_sst_5_day, by="ref_yr") %>% # get MHW data matched to surveys
  mutate(mhw_yes_no = recode(mhw_yes_no, no="No MHW", yes="MHW")) %>% 
  ggplot(aes(x=mhw_yes_no, y=wt_mt_log, group=mhw_yes_no, color=mhw_yes_no)) +
  geom_boxplot() +
  scale_color_manual(values=c("#E31A1C","#1F78B4")) +
  # scale_fill_manual(values=c("#E31A1C","#1F78B4")) +
  theme_bw() + 
  labs(x="", y="Biomass log ratio") +
  theme(legend.position = "none", 
        panel.grid.major = element_blank(), panel.grid.minor = element_blank())
gg_mhw_biomass_box

ggsave(gg_mhw_biomass_point_final, scale=0.8, filename=here("figures","final_biomass_point.png"), width=170, height=135, units="mm")
ggsave(gg_mhw_biomass_box, scale=0.8, filename=here("figures","final_biomass_box.png"), width=50, height=50, units="mm")
ggsave(gg_mhw_biomass_hist, scale=0.8, filename=here("figures","final_biomass_hist.png"), width=50, height=50, units="mm")

reg_cti <- survey_summary %>% 
  select(CTI, ref_yr) %>% 
  distinct()

top_spp <- survey_spp_summary %>% 
  group_by(survey, spp) %>% 
  summarise(sumwt = sum(wt_mt)) %>% 
  left_join(survey_spp_summary %>% select(spp, STI) %>% distinct()) %>% 
  arrange(-sumwt) %>% 
  slice(1:10)

tax_list <- survey_spp_summary %>% 
  select(spp) %>% 
  distinct() %>% 
  pull()

sti_list <- survey_spp_summary %>% 
  filter(!is.na(STI)) %>% 
  select(spp) %>% 
  distinct() %>% 
  pull()

gg_mhw_biomass_point_spp <- survey_spp_summary %>% 
  left_join(reg_cti) %>% 
  mutate(STI_diff = STI - CTI,
         wt_mt_log = as.numeric(wt_mt_log)) %>% 
  inner_join(mhw_summary_sat_sst_5_day, by="ref_yr") %>% # get MHW data matched to surveys
  filter(!is.na(STI_diff), mhw_yes_no=="yes") %>% 
  ggplot(aes(x=STI_diff, y=wt_mt_log, color=anom_days, fill=anom_days)) +
  geom_point(size=0.5, position="jitter") + 
  scale_color_gradient(low="#1F78B4", high="#E31A1C", name="MHW duration\n(days)") +
  scale_fill_gradient(low="#1F78B4", high="#E31A1C", name="MHW duration\n(days)") +
  # geom_smooth(method="lm")+
  theme_bw() + 
  coord_cartesian(clip = "off") +
  labs(x="Species thermal bias", y="Biomass log ratio") +
  geom_hline(aes(yintercept=0), linetype="dashed", color="black") +
  geom_vline(aes(xintercept=0), linetype="dashed", color="black") +
  scale_y_continuous(limits=c(-10, 10)) +
  scale_x_continuous(limits=c(-20, 20)) +
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        legend.position="bottom",
        legend.margin=margin(t=-10)) +
  # facet_wrap(~survey) +
  NULL
gg_mhw_biomass_point_spp
ggsave(gg_mhw_biomass_point_spp, scale=0.9, filename=here("figures","final_sti_cti.png"), width=80, height=70, units="mm", dpi=300)


gg_mhw_cti_hist <- survey_summary %>%
  inner_join (mhw_summary_sat_sst_5_day, by="ref_yr") %>% # get MHW data matched to surveys 
  mutate(mhw_yes_no = recode(mhw_yes_no, no="No Marine Heatwave", yes="Marine Heatwave")) %>% 
  ggplot(aes(x=cti_log, group=mhw_yes_no, fill=mhw_yes_no, color=mhw_yes_no)) +
  geom_freqpoly(binwidth=0.05, alpha=0.8, size=2) +
  scale_color_manual(values=c("#E31A1C","#1F78B4")) +
  scale_fill_manual(values=c("#E31A1C","#1F78B4")) +
  theme_bw() + 
  labs(x="CTI log ratio", y="Frequency") +
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        legend.position = "none")
gg_mhw_cti_hist
ggsave(gg_mhw_cti_hist, scale=0.9, filename=here("figures","final_cti_hist.png"), width=50, height=50, units="mm")

######
# models and stats 
######

########
# old plots
########

gg_mhw_biomass_hist <- survey_summary %>% 
  inner_join(mhw_summary_sat_sst_5_day, by="ref_yr") %>% # get MHW data matched to surveys
  mutate(mhw_yes_no = recode(mhw_yes_no, no="No Marine Heatwave", yes="Marine Heatwave")) %>% 
  ggplot(aes(x=wt_mt_log, group=mhw_yes_no, fill=mhw_yes_no, color=mhw_yes_no)) +
  geom_freqpoly(binwidth=0.1, alpha=0.8, size=2) +
  scale_color_manual(values=c("#E31A1C","#1F78B4")) +
  scale_fill_manual(values=c("#E31A1C","#1F78B4")) +
  theme_bw() + 
  labs(x="Biomass Log Ratio", y="Frequency (Survey-Years)") +
  theme(legend.position = c(0.2,0.8),
        legend.title = element_blank())
gg_mhw_biomass_hist

gg_mhw_biomass_point <- survey_summary %>% 
  inner_join(mhw_summary_sat_sst_5_day, by="ref_yr") %>% # get MHW data matched to surveys
  ggplot(aes(x=anom_days, y=wt_mt_log, label=ref_yr)) +
  geom_point() +
  theme_bw() + 
  coord_cartesian(clip = "off") +
  labs(x="Marine Heatwave Duration (days)", y="Biomass Log Ratio") +
  geom_hline(aes(yintercept=0), linetype="dashed", color="black") 
gg_mhw_biomass_point

gg_mhw_biomass_point_labels <- survey_summary %>% 
  inner_join(mhw_summary_sat_sst_5_day, by="ref_yr") %>% # get MHW data matched to surveys
  ggplot(aes(x=anom_days, y=wt_mt_log, label=ref_yr)) +
  geom_point() +
  geom_text_repel(aes(label=ifelse(anom_days>75|abs(wt_mt_log)>1,as.character(ref_yr),'')),max.overlaps = Inf,xlim = c(-Inf, Inf), ylim = c(-Inf, Inf),min.segment.length = 0) +
  theme_bw() + 
  coord_cartesian(clip = "off") +
  labs(x="Marine Heatwave Duration (days)", y="Biomass Log Ratio") +
  geom_hline(aes(yintercept=0), linetype="dashed", color="black") 
gg_mhw_biomass_point_labels

gg_mhw_biomass_point_models <- survey_summary %>% 
  inner_join (mhw_summary_sat_sst_5_day, by="ref_yr") %>% # get MHW data matched to surveys
  ggplot(aes(x=anom_days, y=wt_mt_log)) +
  geom_point() +
  theme_bw() + 
  geom_smooth(method="lm", color="blue", se=FALSE) +
  geom_smooth(method="lm", formula = y ~ poly(x, degree=3), color="red", se=FALSE) +
  geom_smooth(method="loess", color="green", se=FALSE) +
  geom_line(data = my.model, aes(x=anom_days, y=wt_mt_log), colour = "yellow", size=1) +
  labs(x="Marine Heatwave Duration (days)", y="Biomass Log Ratio") +
  geom_hline(aes(yintercept=0), linetype="dashed", color="black") 
gg_mhw_biomass_point_models

gg_mhw_cti_point <- survey_summary %>%
  inner_join (mhw_summary_sat_sst_5_day, by="ref_yr") %>% # get MHW data matched to surveys 
  ggplot(aes(x=anom_days, y=cti_log)) +
  geom_point() +
  theme_bw() + 
  labs(x="Marine Heatwave Duration (days)", y="CTI Log Ratio") +
  geom_hline(aes(yintercept=0), linetype="dashed", color="black")
gg_mhw_cti_point

gg_mhw_cti_point_labels <- survey_summary %>%
  inner_join (mhw_summary_sat_sst_5_day, by="ref_yr") %>% # get MHW data matched to surveys 
  ggplot(aes(x=anom_days, y=cti_log)) +
  geom_point() +
  geom_text_repel(aes(label=ifelse(anom_days>75|abs(cti_log)>0.3,as.character(ref_yr),'')),max.overlaps = Inf,xlim = c(-Inf, Inf), ylim = c(-Inf, Inf),min.segment.length = 0, force=50) +
  theme_bw() + 
  labs(x="Marine Heatwave Duration (days)", y="CTI Log Ratio") +
  geom_hline(aes(yintercept=0), linetype="dashed", color="black")
gg_mhw_cti_point_labels

gg_mhw_cti_point_models <- survey_summary %>%
  inner_join (mhw_summary_sat_sst_5_day, by="ref_yr") %>% # get MHW data matched to surveys 
  ggplot(aes(x=anom_days, y=cti_log)) +
  geom_point() +
  geom_smooth(method="lm", color="blue", se=FALSE) +
  geom_line(data = my.model.cti, aes(x=anom_days, y=cti_log), colour = "yellow", size=1) +
  theme_bw() + 
  labs(x="Marine Heatwave Duration (days)", y="CTI Log Ratio") +
  geom_hline(aes(yintercept=0), linetype="dashed", color="black")
gg_mhw_cti_point_models

mhw_panel_fig <- grid.arrange(gg_mhw_biomass_hist, gg_mhw_biomass_point, gg_mhw_cti_hist, gg_mhw_cti_point, ncol=2, nrow=2)
# ggsave(mhw_panel_fig, scale=1.5, dpi=300, width=5, height=3.5, filename=here("figures","mhw_panel_figure.png"))

gg_mhw_cti_point_int <- survey_summary %>%
  inner_join (mhw_summary_sat_sst_5_day, by="ref_yr") %>% # get MHW data matched to surveys 
  ggplot(aes(x=anom_int, y=cti_log)) +
  geom_point() +
  geom_text_repel(aes(label=ifelse(anom_int>0.75|abs(cti_log)>0.3,as.character(ref_yr),'')),max.overlaps = Inf,xlim = c(-Inf, Inf), ylim = c(-Inf, Inf),min.segment.length = 0, force=50) +
  theme_bw() + 
  labs(x="Marine Heatwave Cumulative Mean Intensity", y="CTI Log Ratio") +
  geom_hline(aes(yintercept=0), linetype="dashed", color="black")
gg_mhw_cti_point_int

ggsave(gg_mhw_biomass_hist, scale=1.5, dpi=300, width=3, filename=here("figures","biomass_vs_mhw_hist.png"))
ggsave(gg_mhw_cti_hist, scale=1.5, dpi=300, width=3, filename=here("figures","cti_vs_mhw_hist.png"))
ggsave(gg_mhw_biomass_point, scale=1.5, dpi=300, width=4, filename=here("figures","biomass_vs_mhw_points.png"))
ggsave(gg_mhw_biomass_point_abs, scale=1.5, dpi=300, width=4, filename=here("figures","abs_biomass_vs_mhw_points.png"))
ggsave(gg_mhw_biomass_point_models, scale=1.5, dpi=300, width=4, filename=here("figures","biomass_vs_mhw_points_models.png"))
ggsave(gg_mhw_biomass_point_models_int, scale=1.5, dpi=300, width=4, filename=here("figures","biomass_vs_mhw_points_models_int.png"))
ggsave(gg_mhw_biomass_point_labels, scale=1.5, dpi=300, width=4, filename=here("figures","biomass_vs_mhw_points_labels.png"))
ggsave(gg_mhw_cti_point, scale=1.5, dpi=300, width=4, filename=here("figures","cti_vs_mhw_points.png"))
ggsave(gg_mhw_cti_point_models, scale=1.5, dpi=300, width=4, filename=here("figures","cti_vs_mhw_points_models.png"))
ggsave(gg_mhw_cti_point_labels, scale=1.5, dpi=300, width=4, filename=here("figures","cti_vs_mhw_points_labels.png"))
ggsave(gg_mhw_biomass_point_soda, scale=1.5, dpi=300, width=4, filename=here("figures","biomass_vs_bottom_mhw_points.png"))

####### NE Pacific

gg_goa <- ggplot() + 
  geom_point(data = survey_summary %>% filter(survey=="gulf_of_alaska"), aes(x=year, y=wt_mt_log), color="blue") + 
  geom_point(data = cti_sst %>% filter(survey=="gulf_of_alaska"), aes(x=year, y=ctiLog), color="red") + 
  theme_bw() +
  labs(title="GOA", y="Log Ratio") +
  scale_x_continuous(breaks=seq(1982, 2018, 2)) 
gg_goa

gg_ebs <- ggplot() + 
  geom_point(data = survey_summary %>% filter(survey=="eastern_bering_sea"), aes(x=year, y=wt_mt_log), color="blue") + 
  geom_point(data = cti_sst %>% filter(survey=="eastern_bering_sea"), aes(x=year, y=ctiLog), color="red") + 
  theme_bw() +
  labs(title="EBS", y="Log Ratio") +
  scale_x_continuous(breaks=seq(1982, 2018, 2)) 
gg_ebs


gg_goa_spp <- survey_spp_summary %>% 
  filter(survey=="gulf_of_alaska", spp %in% c("Gadus macrocephalus","Gadus chalcogrammus")) %>% 
  ggplot(aes(x=year, y=wt_mt_log, color=spp, group=spp, fill=spp)) + 
  geom_point() +
  geom_line() +
  theme_bw() +
  labs(title="GOA - Cod and Pollock", y="Log Ratio") +
  scale_x_continuous(breaks=seq(1982, 2018, 2)) +
  theme(legend.position = c(0.2,0.8))
gg_goa_spp

gg_ebs_spp <- survey_spp_summary %>% 
  filter(survey=="eastern_bering_sea", spp %in% c("Gadus macrocephalus","Gadus chalcogrammus")) %>% 
  ggplot(aes(x=year, y=wt_mt_log, color=spp, group=spp, fill=spp)) + 
  geom_point() +
  geom_line() +
  theme_bw() +
  labs(title="EBS - Cod and Pollock", y="Log Ratio") +
  scale_x_continuous(breaks=seq(1982, 2018, 2)) +
  theme(legend.position = c(0.2,0.2))
gg_ebs_spp


# try cluster analysis
tmp <- survey_summary %>% 
  inner_join(mhw_summary_sst, by="ref_yr") %>% 
  select(ref_yr, wt_mt_log, anom_int) %>% 
  data.frame(., row.names=1) %>% 
  na.omit() %>% 
  scale()
ktmp <- kmeans(tmp, centers=2)
tmp %>%
  as_tibble() %>%
  mutate(cluster = ktmp$cluster,
         ref_yr = row.names(tmp)) %>%
  ggplot(aes(wt_mt_log, anom_int, color = factor(cluster), label = ref_yr)) +
  theme_bw() +
  geom_text()

#######
# stats
#######

# what magnitude of (absolute) change followed MHWs vs non-MHWs?
survey_summary %>% 
  inner_join(mhw_summary_sat_sst_any, by="ref_yr") %>% 
  mutate(abs_wt_mt_log = abs(wt_mt_log)) %>% 
  group_by(mhw_yes_no) %>% 
  summarise(mean_abs_log_ratio = mean(abs_wt_mt_log, na.rm=TRUE))
survey_summary %>% 
  inner_join(mhw_summary_sat_sst_5_day, by="ref_yr") %>% 
  mutate(abs_wt_mt_log = abs(wt_mt_log)) %>% 
  group_by(mhw_yes_no) %>% 
  summarise(mean_abs_log_ratio = mean(abs_wt_mt_log, na.rm=TRUE))

# how much did biomass decline in the Gulf of Alaska in 2014-2016?
survey_summary %>% 
  filter(survey=="GOA") %>% 
  filter(year %in% c(2013, 2015, 2017)) %>% 
  select(year, wt_mt) %>% 
  mutate(relative_to_2013 = (wt_mt-wt_mt[1])/wt_mt[1])

# specifically for cod and pollock
survey_spp_summary %>% 
  filter(survey=="GOA", spp %in% c("Gadus macrocephalus","Gadus chalcogrammus"), year %in% c(2013, 2015, 2017)) %>% 
  select(year, spp, wt_mt) %>% 
  group_by(spp) %>% 
  arrange(year) %>% 
  mutate(relative_to_2013 = (wt_mt-wt_mt[1])/wt_mt[1]) %>% 
  ungroup()

# how much did biomass change on the West Coast?
survey_summary %>% 
  filter(survey=="WCANN") %>% 
  filter(year >= 2014) %>% 
  select(year, wt_mt) %>% 
  arrange(year) %>% 
  mutate(relative_to_2014 = (wt_mt-wt_mt[1])/wt_mt[1])

# Northeast 2012 MHW
survey_summary %>% 
  filter(survey=="NEUS") %>% 
  filter(year >= 2012) %>% 
  select(year, wt_mt) %>% 
  arrange(year) %>% 
  mutate(relative_to_2012 = (wt_mt-wt_mt[1])/wt_mt[1])

#########
# maps
#########

reg_hulls <- coords_dat %>% 
  mutate(lon = ifelse(lon>-180, lon, lon+360)) %>% # fix values in AK that are -189 etc
  filter(!survey=="Aleutian Islands") %>%  # COME BACK TO THIS AND FIX THE MAP
  st_as_sf(., coords=c('lon','lat')) %>% 
  group_by(survey) %>% 
  summarise(geometry=st_union(geometry)) %>% 
  st_convex_hull()

if(file.exists(here("processed-data","global_oceans.shp"))==TRUE){
  ocean <- st_read(here("processed-data","global_oceans.shp"))
}else{
  ocean <- ne_download(scale=110, type = 'ocean', category = 'physical', returnclass ="sf")
  st_write(ocean, here("processed-data","global_oceans.shp"))
}

# make CRS of hulls the same as ocean -- DANGER!
st_crs(reg_hulls) <- st_crs(ocean)

ggplot() +
  geom_sf(data=reg_hulls, aes(), fill="steelblue2", color="navy", alpha=0.5) +
  geom_sf(data=ocean, aes()) +
  geom_sf_text(data=reg_hulls, aes(label=survey), size=2) +
  theme_bw()


ggplot() +
  geom_sf(data=ocean, aes()) +
  geom_sf(data=reg_hulls %>% filter(survey %in% c("Eastern Bering Sea","West Coast","Northeast")), aes(), fill="steelblue2", color="navy", alpha=0.5) +
  theme_bw()


ggplot() +
  geom_sf(data=ocean, aes()) +
  geom_sf(data=reg_hulls %>% filter(survey %in% c("NorBTS","BITS",'SWC-IBTS','NS-IBTS')), aes(), fill="steelblue2", color="navy", alpha=0.5) +
  geom_sf_text(data=reg_hulls%>% filter(survey %in% c("NorBTS","BITS",'SWC-IBTS','NS-IBTS')), aes(label=survey), size=3) +
  scale_x_continuous(limits=c(-15, 60)) + 
  scale_y_continuous(limits=c(40, 90)) +
  theme_bw()


