
<!-- README.md is generated from README.Rmd. Please edit that file -->
PetFindr <img src='man/figures/logo.png' align="right" height="280" />
======================================================================

<!-- badges: start -->
[![Travis build status](https://travis-ci.org/earl88/PetFindr.svg?branch=master)](https://travis-ci.org/earl88/PetFindr) [![Codecov test coverage](https://codecov.io/gh/earl88/PetFindr/branch/master/graph/badge.svg)](https://codecov.io/gh/earl88/PetFindr?branch=master) <!-- badges: end -->

PetFindr provides an R interface for the [Petfinder.com API (V2)](https://www.petfinder.com/developers/). Once a user obtains an API key and secret from Petfinder, this package allows the user to retrieve information about animals by type, breed, location, and other useful characteristics. Find more documentation at <https://earl88.github.io/PetFindr/>.

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
library(PetFindr)
pf_setup()
```

The PetFinder API (V2) will assign you a key and secret. Those values can be saved to your .Rprofile for future use.

``` r
petfindr_key <- "paste_key_here"
petfindr_secret <- "paste_secret_here"
pf_save_credentials(key = petfindr_key, secret = petfindr_secret)
```

You're almost ready to find pets! Before you can make a search, you'll need to get an access token.

``` r
token <- pf_accesstoken(petfindr_key, petfindr_secret)
```

Your access token will last for one hour. After that time, you will need to generate a new token.

### Using PetFindr

PetFindr has two functions that list available animal search values: `pf_list_types()` and `pf_list_breeds()`. To list animal breeds, you must specify one of the primary animal types.

``` r
pf_list_types(token)
```

    #> # A tibble: 8 x 4
    #>   name        coats               colors                        genders    
    #>   <chr>       <chr>               <chr>                         <chr>      
    #> 1 Dog         Hairless, Short, M~ Apricot / Beige, Bicolor, Bl~ Male, Fema~
    #> 2 Cat         Hairless, Short, M~ Black, Black & White / Tuxed~ Male, Fema~
    #> 3 Rabbit      Short, Long         Agouti, Black, Blue / Gray, ~ Male, Fema~
    #> 4 Small & Fu~ Hairless, Short, L~ Agouti, Albino, Black, Black~ Male, Fema~
    #> 5 Horse       ""                  Appaloosa, Bay, Bay Roan, Bl~ Male, Fema~
    #> 6 Bird        ""                  Black, Blue, Brown, Buff, Gr~ Male, Fema~
    #> 7 Scales, Fi~ ""                  Black, Blue, Brown, Gray, Gr~ Male, Fema~
    #> 8 Barnyard    Short, Long         Agouti, Black, Black & White~ Male, Fema~

``` r
pf_list_breeds(token, type = "dog") %>% head()
```

    #> [1] "Affenpinscher"    "Afghan Hound"     "Airedale Terrier"
    #> [4] "Akbash"           "Akita"            "Alaskan Malamute"

Armed with options for animal type, breed, coat, color, and gender from the pf\_list\_\*() functions, you can search for animals using a variety of query parameters.

``` r
# Search for baby dogs
puppies <- pf_find_pets(token, type = "dog", age = "baby", gender = "female")

# View images of horses near Dallas, TX
pf_find_pets(token, type = "horse", location = "Dallas, TX", sort = "distance") %>%
  pf_view_photos(., size = "small")
```

<img src="https://raw.githubusercontent.com/earl88/PetFindr/master/inst/FinalPresentation/images/horsepics.gif" width="40%" />

``` r
# Map the locations of small & furry animals
pf_find_pets(token, type = "Small & furry", page = 1:2) %>%
  pf_map_locations(token, .)
```

Interactive exploration of the package could be done with Shiny.

``` r
library(shiny)
pf_run_Shiny()
```

For more details, see the [vignette](https://earl88.github.io/PetFindr/articles/using-petfindr.html).
