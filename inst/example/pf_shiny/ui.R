shinyUI(navbarPage("PetFinder",
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
)
