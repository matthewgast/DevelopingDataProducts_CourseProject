
createLookupTables <- function(dir) {
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

readMonthDelay <- function (file, dir) {
  filepath <- paste(dir, file, sep="/")
  df <- read.csv(filepath)
  
  df <- join(df,airline.id.lookup,by='AIRLINE_ID')
  df <- join(df,airport.origin.lookup,by='ORIGIN_AIRPORT_ID')
  df <- join(df,airport.dest.lookup,by='DEST_AIRPORT_ID')
  df <- join(df,months.lookup,by='MONTH')
  df <- join(df,weekdays.lookup,by='DAY_OF_WEEK')
  df <- join(df,yesno.lookup,by='CANCELLED')
  
  df <- select(df,Weekday,Month,DAY_OF_MONTH,YEAR,Airline,FL_NUM,FromAirport,ToAirport,DEP_DELAY,ARR_DELAY,Canceled)
  names(df) <- c("Weekday","Month","Day","Year","Airline","Flight","From","To","DepartDelay","ArriveDelay","Canceled")
  
  return (df)
}

createLookupTables()
proj.dir <- "/Users/mgast/Dropbox/data-science-specialization/9-developing-data-products/DevelopingDataProducts_CourseProject/data"

jan.delay <- readMonthDelay("2015_01_ONTIME.csv",proj.dir)
feb.delay <- readMonthDelay("2015_02_ONTIME.csv",proj.dir)
mar.delay <- readMonthDelay("2015_03_ONTIME.csv",proj.dir)
apr.delay <- readMonthDelay("2015_04_ONTIME.csv",proj.dir)
may.delay <- readMonthDelay("2015_05_ONTIME.csv",proj.dir)
jun.delay <- readMonthDelay("2015_06_ONTIME.csv",proj.dir)
jul.delay <- readMonthDelay("2015_07_ONTIME.csv",proj.dir)
aug.delay <- readMonthDelay("2015_08_ONTIME.csv",proj.dir)

ytd.2015.delay <- rbind(jan.delay,feb.delay,mar.delay,apr.delay,may.delay,jun.delay,jul.delay,aug.delay)

ytd.2015.delay <- ytd.2015.delay %>% mutate(airlineCode=lapply(strsplit(as.character(Airline),": "),"[[",2))
ytd.2015.delay <- ytd.2015.delay %>% mutate(City=lapply(strsplit(as.character(From),": "),"[[",1))
ytd.2015.delay$airlineCode <- as.character(ytd.2015.delay$airlineCode)
ytd.2015.delay$City <- as.character(ytd.2015.delay$City)