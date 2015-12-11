source("./data/keys.R")
library(RCurl)
library(jsonlite)

disturl <- function(origin, destination, return.call = "json", sensor = "false", key = keys[1]) {
    root <- "https://maps.googleapis.com/maps/api/distancematrix/"
    k <- paste(root, return.call, 
               "?origins=", paste(origin, collapse = ","), 
               "&destinations=", paste(destination, collapse = ","), 
               "&key=", key, sep = "")
    return(URLencode(k))
}


distFunc <- function(row, k) {
    origin <- paste(optimizedspot$lats, optimizedspot$lngs, sep = ",")
    destination <- paste(station5.clean.select[row, ]$lat, station5.clean.select[row, ]$lng, sep = ",")
    durl <- disturl(origin, destination, key = k)
    doc <- getURL(durl)
    x <- fromJSON(doc)
    elements <- unlist(x$rows$elements)
    vals <- as.numeric(elements[4])
    return(vals)
}

newtimes <- rep(NA, nrow(station5.clean.select))

for(i in 1:2000) {
    print(paste("Doing row ", i, sep = ""))
    newtimes[i] <- distFunc(i, keys[1])
    print("Done!")
}

for(i in 2001:4000) {
    print(paste("Doing row ", i, sep = ""))
    newtimes[i] <- distFunc(i, keys[3])
    print("Done!")
}

for(i in 4001:nrow(station5.clean.select)) {
    print(paste("Doing row ", i, sep = ""))
    newtimes[i] <- distFunc(i, keys[2])
    print("Done!")
}

station5.clean.select$newtimes <- newtimes

save(station5.clean.select, file = "./output/geodata2.Rda")
