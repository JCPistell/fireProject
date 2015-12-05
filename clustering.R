library(dplyr)
setwd("~/Classes/Fall/AnalyticsLabs/finalProject")
load("./output/geodata2.Rda")

clusterSet <- select(station5.clean.select, lat, lng)

k = 6
set.seed(11235)
clusters <- kmeans(x = clusterSet, centers = k)

kmCenters <- clusters$centers
kmCenters <- as.data.frame(kmCenters)
kmCenters$clustID <- paste("Cluster", 1:k, sep = " ")
