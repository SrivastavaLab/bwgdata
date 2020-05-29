credentials <- new.env(parent = emptyenv())

#' Get login information for the database
#' 
#' In order to access the bwgdb, you need a login token. 
#' This function gets it for you. It will ask you for your
#' BWG username and password (masked)
#' 
#' 
#' @return sets environment variable with login information
#' @export
bwg_auth <- function() {
  ## should check if it exists, and not rerun the function.

  username <- readline("USERNAME: ")
  password <- getPass::getPass("PASSWORD: ")

  
  ## create POST 
  url <- "https://www.zoology.ubc.ca/~lize/v1/api/?route=users&action=login"
  
  body <- list(username = username,
               password = password)
  
  r <- httr::POST(url, body = body, encode = "json")
  
  ## check status code
  httr::stop_for_status(r)
  
  answer <- httr::content(r, as = "text")
  
  credentials$token  <- jsonlite::fromJSON(answer)[["results"]]

}