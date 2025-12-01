# Compute ratio indicators of summarized variables over macro indicators

\`compute_fastshare()\` summarizes selected numeric columns by specified
groups, merges the result with macroeconomic indicators, computes ratios
of summarized variables per macro variable, and returns either a long or
wide-format data.table.

## Usage

``` r
compute_fastshare(
  data,
  macro_data = as.data.table(macro_indicators),
  macro_cols,
  cols,
  groups,
  fns,
  output = c("long", "wide")
)
```

## Arguments

- data:

  A data.frame or data.table containing the raw data to summarize.

- macro_data:

  A data.frame or data.table containing macro-level indicators. Must
  share at least one common grouping variable with \`data\`. Default is
  \`macro_indicators\`.

- macro_cols:

  A character vector of column names in \`macro_data\` to use as
  denominators for ratio calculations.

- cols:

  A character vector of column names in \`data\` to summarize.

- groups:

  A character vector of column names in \`data\` to group by. Typically
  includes country and date/year variables. Default is
  \`c("country_code", "year")\`.

- fns:

  A character vector of summary functions to apply to \`cols\`.
  Examples: \`"sum"\`, \`"mean"\`, \`"median"\`.

- output:

  Either \`"long"\` or \`"wide"\` (default \`"long"\`). - \`"long"\`
  returns a tidy table with columns: group variables, \`macro_var\`,
  \`summary_var\`, \`indicator\`, and \`value\`. - \`"wide"\` returns a
  table with one column per indicator and original macro/summary values.

## Value

A \`data.table\` containing: - In \`"long"\` format: group variables,
\`macro_var\`, \`macro_value\`, \`summary_var\`, \`summary_value\`,
\`indicator\`, and \`value\`. - In \`"wide"\` format: group variables,
one column per indicator (\`summary_var\` per \`macro_var\`), and
original macro and summary values.

## Details

The function works as follows: 1. Summarizes \`cols\` by \`groups\`
using the functions in \`fns\`. 2. Automatically detects common join
variables between \`summary_dt\` and \`macro_data\`. 3. Merges the
summarized data with macro indicators. 4. Computes ratio indicators
(\`summary_value / macro_value\`) for all combinations of summarized
columns and macro columns. 5. Optionally reshapes the result into wide
format with one column per indicator.

## Examples

``` r
if (FALSE) { # \dontrun{

dt <- contract_harmonized |> mutate(year = year(est_date)) |> as.data.table()


compute_fastshare(
  data = dt,
  macro_cols = c("gdp_lcu", "pexpenditure_lcu"),
  cols = c("gross_salary_lcu", "net_salary_lcu", "base_salary_lcu"),
  fns = c("sum", "mean"),
  output = "long",
  groups = c("country_code", "year")
)

## produce results in wide format
compute_fastshare(
  data = dt,
  macro_cols = c("gdp_lcu", "pexpenditure_lcu"),
  cols = c("gross_salary_lcu", "net_salary_lcu", "base_salary_lcu"),
  fns = c("sum", "mean"),
  output = "wide",
  groups = c("country_code", "year"))

} # }
```
