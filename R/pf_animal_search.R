### pf_animal_search is a function to return data frame based on animal information.
### If a variabale is missed, then a default given by the petfinder API will be returned.
### breed, color are not yet specified with a list.
### There are very few pets containing coat information.
### Default limit of a page is now 100.
### If page = "all" then all the pets will be shown in one data frame.
### Default page is 1.

#' Title
#'
#' @param token 
#' @param type 
#' @param breed 
#' @param size 
#' @param gender 
#' @param age 
#' @param color 
#' @param coat 
#' @param status 
#' @param name 
#' @param organization 
#' @param location 
#' @param distance 
#' @param sort 
#' @param limit 
#' @param page 
#'
#' 
#' @importFrom httr GET content add_headers
#' @importFrom magrittr %>%
#' @importFrom tibble tibble
#' @importFrom purrr map map_df set_names
#' @importFrom assertthat is.string
#' @importFrom rlist list.flatten
#' @importFrom plyr rbind.fill
#' @return (Fill this in)
#' @export
#'
#' @examples
#' pf_animal_search(token, type = "dog")
pf_animal_search <- function(token, 
                                   type = c("cat", "dog", "smallfurry", "barnyard", "bird", "horse", "reptile"), 
                                   breed = NULL,
                                   size = c("small", "medium", "large", "xlarge"), 
                                   gender = c("all", "male", "female", "unknown"),
                                   age = c("baby", "young", "adult", "senior"), 
                                   color = NULL,
                                   coat = c("short", "medium", "long", "wire", "hairless", "curly"), 
                                   status = c("adoptable", "adopted", "found"),
                                   name = NULL, organization = NULL,
                                   location = NULL, 
                                   distance = NULL,
                                   sort = c("distance", "-distance", "name", "-name", "country", "-country", "state", "-state"),
                                   limit = 100, page=1) {
  
  
  base <- "https://api.petfinder.com/v2/"
  
  gender.arg <- match.arg(gender, several.ok = T) # allow multiple arguements for gender variable
  size.arg <- match.arg(size, several.ok = T) # allow multiple arguements for size variable
  age.arg <- match.arg(age, several.ok = T) # allow multiple arguements for age variable
  coat.arg <- match.arg(coat, several.ok = T) # allow multiple arguements for coat variable
  
  if(!missing(type)) {
    animal_type <- paste0("type", "=", paste(type, collapse=",")) # argument to paste query
  } else {animal_type <- NULL} # if type is missing, define NULL to type of pets
  
  if(!missing(gender)) {
    animal_gender <- paste0("gender", "=", paste(gender.arg, collapse=","))
  } else {animal_gender <- NULL} # if gender is missing, define NULL to gender of pets
  
  if(!missing(age)) {
    animal_age <- paste0("age", "=", paste(age.arg, collapse=","))
  } else {animal_age <- NULL}
  
  if(!missing(size)) {
    animal_size <- paste0("size", "=", paste(size.arg, collapse=","))
  } else {animal_size <- NULL} 
  
  if(!missing(color)) {
    animal_color <- paste0("color", "=", color)
  } else {animal_color <- NULL}
  
  if(!missing(breed)) {
    animal_breed <- paste0("breed", "=", breed)
  } else {animal_breed <- NULL}
  
  if(!missing(coat)) {
    animal_coat <- paste0("coat", "=", paste(coat.arg, collapse=","))
  } else {animal_coat <- NULL}
  
  if(!missing(status)) {
    animal_status <- paste0("status", "=", status)
  } else {animal_status <- NULL} 
  
  if(!missing(sort)) {
    animal_sort <- paste0("sort", "=", sort)
  } else {animal_sort <- NULL} # define sort information. Null will show the newly updated ones first
  
  if(!missing(location)) {
    animal_location <- paste0("location", "=", location)
  } else {animal_location <- NULL} # define location
  
  if(missing(distance)) {
    animal_distance <- NULL # if distance is missing, defind NULL to distance variable
  } else if (missing(location)) {
    stop("You should specify location before using distance") # If location is missing and distance is assigned, stop with error message
  } else {
    animal_distance <- paste0("distance", "=", distance)
  } # define distance from the location
  
  if(missing(limit)) {
    animal_imit <- 100
  } else if (limit > 100 & limit <= 0) {
    stop("The page limit should be between 0 and 100")
  } else {
    animal_imit <- paste0("limit", "=", limit)
  } # define a limit number of pets shown in a page
  
  ####################################
  ####################################
  
  # When page is assigned with a number,
  
  if (page != "all") {
    
    if(!missing(page)) {
      animal_page <- paste0("page", "=", page)
    } else {animal_page <- 1} # define page number
    
    query.sub <- gsub("([[:punct:]])\\1+", "\\1", paste0("animals?", paste(animal_location, animal_distance, animal_type, animal_gender,
                                                                           animal_size, animal_age, animal_status, animal_color, 
                                                                           animal_breed, animal_imit, animal_page, animal_sort,
                                                                           sep = "&")))
    # by the gsub, only one & will be assigned with paste0 procedure
    
    ifelse(tail(strsplit(query.sub, "")[[1]], 1) == "&", # If the last value of the query.sub is &
           query <- substr(query.sub, 1,nchar(query.sub)-1), # remove the &
           query <- query.sub) # Otherwise, just assign query.sub
    
    url <- paste0(base, query) # url is assigned
    search_results <-httr::GET(url = url, 
                          httr::add_headers(Authorization = paste("Bearer", token)))
    animal_info <- httr::content(search_results)[[1]]
    
    # Now We can automatically extract the information instead of defining them all.
    # I would try to find an alternative to the part of the function "tibble.f" below later.
    new.distinct.names <- animal_info %>% 
      purrr::map(.x, 
                 .f=~names(rbind.data.frame(rlist::list.flatten(.x),0)))
    
    unlisted <- animal_info %>% 
      purrr::map(.f = ~rbind.data.frame(unlist(.x, recursive=T, use.names=T)))
    
    unlisted.info <- purrr::map2(unlisted,
                                 new.distinct.names,
                                 .f= ~purrr::set_names(.x, .y))
    
    animal_df <- do.call(plyr::rbind.fill, unlisted.info)

    return(animal_df)
    # until this if statement, page number is specified.
    # Below is the procedure to attach all the pages so that users can see all the pets from a data frame by page="all" arguement.
    
  } else if (page=="all") {
    animal_df_list <- list() # list need to be defined so that a data frame can assigned in a level of list
    pg <- 1 # Iteration index
    keep <- FALSE # keep is assigned to be FALSE
    animal_info <- c()
    
    while(!keep) { # Iteration starts and repeat until keep=TRUE
      
      animal_page <- paste0("page", "=", pg) # start iteration with page=1
      
      query.sub <- gsub("([[:punct:]])\\1+", "\\1", paste0("animals?", paste(animal_location, animal_distance, animal_type, animal_gender,
                                                                             animal_size, animal_age, animal_status, animal_color, 
                                                                             animal_breed, animal_imit, animal_page, animal_sort,
                                                                             sep = "&")))
      
      ifelse(tail(strsplit(query.sub, "")[[1]], 1) == "&",
             query <- substr(query.sub, 1,nchar(query.sub)-1),
             query <- query.sub)
      
      url <- paste0(base, query)
      search_results <- httr::GET(url = url, 
                            httr::add_headers(Authorization = paste("Bearer", token)))
      
      
      # search_status <- search_results$status_code
      # if(search_status != 200) {
      #   stop(pf_error(search_status))
      # }
      tmp_info <- httr::content(search_results)[[1]]
      animal_info <- append(animal_info, tmp_info)
 
      pg <- pg+1 # go to the next page iteration
      keep <- length(tmp_info) < limit # keep repeat this until the number of rows in the data frame is less than assigned limit
      # keep assign the data frame to the list
    }
    
    # Now We can automatically extract the information instead of defining them all.
    # I would try to find an alternative to the part of the function "tibble.f" below later.
    
    new.distinct.names <- animal_info %>% 
      purrr::map(.x, 
                 .f=~names(rbind.data.frame(rlist::list.flatten(.x),0)))
    
    unlisted <- animal_info %>% 
      purrr::map(.f = ~rbind.data.frame(unlist(.x, recursive=T, use.names=T)))
    
    unlisted.info <- purrr::map2(unlisted,
                                 new.distinct.names,
                                 .f= ~purrr::set_names(.x, .y))
    
    animal_df <- do.call(plyr::rbind.fill, unlisted.info)
    
    return(animal_df) # return the data frame with all the pets 
  }
} 

# test
#
# animals_of_interest <- pf_animal_search(token, location = 50014, distance = 150, type = "dog", breed = "pug", gender = c("male", "female"), 

#                           age = "baby", coat = "long", limit=100, page="all", sort = "distance")

