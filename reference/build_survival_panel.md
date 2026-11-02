# Build a person-interval panel for survival (hazard) models

Turns HRMIS snapshots into the table a model of exits is fitted on: one
row per person and interval between two snapshots in which they could
leave, with how long they were at risk (`exposure`), whether and how
they left by the next snapshot (`exit_type`), and their covariates (and
pay, if asked for) at the start of the interval.

## Usage

``` r
build_survival_panel(personnel, ...)

# S3 method for class 'data.frame'
build_survival_panel(
  personnel,
  contracts = NULL,
  tenure_col,
  salary_col = NULL,
  status_col = "employment_status",
  covariate_cols = NULL,
  personnel_id_col = "personnel_id",
  ref_date_col = "ref_date",
  contract_id_col = "contract_id",
  select_contract = c("highest_paid", "lowest_paid"),
  ...
)

# S3 method for class 'tbl_dbi'
build_survival_panel(
  personnel,
  contracts = NULL,
  tenure_col,
  salary_col = NULL,
  status_col = "employment_status",
  covariate_cols = NULL,
  personnel_id_col = "personnel_id",
  ref_date_col = "ref_date",
  contract_id_col = "contract_id",
  select_contract = c("highest_paid", "lowest_paid"),
  ...
)

# Default S3 method
build_survival_panel(personnel, ...)
```

## Arguments

- personnel:

  Personnel snapshots: one row per person and `ref_date`, as a data
  frame or a lazy database table (`tbl_dbi`).

- ...:

  Not used.

- contracts:

  Contract snapshots (one row per contract and `ref_date`, of the same
  kind as `personnel`), or `NULL` (the default) to build the panel from
  `personnel` alone. Needed for pay and for contract covariates such as
  occupation; give `salary_col` with it.

- tenure_col:

  Character. The `personnel` column with years of service, e.g. from
  [`compute_tenure_panel()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_tenure_panel.md).
  It must count from hiring, not from the first snapshot.

- salary_col:

  Character or `NULL`. The `contracts` pay column, summed across a
  person's contracts and carried into the panel. Deflate it first
  ([`deflate_to_real()`](https://wb-pida-data-science-shop.github.io/govhr/reference/deflate_to_real.md))
  to compare years. To model pay, cut it into bands (e.g. quintiles) and
  name the band column in
  [`fit_survival_model()`](https://wb-pida-data-science-shop.github.io/govhr/reference/fit_survival_model.md)'s
  `covariate_cols` (see there). Required with `contracts`.

- status_col:

  Character or `NULL`. The `personnel` status column, default
  `"employment_status"`: `"active"` can leave, `"pensioner"` has
  retired. `NULL`, for data with no status, treats everyone on the
  payroll as active, so every exit is `"other"`.

- covariate_cols:

  Character vector or `NULL`. Columns to carry into the panel, from
  `personnel` (e.g. gender) or `contracts` (e.g. occupation, from the
  contract chosen by `select_contract`).

- personnel_id_col, ref_date_col, contract_id_col:

  Character. The person, snapshot date and contract id columns.

- select_contract:

  `"highest_paid"` (the default) or `"lowest_paid"`: which contract the
  contract covariates come from when a person has several. Ties go to
  the lowest contract id.

## Value

A `survival_panel` for
[`fit_survival_model()`](https://wb-pida-data-science-shop.github.io/govhr/reference/fit_survival_model.md):
a data.table (a lazy table for a `tbl_dbi`) with one row per person and
interval:

- personnel_id_col, ref_date_col:

  The person and the start of the interval.

- next_date:

  The next snapshot, where the interval ends.

- tenure_col:

  Years of service at the start (`NA` kept).

- exposure:

  Years at risk: the interval's length, or half of it for someone who
  left.

- exit_type:

  At the next snapshot: `"none"` (still active), `"retired"` (a
  pensioner) or `"other"` (gone, or any other status).

- salary_col:

  With `contracts`: total pay at the start; `NA` with no contract.

- covariate_cols:

  As at the start of the interval.

It remembers the column arguments, so
[`fit_survival_model()`](https://wb-pida-data-science-shop.github.io/govhr/reference/fit_survival_model.md)
needs none.

## Details

**Model.** A Poisson regression of exits with a `log(exposure)` offset
on this panel is a piecewise-constant proportional hazards model;
[`fit_survival_model()`](https://wb-pida-data-science-shop.github.io/govhr/reference/fit_survival_model.md)
fits one per exit type (cause-specific hazards).

**Two exit types, from fixed statuses.** Only `"active"` and
`"pensioner"` are read from `status_col`: an active person who is a
pensioner at the next snapshot retired, and one who is gone or has any
other status (e.g. `"deceased"`, `"transferred"`) left otherwise. Recode
your statuses to these two first if they differ.

**Risk set and censoring.** Everyone active at a snapshot that has a
next one; pensioners are not at risk. The last snapshot is
right-censored: it adds no rows, and someone still in service then never
counts as a leaver.

**Left truncation.** Someone in service when the panel starts enters at
the tenure first seen and adds nothing to earlier tenures, which is
right as long as `tenure_col` counts from hiring.

**Exits and returns.** Absence at the next snapshot is an exit, counted
as half the interval at risk; someone who reappears is at risk again
from there.

**Intervals.** An interval runs to the next snapshot in the data, so
monthly or irregular snapshots work: exposure is always in years
(January 2020 is 31/366), and a snapshot missing for everyone makes the
interval longer rather than counting as exits.

**Duplicates.** A person seen twice at one snapshot is kept once, with a
warning: the row first by status, then with the lowest tenure (missing
values last). Rows that tie on both may differ in which one each backend
keeps.

## See also

[`fit_survival_model()`](https://wb-pida-data-science-shop.github.io/govhr/reference/fit_survival_model.md)
to model the exits;
[`compute_service_table()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_service_table.md)
for expected years of service by tenure without covariates.

## Examples

``` r
library(data.table)
#> 
#> Attaching package: ‘data.table’
#> The following object is masked from ‘package:base’:
#> 
#>     %notin%
contracts <- as.data.table(bra_hrmis_contract)
personnel <- as.data.table(bra_hrmis_personnel)
tenure <- compute_tenure_panel(contracts)
personnel <- merge(personnel, tenure, by = c("personnel_id", "ref_date"), all.x = TRUE)

# from personnel alone, with gender
panel <- build_survival_panel(
  personnel, tenure_col = "tenure_years", covariate_cols = "gender"
)
panel[, .N, by = exit_type]
#>    exit_type     N
#>       <char> <int>
#> 1:     other   330
#> 2:      none  9173
#> 3:   retired   250

# with real pay and the occupation of each person's highest-paid contract
contracts[, gross_salary_real := deflate_to_real(gross_salary_lcu, ref_date, "BRA")]
#>        contract_id personnel_id
#>             <char>       <char>
#>     1:      144216  17795117449
#>     2:      144216  17795117449
#>     3:      136329   7650148408
#>     4:      136329   7650148408
#>     5:      136194   2282669479
#>    ---                         
#> 14769:       13129   6046088453
#> 14770:       13129   6046088453
#> 14771:      127978   6145203471
#> 14772:        8967  14006251491
#> 14773:       19683  13369091453
#>                                                             est_id   ref_date
#>                                                             <char>     <Date>
#>     1:                    PROCURADORIA JUNTO AO TRIBUNAL DE CONTAS 2012-09-01
#>     2:                    PROCURADORIA JUNTO AO TRIBUNAL DE CONTAS 2011-09-01
#>     3: AGENCIA DE DEFESA E INSPECAO AGROPECUARIA ESTADO DE ALAGOAS 2009-09-01
#>     4: AGENCIA DE DEFESA E INSPECAO AGROPECUARIA ESTADO DE ALAGOAS 2011-09-01
#>     5: AGENCIA DE DEFESA E INSPECAO AGROPECUARIA ESTADO DE ALAGOAS 2009-09-01
#>    ---                                                                       
#> 14769:                                         ALAGOAS PREVIDENCIA 2012-09-01
#> 14770:                                         ALAGOAS PREVIDENCIA 2016-09-01
#> 14771:                                         ALAGOAS PREVIDENCIA 2011-09-01
#> 14772:                                         ALAGOAS PREVIDENCIA 2016-09-01
#> 14773:                                         ALAGOAS PREVIDENCIA 2017-09-01
#>        base_salary_lcu allowance_lcu gross_salary_lcu net_salary_lcu whours
#>                  <num>         <num>            <num>          <num>  <num>
#>     1:            0.00             0           275.00         275.00     30
#>     2:            0.00             0           275.00         275.00     30
#>     3:          610.42             0           610.42         610.42     40
#>     4:          653.15             0           653.15         653.15     40
#>     5:          610.42             0           610.42         610.42     40
#>    ---                                                                     
#> 14769:              NA            NA           622.00         622.00      0
#> 14770:              NA            NA           880.00         880.00      0
#> 14771:              NA            NA           591.18         591.18      0
#> 14772:              NA            NA           880.00         880.00      0
#> 14773:              NA            NA          1042.71        1042.71      0
#>        start_date   end_date paygrade seniority      occupation_native
#>            <Date>     <Date>   <char>    <char>                 <char>
#>     1: 2011-07-11       <NA>     <NA>       999    .g funcao confianca
#>     2: 2011-07-11       <NA>     <NA>       999    .g funcao confianca
#>     3: 2008-06-10       <NA>     <NA>    ADMAAA adjunto administrativo
#>     4: 2008-06-10       <NA>     <NA>    ADMAAA adjunto administrativo
#>     5: 2008-05-09       <NA>     <NA>    ADMAAA adjunto administrativo
#>    ---                                                                
#> 14769: 1985-05-08 2011-02-01     <NA>   ACENB40                   <NA>
#> 14770: 1985-05-08 2011-02-01     <NA>   ACENB40                   <NA>
#> 14771: 1975-02-18       <NA>     <NA>   ACEND40                   <NA>
#> 14772: 1982-03-24       <NA>     <NA>   ACENC40                   <NA>
#> 14773: 1985-07-02 2015-10-13     <NA>   AEF30C2                   <NA>
#>           occupation_english occupation_iscocode
#>                       <char>              <char>
#>     1:     .g trust function                2412
#>     2:     .g trust function                2412
#>     3: administrative deputy                3341
#>     4: administrative deputy                3341
#>     5: administrative deputy                3341
#>    ---                                          
#> 14769:                  <NA>                <NA>
#> 14770:                  <NA>                <NA>
#> 14771:                  <NA>                <NA>
#> 14772:                  <NA>                <NA>
#> 14773:                  <NA>                <NA>
#>                      occupation_isconame        contract_type_native
#>                                   <char>                      <char>
#>     1: Financial and Investment Advisers EXCLUSIVAMENTE COMISSIONADO
#>     2: Financial and Investment Advisers EXCLUSIVAMENTE COMISSIONADO
#>     3:                Office Supervisors                     EFETIVO
#>     4:                Office Supervisors                     EFETIVO
#>     5:                Office Supervisors                     EFETIVO
#>    ---                                                              
#> 14769:                              <NA>                     INATIVO
#> 14770:                              <NA>                     INATIVO
#> 14771:                              <NA>                 PENSIONISTA
#> 14772:                              <NA>                     INATIVO
#> 14773:                              <NA>                     INATIVO
#>        contract_type gross_salary_real
#>               <char>             <num>
#>     1:    fixed-term          476.4956
#>     2:    fixed-term          501.6651
#>     3:     permanent         1251.1747
#>     4:     permanent         1191.5001
#>     5:     permanent         1251.1747
#>    ---                                
#> 14769:          <NA>         1077.7464
#> 14770:          <NA>         1136.0829
#> 14771:          <NA>         1078.4522
#> 14772:          <NA>         1136.0829
#> 14773:          <NA>         1312.8266
panel <- build_survival_panel(
  personnel, contracts,
  tenure_col = "tenure_years", salary_col = "gross_salary_real",
  covariate_cols = c("gender", "paygrade")
)
```
