#' View photos of pets
#' 
#' This function takes a data frame of searched pets and displays the image in
#' a slideshow format.
#'
#' @param animal_df A data frame of animal search results from pf_find_pets().
#' @param size The desired size of the animal photos to be shown 
#'
#' @return A slideshow of animal pictures
#' @export
#'
#' @examples 
#' \dontrun{
#'   puppies <- pf_find_pets(token, type = "dog", age = "baby", breed = "corgi")
#'   pf_view_photos(animal_df = puppies, size = "small")
#'   
#'   bunnies <- pf_find_pets(token, type = "rabbit", age = "baby", limit = 10)
#'   pf_view_photos(animal_df = bunnies, size = "full")
#' }
pf_view_photos <- function(animal_df, 
                           size = c("small", "medium", "large", "full")) {
    assertthat::assert_that(is.data.frame(animal_df))
    assertthat::not_empty(animal_df)
    size <- match.arg(size)
    
    animal_photos <- animal_df %>%
      dplyr::select(tidyselect::vars_select(
        names(animal_df),
        dplyr::starts_with(paste0("photos.", size), ignore.case = TRUE)))
    
    assertthat::not_empty(animal_photos)
    animal_photos <- animal_photos %>%
      lapply(FUN = as.character) %>%
      purrr::flatten()
    
    npix <- (as.character(c(100, 300, 600, 600)) %>%
               stats::setNames(c("small", "medium", "large", "full")))[size]
    
    photos <- purrr::map_chr(animal_photos, magrittr::extract2, 1) %>%
      stats::na.omit() %>%
      stringr::str_remove(paste0("&width=", npix))
    
    return(photos %>%
             knitr::include_graphics() %>%
             magick::image_read() %>%
             magick::image_scale("x400")
    )
  }
