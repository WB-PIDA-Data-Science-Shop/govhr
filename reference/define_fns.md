# Define Default Summary Functions

Creates and returns a named list of default summary functions used
throughout the analytics framework (e.g., by \[compute_fastsummary()\]).
Each function is defined as a purrr-style formula (\`~\`) that operates
on a vector \`.x\` and returns a scalar summary statistic. The returned
list can be supplied directly to a summarization pipeline or extended by
users with custom functions.

## Usage

``` r
define_fns()
```

## Format

The list includes the following summary functions:

- sum:

  Sum of values, ignoring \`NA\`s.

- mean:

  Arithmetic mean.

- median:

  Median value.

- cv:

  Coefficient of variation (requires a \`cv()\` helper).

- cp_ratio:

  Custom "cp ratio" statistic (requires a \`cp_ratio()\` helper).

- var:

  Sample variance.

- iqr:

  Interquartile range, computed as \`diff(range(.x))\`.

- min:

  Minimum value.

- max:

  Maximum value.

- count:

  Number of observations.

- count_unique:

  Number of distinct (unique) values.

- prop_na:

  Proportion of missing (\`NA\`) values.

- prop_zero:

  Proportion of zero values among non-missing data.

- p25:

  25th percentile (first quartile).

- p75:

  75th percentile (third quartile).

- p90:

  90th percentile.

- sd:

  Standard deviation.

## Value

A named list of formula functions suitable for use with
\`dplyr::across()\`, where each element name is the function label and
the value is a one-sided formula that computes the summary.

## Details

The returned list contains commonly used descriptive statistics for
numeric vectors, including measures of central tendency, dispersion,
distribution, and data quality (e.g., share of missing or zero values).
Users can extend or override the defaults by appending their own named
formulas before passing to \[compute_fastsummary()\].

## See also

\[compute_fastsummary()\], \[compute_fastshare()\]

## Examples

``` r
# Load the default function set
fns <- define_fns()

# Inspect available summaries
names(fns)
#>  [1] "sum"          "mean"         "median"       "cv"           "cp_ratio"    
#>  [6] "var"          "iqr"          "min"          "max"          "count"       
#> [11] "prop"         "dtprop"       "count_unique" "prop_na"      "prop_zero"   
#> [16] "p25"          "p75"          "p90"          "sd"          

# Example usage with compute_fastsummary()
compute_fastsummary(
  data = tibble::tibble(
     country_code = c(rep("A", 100), rep("B", 100)),
     gross_salary_lcu = c(
      rnorm(100, mean = 1000, sd = 100),
      rnorm(100,  mean = 2000, sd = 100)
      ),
     net_salary_lcu = c(
      rnorm(100, mean = 0.7 * 1000, sd = 100),
      rnorm(100,  mean = 0.7 * 2000, sd = 100)
     )
  ) |> data.table::as.data.table(),
  cols = c("gross_salary_lcu", "net_salary_lcu"),
  groups = c("country_code"),
  fns = c("mean", "sd", "cv")
)
#>     country_code             indicator        value
#>           <char>                <fctr>        <num>
#>  1:            A gross_salary_lcu_mean 1.010456e+03
#>  2:            B gross_salary_lcu_mean 2.009664e+03
#>  3:            A   gross_salary_lcu_sd 1.033554e+02
#>  4:            B   gross_salary_lcu_sd 1.042561e+02
#>  5:            A   gross_salary_lcu_cv 1.022859e-01
#>  6:            B   gross_salary_lcu_cv 5.187739e-02
#>  7:            A   net_salary_lcu_mean 7.028759e+02
#>  8:            B   net_salary_lcu_mean 1.416506e+03
#>  9:            A     net_salary_lcu_sd 1.023298e+02
#> 10:            B     net_salary_lcu_sd 1.007025e+02
#> 11:            A     net_salary_lcu_cv 1.455874e-01
#> 12:            B     net_salary_lcu_cv 7.109214e-02
```
