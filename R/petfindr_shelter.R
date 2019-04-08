
library(httr)
library(magrittr)
library(tidyverse)

petfindr_shelter <- function(token, zip, dist) {
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
  
  new.names <- org_info %>% 
    purrr::map(.x, 
               .f=~names(rbind.data.frame(rlist::list.flatten(.x),0)))
  
  unlisted <- org_info %>% 
    purrr::map(.f = ~unlist(.x, recursive=T, use.names=T))
  
  
  unlisted.org.info <- purrr::map2(unlisted, 
                                   new.names,
                                   .f= ~purrr::set_names(.x, .y))
  
  unique.names <- unique(unlist(new.names))
  
  tibble.f <- function(x){
    xx <- c()
    for(i in 1:length(unique.names)){
      assign(unique.names[i], check_null(x[unique.names[i]]))
      xx <- paste(xx, unique.names[i], sep=",")
    }
    return(eval(parse(text=(paste("tibble(", substring(xx,2), ")", sep="")))))
  }
  
  org_df2 <- unlisted.org.info %>% 
    purrr::map_df(tibble.f)
  
  return(org_df2)
  
}

#I want a list of shelters around 50 miles from zip code 50010
#petfindr_shelter(token, 50010, 50)
