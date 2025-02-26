#' Tidy a list of abundance data into a data.frame
#' 
#' This function processes data from the output of \code{bwg_get("matrix")}. It 
#' runs several smaller functions that convert a list of nested datasets into 
#' a tidy data frame. The function assumes that the input is a list of 
#' datasets, and it heavily utilizes the \code{purrr} package for mapping and 
#' iterating over the data.
#' 
#' @param matrix_data_list A list of datasets containing abundance data. 
#'   Each dataset is assumed to have measurements related to various species 
#'   and their respective bromeliad abundances.
#' 
#' @return A tidy data.frame where each row represents an individual 
#'   observation of abundance data, with columns representing species, 
#'   measurements, and dataset metadata.
#' @export
tidy_dataset_list <- function(matrix_data_list){
  matrix_data_list %>%
    map(make_brom_a_df) %>%
    map(make_full_df) %>%
    bind_rows(.id = "dataset_id")
}


#' Process abundance data for bromeliads and convert to a data frame
#' 
#' This function processes abundance data at a depth of 2 in a nested list 
#' and returns a data frame for each dataset. It extracts measurements related 
#' to bromeliads and calculates abundance values.
#' 
#' @param abd_data A nested list containing abundance data.
#' 
#' @return A nested data frame where each element corresponds to the 
#'   abundance of a species in a particular bromeliad.
#' @export
make_brom_a_df <- function(abd_data){
  abd_data %>%
    at_depth(2,
             ~ map_at(.x, "measurements",
                      ~ map(.x,
                            ~ map_at(.x, "bromeliads",
                                     ~ data_frame(bromeliad_id = names(.x),
                                                  abd = test_numeric(.x))))))
}


#' Convert a list of measurements into a single data frame
#' 
#' This function processes a list of measurements for a specific insect size 
#' and returns them as a flat data frame.
#' 
#' @param measure_list A list containing measurements for a particular insect 
#'   size.
#' 
#' @return A data frame representing the measurements for a specific insect size.
#' @export
one_measurement <- function(measure_list){
  measure_list_flat <- map_at(measure_list, "measurement", flatten_chr)
  
  assertthat::assert_that(length(measure_list_flat$measurement) == 1)
  
  measure_list_flat %>%
    flatten %>%
    invoke(data_frame, .)
}


#' Test if numeric values are valid
#' 
#' This function converts input values into numeric format and stores any 
#' values that are not valid numbers (NA) into a list of problems.
#' 
#' @param to_num A vector of values to be converted to numeric.
#' 
#' @return A numeric vector where invalid values are converted to NA. 
#'   It also updates the 'weird' environment with the invalid entries.
#' @export
test_numeric <- function(to_num){
  as_num <- as.numeric(to_num)
  
  for (x in 1:length(as_num))
    if (is.na(as_num[x])) {
      weird$problems <- c(weird$problems, to_num[x])
    }
  return(as_num)
}