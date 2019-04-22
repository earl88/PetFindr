library(shiny)
library(tidyverse)
library(PetFindr)
library(DT)


ui <- navbarPage("PetFinder",
                 tabPanel("Search by Animals",
                          fluidRow(
                            sidebarPanel(
                              numericInput(inputId = "location", 50014,
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
                                          choices = c("adopted", "adoptable", "found"))
                            ),
                            mainPanel(
                              h1("Pets in your location"),
                              DT::dataTableOutput("table")
                              #textOutput("table")
                            )
                          )
                 ),
                 tabPanel("Location of shelters")
)



server <- function(input, output, session) {

    dat <- reactive({
    my_df <- pf_find_pets(token=token, location=50014, limit=100)
  })
  output$table <- DT::renderDataTable(DT::datatable({
    dat() %>% 
      select(c("organization_id", "type", "status", "contact.address.address1", "contact.address.city"))
    })
    )
}

# Run the application 
shinyApp(ui = ui, server = server)


