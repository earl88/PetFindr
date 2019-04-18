#' NAME/TITLE OF FUNCTION
#'
#' @param id 
#'
#' @importFrom magrittr %>%
#' @importFrom purrr map map_df set_names
#' @importFrom leaflet leaflet addTiles addCircleMarkers
#' @import zipcode
#' 
#' @return (Fill this in)
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
  base <- "https://api.petfinder.com/v2/organizations/"
  
  organization_list <- list()
  
  for (i in 1:length(id)) {
    
    query <- tolower(id[i])
    
    url <- paste0(base, query)
    
    search_results <- httr::GET(url = url, 
                       httr::add_headers(Authorization = paste("Bearer", token)))
    organization_info <- httr::content(search_results)[[1]]
    
    organization_list[[i]] <- data.frame(id=organization_info$id, 
                                         name=organization_info$name, 
                                         city=organization_info$address[3],
                                         state=organization_info$address[4], 
                                         zip=organization_info$address[5])
  }
  
  organization_df <- do.call(plyr::rbind.fill, organization_list)
  
  org_map_dat <- merge(organization_df, zipcode, by="postcode", by.y="zip")
  
  zipmap <- leaflet(data = org_map_dat) %>% addTiles() %>%
    addCircleMarkers(~longitude, ~latitude, popup = ~name, label = ~name)
  
  return(zipmap)
}
