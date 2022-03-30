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

#background world_map
world <- ne_countries(scale = "medium", returnclass = "sf") #set up for world map
class(world)

#alternative

library(rgdal)                                                                                                      
library(raster)
library(ggplot2)


data("wrld_simpl", package = "maptools")                                                                            
wm_polar <- crop(wrld_simpl, extent(-180, 180, 22, 90))                                                                   

#polar
basemap_polar <- ggplot() +
  geom_polygon(data = wm, aes(x = long, y = lat, group = group), fill = "azure4", 
              # colour = "black"
              #,
              # alpha = 0.8
              ) +
  
  # Convert to polar coordinates
  coord_map("ortho", orientation = c(50, -50, -20)) +
  scale_y_continuous(breaks = seq(0, 90, by = 5), labels = NULL) +
  
  # Removes Axes and labels
  scale_x_continuous(breaks = NULL) +
  xlab("") + 
  ylab("") +
  
  # Change theme to remove axes and ticks
  theme(panel.background = element_blank(),
        axis.ticks=element_blank())

##########
#distinctive color pallette
survey_pallette <- c("#AAF400","#B5EFB5","#F6222E","#FE00FA", 
                     "#16FF32","#3283FE","#FEAF16","#B00068", 
                     "#1CFFCE","#90AD1C","#2ED9FF","#DEA0FD", 
                     "#AA0DFE","#F8A19F","#325A9B","#C4451C", 
                     "#1C8356","#66B0FF")
#add survey points
survey_regions_polar <- basemap_polar + geom_point(data = haul_info.r, aes(x = longitude, y = latitude, color = survey), alpha = 0.8, shape = 20, size = 0.00000000000001) +
  scale_color_manual(values = survey_pallette) + theme(legend.position = "none")

#save global map
ggsave(survey_regions_polar, path = here::here("figures"), filename = "survey_regions_polar.jpg",height = 5, width = 6, unit = "in")


