# Compute wage bill aggregates with optional macro-fiscal shares

Computes aggregate wage bill statistics from contract-level salary data.
The function converts salary variables to constant purchasing power
parity (PPP) using macro indicators, then aggregates by specified
grouping variables. Optionally computes wage bill shares relative to
macro-fiscal aggregates (e.g., GDP, public expenditure, revenue).

## Usage

``` r
compute_wagebill(
  contract_df,
  wage_vars = c("gross_salary_lcu", "net_salary_lcu", "base_salary_lcu"),
  groups = c("country_code", "year"),
  share_macro = FALSE,
  macro_vars = c("gdp_lcu", "pexpenditure_lcu", "prevenue_lcu", "taxrevenue_lcu"),
  drop_na = TRUE
)
```

## Arguments

- contract_df:

  A data.frame or tibble containing contract-level salary data. Must
  include the columns specified in \`wage_vars\` and \`groups\`.

- wage_vars:

  Character vector of salary column names to aggregate. Defaults to
  \`c("gross_salary_lcu", "net_salary_lcu", "base_salary_lcu")\`.

- groups:

  Character vector of grouping columns for aggregation. Defaults to
  \`c("country_code", "year")\`.

- share_macro:

  Logical; if \`TRUE\`, computes wage bill shares relative to
  macro-fiscal aggregates specified in \`macro_vars\`. Defaults to
  \`FALSE\`.

- macro_vars:

  Character vector of macro indicator column names to use as
  denominators when \`share_macro = TRUE\`. Defaults to \`c("gdp_lcu",
  "pexpenditure_lcu", "prevenue_lcu", "taxrevenue_lcu")\`.

- drop_na:

  Logical; if \`TRUE\`, removes \`NA\` values before aggregation.
  Defaults to \`TRUE\`.

## Value

A wage bill table with optional grouping variables, an \`indicator\`
column (describing the wage variable and level of analysis), and a
\`value\` column. When \`share_macro = TRUE\`, values represent shares
(wage bill / macro aggregate).

## See also

[`convert_constant_ppp`](https://wb-pida-data-science-shop.github.io/govhr/reference/convert_constant_ppp.md)
for PPP conversion
[`compute_fastsummary`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_fastsummary.md)
for general aggregation
[`compute_fastshare`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_fastshare.md)
for share computation (when \`share_macro = TRUE\`)

## Examples

``` r
# Compute wage bill totals by country and year
if (FALSE) { # \dontrun{
compute_wagebill(
  contract_df = govhr::bra_hrmis_contract,
  wage_vars = c("gross_salary_lcu"),
  groups = c("country_code", "year")
)

# Compute wage bill as share of GDP and public expenditure
compute_wagebill(
  contract_df = govhr::bra_hrmis_contract,
  wage_vars = c("gross_salary_lcu", "net_salary_lcu"),
  groups = c("country_code", "year"),
  share_macro = TRUE,
  macro_vars = c("gdp_lcu", "pexpenditure_lcu")
) 
} # }
```
