#' Pipe operator
#' 
#' See \code{\link[magrittr]{\%>\%}} for more details.
#'
#' @name %>%
#' @rdname pipe
#' @keywords internal
#' @export
#' @importFrom magrittr %>%
#' @usage lhs \%>\% rhs
NULL

#' Restart RStudio.
#' 
#' This function is reproduced from the package 'usethis'. 
#' For more details, see https://github.com/r-lib/usethis
#' 
#' @param message The message to display when requesting to restart RStudio
#' 
#' @import usethis
restart_rstudio <- function(message = NULL) {
  if (!in_rstudio(proj_get())) {
    return(FALSE)
  }
  
  if (!interactive()) {
    return(FALSE)
  }
  
  if (!is.null(message)) {
    ui_todo(message)
  }
  
  if (!rstudioapi::hasFun("openProject")) {
    return(FALSE)
  }
  
  if (ui_nope("Restart now?")) {
    return(FALSE)
  }
  
  rstudioapi::openProject(proj_get())
}

#' Determine whether base_path is open in RStudio
#' 
#' This function is reproduced from the package 'usethis'. 
#' For more details, see https://github.com/r-lib/usethis
#' 
#' @param base_path The path to investigate
#' 
#' @import usethis
in_rstudio <- function(base_path = proj_get()) {
  if (!rstudioapi::isAvailable()) {
    return(FALSE)
  }
  
  if (!rstudioapi::hasFun("getActiveProject")) {
    return(FALSE)
  }
  
  proj <- rstudioapi::getActiveProject()
  
  if (is.null(proj)) {
    return(FALSE)
  }
  
  fs::path_real(proj) == fs::path_real(base_path)
}
