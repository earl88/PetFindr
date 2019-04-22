library(DT)
library(shiny)
library(plotly)
library(tidyverse)
library(PetFindr)


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
             column(6, plotlyOutput("bar")),
             column(6, plotlyOutput("companies"))
             #textOutput("table")
           )
         )
       ),
       tabPanel("Location of shelters")
)



server <- function(input, output) {

  #  dat <-  pf_find_pets(token=token, location=50014)

  
  output$table <- DT::renderDataTable(DT::datatable({
    key <- "Z69HqIlhMDkYHo9HCKH78NwtP2v8Js2YlqZs2heB887n5ePUpF"
    secret <- "X7RUPlGuPkbXP0gNXz8r2KfpZUfb5EB1pg4neruZ"
    token <- pf_accesstoken(key, secret)
    dat <-  pf_find_pets(token=token, location=input$location)
    dat %>% 
      select(c("organization_id", "type", "status", "contact.address.address1", "contact.address.city"))
  })
  )
  
  #   org_df <- pf_merge_organizations(token, dat)
  
}

# Run the application 
shinyApp(ui = ui, server = server)


