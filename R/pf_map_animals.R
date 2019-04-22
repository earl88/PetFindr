#' Merge Organization Data to Animal Data
#'
#' @param token An access token, provided by pf_accesstoken(key, secret).
#' @param animal_df A data frame of animal information output from pf_find_pets().
#'
#' @return The original data frame supplemented with more detailed organization information.
#' 
#' @import httr
pf_merge_organizations <- function(token, animal_df) {
  id <- unique(animal_df$organization_id)
  base <- "https://api.petfinder.com/v2/organizations/"
  urls <- paste0(base, tolower(id))
  
  organization_info <- lapply(urls, function(x) {
    results <- GET(url = x, add_headers(Authorization = paste("Bearer", token)))
    if(results$status_code != 200) {stop(pf_error(results$status_code))}
    return(content(results)[[1]])
  })
  
  organization_df <- purrr::map_dfr(organization_info, function(x) {
    tibble::tibble(id = x$id, name = x$name, city = x$address[3],
                   state = x$address[4], zip = as.character(x$address[5]))
  })
  
  zips <- utils::read.delim2(system.file("extdata/uszip.txt", 
                                         package = "PetFindr"),
                             sep = ",", colClasses = c("character")) %>%
    setNames(c("zipcode", "latitude", "longitude"))
  
  zips$latitude <- as.numeric(zips$latitude)
  zips$longitude <- as.numeric(zips$longitude)
  org_map_dat <- merge(organization_df, zips, by.x = "zip", 
                       by.y = "zipcode", all.y = F)
  
  return(org_map_dat)
}

#' Display Animal Locations
#'
#' @param token An access token, provided by pf_accesstoken(key, secret).
#' @param animal_df A data frame of animal information output from pf_find_pets().
#'
#' @return A leaflet map of the locations of animals provided.
#' @export
#' 
#' @import leaflet
#' 
#' @examples
#' \dontrun{
#' pups <- pf_find_pets(token, type = "dog", breed = "corgi", location = "50014", distance = "150")
#' pf_map_animals(token, pups)
#' }
pf_map_animals <- function(token, animal_df) {
  org_map_dat <- pf_merge_organizations(token, animal_df)
  
  zipmap <- leaflet(data = org_map_dat) %>% addTiles() %>%
    addCircleMarkers(~longitude, ~latitude, popup = ~name, label = ~name)
  return(zipmap)
}
