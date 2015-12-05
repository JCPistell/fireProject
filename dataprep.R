#source api functions and load leaflet
source("/home/jcpistell/Classes/Fall/AnalyticsLabs/finalProject/geocoding.R")

#Select relevant data from dataframe
station5.clean.select <-  select(station5.clean, IncidentNumber, 
                                 TimeandDateofCall, IncidentTypeCategory)

#Convert Incident Type to factor
station5.clean.select$IncidentTypeCategory <- as.factor(station5.clean.select$IncidentTypeCategory)

#finalize dataframe and save it
station5.clean.select <- cbind(station5.clean.select, df[, 2:3])
station5.clean.select <- filter(station5.clean.select, lng <= -104 & lng >= -105)
#save(station5.clean.select, file = "./output/geodata2.Rda")
