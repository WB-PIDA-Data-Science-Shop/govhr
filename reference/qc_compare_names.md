# Compare Dataset Variable Names Against a Dictionary

This internal function checks whether all required variable names
defined in a harmonization dictionary exist in a module dataset. It
returns differences in a user-specified output format.

## Usage

``` r
qc_compare_names(data, dict_names, output_format = "simple")
```

## Arguments

- data:

  A data.frame or data.table to check.

- dict_names:

  A character vector of variable names expected in the dataset.

- output_format:

  Output format for reporting differences. Options are `"simple"`,
  `"bullet"`, or `"badges"`.

## Value

A list containing:

- `missing_in_data`: Variables present in the dictionary but not in the
  dataset.

- `extra_in_data`: Variables in the dataset that are not in the
  dictionary.

- `formatted`: A formatted character output according to
  `output_format`.
