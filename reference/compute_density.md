# Function to compute the distribution function of a variable.

Function to compute the distribution function of a variable.

## Usage

``` r
compute_density(
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

A data frame with the distribution function, where \`pct\` denotes the
percentage of observations in each bin and \`cum_pct\` denotes the
cumulative percentage.
