# Tag a panel as a survival_panel

Adds the `survival_panel` class and stores the column arguments the
panel was built with as attributes, so
[`fit_survival_model()`](https://wb-pida-data-science-shop.github.io/govhr/reference/fit_survival_model.md)
needs no column arguments. A data.table is tagged by reference, which a
copying `attr<-` would break.

## Usage

``` r
.new_survival_panel(
  panel,
  tenure_col,
  salary_col,
  covariate_cols,
  personnel_id_col,
  ref_date_col
)
```

## Arguments

- panel:

  The panel, as a data.table or a lazy database table.

- tenure_col, salary_col, covariate_cols, personnel_id_col,
  ref_date_col:

  The column arguments of
  [`build_survival_panel()`](https://wb-pida-data-science-shop.github.io/govhr/reference/build_survival_panel.md).

## Value

`panel`, with class `survival_panel` prepended and one attribute per
column argument.
