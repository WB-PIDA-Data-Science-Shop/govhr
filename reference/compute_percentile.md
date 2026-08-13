# Function to compute the percentile values

Function to compute the percentile values

## Usage

``` r
compute_percentile(
  .data,
  group_col = NULL,
  measure_col,
  binwidth = 1,
  latest_measure = FALSE
)
```

## Arguments

- .data:

  A data frame.

- group_col:

  A character vector of column names to group the data by.

- measure_col:

  The name of the column for which the percentile values will be
  computed.

- binwidth:

  The width of the bins for grouping the measure values (default is 1).

- latest_measure:

  A logical value indicating whether to return only the measures for the
  latest reference date.

## Value

A data frame containing the 90th, 50th, and 10th percentiles for the
specified measure column within the specified groups and reference
dates.
