# HRMIS Personnel Dataset

Harmonized personnel-level human resource management information system
(HRMIS) data for the State of Alagoas, Brazil. Each observation
represents a unique worker at a given reference date (\`personnel_id\`,
\`ref_date\`) and contains demographic characteristics, education,
employment status, and public service information.

## Usage

``` r
bra_hrmis_personnel
```

## Format

A data frame with 15,681 rows and 11 variables:

- personnel_id:

  Unique identifier assigned to each worker.

- ref_date:

  Reference date of the HRMIS record.

- birth_date:

  Worker's date of birth.

- age:

  Worker's age in years at the reference date.

- gender:

  Worker's gender.

- educat7:

  Educational attainment using the World Bank Global Labor Database
  (GLD) seven-level education classification.

- employment_status:

  Standardized employment status. One of `"active"`, `"inactive"`, or
  `"pensioner"`.

- service_type:

  Type of public service. One of `"civilian"` or `"military"`.

- race:

  Worker's race or broad ethnic classification, where available.

- tribe:

  Worker's ethnic or tribal affiliation, where available.

- first_employment_date:

  Date the worker first entered the public service.

## Source

Government of the State of Alagoas Human Resource Management Information
System (HRMIS), harmonized by the GovHR project.

## Details

The dataset follows the GovHR personnel module data dictionary and is
intended for workforce analytics, demographic analysis, and personnel
microsimulation.

This dataset is harmonized according to the GovHR data dictionary.
Educational attainment follows the seven-level classification used by
the World Bank's Global Labor Database (GLD). Employment status and
service type are standardized across countries to facilitate comparative
analysis of public sector workforces.

## See also

[`bra_hrmis_contract`](https://wb-pida-data-science-shop.github.io/govhr/reference/bra_hrmis_contract.md),
[`bra_hrmis_est`](https://wb-pida-data-science-shop.github.io/govhr/reference/bra_hrmis_est.md)

## Examples

``` r
data(bra_hrmis_personnel)
```
