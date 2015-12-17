#load leaflet
library(leaflet)
library(RColorBrewer)

#Build Map in leaflet
firemap <- function(centers, providerTile = "Stamen.Toner") {
    
    #Create icons
    fireIcon <- makeIcon("./data/FireStation.png", 
                         iconWidth = 32, iconHeight = 32, 
                         iconAnchorX = 16, iconAnchorY = 16)
    targetIcon <- makeIcon("./data/target.png",
                           iconWidth = 24, iconHeight = 24,
                           iconAnchorX = 12, iconAnchorY = 12)
    
    #Create color palette
    pal <- c("red", "blue", "green", "orange", "brown", "steelblue", "black", "purple", "yellow", "grey")
    pal2 <- brewer.pal(centers, "Dark2")
    factpal <- colorFactor(pal, station5.clean.select$IncidentTypeCategory)
    factpal2 <- colorFactor(pal2, station5.clean.select$cluster)
    
    #Build Map
    
    m <- leaflet(data = station5.clean.select) %>% setView(lng = -104.8, lat = 39.7, zoom = 12) %>% 
        addProviderTiles(providerTile) %>% 
        addRectangles(lng1 = lng1, lat1 = lat1, 
                      lng2 = lng2, lat2 = lat2,
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
        addMarkers(~lngs, ~lats, data = bestspot, 
                   popup = ~paste("Best Avg Response", "<br>",
                                  "Avg Resp. Time: ", round(weightedtimes, 2), "<br>", 
                                  "Max Resp. Time: ", round(max(unlist(bestspot)), 2), "<br>",
                                  "Lat: ", lats, "<br>", 
                                  "Lng: ", lngs, sep = ""), 
                   icon = fireIcon, group = "Best Spot") %>%
        addMarkers(~lngs, ~lats, data = optimizedspot, 
                   popup = ~paste("Optimized Response", "<br>",
                                  "Avg Resp Time: ", round(weightedtimes, 2), "<br>",
                                  "Max Resp Time: ", round(max(unlist(optimizedspot)), 2), "<br>",
                                  "Lat: ", lats, "<br>", 
                                  "Lng: ", lngs, sep = ""), 
                   icon = fireIcon, group = "Best Spot") %>%
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
