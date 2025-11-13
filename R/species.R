#' Get data from bwg
#'
#' At present this is very general, since perhaps we will
#' only ever get whole tables?
#'
#' @param dataname the name of the dataset you want (e.g.
#'   "species")
#' @param opts list of named options for the different API routes.
#' @param to_dataframe logical, should the response be converted to a
#'   data frame? Default is TRUE. If FALSE, the raw content of the response
#'   is returned as text.
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



#' Get all Abundances from a list of datasets
#'
#' @param .dats a dataframe containing datasets. usually the result of using
#'   `bwg_get("datasets")`
#'
#' @returns a dataframe with one row per invertebrate species found in each
#'   dataset. abundances across all bromeliads are in a NESTED dataframe to
#'   reduce clutter.
#' @export
get_all_abundances <- function(.dats){

  ## might need to replace this with a suitable structure
  bwg_get_safe <- purrr::possibly(bwg_get, NA)

  abds_ <- .dats[["dataset_id"]] |>
    as.numeric() |>
    purrr::set_names() |>
    purrr::map(~ list(dataset_id = .x)) |>
    purrr::map(~ bwg_get_safe("matrix", .))

  return(abds_)
}


#' Get all bromeliad information from the database
#'
#' @param .dats a dataframe containing visits. it must have a column called
#'   "visit_id" which stores the IDs for the visits whose bromeliads will be
#'   downloaded. Typically these would be unique, as in the output from
#'   `bwg_get("visits")`.
#'
#' @returns a single dataframe with a column called visit_id, where visit ID is
#'   stored as an integer. The dataframe has one row per bromeliad.
#' @export
get_all_bromeliads <- function(.dats){

  all_brom_list_dropempty <- all_brom_list |>
    purrr::discard(~nrow(.x) == 0)

  all_brom_list_dropempty |>
    purrr:::map_int(~unique(.x[["visit_id"]]))

  if(all(names(vids) == vids)) {
    message("all visit ID match correctly to the query, with no duplicates")
  } else {
    stop("there seems to be a visit response that doesn't match the query")
  }

  # id column not necessary because the visit ID is within the table also, and the
  # database key is identical to the visible visit_id
  all_brom_df <- dplyr::bind_rows(all_brom_list, .id = NULL)

  return(all_brom_df)
}

