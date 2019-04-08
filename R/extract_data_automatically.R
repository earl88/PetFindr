# Helper function for blank fields
check_null <- function(x) {
  ifelse(!is.null(x), x, NA)
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
  
  
  animal_info <- content(search_results)$animals
  
  # Now We can automatically extract the information instead of defining them all.
  # I would try to find an alternative to the part of the function "tibble.f" below later.
  
  new.names <- animal_info %>% 
    purrr::map(.x, 
               .f=~names(rbind.data.frame(rlist::list.flatten(.x),0)))
  
  unlisted <- animal_info %>% 
    purrr::map(.f = ~unlist(.x, recursive=T, use.names=T))
  
  
  unlisted.animal.info <- purrr::map2(unlisted, 
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
  
  animal_df <- unlisted.animal.info %>% 
    purrr::map_df(tibble.f)
  
  return(animal_df)
  
}

# petfindr_search(token)








