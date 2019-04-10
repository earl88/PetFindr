#' List available breeds for a specific animal type on Petfinder
#'
#' Longer description of what the function does
#'
#' @export
#' @param token An access token
#' @param type One of the eight available types. If no type is specified, dog breeds are returned.
#' @return A character vector containing the breed names for the given animal type
#'
#' @examples
#' petfindr_breeds(token, type = "dog")
#' petfindr_breeds(token, type = "cat")
#'
#' @importFrom httr GET content
#' @importFrom magrittr %>%
#' @importFrom tibble tibble
#' @importFrom purrr map_chr
#' @import assertthat

petfindr_breeds <- function(token, type=c("dog", "cat", "rabbit",
                                          "small & furry","horse", "bird", 
                                          "scales, fins, & other", "barnyard")) {
  
  assertthat::is.string(type)
  type <- tolower(type)
  type <- match.arg(type)
  if(type == "small & furry") {type <- "small-furry"}
  if(type == "scales, fins, & other") {type <- "scales-fins-other"}
  
  query = paste0("/", type, "/breeds")

  base <- "https://api.petfinder.com/v2/types"
  url <- paste0(base, query)
  
  search_results <- GET(url = url, 
                        add_headers(Authorization = paste("Bearer", token)))
  
  breeds <- purrr::map_chr(content(search_results)$breeds, function(x) {x$name})
  return(breeds)
}

