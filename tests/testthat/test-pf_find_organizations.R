context("test-pf_find_organizations")


token <- readLines("token.txt")
# print(token)
# 
# test_that("function runs", {
#   # token <- readLines("token.txt")
#   skip_if_not(exists("token"))
# })

#test_that("name input behaves as expected", {
#  token <- readLines("token.txt")
#  skip_if_not(exists("token"))
#  expect_error(pf_find_organizations(token, name = -1))
#})

test_that("limit input behaves as expected", {
  skip_if_not(exists("token"))
  df <- pf_find_organizations(token = token, name = "dog")
  expect_s3_class(df, "data.frame")
  expect_error(pf_find_organizations(token, name = "dog", limit = -1))
#  expect_error(pf_find_organizations(token, limit = 1:2))
#  expect_error(pf_find_organizations(token, limit = 101))
#  expect_error(pf_find_organizations(token, limit = "ten"))
})

test_that("page input behaves as expected", {
  skip_if_not(exists("token"))
#  expect_error(pf_find_organizations(token, page = -1))
#  expect_error(pf_find_organizations(token, page = "one"))
#  expect_error(pf_find_organizations(token, page = c(1, 1.5, 2.7)))
  expect_error(pf_find_organizations(token, page = 1000^1000))
})


