# Plot model coefficients with confidence intervals

Plot model coefficients with confidence intervals

## Usage

``` r
ggplot_coef(model, coef)
```

## Arguments

- model:

  A fitted model object (e.g., lm, glm).

- coef:

  A character string of coefficient name to plot. It can be a regular
  expression (e.g., "^term").

## Value

A ggplot object showing coefficients with error bars.

## Examples

``` r
if (FALSE) { # \dontrun{
  model <- lm(mpg ~ wt + hp, data = mtcars)
  ggplot_coef(model)
} # }
```
