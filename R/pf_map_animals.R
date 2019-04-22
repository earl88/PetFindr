#' Merge Organization Data to Animal Data
#'
#' @param token An access token, provided by pf_accesstoken(key, secret).
#' @param animal_df A data frame of animal information output from pf_find_pets().
#'
#' @return The original data frame supplemented with more detailed organiation information
#' @export
#'
#' @examples
pf_merge_organizations <- function(token, animal_df) {
  id <- unique(animal_df$id)
  base <- "https://api.petfinder.com/v2/organizations/"
  urls <- paste0(base, tolower(id))
  
  organization_info <- lapply(urls, function(x) {
    results <- GET(url = x, add_headers(Authorization = paste("Bearer", token)))
    if(results$status_code != 200) {stop(pf_error(results$status_code))}
    return(content(results)[[1]])
  })
  
  organization_df <- purrr::map_dfr(organization_info, function(x) {
    tibble::tibble(id = x$id, name = x$name, city = x$address[3],
                   state = x$address[4], zip = x$address[5])
  })
  
  org_map_dat <- merge(organization_df, zipcode, by="postcode", by.y="zip")
  
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
#' @examples
pf_map_animals <- function(token, animal_df) {
  org_map_dat <- pf_merge_organizations(token, animal_df)
  
  zipmap <- leaflet(data = org_map_dat) %>% addTiles() %>%
    addCircleMarkers(~longitude, ~latitude, popup = ~name, label = ~name)
}