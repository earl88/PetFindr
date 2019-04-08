library(httr) #these will need to be @import in Roxygen
library(magrittr)
library(tidyverse)

petfindr_animaltypes <- function(token, type=c("all", "dog", "cat", "rabbit",
                                               "small & furry", "horse", 
                                               "bird", "scales, fins, & other", 
                                               "barnyard")) {
  base <- "https://api.petfinder.com/v2/types"
  type <- match.arg(type)
  if(type == "all") {
    query = ""
  } else {
    query = paste0("/", type)
  }
  url <- paste0(base, query)
  
  search_results <- GET(url = url, 
                        add_headers(Authorization = paste("Bearer", token)))
  
  if(type == "all") {
    type_info <- content(search_results)$types
  } else {
    type_info <- content(search_results)
  }
  
  types_df <- purrr::map_df(type_info, function(x) {
    tibble(name = x$name,
           coats = unlist(x$coats) %>% paste(sep = "", collapse = ", "),
           colors = unlist(x$colors) %>% paste(sep = "", collapse = ", "),
           genders = unlist(x$genders) %>% paste(sep = "", collapse = ", "))
    })
  return(types_df)
}

# petfindr_animaltypes(token, "all")
# petfindr_animaltypes(token, "dog")


