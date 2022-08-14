#' GBIF Literature API wrapper
#' @description This wrapper is designed to retrive gbif literature for a
#' full year.  The idea to scrap the full information of a full year
#' is to limit 1000 entries and offset other 1000 with this you retrive all
#' the citations in that year.
#'
#' @param year an integer with year. Should have a value over 2000 to present
#' @param limit The number of entries returned. If is null the default is 20
#' @param peer Logical. If is a peer reviewed work or not.
#' @param offset Determines the offset for the search results.
#' A limit of 20 and offset of 20, will get the second page of 20 results
#' @param returnOffset Logical. Returns only the offset or the limit and
#' offset result.
#' @importFrom httr2 request req_perform
#' @importFrom jsonlite fromJSON
#' @importFrom tibble tibble
#'
#'
#' @return a data frame with literature information
#' associated to GBIF Literature API
#' @export
#'
#' @examples
#' get_gbif_literature(year = 2022,
#' limit = 2,
#'  peer = TRUE,
#'  returnOffset = FALSE)
get_gbif_literature <- function(year = 2022,
                                     limit = 1000,
                                     peer = TRUE,
                                     offset = 1000,
                                     returnOffset = TRUE){
  baseUrl <- "https://api.gbif.org/v1/literature/search?"
  if(!is.null(limit)){
    limitString <- paste0("limit=", limit)
  } else {
    limitString <- "limit=20"
  }
  if(peer){
    peerReviewString <- "peerReview=true"
  } else {
    peerReviewString <- "peerReview=false"
  }
  if(!is.null(year)){
    yearString <- paste0("year=", year)
  } else {
    yearString <- paste0("year=", format(Sys.Date(), "%Y"))
  }
  urlQuery <- paste0(baseUrl, limitString, "&",  peerReviewString, "&", yearString )
  req_1 <- httr2::request(base_url = urlQuery)

  resp_1 <- httr2::req_perform(req_1)
  data_json_1 <-  jsonlite::fromJSON(rawToChar(resp_1$body))
  A <- tibble::tibble(data_json_1$results)

  if(is.null(offset)){
    gbif_df <- A
    return(gbif_df)
  } else{
    offsetString = paste0("offset=", offset)
    urlQuery_2 <- paste0(urlQuery, "&", offsetString)
    req_2 <- httr2::request(base_url = urlQuery)
    resp_2 <- httr2::req_perform(req_2)
    data_json_2 <-  jsonlite::fromJSON(rawToChar(resp_2$body))
    B <- tibble::tibble(data_json_2$results)
    if(returnOffset == FALSE){
      gbif_df <- B
      return(gbif_df)
    } else {
      gbif_df <- cbind(A, B)
      return(gbif_df)
    }

  }

}
