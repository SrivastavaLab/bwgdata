% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tidy-abundance.R
\name{tidy_dataset_list}
\alias{tidy_dataset_list}
\title{Tidy a list of abundance data into a data.frame}
\usage{
tidy_dataset_list(matrix_data_list)
}
\arguments{
\item{matrix_data_list}{A list of datasets containing abundance data. 
Each dataset is assumed to have measurements related to various species 
and their respective bromeliad abundances.}
}
\value{
A tidy data.frame where each row represents an individual 
  observation of abundance data, with columns representing species, 
  measurements, and dataset metadata.
}
\description{
This function processes data from the output of \code{bwg_get("matrix")}. It 
runs several smaller functions that convert a list of nested datasets into 
a tidy data frame. The function assumes that the input is a list of 
datasets, and it heavily utilizes the \code{purrr} package for mapping and 
iterating over the data.
}
