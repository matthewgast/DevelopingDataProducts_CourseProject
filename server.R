library(shiny)
library(ggplot2)

#source("read-airline-delay-data.R")
#source("airline-delay-support-functions.R")

function(input, output) {

  
  flightData <- reactive({
    delayMatch(ytd.2015.delay,
                              airline=input$selectedAirlines,
                             from=input$selectedAirports,
               cxl=input$canceledFlights
    )
  })
  
  delayCalc <- reactive ({
    summarizeFlightDelayData(flightData())
  })
  
  output$airlines <- renderText({
    input$selectedAirlines
  })
  output$airports <- renderText({
    input$selectedAirports
  })
  output$cancel <- renderText({
    input$canceledFlights
  })
  
  output$count <- renderText({
    paste("selected flight count is",nrow(flightData()))
  })
  
  output$controlCount <- renderText({
    paste("total flights in database is ",nrow(ytd.2015.delay))
  })
  
  output$flightTable <- renderDataTable({
    flightData()
  }
  )
  
  output$delayTable <- renderDataTable({
    delayCalc()
  })
  
  output$delayPlot <- renderPlot({
    ggplot(delayCalc(),aes(x=Airline,y=Delay)) + geom_bar(stat="identity") + facet_grid(City~.)+theme(axis.text.x=element_text(angle=45))
  })
}