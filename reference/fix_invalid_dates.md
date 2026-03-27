# Fix Invalid Reference Dates

Corrects \`ref_date\` values outside the valid range, addressing
violations of \`personnel_ref_date_valid\` and
\`contract_ref_date_valid\` rules.

## Usage

``` r
fix_invalid_dates(
  data,
  min_date = as.Date("1900-01-01"),
  max_date = Sys.Date(),
  treatment = c("na", "clamp", "filter")
)
```

## Arguments

- data:

  A data.frame with a \`ref_date\` column (Date class).

- min_date:

  Minimum valid date (default: \`1900-01-01\`).

- max_date:

  Maximum valid date (default: \`Sys.Date()\`).

- treatment:

  Correction strategy:

  - \`"na"\`: Set invalid dates to \`NA\`

  - \`"clamp"\`: Replace out-of-range dates with \`min_date\` or
    \`max_date\`

  - \`"filter"\`: Remove records with invalid dates

## Value

A data.frame with corrected \`ref_date\` values.

## See also

[`fix_invalid_birthdates`](https://wb-pida-data-science-shop.github.io/govhr/reference/fix_invalid_birthdates.md)

## Examples

``` r
if (FALSE) { # \dontrun{
fix_invalid_dates(personnel_df, treatment = "na")
fix_invalid_dates(contract_df, min_date = as.Date("2000-01-01"), treatment = "clamp")
} # }
```
