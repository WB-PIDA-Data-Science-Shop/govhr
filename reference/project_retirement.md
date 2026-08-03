# Project Retirement Dates

Project Retirement Dates

## Usage

``` r
project_retirement(
  .data,
  threshold_age = 60,
  birth_col = "birth_date",
  group_cols = NULL,
  measure_col = NULL,
  retirement_coefficient = 0.6,
  simplify_retirement_date = TRUE,
  cutoff_date = 10
)
```

## Arguments

- .data:

  A data frame, either the workforce or wage bill data.

- threshold_age:

  The age at which personnel are considered eligible for retirement
  (default is 60).

- birth_col:

  The name of the column representing birth dates (default is
  "birth_date").

- group_cols:

  A character vector of column names to group the data by when counting
  eligible retirees (default is NULL, meaning no grouping).

- measure_col:

  The name of the column representing the measure to be projected
  (default is NULL, meaning no measure column).

- retirement_coefficient:

  A numeric value indicating the coefficient to apply to the projected
  retirement cost (default is 0.6).

- simplify_retirement_date:

  A logical value indicating whether to simplify the retirement date to
  the end of the year (default is TRUE).

- cutoff_date:

  A numeric value indicating the cut-off for future retirement
  projections in years (default is 10).

## Value

A data frame with projected retirement dates and counts of staff
eligible for retirement at each reference date.

## Details

The function takes a data frame containing personnel data with birth
dates and reference dates. It only considers the last reference date in
the data. It then calculates the projected retirement date for each
staff member based on the specified threshold age, and counts the number
of staff eligible for retirement at each future reference date.
