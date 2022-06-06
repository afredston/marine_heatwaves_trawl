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
library(mcp)

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
set.seed(42)

# marine heatwave data for joining with survey data
# mhw_summary_sat_sst_any <- read_csv(here("processed-data","mhw_satellite_sst.csv")) # MHW summary stats from satellite SST record, using any anomaly as a MHW
mhw_summary_sat_sst_5_day <- read_csv(here("processed-data","mhw_satellite_sst_5_day_threshold.csv")) # MHW summary stats from satellite SST record, defining MHWs as events >=5 days
mhw_summary_soda_sst <-  read_csv(here("processed-data","mhw_soda_sst.csv")) # modeled SST from SODA
mhw_summary_soda_sbt <-  read_csv(here("processed-data","mhw_soda_sbt.csv")) # modeled SBT from SODA

# calendar year MHW data for plotting
# mhw_cal_yr_sat_sst_5_day <- read_csv(here("processed-data","MHW_calendar_year_satellite_sst_5_day_threshold.csv"))
# mhw_cal_yr_soda_sst <- read_csv(here("processed-data","MHW_calendar_year_soda_sst.csv"))
# mhw_cal_yr_soda_sbt <- read_csv(here("processed-data","MHW_calendar_year_soda_sbt.csv"))

# survey data 
survey_summary <-read_csv(here("processed-data","survey_biomass_with_CTI.csv")) %>% inner_join(mhw_summary_sat_sst_5_day)
survey_spp_summary <- read_csv(here("processed-data","species_biomass_with_CTI.csv")) %>% 
  rename('spp'=accepted_name)
survey_start_times <- read_csv(here("processed-data","survey_start_times.csv"))
coords_dat <- read_csv(here("processed-data","survey_coordinates.csv"))
haul_info <- read_csv(here("processed-data","haul_info.csv")) 
survey_names <- data.frame(survey=c("BITS",'DFO-QCS',  "EBS","EVHOE","FR-CGFS","GMEX", "GOA",'GSL-S',  "IE-IGFS", "NEUS",  "NIGFS", "Nor-BTS",  "NS-IBTS", 
                                    "PT-IBTS","SCS",
                                    "SEUS",  "SWC-IBTS","WCANN"), title=c('Baltic Sea','British Columbia','Eastern Bering Sea','France','English Channel','Gulf of Mexico','Gulf of Alaska','Gulf of Saint Lawrence','Ireland','Northeast US','Northern Ireland','Norway','North Sea','Portugal','Scotian Shelf','Southeast US','Scotland','West Coast US'))
write_csv(survey_names, here('processed-data','survey_names.csv'))
beta_div <- read_csv(here("processed-data","survey_temporal_beta_diversity.csv")) %>% 
  left_join(survey_start_times) %>% # add in the ref_yr column 
  select(-month_year, -survey_date) %>% 
  left_join(mhw_summary_sat_sst_5_day) # add in mhw data

# map data 
haul_info_map <- fread(here::here("processed-data","haul_info.csv"))

######
# stats 
######

# T-tests 

wt_no_mhw <- survey_summary %>% 
  filter(mhw_yes_no == "no", !is.na(wt_mt_log)) %>%
  pull(wt_mt_log)
wt_mhw <- survey_summary %>% 
  filter(mhw_yes_no == "yes", !is.na(wt_mt_log)) %>%
  pull(wt_mt_log)
mean(wt_mhw)
sd(wt_mhw)
mean(wt_no_mhw)
sd(wt_no_mhw)
t.test(wt_mhw, wt_no_mhw)
pwr.t2n.test(n1 = length(wt_mhw), n2= length(wt_no_mhw), d = 0.1, sig.level = 0.05, power = NULL, alternative="two.sided")
# d = (abs(log(1)-log(0.94/1)) / sd(c(wt_mhw, wt_no_mhw)))
# pwr.t2n.test(n1 = length(wt_mhw), n2= length(wt_no_mhw), d = d, sig.level = 0.05, power = NULL, alternative="two.sided")
# pwr.t.test(n = NULL, d = d, sig.level = 0.05, power = .8, alternative="two.sided")
# pwr.t2n.test(n1 = length(wt_mhw), n2= length(wt_no_mhw), d = NULL, sig.level = 0.05, power = 0.8, alternative="two.sided")

cti_no_mhw <- survey_summary %>% 
  filter(mhw_yes_no == "no", !is.na(cti_log)) %>%
  pull(cti_log)
cti_mhw <- survey_summary %>% 
  filter(mhw_yes_no == "yes", !is.na(cti_log)) %>%
  pull(cti_log)
t.test(cti_no_mhw, cti_mhw)

###########
# power analysis
###########

# STEP 1: simulate data for each region with gamma from Cheung et al. 2021

powerdat <- survey_summary %>%
  group_by(survey) %>% 
  arrange(year) %>% 
  mutate(lagwt = lag(wt, 1))
# based on the effect sizes in Cheung et al. (6% overall biomass loss in worst-case scenario), how much data would we have needed, given the actual variance in the data? 
# d = abs(log(1 / 1.06)) / sd(c(wt_no_mhw, wt_mhw))
# pwr.t.test(n = NULL, d = d, sig.level = 0.05, power = 0.8, type="one.sample") 
# pwr.t.test(n = nrow(survey_summary), d = d, sig.level = 0.05, power = NULL, type="one.sample") 

powerout <- NULL
for(surv in survey_names$survey){
  Data = powerdat %>% filter(survey==surv)
  Gompertz = lm( log(wt) ~ 1 + log(lagwt) + mhw_yes_no, data=Data )
  
  # Gompertz parameters
  alpha = Gompertz$coef['(Intercept)']
  beta = Gompertz$coef['log(lagwt)']
  conditional_sd = sqrt(mean(Gompertz$residuals^2))
  
  # set simulation length 
  n_years = 110
  
  # MHW frequency and intensity
  prob_mhw = mean( ifelse(Data[,'mhw_yes_no']=="yes",1,0), na.rm=TRUE )
  #gamma = Gompertz$coef['mhw_yes_noyes']
  gamma = log(0.94) # from Cheung et al. 2021
  
  # Stationary properties (for initial condition)
  marginal_sd = conditional_sd / (1-beta)^2
  marginal_mean = alpha / (1-beta)
  
  #
  logB_t = rep(NA,n_years)
  MHW_t = rbinom(n_years, size=1, prob=prob_mhw)
  
  # Initialize
 #  logB_t[1] = rnorm( n=1, mean=marginal_mean, sd=marginal_sd )
  logB_t[1] = mean = marginal_mean # variance was too big for initializing 
  
  # Project
  #  Gompertz:  log(N(t+1)) = alpha + beta * log(N(t)) + effects + error
  for( tI in 2:n_years){
    logB_t[tI] = alpha + beta*logB_t[tI-1] + gamma*MHW_t[tI] + rnorm( n=1, mean=0, sd=conditional_sd )
  }
  
  tmp <- tibble(wt = exp(logB_t), year = seq(1, n_years, 1), mhw_yes_no = MHW_t, n_years = n_years, gamma = gamma, survey = unique(Data$survey))
  
  powerout <- rbind(powerout, tmp)
}

# STEP 2: analyze that data the same way we did the actual data 

powertest <- powerout %>% 
  group_by(survey) %>% 
  arrange(year) %>% 
  mutate(wt_mt_log = log(wt / lag(wt))) %>% 
  filter(wt_mt_log > -Inf, wt_mt_log < Inf) 

powertest_mhw <- powertest %>% 
  filter(mhw_yes_no == 1) %>% 
  pull(wt_mt_log)

powertest_no_mhw <- powertest %>% 
  filter(mhw_yes_no == 0) %>% 
  pull(wt_mt_log)

t.test(powertest_no_mhw, powertest_mhw) 

# STEP 3: given the data we have, what effect size could we detect? 

effectout <- NULL
for(surv in survey_names$survey){
  Data = powerdat %>% filter(survey==surv)
  Gompertz = lm( log(wt) ~ 1 + log(lagwt) + mhw_yes_no, data=Data )
  
  # Gompertz parameters
  alpha = Gompertz$coef['(Intercept)']
  beta = Gompertz$coef['log(lagwt)']
  conditional_sd = sqrt(mean(Gompertz$residuals^2))
  
  #
  n_years = length(unique(Data$year))
  
  # MHW frequency and intensity
  prob_mhw = mean( ifelse(Data[,'mhw_yes_no']=="yes",1,0), na.rm=TRUE )

    gamma = log(0.90) # vary to evaluate how much of a decrease we could detect 
  
  # Stationary properties (for initial condition)
  marginal_sd = conditional_sd / (1-beta)^2
  marginal_mean = alpha / (1-beta)
  
  #
  logB_t = rep(NA,n_years)
  MHW_t = rbinom(n_years, size=1, prob=prob_mhw)
  
  # Initialize
 #  logB_t[1] = rnorm( n=1, mean=marginal_mean, sd=marginal_sd )
  logB_t[1] = mean = marginal_mean # variance was too big for initializing 
  
  # Project
  #  Gompertz:  log(N(t+1)) = alpha + beta * log(N(t)) + effects + error
  for( tI in 2:n_years){
    logB_t[tI] = alpha + beta*logB_t[tI-1] + gamma*MHW_t[tI] + rnorm( n=1, mean=0, sd=conditional_sd )
  }
  
  tmp <- tibble(wt = exp(logB_t), year = seq(1, n_years, 1), mhw_yes_no = MHW_t, n_years = n_years, gamma = gamma, survey = unique(Data$survey))
  
  effectout <- rbind(effectout, tmp)
}

effecttest <- effectout %>% 
  group_by(survey) %>% 
  arrange(year) %>% 
  mutate(wt_mt_log = log(wt / lag(wt))) %>% 
  filter(wt_mt_log > -Inf, wt_mt_log < Inf) 

effecttest_mhw <- effecttest %>% 
  filter(mhw_yes_no == 1) %>% 
  pull(wt_mt_log)

effecttest_no_mhw <- effecttest %>% 
  filter(mhw_yes_no == 0) %>% 
  pull(wt_mt_log)

t.test(effecttest_no_mhw, effecttest_mhw) 

# models to explain biomass and CTI change 

# community turnover using biomass metrics
bc_mhw_turnover <- beta_div %>% 
  filter(anom_days>0, !is.na(bray_dissimilarity_turnover)) %>% 
  pull(bray_dissimilarity_turnover)
bc_no_mhw_turnover <- beta_div %>% 
  filter(anom_days==0, !is.na(bray_dissimilarity_turnover)) %>% 
  pull(bray_dissimilarity_turnover)

t.test(bc_mhw_turnover, bc_no_mhw_turnover)
summary(lm(bray_dissimilarity_turnover ~ anom_days, data=beta_div))

#community nestedness using biomass metrics
bc_mhw_nestedness <- beta_div %>% 
  filter(anom_days>0, !is.na(bray_dissimilarity_nestedness)) %>% 
  pull(bray_dissimilarity_nestedness)
bc_no_mhw_nestedness <- beta_div %>% 
  filter(anom_days==0, !is.na(bray_dissimilarity_nestedness)) %>% 
  pull(bray_dissimilarity_nestedness)

t.test(bc_mhw_nestedness, bc_no_mhw_nestedness)
summary(lm(bray_dissimilarity_nestedness ~ anom_days, data=beta_div))

# community turnover using occurrence metrics
j_mhw_turnover <- beta_div %>% 
  filter(anom_days>0, !is.na(jaccard_dissimilarity_turnover)) %>% 
  pull(jaccard_dissimilarity_turnover)
j_no_mhw_turnover <- beta_div %>% 
  filter(anom_days==0, !is.na(jaccard_dissimilarity_turnover)) %>% 
  pull(jaccard_dissimilarity_turnover)

t.test(j_mhw_turnover, j_no_mhw_turnover)
summary(lm(jaccard_dissimilarity_turnover ~ anom_days, data=beta_div)) #not significant, p>0.05, but, p = 0.06, so close to significant
                                                                        #suggests that there may be higher turnover of species in MHW years
                                                                        #but this doesn't translate to a significant turnover in biomass

#community nestedness using occurrence metrics
j_mhw_nestedness <- beta_div %>% 
  filter(anom_days>0, !is.na(jaccard_dissimilarity_nestedness)) %>% 
  pull(jaccard_dissimilarity_nestedness)
j_no_mhw_nestedness <- beta_div %>% 
  filter(anom_days==0, !is.na(jaccard_dissimilarity_nestedness)) %>% 
  pull(jaccard_dissimilarity_nestedness)

t.test(j_mhw_nestedness, j_no_mhw_nestedness)
summary(lm(jaccard_dissimilarity_nestedness ~ anom_days, data=beta_div))

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

# NE Pacific

# what was the percentage change in biomass from 2015 to 2017?
survey_summary %>% 
  filter(survey %in% c('EBS','GOA','WCANN'), year %in% c(2015, 2017)) %>% 
  group_by(survey) %>% 
  arrange(year) %>% 
  mutate(wtdiff = (wt_mt - lag(wt_mt)) / lag(wt_mt)) %>% 
  select(survey, wtdiff) %>% 
  filter(!is.na(wtdiff))

######
# figures
######

#if positive, subtract 360
# haul_info_map[,longitude_s := ifelse(longitude > 150,(longitude-360),(longitude))]

#delete if NA for longitude or latitude
haul_info_map.r <- haul_info_map[complete.cases(haul_info_map[,.(longitude, latitude)])]

haul_info.r.split <- split(haul_info_map.r, haul_info_map.r$survey)
haul_info.r.split.sf <- lapply(haul_info.r.split, st_as_sf, coords = c("longitude", "latitude"))
haul_info.r.split.concave <- lapply(haul_info.r.split.sf, concaveman, concavity = 3, length_threshold = 2)
haul_info.r.split.concave.binded <- do.call('rbind', haul_info.r.split.concave)
haul_info.r.split.concave.binded.spdf <- as_Spatial(haul_info.r.split.concave.binded)

haul_info.r.split.concave.binded.spdf$survey <- levels(as.factor(haul_info_map.r$survey))

# get other objects needed for map plot 
survey_palette <- c("#AAF400","#B5EFB5","#F6222E","#FE00FA", 
                    "#16FF32","#3283FE","#FEAF16","#B00068", 
                    "#1CFFCE","#90AD1C","#2ED9FF","#DEA0FD", 
                    "#AA0DFE","#F8A19F","#325A9B","#C4451C", 
                    "#1C8356","#66B0FF")
x_lines <- seq(-120,180, by = 60)

data("wrld_simpl", package = "maptools")                                                                            
wm_polar <- crop(wrld_simpl, extent(-180, 180, 22, 90))  


# ---------------------------- #
#### Juliano's Map tweeks #####
# ---------------------------- #

survey_regions_polar_polygon_jepa <- ggplot() +
  geom_polygon(data = haul_info.r.split.concave.binded.spdf,
               aes(x = long, y = lat, group = group, fill = group, color = group),
               alpha = 0.8) +
  scale_color_manual(values = survey_palette, guide = "none") +
  scale_fill_manual(values = survey_palette, guide = "none") +
  # geom_polygon(data = wm_polar, aes(x = long, y = lat, group = group), fill = "azure4", 
  # ) + 
  scale_y_continuous(breaks = seq(-90,180,15)) +
  scale_x_continuous(breaks = c(-100,-45,0)) +
  coord_map("ortho", orientation = c(50, -45, 0),
            xlim=c(-180,180),
            ylim=c(35,90)) +
  theme_bw() +
  theme(panel.grid = element_line(colour="grey"),
        panel.grid.major = element_line(size=0.1),
        #panel.border = element_blank(),
        axis.ticks.y = element_blank(),
        axis.text.y = element_blank()
  )

#save global map
ggsave(survey_regions_polar_polygon_jepa, path = here::here("figures"),
       filename = "survey_regions_polar_polygon_jepa.jpg",height = 5, width = 6, unit = "in") # JEPA

# map filled by MHW impacts 

# get the most severe MHW in each region, and its biomass impacts 
mapfill <- survey_summary %>% 
  group_by(survey) %>% 
  filter(anom_days == max(anom_days)) %>% 
  select(survey, anom_days, wt_mt_log) %>% 
  mutate(fill = case_when(
    anom_days > 60 & wt_mt_log > 0 ~ "big_MHW_gain",
    anom_days <= 60 & wt_mt_log > 0 ~ "small_MHW_gain",
    anom_days > 60 & wt_mt_log < 0 ~ "big_MHW_loss",
    anom_days <= 60 & wt_mt_log < 0 ~ "small_MHW_loss"
  )) %>% 
  arrange(survey)
# nrow(mapfill) == length(unique(survey_summary$survey)) # check no duplicates
mapfill$id = as.character(1:nrow(mapfill))

# attach the map fill column to the spdf
mhw_map_spdf <- as_Spatial(haul_info.r.split.concave.binded)
mhw_map_spdf$survey <- levels(as.factor(haul_info_map.r$survey))
mhw_map_fort <- fortify(mhw_map_spdf) %>% 
  left_join(mapfill, by="id")

# map 
mhw_map <- ggplot() +
  geom_polygon(data = mhw_map_fort,
               aes(x = long, y = lat, group=group, fill=fill, color=fill),
               alpha = 0.8) +
  scale_color_manual(values = c("#960867","#8a0620","#670e96","#2f4578"), labels=c("Long MHW + biomass","Long MHW - biomass", "Short MHW + biomass", "Short MHW - biomass")) +
  scale_fill_manual(values = c("#960867","#8a0620","#670e96","#2f4578"), labels=c("Long MHW + biomass","Long MHW - biomass", "Short MHW + biomass", "Short MHW - biomass")) +
  geom_polygon(data = wm_polar, aes(x = long, y = lat, group = group), fill = "azure4" ) + 
  scale_y_continuous(breaks = seq(-90,180,15)) +
  scale_x_continuous(breaks = c(-100,-45,0)) +
  coord_map("ortho", orientation = c(50, -45, 0),
            xlim=c(-180,180),
            ylim=c(35,90)) +
  theme_bw() +
  theme(panel.grid = element_line(colour="grey"),
        panel.grid.major = element_line(size=0.1),
        #panel.border = element_blank(),
        axis.ticks.y = element_blank(),
        axis.text.y = element_blank(),
        axis.title.y = element_blank(), 
        legend.position="bottom", 
        legend.title = element_blank(),
        axis.title.x = element_blank(),
  ) +
  guides(colour = guide_legend(nrow = 2))

#save global map
ggsave(mhw_map, path = here("figures"),
       filename = "map_mhw_fill.jpg",height = 5, width = 6, unit = "in") 

# Labeles to correclty allocate mini maps on big map

labels <- haul_info_map %>% 
  group_by(survey) %>% 
  summarise(
    lon = mean(longitude),
    lat = mean(latitude)
  )

ggplot(haul_info_map) +
  geom_point(
    aes(
      x = longitude,
      y = latitude,
      color = survey
    )
  ) +
  coord_map("ortho", orientation = c(50, -45, 0),
            xlim=c(-180,180),
            ylim=c(35,90)) +
  geom_label(data = labels,
             aes(x = lon,
                 y = lat,
                 label = survey))

# ---------------------------- #
# -----------end JEPA--------- #
# ---------------------------- #


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
  group_by(survey) %>% 
  summarise(max_mhw=max(anom_days, na.rm = TRUE)) %>% 
  arrange(survey)

# generate columns for map fill
mapfill <- survey_summary %>% 
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
    filter(survey=="NIGFS")
  coeff = 5 
  tmpplot <- ggplot(tmp) +
    geom_col(aes(x=year, y=n / coeff), color="gray85", fill="gray85") +
    geom_line(aes(x=year, y=anom_days, color=anom_days), size=1) + 
    scale_color_gradient(low="#1e03cd", high="#b80d06") +
    scale_y_continuous(sec.axis = sec_axis(~ . * coeff, name = "Sampling events"))+
    # scale_x_continuous(breaks = c(2010,2012,2014,2016,2018))+
    labs(title=tmp$title) + 
    theme_bw()  +
    theme(legend.position = "none",
          axis.title.x=element_blank(),
          axis.title.y=element_blank(),
          panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          axis.text.x=element_text(angle = 45, vjust=0.5, size = 13),
          axis.text.y=element_text(size = 12),
          #    axis.title.x=element_text(vjust=5),
          #    plot.title.position = "plot",
          # plot.title = element_text(hjust=0.3, vjust = -7) # JEPA
    ) +
    NULL
  ggsave(tmpplot, filename=here("figures",paste0("inset_timeseries_",reg,".png")), height=2.5, width=5, scale=0.7, dpi=160)
  # plot_crop(here("figures",paste0("inset_timeseries_",reg,".png")))
}

  gg_mhw_biomass_hist <- survey_summary %>% 
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
  filter(anom_days>0)
lm.final1 <- lm(wt_mt_log ~ anom_days, data = lm.dat1)
lm.predict1 <- data.frame(wt_mt_log = predict(lm.final1, lm.dat1), anom_days=lm.dat1$anom_days)

gg_mhw_biomass_point_final <- survey_summary %>% 
  filter(wt_mt_log > -2) %>% # getting rid of Norway 1997 which has a -2.7 biomass ratio decline
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


