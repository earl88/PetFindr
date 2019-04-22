#' Drawing a map and get data frame with organization id.
#'
#' @param token An access token, provided by pf_accesstoken(key, secret).
#' @param name The name of organizations to be found (includes partial matches).
#' @param location The location of organizations to be found. Values can be specified as "<City>, <State>", "<latitude>, <longitude>", or "<postal code>".
#' @param distance The distance, in miles, from the provided location to find organizations. Note that location is required to use distance.
#' @param state The state from which to return organizations. Accepts two-letter abbreviations, e.g. AL, WY.
#' @param country The country from which to return organizations. Accepts two-letter abbreviations, e.g. US, CA.
#' @param sort The attribute on which to sort results. Possible attributes are "distance", "-distance", "name", "-name", "country", "-country", "state", or "-state".
#' @param page The page(s) of results to return (default = 1).
#' @param limit The maximum number of results to return per page (maximum = 100).
#'
#' @return A data frame of results matching the search parameters.
#' @export
#' 
#' @importFrom purrr map map_df set_names
#' @importFrom leaflet leaflet addTiles addCircleMarkers
#' @importFrom utils read.table
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

pf_map_organizations <- function(token = NULL, name = NULL, 
                                 location = NULL, distance = NULL,
                                 state = NULL, country = NULL,
                                 sort = "recent", page = 1, limit = 20) {
  # We should change this to take in raw search results so the user doesn't
  # need to find the ID themselves
  zipcode <- read.table("inst/extdata/uszip.txt", sep=",", header = TRUE)

  args <- as.list(match.call(expand.dots = T))[-1]
  args <- args[!purrr::map_lgl(args, is.null)] %>% purrr::map(eval)
  
  query_args <- args[!names(args) %in% c("token", "page")]
  query <- paste(names(query_args), query_args, sep = "=", collapse = "&")
  base <- "https://api.petfinder.com/v2/organizations?"
  probe <- GET(url = paste0(base, query),
               add_headers(Authorization = paste("Bearer", token)))
  
  probe <- GET(url = paste0(base, query),
               add_headers(Authorization = paste("Bearer", token)))
  
  if (probe$status_code != 200) {stop(pf_error(probe$status_code))}
  
  assertthat::assert_that(is.numeric(page))
  if (length(page) == 1 && page == 1) {
    organization_info <- content(probe)$organizations
  } else {
    max_page <- content(probe)$pagination$total_pages
    if (max(page) > max_page) {
      warning("You have specified one or more page numbers that do not exist.")
      if (any(page <= max_page)) {
        page <- page[page <= max_page]
      } else {
        warning("No valid pages were specified. Defaulting to page 1.")
        organization_info <- content(probe)$organizations
      }
    }
  }
  
  organization_info <- lapply(paste0(base, query, "&page=", page), function(x) {
    results <- GET(url = x,
                   add_headers(Authorization = paste("Bearer", token)))
    if (results$status_code != 200) {stop(pf_error(results$status_code))}
    content(results)$organizations
  }) %>% 
    purrr::flatten()
  
  organization_df <- purrr::map_dfr(organization_info, .f = function(x) {
    rlist::list.flatten(x) %>%
      rbind.data.frame(deparse.level = 0, stringsAsFactors = F)
  })
  
  org_map_dat <- merge(organization_df, zipcode, by="address.postcode", by.y="ZIP")
  
  zipmap <- leaflet(data = org_map_dat) %>% addTiles() %>%
    addCircleMarkers(~LNG, ~LAT, popup = ~name, label = ~name)
  
  return(zipmap)
}
