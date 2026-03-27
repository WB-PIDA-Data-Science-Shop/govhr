# Flag or Remove Underage Workers

Addresses violations of the \`personnel_minimum_age\` rule. Workers
below \`min_age\` (default: 18) are identified using \`birth_date\` and
\`ref_date\`. Age is calculated as \`difftime(ref_date, birth_date,
units = "days") / 365.25\`.

## Usage

``` r
fix_underage_workers(data, min_age = 18, treatment = c("flag", "filter"))
```

## Arguments

- data:

  A data.frame with \`birth_date\` and \`ref_date\` columns (Date
  class).

- min_age:

  Minimum working age in years (default: 18).

- treatment:

  Handling strategy:

  - \`"flag"\`: Add \`underage_flag\` column (TRUE for underage workers)

  - \`"filter"\`: Remove underage worker records

## Value

A data.frame with underage workers handled according to \`treatment\`.

## See also

[`personnel_rules`](https://wb-pida-data-science-shop.github.io/govhr/reference/personnel_rules.md),
[`fix_retirement_age`](https://wb-pida-data-science-shop.github.io/govhr/reference/fix_retirement_age.md)

## Examples

``` r
if (FALSE) { # \dontrun{
fix_underage_workers(personnel_df, treatment = "flag")
fix_underage_workers(personnel_df, min_age = 16, treatment = "filter")
} # }
```
