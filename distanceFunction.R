library(RCurl)
library(jsonlite)

lngs <- seq(lng1, lng2, length.out = 10)
lats <- seq(lat1, lat2, length.out = 10)
locs <- expand.grid(lats, lngs)
names(locs) <- c("lats", "lngs")

source("./data/keys.R")

disturl <- function(origin, destination, return.call = "json", sensor = "false", key = keys[1]) {
    root <- "https://maps.googleapis.com/maps/api/distancematrix/"
    k <- paste(root, return.call, 
               "?origins=", paste(origin, collapse = ","), 
               "&destinations=", paste(destination, collapse = ","), 
               "&key=", key, sep = "")
    return(URLencode(k))
}


distFunc <- function(row, cluster) {
    origin <- paste(locs[row, ]$lats, locs[row, ]$lngs, sep = ",")
    destination <- paste(kmCenters[cluster, ]$lat, kmCenters[cluster, ]$lng, sep = ",")
    durl <- disturl(origin, destination, )
    doc <- getURL(durl)
    x <- fromJSON(doc)
    elements <- unlist(x$rows$elements)
    vals <- c(dist = as.numeric(elements[2]), time = as.numeric(elements[4]))
    return(vals)
}

colMaker <- function(cluster) {
    print(paste("Doing Cluster ", cluster, "!", sep = ""))
    distcol <- paste("Cluster", cluster, "Dist", sep = "")
    timecol <- paste("Cluster", cluster, "Time", sep = "")
    vals <- sapply(1:nrow(locs), function(x) distFunc(x, cluster))
    vals <- as.data.frame(t(vals))
    locs[[distcol]] <<- vals$dist
    locs[[timecol]] <<- vals$time
    print(paste("Done with Cluster ", cluster, "!", sep = ""))
    return(vals)
}
