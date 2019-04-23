pf_types <- pf_list_types(token)

pf_breeds <- pf_types %>%
  lapply(., function(x) pf_list_breeds(token, type = x)) %>%
  purrr::map(., paste, collapse = ", ") %>%
  purrr::map_dfr(., dplyr::data_frame) %>%
  cbind(types$name, .) %>%
  setNames(c("name", "breeds"))

# usethis::use_data(pf_types)
# usethis::use_data(pf_breeds)
