##
## Matthew Gast
## October 2015
##
## This file contains R code to read in US DOT data on airline delays
## for further processing of the airline delay data set for the
## Coursera "Developing Data Products" course in the Johns Hopkins
## Data Science Specialization

# Begin by reading in the data
source("read-airline-delay-data.R")
source("airline-delay-support-functions.R")

function(input, output) {

  # Select data based on user inputs
  flightData <- reactive({
    delayMatch(ytd.2015.delay,
               airline=input$selectedAirlines,
               from=input$selectedAirports,
               cxl=input$canceledFlights)
  })

  # Take data selected by previous function and calculate average
  # delay
  delayCalc <- reactive ({
    summarizeFlightDelayData(flightData())
  })

  # Prepare output table based on the data
  output$delayTable <- renderDataTable({
    delayCalc()
  })

  # Prepare output plot based on selected data
  output$delayPlot <- renderPlot({
    ggplot(delayCalc(),aes(x=Airline,y=Delay)) +
        geom_bar(stat="identity") + facet_grid(City~.) +
        theme(axis.text.x=element_text(angle=45))
  })
}
