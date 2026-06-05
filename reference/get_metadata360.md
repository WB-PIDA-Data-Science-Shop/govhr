# Retrieve dataset metadata from the World Bank Data360 API

This function queries the World Bank Data360 API to fetch metadata for a
specified dataset, identified by its \`dataset_id\`. It constructs the
request URL, retrieves the metadata in JSON format, and parses it into
an R list or data frame.

## Usage

``` r
get_metadata360(dataset_id)
```

## Arguments

- dataset_id:

  A character string or numeric identifier specifying the dataset for
  which metadata should be retrieved.

## Value

A list (or data frame) containing the metadata associated with the
requested dataset, as returned by the Data360 API.

## Examples

``` r
get_metadata360("WB_MPO")
#> $`@odata.context`
#> [1] "https://itsda-dataexp-prd.search.windows.net/indexes('data360-metadata')/$metadata#docs(*)"
#> 
#> $`@odata.count`
#> [1] 1
#> 
#> $value
#>   @search.score     id idno type subtype disaggregation_types isDelete cfPath
#> 1      5.679689 WB_MPO   NA   NA      NA                 NULL       NA     NA
#>   doc_type remove_chart_type data_confidentiality_code
#> 1       NA                NA                        NA
#>   data_confidentiality_name dsd_name dsd_version dsd_codelist is_active
#> 1                        NA       NA          NA         NULL        NA
#>   metadata_information series_description tags additional product
#> 1                   NA                 NA NULL         NA      NA
#>   disaggregation_codes admin_metadata
#> 1                 NULL             NA
#> 
```
