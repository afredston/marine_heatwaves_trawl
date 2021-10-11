
# load packages
library(tidyverse)
library(here)
library(lubridate) # for standardizing date format of MHW data
library(kableExtra)
library(broom)
library(gridExtra)

# load data
mhwSurvSummary <- read_csv(here("processed-data","survey_MHW_summary_stats.csv"))
mhwYrTidy <- read_csv(here("processed-data","MHW_calendar_year_anomaly.csv"))
region_summary <-read_csv(here("processed-data","survey_region_biomass_with_MHWs.csv"))
region_spp_summary <- read_csv(here("processed-data","survey_species_biomass_with_MHWs.csv"))
survey_start_times <- read_csv(here("processed-data","survey_start_times.csv"))
cti <- read_csv(here("processed-data","survey_CTI_with_MHWs.csv"))

#######
# stats
#######

# what magnitude of change followed MHWs vs non-MHWs?
region_summary %>% 
  left_join (mhwSurvSummary, by="ref_year") %>% 
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

gg_mhw_biomass_hist <- region_summary %>% 
  left_join (mhwSurvSummary, by="ref_year") %>% # get MHW data matched to surveys
  mutate(mhwYesNo = recode(mhwYesNo, no="No Marine Heatwave", yes="Marine Heatwave")) %>% 
  ggplot(aes(x=wtMtLog, group=mhwYesNo, fill=mhwYesNo, color=mhwYesNo)) +
  geom_histogram(binwidth=0.1, alpha=0.5) +
  scale_color_manual(values=c("#E31A1C","#1F78B4")) +
  scale_fill_manual(values=c("#E31A1C","#1F78B4")) +
  theme_bw() + 
  labs(x="Biomass Log Ratio", y="Frequency (Survey-Years)") +
  theme(legend.position = c(0.7,0.8),
        legend.title = element_blank())
gg_mhw_biomass_hist

gg_mhw_biomass_point <- region_summary %>% 
  left_join (mhwSurvSummary, by="ref_year") %>% # get MHW data matched to surveys
  ggplot(aes(x=anomIntC, y=wtMtLog)) +
  geom_point() +
  theme_bw() + 
  labs(x="Marine Heatwave Cumulative Mean Intensity", y="Biomass Log Ratio") +
  geom_hline(aes(yintercept=0), linetype="dashed", color="black") 
gg_mhw_biomass_point

gg_mhw_cti_hist <- cti %>% 
  mutate(mhwYesNo = recode(mhwYesNo, no="No Marine Heatwave", yes="Marine Heatwave")) %>% 
  ggplot(aes(x=ctiLog, group=mhwYesNo, fill=mhwYesNo, color=mhwYesNo)) +
  geom_histogram(binwidth=0.05, alpha=0.5) +
  scale_color_manual(values=c("#E31A1C","#1F78B4")) +
  scale_fill_manual(values=c("#E31A1C","#1F78B4")) +
  theme_bw() + 
  labs(x="CTI Log Ratio", y="Frequency (Survey-Years)") +
  theme(legend.position = "none")
gg_mhw_cti_hist

gg_mhw_cti_point <- cti %>% 
  ggplot(aes(x=anomIntC, y=ctiLog)) +
  geom_point() +
  theme_bw() + 
  labs(x="Marine Heatwave Cumulative Mean Intensity", y="CTI Log Ratio") +
  geom_hline(aes(yintercept=0), linetype="dashed", color="black")
gg_mhw_cti_point

mhw_panel_fig <- grid.arrange(gg_mhw_biomass_hist, gg_mhw_biomass_point, gg_mhw_cti_hist, gg_mhw_cti_point, ncol=2, nrow=2)
ggsave(mhw_panel_fig, scale=1.5, dpi=300, filename=here("results","mhw_panel_figure.png"))


#######
# Absolute Change
#######

gg_mhw_biomass_hist_abs <- region_summary %>% 
  left_join (mhwSurvSummary, by="ref_year") %>% # get MHW data matched to surveys
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
  left_join (mhwSurvSummary, by="ref_year") %>% # get MHW data matched to surveys
  mutate(wtMtLogAbs = abs(wtMtLog)) %>% 
  ggplot(aes(x=anomIntC, y=wtMtLogAbs)) +
  geom_point() +
  theme_bw() + 
  labs(x="Marine Heatwave Cumulative Mean Intensity", y="Biomass Log Ratio Absolute Value") +
  geom_hline(aes(yintercept=0), linetype="dashed", color="black") 
gg_mhw_biomass_point_abs

#######
# NE Pacific
#######

gg_goa <- ggplot() + 
  geom_point(data = region_summary %>% filter(region=="gulf_of_alaska"), aes(x=year, y=wtMtLog), color="blue") + 
  geom_point(data = cti %>% filter(region=="gulf_of_alaska"), aes(x=year, y=ctiLog), color="red") + 
  theme_bw() +
  labs(title="GOA", y="Log Ratio") +
  scale_x_continuous(breaks=seq(1982, 2018, 2)) 
gg_goa

gg_ebs <- ggplot() + 
  geom_point(data = region_summary %>% filter(region=="eastern_bering_sea"), aes(x=year, y=wtMtLog), color="blue") + 
  geom_point(data = cti %>% filter(region=="eastern_bering_sea"), aes(x=year, y=ctiLog), color="red") + 
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



