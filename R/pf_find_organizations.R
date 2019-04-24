#' Search for organizations
#'
#' Retrieve a data frame of information about organizations that are listed on
#' Petfinder.com. Filter searches based on location by specifying a postal code,
#' city and state, country, or latitude and longitude.
#'
#' @param token An access token, provided by \code{\link{pf_accesstoken}}.
#' @param name The name of organizations to be found (includes partial matches).
#' @param location The location of organizations to be found. Values can be specified as "City, State", "latitude, longitude", or "zipcode".
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
#' @importFrom httr GET add_headers content
#'
#' @examples
#' \dontrun{
#' US_orgs <- pf_find_organizations(token, country = "US", limit = 100, sort = "state")
#' MN_orgs <- pf_find_organizations(token, location = "Minneapolis, MN", distance = 50)
#' }
pf_find_organizations <- function(token = NULL, name = NULL, 
                                  location = NULL, distance = NULL,
                                  state = NULL, country = NULL,
                                  sort = "recent", page = 1, limit = 20) {
  
  args <- as.list(match.call())[-1]
  query_args <- args[!names(args) %in% c("token", "page")] %>% purrr::map(eval)
  query_args <- stats::setNames(unlist(query_args, use.names=F),
                                rep(names(query_args), lengths(query_args)))
  
  query <- paste(names(query_args), query_args, sep = "=", collapse = "&") %>%
    gsub(pattern = "[ ]", replacement = "%20")

  base <- "https://api.petfinder.com/v2/organizations?"
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
  
  return(organization_df)
}
