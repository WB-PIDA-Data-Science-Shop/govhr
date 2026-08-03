# Guess the Reporting Frequency of the Reference Dates

Evaluates a vector of reference dates and returns a single string
representing the data's reporting interval (e.g., "year", "month"). The
function calculates the median day difference between consecutive dates.

## Usage

``` r
guess_date_frequency(.data)
```

## Arguments

- .data:

  A dataset containing a column named `ref_date` with date values.

## Value

A single character scalar: `"year"`, `"quarter"`, `"month"`, `"week"`,
or `"day"`.

## Examples

``` r
# Monthly reporting dates
data <- data.frame(
 ref_date = seq(as.Date("2020-01-01"), as.Date("2020-12-01"), by = "months")
)

guess_date_frequency(data)
#> [1] "month"
#> [1] "month"
```
