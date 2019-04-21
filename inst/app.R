library(shiny)
library(tidyverse)
library(tibble)
library(rvest)
library(PetFindr)

ui <- navbarPage("PetFinder",
                 tabPanel("Search by Animals",
                          fluidRow(
                            sidebarPanel(
                              textInput(inputId = "location", 50014,
                                           label = "Your ZIP code"),
                              numericInput(inputId = "distance", 10,
                                           label = "How far away?"),
                              selectInput(inputId = "animal",
                                          label = "What kind of pet are you looking for:",
                                          choices = c("dog", "cat", "rabbit",
                                                      "smallfurry","horse", "bird", 
                                                      "scales, fins, & other", "barnyard")),
                              selectInput(inputId = "status",
                                          label = "Status of the pet:",
                                          choices = c("adopted", "adoptable", "found")),
                              submitButton("Submit")
                            ),
                            mainPanel(
                              h1("Pets in your location"),
                              textOutput("table")
                              #textOutput("table")
                            )
                          )
                 ),
                 tabPanel("Location of shelters")
)


# Define server logic required to draw a histogram
server <- function(input, output, session) {
  
  output$table <-renderText(
   pf_find_pets(token=token, location = reactive(input$location))
   )
}

# Run the application 
shinyApp(ui = ui, server = server)


