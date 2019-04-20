#' Search for pets from Petfinder.com via the Petfinder.com API (V2)
#' 
#' (Longer description)
#'
#' @param token An access token, provided by pf_accesstoken(key, secret).
#' @param type The type(s) of animals to be found. A full list of animal types, along with their respective coat and color options, can be found by running pf_list_types(token).
#' @param breed The breed(s) of animals to be found. A full list of breeds for a given animal type can be found by running pf_breeds(token, type).
#' @param size The size(s) of animals to be found. Possible values are "small", "medium", "large", and "xlarge".
#' @param gender The gender(s) of animals to be found. Possible values are "male", "female", and "unknown".
#' @param age The age(s) of animals to be found. Possible values are "baby", "young", "adult", and "senior".
#' @param color The color(s) of animals to be found. A full list of animal types, along with their respective coat and color options, can be found by running pf_list_types(token).
#' @param coat The coat(s) of animals to be found. A full list of animal types, along with their respective coat and color options, can be found by running pf_list_types(token).
#' @param status The status of animals to be found. Possible values are "adoptable", "adopted", or "found".
#' @param name The name of animals to be found (includes partial matches; e.g. "Fred" will return "Alfredo" and "Frederick").
#' @param organization The organization(s) associated with animals to be found. Values should be provided as identification numbers.
#' @param location The location of animals to be found. Values can be specified as "<City>, <State>", "<latitude>, <longitude>", or "<postal code>".
#' @param distance The distance, in miles, from the provided location to find animals. Note that location is required to use distance.
#' @param sort The attribute on which to sort results. Possible attributes are "recent", "-recent", "distance", or "-distance".
#' @param page The page(s) of results to return; default is 1. 
#' @param limit The maximum number of results to return per page (max of 100).
#'
#' @return A data frame of results matching the search parameters
#' @export
#' 
#' @import httr
#'
#' @examples
#' \dontrun{
#' puppies <- pf_find_pets(token, type = "dog", age = "baby", page = 1:5)
#' }
pf_find_pets <- function(token = NULL, type = NULL, breed = NULL, size = NULL, 
                         gender = NULL, age = NULL, color = NULL, coat = NULL,
                         status = NULL, name  = NULL, organization = NULL,
                         location = NULL, distance = NULL, 
                         sort = "recent", page = 1, limit = 20) {
  
  args <- as.list(match.call(expand.dots = T))[-1]
  args <- args[!purrr::map_lgl(args, is.null)] %>% purrr::map(eval)
  
  query_args <- args[!names(args) %in% c("token", "page")]
  query <- paste0(paste0(names(query_args), "=", query_args), collapse = "&")
  base <- "https://api.petfinder.com/v2/animals?"
  probe <- GET(url = paste0(base, query),
               add_headers(Authorization = paste("Bearer", token)))
  
  if(probe$status_code != 200) {stop(pf_error(probe$status_code))}
  
  if(length(page) == 1 && page == 1) {
    animal_info <- content(probe)$animals
  } else {
    max_page <- content(probe)$pagination$total_pages
    if("all" %in% page) {
      page <- 1:max_page
    } else {
      if(max(page) > max_page) {
        warning("You have specified a page number that does not exist. Try using 'page = \"all\"'.")
        page <- page[page <= max_page]
      }
    }
    
    animal_info <- lapply(paste0(base, query, "&page=", page), function(x) {
      results <- GET(url = x,
                     add_headers(Authorization = paste("Bearer", token)))
      if(results$status_code != 200) {stop(pf_error(results$status_code))}
      content(results)$animals}
    ) %>% purrr::flatten()
  }
  
  animal_df <- purrr::map_dfr(animal_info, .f = function(x) {
    rlist::list.flatten(x) %>%
      rbind.data.frame(deparse.level = 0, stringsAsFactors = F)
  })
  
  return(animal_df)
}

