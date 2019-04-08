check_null <- function(x) {
  ifelse(!is.null(x), x, NA)
}

animals_to_df <- function(x) {
  tibble(id = x$id, organization_id = x$organization_id, url = x$url,
         type = x$type, species = x$species,
         breed_primary = check_null(x$breeds$primary),
         breed_secondary = check_null(x$breeds$secondary),
         breed_mixed = x$breeds$mixed,
         breed_unknown = x$breeds$unknown,
         color_primary = check_null(x$colors$primary),
         color_secondary = check_null(x$colors$secondary),
         color_tertiary = check_null(x$colors$tertiary),
         gender = x$gender, name = x$name)
}

petfindr_search <- function(token, query) {
  library(httr)
  library(magrittr)
  library(tidyverse)
  base <- "https://api.petfinder.com/v2/"
  query <- "animals"
  url <- paste0(base, query)
  search_results <- GET(url = url, 
                        add_headers(Authorization = paste("Bearer", token)))
  
  
  animal_df <- content(search_results)$animals %>% purrr::map_df(animals_to_df)
  return(animal_df)
  
}

# petfindr_search(token)