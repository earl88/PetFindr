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
#' \dontrun{
#' pf_list_types(token)
#' pf_list_types(token, "dog")
#' pf_list_types(token)$name
#' }
pf_list_types <- function(token, type = NULL) {
  
  if(is.null(type)) {
    type <- ""
  } else {
    assertthat::is.string(type)
    type <- tolower(type)
    type <- match.arg(type, choices = c("dog", "cat", "rabbit",
                                        "small & furry", "horse","bird",
                                        "scales, fins, & other", "barnyard")) %>%
      gsub(pattern = "([, &]{1,4})", replacement = "-")
  }
  
  base <- "https://api.petfinder.com/v2/types/"
  
  results <- httr::GET(url = paste0(base, type), 
                       httr::add_headers(Authorization = paste("Bearer", token)))
  if(results$status_code != 200) {stop(pf_error(results$status_code))}
  
  if(type == "") {
    type_info <- httr::content(results)$types
  } else {
    type_info <- httr::content(results)
  }
  
  types_df <- purrr::map_df(type_info, function(x) {
    tibble::tibble(name = x$name,
                   coats = unlist(x$coats) %>% paste0(collapse = ", "),
                   colors = unlist(x$colors) %>% paste0(collapse = ", "),
                   genders = unlist(x$genders) %>% paste0(collapse = ", "))
  })
  return(types_df)
}

