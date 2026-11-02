# Fit a survival (hazard) model of leaving the service

Estimates how covariates such as gender or occupation change the chance
of leaving the service in a given year, for people of the same tenure in
the same year, separately for retiring and for leaving otherwise.

The effects are hazard ratios (see
[`tidy.survival_model()`](https://wb-pida-data-science-shop.github.io/govhr/reference/tidy.survival_model.md)):
`0.8` for women means a woman is 20% less likely to leave in a given
year than a comparable man.

## Usage

``` r
fit_survival_model(panel, ...)

# S3 method for class 'data.frame'
fit_survival_model(
  panel,
  covariate_cols = attr(panel, "covariate_cols"),
  exit_types = c("retired", "other"),
  band_width = 1,
  period_effects = TRUE,
  make_tidy_output = FALSE,
  ...
)

# S3 method for class 'tbl_dbi'
fit_survival_model(
  panel,
  covariate_cols = attr(panel, "covariate_cols"),
  exit_types = c("retired", "other"),
  band_width = 1,
  period_effects = TRUE,
  make_tidy_output = FALSE,
  ...
)

# Default S3 method
fit_survival_model(panel, ...)
```

## Arguments

- panel:

  A `survival_panel` from
  [`build_survival_panel()`](https://wb-pida-data-science-shop.github.io/govhr/reference/build_survival_panel.md),
  in memory or in a database.

- ...:

  Passed to
  [`fixest::fepois()`](https://lrberge.github.io/fixest/reference/feglm.html),
  e.g. `nthreads`, or `notes = TRUE` to see fixest's own notes (off by
  default). Not `fml`, `data`, `offset`, `vcov`, `ssc`, `weights` or
  `cluster` (see Details).

- covariate_cols:

  Character vector. The covariates to model. Defaults to those the panel
  was built with; `character(0)` for tenure (and year) effects only.

  - A character column becomes categories, compared with its first value
    in alphabetical order. To compare with another, make it a factor
    with that level first.

  - A numeric column enters linearly, per unit: for pay, that is per
    unit of currency. Cut it into bands first (e.g. pay quintiles): the
    hazard ratios are easier to read, and people stay added up into few
    groups (a column with a value per person makes a group per person).

- exit_types:

  Any of `"retired"` and `"other"` (both by default). An exit type no
  one had is left out, with a warning.

- band_width:

  Number. The width in years of the tenure bands within which the chance
  of leaving is taken as constant. Default `1`.

- period_effects:

  Logical. If `TRUE` (the default), each calendar year gets its own
  level of exits, absorbing shocks that hit everyone in a year.

- make_tidy_output:

  Logical. If `TRUE`, return the hazard ratio table from
  [`tidy.survival_model()`](https://wb-pida-data-science-shop.github.io/govhr/reference/tidy.survival_model.md)
  instead of the model. Default `FALSE`.

## Value

A `survival_model`, for
[`tidy.survival_model()`](https://wb-pida-data-science-shop.github.io/govhr/reference/tidy.survival_model.md)
and
[`predict.survival_model()`](https://wb-pida-data-science-shop.github.io/govhr/reference/predict.survival_model.md);
fixest's own functions
([`summary()`](https://rdrr.io/r/base/summary.html),
[`coef()`](https://rdrr.io/r/stats/coef.html),
[`fixest::fixef()`](https://rdrr.io/pkg/nlme/man/fixed.effects.html),
[`fixest::etable()`](https://lrberge.github.io/fixest/reference/etable.html))
work on it too. With `make_tidy_output = TRUE`, the hazard ratio table
instead.

## Details

**Model.** A piecewise-constant proportional hazards model, fitted as a
Poisson regression of exits
([`fixest::fepois()`](https://lrberge.github.io/fixest/reference/feglm.html))
with a `log(exposure)` offset and fixed effects for tenure band (the
baseline hazard) and, with `period_effects`, calendar year. One model
per exit type gives cause-specific hazards. The result is fixest's
output (a `fixest_multi`, or a `fixest` for one exit type) with class
`survival_model` added.

**Groups, not people.** The panel is first added up into groups of
people with the same tenure band, snapshot date and covariate values (in
the database, for a database panel). Exit counts and years at risk are
sufficient statistics for a Poisson model, so the estimates and standard
errors equal those on the person-level panel; fixest's number of
observations is the number of groups.

**Missing values.** A person-interval with no tenure or a missing
covariate cannot be modelled: it is left out, with a warning that counts
them.

**Standard errors** are the model's own (`vcov = "iid"`), with no
small-sample adjustment, which would depend on the number of groups. As
`fml`, `data`, `offset`, `vcov` and `ssc` are set here, and `weights` or
`cluster` would be wrong on grouped data, `...` cannot pass them.

**Tenure and year.** Within a person, tenure and year rise together, so
with both sets of fixed effects the hire cohort is implied: the model
assumes the shape of the hazard over tenure is the same for every
cohort.

## See also

[`build_survival_panel()`](https://wb-pida-data-science-shop.github.io/govhr/reference/build_survival_panel.md)
for the panel,
[`tidy.survival_model()`](https://wb-pida-data-science-shop.github.io/govhr/reference/tidy.survival_model.md)
for the hazard ratios,
[`predict.survival_model()`](https://wb-pida-data-science-shop.github.io/govhr/reference/predict.survival_model.md)
for predictions.

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
summary(fit)
#>                               x.1              x.2
#> Dependent Var.:      exit_retired       exit_other
#>                                                   
#> genderMASCULINO -0.3311* (0.1298) -0.1133 (0.1127)
#> Fixed-Effects:  ----------------- ----------------
#> .band                         Yes              Yes
#> .year                         Yes              Yes
#> _______________ _________________ ________________
#> S.E. type                     IID              IID
#> Observations                  137              164
#> Squared Cor.              0.79424          0.82637
#> Pseudo R2                 0.53249          0.62053
#> BIC                        421.75           487.41
#> ---
#> Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

# hazard ratios
broom::tidy(fit)
#> # A tibble: 2 × 10
#>   exit_type term   covariate level estimate std.error statistic p.value conf.low
#>   <chr>     <chr>  <chr>     <chr>    <dbl>     <dbl>     <dbl>   <dbl>    <dbl>
#> 1 retired   gende… gender    MASC…    0.718     0.130     -2.55  0.0107    0.557
#> 2 other     gende… gender    MASC…    0.893     0.113     -1.01  0.315     0.716
#> # ℹ 1 more variable: conf.high <dbl>
```
