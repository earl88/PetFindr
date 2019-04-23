#' @export
runExample <- function() {
  appDir <- system.file("shiny-examples", "myapp", package = "PetFindr")
  if (appDir == "") {
    stop("Could not find example directory. Try re-installing `PetFindr`.", call. = FALSE)
  }
  
  shiny::runApp(appDir, display.mode = "normal")
}