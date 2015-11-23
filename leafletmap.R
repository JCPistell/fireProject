#source api functions and load leaflet
source("/home/jcpistell/Classes/Fall/AnalyticsLabs/finalProject/geocoding.R")
library(leaflet)
library(RColorBrewer)

#Select relevant data from dataframe
station5.clean.select <-  select(station5.clean, IncidentNumber, 
                                 TimeandDateofCall, IncidentTypeCategory)

#Convert Incident Type to factor
station5.clean.select$IncidentTypeCategory <- as.factor(station5.clean.select$IncidentTypeCategory)

#finalize dataframe and save it
station5.clean.select <- cbind(station5.clean.select, df[, 2:3])
station5.clean.select <- filter(station5.clean.select, lng <= -104 & lng >= -105)
#save(station5.clean.select, file = "geodata2.Rda")

#Create color palette
pal = c("red", "blue", "green", "orange", "brown", "steelblue", "black", "purple", "yellow", "grey")
factpal <- colorFactor(pal, station5.clean.select$IncidentTypeCategory)

#Build Map in leaflet
leaflet(data = station5.clean.select) %>% setView(lng = -104.8, lat = 39.7, zoom = 12) %>% 
    addProviderTiles("Stamen.Toner") %>% 
    addRectangles(lng1 = -104.810313, lat1 = 39.759473, lng2 = -104.788854, lat2 = 39.732902,
                  color = "red", fillOpacity = .2) %>%
    addCircleMarkers(~lng, ~lat,
                     radius = 6,
                     color = ~factpal(IncidentTypeCategory),
                     stroke = FALSE,
                     fillOpacity = 1.0,
                     clusterOptions = markerClusterOptions(),
                     popup = ~paste("#:", IncidentNumber, "<br>", 
                                    "Time:", TimeandDateofCall, "<br>", 
                                    "Category:", IncidentTypeCategory, "<br>", 
                                    "Coords:", lat, lng, sep = " ")) %>%
    addMarkers(lng = -104.791636, lat = 39.736827, popup = "Station 5") %>%
    addLegend(position = "bottomright", 
              pal = factpal, 
              values = ~IncidentTypeCategory,
              opacity = 1,
              title = "Incident Type")
