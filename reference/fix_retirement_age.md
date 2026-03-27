# Flag or Adjust Over-Retirement-Age Workers

Addresses violations of the \`personnel_maximum_age\` rule. Only targets
workers with \`status == "active"\`; retired or inactive workers are
ignored.

## Usage

``` r
fix_retirement_age(data, max_age = 65, treatment = c("flag", "adjust_status"))
```

## Arguments

- data:

  A data.frame with \`birth_date\`, \`ref_date\`, and \`status\`
  columns.

- max_age:

  Retirement age threshold in years (default: 65).

- treatment:

  Handling strategy:

  - \`"flag"\`: Add \`over_retirement_flag\` column

  - \`"adjust_status"\`: Set \`status\` to \`"retired"\` for affected
    workers

## Value

A data.frame with over-retirement-age workers handled according to
\`treatment\`.

## See also

[`personnel_rules`](https://wb-pida-data-science-shop.github.io/govhr/reference/personnel_rules.md),
[`fix_underage_workers`](https://wb-pida-data-science-shop.github.io/govhr/reference/fix_underage_workers.md)

## Examples

``` r
if (FALSE) { # \dontrun{
fix_retirement_age(personnel_df, treatment = "flag")
fix_retirement_age(personnel_df, max_age = 70, treatment = "adjust_status")
} # }
```
