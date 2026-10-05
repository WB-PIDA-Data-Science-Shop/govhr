# Compute standard wagebill indicators

Produces a standard set of wagebill indicators in one call: how much
government spends on pay, where that spending goes, how average pay
evolves, what pay is made of, and how pay is distributed. Each indicator
comes from an existing govhr function, so the results match what those
functions return on their own.

## Usage

``` r
compute_wagebill_analytics(
  contracts,
  personnel,
  establishment,
  binwidth = NULL,
  measure_col = "gross_salary_lcu",
  wage_component_cols = c("base_salary_lcu", "allowance_lcu"),
  base_month = "2021-12-01"
)
```

## Arguments

- contracts:

  Data frame or remote database table (`tbl_dbi`) with the contract
  data, one row per contract and reference date. Must contain
  `personnel_id`, `ref_date`, `est_id`, and the columns named in
  `measure_col` and `wage_component_cols`, with pay in nominal local
  currency.

- personnel:

  Data frame or remote database table (`tbl_dbi`) with the personnel
  data. Must contain `personnel_id`, `ref_date` and `employment_status`
  (with `"active"` marking people currently employed). For database
  input, it must live in the same database as `contracts`.

- establishment:

  Data frame or remote database table (`tbl_dbi`) with the establishment
  data. Must contain `est_id` and `country_code`, used to pick the
  consumer price index for each contract. For database input, it must
  live in the same database as `contracts`.

- binwidth:

  Positive whole number. Width of the pay bins used for the wage
  distribution, in the same currency as `measure_col` (for example `1e6`
  for wages in the millions). Default `NULL` picks a width from the
  data, as described in
  [`compute_percentile()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_percentile.md).

- measure_col:

  Character. Pay column used for totals, averages and the distribution.
  Default `"gross_salary_lcu"`.

- wage_component_cols:

  Character vector of pay columns that add up to total pay, used for the
  composition of the wagebill. Default
  `c("base_salary_lcu", "allowance_lcu")`.

- base_month:

  The month whose prices pay is expressed in, given as its first day
  (for example `"2021-12-01"`). Passed to
  [`deflate_to_real()`](https://wb-pida-data-science-shop.github.io/govhr/reference/deflate_to_real.md).
  Default `"2021-12-01"`.

## Value

A named list of tables:

- wagebill:

  Wagebill and its growth for each `ref_date`, from
  [`compute_wagebill()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_wagebill.md).

- wagebill_by_est:

  Wagebill, share of the total and growth for each establishment and
  `ref_date`, from
  [`compute_wagebill()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_wagebill.md).

- wage:

  Average wage and its growth for each `ref_date`, from
  [`compute_wage()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_wage.md).

- wage_by_est:

  Average wage and its growth for each establishment and `ref_date`,
  from
  [`compute_wage()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_wage.md).

- composition:

  Wagebill, share and growth of each pay component (`component`) for
  each `ref_date`, from
  [`compute_wagebill()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_wagebill.md).

- distribution:

  Share of contracts in each pay bin, from
  [`compute_percentile()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_percentile.md).

Each table has the class its function returns for `contracts`:
data.tables for data frame input, lazy tables for `tbl_dbi` input (use
[`dplyr::collect()`](https://dplyr.tidyverse.org/reference/compute.html)
to bring them into memory).

## Details

Only the pay of active personnel is counted: each contract is matched to
`personnel` by `personnel_id` and `ref_date`, and kept only if
`employment_status` is `"active"` on that date. Contracts with no
matching personnel record are left out.

All pay is in real terms, so it can be compared across years: the
columns in `measure_col` and `wage_component_cols` are converted to
constant prices of `base_month` with
[`deflate_to_real()`](https://wb-pida-data-science-shop.github.io/govhr/reference/deflate_to_real.md),
using the country of each contract's establishment. Column names are
kept as they are. Contracts in an establishment missing from
`establishment` have no country, so their pay becomes `NA`, with a
warning.

Each indicator function picks the method for the class of the data, so a
database table is processed in the database. Only the distinct countries
and reference dates are brought into memory, to look up their price
index.

In `composition`, each component's share is of the sum of
`wage_component_cols`, so the shares add up to 1 within each `ref_date`.

The `distribution` pools contracts from all reference dates. Filter
`data` to one date first to see a single year.

## Examples

``` r
contracts <- data.frame(
  personnel_id = c(1, 2, 3, 1, 2, 3),
  ref_date = as.Date(rep(c("2020-01-01", "2021-01-01"), each = 3)),
  est_id = c("A", "A", "B", "A", "B", "B"),
  base_salary_lcu = c(800, 900, 1000, 850, 950, 1100),
  allowance_lcu = c(200, 100, 300, 250, 150, 200)
)
contracts$gross_salary_lcu <- contracts$base_salary_lcu + contracts$allowance_lcu

personnel <- data.frame(
  personnel_id = c(1, 2, 3, 1, 2, 3),
  ref_date = as.Date(rep(c("2020-01-01", "2021-01-01"), each = 3)),
  employment_status = c("active", "active", "active", "active", "active", "pensioner")
)

establishment <- data.frame(est_id = c("A", "B"), country_code = "BRA")

compute_wagebill_analytics(contracts, personnel, establishment)
#> $wagebill
#>      ref_date wagebill wagebill_growth
#>        <Date>    <num>           <num>
#> 1: 2020-01-01 3788.134              NA
#> 2: 2021-01-01 2415.304      -0.3624027
#> 
#> $wagebill_by_est
#>    est_id   ref_date wagebill share_wagebill wagebill_growth
#>    <char>     <Date>    <num>          <num>           <num>
#> 1:      A 2020-01-01 2295.839      0.6060606              NA
#> 2:      A 2021-01-01 1207.652      0.5000000      -0.4739822
#> 3:      B 2020-01-01 1492.295      0.3939394              NA
#> 4:      B 2021-01-01 1207.652      0.5000000      -0.1907418
#> 
#> $wage
#>      ref_date     wage wage_growth
#>        <Date>    <num>       <num>
#> 1: 2020-01-01 1262.711          NA
#> 2: 2021-01-01 1207.652 -0.04360399
#> 
#> $wage_by_est
#>    est_id   ref_date     wage wage_growth
#>    <char>     <Date>    <num>       <num>
#> 1:      A 2020-01-01 1147.919          NA
#> 2:      A 2021-01-01 1207.652  0.05203561
#> 3:      B 2020-01-01 1492.295          NA
#> 4:      B 2021-01-01 1207.652 -0.19074184
#> 
#> $composition
#>      ref_date       component  wagebill share_wagebill wagebill_growth
#>        <Date>          <char>     <num>          <num>           <num>
#> 1: 2020-01-01 base_salary_lcu 3099.3822      0.8181818              NA
#> 2: 2021-01-01 base_salary_lcu 1976.1578      0.8181818      -0.3624027
#> 3: 2020-01-01   allowance_lcu  688.7516      0.1818182              NA
#> 4: 2021-01-01   allowance_lcu  439.1462      0.1818182      -0.3624027
#> 
#> $distribution
#> Key: <bin>
#>       bin count   pct cum_pct
#>     <num> <int> <num>   <num>
#>  1:  1140     2   0.4     0.4
#>  2:  1160     0   0.0     0.4
#>  3:  1180     0   0.0     0.4
#>  4:  1200     2   0.4     0.8
#>  5:  1220     0   0.0     0.8
#>  6:  1240     0   0.0     0.8
#>  7:  1260     0   0.0     0.8
#>  8:  1280     0   0.0     0.8
#>  9:  1300     0   0.0     0.8
#> 10:  1320     0   0.0     0.8
#> 11:  1340     0   0.0     0.8
#> 12:  1360     0   0.0     0.8
#> 13:  1380     0   0.0     0.8
#> 14:  1400     0   0.0     0.8
#> 15:  1420     0   0.0     0.8
#> 16:  1440     0   0.0     0.8
#> 17:  1460     0   0.0     0.8
#> 18:  1480     1   0.2     1.0
#> 
```
