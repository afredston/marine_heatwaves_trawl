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
library(ggExtra)

# modeling 
library(broom)
#library(pwr)
library(mgcv)
#library(lme4)
#library(mcp)

# making maps 
# JULIANO, do we still need these?
library(sf)
#library(rnaturalearth)
#library(ggrepel)
library(rgdal)
library(raster)
library(sp)
#library(rnaturalearthdata)
library(rgeos)
library(geosphere)  #to calculate distance between lat lon of grid cells
library(concaveman)
library("robinmap")
library(maptools)

select <- dplyr::select
set.seed(42)

# marine heatwave data for joining with survey data
mhw_summary_oisst_d_5_day <- read_csv(here("processed-data","MHW_oisst_5_day_threshold.csv"))
mhw_summary_glorys_d_5_day <- read_csv(here("processed-data","MHW_glorys_5_day_threshold.csv"))

total_mhws_oisst_d <- read_csv(here("processed-data","total_number_mhws_oisst_d.csv")) %>% 
  select(2:4)
total_mhws_glorys_d <- read_csv(here("processed-data","total_number_mhws_glorys_d.csv"))%>% 
  select(2:4)

# survey data joined to SBT MHWs
survey_summary <-read_csv(here("processed-data","survey_biomass_with_CTI.csv")) %>% inner_join(mhw_summary_glorys_d_5_day) %>%
  group_by(survey) %>% 
  mutate(
    wt_mt_scale = as.numeric(scale(wt_mt, center=TRUE, scale=TRUE)),
    wt_mt_log_scale = as.numeric(scale(wt_mt_log, center=TRUE, scale=TRUE)),
    cti_log_scale =  as.numeric(scale(cti_log, center=TRUE, scale=TRUE)),
    cti_diff_scale =  as.numeric(scale(cti_diff, center=TRUE, scale=TRUE)),
    anom_sev_scale =  as.numeric(scale(anom_sev, center=TRUE, scale=TRUE)),
    depth_wt_scale =  as.numeric(scale(depth_wt, center=TRUE, scale=TRUE))
  ) 

survey_spp_summary <- read_csv(here("processed-data","species_biomass_with_CTI.csv")) %>% 
  rename('spp'=accepted_name) %>% 
  mutate(wt_mt_log = as.numeric(wt_mt_log))
survey_start_times <- read_csv(here("processed-data","survey_start_times.csv"))
coords_dat <- read_csv(here("processed-data","survey_coordinates.csv"))
haul_info <- read_csv(here("processed-data","haul_info.csv")) 
haul_stats <- read_csv(here("processed-data","stats_about_raw_data.csv")) 
survey_names <- data.frame(survey=c("BITS",'DFO-QCS',  "EBS","EVHOE","FR-CGFS","GMEX", "GOA",'GSL-S',  "IE-IGFS", "NEUS",  "NIGFS", "Nor-BTS",  "NS-IBTS", 
                                    "PT-IBTS","SCS",
                                    "SEUS",  "SWC-IBTS","WCANN"), title=c('Baltic Sea','British Columbia','Eastern Bering Sea','France','English Channel','Gulf of Mexico','Gulf of Alaska','Gulf of Saint Lawrence','Ireland','Northeast US','Northern Ireland','Norway','North Sea','Portugal','Scotian Shelf','Southeast US','Scotland','West Coast US'))
write_csv(survey_names, here('processed-data','survey_names.csv'))
beta_div <- read_csv(here("processed-data","survey_temporal_beta_diversity.csv")) %>% 
  left_join(survey_start_times) %>% # add in the ref_yr column 
  select(-month_year, -survey_date) %>% 
  left_join(mhw_summary_glorys_d_5_day) %>%  # add in mhw data
  group_by(survey)  %>% 
  # scale and center all beta diversity measures within regions 
  mutate(across(jaccard_dissimilarity_turnover:richness_percent_change, ~scale(., center=TRUE, scale=TRUE), .names="{.col}_scale")) %>% # UPDATE IF COLUMNS CHANGE!
  ungroup()

sim_test_summ_gamma_glorys <- readRDS(here("processed-data","sim_test_summ_gamma_glorys.rds"))
sim_test_summ_yrs_glorys <- readRDS(here("processed-data","sim_test_summ_yrs_glorys.rds"))
colnames(sim_test_summ_gamma_glorys) <- c('exp_gamma','propsig')
colnames(sim_test_summ_yrs_glorys) <- c('n_years','propsig','n_years_tot')

sim_test_summ_gamma_oisst <- readRDS(here("processed-data","sim_test_summ_gamma_oisst.rds"))
sim_test_summ_yrs_oisst <- readRDS(here("processed-data","sim_test_summ_yrs_oisst.rds"))
colnames(sim_test_summ_gamma_oisst) <- c('exp_gamma','propsig')
colnames(sim_test_summ_yrs_oisst) <- c('n_years','propsig','n_years_tot')

# map data 
haul_info_map <- fread(here::here("processed-data","haul_info.csv"))

######
# stats 
######

# how many MHWs total?
sum(total_mhws_glorys_d$n_mhw)
sum(total_mhws_oisst_d$n_mhw)

# how many hauls total?
haul_info_oisst <- haul_info %>% 
  mutate(year = as.numeric(year)) %>% 
  filter(year<2020)
haul_info_glorys <- haul_info %>% 
  mutate(year = as.numeric(year)) %>% 
  filter(year<2020, year>1993)
nrow(haul_info_oisst)
nrow(haul_info_glorys)
haul_stats

# how many MHW vs non-MHW years?
survey_summary %>% 
  group_by(mhw_yes_no) %>% 
  summarise(n=n())

# is absolute variability predicted by number of hauls in a region?
hauldat_prep <- haul_info %>% 
  group_by(survey) %>% 
  summarise(Years = length(unique(year)), Hauls = length(unique(haul_id))) %>% 
  mutate(hyr = Hauls/Years) 
hauldat <- survey_summary %>% 
  mutate(abs_wt_mt_log = abs(wt_mt_log)) %>% 
  filter(!is.na(abs_wt_mt_log)) %>% 
  left_join(hauldat_prep, by="survey")
glance(lm(abs_wt_mt_log ~ hyr, data=hauldat))

# GOA 2017
survey_summary %>% 
  filter(survey=='GOA',year==2017) %>% 
  select(wt_mt_log, anom_sev)%>% 
  mutate(wt_mt_per = (exp(wt_mt_log)-1)*100)

# NEUS 2012
survey_summary %>% 
  filter(survey=='NEUS', year==2012) %>% 
  select(wt_mt_log, anom_sev) %>% 
  mutate(wt_mt_per = (exp(wt_mt_log)-1)*100)

# NS 
survey_summary %>% 
  filter(survey=='NS-IBTS',year == 2008) %>% 
  select(wt_mt_log, anom_sev)%>% 
  mutate(wt_mt_per = (exp(wt_mt_log)-1)*100)

# Scotland 2014 (2018 almost identical)
# survey_summary %>%
#   filter(survey=='SWC-IBTS', year==2014) %>%
#   select(wt_mt_log, anom_sev) %>%
#   mutate(wt_mt_per = (exp(wt_mt_log)-1)*100)

# SEUS 1996
survey_summary %>%
  filter(survey=='SEUS', year==1996) %>%
  select(wt_mt_log, anom_sev) %>%
  mutate(wt_mt_per = (exp(wt_mt_log)-1)*100)

# Portugal 2009
survey_summary %>%
  filter(survey=='PT-IBTS', year==2009) %>%
  select(wt_mt_log, anom_sev) %>%
  mutate(wt_mt_per = (exp(wt_mt_log)-1)*100)

# GSL 2012-2013
survey_summary %>% 
  filter(survey=='GSL-S', year %in% c(2011, 2012, 2013)) %>% 
  select(year, wt_mt_log, anom_sev, wt_mt)  %>% 
  mutate(wt_mt_per = (exp(wt_mt_log)-1)*100)

# statistical tests 

wt_no_mhw <- survey_summary %>% 
  filter(mhw_yes_no == "no", !is.na(wt_mt_log)) %>%
  pull(wt_mt_log)
wt_mhw <- survey_summary %>% 
  filter(mhw_yes_no == "yes", !is.na(wt_mt_log)) %>%
  pull(wt_mt_log)
shapiro.test(wt_no_mhw)
shapiro.test(wt_mhw)

median(wt_mhw)
sd(wt_mhw)
median(wt_no_mhw)
sd(wt_no_mhw)
t.test(wt_mhw, wt_no_mhw, alternative = "two.sided")

# absolute variation in log ratios
median(abs(wt_mhw))
sd(abs(wt_mhw))
median(abs(wt_no_mhw))
sd(abs(wt_no_mhw))
t.test(abs(wt_mhw), abs(wt_no_mhw), alternative = "two.sided")

# how many followed MHWs?
survey_summary %>% 
  group_by(mhw_yes_no) %>% 
  summarise(n=n())

cti_no_mhw <- survey_summary %>% 
  filter(mhw_yes_no == "no", !is.na(cti_diff)) %>%
  pull(cti_diff)
cti_mhw <- survey_summary %>% 
  filter(mhw_yes_no == "yes", !is.na(cti_diff)) %>%
  pull(cti_diff)
shapiro.test(cti_no_mhw)
shapiro.test(cti_mhw)
median(cti_no_mhw)
sd(cti_no_mhw)
median(cti_mhw)
sd(cti_mhw)
t.test(cti_no_mhw, cti_mhw, alternative = "two.sided")

# how correlated are SODA SBT and SODA SST?
# cor.test(
#   mhw_summary_soda_sbt %>% arrange(ref_yr) %>% pull(anom_sev),
#   mhw_summary_soda_sst %>% arrange(ref_yr) %>% pull(anom_sev),
#   method="spearman"
# )
# 
# cor.test(
#   mhw_summary_soda_sbt %>% arrange(ref_yr) %>% pull(anom_int),
#   mhw_summary_soda_sst %>% arrange(ref_yr) %>% pull(anom_int),
#   method="spearman"
# )


# regressions

lm_wt <- lm(wt_mt_log_scale ~ anom_sev_scale, data = survey_summary)
summary(lm_wt)
lm_cti <- lm(cti_diff_scale ~ anom_sev_scale, data = survey_summary)
summary(lm_cti)

# how many taxa total?
survey_spp_summary %>% 
  select(spp, STI) %>% 
  distinct() %>% 
  nrow(.)

# how many taxa had STI values?
survey_spp_summary %>% 
  select(spp, STI) %>% 
  distinct() %>% 
  mutate(STItest = ifelse(is.na(STI), "no","yes")) %>% 
  group_by(STItest) %>% 
  summarise(n=n())


# and what % of the biomass does that represent? 
survey_spp_summary %>% 
  group_by(spp, STI) %>% 
  summarise(tot = sum(wt_mt)) %>% 
  mutate(STItest = ifelse(is.na(STI), "no","yes")) %>% 
  group_by(STItest) %>% 
  summarise(totwt = sum(tot))

# CTI stats

survey_spp_summary%>% 
  filter(survey=='SWC-IBTS', spp=='Scomber scombrus', year %in% c(2004, 2005)) %>% 
  select(spp, year, wt_mt_log, wt_mt) %>% 
  mutate(wt_mt_per = (exp(wt_mt_log)-1)*100)

survey_summary %>% 
  filter(survey=='SWC-IBTS', year %in% c(2004, 2005)) %>% 
  select(survey, year, cti_diff, CTI)

survey_summary %>%
  filter(survey=='WCANN', year==2015) %>% 
  select(year, survey, cti_diff, anom_sev)

# Scotian Shelf tropicalization 2013
# survey_summary %>%
#   filter(survey=='SCS', year==2013) %>% 
#   select(year, survey, cti_log, anom_days, CTI)

survey_spp_summary %>% 
  filter(survey=='SCS', spp=='Squalus acanthias', year %in% c(2012, 2013)) %>% 
  select(year, spp, wt_mt, wt_mt_log, STI)

# what happened after the 2014-2016 NE Pacific MHW?
survey_summary %>% 
  filter(survey %in% c('WCANN','EBS','GOA','DFO-QCS'), year %in% seq(2015, 2017, 1)) %>% 
  select(survey, year, wt_mt_log, wt_mt, CTI, cti_diff) %>% 
  mutate(cti_change = ifelse(cti_diff<0, "cold","warm")) %>% 
  group_by(cti_change) 

survey_summary %>% 
  filter(survey %in% c('WCANN','EBS','GOA','DFO-QCS'), year %in% seq(2015, 2017, 1)) %>% 
  select(survey, year, wt_mt_log, wt_mt, CTI, cti_diff) %>% 
  mutate(cti_change = ifelse(cti_diff<0, "cold","warm")) %>% 
  group_by(cti_change) %>% 
  summarise(n=n())

# power analysis

# what % biomass loss could we detect with our sample size, aiming for a power of >80%?
sim_test_summ_gamma_glorys %>% filter(propsig>0.8)
sim_test_summ_gamma_oisst %>% filter(propsig>0.8)

# how many sample-years would we need to detect a 6% loss of biomass with the same power threshold?
sim_test_summ_yrs_glorys %>% filter(propsig>0.8)
sim_test_summ_yrs_oisst %>% filter(propsig>0.8)

############
# community turnover
############

# biomass weighted 
bc_mhw_substitution <- beta_div %>% 
  filter(mhw_yes_no=="yes", !is.na(bray_dissimilarity_turnover_scale)) %>% 
  pull(bray_dissimilarity_turnover_scale)
bc_no_mhw_substitution <- beta_div %>% 
  filter(mhw_yes_no=="no", !is.na(bray_dissimilarity_turnover_scale)) %>% 
  pull(bray_dissimilarity_turnover_scale)
bc_mhw_subset <- beta_div %>% 
  filter(mhw_yes_no=="yes", !is.na(bray_dissimilarity_nestedness_scale)) %>% 
  pull(bray_dissimilarity_nestedness_scale)
bc_no_mhw_subset <- beta_div %>% 
  filter(mhw_yes_no=="no", !is.na(bray_dissimilarity_nestedness_scale)) %>% 
  pull(bray_dissimilarity_nestedness_scale)
bc_mhw_total <- beta_div %>% 
  filter(mhw_yes_no=="yes", !is.na(bray_dissimilarity_total_scale)) %>% 
  pull(bray_dissimilarity_total_scale)
bc_no_mhw_total <- beta_div %>% 
  filter(mhw_yes_no=="no", !is.na(bray_dissimilarity_total_scale)) %>% 
  pull(bray_dissimilarity_total_scale)

t.test(bc_mhw_substitution, bc_no_mhw_substitution, alternative="two.sided")
t.test(bc_mhw_subset, bc_no_mhw_subset, alternative="two.sided")
t.test(bc_mhw_total, bc_no_mhw_total, alternative="two.sided")

# occurrence based 
jac_mhw_substitution <- beta_div %>% 
  filter(mhw_yes_no=="yes", !is.na(jaccard_dissimilarity_turnover_scale)) %>% 
  pull(jaccard_dissimilarity_turnover_scale)
jac_no_mhw_substitution <- beta_div %>% 
  filter(mhw_yes_no=="no", !is.na(jaccard_dissimilarity_turnover_scale)) %>% 
  pull(jaccard_dissimilarity_turnover_scale)
jac_mhw_subset <- beta_div %>% 
  filter(mhw_yes_no=="yes", !is.na(jaccard_dissimilarity_nestedness_scale)) %>% 
  pull(jaccard_dissimilarity_nestedness_scale)
jac_no_mhw_subset <- beta_div %>% 
  filter(mhw_yes_no=="no", !is.na(jaccard_dissimilarity_nestedness_scale)) %>% 
  pull(jaccard_dissimilarity_nestedness_scale)
jac_mhw_total <- beta_div %>% 
  filter(mhw_yes_no=="yes", !is.na(jaccard_dissimilarity_total_scale)) %>% 
  pull(jaccard_dissimilarity_total_scale)
jac_no_mhw_total <- beta_div %>% 
  filter(mhw_yes_no=="no", !is.na(jaccard_dissimilarity_total_scale)) %>% 
  pull(jaccard_dissimilarity_total_scale)

t.test(jac_mhw_substitution, jac_no_mhw_substitution, alternative="two.sided")
t.test(jac_mhw_subset, jac_no_mhw_subset, alternative="two.sided")
t.test(jac_mhw_total, jac_no_mhw_total, alternative="two.sided")
  

######
# figures
######

gg_mhw_biomass_point_marg <- survey_summary %>% 
  ggplot(aes(x=anom_sev, y=wt_mt_log)) +
  geom_point(aes(color=mhw_yes_no, fill=mhw_yes_no, group = mhw_yes_no)) +
  scale_color_manual(values=c("#E31A1C","#1F78B4")) +
  geom_point(color="black") +
  geom_smooth(method="lm", color = "gray35") +
  theme_bw() + 
  coord_cartesian(clip = "off") +
  labs(x="Marine heatwave severity (°C-days)", y="Biomass log ratio") +
  geom_hline(aes(yintercept=0), linetype="dashed", color="black") +
  theme(
    legend.position = "none", 
    panel.grid.major = element_blank(), 
    panel.grid.minor = element_blank())
margplot <- ggMarginal(gg_mhw_biomass_point_marg,type="density", margins="y", groupColour = TRUE, groupFill=TRUE, yparams=list(size=0.9))
margplot
# for labeling in inkscape
survey_summary %>% 
  select(ref_yr, wt_mt_log, anom_sev) %>%
  filter(anom_sev>25) %>%
  arrange(-anom_sev)
# regression slope for figure caption
summary(lm(wt_mt_log ~ anom_sev, data=survey_summary))

ggsave(margplot, scale=0.8, filename=here("figures","final_biomass_point.png"), width=170, height=110, units="mm")

# time-series of NE Pacific surveys
nep <- survey_summary %>% 
  left_join(beta_div) %>% 
  filter(survey %in% c('DFO-QCS','EBS','GOA','WCANN')) %>% 
  left_join(survey_names) %>% 
  group_by(survey) %>% 
  mutate(wt_scale = scale(wt_mt, center=TRUE, scale=TRUE), 
         cti_scale = scale(CTI, center=TRUE, scale=TRUE)) %>% 
  ungroup() %>% 
  arrange(survey)

gg_nep_wt <- nep %>% 
  ggplot() +
  geom_rect(aes(xmin=2015, xmax=2017, ymin=-2, ymax=3), color="grey", fill="grey", alpha=0.5) +
  geom_line(aes(x=year, y=wt_scale, color=title, fill=title)) +
  geom_point(aes(x=year, y=wt_scale, color=title, fill=title), ) +
  scale_fill_manual(values=c("#B8EFB8","#F74F57","#FDBE43","#5DAAFF"), guide="none") +
  scale_color_manual(values=c("#B8EFB8","#F74F57","#FDBE43","#5DAAFF"), guide="none") +
  theme_bw() + 
  labs(x=NULL, y=NULL, title="Biomass") +
  theme(
    panel.grid.major = element_blank(), 
    panel.grid.minor = element_blank(),
    axis.text.x=element_blank())
gg_nep_wt

gg_nep_cti <- nep %>% 
  ggplot() +
  geom_rect(aes(xmin=2015, xmax=2017, ymin=-3, ymax=2), color="grey", fill="grey", alpha=0.5) +
  geom_line(aes(x=year, y=cti_scale, color=title, fill=title)) +
  geom_point(aes(x=year, y=cti_scale, color=title, fill=title), ) +
  scale_fill_manual(values=c("#B8EFB8","#F74F57","#FDBE43","#5DAAFF"), guide="none") +
  scale_color_manual(values=c("#B8EFB8","#F74F57","#FDBE43","#5DAAFF"), guide="none") +
  theme_bw() + 
  labs(x=NULL, y=NULL, title="Community Temperature Index") +
  theme(
    panel.grid.major = element_blank(), 
    panel.grid.minor = element_blank(),
    axis.text.x=element_blank())
gg_nep_cti

gg_nep_bray <- nep %>% 
  ggplot() +
  geom_rect(aes(xmin=2015, xmax=2017, ymin=0, ymax=0.3), color="grey", fill="grey", alpha=0.5) +
  geom_line(aes(x=year, y=bray_dissimilarity_turnover, color=title, fill=title)) +
  geom_point(aes(x=year, y=bray_dissimilarity_turnover, color=title, fill=title), ) +
  scale_fill_manual(values=c("#B8EFB8","#F74F57","#FDBE43","#5DAAFF")) +
  scale_color_manual(values=c("#B8EFB8","#F74F57","#FDBE43","#5DAAFF")) +
  theme_bw() + 
  labs(x=NULL, y=NULL, title="Community Dissimilarity") +
  theme(
    panel.grid.major = element_blank(), 
    panel.grid.minor = element_blank(),
    legend.position="bottom",
    legend.margin=margin(),
    legend.title = element_blank()) +
  guides(fill=guide_legend(nrow=2))
gg_nep_bray
ggsave(gg_nep_wt, width=70, height=30, units="mm", dpi=300, filename=here("figures","nepacific_biomass.png"), scale=1.5)
ggsave(gg_nep_cti, width=70, height=30, units="mm", dpi=300, filename=here("figures","nepacific_cti.png"), scale=1.5)
ggsave(gg_nep_bray, width=70, height=42, units="mm", dpi=300, filename=here("figures","nepacific_bray.png"), scale=1.5)

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
               aes(x = long, 
                   y = lat, 
                   group = group, 
                   fill = group, 
                   color = group),
               alpha = 0.8) +
  scale_color_manual(values = survey_palette, guide = "none") +
  scale_fill_manual(values = survey_palette, guide = "none") +
  geom_polygon(data = wm_polar, 
               aes(x = long, y = lat, group = group), 
               fill = "azure4",
  ) +
  geom_label(data = labels,
             aes(x = lon,
                 y = lat,
                 label = survey))+
  scale_y_continuous(breaks = seq(-90,180,15)) +
  scale_x_continuous(breaks = c(-100,-50,-10)) +
  coord_map("ortho", orientation = c(50, -45, 0),
            xlim=c(-180,-15),
            ylim=c(35,90)) +
  theme_bw() +
  theme(panel.grid = element_line(colour="grey"),
        panel.grid.major = element_line(size=0.1),
        #panel.border = element_blank(),
        axis.ticks.y = element_blank(),
        axis.text.y = element_blank()
  );survey_regions_polar_polygon_jepa

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

ggplot() +
  # geom_point(data = subset(haul_info_map, survey == "SCS")) +
  geom_point(data = haul_info_map,
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


# ---------------------------- #
#### Sub-Pannels #####
# ---------------------------- #


# JEPA #
# Include abbreviation on title for plot

survey_names <- survey_names %>% 
  mutate(abb = c(
    "(BS)",
    "(BC)",
    "(EBS)",
    "(FR)",
    "(EC)",
    "(GoM)",
    "(GoA)",
    "(GSL)",
    "(IR)",
    "(NeUS)",
    "(NI)",
    "(NO)",
    "(NS)",
    "(PO)",
    "(SS)",
    "(SeUS)",
    "(SC)",
    "(WUS)"
  ),
  title = ifelse(title == "Norway", "Western Barents Sea (WBS)", paste(title, abb))
  ) 

# Generate figure palette
pal <-  wesanderson::wes_palette("Zissou1",100,type = "continuous")

# generate many small panels for Fig 1
for(reg in survey_names$survey) {
  tmp <- mhw_summary_oisst_d_5_day %>%
    left_join(survey_summary %>% select(ref_yr, survey, year) %>% distinct()) %>%
    left_join(survey_names) %>%
    left_join(haul_info %>% group_by(survey,year) %>% summarise(n=n())) %>%
    filter(survey==reg) %>%
    mutate(lowyr = plyr::round_any(min(year), 5, f=ceiling),
           hiyr = plyr::round_any(max(year), 5, f=floor))
  
  coeff = ceiling(max(tmp$n)/max(tmp$anom_days))

  # # Expand dataset for line gradient
  # # i = 1
  # for(i in 1:nrow(tmp)-1){
  #   # Fix last row issue
  #   if(i == 0){i = 1}
  #   if(tmp$anom_days[i] == tmp$anom_days[i+1]){
  #     df <- data.frame(anom_daysb = rep(tmp$anom_days[i],12),
  #                      yearb = seq(tmp$year[i],tmp$year[i+1],0.083)[1:12],
  #                      ref_yr = tmp$ref_yr[i])
  #   }
  #   # set the inter-years values if difference between years
  #   if(tmp$anom_days[i] != tmp$anom_days[i+1]){
  #     # Estimate the break between different values
  #     sbreak = (tmp$anom_days[i+1]-tmp$anom_days[i])/12
  #     tbreak = (tmp$year[i+1]-tmp$year[i])/12
  #     df <- data.frame(anom_daysb = c(tmp$anom_days[i],seq(tmp$anom_days[i],tmp$anom_days[i+1],sbreak)[2:12]),
  #                      yearb = seq(tmp$year[i],tmp$year[i+1],tbreak)[1:12],
  #                      ref_yr = tmp$ref_yr[i])
  #   }

  
  
  # Expand dataset for line gradient
  # rm(long_tmp,df)
  
  for(i in 1:nrow(tmp)-1){
    # Set 0s if no difference 
    
    if(i == 0){i = 1}
    if(tmp$anom_days[i] == tmp$anom_days[i+1]){
      df <- data.frame(anom_daysb = rep(tmp$anom_days[i],12),
                       yearb = seq(tmp$year[i],tmp$year[i+1],0.08)[1:12],
                       ref_yr = tmp$ref_yr[i])
    }
    
    # set the inter-years values if difference between years
    if(tmp$anom_days[i] != tmp$anom_days[i+1]){
      
      # Estimate the break between different values
      sbreak = (tmp$anom_days[i+1]-tmp$anom_days[i])/12
      
      df <- data.frame(anom_daysb = c(seq(tmp$anom_days[i],tmp$anom_days[i+1],sbreak),tmp$anom_days[i+1])[2:13],
                       yearb = seq(tmp$year[i],tmp$year[i+1],0.08)[1:12],
                       ref_yr = tmp$ref_yr[i])
    }
    

    # Create df
    if(i == 1){
      long_tmp <- df
    }else{
      # print(df)
      long_tmp <- bind_rows(long_tmp,df)
    }
  }

  
  # Plot me
  tmpplot <-
    ggplot(tmp) +
    geom_col(aes(x=year, y=n / coeff), color="gray85", fill="gray85") +
    # geom_line(aes(x=year, y=anom_days, color=anom_days), size=2)  +
    geom_line(data = long_tmp, aes(x=yearb, y=anom_daysb, color=anom_daysb), size=1)  +
    # scale_color_gradient(low=“#1E03CD”, high=“#B80D06") + # original option
    # scale_color_viridis_b() + # viridis option
    scale_color_gradientn(colours = pal) + # wesanderson option
    # scale_color_gradient(low="#1e03cd", high="#b80d06") +
    scale_y_continuous(sec.axis = sec_axis(~ . * coeff, name = "Sampling events"))+
    scale_x_continuous(breaks = seq(tmp$lowyr[1], tmp$hiyr[1], 5)) +
    labs(title=tmp$title) +
    theme_bw()  +
    theme(legend.position = "none",
          axis.title.x=element_blank(),
          axis.title.y=element_blank(),
          panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          axis.text.x=element_text(angle = 45, vjust=0.5, size = 14),
          axis.text.y=element_text(size = 14),
          #    axis.title.x=element_text(vjust=5),
          #    plot.title.position = “plot”,
          # plot.title = element_text(hjust=0.3, vjust = -7) # JEPA
    ) +
    NULL
  ggsave(tmpplot, filename=here("figures",paste0("inset_timeseries_",reg,".png")), height=2.5, width=5, scale=0.7, dpi=160)
  # plot_crop(here(“figures”,paste0(“inset_timeseries_“,reg,“.png”)))
}

reg_cti <- survey_summary %>% 
  select(CTI, ref_yr) %>% 
  distinct()

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
  inner_join(mhw_summary_oisst_d_5_day, by="ref_yr") %>% # get MHW data matched to surveys
  filter(!is.na(STI_diff), mhw_yes_no=="yes", wt_mt_log < Inf, wt_mt_log > -Inf) %>% 
  ggplot(aes(x=STI_diff, y=wt_mt_log, color=anom_sev, fill=anom_sev)) +
  geom_point(size=0.5, position="jitter") + 
 scale_color_distiller(palette="RdPu", name="MHW severity\n(°C-days)", direction=1) +
  scale_fill_distiller(palette="RdPu", name="MHW severity\n(°C-days)", direction=1) +
 # scale_color_gradient(low="#1F78B4", high="#E31A1C", name="MHW duration\n(days)") +
 # scale_fill_gradient(low="#1F78B4", high="#E31A1C", name="MHW duration\n(days)") +
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
  ggplot(aes(x=cti_diff, group=mhw_yes_no, fill=mhw_yes_no, color=mhw_yes_no)) +
  geom_freqpoly(binwidth=0.5, alpha=0.8, size=2) +
  scale_color_manual(values=c("#E31A1C","#1F78B4")) +
  scale_fill_manual(values=c("#E31A1C","#1F78B4")) +
  theme_bw() + 
  labs(x="CTI difference", y="Frequency") +
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        legend.position = "none")
gg_mhw_cti_hist
ggsave(gg_mhw_cti_hist, scale=0.9, filename=here("figures","final_cti_hist.png"), width=50, height=50, units="mm")
