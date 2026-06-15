# Deflate a nominal LCU column to real values

Convert nominal wages (LCU prices) into real wages expressed in constant
LCU prices of a specified base year using: \$\$\text{real} =
\text{nominal} \times \frac{\text{CPI}\_{base}}{\text{CPI}\_{ref}}\$\$

## Usage

``` r
deflate_to_real(col, ref_date, country_code, base_year = 2021)
```

## Arguments

- col:

  Numeric vector. The nominal LCU values to deflate (a data column).

- ref_date:

  A vector coercible to `Date` (or a `Date` column). The reference date
  for each observation; the year is extracted internally.

- country_code:

  Character. Either a scalar (e.g. `"MOZ"`) recycled across all rows, or
  a character column of ISO3 country codes.

- base_year:

  Integer scalar. The base year to deflate to. Defaults to `2021`.

## Value

A numeric vector of the same length as `col`, expressed in constant
`base_year` LCU prices. Returns `NA` for any row where CPI data is
missing for the given country/year combination.

## Details

CPI data is sourced from \[govhr::macro_indicators\], which must contain
columns `country_code`, `year`, and `cpi`.

## Examples

``` r
library(dplyr)

data <- tibble::tibble(
  country_code = c("MOZ", "MOZ", "BWA", "BWA"),
  survey_date  = as.Date(c("2019-06-01", "2020-03-15", "2021-09-01", "2022-11-30")),
  wage_lcu     = c(15000, 18000, 42000, 51000)
)

# Scalar country code
data |>
  dplyr::mutate(wage_real = deflate_to_real(wage_lcu, survey_date, "MOZ"))
#> # A tibble: 4 × 4
#>   country_code survey_date wage_lcu wage_real
#>   <chr>        <date>         <dbl>     <dbl>
#> 1 MOZ          2019-06-01     15000    16517.
#> 2 MOZ          2020-03-15     18000    19154.
#> 3 BWA          2021-09-01     42000    42000 
#> 4 BWA          2022-11-30     51000    46246.

# Country code from a column
data |>
  dplyr::mutate(wage_real = deflate_to_real(wage_lcu, survey_date, country_code))
#> # A tibble: 4 × 4
#>   country_code survey_date wage_lcu wage_real
#>   <chr>        <date>         <dbl>     <dbl>
#> 1 MOZ          2019-06-01     15000    16517.
#> 2 MOZ          2020-03-15     18000    19154.
#> 3 BWA          2021-09-01     42000    42000 
#> 4 BWA          2022-11-30     51000    45672.

# Custom base year
data |>
  dplyr::mutate(wage_real = deflate_to_real(wage_lcu, survey_date, country_code, base_year = 2015))
#> # A tibble: 4 × 4
#>   country_code survey_date wage_lcu wage_real
#>   <chr>        <date>         <dbl>     <dbl>
#> 1 MOZ          2019-06-01     15000    10389.
#> 2 MOZ          2020-03-15     18000    12047.
#> 3 BWA          2021-09-01     42000    34107.
#> 4 BWA          2022-11-30     51000    37089.
```
