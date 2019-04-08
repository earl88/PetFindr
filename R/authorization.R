# Running this function will open the website for Petfinder's API.
petfindr_setup <- function() {
  request <- "Welcome to PetFindr! Before you can search for sweet puppers and kitty cats in R, you'll need to register for the official PetFinder API at https://www.petfinder.com/developers/. Would you like to do this now? (Selecting 'Yes' will open browser.)"
  if(!interactive()) {
    stop("Welcome to PetFindr! Before you can search for sweet puppers and kitty cats in R, you'll need to register for the official PetFinder API at https://www.petfinder.com/developers/. Once you have your user credentials, you can generate your access token using petfindr_accesstoken(key, secret)")
  }
  if(usethis:::yep(request)) {
    browseURL("https://www.petfinder.com/developers/")
    cat("If a browser did not open automatically, please open a browser and register at https://www.petfinder.com/developers/.\n")
    cat("After registering, you will be assigned a 'key' and a 'secret'. You can use \n these to generate your access token using petfindr_accesstoken(key, secret).\n You can also choose to save them to your .Rprofile for later use with petfindr_save_credentials(key, secret).")
  }
}

# test
# petfindr_setup()








# Once they have a key and secret from the website,
# # our functions can save them to their RProfile
petfindr_save_credentials <- function(key = NULL, secret = NULL,
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
      str <- paste0("\npetfindr_key = \"", key, "\"\n")
      cat(str, file = rprof_path, append = TRUE)
    }
  }
  # If a key is provided, check validity and whether already in Rprofile
  if(!is.null(secret)) {

    # Check input type and length
    assertthat::is.string(secret)
    assertthat::are_equal(nchar(secret), 40)

    # If there is not already a key, add the user-provided key to Rprofile
    secret_exists <- any(grepl("petfindr_secret", rprof_contents))
    if(!secret_exists) {
      str <- paste0("\npetfindr_secret = \"", secret, "\"\n")
      cat(str, file = rprof_path, append = TRUE)
    }
  }

  usethis:::restart_rstudio("Your credentials will be avaiable in your Global Environment after restarting RStudio.")
}


# petfindr_save_credentials(petfindr_key, petfindr_secret)







# When the user has a key and secret, this will generate an access token
petfindr_accesstoken <- function(key, secret) {
  auth <- httr::POST(url = "https://api.petfinder.com/v2/oauth2/token",
               body = list(grant_type = "client_credentials",
                           client_id = key,
                           client_secret = secret),
               encode = "json")
  cat("Your access token will last for one hour. After that time, you will need to generate a new token.\n")
  accesstoken <- httr::content(auth)$access_token
  return(accesstoken)
}

# test
# token <- petfindr_accesstoken(petfindr_key, petfindr_secret)
