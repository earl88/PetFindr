context("test-pf_view_photos")

if(file.exists("token.txt")) {
  token <- readLines("token.txt")
}

test_that("pf_view_photos works", {
  expect_error(pf_view_photos(animal_df = puppies, size = 123))
  expect_error(pf_view_photos(animal_df = puppies, size = "abc"))
  
  skip_if_not(exists("token"))
  df <- pf_find_pets(token, type = "dog", limit = 3)
  output <- pf_view_photos(df, "small")
  expect_true(tibble::is_tibble(magick::image_info(output)))
  
  photo_cols <- grepl(pattern = "photo", x = names(df))
  df[,photo_cols] <- NA
  expect_error(pf_view_photos(df, "small"))
})

