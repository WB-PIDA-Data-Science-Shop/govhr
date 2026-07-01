# Brazil HRMIS Allowance Module

A harmonized personnel allowance dataset derived from the Brazil Human
Resource Management Information System (HRMIS). Each record represents a
single allowance or bonus received by a personnel contract during a
reference period.

## Usage

``` r
data(bra_hrmis_allowance)
```

## Format

A data frame with 60,430 rows and 5 variables:

- contract_id:

  Character. Unique identifier for the employment contract associated
  with the allowance.

- ref_date:

  Date. Reference date for the payroll record.

- allowance_type:

  Character. Harmonized allowance or bonus category.

- allowance_lcu:

  Numeric. Value of the allowance in local currency units (LCU).

- personnel_id:

  Character. Unique identifier for the individual receiving the
  allowance.

## Source

Government of the State of Alagoas Human Resource Management Information
System (HRMIS), harmonized by the \`govhrcast\` package.

## Details

The dataset follows a long format, with one observation per
\`contract_id\`–\`ref_date\`–\`allowance_type\` combination. Monetary
values are reported in local currency units (LCU).

The allowance module records non-base salary remuneration components
paid to employees, including permanent and temporary allowances,
bonuses, commissions, and other supplementary payments. Each observation
corresponds to a single allowance category for a specific contract and
payroll reference date.

Multiple allowance records may exist for the same contract and reference
date when an employee receives more than one type of allowance.
