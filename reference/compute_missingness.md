# Compute Missingness Counts and Percentages

Computes the number and percentage of missing values for each variable
in a dataset. The function supports both overall missingness (when
`by = NULL`) and grouped missingness (when grouping variables are
supplied through the `by` argument).

## Usage

``` r
compute_missingness(data, by = NULL)
```

## Arguments

- data:

  A data.frame or data.table containing the dataset to analyze.

- by:

  Optional. A character vector of column names specifying grouping
  variables. If `NULL`, missingness is computed for the full dataset.

## Value

A data.table in long format with columns:

- `by`:

  (if provided) Grouping variables.

- `variable`:

  The variable name.

- `n_missing`:

  Number of missing values.

- `pct_missing`:

  Percentage of missingness within group or overall.

## Details

When `by = NULL`, the function returns one row per variable with the
total number of missing values and the percent missing out of all rows.
When `by` is provided, missingness is computed within each group, and
the percent missing is calculated relative to the group size.

## Examples

``` r
if (FALSE) { # \dontrun{
compute_missingness(df)                # overall missingness
compute_missingness(df, by = "contract_type_code") # missingness by contract type
} # }
```
