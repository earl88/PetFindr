context("test-pf_error")

test_that("error codes function as expected", {
  errors <- c(200, 400, 401)
  msgs <- c("OK", "")
  expect_equivalent(pf_error(200), "OK")
})
