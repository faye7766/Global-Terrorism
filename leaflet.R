library(leaflet)
library(sp)
library(mapproj)
library(maps)
library(mapdata)
library(maptools)
library(htmlwidgets)
library(magrittr)
library(XML)
library(plyr)
library(rgdal)
library(WDI)
library(raster)
library(noncensus)
library(stringr)
library(tidyr)
library(tigris)
library(rgeos)
library(ggplot2)
library(scales)
library(ggmap)

data = read.csv('TerrorData.csv')
data = data[-1]

# make a basic map shows attacks by region all years 

# paste year, month, and day into a single date column
data$Date = paste(data$Year, data$Month, data$Day, sep = '/')

# set blank locations to "Not specified"
data[location == "", location := "Not specified"]

# create the labels
labels <- sprintf(
  "Date: %s  City: %s  Location: %s", data$Date, data$city, data$Target) 

wmap = 
  data %>%
    leaflet() %>%
    addProviderTiles(providers$Esri.NatGeoWorldMap) %>%
    addCircleMarkers(~ longitude,
                     ~ latitude,
                     radius = 5,
                     label = labels,
                     clusterOptions = markerClusterOptions()) %>%
    addMiniMap(tiles = providers$Esri.WorldStreetMap,
               toggleDisplay = TRUE)
saveWidget(wmap, 'Terror_World.html', selfcontained = TRUE)
