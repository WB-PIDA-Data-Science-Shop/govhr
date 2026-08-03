# Function to compute quantiles of a measure column within groups and reference dates.

Function to compute quantiles of a measure column within groups and
reference dates.

## Usage

``` r
compute_quantile(
  .data,
  group_cols = NULL,
  measure_col,
  latest_measure = FALSE,
  n_quantiles = 10
)
```

## Arguments

- .data:

  A data frame containing the data to be processed.

- group_cols:

  A character vector of column names to group the data by.

- measure_col:

  The name of the column for which quantiles will be computed.

- latest_measure:

  A logical value indicating whether to return only the measures for the
  latest reference date's quantiles (default is FALSE).

- n_quantiles:

  The number of quantiles to compute (default is 10 for deciles).

## Value

A data frame containing the quantiles, median values, and mean values
for the specified measure column within the specified groups and
reference dates.
