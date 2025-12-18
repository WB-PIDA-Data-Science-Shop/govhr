# Compare the contents of two character vectors

This function compares two vectors and identifies:

## Usage

``` r
compare_names_qc(x, y, output_format = c("simple", "bullet", "badges"))
```

## Arguments

- x:

  A vector of values to compare.

- y:

  A second vector of values to compare with `x`.

- output_format:

  Character string indicating the output format. Must be one of
  `"simple"`, `"bullet"`, or `"badges"`.

## Value

A named list containing:

- `missing`:

  Formatted HTML showing values in `x` but not in `y`.

- `extra`:

  Formatted HTML showing values in `y` but not in `x`.

- `x_missing_y`:

  Raw vector of elements in `x` but not in `y`.

- `y_missing_x`:

  Raw vector of elements in `y` but not in `x`.

## Details

- Elements in `x` that are missing in `y`.

- Elements in `y` that are missing in `x`.

It returns both the raw differences and formatted HTML output for use in
reports, Shiny apps, or pointblank validation messages.

Three output formats are supported:

- `"simple"`:

  Colored comma-separated strings (HTML).

- `"bullet"`:

  HTML unordered lists.

- `"badges"`:

  Bootstrap-style colored badges.

## Examples

``` r
x <- c("a", "b", "c")
y <- c("b", "c", "d")

compare_names_qc(x, y)
#> $missing
#> [1] "<span style='color:red; font-weight:bold;'>a</span>"
#> 
#> $extra
#> [1] "<span style='color:orange; font-weight:bold;'>d</span>"
#> 
#> $x_missing_y
#> [1] "a"
#> 
#> $y_missing_x
#> [1] "d"
#> 
compare_names_qc(x, y, output_format = "bullet")
#> $missing
#> [1] "<ul style='margin-left:0; padding-left:1em;'><li>a</li></ul>"
#> 
#> $extra
#> [1] "<ul style='margin-left:0; padding-left:1em;'><li>d</li></ul>"
#> 
#> $x_missing_y
#> [1] "a"
#> 
#> $y_missing_x
#> [1] "d"
#> 
compare_names_qc(x, y, output_format = "badges")
#> $missing
#> [1] "<span style='background:#d32f2f;color:white;padding:2px 6px;border-radius:4px;'>a</span>"
#> 
#> $extra
#> [1] "<span style='background:#ff9800;color:white;padding:2px 6px;border-radius:4px;'>d</span>"
#> 
#> $x_missing_y
#> [1] "a"
#> 
#> $y_missing_x
#> [1] "d"
#> 
```
