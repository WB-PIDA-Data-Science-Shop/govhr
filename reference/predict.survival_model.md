# Predict exits from a survival model

- **Without `newdata`:** the groups the model was fitted on (one row per
  tenure band, snapshot date and covariate values), with the exits
  expected next to the exits seen, to check how well the model fits.

- **With `newdata`:** for each row, e.g. each person, the hazard of each
  exit type and the chance of retiring, leaving otherwise or staying
  within `horizon` years, e.g. for a simulation.

## Usage

``` r
# S3 method for class 'survival_model'
predict(object, newdata = NULL, horizon = 1, ...)
```

## Arguments

- object:

  A `survival_model` from
  [`fit_survival_model()`](https://wb-pida-data-science-shop.github.io/govhr/reference/fit_survival_model.md).

- newdata:

  `NULL` (the default), or a data frame with the panel's tenure column,
  covariates and, if the model has year effects, snapshot date column. A
  `survival_panel` works; a database table is collected.

- horizon:

  Number. With `newdata`, the years ahead the chances are for, e.g.
  `1 / 12` for a month. Default `1`.

- ...:

  Not used.

## Value

A data.table.

**Without `newdata`:** the snapshot date, `tenure_band` (its lower
bound), the covariates, `exposure` (years at risk) and, for each exit
type modelled, `exit_<type>` (exits seen) and `pred_<type>` (exits
expected).

**With `newdata`:** `newdata` plus `hazard_<type>` (exits per year at
risk) for each exit type modelled and, if both were, `prob_retired`,
`prob_other` and `prob_stay`, which add up to 1.

## Details

**Chances from hazards.** The hazard is constant within a tenure band,
so the chance of leaving within `horizon` is `1 - exp(-h * horizon)`,
with `h` the sum of the two hazards, split between the exit types in
proportion to their hazards. With one exit type not modelled, `h` is
unknown, so no chances are given.

**Levels with no exits.** fixest drops a tenure band or year in which no
one left (its fixed effect is minus infinity) and predicts `NA` there.
The maximum likelihood estimate is 0 exits, so a band or year seen in
the data but dropped gives 0; one never seen, or a covariate level never
seen, gives `NA`.

**No intervals.** fixest gives no standard errors for its fixed effects,
which carry most of a prediction, so none are given.

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

# exits seen and expected in each group
predict(fit)
#>        ref_date tenure_band    gender exposure exit_retired pred_retired
#>          <Date>       <num>    <char>    <num>        <int>        <num>
#>   1: 2007-09-01           0  FEMININO    164.0            0   0.00000000
#>   2: 2007-09-01           0 MASCULINO    140.5            0   0.00000000
#>   3: 2007-09-01           5  FEMININO     91.0            0   0.13610970
#>   4: 2007-09-01           5 MASCULINO     89.0            1   0.09560029
#>   5: 2007-09-01          10  FEMININO     11.0            0   0.04298754
#>  ---                                                                    
#> 161: 2016-09-01          35  FEMININO     17.0            2   2.01833993
#> 162: 2016-09-01          35 MASCULINO     17.0            0   1.44949201
#> 163: 2016-09-01          40  FEMININO      5.0            0   0.00000000
#> 164: 2016-09-01          40 MASCULINO      2.0            0   0.00000000
#> 165: 2016-09-01          45  FEMININO      1.0            0   0.00000000
#>      exit_other  pred_other
#>           <int>       <num>
#>   1:          6 14.33507959
#>   2:         13 10.96501124
#>   3:          2  1.30389943
#>   4:          3  1.13859483
#>   5:          0  0.04492799
#>  ---                       
#> 161:          0  0.60346669
#> 162:          2  0.53880274
#> 163:          0  0.18526510
#> 164:          0  0.06616527
#> 165:          0  0.00000000

# each person's chances of retiring, leaving otherwise or staying over the
# next month
predict(fit, newdata = panel, horizon = 1 / 12)
#>       personnel_id   ref_date  next_date tenure_years exposure exit_type
#>             <char>     <Date>     <Date>        <num>    <num>    <char>
#>    1:    101237413 2013-09-01 2014-09-01    0.2819986      0.5     other
#>    2:    101237413 2015-09-01 2016-09-01    2.2806297      0.5     other
#>    3:  10139748407 2016-09-01 2017-09-01    0.3148528      1.0      none
#>    4:  10142013498 2015-09-01 2016-09-01    0.2600958      1.0      none
#>    5:  10142013498 2016-09-01 2017-09-01    1.2621492      1.0      none
#>   ---                                                                   
#> 9749:    998226521 2008-09-01 2009-09-01    1.8097194      1.0      none
#> 9750:    998226521 2009-09-01 2010-09-01    2.8090349      1.0      none
#> 9751:    998226521 2010-09-01 2011-09-01    3.8083504      1.0      none
#> 9752:    998226521 2011-09-01 2012-09-01    4.8076660      1.0      none
#> 9753:    998226521 2012-09-01 2013-09-01    5.8097194      0.5     other
#>       gross_salary_lcu    gender hazard_retired hazard_other prob_retired
#>                  <num>    <char>          <num>        <num>        <num>
#>    1:           780.81 MASCULINO    0.000000000   0.13046572 0.0000000000
#>    2:           970.69 MASCULINO    0.000000000   0.23428050 0.0000000000
#>    3:          1367.15 MASCULINO    0.000000000   0.08832513 0.0000000000
#>    4:          3137.55  FEMININO    0.000000000   0.26239748 0.0000000000
#>    5:          1071.36  FEMININO    0.000000000   0.09892539 0.0000000000
#>   ---                                                                    
#> 9749:          3739.12  FEMININO    0.000000000   0.05498212 0.0000000000
#> 9750:          4100.98  FEMININO    0.000000000   0.11540880 0.0000000000
#> 9751:          4100.98  FEMININO    0.000000000   0.09953174 0.0000000000
#> 9752:          4388.06  FEMININO    0.000000000   0.10114286 0.0000000000
#> 9753:          4761.04  FEMININO    0.001779933   0.01835657 0.0001482034
#>        prob_other prob_stay
#>             <num>     <num>
#>    1: 0.010813255 0.9891867
#>    2: 0.019334028 0.9806660
#>    3: 0.007333406 0.9926666
#>    4: 0.021629118 0.9783709
#>    5: 0.008209896 0.9917901
#>   ---                      
#> 9749: 0.004571363 0.9954286
#> 9750: 0.009571301 0.9904287
#> 9751: 0.008260009 0.9917400
#> 9752: 0.008393150 0.9916068
#> 9753: 0.001528431 0.9983234
```
