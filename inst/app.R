library(shiny)
library(plotly)
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
                              DT::dataTableOutput("table"),
                              column(6, 
                                     plotlyOutput("bar")),
                              column(6, 
                                     plotlyOutput("companies"))
                              #textOutput("table")
                            )
                          )
                 ),
                 tabPanel("Location of shelters")
)



server <- function(input, output) {

  
#  dat <-  pf_find_pets(token=token, location=50014)
  dat <-  pf_find_pets(token=token, location=input$location)
  
    output$table <- DT::renderDataTable(DT::datatable({
      dat %>% 
        select(c("organization_id", "type", "status", "contact.address.address1", "contact.address.city"))
    })
    )
    
 #   org_df <- pf_merge_organizations(token, dat)

}

# Run the application 
shinyApp(ui = ui, server = server)


