library(jsonlite)
library(RCurl)

#These functions will be used to query the API
addrMaker <- function(row) {
    street <- station5.clean[row, ]$Location
    zip <- station5.clean[row, ]$ZipCode
    address <- paste(street, "Aurora CO", zip, sep = ", ")
    return(address)
}

url <- function(address, return.call = "json", sensor = "false", key) {
    root <- "https://maps.google.com/maps/api/geocode/"
    u <- paste(root, return.call, "?address=", address, 
               "&sensor=", sensor, "&key=", key, sep = "")
    return(URLencode(u))
}

geoCode <- function(r, k) {
    u <- url(addrMaker(r), key = k)
    doc <- getURL(u)
    x <- fromJSON(doc)
    lat <- x$results$geometry$location$lat
    lng <- x$results$geometry$location$lng
    latlng <- c(lat = lat, lng = lng)
    return(latlng)
}


###################################################################################
#
# This next section does a lot of API queries. Use at your own risk.
# Note: You'll need to provide your own API key
#
###################################################################################

#create empty data frame and load in API keys. You'll need to provide your own.

df <- data.frame(lat = rep(NA, nrow(station5.clean)), lng = rep(NA, nrow(station5.clean)))
source("./data/keys.R")

#Query Maps API

for(i in 1:1800) {
    entry <- geoCode(i, keys[1])
    df[i, 1] <- entry[1]
    df[i, 2] <- entry[2]
}

for(i in 1801:3600) {
    entry <- geoCode(i, keys[2])
    df[i, 1] <- entry[1]
    df[i, 2] <- entry[2]
}

for(i in 3601:5395) {
    entry <- geoCode(i, keys[3])
    df[i, 1] <- entry[1]
    df[i, 2] <- entry[2]
}

#################################################################################
#
# The End!
#
#################################################################################