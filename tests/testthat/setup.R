# if (Sys.getenv("TRAVIS") == "true") {
#   PetFindr::pf_save_credentials(key = Sys.getenv("pf_key"), secret = Sys.getenv("pf_secret"))
# }

# Set system env variables - run once
# Sys.setenv(pf_key = petfindr_key, pf_secret = petfindr_secret)

if (Sys.getenv("pf_key") != "") {
  test_key <- Sys.getenv("pf_key")
}

if (Sys.getenv("pf_secret") != "") {
  test_secret <- Sys.getenv("pf_secret")
}
