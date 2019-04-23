#' List available breeds for a given animal type
#'
#' This function allows the user to specify an animal type found on Petfinder.com and returns a vector containing all available breeds for that animal type.
#'
#' @param token An access token, provided by \code{\link{pf_accesstoken}}.
#' @param type One of the available animal types for which to return breed information. A full list of animal types can be found by running \code{\link{pf_list_types}}.
#' @return A character vector containing the breed names for the specified animal type.
#' @export
#' 
#' @importFrom httr GET add_headers content
#'
#' @examples
#' \dontrun{
#' pf_list_breeds(token, type = "dog")
#' pf_list_breeds(token, type = "barnyard")
#' }
pf_list_breeds <- function(token, type = NULL) {
  assertthat::is.string(type)
  type <- tolower(type) %>%
    gsub(pattern = "([, &]{1,4})", replacement = "-")
  
  base <- "https://api.petfinder.com/v2/types/"
  query <- paste0(type, "/breeds")
  
  results <- GET(url = paste0(base, query), 
                 add_headers(Authorization = paste("Bearer", token)))
  if (results$status_code != 200) {stop(pf_error(results$status_code))}
  
  breeds <- purrr::map_chr(content(results)$breeds, function(x) {x$name})
  return(breeds)
}

