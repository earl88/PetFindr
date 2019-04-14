#' List available breeds for a specific animal type on Petfinder
#'
#' This function takes in one of the eight animal types found on Petfinder.com and returns a vector containing all available breeds for that animal type
#'
#' @export
#' @param token An access token for the Petfinder API
#' @param type One of the eight available types. If no type is specified, dog breeds are returned.
#' @return A character vector containing the breed names for the given animal type
#'
#' @examples
#' pf_breeds(token, type = "dog")
#' pf_breeds(token, type = "cat")
#'
#' @importFrom magrittr %>%
#' @importFrom tibble tibble

pf_breeds <- function(token, type = c("dog", "cat", "rabbit",
                                          "small & furry","horse", "bird", 
                                          "scales, fins, & other", "barnyard")) {
  
  assertthat::is.string(type)
  type <- tolower(type)
  type <- match.arg(type) %>%
    gsub(pattern = "([, ][& ][& ]?[ ]?)", replacement = "-")
  
  query = paste0("/", type, "/breeds")

  base <- "https://api.petfinder.com/v2/types"
  url <- paste0(base, query)
  
  search_results <- httr::GET(url = url, 
                       httr::add_headers(Authorization = paste("Bearer", token)))
  if(search_results$status_code != 200) {
    stop(pf_error(search_results$status_code))
  }
  
  breeds <- purrr::map_chr(httr::content(search_results)$breeds, 
                           function(x) {x$name})
  return(breeds)
}

