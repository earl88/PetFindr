# Helper function for blank fields
check_null <- function(x) {
  ifelse(!is.null(x), x, NA)
}

petfindr_searchanimals <- function(token, type = NULL, breed = NULL,
                                   size = NULL, 
                                   gender=c("all", "male", "female", "unknown"),
                                   age = NULL, color = NULL,
                                   coat = NULL, status = NULL,
                                   name = NULL, organization = NULL,
                                   location = NULL, distance = NULL,
                                   sort = NULL, page = NULL, limit = 20) {
  library(httr)
  library(magrittr)
  library(tidyverse)
  base <- "https://api.petfinder.com/v2/animals"
  
  ####################################
  # NEEDS TO BE CODED:
  # Build query here based on available variables from above.
  # Whoever wants to do this, the steps are
  # 1. Finding the options for each argument in the online API documentation
  # 2. Typing the options in the function call above (like for gender, above)
  # 3. Writing a match.arg() below with several.ok = T when appropropriate
  # When this is done for all fields, write an appropriate paste command
  # to create the full query.
  gender <- match.arg(gender, several.ok = T)
  query <- ""
  ####################################
  
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








