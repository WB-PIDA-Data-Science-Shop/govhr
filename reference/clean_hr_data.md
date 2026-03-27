# Apply Standard HR Data Cleaning Pipeline

Chains the treatment functions in a recommended order. Steps applied per
\`data_type\`:

1.  \*\*Both\*\*: Remove duplicates (keep first); fix \`ref_date\` →
    \`NA\`

2.  \*\*Personnel\*\*: Fix \`birth_date\` → \`NA\`; flag underage and
    over-retirement-age workers

3.  \*\*Contract\*\*: Clamp \`whours\`; abs(negative salaries);
    recalculate gross = base + allowance

Use individual functions directly when you need custom strategies.

## Usage

``` r
clean_hr_data(
  data,
  data_type = c("personnel", "contract"),
  remove_duplicates = TRUE,
  fix_dates = TRUE,
  fix_ages = TRUE,
  fix_salaries = TRUE,
  verbose = FALSE
)
```

## Arguments

- data:

  A data.frame containing personnel or contract records.

- data_type:

  \`"personnel"\` or \`"contract"\`.

- remove_duplicates:

  Logical (default: \`TRUE\`).

- fix_dates:

  Logical (default: \`TRUE\`).

- fix_ages:

  Logical, personnel only (default: \`TRUE\`).

- fix_salaries:

  Logical, contract only (default: \`TRUE\`).

- verbose:

  Logical, print step-level messages (default: \`FALSE\`).

## Value

A cleaned data.frame.

## See also

[`remove_duplicate_personnel`](https://wb-pida-data-science-shop.github.io/govhr/reference/remove_duplicate_personnel.md),
[`remove_duplicate_contracts`](https://wb-pida-data-science-shop.github.io/govhr/reference/remove_duplicate_contracts.md),
[`fix_invalid_dates`](https://wb-pida-data-science-shop.github.io/govhr/reference/fix_invalid_dates.md),
[`fix_underage_workers`](https://wb-pida-data-science-shop.github.io/govhr/reference/fix_underage_workers.md),
[`fix_retirement_age`](https://wb-pida-data-science-shop.github.io/govhr/reference/fix_retirement_age.md),
[`fix_working_hours`](https://wb-pida-data-science-shop.github.io/govhr/reference/fix_working_hours.md),
[`fix_salary_components`](https://wb-pida-data-science-shop.github.io/govhr/reference/fix_salary_components.md),
[`fix_negative_salaries`](https://wb-pida-data-science-shop.github.io/govhr/reference/fix_negative_salaries.md)

## Examples

``` r
if (FALSE) { # \dontrun{
clean_hr_data(personnel_df, data_type = "personnel", verbose = TRUE)
clean_hr_data(contract_df, data_type = "contract", fix_salaries = FALSE)

# Custom pipeline
contract_df |>
  remove_duplicate_contracts(level = "assignment", keep = "last") |>
  fix_invalid_dates(treatment = "clamp") |>
  fix_working_hours(treatment = "na") |>
  fix_salary_components(strategy = "cap_net")
} # }
```
