library(DT)
library(shiny)
library(magick)
library(tidyverse)
library(leaflet)
library(PetFindr)


ui <- navbarPage("PetFinder",
                 tabPanel("Search by Animals",
                          fluidRow(
                            sidebarPanel(
                              numericInput(inputId = "location", 50014,
                                           label = "Your ZIP code"),
                              numericInput(inputId = "distance", 50,
                                           label = "How far away?"),
                              selectInput(inputId = "animal",
                                          label = "What kind of pet are you looking for:",
                                          choices = c("dog", "cat", "rabbit",
                                                      "smallfurry","horse", "bird", 
                                                      "scales, fins, & other", "barnyard")),
                              selectInput(inputId = "status",
                                          label = "Status of the pet:",
                                          choices = c("adoptable", "adopted", "found")),
                              numericInput(inputId = "limit", 50,
                                           label = "Number of Pets to show:")
                            ),
                            mainPanel(
                              h1("Pets in your location"),
                              DT::dataTableOutput("table"),
                              column(6, 
                                     leafletOutput("map1")),
                              column(6, 
                                     imageOutput("photos"))
                              #textOutput("table")
                            )
                          )
                 ),
                 tabPanel("Location of shelters")
)


server <- function(input, output) {
  
  output$table <- DT::renderDataTable(DT::datatable({
    key <- "Z69HqIlhMDkYHo9HCKH78NwtP2v8Js2YlqZs2heB887n5ePUpF"
    secret <- "X7RUPlGuPkbXP0gNXz8r2KfpZUfb5EB1pg4neruZ"
    token <- pf_accesstoken(key, secret)
    data <- do.call(PetFindr::pf_find_pets, args = list(token=token, location=input$location, distance=input$distance, type=input$animal,
                                                        status=input$status, limit=input$limit))
    
    data %>% 
      select(c("organization_id", "type", "status", "contact.address.address1", "contact.address.city", "contact.phone"))
  }, selection = "single")
  )
  
  
  
  output$map1 <- renderLeaflet({
    key <- "Z69HqIlhMDkYHo9HCKH78NwtP2v8Js2YlqZs2heB887n5ePUpF"
    secret <- "X7RUPlGuPkbXP0gNXz8r2KfpZUfb5EB1pg4neruZ"
    token <- pf_accesstoken(key, secret)
    data <- do.call(PetFindr::pf_find_pets, args = list(token=token, location=input$location, distance=input$distance, type=input$animal,
                                                        status=input$status, limit=input$limit))
    
    observeEvent(input$table_rows_selected, {
      row_selected = data[as.numeric(input$table_rows_selected),]
      selected <- pf_locate_organizations(token, row_selected)
      
      proxy <- leafletProxy('map1', data=selected)
      proxy %>%
        removeMarker(layerId = "selected") %>%
        addAwesomeMarkers(lng=~longitude,
                          lat=~latitude, layerId = "selected")
    })
    
    org_df <- pf_locate_organizations(token, data)
    
    org_sum <- data %>% group_by(organization_id) %>%
      summarise(sum = length(id))
    
    df_map <- merge(org_df, org_sum, by.x = "id", by.y = "organization_id")
    leaflet()  %>%
      addProviderTiles("Esri.WorldStreetMap") %>%
      addCircleMarkers(data=df_map, lat = ~latitude, lng = ~longitude, radius = ~sum,
                       popup = ~paste("Name of Organization:", name, "<br>",
                                      "City:", city, state, "<br>",
                                      "Number of Pets:", sum))
    
    
  })
  
  output$photos = renderImage({
    key <- "Z69HqIlhMDkYHo9HCKH78NwtP2v8Js2YlqZs2heB887n5ePUpF"
    secret <- "X7RUPlGuPkbXP0gNXz8r2KfpZUfb5EB1pg4neruZ"
    token <- pf_accesstoken(key, secret)
    data <- do.call(PetFindr::pf_find_pets, args = list(token=token, location=input$location, distance=input$distance, type=input$animal,
                                                        status=input$status, limit=input$limit))
    
    data$number <- c(1:nrow(data))
    
    validate(
      need(input$table_rows_selected, "Please select a pet")
    )
    
    selected_df <- data %>% filter(number == as.numeric(input$table_rows_selected))
    
    photo.dat <- pf_view_photos(selected_df, size="medium") %>%
      image_write(tempfile(fileext='jpg'), format = 'jpg')
    list(src = photo.dat, contentType = "image/jpg")
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)


