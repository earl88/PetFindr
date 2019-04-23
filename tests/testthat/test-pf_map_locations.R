context("test-pf_map_locations")

test_that("data input behaves as expected", {
  token <- readLines("token.txt")
  skip_if_not(exists("token"))
  expect_error(pf_map_locations(token, data = 1))
  expect_error(pf_map_locations(token, data = "abc"))
})