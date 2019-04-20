#' Drawing a map and get data frame with organization id.
#'
#' @param id Organization id
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
#' 
#' animal_dat <- pf_find_pets(token, location=50014, distance=10, type="dog")
#' id_ex <- unique(animal_dat$organization_id)
#' pf_map_organizations(id=id_ex)
#' }

pf_map_organizations <- function(id) {
  
  data(zipcode, package = "zipcode")
  
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

  
  org_map_dat <- merge(organization_df, zipcode, by="postcode", by.y="zip")
  
  zipmap <- leaflet(data = org_map_dat) %>% addTiles() %>%
    addCircleMarkers(~longitude, ~latitude, popup = ~name, label = ~name)
  
  return(zipmap)
}
