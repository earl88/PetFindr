context("test-authorization")

test_that("multiplication works", {
  expect_equal(2 * 2, 4)
})

test_that("can use key and secret", {
  expect_type(Sys.getenv("pf_key"), "character")
  # expect_success(pf_accesstoken(Sys.getenv(x = "pf_key"), 
                                # Sys.getenv(x = "pf_secret")))
})
  