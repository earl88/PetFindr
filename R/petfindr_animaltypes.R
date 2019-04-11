#' List all animal types found on Petfinder
#'
#' Longer description of what the function does
#'
#' @export
#' @param token An access token
#' @param type One of the eight available types: "dog", "cat", "rabbit", "small & furry", "horse", "bird", "scales, fins, & other", or "barnyard". If no type is provided, all types are returned.
#' @return A tibble listing the desired animal types with their available coats, colors, and genders
#'
#' @examples
#' petfindr_animaltypes(token)
#' petfindr_animaltypes(token, "dog")
#' petfindr_animaltypes(token)$name
#'
#' @importFrom httr GET content
#' @importFrom magrittr %>%
#' @importFrom tibble tibble
#' @importFrom purrr map_df
#' @importFrom assertthat is.string
petfindr_animaltypes <- function(token, type = NULL) {
  
  if(is.null(type)) {
    type <- ""
  } else {
    assertthat::is.string(type)
    type <- tolower(type)
    type <- match.arg(type, choices = c("dog", "cat", "rabbit",
                                        "small & furry", "horse","bird",
                                        "scales, fins, & other", "barnyard"))
    if(type == "small & furry") {type <- "small-furry"}
    if(type == "scales, fins, & other") {type <- "scales-fins-other"}
  }
  
  base <- "https://api.petfinder.com/v2/types/"
  
  search_results <- GET(url = paste0(base, type), 
                        add_headers(Authorization = paste("Bearer", token)))
  
  if(type == "") {
    type_info <- content(search_results)$types
  } else {
    type_info <- content(search_results)
  }
  
  types_df <- purrr::map_df(type_info, function(x) {
    tibble(name = x$name,
           coats = unlist(x$coats) %>% paste(sep = "", collapse = ", "),
           colors = unlist(x$colors) %>% paste(sep = "", collapse = ", "),
           genders = unlist(x$genders) %>% paste(sep = "", collapse = ", "))
  })
  return(types_df)
}

