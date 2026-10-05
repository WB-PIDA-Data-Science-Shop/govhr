# Monthly consumer price index (CPI) by country

The monthly consumer price index (CPI) for all items, by country, from
the International Monetary Fund (IMF). A CPI tracks how the prices of
everyday goods and services change over time, so it can turn nominal
wages into real wages that are comparable across months and years. It is
the data underlying
[`deflate_to_real()`](https://wb-pida-data-science-shop.github.io/govhr/reference/deflate_to_real.md).

## Usage

``` r
cpi
```

## Format

A tibble with 66,742 rows and 5 columns, one row per country and month:

- ref_date:

  First day of the month the CPI refers to (`Date`).

- country_code:

  ISO3 country code.

- cpi:

  CPI rebased so that December 2021 = 100, or the closest available
  month for the 15 countries listed under Details.

- cpi_national:

  CPI as published by the IMF, relative to the country's own reference
  period (see `cpi_national_base_period`).

- cpi_national_base_period:

  Reference period of `cpi_national`, in IMF notation: `"2019M6"` means
  June 2019 = 100, `"2010A"` means the 2010 annual average = 100.

## Source

IMF Consumer Price Index (CPI) dataset, series `<country>.CPI._T.IX.M`
(all items, index, monthly), via the IMF SDMX 3.0 API:
<https://data.imf.org/>

## Details

Covers 191 countries. How far back each country's series goes varies,
and some countries have gaps. `cpi_national` uses a different reference
period in each country, while `cpi` puts every country on the same one
(December 2021), which makes inflation trends easier to compare side by
side. Within a single country, ratios of either column give the same
inflation rate.

**Countries with a different base month.** 15 countries report no CPI
for December 2021, mostly because their series stops earlier. For these,
`cpi` is rebased to the month closest to December 2021 instead (`cpi` =
100 in that month):

|                  |            |                              |            |
|------------------|------------|------------------------------|------------|
| Country          | Base month | Country                      | Base month |
| ABW (Aruba)      | 2020-02    | MTQ (Martinique)             | 2018-08    |
| AUS (Australia)  | 2024-04    | NCL (New Caledonia)          | 2017-01    |
| COD (DR Congo)   | 2017-02    | NRU (Nauru)                  | 2013-08    |
| CUW (Curacao)    | 2020-02    | SWZ (Eswatini)               | 2020-09    |
| GLP (Guadeloupe) | 2016-12    | SXM (Sint Maarten)           | 2017-12    |
| MMR (Myanmar)    | 2020-11    | SYR (Syria)                  | 2019-12    |
| VEN (Venezuela)  | 2016-12    | VGB (British Virgin Islands) | 2017-05    |
| YEM (Yemen)      | 2015-12    |                              |            |

Australia is the one country whose series starts after December 2021
rather than ending before it: the IMF's monthly series for Australia
begins in April 2024.

Because the base month differs, the level of `cpi` for these countries
is not directly comparable with other countries. Inflation between any
two months (the ratio of their `cpi` values) is unaffected, so
[`deflate_to_real()`](https://wb-pida-data-science-shop.github.io/govhr/reference/deflate_to_real.md)
works the same for every country.

To refresh the data, run `data-raw/cpi.R`.
