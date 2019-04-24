pf_types <- pf_list_types(token)

pf_breeds <- pf_types %>%
  lapply(., function(x) pf_list_breeds(token, type = x)) %>%
  purrr::map(., paste, collapse = ", ") %>%
  purrr::map_dfr(., dplyr::data_frame) %>%
  cbind(types$name, .) %>%
  setNames(c("name", "breeds"))



# usethis::use_data(pf_types)
# usethis::use_data(pf_breeds)


#puppy.data
LA_puppies <- pf_find_pets(token, type = "dog", age = "baby", location = 90405, 
                           distance = 100, limit = 100, page = 1:5, sort = "recent") %>% select("id", "organization_id", "type", "species", "age", "name")
#usethis::use_data(LA_puppies)



#organizations.data 
NY_orgs <- pf_find_organizations(token, state = "NY", 
                                 limit = 100, page = 1:5, sort = "-name") %>% select("id", "name", "address.city", "address.state", "address.state", "address.postcode")
#usethis::use_data(NY_orgs)
