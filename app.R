library(shiny)
library(maps)
library(mapproj)
counties <- readRDS("counties.rds")
source("helpers.R")

ui <- fluidPage(
  titlePanel("Census Visualization"),
  
  sidebarLayout(
    sidebarPanel(
      code("Create demographic maps with 
        information from the 2010 US Census.", style = "color:black"),
      
      selectInput("var", 
                  label = "Choose a variable to display",
                  choices = c("Percent White", "Percent Black",
                              "Percent Hispanic", "Percent Asian"),
                  selected = "Percent White"),
      
      sliderInput("range", 
                  label = "Range of interest:",
                  min = 0, max = 100, value = c(0, 100))
    ),
    
    mainPanel(plotOutput("map"))
  )
)

server = function(input, output){
  output$map = renderPlot({
    args = switch(input$var,
                  "Percent White" = list(counties$white, "yellow", "%W", input$range[1], input$range[2]),
                  "Percent Black" = list(counties$black, "red", "%B", input$range[1], input$range[2]),
                  "Percent Hispanic" = list(counties$hispanic, "orange", "%H", input$range[1], input$range[2]),
                  "Percent Asian" = list(counties$asian, "pink", "%A", input$range[1], input$range[2]))
    do.call(percent_map,args)
  }) 
}

shinyApp(ui, server)