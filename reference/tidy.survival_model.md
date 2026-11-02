# Tidy a survival model into a table of hazard ratios

One row per exit type and covariate, with its hazard ratio, test and
confidence interval. Call it as `broom::tidy(fit)`.

## Usage

``` r
# S3 method for class 'survival_model'
tidy(x, conf.level = 0.95, ...)
```

## Arguments

- x:

  A `survival_model` from
  [`fit_survival_model()`](https://wb-pida-data-science-shop.github.io/govhr/reference/fit_survival_model.md).

- conf.level:

  Number. The confidence level. Default `0.95`.

- ...:

  Not used.

## Value

A tibble with one row per exit type and term, and none if the model has
no covariates:

- exit_type:

  `"retired"` or `"other"`.

- term:

  The covariate as fixest names it: a category's column and level (e.g.
  `genderM`), or a numeric column's name.

- covariate, level:

  The term split in two: the column (`gender`) and the category compared
  with the reference (`M`). `level` is `NA` for a numeric covariate.

- estimate:

  The hazard ratio: e.g. `0.8` is a 20% lower chance of leaving in a
  given year than the reference category (or per unit of a numeric
  covariate).

- std.error, statistic, p.value:

  On the log scale (see Details).

- conf.low, conf.high:

  The confidence interval of the hazard ratio.

## Details

`estimate`, `conf.low` and `conf.high` are
[`exp()`](https://rdrr.io/r/base/Log.html) of the coefficient and its
Wald interval; `std.error`, `statistic` (z) and `p.value` are for the
log coefficient, as
[`broom::tidy()`](https://generics.r-lib.org/reference/tidy.html) gives
them for
[`survival::coxph()`](https://rdrr.io/pkg/survival/man/coxph.html). The
tenure band and year fixed effects (the baseline hazard) are left out:
see
[`fixest::fixef()`](https://rdrr.io/pkg/nlme/man/fixed.effects.html).

## See also

[`fit_survival_model()`](https://wb-pida-data-science-shop.github.io/govhr/reference/fit_survival_model.md)
for the model.

## Examples

``` r
library(data.table)
contracts <- as.data.table(bra_hrmis_contract)
personnel <- as.data.table(bra_hrmis_personnel)
tenure <- compute_tenure_panel(contracts)
personnel <- merge(personnel, tenure, by = c("personnel_id", "ref_date"), all.x = TRUE)

panel <- build_survival_panel(
  personnel, contracts,
  tenure_col = "tenure_years", salary_col = "gross_salary_lcu",
  status_col = "employment_status", covariate_cols = "gender"
)
fit <- fit_survival_model(panel, band_width = 5)
#> Warning: 54 person-intervals have a missing value in `tenure_years` or `gender` and are left out of the model.
broom::tidy(fit)
#> # A tibble: 2 × 10
#>   exit_type term   covariate level estimate std.error statistic p.value conf.low
#>   <chr>     <chr>  <chr>     <chr>    <dbl>     <dbl>     <dbl>   <dbl>    <dbl>
#> 1 retired   gende… gender    MASC…    0.718     0.130     -2.55  0.0107    0.557
#> 2 other     gende… gender    MASC…    0.893     0.113     -1.01  0.315     0.716
#> # ℹ 1 more variable: conf.high <dbl>
```
