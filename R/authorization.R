#' Get started with PetFindr
#'
#' Running this function will open the website for Petfinder's API (V2) and prompt the user to sign up for an account.
#'
#' @return None
#' @export
#'
#' @examples
#' pf_setup()
pf_setup <- function() {
  request <- "Welcome to PetFindr! Before you can search for sweet puppers and kitty cats in R, you'll need to register for the official PetFinder API at https://www.petfinder.com/developers/. Would you like to do this now? (Selecting 'Yes' will open browser.)"
  if(!interactive()) {
    stop("Welcome to PetFindr! Before you can search for sweet puppers and kitty cats in R, you'll need to register for the official PetFinder API at https://www.petfinder.com/developers/. Once you have your user credentials, you can generate your access token using pf_accesstoken(key, secret)")
  }
  if(usethis::ui_yeah(request)) {
    browseURL("https://www.petfinder.com/developers/")
    cat("If a browser did not open automatically, please open a browser and register at https://www.petfinder.com/developers/.\n\n")
    cat("After registering, you will be assigned a 'key' and a 'secret'. You can use \n these to generate your access token using pf_accesstoken(key, secret).\n You can also choose to save them to your .Rprofile for later use with pf_save_credentials(key, secret).")
  }
}









#' Save Petfinder API (V2) key and secret to .Rprofile
#'
#' This function allows the user to save their Petfinder API (V2) key and/or secret to their user or project .Rprofile
#'
#' @param key A key provided to the user by the Petfinder API (V2)
#' @param secret A secret provided to the user by the Petfinder API (V2)
#' @param scope The scope of the .Rprofile to which the key and secret should be saved, either "project" or "user".
#'
#' @return None
#' @export
#' 
#' @examples
#' pf_save_credentials(petfindr_key, petfindr_secret)
pf_save_credentials <- function(key = NULL, secret = NULL,
                                scope = c("project", "user")) {
  
  # Select scope for .Rprofile and make sure file exists
  scope <- match.arg(scope)
  rprof_path <- file.path(usethis:::scoped_path_r(scope), ".Rprofile")
  assertthat::assert_that(file.exists(rprof_path))
  rprof_contents <- readLines(rprof_path)
  
  # Need user to provide at least one of key or secret
  assertthat::assert_that(!is.null(key) | !is.null(secret))
  
  # If a key is provided, check validity and whether already in Rprofile
  if(!is.null(key)) {
    
    # Check input type and length
    assertthat::is.string(key)
    assertthat::are_equal(nchar(key), 50)
    
    # If there is not already a key, add the user-provided key to Rprofile
    key_exists <- any(grepl("petfindr_key", rprof_contents))
    if(!key_exists) {
      str <- sprintf('\npetfindr_key = \"%s\"\n', key)
      cat(str, file = rprof_path, append = TRUE)
    } else{
      cat(".Rprofile already contains a key; no file change was made.\n")
    }
  }
  
  # If a secret is provided, check validity and whether already in Rprofile
  if(!is.null(secret)) {
    
    # Check input type and length
    assertthat::is.string(secret)
    assertthat::are_equal(nchar(secret), 40)
    
    # If there is not already a secret, add the user-provided secret to Rprofile
    secret_exists <- any(grepl("petfindr_secret", rprof_contents))
    if(!secret_exists) {
      str <- sprintf('\npetfindr_key = \"%s\"\n', secret)
      cat(str, file = rprof_path, append = TRUE)
    } else {
      cat(".Rprofile already contains a secret; no file change was made.\n")
    }
  }
  
  if(!requireNamespace(rstudioapi, quietly = T) || 
     !requireNamespace(fs, quietly = T)) {
    message("Your credentials will be avaiable in your Global Environment after restarting RStudio.")
  } else {
    restart_rstudio("Your credentials will be avaiable in your Global Environment after restarting RStudio.")
  }
  return(NULL)
}








#' Generate an access token for the Petfinder API (V2)
#'
#' @param key A key provided to the user by the Petfinder API (V2)
#' @param secret A secret provided to the user by the Petfinder API (V2)
#'
#' @return An access token for the PetFindr API (V2)
#' @export
#'
#' @examples
#' token <- pf_accesstoken(petfindr_key, petfindr_secret)
pf_accesstoken <- function(key = NULL, secret = NULL) {
  
  if(is.null(key) || is.null(secret)) {
    stop("You must provide both a key and a secret to receive an access token. Please run 'pf_setup() for more information.")
  }
  
  auth <- httr::POST(url = "https://api.petfinder.com/v2/oauth2/token",
                     body = list(grant_type = "client_credentials",
                                 client_id = key,
                                 client_secret = secret),
                     encode = "json")
  
  if(auth$status_code != 200) {stop(pf_error(auth$status_code))}
  
  cat("Your access token will last for one hour. After that time, you will need to generate a new token.\n")
  
  accesstoken <- httr::content(auth)$access_token
  return(accesstoken)
}
