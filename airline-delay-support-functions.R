delayMatch <- function (input.df, ...) {
  
  arglist <- list(...)  
  result.df <- input.df
  
  if (is.not.null(arglist$airline)) {
    result.df <- result.df %>%
      filter(Airline %in% arglist$airline)
  }
  if (is.not.null(arglist$from)) {
    #turn airports into a list to match against
    #fromlist <- as.list(arglist$from)
    result.df <- result.df %>%
      filter(From %in% arglist$from)
  }
  if (is.not.null(arglist$cxl)) {
    result.df <- result.df %>%
      filter(Canceled %in% arglist$cxl)
  }
  
  return (result.df)
}

summarizeFlightDelayData <- function (in.df) {
  summ.df <- in.df %>% group_by(airlineCode,City) %>% summarize(mean(DepartDelay,na.rm=TRUE))
  names(summ.df) <- c("Airline","City","Delay")
  return(summ.df)
}

is.not.null <- function(x) ! is.null(x)

# There are 300 airports in the list, find the top 10 busiest
top10AirportList <- ytd.2015.delay %>% group_by(From) %>% summarize(count=n()) %>% arrange(desc(count)) %>% head(10)

airlineList <- sort(unique(ytd.2015.delay$Airline))
airlineNames <- strsplit(as.character(airlineList),":")
airlineCodes <- substr(sapply(airlineNames, "[[",2),2,3)
