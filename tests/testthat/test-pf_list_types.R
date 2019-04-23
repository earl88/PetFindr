context("test-pf_list_types")

test_that("list breeds has input as expected", {
  token <- readLines("token.txt")
  skip_if_not(exists("token"))
  expect_error(pf_list_types(token= 123))
  expect_is(pf_list_types(token= token)[, 1], "data.frame")
  expect_is(pf_list_types(token= token)[, 1], "tbl_df")
  
  
})

test_that("[ retains class", {
  token <- readLines("token.txt")
  skip_if_not(exists("token"))
  mtcars2 <- pf_list_types(token)
  
  expect_identical(class(mtcars2), class(mtcars2[1:2, ]))
  expect_identical(class(mtcars2), class(mtcars2[, 1:2]))
  expect_identical(class(mtcars2), class(mtcars2[1:2, 1:2]))
})