load("./output/potentialLocations.Rda")
load("./output/clusterCenters.Rda")

weighter <- function(row) {
    cols <- paste("Cluster", 1:6, "Time", sep = "")
    x <- as.numeric(locs[row, cols])
    w <- kmCenters$weight
    weightedtime <- weighted.mean(x, w)
    return(weightedtime)
}

wvec <- sapply(1:nrow(locs), function(x) weighter(x))
locs$weightedtimes <- wvec
