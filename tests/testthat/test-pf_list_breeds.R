context("test-pf_list_breeds")

test_that("list breeds works", {
  token <- readLines("token.txt")
  skip_if_not(exists("token"))
  expect_error(pf_list_breeds(token, type = 123))
})

test_that("the  type is a string ", {
  token <- readLines("token.txt")
  skip_if_not(exists("token"))
  expect_true(is.character(pf_list_breeds(token, type = "dog")))
  
})


test_that("the  output is a character vector", {
  token <- readLines("token.txt")
  skip_if_not(exists("token"))
  expect_true(is.character(pf_list_breeds(token, type = "dog")))
  
})