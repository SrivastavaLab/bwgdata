#' Get data from bwg
#' 
#' At present this is very general, since perhaps we will 
#' only ever get whole tables?
#' 
#' @param dataname the name of the dataset you want (e.g.
#'   "species")
#'   
#' @return a data.frame containing one whole table.
#' @export
bwg_get <- function(dataname) {
  
  ## first, check if there is a token
  assertthat::assert_that(exists("token", envir = parent.frame()))
  
  token <- get("token", envir = parent.frame())
  
  ## process token
  ### its a list, so we simplify it to a scalar vector:
  token_value <- token[[1]]
  ### then we add the word "bearer " to the beginning
  bearer <- paste0("bearer ", token_value)
  
  ## request the species
  
  baseurl <- "http://www.zoology.ubc.ca/~lui/v1/api/"

  response <- httr::GET(baseurl,
                        httr::add_headers(Authorization = bearer),
                        query = list(route = dataname,
                                     action = "list"))
 
  ## error if it didn't work
  httr::stop_for_status(response)
  
  ## is it json?
  is_json <- grepl("json", httr::headers(response)$`content-type`) # is there a better way?
  
  assertthat::assert_that(is_json)
  
  content <- content(response, as = "text")
  
  jsonlite::fromJSON(content[["result"]])
}