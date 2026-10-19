# Warn about records dropped as duplicates

Raises the warning of
[`drop_duplicate()`](https://wb-pida-data-science-shop.github.io/govhr/reference/drop_duplicate.md),
shared by its methods so that both backends word it identically.

## Usage

``` r
warn_duplicate_records(n_duplicates, n_rows, n_ids, id_col)
```

## Arguments

- n_duplicates:

  Number of surplus records, i.e. records beyond the first for each
  entity and `ref_date`.

- n_rows:

  Number of records dropped, all records of the affected entities.

- n_ids:

  Number of entities dropped.

- id_col:

  Character. Column identifying the entity.

## Value

`NULL`, invisibly. Called for its warning.
