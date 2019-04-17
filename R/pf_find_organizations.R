#' find_organizations
#'
#' Longer description of what the function does
#'
#' @export
#' @param token An access token
#' @param name Names of organizations
#' @return A dataframe listing information of the desired organizations
#' 
#' @importFrom magrittr %>%
#' @importFrom tibble tibble
#'
#' @examples
#' organizations_of_interest <- pf_find_organizations(token, country = "US", limit = 100, page = 1, sort = "state")


### pf_organziation_search is a function to return data frame based on organization information.
### If a variabale is missed, then a default given by the petfinder API will be returned.
### Default limit of a page is now 100.
### If page = "all" then all the pets will be shown in one data frame.
### Default page is 1.
### Procedures of building up this function is the same as the above function.


pf_find_organizations <- function(token, name = NULL,
                                   location = NULL, 
                                   distance = NULL,
                                   state = NULL, 
                                   country = NULL,
                                   sort = NULL,
                                   limit = 100, page=1) {

  base <- "https://api.petfinder.com/v2/"
  
  if(!missing(location)) {
    organization_location <- paste0("location", "=", location)
  } else {organization_location <- NULL} # define location
  
  if(missing(distance)) {
    organization_distance <- NULL
  } else if (missing(location)) {
    stop("You must specify location in order to filter by distance")
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
    search_results <- httr::GET(url = url, 
                                httr::add_headers(Authorization = paste("Bearer", token)))
    organization_info <- httr::content(search_results)[[1]]
    
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

    return(organization_df)
    
  } else if (page=="all") {
    organization_df_list <- list()
    pg <- 1
    keep <- FALSE
    organization_info <- c()
    
    while(!keep) { # Iteration starts and repeat until keep=TRUE
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
      search_results <- httr::GET(url = url, 
                                  httr::add_headers(Authorization = paste("Bearer", token)))
      tmp_info <- httr::content(search_results)[[1]]

      organization_info <- append(organization_info, tmp_info)
      
      pg <- pg+1 # go to the next page iteration
      keep <- length(tmp_info) < limit # keep repeat this until the number of rows in the data frame is less than assigned limit
      # keep assign the data frame to the list
    }
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
    
    return(organization_df) # return the data frame with all the pets 
  }
  
} 

# test
# organizations_of_interest <- pf_find_organizations(token, country = "US", limit = 100, page = 1, sort = "state")
