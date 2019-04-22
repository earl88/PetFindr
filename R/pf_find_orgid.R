##' Obtain a data frame of organization id using pf_find_pets
#'
#' Retrieve a data frame of information about organizations using the organization id information
#' from pf_find_pets.
#'
#' @param data a data frame obtained from pf_find_pets
#'
#' @importFrom magrittr %>%
#' @importFrom purrr map map_df set_names
#' @importFrom PetFindr pf_find_pets
#' 
#' @return (a data frame obtained by organization id from pf_find_pets)
#' @export
#'
#' @examples
#' \dontrun{
#' pf_dat <- pf_find_pets(token=tokne, location=50014, type="dog")
#' pf_find_orgid(pf_dat)
#' }

pf_find_orgid <- function(data) {
  
  id <- unique(data$organization_id)
  
  base <- "https://api.petfinder.com/v2/organizations/"
  
  organization_list <- list()
  
  for (i in 1:length(id)) {
    
    query <- tolower(id[i])
    
    url <- paste0(base, query)
    
    search_results <- httr::GET(url = url, 
                                httr::add_headers(Authorization = paste("Bearer", token)))
    organization_info <- httr::content(search_results)[[1]]
    
    organization_list[[i]] <- data.frame(id=organization_info$id, 
                                         name=organization_info$name, 
                                         city=organization_info$address[3],
                                         state=organization_info$address[4], 
                                         zip=organization_info$address[5])
  }
  
  organization_df <- do.call(plyr::rbind.fill, organization_list)
  
  org_id_dat <- merge(organization_df, zipcode, by="postcode", by.y="ZIP")
  
  return(org_id_dat)
}
