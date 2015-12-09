#load leaflet
library(leaflet)
library(RColorBrewer)

#load data
load("./output/geodata2.Rda")
source("./clustering.R")
source("./distanceFunction.R")

#Build Map in leaflet
firemap <- function(centers, providerTile = "Stamen.Toner") {
    
    #Create icons
    fireIcon <- makeIcon("./data/FireStation.png", 
                         iconWidth = 32, iconHeight = 32, 
                         iconAnchorX = 16, iconAnchorY = 26)
    targetIcon <- makeIcon("./data/target.png",
                           iconWidth = 24, iconHeight = 24,
                           iconAnchorX = 12, iconAnchorY = 12)
    
    #Determine clusters
    kmCenters <<- firecluster(centers)
    
    #Create color palette
    pal <- c("red", "blue", "green", "orange", "brown", "steelblue", "black", "purple", "yellow", "grey")
    pal2 <- brewer.pal(centers, "Dark2")
    factpal <- colorFactor(pal, station5.clean.select$IncidentTypeCategory)
    factpal2 <- colorFactor(pal2, station5.clean.select$cluster)
    
    #Build Map
    
    m <- leaflet(data = station5.clean.select) %>% setView(lng = -104.8, lat = 39.7, zoom = 12) %>% 
        addProviderTiles(providerTile) %>% 
        addRectangles(lng1 = -104.810313, lat1 = 39.759473, 
                      lng2 = -104.788854, lat2 = 39.732902,
                      color = "red", fillOpacity = .2,
                      group = "Station Location Area") %>%
        addCircleMarkers(~lng, ~lat,
                         radius = 4,
                         color = ~factpal2(cluster),
                         stroke = FALSE,
                         fillOpacity = 0.8,
                         #clusterOptions = markerClusterOptions(),
                         popup = ~paste("#:", IncidentNumber, "<br>", 
                                        "Time:", TimeandDateofCall, "<br>", 
                                        "Category:", IncidentTypeCategory, "<br>", 
                                        "Coords:", lat, lng, sep = " "),
                         group = "Cluster Color") %>%
        addCircleMarkers(~lng, ~lat,
                         radius = 4,
                         color = ~factpal(IncidentTypeCategory), 
                         stroke = FALSE,
                         fillOpacity = 0.8,
                         #clusterOptions = markerClusterOptions(),
                         popup = ~paste("#:", IncidentNumber, "<br>", 
                                        "Time:", TimeandDateofCall, "<br>", 
                                        "Category:", IncidentTypeCategory, "<br>", 
                                        "Coords:", lat, lng, sep = " "),
                         group = "Incident Color") %>%
        addMarkers(lng = -104.791636, lat = 39.736827, popup = "Station 5", icon = fireIcon) %>%
        addMarkers(~lng, ~lat, popup = ~clustID, data = kmCenters, group = "Cluster Centers") %>%
        addMarkers(~lngs, ~lats, data = locs, icon = targetIcon, group = "Possible Locations") %>%
        addMarkers(lng = -104.7984, lat = 39.73881, popup = "New Location", icon = fireIcon, group = "Best Spot") %>%   #This may need to move
        addLegend(position = "bottomleft", 
                  pal = factpal2, 
                  values = ~cluster,
                  opacity = 1,
                  title = "Cluster") %>%
        addLegend(position = "bottomright", 
                  pal = factpal, 
                  #values = ~IncidentTypeCategory,  #uncomment for incident type
                  values = ~IncidentTypeCategory,
                  opacity = 1,
                  title = "Incident Type") %>%
        addLayersControl(
            baseGroups = c("Incident Color", "Cluster Color"),
            overlayGroups = c("Station Location Area", "Cluster Centers", "Possible Locations", "Best Spot"),
            options = layersControlOptions(collapsed = FALSE))
    return(m)
}
