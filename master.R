rm(list = ls())
setwd("~/Classes/Fall/AnalyticsLabs/finalProject/") #Set to appropriate location

clusterNumber <- 6
lng1 <- -104.810313
lat1 <- 39.7473982
lng2 <- -104.788854
lat2 <- 39.732902

outputfiles <- list.files("./output/")
if(!"geodata.Rda" %in% outputfiles) {
    source("./dataload.R")
    source("./geocoding.R")
    source("./dataprep.R")
} else{
    load("./output/geodata.Rda")
}

source("./clustering.R")
kmCenters <- firecluster(6)

if(!"potentialLocations.Rda" %in% outputfiles) {
    source("./distanceFunction.R")
    source("./distfunctionloop.R")
    source("./weightedtimes.R")
} else {
    load("./output/potentialLocations.Rda")
}

bestspot <- slice(locs, 1)

source("./leafletmap.R")
map <- firemap(6)
