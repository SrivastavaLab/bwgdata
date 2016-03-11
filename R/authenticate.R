credentials <- new.env(parent = emptyenv())

#' Get login information for the database
#' 
#' In order to access the bwgdb, you need a login token.
#' This function gets it for you.
#' 
#' @param username bwgdb username
#' @param password bwgdb password
#'   
#' @return sets environment variable with login information
#' @export
bwg_auth <- function() {
  ## should check if it exists, and not rerun the function.

  username <- readline("USERNAME: ")
  password <- getPass::getPass("PASSWORD: ")

  
  ## create POST 
  url <- "http://www.zoology.ubc.ca/~lui/v1/api/?route=users&action=login"
  
  body <- list(username = username,
               password = password)
  
  r <- httr::POST(url, body = body, encode = "json")
  
  ## check status code
  httr::stop_for_status(r)
  
  answer <- httr::content(r, as = "text")
  
  credentials$token  <- jsonlite::fromJSON(answer)[["results"]]

}