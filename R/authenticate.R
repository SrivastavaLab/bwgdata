if (!exists("credentials", inherits = FALSE)) {
  credentials <- new.env(parent = emptyenv())
}

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
  # Try to read environment variables
  env_user <- Sys.getenv("bwg_username", unset = NA)
  env_pass <- Sys.getenv("bwg_password", unset = NA)

  if (!is.na(env_user) && !is.na(env_pass)) {
    username <- env_user
    password <- env_pass
  } else {
    message("Environment variables 'bwg_username' and/or 'bwg_password' not set. Please enter credentials manually.")
    username <- readline("USERNAME: ")
    password <- getPass::getPass("PASSWORD: ")
  }

  # Create POST request
  url <- "https://www.zoology.ubc.ca/~srivast/bwgdb/v3/api/?route=users&action=login"
  body <- list(username = username, password = password)

  r <- httr::POST(url, body = body, encode = "json")
  httr::stop_for_status(r)

  answer <- httr::content(r, as = "text")
  credentials$token <- jsonlite::fromJSON(answer)[["results"]]
}
