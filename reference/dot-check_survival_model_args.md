# Check the inputs of fit_survival_model()

Shared by the data.frame and tbl_dbi methods, so the checks cannot drift
apart. Stops with an error if `panel` is not a `survival_panel`, if a
covariate is not one of its columns, if `band_width` is not a single
positive number, or if `...` holds an argument of
[`fixest::fepois()`](https://lrberge.github.io/fixest/reference/feglm.html)
that
[`fit_survival_model()`](https://wb-pida-data-science-shop.github.io/govhr/reference/fit_survival_model.md)
sets itself or that would be wrong on summed cells (`weights`,
`cluster`). Runs before the cells are summed, so a database panel is not
queried for a call that would fail.

## Usage

``` r
.check_survival_model_args(panel, covariate_cols, band_width, dot_names = NULL)
```

## Arguments

- panel:

  The `panel` argument of
  [`fit_survival_model()`](https://wb-pida-data-science-shop.github.io/govhr/reference/fit_survival_model.md).

- covariate_cols:

  Character vector. The covariates to model.

- band_width:

  Number. The width of the tenure bands, in years.

- dot_names:

  Character vector or `NULL`. The names of the arguments in
  [`fit_survival_model()`](https://wb-pida-data-science-shop.github.io/govhr/reference/fit_survival_model.md)'s
  `...`, from [`...names()`](https://rdrr.io/r/base/dots.html).

## Value

`NULL`, invisibly.
