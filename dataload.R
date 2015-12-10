rm(list = ls())
setwd("~/Classes/Fall/AnalyticsLabs/finalProject/")
library(readxl)
library(dplyr)

fireData <- read_excel("./data/fireData_newdata.xlsx")

#rename columns
names(fireData) <- sapply(names(fireData),
                          function(x) gsub(" ", "", x))

#filter only station 5 and only years 2013 & 2014. Remove nonemergent activity
station5 <- filter(fireData, StationDistrict == "Aurora Station 5")
station5.clean <- filter(station5, IncidentYear == 2014 | IncidentYear == 2013) %>% 
    filter(IncidentTypeCategory != "Non Emergent Activity")

