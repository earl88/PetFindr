
<!-- README.md is generated from README.Rmd. Please edit that file -->
PetFindr
========

<!-- badges: start -->
<img src='inst/logo.png' align="right" height="281" /></a>
==========================================================

[![Travis build status](https://travis-ci.org/earl88/PetFindr.svg?branch=master)](https://travis-ci.org/earl88/PetFindr) [![Codecov test coverage](https://codecov.io/gh/earl88/PetFindr/branch/master/graph/badge.svg)](https://codecov.io/gh/earl88/PetFindr?branch=master) <!-- badges: end -->

PetFindr provides an R interface for the Petfinder.com API (V2). Once a user obtains an API key and secret from [Petfinder](https://www.petfinder.com/developers/), this package allows the user to retrieve information about animals by type, breed, location, and other useful characteristics.

Installation
------------

You can install the the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("earl88/PetFindr")
```

Example
-------

### Set up

Welcome to PetFindr! Before you can search for sweet puppers and kitty cats in R, you'll need to register for the official PetFinder API (V2) at <https://www.petfinder.com/developers/>.

``` r
# pf_setup()
```

The PetFinder API (V2) will assign you a key and secret. Those values can be saved to your .Rprofile for future use.

``` r
petfindr_key <- "paste_key_here"
petfindr_secret <- "paste_secret_here"
# pf_save_credentials(key = petfindr_key, secret = petfindr_secret)
```

You're almost ready! Before you can make a search, you'll need to get an access token.

``` r
# token <- pf_accesstoken(petfindr_key, petfindr_secret)
```

Your access token will last for one hour. After that time, you will need to generate a new token.

### Using PetFindr

Contents
--------

Setup functions

-   `pf_setup()`

-   `pf_save_credentials()`

-   `pf_accesstoken()`

Search functions

-   `pf_find_pets()`

-   `pf_find_organizations()`

List functions

-   `pf_list_types()`

-   `pf_list_breeds()`

viewing functions

-   `pf_view_photos()`

-   `pf_map_animals()`
