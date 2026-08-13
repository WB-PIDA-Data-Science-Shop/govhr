# Compute coverage of non-missing values in a dataset.

Compute coverage of non-missing values in a dataset.

## Usage

``` r
compute_coverage(
  .data,
  group = NULL,
  include_ref_date = FALSE,
  aggregate = FALSE
)
```

## Arguments

- .data:

  A data frame.

- group:

  A character string specifying the column name to group by. If NULL,
  coverage is computed for the entire data set.

- include_ref_date:

  A logical value indicating whether to include the \`ref_date\` column
  in the grouping.

- aggregate:

  A logical value indicating whether to aggregate coverage values by the
  \`group\`.

## Value

A data frame with coverage values for each column, optionally grouped by
the specified \`group\`.
