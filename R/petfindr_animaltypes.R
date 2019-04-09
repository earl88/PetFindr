#' List all animal types found on Petfinder
#'
#' Longer description of what the function does
#'
#' @export
#' @param token An access token
#' @param type One of the eight available types. If no type is specified, all types are returned
#' @return A tibble listing all animal types with their available coats, colors, and genders
#'
#' @examples
#' petfindr_animaltypes(token, "all")
#' petfindr_animaltypes(token, "dog")
#'
#' @importFrom httr GET content
#' @importFrom magrittr %>%
#' @importFrom tibble tibble
#' @importFrom purrr map_df

petfindr_animaltypes <- function(token, type=c("all", "dog", "cat", "rabbit",
                                               "small & furry", "horse", 
                                               "bird", "scales, fins, & other", 
                                               "barnyard")) {
  
  assertthat::is.string(type)
  type <- tolower(type)
  type <- match.arg(type)
  
  if(type == "all") {
    query = ""
  } else {
    query = paste0("/", type)
  }
  
  base <- "https://api.petfinder.com/v2/types"
  url <- paste0(base, query)
  
  search_results <- GET(url = url, 
                        add_headers(Authorization = paste("Bearer", token)))
  
  if(type == "all") {
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

