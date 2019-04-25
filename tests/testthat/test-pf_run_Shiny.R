context("test-pf_run_Shiny")

test_that("file exist", {
  skip_if_not(dir.exists("../../inst/shiny-example"))
  expect_true(file.exists(file.path(system.file("shiny-example\\pf_shiny", package = "PetFindr"), "global.R")))
  expect_true(file.exists(file.path(system.file("shiny-example\\pf_shiny", package = "PetFindr"), "server.R")))
  expect_true(file.exists(file.path(system.file("shiny-example\\pf_shiny", package = "PetFindr"), "ui.R")))
})
