# Fix Negative Salary Values

Addresses violations of positive salary rules
(\`wagebill\_\*\_positive\`) by handling negative values across salary
columns.

## Usage

``` r
fix_negative_salaries(
  data,
  columns = c("gross_salary_lcu", "base_salary_lcu", "net_salary_lcu"),
  treatment = c("na", "abs", "zero")
)
```

## Arguments

- data:

  A data.frame with salary columns.

- columns:

  Salary columns to fix (default: \`gross_salary_lcu\`,
  \`base_salary_lcu\`, \`net_salary_lcu\`).

- treatment:

  Correction strategy:

  - \`"na"\`: Set negative values to \`NA\`

  - \`"abs"\`: Take absolute value

  - \`"zero"\`: Set negative values to \`0\`

## Value

A data.frame with corrected salary values in the specified columns.

## See also

[`contract_rules`](https://wb-pida-data-science-shop.github.io/govhr/reference/contract_rules.md),
[`fix_salary_components`](https://wb-pida-data-science-shop.github.io/govhr/reference/fix_salary_components.md)

## Examples

``` r
if (FALSE) { # \dontrun{
fix_negative_salaries(contract_df, treatment = "abs")
fix_negative_salaries(contract_df, columns = "gross_salary_lcu", treatment = "na")
} # }
```
