# Generate Standard HR Analytics Report

Produces a comprehensive HTML analytics report for harmonized HR data
using a Quarto template. The report includes descriptive statistics,
visualizations, and optional quality control diagnostics across
Contract, Personnel, and Establishment modules.

## Usage

``` r
generate_hr_report(
  contract_dt,
  personnel_dt,
  est_dt,
  country_code,
  output = "hr_report.html"
)
```

## Arguments

- contract_dt:

  A data.table containing the Contract module data with harmonized
  column names according to
  [`harmonization_dict`](https://wb-pida-data-science-shop.github.io/govhr/reference/harmonization_dict.md).
  Should include columns such as contract_id, personnel_id, est_id,
  ref_date, salary fields, and occupation information.

- personnel_dt:

  A data.table containing the Personnel module data with harmonized
  column names. Should include personnel_id and demographic information.

- est_dt:

  A data.table containing the Establishment module data with harmonized
  column names. Should include est_id and establishment characteristics.

- country_code:

  The reference country code. Must be specified in the three-letter,
  World Bank standard (e.g., BRA for Brazil).

- output:

  Character string specifying the output file name. Defaults to
  "hr_report.html". The file will be created in the current working
  directory.

## Value

An HR report, in HTML.

## See also

[`generate_qc_report`](https://wb-pida-data-science-shop.github.io/govhr/reference/generate_qc_report.md)
for the data quality assessment report.
[`harmonization_dict`](https://wb-pida-data-science-shop.github.io/govhr/reference/harmonization_dict.md)
for the harmonization dictionary.

## Examples

``` r
if (FALSE) { # \dontrun{
# Generate HR analytics report for Brazilian HRMIS data
generate_hr_report(
  contract_dt = bra_hrmis_contract,
  personnel_dt = bra_hrmis_personnel,
  est_dt = bra_hrmis_est,
  country_code = "BRA",
  output = "brazil_hr_report.html"
)
} # }
```
