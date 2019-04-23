
library(shiny)
library(zipcode)
library(tidyr)
library(leaflet)
library(PetFindr)
library(tidyverse)

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

##


###
server <- function(input, output) {
  zipmap <- read.csv("C:/Users/Jessica Lee K/Desktop/ISU Stat/Spring 2918/Stat 585/FinalProject585/inst/extdata/uszip.txt", colClasses = c("character", rep("numeric", 2)))
  
  output$plot <- renderLeaflet({
    
    validate(need(!is.na(input$Zipcode), "Zipcode must not be NA. Please enter a zip code"))
    validate(need(!is.na(input$Distance), "Distance must not be NA. Please enter a valid distance"))
    
    data <-do.call(PetFindr::pf_find_organizations, args = list(token=token, location=input$Zipcode, distance = input$Distance)) %>%
      left_join(zipmap, by = c("address.postcode" = "ZIP")) %>%
      select(address.postcode, LAT, LNG, name)
    
    # print(head(data))
    
    leaflet(data = data) %>%
      addTiles() %>%
      addMarkers(lat = data$LAT, lng = data$LNG, popup = ~data$name)
  })
}
### print n rows of data
  
  
  
  # Run the application 
shinyApp(ui = ui, server = server)

#leaflet(data = merge(pf_find_organizations(token, country = "US", location = 50010, distance = 100, limit = 100, page = 1)), zipcode, by="address.postcode", by.y="zip") %>% addTiles() %>%
 # addCircleMarkers(~longitude, ~latitude, popup = ~name, label = ~name)  


#data = merge(pf_find_organizations(token, country = "US", location = 50010, distance = 100, limit = 100, page = 1),zipcode, by="address.postcode", by.y="zip") 
