# Running this function will open the website for Petfinder's API.
petfindr_setup <- function() {
  request <- "Welcome to Petfindr! Before you can search for sweet puppers and kitty cats in R, you'll need to register for the official PetFinder API. Would you like to do this now?"
  if(!interactive()) {
    stop("Welcome to Petfindr! Before you can search for sweet puppers and kitty cats in R, you'll need to register for the official PetFinder API. Once you have your user credentials, you can generate your access token using petfindr_accesstoken(key, secret)")
  }
  if(usethis:::yep(request)) {
    browseURL("https://www.petfinder.com/developers/")
    cat("After registering, you will be assigned a 'key' and a 'secret'. You can use\n these to generate your access token using petfindr_accesstoken(key, secret).\n You can also choose to save them to your .Rprofile for later use.")
  }
}

# Once they have a key and secret from the website,
# # our functions can save them to their RProfile
############################# in progress. Mostly functional?
petfindr_save_credentials <- function(key = NULL, secret = NULL,
                                      scope = c("user", "project")) {

  #Select scope for .Rprofile and make sure file exists
  scope <- match.arg(scope)
  rprof_path <- file.path(usethis:::scoped_path_r(scope), ".Rprofile")
  assertthat::assert_that(file.exists(rprof_path))

  # Check that the string inputs are what you expect
  assertthat::assert_that(!is.null(key) | !is.null(secret))

  if(!is.null(key)) {
    assertthat::is.string(key)
    assertthat::are_equal(nchar(key), 50)
  }
  if(!is.null(secret)) {
    assertthat::is.string(secret)
    assertthat::are_equal(nchar(secret), 40)
  }


  # Check whether a key is already in .Rprofile
  rprof_contents <- readLines(rprof_path)
  key_exists <- grepl("petfindr_key", rprof_contents)


  if(!key_exists) {
    str <- paste0("\npetfindr_key = \"", key, "\"\n")
    cat(str, file = ".Rprofile", append = TRUE)
  }
}


petfindr_savekey(petfindr_key)

# When the user has a key and secret, this will generate an authorization token
petfindr_accesstoken <- function(key, secret) {
  auth <- httr::POST(url = "https://api.petfinder.com/v2/oauth2/token",
               body = list(grant_type = "client_credentials",
                           client_id = key,
                           client_secret = secret),
               encode = "json")
  cat("Your access token will last for one hour. After that time, you will need to generate a new one.\n")
  accesstoken <- httr::content(auth)$access_token
}

petfindr_accesstoken(key, secret)
