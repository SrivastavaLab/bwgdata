% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/species.R
\name{bwg_get}
\alias{bwg_get}
\title{Get data from bwg}
\usage{
bwg_get(dataname, opts = NULL, to_dataframe = TRUE)
}
\arguments{
\item{dataname}{the name of the dataset you want (e.g.
"species")}

\item{opts}{list of named options for the different API routes.}
}
\value{
a data.frame containing one whole table.
}
\description{
At present this is very general, since perhaps we will 
only ever get whole tables?
}

