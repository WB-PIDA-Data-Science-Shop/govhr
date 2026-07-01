# HRMIS Contract Dataset

Harmonized contract-level human resource management information system
(HRMIS) data for the State of Alagoas, Brazil. Each observation
represents a unique contract at a given reference date (\`contract_id\`,
\`ref_date\`) and contains information on remuneration, contract
characteristics, occupation, and employment details.

## Usage

``` r
bra_hrmis_contract
```

## Format

A data frame with 16,434 rows and 19 variables:

- contract_id:

  Unique identifier assigned to each contract.

- personnel_id:

  Unique identifier assigned to each worker.

- est_id:

  Unique identifier assigned to each establishment.

- ref_date:

  Reference date of the HRMIS record.

- base_salary_lcu:

  Basic salary before allowances and deductions (local currency units).

- allowance_lcu:

  Total allowances paid in addition to base salary (local currency
  units).

- gross_salary_lcu:

  Total compensation before taxes and deductions (local currency units).

- net_salary_lcu:

  Take-home pay after taxes and deductions (local currency units).

- whours:

  Contracted working hours.

- start_date:

  Employment contract start date.

- end_date:

  Employment contract end date, if applicable.

- paygrade:

  Pay grade or salary scale classification.

- seniority:

  Level or step within the pay grade.

- occupation_native:

  Occupation title in the native language.

- occupation_english:

  Occupation title translated into English.

- occupation_iscocode:

  ISCO-08 occupation code (4-digit level).

- occupation_isconame:

  ISCO-08 occupation name corresponding to the occupation code.

- contract_type_native:

  Employment contract type in the native language.

- contract_type:

  Standardized employment contract type. One of `"permanent"`,
  `"fixed-term"`, `"short-term"`, `"pensioner"`, or `"inactive"`.

## Source

Government of the State of Alagoas Human Resource Management Information
System (HRMIS), harmonized by the GovHR project.

## Details

The dataset follows the GovHR contract module data dictionary and is
intended for workforce analytics, payroll analysis, and personnel
microsimulation.

This dataset is harmonized according to the GovHR data dictionary.
Salary variables are expressed in nominal local currency units (LCU).
Occupations are translated into English and mapped to the International
Standard Classification of Occupations (ISCO-08). Contract types are
standardized across countries to facilitate comparative analysis.

## See also

[`bra_hrmis_personnel`](https://wb-pida-data-science-shop.github.io/govhr/reference/bra_hrmis_personnel.md),
[`bra_hrmis_est`](https://wb-pida-data-science-shop.github.io/govhr/reference/bra_hrmis_est.md)

## Examples

``` r
data(bra_hrmis_contract)
head(bra_hrmis_contract)
#> # A tibble: 6 × 19
#>   contract_id personnel_id est_id       ref_date   base_salary_lcu allowance_lcu
#>   <chr>       <chr>        <chr>        <date>               <dbl>         <dbl>
#> 1 144216      17795117449  PROCURADORI… 2012-09-01              0              0
#> 2 144216      17795117449  PROCURADORI… 2011-09-01              0              0
#> 3 136329      7650148408   AGENCIA DE … 2009-09-01            610.             0
#> 4 136329      7650148408   AGENCIA DE … 2011-09-01            653.             0
#> 5 136194      2282669479   AGENCIA DE … 2009-09-01            610.             0
#> 6 136194      2282669479   AGENCIA DE … 2008-09-01            610.             0
#> # ℹ 13 more variables: gross_salary_lcu <dbl>, net_salary_lcu <dbl>,
#> #   whours <dbl>, start_date <date>, end_date <date>, paygrade <chr>,
#> #   seniority <chr>, occupation_native <chr>, occupation_english <chr>,
#> #   occupation_iscocode <chr>, occupation_isconame <chr>,
#> #   contract_type_native <chr>, contract_type <chr>
```
