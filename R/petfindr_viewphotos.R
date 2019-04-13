
# 
# Getting the photo of thepets on R
# I modified Susan's code to get photos of the search on R. I 
# The full photos are pretty big and it takes too long to be 
# loaded and shown, so I used the medium size images. We can later
# make it a function to allow users choose if they wanna see the small/ medium
# or full size images (if they are available). This is just an example of getting
# the images on R. 


# library(tibble)
# library(stringr)
# # 
# nimals_of_interest <- petfindr_animal_search(token, location = 50014, distance = 150, type = "dog", breed = "pug", gender = c("male", "female"), 
#                                              age = "baby", coat = "long", limit=100, page="all", sort = "distance")
# na.omit (purrr:: map_chr(animals_of_interest[,]$photos.medium, 
#                          magrittr::extract2, 1)) %>% 
#   str_remove("&width=60&-pnt.jpg") %>%
#   knitr::include_graphics() %>% magick::image_read()


pf_photo_view<- function(search_result, size=c("small", "medium", 
                                               "large","full")){
  assertthat::assert_that(is.data.frame( search_result))
  assertthat::not_empty(search_result)
  if (size== "small"){ photo.size<- c(search_result$photos.small, 
                                      search_result$photos.small.1,
                                      search_result$photos.small.2,
                                      search_result$photos.small.3,
                                      search_result$photos.small.4)}
  
  if (size== "medium"){ photo.size<- c(search_result$photos.medium, 
                                      search_result$photos.medium.1,
                                      search_result$photos.medium.2,
                                      search_result$photos.medium.3,
                                      search_result$photos.medium.4)} 
  
  if (size== "large"){ photo.size<- c(search_result$photos.large, 
                                       search_result$photos.large.1,
                                       search_result$photos.large.2,
                                       search_result$photos.large.3,
                                       search_result$photos.large.4)} 
 
  if (size== "large"){ photo.size<- c(search_result$photos.large, 
                                      search_result$photos.large.1,
                                      search_result$photos.large.2,
                                      search_result$photos.large.3,
                                      search_result$photos.large.4)}  
  
  
  if (size== "full"){ photo.size<- c(search_result$photos.full, 
                                      search_result$photos.full.1,
                                      search_result$photos.full.2,
                                      search_result$photos.full.3,
                                      search_result$photos.full.4)} 
  photo.size<-na.omit(photo.size)
  if (length(photo.size)== 0){cat("There is no photo available at this size. You may try another size")}
  
  photo.out<-purrr:: map_chr(animals_of_interest[,]$photo.size, 
                           magrittr::extract2, 1) %>% 
    str_remove("&width=60&-pnt.jpg") %>%
    knitr::include_graphics()
    return(photo.out %>% magick::image_read())
}
