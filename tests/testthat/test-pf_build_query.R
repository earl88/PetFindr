context("test-pf_build_query")

test_that("building query works", {
  expect_equivalent(pf_build_query(list(limit = 100)), "limit=100")
  expect_equivalent(pf_build_query(list(type = "dog", location = "Ames, IA")),
               "type=dog&location=Ames,%20IA")
})
