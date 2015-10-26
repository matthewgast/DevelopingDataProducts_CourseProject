##
## Matthew Gast
## October 2015
##
## This file contains R code to read in US DOT data on airline delays
## for further processing of the airline delay data set for the
## Coursera "Developing Data Products" course in the Johns Hopkins
## Data Science Specialization

loadLibraries <- function() {

# Load required libraries for the application
    
  library(shiny)
  library(MASS)
  library(ggplot2) # Must come before dplyr
  library(plyr)
  library(dplyr)
}

createLookupTables <- function() {

# This function creates lookup tables for the raw data by reading in
# CSV files with data code books.  It then saves the lookup tables
# into the global environment so they can be used by the read process
#
# Input:  None
#
# Output: A series of lookup tables in the global environment.
    
  airline.id.raw <- read.csv("L_AIRLINE_ID.csv-")
  airport.id.raw <- read.csv("L_AIRPORT_ID.csv-")
  months.raw <- read.csv("L_MONTHS.csv-")
  weekdays.raw <- read.csv("L_WEEKDAYS.csv-")
  yesno.raw <- read.csv("L_YESNO_RESP.csv-")
  
  names(airline.id.raw) <- c("AIRLINE_ID","Airline")
  airline.id.lookup <<- airline.id.raw
  
  names(airport.id.raw) <- c("ORIGIN_AIRPORT_ID","FromAirport")
  airport.origin.lookup <<- airport.id.raw
  
  names(airport.id.raw) <- c("DEST_AIRPORT_ID","ToAirport")
  airport.dest.lookup <<- airport.id.raw
  
  names(months.raw) <- c("MONTH","Month")
  months.lookup <<- months.raw
  
  names(weekdays.raw) <- c("DAY_OF_WEEK","Weekday")
  weekdays.lookup <<- weekdays.raw
  
  names(yesno.raw) <- c("CANCELLED","Canceled")
  yesno.lookup <<- yesno.raw
  
}

readMonthDelay <- function (file, dir=getwd()) {

# This function reads a single month of delay data.
#
# Input:  A file name and an optional directory
#
# Output: A data frame containing selected columns in on month of
# data.
    
  if (!is.null(dir)) {
    filepath <- paste(dir, file, sep="/")
  }
  df <- read.csv(filepath)
  
  df <- join(df,airline.id.lookup,by='AIRLINE_ID')
  df <- join(df,airport.origin.lookup,by='ORIGIN_AIRPORT_ID')
  df <- join(df,airport.dest.lookup,by='DEST_AIRPORT_ID')
  df <- join(df,months.lookup,by='MONTH')
  df <- join(df,weekdays.lookup,by='DAY_OF_WEEK')
  df <- join(df,yesno.lookup,by='CANCELLED')
  
  df <- select(df,Weekday,Month,DAY_OF_MONTH,YEAR,Airline,FL_NUM,
               FromAirport,ToAirport,DEP_DELAY,ARR_DELAY,Canceled)
  names(df) <- c("Weekday","Month","Day","Year","Airline","Flight",
                 "From","To","DepartDelay","ArriveDelay","Canceled")
  
  return (df)
}

base.dir <- getwd()
loadLibraries()
setwd("./data/")
createLookupTables()

jan.delay <- readMonthDelay("2015_01_ONTIME.csv")
#Application takes too long to load with all eight months of data,
#restrict to just 1.
#
#feb.delay <- readMonthDelay("2015_02_ONTIME.csv")
#mar.delay <- readMonthDelay("2015_03_ONTIME.csv")
#apr.delay <- readMonthDelay("2015_04_ONTIME.csv")
#may.delay <- readMonthDelay("2015_05_ONTIME.csv")
#jun.delay <- readMonthDelay("2015_06_ONTIME.csv")
#jul.delay <- readMonthDelay("2015_07_ONTIME.csv")
#aug.delay <- readMonthDelay("2015_08_ONTIME.csv")
#ytd.2015.delay <- rbind(jan.delay,feb.delay,mar.delay,apr.delay,may.delay,jun.delay,jul.delay,aug.delay)
ytd.2015.delay <- jan.delay

# Add airline code field to the data, and simplify airport to the origin city.
ytd.2015.delay <- ytd.2015.delay %>% mutate(airlineCode=lapply(strsplit(as.character(Airline),": "),"[[",2))
ytd.2015.delay <- ytd.2015.delay %>% mutate(City=lapply(strsplit(as.character(From),": "),"[[",1))
ytd.2015.delay$airlineCode <- as.character(ytd.2015.delay$airlineCode)
ytd.2015.delay$City <- as.character(ytd.2015.delay$City)

# Return out of the data directory after finishing processing this file.
setwd("..")

# There are 300 airports in the list, find the top 10 busiest to put in the UI
top10AirportList <- ytd.2015.delay %>%
  group_by(From) %>%
  summarize(count=n()) %>%
  arrange(desc(count)) %>%
  head(10)

# Get list of airlines for UI work
airlineList <- sort(unique(ytd.2015.delay$Airline))
airlineNames <- strsplit(as.character(airlineList),":")
airlineCodes <- substr(sapply(airlineNames, "[[",2),2,3)

