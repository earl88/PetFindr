#' List available breeds for a specific animal type on Petfinder
#'
#' This function allows the user to specify an animal type found on Petfinder.com and returns a vector containing all available breeds for that animal type.
#'
#' @param token An access token for the Petfinder API (V2)
#' @param type One of the available animal types for which to return breed information. If no type is specified, dog breeds are returned. A full list of animal types can be found by running pf_animaltypes(token).
#' @return A character vector containing the breed names for the specified animal type.
#' @export
#' 
#' @importFrom httr GET add_headers content
#'
#' @examples
#' \dontrun{
#' pf_list_breeds(token, type = "dog")
#' pf_list_breeds(token, type = "cat")
#' }
pf_list_breeds <- function(token, type = c("dog", "cat", "rabbit",
                                           "small & furry","horse", "bird", 
                                           "scales, fins, & other", "barnyard")) {
  assertthat::is.string(type)
  type <- tolower(type)
  type <- match.arg(type) %>%
    gsub(pattern = "([, &]{1,4})", replacement = "-")
  
  query = paste0("/", type, "/breeds")
  
  base <- "https://api.petfinder.com/v2/types"
  url <- paste0(base, query)
  
  search_results <- GET(url = url, 
                        add_headers(Authorization = paste("Bearer", token)))
  if (search_results$status_code != 200) {
    stop(pf_error(search_results$status_code))
  }
  
  breeds <- purrr::map_chr(content(search_results)$breeds, function(x) {x$name})
  return(breeds)
}

