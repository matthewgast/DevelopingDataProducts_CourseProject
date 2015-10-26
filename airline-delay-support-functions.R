##
## Matthew Gast
## October 2015
##
## This file contains R code to read in US DOT data on airline delays
## for further processing of the airline delay data set for the
## Coursera "Developing Data Products" course in the Johns Hopkins
## Data Science Specialization

delayMatch <- function (input.df, ...) {
    
# This function takes an input data frame and returns a subset data
# frame that matches the operating airline, the departure airport, and
# whether or not the flight was canceled.
#
# Input: A data frame to subset, and optionally, arguments specified
# with airline=, from=, and cxl= to indicate a list of airlines to
# select, a list of departure airports to select, and whether or not
# the flight was canceled.
#
# Output: A data frame with a list of flights matching the specified
# criteria.  It may be empty if no flights match.
    
  arglist <- list(...)  
  result.df <- input.df
  
  if (is.not.null(arglist$airline)) {
    result.df <- result.df %>%
      filter(Airline %in% arglist$airline)
  }
  if (is.not.null(arglist$from)) {
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

# This function summarizes the average departure delay by city and
# airline.  It is used in the shiny architecture to return a data
# frame into a reactive expression.
#
# Input: A data frame with many flights
#
# Output: A data frame that has the average departure delay for each city pair.

  summ.df <- in.df %>% group_by(airlineCode,City) %>% summarize(mean(DepartDelay,na.rm=TRUE))
  names(summ.df) <- c("Airline","City","Delay")
  return(summ.df)
}

is.not.null <- function(x) ! is.null(x)
# Simple function to improve readability.
