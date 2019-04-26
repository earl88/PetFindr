function(input, output, session) {
  
  if (exists("petfindr_key")) {
    updateTextInput(session, "key", value = petfindr_key)
  }
  if (exists("petfindr_secret")) {
    updateTextInput(session, "secret", value = petfindr_secret)
  }
  
  get_token <- reactive({
    if (input$auth > 0) {
      key <- req(isolate(input$key))
      secret <- req(isolate(input$secret))
      token <- pf_accesstoken(key, secret)
    } else {
      token <- ""
    }
    validate(need(nchar(token) > 0, "Please authenticate - add your key and secret, then click the Authenticate button"))
    token
  })
  
  
  output$tokenstatus <- reactive({
    nchar(get_token() > 0)
  })
  
  outputOptions(output, "tokenstatus", suspendWhenHidden = FALSE)

  petdata <- reactive({
    # add dependency on search button
    input$search
    
    req <- as.numeric(isolate(input$num_animals))
    if(req <= 100) {
      limit <- req
      page <- 1
    } else {
      limit <- 100
      page <- ceiling(req / 100)
    }
    
    if(!is.na(isolate(input$distance))) {
      validate(need(isolate(input$location), "To specify Distance, you must specify Location"))
    }
    
    data <- do.call(PetFindr::pf_find_pets, 
                    args = list(token = get_token(), 
                                location = isolate(input$location), 
                                distance = isolate(input$distance), 
                                type = isolate(input$animal),
                                status = isolate(input$status), 
                                limit = limit, page = page))
    data <- data[1:req,]
  })
  
  output$table <- DT::renderDataTable(DT::datatable({
    validate(need(nrow(petdata()) > 0, "No pets found. Are your search parameters too narrow?"))
    
    colnames <- c("name", "breeds.primary", "organization_id", "type", 
                  "contact.address.address1", "contact.address.city", 
                  "contact.phone")
    
    petdata() %>% 
      select(names(petdata())[names(petdata()) %in% colnames])
  }, selection = "single")
  )
  
  
  
  output$map1 <- renderLeaflet({
    validate(need(nrow(petdata()) > 0, "No pets found."))
    
    observeEvent(input$table_rows_selected, {
      row_selected = petdata()[as.numeric(input$table_rows_selected),]
      selected <- PetFindr:::pf_locate_organizations(get_token(), row_selected)
      
      proxy <- leafletProxy('map1', data=selected)
      proxy %>%
        removeMarker(layerId = "selected") %>%
        addAwesomeMarkers(lng=~longitude,
                          lat=~latitude, layerId = "selected")
    })
    
    org_df <- PetFindr:::pf_locate_organizations(get_token(), petdata())
    
    org_sum <- petdata() %>% group_by(organization_id) %>%
      summarise(sum = length(id))
    
    df_map <- merge(org_df, org_sum, by.x = "id", by.y = "organization_id")
    
    leaflet()  %>%
      addProviderTiles("Esri.WorldStreetMap") %>%
      addCircleMarkers(data=df_map, lat = ~latitude, lng = ~longitude, 
                       radius = ~sum,
                       popup = ~paste("Name of Organization:", name, "<br>",
                                      "City:", city, state, "<br>",
                                      "Number of Pets:", sum))
  })
  
  output$photos = renderImage({
    validate(need(nrow(petdata()) > 0, "No pets found."))
    data <- petdata()
    data$number <- c(1:nrow(data))
    
    validate(need(input$table_rows_selected, 
                  "Please select a pet from above table"))
    
    selected_df <- data %>% 
      filter(number == as.numeric(input$table_rows_selected))
    # MuST FIX !!!: Check whether the pet has a photo, display "No photos" if not
    photo.dat <- pf_view_photos(selected_df, size="medium") %>%
      image_write(tempfile(fileext='jpg'), format = 'jpg')
    list(src = photo.dat, contentType = "image/jpg")
  })
  
}