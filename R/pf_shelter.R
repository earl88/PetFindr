#' Title
#'
#' @param token 
#' @param zip 
#' @param dist 
#'
#' @return
#' @export
#'
#' @examples
pf_shelter <- function(token, zip, dist) {
  
  base <- "https://api.petfinder.com/v2/"
  query <- "organizations"
  location <- paste0("location", "=", zip)
  distance <- paste0("distance", "=", dist)
  query <- paste0("organizations?",location, "&", distance, "&","limit=100&page=1")
  url <- paste0(base, query)
  search_results <- GET(url = url, 
                        add_headers(Authorization = paste("Bearer", token)))
  
  
  org_info <- content(search_results)$organizations
  
  # Now We can automatically extract the information instead of defining them all.
  # I would try to find an alternative to the part of the function "tibble.f" below later.
  new.distinct.names <- org_info %>% 
    purrr::map(.x, 
               .f=~names(rbind.data.frame(rlist::list.flatten(.x),0)))
  
  unlisted <- org_info %>% 
    purrr::map(.f = ~rbind.data.frame(unlist(.x, recursive=T, use.names=T)))
  
  unlisted.info <- purrr::map2(unlisted,
                               new.distinct.names,
                               .f= ~purrr::set_names(.x, .y))
  
  org_df <- do.call(plyr::rbind.fill, unlisted.info)
  
  return(org_df)
  
}

#I want a list of shelters around 50 miles from zip code 50010
#pf_shelter(token, 50010, 50)


library(httr)
library(magrittr)
library(tidyverse)

pf_shelter <- function(token, zip, dist) {
  base <- "https://api.petfinder.com/v2/"
  query <- "organizations"
  location <- paste0("location", "=", zip)
  distance <- paste0("distance", "=", dist)
  query <- paste0("organizations?",location, "&", distance, "&","limit=100&page=1")
  url <- paste0(base, query)
  search_results <- GET(url = url, 
                        add_headers(Authorization = paste("Bearer", token)))
  
  
  org_info <- content(search_results)$organizations
  
  # Now We can automatically extract the information instead of defining them all.
  # I would try to find an alternative to the part of the function "tibble.f" below later.
  new.distinct.names <- org_info %>% 
    purrr::map(.x, 
               .f=~names(rbind.data.frame(rlist::list.flatten(.x),0)))
  
  unlisted <- org_info %>% 
    purrr::map(.f = ~rbind.data.frame(unlist(.x, recursive=T, use.names=T)))
  
  unlisted.info <- purrr::map2(unlisted,
                               new.distinct.names,
                               .f= ~purrr::set_names(.x, .y))
  
  org_df <- do.call(plyr::rbind.fill, unlisted.info)
  
  return(org_df)
  
}

#I want a list of shelters around 50 miles from zip code 50010
#pf_shelter(token, 50010, 50)

