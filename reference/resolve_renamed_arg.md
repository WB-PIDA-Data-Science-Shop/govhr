# Support a renamed argument for one deprecation cycle

Returns the value for the new argument, warning if the caller supplied
the old name instead. `old` defaults to `NULL` in the wrapping function,
so a non-`NULL` value means the caller explicitly passed the deprecated
argument.

## Usage

``` r
resolve_renamed_arg(new, old, old_name, new_name)
```

## Arguments

- new:

  The value of the new argument.

- old:

  The value of the deprecated argument.

- old_name, new_name:

  The names of the deprecated and new arguments, used in the messages.

## Value

`new` if `old` is `NULL`; otherwise `old`, with a deprecation warning.
An error if both were supplied.
