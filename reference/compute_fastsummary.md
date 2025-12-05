# Compute Fast Summary Statistics by Group

\`compute_fastsummary()\` computes summary statistics for selected
columns of a dataset, optionally grouped by one or more variables. It
allows the user to specify a set of functions to apply, either from a
predefined set or custom formulas/functions.

## Usage

``` r
compute_fastsummary(
  data,
  cols,
  fns = NULL,
  groups,
  output = c("long", "wide"),
  tbl = FALSE
)
```

## Arguments

- data:

  A \`data.table\`, \`data.frame\`, or tibble. The dataset on which to
  compute the summaries. If not a \`data.table\`, it will be converted
  internally for computation. The result will be returned in the same
  class as the input (unless \`tbl = TRUE\`).

- cols:

  A character vector. Names of the columns to summarize.

- fns:

  Optional. Either:

  - \`NULL\` (default): use all default functions defined by
    \`define_fns()\`.

  - A character vector of function names matching \`define_fns()\`.

  - A list of functions or formulas, possibly mixed with character names
    referring to \`define_fns()\`.

- groups:

  A character vector. Column(s) by which to group the data before
  computing the summary statistics.

- output:

  Character. Either \`"long"\` (default) or \`"wide"\` to specify the
  output format. \`"long"\` returns one row per group per summary
  statistic, \`"wide"\` returns one row per group with multiple columns
  for each summary statistic.

- tbl:

  Logical. If \`TRUE\`, converts the result to a tibble
  (\`tibble::as_tibble()\`).

## Value

A dataset containing the summary statistics for the selected columns.
The output will be either long or wide depending on the \`output\`
argument. The returned object will match the class of the input \`data\`
(unless \`tbl = TRUE\`).

## Details

The function constructs the summary calls efficiently using \`bquote()\`
and evaluates them within the \`data.table\` environment. This allows
for fast computation even with large datasets. Custom functions can be
supplied as formulas (e.g., \`~ mean(.x, na.rm = TRUE)\`) or as
pre-defined function names from \`define_fns()\`.

## Examples

``` r
if (FALSE) { # \dontrun{
library(data.table)
dt <- data.table(x = rnorm(100), y = rnorm(100), group = sample(1:2, 100, TRUE))
# Compute mean and sd by group
compute_fastsummary(dt, cols = c("x", "y"), fns = c("mean", "sd"), groups = "group")

# Use a custom function
compute_fastsummary(
  dt,
  cols = "x",
  fns = list(mean = ~mean(.x, na.rm = TRUE)),
  groups = "group",
  output = "long",
  tbl = TRUE
)
} # }
```
