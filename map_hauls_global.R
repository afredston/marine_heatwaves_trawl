#This code produces maps to exhibit heat wave data
#Contact Zoe Kitchel for questions
########
# load packages
########

library(data.table)
library(rgdal)
library(raster)
library(sp)
library(rnaturalearth)
library(rnaturalearthdata)
library(rgeos)
library(geosphere)  #to calculate distance between lat lon of grid cells
library(googledrive)
library(here)
library(sf)
library(cowplot)
library(ggplot2)
library(pals)
library(concaveman)
library(ggforce)

#pacific centered base
# install.packages("remotes")
remotes::install_github("FRBCesab/robinmap")
library("robinmap")

##Load Data
haul_info <- fread(here::here("processed-data","haul_info.csv"))


#if positive, subtract 360
haul_info[,longitude_s := ifelse(longitude > 150,(longitude-360),(longitude))]

#delete if NA for longitude or latitude
haul_info.r <- haul_info[complete.cases(haul_info[,.(longitude, latitude)])]

#alternative

data("wrld_simpl", package = "maptools")                                                                            
wm_polar <- crop(wrld_simpl, extent(-180, 180, 22, 90))  

# Defines the x axes required
x_lines <- seq(-120,180, by = 60)

#polar
basemap_polar <- ggplot() +
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
        axis.line = element_blank(), axis.ticks = element_blank())
  
  
##########
#distinctive color palette
survey_palette <- c("#AAF400","#B5EFB5","#F6222E","#FE00FA", 
                     "#16FF32","#3283FE","#FEAF16","#B00068", 
                     "#1CFFCE","#90AD1C","#2ED9FF","#DEA0FD", 
                     "#AA0DFE","#F8A19F","#325A9B","#C4451C", 
                     "#1C8356","#66B0FF")
#add survey points
survey_regions_polar <- basemap_polar + geom_point(data = haul_info.r, aes(x = longitude, y = latitude, color = survey), alpha = 0.8, shape = 20, size = 0.00000000000001) +
  scale_color_manual(values = survey_palette) + theme(legend.position = "none")

#save global map
ggsave(survey_regions_polar, path = here::here("figures"), filename = "survey_regions_polar.jpg",height = 5, width = 6, unit = "in")

###polygons instead of points
#leave out AI for now
haul_info.r.noAI <- haul_info.r[survey != "AI",]
haul_info.r.AI <- haul_info.r[survey == "AI",]

#split points into list all but ai
haul_info.r.split <- split(haul_info.r.noAI, haul_info.r.noAI$survey)
haul_info.r.split.sf <- lapply(haul_info.r.split, st_as_sf, coords = c("longitude", "latitude"))
haul_info.r.split.concave <- lapply(haul_info.r.split.sf, concaveman, concavity = 3, length_threshold = 2)
haul_info.r.split.concave.binded <- do.call('rbind', haul_info.r.split.concave)
haul_info.r.split.concave.binded.spdf <- as_Spatial(haul_info.r.split.concave.binded)

#split AI points into list
haul_info.r.AI.split <- split(haul_info.r.AI, haul_info.r.AI$survey)
haul_info.r.AI.split.sf <- lapply(haul_info.r.AI.split, st_as_sf, coords = c("longitude_s", "latitude"))
haul_info.r.AI.split.concave <- lapply(haul_info.r.AI.split.sf, concaveman, concavity = 5, length_threshold = 2)
haul_info.r.AI.split.concave.binded <- do.call('rbind', haul_info.r.AI.split.concave)
haul_info.r.AI.split.concave.binded.spdf <- as_Spatial(haul_info.r.AI.split.concave.binded)


#merge
haul_info.r.split.concave.binded_merge <- rbind(haul_info.r.AI.split.concave.binded,
                                                   haul_info.r.split.concave.binded)

#haul_info.r.split.concave.binded_merge.spdf <- as_Spatial(haul_info.r.AI.split.concave.binded_merge)
# Alexa hacky fix to drop AI
haul_info.r.split.concave.binded_merge.spdf <- as_Spatial(haul_info.r.split.concave.binded)

haul_info.r.split.concave.binded_merge.spdf$survey <- levels(as.factor(haul_info.r[!haul_info.r$survey=='AI',]$survey))


#add these polygons to map
#add survey polygons
#and rearrange order

survey_regions_polar_polygon <- ggplot() +
  geom_polygon(data = haul_info.r.split.concave.binded_merge.spdf,
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



survey_regions_polar_polygon <- basemap_polar +
  geom_polygon(data = haul_info.r.split.concave.binded_merge.spdf,
          aes(x = long, y = lat, group = group, fill = group, color = group),
               alpha = 0.8) +
  scale_color_manual(values = survey_palette) +
  scale_fill_manual(values = survey_palette)  +  
  theme(legend.position = "none")

#what abouttt

