
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
# 
# na.omit (purrr:: map_chr(animals_of_interest[,]$photos.medium, 
#                          magrittr::extract2, 1)) %>% 
#   str_remove("&width=60&-pnt.jpg") %>%
#   knitr::include_graphics() %>% magick::image_read()