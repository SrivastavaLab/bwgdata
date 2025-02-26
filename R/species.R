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
  ### its a list, so we simplify it to a scalar vector:
  token_value <- token[[1]]
  ### then we add the word "bearer " to the beginning
  bearer <- paste0("bearer ", token_value)
  
  ## request the species
  
  baseurl <- "https://www.zoology.ubc.ca/~srivast/bwgdb/v3/api/"
  
  list_method <- list(route = dataname,
                      action = "list")
  
  q <- c(list_method, opts)

  response <- httr::GET(baseurl,
                        httr::add_headers(Authorization = bearer),
                        query = q)
 
  ## error if it didn't work
  httr::stop_for_status(response)
  
  ## is it json?
  is_json <- grepl("json", httr::headers(response)$`content-type`) # is there a better way?
  
  # assertthat::assert_that(is_json)
  
  content <- httr::content(response, as = "text")
  
  if (isTRUE(to_dataframe)){
    ## parse response to text
    
    response_data <- jsonlite::fromJSON(content, flatten = TRUE)
    
    ## hopefully it is true that there is always part of the results called "dataname"
    if (assertthat::has_name(response_data$results, dataname)) {
      output <- tibble::as_tibble(response_data$results[[dataname]])
    } else {
      message("coercion to data.frame impossible! returning a list")
      output <- response_data$results
      
    }
    
  } else {
    output <- content
  }
   output 
}