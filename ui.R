##
## Matthew Gast
## October 2015
##
## This file contains R code to read in US DOT data on airline delays
## for further processing of the airline delay data set for the
## Coursera "Developing Data Products" course in the Johns Hopkins
## Data Science Specialization

fluidPage(
  
  titlePanel("Air Transport Pain Explorer"),

  # Input panel: select airlines, airports, and whether to analyze
  # canceled or flown flights
  sidebarPanel(
    checkboxGroupInput('selectedAirlines', 'Airlines:',
                       as.character(airlineList), selected=airlineList),
    checkboxGroupInput('selectedAirports', 'Airports:',
                       as.character(top10AirportList$From),
                       selected=top10AirportList$From),
    radioButtons('canceledFlights','Canceled flights?', c("No","Yes"))
  ),

  # Output panel: plot delays and show raw data in the table
  mainPanel(
    plotOutput("delayPlot"),
    dataTableOutput(outputId="delayTable")
  )
)
