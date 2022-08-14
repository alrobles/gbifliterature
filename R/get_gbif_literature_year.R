#' get_gbif_literature_year
#' @description Simply GBIF Literature API wrapper to retrive all
#' peer reviewed literature in a given year
#'
#' @param year An integer greather than 2000 to present.
#' @importFrom httr GET
#' @importFrom jsonlite fromJSON
#' @importFrom tibble tibble
#' @importFrom dplyr bind_rows
#'
#'
#' @return A \code{data.frame} with gbif literature for that specific year
#' @export
#'
#'
#' @examples
#' get_gbif_literature_year(2001)
get_gbif_literature_year <- function(year){
  baseUrl <- "https://api.gbif.org/v1/literature/search?limit=1000&year="
  url_1 <- paste0(baseUrl, year)
  res_1 = httr::GET(url_1)
  data_1 <-  jsonlite::fromJSON(rawToChar(res_1$content))
  A <- tibble::tibble(data_1$results)

  url_2 <- paste0(baseUrl, year, "&offset=1000")
  res_2 = httr::GET(url_2)
  data_2 <-  jsonlite::fromJSON(rawToChar(res_2$content))
  B <- tibble::tibble(data_2$results)

  gbif_db <- dplyr::bind_rows(A, B)
  return(gbif_db)
}
