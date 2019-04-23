context("test-pf_list_types")

test_that("list breeds has input as expected", {
  token <- readLines("token.txt")
  skip_if_not(exists("token"))
  expect_error(pf_list_types(token= 123))
  expect_true(tibble::is_tibble(pf_list_types(token= token)))
  expect_is(pf_list_types(token= token)[, 1], "data.frame")
  expect_is(pf_list_types(token= token)[, 1], "tbl_df")
  
  
})

