context("test-pf_map_locations")

if(file.exists("token.txt")) {
  token <- readLines("token.txt")
}

test_that("pf_map_locations works", {
  skip_if_not(exists("token"))
  expect_error(pf_map_locations(token))
  expect_error(pf_map_locations(token, data = 1))
  expect_error(pf_map_locations(token, data = "abc"))
  df <- pf_find_pets(token=token, location=50014)
  leaflet_map <- pf_map_locations(token = token, animal_df = df)
  expect_s3_class(leaflet_map, "leaflet")
  
  df$organization_id[1] <- "Not an ID"
  expect_error(pf_locate_organizations(token, df[1,]))
})