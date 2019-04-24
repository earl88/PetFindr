context("test-pf_find_pets")

token <- readLines("token.txt")

test_that("limit, sort and page inputs behaves as expected", {
  
  expect_error(pf_find_organizations(token, type= "dog", limit = -1))
  expect_error(pf_find_pets(token, sort = "123"))
  expect_error(pf_find_pets(token, page = 1000^1000))
  
 
})

test_that("the output is a data frame", {
  
  skip_if_not(exists("token"))
  df <- pf_find_pets(token = token, type = "dog")
  expect_s3_class(df, "data.frame")

})

# test_that("output is a data frame  as expected", {
#   skip_if_not(exists("token"))
#   data(LA_puppies, package = "PetFindr")
#   expect_true(is.data.frame(LA_puppies))
# })