#' Slideshow all available photos of the animals of interest in R
#'
#' @param search_result 
#' @param size 
#'
#' @return SOMETHING MUST GO HERE
#' @export
#'
#' @examples 
#' \dontrun{
#' animals_of_interest<-pf_find_pets(token, location = 50014, distance = 100,
#'     type = "dog", breed = "corgi", gender = c("male", "female"), 
#'     limit=100, page="all", sort = "distance")
#' pf_photo_view(search_result= animals_of_interest, size= "medium")
#' }
pf_photo_view<- function(search_result, size=c("small", "medium", 
                                               "large","full")){
  assertthat::assert_that(is.data.frame( search_result))
  assertthat::not_empty(search_result)
  size<- match.arg(size )
  if (size== "small"){animal_photos<- search_result %>%
    select( tidyselect::vars_select(names(search_result),
                                    starts_with("photos.small", 
                                                ignore.case = TRUE))) }
  
  if (size== "medium"){animal_photos<- search_result %>%
    select(tidyselect::vars_select(names(search_result),
                                   starts_with("photos.medium", 
                                               ignore.case = TRUE)))} 
  
  if (size== "large"){animal_photos<- search_result %>%
    select(tidyselect::vars_select(names(search_result),
                                   starts_with("photos.large", 
                                               ignore.case = TRUE)))} 
  
  if (size== "full"){animal_photos<- search_result %>%
    select(tidyselect::vars_select(names(search_result),
                                   starts_with("photos.full", 
                                               ignore.case = TRUE)))} 
  assertthat::not_empty(animal_photos)
  animal_photos<-animal_photos %>% lapply(FUN = as.character) %>% flatten()
  if (size== "small"){
    
    photos<-purrr::map_chr(animal_photos, magrittr::extract2, 1) %>% na.omit() %>% 
      str_remove("&width=100") 
  }
  if (size== "medium"){
    
    photos<- purrr::map_chr(animal_photos, magrittr::extract2, 1) %>% na.omit() %>% 
      str_remove("&width=300") 
  }
  if (size== "large"){
    
    photos<- purrr::map_chr(animal_photos, magrittr::extract2, 1) %>% na.omit() %>% 
      str_remove("&width=600") 
  }
  if (size== "full"){
    
    photos<- purrr::map_chr(animal_photos, magrittr::extract2, 1) %>% na.omit() %>% 
      str_remove("&width=600") 
  }
  
  return( photos %>%
            knitr::include_graphics() %>% magick::image_read() %>%
            magick::image_scale("400") %>% 
            magick::image_scale("x400") )
}




