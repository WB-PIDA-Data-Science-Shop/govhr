# Fix Salary Component Inconsistencies

Corrects violations of wage bill consistency rules: gross ≥ base +
allowance, gross ≥ net, gross ≥ base.

## Usage

``` r
fix_salary_components(
  data,
  strategy = c("recalculate_gross", "cap_net", "cap_base", "flag")
)
```

## Arguments

- data:

  A data.frame with columns \`gross_salary_lcu\`, \`base_salary_lcu\`,
  \`net_salary_lcu\`, \`allowance_lcu\`.

- strategy:

  Correction strategy:

  - \`"recalculate_gross"\`: Set \`gross = base + allowance\`

  - \`"cap_net"\`: Cap net at gross

  - \`"cap_base"\`: Cap base at gross

  - \`"flag"\`: Add flag columns \`gross_composition_flag\`,
    \`net_exceeds_gross_flag\`, \`base_exceeds_gross_flag\`

## Value

A data.frame with corrected salary components.

## See also

[`contract_rules`](https://wb-pida-data-science-shop.github.io/govhr/reference/contract_rules.md),
[`fix_negative_salaries`](https://wb-pida-data-science-shop.github.io/govhr/reference/fix_negative_salaries.md)

## Examples

``` r
if (FALSE) { # \dontrun{
fix_salary_components(contract_df, strategy = "recalculate_gross")
fix_salary_components(contract_df, strategy = "flag")
} # }
```
