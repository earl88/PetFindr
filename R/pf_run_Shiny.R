#'  Run petorg example
#'
#' Launch a Shiny app that shows a demo of what can be done with
#' 
#' \code{PetFindr::petorg}.
#' 
#' @export
#'
#' @examples
#' \dontrun{
#' pf_ShinyApp()
#' }
pf_runShinyApp <- function() {
  appDir <- system.file("example", "petorg", package = "PetFindr")
  if (appDir == "") {
    stop("Could not find example directory. Try re-installing `PetFindr`.",
         call. = FALSE
    )
  }
  
  shiny::runApp(appDir, display.mode = "normal")
}