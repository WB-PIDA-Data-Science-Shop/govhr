# Compute Comprehensive Quality Control Checks for Harmonized HRMIS Data

This function runs a full suite of quality control (QC) diagnostics
across three harmonized HRMIS modules—contract, personnel, and
establishment. It performs structure checks against a harmonization
dictionary, primary key uniqueness checks, orphan detection across
modules, salary validation, date logic checks, missingness profiling,
and volatility analysis for selected indicators.

## Usage

``` r
compute_qualitycontrol(contract_dt, personnel_dt, est_dt)
```

## Arguments

- contract_dt:

  A data.frame or data.table containing the harmonized Contract module.

- personnel_dt:

  A data.frame or data.table containing the harmonized Personnel module.

- est_dt:

  A data.frame or data.table containing the harmonized Establishment
  module.

## Value

A named list containing:

- `n_obs`:

  Number of observations in the Contract module.

- `n_vars`:

  Number of variables in the Contract module.

- `structure`:

  Results of structure/dictionary checks for each module.

- `keys`:

  Primary key uniqueness diagnostics.

- `orphans`:

  Orphan record diagnostics across modules.

- `salaries`:

  Salary consistency and validation results.

- `date_logic`:

  Results of date-related logical checks.

- `missingness`:

  Missingness summaries overall and by grouping.

- `volatility`:

  Volatility diagnostics for selected indicators.

## Details

The function executes the following QC components:

- **Structure checks**:

  Verifies that variable names in each module match those expected in
  the harmonization dictionary.

- **Primary key uniqueness**:

  Tests whether `contract_id`, `personnel_id`, and `ref_date` uniquely
  identify observations in the Contract module.

- **Orphan checks**:

  Detects cases where contract data reference personnel or establishment
  IDs not present in the respective parent modules.

- **Salary checks**:

  Validates salary fields for numeric type, non-negativity, and logical
  consistency (e.g., base salary ≤ gross salary ≥ net salary).

- **Date logic**:

  Identifies contracts with `end_date < start_date`.

- **Missingness profiling**:

  Computes missingness overall and by occupation, ISCO category,
  reference date, and establishment.

- **Volatility analysis**:

  Calculates period-over-period volatility in wage bill, salaries,
  staffing counts, and contract counts using the
  [`compute_volatility()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_volatility.md)
  function.

## Examples

``` r
if (FALSE) { # \dontrun{
qc <- compute_qualitycontrol(
  contract_dt = bra_hrmis_contract,
  personnel_dt = bra_hrmis_personnel,
  est_dt = bra_hrmis_est
)

qc$structure
qc$salaries
} # }
```
