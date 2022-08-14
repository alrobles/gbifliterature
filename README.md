
<!-- README.md is generated from README.Rmd. Please edit that file -->

# gbifliterature

<!-- badges: start -->
<!-- badges: end -->

The goal of gbifliterature is to connect with GBIF Literature API and
retrive the full information by year.

## Installation

You can install the development version of gbifliterature from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("alrobles/gbifliterature")
```

## Example GBIF literature by year

We starting download all the literature from 2022. We use
`get_gbif_literature_year` to get the literature for the specific 2022
year from the API.

``` r
lit_2001 <- gbifliterature::get_gbif_literature_year(year = 2001)
```

You can print the output object if you want. The output is a data frame
containing all the information related to GBIF peer reviewed literature
in 2022

## Download all GBIF iterature

In the last example we observe that it’s possible to map this function
passing the year parameter:

``` r
library(purrr)
literature_df <- map_df(2000:2022, function(x){
    gbifliterature::get_gbif_literature_year(year = x)
  })
```
