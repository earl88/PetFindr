### pf_organziation_search is a function to return data frame based on organization information.
### If a variabale is missed, then a default given by the petfinder API will be returned.
### Default limit of a page is now 100.
### If page = "all" then all the pets will be shown in one data frame.
### Default page is 1.
### Procedures of building up this function is the same as the above function.

pf_organization_search <- function(token, name = NULL,
                                   location = NULL, 
                                   distance = NULL,
                                   state = NULL, 
                                   country = NULL,
                                   sort = NULL,
                                   limit = 100, page=1) {
  
  library(httr)
  library(magrittr)
  library(tidyverse)
  library(plyr)
  base <- "https://api.petfinder.com/v2/"
  
  if(!missing(location)) {
    organization_location <- paste0("location", "=", location)
  } else {organization_location <- NULL} # define location
  
  if(missing(distance)) {
    organization_distance <- NULL
  } else if (missing(location)) {
    stop("You should specify location before using distance")
  } else {
    organization_distance <- paste0("distance", "=", distance)
  } # define distance from the location
  
  if(missing(limit)) {
    organization_imit <- 100
  } else if (limit > 100 & limit <= 0) {
    stop("The page limit should be between 0 and 100")
  } else {
    organization_imit <- paste0("limit", "=", limit)
  } # define a limit number of pets shown in a page
  
  if(!missing(state)) {
    organization_state <- paste0("state", "=", state)
  } else {organization_state <- NULL}# define state of organizations
  
  if(!missing(country)) {
    organization_country <- paste0("country", "=", country)
  } else {organization_country <- NULL}# define country of organizations
  
  if(!missing(sort)) {
    organization_sort <- paste0("sort", "=", sort)
  } else {organization_sort <- NULL} # define sort information. Null will show the newly updated ones first
  
  
  ####################################
  
  if (page != "all") {
    
    if(!missing(page)) {
      organization_page <- paste0("page", "=", page)
    } else {organization_page <- 1} # define page number
    
    query.sub <- gsub("([[:punct:]])\\1+", "\\1", paste0("organizations?", paste(organization_location, organization_distance, 
                                                                                 organization_state, organization_country,
                                                                                 organization_imit, organization_page, 
                                                                                 organization_sort,
                                                                                 sep = "&")))
    
    ifelse(tail(strsplit(query.sub, "")[[1]], 1) == "&",
           query <- substr(query.sub, 1,nchar(query.sub)-1),
           query <- query.sub)
    
    url <- paste0(base, query)
    search_results <- GET(url = url, 
                          add_headers(Authorization = paste("Bearer", token)))
    organization_info <- content(search_results)[[1]]
    
    # Now We can automatically extract the information instead of defining them all.
    # I would try to find an alternative to the part of the function "tibble.f" below later.
    new.distinct.names <- organization_info %>% 
      purrr::map(.x, 
                 .f=~names(rbind.data.frame(rlist::list.flatten(.x),0)))
    
    unlisted <- organization_info %>% 
      purrr::map(.f = ~rbind.data.frame(unlist(.x, recursive=T, use.names=T)))
    
    unlisted.info <- purrr::map2(unlisted,
                                 new.distinct.names,
                                 .f= ~purrr::set_names(.x, .y))
    
    organization_df <- do.call(plyr::rbind.fill, unlisted.info)
    
    organization_df <- organization_df[which(duplicated(organization_df$id)==FALSE),]
    return(organization_df)
    
  } else if (page=="all") {
    organization_df_list <- list()
    pg <- 1
    keep <- FALSE
    
    while(!keep) {
      
      organization_page <- paste0("page", "=", pg) # start iteration with page=1
      
      query.sub <- gsub("([[:punct:]])\\1+", "\\1", paste0("organizations?", paste(organization_location, organization_distance, 
                                                                                   organization_state, organization_country,
                                                                                   organization_imit, organization_page, 
                                                                                   organization_sort,
                                                                                   sep = "&")))
      
      ifelse(tail(strsplit(query.sub, "")[[1]], 1) == "&",
             query <- substr(query.sub, 1,nchar(query.sub)-1),
             query <- query.sub)
      
      url <- paste0(base, query)
      search_results <- GET(url = url, 
                            add_headers(Authorization = paste("Bearer", token)))
      organization_info <- content(search_results)[[1]]
      
      # Now We can automatically extract the information instead of defining them all.
      # I would try to find an alternative to the part of the function "tibble.f" below later.
      new.distinct.names <- organization_info %>% 
        purrr::map(.x, 
                   .f=~names(rbind.data.frame(rlist::list.flatten(.x),0)))
      
      unlisted <- organization_info %>% 
        purrr::map(.f = ~rbind.data.frame(unlist(.x, recursive=T, use.names=T)))
      
      unlisted.info <- purrr::map2(unlisted,
                                   new.distinct.names,
                                   .f= ~purrr::set_names(.x, .y))
      
      organization_df <- do.call(plyr::rbind.fill, unlisted.info)
      
      organization_df <- organization_df[which(duplicated(organization_df$id)==FALSE),]
      organization_df_list[[pg]] <- organization_df
      pg <- pg+1
      keep <- nrow(organization_df) < limit
    }
    
    organization_df_all <- do.call(rbind.fill, organization_df_list) # rbind.fill is used to combine data in the list
    
    organization_df_all <- organization_df_all[which(duplicated(organization_df_all$id)==FALSE),] # remove duplicated observations
    return(organization_df_all)
  }
  
} 

# test
# organizations_of_interest <- pf_organization_search(token, country = "US", limit = 100, page = 1, sort = "state")
