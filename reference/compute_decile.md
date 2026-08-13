# Function to compute deciles of a measure column within groups and reference dates.

Function to compute deciles of a measure column within groups and
reference dates.

## Usage

``` r
compute_decile(.data, group_cols = NULL, measure_col, latest_measure = FALSE)
```

## Arguments

- .data:

  A data frame containing the data to be processed.

- group_cols:

  A character vector of column names to group the data by.

- measure_col:

  The name of the column for which deciles will be computed.

- latest_measure:

  A logical value indicating whether to return only the measures for the
  latest reference date's deciles (default is FALSE).

## Value

A data frame containing the deciles, median values, and mean values for
the specified measure column within the specified groups and reference
dates.
