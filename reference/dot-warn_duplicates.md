# Warn about duplicate person-snapshot rows in a personnel panel

Shared by both methods of
[`estimate_decrement_rates()`](https://wb-pida-data-science-shop.github.io/govhr/reference/estimate_decrement_rates.md)
and
[`build_survival_panel()`](https://wb-pida-data-science-shop.github.io/govhr/reference/build_survival_panel.md),
which all keep the same row, so the message is the same everywhere.

## Usage

``` r
.warn_duplicates(n_dup, personnel_id_col, ref_date_col)
```

## Arguments

- n_dup:

  Number. How many rows are duplicates.

- personnel_id_col, ref_date_col:

  Character. The person and snapshot date columns, named in the message.

## Value

The warning message, invisibly (called for its warning).
