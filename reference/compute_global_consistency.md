# Compute global consistency

Averages record consistency and the value consistency of the columns in
`value_cols` into a single percentage for the whole table.

## Usage

``` r
compute_global_consistency(data, id_col, value_cols, digits = 2)
```

## Arguments

- data:

  Data frame or remote database table (`tbl_dbi`) with `ref_date` and
  the columns named in `id_col` and `group_cols`.

- id_col:

  Character. Column identifying the entity, such as `"personnel_id"`.

- value_cols:

  Character vector of columns whose values should stay the same for each
  identifier.

- digits:

  Whole number. Decimal places to round to. Default `2`.

## Value

A number from 0 to 100.

## Details

The value consistencies of `value_cols` are averaged first, and that
average weighs as much as record consistency. Intermediate results are
not rounded, so rounding errors do not compound.

## See also

[`compute_record_consistency()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_record_consistency.md)
and
[`compute_value_consistency()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_value_consistency.md),
which it combines.

## Examples

``` r
hr <- data.frame(
  personnel_id = c("a", "a", "b"),
  ref_date = as.Date(c("2020-01-01", "2021-01-01", "2020-01-01")),
  birth_date = as.Date(c("1980-01-01", "1981-01-01", "1990-01-01"))
)
compute_global_consistency(hr, "personnel_id", value_cols = "birth_date")
#> [1] 75
```
