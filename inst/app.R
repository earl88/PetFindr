library(shiny)
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
                              tableOutput("table")
                              #textOutput("table")
                            )
                          )
                 ),
                 tabPanel("Location of shelters")
)



server <- function(input, output, session) {
  
  output$table <- renderTable({
    #pf_find_pets(token=token, location=50014)
    pf_find_pets(token=token, location=reactive(input$location))
    })
}

# Run the application 
shinyApp(ui = ui, server = server)


