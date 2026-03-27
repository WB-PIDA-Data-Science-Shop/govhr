# Fix Invalid Working Hours

Corrects \`whours\` values outside the valid range \[0, 168\],
addressing violations of the \`contract_whours\` rule. The maximum of
168 reflects 5 days × 8 hours per week.

## Usage

``` r
fix_working_hours(data, treatment = c("na", "clamp", "flag"))
```

## Arguments

- data:

  A data.frame with a \`whours\` column (numeric).

- treatment:

  Correction strategy:

  - \`"na"\`: Set invalid hours to \`NA\`

  - \`"clamp"\`: Clamp to \`\[0, 40\]\`

  - \`"flag"\`: Add \`invalid_hours_flag\` column (also flags \`NA\`)

## Value

A data.frame with corrected working hours.

## See also

[`contract_rules`](https://wb-pida-data-science-shop.github.io/govhr/reference/contract_rules.md)

## Examples

``` r
if (FALSE) { # \dontrun{
fix_working_hours(contract_df, treatment = "clamp")
} # }
```
