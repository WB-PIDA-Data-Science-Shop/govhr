# Name the groups of a table in a message

Labels each row of `dt` by its group values, e.g.
`"gender = F, occupation = nurse"`, for warnings that name the groups
affected. Used by
[`compute_service_table()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_service_table.md).

## Usage

``` r
.group_labels(dt, group_cols)
```

## Arguments

- dt:

  A data frame with the `group_cols` columns, one row per group to name.

- group_cols:

  A character vector of group columns, or `NULL`.

## Value

A character vector with one label per row of `dt`, or `"the table"` when
`group_cols` is empty.
