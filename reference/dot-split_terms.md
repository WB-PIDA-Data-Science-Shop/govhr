# Split model terms into their covariate and level

fixest names a category's coefficient by pasting the column name and the
level (`genderM`), and a numeric covariate's by its name alone (`age`).
Used by
[`tidy.survival_model()`](https://wb-pida-data-science-shop.github.io/govhr/reference/tidy.survival_model.md)
to give each term its covariate and level.

## Usage

``` r
.split_terms(terms, covariate_cols)
```

## Arguments

- terms:

  Character vector of coefficient names.

- covariate_cols:

  Character vector of the model's covariates.

## Value

A list of two character vectors as long as `terms`: `covariate` (the
longest covariate name the term starts with, so `grade_bandB` is
`grade_band`, not `grade`) and `level` (the rest; `NA` for a numeric
covariate).
