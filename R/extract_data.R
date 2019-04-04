library(tidyverse)

# Possible searches are documented here:
# # https://www.petfinder.com/developers/v2/docs/


# This is how you complete a search. You need an access token to search
# # (see authorization.R). Now we need to figure out how to parse the search
# # results so we can display them for a user, especially pictures.


# This search gets the first 20 animals from the front page
search_results <- httr::GET(url = "https://api.petfinder.com/v2/animals",
                    httr::add_headers(Authorization = paste("Bearer", token)))
# content() gives us the actual content of the search
raw_info <- httr::content(search_results)
animal_info <- httr::content(search_results)$animals


# Helper function for blank fields
check_null <- function(x) {
  ifelse(!is.null(x), x, NA)
}

# We can manually extract the information (I started to write that here),
# # but it gets really tedious, and it would be better to automatically
# # detect the fields and populate them, instead of defining them all.
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

x <- animal_info[[1]]
names(x)
names(unlist(x))
animal_df <- animal_info %>% purrr::map_df(animals_to_df)
