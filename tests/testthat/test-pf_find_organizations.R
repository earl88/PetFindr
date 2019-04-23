context("test-pf_find_organizations")

test_that("name input behaves as expected", {
  token <- readLines("token.txt")
  skip_if_not(exists("token"))
  expect_error(pf_find_organizations(token, name = -1))
})

test_that("limit input behaves as expected", {
  token <- readLines("token.txt")
  skip_if_not(exists("token"))
  expect_error(pf_find_organizations(token, limit = -1))
  expect_error(pf_find_organizations(token, limit = 1:2))
  expect_error(pf_find_organizations(token, limit = 101))
  expect_error(pf_find_organizations(token, limit = "ten"))
})


