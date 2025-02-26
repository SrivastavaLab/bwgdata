#' Get data from bwg
#' 
#' At present this is very general, since perhaps we will 
#' only ever get whole tables?
#' 
#' @param dataname the name of the dataset you want (e.g.
#'   "species")
#' @param opts list of named options for the different API routes.
#'   
#' @return a data.frame containing one whole table.
#' @export
bwg_get <- function(dataname, opts = NULL, to_dataframe = TRUE) {
  
  ## first, check if there is a token
  if (!exists("token", envir = credentials)) {
    message("please log in first!")
    bwg_auth()
  }
  
  token <- get("token", envir = credentials)
  
  ## process token
  token_value <- token[[1]]
  bearer <- paste0("bearer ", token_value)
  
  ## request the species
  baseurl <- "https://www.zoology.ubc.ca/~srivast/bwgdb/v3/api/"
  list_method <- list(route = dataname, action = "list")
  q <- c(list_method, opts)
  
  response <- httr::GET(baseurl,
                        httr::add_headers(Authorization = bearer),
                        query = q)
  
  ## error if it didn't work
  httr::stop_for_status(response)
  
  ## is it json?
  is_json <- grepl("json", httr::headers(response)$`content-type`)
  content <- httr::content(response, as = "text")
  
  if (isTRUE(to_dataframe)) {
    ## Parse response
    response_data <- jsonlite::fromJSON(content, flatten = TRUE)
    
    ## Determine how to extract data
    if (is.data.frame(response_data$results)) {
      # If results is already a data frame, convert to tibble
      output <- tibble::as_tibble(response_data$results)
    } else if (assertthat::has_name(response_data$results, dataname)) {
      # If results has a nested data frame for the dataname
      output <- tibble::as_tibble(response_data$results[[dataname]])
    } else {
      # If results is a flat list, combine into a data frame
      output <- tibble::as_tibble(response_data$results)
    }
  } else {
    output <- content
  }
  
  output
}