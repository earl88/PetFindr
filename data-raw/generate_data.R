pf_types <- pf_list_types(token)

pf_breeds <- pf_types %>%
  lapply(., function(x) pf_list_breeds(token, type = x)) %>%
  purrr::map(., paste, collapse = ", ") %>%
  purrr::map_dfr(., dplyr::data_frame) %>%
  cbind(types$name, .) %>%
  setNames(c("name", "breeds"))

# usethis::use_data(pf_types)
# usethis::use_data(pf_breeds)


# Animals example data
LA_puppies <- pf_find_pets(token, type = "dog", age = "baby",
                           location = 90405, distance = 100, limit = 100,
                           page = 1:5, sort = "recent")
rm_indices <- c(paste0("photos.[a-z]{4,6}.", 2:5), "hours", "tags", "links") %>%
  sapply(., grepl, names(LA_puppies)) %>%
  apply(1, any)
keep_cols <- names(LA_puppies)[!rm_indices]
LA_puppies <- LA_puppies[,keep_cols]

# usethis::use_data(LA_puppies)



# Organizations example data
NY_orgs <- pf_find_organizations(token, state = "NY",
                                 limit = 100, page = 1:5, sort = "-name")
rm_indices <- c(paste0("photos.[a-z]{4,6}.", 2:5), "hours", "tags", "links") %>%
  sapply(., grepl, names(NY_orgs)) %>%
  apply(1, any)
keep_cols <- names(NY_orgs)[!rm_indices]
NY_orgs <- NY_orgs[,keep_cols]
# usethis::use_data(NY_orgs)
