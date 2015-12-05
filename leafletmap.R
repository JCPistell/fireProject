#load leaflet
library(leaflet)
library(RColorBrewer)

#load data
source("./clustering.R")

#Create color palette
pal = c("red", "blue", "green", "orange", "brown", "steelblue", "black", "purple", "yellow", "grey")
factpal <- colorFactor(pal, station5.clean.select$IncidentTypeCategory)

#Build Map in leaflet
map <- leaflet(data = station5.clean.select) %>% setView(lng = -104.8, lat = 39.7, zoom = 12) %>% 
    addProviderTiles("Stamen.Toner") %>% 
    addRectangles(lng1 = -104.810313, lat1 = 39.759473, lng2 = -104.788854, lat2 = 39.732902,
                  color = "red", fillOpacity = .2) %>%
    addCircleMarkers(~lng, ~lat,
                     radius = 4,
                     color = ~factpal(IncidentTypeCategory),
                     stroke = FALSE,
                     fillOpacity = 0.3,
                     #clusterOptions = markerClusterOptions(),
                     popup = ~paste("#:", IncidentNumber, "<br>", 
                                    "Time:", TimeandDateofCall, "<br>", 
                                    "Category:", IncidentTypeCategory, "<br>", 
                                    "Coords:", lat, lng, sep = " ")) %>%
    addMarkers(lng = -104.791636, lat = 39.736827, popup = "Station 5") %>%
    addMarkers(~lng, ~lat, popup = ~clustID, data = kmCenters) %>%
    addLegend(position = "bottomright", 
              pal = factpal, 
              values = ~IncidentTypeCategory,
              opacity = 1,
              title = "Incident Type")
