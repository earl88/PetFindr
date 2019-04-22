context("test-pf_view_photos")

test_that("correct animal dataframe ", {
#   expect_true(is.data.frame(animal_df= pf_find_pets(token) ))
#   expect_is(animal_df, "data.frame")
#   expect_true(is.character(size))
#  expect_is(size, "character")
  
  # expect an error due to incorrect search result from pf_find_pet
  expect_error(pf_view_photos(animal_df = puppies, size = 123))
  
  # expect an error due to incorrect size
  expect_error(pf_view_photos(animal_df = puppies, size = abc))
  
  
})
