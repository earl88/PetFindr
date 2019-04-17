#' Search for pets from Petfinder.com
#'
#' @param token An access token, provided by pf_accesstoken(key, secret).
#' @param type The type(s) of animals to be found. A full list of animal types, along with their respective coat and color options, can be found by running pf_animaltypes(token).
#' @param breed The breed(s) of animals to be found. A full list of breeds for a given animal type can be found by running pf_breeds(token, type).
#' @param size The size(s) of animals to be found. Possible values are "small", "medium", "large", and "xlarge".
#' @param gender The gender(s) of animals to be found. Possible values are "male", "female", and "unknown".
#' @param age The age(s) of animals to be found. Possible values are "baby", "young", "adult", and "senior".
#' @param color The color(s) of animals to be found. A full list of animal types, along with their respective coat and color options, can be found by running pf_animaltypes(token).
#' @param coat The coat(s) of animals to be found. A full list of animal types, along with their respective coat and color options, can be found by running pf_animaltypes(token).
#' @param status The status of animals to be found. Possible values are "adoptable", "adopted", or "found".
#' @param name The name of animals to be found (includes partial matches; e.g. "Fred" will return "Alfredo" and "Frederick").
#' @param organization The organization(s) associated with animals to be found. Values should be provided as identification numbers.
#' @param location The location of animals to be found. Values can be specified as "[City], [State]", "[latitude], [longitude]", or "[postal code]".
#' @param distance The distance, in miles, from the provided location to find animals. Note that location is required to use distance.
#' @param sort The attribute on which to sort results. Possible attributes are "recent", "-recent", "distance", or "-distance".
#' @param page The page of results to return. Default is 1.
#' @param limit The maximum number of results to return per page. Default is 20, maximum is 100.
#'
#' @return A data frame of results matching the search parameters
#' @export
#'
#' @examples
#' puppies <- pf_find_pets(token, type = "dog", age = "baby")
pf_find_pets <- function(token = NULL, type = NULL, breed = NULL, size = NULL, 
                       gender = NULL, age = NULL, color = NULL, coat = NULL,
                       status = NULL, name  = NULL, organization = NULL,
                       location = NULL, distance = NULL, 
                       sort = "recent", page = 1, limit = 20) {
  
  
  defaults <- formals()
  defaults <- defaults[!purrr::map_lgl(defaults, is.null)]
  args <- as.list(match.call(expand.dots = T))[-1]
  args <- args[!purrr::map_lgl(args, is.null)]
  full_args <- purrr::map(c(args, defaults[!names(defaults) %in% names(args)]),
                          eval)[-1]
  
  query <- paste0(paste0(names(full_args), "=", full_args), collapse = "&")
  
  base <- "https://api.petfinder.com/v2/animals?"
  url <- paste0(base, query)
  search_results <- httr::GET(url = url,
                      httr::add_headers(Authorization = paste("Bearer", token)))
  
  if(search_results$status_code != 200) {
    stop(pf_error(search_results$status_code))
  }
  
  animal_info <- httr::content(search_results)$animals
  
  new.distinct.names <- animal_info %>% 
    purrr::map(.x, .f=~names(rbind.data.frame(rlist::list.flatten(.x),0)))
  
  unlisted <- animal_info %>% 
    purrr::map(.f = ~rbind.data.frame(unlist(.x, recursive=T, use.names=T)))
  
  unlisted.info <- purrr::map2(unlisted, new.distinct.names,
                               .f= ~purrr::set_names(.x, .y))
  
  animal_df <- do.call(plyr::rbind.fill, unlisted.info)

  return(animal_df)
}

