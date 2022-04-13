
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
#library(mcp)
#library(rjags)
#library(segmented)
library(patchwork)
# load data
library(pwr)

# marine heatwave data for joining with survey data
mhw_summary_sat_sst_any <- read_csv(here("processed-data","mhw_satellite_sst.csv")) # MHW summary stats from satellite SST record, using any anomaly as a MHW
mhw_summary_sat_sst_5_day <- read_csv(here("processed-data","mhw_satellite_sst_5_day_threshold.csv")) # MHW summary stats from satellite SST record, defining MHWs as events >=5 days
mhw_summary_soda_sst <-  read_csv(here("processed-data","mhw_soda_sst.csv")) # modeled SST from SODA
mhw_summary_soda_sbt <-  read_csv(here("processed-data","mhw_soda_sbt.csv")) # modeled SBT from SODA

# calendar year MHW data for plotting
mhw_cal_yr_sat_sst_5_day <- read_csv(here("processed-data","MHW_calendar_year_satellite_sst_5_day_threshold.csv"))
mhw_cal_yr_soda_sst <- read_csv(here("processed-data","MHW_calendar_year_soda_sst.csv"))
mhw_cal_yr_soda_sbt <- read_csv(here("processed-data","MHW_calendar_year_soda_sbt.csv"))

# survey data 
survey_summary <-read_csv(here("processed-data","survey_biomass_with_CTI.csv"))
survey_spp_summary <- read_csv(here("processed-data","species_biomass_with_CTI.csv")) %>% 
  rename('spp'=accepted_name)
survey_start_times <- read_csv(here("processed-data","survey_start_times.csv"))
coords_dat <- read_csv(here("processed-data","survey_coordinates.csv"))
haul_info <- read_csv(here("processed-data","haul_info.csv"))
med_lat <- haul_info %>% group_by(survey) %>% summarise(med_lat = median(latitude))
survey_names <- data.frame(survey=c("AI", "BITS", "EVHOE", "FR-CGFS", "IE-IGFS", "NIGFS", "NS-IBTS", 
                                    "PT-IBTS", "SWC-IBTS", "EBS", "GMEX", "GOA", "NEUS", "Nor-BTS", 
                                    "SCS", "SEUS", "WCANN"), title=c('Aleutian Islands','Baltic Sea','France','English Channel','Ireland','Northern Ireland','North Sea','Portugal','Scotland','Eastern Bering Sea','Gulf of Mexico','Gulf of Alaska','Northeast US','Norway','Maritimes','Southeast US','West Coast US'))
######
# figures
######

# generate many small panels for Fig 1
for(reg in survey_names$survey) {
tmp <- mhw_summary_sat_sst_5_day %>% 
  left_join(survey_summary %>% select(ref_yr, survey, year) %>% distinct()) %>% 
  left_join(survey_names) %>% 
  left_join(haul_info %>% group_by(survey,year) %>% summarise(n=n())) %>% 
  filter(survey==reg)
coeff = 5 
tmpplot <- ggplot(tmp) +
  geom_col(aes(x=year, y=n / coeff), color="white", fill="gray85") +
  geom_line(aes(x=year, y=anom_days, color=anom_days), size=1) + 
  scale_color_gradient(low="#1e03cd", high="#b80d06") +
  scale_y_continuous("MHW duration", sec.axis = sec_axis(~ . * coeff, name = "Sampling events"))+
  labs(title=tmp$title, x="Year") +
  theme_bw()  +
  theme(legend.position = "none",
        panel.grid.major = element_blank(), panel.grid.minor = element_blank()
  )+
  NULL
ggsave(tmpplot, filename=here("figures",paste0("inset_timeseries_",reg,".png")), height=4, width=4, scale=0.8)
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
  mutate(STI_diff = STI - CTI) %>% 
  inner_join(mhw_summary_sat_sst_5_day, by="ref_yr") %>% # get MHW data matched to surveys
  filter(!is.na(STI_diff), mhw_yes_no=="yes") %>% 
  ggplot(aes(x=anom_days, y=wt_mt_log, color=STI_diff, fill=STI_diff)) +
  geom_point(size=0.5, position="jitter") + 
  scale_color_gradient2(midpoint=0, low="#1F78B4", mid="grey",
                        high="#E31A1C") +
  scale_fill_gradient2(midpoint=0, low="#1F78B4", mid="grey",
                       high="#E31A1C")+
  theme_bw() + 
  coord_cartesian(clip = "off") +
  labs(x="Marine heatwave duration (days)", y="Biomass log ratio") +
  geom_hline(aes(yintercept=0), linetype="dashed", color="black") +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), legend.position="none")

#gg_mhw_biomass_point_spp
ggsave(gg_mhw_biomass_point_spp, filename=here("figures","final_sti_cti.png"))

######
# models and stats 
######

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

modeldat <- survey_summary %>% 
  inner_join(mhw_summary_sat_sst_5_day, by="ref_yr") %>% 
  filter(!is.na(wt_mt_log), !is.na(anom_days)) %>% 
  left_join(med_lat)

summary(lm(wt_mt_log ~ anom_days + med_lat + med_lat * anom_days, data = modeldat))
summary(lm(wt_mt_log ~ anom_days + med_lat, data = modeldat))
summary(lm(depth_wt ~ anom_days, data = modeldat %>% filter(mhw_yes_no=="yes")))
summary(lm(wt_mt_log ~ anom_days, data = modeldat %>% filter(mhw_yes_no=="yes")))

# Define the model
model = list(
  wt_mt_log ~ 1 + anom_days, 
  ~ 0 +anom_days
)
fit = mcp(model, data=modeldat)

plot(fit)

model_null = list(
  wt_mt_log ~ 1 + anom_days
)
fit_null = mcp(model_null, data=modeldat)
plot(fit_null)

fit$loo = loo(fit)
fit_null$loo = loo(fit_null)

loo::loo_compare(fit$loo, fit_null$loo)

my.lm <- lm(wt_mt_log ~ anom_days, data = modeldat)
my.seg1 <- segmented(my.lm, seg.Z = ~ anom_days, npsi=1)
# my.seg2 <- segmented(my.lm, seg.Z = ~ anom_days, npsi=2)
# my.seg3 <- segmented(my.lm, seg.Z = ~ anom_int, psi = c(0.25, 0.5, 0.75), npsi=3)
# AIC(my.lm, my.seg1, my.seg2, my.seg3)
AIC(my.lm, my.seg1)$AIC - min(AIC(my.lm, my.seg1)$AIC)
# 
my.fitted <- fitted(my.seg1)
my.model <- data.frame(anom_days = modeldat$anom_days, wt_mt_log = my.fitted)

my.lm.abs <- lm(abs(wt_mt_log) ~ anom_days, data = modeldat)
my.seg1.abs <- segmented(my.lm.abs, seg.Z = ~ anom_days, npsi=1)
my.fitted.abs <- fitted(my.seg1.abs)
my.model.abs <- data.frame(anom_days = modeldat$anom_days, wt_mt_log_abs = my.fitted.abs)

my.lm.int <- lm(wt_mt_log ~ anom_int, data = modeldat)
my.seg1.int <- segmented(my.lm.int, seg.Z = ~ anom_int, npsi=1)
my.fitted.int <- fitted(my.seg1.int)
my.model.int <- data.frame(anom_int = modeldat$anom_int, wt_mt_log = my.fitted.int)
AIC(my.lm.int, my.seg1.int)


my.lm.cti <- lm(cti_log ~ anom_days, data = modeldat)
my.seg1.cti <- segmented(my.lm.cti, seg.Z = ~ anom_days, npsi=1)
my.fitted.cti <- fitted(my.seg1.cti)
my.model.cti <- data.frame(anom_days = modeldat$anom_days, cti_log = my.fitted.cti)
AIC(my.lm.cti, my.seg1.cti)
########
# plots
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

gg_mhw_cti_hist <- survey_summary %>%
  inner_join (mhw_summary_sat_sst_5_day, by="ref_yr") %>% # get MHW data matched to surveys 
  mutate(mhw_yes_no = recode(mhw_yes_no, no="No Marine Heatwave", yes="Marine Heatwave")) %>% 
  ggplot(aes(x=cti_log, group=mhw_yes_no, fill=mhw_yes_no, color=mhw_yes_no)) +
  geom_freqpoly(binwidth=0.05, alpha=0.8, size=2) +
  scale_color_manual(values=c("#E31A1C","#1F78B4")) +
  scale_fill_manual(values=c("#E31A1C","#1F78B4")) +
  theme_bw() + 
  labs(x="CTI Log Ratio", y="Frequency (Survey-Years)") +
  theme(legend.position = "none")
gg_mhw_cti_hist

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


