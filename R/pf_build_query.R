#' Build a query string
#'
#' @param args The list of arguments from the parent function
#'
#' @return A query string
pf_build_query <- function(args = NULL) {
  args <- args[!purrr::map_lgl(args, is.null)] %>% purrr::map(eval)
  
  query_args <- args[!names(args) %in% c("token", "page")]
  query_args <- stats::setNames(unlist(query_args, use.names=F),
                                rep(names(query_args), lengths(query_args)))
  
  query <- paste(names(query_args), query_args, sep = "=", collapse = "&") %>%
    gsub(pattern = "[ ]", replacement = "%20")
  return(query)
}
