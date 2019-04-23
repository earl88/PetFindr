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
#'  types
#' }
"types"