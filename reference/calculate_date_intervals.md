# Calculate time intervals between reference dates

This function computes the time interval between consecutive values in a
reference date column, optionally within groups.

## Usage

``` r
calculate_date_intervals(data, ref_date, group_vars = NULL)
```

## Arguments

- data:

  A data frame or tibble.

- ref_date:

  Name of the column containing reference dates.

- group_vars:

  Optional grouping variables (e.g., \`id\`, \`country\`, or \`c(id,
  country)\`).

## Value

The original data with an additional set of columns indicating the
difference between consecutive reference dates.

## Examples

``` r
library(tibble)

df <- tibble(id = c(1, 1, 1, 2, 2),
             ref_date = as.Date(c("2020-01-01", "2021-01-01", "2023-01-01",
                                  "2020-06-01", "2020-12-01")))
calculate_date_intervals(df, "ref_date", "id")
#>       id interval_days
#>    <num>         <num>
#> 1:     1            NA
#> 2:     1           366
#> 3:     1           730
#> 4:     2            NA
#> 5:     2           183
```
