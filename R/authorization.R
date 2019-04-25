#' Get started with PetFindr
#'
#' Running this function will open a browser to "https://www.petfinder.com/developers/" and prompt the user to register for Petfinder's API (V2).
#'
#' @return None
#' @export
#'
#' @examples
#' \dontrun{
#' pf_setup()
#' }
pf_setup <- function() {
  request <- "Welcome to PetFindr! Before you can search for sweet puppers and kitty cats  \n in R, you'll need to register for the official PetFinder API (V2) at \n https://www.petfinder.com/developers/. Would you like to do this now? (Selecting \n 'Yes' will open browser.)"
  
  if (!interactive()) {
    message("Welcome to PetFindr! Before you can search for sweet puppers and kitty cats in R, you'll need to register for the official PetFinder API (V2) at https://www.petfinder.com/developers/. Once you have your user credentials, you can generate your access token using the function pf_accesstoken(key, secret)")
    return(invisible(NULL))
  }
  
  if (usethis::ui_yeah(request)) {
    utils::browseURL("https://www.petfinder.com/developers/")
    cat("If a browser did not open automatically, please open a browser and register \n at https://www.petfinder.com/developers/.\n\n")
    cat("After registering, you will be given a 'key' and a 'secret'. You can use these \n to generate your access token using the function pf_accesstoken(key, secret).\n You can also choose to save them to your .Rprofile for later use with \n the function pf_save_credentials(key, secret).")
  }
}

#' Save Petfinder API (V2) key and secret to .Rprofile
#'
#' This function allows the user to save their Petfinder API (V2) key and/or secret to their .Rprofile for future use.
#'
#' @param key A key provided to the user by the Petfinder API (V2).
#' @param secret A secret provided to the user by the Petfinder API (V2).
#'
#' @return None
#' @export
#' 
#' @examples
#' \dontrun{
#' pf_save_credentials(key, secret)
#' }
pf_save_credentials <- function(key = NULL, secret = NULL) {
  assertthat::assert_that(file.exists(".Rprofile"))
  rprof_contents <- readLines(".Rprofile")
  assertthat::assert_that(!is.null(key) | !is.null(secret))
  
  if (!is.null(key)) {
    assertthat::assert_that(is.character(key))
    assertthat::assert_that(nchar(key) == 50)
    key_exists <- any(grepl("petfindr_key", rprof_contents))
    if (!key_exists) {
      str <- sprintf('\npetfindr_key = \"%s\"\n', key)
      cat(str, file = ".Rprofile", append = TRUE)
      file_changed <- T
    } else {
      message(".Rprofile already contains a key; no file change was made.\n")
      file_changed <- F
    }
  }
  
  if (!is.null(secret)) {
    assertthat::assert_that(is.character(secret))
    assertthat::assert_that(nchar(secret) == 40)
    secret_exists <- any(grepl("petfindr_secret", rprof_contents))
    if (!secret_exists) {
      str <- sprintf('\npetfindr_secret = \"%s\"\n', secret)
      cat(str, file = ".Rprofile", append = TRUE)
      if (!file_changed) {file_changed <- T}
    } else {
      message(".Rprofile already contains a secret; no file change was made.\n")
    }
  }
  
  if (file_changed) {
    source(".Rprofile")
  }
#     if (!requireNamespace("rstudioapi", quietly = T) || 
#         !requireNamespace("fs", quietly = T)) {
# 
#       message("Your credentials will be avaiable in your Global Environment after restarting RStudio.")
#     } else {
#       restart_rstudio("Your credentials will be avaiable in your Global Environment after restarting RStudio.")
#     }
#   }
}

#' Generate an access token for the Petfinder API (V2)
#'
#' @param key A key provided to the user by the Petfinder API (V2)
#' @param secret A secret provided to the user by the Petfinder API (V2)
#'
#' @return An access token for the Petfinder API (V2)
#' @export
#' 
#' @importFrom httr POST content
#'
#' @examples
#' \dontrun{
#' token <- pf_accesstoken(petfindr_key, petfindr_secret)
#' }
pf_accesstoken <- function(key = NULL, secret = NULL) {
  if (is.null(key) || is.null(secret)) {
    stop("You must provide both a key and a secret to receive an access token. Please run 'pf_setup()' for more information.")
  }
  auth <- POST(url = "https://api.petfinder.com/v2/oauth2/token",
                     body = list(grant_type = "client_credentials",
                                 client_id = key, client_secret = secret),
                     encode = "json")
  if (auth$status_code != 200) {stop(pf_error(auth$status_code))}
  accesstoken <- content(auth)$access_token
  message("Your access token will last for one hour. After that time, you will need to generate a new token.\n")
  return(accesstoken)
}