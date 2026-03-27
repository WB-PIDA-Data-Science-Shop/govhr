# Fix Invalid Birth Dates

Corrects \`birth_date\` values outside the valid range, addressing
violations of the \`personnel_birth_date\` rule. Defaults assume no
active worker was born before 1920 or in the future.

## Usage

``` r
fix_invalid_birthdates(
  data,
  min_date = as.Date("1920-01-01"),
  max_date = Sys.Date(),
  treatment = c("na", "clamp", "filter")
)
```

## Arguments

- data:

  A data.frame with a \`birth_date\` column (Date class).

- min_date:

  Minimum valid birth date (default: \`1920-01-01\`).

- max_date:

  Maximum valid birth date (default: \`Sys.Date()\`).

- treatment:

  Correction strategy: \`"na"\`, \`"clamp"\`, or \`"filter"\`. See
  [`fix_invalid_dates`](https://wb-pida-data-science-shop.github.io/govhr/reference/fix_invalid_dates.md).

## Value

A data.frame with corrected \`birth_date\` values.

## See also

[`personnel_rules`](https://wb-pida-data-science-shop.github.io/govhr/reference/personnel_rules.md),
[`fix_invalid_dates`](https://wb-pida-data-science-shop.github.io/govhr/reference/fix_invalid_dates.md)

## Examples

``` r
if (FALSE) { # \dontrun{
fix_invalid_birthdates(personnel_df, treatment = "na")
} # }
```
