# Count Unique Entities by Group

Count Unique Entities by Group

## Usage

``` r
count_entity(.data, id_col, group_cols = NULL)
```

## Arguments

- .data:

  Data frame containing the data.

- id_col:

  Character. Column name of the unique identifier for the entity.

- group_cols:

  Character vector of column names to group by, or \`NULL\` for no
  grouping.

## Value

A data frame with the grouping columns and a \`count\` column
representing the number of unique entities in each group.
