library(shiny)
library(ggplot2)

fluidPage(
  
  titlePanel("Air Transport Pain Explorer"),
  
  sidebarPanel(
    
  #  sliderInput("month",
  #              "Month:", 
  #              min = 1,
  #              max = 8,
  #              value = c(1, 8)
  #  )#,
    
#    checkboxGroupInput('airlineList', 'Airlines:', airlineList, selected=airlineList),
    
    checkboxGroupInput('selectedAirlines', 'Airlines:', as.character(airlineList), selected=airlineList),
    checkboxGroupInput('selectedAirports', 'Airports:', as.character(top10AirportList$From), selected=top10AirportList$From),
    
    radioButtons('canceledFlights','Canceled flights?', c("No","Yes"))
    
  ),
  
  mainPanel(
    plotOutput("delayPlot"),
    dataTableOutput(outputId="delayTable")
  )
)