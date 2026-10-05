# Check that a table has the columns a function needs

Check that a table has the columns a function needs

## Usage

``` r
check_required_cols(data, required_cols, arg = "data")
```

## Arguments

- data:

  A data frame or lazy database table.

- required_cols:

  A character vector of column names `data` must have.

- arg:

  Character. Name of the argument holding `data`, used in the error
  message.

## Value

`data`, invisibly. Stops with an error listing the missing columns if
there are any.
