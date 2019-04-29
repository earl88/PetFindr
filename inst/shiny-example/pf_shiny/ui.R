shinyUI(
  navbarPage(
    "PetFinder",
    tabPanel(
      "Get Authentication",
      fluidRow(
        sidebarPanel(width = 2, 
                     "Paste your Key and Secret. Then Authenticate!",
                     textInput(
                       "key", "Key", value = "", placeholder = "Paste your key here"),
                     textInput("secret", "Secret", value = "", placeholder = "Paste your secret here"),
                     actionButton("auth", label = "Authenticate"),
                     br(),
                     br(),
                     "In case you do not have petfinder API account, please click the url",
                     actionButton("setup", label = "Get Account")),
        mainPanel(
          fluidRow(
            tags$img(src='logo1.jpg', height = '300px', width = '450px'),
            column(12,
                   uiOutput("instruction")
            )
          )
        )
      )
    ),
    tabPanel(
      "Search by Animals",
      fluidRow(
        sidebarPanel(width = 2,
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
                     conditionalPanel(
                       "output.tokenstatus",
                       textInput(inputId = "location_org", "50014",
                                 label = 'Location (City, State; Latitude, Longitude; or Zipcode)'),
                       numericInput(inputId = "distance_org", 50,
                                    label = "Search Radius (miles)"),
                       numericInput(inputId = "num_orgs", 50,
                                    label = "Number of Organizations to show:"),
                       actionButton("search_org","Search")
                     )
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
    ),
    tabPanel(
      "Thank you!",
      tags$img(src='dogs.gif', height = '400', width = '700', align = "center"),
      br(),
      tags$img(src='cats2.gif', height = '400', width = '600', align = "center")
    )
  )
)
