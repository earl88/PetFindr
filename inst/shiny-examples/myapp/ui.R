library(shiny)
library(zipcode)
library(tidyr)
library(leaflet)
library(PetFindr)

ui <- fluidPage(
  
  titlePanel("Find Animal Shelters Near You!"),
  
  sidebarPanel(
    textInput("Zipcode", "Enter a 5-digit U.S. ZIP (postal) code to see the shelters:", value="50010"),
    selectInput("Distance", "Input miles from the zip code:", choices = seq(50, 500, by=50), selected = "100"),
    submitButton("Submit"),
    width = 4),
  
  mainPanel(
    tabsetPanel(
      tabPanel("Animal Shelters", leafletOutput("plot"),
               width = 8)
    )
  )
)