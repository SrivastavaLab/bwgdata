# Obtaining data from the BWG database

A simple package to access our (currently private) API for the bromelaid working group database.

## Installation

This package is not yet on CRAN. To install directly from github, use `devtools`:

```r
library(devtools)
install_github("Srivastavalab/bwgdata")
```

If you don't have `devtools`, you can try the much more lightweight `ghit`

```r
install.packages(ghit)
library(ghit)
install_github("Srivastavalab/bwgdata")
```

## usage

Before accessing data from our database, you'll need a valid username and password. 

### Step 1: Authenticate

First, you need to tell R your username and password:

```r
library(bwgdata)
bwg_auth()
```

You will be prompted for your username and your password. The latter will be "masked" to protect your privacy. After entering your password, one of two things will happen: 

* nothing. This means that you have access to the data!
* `Forbidden (HTTP 403)` this means that you have either misspelt your password, or you don't have permission to use these data. 

If some third thing happens, please tell me! This would be very unusual.

### Step 2: access data

Right now there's only one data-obtaining function:

```r
bwg_get("datasets")

bwg_get("visits")

bwg_get("bromeliads")
```

There are two ways of getting the species: with or without the _Tachet traits_:

```r
# just the species pls
bwg_get("species")

# both species and traits
bwg_get("species", list(traits = "true"))
```