# Convert nominal wages to real PPP-adjusted wages (2021 base year)

Convert nominal wages (LCU at survey-year prices) into real wages
expressed in 2021 PPP international dollars using: \$\$Real\_{h}^{PPP} =
(CPI_t / CPI\_{2021}) \* (Nominal\_{h,t} / PPP\_{2021})\$\$

## Usage

``` r
convert_constant_ppp(data, cols, macro_indicators)
```

## Arguments

- data:

  Data frame with columns (country_code, year, wage).

- cols:

  A character vector with column name to convert to constant PPP in
  international 2021 dollars.

- macro_indicators:

  Macroeconomic indicators, can be lazy loaded.

## Value

\`data_out\` augmented with columns converted to international 2021
dollars.

## Details

Assumes - \`data\` has columns: country_code, year, wage - \`cpi\` has
columns: country_code, year, cpi - \`ppp\` has columns: country_code,
ppp (ppp = LCU per 2021 Intl\$)

## Examples

``` r
library(tibble)
hh <- tibble(
  country_code = c("A","A"),
  year = c("2010", "2021"),
  wage = c(20000, 25000)
)

macro_indicators <- tibble(
  country_code = "A", year = "2010", "2021",
  cpi = c(85, 100), ppp = c(1.5, 3.5)
)

convert_constant_ppp(hh, "wage", macro_indicators)
#> # A tibble: 3 × 6
#>   country_code year   wage `"2021"`   cpi   ppp
#>   <chr>        <chr> <dbl> <chr>    <dbl> <dbl>
#> 1 A            2010     NA 2021        85   1.5
#> 2 A            2010     NA 2021       100   3.5
#> 3 A            2021     NA NA          NA  NA  
```
