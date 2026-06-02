# Compute Missingness for All Variables by All Non-Numeric Group Variables

For a given data.table, identifies non-numeric columns as group
variables and numeric columns as target variables, then computes
`n_missing`, `N`, and `pct_missing` for every target × group-value
combination using a fast double-melt + join approach.

## Usage

``` r
compute_missingness(dt, module = NULL, group_cols = NULL)
```

## Arguments

- dt:

  A data.frame or data.table.

- module:

  Optional character scalar (e.g. `"contract"`) added as a `module`
  column to the result for downstream `rbindlist`.

- group_cols:

  Character vector of column names to use as grouping variables. Glob
  patterns (e.g. `"country_*"`) are resolved against the actual column
  names in `dt`. When `NULL` (the default), missingness is computed for
  each variable across the whole dataset with no grouping, returning one
  row per variable.

## Value

When `group_cols = NULL`: a data.table with columns `target_var`,
`n_missing`, `N`, `pct_missing`. Otherwise: a data.table with columns
`group_var`, `group_val`, `target_var`, `n_missing`, `N`, `pct_missing`,
and (if `module` is supplied) `module`.
