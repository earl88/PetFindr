function(input, output, session) {
  
  url <- a("Petfinder API", href="https://www.petfinder.com/developers/")
  
    output$instruction <- renderUI(
      tagList("Make an account here:", url)
      )
    
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
  
  output$select_breeds <- renderUI({
    
    choices <- pf_list_breeds(get_token(), input$animal)
    
    selectInput('breeds', label = 'Select breeds:',
                       choices = choices)
  })
  
  output$gettoken <- renderText(
    if (nchar(get_token() > 0)) {
      res <- "Your access token will last for one hour. After that time, you will need to generate a new token."
    } else {
      res <- "Access was denied due to invalid credentials. This could be an invalid API key/secret combination, missing access token, or expired access token."
    }
  )
  

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
      validate(need(isolate(input$location), 
                    "To specify Distance, you must specify Location"))
    }
    
    data <- do.call(PetFindr::pf_find_pets, 
                    args = list(token = get_token(), 
                                location = isolate(input$location), 
                                distance = isolate(input$distance), 
                                type = isolate(input$animal),
                                breed = isolate(input$breeds),
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
    
    if (is.na(selected_df$photos.small)) {
      stop("Ooops, this pet does not have photos")
    }

    photo.dat <- pf_view_photos(selected_df, size="medium") %>%
      image_write(tempfile(fileext='jpg'), format = 'jpg')
    list(src = photo.dat, contentType = "image/jpg")
  })


  petmapdata <- reactive({
    input$search_org
    
    req <- as.numeric(isolate(input$num_orgs))
    if(req <= 100) {
      limit <- req
      page <- 1
    } else {
      limit <- 100
      page <- ceiling(req / 100)
    }
    
    if(!is.na(isolate(input$distance_org))) {
      validate(need(isolate(input$location_org), 
                    "To specify Distance, you must specify Location"))
    }
    
    data <- do.call(PetFindr::pf_find_pets, 
                    args = list(token = get_token(), 
                                location = isolate(input$location_org), 
                                distance = isolate(input$distance_org), 
                                limit = limit, page = page))
    data <- data[1:req,]
    
  })
  
  output$map2 <- renderLeaflet({
    
    validate(need(nrow(petmapdata()) > 0, "No organizations found. Are your search parameters too narrow?"))
    
    pet_locate = petmapdata()
    selected_pet <- PetFindr:::pf_locate_organizations(get_token(), pet_locate)
    
    pet_locate_sum <- pet_locate %>% group_by(organization_id) %>%
      summarise(sum = length(id))
    
    req <- as.numeric(isolate(input$num_orgs))
    if(req <= 100) {
      limit <- req
      page <- 1
    } else {
      limit <- 100
      page <- ceiling(req / 100)
    }
    
    if(!is.na(isolate(input$distance_org))) {
      validate(need(isolate(input$location_org), 
                    "To specify Distance, you must specify Location"))
    }
    
    orgdata <- do.call(PetFindr::pf_find_organizations, 
                       args = list(token = get_token(), 
                                   location = isolate(input$location_org), 
                                   distance = isolate(input$distance_org), 
                                   limit = limit, page = page))

    org_locate <- orgdata %>%
      mutate(organization_id = id)

    selected_org <- PetFindr:::pf_locate_organizations(get_token(), org_locate)

    orgmap_data <- rbind(selected_org, selected_pet)
    
    orgmap_data <- orgmap_data[which(!duplicated(orgmap_data$id)), ]

    orgmap_sum <- merge(orgmap_data, pet_locate_sum, by.x="id", by.y="organization_id", all.x = TRUE)
    
    orgmap_sum$sum[is.na(orgmap_sum$sum)] <- 0
    
    orgmap_sum$radius <- as.numeric(orgmap_sum$sum)
    
    leaflet(data=orgmap_sum) %>%
      addTiles() %>%
      # addCircleMarkers(data=orgmap_sum, lat = ~latitude, lng = ~longitude) %>%
      addCircles(lat = ~latitude, lng = ~longitude, color = "red", radius = ~(radius*5)^2,
                 popup = ~paste("Name of Organization:", name, "<br>",
                                "City:", city, state, "<br>",
                                "Number of Pets:", sum), layerId = ~id)
  })
  
  output$list_table <- renderTable({
    validate(need(!is.null(input$map2_shape_click), "Please Make Selection"))
    event <- input$map2_shape_click
    newloc <- paste0(event$lat, ",","%20", event$lng)
    Variables = c("Name", "Email", "Phone", "Street", "City", "Postcode", "Hours_Monday", "Hours_Tuesday", "Hours_Wednesday", "Hours_Thursday", "Hours_Friday")
    orgdata_list <- do.call(PetFindr::pf_find_organizations,
                            args = list(token = get_token(),location = newloc)) %>% filter(id==event$id) %>%
      select(c(name, email, phone, address.address1, address.city, address.postcode, hours.monday, hours.tuesday, hours.wednesday, hours.thursday, hours.friday))
    validate(need(nrow(orgdata_list)>0, "Organization information cannot be found by petfinder API's organization searching algorithm."))
    orgdata_list <- data.frame(Variables, Organization_Info = transpose(orgdata_list) %>% setNames("Organization_Info"))
    print(orgdata_list)
    })

  output$bars <- renderPlotly({
    
    validate(need(!is.null(input$map2_shape_click), "Please Make Selection"))
    
    event <- input$map2_shape_click
    
    plotmap <- petmapdata() %>% 
        dplyr::filter(organization_id == event$id) %>% 
        group_by(type) %>%
        summarise(sum=length(id))
    
    plotmap <- data.frame(plotmap)
    
    validate(need(nrow(plotmap) > 0, "No pets in this organization..."))

    p <- ggplot(data=plotmap, aes(x=type, y=sum)) +
        geom_bar(stat="identity", fill="navy") +
        labs(x="Animal Types", y="Number of Animals")+
        theme_bw()
    
    ggplotly(p)

  })
}