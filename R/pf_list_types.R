#' List animal types with their respective coat, color, and gender options
#'
#' This function returns the available animal types from Petfinder.com, along with each type's available coat, color, and gender options.
#'
#' @export
#' @param token An access token, provided by \code{\link{pf_accesstoken}}.
#' @return A tibble listing all available animal types with their respective coat, color, and gender options.
#'
#' @importFrom httr GET add_headers content
#'
#' @examples
#' \dontrun{
#' pf_list_types(token)
#' pf_list_types(token)$name
#' }
pf_list_types <- function(token) {
  
  results <- GET(url = "https://api.petfinder.com/v2/types/", 
                       add_headers(Authorization = paste("Bearer", token)))
  if(results$status_code != 200) {stop(pf_error(results$status_code))}
  
  types_df <- purrr::map_df(content(results)[[1]], function(x) {
    tibble::tibble(name = x$name,
                   coats = unlist(x$coats) %>% paste0(collapse = ", "),
                   colors = unlist(x$colors) %>% paste0(collapse = ", "),
                   genders = unlist(x$genders) %>% paste0(collapse = ", "))
  })
  return(types_df)
}
