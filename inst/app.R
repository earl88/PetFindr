library(shiny)
library(tidyr)
library(leaflet)
library(tidyverse)

pet_fun <- function(x) {
  tibble(
    name = xml_node(x, "name") %>% xml_text(),
    breed = xml_nodes(x, "breed") %>% xml_text() %>% paste(collapse = ", "),
    age = xml_node(x, "age") %>% xml_text(),
    sex = xml_node(x, "sex") %>% xml_text(),
    id = xml_node(x, "id") %>% xml_text(),
    shelterID = xml_node(x, "shelterId") %>% xml_text()
  )
}

ui <- navbarPage("Iowa Liquor Sales",
                 tabPanel("Locations of Liquor Stores",
                          fluidRow(
                            sidebarPanel(
                              numericInput(inputId = "location", 50014,
                                         label = "Your ZIP code"),
                              selectInput(inputId = "animal",
                                        label = "What kind of pet are you looking for:",
                                        choices = c("cat", "dog", "smallfurry", "barnyard", "bird", "horse", "reptile"))
                              ),
                            mainPanel(
                              h1("Pets in your location"),
                              DT::dataTableOutput("table")
                              )
                            )
                          ),
                 tabPanel("Location of shelters")
                 )


# Define server logic required to draw a histogram
server <- function(input, output) {
  
  output$table <- DT::renderDataTable(
    
      DT::datatable({
        selectedzip <- input$location
        selectedpet <- input$animal
        
        key <- "key="
        base_url <- "http://api.petfinder.com/"
        method <- "pet.find"
        
        query <- paste0("animal=", selectedpet, "&", "location=", selectedzip)
        url <- sprintf("%s%s?%s&%s", base_url, method, key, query)
        pets_list <- read_xml(url) %>% xml_nodes("pet")
        
        pet_df <- pets_list %>% purrr::map_df(pet_fun)
        
        pet_df
        
        }, options = list(pageLength = 20, dom = "tip"))
      
  )
}

# Run the application 
shinyApp(ui = ui, server = server)


