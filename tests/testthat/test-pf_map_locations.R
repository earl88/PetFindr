context("test-pf_map_locations")

if(file.exists("token.txt")) {
  token <- readLines("token.txt")
}

test_that("data input behaves as expected", {
  skip_if_not(exists("token"))
  expect_error(pf_map_locations(token))
  expect_error(pf_map_locations(token, data = 1))
  expect_error(pf_map_locations(token, data = "abc"))
  leaflet_map <- pf_map_locations(token = token, animal_df = pf_find_pets(token=token, location=50014))
  expect_s3_class(leaflet_map, "leaflet")
})