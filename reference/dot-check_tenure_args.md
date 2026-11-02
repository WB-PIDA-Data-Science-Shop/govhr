# Check the inputs of the tenure functions

Shared by every method of
[`compute_tenure()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_tenure.md),
[`compute_tenure_panel()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_tenure_panel.md)
and
[`compute_employment_spells()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_employment_spells.md).
Uses
[`check_required_cols()`](https://wb-pida-data-science-shop.github.io/govhr/reference/check_required_cols.md),
which also lists a lazy database table's columns.

## Usage

``` r
.check_tenure_args(contracts, cols)
```

## Arguments

- contracts:

  The contract table.

- cols:

  Character vector. The columns the function needs.

## Value

`contracts`, invisibly. Stops with an error naming any missing column.
