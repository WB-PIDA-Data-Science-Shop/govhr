# Pivot Data360 dataset to wide format

This function reshapes a Data360-style dataset from long to wide format.
It spreads indicator values (`OBS_VALUE`) across multiple columns based
on the indicator variable (`INDICATOR`), while keeping the reference
area and time period identifiers. The resulting dataset is renamed and
cleaned to have snake_case variable names.

## Usage

``` r
pivot_data360(data)
```

## Arguments

- data:

  A data frame or tibble containing the variables:

  - `REF_AREA`: Country or region code

  - `TIME_PERIOD`: Year or time reference

  - `INDICATOR`: Indicator code or name

  - `OBS_VALUE`: Observation value for the indicator

## Value

A tibble in wide format with columns:

- `country_code`: The country or region code (from `REF_AREA`)

- `year`: The year or time period (from `TIME_PERIOD`)

- One column per unique `INDICATOR`, containing corresponding values
  from `OBS_VALUE`

## Details

This function is particularly useful for preparing Data360 or similar
datasets for analysis, where multiple indicators are recorded by country
and year. The output dataset is cleaned using
[`janitor::clean_names()`](https://sfirke.github.io/janitor/reference/clean_names.html)
to ensure consistent naming.

## Examples

``` r
library(dplyr)
library(tidyr)

data_long <- tibble(
  REF_AREA = c("USA", "USA", "CAN", "CAN"),
  TIME_PERIOD = c(2020, 2020, 2020, 2020),
  INDICATOR = c("GDP", "POP", "GDP", "POP"),
  OBS_VALUE = c(21000, 330, 1800, 38)
)

data_wide <- pivot_data360(data_long)
print(data_wide)
#> # A tibble: 2 × 4
#>   country_code  year   gdp   pop
#>   <chr>        <dbl> <dbl> <dbl>
#> 1 USA           2020 21000   330
#> 2 CAN           2020  1800    38
```
