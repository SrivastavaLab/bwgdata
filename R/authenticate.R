#' Get login information for the BWG database
#' 
#' This function retrieves a login token necessary for accessing the BWG database. 
#' It prompts the user for their BWG username and password (the password is masked), 
#' and then sends a login request to the API to obtain an authentication token. 
#' This token is saved in the global environment variable `credentials` for later use.
#' 
#' @details
#' The login information is stored in the `credentials` environment, specifically 
#' in the `token` field. The token is required for making subsequent requests 
#' to the BWG database API.
#' 
#' @return This function does not return a value but sets the `credentials$token` 
#'   environment variable with the obtained login token.
#' 
#' @export
bwg_auth <- function() {
  ## should check if it exists, and not rerun the function.
  
  username <- readline("USERNAME: ")
  password <- getPass::getPass("PASSWORD: ")
  
<<<<<<< HEAD
  ## create POST 
=======
  ## create POST request body
>>>>>>> 2dc4eeb5764448ca9936cd199ab9d152a484f08f
  url <- "https://www.zoology.ubc.ca/~srivast/bwgdb/v3/api/?route=users&action=login"
  
  body <- list(username = username,
               password = password)
  
  r <- httr::POST(url, body = body, encode = "json")
  
  ## check if the request was successful
  httr::stop_for_status(r)
  
  answer <- httr::content(r, as = "text")
  
  ## store the token in the credentials environment
  credentials$token  <- jsonlite::fromJSON(answer)[["results"]]
}