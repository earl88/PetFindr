#' Slideshow all available photos of the animals of interest in R
#'
#' @param search_result YOU NEED TO DESCRIBE THIS
#' @param size YOU NEED TO DESCRIBE THIS
#'
#' @return A slideshow of the searched pets
#' @export
#'
#' @examples 
#' \dontrun{
#' corgis <- pf_find_pets(token, location = 50014, distance = 100, type = "dog",
#'     breed = "corgi", gender = c("male", "female"), limit = 100, page = "all", 
#'     sort = "distance")
#' pf_photo_view(search_result = corgis, size = "medium")
#' }

pf_photo_view<- function(search_result, size=c("small", "medium", 
                                               "large", "full")){
  assertthat::assert_that(is.data.frame(search_result))
  assertthat::not_empty(search_result)
  size <- match.arg(size)
  
  # Amin: I think these lines do what your next four "if" statements do.
  # Once you've gone over new changes, delete the old code and comments please
  animal_photos <- search_result %>%
    dplyr::select(tidyselect::vars_select(names(search_result),
                                   dplyr::starts_with(paste0("photos.", size),
                                   ignore.case = TRUE)))
  
  # if (size== "small"){animal_photos<- search_result %>%
  #   select( tidyselect::vars_select(names(search_result),
  #                                   starts_with("photos.small", 
  #                                               ignore.case = TRUE))) }
  # 
  # if (size== "medium"){animal_photos<- search_result %>%
  #   select(tidyselect::vars_select(names(search_result),
  #                                  starts_with("photos.medium", 
  #                                              ignore.case = TRUE)))} 
  # 
  # if (size== "large"){animal_photos<- search_result %>%
  #   select(tidyselect::vars_select(names(search_result),
  #                                  starts_with("photos.large", 
  #                                              ignore.case = TRUE)))} 
  # 
  # if (size== "full"){animal_photos<- search_result %>%
  #   select(tidyselect::vars_select(names(search_result),
  #                                  starts_with("photos.full", 
  #                                              ignore.case = TRUE)))} 
  
  assertthat::not_empty(animal_photos)
  animal_photos <- animal_photos %>%
    lapply(FUN = as.character) %>%
    purrr::flatten()
  
  # Amin: I think these lines do what your next four "if" statements do.
  npix <- (as.character(c(100, 300, 600, 600)) %>% 
             setNames(c("small", "medium", "large", "full")))[size]
  photos <- purrr::map_chr(animal_photos, magrittr::extract2, 1) %>% 
    na.omit() %>%
    stringr::str_remove(paste0("&width=", npix))
  
  # if (size== "small"){
  #   
  #   photos<-purrr::map_chr(animal_photos, magrittr::extract2, 1) %>% na.omit() %>% 
  #     str_remove("&width=100") 
  # }
  # if (size== "medium"){
  #   
  #   photos<- purrr::map_chr(animal_photos, magrittr::extract2, 1) %>% na.omit() %>% 
  #     str_remove("&width=300") 
  # }
  # if (size== "large"){
  #   
  #   photos<- purrr::map_chr(animal_photos, magrittr::extract2, 1) %>% na.omit() %>% 
  #     str_remove("&width=600") 
  # }
  # if (size== "full"){
  #   
  #   photos<- purrr::map_chr(animal_photos, magrittr::extract2, 1) %>% na.omit() %>% 
  #     str_remove("&width=600") 
  # }
  
  return(photos %>%
           knitr::include_graphics() %>% magick::image_read() %>%
           magick::image_scale("400") %>% 
           magick::image_scale("x400"))
}




