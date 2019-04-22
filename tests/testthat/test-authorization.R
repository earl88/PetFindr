context("test-authorization")

test_that("can use key and secret", {
  skip_if_not(exists(c("petfindr_key", "petfindr_secret")))
  expect_message(pf_accesstoken(petfindr_key, petfindr_secret), "Your access token will last for one hour")
})
  