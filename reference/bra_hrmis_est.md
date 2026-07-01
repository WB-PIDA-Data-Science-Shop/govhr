# HRMIS Establishment Dataset

Harmonized establishment-level human resource management information
system (HRMIS) data for the State of Alagoas, Brazil. Each observation
represents a unique public sector establishment and contains
standardized establishment names, country identifiers, and functional
classifications.

## Usage

``` r
bra_hrmis_est
```

## Format

A data frame with 65 rows and 6 variables:

- est_name_native:

  Official establishment name in the native language (Portuguese).

- est_id:

  Unique identifier assigned to each establishment.

- country_code:

  Three-letter ISO 3166-1 alpha-3 country code following the World Bank
  convention (e.g., `"BRA"`).

- country_name:

  Official World Bank country name.

- est_name_en:

  Official establishment name translated into English.

- sector:

  Standardized Classification of the Functions of Government (COFOG)
  sector assigned to the establishment.

## Source

Government of the State of Alagoas Human Resource Management Information
System (HRMIS), harmonized by the GovHR project.

## Details

The dataset follows the GovHR establishment module data dictionary and
is intended to support organizational analysis, workforce reporting, and
aggregation of personnel and contract records.

This dataset is harmonized according to the GovHR establishment module
data dictionary. Establishment names are translated into English to
facilitate international comparative analysis. Each establishment is
assigned to one of the ten top-level COFOG functional sectors:

- General Public Services

- Defence

- Public Order and Safety

- Economic Affairs

- Environmental Protection

- Housing and Community Amenities

- Health

- Recreation, Culture and Religion

- Education

- Social Protection

## See also

[`bra_hrmis_contract`](https://wb-pida-data-science-shop.github.io/govhr/reference/bra_hrmis_contract.md),
[`bra_hrmis_personnel`](https://wb-pida-data-science-shop.github.io/govhr/reference/bra_hrmis_personnel.md)

## Examples

``` r
data(bra_hrmis_est)
head(bra_hrmis_est)
#> # A tibble: 6 × 6
#>   est_name_native            est_id country_code country_name est_name_en sector
#>   <chr>                      <chr>  <chr>        <chr>        <chr>       <chr> 
#> 1 AGENCIA DE DEFESA E INSPE… AGENC… BRA          Brazil       defense an… Defen…
#> 2 AGENCIA DE FOMENTO DE ALA… AGENC… BRA          Brazil       alagoas fo… Econo…
#> 3 AGENCIA DE HABITACAO E DE… AGENC… BRA          Brazil       al housing… Housi…
#> 4 AGENCIA DE MODERNIZACAO D… AGENC… BRA          Brazil       process ma… Gener…
#> 5 AGENCIA REGULADORA DE SER… AGENC… BRA          Brazil       public ser… Gener…
#> 6 ALAGOAS PREVIDENCIA        ALAGO… BRA          Brazil       alagoas pe… Socia…
```
