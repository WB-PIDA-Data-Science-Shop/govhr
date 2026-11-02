# Stop for data a function cannot handle

Used by the `.default` method of generics that accept a data frame or a
lazy database table, so unsupported input (a list, vector, matrix, ...)
gets an error that names the argument instead of R's "no applicable
method" message.

## Usage

``` r
stop_unsupported_data(x, arg = "data")
```

## Arguments

- x:

  The object that was passed.

- arg:

  Character. Name of the argument holding `x`, used in the error
  message.

## Value

Does not return; always stops with an error.
