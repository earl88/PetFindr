function(input, output) {
  
  output$table <- DT::renderDataTable(DT::datatable({
    key <- "Z69HqIlhMDkYHo9HCKH78NwtP2v8Js2YlqZs2heB887n5ePUpF"
    secret <- "X7RUPlGuPkbXP0gNXz8r2KfpZUfb5EB1pg4neruZ"
    token <- pf_accesstoken(key, secret)
    data <- do.call(PetFindr::pf_find_pets, args = list(token=token, location=input$location, distance=input$distance, type=input$animal,
                                                        status=input$status, limit=input$limit))
    
    data %>% 
      select(c("organization_id", "type", "status", "contact.address.address1", "contact.address.city", "contact.phone"))
  }, selection = "single")
  )
  
  
  
  output$map1 <- renderLeaflet({
    key <- "Z69HqIlhMDkYHo9HCKH78NwtP2v8Js2YlqZs2heB887n5ePUpF"
    secret <- "X7RUPlGuPkbXP0gNXz8r2KfpZUfb5EB1pg4neruZ"
    token <- pf_accesstoken(key, secret)
    data <- do.call(PetFindr::pf_find_pets, args = list(token=token, location=input$location, distance=input$distance, type=input$animal,
                                                        status=input$status, limit=input$limit))
    
    observeEvent(input$table_rows_selected, {
      row_selected = data[as.numeric(input$table_rows_selected),]
      selected <- PetFindr:::pf_locate_organizations(token, row_selected)
      
      proxy <- leafletProxy('map1', data=selected)
      proxy %>%
        removeMarker(layerId = "selected") %>%
        addAwesomeMarkers(lng=~longitude,
                          lat=~latitude, layerId = "selected")
    })
    
    org_df <- PetFindr:::pf_locate_organizations(token, data)
    
    org_sum <- data %>% group_by(organization_id) %>%
      summarise(sum = length(id))
    
    df_map <- merge(org_df, org_sum, by.x = "id", by.y = "organization_id")
    leaflet()  %>%
      addProviderTiles("Esri.WorldStreetMap") %>%
      addCircleMarkers(data=df_map, lat = ~latitude, lng = ~longitude, radius = ~sum,
                       popup = ~paste("Name of Organization:", name, "<br>",
                                      "City:", city, state, "<br>",
                                      "Number of Pets:", sum))
    
    
  })
  
  output$photos = renderImage({
    key <- "Z69HqIlhMDkYHo9HCKH78NwtP2v8Js2YlqZs2heB887n5ePUpF"
    secret <- "X7RUPlGuPkbXP0gNXz8r2KfpZUfb5EB1pg4neruZ"
    token <- pf_accesstoken(key, secret)
    data <- do.call(PetFindr::pf_find_pets, args = list(token=token, location=input$location, distance=input$distance, type=input$animal,
                                                        status=input$status, limit=input$limit))
    
    data$number <- c(1:nrow(data))
    
    validate(
      need(input$table_rows_selected, "Please select a pet")
    )
    
    selected_df <- data %>% filter(number == as.numeric(input$table_rows_selected))
    
    photo.dat <- pf_view_photos(selected_df, size="medium") %>%
      image_write(tempfile(fileext='jpg'), format = 'jpg')
    list(src = photo.dat, contentType = "image/jpg")
  })
  
  zipmap <- read_csv("https://gist.githubusercontent.com/erichurst/7882666/raw/5bdc46db47d9515269ab12ed6fb2850377fd869e/US%2520Zip%2520Codes%2520from%25202013%2520Government%2520Data")
  
  output$plot <- renderLeaflet({
    
    validate(need(!is.na(input$Zipcode), "Zipcode must not be NA. Please enter a zip code"))
    validate(need(!is.na(input$Distance), "Distance must not be NA. Please enter a valid distance"))
    
    data <-do.call(PetFindr::pf_find_organizations, args = list(token=token, location=input$Zipcode, distance = input$Distance)) %>%
      left_join(zipmap, by = c("address.postcode" = "ZIP")) %>%
      select(address.postcode, LAT, LNG, name)
    
    # print(head(data))
    
    leaflet(data = data) %>%
      addTiles() %>%
      addMarkers(lat = data$LAT, lng = data$LNG, popup = ~data$name)
  })
  
}