shinyUI(navbarPage("PetFinder",
                 tabPanel("Search by Animals",
                          fluidRow(
                            sidebarPanel(
                              textInput("key", "Key", ifelse(exists("petfindr_key"), petfindr_key, "Paste your key here")),
                              textInput("secret", "Secret", ifelse(exists("petfindr_secret"), petfindr_secret, "Paste your secret here")),
                              numericInput(inputId = "location", 50014,
                                           label = "Zip code"),
                              numericInput(inputId = "distance", 50,
                                           label = "Search Radius (miles)"),
                              selectInput(inputId = "animal",
                                          label = "What kind of pet are you looking for?",
                                          choices = c("Dog", "Cat", "Rabbit",
                                                      "Small & furry", "Horse",
                                                      "Bird", 
                                                      "Scales, fins, & other",
                                                      "Barnyard")),
                              selectInput(inputId = "status",
                                          label = "Pet Status",
                                          choices = c("Adoptable", "Adopted", "Found")),
                              numericInput(inputId = "limit", 50,
                                           label = "Number of Pets to show:"),
                              actionButton("search","Search")
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
