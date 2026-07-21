# Compute Ratio of Last Salary to First Pension for Retired Workers

For each individual who has retired, computes the ratio of their first
pension payment to their last active salary.

## Usage

``` r
compute_pension_ratio(
  personnel_dt,
  contract_dt,
  salary_col,
  personnel_id_col = "personnel_id",
  status_col = "employment_status",
  date_col = "ref_date",
  pensioner_value = "pensioner",
  keep_vars = NULL
)
```

## Arguments

- personnel_dt:

  A data.table (or tibble/data.frame) containing at minimum the columns
  named in \`id_col\`, \`status_col\`, and \`date_col\`.

- contract_dt:

  A data.table (or tibble/data.frame) containing at minimum the columns
  named in \`id_col\`, \`date_col\`, and \`salary_col\`.

- salary_col:

  A single string naming the compensation column to use, e.g.
  \`"gross_salary_def"\` (default), \`"base_salary_lcu"\`, etc.

- personnel_id_col:

  A single string naming the personnel identifier column. Defaults to
  \`"personnel_id"\`.

- status_col:

  A single string naming the employment status column inside
  \`personnel_dt\`. Defaults to \`"employment_status"\`.

- date_col:

  A single string naming the snapshot/reference date column. Defaults to
  \`"ref_date"\`.

- pensioner_value:

  A single string giving the value of \`status_col\` that identifies a
  pensioner record. Defaults to \`"pensioner"\`.

- keep_vars:

  A character vector of additional contract-level columns to attach via
  \`govhr::add_contract_to_event()\`. Defaults to NULL

## Value

A data.table with one row per retiring individual containing the
\`id_col\` identifier, \`ref_date_active\` (last active date),
\`last_salary\`, \`ref_date_pension\` (first pension date),
\`first_pension\`, and \`replacement_rate\`.

## Details

The replacement rate is a standard diagnostic in public sector pension
and workforce analysis, and it matters here for a few distinct reasons:

- **Fiscal sustainability**: Aggregated across occupation or paygrade,
  replacement rates feed directly into pension liability projections.

- **Retirement incentive / take-up behavior**: Low replacement rates
  help explain deferred retirement, relevant to calibrating
  `ANNUAL_TAKE_UP` rather than assuming 100% take-up at eligibility.

- **Equity diagnostics**: Comparing rates across paygrade, occupation,
  or establishment can surface structural inequities in how the pension
  formula interacts with career trajectories.

- **Policy reform simulation**: Because the function is column-name
  agnostic, it can be re-run under counterfactual salary or pension
  formulas or against differently structured client datasets without
  code changes.
