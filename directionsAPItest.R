stationLoc <- c(39.7536827, -104.791636)

url <- function(origin = stationLoc, destination, return.call = "json", sensor = "false", 
                key = "AIzaSyBtFK60px7x9f-8iXidik6SO9v9rXl9X-M") {
    root <- "https://maps.googleapis.com/maps/api/distancematrix/"
    k <- paste(root, return.call, 
    	"?origins=", paste(origin, collapse = ","), 
    	"&destinations=", paste(destination, collapse = ","), 
    	"&key=", key, sep = "")
    return(URLencode(k))
}
