#'  Run petorg example
#'
#' Launch a Shiny app that shows a demo of what can be done with
#' 
#' \code{PetFindr::petorg}.
#'
#'
#' @examples
#' ## Only run this example in interactive R sessions
#' runExample()
#' 
#' 
#' @export
#' 
runExample <- function() {
  appDir <- system.file("shiny-examples", "petorg", package = "PetFindr")
  if (appDir == "") {
    stop("Could not find example directory. Try re-installing `PetFindr`.",
         call. = FALSE
    )
  }
  
  shiny::runApp(appDir, display.mode = "normal")
}