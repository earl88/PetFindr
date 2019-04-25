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


#' Available puppies from the Los Angeles area extracted from Petfinder.com
#'
#' @source Petfinder API (V2); retrieved on April 25, 2019 \url{https://www.petfinder.com/developers/}
#' @format A data frame with columns:
#' \describe{
#'  \item{id}{Animal ID}
#'  \item{organization_id}{Organization ID}
#'  \item{url}{URL}
#'  \item{type}{Type}
#'  \item{species}{Species}
#'  \item{breeds.primary}{Primary breed (if known)}
#'  \item{breeds.secondary}{Secondary breed (if known)}
#'  \item{breeds.mixed}{Is breed mixed? (TRUE if secondary breed exists)}
#'  \item{breeds.unknown}{Is breed unknown?}
#'  \item{age}{Age}
#'  \item{gender}{Gender}
#'  \item{size}{Size}
#'  \item{attributes.spayed_neutered}{Is the animal spayed or neutered?}
#'  \item{attributes.house_trained}{Is the animal house-trained?}
#'  \item{attributes.special_needs}{Does the animal have special needs?}
#'  \item{attributes.shots_current}{Are the animal's vaccinations current?}
#'  \item{name}{Name}
#'  \item{description}{Description of the animal's history, personality, and other characteristics}
#'  \item{status}{Adoption status}
#'  \item{published_at}{Date and time the animal's listing was posted}
#'  \item{contact.email}{Contact email}
#'  \item{contact.phone}{Contact phone}
#'  \item{contact.address.address1}{Contact address: line 1}
#'  \item{contact.address.city}{Contact address: city}
#'  \item{contact.address.state}{Contact address: state}
#'  \item{contact.address.postcode}{Contact address: postcode/zipcode}
#'  \item{contact.address.country}{Contact address: country}
#'  \item{colors.primary}{Primary color}
#'  \item{colors.secondary}{Secondary color}
#'  \item{coat}{Coat type}
#'  \item{environment.children}{Can the animal live with children?}
#'  \item{environment.dogs}{Can the animal live with dogs?}
#'  \item{environment.cats}{Can the animal live with cats?}
#'  \item{photos.small}{First photo, small size}
#'  \item{photos.medium}{First photo, medium size}
#'  \item{photos.large}{First photo, large size}
#'  \item{photos.full}{First photo, full size}
#'  \item{photos.small.1}{Second photo, small size}
#'  \item{photos.medium.1}{Second photo, medium size}
#'  \item{photos.large.1}{Second photo, large size}
#'  \item{photos.full.1}{Second photo, full size}
#'  \item{contact.address.address2}{Contact address: line 2}
#'  \item{colors.tertiary}{Tertiary color}
#' }
#' @examples
#' \dontrun{
#'  LA_puppies
#' }
"LA_puppies"


#' List of animal shelters in New York State extracted from Petfinder.com
#'
#' @source Petfinder API (V2); retrieved on April 24, 2019 \url{https://www.petfinder.com/developers/}
#' @format A data frame with columns:
#' \describe{
#'  \item{id}{Organization ID}
#'  \item{name}{Organization name}
#'  \item{email}{Organization email address}
#'  \item{phone}{phone}
#'  \item{address.city}{Organization address: city}
#'  \item{address.state}{Organization address: state}
#'  \item{address.postcode}{Organization address: postcode/zipcode}
#'  \item{address.country}{Organization address: country}
#'  \item{url}{URL}
#'  \item{website}{Organization website}
#'  \item{mission_statement}{Organization mission statement}
#'  \item{adoption.policy}{Adoption policy}
#'  \item{photos.small}{First photo, small size}
#'  \item{photos.medium}{First photo, medium size}
#'  \item{photos.large}{First photo, large size}
#'  \item{photos.full}{First photo, full size}
#'  \item{photos.small.1}{Second photo, small size}
#'  \item{photos.medium.1}{Second photo, medium size}
#'  \item{photos.large.1}{Second photo, large size}
#'  \item{photos.full.1}{Second photo, full size}
#'  \item{address.address1}{Organization address: line 1}
#'  \item{address.address2}{Organization address: line 2}
#'  \item{adoption.url}{Adoption URL}
#'  \item{social_media.facebook}{Social media link: Facebook}
#'  \item{social_media.youtube}{Social media link: YouTube}
#'  \item{social_media.instagram}{Social media link: Instagram}
#'  \item{social_media.twitter}{Social media link: Twitter}
#'  \item{social_media.pinterest}{Social media link: Pinterest}
#' }
#' @examples
#' \dontrun{
#'  NY_orgs
#' }
"NY_orgs"
