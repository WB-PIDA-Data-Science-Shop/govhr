# Deflate a nominal LCU column to real values

Converts nominal values (e.g. wages in local currency units, LCU) into
real values expressed in constant LCU prices of a chosen base month,
using monthly consumer price index (CPI) data: \$\$\text{real} =
\text{nominal} \times \frac{\text{CPI}\_{base}}{\text{CPI}\_{month}}\$\$

## Usage

``` r
deflate_to_real(col, ref_date, country_code, base_month = "2021-12-01")
```

## Arguments

- col:

  Numeric vector. The nominal LCU values to deflate (a data column).

- ref_date:

  A vector coercible to `Date` (or a `Date` column). The reference date
  for each observation. Any day within a month is matched to that
  month's CPI.

- country_code:

  Character. Either a scalar (e.g. `"MOZ"`) recycled across all rows, or
  a character column of ISO3 country codes.

- base_month:

  The month whose prices the values are expressed in, given as its first
  day in `"YYYY-MM-01"` format (or as a `Date`). Defaults to
  `"2021-12-01"`.

## Value

A numeric vector of the same length as `col`, expressed in constant LCU
prices of `base_month`. Returns `NA` (with a warning) for any row where
CPI is missing for its own month, or for the country's base month.

## Details

CPI data comes from
[cpi](https://wb-pida-data-science-shop.github.io/govhr/reference/cpi.md),
the IMF's monthly all-items CPI. Each observation is deflated with the
CPI of its own month, rather than an annual average, so values within
the same year are made comparable too.

The base month must be within each country's CPI data. With the default
(December 2021), this holds for every country except the 15 listed in
[cpi](https://wb-pida-data-science-shop.github.io/govhr/reference/cpi.md),
whose series stop before or start after that month. For those, pick a
`base_month` within their data; otherwise the result is `NA`, and the
warning shows the months each country covers.

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
#> 1 MOZ          2019-06-01     15000    17143.
#> 2 MOZ          2020-03-15     18000    19835.
#> 3 BWA          2021-09-01     42000    43592.
#> 4 BWA          2022-11-30     51000    46606.

# Country code from a column
data |>
  dplyr::mutate(wage_real = deflate_to_real(wage_lcu, survey_date, country_code))
#> # A tibble: 4 × 4
#>   country_code survey_date wage_lcu wage_real
#>   <chr>        <date>         <dbl>     <dbl>
#> 1 MOZ          2019-06-01     15000    17143.
#> 2 MOZ          2020-03-15     18000    19835.
#> 3 BWA          2021-09-01     42000    42432.
#> 4 BWA          2022-11-30     51000    45171.

# Custom base month
data |>
  dplyr::mutate(
    wage_real = deflate_to_real(
      wage_lcu, survey_date, country_code, base_month = "2015-01-01"
    )
  )
#> # A tibble: 4 × 4
#>   country_code survey_date wage_lcu wage_real
#>   <chr>        <date>         <dbl>     <dbl>
#> 1 MOZ          2019-06-01     15000    10286.
#> 2 MOZ          2020-03-15     18000    11901.
#> 3 BWA          2021-09-01     42000    33209.
#> 4 BWA          2022-11-30     51000    35352.
```
