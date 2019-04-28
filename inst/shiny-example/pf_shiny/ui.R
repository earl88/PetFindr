shinyUI(
  navbarPage(
    "PetFinder",
    tabPanel(
      "Search by Animals",
      fluidRow(
        sidebarPanel(width = 2,
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
            numericInput(inputId = "num_animals", value = 50,
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
            column(8, 
                   leafletOutput("map1")),
            column(4,
                   imageOutput("photos"))
          )
          
          #textOutput("table")
        )
      )
    ),
    tabPanel(
      "Search by Organizations",
      fluidRow(
        sidebarPanel(width = 2,
          textInput(inputId = "location_org", "50014",
                    label = 'Location (City, State; Latitude, Longitude; or Zipcode)'),
          numericInput(inputId = "distance_org", 50,
                       label = "Search Radius (miles)"),
          numericInput(inputId = "num_orgs", 50,
                       label = "Number of Organizations to show:"),
          actionButton("search_org","Search")
          ),
        mainPanel(
          fluidRow(
            column(12,
                   h1("Organizations in your location"), 
                   leafletOutput("map2")
            )
          ),
          br(),
          fluidRow(
            column(6, 
                   DT::dataTableOutput("list_table")),
            column(6,
                   plotlyOutput("bars"))
          )
        )
      )
    )
  )
)
