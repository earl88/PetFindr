# Returns NA when input is null
check_null <- function(x) {
  ifelse(!is.null(x), x, NA)
}

# Function to restart Rstudio.
# This function originates from the package 'usethis'
# which can be found here : https://github.com/r-lib/usethis
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
