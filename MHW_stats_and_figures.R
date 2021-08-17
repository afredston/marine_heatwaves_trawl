
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



