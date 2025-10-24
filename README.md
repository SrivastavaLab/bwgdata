# Obtaining data from the BWG database

last updated Andrew, Diane, Sandra Feb 2024

A simple package to access our (currently private) API for the bromelaid working group database.

## Installation

This package is not yet on CRAN. To install directly from github, use `devtools`:

```r
library(devtools)
install_github("Srivastavalab/bwgdata")
```

If you don't have `devtools`, you can try the much more lightweight `remotes`

```r
install.packages(remotes)
remotes::install_github("Srivastavalab/bwgdata")
```

## Authentification

Before accessing data from our database, you'll need a valid username and password. 
`bwgdata` has been updated to use **environment variables** instead of interactive passwords. 
To learn more about this approach read the [httr vignette](https://cran.r-project.org/web/packages/httr/vignettes/secrets.html)

### Using `.Renviron` to store your sign-in info

This approach requires a specific text file called `.Renviron`. 
When R starts up, it looks for a file of that name. You can make it manually or via R in the following way:

For your entire computer:

```r
file.edit("~/.Renviron")
```

**NOTE**: if you do this, make sure you know where that file ended up so you can edit it again later if you need!

For your specific project:

```r
file.edit("./.Renviron")
```

**NOTE**: if you do this, make SURE you do not put `.Renviron` on github! 
Do this by adding it to your `.gitignore` file.


### Interactive authentification via `bwg_auth()`

First, you need to tell R your username and password:

```r
library(bwgdata)
bwg_auth()
```

You will be prompted for your username and your password. The latter will be "masked" to protect your privacy. After entering your password, one of two things will happen: 

* nothing. This means that you have access to the data!
* `Forbidden (HTTP 403)` this means that you have either misspelt your password, or you don't have permission to use these data. 

If some third thing happens, please tell me! This would be very unusual.

## Accessing data

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
