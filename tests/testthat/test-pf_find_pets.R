context("test-pf_find_pets")

if(file.exists("token.txt")) {
  token <- readLines("token.txt")
}


test_that("limit input behaves as expected", {
  skip_if_not(exists("token"))
  df <- pf_find_pets(token = token)
  expect_s3_class(df, "data.frame")
  expect_error(pf_find_pets(token, name = "dog", limit = -1))
  expect_error(pf_find_pets(token, limit = 101))
  expect_error(pf_find_pets(token, limit = "ten"))
})

test_that("page input behaves as expected", {
  skip_if_not(exists("token"))
  expect_error(pf_find_pets(token, page = -1))
  expect_error(pf_find_pets(token, page = "one"))
  expect_error(pf_find_pets(token, page = c(1, 1.5, 2.7)))
  expect_warning(pf_find_pets(token, type = "dog", age = "baby", location = 50014, name = "Bobby Kennedy", page = 10))
  expect_warning(pf_find_pets(token, type = "dog", age = "baby", location = 50014, name = "Bobby Kennedy", limit = 10, page = c(1, 199, 200)))
})

test_that("age input behaves as expected", {
  skip_if_not(exists("token"))
  expect_error(pf_find_pets(token, age = 1))

})


test_that("the output is a data frame", {
  
  skip_if_not(exists("token"))
  df <- pf_find_pets(token = token, type = "dog")
  expect_s3_class(df, "data.frame")

})

