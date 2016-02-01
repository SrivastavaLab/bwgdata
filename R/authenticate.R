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
#' 
#' @examples
bwg_auth <- function(username, password) {
  ## should check if it exists, and not rerun the function.
  token_exists <- exists("token", envir = parent.frame())
  
  if (token_exists) stop("you've already got a token")

  ## check inputs
  assertthat::assert_that(is.character(username))
  assertthat::assert_that(is.character(password))
  
  ## create POST 
  url <- "http://www.zoology.ubc.ca/~lui/v1/api/?route=users&action=login"
  
  body <- list(username = username,
               password = password)
  
  r <- httr::POST(url, body = body, encode = "json")
  
  ## check status code
  httr::stop_for_status(r)
  
  answer <- httr::content(r, as = "text")
  
  token <<- jsonlite::fromJSON(answer)[["results"]]

}