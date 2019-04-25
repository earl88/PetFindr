function(input, output) {
  output$table <- DT::renderDataTable(DT::datatable({
    key <- input$key
    secret <- input$secret
    token <- pf_accesstoken(key, secret)
    data <- do.call(PetFindr::pf_find_pets, 
                    args = list(token = token, location = input$location, 
                                distance = input$distance, type = input$animal,
                                status = input$status, limit = input$limit))
    
    data %>% 
      select(c("organization_id", "type", "status", 
               "contact.address.address1", "contact.address.city", 
               "contact.phone"))
  }, selection = "single")
  )
  
  
  
  output$map1 <- renderLeaflet({
    key <- input$key
    secret <- input$secret
    token <- pf_accesstoken(key, secret)
    data <- do.call(PetFindr::pf_find_pets, 
                    args = list(token = token, location = input$location, 
                                distance = input$distance, type = input$animal,
                                status = input$status, limit = input$limit))
    
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
    key <- input$key
    secret <- input$secret
    token <- pf_accesstoken(key, secret)
    data <- do.call(PetFindr::pf_find_pets, 
                    args = list(token = token, location = input$location, 
                                distance = input$distance, type = input$animal,
                                status = input$status, limit = input$limit))
    
    data$number <- c(1:nrow(data))
    
    validate(
      need(input$table_rows_selected, "Please select a pet from above table")
    )
    
    selected_df <- data %>% filter(number == as.numeric(input$table_rows_selected))
    
    photo.dat <- pf_view_photos(selected_df, size="medium") %>%
      image_write(tempfile(fileext='jpg'), format = 'jpg')
    list(src = photo.dat, contentType = "image/jpg")
  })
  
}