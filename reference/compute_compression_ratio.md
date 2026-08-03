# Function to compute the compression ratio

Function to compute the compression ratio

## Usage

``` r
compute_compression_ratio(
  .data,
  group_cols = NULL,
  percentiles = c(0.9, 0.5, 0.1),
  measure_col,
  latest_measure = FALSE
)
```

## Arguments

- .data:

  A data frame.

- group_cols:

  A character vector of column names to group the data by.

- percentiles:

  A numeric vector of length 3 indicating the upper, middle, and lower
  percentiles to compute (default is c(0.9, 0.5, 0.1)).

- measure_col:

  The name of the column for which the compression ratio will be
  computed.

- latest_measure:

  A logical value indicating whether to return only the measures for the
  latest reference date.

## Value

A data frame containing the 90th, 50th, and 10th percentiles for the
specified measure column within the specified groups and reference
dates.
