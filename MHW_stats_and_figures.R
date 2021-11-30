
# load packages
library(tidyverse)
library(here)
library(lubridate) # for standardizing date format of MHW data
library(kableExtra)
library(broom)
library(gridExtra)
library(sf)
library(rnaturalearth)
library(ggrepel)

# load data
mhw_summary <- read_csv(here("processed-data","survey_MHW_summary_stats.csv"))
mhw_summary_sst <- mhw_summary %>% filter(metric=="sst")
mhw_cal_yr <- read_csv(here("processed-data","MHW_calendar_year_anomaly.csv"))
mhw_cal_daily <- read_csv(here("processed-data","MHW_calendar_year_daily_anomaly.csv"))
region_summary <-read_csv(here("processed-data","survey_region_biomass_with_MHWs.csv"))
region_spp_summary <- read_csv(here("processed-data","survey_species_biomass_with_MHWs.csv"))
survey_start_times <- read_csv(here("processed-data","survey_start_times.csv"))
cti <- read_csv(here("processed-data","survey_CTI_with_MHWs.csv"))
cti_sst <- cti  %>% filter(metric=="sst")
coords_dat <- read_csv(here("processed-data","survey_coordinates.csv"))
mhw_raw_sst <- read.delim(here("raw-data","MHW_95P_surveys_for_malin.csv"), sep=";") # file from Thomas - download and move to processed-data folder

#######
# stats
#######

# what magnitude of change followed MHWs vs non-MHWs?
region_summary %>% 
  left_join (mhw_summary_sst, by="ref_year") %>% 
  mutate(abswtMtLog = abs(wtMtLog)) %>% 
  group_by(mhwYesNo) %>% 
  summarise(mean_abs_log_ratio = mean(abswtMtLog, na.rm=TRUE))

# how much did biomass decline in the Gulf of Alaska in 2014-2016?
region_summary %>% 
  filter(region=="gulf_of_alaska") %>% 
  filter(year %in% c(2013, 2015, 2017)) %>% 
  select(year, wtMt) %>% 
  mutate(relative_to_2013 = (wtMt-wtMt[1])/wtMt[1])

# specifically for cod and pollock
region_spp_summary %>% 
  filter(region=="gulf_of_alaska", spp %in% c("Gadus macrocephalus","Gadus chalcogrammus"), year %in% c(2013, 2015, 2017)) %>% 
  select(year, spp, wtMt) %>% 
  group_by(spp) %>% 
  arrange(year) %>% 
  mutate(relative_to_2013 = (wtMt-wtMt[1])/wtMt[1]) %>% 
  ungroup()

# how much did biomass change on the West Coast?
region_summary %>% 
  filter(region=="west_coast") %>% 
  filter(year >= 2014) %>% 
  select(year, wtMt) %>% 
  arrange(year) %>% 
  mutate(relative_to_2014 = (wtMt-wtMt[1])/wtMt[1])

# Northeast 2012 MHW
region_summary %>% 
  filter(region=="northeast") %>% 
 filter(year >= 2012) %>% 
  select(year, wtMt) %>% 
  arrange(year) %>% 
  mutate(relative_to_2012 = (wtMt-wtMt[1])/wtMt[1])

region_spp_summary %>% 
  filter(region=="northeast", spp=="Homarus americanus") %>% 
  filter(year >= 2012) %>% 
  select(year, wtMt) %>% 
  arrange(year) %>% 
  mutate(relative_to_2012 = (wtMt-wtMt[1])/wtMt[1])

########
# plots
########

mhw_cal_daily %>% 
  ggplot(aes(x=metric, y=year, fill=mhwYesNo)) +
  facet_wrap(~region) +
  geom_tile()

mhw_raw_sst %>% 
  rename("dateRaw"=X) %>% 
  pivot_longer(cols=2:ncol(mhw_raw_sst), names_to="region", values_to="sstAnom") %>% # convert to "long" format
  mutate(sstAnom=replace_na(sstAnom, 0)) %>% 
  mutate(date = dmy(dateRaw)) %>%  # standardize date formats
  select(-dateRaw) %>% 
  ggplot(aes(x=date, y=sstAnom, color=sstAnom)) + 
  geom_line() +
  facet_wrap(~region) + 
  theme_bw() + 
  scale_color_viridis_c(option="inferno") +
  NULL

gg_mhw_biomass_hist <- region_summary %>% 
  left_join (mhw_summary_sst, by="ref_year") %>% # get MHW data matched to surveys
  mutate(mhwYesNo = recode(mhwYesNo, no="No Marine Heatwave", yes="Marine Heatwave")) %>% 
  ggplot(aes(x=wtMtLog, group=mhwYesNo, fill=mhwYesNo, color=mhwYesNo)) +
  geom_freqpoly(binwidth=0.1, alpha=0.8, size=2) +
  scale_color_manual(values=c("#E31A1C","#1F78B4")) +
  scale_fill_manual(values=c("#E31A1C","#1F78B4")) +
  theme_bw() + 
  labs(x="Biomass Log Ratio", y="Frequency (Survey-Years)") +
  theme(legend.position = c(0.7,0.8),
        legend.title = element_blank())
gg_mhw_biomass_hist

gg_mhw_biomass_point <- region_summary %>% 
  left_join (mhw_summary_sst, by="ref_year") %>% # get MHW data matched to surveys
  ggplot(aes(x=anomIntC, y=wtMtLog, label=ref_year)) +
  geom_point() +
  geom_text_repel(aes(label=ifelse(anomIntC>0.75|abs(wtMtLog)>1,as.character(ref_year),'')),max.overlaps = Inf,xlim = c(-Inf, Inf), ylim = c(-Inf, Inf),min.segment.length = 0) +
  theme_bw() + 
  coord_cartesian(clip = "off") +
  labs(x="Marine Heatwave Cumulative Mean Intensity", y="Biomass Log Ratio") +
  geom_hline(aes(yintercept=0), linetype="dashed", color="black") 
gg_mhw_biomass_point

gg_mhw_anomtype <- region_summary %>% 
  left_join (mhw_summary_sst, by="ref_year") %>% 
  ggplot(aes(x=anomDays, y=anomSev, color=anomIntC, fill=anomIntC)) +
  geom_point() + 
  theme_bw() +
  scale_fill_viridis_c()+
  scale_color_viridis_c() +
  coord_cartesian(clip = "off") +
  geom_text_repel(aes(label=ifelse(anomSev>50|anomDays>100,as.character(ref_year),'')),max.overlaps = Inf,xlim = c(-Inf, Inf), ylim = c(-Inf, Inf),min.segment.length = 0)+
  theme(plot.margin = margin(2,2,2,2, "pt"))

gg_mhw_biomass_point_metric <- mhw_summary %>% 
  left_join (region_summary, by="ref_year") %>% # get MHW data matched to surveys
  pivot_longer(cols=c('anomDays','anomSev','anomIntC'), names_to = "mhwType", values_to = "mhwIndex") %>% 
  ggplot(aes(x=mhwIndex, y=wtMtLog, label=ref_year)) +
  facet_grid(metric ~ mhwType, scales="free_x") +
  geom_point() +
 # geom_text_repel(aes(label=ifelse(anomIntC>0.75|abs(wtMtLog)>1,as.character(ref_year),'')),max.overlaps = Inf,xlim = c(-Inf, Inf), ylim = c(-Inf, Inf),min.segment.length = 0) +
  theme_bw() + 
  coord_cartesian(clip = "off") +
  labs(x="Marine Heatwave Index", y="Biomass Log Ratio") +
  geom_hline(aes(yintercept=0), linetype="dashed", color="black") 

gg_mhw_cti_hist <- cti_sst %>% 
  mutate(mhwYesNo = recode(mhwYesNo, no="No Marine Heatwave", yes="Marine Heatwave")) %>% 
  ggplot(aes(x=ctiLog, group=mhwYesNo, fill=mhwYesNo, color=mhwYesNo)) +
  geom_freqpoly(binwidth=0.05, alpha=0.8, size=2) +
  scale_color_manual(values=c("#E31A1C","#1F78B4")) +
  scale_fill_manual(values=c("#E31A1C","#1F78B4")) +
  theme_bw() + 
  labs(x="CTI Log Ratio", y="Frequency (Survey-Years)") +
  theme(legend.position = "none")
gg_mhw_cti_hist

gg_mhw_cti_point <- cti_sst %>% 
  ggplot(aes(x=anomIntC, y=ctiLog)) +
  geom_point() +
  geom_text_repel(aes(label=ifelse(anomIntC>0.75,as.character(ref_year),'')),max.overlaps = Inf,xlim = c(-Inf, Inf), ylim = c(-Inf, Inf),min.segment.length = 0, force=50) +
  theme_bw() + 
  labs(x="Marine Heatwave Cumulative Mean Intensity", y="CTI Log Ratio") +
  geom_hline(aes(yintercept=0), linetype="dashed", color="black")
gg_mhw_cti_point

mhw_panel_fig <- grid.arrange(gg_mhw_biomass_hist, gg_mhw_biomass_point, gg_mhw_cti_hist, gg_mhw_cti_point, ncol=2, nrow=2)
ggsave(mhw_panel_fig, scale=1.5, dpi=300, filename=here("results","mhw_panel_figure.png"))


####### Absolute Change

gg_mhw_biomass_hist_abs <- region_summary %>% 
  left_join (mhw_summary_sst, by="ref_year") %>% # get MHW data matched to surveys
  mutate(mhwYesNo = recode(mhwYesNo, no="No Marine Heatwave", yes="Marine Heatwave"),
         wtMtLogAbs = abs(wtMtLog)) %>% 
  ggplot(aes(x=wtMtLogAbs, group=mhwYesNo, fill=mhwYesNo, color=mhwYesNo)) +
  geom_histogram(binwidth=0.1, alpha=0.5) +
  scale_color_manual(values=c("#E31A1C","#1F78B4")) +
  scale_fill_manual(values=c("#E31A1C","#1F78B4")) +
  theme_bw() + 
  labs(x="Biomass Log Ratio Absolute Value", y="Frequency (Survey-Years)") +
  theme(legend.position = c(0.7,0.8),
        legend.title = element_blank())
gg_mhw_biomass_hist_abs

gg_mhw_biomass_point_abs <- region_summary %>% 
  left_join (mhw_summary_sst, by="ref_year") %>% # get MHW data matched to surveys
  mutate(wtMtLogAbs = abs(wtMtLog)) %>% 
  ggplot(aes(x=anomIntC, y=wtMtLogAbs)) +
  geom_point() +
  theme_bw() + 
  labs(x="Marine Heatwave Cumulative Mean Intensity", y="Biomass Log Ratio Absolute Value") +
  geom_hline(aes(yintercept=0), linetype="dashed", color="black") 
gg_mhw_biomass_point_abs

####### NE Pacific

gg_goa <- ggplot() + 
  geom_point(data = region_summary %>% filter(region=="gulf_of_alaska"), aes(x=year, y=wtMtLog), color="blue") + 
  geom_point(data = cti_sst %>% filter(region=="gulf_of_alaska"), aes(x=year, y=ctiLog), color="red") + 
  theme_bw() +
  labs(title="GOA", y="Log Ratio") +
  scale_x_continuous(breaks=seq(1982, 2018, 2)) 
gg_goa

gg_ebs <- ggplot() + 
  geom_point(data = region_summary %>% filter(region=="eastern_bering_sea"), aes(x=year, y=wtMtLog), color="blue") + 
  geom_point(data = cti_sst %>% filter(region=="eastern_bering_sea"), aes(x=year, y=ctiLog), color="red") + 
  theme_bw() +
  labs(title="EBS", y="Log Ratio") +
  scale_x_continuous(breaks=seq(1982, 2018, 2)) 
gg_ebs


gg_goa_spp <- region_spp_summary %>% 
  filter(region=="gulf_of_alaska", spp %in% c("Gadus macrocephalus","Gadus chalcogrammus")) %>% 
  ggplot(aes(x=year, y=wtMtLog, color=spp, group=spp, fill=spp)) + 
  geom_point() +
  geom_line() +
  theme_bw() +
  labs(title="GOA - Cod and Pollock", y="Log Ratio") +
  scale_x_continuous(breaks=seq(1982, 2018, 2)) +
  theme(legend.position = c(0.2,0.8))
gg_goa_spp

gg_ebs_spp <- region_spp_summary %>% 
  filter(region=="eastern_bering_sea", spp %in% c("Gadus macrocephalus","Gadus chalcogrammus")) %>% 
  ggplot(aes(x=year, y=wtMtLog, color=spp, group=spp, fill=spp)) + 
  geom_point() +
  geom_line() +
  theme_bw() +
  labs(title="EBS - Cod and Pollock", y="Log Ratio") +
  scale_x_continuous(breaks=seq(1982, 2018, 2)) +
  theme(legend.position = c(0.2,0.2))
gg_ebs_spp


# try cluster analysis
tmp <- region_summary %>% 
  left_join (mhw_summary_sst, by="ref_year") %>% 
  select(ref_year, wtMtLog, anomIntC) %>% 
  data.frame(., row.names=1) %>% 
  na.omit() %>% 
  scale()
ktmp <- kmeans(tmp, centers=2)
tmp %>%
  as_tibble() %>%
  mutate(cluster = ktmp$cluster,
         ref_year = row.names(tmp)) %>%
  ggplot(aes(wtMtLog, anomIntC, color = factor(cluster), label = ref_year)) +
  theme_bw() +
  geom_text()

####### maps
reg_hulls <- coords_dat %>% 
  mutate(lon = ifelse(lon>-180, lon, lon+360)) %>% # fix values in AK that are -189 etc
  filter(!region=="Aleutian Islands") %>%  # COME BACK TO THIS AND FIX THE MAP
  st_as_sf(., coords=c('lon','lat')) %>% 
  group_by(region) %>% 
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
  geom_sf_text(data=reg_hulls, aes(label=region), size=2) +
  theme_bw()


ggplot() +
  geom_sf(data=ocean, aes()) +
  geom_sf(data=reg_hulls %>% filter(region %in% c("Eastern Bering Sea","West Coast","Northeast")), aes(), fill="steelblue2", color="navy", alpha=0.5) +
  theme_bw()


ggplot() +
  geom_sf(data=ocean, aes()) +
  geom_sf(data=reg_hulls %>% filter(region %in% c("NorBTS","BITS",'SWC-IBTS','NS-IBTS')), aes(), fill="steelblue2", color="navy", alpha=0.5) +
  geom_sf_text(data=reg_hulls%>% filter(region %in% c("NorBTS","BITS",'SWC-IBTS','NS-IBTS')), aes(label=region), size=3) +
  scale_x_continuous(limits=c(-15, 60)) + 
  scale_y_continuous(limits=c(40, 90)) +
  theme_bw()


