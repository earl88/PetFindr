shinyUI(
  navbarPage(
    "PetFinder",
    tabPanel(
      "Search by Animals",
      fluidRow(
        sidebarPanel(
          textInput(
            "key", "Key", value = "", placeholder = "Paste your key here"),
          textInput("secret", "Secret", value = "", placeholder = "Paste your secret here"),
          actionButton("auth", label = "Authenticate"),
          br(),
          conditionalPanel(
            "output.tokenstatus",
            textInput(inputId = "location", "50014",
                      label = 'Location (City, State; Latitude, Longitude; or Zipcode)'),
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
            numericInput(inputId = "num_animals", value = 50, min = 0,
                        label = "Number of Pets to show:"),
            actionButton("search","Search")
          )
        ),
        mainPanel(
          fluidRow(
            column(12,
              h1("Pets in your location"),
              DT::dataTableOutput("table")
            )
          ),
          br(),
          fluidRow(
            column(6, 
                   leafletOutput("map1")),
            column(6,
                   imageOutput("photos"))
          )
          
          #textOutput("table")
        )
      )
    ),
    tabPanel("Location of shelters")
  )
)
