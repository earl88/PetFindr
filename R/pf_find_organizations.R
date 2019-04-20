#' find_organizations
#'
#' Longer description of what the function does
#'
#' @export
#' @param token An access token
#' @param name Names of organizations
#' @return A dataframe listing information of the desired organizations
#' 
#' @importFrom magrittr %>%
#' @importFrom tibble tibble
#'
#' @examples
#' \dontrun{
#' organizations_of_interest <- pf_find_organizations(token, country = "US",
#'     limit = 100, page = 1, sort = "state")
#' }
pf_find_organizations <- function(token = NULL, name = NULL, 
                                  location = NULL, distance = NULL,
                                  state = NULL, country = NULL,
                                  sort = "recent", page = 1, limit = 20) {

  args <- as.list(match.call(expand.dots = T))[-1]
  args <- args[!purrr::map_lgl(args, is.null)] %>% purrr::map(eval)
  
  query_args <- args[!names(args) %in% c("token", "page")]
  query <- paste0(paste0(names(query_args), "=", query_args), collapse = "&")
  base <- "https://api.petfinder.com/v2/organizations?"
  probe <- GET(url = paste0(base, query),
               add_headers(Authorization = paste("Bearer", token)))
  
  if(probe$status_code != 200) {stop(pf_error(probe$status_code))}
  
  if(length(page) == 1 && page == 1) {
    organization_info <- content(probe)$organizations
  } else {
    max_page <- content(probe)$pagination$total_pages
    if("all" %in% page) {
      page <- 1:max_page
    } else {
      if(max(page) > max_page) {
        warning("You have specified a page number that does not exist. Try using 'page = \"all\"'.")
        page <- page[page <= max_page]
      }
    }
    
    organization_info <- lapply(paste0(base, query, "&page=", page), function(x) {
      results <- GET(url = x,
                     add_headers(Authorization = paste("Bearer", token)))
      if(results$status_code != 200) {stop(pf_error(results$status_code))}
      content(results)$organizations}
    ) %>% purrr::flatten()
  }
  
  organization_df <- purrr::map_dfr(organization_info, .f = function(x) {
    rlist::list.flatten(x) %>%
      rbind.data.frame(deparse.level = 0, stringsAsFactors = F)
  })
  
  return(organization_df)
}