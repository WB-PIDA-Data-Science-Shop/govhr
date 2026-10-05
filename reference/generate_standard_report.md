# Generate the standard HR report

Produces an HTML or Word report with the standard workforce and wagebill
indicators: headcount, hires and separations, moves between
establishments, the wagebill and its growth, average wages, and the
composition and distribution of pay.

## Usage

``` r
generate_standard_report(
  contracts,
  personnel,
  establishment,
  binwidth = NULL,
  base_month = "2021-12-01",
  format = c("html", "docx"),
  output = paste0("standard_report.", format)
)
```

## Arguments

- contracts:

  Data frame or remote database table (`tbl_dbi`) with the contract
  data, one row per contract and reference date. Must contain
  `personnel_id`, `ref_date`, `est_id`, `gross_salary_lcu`,
  `base_salary_lcu` and `allowance_lcu`.

- personnel:

  Data frame or remote database table (`tbl_dbi`) with the personnel
  data. Must contain `personnel_id`, `ref_date` and `employment_status`.
  For database input, it must live in the same database as `contracts`.

- establishment:

  Data frame or remote database table (`tbl_dbi`) with the establishment
  data. Must contain `est_id` and `country_code`. For database input, it
  must live in the same database as `contracts`.

- binwidth:

  Positive whole number. Width of the pay bins in the wage distribution,
  in the same currency as the pay columns. Default `NULL` picks a width
  from the data. See
  [`compute_wagebill_analytics()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_wagebill_analytics.md).

- base_month:

  The month whose prices pay is expressed in, given as its first day.
  Default `"2021-12-01"`. See
  [`compute_wagebill_analytics()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_wagebill_analytics.md).

- format:

  Character. `"html"` (default) for an HTML report or `"docx"` for a
  Word document. In Word, the network of transitions is a static image
  rather than an interactive chart.

- output:

  Character. Path of the file to create. Default
  `"standard_report.html"` or `"standard_report.docx"`, depending on
  `format`, in the working directory.

## Value

The path to the report, invisibly.

## Details

The indicators are computed by
[`compute_workforce_analytics()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_workforce_analytics.md)
and
[`compute_wagebill_analytics()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_wagebill_analytics.md),
so the report shows the same numbers those functions return. Database
tables are processed in the database, and only the results are brought
into memory.

Only active personnel are counted: employment status comes from
`personnel` and is matched to `contracts` by `personnel_id` and
`ref_date`. Pay is converted to constant prices of `base_month` with
[`deflate_to_real()`](https://wb-pida-data-science-shop.github.io/govhr/reference/deflate_to_real.md),
using the country of each contract's establishment.

## Examples

``` r
if (FALSE) { # \dontrun{
generate_standard_report(
  contracts = bra_hrmis_contract,
  personnel = bra_hrmis_personnel,
  establishment = bra_hrmis_est,
  output = "brazil_report.html"
)

# the same report as a Word document
generate_standard_report(
  contracts = bra_hrmis_contract,
  personnel = bra_hrmis_personnel,
  establishment = bra_hrmis_est,
  format = "docx"
)
} # }
```
