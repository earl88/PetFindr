context("test-pf_view_photos")

test_that("correct animal dataframe ", {
#   expect_true(is.data.frame(animal_df= pf_find_pets(token) ))
  
  # expect an error due to incorrect search result from pf_find_pet
  expect_error(pf_view_photos(animal_df = puppies, size = 123))
  
  # expect an error due to incorrect size
  expect_error(pf_view_photos(animal_df = puppies, size = "abc"))
  
  
})
