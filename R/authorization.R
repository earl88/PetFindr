# Prompt user to sign up for API
petfindr_setup <- function() {
  browseURL("https://www.petfinder.com/developers/")
}

# Once they have a key  and secret, our functions can save them to their RProfile
petfindr_savekey <- function(key, scope = c("user", "project")) {
  scope <- match.arg(scope)
  path <- usethis:::scoped_path_r(scope)
  assertthat::is.string(key)
  usethis::edit_r_profile(scope = "user")
}

petfindr_savesecret <- function(secret) {
  assertthat::is.string(secret)
  usethis::edit_r_profile(scope = "project")
}

# When the user has a key and secret, this will generate an authorization token
petfindr_auth <- function(key, secret) {
  auth <- POST(url = "https://api.petfinder.com/v2/oauth2/token",
               body = list(grant_type = "client_credentials",
                           client_id = key,
                           client_secret = secret),
               encode = "json")

  access_token <- content(auth)$access_token
  # Maybe also save to RProfile?
}
