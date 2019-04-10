# Helper function for blank fields
check_null <- function(x) {
  ifelse(!is.null(x), x, NA)
}
