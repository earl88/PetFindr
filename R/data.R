#' Available animal types from Petfinder.com, with their respective coat, color, and gender options
#'
#' @source Petfinder API (V2); retrieved on April 23, 2019 \url{https://www.petfinder.com/developers/}
#' @format A data frame with columns:
#' \describe{
#'  \item{name}{Available animal types}
#'  \item{coats}{Available coats for each animal type; if multiple, values are separated by commas}
#'  \item{colors}{Available colors for each animal type; if multiple, values are separated by commas}
#'  \item{genders}{Available coats for each animal type; if multiple, values are separated by commas}
#' }
#' @examples
#' \dontrun{
#'  pf_types
#' }
"pf_types"

#' Available breeds by type from Petfinder.com
#'
#' @source Petfinder API (V2); retrieved on April 23, 2019 \url{https://www.petfinder.com/developers/}
#' @format A data frame with columns:
#' \describe{
#'  \item{name}{Available animal types}
#'  \item{breeds}{Available breeds for each animal type, separated by commas}
#' }
#' @examples
#' \dontrun{
#'  pf_breeds
#' }
"pf_breeds"

#' 
#' #' Available puppies from Los Angeles area extracted from Petfinder.com
#' #'
#' #' @source Petfinder API (V2); retrieved on April 24, 2019 \url{https://www.petfinder.com/developers/}
#' #' @format A data frame with columns:
#' #' \describe{
#' #'  \item{id}{Animal ID}
#' #'  \item{organization_id}{Organization ID}
#' #'  \item{url}{url}
#' #'  \item{type}{type}
#' #'  \item{species}{species}
#' #'  \item{breeds.primary}{breeds.primary}
#' #'  \item{age}{age}
#' #'  \item{gender}{gender}
#' #'  \item{name}{name}
#' #' }
#' #' @examples
#' #' \dontrun{
#' #'  LA_puppies
#' #' }
#' "LA_puppies"
#' 
#' 
#' 
#' #' List of animal shelters in New York State extracted from Petfinder.com
#' #'
#' #' @source Petfinder API (V2); retrieved on April 24, 2019 \url{https://www.petfinder.com/developers/}
#' #' @format A data frame with columns:
#' #' \describe{
#' #'  \item{organization_id}{Organization ID}
#' #'  \item{name}{name}
#' #'  \item{email}{email}
#' #'  \item{phone}{phone}
#' #'  \item{address.city}{city}
#' #'  \item{address.state}{state}
#' #'  \item{address.postcode}{postcode}
#' #' }
#' #' @examples
#' #' \dontrun{
#' #'  NY_orgs
#' #' }
#' "NY_orgs"