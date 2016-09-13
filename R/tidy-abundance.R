
weird <- new.env()

weird$problems <- list()

test_numeric <- function(to_num){
  as_num <- as.numeric(to_num)
  
  for (x in 1:length(as_num))
    if (is.na(as_num[x])) {
      weird$problems <- c(weird$problems, to_num[x])
    }
  return(as_num)
}


make_brom_a_df <- function(abd_data){
  # browser()
  abd_data %>%
    at_depth(2,
             ~ map_at(.x, "measurements",
                      ~ map(.x,
                            ~ map_at(.x, "bromeliads",
                                     ~ data_frame(bromeliad_id = names(.x),
                                                  abd = test_numeric(.x))))))
}

## A function to convert the information about the abundance of a particular
## insect of particular size into one dataframe.
one_measurement <- function(measure_list){
  measure_list_flat <- map_at(measure_list, "measurement", flatten_chr)
  
  assertthat::assert_that(length(measure_list_flat$measurement) == 1)
  
  measure_list_flat %>%
    flatten %>%
    invoke(data_frame, .)
}


make_full_df <- function(abd_data_flat){
  abd_data_flat %>%
    at_depth(2,
             ~ map_at(.x, "measurements",
                      ~ map(.x, one_measurement) %>%
                        bind_rows)) %>%
    at_depth(2, flatten) %>%
    at_depth(2, ~ invoke(data_frame, .x)) %>%
    at_depth(1, bind_rows, .id = "species_id") %>%
    .[["species"]]
}


#' Tidy a list of abundance data in to a data.frame
#' 
#' This is a function that runs many smaller functions. together, they process 
#' data from the output of \code{bwg_get("matrix")}. The function assumes that
#' there is a list of such datasets. It relies heavily on \code{purrr}
#' 
#' @param matrix_data_list
#'   
#' @return a dataframe
#' @export
tidy_dataset_list <- function(matrix_data_list){
  matrix_data_list %>%
    map(make_brom_a_df) %>%
    map(make_full_df) %>%
    bind_rows(.id = "dataset_id")
}

