context("test-pf_error")

test_that("error codes function as expected", {
  errors <- c(200, 400, 401, 403, 404, 500)
  msgs <- c("OK", 
            "The request is missing parameters or contains invalid parameters. For more information, go to https://www.petfinder.com/developers/v2/docs/.", 
            "Access was denied due to invalid credentials. This could be an invalid API key/secret combination, missing access token, or expired access token.", 
            "Access denied due to insufficient access.", 
            "The requested resource was not found.", 
            "The request ran into an unexpected error. If the problem persists, please contact support at https://www.petfinder.com/developers/support/.")
  expect_equivalent(sapply(errors, pf_error), msgs)
  
  expect_equivalent(pf_error(429), httr::http_status(429L)$message)
  expect_error(pf_error(2))
})
