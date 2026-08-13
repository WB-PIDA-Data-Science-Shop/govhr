# Data harmonization

``` r

library(govhr)
library(dplyr)
library(data.table)
```

## Why harmonize?

Governments collect HR data in their own conventions: column names,
classifications, and identifiers rarely match a common standard.
Harmonization re-expresses raw HR data extractions using the `govhr`
[Standard Data
Dictionary](https://wb-pida-data-science-shop.github.io/govhr/articles/01-standard_dictionary.html),
organized into three modules: **Establishment**, **Personnel**, and
**Contract**. Once harmonized, data becomes comparable across countries
and over time, and can feed directly into `govhr`’s analytics functions.

This article walks through harmonizing a synthetic dataset, `bra_hrmis`,
built from a contract-level extract from Brazil’s HRMIS system in the
Alagoas state, using the helper functions in `govhr`. The example
focuses primarily on generating one module, Personnel, but a similar
logic can be applied to the Establishment and Contract modules.

``` r

bra_hrmis <- as.data.table(govhr::bra_hrmis)
dim(bra_hrmis)
#> [1] 12576    34
```

## Step 1: check column consistency

Before harmonizing, it’s useful to check whether raw data sources
(e.g. multiple years or offices) share a consistent column naming (i.e.,
schema).
[`find_inconsistent_colnames()`](https://wb-pida-data-science-shop.github.io/govhr/reference/find_inconsistent_colnames.md)
flags columns that aren’t shared across all sources.

``` r

# simulate two extracts with slightly different schemas
extract_2020 <- bra_hrmis[ANO_PAGAMENTO == min(ANO_PAGAMENTO)]
extract_2021 <- bra_hrmis[ANO_PAGAMENTO == max(ANO_PAGAMENTO)]

find_inconsistent_colnames(list(extract_2020, extract_2021))
#> # A tibble: 0 × 1
#> # ℹ 1 variable: colnames <chr>
```

## Step 2: generate module identifiers

Harmonization requires knowing which column identifies a contract and
which identifies a person. These are our primary keys, that is, unique
identifiers for contracts and personnel, respectively.
[`find_duplicate_ids()`](https://wb-pida-data-science-shop.github.io/govhr/reference/find_duplicate_ids.md)
is a quick way to test whether a candidate column is a valid unique key.

``` r

bra_hrmis |> find_duplicate_ids(MATRICULA)
#> Index: <ANO_PAGAMENTO>
#>       MATRICULA     n
#>          <char> <int>
#>    1:    100025    10
#>    2:    100030     2
#>    3:    100070    10
#>    4:    100094    10
#>    5:    100096    10
#>   ---                
#> 1961:     99772    10
#> 1962:      9979     5
#> 1963:     99851    10
#> 1964:     99962    10
#> 1965:     99990    10
```

`MATRICULA` uniquely identifies a contract for a given reference date,
so it becomes the **contract identifier**, or `contract_id` in our
standard data dictionary. `CPF` will serve as the **personnel
identifier**, the `personnel_id`.

## Step 3: map raw columns to standardized names

Raw data columns rarely match the naming conventions of the `govhr`
standard dictionary.
[`harmonize_columns()`](https://wb-pida-data-science-shop.github.io/govhr/reference/harmonize_columns.md)
renames the data with a key-value dictionary, keeping only the desired
columns.

``` r

column_dictionary <- c(
  contract_id  = "MATRICULA",
  personnel_id = "CPF",
  est_id       = "ORGAO",
  paygrade     = "CLASSE",
  seniority    = "NIVEL",
  gender       = "GENERO"
)

bra_hrmis <- harmonize_columns(bra_hrmis, column_dictionary) |>
  cbind(bra_hrmis[, !names(column_dictionary), with = FALSE][
    ,
    setdiff(names(bra_hrmis), names(column_dictionary)),
    with = FALSE
  ])
```

## Building reference dates

Dates are often stored as serial numbers or split across year/month
columns. Once a `ref_date` column is built,
[`guess_date_frequency()`](https://wb-pida-data-science-shop.github.io/govhr/reference/guess_date_frequency.md)
confirms the reporting interval — useful for choosing the right window
when computing growth or turnover indicators later.

``` r

bra_hrmis[, ref_date := as.Date(paste(ANO_PAGAMENTO, MES_REFERENCIA, "01", sep = "-"))]

bra_hrmis |>
  as.data.frame() |>
  guess_date_frequency()
#> [1] "quarter"
```

## Deduping values

Attributes like education and gender should be constant for a given
personnel-period, but raw data sometimes disagrees across rows for the
same `personnel_id`/`ref_date` (e.g. due to concurrent contracts).
[`dedup_values()`](https://wb-pida-data-science-shop.github.io/govhr/reference/dedup_values.md)
resolves this using a chosen strategy — here, the modal value.

``` r

bra_hrmis <- dedup_values(
  bra_hrmis,
  id_col = personnel_id,
  date_col = ref_date,
  value_col = gender,
  method = "mode"
) |>
  select(personnel_id, ref_date, gender) |>
  right_join(
    bra_hrmis |> select(-gender),
    by = c("personnel_id", "ref_date")
  ) |>
  as.data.table()
```

## Deflating wages

Nominal wages in local currency aren’t comparable across time or
countries.
[`convert_constant_ppp()`](https://wb-pida-data-science-shop.github.io/govhr/reference/convert_constant_ppp.md)
uses the bundled `macro_indicators` dataset (with CPI and PPP conversion
factors) to convert local currency units into international dollars.

``` r

setnames(
  bra_hrmis,
  old = c("SALARIO_BASE", "SALARIO_BRUTO", "SALARIO_LIQUIDO"),
  new = c("base_salary_lcu", "gross_salary_lcu", "net_salary_lcu")
)

bra_hrmis[, country_code := "BRA"]

salary_cols <- grep("_lcu$", names(bra_hrmis), value = TRUE)
bra_hrmis[, (salary_cols) := lapply(.SD, as.numeric), .SDcols = salary_cols]

bra_hrmis <- convert_constant_ppp(bra_hrmis, cols = salary_cols)

bra_hrmis |>
  select(personnel_id, ref_date, all_of(salary_cols), ends_with("_ppp")) |>
  head()
#>    personnel_id   ref_date base_salary_lcu gross_salary_lcu net_salary_lcu
#>          <char>     <Date>           <num>            <num>          <num>
#> 1:    101237413 2015-08-01          924.49           924.49         850.54
#> 2:    101237413 2015-09-01          970.69           970.69         898.02
#> 3:  10128158468 2015-09-01              NA               NA             NA
#> 4:  10128158468 2016-09-01              NA               NA             NA
#> 5:  10128158468 2017-09-01              NA               NA             NA
#> 6:  10128158468 2018-09-01              NA               NA             NA
#>    base_salary_ppp gross_salary_ppp net_salary_ppp
#>              <num>            <num>          <num>
#> 1:          279.09           279.09         256.77
#> 2:          293.04           293.04         271.10
#> 3:              NA               NA             NA
#> 4:              NA               NA             NA
#> 5:              NA               NA             NA
#> 6:              NA               NA             NA
```

[`deflate_to_real()`](https://wb-pida-data-science-shop.github.io/govhr/reference/deflate_to_real.md)
offers a lighter-weight alternative when you only need compensation
expressed in constant local currency units (rather than constant
international dollars):

``` r

bra_hrmis[, gross_salary_real := deflate_to_real(
  gross_salary_lcu,
  ref_date,
  country_code,
  base_year = 2021
)]
```

## Completing the module

Not every data extraction contains every dictionary column
(e.g. `tribe`, `race` may be unavailable).
[`complete_columns()`](https://wb-pida-data-science-shop.github.io/govhr/reference/complete_columns.md)
adds any missing dictionary columns as `NA`, so the resulting table
always matches the expected schema — no more, no less.

``` r

personnel_cols <- c(
  "personnel_id", "est_id", "ref_date", "gender",
  "educat7", "tribe", "race", "country_code"
)

bra_hrmis_personnel <- bra_hrmis |>
  select(any_of(personnel_cols)) |>
  distinct() |>
  complete_columns(personnel_cols)

bra_hrmis_personnel |> head()
#>    personnel_id                                                est_id
#>          <char>                                                <char>
#> 1:    101237413 UNIVERSIDADE ESTADUAL DE CIENCIAS DA SAUDE DE ALAGOAS
#> 2:    101237413 UNIVERSIDADE ESTADUAL DE CIENCIAS DA SAUDE DE ALAGOAS
#> 3:  10128158468                                   ALAGOAS PREVIDENCIA
#> 4:  10128158468                                   ALAGOAS PREVIDENCIA
#> 5:  10128158468                                   ALAGOAS PREVIDENCIA
#> 6:  10128158468                                   ALAGOAS PREVIDENCIA
#>      ref_date    gender educat7  tribe   race country_code
#>        <Date>    <char>  <lgcl> <lgcl> <lgcl>       <char>
#> 1: 2015-08-01 MASCULINO      NA     NA     NA          BRA
#> 2: 2015-09-01 MASCULINO      NA     NA     NA          BRA
#> 3: 2015-09-01  FEMININO      NA     NA     NA          BRA
#> 4: 2016-09-01  FEMININO      NA     NA     NA          BRA
#> 5: 2017-09-01  FEMININO      NA     NA     NA          BRA
#> 6: 2018-09-01  FEMININO      NA     NA     NA          BRA
```

## Validating the harmonized data

Once harmonized,
[`validate_data()`](https://wb-pida-data-science-shop.github.io/govhr/reference/validate_data.md)
checks the harmonized dataset against a set of validation rules. It then
reports both a pass-rate summary and the specific records that violate
each rule. This helps you identify negative salaries, missing keys, or
out-of-range dates before analytics are run.

``` r

result <- validate_data(
  data        = govhr::bra_hrmis_contract,
  input_rules = govhr::contract_rules
)

result$report
```

You can inspect the specific records that violate a given rule, for
example, the `salary_non_negative` rule:

``` r

result$violations[["salary_non_negative"]]
#> NULL
```

Informed by this validation, you might want to revisit your
harmonization process and address lingering data quality issues.
