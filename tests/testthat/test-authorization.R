context("test-authorization")

test_that("setup function works", {
  expect_error(pf_setup())
})

test_that("save credentials", {
  expect_error(pf_save_credentials())
  expect_error(pf_save_credentials(key = 1))
  expect_error(pf_save_credentials(key = "Ceci n'est pas un key"))
})

test_that("can use key and secret", {
  skip_if_not(exists(c("test_key", "test_secret")))
  token <- expect_message(pf_accesstoken(test_key, test_secret), 
                          "Your access token will last for one hour")
  if (nchar(token) > 0) writeLines(token, "token.txt")
})
  