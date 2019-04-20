#' Drawing a map and get data frame with organization id.
#'
#' @param id 
#'
#' @importFrom purrr map map_df set_names
#' @importFrom leaflet leaflet addTiles addCircleMarkers
#' @import zipcode
#' @import httr
#' 
#' @return A data frame using organzation and print a leaflet map
#' @export
#'
#' @examples
#' \dontrun{
#' pf_find_pets(token, type = "dog")
#' data(zipcode, package = "zipcode")
#' animal_dat <- pf_find_pets(token, location=50014, distance=10, type="dog")
#' id_ex <- unique(animal_dat$organization_id)
#' pf_map_organizations(id=id_ex)
#' }

pf_map_organizations <- function(id) {
  # We should change this to take in raw search results so the user doesn't
  # need to find the ID themselves
  
  base <- "https://api.petfinder.com/v2/organizations/"
  urls <- paste0(base, tolower(id))
  
  # These next two function calls use apply instead of loops, so they're faster
  
  organization_info <- lapply(urls, function(x) {
    results <- GET(url = x, add_headers(Authorization = paste("Bearer", token)))
    if(results$status_code != 200) {stop(pf_error(results$status_code))}
    return(content(results)[[1]])
    })
  
  organization_df <- purrr::map_dfr(organization_info, function(x) {
    tibble::tibble(id = x$id, name = x$name, city = x$address[3],
                   state = x$address[4], zip = x$address[5])
  })

  # organization_list <- list()
  # 
  # for (i in 1:length(id)) {
  #   
  #   query <- tolower(id[i])
  #   
  #   url <- paste0(base, query)
  #   
  #   search_results <- GET(url = url, 
  #                      add_headers(Authorization = paste("Bearer", token)))
  #   organization_info <- content(search_results)[[1]]
  #   
  #   organization_list[[i]] <- data.frame(id=organization_info$id, 
  #                                        name=organization_info$name, 
  #                                        city=organization_info$address[3],
  #                                        state=organization_info$address[4], 
  #                                        zip=organization_info$address[5])
  # }
  # 
  # organization_df <- do.call(plyr::rbind.fill, organization_list)
  
  org_map_dat <- merge(organization_df, zipcode, by="postcode", by.y="zip")
  
  zipmap <- leaflet(data = org_map_dat) %>% addTiles() %>%
    addCircleMarkers(~longitude, ~latitude, popup = ~name, label = ~name)
  
  return(zipmap)
}
