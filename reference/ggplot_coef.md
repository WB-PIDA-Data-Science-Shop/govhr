# Plot model coefficients with confidence intervals

Plot model coefficients with confidence intervals

## Usage

``` r
ggplot_coef(model, coefs)
```

## Arguments

- model:

  A fitted model object (e.g., lm, glm).

- coefs:

  A character vector of coefficient names to plot.

## Value

A ggplot object showing coefficients with error bars.

## Examples

``` r
if (FALSE) { # \dontrun{
  model <- lm(mpg ~ wt + hp, data = mtcars)
  ggplot_coef(model)
} # }
```
