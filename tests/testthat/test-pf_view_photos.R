context("test-pf_view_photos")

test_that("correct animal dataframe ", {

  # expect an error due to incorrect search result from pf_find_pet
  expect_error(pf_view_photos(animal_df = puppies, size = 123))
  
  # expect an error due to incorrect size
  expect_error(pf_view_photos(animal_df = puppies, size = "abc"))
  
  
  
})

# test_that("photo view has output as expected", {
#   token <- readLines("token.txt")
#   skip_if_not(exists("token"))
#   data(LA_puppies, package = "PetFindr")
#   expect_true(is.data.frame(LA_puppies))
#   LA_puppies_df<-pf_view_photos(LA_puppies[1:20,], "small")
#   expect_true(tibble::is_tibble( magick::image_info(LA_puppies_df) ))
# 
# 
# })
