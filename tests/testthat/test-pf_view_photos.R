context("test-pf_view_photos")

test_that("correct animal dataframe ", {
  expect_error(pf_view_photos(animal_df = puppies, size = 123))
  expect_error(pf_view_photos(animal_df = puppies, size = "abc"))
  
  token <- readLines("token.txt")
  skip_if_not(exists("token"))
  df <- pf_find_pets(token, type = "dog", limit = 3)
  output <- pf_view_photos(df, "small")
  expect_true(tibble::is_tibble(magick::image_info(output)))
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
