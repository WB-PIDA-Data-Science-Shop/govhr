# Compute Core HRMIS Analytical Tables

This function generates a suite of standardized analytical tables for
HRMIS (Human Resource Management Information System) reports. It
combines contract-level, personnel-level, and establishmental data to
compute wage bill summaries, employment shares, decompositions, and
profiles by occupation, pay grade, establishment, education, and
seniority.

## Usage

``` r
compute_hrmreport_stats(contract_dt, personnel_dt, est_dt, macro_indicators)
```

## Arguments

- contract_dt:

  A \`data.table\` containing individual employment contracts with
  variables such as \`personnel_id\`, \`ref_date\`, wage variables
  (\`gross_salary_lcu\`, \`net_salary_lcu\`, \`base_salary_lcu\`), and
  job attributes.

- personnel_dt:

  A \`data.table\` containing personnel-level panel data, including
  \`personnel_id\`, \`ref_date\`, demographic and employment
  information.

- est_dt:

  A \`data.table\` containing establishmental information (e.g.,
  institution identifiers, types, or sectors).

- macro_indicators:

  A data frame containing macro indicators.

## Value

A named list of \`data.table\` objects containing:

- wagebill_shares:

  Wage bill components as shares of macro indicators.

- publicemployment_share:

  Public employment as a share of total employment.

- wagebill_occupisco:

  Wage bill decomposition by ISCO occupation group.

- wagebill_occupnative:

  Wage bill decomposition by native occupational titles.

- wagebill_estdecomp:

  Wage bill decomposition by establishment.

- wagebill_allowshare_paygrade:

  Allowance rate by pay grade.

- wagebill_allowshare_seniority:

  Allowance rate by seniority.

- personnelevent:

  Personnel-level hiring, firing, and retirement events over time.

- employment_decomp:

  Employment decomposition by occupation and ISCO group.

- est_decomp:

  Employment decomposition by establishment.

- education_profile:

  Distribution of public sector personnel by education, gender, and
  occupation.

- mobilityprofile:

  Distribution of public sector personnel by pay grade, seniority,
  gender, and occupation.

## Details

The function integrates contract, personnel, and establishmental
datasets to compute a standardized HRMIS statistical report. It relies
on supporting helper functions such as:
[`convert_constant_ppp()`](https://wb-pida-data-science-shop.github.io/govhr/reference/convert_constant_ppp.md),
[`compute_fastshare()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_fastshare.md),
[`compute_fastsummary()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_fastsummary.md),
[`detect_personnel_event()`](https://wb-pida-data-science-shop.github.io/govhr/reference/detect_personnel_event.md),
and
[`detect_retirement()`](https://wb-pida-data-science-shop.github.io/govhr/reference/detect_retirement.md).

Each sub-table in the output list can be used directly in dashboards,
reports, or further analytical aggregation.

## Examples

``` r
if (FALSE) { # \dontrun{
hrm_stats <- compute_hrmreport_stats(contract_dt = contract_data,
                                     personnel_dt = personnel_data,
                                     est_dt = est_data)
names(hrm_stats)
} # }
```
