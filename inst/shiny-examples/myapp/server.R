library(shiny)
library(zipcode)
library(tidyr)
library(readr)
library(leaflet)
library(PetFindr)
library(tidyverse)

server <- function(input, output) {
  zipmap <- read_csv("https://gist.githubusercontent.com/erichurst/7882666/raw/5bdc46db47d9515269ab12ed6fb2850377fd869e/US%2520Zip%2520Codes%2520from%25202013%2520Government%2520Data")
  
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

shinyApp(ui = ui, server = server)