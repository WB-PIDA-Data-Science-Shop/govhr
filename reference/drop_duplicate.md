# Drop entities with duplicated records

Drops every record of each entity holding more than one record on the
same `ref_date`, even if those records are otherwise identical, and
warns how many records were removed. Used to keep a single record per
entity and period, e.g. a single group per period in
[`detect_transition()`](https://wb-pida-data-science-shop.github.io/govhr/reference/detect_transition.md).

## Usage

``` r
drop_duplicate(data, ...)

# S3 method for class 'data.frame'
drop_duplicate(data, id_col, ...)

# S3 method for class 'tbl_dbi'
drop_duplicate(data, id_col, ...)
```

## Arguments

- data:

  A data frame or lazy database table (`tbl_dbi`) with `ref_date` and
  the column named in `id_col`.

- ...:

  Arguments passed to methods.

- id_col:

  Character. Column identifying the entity, such as a person or a
  contract.

## Value

`data` without the records of the entities holding several records on a
date. A data.table for data frame input; a lazy table for `tbl_dbi`
input.
