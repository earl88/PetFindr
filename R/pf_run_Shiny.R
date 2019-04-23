#' Run PetFindr Shiny app
#'
#' Launch the PetFindr Shiny application that displays animal location information.
#' 
#' @export
#'
#' @examples
#' \dontrun{
#' pf_run_Shiny()
#' }
pf_run_Shiny <- function() {
  appDir <- system.file("example", "pf_shiny", package = "PetFindr")
  if (appDir == "") {
    stop("Could not find example directory. Try re-installing `PetFindr`.",
         call. = FALSE
    )
  }
  
  shiny::runApp(appDir, display.mode = "normal")
}