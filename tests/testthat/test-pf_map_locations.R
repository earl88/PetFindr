context("test-pf_map_locations")
token <- readLines("token.txt")

test_that("data input behaves as expected", {
  skip_if_not(exists("token"))
  expect_error(pf_map_locations(token))
  expect_error(pf_map_locations(token, data = 1))
  expect_error(pf_map_locations(token, data = "abc"))
})