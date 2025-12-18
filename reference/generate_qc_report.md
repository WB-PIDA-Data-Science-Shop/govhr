# Generate Quality Control Report for HR Data

Produces a comprehensive HTML quality control report for harmonized HR
data. The report includes diagnostics on data structure, primary key
integrity, cross-module orphan checks, missingness patterns, and
temporal volatility across Contract, Personnel, and Establishment
modules.

## Usage

``` r
generate_qc_report(
  contract_dt,
  personnel_dt,
  est_dt,
  output = "qc_report.html"
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

- output:

  Character string specifying the output file name. Defaults to
  "qc_report.html". The file will be created in the current working
  directory.

## Value

Invisibly returns the path to the generated HTML report. The function is
primarily called for its side effect of creating the report file.

## Details

The function performs the following steps:

1.  Computes quality control diagnostics using
    [`compute_qualitycontrol`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_qualitycontrol.md)

2.  Locates the RMarkdown template from the package installation

3.  Renders the template with the provided data and diagnostics

The generated report includes:

- Module dimensions and variable structure conformity

- Primary key uniqueness checks

- Cross-module orphan record identification

- Comprehensive missingness analysis with visualizations

- Temporal volatility metrics for salary, wagebill, and staff counts

## See also

[`compute_qualitycontrol`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_qualitycontrol.md)
for the underlying diagnostic functions
[`harmonization_dict`](https://wb-pida-data-science-shop.github.io/govhr/reference/harmonization_dict.md)
for the harmonization dictionary

## Examples

``` r
if (FALSE) { # \dontrun{
# Generate quality control report for Brazilian HRMIS data
generate_qc_report(
  contract_dt = bra_hrmis_contract,
  personnel_dt = bra_hrmis_personnel,
  est_dt = bra_hrmis_est,
  output = "brazil_qc_report.html"
)
} # }
```
