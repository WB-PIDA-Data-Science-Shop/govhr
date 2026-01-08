# Compute index values relative to base year

Computes index values for specified columns where the earliest year
value is set to 100. All subsequent values are expressed as a percentage
of the base year value. This is useful for comparing growth trends
across multiple time series on a common scale.

## Usage

``` r
compute_baseline_index(.data, date_col, ...)
```

## Arguments

- .data:

  A data.frame or tibble containing the time series data.

- date_col:

  Unquoted column name containing the time/year variable.

- ...:

  Unquoted column names to compute indices for. Each selected column
  must be numeric.

## Value

A tibble with the date column and computed index columns. Index column
names are formed by appending "\_index" to the original column names.

## Examples

``` r
if (FALSE) { # \dontrun{
# Compute indices for headcount and labor force
contract_df |>
  compute_baseline_index(year, total_headcount, labor_force_total)
} # }
```
