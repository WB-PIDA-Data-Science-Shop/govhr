# Convert nominal wages to real PPP-adjusted wages (2021 base year)

Convert nominal wages (LCU at survey-year prices) into real wages
expressed in 2021 PPP international dollars using: \$\$Real\_{h}^{PPP} =
(CPI_t / CPI\_{2021}) \* (Nominal\_{h,t} / PPP\_{2021})\$\$

## Usage

``` r
convert_constant_ppp(data, cols)
```

## Arguments

- data:

  Data frame with columns (country_code, year, wage).

- cols:

  A character vector with column name to convert to constant PPP in
  international 2021 dollars.

## Value

\`data_out\` augmented with columns converted to international 2021
dollars.

## Details

\#' @details CPI data is sourced from \[govhr::macro_indicators\], which
must contain columns `country_code`, `year`, and `cpi`.

## Examples

``` r
library(tibble)
data <- tibble(
  country_code = c("BRA","BRA"),
  ref_date = c("2010-01-01", "2021-01-01"),
  wage = c(20000, 25000)
)

convert_constant_ppp(data, "wage")
#> # A tibble: 2 × 4
#>   country_code ref_date     wage   cpi
#>   <chr>        <chr>       <dbl> <dbl>
#> 1 BRA          2010-01-01  4363.  100 
#> 2 BRA          2021-01-01 10205.  187.
```
