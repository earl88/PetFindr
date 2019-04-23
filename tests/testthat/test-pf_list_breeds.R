context("test-pf_list_breeds")

test_that("list breeds has input as expected", {
  token <- readLines("token.txt")
  skip_if_not(exists("token"))
  expect_error(pf_list_breeds(token, type = 123))
  expect_error(pf_list_breeds(token, type = "unicorn"))
  expect_true(is.character(pf_list_breeds(token, type = "dog")))
  
  
})


