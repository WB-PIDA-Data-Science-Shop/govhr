# Compute Comprehensive Quality Control Checks for Harmonized HRMIS Data

Runs a full suite of QC diagnostics across the three harmonized HRMIS
modules—contract, personnel, and establishment. Rule-based validation
uses the validate framework and the built-in
[`govhr::contract_rules`](https://wb-pida-data-science-shop.github.io/govhr/reference/contract_rules.md)
/
[`govhr::personnel_rules`](https://wb-pida-data-science-shop.github.io/govhr/reference/personnel_rules.md)
datasets, optionally extended with country-specific rules supplied via
`custom_rules`.

## Usage

``` r
compute_qualitycontrol(
  contract_dt,
  personnel_dt,
  est_dt,
  custom_rules = list(contract = NULL, personnel = NULL)
)
```

## Arguments

- contract_dt:

  A data.frame or data.table — harmonized Contract module.

- personnel_dt:

  A data.frame or data.table — harmonized Personnel module.

- est_dt:

  A data.frame or data.table — harmonized Establishment module.

- custom_rules:

  A named list with optional elements `contract` and `personnel`, each a
  data.frame with the same four-column schema as
  [`govhr::contract_rules`](https://wb-pida-data-science-shop.github.io/govhr/reference/contract_rules.md)
  (`rule`, `name`, `description`, `label`). These rows are appended to
  the package-level rules before validation. Use `NULL` (the default) to
  run only the built-in rules.

## Value

A named list:

- `n_obs`:

  Row count of the Contract module.

- `n_vars`:

  Column count of the Contract module.

- `structure`:

  Dictionary-comparison results for each module.

- `orphans`:

  Orphan ID diagnostics.

- `validation`:

  Named list: `contract` and `personnel` audit reports from
  [`validate_data()`](https://wb-pida-data-science-shop.github.io/govhr/reference/validate_data.md).

- `missingness`:

  Long-format data.table of missingness by group, with columns
  `group_var`, `group_label`, `group_val`, `target_var`, `target_label`,
  `n_missing`, `N`, and `pct_missing`.

- `volatility`:

  Named list: `contract` and `personnel` flat data.tables from
  [`flatten_volatility()`](https://wb-pida-data-science-shop.github.io/govhr/reference/flatten_volatility.md).

- `temporal_coverage`:

  Named list: `contract`, `personnel` (if supplied), and `establishment`
  (if supplied), each a data.table with columns `ref_date` and `n_obs`
  showing the observation count per snapshot.

- `metadata`:

  Named list with `date_range` (min/max ref_date across all modules),
  `n_obs` (row counts per module), and `n_vars` (column counts per
  module).

## Details

- **Structure checks**:

  Variable names checked against the harmonization dictionary for each
  module.

- **Orphan checks**:

  Cross-module referential integrity: personnel and establishment IDs in
  the Contract module are checked against their parent modules.

- **Rule-based validation**:

  [`govhr::contract_rules`](https://wb-pida-data-science-shop.github.io/govhr/reference/contract_rules.md)
  and
  [`govhr::personnel_rules`](https://wb-pida-data-science-shop.github.io/govhr/reference/personnel_rules.md)
  (plus any `custom_rules`) are evaluated via
  [`validate_data()`](https://wb-pida-data-science-shop.github.io/govhr/reference/validate_data.md),
  covering uniqueness, date logic, salary consistency, working hours,
  age ranges, and more.

- **Missingness profiling**:

  Missingness by key grouping variables (contract type, occupation,
  reference date). Groups are silently skipped if the column is absent
  from the data.

- **Volatility analysis**:

  Period-over-period percent change for salaries, contract counts,
  working hours, occupation diversity, and contract-type diversity, each
  by multiple groupings. Groupings are silently skipped if the required
  columns are absent.

## Examples

``` r
if (FALSE) { # \dontrun{
qc <- compute_qualitycontrol(
  contract_dt  = bra_hrmis_contract,
  personnel_dt = bra_hrmis_personnel,
  est_dt       = bra_hrmis_est
)
qc$validation$contract
qc$volatility$contract
} # }
```
