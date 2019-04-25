context("test-authorization")

test_that("setup function works", {
  expect_message(pf_setup(), "Welcome to PetFindr!")
})


test_that("can use key and secret", {
  skip_if_not(exists(c("test_key", "test_secret")))
  token <- expect_message(pf_accesstoken(test_key, test_secret), 
                          "Your access token will last for one hour")
  if (nchar(token) > 0) writeLines(token, "token.txt")
})

test_that("can save credentials", {
  if(!file.exists(".RProfile")) writeLines("# Test\n", ".Rprofile")
  skip_if_not(file.exists(".Rprofile"))

  expect_error(pf_save_credentials())
  
  expect_error(pf_save_credentials(key = 1))
  expect_error(pf_save_credentials(key = "Ceci n'est pas une key"))
  
  pf_save_credentials(key = "Ceci n'est pas une key, mais il a 50 caracteres :)")
  expect_warning(pf_save_credentials(key = "This is not a key but it also has 50 characters :)"))
  
  expect_error(pf_save_credentials(secret = 1))
  expect_error(pf_save_credentials(secret = "Ceci n'est pas une secret"))
  
  pf_save_credentials(secret = "Ceci n'est pas une secret, c'est vrai :(")
  expect_warning(pf_save_credentials(secret = "This is not a secret; so sad but true :("))
})
