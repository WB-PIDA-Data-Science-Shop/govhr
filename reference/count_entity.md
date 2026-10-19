# Count unique entities by group

Counts how many distinct entities, such as people or contracts, are in
each group. Rows with a missing identifier are not counted.

## Usage

``` r
count_entity(data, ...)

# S3 method for class 'data.frame'
count_entity(data, id_col, group_cols = NULL, ...)

# S3 method for class 'tbl_dbi'
count_entity(data, id_col, group_cols = NULL, ...)
```

## Arguments

- data:

  Data frame or remote database table (`tbl_dbi`) containing `id_col`
  and `group_cols`.

- ...:

  Arguments passed to methods.

- id_col:

  Character. Column name of the unique identifier for the entity.

- group_cols:

  Character vector of column names to group by, or `NULL` for no
  grouping.

## Value

A table with the grouping columns and a `count` column representing the
number of unique entities in each group. A data.table sorted by the
grouping columns for data frame input; a lazy table for `tbl_dbi` input
(use
[`dplyr::collect()`](https://dplyr.tidyverse.org/reference/compute.html)
to bring it into memory).

## Examples

``` r
hr <- data.frame(
  personnel_id = c(1, 1, 2, NA),
  est_id = c("A", "A", "B", "B")
)
count_entity(hr, id_col = "personnel_id", group_cols = "est_id")
#> Key: <est_id>
#>    est_id count
#>    <char> <int>
#> 1:      A     1
#> 2:      B     1
```
