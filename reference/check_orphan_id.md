# Detect Orphan Records Between Parent and Child Modules

This internal function checks for referential integrity violations
between two datasets. It identifies child IDs that do not exist in the
parent module.

## Usage

``` r
check_orphan_id(parent_dt, child_dt, parent_id, child_id)
```

## Arguments

- parent_dt:

  A data.table representing the upstream (parent) dataset.

- child_dt:

  A data.table representing the downstream (child) dataset.

- parent_id:

  Name of the ID column in the parent dataset.

- child_id:

  Name of the ID column in the child dataset.

## Value

A list containing:

- `n_orphans`:

  Number of child IDs not found in the parent.

- `orphan_ids`:

  The vector of orphan IDs.
