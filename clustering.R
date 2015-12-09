library(dplyr)
setwd("~/Classes/Fall/AnalyticsLabs/finalProject")
load("./output/geodata2.Rda")

clusterSet <- select(station5.clean.select, lat, lng)

firecluster <- function(k) {
	set.seed(11235)
	clusters <- kmeans(x = clusterSet, centers = k)
	station5.clean.select$cluster <<- clusters$cluster
	kmCenters <- clusters$centers
	kmCenters <- as.data.frame(kmCenters)
	kmCenters$clustID <- paste("Cluster", 1:k, sep = " ")
	kmCenters$size <- clusters$size
	kmCenters$weight <- sapply(kmCenters$size, function(x) x/sum(kmCenters$size))
	return(kmCenters)
}
