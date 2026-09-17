# Retrieve dataset metadata from the World Bank Data360 API

This function queries the World Bank Data360 API to fetch metadata for a
specified dataset, identified by its `dataset_id`. It constructs the
request URL, retrieves the metadata in JSON format, and parses it into
an R list or data frame.

## Usage

``` r
get_metadata360(dataset_id)
```

## Arguments

- dataset_id:

  A string or numeric identifier specifying the dataset for which
  metadata should be retrieved.

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
#> [1] 34
#> 
#> $value
#>    @search.score               id                                 idno
#> 1       40.99419  META_MP_PJ_POV1 af08c7a1-873d-415a-8cdb-2656b859e9a6
#> 2       39.73193   META_GGDBTTOTL 150f9817-21ce-425b-9e0a-84a126800234
#> 3       36.38148   META_NEGDIFTOT f2bd3acf-3cc3-44eb-9ef7-efda0bdfee62
#> 4       36.28261   META_BFCAFFFDI 8f5c7b62-ce7a-49b8-92c3-fc1fe7e64494
#> 5       36.00066   META_FPCPITOTL 439d46fe-8e6a-48c2-a3b0-93dbcebba565
#> 6       36.00066   META_GGEXPTOTL 045d144c-8dee-428d-bcc0-b069bfaf2f79
#> 7       35.33838   META_BFCAFTOTL b4d324f5-75bc-47d2-aa83-93362aa9d539
#> 8       35.33838   META_GGBALOVRL 859e8798-f252-4835-88b8-641859334fc2
#> 9       34.93404  META_MP_PJ_POV2 038f91a4-373e-4518-8f30-c6fede87ce8e
#> 10      34.20327   META_NYGDPFCST e971d916-dd08-4319-bd12-fcf00500ac8e
#> 11      34.00194 META_FPCPITOTLXN 4c35692b-c581-48f1-b15c-a4aa91769a9b
#> 12      33.51028  META_MP_PJ_POV3 f726b67f-e51c-4467-9937-d79e3e3edcd2
#> 13      33.32766   META_GGREVTOTL 2a12a3d3-d968-4294-8ebe-abdf37d48f1a
#> 14      31.99641   META_NVINDTOTL 45fea94a-003b-40eb-94c3-83894800908c
#> 15      31.73319   META_GGEXPINTP 3a1a10f1-9576-4864-b37f-7472903343b3
#> 16      31.73319   META_NECONGOVT d414ecc7-c477-4328-91c6-759f3f0fd8cf
#> 17      31.73319   META_NEEXPGNFS 93b706e8-25a0-4151-89ba-e6e19c1029f7
#> 18      31.73319   META_NVAGRTOTL 8c60b15a-e28e-4b07-8344-4ca68e458aa9
#> 19      30.12572   META_BNCABFUND c51eaa5e-e1e7-40de-8eef-df8ab1f0e3de
#> 20      30.12572   META_NYGDPMKTP b40ec5aa-46b4-4236-8208-75ed056fc0b4
#> 21      29.43051   META_ENATMCO2E 67f559f9-baf2-437e-9357-0c521be02fa9
#> 22      29.43051   META_ENTOTGHGE 4e9229ec-6825-46d3-9696-b47ee5236497
#> 23      29.25863   META_ENENRGHGE ac596a77-81b6-4c85-9bd4-88333895b0eb
#> 24      29.25863   META_NECONPRVT eb28a228-e24c-4c85-a8f0-a2341ce1f653
#> 25      29.25863   META_SPPOPTOTL a4707329-948b-4afa-bdd5-80d3fc5f44ae
#> 26      28.41989     META_NYGDPPC 80ca1711-e306-4de6-abc7-bd2b0ef397b6
#> 27      28.08238   META_GGBALPRIM 7a5b5994-5d58-4f84-b9dd-745d47d41b94
#> 28      28.08238   META_NEIMPGNFS fdf4269f-a74c-492e-8839-8c08097f578c
#> 29      26.74964           WB_MPO 16ffd22e-c3b6-477d-bb16-45c423263eb0
#> 30      26.53360   META_NVSRVTOTL 61b904f5-3524-44bd-90dc-359483e13a21
#> 31      26.53360 META_NYGDPMKTPXN e07a12b9-2a47-4d28-bd55-f5324cd4d521
#> 32      25.23259   META_CONPRVTPC 0cf71f79-f85f-427f-81d0-9977a81b0e94
#> 33      25.23259 META_NECONPRVTXN 33dc17d0-7388-425d-b668-747e98219bde
#> 34      25.23259  META_NEGDIFTOTK 3c05b471-da76-4f75-b873-51fa9ba29e20
#>         type    subtype                  disaggregation_types isDelete cfPath
#> 1  indicator timeseries                               Vintage       NA     NA
#> 2  indicator timeseries              Vintage, Unit of measure       NA     NA
#> 3  indicator timeseries Price Basis, Vintage, Unit of measure       NA     NA
#> 4  indicator timeseries              Vintage, Unit of measure       NA     NA
#> 5  indicator timeseries                               Vintage       NA     NA
#> 6  indicator timeseries                               Vintage       NA     NA
#> 7  indicator timeseries                               Vintage       NA     NA
#> 8  indicator timeseries              Vintage, Unit of measure       NA     NA
#> 9  indicator timeseries                               Vintage       NA     NA
#> 10 indicator timeseries Price Basis, Vintage, Unit of measure       NA     NA
#> 11 indicator timeseries                               Vintage       NA     NA
#> 12 indicator timeseries                               Vintage       NA     NA
#> 13 indicator timeseries                               Vintage       NA     NA
#> 14 indicator timeseries Price Basis, Vintage, Unit of measure       NA     NA
#> 15 indicator timeseries                               Vintage       NA     NA
#> 16 indicator timeseries Price Basis, Vintage, Unit of measure       NA     NA
#> 17 indicator timeseries Price Basis, Vintage, Unit of measure       NA     NA
#> 18 indicator timeseries Price Basis, Vintage, Unit of measure       NA     NA
#> 19 indicator timeseries              Vintage, Unit of measure       NA     NA
#> 20 indicator timeseries Price Basis, Vintage, Unit of measure       NA     NA
#> 21 indicator timeseries                               Vintage       NA     NA
#> 22 indicator timeseries              Vintage, Unit of measure       NA     NA
#> 23 indicator timeseries              Vintage, Unit of measure       NA     NA
#> 24 indicator timeseries Price Basis, Vintage, Unit of measure       NA     NA
#> 25 indicator timeseries                               Vintage       NA     NA
#> 26 indicator timeseries              Vintage, Unit of measure       NA     NA
#> 27 indicator timeseries              Vintage, Unit of measure       NA     NA
#> 28 indicator timeseries Price Basis, Vintage, Unit of measure       NA     NA
#> 29   dataset       <NA>                                             NA     NA
#> 30 indicator timeseries Price Basis, Vintage, Unit of measure       NA     NA
#> 31 indicator timeseries                               Vintage       NA     NA
#> 32 indicator timeseries              Vintage, Unit of measure       NA     NA
#> 33 indicator timeseries                               Vintage       NA     NA
#> 34 indicator timeseries                               Vintage       NA     NA
#>    doc_type    remove_chart_type data_confidentiality_code
#> 1        NA      stackedBar, pie                        PU
#> 2        NA      stackedBar, pie                        PU
#> 3        NA stackedBar, pie, map                        PU
#> 4        NA      stackedBar, pie                        PU
#> 5        NA      stackedBar, pie                        PU
#> 6        NA      stackedBar, pie                        PU
#> 7        NA      stackedBar, pie                        PU
#> 8        NA      stackedBar, pie                        PU
#> 9        NA      stackedBar, pie                        PU
#> 10       NA      stackedBar, pie                        PU
#> 11       NA      stackedBar, pie                        PU
#> 12       NA      stackedBar, pie                        PU
#> 13       NA      stackedBar, pie                        PU
#> 14       NA stackedBar, pie, map                        PU
#> 15       NA stackedBar, pie, map                        PU
#> 16       NA stackedBar, pie, map                        PU
#> 17       NA stackedBar, pie, map                        PU
#> 18       NA stackedBar, pie, map                        PU
#> 19       NA      stackedBar, pie                        PU
#> 20       NA      stackedBar, pie                        PU
#> 21       NA      stackedBar, pie                        PU
#> 22       NA      stackedBar, pie                        PU
#> 23       NA      stackedBar, pie                        PU
#> 24       NA stackedBar, pie, map                        PU
#> 25       NA      stackedBar, pie                        PU
#> 26       NA      stackedBar, pie                        PU
#> 27       NA      stackedBar, pie                        PU
#> 28       NA stackedBar, pie, map                        PU
#> 29       NA                 <NA>                        PU
#> 30       NA stackedBar, pie, map                        PU
#> 31       NA stackedBar, pie, map                        PU
#> 32       NA      stackedBar, pie                        PU
#> 33       NA      stackedBar, pie                        PU
#> 34       NA      stackedBar, pie                        PU
#>    data_confidentiality_name dsd_name dsd_version
#> 1                     Public   DS_MPO       1.0.0
#> 2                     Public   DS_MPO       1.0.0
#> 3                     Public   DS_MPO       1.0.0
#> 4                     Public   DS_MPO       1.0.0
#> 5                     Public   DS_MPO       1.0.0
#> 6                     Public   DS_MPO       1.0.0
#> 7                     Public   DS_MPO       1.0.0
#> 8                     Public   DS_MPO       1.0.0
#> 9                     Public   DS_MPO       1.0.0
#> 10                    Public   DS_MPO       1.0.0
#> 11                    Public   DS_MPO       1.0.0
#> 12                    Public   DS_MPO       1.0.0
#> 13                    Public   DS_MPO       1.0.0
#> 14                    Public   DS_MPO       1.0.0
#> 15                    Public   DS_MPO       1.0.0
#> 16                    Public   DS_MPO       1.0.0
#> 17                    Public   DS_MPO       1.0.0
#> 18                    Public   DS_MPO       1.0.0
#> 19                    Public   DS_MPO       1.0.0
#> 20                    Public   DS_MPO       1.0.0
#> 21                    Public   DS_MPO       1.0.0
#> 22                    Public   DS_MPO       1.0.0
#> 23                    Public   DS_MPO       1.0.0
#> 24                    Public   DS_MPO       1.0.0
#> 25                    Public   DS_MPO       1.0.0
#> 26                    Public   DS_MPO       1.0.0
#> 27                    Public   DS_MPO       1.0.0
#> 28                    Public   DS_MPO       1.0.0
#> 29                    Public     <NA>        <NA>
#> 30                    Public   DS_MPO       1.0.0
#> 31                    Public   DS_MPO       1.0.0
#> 32                    Public   DS_MPO       1.0.0
#> 33                    Public   DS_MPO       1.0.0
#> 34                    Public   DS_MPO       1.0.0
#>                                                                                                                                                 dsd_codelist
#> 1  DATABASE_ID, INDICATOR, VINTAGE, AGG_METHOD, TIME_FORMAT, REF_AREA, FREQ, UNIT_MEASURE, OBS_STATUS, PRICE_BASIS, OBS_CONF, UNIT_MULT, UNIT_TYPE, DECIMALS
#> 2  DATABASE_ID, INDICATOR, VINTAGE, AGG_METHOD, TIME_FORMAT, REF_AREA, FREQ, UNIT_MEASURE, OBS_STATUS, PRICE_BASIS, OBS_CONF, UNIT_MULT, UNIT_TYPE, DECIMALS
#> 3  DATABASE_ID, INDICATOR, VINTAGE, AGG_METHOD, TIME_FORMAT, REF_AREA, FREQ, UNIT_MEASURE, OBS_STATUS, PRICE_BASIS, OBS_CONF, UNIT_MULT, UNIT_TYPE, DECIMALS
#> 4  DATABASE_ID, INDICATOR, VINTAGE, AGG_METHOD, TIME_FORMAT, REF_AREA, FREQ, UNIT_MEASURE, OBS_STATUS, PRICE_BASIS, OBS_CONF, UNIT_MULT, UNIT_TYPE, DECIMALS
#> 5  DATABASE_ID, INDICATOR, VINTAGE, AGG_METHOD, TIME_FORMAT, REF_AREA, FREQ, UNIT_MEASURE, OBS_STATUS, PRICE_BASIS, OBS_CONF, UNIT_MULT, UNIT_TYPE, DECIMALS
#> 6  DATABASE_ID, INDICATOR, VINTAGE, AGG_METHOD, TIME_FORMAT, REF_AREA, FREQ, UNIT_MEASURE, OBS_STATUS, PRICE_BASIS, OBS_CONF, UNIT_MULT, UNIT_TYPE, DECIMALS
#> 7  DATABASE_ID, INDICATOR, VINTAGE, AGG_METHOD, TIME_FORMAT, REF_AREA, FREQ, UNIT_MEASURE, OBS_STATUS, PRICE_BASIS, OBS_CONF, UNIT_MULT, UNIT_TYPE, DECIMALS
#> 8  DATABASE_ID, INDICATOR, VINTAGE, AGG_METHOD, TIME_FORMAT, REF_AREA, FREQ, UNIT_MEASURE, OBS_STATUS, PRICE_BASIS, OBS_CONF, UNIT_MULT, UNIT_TYPE, DECIMALS
#> 9  DATABASE_ID, INDICATOR, VINTAGE, AGG_METHOD, TIME_FORMAT, REF_AREA, FREQ, UNIT_MEASURE, OBS_STATUS, PRICE_BASIS, OBS_CONF, UNIT_MULT, UNIT_TYPE, DECIMALS
#> 10 DATABASE_ID, INDICATOR, VINTAGE, AGG_METHOD, TIME_FORMAT, REF_AREA, FREQ, UNIT_MEASURE, OBS_STATUS, PRICE_BASIS, OBS_CONF, UNIT_MULT, UNIT_TYPE, DECIMALS
#> 11 DATABASE_ID, INDICATOR, VINTAGE, AGG_METHOD, TIME_FORMAT, REF_AREA, FREQ, UNIT_MEASURE, OBS_STATUS, PRICE_BASIS, OBS_CONF, UNIT_MULT, UNIT_TYPE, DECIMALS
#> 12 DATABASE_ID, INDICATOR, VINTAGE, AGG_METHOD, TIME_FORMAT, REF_AREA, FREQ, UNIT_MEASURE, OBS_STATUS, PRICE_BASIS, OBS_CONF, UNIT_MULT, UNIT_TYPE, DECIMALS
#> 13 DATABASE_ID, INDICATOR, VINTAGE, AGG_METHOD, TIME_FORMAT, REF_AREA, FREQ, UNIT_MEASURE, OBS_STATUS, PRICE_BASIS, OBS_CONF, UNIT_MULT, UNIT_TYPE, DECIMALS
#> 14 DATABASE_ID, INDICATOR, VINTAGE, AGG_METHOD, TIME_FORMAT, REF_AREA, FREQ, UNIT_MEASURE, OBS_STATUS, PRICE_BASIS, OBS_CONF, UNIT_MULT, UNIT_TYPE, DECIMALS
#> 15 DATABASE_ID, INDICATOR, VINTAGE, AGG_METHOD, TIME_FORMAT, REF_AREA, FREQ, UNIT_MEASURE, OBS_STATUS, PRICE_BASIS, OBS_CONF, UNIT_MULT, UNIT_TYPE, DECIMALS
#> 16 DATABASE_ID, INDICATOR, VINTAGE, AGG_METHOD, TIME_FORMAT, REF_AREA, FREQ, UNIT_MEASURE, OBS_STATUS, PRICE_BASIS, OBS_CONF, UNIT_MULT, UNIT_TYPE, DECIMALS
#> 17 DATABASE_ID, INDICATOR, VINTAGE, AGG_METHOD, TIME_FORMAT, REF_AREA, FREQ, UNIT_MEASURE, OBS_STATUS, PRICE_BASIS, OBS_CONF, UNIT_MULT, UNIT_TYPE, DECIMALS
#> 18 DATABASE_ID, INDICATOR, VINTAGE, AGG_METHOD, TIME_FORMAT, REF_AREA, FREQ, UNIT_MEASURE, OBS_STATUS, PRICE_BASIS, OBS_CONF, UNIT_MULT, UNIT_TYPE, DECIMALS
#> 19 DATABASE_ID, INDICATOR, VINTAGE, AGG_METHOD, TIME_FORMAT, REF_AREA, FREQ, UNIT_MEASURE, OBS_STATUS, PRICE_BASIS, OBS_CONF, UNIT_MULT, UNIT_TYPE, DECIMALS
#> 20 DATABASE_ID, INDICATOR, VINTAGE, AGG_METHOD, TIME_FORMAT, REF_AREA, FREQ, UNIT_MEASURE, OBS_STATUS, PRICE_BASIS, OBS_CONF, UNIT_MULT, UNIT_TYPE, DECIMALS
#> 21 DATABASE_ID, INDICATOR, VINTAGE, AGG_METHOD, TIME_FORMAT, REF_AREA, FREQ, UNIT_MEASURE, OBS_STATUS, PRICE_BASIS, OBS_CONF, UNIT_MULT, UNIT_TYPE, DECIMALS
#> 22 DATABASE_ID, INDICATOR, VINTAGE, AGG_METHOD, TIME_FORMAT, REF_AREA, FREQ, UNIT_MEASURE, OBS_STATUS, PRICE_BASIS, OBS_CONF, UNIT_MULT, UNIT_TYPE, DECIMALS
#> 23 DATABASE_ID, INDICATOR, VINTAGE, AGG_METHOD, TIME_FORMAT, REF_AREA, FREQ, UNIT_MEASURE, OBS_STATUS, PRICE_BASIS, OBS_CONF, UNIT_MULT, UNIT_TYPE, DECIMALS
#> 24 DATABASE_ID, INDICATOR, VINTAGE, AGG_METHOD, TIME_FORMAT, REF_AREA, FREQ, UNIT_MEASURE, OBS_STATUS, PRICE_BASIS, OBS_CONF, UNIT_MULT, UNIT_TYPE, DECIMALS
#> 25 DATABASE_ID, INDICATOR, VINTAGE, AGG_METHOD, TIME_FORMAT, REF_AREA, FREQ, UNIT_MEASURE, OBS_STATUS, PRICE_BASIS, OBS_CONF, UNIT_MULT, UNIT_TYPE, DECIMALS
#> 26 DATABASE_ID, INDICATOR, VINTAGE, AGG_METHOD, TIME_FORMAT, REF_AREA, FREQ, UNIT_MEASURE, OBS_STATUS, PRICE_BASIS, OBS_CONF, UNIT_MULT, UNIT_TYPE, DECIMALS
#> 27 DATABASE_ID, INDICATOR, VINTAGE, AGG_METHOD, TIME_FORMAT, REF_AREA, FREQ, UNIT_MEASURE, OBS_STATUS, PRICE_BASIS, OBS_CONF, UNIT_MULT, UNIT_TYPE, DECIMALS
#> 28 DATABASE_ID, INDICATOR, VINTAGE, AGG_METHOD, TIME_FORMAT, REF_AREA, FREQ, UNIT_MEASURE, OBS_STATUS, PRICE_BASIS, OBS_CONF, UNIT_MULT, UNIT_TYPE, DECIMALS
#> 29                                                                                                                                                          
#> 30 DATABASE_ID, INDICATOR, VINTAGE, AGG_METHOD, TIME_FORMAT, REF_AREA, FREQ, UNIT_MEASURE, OBS_STATUS, PRICE_BASIS, OBS_CONF, UNIT_MULT, UNIT_TYPE, DECIMALS
#> 31 DATABASE_ID, INDICATOR, VINTAGE, AGG_METHOD, TIME_FORMAT, REF_AREA, FREQ, UNIT_MEASURE, OBS_STATUS, PRICE_BASIS, OBS_CONF, UNIT_MULT, UNIT_TYPE, DECIMALS
#> 32 DATABASE_ID, INDICATOR, VINTAGE, AGG_METHOD, TIME_FORMAT, REF_AREA, FREQ, UNIT_MEASURE, OBS_STATUS, PRICE_BASIS, OBS_CONF, UNIT_MULT, UNIT_TYPE, DECIMALS
#> 33 DATABASE_ID, INDICATOR, VINTAGE, AGG_METHOD, TIME_FORMAT, REF_AREA, FREQ, UNIT_MEASURE, OBS_STATUS, PRICE_BASIS, OBS_CONF, UNIT_MULT, UNIT_TYPE, DECIMALS
#> 34 DATABASE_ID, INDICATOR, VINTAGE, AGG_METHOD, TIME_FORMAT, REF_AREA, FREQ, UNIT_MEASURE, OBS_STATUS, PRICE_BASIS, OBS_CONF, UNIT_MULT, UNIT_TYPE, DECIMALS
#>    is_active
#> 1         NA
#> 2         NA
#> 3         NA
#> 4         NA
#> 5         NA
#> 6         NA
#> 7         NA
#> 8         NA
#> 9         NA
#> 10        NA
#> 11        NA
#> 12        NA
#> 13        NA
#> 14        NA
#> 15        NA
#> 16        NA
#> 17        NA
#> 18        NA
#> 19        NA
#> 20        NA
#> 21        NA
#> 22        NA
#> 23        NA
#> 24        NA
#> 25        NA
#> 26        NA
#> 27        NA
#> 28        NA
#> 29        NA
#> 30        NA
#> 31        NA
#> 32        NA
#> 33        NA
#> 34        NA
#>                                                            metadata_information.title
#> 1        Metadata for International poverty rate ($2.15 in 2017 PPP), MPO projections
#> 2                                          Metadata for General Government Debt Stock
#> 3                                                 Metadata for Gross Fixed Investment
#> 4                                  Metadata for Net Foreign Direct Investment Outflow
#> 5                                                         Metadata for Inflation Rate
#> 6                                                      Metadata for Total Expenditure
#> 7                                  Metadata for Capital and Financial Account Balance
#> 8                                                 Metadata for Overall Fiscal Balance
#> 9  Metadata for Lower middle-income poverty rate ($3.65 in 2017 PPP), MPO projections
#> 10                           Metadata for Gross Domestic Product (GDP) at Factor Cost
#> 11                               Metadata for Consumer Price Index, Implicit Deflator
#> 12 Metadata for Upper middle-income poverty rate ($6.85 in 2017 PPP), MPO projections
#> 13                                              Metadata for Total Revenue and Grants
#> 14                                                 Metadata for Industry, Value Added
#> 15                                                     Metadata for Interest Payments
#> 16                                                Metadata for Government Consumption
#> 17                          Metadata for Goods and Non-Factor Services (GNFS) Exports
#> 18                                              Metadata for Agriculture, Value Added
#> 19                                               Metadata for Current Account Balance
#> 20                          Metadata for Gross Domestic Product (GDP) at Market Price
#> 21                                        Metadata for Emissions: Total CO2 emissions
#> 22                                        Metadata for Emissions: Total GHG emissions
#> 23                         Metadata for Emissions: Energy, fuel combustion activities
#> 24                                                   Metadata for Private Consumption
#> 25                                           Metadata for Population, MPO Projections
#> 26                                        Metadata for GDP per capita at Market Price
#> 27                                                Metadata for Primary Fiscal Balance
#> 28                          Metadata for Goods and Non-Factor Services (GNFS) Imports
#> 29                                                              Macro Poverty Outlook
#> 30                                                 Metadata for Services, Value Added
#> 31       Metadata for Gross Domestic Product (GDP) at Market Price, Implicit Deflator
#> 32                                        Metadata for Private Consumption per capita
#> 33                                Metadata for Private Consumption, Implicit Deflator
#> 34                           Metadata for Gross Fixed Investment as percentage of GDP
#>               metadata_information.idno metadata_information.prod_date
#> 1                       META_MP_PJ_POV1                     2024-07-02
#> 2                        META_GGDBTTOTL                     2024-07-02
#> 3                        META_NEGDIFTOT                     2024-07-02
#> 4                        META_BFCAFFFDI                     2024-07-02
#> 5                        META_FPCPITOTL                     2024-07-02
#> 6                        META_GGEXPTOTL                     2024-07-02
#> 7                        META_BFCAFTOTL                     2024-07-02
#> 8                        META_GGBALOVRL                     2024-07-02
#> 9                       META_MP_PJ_POV2                     2024-07-02
#> 10                       META_NYGDPFCST                     2024-07-02
#> 11                     META_FPCPITOTLXN                     2024-07-02
#> 12                      META_MP_PJ_POV3                     2024-07-02
#> 13                       META_GGREVTOTL                     2024-07-02
#> 14                       META_NVINDTOTL                     2024-07-02
#> 15                       META_GGEXPINTP                     2024-07-02
#> 16                       META_NECONGOVT                     2024-07-02
#> 17                       META_NEEXPGNFS                     2024-07-02
#> 18                       META_NVAGRTOTL                     2024-07-02
#> 19                       META_BNCABFUND                     2024-07-02
#> 20                       META_NYGDPMKTP                     2024-07-02
#> 21                       META_ENATMCO2E                     2024-07-02
#> 22                       META_ENTOTGHGE                     2024-07-02
#> 23                       META_ENENRGHGE                     2024-07-02
#> 24                       META_NECONPRVT                     2024-07-02
#> 25                       META_SPPOPTOTL                     2024-07-02
#> 26                         META_NYGDPPC                     2024-07-02
#> 27                       META_GGBALPRIM                     2024-07-02
#> 28                       META_NEIMPGNFS                     2024-07-02
#> 29 16ffd22e-c3b6-477d-bb16-45c423263eb0                           <NA>
#> 30                       META_NVSRVTOTL                     2024-07-02
#> 31                     META_NYGDPMKTPXN                     2024-07-02
#> 32                       META_CONPRVTPC                     2024-07-02
#> 33                     META_NECONPRVTXN                     2024-07-02
#> 34                      META_NEGDIFTOTK                     2024-07-02
#>    metadata_information.version_statement.version
#> 1                                            <NA>
#> 2                                            <NA>
#> 3                                            <NA>
#> 4                                            <NA>
#> 5                                            <NA>
#> 6                                             1.1
#> 7                                            <NA>
#> 8                                            <NA>
#> 9                                            <NA>
#> 10                                           <NA>
#> 11                                           <NA>
#> 12                                           <NA>
#> 13                                           <NA>
#> 14                                           <NA>
#> 15                                           <NA>
#> 16                                           <NA>
#> 17                                           <NA>
#> 18                                           <NA>
#> 19                                           <NA>
#> 20                                           <NA>
#> 21                                           <NA>
#> 22                                           <NA>
#> 23                                           <NA>
#> 24                                           <NA>
#> 25                                           <NA>
#> 26                                           <NA>
#> 27                                           <NA>
#> 28                                           <NA>
#> 29                                           <NA>
#> 30                                           <NA>
#> 31                                           <NA>
#> 32                                           <NA>
#> 33                                           <NA>
#> 34                                           <NA>
#>    metadata_information.version_statement.version_date
#> 1                                           2026-09-16
#> 2                                           2026-09-16
#> 3                                           2026-09-16
#> 4                                           2026-09-16
#> 5                                           2026-09-16
#> 6                                           2026-09-16
#> 7                                           2026-09-16
#> 8                                           2026-09-16
#> 9                                           2026-09-16
#> 10                                          2026-09-16
#> 11                                          2026-09-16
#> 12                                          2026-09-16
#> 13                                          2026-09-16
#> 14                                          2026-09-16
#> 15                                          2026-09-16
#> 16                                          2026-09-16
#> 17                                          2026-09-16
#> 18                                          2026-09-16
#> 19                                          2026-09-16
#> 20                                          2026-09-16
#> 21                                          2026-09-16
#> 22                                          2026-09-16
#> 23                                          2026-09-16
#> 24                                          2026-09-16
#> 25                                          2026-09-16
#> 26                                          2026-09-16
#> 27                                          2026-09-16
#> 28                                          2026-09-16
#> 29                                                <NA>
#> 30                                          2026-09-16
#> 31                                          2026-09-16
#> 32                                          2026-09-16
#> 33                                          2026-09-16
#> 34                                          2026-09-16
#>    metadata_information.version_statement.version_resp
#> 1                                                   NA
#> 2                                                   NA
#> 3                                                   NA
#> 4                                                   NA
#> 5                                                   NA
#> 6                                                   NA
#> 7                                                   NA
#> 8                                                   NA
#> 9                                                   NA
#> 10                                                  NA
#> 11                                                  NA
#> 12                                                  NA
#> 13                                                  NA
#> 14                                                  NA
#> 15                                                  NA
#> 16                                                  NA
#> 17                                                  NA
#> 18                                                  NA
#> 19                                                  NA
#> 20                                                  NA
#> 21                                                  NA
#> 22                                                  NA
#> 23                                                  NA
#> 24                                                  NA
#> 25                                                  NA
#> 26                                                  NA
#> 27                                                  NA
#> 28                                                  NA
#> 29                                                  NA
#> 30                                                  NA
#> 31                                                  NA
#> 32                                                  NA
#> 33                                                  NA
#> 34                                                  NA
#>         metadata_information.version_statement.version_notes
#> 1  Metadata updated by automated Data360 publishing pipeline
#> 2  Metadata updated by automated Data360 publishing pipeline
#> 3  Metadata updated by automated Data360 publishing pipeline
#> 4  Metadata updated by automated Data360 publishing pipeline
#> 5  Metadata updated by automated Data360 publishing pipeline
#> 6  Metadata updated by automated Data360 publishing pipeline
#> 7  Metadata updated by automated Data360 publishing pipeline
#> 8  Metadata updated by automated Data360 publishing pipeline
#> 9  Metadata updated by automated Data360 publishing pipeline
#> 10 Metadata updated by automated Data360 publishing pipeline
#> 11 Metadata updated by automated Data360 publishing pipeline
#> 12 Metadata updated by automated Data360 publishing pipeline
#> 13 Metadata updated by automated Data360 publishing pipeline
#> 14 Metadata updated by automated Data360 publishing pipeline
#> 15 Metadata updated by automated Data360 publishing pipeline
#> 16 Metadata updated by automated Data360 publishing pipeline
#> 17 Metadata updated by automated Data360 publishing pipeline
#> 18 Metadata updated by automated Data360 publishing pipeline
#> 19 Metadata updated by automated Data360 publishing pipeline
#> 20 Metadata updated by automated Data360 publishing pipeline
#> 21 Metadata updated by automated Data360 publishing pipeline
#> 22 Metadata updated by automated Data360 publishing pipeline
#> 23 Metadata updated by automated Data360 publishing pipeline
#> 24 Metadata updated by automated Data360 publishing pipeline
#> 25 Metadata updated by automated Data360 publishing pipeline
#> 26 Metadata updated by automated Data360 publishing pipeline
#> 27 Metadata updated by automated Data360 publishing pipeline
#> 28 Metadata updated by automated Data360 publishing pipeline
#> 29                                                      <NA>
#> 30 Metadata updated by automated Data360 publishing pipeline
#> 31 Metadata updated by automated Data360 publishing pipeline
#> 32 Metadata updated by automated Data360 publishing pipeline
#> 33 Metadata updated by automated Data360 publishing pipeline
#> 34 Metadata updated by automated Data360 publishing pipeline
#>                             metadata_information.producers
#> 1  Development Economics Data Group, DECDG, World Bank, NA
#> 2  Development Economics Data Group, DECDG, World Bank, NA
#> 3  Development Economics Data Group, DECDG, World Bank, NA
#> 4  Development Economics Data Group, DECDG, World Bank, NA
#> 5  Development Economics Data Group, DECDG, World Bank, NA
#> 6  Development Economics Data Group, DECDG, World Bank, NA
#> 7  Development Economics Data Group, DECDG, World Bank, NA
#> 8  Development Economics Data Group, DECDG, World Bank, NA
#> 9  Development Economics Data Group, DECDG, World Bank, NA
#> 10 Development Economics Data Group, DECDG, World Bank, NA
#> 11 Development Economics Data Group, DECDG, World Bank, NA
#> 12 Development Economics Data Group, DECDG, World Bank, NA
#> 13 Development Economics Data Group, DECDG, World Bank, NA
#> 14 Development Economics Data Group, DECDG, World Bank, NA
#> 15 Development Economics Data Group, DECDG, World Bank, NA
#> 16 Development Economics Data Group, DECDG, World Bank, NA
#> 17 Development Economics Data Group, DECDG, World Bank, NA
#> 18 Development Economics Data Group, DECDG, World Bank, NA
#> 19 Development Economics Data Group, DECDG, World Bank, NA
#> 20 Development Economics Data Group, DECDG, World Bank, NA
#> 21 Development Economics Data Group, DECDG, World Bank, NA
#> 22 Development Economics Data Group, DECDG, World Bank, NA
#> 23 Development Economics Data Group, DECDG, World Bank, NA
#> 24 Development Economics Data Group, DECDG, World Bank, NA
#> 25 Development Economics Data Group, DECDG, World Bank, NA
#> 26 Development Economics Data Group, DECDG, World Bank, NA
#> 27 Development Economics Data Group, DECDG, World Bank, NA
#> 28 Development Economics Data Group, DECDG, World Bank, NA
#> 29                                                    NULL
#> 30 Development Economics Data Group, DECDG, World Bank, NA
#> 31 Development Economics Data Group, DECDG, World Bank, NA
#> 32 Development Economics Data Group, DECDG, World Bank, NA
#> 33 Development Economics Data Group, DECDG, World Bank, NA
#> 34 Development Economics Data Group, DECDG, World Bank, NA
#>    series_description.idno series_description.doi
#> 1               MP_PJ_POV1                     NA
#> 2                GGDBTTOTL                     NA
#> 3                NEGDIFTOT                     NA
#> 4                BFCAFFFDI                     NA
#> 5                FPCPITOTL                     NA
#> 6                GGEXPTOTL                     NA
#> 7                BFCAFTOTL                     NA
#> 8                GGBALOVRL                     NA
#> 9               MP_PJ_POV2                     NA
#> 10               NYGDPFCST                     NA
#> 11             FPCPITOTLXN                     NA
#> 12              MP_PJ_POV3                     NA
#> 13               GGREVTOTL                     NA
#> 14               NVINDTOTL                     NA
#> 15               GGEXPINTP                     NA
#> 16               NECONGOVT                     NA
#> 17               NEEXPGNFS                     NA
#> 18               NVAGRTOTL                     NA
#> 19               BNCABFUND                     NA
#> 20               NYGDPMKTP                     NA
#> 21               ENATMCO2E                     NA
#> 22               ENTOTGHGE                     NA
#> 23               ENENRGHGE                     NA
#> 24               NECONPRVT                     NA
#> 25               SPPOPTOTL                     NA
#> 26                 NYGDPPC                     NA
#> 27               GGBALPRIM                     NA
#> 28               NEIMPGNFS                     NA
#> 29                    <NA>                     NA
#> 30               NVSRVTOTL                     NA
#> 31             NYGDPMKTPXN                     NA
#> 32               CONPRVTPC                     NA
#> 33             NECONPRVTXN                     NA
#> 34              NEGDIFTOTK                     NA
#>                                                  series_description.name
#> 1        International poverty rate ($2.15 in 2017 PPP), MPO projections
#> 2                                          General Government Debt Stock
#> 3                                                 Gross Fixed Investment
#> 4                                  Net Foreign Direct Investment Outflow
#> 5                                                         Inflation Rate
#> 6                                                      Total Expenditure
#> 7                                  Capital and Financial Account Balance
#> 8                                                 Overall Fiscal Balance
#> 9  Lower middle-income poverty rate ($3.65 in 2017 PPP), MPO projections
#> 10                           Gross Domestic Product (GDP) at Factor Cost
#> 11                               Consumer Price Index, Implicit Deflator
#> 12 Upper middle-income poverty rate ($6.85 in 2017 PPP), MPO projections
#> 13                                              Total Revenue and Grants
#> 14                                                 Industry, Value Added
#> 15                                                     Interest Payments
#> 16                                                Government Consumption
#> 17                          Goods and Non-Factor Services (GNFS) Exports
#> 18                                              Agriculture, Value Added
#> 19                                               Current Account Balance
#> 20                          Gross Domestic Product (GDP) at Market Price
#> 21                                        Emissions: Total CO2 emissions
#> 22                                        Emissions: Total GHG emissions
#> 23                         Emissions: Energy, fuel combustion activities
#> 24                                                   Private Consumption
#> 25                                           Population, MPO Projections
#> 26                                        GDP per capita at Market Price
#> 27                                                Primary Fiscal Balance
#> 28                          Goods and Non-Factor Services (GNFS) Imports
#> 29                                                 Macro Poverty Outlook
#> 30                                                 Services, Value Added
#> 31       Gross Domestic Product (GDP) at Market Price, Implicit Deflator
#> 32                                        Private Consumption per capita
#> 33                                Private Consumption, Implicit Deflator
#> 34                           Gross Fixed Investment as percentage of GDP
#>    series_description.display_name series_description.database_id
#> 1                               NA                         WB_MPO
#> 2                               NA                         WB_MPO
#> 3                               NA                         WB_MPO
#> 4                               NA                         WB_MPO
#> 5                               NA                         WB_MPO
#> 6                               NA                         WB_MPO
#> 7                               NA                         WB_MPO
#> 8                               NA                         WB_MPO
#> 9                               NA                         WB_MPO
#> 10                              NA                         WB_MPO
#> 11                              NA                         WB_MPO
#> 12                              NA                         WB_MPO
#> 13                              NA                         WB_MPO
#> 14                              NA                         WB_MPO
#> 15                              NA                         WB_MPO
#> 16                              NA                         WB_MPO
#> 17                              NA                         WB_MPO
#> 18                              NA                         WB_MPO
#> 19                              NA                         WB_MPO
#> 20                              NA                         WB_MPO
#> 21                              NA                         WB_MPO
#> 22                              NA                         WB_MPO
#> 23                              NA                         WB_MPO
#> 24                              NA                         WB_MPO
#> 25                              NA                         WB_MPO
#> 26                              NA                         WB_MPO
#> 27                              NA                         WB_MPO
#> 28                              NA                         WB_MPO
#> 29                              NA                         WB_MPO
#> 30                              NA                         WB_MPO
#> 31                              NA                         WB_MPO
#> 32                              NA                         WB_MPO
#> 33                              NA                         WB_MPO
#> 34                              NA                         WB_MPO
#>    series_description.database_name series_description.date_last_update
#> 1                            WB_MPO                                <NA>
#> 2                            WB_MPO                                <NA>
#> 3                            WB_MPO                                <NA>
#> 4                            WB_MPO                                <NA>
#> 5                            WB_MPO                                <NA>
#> 6                            WB_MPO                                <NA>
#> 7                            WB_MPO                                <NA>
#> 8                            WB_MPO                                <NA>
#> 9                            WB_MPO                                <NA>
#> 10                           WB_MPO                                <NA>
#> 11                           WB_MPO                                <NA>
#> 12                           WB_MPO                                <NA>
#> 13                           WB_MPO                                <NA>
#> 14                           WB_MPO                                <NA>
#> 15                           WB_MPO                                <NA>
#> 16                           WB_MPO                                <NA>
#> 17                           WB_MPO                                <NA>
#> 18                           WB_MPO                                <NA>
#> 19                           WB_MPO                                <NA>
#> 20                           WB_MPO                                <NA>
#> 21                           WB_MPO                                <NA>
#> 22                           WB_MPO                                <NA>
#> 23                           WB_MPO                                <NA>
#> 24                           WB_MPO                                <NA>
#> 25                           WB_MPO                                <NA>
#> 26                           WB_MPO                                <NA>
#> 27                           WB_MPO                                <NA>
#> 28                           WB_MPO                                <NA>
#> 29            Macro Poverty Outlook                          2026-09-16
#> 30                           WB_MPO                                <NA>
#> 31                           WB_MPO                                <NA>
#> 32                           WB_MPO                                <NA>
#> 33                           WB_MPO                                <NA>
#> 34                           WB_MPO                                <NA>
#>    series_description.date_released
#> 1                                NA
#> 2                                NA
#> 3                                NA
#> 4                                NA
#> 5                                NA
#> 6                                NA
#> 7                                NA
#> 8                                NA
#> 9                                NA
#> 10                               NA
#> 11                               NA
#> 12                               NA
#> 13                               NA
#> 14                               NA
#> 15                               NA
#> 16                               NA
#> 17                               NA
#> 18                               NA
#> 19                               NA
#> 20                               NA
#> 21                               NA
#> 22                               NA
#> 23                               NA
#> 24                               NA
#> 25                               NA
#> 26                               NA
#> 27                               NA
#> 28                               NA
#> 29                               NA
#> 30                               NA
#> 31                               NA
#> 32                               NA
#> 33                               NA
#> 34                               NA
#>                                                       series_description.measurement_unit
#> 1                                                                Percentage of population
#> 2                  US dollars (Millions), Domestic currency (Millions), Percentage of GDP
#> 3        Domestic currency (Millions), Percentage change per annum, US dollars (Millions)
#> 4                                                Percentage of GDP, US dollars (Millions)
#> 5                                                             Percentage change per annum
#> 6                                                                   US dollars (Millions)
#> 7                                                                   US dollars (Millions)
#> 8                  Domestic currency (Millions), Percentage of GDP, US dollars (Millions)
#> 9                                                                Percentage of population
#> 10       US dollars (Millions), Domestic currency (Millions), Percentage change per annum
#> 11                                                                                  Index
#> 12                                                               Percentage of population
#> 13                                                                  US dollars (Millions)
#> 14       Domestic currency (Millions), Percentage change per annum, US dollars (Millions)
#> 15                                                           Domestic currency (Millions)
#> 16       Percentage change per annum, Domestic currency (Millions), US dollars (Millions)
#> 17       Domestic currency (Millions), Percentage change per annum, US dollars (Millions)
#> 18       Percentage change per annum, Domestic currency (Millions), US dollars (Millions)
#> 19                                               Percentage of GDP, US dollars (Millions)
#> 20       US dollars (Millions), Domestic currency (Millions), Percentage change per annum
#> 21                                                                      Kilotonnes of CO2
#> 22                              Percentage change per annum, Kilotonnes of CO2-equivalent
#> 23 Percentage change per annum, Kilotonnes of CO2-equivalent, Percentage of GHG emissions
#> 24       Percentage change per annum, Domestic currency (Millions), US dollars (Millions)
#> 25                                                                     Persons (Millions)
#> 26       US dollars (Millions), Percentage change per annum, Domestic currency (Millions)
#> 27                 US dollars (Millions), Percentage of GDP, Domestic currency (Millions)
#> 28       Percentage change per annum, US dollars (Millions), Domestic currency (Millions)
#> 29                                                                                   <NA>
#> 30       US dollars (Millions), Domestic currency (Millions), Percentage change per annum
#> 31                                                                                  Index
#> 32       Domestic currency (Millions), US dollars (Millions), Percentage change per annum
#> 33                                                                                  Index
#> 34                                                                      Percentage of GDP
#>                     series_description.release_calendar
#> 1                                                  <NA>
#> 2                                                  <NA>
#> 3                                                  <NA>
#> 4                                                  <NA>
#> 5                                                  <NA>
#> 6                                                  <NA>
#> 7                                                  <NA>
#> 8                                                  <NA>
#> 9                                                  <NA>
#> 10                                                 <NA>
#> 11                                                 <NA>
#> 12                                                 <NA>
#> 13                                                 <NA>
#> 14                                                 <NA>
#> 15                                                 <NA>
#> 16                                                 <NA>
#> 17                                                 <NA>
#> 18                                                 <NA>
#> 19                                                 <NA>
#> 20                                                 <NA>
#> 21                                                 <NA>
#> 22                                                 <NA>
#> 23                                                 <NA>
#> 24                                                 <NA>
#> 25                                                 <NA>
#> 26                                                 <NA>
#> 27                                                 <NA>
#> 28                                                 <NA>
#> 29 {"update_schedule":null,"update_frequency":"annual"}
#> 30                                                 <NA>
#> 31                                                 <NA>
#> 32                                                 <NA>
#> 33                                                 <NA>
#> 34                                                 <NA>
#>    series_description.periodicity series_description.base_period
#> 1                          Annual                             NA
#> 2                          Annual                             NA
#> 3                          Annual                             NA
#> 4                          Annual                             NA
#> 5                          Annual                             NA
#> 6                          Annual                             NA
#> 7                          Annual                             NA
#> 8                          Annual                             NA
#> 9                          Annual                             NA
#> 10                         Annual                             NA
#> 11                         Annual                             NA
#> 12                         Annual                             NA
#> 13                         Annual                             NA
#> 14                         Annual                             NA
#> 15                         Annual                             NA
#> 16                         Annual                             NA
#> 17                         Annual                             NA
#> 18                         Annual                             NA
#> 19                         Annual                             NA
#> 20                         Annual                             NA
#> 21                         Annual                             NA
#> 22                         Annual                             NA
#> 23                         Annual                             NA
#> 24                         Annual                             NA
#> 25                         Annual                             NA
#> 26                         Annual                             NA
#> 27                         Annual                             NA
#> 28                         Annual                             NA
#> 29                           <NA>                             NA
#> 30                         Annual                             NA
#> 31                         Annual                             NA
#> 32                         Annual                             NA
#> 33                         Annual                             NA
#> 34                         Annual                             NA
#>    series_description.definition_short
#> 1                                   NA
#> 2                                   NA
#> 3                                   NA
#> 4                                   NA
#> 5                                   NA
#> 6                                   NA
#> 7                                   NA
#> 8                                   NA
#> 9                                   NA
#> 10                                  NA
#> 11                                  NA
#> 12                                  NA
#> 13                                  NA
#> 14                                  NA
#> 15                                  NA
#> 16                                  NA
#> 17                                  NA
#> 18                                  NA
#> 19                                  NA
#> 20                                  NA
#> 21                                  NA
#> 22                                  NA
#> 23                                  NA
#> 24                                  NA
#> 25                                  NA
#> 26                                  NA
#> 27                                  NA
#> 28                                  NA
#> 29                                  NA
#> 30                                  NA
#> 31                                  NA
#> 32                                  NA
#> 33                                  NA
#> 34                                  NA
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        series_description.definition_long
#> 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 3                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 4                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 5                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 6                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 7                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 8                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 9                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 10                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 11                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 12                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 13                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 14                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 15                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 16                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 17                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 18                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 19                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 20                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 21                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 22                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 23                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 24                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 25                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 26                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 27                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 28                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 29 The Macro Poverty Outlook (MPO) analyzes macroeconomic and poverty developments in 147 developing countries. The report is released twice annually for the Spring and Annual Meetings of the World Bank and the International Monetary Fund. The MPO consists of individual country notes that provide an overview of recent developments, forecasts of major macroeconomic variables and poverty during 2024-2026, and a discussion of critical challenges for economic growth, macroeconomic stability, and poverty reduction moving forward.\n\nFor further details, please refer to https://www.worldbank.org/en/publication/macro-poverty-outlook
#> 30                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 31                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 32                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 33                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 34                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#>    series_description.statistical_concept
#> 1                                      NA
#> 2                                      NA
#> 3                                      NA
#> 4                                      NA
#> 5                                      NA
#> 6                                      NA
#> 7                                      NA
#> 8                                      NA
#> 9                                      NA
#> 10                                     NA
#> 11                                     NA
#> 12                                     NA
#> 13                                     NA
#> 14                                     NA
#> 15                                     NA
#> 16                                     NA
#> 17                                     NA
#> 18                                     NA
#> 19                                     NA
#> 20                                     NA
#> 21                                     NA
#> 22                                     NA
#> 23                                     NA
#> 24                                     NA
#> 25                                     NA
#> 26                                     NA
#> 27                                     NA
#> 28                                     NA
#> 29                                     NA
#> 30                                     NA
#> 31                                     NA
#> 32                                     NA
#> 33                                     NA
#> 34                                     NA
#>                                                                   series_description.methodology
#> 1  Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 2  Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 3  Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 4  Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 5  Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 6  Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 7  Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 8  Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 9  Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 10 Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 11 Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 12 Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 13 Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 14 Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 15 Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 16 Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 17 Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 18 Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 19 Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 20 Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 21 Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 22 Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 23 Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 24 Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 25 Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 26 Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 27 Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 28 Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 29                                                                                          <NA>
#> 30 Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 31 Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 32 Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 33 Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 34 Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#>    series_description.derivation series_description.imputation
#> 1                             NA                            NA
#> 2                             NA                            NA
#> 3                             NA                            NA
#> 4                             NA                            NA
#> 5                             NA                            NA
#> 6                             NA                            NA
#> 7                             NA                            NA
#> 8                             NA                            NA
#> 9                             NA                            NA
#> 10                            NA                            NA
#> 11                            NA                            NA
#> 12                            NA                            NA
#> 13                            NA                            NA
#> 14                            NA                            NA
#> 15                            NA                            NA
#> 16                            NA                            NA
#> 17                            NA                            NA
#> 18                            NA                            NA
#> 19                            NA                            NA
#> 20                            NA                            NA
#> 21                            NA                            NA
#> 22                            NA                            NA
#> 23                            NA                            NA
#> 24                            NA                            NA
#> 25                            NA                            NA
#> 26                            NA                            NA
#> 27                            NA                            NA
#> 28                            NA                            NA
#> 29                            NA                            NA
#> 30                            NA                            NA
#> 31                            NA                            NA
#> 32                            NA                            NA
#> 33                            NA                            NA
#> 34                            NA                            NA
#>    series_description.missing series_description.quality_checks
#> 1                          NA                                NA
#> 2                          NA                                NA
#> 3                          NA                                NA
#> 4                          NA                                NA
#> 5                          NA                                NA
#> 6                          NA                                NA
#> 7                          NA                                NA
#> 8                          NA                                NA
#> 9                          NA                                NA
#> 10                         NA                                NA
#> 11                         NA                                NA
#> 12                         NA                                NA
#> 13                         NA                                NA
#> 14                         NA                                NA
#> 15                         NA                                NA
#> 16                         NA                                NA
#> 17                         NA                                NA
#> 18                         NA                                NA
#> 19                         NA                                NA
#> 20                         NA                                NA
#> 21                         NA                                NA
#> 22                         NA                                NA
#> 23                         NA                                NA
#> 24                         NA                                NA
#> 25                         NA                                NA
#> 26                         NA                                NA
#> 27                         NA                                NA
#> 28                         NA                                NA
#> 29                         NA                                NA
#> 30                         NA                                NA
#> 31                         NA                                NA
#> 32                         NA                                NA
#> 33                         NA                                NA
#> 34                         NA                                NA
#>    series_description.quality_note series_description.sources_discrepancies
#> 1                               NA                                       NA
#> 2                               NA                                       NA
#> 3                               NA                                       NA
#> 4                               NA                                       NA
#> 5                               NA                                       NA
#> 6                               NA                                       NA
#> 7                               NA                                       NA
#> 8                               NA                                       NA
#> 9                               NA                                       NA
#> 10                              NA                                       NA
#> 11                              NA                                       NA
#> 12                              NA                                       NA
#> 13                              NA                                       NA
#> 14                              NA                                       NA
#> 15                              NA                                       NA
#> 16                              NA                                       NA
#> 17                              NA                                       NA
#> 18                              NA                                       NA
#> 19                              NA                                       NA
#> 20                              NA                                       NA
#> 21                              NA                                       NA
#> 22                              NA                                       NA
#> 23                              NA                                       NA
#> 24                              NA                                       NA
#> 25                              NA                                       NA
#> 26                              NA                                       NA
#> 27                              NA                                       NA
#> 28                              NA                                       NA
#> 29                              NA                                       NA
#> 30                              NA                                       NA
#> 31                              NA                                       NA
#> 32                              NA                                       NA
#> 33                              NA                                       NA
#> 34                              NA                                       NA
#>    series_description.series_break series_description.limitation
#> 1                               NA                            NA
#> 2                               NA                            NA
#> 3                               NA                            NA
#> 4                               NA                            NA
#> 5                               NA                            NA
#> 6                               NA                            NA
#> 7                               NA                            NA
#> 8                               NA                            NA
#> 9                               NA                            NA
#> 10                              NA                            NA
#> 11                              NA                            NA
#> 12                              NA                            NA
#> 13                              NA                            NA
#> 14                              NA                            NA
#> 15                              NA                            NA
#> 16                              NA                            NA
#> 17                              NA                            NA
#> 18                              NA                            NA
#> 19                              NA                            NA
#> 20                              NA                            NA
#> 21                              NA                            NA
#> 22                              NA                            NA
#> 23                              NA                            NA
#> 24                              NA                            NA
#> 25                              NA                            NA
#> 26                              NA                            NA
#> 27                              NA                            NA
#> 28                              NA                            NA
#> 29                              NA                            NA
#> 30                              NA                            NA
#> 31                              NA                            NA
#> 32                              NA                            NA
#> 33                              NA                            NA
#> 34                              NA                            NA
#>    series_description.relevance series_description.aggregation_method
#> 1                            NA                                    NA
#> 2                            NA                                    NA
#> 3                            NA                                    NA
#> 4                            NA                                    NA
#> 5                            NA                                    NA
#> 6                            NA                                    NA
#> 7                            NA                                    NA
#> 8                            NA                                    NA
#> 9                            NA                                    NA
#> 10                           NA                                    NA
#> 11                           NA                                    NA
#> 12                           NA                                    NA
#> 13                           NA                                    NA
#> 14                           NA                                    NA
#> 15                           NA                                    NA
#> 16                           NA                                    NA
#> 17                           NA                                    NA
#> 18                           NA                                    NA
#> 19                           NA                                    NA
#> 20                           NA                                    NA
#> 21                           NA                                    NA
#> 22                           NA                                    NA
#> 23                           NA                                    NA
#> 24                           NA                                    NA
#> 25                           NA                                    NA
#> 26                           NA                                    NA
#> 27                           NA                                    NA
#> 28                           NA                                    NA
#> 29                           NA                                    NA
#> 30                           NA                                    NA
#> 31                           NA                                    NA
#> 32                           NA                                    NA
#> 33                           NA                                    NA
#> 34                           NA                                    NA
#>    series_description.disaggregation
#> 1                                 NA
#> 2                                 NA
#> 3                                 NA
#> 4                                 NA
#> 5                                 NA
#> 6                                 NA
#> 7                                 NA
#> 8                                 NA
#> 9                                 NA
#> 10                                NA
#> 11                                NA
#> 12                                NA
#> 13                                NA
#> 14                                NA
#> 15                                NA
#> 16                                NA
#> 17                                NA
#> 18                                NA
#> 19                                NA
#> 20                                NA
#> 21                                NA
#> 22                                NA
#> 23                                NA
#> 24                                NA
#> 25                                NA
#> 26                                NA
#> 27                                NA
#> 28                                NA
#> 29                                NA
#> 30                                NA
#> 31                                NA
#> 32                                NA
#> 33                                NA
#> 34                                NA
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   series_description.confidentiality
#> 1  You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 2  You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 3  You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 4  You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 5  You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 6  You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 7  You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 8  You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 9  You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 10 You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 11 You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 12 You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 13 You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 14 You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 15 You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 16 You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 17 You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 18 You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 19 You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 20 You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 21 You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 22 You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 23 You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 24 You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 25 You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 26 You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 27 You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 28 You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 29                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              <NA>
#> 30 You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 31 You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 32 You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 33 You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 34 You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#>    series_description.confidentiality_status
#> 1                                         PU
#> 2                                         PU
#> 3                                         PU
#> 4                                         PU
#> 5                                         PU
#> 6                                         PU
#> 7                                         PU
#> 8                                         PU
#> 9                                         PU
#> 10                                        PU
#> 11                                        PU
#> 12                                        PU
#> 13                                        PU
#> 14                                        PU
#> 15                                        PU
#> 16                                        PU
#> 17                                        PU
#> 18                                        PU
#> 19                                        PU
#> 20                                        PU
#> 21                                        PU
#> 22                                        PU
#> 23                                        PU
#> 24                                        PU
#> 25                                        PU
#> 26                                        PU
#> 27                                        PU
#> 28                                        PU
#> 29                                      <NA>
#> 30                                        PU
#> 31                                        PU
#> 32                                        PU
#> 33                                        PU
#> 34                                        PU
#>                               series_description.confidentiality_note
#> 1  https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 2  https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 3  https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 4  https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 5  https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 6  https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 7  https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 8  https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 9  https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 10 https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 11 https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 12 https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 13 https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 14 https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 15 https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 16 https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 17 https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 18 https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 19 https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 20 https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 21 https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 22 https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 23 https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 24 https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 25 https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 26 https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 27 https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 28 https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 29                                                               <NA>
#> 30 https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 31 https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 32 https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 33 https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 34 https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#>                                                                                                  series_description.citation_requirement
#> 1                                                                                                                                   <NA>
#> 2                                                                                                                                   <NA>
#> 3                                                                                                                                   <NA>
#> 4                                                                                                                                   <NA>
#> 5                                                                                                                                   <NA>
#> 6                                                                                                                                   <NA>
#> 7                                                                                                                                   <NA>
#> 8                                                                                                                                   <NA>
#> 9                                                                                                                                   <NA>
#> 10                                                                                                                                  <NA>
#> 11                                                                                                                                  <NA>
#> 12                                                                                                                                  <NA>
#> 13                                                                                                                                  <NA>
#> 14                                                                                                                                  <NA>
#> 15                                                                                                                                  <NA>
#> 16                                                                                                                                  <NA>
#> 17                                                                                                                                  <NA>
#> 18                                                                                                                                  <NA>
#> 19                                                                                                                                  <NA>
#> 20                                                                                                                                  <NA>
#> 21                                                                                                                                  <NA>
#> 22                                                                                                                                  <NA>
#> 23                                                                                                                                  <NA>
#> 24                                                                                                                                  <NA>
#> 25                                                                                                                                  <NA>
#> 26                                                                                                                                  <NA>
#> 27                                                                                                                                  <NA>
#> 28                                                                                                                                  <NA>
#> 29 World Bank. (Year). Macro Poverty Outlook. Washington, DC: World Bank. https://www.worldbank.org/en/publication/macro-poverty-outlook
#> 30                                                                                                                                  <NA>
#> 31                                                                                                                                  <NA>
#> 32                                                                                                                                  <NA>
#> 33                                                                                                                                  <NA>
#> 34                                                                                                                                  <NA>
#>    series_description.sources_note series_description.acknowledgement_statement
#> 1                               NA                                           NA
#> 2                               NA                                           NA
#> 3                               NA                                           NA
#> 4                               NA                                           NA
#> 5                               NA                                           NA
#> 6                               NA                                           NA
#> 7                               NA                                           NA
#> 8                               NA                                           NA
#> 9                               NA                                           NA
#> 10                              NA                                           NA
#> 11                              NA                                           NA
#> 12                              NA                                           NA
#> 13                              NA                                           NA
#> 14                              NA                                           NA
#> 15                              NA                                           NA
#> 16                              NA                                           NA
#> 17                              NA                                           NA
#> 18                              NA                                           NA
#> 19                              NA                                           NA
#> 20                              NA                                           NA
#> 21                              NA                                           NA
#> 22                              NA                                           NA
#> 23                              NA                                           NA
#> 24                              NA                                           NA
#> 25                              NA                                           NA
#> 26                              NA                                           NA
#> 27                              NA                                           NA
#> 28                              NA                                           NA
#> 29                              NA                                           NA
#> 30                              NA                                           NA
#> 31                              NA                                           NA
#> 32                              NA                                           NA
#> 33                              NA                                           NA
#> 34                              NA                                           NA
#>    series_description.disclaimer series_description.economies_count
#> 1                             NA                                 NA
#> 2                             NA                                 NA
#> 3                             NA                                 NA
#> 4                             NA                                 NA
#> 5                             NA                                 NA
#> 6                             NA                                 NA
#> 7                             NA                                 NA
#> 8                             NA                                 NA
#> 9                             NA                                 NA
#> 10                            NA                                 NA
#> 11                            NA                                 NA
#> 12                            NA                                 NA
#> 13                            NA                                 NA
#> 14                            NA                                 NA
#> 15                            NA                                 NA
#> 16                            NA                                 NA
#> 17                            NA                                 NA
#> 18                            NA                                 NA
#> 19                            NA                                 NA
#> 20                            NA                                 NA
#> 21                            NA                                 NA
#> 22                            NA                                 NA
#> 23                            NA                                 NA
#> 24                            NA                                 NA
#> 25                            NA                                 NA
#> 26                            NA                                 NA
#> 27                            NA                                 NA
#> 28                            NA                                 NA
#> 29                            NA                                149
#> 30                            NA                                 NA
#> 31                            NA                                 NA
#> 32                            NA                                 NA
#> 33                            NA                                 NA
#> 34                            NA                                 NA
#>                                                    series_description.csv_link
#> 1   https://data360files.worldbank.org/data360-data/data/WB_MPO/MP_PJ_POV1.csv
#> 2    https://data360files.worldbank.org/data360-data/data/WB_MPO/GGDBTTOTL.csv
#> 3    https://data360files.worldbank.org/data360-data/data/WB_MPO/NEGDIFTOT.csv
#> 4    https://data360files.worldbank.org/data360-data/data/WB_MPO/BFCAFFFDI.csv
#> 5    https://data360files.worldbank.org/data360-data/data/WB_MPO/FPCPITOTL.csv
#> 6    https://data360files.worldbank.org/data360-data/data/WB_MPO/GGEXPTOTL.csv
#> 7    https://data360files.worldbank.org/data360-data/data/WB_MPO/BFCAFTOTL.csv
#> 8    https://data360files.worldbank.org/data360-data/data/WB_MPO/GGBALOVRL.csv
#> 9   https://data360files.worldbank.org/data360-data/data/WB_MPO/MP_PJ_POV2.csv
#> 10   https://data360files.worldbank.org/data360-data/data/WB_MPO/NYGDPFCST.csv
#> 11 https://data360files.worldbank.org/data360-data/data/WB_MPO/FPCPITOTLXN.csv
#> 12  https://data360files.worldbank.org/data360-data/data/WB_MPO/MP_PJ_POV3.csv
#> 13   https://data360files.worldbank.org/data360-data/data/WB_MPO/GGREVTOTL.csv
#> 14   https://data360files.worldbank.org/data360-data/data/WB_MPO/NVINDTOTL.csv
#> 15   https://data360files.worldbank.org/data360-data/data/WB_MPO/GGEXPINTP.csv
#> 16   https://data360files.worldbank.org/data360-data/data/WB_MPO/NECONGOVT.csv
#> 17   https://data360files.worldbank.org/data360-data/data/WB_MPO/NEEXPGNFS.csv
#> 18   https://data360files.worldbank.org/data360-data/data/WB_MPO/NVAGRTOTL.csv
#> 19   https://data360files.worldbank.org/data360-data/data/WB_MPO/BNCABFUND.csv
#> 20   https://data360files.worldbank.org/data360-data/data/WB_MPO/NYGDPMKTP.csv
#> 21   https://data360files.worldbank.org/data360-data/data/WB_MPO/ENATMCO2E.csv
#> 22   https://data360files.worldbank.org/data360-data/data/WB_MPO/ENTOTGHGE.csv
#> 23   https://data360files.worldbank.org/data360-data/data/WB_MPO/ENENRGHGE.csv
#> 24   https://data360files.worldbank.org/data360-data/data/WB_MPO/NECONPRVT.csv
#> 25   https://data360files.worldbank.org/data360-data/data/WB_MPO/SPPOPTOTL.csv
#> 26     https://data360files.worldbank.org/data360-data/data/WB_MPO/NYGDPPC.csv
#> 27   https://data360files.worldbank.org/data360-data/data/WB_MPO/GGBALPRIM.csv
#> 28   https://data360files.worldbank.org/data360-data/data/WB_MPO/NEIMPGNFS.csv
#> 29      https://data360files.worldbank.org/data360-data/data/WB_MPO/WB_MPO.csv
#> 30   https://data360files.worldbank.org/data360-data/data/WB_MPO/NVSRVTOTL.csv
#> 31 https://data360files.worldbank.org/data360-data/data/WB_MPO/NYGDPMKTPXN.csv
#> 32   https://data360files.worldbank.org/data360-data/data/WB_MPO/CONPRVTPC.csv
#> 33 https://data360files.worldbank.org/data360-data/data/WB_MPO/NECONPRVTXN.csv
#> 34  https://data360files.worldbank.org/data360-data/data/WB_MPO/NEGDIFTOTK.csv
#>    series_description.excel_link
#> 1                             NA
#> 2                             NA
#> 3                             NA
#> 4                             NA
#> 5                             NA
#> 6                             NA
#> 7                             NA
#> 8                             NA
#> 9                             NA
#> 10                            NA
#> 11                            NA
#> 12                            NA
#> 13                            NA
#> 14                            NA
#> 15                            NA
#> 16                            NA
#> 17                            NA
#> 18                            NA
#> 19                            NA
#> 20                            NA
#> 21                            NA
#> 22                            NA
#> 23                            NA
#> 24                            NA
#> 25                            NA
#> 26                            NA
#> 27                            NA
#> 28                            NA
#> 29                            NA
#> 30                            NA
#> 31                            NA
#> 32                            NA
#> 33                            NA
#> 34                            NA
#>                                                        series_description.json_link
#> 1   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/MP_PJ_POV1.json
#> 2    https://data360files.worldbank.org/data360-data/metadata/WB_MPO/GGDBTTOTL.json
#> 3    https://data360files.worldbank.org/data360-data/metadata/WB_MPO/NEGDIFTOT.json
#> 4    https://data360files.worldbank.org/data360-data/metadata/WB_MPO/BFCAFFFDI.json
#> 5    https://data360files.worldbank.org/data360-data/metadata/WB_MPO/FPCPITOTL.json
#> 6    https://data360files.worldbank.org/data360-data/metadata/WB_MPO/GGEXPTOTL.json
#> 7    https://data360files.worldbank.org/data360-data/metadata/WB_MPO/BFCAFTOTL.json
#> 8    https://data360files.worldbank.org/data360-data/metadata/WB_MPO/GGBALOVRL.json
#> 9   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/MP_PJ_POV2.json
#> 10   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/NYGDPFCST.json
#> 11 https://data360files.worldbank.org/data360-data/metadata/WB_MPO/FPCPITOTLXN.json
#> 12  https://data360files.worldbank.org/data360-data/metadata/WB_MPO/MP_PJ_POV3.json
#> 13   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/GGREVTOTL.json
#> 14   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/NVINDTOTL.json
#> 15   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/GGEXPINTP.json
#> 16   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/NECONGOVT.json
#> 17   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/NEEXPGNFS.json
#> 18   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/NVAGRTOTL.json
#> 19   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/BNCABFUND.json
#> 20   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/NYGDPMKTP.json
#> 21   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/ENATMCO2E.json
#> 22   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/ENTOTGHGE.json
#> 23   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/ENENRGHGE.json
#> 24   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/NECONPRVT.json
#> 25   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/SPPOPTOTL.json
#> 26     https://data360files.worldbank.org/data360-data/metadata/WB_MPO/NYGDPPC.json
#> 27   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/GGBALPRIM.json
#> 28   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/NEIMPGNFS.json
#> 29      https://data360files.worldbank.org/data360-data/datasetmetadata/WB_MPO.json
#> 30   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/NVSRVTOTL.json
#> 31 https://data360files.worldbank.org/data360-data/metadata/WB_MPO/NYGDPMKTPXN.json
#> 32   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/CONPRVTPC.json
#> 33 https://data360files.worldbank.org/data360-data/metadata/WB_MPO/NECONPRVTXN.json
#> 34  https://data360files.worldbank.org/data360-data/metadata/WB_MPO/NEGDIFTOTK.json
#>                                                                               series_description.api_link
#> 1   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=MP_PJ_POV1
#> 2    https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=GGDBTTOTL
#> 3    https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=NEGDIFTOT
#> 4    https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=BFCAFFFDI
#> 5    https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=FPCPITOTL
#> 6    https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=GGEXPTOTL
#> 7    https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=BFCAFTOTL
#> 8    https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=GGBALOVRL
#> 9   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=MP_PJ_POV2
#> 10   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=NYGDPFCST
#> 11 https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=FPCPITOTLXN
#> 12  https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=MP_PJ_POV3
#> 13   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=GGREVTOTL
#> 14   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=NVINDTOTL
#> 15   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=GGEXPINTP
#> 16   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=NECONGOVT
#> 17   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=NEEXPGNFS
#> 18   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=NVAGRTOTL
#> 19   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=BNCABFUND
#> 20   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=NYGDPMKTP
#> 21   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=ENATMCO2E
#> 22   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=ENTOTGHGE
#> 23   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=ENENRGHGE
#> 24   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=NECONPRVT
#> 25   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=SPPOPTOTL
#> 26     https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=NYGDPPC
#> 27   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=GGBALPRIM
#> 28   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=NEIMPGNFS
#> 29                       https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO
#> 30   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=NVSRVTOTL
#> 31 https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=NYGDPMKTPXN
#> 32   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=CONPRVTPC
#> 33 https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=NECONPRVTXN
#> 34  https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=NEGDIFTOTK
#>    series_description.indicator_count series_description.apiservice_link
#> 1                                  NA                                 NA
#> 2                                  NA                                 NA
#> 3                                  NA                                 NA
#> 4                                  NA                                 NA
#> 5                                  NA                                 NA
#> 6                                  NA                                 NA
#> 7                                  NA                                 NA
#> 8                                  NA                                 NA
#> 9                                  NA                                 NA
#> 10                                 NA                                 NA
#> 11                                 NA                                 NA
#> 12                                 NA                                 NA
#> 13                                 NA                                 NA
#> 14                                 NA                                 NA
#> 15                                 NA                                 NA
#> 16                                 NA                                 NA
#> 17                                 NA                                 NA
#> 18                                 NA                                 NA
#> 19                                 NA                                 NA
#> 20                                 NA                                 NA
#> 21                                 NA                                 NA
#> 22                                 NA                                 NA
#> 23                                 NA                                 NA
#> 24                                 NA                                 NA
#> 25                                 NA                                 NA
#> 26                                 NA                                 NA
#> 27                                 NA                                 NA
#> 28                                 NA                                 NA
#> 29                                 33                                 NA
#> 30                                 NA                                 NA
#> 31                                 NA                                 NA
#> 32                                 NA                                 NA
#> 33                                 NA                                 NA
#> 34                                 NA                                 NA
#>                                                                           series_description.api_explorer_link
#> 1   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=MP_PJ_POV1
#> 2    http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=GGDBTTOTL
#> 3    http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=NEGDIFTOT
#> 4    http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=BFCAFFFDI
#> 5    http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=FPCPITOTL
#> 6    http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=GGEXPTOTL
#> 7    http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=BFCAFTOTL
#> 8    http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=GGBALOVRL
#> 9   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=MP_PJ_POV2
#> 10   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=NYGDPFCST
#> 11 http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=FPCPITOTLXN
#> 12  http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=MP_PJ_POV3
#> 13   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=GGREVTOTL
#> 14   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=NVINDTOTL
#> 15   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=GGEXPINTP
#> 16   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=NECONGOVT
#> 17   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=NEEXPGNFS
#> 18   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=NVAGRTOTL
#> 19   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=BNCABFUND
#> 20   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=NYGDPMKTP
#> 21   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=ENATMCO2E
#> 22   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=ENTOTGHGE
#> 23   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=ENENRGHGE
#> 24   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=NECONPRVT
#> 25   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=SPPOPTOTL
#> 26     http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=NYGDPPC
#> 27   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=GGBALPRIM
#> 28   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=NEIMPGNFS
#> 29                       http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO
#> 30   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=NVSRVTOTL
#> 31 http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=NYGDPMKTPXN
#> 32   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=CONPRVTPC
#> 33 http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=NECONPRVTXN
#> 34  http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=NEGDIFTOTK
#>    series_description.authoring_entity
#> 1                                 NULL
#> 2                                 NULL
#> 3                                 NULL
#> 4                                 NULL
#> 5                                 NULL
#> 6                                 NULL
#> 7                                 NULL
#> 8                                 NULL
#> 9                                 NULL
#> 10                                NULL
#> 11                                NULL
#> 12                                NULL
#> 13                                NULL
#> 14                                NULL
#> 15                                NULL
#> 16                                NULL
#> 17                                NULL
#> 18                                NULL
#> 19                                NULL
#> 20                                NULL
#> 21                                NULL
#> 22                                NULL
#> 23                                NULL
#> 24                                NULL
#> 25                                NULL
#> 26                                NULL
#> 27                                NULL
#> 28                                NULL
#> 29                                NULL
#> 30                                NULL
#> 31                                NULL
#> 32                                NULL
#> 33                                NULL
#> 34                                NULL
#>    series_description.version_statement.version
#> 1                                            NA
#> 2                                            NA
#> 3                                            NA
#> 4                                            NA
#> 5                                            NA
#> 6                                            NA
#> 7                                            NA
#> 8                                            NA
#> 9                                            NA
#> 10                                           NA
#> 11                                           NA
#> 12                                           NA
#> 13                                           NA
#> 14                                           NA
#> 15                                           NA
#> 16                                           NA
#> 17                                           NA
#> 18                                           NA
#> 19                                           NA
#> 20                                           NA
#> 21                                           NA
#> 22                                           NA
#> 23                                           NA
#> 24                                           NA
#> 25                                           NA
#> 26                                           NA
#> 27                                           NA
#> 28                                           NA
#> 29                                           NA
#> 30                                           NA
#> 31                                           NA
#> 32                                           NA
#> 33                                           NA
#> 34                                           NA
#>    series_description.version_statement.version_date
#> 1                                         2026-09-16
#> 2                                         2026-09-16
#> 3                                         2026-09-16
#> 4                                         2026-09-16
#> 5                                         2026-09-16
#> 6                                         2026-09-16
#> 7                                         2026-09-16
#> 8                                         2026-09-16
#> 9                                         2026-09-16
#> 10                                        2026-09-16
#> 11                                        2026-09-16
#> 12                                        2026-09-16
#> 13                                        2026-09-16
#> 14                                        2026-09-16
#> 15                                        2026-09-16
#> 16                                        2026-09-16
#> 17                                        2026-09-16
#> 18                                        2026-09-16
#> 19                                        2026-09-16
#> 20                                        2026-09-16
#> 21                                        2026-09-16
#> 22                                        2026-09-16
#> 23                                        2026-09-16
#> 24                                        2026-09-16
#> 25                                        2026-09-16
#> 26                                        2026-09-16
#> 27                                        2026-09-16
#> 28                                        2026-09-16
#> 29                                              <NA>
#> 30                                        2026-09-16
#> 31                                        2026-09-16
#> 32                                        2026-09-16
#> 33                                        2026-09-16
#> 34                                        2026-09-16
#>    series_description.version_statement.version_resp
#> 1                                                 NA
#> 2                                                 NA
#> 3                                                 NA
#> 4                                                 NA
#> 5                                                 NA
#> 6                                                 NA
#> 7                                                 NA
#> 8                                                 NA
#> 9                                                 NA
#> 10                                                NA
#> 11                                                NA
#> 12                                                NA
#> 13                                                NA
#> 14                                                NA
#> 15                                                NA
#> 16                                                NA
#> 17                                                NA
#> 18                                                NA
#> 19                                                NA
#> 20                                                NA
#> 21                                                NA
#> 22                                                NA
#> 23                                                NA
#> 24                                                NA
#> 25                                                NA
#> 26                                                NA
#> 27                                                NA
#> 28                                                NA
#> 29                                                NA
#> 30                                                NA
#> 31                                                NA
#> 32                                                NA
#> 33                                                NA
#> 34                                                NA
#>    series_description.version_statement.version_notes
#> 1                                                  NA
#> 2                                                  NA
#> 3                                                  NA
#> 4                                                  NA
#> 5                                                  NA
#> 6                                                  NA
#> 7                                                  NA
#> 8                                                  NA
#> 9                                                  NA
#> 10                                                 NA
#> 11                                                 NA
#> 12                                                 NA
#> 13                                                 NA
#> 14                                                 NA
#> 15                                                 NA
#> 16                                                 NA
#> 17                                                 NA
#> 18                                                 NA
#> 19                                                 NA
#> 20                                                 NA
#> 21                                                 NA
#> 22                                                 NA
#> 23                                                 NA
#> 24                                                 NA
#> 25                                                 NA
#> 26                                                 NA
#> 27                                                 NA
#> 28                                                 NA
#> 29                                                 NA
#> 30                                                 NA
#> 31                                                 NA
#> 32                                                 NA
#> 33                                                 NA
#> 34                                                 NA
#>    series_description.aliases
#> 1                        NULL
#> 2                        NULL
#> 3                        NULL
#> 4                        NULL
#> 5                        NULL
#> 6                        NULL
#> 7                        NULL
#> 8                        NULL
#> 9                        NULL
#> 10                       NULL
#> 11                       NULL
#> 12                       NULL
#> 13                       NULL
#> 14                       NULL
#> 15                       NULL
#> 16                       NULL
#> 17                       NULL
#> 18                       NULL
#> 19                       NULL
#> 20                       NULL
#> 21                       NULL
#> 22                       NULL
#> 23                       NULL
#> 24                       NULL
#> 25                       NULL
#> 26                       NULL
#> 27                       NULL
#> 28                       NULL
#> 29                       NULL
#> 30                       NULL
#> 31                       NULL
#> 32                       NULL
#> 33                       NULL
#> 34                       NULL
#>                                                                           series_description.alternate_identifiers
#> 1           EFIDATA360_IND_ID, WB.MPO.POV1, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 2    EFIDATA360_IND_ID, WB.MPO.GGDBTTOTLCD, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 3    EFIDATA360_IND_ID, WB.MPO.NEGDIFTOTCN, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 4    EFIDATA360_IND_ID, WB.MPO.BFCAFFFDICD, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 5   EFIDATA360_IND_ID, WB.MPO.FPCPITOTLXNZ, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 6    EFIDATA360_IND_ID, WB.MPO.GGEXPTOTLCD, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 7    EFIDATA360_IND_ID, WB.MPO.BFCAFTOTLCD, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 8    EFIDATA360_IND_ID, WB.MPO.GGBALOVRLCD, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 9           EFIDATA360_IND_ID, WB.MPO.POV2, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 10   EFIDATA360_IND_ID, WB.MPO.NYGDPFCSTCD, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 11   EFIDATA360_IND_ID, WB.MPO.FPCPITOTLXN, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 12          EFIDATA360_IND_ID, WB.MPO.POV3, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 13   EFIDATA360_IND_ID, WB.MPO.GGREVTOTLCD, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 14   EFIDATA360_IND_ID, WB.MPO.NVINDTOTLCN, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 15   EFIDATA360_IND_ID, WB.MPO.GGEXPINTPCN, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 16   EFIDATA360_IND_ID, WB.MPO.NECONGOVTCN, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 17   EFIDATA360_IND_ID, WB.MPO.NEEXPGNFSCN, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 18   EFIDATA360_IND_ID, WB.MPO.NVAGRTOTLCN, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 19   EFIDATA360_IND_ID, WB.MPO.BNCABFUNDCD, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 20   EFIDATA360_IND_ID, WB.MPO.NYGDPMKTPCD, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 21   EFIDATA360_IND_ID, WB.MPO.ENATMCO2EKT, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 22   EFIDATA360_IND_ID, WB.MPO.ENTOTGHGEKT, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 23   EFIDATA360_IND_ID, WB.MPO.ENENRGHGEKT, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 24   EFIDATA360_IND_ID, WB.MPO.NECONPRVTCN, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 25     EFIDATA360_IND_ID, WB.MPO.SPPOPTOTL, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 26     EFIDATA360_IND_ID, WB.MPO.NYGDPPCKD, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 27   EFIDATA360_IND_ID, WB.MPO.GGBALPRIMCD, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 28   EFIDATA360_IND_ID, WB.MPO.NEIMPGNFSCN, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 29                                                                                                            NULL
#> 30   EFIDATA360_IND_ID, WB.MPO.NVSRVTOTLCN, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 31   EFIDATA360_IND_ID, WB.MPO.NYGDPMKTPXN, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 32 EFIDATA360_IND_ID, WB.MPO.NECONPRVTPCKD, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 33   EFIDATA360_IND_ID, WB.MPO.NECONPRVTXN, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 34  EFIDATA360_IND_ID, WB.MPO.NEGDIFTOTKD_, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#>    series_description.languages
#> 1                   English, EN
#> 2                   English, EN
#> 3                   English, EN
#> 4                   English, EN
#> 5                   English, EN
#> 6                   English, EN
#> 7                   English, EN
#> 8                   English, EN
#> 9                   English, EN
#> 10                  English, EN
#> 11                  English, EN
#> 12                  English, EN
#> 13                  English, EN
#> 14                  English, EN
#> 15                  English, EN
#> 16                  English, EN
#> 17                  English, EN
#> 18                  English, EN
#> 19                  English, EN
#> 20                  English, EN
#> 21                  English, EN
#> 22                  English, EN
#> 23                  English, EN
#> 24                  English, EN
#> 25                  English, EN
#> 26                  English, EN
#> 27                  English, EN
#> 28                  English, EN
#> 29                         NULL
#> 30                  English, EN
#> 31                  English, EN
#> 32                  English, EN
#> 33                  English, EN
#> 34                  English, EN
#>                                                                                                                                                                                           series_description.dimensions
#> 1                                                                                                               NA, NA, NA, NA, Geographic area, Time period, Price Basis, Vintage, Country/economy, Region, NA, NA, NA
#> 2                                        NA, NA, NA, NA, NA, Time period, Price Basis, Vintage, Geographic area, Unit of measure, NA, NA, NA, Country/economy, Region, Domestic currency, Percentage of GDP, US dollars
#> 3                              NA, NA, NA, NA, NA, Time period, Price Basis, Vintage, Geographic area, Unit of measure, NA, NA, NA, Country/economy, Region, Domestic currency, Percentage change per annum, US dollars
#> 4                                                           NA, NA, NA, NA, NA, Time period, Price Basis, Vintage, Unit of measure, Geographic area, NA, NA, NA, Percentage of GDP, US dollars, Country/economy, Region
#> 5                                                                                                               NA, NA, NA, NA, Geographic area, Time period, Price Basis, Vintage, Country/economy, Region, NA, NA, NA
#> 6                                                                                                               NA, NA, NA, NA, Geographic area, Time period, Price Basis, Vintage, Country/economy, Region, NA, NA, NA
#> 7                                                                                                               NA, NA, NA, NA, Geographic area, Time period, Price Basis, Vintage, Country/economy, Region, NA, NA, NA
#> 8                                        NA, NA, NA, NA, NA, Time period, Price Basis, Vintage, Geographic area, Unit of measure, NA, NA, NA, Country/economy, Region, Domestic currency, Percentage of GDP, US dollars
#> 9                                                                                                               NA, NA, NA, NA, Geographic area, Time period, Price Basis, Vintage, Country/economy, Region, NA, NA, NA
#> 10                             NA, NA, NA, NA, NA, Time period, Price Basis, Vintage, Geographic area, Unit of measure, NA, NA, NA, Country/economy, Region, Domestic currency, Percentage change per annum, US dollars
#> 11                                                                                                              NA, NA, NA, NA, Geographic area, Time period, Price Basis, Vintage, Country/economy, Region, NA, NA, NA
#> 12                                                                                                              NA, NA, NA, NA, Geographic area, Time period, Price Basis, Vintage, Country/economy, Region, NA, NA, NA
#> 13                                                                                                              NA, NA, NA, NA, Geographic area, Time period, Price Basis, Vintage, Country/economy, Region, NA, NA, NA
#> 14                             NA, NA, NA, NA, NA, Time period, Price Basis, Vintage, Geographic area, Unit of measure, NA, NA, NA, Country/economy, Region, Domestic currency, Percentage change per annum, US dollars
#> 15                                                                                                              NA, NA, NA, NA, Geographic area, Time period, Price Basis, Vintage, Country/economy, Region, NA, NA, NA
#> 16                             NA, NA, NA, NA, NA, Time period, Price Basis, Vintage, Geographic area, Unit of measure, NA, NA, NA, Country/economy, Region, Domestic currency, Percentage change per annum, US dollars
#> 17                             NA, NA, NA, NA, NA, Time period, Price Basis, Vintage, Geographic area, Unit of measure, NA, NA, NA, Country/economy, Region, Domestic currency, Percentage change per annum, US dollars
#> 18                             NA, NA, NA, NA, NA, Time period, Price Basis, Vintage, Geographic area, Unit of measure, NA, NA, NA, Country/economy, Region, Domestic currency, Percentage change per annum, US dollars
#> 19                                                          NA, NA, NA, NA, NA, Time period, Price Basis, Vintage, Unit of measure, Geographic area, NA, NA, NA, Percentage of GDP, US dollars, Country/economy, Region
#> 20                             NA, NA, NA, NA, NA, Time period, Price Basis, Vintage, Geographic area, Unit of measure, NA, NA, NA, Country/economy, Region, Domestic currency, Percentage change per annum, US dollars
#> 21                                                                                                              NA, NA, NA, NA, Geographic area, Time period, Price Basis, Vintage, Country/economy, Region, NA, NA, NA
#> 22                              NA, NA, NA, NA, NA, Unit of measure, Time period, Price Basis, Vintage, Geographic area, Kilotonnes of CO2-equivalent, Percentage change per annum, NA, NA, NA, Country/economy, Region
#> 23 NA, NA, NA, NA, NA, Time period, Price Basis, Vintage, Geographic area, Unit of measure, NA, NA, NA, Country/economy, Region, Kilotonnes of CO2-equivalent, Percentage change per annum, Percentage of GHG emissions
#> 24                             NA, NA, NA, NA, NA, Time period, Price Basis, Vintage, Geographic area, Unit of measure, NA, NA, NA, Country/economy, Region, Domestic currency, Percentage change per annum, US dollars
#> 25                                                                                                              NA, NA, NA, NA, Geographic area, Time period, Price Basis, Vintage, Country/economy, Region, NA, NA, NA
#> 26                             NA, NA, NA, NA, NA, Time period, Price Basis, Vintage, Geographic area, Unit of measure, NA, NA, NA, Country/economy, Region, Domestic currency, Percentage change per annum, US dollars
#> 27                                       NA, NA, NA, NA, NA, Time period, Price Basis, Vintage, Geographic area, Unit of measure, NA, NA, NA, Country/economy, Region, Domestic currency, Percentage of GDP, US dollars
#> 28                             NA, NA, NA, NA, NA, Time period, Price Basis, Vintage, Geographic area, Unit of measure, NA, NA, NA, Country/economy, Region, Domestic currency, Percentage change per annum, US dollars
#> 29                                                                                                                                                                                                                 NULL
#> 30                             NA, NA, NA, NA, NA, Time period, Price Basis, Vintage, Geographic area, Unit of measure, NA, NA, NA, Country/economy, Region, Domestic currency, Percentage change per annum, US dollars
#> 31                                                                                                              NA, NA, NA, NA, Geographic area, Time period, Price Basis, Vintage, Country/economy, Region, NA, NA, NA
#> 32                             NA, NA, NA, NA, NA, Time period, Price Basis, Vintage, Geographic area, Unit of measure, NA, NA, NA, Country/economy, Region, Domestic currency, Percentage change per annum, US dollars
#> 33                                                                                                              NA, NA, NA, NA, Geographic area, Time period, Price Basis, Vintage, Country/economy, Region, NA, NA, NA
#> 34                                                                                                              NA, NA, NA, NA, Geographic area, Time period, Price Basis, Vintage, Country/economy, Region, NA, NA, NA
#>    series_description.definition_references
#> 1                                      NULL
#> 2                                      NULL
#> 3                                      NULL
#> 4                                      NULL
#> 5                                      NULL
#> 6                                      NULL
#> 7                                      NULL
#> 8                                      NULL
#> 9                                      NULL
#> 10                                     NULL
#> 11                                     NULL
#> 12                                     NULL
#> 13                                     NULL
#> 14                                     NULL
#> 15                                     NULL
#> 16                                     NULL
#> 17                                     NULL
#> 18                                     NULL
#> 19                                     NULL
#> 20                                     NULL
#> 21                                     NULL
#> 22                                     NULL
#> 23                                     NULL
#> 24                                     NULL
#> 25                                     NULL
#> 26                                     NULL
#> 27                                     NULL
#> 28                                     NULL
#> 29                                     NULL
#> 30                                     NULL
#> 31                                     NULL
#> 32                                     NULL
#> 33                                     NULL
#> 34                                     NULL
#>    series_description.statistical_concept_references
#> 1                                               NULL
#> 2                                               NULL
#> 3                                               NULL
#> 4                                               NULL
#> 5                                               NULL
#> 6                                               NULL
#> 7                                               NULL
#> 8                                               NULL
#> 9                                               NULL
#> 10                                              NULL
#> 11                                              NULL
#> 12                                              NULL
#> 13                                              NULL
#> 14                                              NULL
#> 15                                              NULL
#> 16                                              NULL
#> 17                                              NULL
#> 18                                              NULL
#> 19                                              NULL
#> 20                                              NULL
#> 21                                              NULL
#> 22                                              NULL
#> 23                                              NULL
#> 24                                              NULL
#> 25                                              NULL
#> 26                                              NULL
#> 27                                              NULL
#> 28                                              NULL
#> 29                                              NULL
#> 30                                              NULL
#> 31                                              NULL
#> 32                                              NULL
#> 33                                              NULL
#> 34                                              NULL
#>                                                    series_description.methodology_references
#> 1  Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 2  Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 3  Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 4  Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 5  Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 6  Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 7  Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 8  Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 9  Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 10 Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 11 Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 12 Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 13 Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 14 Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 15 Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 16 Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 17 Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 18 Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 19 Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 20 Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 21 Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 22 Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 23 Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 24 Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 25 Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 26 Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 27 Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 28 Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 29                                                                                      NULL
#> 30 Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 31 Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 32 Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 33 Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 34 Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#>    series_description.derivation_references
#> 1                                      NULL
#> 2                                      NULL
#> 3                                      NULL
#> 4                                      NULL
#> 5                                      NULL
#> 6                                      NULL
#> 7                                      NULL
#> 8                                      NULL
#> 9                                      NULL
#> 10                                     NULL
#> 11                                     NULL
#> 12                                     NULL
#> 13                                     NULL
#> 14                                     NULL
#> 15                                     NULL
#> 16                                     NULL
#> 17                                     NULL
#> 18                                     NULL
#> 19                                     NULL
#> 20                                     NULL
#> 21                                     NULL
#> 22                                     NULL
#> 23                                     NULL
#> 24                                     NULL
#> 25                                     NULL
#> 26                                     NULL
#> 27                                     NULL
#> 28                                     NULL
#> 29                                     NULL
#> 30                                     NULL
#> 31                                     NULL
#> 32                                     NULL
#> 33                                     NULL
#> 34                                     NULL
#>    series_description.imputation_references
#> 1                                      NULL
#> 2                                      NULL
#> 3                                      NULL
#> 4                                      NULL
#> 5                                      NULL
#> 6                                      NULL
#> 7                                      NULL
#> 8                                      NULL
#> 9                                      NULL
#> 10                                     NULL
#> 11                                     NULL
#> 12                                     NULL
#> 13                                     NULL
#> 14                                     NULL
#> 15                                     NULL
#> 16                                     NULL
#> 17                                     NULL
#> 18                                     NULL
#> 19                                     NULL
#> 20                                     NULL
#> 21                                     NULL
#> 22                                     NULL
#> 23                                     NULL
#> 24                                     NULL
#> 25                                     NULL
#> 26                                     NULL
#> 27                                     NULL
#> 28                                     NULL
#> 29                                     NULL
#> 30                                     NULL
#> 31                                     NULL
#> 32                                     NULL
#> 33                                     NULL
#> 34                                     NULL
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        series_description.topics
#> 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             P3, P3_000004, P3_000020, P4, P4_000034, P4_000040, GAFS_0008, Prosperity, Poverty, Poverty, Infrastructure, Urban, Resilience and Land, Housing, Trends in the Determinants of Food Security Outcomes, NA, P3, P3_000004, NA, P4, P4_000034, NA, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, GAFS, NA, NA, NA, NA, NA, NA, NA
#> 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    P3, P3_000001, P3_000008, Prosperity, Economic Policy, Fiscal Policy, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 3                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    P3, P3_000001, P3_000008, Prosperity, Economic Policy, Fiscal Policy, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 4                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         P3, P3_000001, P3_000009, Prosperity, Economic Policy, Macro-financial Policies, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 5                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         P3, P3_000001, P3_000009, Prosperity, Economic Policy, Macro-financial Policies, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 6                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    P3, P3_000001, P3_000008, Prosperity, Economic Policy, Fiscal Policy, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 7                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         P3, P3_000001, P3_000009, Prosperity, Economic Policy, Macro-financial Policies, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 8                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    P3, P3_000001, P3_000008, Prosperity, Economic Policy, Fiscal Policy, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 9                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  P3, P3_000004, P3_000020, Prosperity, Poverty, Poverty, NA, P3, P3_000004, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 10                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 P3, P3_000001, P3_000007, Prosperity, Economic Policy, Growth and Jobs, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 11                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        P3, P3_000001, P3_000009, Prosperity, Economic Policy, Macro-financial Policies, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 12                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 P3, P3_000004, P3_000020, Prosperity, Poverty, Poverty, NA, P3, P3_000004, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 13                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   P3, P3_000001, P3_000008, Prosperity, Economic Policy, Fiscal Policy, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 14                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 P3, P3_000001, P3_000007, Prosperity, Economic Policy, Growth and Jobs, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 15                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   P3, P3_000001, P3_000008, Prosperity, Economic Policy, Fiscal Policy, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 16                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   P3, P3_000001, P3_000008, Prosperity, Economic Policy, Fiscal Policy, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 17                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            P3, P3_000006, P3_000028, Prosperity, Trade, Investment and Competitiveness, Trade Outcomes, NA, P3, P3_000006, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 18                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 P3, P3_000001, P3_000007, Prosperity, Economic Policy, Growth and Jobs, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 19                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        P3, P3_000001, P3_000009, Prosperity, Economic Policy, Macro-financial Policies, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 20                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 P3, P3_000001, P3_000007, Prosperity, Economic Policy, Growth and Jobs, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 21                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 P3, P3_000001, P3_000007, Prosperity, Economic Policy, Growth and Jobs, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 22                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 P3, P3_000001, P3_000007, Prosperity, Economic Policy, Growth and Jobs, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 23                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 P3, P3_000001, P3_000007, Prosperity, Economic Policy, Growth and Jobs, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 24                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 P3, P3_000001, P3_000007, Prosperity, Economic Policy, Growth and Jobs, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 25                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    P3, Prosperity, NA, WB Practice Groups, NA
#> 26                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 P3, P3_000001, P3_000007, Prosperity, Economic Policy, Growth and Jobs, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 27                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   P3, P3_000001, P3_000008, Prosperity, Economic Policy, Fiscal Policy, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 28                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            P3, P3_000006, P3_000028, Prosperity, Trade, Investment and Competitiveness, Trade Outcomes, NA, P3, P3_000006, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 29 P3, P3_000001, P3_000006, P3_000004, P3_000007, P3_000008, P3_000009, P3_000020, P3_000028, Prosperity, Economic Policy, Trade, Investment and Competitiveness, Poverty, Growth and Jobs, Fiscal Policy, Macro-financial Policies, Poverty, Trade Outcomes, NA, P3, P3, P3, P3_000001, P3_000001, P3_000001, P3_000004, P3_000006, WB Practice Groups, Data360 Topic L1, Data360 Topic L1, Data360 Topic L1, Data360 Topic L2, Data360 Topic L2, Data360 Topic L2, Data360 Topic L2, Data360 Topic L2, https://fmr.worldbank.org/FMR/sdmx/v2/structure/codelist/WB.DATA360/CL_D360_TOPICS/1.0, https://fmr.worldbank.org/FMR/sdmx/v2/structure/hierarchy/WB.DATA360/H_D360_TOPICS/1.0, https://fmr.worldbank.org/FMR/sdmx/v2/structure/hierarchy/WB.DATA360/H_D360_TOPICS/1.0, https://fmr.worldbank.org/FMR/sdmx/v2/structure/hierarchy/WB.DATA360/H_D360_TOPICS/1.0, https://fmr.worldbank.org/FMR/sdmx/v2/structure/hierarchy/WB.DATA360/H_D360_TOPICS/1.0, https://fmr.worldbank.org/FMR/sdmx/v2/structure/hierarchy/WB.DATA360/H_D360_TOPICS/1.0, https://fmr.worldbank.org/FMR/sdmx/v2/structure/hierarchy/WB.DATA360/H_D360_TOPICS/1.0, https://fmr.worldbank.org/FMR/sdmx/v2/structure/hierarchy/WB.DATA360/H_D360_TOPICS/1.0, https://fmr.worldbank.org/FMR/sdmx/v2/structure/hierarchy/WB.DATA360/H_D360_TOPICS/1.0
#> 30                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 P3, P3_000001, P3_000007, Prosperity, Economic Policy, Growth and Jobs, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 31                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 P3, P3_000001, P3_000007, Prosperity, Economic Policy, Growth and Jobs, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 32                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 P3, P3_000001, P3_000007, Prosperity, Economic Policy, Growth and Jobs, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 33                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 P3, P3_000001, P3_000007, Prosperity, Economic Policy, Growth and Jobs, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 34                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   P3, P3_000001, P3_000008, Prosperity, Economic Policy, Fiscal Policy, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#>    series_description.time_periods
#> 1                   2010, 2028, NA
#> 2                   1980, 2028, NA
#> 3                   1980, 2028, NA
#> 4                   1980, 2028, NA
#> 5                   1981, 2028, NA
#> 6                   1980, 2028, NA
#> 7                   1980, 2026, NA
#> 8                   1980, 2028, NA
#> 9                   2010, 2028, NA
#> 10                  1980, 2028, NA
#> 11                  1980, 2028, NA
#> 12                  2010, 2028, NA
#> 13                  1980, 2028, NA
#> 14                  1980, 2028, NA
#> 15                  1980, 2028, NA
#> 16                  1980, 2028, NA
#> 17                  1980, 2028, NA
#> 18                  1980, 2028, NA
#> 19                  1980, 2028, NA
#> 20                  1980, 2028, NA
#> 21                  1990, 2028, NA
#> 22                  1990, 2028, NA
#> 23                  1990, 2028, NA
#> 24                  1980, 2028, NA
#> 25                  1980, 2028, NA
#> 26                  1980, 2028, NA
#> 27                  1980, 2028, NA
#> 28                  1980, 2028, NA
#> 29                  1980, 2028, NA
#> 30                  1980, 2028, NA
#> 31                  1980, 2028, NA
#> 32                  1980, 2028, NA
#> 33                  1980, 2028, NA
#> 34                  1980, 2028, NA
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              series_description.ref_country
#> 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    Benin, El Salvador, Mexico, Mauritania, Ethiopia, Albania, Dominican Republic, Guinea-Bissau, South Sudan, Liberia, Russian Federation, Guinea, São Tomé and Príncipe, Senegal, Côte d’Ivoire, Kenya, Indonesia, Mali, Uganda, Panama, St. Lucia, Chad, Uruguay, Nigeria, Vietnam, China, Sierra Leone, Syrian Arab Republic, Georgia, Montenegro, Zimbabwe, Iran, Islamic Rep., Belarus, Burkina Faso, Sri Lanka, Congo, Rep., Malaysia, Cabo Verde, Croatia, Haiti, Eswatini, Grenada, Costa Rica, Suriname, Nicaragua, Jamaica, Mozambique, Uzbekistan, Pakistan, India, Namibia, Botswana, Togo, Peru, Kyrgyz Republic, Thailand, Cameroon, Djibouti, Guatemala, Central African Republic, Serbia, Colombia, Bolivia, Brazil, Tanzania, Timor-Leste, Kiribati, Madagascar, Seychelles, Barbados, Ghana, Tajikistan, Niger, Congo, Dem. Rep., Argentina, Bangladesh, Mongolia, Iraq, Romania, Zambia, West Bank and Gaza, Bulgaria, Gabon, Armenia, Honduras, Nepal, Lesotho, South Africa, Burundi, Comoros, Moldova, Angola, Morocco, Ecuador, Mauritius, Malawi, Belize, Kazakhstan, Paraguay, Lao PDR, Sudan, Bhutan, Türkiye, Somalia, Federal Republic of, Philippines, Chile, Rwanda, Gambia, The, Tunisia, Lebanon, Equatorial Guinea, Fiji, BEN, SLV, MEX, MRT, ETH, ALB, DOM, GNB, SSD, LBR, RUS, GIN, STP, SEN, CIV, KEN, IDN, MLI, UGA, PAN, LCA, TCD, URY, NGA, VNM, CHN, SLE, SYR, GEO, MNE, ZWE, IRN, BLR, BFA, LKA, COG, MYS, CPV, HRV, HTI, SWZ, GRD, CRI, SUR, NIC, JAM, MOZ, UZB, PAK, IND, NAM, BWA, TGO, PER, KGZ, THA, CMR, DJI, GTM, CAF, SRB, COL, BOL, BRA, TZA, TLS, KIR, MDG, SYC, BRB, GHA, TJK, NER, COD, ARG, BGD, MNG, IRQ, ROU, ZMB, PSE, BGR, GAB, ARM, HND, NPL, LSO, ZAF, BDI, COM, MDA, AGO, MAR, ECU, MUS, MWI, BLZ, KAZ, PRY, LAO, SDN, BTN, TUR, SOM, PHL, CHL, RWA, GMB, TUN, LBN, GNQ, FJI
#> 2                                                   Iraq, Cabo Verde, Cameroon, Haiti, Bolivia, Chad, Equatorial Guinea, Belarus, Indonesia, Grenada, Central African Republic, South Sudan, Mexico, Yemen, Rep., Saudi Arabia, Belize, Peru, Comoros, Costa Rica, Zimbabwe, Jamaica, Georgia, Russian Federation, Angola, Rwanda, Micronesia, Fed. Sts., Guyana, São Tomé and Príncipe, Croatia, Bahamas, The, Guatemala, Colombia, Mongolia, Kosovo, Niger, Timor-Leste, Bahrain, Maldives, Nigeria, Djibouti, Sri Lanka, Pakistan, Oman, Afghanistan, St. Lucia, North Macedonia, Nepal, Moldova, Liberia, Qatar, Uruguay, Tunisia, Samoa, Guinea-Bissau, Mali, Argentina, South Africa, Côte d’Ivoire, Lao PDR, Seychelles, Madagascar, Ghana, Nicaragua, Barbados, Mauritania, Bangladesh, Ethiopia, Paraguay, Eritrea, Tanzania, Namibia, St. Vincent and the Grenadines, Tajikistan, Türkiye, Bulgaria, China, Poland, Botswana, Congo, Dem. Rep., Suriname, Kazakhstan, Bhutan, Serbia, Jordan, India, El Salvador, Eswatini, Solomon Islands, Philippines, Gambia, The, Malaysia, Myanmar, Kiribati, Armenia, Brazil, Burundi, Syrian Arab Republic, Sierra Leone, Palau, Gabon, Senegal, Mauritius, Bosnia and Herzegovina, Uzbekistan, Ukraine, Lebanon, Kenya, Vanuatu, Vietnam, Lesotho, Albania, Egypt, Arab Rep., Papua New Guinea, Zambia, West Bank and Gaza, Algeria, Somalia, Federal Republic of, Morocco, Tonga, Trinidad and Tobago, Burkina Faso, Kuwait, Panama, Benin, Sudan, Fiji, Kyrgyz Republic, Ecuador, Uganda, Thailand, Libya, Dominican Republic, Togo, Cambodia, Malawi, Honduras, Montenegro, Romania, Azerbaijan, Chile, Congo, Rep., United Arab Emirates, Dominica, Mozambique, Iran, Islamic Rep., Guinea, IRQ, CPV, CMR, HTI, BOL, TCD, GNQ, BLR, IDN, GRD, CAF, SSD, MEX, YEM, SAU, BLZ, PER, COM, CRI, ZWE, JAM, GEO, RUS, AGO, RWA, FSM, GUY, STP, HRV, BHS, GTM, COL, MNG, XKX, NER, TLS, BHR, MDV, NGA, DJI, LKA, PAK, OMN, AFG, LCA, MKD, NPL, MDA, LBR, QAT, URY, TUN, WSM, GNB, MLI, ARG, ZAF, CIV, LAO, SYC, MDG, GHA, NIC, BRB, MRT, BGD, ETH, PRY, ERI, TZA, NAM, VCT, TJK, TUR, BGR, CHN, POL, BWA, COD, SUR, KAZ, BTN, SRB, JOR, IND, SLV, SWZ, SLB, PHL, GMB, MYS, MMR, KIR, ARM, BRA, BDI, SYR, SLE, PLW, GAB, SEN, MUS, BIH, UZB, UKR, LBN, KEN, VUT, VNM, LSO, ALB, EGY, PNG, ZMB, PSE, DZA, SOM, MAR, TON, TTO, BFA, KWT, PAN, BEN, SDN, FJI, KGZ, ECU, UGA, THA, LBY, DOM, TGO, KHM, MWI, HND, MNE, ROU, AZE, CHL, COG, ARE, DMA, MOZ, IRN, GIN
#> 3                                                                                                                                                                                                                                                                                                                                     Vietnam, Tunisia, South Africa, Rwanda, Samoa, Morocco, Bulgaria, Romania, Thailand, Kazakhstan, Guatemala, Afghanistan, Djibouti, Peru, Kosovo, Tanzania, Belarus, Nigeria, Cameroon, Zimbabwe, Panama, Philippines, Indonesia, Bosnia and Herzegovina, Madagascar, Mauritania, Mexico, Myanmar, Iraq, Gabon, Uganda, Zambia, Syrian Arab Republic, Congo, Rep., Dominican Republic, Costa Rica, Vanuatu, Haiti, Russian Federation, Saudi Arabia, Algeria, Georgia, Mongolia, Bahrain, Iran, Islamic Rep., Azerbaijan, Kiribati, Nicaragua, Mauritius, Sri Lanka, Guinea-Bissau, Kenya, Côte d’Ivoire, Solomon Islands, Tajikistan, Qatar, Belize, Croatia, El Salvador, Burkina Faso, Oman, Namibia, Poland, Libya, Niger, Senegal, Liberia, Bangladesh, Jamaica, Honduras, West Bank and Gaza, Ghana, Ecuador, Argentina, Kuwait, Moldova, Bahamas, The, Burundi, Yemen, Rep., Benin, Uzbekistan, Mozambique, Botswana, Timor-Leste, Nepal, Türkiye, Bolivia, Kyrgyz Republic, Cambodia, Guinea, Eswatini, Pakistan, Togo, Jordan, Bhutan, Paraguay, Egypt, Arab Rep., Marshall Islands, United Arab Emirates, Maldives, Albania, Gambia, The, Sierra Leone, Sudan, Chad, Seychelles, Uruguay, Lebanon, North Macedonia, Comoros, Malaysia, China, Somalia, Federal Republic of, Serbia, Angola, Central African Republic, Lesotho, Brazil, Ethiopia, Armenia, Ukraine, Congo, Dem. Rep., Cabo Verde, India, Mali, Chile, Montenegro, Equatorial Guinea, Eritrea, Malawi, Colombia, VNM, TUN, ZAF, RWA, WSM, MAR, BGR, ROU, THA, KAZ, GTM, AFG, DJI, PER, XKX, TZA, BLR, NGA, CMR, ZWE, PAN, PHL, IDN, BIH, MDG, MRT, MEX, MMR, IRQ, GAB, UGA, ZMB, SYR, COG, DOM, CRI, VUT, HTI, RUS, SAU, DZA, GEO, MNG, BHR, IRN, AZE, KIR, NIC, MUS, LKA, GNB, KEN, CIV, SLB, TJK, QAT, BLZ, HRV, SLV, BFA, OMN, NAM, POL, LBY, NER, SEN, LBR, BGD, JAM, HND, PSE, GHA, ECU, ARG, KWT, MDA, BHS, BDI, YEM, BEN, UZB, MOZ, BWA, TLS, NPL, TUR, BOL, KGZ, KHM, GIN, SWZ, PAK, TGO, JOR, BTN, PRY, EGY, MHL, ARE, MDV, ALB, GMB, SLE, SDN, TCD, SYC, URY, LBN, MKD, COM, MYS, CHN, SOM, SRB, AGO, CAF, LSO, BRA, ETH, ARM, UKR, COD, CPV, IND, MLI, CHL, MNE, GNQ, ERI, MWI, COL
#> 4                                                                                                                                                                                                                                                                                                                                                                                                                                                                  Philippines, Timor-Leste, Gabon, Oman, Afghanistan, Eswatini, Ecuador, Saudi Arabia, Togo, Honduras, Haiti, Mongolia, Montenegro, Jordan, Niger, Chile, Kyrgyz Republic, Qatar, Tanzania, West Bank and Gaza, Albania, Chad, Croatia, Nigeria, Poland, São Tomé and Príncipe, Vanuatu, Guyana, Sudan, Armenia, Papua New Guinea, Vietnam, Cameroon, Georgia, Eritrea, Micronesia, Fed. Sts., Azerbaijan, Bahamas, The, Uzbekistan, Pakistan, Türkiye, Tonga, El Salvador, Thailand, Nicaragua, Benin, Guinea, Kenya, Côte d’Ivoire, Peru, Bulgaria, Belarus, Malaysia, Mauritania, Mali, Seychelles, Egypt, Arab Rep., Russian Federation, Kosovo, Bangladesh, Moldova, India, Bosnia and Herzegovina, Mexico, Solomon Islands, Romania, Trinidad and Tobago, Angola, South Africa, Morocco, Iran, Islamic Rep., South Sudan, Ghana, Jamaica, Burkina Faso, Burundi, Cambodia, Guinea-Bissau, Zimbabwe, Congo, Rep., Guatemala, Lebanon, Iraq, Sierra Leone, Indonesia, Bhutan, Maldives, Panama, Ukraine, Belize, China, Suriname, Botswana, Kuwait, Tunisia, Samoa, Madagascar, Nepal, Uganda, Uruguay, Zambia, Dominican Republic, Equatorial Guinea, Costa Rica, Fiji, Kazakhstan, Paraguay, Brazil, Rwanda, Namibia, Argentina, Serbia, North Macedonia, Cabo Verde, Malawi, Lesotho, Bahrain, Yemen, Rep., Tajikistan, Syrian Arab Republic, Sri Lanka, Mauritius, Bolivia, Mozambique, PHL, TLS, GAB, OMN, AFG, SWZ, ECU, SAU, TGO, HND, HTI, MNG, MNE, JOR, NER, CHL, KGZ, QAT, TZA, PSE, ALB, TCD, HRV, NGA, POL, STP, VUT, GUY, SDN, ARM, PNG, VNM, CMR, GEO, ERI, FSM, AZE, BHS, UZB, PAK, TUR, TON, SLV, THA, NIC, BEN, GIN, KEN, CIV, PER, BGR, BLR, MYS, MRT, MLI, SYC, EGY, RUS, XKX, BGD, MDA, IND, BIH, MEX, SLB, ROU, TTO, AGO, ZAF, MAR, IRN, SSD, GHA, JAM, BFA, BDI, KHM, GNB, ZWE, COG, GTM, LBN, IRQ, SLE, IDN, BTN, MDV, PAN, UKR, BLZ, CHN, SUR, BWA, KWT, TUN, WSM, MDG, NPL, UGA, URY, ZMB, DOM, GNQ, CRI, FJI, KAZ, PRY, BRA, RWA, NAM, ARG, SRB, MKD, CPV, MWI, LSO, BHR, YEM, TJK, SYR, LKA, MUS, BOL, MOZ
#> 5                                                                                              Albania, Kenya, Niger, Paraguay, Maldives, Oman, Lao PDR, Uzbekistan, Congo, Rep., Türkiye, Senegal, São Tomé and Príncipe, Bhutan, Equatorial Guinea, Bolivia, Namibia, Tanzania, Angola, Mongolia, Mauritania, Fiji, Pakistan, Eswatini, Nicaragua, Qatar, Morocco, Poland, Mali, Dominica, Solomon Islands, Romania, Belarus, Peru, Mauritius, Trinidad and Tobago, United Arab Emirates, Guinea-Bissau, Vietnam, Cambodia, Kyrgyz Republic, Moldova, Colombia, Somalia, Federal Republic of, Timor-Leste, Lesotho, Congo, Dem. Rep., Egypt, Arab Rep., Saudi Arabia, Ukraine, Russian Federation, Chile, Grenada, Jamaica, Zimbabwe, India, Bangladesh, Burundi, Thailand, Micronesia, Fed. Sts., Sierra Leone, Belize, Iraq, Azerbaijan, Côte d’Ivoire, Georgia, Uganda, Costa Rica, Sudan, Vanuatu, Tonga, Guinea, Honduras, Guyana, Palau, Yemen, Rep., El Salvador, Armenia, Nigeria, St. Lucia, Haiti, Lebanon, Zambia, Madagascar, Mexico, Bosnia and Herzegovina, Kuwait, Samoa, Tunisia, Central African Republic, China, Brazil, Comoros, Eritrea, Indonesia, Papua New Guinea, Burkina Faso, Malawi, Uruguay, Philippines, Libya, Panama, Algeria, North Macedonia, Suriname, Togo, Serbia, Jordan, Croatia, Bahamas, The, Djibouti, Cameroon, Afghanistan, Seychelles, St. Vincent and the Grenadines, Iran, Islamic Rep., Ecuador, Montenegro, Ethiopia, Benin, Kosovo, Bulgaria, Dominican Republic, Barbados, Tajikistan, Liberia, Gabon, Kazakhstan, Cabo Verde, Ghana, Botswana, Myanmar, South Africa, South Sudan, Sri Lanka, Nepal, Chad, Kiribati, Malaysia, Mozambique, West Bank and Gaza, Rwanda, Bahrain, Guatemala, Gambia, The, ALB, KEN, NER, PRY, MDV, OMN, LAO, UZB, COG, TUR, SEN, STP, BTN, GNQ, BOL, NAM, TZA, AGO, MNG, MRT, FJI, PAK, SWZ, NIC, QAT, MAR, POL, MLI, DMA, SLB, ROU, BLR, PER, MUS, TTO, ARE, GNB, VNM, KHM, KGZ, MDA, COL, SOM, TLS, LSO, COD, EGY, SAU, UKR, RUS, CHL, GRD, JAM, ZWE, IND, BGD, BDI, THA, FSM, SLE, BLZ, IRQ, AZE, CIV, GEO, UGA, CRI, SDN, VUT, TON, GIN, HND, GUY, PLW, YEM, SLV, ARM, NGA, LCA, HTI, LBN, ZMB, MDG, MEX, BIH, KWT, WSM, TUN, CAF, CHN, BRA, COM, ERI, IDN, PNG, BFA, MWI, URY, PHL, LBY, PAN, DZA, MKD, SUR, TGO, SRB, JOR, HRV, BHS, DJI, CMR, AFG, SYC, VCT, IRN, ECU, MNE, ETH, BEN, XKX, BGR, DOM, BRB, TJK, LBR, GAB, KAZ, CPV, GHA, BWA, MMR, ZAF, SSD, LKA, NPL, TCD, KIR, MYS, MOZ, PSE, RWA, BHR, GTM, GMB
#> 6                                                   Eswatini, Equatorial Guinea, Argentina, Gambia, The, Indonesia, Mali, Thailand, Zimbabwe, Pakistan, Central African Republic, Bahrain, Djibouti, Bolivia, Kiribati, Palau, Colombia, South Sudan, Benin, Timor-Leste, Uzbekistan, Honduras, St. Lucia, Peru, India, Seychelles, West Bank and Gaza, São Tomé and Príncipe, Panama, Mozambique, Burkina Faso, Congo, Dem. Rep., Cambodia, Nepal, China, Gabon, Madagascar, Oman, Saudi Arabia, Sri Lanka, Qatar, Solomon Islands, North Macedonia, Kazakhstan, Guyana, Albania, Tunisia, Dominica, Sierra Leone, Romania, Uruguay, Tajikistan, Bosnia and Herzegovina, Kuwait, Poland, Chad, Nigeria, Bahamas, The, Cabo Verde, Algeria, Fiji, Botswana, Rwanda, Moldova, Serbia, Bulgaria, Russian Federation, Iran, Islamic Rep., Jamaica, Lao PDR, Eritrea, Croatia, Libya, Papua New Guinea, Haiti, United Arab Emirates, Mauritius, Mexico, Myanmar, Georgia, Guatemala, Costa Rica, Ukraine, Tanzania, Maldives, Ghana, Suriname, Azerbaijan, Afghanistan, Somalia, Federal Republic of, Vanuatu, Iraq, Montenegro, Syrian Arab Republic, Samoa, Brazil, Uganda, Chile, Burundi, Mauritania, Mongolia, Nicaragua, Micronesia, Fed. Sts., Lesotho, Kyrgyz Republic, Trinidad and Tobago, Angola, Belarus, Vietnam, Namibia, Kenya, Yemen, Rep., Senegal, South Africa, Egypt, Arab Rep., Togo, Malawi, Guinea-Bissau, Cameroon, Sudan, Guinea, Philippines, Ethiopia, Grenada, Morocco, Niger, El Salvador, Armenia, Bhutan, Lebanon, Côte d’Ivoire, Türkiye, Barbados, Dominican Republic, Kosovo, Belize, Comoros, St. Vincent and the Grenadines, Zambia, Tonga, Ecuador, Paraguay, Jordan, Malaysia, Bangladesh, Liberia, Congo, Rep., SWZ, GNQ, ARG, GMB, IDN, MLI, THA, ZWE, PAK, CAF, BHR, DJI, BOL, KIR, PLW, COL, SSD, BEN, TLS, UZB, HND, LCA, PER, IND, SYC, PSE, STP, PAN, MOZ, BFA, COD, KHM, NPL, CHN, GAB, MDG, OMN, SAU, LKA, QAT, SLB, MKD, KAZ, GUY, ALB, TUN, DMA, SLE, ROU, URY, TJK, BIH, KWT, POL, TCD, NGA, BHS, CPV, DZA, FJI, BWA, RWA, MDA, SRB, BGR, RUS, IRN, JAM, LAO, ERI, HRV, LBY, PNG, HTI, ARE, MUS, MEX, MMR, GEO, GTM, CRI, UKR, TZA, MDV, GHA, SUR, AZE, AFG, SOM, VUT, IRQ, MNE, SYR, WSM, BRA, UGA, CHL, BDI, MRT, MNG, NIC, FSM, LSO, KGZ, TTO, AGO, BLR, VNM, NAM, KEN, YEM, SEN, ZAF, EGY, TGO, MWI, GNB, CMR, SDN, GIN, PHL, ETH, GRD, MAR, NER, SLV, ARM, BTN, LBN, CIV, TUR, BRB, DOM, XKX, BLZ, COM, VCT, ZMB, TON, ECU, PRY, JOR, MYS, BGD, LBR, COG
#> 7                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   Uzbekistan, São Tomé and Príncipe, Maldives, Azerbaijan, Honduras, Saudi Arabia, Argentina, Kuwait, Peru, Uruguay, Sierra Leone, Malaysia, Nigeria, Paraguay, Syrian Arab Republic, Kazakhstan, China, Tunisia, Iraq, Solomon Islands, Lebanon, Belize, Timor-Leste, Oman, Bahamas, The, Sri Lanka, Mongolia, Bahrain, Trinidad and Tobago, Eritrea, Jamaica, Nicaragua, Ukraine, Russian Federation, Belarus, El Salvador, Qatar, Papua New Guinea, Fiji, Mexico, Vanuatu, UZB, STP, MDV, AZE, HND, SAU, ARG, KWT, PER, URY, SLE, MYS, NGA, PRY, SYR, KAZ, CHN, TUN, IRQ, SLB, LBN, BLZ, TLS, OMN, BHS, LKA, MNG, BHR, TTO, ERI, JAM, NIC, UKR, RUS, BLR, SLV, QAT, PNG, FJI, MEX, VUT
#> 8                                                   Nicaragua, Burkina Faso, Jamaica, Iran, Islamic Rep., Samoa, Egypt, Arab Rep., Panama, Angola, Tonga, Congo, Rep., Saudi Arabia, Seychelles, Côte d’Ivoire, Philippines, Ukraine, Senegal, Congo, Dem. Rep., Kenya, Brazil, Timor-Leste, Burundi, Ecuador, Solomon Islands, Chad, Armenia, Papua New Guinea, Costa Rica, Chile, Dominican Republic, Mexico, Guinea, Tunisia, Sri Lanka, Algeria, Bahrain, Botswana, Uruguay, Bangladesh, Tajikistan, Mongolia, Uzbekistan, Zimbabwe, Liberia, Kazakhstan, Nigeria, Grenada, Poland, Rwanda, Kiribati, Albania, São Tomé and Príncipe, Suriname, Colombia, Namibia, Djibouti, Syrian Arab Republic, Russian Federation, Mauritania, Uganda, Lebanon, Azerbaijan, Maldives, Cambodia, United Arab Emirates, Cabo Verde, Fiji, Palau, St. Vincent and the Grenadines, Qatar, Madagascar, Kosovo, Mali, North Macedonia, Kyrgyz Republic, Morocco, Romania, Malawi, Mauritius, Argentina, Haiti, West Bank and Gaza, Peru, Libya, Pakistan, Yemen, Rep., Lao PDR, El Salvador, Eritrea, China, Gambia, The, Jordan, Thailand, Micronesia, Fed. Sts., Trinidad and Tobago, Croatia, Nepal, Gabon, South Sudan, Benin, Bosnia and Herzegovina, Bolivia, Vietnam, Vanuatu, Mozambique, Comoros, Togo, Guinea-Bissau, Dominica, Bahamas, The, India, Somalia, Federal Republic of, Bulgaria, St. Lucia, Belarus, Eswatini, Myanmar, Sudan, Guatemala, Belize, Cameroon, Guyana, Oman, Central African Republic, Bhutan, Zambia, Equatorial Guinea, Malaysia, Kuwait, Moldova, Serbia, Honduras, Lesotho, Tanzania, Ghana, Paraguay, Georgia, South Africa, Niger, Türkiye, Indonesia, Afghanistan, Iraq, Montenegro, Sierra Leone, Barbados, Ethiopia, NIC, BFA, JAM, IRN, WSM, EGY, PAN, AGO, TON, COG, SAU, SYC, CIV, PHL, UKR, SEN, COD, KEN, BRA, TLS, BDI, ECU, SLB, TCD, ARM, PNG, CRI, CHL, DOM, MEX, GIN, TUN, LKA, DZA, BHR, BWA, URY, BGD, TJK, MNG, UZB, ZWE, LBR, KAZ, NGA, GRD, POL, RWA, KIR, ALB, STP, SUR, COL, NAM, DJI, SYR, RUS, MRT, UGA, LBN, AZE, MDV, KHM, ARE, CPV, FJI, PLW, VCT, QAT, MDG, XKX, MLI, MKD, KGZ, MAR, ROU, MWI, MUS, ARG, HTI, PSE, PER, LBY, PAK, YEM, LAO, SLV, ERI, CHN, GMB, JOR, THA, FSM, TTO, HRV, NPL, GAB, SSD, BEN, BIH, BOL, VNM, VUT, MOZ, COM, TGO, GNB, DMA, BHS, IND, SOM, BGR, LCA, BLR, SWZ, MMR, SDN, GTM, BLZ, CMR, GUY, OMN, CAF, BTN, ZMB, GNQ, MYS, KWT, MDA, SRB, HND, LSO, TZA, GHA, PRY, GEO, ZAF, NER, TUR, IDN, AFG, IRQ, MNE, SLE, BRB, ETH
#> 9                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            Syrian Arab Republic, Congo, Dem. Rep., Türkiye, South Africa, Albania, Panama, Togo, Haiti, Argentina, Guinea-Bissau, Liberia, Gabon, Honduras, Senegal, Uzbekistan, Congo, Rep., Georgia, Brazil, Madagascar, India, Chile, Sierra Leone, Uruguay, Zimbabwe, Malaysia, Lao PDR, Côte d’Ivoire, Gambia, The, Grenada, Barbados, Benin, China, Mauritania, Eswatini, Vanuatu, Serbia, El Salvador, Belarus, Tanzania, Armenia, Colombia, Nigeria, Pakistan, Lesotho, Mongolia, Seychelles, Angola, Malawi, South Sudan, Kazakhstan, Tajikistan, Thailand, Zambia, Guinea, Djibouti, Dominican Republic, Indonesia, Montenegro, Jamaica, Lebanon, Kyrgyz Republic, Belize, Comoros, Nepal, Cabo Verde, Suriname, Chad, Burundi, Fiji, Bolivia, Cameroon, Mali, Sudan, Central African Republic, Morocco, Romania, Kiribati, Bangladesh, Rwanda, Paraguay, Namibia, Philippines, Guatemala, Mauritius, Ecuador, Ethiopia, Burkina Faso, Moldova, Croatia, Russian Federation, Sri Lanka, Bhutan, Equatorial Guinea, Costa Rica, Kenya, Botswana, Nicaragua, Bulgaria, Mozambique, Peru, Vietnam, Egypt, Arab Rep., Somalia, Federal Republic of, Iran, Islamic Rep., St. Lucia, Tunisia, Niger, Iraq, Ghana, West Bank and Gaza, São Tomé and Príncipe, Timor-Leste, Uganda, SYR, COD, TUR, ZAF, ALB, PAN, TGO, HTI, ARG, GNB, LBR, GAB, HND, SEN, UZB, COG, GEO, BRA, MDG, IND, CHL, SLE, URY, ZWE, MYS, LAO, CIV, GMB, GRD, BRB, BEN, CHN, MRT, SWZ, VUT, SRB, SLV, BLR, TZA, ARM, COL, NGA, PAK, LSO, MNG, SYC, AGO, MWI, SSD, KAZ, TJK, THA, ZMB, GIN, DJI, DOM, IDN, MNE, JAM, LBN, KGZ, BLZ, COM, NPL, CPV, SUR, TCD, BDI, FJI, BOL, CMR, MLI, SDN, CAF, MAR, ROU, KIR, BGD, RWA, PRY, NAM, PHL, GTM, MUS, ECU, ETH, BFA, MDA, HRV, RUS, LKA, BTN, GNQ, CRI, KEN, BWA, NIC, BGR, MOZ, PER, VNM, EGY, SOM, IRN, LCA, TUN, NER, IRQ, GHA, PSE, STP, TLS, UGA
#> 10                                                 Vanuatu, Bangladesh, Paraguay, Ghana, Mozambique, Afghanistan, Kazakhstan, Panama, Marshall Islands, Bahrain, Nicaragua, Argentina, Azerbaijan, Sri Lanka, Kosovo, Senegal, Barbados, Costa Rica, Armenia, Comoros, Zimbabwe, Eswatini, Bahamas, The, Gambia, The, Angola, Mexico, China, Guinea, Ukraine, Tajikistan, Cameroon, Sierra Leone, Papua New Guinea, Uganda, Uruguay, Zambia, St. Vincent and the Grenadines, St. Lucia, Guinea-Bissau, Gabon, United Arab Emirates, Fiji, Morocco, Myanmar, Egypt, Arab Rep., Jordan, Albania, Equatorial Guinea, Peru, Mauritius, Tuvalu, Bhutan, Burkina Faso, Pakistan, Kuwait, Seychelles, Rwanda, Indonesia, Syrian Arab Republic, Dominica, Nigeria, Bolivia, Kyrgyz Republic, Mongolia, Kenya, Montenegro, Tanzania, Romania, Bosnia and Herzegovina, Micronesia, Fed. Sts., Congo, Rep., Belize, El Salvador, Trinidad and Tobago, Chile, Eritrea, India, Congo, Dem. Rep., South Africa, Namibia, Mauritania, Uzbekistan, Tonga, Chad, Ethiopia, Brazil, Yemen, Rep., Algeria, Georgia, Grenada, Palau, Lesotho, Maldives, Niger, Iran, Islamic Rep., Côte d’Ivoire, Thailand, Suriname, Togo, Poland, Tunisia, Vietnam, Belarus, Cabo Verde, South Sudan, North Macedonia, Mali, São Tomé and Príncipe, Guyana, Madagascar, Iraq, Kiribati, Malawi, West Bank and Gaza, Samoa, Lebanon, Malaysia, Guatemala, Türkiye, Lao PDR, Timor-Leste, Botswana, Haiti, Moldova, Nepal, Russian Federation, Dominican Republic, Saudi Arabia, Liberia, Honduras, Colombia, Oman, Ecuador, Serbia, Croatia, Libya, Bulgaria, Qatar, Sudan, Jamaica, Central African Republic, Philippines, Cambodia, Benin, Solomon Islands, Djibouti, Burundi, VUT, BGD, PRY, GHA, MOZ, AFG, KAZ, PAN, MHL, BHR, NIC, ARG, AZE, LKA, XKX, SEN, BRB, CRI, ARM, COM, ZWE, SWZ, BHS, GMB, AGO, MEX, CHN, GIN, UKR, TJK, CMR, SLE, PNG, UGA, URY, ZMB, VCT, LCA, GNB, GAB, ARE, FJI, MAR, MMR, EGY, JOR, ALB, GNQ, PER, MUS, TUV, BTN, BFA, PAK, KWT, SYC, RWA, IDN, SYR, DMA, NGA, BOL, KGZ, MNG, KEN, MNE, TZA, ROU, BIH, FSM, COG, BLZ, SLV, TTO, CHL, ERI, IND, COD, ZAF, NAM, MRT, UZB, TON, TCD, ETH, BRA, YEM, DZA, GEO, GRD, PLW, LSO, MDV, NER, IRN, CIV, THA, SUR, TGO, POL, TUN, VNM, BLR, CPV, SSD, MKD, MLI, STP, GUY, MDG, IRQ, KIR, MWI, PSE, WSM, LBN, MYS, GTM, TUR, LAO, TLS, BWA, HTI, MDA, NPL, RUS, DOM, SAU, LBR, HND, COL, OMN, ECU, SRB, HRV, LBY, BGR, QAT, SDN, JAM, CAF, PHL, KHM, BEN, SLB, DJI, BDI
#> 11                                                                  Namibia, Morocco, Ukraine, Burundi, Mali, Vanuatu, Guyana, Azerbaijan, Uganda, Dominica, Belarus, Liberia, Bulgaria, Haiti, Pakistan, Solomon Islands, Seychelles, Senegal, Eswatini, Equatorial Guinea, Timor-Leste, Micronesia, Fed. Sts., Syrian Arab Republic, Trinidad and Tobago, Oman, Peru, Fiji, Honduras, Dominican Republic, Kenya, Angola, Afghanistan, Botswana, Kazakhstan, Bahamas, The, Lao PDR, Tanzania, Chile, Montenegro, Tajikistan, Qatar, Saudi Arabia, Malawi, Congo, Dem. Rep., Jordan, Eritrea, Rwanda, Sudan, Cabo Verde, Côte d’Ivoire, United Arab Emirates, Maldives, Costa Rica, Iran, Islamic Rep., Sri Lanka, Panama, Zimbabwe, São Tomé and Príncipe, Türkiye, India, Zambia, Mongolia, El Salvador, Mozambique, Sierra Leone, Gambia, The, Guatemala, South Sudan, China, Russian Federation, Georgia, Cameroon, Guinea-Bissau, Libya, Uzbekistan, Belize, Indonesia, Nepal, Comoros, Tunisia, Romania, Congo, Rep., Cambodia, Croatia, Poland, Bosnia and Herzegovina, Bangladesh, Central African Republic, Kyrgyz Republic, Lebanon, Armenia, Niger, Benin, Jamaica, Albania, St. Lucia, Somalia, Federal Republic of, St. Vincent and the Grenadines, Guinea, Brazil, Bhutan, Philippines, Yemen, Rep., Colombia, Algeria, Ethiopia, Mexico, Bolivia, Togo, Mauritania, Samoa, Chad, Palau, Bahrain, Mauritius, Myanmar, Kosovo, Barbados, Ghana, Vietnam, Kiribati, Nicaragua, West Bank and Gaza, Paraguay, Moldova, Ecuador, Suriname, Djibouti, Gabon, Grenada, Tonga, Thailand, North Macedonia, Iraq, Malaysia, Lesotho, Papua New Guinea, Egypt, Arab Rep., Madagascar, South Africa, Serbia, Burkina Faso, Nigeria, Uruguay, Kuwait, NAM, MAR, UKR, BDI, MLI, VUT, GUY, AZE, UGA, DMA, BLR, LBR, BGR, HTI, PAK, SLB, SYC, SEN, SWZ, GNQ, TLS, FSM, SYR, TTO, OMN, PER, FJI, HND, DOM, KEN, AGO, AFG, BWA, KAZ, BHS, LAO, TZA, CHL, MNE, TJK, QAT, SAU, MWI, COD, JOR, ERI, RWA, SDN, CPV, CIV, ARE, MDV, CRI, IRN, LKA, PAN, ZWE, STP, TUR, IND, ZMB, MNG, SLV, MOZ, SLE, GMB, GTM, SSD, CHN, RUS, GEO, CMR, GNB, LBY, UZB, BLZ, IDN, NPL, COM, TUN, ROU, COG, KHM, HRV, POL, BIH, BGD, CAF, KGZ, LBN, ARM, NER, BEN, JAM, ALB, LCA, SOM, VCT, GIN, BRA, BTN, PHL, YEM, COL, DZA, ETH, MEX, BOL, TGO, MRT, WSM, TCD, PLW, BHR, MUS, MMR, XKX, BRB, GHA, VNM, KIR, NIC, PSE, PRY, MDA, ECU, SUR, DJI, GAB, GRD, TON, THA, MKD, IRQ, MYS, LSO, PNG, EGY, MDG, ZAF, SRB, BFA, NGA, URY, KWT
#> 12                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 Botswana, Benin, Nepal, Senegal, Tajikistan, Fiji, Chile, Namibia, Jamaica, Mauritius, Russian Federation, Thailand, Mali, Montenegro, Malaysia, Gambia, The, Cameroon, Barbados, Belize, Cabo Verde, Philippines, Nicaragua, Côte d’Ivoire, Kyrgyz Republic, West Bank and Gaza, Chad, China, Panama, Serbia, Guinea, Guinea-Bissau, Sri Lanka, Congo, Rep., Liberia, Maldives, Armenia, Bhutan, Bulgaria, Lesotho, Kenya, Mexico, Mongolia, Rwanda, Sierra Leone, Ecuador, Moldova, Congo, Dem. Rep., Croatia, Eswatini, Tunisia, Bangladesh, Uzbekistan, Togo, South Africa, Grenada, Nigeria, Poland, Iran, Islamic Rep., St. Lucia, Mauritania, Uruguay, Syrian Arab Republic, Lao PDR, Malawi, Marshall Islands, Morocco, Vietnam, Haiti, Brazil, Sudan, Suriname, Dominican Republic, Belarus, São Tomé and Príncipe, Angola, Madagascar, Ethiopia, Argentina, Iraq, South Sudan, Costa Rica, Somalia, Federal Republic of, Tonga, Uganda, Georgia, Kazakhstan, Albania, Gabon, Paraguay, Türkiye, Niger, Tanzania, Central African Republic, Colombia, Bolivia, Peru, Comoros, Honduras, Djibouti, Kiribati, Mozambique, Kosovo, Romania, El Salvador, Equatorial Guinea, Zambia, Burkina Faso, Indonesia, Zimbabwe, Seychelles, Lebanon, India, Pakistan, Ghana, North Macedonia, Guatemala, BWA, BEN, NPL, SEN, TJK, FJI, CHL, NAM, JAM, MUS, RUS, THA, MLI, MNE, MYS, GMB, CMR, BRB, BLZ, CPV, PHL, NIC, CIV, KGZ, PSE, TCD, CHN, PAN, SRB, GIN, GNB, LKA, COG, LBR, MDV, ARM, BTN, BGR, LSO, KEN, MEX, MNG, RWA, SLE, ECU, MDA, COD, HRV, SWZ, TUN, BGD, UZB, TGO, ZAF, GRD, NGA, POL, IRN, LCA, MRT, URY, SYR, LAO, MWI, MHL, MAR, VNM, HTI, BRA, SDN, SUR, DOM, BLR, STP, AGO, MDG, ETH, ARG, IRQ, SSD, CRI, SOM, TON, UGA, GEO, KAZ, ALB, GAB, PRY, TUR, NER, TZA, CAF, COL, BOL, PER, COM, HND, DJI, KIR, MOZ, XKX, ROU, SLV, GNQ, ZMB, BFA, IDN, ZWE, SYC, LBN, IND, PAK, GHA, MKD, GTM
#> 13                                                  Barbados, Belarus, Syrian Arab Republic, China, Guyana, Equatorial Guinea, Grenada, North Macedonia, Nepal, Somalia, Federal Republic of, Tonga, Zambia, Libya, Armenia, Lesotho, Russian Federation, Eritrea, Senegal, Seychelles, Bhutan, Azerbaijan, Iraq, Palau, Papua New Guinea, Colombia, Jamaica, Nigeria, Serbia, Cameroon, Thailand, St. Lucia, Kazakhstan, West Bank and Gaza, Sri Lanka, Madagascar, Ethiopia, Ghana, Kyrgyz Republic, Oman, Suriname, Pakistan, Bulgaria, Chile, Uruguay, Morocco, Mongolia, Kuwait, United Arab Emirates, Congo, Dem. Rep., Fiji, Zimbabwe, Lebanon, Djibouti, Iran, Islamic Rep., El Salvador, Egypt, Arab Rep., Tunisia, Cabo Verde, Eswatini, Burkina Faso, Bahamas, The, Saudi Arabia, Dominican Republic, Sudan, Lao PDR, Jordan, Solomon Islands, Myanmar, Guatemala, Benin, Trinidad and Tobago, Romania, Mozambique, Ecuador, Mauritania, Comoros, Ukraine, Mauritius, Qatar, Uganda, Nicaragua, Panama, Central African Republic, Paraguay, Brazil, Chad, Samoa, Côte d’Ivoire, Liberia, India, Tanzania, Philippines, Dominica, Moldova, Togo, Uzbekistan, Belize, South Sudan, Kosovo, Poland, Timor-Leste, Guinea, Bolivia, Botswana, Tajikistan, Gabon, Namibia, St. Vincent and the Grenadines, Angola, Costa Rica, South Africa, Türkiye, Croatia, Kenya, São Tomé and Príncipe, Mexico, Montenegro, Vanuatu, Maldives, Sierra Leone, Congo, Rep., Algeria, Indonesia, Honduras, Bahrain, Malawi, Guinea-Bissau, Mali, Afghanistan, Albania, Kiribati, Rwanda, Peru, Cambodia, Niger, Bangladesh, Vietnam, Burundi, Bosnia and Herzegovina, Malaysia, Haiti, Micronesia, Fed. Sts., Georgia, Gambia, The, Yemen, Rep., Argentina, BRB, BLR, SYR, CHN, GUY, GNQ, GRD, MKD, NPL, SOM, TON, ZMB, LBY, ARM, LSO, RUS, ERI, SEN, SYC, BTN, AZE, IRQ, PLW, PNG, COL, JAM, NGA, SRB, CMR, THA, LCA, KAZ, PSE, LKA, MDG, ETH, GHA, KGZ, OMN, SUR, PAK, BGR, CHL, URY, MAR, MNG, KWT, ARE, COD, FJI, ZWE, LBN, DJI, IRN, SLV, EGY, TUN, CPV, SWZ, BFA, BHS, SAU, DOM, SDN, LAO, JOR, SLB, MMR, GTM, BEN, TTO, ROU, MOZ, ECU, MRT, COM, UKR, MUS, QAT, UGA, NIC, PAN, CAF, PRY, BRA, TCD, WSM, CIV, LBR, IND, TZA, PHL, DMA, MDA, TGO, UZB, BLZ, SSD, XKX, POL, TLS, GIN, BOL, BWA, TJK, GAB, NAM, VCT, AGO, CRI, ZAF, TUR, HRV, KEN, STP, MEX, MNE, VUT, MDV, SLE, COG, DZA, IDN, HND, BHR, MWI, GNB, MLI, AFG, ALB, KIR, RWA, PER, KHM, NER, BGD, VNM, BDI, BIH, MYS, HTI, FSM, GEO, GMB, YEM, ARG
#> 14                                                 Zimbabwe, Mali, Rwanda, Mauritania, Croatia, Kenya, Paraguay, Equatorial Guinea, Djibouti, Chad, Nigeria, Uganda, Central African Republic, Moldova, Iran, Islamic Rep., Vietnam, Egypt, Arab Rep., Niger, Cambodia, Sri Lanka, Mauritius, Nicaragua, Romania, Senegal, Serbia, Sudan, China, Qatar, Montenegro, Ecuador, Kuwait, Marshall Islands, Syrian Arab Republic, Cabo Verde, Mongolia, Bulgaria, Kosovo, Suriname, Guatemala, Afghanistan, Iraq, Namibia, Bosnia and Herzegovina, Malaysia, Botswana, Gabon, Ukraine, Grenada, Guyana, Bolivia, Dominican Republic, Saudi Arabia, Türkiye, Colombia, Madagascar, St. Lucia, Tuvalu, São Tomé and Príncipe, Indonesia, Angola, Mozambique, Guinea, Mexico, Chile, Azerbaijan, Palau, Zambia, Micronesia, Fed. Sts., Panama, Dominica, Philippines, Seychelles, Barbados, Benin, Lesotho, Fiji, United Arab Emirates, Costa Rica, Ghana, Uzbekistan, Argentina, Bahrain, Guinea-Bissau, Cameroon, Lebanon, Albania, South Africa, Malawi, Morocco, Belarus, Samoa, Ethiopia, West Bank and Gaza, Solomon Islands, Congo, Rep., Myanmar, Uruguay, Burkina Faso, Jamaica, El Salvador, Bhutan, Pakistan, Tunisia, Kiribati, Libya, Lao PDR, Peru, Maldives, Congo, Dem. Rep., India, Vanuatu, St. Vincent and the Grenadines, Haiti, Eritrea, Russian Federation, Côte d’Ivoire, Tanzania, Trinidad and Tobago, Algeria, Yemen, Rep., Thailand, Jordan, Timor-Leste, Poland, Armenia, Honduras, Belize, Gambia, The, Liberia, North Macedonia, Kyrgyz Republic, Bangladesh, Eswatini, Papua New Guinea, Comoros, Nepal, Kazakhstan, Burundi, Oman, Togo, Brazil, Tajikistan, Bahamas, The, Sierra Leone, South Sudan, Georgia, Tonga, ZWE, MLI, RWA, MRT, HRV, KEN, PRY, GNQ, DJI, TCD, NGA, UGA, CAF, MDA, IRN, VNM, EGY, NER, KHM, LKA, MUS, NIC, ROU, SEN, SRB, SDN, CHN, QAT, MNE, ECU, KWT, MHL, SYR, CPV, MNG, BGR, XKX, SUR, GTM, AFG, IRQ, NAM, BIH, MYS, BWA, GAB, UKR, GRD, GUY, BOL, DOM, SAU, TUR, COL, MDG, LCA, TUV, STP, IDN, AGO, MOZ, GIN, MEX, CHL, AZE, PLW, ZMB, FSM, PAN, DMA, PHL, SYC, BRB, BEN, LSO, FJI, ARE, CRI, GHA, UZB, ARG, BHR, GNB, CMR, LBN, ALB, ZAF, MWI, MAR, BLR, WSM, ETH, PSE, SLB, COG, MMR, URY, BFA, JAM, SLV, BTN, PAK, TUN, KIR, LBY, LAO, PER, MDV, COD, IND, VUT, VCT, HTI, ERI, RUS, CIV, TZA, TTO, DZA, YEM, THA, JOR, TLS, POL, ARM, HND, BLZ, GMB, LBR, MKD, KGZ, BGD, SWZ, PNG, COM, NPL, KAZ, BDI, OMN, TGO, BRA, TJK, BHS, SLE, SSD, GEO, TON
#> 15                                                  Bolivia, Serbia, Tajikistan, Argentina, Brazil, South Sudan, Guinea, Mongolia, Kyrgyz Republic, Lebanon, Malaysia, Côte d’Ivoire, Botswana, Qatar, Thailand, North Macedonia, Tanzania, Egypt, Arab Rep., Montenegro, Maldives, Guinea-Bissau, Iraq, Croatia, Seychelles, Comoros, Central African Republic, Poland, São Tomé and Príncipe, St. Vincent and the Grenadines, Mozambique, Rwanda, Samoa, Nigeria, Peru, Armenia, Niger, Timor-Leste, Bahamas, The, Burundi, Congo, Rep., Vietnam, Micronesia, Fed. Sts., Bangladesh, Sudan, Barbados, Eswatini, Zambia, Lesotho, China, Yemen, Rep., Guyana, Zimbabwe, Namibia, St. Lucia, Romania, West Bank and Gaza, Tonga, Cabo Verde, Uganda, Georgia, Cameroon, Angola, Bahrain, Iran, Islamic Rep., Jamaica, Sri Lanka, Uzbekistan, Syrian Arab Republic, Dominica, Kuwait, Somalia, Federal Republic of, Uruguay, Albania, Djibouti, El Salvador, Pakistan, Equatorial Guinea, Oman, Tunisia, Trinidad and Tobago, Türkiye, Philippines, Panama, Jordan, Colombia, Togo, Ghana, Lao PDR, Algeria, Benin, Ecuador, Chad, Burkina Faso, Afghanistan, Vanuatu, Gambia, The, Sierra Leone, Morocco, Haiti, Bhutan, Guatemala, Belarus, Bulgaria, Malawi, Myanmar, Gabon, Kazakhstan, Solomon Islands, Ukraine, Nicaragua, Bosnia and Herzegovina, Russian Federation, Liberia, Dominican Republic, Palau, Suriname, South Africa, Kiribati, Kenya, Azerbaijan, Costa Rica, Cambodia, Mauritius, Fiji, Nepal, Chile, Congo, Dem. Rep., Mali, Mexico, Saudi Arabia, Madagascar, United Arab Emirates, Papua New Guinea, Grenada, India, Paraguay, Belize, Libya, Ethiopia, Honduras, Kosovo, Mauritania, Senegal, Moldova, Eritrea, Indonesia, BOL, SRB, TJK, ARG, BRA, SSD, GIN, MNG, KGZ, LBN, MYS, CIV, BWA, QAT, THA, MKD, TZA, EGY, MNE, MDV, GNB, IRQ, HRV, SYC, COM, CAF, POL, STP, VCT, MOZ, RWA, WSM, NGA, PER, ARM, NER, TLS, BHS, BDI, COG, VNM, FSM, BGD, SDN, BRB, SWZ, ZMB, LSO, CHN, YEM, GUY, ZWE, NAM, LCA, ROU, PSE, TON, CPV, UGA, GEO, CMR, AGO, BHR, IRN, JAM, LKA, UZB, SYR, DMA, KWT, SOM, URY, ALB, DJI, SLV, PAK, GNQ, OMN, TUN, TTO, TUR, PHL, PAN, JOR, COL, TGO, GHA, LAO, DZA, BEN, ECU, TCD, BFA, AFG, VUT, GMB, SLE, MAR, HTI, BTN, GTM, BLR, BGR, MWI, MMR, GAB, KAZ, SLB, UKR, NIC, BIH, RUS, LBR, DOM, PLW, SUR, ZAF, KIR, KEN, AZE, CRI, KHM, MUS, FJI, NPL, CHL, COD, MLI, MEX, SAU, MDG, ARE, PNG, GRD, IND, PRY, BLZ, LBY, ETH, HND, XKX, MRT, SEN, MDA, ERI, IDN
#> 16                                                                                                                                                                                                                                                                                                                                    Nigeria, Maldives, Uganda, Uzbekistan, Bahamas, The, Malaysia, Senegal, India, Guatemala, Montenegro, Kenya, Vietnam, Mali, Zimbabwe, Panama, Argentina, Congo, Rep., Namibia, Mexico, Botswana, Lesotho, Serbia, Mongolia, Kosovo, Haiti, Kyrgyz Republic, Gabon, Kiribati, United Arab Emirates, Jordan, Mauritius, Peru, Cabo Verde, Egypt, Arab Rep., Mauritania, Samoa, Colombia, North Macedonia, Bosnia and Herzegovina, Belarus, Croatia, Afghanistan, Costa Rica, Marshall Islands, Honduras, Chad, Cameroon, Azerbaijan, Bulgaria, Malawi, Qatar, Paraguay, Algeria, Armenia, Seychelles, Bhutan, Albania, Myanmar, Pakistan, Eswatini, Oman, West Bank and Gaza, Thailand, Bangladesh, Iran, Islamic Rep., Kazakhstan, Iraq, Kuwait, Gambia, The, Zambia, Chile, Georgia, Guinea-Bissau, Belize, El Salvador, Tanzania, Guinea, Ecuador, Yemen, Rep., Brazil, Nepal, Lebanon, Morocco, Nicaragua, Moldova, South Africa, Libya, Romania, Bahrain, Burundi, Ghana, Comoros, Central African Republic, Congo, Dem. Rep., Saudi Arabia, Ukraine, Cambodia, Sri Lanka, Ethiopia, Timor-Leste, Poland, Sierra Leone, Uruguay, Türkiye, Indonesia, Benin, Sudan, Tajikistan, Bolivia, Somalia, Federal Republic of, Mozambique, Angola, Russian Federation, Tunisia, Syrian Arab Republic, Jamaica, Togo, Dominican Republic, Rwanda, Vanuatu, Liberia, Niger, Solomon Islands, Burkina Faso, China, Eritrea, Côte d’Ivoire, Madagascar, Philippines, Equatorial Guinea, Djibouti, NGA, MDV, UGA, UZB, BHS, MYS, SEN, IND, GTM, MNE, KEN, VNM, MLI, ZWE, PAN, ARG, COG, NAM, MEX, BWA, LSO, SRB, MNG, XKX, HTI, KGZ, GAB, KIR, ARE, JOR, MUS, PER, CPV, EGY, MRT, WSM, COL, MKD, BIH, BLR, HRV, AFG, CRI, MHL, HND, TCD, CMR, AZE, BGR, MWI, QAT, PRY, DZA, ARM, SYC, BTN, ALB, MMR, PAK, SWZ, OMN, PSE, THA, BGD, IRN, KAZ, IRQ, KWT, GMB, ZMB, CHL, GEO, GNB, BLZ, SLV, TZA, GIN, ECU, YEM, BRA, NPL, LBN, MAR, NIC, MDA, ZAF, LBY, ROU, BHR, BDI, GHA, COM, CAF, COD, SAU, UKR, KHM, LKA, ETH, TLS, POL, SLE, URY, TUR, IDN, BEN, SDN, TJK, BOL, SOM, MOZ, AGO, RUS, TUN, SYR, JAM, TGO, DOM, RWA, VUT, LBR, NER, SLB, BFA, CHN, ERI, CIV, MDG, PHL, GNQ, DJI
#> 17                                                                                                                                                                                                                                                                                                                       Sri Lanka, Mongolia, Iraq, Madagascar, Malawi, South Africa, Bahrain, Guinea-Bissau, Yemen, Rep., Montenegro, Uzbekistan, Costa Rica, Ukraine, Congo, Dem. Rep., Cabo Verde, Zimbabwe, Romania, Peru, Armenia, Gambia, The, Afghanistan, Haiti, Marshall Islands, Bahamas, The, Samoa, Algeria, Libya, Tunisia, Moldova, Chad, El Salvador, Indonesia, Benin, Vietnam, Egypt, Arab Rep., Poland, Ghana, Uruguay, Syrian Arab Republic, Tajikistan, Bosnia and Herzegovina, Bangladesh, Nepal, Kenya, Botswana, Türkiye, Azerbaijan, Georgia, Kuwait, Dominican Republic, North Macedonia, Saudi Arabia, Colombia, Maldives, Nigeria, Thailand, Lebanon, Malaysia, Argentina, Guatemala, Belize, Mexico, Somalia, Federal Republic of, Kosovo, Belarus, Niger, Vanuatu, Honduras, Senegal, India, Kyrgyz Republic, Guinea, Eritrea, Rwanda, Namibia, Equatorial Guinea, Pakistan, Chile, Congo, Rep., Uganda, Burkina Faso, Solomon Islands, Jordan, Nicaragua, Eswatini, Philippines, Paraguay, Croatia, Timor-Leste, Bolivia, Oman, Mozambique, Russian Federation, Qatar, Brazil, Comoros, Morocco, Kazakhstan, Liberia, China, Djibouti, Central African Republic, Zambia, Serbia, Togo, Burundi, Ethiopia, Albania, Bhutan, Tanzania, Angola, Cameroon, Myanmar, West Bank and Gaza, Côte d’Ivoire, Lesotho, Ecuador, Mauritania, Gabon, Sierra Leone, Bulgaria, Jamaica, United Arab Emirates, Mali, Panama, Mauritius, Sudan, Naoero, Cambodia, Kiribati, Seychelles, Iran, Islamic Rep., LKA, MNG, IRQ, MDG, MWI, ZAF, BHR, GNB, YEM, MNE, UZB, CRI, UKR, COD, CPV, ZWE, ROU, PER, ARM, GMB, AFG, HTI, MHL, BHS, WSM, DZA, LBY, TUN, MDA, TCD, SLV, IDN, BEN, VNM, EGY, POL, GHA, URY, SYR, TJK, BIH, BGD, NPL, KEN, BWA, TUR, AZE, GEO, KWT, DOM, MKD, SAU, COL, MDV, NGA, THA, LBN, MYS, ARG, GTM, BLZ, MEX, SOM, XKX, BLR, NER, VUT, HND, SEN, IND, KGZ, GIN, ERI, RWA, NAM, GNQ, PAK, CHL, COG, UGA, BFA, SLB, JOR, NIC, SWZ, PHL, PRY, HRV, TLS, BOL, OMN, MOZ, RUS, QAT, BRA, COM, MAR, KAZ, LBR, CHN, DJI, CAF, ZMB, SRB, TGO, BDI, ETH, ALB, BTN, TZA, AGO, CMR, MMR, PSE, CIV, LSO, ECU, MRT, GAB, SLE, BGR, JAM, ARE, MLI, PAN, MUS, SDN, NRU, KHM, KIR, SYC, IRN
#> 18                                                 Malawi, Tajikistan, Russian Federation, Sudan, Nicaragua, Suriname, Solomon Islands, Egypt, Arab Rep., Liberia, Mauritania, Mali, Ukraine, Samoa, Benin, Panama, Zambia, Bolivia, El Salvador, Micronesia, Fed. Sts., Mauritius, Chile, Kuwait, Romania, Peru, China, Equatorial Guinea, Bosnia and Herzegovina, Madagascar, Bulgaria, Cabo Verde, West Bank and Gaza, India, Marshall Islands, Seychelles, Costa Rica, Brazil, Dominican Republic, Gambia, The, Jordan, Oman, Djibouti, Morocco, São Tomé and Príncipe, Dominica, Ethiopia, Uruguay, Algeria, Tuvalu, Yemen, Rep., Colombia, Eritrea, Poland, Botswana, Palau, Grenada, Zimbabwe, Nepal, Vietnam, Guyana, Kenya, Malaysia, Kosovo, United Arab Emirates, Tonga, Libya, Myanmar, Honduras, Iraq, Kiribati, Ecuador, Tanzania, Sierra Leone, Belarus, Fiji, Central African Republic, Bahrain, Togo, Vanuatu, Sri Lanka, Cambodia, South Sudan, Lao PDR, Albania, Nigeria, Burundi, Iran, Islamic Rep., Barbados, Philippines, Mozambique, Bhutan, Thailand, Syrian Arab Republic, Papua New Guinea, Chad, Bahamas, The, Haiti, Armenia, Côte d’Ivoire, Azerbaijan, Guinea-Bissau, Uzbekistan, Tunisia, Belize, Montenegro, Angola, Kazakhstan, St. Vincent and the Grenadines, Congo, Dem. Rep., Lesotho, North Macedonia, Indonesia, Jamaica, South Africa, Trinidad and Tobago, Ghana, Comoros, Croatia, Cameroon, Moldova, Maldives, Argentina, Bangladesh, Georgia, Türkiye, Senegal, St. Lucia, Namibia, Qatar, Pakistan, Timor-Leste, Congo, Rep., Mongolia, Uganda, Afghanistan, Rwanda, Guinea, Kyrgyz Republic, Serbia, Lebanon, Niger, Burkina Faso, Gabon, Guatemala, Paraguay, Eswatini, Mexico, Saudi Arabia, MWI, TJK, RUS, SDN, NIC, SUR, SLB, EGY, LBR, MRT, MLI, UKR, WSM, BEN, PAN, ZMB, BOL, SLV, FSM, MUS, CHL, KWT, ROU, PER, CHN, GNQ, BIH, MDG, BGR, CPV, PSE, IND, MHL, SYC, CRI, BRA, DOM, GMB, JOR, OMN, DJI, MAR, STP, DMA, ETH, URY, DZA, TUV, YEM, COL, ERI, POL, BWA, PLW, GRD, ZWE, NPL, VNM, GUY, KEN, MYS, XKX, ARE, TON, LBY, MMR, HND, IRQ, KIR, ECU, TZA, SLE, BLR, FJI, CAF, BHR, TGO, VUT, LKA, KHM, SSD, LAO, ALB, NGA, BDI, IRN, BRB, PHL, MOZ, BTN, THA, SYR, PNG, TCD, BHS, HTI, ARM, CIV, AZE, GNB, UZB, TUN, BLZ, MNE, AGO, KAZ, VCT, COD, LSO, MKD, IDN, JAM, ZAF, TTO, GHA, COM, HRV, CMR, MDA, MDV, ARG, BGD, GEO, TUR, SEN, LCA, NAM, QAT, PAK, TLS, COG, MNG, UGA, AFG, RWA, GIN, KGZ, SRB, LBN, NER, BFA, GAB, GTM, PRY, SWZ, MEX, SAU
#> 19                                                  Brazil, Mongolia, Timor-Leste, Qatar, Jordan, North Macedonia, Nigeria, Ghana, Pakistan, Malawi, Angola, South Sudan, St. Lucia, Bhutan, Russian Federation, Uruguay, Congo, Rep., Gambia, The, Malaysia, Kenya, Burkina Faso, Ethiopia, Eritrea, Gabon, St. Vincent and the Grenadines, Poland, Mexico, Guyana, Honduras, Colombia, Serbia, Thailand, Vanuatu, Belize, Sri Lanka, Mali, Zambia, Türkiye, Tanzania, Niger, Burundi, Egypt, Arab Rep., Botswana, Lao PDR, Guinea, Cameroon, Uzbekistan, Morocco, Mauritius, Palau, Iran, Islamic Rep., Congo, Dem. Rep., Central African Republic, Barbados, Ukraine, Kiribati, Syrian Arab Republic, Samoa, Trinidad and Tobago, Algeria, Grenada, Maldives, Tunisia, Micronesia, Fed. Sts., Equatorial Guinea, Albania, Oman, Senegal, Indonesia, China, Afghanistan, Bosnia and Herzegovina, Bahrain, Seychelles, Benin, Azerbaijan, São Tomé and Príncipe, Bulgaria, Vietnam, Kazakhstan, Kuwait, Romania, Georgia, Costa Rica, Zimbabwe, Sierra Leone, United Arab Emirates, Cabo Verde, Panama, Belarus, Lebanon, Nepal, Chile, Togo, Armenia, Fiji, Iraq, Somalia, Federal Republic of, Côte d’Ivoire, Moldova, Tajikistan, Dominican Republic, Papua New Guinea, Tonga, Peru, Sudan, Rwanda, Mauritania, Suriname, Chad, Madagascar, Bahamas, The, India, Cambodia, Philippines, West Bank and Gaza, Yemen, Rep., Kyrgyz Republic, Myanmar, Lesotho, Saudi Arabia, Montenegro, El Salvador, Uganda, Bolivia, Croatia, Jamaica, Kosovo, Ecuador, Comoros, Dominica, Guatemala, Mozambique, South Africa, Solomon Islands, Paraguay, Haiti, Liberia, Nicaragua, Eswatini, Guinea-Bissau, Namibia, Argentina, Libya, Bangladesh, Djibouti, BRA, MNG, TLS, QAT, JOR, MKD, NGA, GHA, PAK, MWI, AGO, SSD, LCA, BTN, RUS, URY, COG, GMB, MYS, KEN, BFA, ETH, ERI, GAB, VCT, POL, MEX, GUY, HND, COL, SRB, THA, VUT, BLZ, LKA, MLI, ZMB, TUR, TZA, NER, BDI, EGY, BWA, LAO, GIN, CMR, UZB, MAR, MUS, PLW, IRN, COD, CAF, BRB, UKR, KIR, SYR, WSM, TTO, DZA, GRD, MDV, TUN, FSM, GNQ, ALB, OMN, SEN, IDN, CHN, AFG, BIH, BHR, SYC, BEN, AZE, STP, BGR, VNM, KAZ, KWT, ROU, GEO, CRI, ZWE, SLE, ARE, CPV, PAN, BLR, LBN, NPL, CHL, TGO, ARM, FJI, IRQ, SOM, CIV, MDA, TJK, DOM, PNG, TON, PER, SDN, RWA, MRT, SUR, TCD, MDG, BHS, IND, KHM, PHL, PSE, YEM, KGZ, MMR, LSO, SAU, MNE, SLV, UGA, BOL, HRV, JAM, XKX, ECU, COM, DMA, GTM, MOZ, ZAF, SLB, PRY, HTI, LBR, NIC, SWZ, GNB, NAM, ARG, LBY, BGD, DJI
#> 20 Cambodia, Kyrgyz Republic, Eswatini, Botswana, Kosovo, Kenya, India, Vietnam, Burundi, El Salvador, China, Angola, Equatorial Guinea, Fiji, Micronesia, Fed. Sts., Jamaica, Lebanon, Ecuador, Romania, Liberia, Gambia, The, Chile, Guyana, Mongolia, Yemen, Rep., Vanuatu, Myanmar, Algeria, Benin, Trinidad and Tobago, Syrian Arab Republic, St. Vincent and the Grenadines, Seychelles, Dominica, Bangladesh, Pakistan, Bahrain, Dominican Republic, Tajikistan, Kuwait, Uganda, Thailand, Mauritius, Nigeria, Philippines, Bahamas, The, Malaysia, Kiribati, Honduras, Morocco, Samoa, Nepal, Zambia, Argentina, Maldives, Palau, Grenada, Uruguay, Congo, Dem. Rep., Belarus, Rwanda, Tunisia, Central African Republic, Iraq, Congo, Rep., Bulgaria, Cameroon, Cabo Verde, Barbados, Naoero, Tonga, Colombia, Papua New Guinea, Oman, South Sudan, Türkiye, Tanzania, Croatia, Niger, Qatar, Solomon Islands, Nicaragua, Namibia, Tuvalu, Jordan, Zimbabwe, Sudan, Chad, St. Lucia, Ethiopia, Lesotho, Mozambique, Egypt, Arab Rep., Eritrea, Bhutan, Sri Lanka, Kazakhstan, Belize, Madagascar, Uzbekistan, Senegal, West Bank and Gaza, Guinea, Timor-Leste, Azerbaijan, Côte d’Ivoire, Togo, Bolivia, Mali, Mexico, Serbia, Montenegro, Haiti, Lao PDR, North Macedonia, Afghanistan, Paraguay, Albania, Sierra Leone, Mauritania, Guatemala, South Africa, Somalia, Federal Republic of, Djibouti, United Arab Emirates, Ghana, Moldova, Marshall Islands, Panama, Costa Rica, Guinea-Bissau, São Tomé and Príncipe, Russian Federation, Ukraine, Gabon, Burkina Faso, Suriname, Georgia, Comoros, Libya, Poland, Brazil, Peru, Indonesia, Saudi Arabia, Bosnia and Herzegovina, Malawi, Iran, Islamic Rep., Armenia, KHM, KGZ, SWZ, BWA, XKX, KEN, IND, VNM, BDI, SLV, CHN, AGO, GNQ, FJI, FSM, JAM, LBN, ECU, ROU, LBR, GMB, CHL, GUY, MNG, YEM, VUT, MMR, DZA, BEN, TTO, SYR, VCT, SYC, DMA, BGD, PAK, BHR, DOM, TJK, KWT, UGA, THA, MUS, NGA, PHL, BHS, MYS, KIR, HND, MAR, WSM, NPL, ZMB, ARG, MDV, PLW, GRD, URY, COD, BLR, RWA, TUN, CAF, IRQ, COG, BGR, CMR, CPV, BRB, NRU, TON, COL, PNG, OMN, SSD, TUR, TZA, HRV, NER, QAT, SLB, NIC, NAM, TUV, JOR, ZWE, SDN, TCD, LCA, ETH, LSO, MOZ, EGY, ERI, BTN, LKA, KAZ, BLZ, MDG, UZB, SEN, PSE, GIN, TLS, AZE, CIV, TGO, BOL, MLI, MEX, SRB, MNE, HTI, LAO, MKD, AFG, PRY, ALB, SLE, MRT, GTM, ZAF, SOM, DJI, ARE, GHA, MDA, MHL, PAN, CRI, GNB, STP, RUS, UKR, GAB, BFA, SUR, GEO, COM, LBY, POL, BRA, PER, IDN, SAU, BIH, MWI, IRN, ARM
#> 21                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    Kosovo, Tuvalu, Marshall Islands, West Bank and Gaza, Naoero, XKX, TUV, MHL, PSE, NRU
#> 22                                                                                        Djibouti, Zimbabwe, Saudi Arabia, Thailand, Congo, Dem. Rep., Lesotho, Ethiopia, Maldives, Nigeria, Liberia, Sierra Leone, Colombia, Somalia, Federal Republic of, Tonga, Madagascar, Tunisia, Armenia, South Africa, Belize, Guinea-Bissau, Serbia, Solomon Islands, Pakistan, Ukraine, Sudan, Senegal, Yemen, Rep., Russian Federation, Georgia, Palau, Bolivia, Nepal, Cabo Verde, Mongolia, Comoros, Ghana, Togo, Bulgaria, Poland, Myanmar, Iraq, Jamaica, Cambodia, Vanuatu, Niger, Tajikistan, Seychelles, Iran, Islamic Rep., Albania, Eritrea, Mexico, Afghanistan, Uruguay, Gambia, The, St. Vincent and the Grenadines, Grenada, Bosnia and Herzegovina, Brazil, Côte d’Ivoire, Tanzania, Papua New Guinea, Panama, El Salvador, Haiti, Oman, Uzbekistan, Qatar, Uganda, Mauritius, Congo, Rep., Zambia, Jordan, Guinea, China, Vietnam, Dominican Republic, Montenegro, Indonesia, Namibia, South Sudan, Morocco, São Tomé and Príncipe, Algeria, Bahamas, The, Chad, Benin, Burkina Faso, Kuwait, Chile, Lebanon, Kiribati, Libya, Belarus, Lao PDR, Ecuador, Guyana, Dominica, Kyrgyz Republic, Mali, Peru, Rwanda, Fiji, Moldova, Micronesia, Fed. Sts., Malaysia, Eswatini, Trinidad and Tobago, Nicaragua, Paraguay, Kazakhstan, Suriname, Honduras, Egypt, Arab Rep., Malawi, Mozambique, Azerbaijan, Barbados, St. Lucia, Türkiye, Burundi, Philippines, Bangladesh, Bhutan, Syrian Arab Republic, United Arab Emirates, Guatemala, Gabon, Croatia, India, Central African Republic, North Macedonia, Sri Lanka, Romania, Costa Rica, Cameroon, Mauritania, Bahrain, Angola, Argentina, Kenya, Equatorial Guinea, Samoa, Timor-Leste, Botswana, DJI, ZWE, SAU, THA, COD, LSO, ETH, MDV, NGA, LBR, SLE, COL, SOM, TON, MDG, TUN, ARM, ZAF, BLZ, GNB, SRB, SLB, PAK, UKR, SDN, SEN, YEM, RUS, GEO, PLW, BOL, NPL, CPV, MNG, COM, GHA, TGO, BGR, POL, MMR, IRQ, JAM, KHM, VUT, NER, TJK, SYC, IRN, ALB, ERI, MEX, AFG, URY, GMB, VCT, GRD, BIH, BRA, CIV, TZA, PNG, PAN, SLV, HTI, OMN, UZB, QAT, UGA, MUS, COG, ZMB, JOR, GIN, CHN, VNM, DOM, MNE, IDN, NAM, SSD, MAR, STP, DZA, BHS, TCD, BEN, BFA, KWT, CHL, LBN, KIR, LBY, BLR, LAO, ECU, GUY, DMA, KGZ, MLI, PER, RWA, FJI, MDA, FSM, MYS, SWZ, TTO, NIC, PRY, KAZ, SUR, HND, EGY, MWI, MOZ, AZE, BRB, LCA, TUR, BDI, PHL, BGD, BTN, SYR, ARE, GTM, GAB, HRV, IND, CAF, MKD, LKA, ROU, CRI, CMR, MRT, BHR, AGO, ARG, KEN, GNQ, WSM, TLS, BWA
#> 23                                                                                        Congo, Dem. Rep., Lebanon, Niger, El Salvador, Uganda, Ghana, Haiti, Madagascar, Uzbekistan, Burkina Faso, Barbados, Cambodia, Chile, North Macedonia, Bangladesh, Sierra Leone, Croatia, Kazakhstan, Bahrain, Guinea, Poland, Angola, Senegal, Tajikistan, Samoa, Cabo Verde, Nicaragua, Papua New Guinea, Algeria, Kuwait, Mozambique, Gabon, Kenya, São Tomé and Príncipe, Burundi, Montenegro, Pakistan, Mexico, Qatar, Malaysia, Tanzania, Guatemala, Honduras, Brazil, India, Zimbabwe, Iraq, Tonga, Guyana, Congo, Rep., Bahamas, The, Paraguay, Kiribati, Yemen, Rep., China, Egypt, Arab Rep., Ethiopia, Lao PDR, Iran, Islamic Rep., Uruguay, Solomon Islands, Tunisia, Serbia, Guinea-Bissau, Botswana, Russian Federation, Palau, Romania, Ecuador, United Arab Emirates, South Sudan, Mauritania, Dominican Republic, Chad, Lesotho, Albania, Ukraine, Rwanda, Bulgaria, Türkiye, Peru, Mongolia, Libya, Liberia, Equatorial Guinea, Azerbaijan, Fiji, Suriname, Morocco, Panama, Timor-Leste, Sudan, Trinidad and Tobago, Eritrea, Myanmar, Micronesia, Fed. Sts., Somalia, Federal Republic of, Belize, Togo, Saudi Arabia, Vanuatu, Moldova, Nepal, St. Lucia, Dominica, Namibia, Belarus, Bhutan, Armenia, Philippines, Zambia, Malawi, Costa Rica, Georgia, Maldives, South Africa, Mauritius, Gambia, The, Vietnam, Djibouti, Bolivia, Mali, Benin, Comoros, Nigeria, Afghanistan, Syrian Arab Republic, St. Vincent and the Grenadines, Eswatini, Central African Republic, Kyrgyz Republic, Argentina, Seychelles, Jamaica, Grenada, Oman, Indonesia, Cameroon, Sri Lanka, Côte d’Ivoire, Jordan, Thailand, Colombia, Bosnia and Herzegovina, COD, LBN, NER, SLV, UGA, GHA, HTI, MDG, UZB, BFA, BRB, KHM, CHL, MKD, BGD, SLE, HRV, KAZ, BHR, GIN, POL, AGO, SEN, TJK, WSM, CPV, NIC, PNG, DZA, KWT, MOZ, GAB, KEN, STP, BDI, MNE, PAK, MEX, QAT, MYS, TZA, GTM, HND, BRA, IND, ZWE, IRQ, TON, GUY, COG, BHS, PRY, KIR, YEM, CHN, EGY, ETH, LAO, IRN, URY, SLB, TUN, SRB, GNB, BWA, RUS, PLW, ROU, ECU, ARE, SSD, MRT, DOM, TCD, LSO, ALB, UKR, RWA, BGR, TUR, PER, MNG, LBY, LBR, GNQ, AZE, FJI, SUR, MAR, PAN, TLS, SDN, TTO, ERI, MMR, FSM, SOM, BLZ, TGO, SAU, VUT, MDA, NPL, LCA, DMA, NAM, BLR, BTN, ARM, PHL, ZMB, MWI, CRI, GEO, MDV, ZAF, MUS, GMB, VNM, DJI, BOL, MLI, BEN, COM, NGA, AFG, SYR, VCT, SWZ, CAF, KGZ, ARG, SYC, JAM, GRD, OMN, IDN, CMR, LKA, CIV, JOR, THA, COL, BIH
#> 24                                                                                                                                                                                                                                                                                                                                    Burkina Faso, Burundi, Kuwait, Togo, Mauritius, Thailand, Moldova, Philippines, Sudan, Afghanistan, Solomon Islands, Syrian Arab Republic, Tanzania, Benin, Guinea, Jordan, Armenia, Uzbekistan, Mauritania, Kiribati, Tunisia, Maldives, Bhutan, Ghana, Mali, Colombia, Kazakhstan, Vietnam, Sierra Leone, Namibia, Gabon, Chad, Pakistan, Oman, Iraq, Panama, Central African Republic, Marshall Islands, Samoa, Argentina, Bulgaria, Yemen, Rep., Guatemala, Sri Lanka, Congo, Rep., Bolivia, Kyrgyz Republic, Equatorial Guinea, Uganda, Serbia, El Salvador, Congo, Dem. Rep., Jamaica, Nigeria, Rwanda, Mongolia, Ethiopia, Liberia, Mozambique, Niger, Azerbaijan, Russian Federation, Zambia, Qatar, Djibouti, Croatia, Belarus, Bahamas, The, South Africa, China, India, Malawi, Peru, Indonesia, Somalia, Federal Republic of, Türkiye, Haiti, Kenya, Chile, Romania, Algeria, Eswatini, Egypt, Arab Rep., Iran, Islamic Rep., Nicaragua, Georgia, United Arab Emirates, Gambia, The, Tajikistan, Comoros, Honduras, Bangladesh, Senegal, Paraguay, Cambodia, Lebanon, Seychelles, Montenegro, Belize, Morocco, Uruguay, Côte d’Ivoire, Guinea-Bissau, Madagascar, Myanmar, Costa Rica, Cabo Verde, Angola, Poland, Bosnia and Herzegovina, Cameroon, Mexico, Brazil, Eritrea, Vanuatu, West Bank and Gaza, Nepal, Malaysia, Timor-Leste, Bahrain, Dominican Republic, Kosovo, Ukraine, Lesotho, Libya, Zimbabwe, Albania, Saudi Arabia, Botswana, North Macedonia, Ecuador, BFA, BDI, KWT, TGO, MUS, THA, MDA, PHL, SDN, AFG, SLB, SYR, TZA, BEN, GIN, JOR, ARM, UZB, MRT, KIR, TUN, MDV, BTN, GHA, MLI, COL, KAZ, VNM, SLE, NAM, GAB, TCD, PAK, OMN, IRQ, PAN, CAF, MHL, WSM, ARG, BGR, YEM, GTM, LKA, COG, BOL, KGZ, GNQ, UGA, SRB, SLV, COD, JAM, NGA, RWA, MNG, ETH, LBR, MOZ, NER, AZE, RUS, ZMB, QAT, DJI, HRV, BLR, BHS, ZAF, CHN, IND, MWI, PER, IDN, SOM, TUR, HTI, KEN, CHL, ROU, DZA, SWZ, EGY, IRN, NIC, GEO, ARE, GMB, TJK, COM, HND, BGD, SEN, PRY, KHM, LBN, SYC, MNE, BLZ, MAR, URY, CIV, GNB, MDG, MMR, CRI, CPV, AGO, POL, BIH, CMR, MEX, BRA, ERI, VUT, PSE, NPL, MYS, TLS, BHR, DOM, XKX, UKR, LSO, LBY, ZWE, ALB, SAU, BWA, MKD, ECU
#> 25 Bolivia, Vanuatu, Oman, Myanmar, Kazakhstan, Poland, Gambia, The, Brazil, Montenegro, Chad, Sri Lanka, Mongolia, St. Lucia, Naoero, Peru, Uruguay, Ukraine, West Bank and Gaza, Bangladesh, Namibia, Mozambique, Russian Federation, South Africa, Eswatini, Tonga, Saudi Arabia, Tanzania, North Macedonia, Suriname, Guatemala, Libya, Kyrgyz Republic, Croatia, Sierra Leone, Guyana, Kosovo, Barbados, Bahrain, Rwanda, Burundi, Afghanistan, Albania, Eritrea, Cameroon, Costa Rica, Côte d’Ivoire, Comoros, Lesotho, Madagascar, Somalia, Federal Republic of, Algeria, Bhutan, Tajikistan, Mali, Guinea, Colombia, Syrian Arab Republic, Ghana, Serbia, Kiribati, Djibouti, Nigeria, Bahamas, The, Trinidad and Tobago, Belarus, South Sudan, Malaysia, Pakistan, Timor-Leste, Zambia, Jordan, Uganda, Uzbekistan, Central African Republic, Honduras, Marshall Islands, Iraq, Zimbabwe, Paraguay, Sudan, Tuvalu, Chile, Benin, Seychelles, Belize, Samoa, Yemen, Rep., Lebanon, Romania, Tunisia, Armenia, Papua New Guinea, Ecuador, Burkina Faso, Iran, Islamic Rep., Jamaica, Qatar, Dominican Republic, Grenada, Senegal, Georgia, Guinea-Bissau, Cambodia, Gabon, Palau, Congo, Dem. Rep., Morocco, Mexico, Botswana, Vietnam, Micronesia, Fed. Sts., Argentina, São Tomé and Príncipe, Azerbaijan, St. Vincent and the Grenadines, Haiti, Nicaragua, Fiji, Türkiye, India, Mauritania, Kuwait, Mauritius, Malawi, Bulgaria, Dominica, Kenya, Congo, Rep., Nepal, Maldives, Panama, Togo, Thailand, Moldova, Egypt, Arab Rep., United Arab Emirates, Indonesia, Bosnia and Herzegovina, China, Solomon Islands, Lao PDR, Angola, Liberia, Philippines, Equatorial Guinea, Niger, Cabo Verde, El Salvador, Ethiopia, BOL, VUT, OMN, MMR, KAZ, POL, GMB, BRA, MNE, TCD, LKA, MNG, LCA, NRU, PER, URY, UKR, PSE, BGD, NAM, MOZ, RUS, ZAF, SWZ, TON, SAU, TZA, MKD, SUR, GTM, LBY, KGZ, HRV, SLE, GUY, XKX, BRB, BHR, RWA, BDI, AFG, ALB, ERI, CMR, CRI, CIV, COM, LSO, MDG, SOM, DZA, BTN, TJK, MLI, GIN, COL, SYR, GHA, SRB, KIR, DJI, NGA, BHS, TTO, BLR, SSD, MYS, PAK, TLS, ZMB, JOR, UGA, UZB, CAF, HND, MHL, IRQ, ZWE, PRY, SDN, TUV, CHL, BEN, SYC, BLZ, WSM, YEM, LBN, ROU, TUN, ARM, PNG, ECU, BFA, IRN, JAM, QAT, DOM, GRD, SEN, GEO, GNB, KHM, GAB, PLW, COD, MAR, MEX, BWA, VNM, FSM, ARG, STP, AZE, VCT, HTI, NIC, FJI, TUR, IND, MRT, KWT, MUS, MWI, BGR, DMA, KEN, COG, NPL, MDV, PAN, TGO, THA, MDA, EGY, ARE, IDN, BIH, CHN, SLB, LAO, AGO, LBR, PHL, GNQ, NER, CPV, SLV, ETH
#> 26 Türkiye, Trinidad and Tobago, Lebanon, Chad, Moldova, Costa Rica, Saudi Arabia, Mozambique, Eswatini, Myanmar, Iraq, Dominica, Azerbaijan, Croatia, Congo, Rep., Sudan, Vanuatu, South Africa, Rwanda, Suriname, Haiti, North Macedonia, Guinea, Jordan, Barbados, Argentina, Paraguay, Sierra Leone, Bhutan, Iran, Islamic Rep., Syrian Arab Republic, Colombia, Mauritania, Togo, Grenada, Pakistan, Palau, Naoero, Mauritius, Tonga, Tanzania, Djibouti, Cambodia, Botswana, Guyana, Mexico, Côte d’Ivoire, Seychelles, Nicaragua, Kiribati, Cameroon, Egypt, Arab Rep., Thailand, China, Bolivia, India, Peru, Central African Republic, El Salvador, Afghanistan, Somalia, Federal Republic of, Kazakhstan, Romania, Serbia, Nepal, Uzbekistan, Maldives, Fiji, Kyrgyz Republic, Oman, Lao PDR, West Bank and Gaza, Georgia, Timor-Leste, Ethiopia, Liberia, Armenia, Namibia, Burkina Faso, United Arab Emirates, Bulgaria, Uganda, Guatemala, Madagascar, Chile, Burundi, Ghana, Marshall Islands, Kosovo, Indonesia, Kuwait, St. Vincent and the Grenadines, Equatorial Guinea, Ukraine, Eritrea, Belize, Albania, Papua New Guinea, Yemen, Rep., Bahrain, Poland, Bangladesh, Brazil, Montenegro, Tajikistan, Belarus, Panama, Cabo Verde, Gabon, Morocco, Angola, Comoros, Algeria, Mongolia, Zambia, Niger, Tuvalu, Zimbabwe, Nigeria, Samoa, Uruguay, Solomon Islands, Malaysia, São Tomé and Príncipe, Micronesia, Fed. Sts., Sri Lanka, Ecuador, Jamaica, South Sudan, Tunisia, Congo, Dem. Rep., Vietnam, Bahamas, The, Guinea-Bissau, Lesotho, Senegal, Russian Federation, Bosnia and Herzegovina, Qatar, Dominican Republic, Honduras, Mali, Philippines, Libya, Malawi, Gambia, The, Kenya, Benin, St. Lucia, TUR, TTO, LBN, TCD, MDA, CRI, SAU, MOZ, SWZ, MMR, IRQ, DMA, AZE, HRV, COG, SDN, VUT, ZAF, RWA, SUR, HTI, MKD, GIN, JOR, BRB, ARG, PRY, SLE, BTN, IRN, SYR, COL, MRT, TGO, GRD, PAK, PLW, NRU, MUS, TON, TZA, DJI, KHM, BWA, GUY, MEX, CIV, SYC, NIC, KIR, CMR, EGY, THA, CHN, BOL, IND, PER, CAF, SLV, AFG, SOM, KAZ, ROU, SRB, NPL, UZB, MDV, FJI, KGZ, OMN, LAO, PSE, GEO, TLS, ETH, LBR, ARM, NAM, BFA, ARE, BGR, UGA, GTM, MDG, CHL, BDI, GHA, MHL, XKX, IDN, KWT, VCT, GNQ, UKR, ERI, BLZ, ALB, PNG, YEM, BHR, POL, BGD, BRA, MNE, TJK, BLR, PAN, CPV, GAB, MAR, AGO, COM, DZA, MNG, ZMB, NER, TUV, ZWE, NGA, WSM, URY, SLB, MYS, STP, FSM, LKA, ECU, JAM, SSD, TUN, COD, VNM, BHS, GNB, LSO, SEN, RUS, BIH, QAT, DOM, HND, MLI, PHL, LBY, MWI, GMB, KEN, BEN, LCA
#> 27                                                  Kuwait, Sierra Leone, Tunisia, Djibouti, Morocco, Montenegro, Benin, Bangladesh, Fiji, Paraguay, Malawi, Panama, India, Bhutan, Saudi Arabia, Belarus, Mongolia, Kazakhstan, Vietnam, Burundi, Ecuador, Solomon Islands, Cambodia, Kyrgyz Republic, Brazil, North Macedonia, Maldives, Congo, Dem. Rep., Kiribati, Papua New Guinea, Iran, Islamic Rep., Samoa, Namibia, Gambia, The, Uzbekistan, Syrian Arab Republic, São Tomé and Príncipe, South Africa, Ukraine, Tanzania, United Arab Emirates, El Salvador, Lebanon, Uganda, Mauritius, Qatar, Dominican Republic, Moldova, Pakistan, Bolivia, Bahrain, Cameroon, Lesotho, Ethiopia, Albania, Liberia, Thailand, Chile, Ghana, Sudan, Nicaragua, Congo, Rep., Nepal, Peru, Bahamas, The, Guinea, Barbados, Mali, Senegal, Somalia, Federal Republic of, Egypt, Arab Rep., Algeria, Guyana, Afghanistan, Kenya, Angola, Colombia, Croatia, Armenia, South Sudan, Georgia, Mexico, Malaysia, Sri Lanka, Kosovo, Bulgaria, Romania, Comoros, Rwanda, Palau, Eswatini, Belize, Oman, Vanuatu, Serbia, Burkina Faso, Chad, Philippines, Cabo Verde, China, Mauritania, Yemen, Rep., Poland, Grenada, West Bank and Gaza, Zimbabwe, Haiti, Iraq, Myanmar, Micronesia, Fed. Sts., Zambia, Jamaica, Argentina, Guinea-Bissau, Libya, Uruguay, Nigeria, Suriname, Timor-Leste, Türkiye, Lao PDR, Dominica, Azerbaijan, Russian Federation, Indonesia, Guatemala, St. Vincent and the Grenadines, Costa Rica, Seychelles, Botswana, Niger, Togo, Honduras, Madagascar, Tonga, Gabon, Central African Republic, St. Lucia, Côte d’Ivoire, Jordan, Tajikistan, Eritrea, Mozambique, Trinidad and Tobago, Bosnia and Herzegovina, Equatorial Guinea, KWT, SLE, TUN, DJI, MAR, MNE, BEN, BGD, FJI, PRY, MWI, PAN, IND, BTN, SAU, BLR, MNG, KAZ, VNM, BDI, ECU, SLB, KHM, KGZ, BRA, MKD, MDV, COD, KIR, PNG, IRN, WSM, NAM, GMB, UZB, SYR, STP, ZAF, UKR, TZA, ARE, SLV, LBN, UGA, MUS, QAT, DOM, MDA, PAK, BOL, BHR, CMR, LSO, ETH, ALB, LBR, THA, CHL, GHA, SDN, NIC, COG, NPL, PER, BHS, GIN, BRB, MLI, SEN, SOM, EGY, DZA, GUY, AFG, KEN, AGO, COL, HRV, ARM, SSD, GEO, MEX, MYS, LKA, XKX, BGR, ROU, COM, RWA, PLW, SWZ, BLZ, OMN, VUT, SRB, BFA, TCD, PHL, CPV, CHN, MRT, YEM, POL, GRD, PSE, ZWE, HTI, IRQ, MMR, FSM, ZMB, JAM, ARG, GNB, LBY, URY, NGA, SUR, TLS, TUR, LAO, DMA, AZE, RUS, IDN, GTM, VCT, CRI, SYC, BWA, NER, TGO, HND, MDG, TON, GAB, CAF, LCA, CIV, JOR, TJK, ERI, MOZ, TTO, BIH, GNQ
#> 28                                                                                                                                                                                                                                                                                                                       Senegal, Moldova, Uruguay, Ukraine, Armenia, Nepal, Egypt, Arab Rep., Seychelles, Vietnam, Central African Republic, Congo, Dem. Rep., Libya, Somalia, Federal Republic of, United Arab Emirates, Philippines, Niger, Angola, Maldives, Benin, Lesotho, Qatar, Guinea-Bissau, Saudi Arabia, Thailand, Eswatini, Romania, Tanzania, Mauritius, Pakistan, Samoa, Haiti, Brazil, Sierra Leone, Gambia, The, Togo, Georgia, Mali, Syrian Arab Republic, Burundi, Kiribati, Vanuatu, Nigeria, Dominican Republic, Oman, Morocco, El Salvador, Ghana, Nicaragua, Kosovo, Uganda, Zimbabwe, Kuwait, Côte d’Ivoire, Mozambique, Tunisia, Iraq, China, Iran, Islamic Rep., Eritrea, Myanmar, Djibouti, Burkina Faso, Ecuador, Peru, Bahamas, The, Chile, Colombia, Sri Lanka, Honduras, Belarus, Panama, Paraguay, Ethiopia, Timor-Leste, Bolivia, Jamaica, Serbia, Kazakhstan, Azerbaijan, Algeria, Tajikistan, Poland, Russian Federation, Rwanda, Sudan, Kenya, Gabon, Yemen, Rep., Comoros, Cambodia, Chad, Albania, Cabo Verde, Kyrgyz Republic, Afghanistan, Bosnia and Herzegovina, Costa Rica, Jordan, Zambia, Bulgaria, Mauritania, Liberia, Malawi, West Bank and Gaza, Belize, Naoero, Botswana, Namibia, Congo, Rep., Mexico, Guatemala, Mongolia, Madagascar, Montenegro, Indonesia, Bhutan, Solomon Islands, Cameroon, Malaysia, Uzbekistan, Argentina, Marshall Islands, South Africa, Croatia, Guinea, Bahrain, Lebanon, Equatorial Guinea, North Macedonia, Bangladesh, India, Türkiye, SEN, MDA, URY, UKR, ARM, NPL, EGY, SYC, VNM, CAF, COD, LBY, SOM, ARE, PHL, NER, AGO, MDV, BEN, LSO, QAT, GNB, SAU, THA, SWZ, ROU, TZA, MUS, PAK, WSM, HTI, BRA, SLE, GMB, TGO, GEO, MLI, SYR, BDI, KIR, VUT, NGA, DOM, OMN, MAR, SLV, GHA, NIC, XKX, UGA, ZWE, KWT, CIV, MOZ, TUN, IRQ, CHN, IRN, ERI, MMR, DJI, BFA, ECU, PER, BHS, CHL, COL, LKA, HND, BLR, PAN, PRY, ETH, TLS, BOL, JAM, SRB, KAZ, AZE, DZA, TJK, POL, RUS, RWA, SDN, KEN, GAB, YEM, COM, KHM, TCD, ALB, CPV, KGZ, AFG, BIH, CRI, JOR, ZMB, BGR, MRT, LBR, MWI, PSE, BLZ, NRU, BWA, NAM, COG, MEX, GTM, MNG, MDG, MNE, IDN, BTN, SLB, CMR, MYS, UZB, ARG, MHL, ZAF, HRV, GIN, BHR, LBN, GNQ, MKD, BGD, IND, TUR
#> 29 Sri Lanka, Mongolia, Iraq, Madagascar, Malawi, South Africa, Bahrain, Guinea-Bissau, Yemen, Rep., Montenegro, Uzbekistan, Costa Rica, Ukraine, Congo, Dem. Rep., Cabo Verde, Zimbabwe, Romania, Peru, Armenia, Gambia, The, Afghanistan, Haiti, Marshall Islands, Bahamas, The, Samoa, Algeria, Libya, Tunisia, Moldova, Chad, El Salvador, Indonesia, Benin, Vietnam, Egypt, Arab Rep., Poland, Ghana, Uruguay, Syrian Arab Republic, Tajikistan, Bosnia and Herzegovina, Bangladesh, Nepal, Kenya, Botswana, Türkiye, Azerbaijan, Georgia, Kuwait, Dominican Republic, North Macedonia, Saudi Arabia, Colombia, Maldives, Nigeria, Thailand, Lebanon, Malaysia, Argentina, Guatemala, Belize, Mexico, Somalia, Federal Republic of, Kosovo, Belarus, Niger, Vanuatu, Honduras, Senegal, India, Kyrgyz Republic, Guinea, Eritrea, Rwanda, Namibia, Equatorial Guinea, Pakistan, Chile, Congo, Rep., Uganda, Burkina Faso, Solomon Islands, Jordan, Nicaragua, Eswatini, Philippines, Paraguay, Croatia, Timor-Leste, Bolivia, Oman, Mozambique, Russian Federation, Qatar, Brazil, Comoros, Morocco, Kazakhstan, Liberia, China, Djibouti, Central African Republic, Zambia, Serbia, Togo, Burundi, Ethiopia, Albania, Bhutan, Tanzania, Angola, Cameroon, Myanmar, West Bank and Gaza, Côte d’Ivoire, Lesotho, Ecuador, Mauritania, Gabon, Sierra Leone, Bulgaria, Jamaica, United Arab Emirates, Mali, Panama, Mauritius, Sudan, Naoero, Cambodia, Kiribati, Seychelles, Iran, Islamic Rep., Tonga, Palau, St. Vincent and the Grenadines, Grenada, Papua New Guinea, South Sudan, São Tomé and Príncipe, Lao PDR, Guyana, Dominica, Fiji, Micronesia, Fed. Sts., Trinidad and Tobago, Suriname, Barbados, St. Lucia, Tuvalu, LKA, MNG, IRQ, MDG, MWI, ZAF, BHR, GNB, YEM, MNE, UZB, CRI, UKR, COD, CPV, ZWE, ROU, PER, ARM, GMB, AFG, HTI, MHL, BHS, WSM, DZA, LBY, TUN, MDA, TCD, SLV, IDN, BEN, VNM, EGY, POL, GHA, URY, SYR, TJK, BIH, BGD, NPL, KEN, BWA, TUR, AZE, GEO, KWT, DOM, MKD, SAU, COL, MDV, NGA, THA, LBN, MYS, ARG, GTM, BLZ, MEX, SOM, XKX, BLR, NER, VUT, HND, SEN, IND, KGZ, GIN, ERI, RWA, NAM, GNQ, PAK, CHL, COG, UGA, BFA, SLB, JOR, NIC, SWZ, PHL, PRY, HRV, TLS, BOL, OMN, MOZ, RUS, QAT, BRA, COM, MAR, KAZ, LBR, CHN, DJI, CAF, ZMB, SRB, TGO, BDI, ETH, ALB, BTN, TZA, AGO, CMR, MMR, PSE, CIV, LSO, ECU, MRT, GAB, SLE, BGR, JAM, ARE, MLI, PAN, MUS, SDN, NRU, KHM, KIR, SYC, IRN, TON, PLW, VCT, GRD, PNG, SSD, STP, LAO, GUY, DMA, FJI, FSM, TTO, SUR, BRB, LCA, TUV
#> 30                                                              Sierra Leone, Tonga, Vanuatu, Guatemala, Uzbekistan, Iran, Islamic Rep., Panama, Paraguay, Burundi, Libya, Botswana, Bahamas, The, Bahrain, Yemen, Rep., Bulgaria, Vietnam, Philippines, Jordan, Lao PDR, Indonesia, Seychelles, Pakistan, Trinidad and Tobago, Uruguay, Côte d’Ivoire, Türkiye, Eswatini, Iraq, Congo, Dem. Rep., Honduras, Eritrea, Niger, Bosnia and Herzegovina, North Macedonia, Mauritania, Congo, Rep., Dominican Republic, Lebanon, Timor-Leste, Belize, Bolivia, Gabon, Poland, Dominica, Syrian Arab Republic, India, Mauritius, Sudan, Nepal, Grenada, Georgia, South Sudan, Haiti, Mongolia, Afghanistan, Saudi Arabia, Guinea, Tanzania, São Tomé and Príncipe, El Salvador, Algeria, Oman, Tunisia, Zambia, Maldives, Barbados, Central African Republic, Morocco, St. Lucia, Gambia, The, Kazakhstan, Thailand, Cabo Verde, Mali, Fiji, Uganda, Bhutan, Ethiopia, China, Malawi, Ghana, Lesotho, Moldova, Namibia, Colombia, Romania, Mozambique, Montenegro, Senegal, Brazil, Equatorial Guinea, Bangladesh, South Africa, Albania, Jamaica, Rwanda, Benin, Liberia, Kosovo, Tajikistan, Belarus, Myanmar, Micronesia, Fed. Sts., Nicaragua, Qatar, Togo, Burkina Faso, Kiribati, United Arab Emirates, Mexico, Costa Rica, Guinea-Bissau, Nigeria, Ecuador, Samoa, Angola, West Bank and Gaza, Sri Lanka, Croatia, Kyrgyz Republic, Cambodia, Serbia, Chile, Marshall Islands, Ukraine, Azerbaijan, Russian Federation, Chad, Kuwait, Djibouti, Armenia, Madagascar, Zimbabwe, Malaysia, Egypt, Arab Rep., Guyana, Cameroon, Argentina, Comoros, Palau, Solomon Islands, St. Vincent and the Grenadines, Peru, Kenya, Suriname, Papua New Guinea, SLE, TON, VUT, GTM, UZB, IRN, PAN, PRY, BDI, LBY, BWA, BHS, BHR, YEM, BGR, VNM, PHL, JOR, LAO, IDN, SYC, PAK, TTO, URY, CIV, TUR, SWZ, IRQ, COD, HND, ERI, NER, BIH, MKD, MRT, COG, DOM, LBN, TLS, BLZ, BOL, GAB, POL, DMA, SYR, IND, MUS, SDN, NPL, GRD, GEO, SSD, HTI, MNG, AFG, SAU, GIN, TZA, STP, SLV, DZA, OMN, TUN, ZMB, MDV, BRB, CAF, MAR, LCA, GMB, KAZ, THA, CPV, MLI, FJI, UGA, BTN, ETH, CHN, MWI, GHA, LSO, MDA, NAM, COL, ROU, MOZ, MNE, SEN, BRA, GNQ, BGD, ZAF, ALB, JAM, RWA, BEN, LBR, XKX, TJK, BLR, MMR, FSM, NIC, QAT, TGO, BFA, KIR, ARE, MEX, CRI, GNB, NGA, ECU, WSM, AGO, PSE, LKA, HRV, KGZ, KHM, SRB, CHL, MHL, UKR, AZE, RUS, TCD, KWT, DJI, ARM, MDG, ZWE, MYS, EGY, GUY, CMR, ARG, COM, PLW, SLB, VCT, PER, KEN, SUR, PNG
#> 31                                                  Panama, Poland, Guinea, Oman, Indonesia, Algeria, Mexico, Eswatini, Comoros, Eritrea, Morocco, Jordan, Libya, Fiji, Armenia, Haiti, Kuwait, Ukraine, Somalia, Federal Republic of, Togo, Djibouti, Bolivia, Central African Republic, Nigeria, West Bank and Gaza, Croatia, Vietnam, South Africa, Chad, Seychelles, Dominican Republic, Cambodia, Colombia, Romania, Sierra Leone, Kenya, Yemen, Rep., Bahrain, Mozambique, Solomon Islands, St. Vincent and the Grenadines, Benin, Zambia, Grenada, Bhutan, Iraq, Kiribati, Angola, China, Tanzania, Belize, Congo, Dem. Rep., Burundi, Moldova, Uzbekistan, Namibia, Ethiopia, Suriname, Honduras, Senegal, United Arab Emirates, Guatemala, Qatar, Syrian Arab Republic, Sudan, Botswana, Niger, Albania, Serbia, Rwanda, Belarus, India, Pakistan, Burkina Faso, Georgia, Mauritius, Jamaica, Malawi, Bosnia and Herzegovina, Lesotho, Côte d’Ivoire, Madagascar, Mongolia, Kazakhstan, Lao PDR, Philippines, Malaysia, Gambia, The, Guinea-Bissau, Iran, Islamic Rep., Brazil, Tunisia, St. Lucia, Barbados, Saudi Arabia, Palau, Trinidad and Tobago, Costa Rica, Lebanon, Dominica, Gabon, Guyana, Azerbaijan, Paraguay, Liberia, Türkiye, Egypt, Arab Rep., South Sudan, Equatorial Guinea, Mauritania, Cabo Verde, Bulgaria, Ecuador, Samoa, Tajikistan, Sri Lanka, Uruguay, Congo, Rep., Peru, Argentina, Bangladesh, Tonga, Montenegro, Bahamas, The, Cameroon, Vanuatu, Timor-Leste, Ghana, Nicaragua, Russian Federation, Micronesia, Fed. Sts., North Macedonia, Kosovo, Chile, Papua New Guinea, Afghanistan, São Tomé and Príncipe, Myanmar, Zimbabwe, Mali, Nepal, Thailand, Maldives, Uganda, Kyrgyz Republic, El Salvador, PAN, POL, GIN, OMN, IDN, DZA, MEX, SWZ, COM, ERI, MAR, JOR, LBY, FJI, ARM, HTI, KWT, UKR, SOM, TGO, DJI, BOL, CAF, NGA, PSE, HRV, VNM, ZAF, TCD, SYC, DOM, KHM, COL, ROU, SLE, KEN, YEM, BHR, MOZ, SLB, VCT, BEN, ZMB, GRD, BTN, IRQ, KIR, AGO, CHN, TZA, BLZ, COD, BDI, MDA, UZB, NAM, ETH, SUR, HND, SEN, ARE, GTM, QAT, SYR, SDN, BWA, NER, ALB, SRB, RWA, BLR, IND, PAK, BFA, GEO, MUS, JAM, MWI, BIH, LSO, CIV, MDG, MNG, KAZ, LAO, PHL, MYS, GMB, GNB, IRN, BRA, TUN, LCA, BRB, SAU, PLW, TTO, CRI, LBN, DMA, GAB, GUY, AZE, PRY, LBR, TUR, EGY, SSD, GNQ, MRT, CPV, BGR, ECU, WSM, TJK, LKA, URY, COG, PER, ARG, BGD, TON, MNE, BHS, CMR, VUT, TLS, GHA, NIC, RUS, FSM, MKD, XKX, CHL, PNG, AFG, STP, MMR, ZWE, MLI, NPL, THA, MDV, UGA, KGZ, SLV
#> 32                                                                                                                                                                                                                                                                                                                                                                                                                                                       Angola, Marshall Islands, Mongolia, Peru, Tunisia, Uruguay, Pakistan, Cambodia, Madagascar, Mexico, Georgia, Guinea, Kosovo, Libya, Romania, Algeria, Ukraine, Côte d’Ivoire, Bahamas, The, Bolivia, Uzbekistan, Bulgaria, El Salvador, Comoros, Malaysia, Belarus, Paraguay, Serbia, Togo, Sudan, Congo, Rep., Qatar, Honduras, Armenia, Gabon, Türkiye, Saudi Arabia, Kazakhstan, Afghanistan, Malawi, Mozambique, Iraq, India, Mauritius, Bangladesh, Chad, Oman, Egypt, Arab Rep., Zimbabwe, Djibouti, Dominican Republic, Burkina Faso, Panama, Somalia, Federal Republic of, Moldova, Congo, Dem. Rep., Azerbaijan, Tajikistan, Eswatini, Kuwait, Eritrea, Lebanon, Guinea-Bissau, Kiribati, West Bank and Gaza, North Macedonia, Argentina, Thailand, Costa Rica, Seychelles, Bosnia and Herzegovina, Nicaragua, Niger, Bhutan, Samoa, Uganda, Croatia, Brazil, Vietnam, Botswana, Zambia, Rwanda, Kenya, Namibia, Lesotho, Cameroon, Nepal, Equatorial Guinea, China, Timor-Leste, Poland, Burundi, Albania, Iran, Islamic Rep., Tanzania, South Africa, Colombia, Benin, United Arab Emirates, Belize, Senegal, Vanuatu, Bahrain, Haiti, Chile, Indonesia, Liberia, Gambia, The, Ecuador, Central African Republic, Mauritania, Philippines, Morocco, Guatemala, Solomon Islands, Ethiopia, Sri Lanka, Montenegro, Ghana, Russian Federation, Mali, Cabo Verde, Kyrgyz Republic, Sierra Leone, AGO, MHL, MNG, PER, TUN, URY, PAK, KHM, MDG, MEX, GEO, GIN, XKX, LBY, ROU, DZA, UKR, CIV, BHS, BOL, UZB, BGR, SLV, COM, MYS, BLR, PRY, SRB, TGO, SDN, COG, QAT, HND, ARM, GAB, TUR, SAU, KAZ, AFG, MWI, MOZ, IRQ, IND, MUS, BGD, TCD, OMN, EGY, ZWE, DJI, DOM, BFA, PAN, SOM, MDA, COD, AZE, TJK, SWZ, KWT, ERI, LBN, GNB, KIR, PSE, MKD, ARG, THA, CRI, SYC, BIH, NIC, NER, BTN, WSM, UGA, HRV, BRA, VNM, BWA, ZMB, RWA, KEN, NAM, LSO, CMR, NPL, GNQ, CHN, TLS, POL, BDI, ALB, IRN, TZA, ZAF, COL, BEN, ARE, BLZ, SEN, VUT, BHR, HTI, CHL, IDN, LBR, GMB, ECU, CAF, MRT, PHL, MAR, GTM, SLB, ETH, LKA, MNE, GHA, RUS, MLI, CPV, KGZ, SLE
#> 33                                                                                                                                                                                                                                                                                                                                                           Tajikistan, Sri Lanka, Nepal, Gambia, The, Djibouti, Vietnam, Congo, Rep., Eswatini, Honduras, Azerbaijan, Paraguay, South Africa, India, Chad, Namibia, Eritrea, Philippines, Uganda, Somalia, Federal Republic of, Kiribati, Moldova, Peru, Ukraine, Botswana, El Salvador, Lesotho, Poland, Montenegro, Cabo Verde, Sierra Leone, Côte d’Ivoire, Tanzania, West Bank and Gaza, Jamaica, Malawi, Algeria, Romania, Morocco, North Macedonia, Kenya, Chile, Uzbekistan, Equatorial Guinea, Angola, Togo, Panama, Benin, Kuwait, Pakistan, Senegal, Ghana, Saudi Arabia, Syrian Arab Republic, Mozambique, Qatar, Costa Rica, Iraq, Mauritania, Rwanda, Kyrgyz Republic, Myanmar, Ethiopia, Jordan, Kosovo, Croatia, Kazakhstan, Mexico, Central African Republic, Bahrain, Indonesia, Bhutan, Libya, Sudan, Serbia, Guinea-Bissau, Niger, Nicaragua, Solomon Islands, Russian Federation, Timor-Leste, Madagascar, Uruguay, Zambia, Georgia, Guinea, Guatemala, Albania, Bolivia, Mali, Oman, Yemen, Rep., Zimbabwe, Haiti, China, Maldives, Congo, Dem. Rep., Mongolia, Nigeria, Burkina Faso, Colombia, Samoa, Iran, Islamic Rep., Bosnia and Herzegovina, Egypt, Arab Rep., Brazil, Seychelles, Gabon, Cambodia, Vanuatu, Dominican Republic, Argentina, Afghanistan, United Arab Emirates, Türkiye, Belize, Comoros, Liberia, Bangladesh, Malaysia, Bulgaria, Lebanon, Mauritius, Cameroon, Belarus, Bahamas, The, Burundi, Ecuador, Armenia, Thailand, Tunisia, TJK, LKA, NPL, GMB, DJI, VNM, COG, SWZ, HND, AZE, PRY, ZAF, IND, TCD, NAM, ERI, PHL, UGA, SOM, KIR, MDA, PER, UKR, BWA, SLV, LSO, POL, MNE, CPV, SLE, CIV, TZA, PSE, JAM, MWI, DZA, ROU, MAR, MKD, KEN, CHL, UZB, GNQ, AGO, TGO, PAN, BEN, KWT, PAK, SEN, GHA, SAU, SYR, MOZ, QAT, CRI, IRQ, MRT, RWA, KGZ, MMR, ETH, JOR, XKX, HRV, KAZ, MEX, CAF, BHR, IDN, BTN, LBY, SDN, SRB, GNB, NER, NIC, SLB, RUS, TLS, MDG, URY, ZMB, GEO, GIN, GTM, ALB, BOL, MLI, OMN, YEM, ZWE, HTI, CHN, MDV, COD, MNG, NGA, BFA, COL, WSM, IRN, BIH, EGY, BRA, SYC, GAB, KHM, VUT, DOM, ARG, AFG, ARE, TUR, BLZ, COM, LBR, BGD, MYS, BGR, LBN, MUS, CMR, BLR, BHS, BDI, ECU, ARM, THA, TUN
#> 34                                                                                                                                                                                                                                                                                                                                                                                                                                                       Gambia, The, Qatar, Poland, Burkina Faso, Iran, Islamic Rep., Albania, Sudan, Kazakhstan, Seychelles, Eritrea, Iraq, Zimbabwe, Namibia, Peru, Bolivia, Mali, Moldova, Nicaragua, Honduras, Kosovo, Mozambique, Armenia, Brazil, Malawi, Mauritania, Ukraine, Indonesia, Afghanistan, Timor-Leste, United Arab Emirates, Chile, Chad, Uganda, Senegal, Mauritius, India, South Africa, Samoa, Uzbekistan, Angola, Eswatini, El Salvador, Burundi, Mongolia, Nepal, Thailand, Equatorial Guinea, Belize, Botswana, Niger, Montenegro, Pakistan, Serbia, Bahrain, Central African Republic, Guinea-Bissau, Paraguay, Colombia, Cabo Verde, Cameroon, Saudi Arabia, Kenya, Bangladesh, Romania, West Bank and Gaza, Uruguay, Tanzania, Kyrgyz Republic, Liberia, Panama, Togo, Argentina, Bahamas, The, Tunisia, Belarus, Guinea, Türkiye, Costa Rica, Djibouti, Congo, Dem. Rep., Bosnia and Herzegovina, Bulgaria, Solomon Islands, Croatia, Comoros, China, Algeria, Côte d’Ivoire, Azerbaijan, Philippines, Dominican Republic, Ecuador, Georgia, Russian Federation, Guatemala, Oman, Kuwait, Ghana, Mexico, Rwanda, Bhutan, Kiribati, Egypt, Arab Rep., Ethiopia, Vanuatu, Gabon, Zambia, Malaysia, Somalia, Federal Republic of, Sri Lanka, Lesotho, Lebanon, Madagascar, Vietnam, Congo, Rep., Tajikistan, Morocco, Benin, Libya, Sierra Leone, Marshall Islands, North Macedonia, Cambodia, Haiti, GMB, QAT, POL, BFA, IRN, ALB, SDN, KAZ, SYC, ERI, IRQ, ZWE, NAM, PER, BOL, MLI, MDA, NIC, HND, XKX, MOZ, ARM, BRA, MWI, MRT, UKR, IDN, AFG, TLS, ARE, CHL, TCD, UGA, SEN, MUS, IND, ZAF, WSM, UZB, AGO, SWZ, SLV, BDI, MNG, NPL, THA, GNQ, BLZ, BWA, NER, MNE, PAK, SRB, BHR, CAF, GNB, PRY, COL, CPV, CMR, SAU, KEN, BGD, ROU, PSE, URY, TZA, KGZ, LBR, PAN, TGO, ARG, BHS, TUN, BLR, GIN, TUR, CRI, DJI, COD, BIH, BGR, SLB, HRV, COM, CHN, DZA, CIV, AZE, PHL, DOM, ECU, GEO, RUS, GTM, OMN, KWT, GHA, MEX, RWA, BTN, KIR, EGY, ETH, VUT, GAB, ZMB, MYS, SOM, LKA, LSO, LBN, MDG, VNM, COG, TJK, MAR, BEN, LBY, SLE, MHL, MKD, KHM, HTI
#>    series_description.geographic_units
#> 1                                 NULL
#> 2                                 NULL
#> 3                                 NULL
#> 4                                 NULL
#> 5                                 NULL
#> 6                                 NULL
#> 7                                 NULL
#> 8                                 NULL
#> 9                                 NULL
#> 10                                NULL
#> 11                                NULL
#> 12                                NULL
#> 13                                NULL
#> 14                                NULL
#> 15                                NULL
#> 16                                NULL
#> 17                                NULL
#> 18                                NULL
#> 19                                NULL
#> 20                                NULL
#> 21                                NULL
#> 22                                NULL
#> 23                                NULL
#> 24                                NULL
#> 25                                NULL
#> 26                                NULL
#> 27                                NULL
#> 28                                NULL
#> 29                                NULL
#> 30                                NULL
#> 31                                NULL
#> 32                                NULL
#> 33                                NULL
#> 34                                NULL
#>    series_description.aggregation_method_references
#> 1                                              NULL
#> 2                                              NULL
#> 3                                              NULL
#> 4                                              NULL
#> 5                                              NULL
#> 6                                              NULL
#> 7                                              NULL
#> 8                                              NULL
#> 9                                              NULL
#> 10                                             NULL
#> 11                                             NULL
#> 12                                             NULL
#> 13                                             NULL
#> 14                                             NULL
#> 15                                             NULL
#> 16                                             NULL
#> 17                                             NULL
#> 18                                             NULL
#> 19                                             NULL
#> 20                                             NULL
#> 21                                             NULL
#> 22                                             NULL
#> 23                                             NULL
#> 24                                             NULL
#> 25                                             NULL
#> 26                                             NULL
#> 27                                             NULL
#> 28                                             NULL
#> 29                                             NULL
#> 30                                             NULL
#> 31                                             NULL
#> 32                                             NULL
#> 33                                             NULL
#> 34                                             NULL
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    series_description.license
#> 1                             CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 2                             CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 3                             CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 4                             CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 5                             CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 6                             CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 7                             CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 8                             CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 9                             CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 10                            CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 11                            CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 12                            CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 13                            CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 14                            CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 15                            CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 16                            CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 17                            CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 18                            CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 19                            CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 20                            CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 21                            CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 22                            CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 23                            CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 24                            CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 25                            CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 26                            CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 27                            CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 28                            CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 29 CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, You are free to:\nShare — copy and redistribute the material in any medium or format for any purpose, even commercially.\nAdapt — remix, transform, and build upon the material for any purpose, even commercially.\nThe licensor cannot revoke these freedoms as long as you follow the license terms.\nUnder the following terms:\nAttribution — You must give appropriate credit , provide a link to the license, and indicate if changes were made . You may do so in any reasonable manner, but not in any way that suggests the licensor endorses you or your use.\nNo additional restrictions — You may not apply legal terms or technological measures that legally restrict others from doing anything the license permits.\nNotices:\nYou do not have to comply with the license for elements of the material in the public domain or where your use is permitted by an applicable exception or limitation .\n\nNo warranties are given. The license may not give you all of the permissions necessary for your intended use. For example, other rights such as publicity, privacy, or moral rights may limit how you use the material.
#> 30                            CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 31                            CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 32                            CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 33                            CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 34                            CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#>                                                                           series_description.links
#> 1  DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 2  DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 3  DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 4  DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 5  DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 6  DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 7  DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 8  DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 9  DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 10 DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 11 DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 12 DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 13 DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 14 DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 15 DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 16 DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 17 DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 18 DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 19 DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 20 DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 21 DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 22 DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 23 DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 24 DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 25 DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 26 DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 27 DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 28 DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 29                      NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 30 DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 31 DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 32 DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 33 DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 34 DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#>    series_description.api_documentation
#> 1                                  NULL
#> 2                                  NULL
#> 3                                  NULL
#> 4                                  NULL
#> 5                                  NULL
#> 6                                  NULL
#> 7                                  NULL
#> 8                                  NULL
#> 9                                  NULL
#> 10                                 NULL
#> 11                                 NULL
#> 12                                 NULL
#> 13                                 NULL
#> 14                                 NULL
#> 15                                 NULL
#> 16                                 NULL
#> 17                                 NULL
#> 18                                 NULL
#> 19                                 NULL
#> 20                                 NULL
#> 21                                 NULL
#> 22                                 NULL
#> 23                                 NULL
#> 24                                 NULL
#> 25                                 NULL
#> 26                                 NULL
#> 27                                 NULL
#> 28                                 NULL
#> 29                                 NULL
#> 30                                 NULL
#> 31                                 NULL
#> 32                                 NULL
#> 33                                 NULL
#> 34                                 NULL
#>                                                                                                        series_description.sources
#> 1  NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 2  NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 3                                       NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org, NA, NA
#> 4  NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 5  NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 6  NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 7  NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 8  NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 9  NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 10 NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 11 NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 12 NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 13 NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 14 NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 15 NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 16 NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 17 NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 18 NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 19 NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 20 NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 21                                      NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org, NA, NA
#> 22                                      NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org, NA, NA
#> 23                                      NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org, NA, NA
#> 24                                      NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org, NA, NA
#> 25 NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 26 NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 27 NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 28 NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 29                                                        NA, NA, NA, World Bank (WB), NA, NA, https://www.worldbank.org/, NA, NA
#> 30 NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 31 NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 32                                      NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org, NA, NA
#> 33                                      NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org, NA, NA
#> 34                                      NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org, NA, NA
#>    series_description.notes series_description.related_indicators
#> 1                      NULL                                  NULL
#> 2                      NULL                                  NULL
#> 3                      NULL                                  NULL
#> 4                      NULL                                  NULL
#> 5                      NULL                                  NULL
#> 6                      NULL                                  NULL
#> 7                      NULL                                  NULL
#> 8                      NULL                                  NULL
#> 9                      NULL                                  NULL
#> 10                     NULL                                  NULL
#> 11                     NULL                                  NULL
#> 12                     NULL                                  NULL
#> 13                     NULL                                  NULL
#> 14                     NULL                                  NULL
#> 15                     NULL                                  NULL
#> 16                     NULL                                  NULL
#> 17                     NULL                                  NULL
#> 18                     NULL                                  NULL
#> 19                     NULL                                  NULL
#> 20                     NULL                                  NULL
#> 21                     NULL                                  NULL
#> 22                     NULL                                  NULL
#> 23                     NULL                                  NULL
#> 24                     NULL                                  NULL
#> 25                     NULL                                  NULL
#> 26                     NULL                                  NULL
#> 27                     NULL                                  NULL
#> 28                     NULL                                  NULL
#> 29                     NULL                                  NULL
#> 30                     NULL                                  NULL
#> 31                     NULL                                  NULL
#> 32                     NULL                                  NULL
#> 33                     NULL                                  NULL
#> 34                     NULL                                  NULL
#>                                                                         tags
#> 1          WB_MPO, GAFS_0008, feature-dataset-profile, feature-topic-profile
#> 2  WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 3                                                                       NULL
#> 4  WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 5  WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 6  WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 7  WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 8  WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 9                                            WB_MPO, feature-dataset-profile
#> 10                                                                      NULL
#> 11 WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 12                                           WB_MPO, feature-dataset-profile
#> 13 WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 14                                                                      NULL
#> 15 WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 16 WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 17 WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 18 WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 19 WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 20 WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 21                                                                      NULL
#> 22                                                                      NULL
#> 23                                                                      NULL
#> 24                                                                      NULL
#> 25                                                                      NULL
#> 26                                                                      NULL
#> 27 WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 28 WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 29                                                                      NULL
#> 30                                                                      NULL
#> 31                                                                      NULL
#> 32                                                                      NULL
#> 33                                                                      NULL
#> 34                                                                      NULL
#>                                                           additional.metadata_link
#> 1                                                                             NULL
#> 2                                                                             NULL
#> 3                                                                             NULL
#> 4                                                                             NULL
#> 5                                                                             NULL
#> 6                                                                             NULL
#> 7                                                                             NULL
#> 8                                                                             NULL
#> 9                                                                             NULL
#> 10                                                                            NULL
#> 11                                                                            NULL
#> 12                                                                            NULL
#> 13                                                                            NULL
#> 14                                                                            NULL
#> 15                                                                            NULL
#> 16                                                                            NULL
#> 17                                                                            NULL
#> 18                                                                            NULL
#> 19                                                                            NULL
#> 20                                                                            NULL
#> 21                                                                            NULL
#> 22                                                                            NULL
#> 23                                                                            NULL
#> 24                                                                            NULL
#> 25    primary, META_WB_WDI_SP_POP_TOTL, WB_WDI, World Development Indicators (WDI)
#> 26 primary, META_WB_WDI_NY_GDP_PCAP_KD, WB_WDI, World Development Indicators (WDI)
#> 27                                                                            NULL
#> 28                                                                            NULL
#> 29                                                                            NULL
#> 30                                                                            NULL
#> 31 primary, META_WB_WDI_NY_GDP_DEFL_ZS, WB_WDI, World Development Indicators (WDI)
#> 32                                                                            NULL
#> 33                                                                            NULL
#> 34                                                                            NULL
#>    additional.visualization.scale_type additional.visualization.legend_type
#> 1                                 <NA>                                   NA
#> 2                                 <NA>                                   NA
#> 3                                 <NA>                                   NA
#> 4                            diverging                                   NA
#> 5                                 <NA>                                   NA
#> 6                                 <NA>                                   NA
#> 7                            diverging                                   NA
#> 8                            diverging                                   NA
#> 9                                 <NA>                                   NA
#> 10                                <NA>                                   NA
#> 11                                <NA>                                   NA
#> 12                                <NA>                                   NA
#> 13                                <NA>                                   NA
#> 14                                <NA>                                   NA
#> 15                                <NA>                                   NA
#> 16                                <NA>                                   NA
#> 17                                <NA>                                   NA
#> 18                           diverging                                   NA
#> 19                           diverging                                   NA
#> 20                                <NA>                                   NA
#> 21                                <NA>                                   NA
#> 22                                <NA>                                   NA
#> 23                                <NA>                                   NA
#> 24                                <NA>                                   NA
#> 25                                <NA>                                   NA
#> 26                                <NA>                                   NA
#> 27                                <NA>                                   NA
#> 28                                <NA>                                   NA
#> 29                                <NA>                                   NA
#> 30                                <NA>                                   NA
#> 31                                <NA>                                   NA
#> 32                                <NA>                                   NA
#> 33                                <NA>                                   NA
#> 34                                <NA>                                   NA
#>    additional.visualization.axis_type additional.visualization.notes
#> 1                                  NA                             NA
#> 2                                  NA                             NA
#> 3                                  NA                             NA
#> 4                                  NA                             NA
#> 5                                  NA                             NA
#> 6                                  NA                             NA
#> 7                                  NA                             NA
#> 8                                  NA                             NA
#> 9                                  NA                             NA
#> 10                                 NA                             NA
#> 11                                 NA                             NA
#> 12                                 NA                             NA
#> 13                                 NA                             NA
#> 14                                 NA                             NA
#> 15                                 NA                             NA
#> 16                                 NA                             NA
#> 17                                 NA                             NA
#> 18                                 NA                             NA
#> 19                                 NA                             NA
#> 20                                 NA                             NA
#> 21                                 NA                             NA
#> 22                                 NA                             NA
#> 23                                 NA                             NA
#> 24                                 NA                             NA
#> 25                                 NA                             NA
#> 26                                 NA                             NA
#> 27                                 NA                             NA
#> 28                                 NA                             NA
#> 29                                 NA                             NA
#> 30                                 NA                             NA
#> 31                                 NA                             NA
#> 32                                 NA                             NA
#> 33                                 NA                             NA
#> 34                                 NA                             NA
#>    additional.visualization.axis_values
#> 1                                    NA
#> 2                                    NA
#> 3                                    NA
#> 4                                    NA
#> 5                                    NA
#> 6                                    NA
#> 7                                    NA
#> 8                                    NA
#> 9                                    NA
#> 10                                   NA
#> 11                                   NA
#> 12                                   NA
#> 13                                   NA
#> 14                                   NA
#> 15                                   NA
#> 16                                   NA
#> 17                                   NA
#> 18                                   NA
#> 19                                   NA
#> 20                                   NA
#> 21                                   NA
#> 22                                   NA
#> 23                                   NA
#> 24                                   NA
#> 25                                   NA
#> 26                                   NA
#> 27                                   NA
#> 28                                   NA
#> 29                                   NA
#> 30                                   NA
#> 31                                   NA
#> 32                                   NA
#> 33                                   NA
#> 34                                   NA
#>    additional.visualization.axis_values_params
#> 1                                           NA
#> 2                                           NA
#> 3                                           NA
#> 4                                           NA
#> 5                                           NA
#> 6                                           NA
#> 7                                           NA
#> 8                                           NA
#> 9                                           NA
#> 10                                          NA
#> 11                                          NA
#> 12                                          NA
#> 13                                          NA
#> 14                                          NA
#> 15                                          NA
#> 16                                          NA
#> 17                                          NA
#> 18                                          NA
#> 19                                          NA
#> 20                                          NA
#> 21                                          NA
#> 22                                          NA
#> 23                                          NA
#> 24                                          NA
#> 25                                          NA
#> 26                                          NA
#> 27                                          NA
#> 28                                          NA
#> 29                                          NA
#> 30                                          NA
#> 31                                          NA
#> 32                                          NA
#> 33                                          NA
#> 34                                          NA
#>    additional.visualization.display_name additional.visualization.suppression
#> 1                                     NA                                   NA
#> 2                                     NA                                   NA
#> 3                                     NA                                   NA
#> 4                                     NA                                   NA
#> 5                                     NA                                   NA
#> 6                                     NA                                   NA
#> 7                                     NA                                   NA
#> 8                                     NA                                   NA
#> 9                                     NA                                   NA
#> 10                                    NA                                   NA
#> 11                                    NA                                   NA
#> 12                                    NA                                   NA
#> 13                                    NA                                   NA
#> 14                                    NA                                   NA
#> 15                                    NA                                   NA
#> 16                                    NA                                   NA
#> 17                                    NA                                   NA
#> 18                                    NA                                   NA
#> 19                                    NA                                   NA
#> 20                                    NA                                   NA
#> 21                                    NA                                   NA
#> 22                                    NA                                   NA
#> 23                                    NA                                   NA
#> 24                                    NA                                   NA
#> 25                                    NA                                   NA
#> 26                                    NA                                   NA
#> 27                                    NA                                   NA
#> 28                                    NA                                   NA
#> 29                                    NA                                   NA
#> 30                                    NA                                   NA
#> 31                                    NA                                   NA
#> 32                                    NA                                   NA
#> 33                                    NA                                   NA
#> 34                                    NA                                   NA
#>    additional.visualization.div_params
#> 1                                 NULL
#> 2                                 NULL
#> 3                                 NULL
#> 4                            NA, 0, NA
#> 5                                 NULL
#> 6                                 NULL
#> 7                            NA, 0, NA
#> 8                            NA, 0, NA
#> 9                                 NULL
#> 10                                NULL
#> 11                                NULL
#> 12                                NULL
#> 13                                NULL
#> 14                                NULL
#> 15                                NULL
#> 16                                NULL
#> 17                                NULL
#> 18                           NA, 0, NA
#> 19                           NA, 0, NA
#> 20                                NULL
#> 21                                NULL
#> 22                                NULL
#> 23                                NULL
#> 24                                NULL
#> 25                                NULL
#> 26                                NULL
#> 27                                NULL
#> 28                                NULL
#> 29                                NULL
#> 30                                NULL
#> 31                                NULL
#> 32                                NULL
#> 33                                NULL
#> 34                                NULL
#>    additional.visualization.axis_type_params
#> 1                                       NULL
#> 2                                       NULL
#> 3                                       NULL
#> 4                                       NULL
#> 5                                       NULL
#> 6                                       NULL
#> 7                                       NULL
#> 8                                       NULL
#> 9                                       NULL
#> 10                                      NULL
#> 11                                      NULL
#> 12                                      NULL
#> 13                                      NULL
#> 14                                      NULL
#> 15                                      NULL
#> 16                                      NULL
#> 17                                      NULL
#> 18                                      NULL
#> 19                                      NULL
#> 20                                      NULL
#> 21                                      NULL
#> 22                                      NULL
#> 23                                      NULL
#> 24                                      NULL
#> 25                                      NULL
#> 26                                      NULL
#> 27                                      NULL
#> 28                                      NULL
#> 29                                      NULL
#> 30                                      NULL
#> 31                                      NULL
#> 32                                      NULL
#> 33                                      NULL
#> 34                                      NULL
#>    additional.visualization.bin_params additional.visualization.missing_data
#> 1                                 NULL                                  NULL
#> 2                                 NULL                                  NULL
#> 3                                 NULL                                  NULL
#> 4                                 NULL                                  NULL
#> 5                                 NULL                                  NULL
#> 6                                 NULL                                  NULL
#> 7                                 NULL                                  NULL
#> 8                                 NULL                                  NULL
#> 9                                 NULL                                  NULL
#> 10                                NULL                                  NULL
#> 11                                NULL                                  NULL
#> 12                                NULL                                  NULL
#> 13                                NULL                                  NULL
#> 14                                NULL                                  NULL
#> 15                                NULL                                  NULL
#> 16                                NULL                                  NULL
#> 17                                NULL                                  NULL
#> 18                                NULL                                  NULL
#> 19                                NULL                                  NULL
#> 20                                NULL                                  NULL
#> 21                                NULL                                  NULL
#> 22                                NULL                                  NULL
#> 23                                NULL                                  NULL
#> 24                                NULL                                  NULL
#> 25                                NULL                                  NULL
#> 26                                NULL                                  NULL
#> 27                                NULL                                  NULL
#> 28                                NULL                                  NULL
#> 29                                NULL                                  NULL
#> 30                                NULL                                  NULL
#> 31                                NULL                                  NULL
#> 32                                NULL                                  NULL
#> 33                                NULL                                  NULL
#> 34                                NULL                                  NULL
#>    product
#> 1       NA
#> 2       NA
#> 3       NA
#> 4       NA
#> 5       NA
#> 6       NA
#> 7       NA
#> 8       NA
#> 9       NA
#> 10      NA
#> 11      NA
#> 12      NA
#> 13      NA
#> 14      NA
#> 15      NA
#> 16      NA
#> 17      NA
#> 18      NA
#> 19      NA
#> 20      NA
#> 21      NA
#> 22      NA
#> 23      NA
#> 24      NA
#> 25      NA
#> 26      NA
#> 27      NA
#> 28      NA
#> 29      NA
#> 30      NA
#> 31      NA
#> 32      NA
#> 33      NA
#> 34      NA
#>                                                                                                                                 disaggregation_codes
#> 1                                                                                           VINTAGE, V_AM2025, V_SM2024, V_SM2025, V_SM2026, Vintage
#> 2                                VINTAGE, UNIT_MEASURE, V_AM2024, V_AM2025, V_SM2024, V_SM2025, V_SM2026, PT_GDP, USD, XDC, Vintage, Unit of measure
#> 3  PRICE_BASIS, VINTAGE, UNIT_MEASURE, C, K, V_AM2024, V_AM2025, V_SM2024, V_SM2025, V_SM2026, PC_A, USD, XDC, Price Basis, Vintage, Unit of measure
#> 4                                     VINTAGE, UNIT_MEASURE, V_AM2024, V_AM2025, V_SM2024, V_SM2025, V_SM2026, PT_GDP, USD, Vintage, Unit of measure
#> 5                                                                                           VINTAGE, V_AM2025, V_SM2024, V_SM2025, V_SM2026, Vintage
#> 6                                                                                 VINTAGE, V_AM2024, V_AM2025, V_SM2024, V_SM2025, V_SM2026, Vintage
#> 7                                                                                                     VINTAGE, V_AM2024, V_SM2024, V_SM2026, Vintage
#> 8                                VINTAGE, UNIT_MEASURE, V_AM2024, V_AM2025, V_SM2024, V_SM2025, V_SM2026, PT_GDP, USD, XDC, Vintage, Unit of measure
#> 9                                                                                           VINTAGE, V_AM2025, V_SM2024, V_SM2025, V_SM2026, Vintage
#> 10 PRICE_BASIS, VINTAGE, UNIT_MEASURE, K, C, V_SM2025, V_AM2025, V_SM2024, V_SM2026, V_AM2024, XDC, USD, PC_A, Price Basis, Vintage, Unit of measure
#> 11                                                                                VINTAGE, V_AM2024, V_AM2025, V_SM2024, V_SM2025, V_SM2026, Vintage
#> 12                                                                                          VINTAGE, V_AM2025, V_SM2024, V_SM2025, V_SM2026, Vintage
#> 13                                                                                VINTAGE, V_AM2024, V_AM2025, V_SM2024, V_SM2025, V_SM2026, Vintage
#> 14 PRICE_BASIS, VINTAGE, UNIT_MEASURE, K, C, V_SM2025, V_AM2025, V_SM2024, V_SM2026, V_AM2024, XDC, USD, PC_A, Price Basis, Vintage, Unit of measure
#> 15                                                                                VINTAGE, V_AM2024, V_AM2025, V_SM2024, V_SM2025, V_SM2026, Vintage
#> 16 PRICE_BASIS, VINTAGE, UNIT_MEASURE, C, K, V_AM2024, V_AM2025, V_SM2024, V_SM2025, V_SM2026, PC_A, USD, XDC, Price Basis, Vintage, Unit of measure
#> 17 PRICE_BASIS, VINTAGE, UNIT_MEASURE, C, K, V_AM2024, V_AM2025, V_SM2024, V_SM2025, V_SM2026, XDC, USD, PC_A, Price Basis, Vintage, Unit of measure
#> 18 PRICE_BASIS, VINTAGE, UNIT_MEASURE, K, C, V_SM2026, V_SM2024, V_AM2024, V_SM2025, V_AM2025, PC_A, XDC, USD, Price Basis, Vintage, Unit of measure
#> 19                                    VINTAGE, UNIT_MEASURE, V_AM2024, V_AM2025, V_SM2024, V_SM2025, V_SM2026, PT_GDP, USD, Vintage, Unit of measure
#> 20 PRICE_BASIS, VINTAGE, UNIT_MEASURE, K, C, V_SM2025, V_AM2025, V_SM2026, V_SM2024, V_AM2024, USD, PC_A, XDC, Price Basis, Vintage, Unit of measure
#> 21                                                                                VINTAGE, V_AM2024, V_AM2025, V_SM2024, V_SM2025, V_SM2026, Vintage
#> 22                                  VINTAGE, UNIT_MEASURE, V_AM2024, V_AM2025, V_SM2024, V_SM2025, V_SM2026, KT_CO2E, PC_A, Vintage, Unit of measure
#> 23                       VINTAGE, UNIT_MEASURE, V_AM2024, V_AM2025, V_SM2024, V_SM2025, V_SM2026, KT_CO2E, PC_A, PT_EM_GHG, Vintage, Unit of measure
#> 24 PRICE_BASIS, VINTAGE, UNIT_MEASURE, C, K, V_SM2025, V_AM2025, V_SM2024, V_SM2026, V_AM2024, XDC, USD, PC_A, Price Basis, Vintage, Unit of measure
#> 25                                                                                VINTAGE, V_AM2024, V_AM2025, V_SM2024, V_SM2025, V_SM2026, Vintage
#> 26                                 VINTAGE, UNIT_MEASURE, V_AM2024, V_AM2025, V_SM2024, V_SM2025, V_SM2026, PC_A, USD, XDC, Vintage, Unit of measure
#> 27                               VINTAGE, UNIT_MEASURE, V_AM2024, V_AM2025, V_SM2024, V_SM2025, V_SM2026, PT_GDP, USD, XDC, Vintage, Unit of measure
#> 28 PRICE_BASIS, VINTAGE, UNIT_MEASURE, K, C, V_SM2024, V_SM2026, V_AM2024, V_SM2025, V_AM2025, PC_A, USD, XDC, Price Basis, Vintage, Unit of measure
#> 29                                                                                                                                              NULL
#> 30 PRICE_BASIS, VINTAGE, UNIT_MEASURE, K, C, V_AM2025, V_AM2024, V_SM2025, V_SM2026, V_SM2024, USD, PC_A, XDC, Price Basis, Vintage, Unit of measure
#> 31                                                                                VINTAGE, V_AM2024, V_AM2025, V_SM2024, V_SM2025, V_SM2026, Vintage
#> 32                                           VINTAGE, UNIT_MEASURE, V_AM2025, V_SM2024, V_SM2025, V_SM2026, PC_A, USD, XDC, Vintage, Unit of measure
#> 33                                                                                VINTAGE, V_AM2024, V_AM2025, V_SM2024, V_SM2025, V_SM2026, Vintage
#> 34                                                                                          VINTAGE, V_AM2025, V_SM2024, V_SM2025, V_SM2026, Vintage
#>    admin_metadata.gafs.visualization.scale_type
#> 1                                            NA
#> 2                                            NA
#> 3                                            NA
#> 4                                            NA
#> 5                                            NA
#> 6                                            NA
#> 7                                            NA
#> 8                                            NA
#> 9                                            NA
#> 10                                           NA
#> 11                                           NA
#> 12                                           NA
#> 13                                           NA
#> 14                                           NA
#> 15                                           NA
#> 16                                           NA
#> 17                                           NA
#> 18                                           NA
#> 19                                           NA
#> 20                                           NA
#> 21                                           NA
#> 22                                           NA
#> 23                                           NA
#> 24                                           NA
#> 25                                           NA
#> 26                                           NA
#> 27                                           NA
#> 28                                           NA
#> 29                                           NA
#> 30                                           NA
#> 31                                           NA
#> 32                                           NA
#> 33                                           NA
#> 34                                           NA
#>    admin_metadata.gafs.visualization.legend_type
#> 1                                             NA
#> 2                                             NA
#> 3                                             NA
#> 4                                             NA
#> 5                                             NA
#> 6                                             NA
#> 7                                             NA
#> 8                                             NA
#> 9                                             NA
#> 10                                            NA
#> 11                                            NA
#> 12                                            NA
#> 13                                            NA
#> 14                                            NA
#> 15                                            NA
#> 16                                            NA
#> 17                                            NA
#> 18                                            NA
#> 19                                            NA
#> 20                                            NA
#> 21                                            NA
#> 22                                            NA
#> 23                                            NA
#> 24                                            NA
#> 25                                            NA
#> 26                                            NA
#> 27                                            NA
#> 28                                            NA
#> 29                                            NA
#> 30                                            NA
#> 31                                            NA
#> 32                                            NA
#> 33                                            NA
#> 34                                            NA
#>    admin_metadata.gafs.visualization.axis_type
#> 1                                           NA
#> 2                                           NA
#> 3                                           NA
#> 4                                           NA
#> 5                                           NA
#> 6                                           NA
#> 7                                           NA
#> 8                                           NA
#> 9                                           NA
#> 10                                          NA
#> 11                                          NA
#> 12                                          NA
#> 13                                          NA
#> 14                                          NA
#> 15                                          NA
#> 16                                          NA
#> 17                                          NA
#> 18                                          NA
#> 19                                          NA
#> 20                                          NA
#> 21                                          NA
#> 22                                          NA
#> 23                                          NA
#> 24                                          NA
#> 25                                          NA
#> 26                                          NA
#> 27                                          NA
#> 28                                          NA
#> 29                                          NA
#> 30                                          NA
#> 31                                          NA
#> 32                                          NA
#> 33                                          NA
#> 34                                          NA
#>    admin_metadata.gafs.visualization.axis_values
#> 1                                             NA
#> 2                                             NA
#> 3                                             NA
#> 4                                             NA
#> 5                                             NA
#> 6                                             NA
#> 7                                             NA
#> 8                                             NA
#> 9                                             NA
#> 10                                            NA
#> 11                                            NA
#> 12                                            NA
#> 13                                            NA
#> 14                                            NA
#> 15                                            NA
#> 16                                            NA
#> 17                                            NA
#> 18                                            NA
#> 19                                            NA
#> 20                                            NA
#> 21                                            NA
#> 22                                            NA
#> 23                                            NA
#> 24                                            NA
#> 25                                            NA
#> 26                                            NA
#> 27                                            NA
#> 28                                            NA
#> 29                                            NA
#> 30                                            NA
#> 31                                            NA
#> 32                                            NA
#> 33                                            NA
#> 34                                            NA
#>    admin_metadata.gafs.visualization.axis_values_params
#> 1                                                    NA
#> 2                                                    NA
#> 3                                                    NA
#> 4                                                    NA
#> 5                                                    NA
#> 6                                                    NA
#> 7                                                    NA
#> 8                                                    NA
#> 9                                                    NA
#> 10                                                   NA
#> 11                                                   NA
#> 12                                                   NA
#> 13                                                   NA
#> 14                                                   NA
#> 15                                                   NA
#> 16                                                   NA
#> 17                                                   NA
#> 18                                                   NA
#> 19                                                   NA
#> 20                                                   NA
#> 21                                                   NA
#> 22                                                   NA
#> 23                                                   NA
#> 24                                                   NA
#> 25                                                   NA
#> 26                                                   NA
#> 27                                                   NA
#> 28                                                   NA
#> 29                                                   NA
#> 30                                                   NA
#> 31                                                   NA
#> 32                                                   NA
#> 33                                                   NA
#> 34                                                   NA
#>    admin_metadata.gafs.visualization.display_name
#> 1                                              NA
#> 2                                              NA
#> 3                                              NA
#> 4                                              NA
#> 5                                              NA
#> 6                                              NA
#> 7                                              NA
#> 8                                              NA
#> 9                                              NA
#> 10                                             NA
#> 11                                             NA
#> 12                                             NA
#> 13                                             NA
#> 14                                             NA
#> 15                                             NA
#> 16                                             NA
#> 17                                             NA
#> 18                                             NA
#> 19                                             NA
#> 20                                             NA
#> 21                                             NA
#> 22                                             NA
#> 23                                             NA
#> 24                                             NA
#> 25                                             NA
#> 26                                             NA
#> 27                                             NA
#> 28                                             NA
#> 29                                             NA
#> 30                                             NA
#> 31                                             NA
#> 32                                             NA
#> 33                                             NA
#> 34                                             NA
#>    admin_metadata.gafs.visualization.notes
#> 1                                       NA
#> 2                                       NA
#> 3                                       NA
#> 4                                       NA
#> 5                                       NA
#> 6                                       NA
#> 7                                       NA
#> 8                                       NA
#> 9                                       NA
#> 10                                      NA
#> 11                                      NA
#> 12                                      NA
#> 13                                      NA
#> 14                                      NA
#> 15                                      NA
#> 16                                      NA
#> 17                                      NA
#> 18                                      NA
#> 19                                      NA
#> 20                                      NA
#> 21                                      NA
#> 22                                      NA
#> 23                                      NA
#> 24                                      NA
#> 25                                      NA
#> 26                                      NA
#> 27                                      NA
#> 28                                      NA
#> 29                                      NA
#> 30                                      NA
#> 31                                      NA
#> 32                                      NA
#> 33                                      NA
#> 34                                      NA
#>    admin_metadata.gafs.visualization.suppression
#> 1                                             NA
#> 2                                             NA
#> 3                                             NA
#> 4                                             NA
#> 5                                             NA
#> 6                                             NA
#> 7                                             NA
#> 8                                             NA
#> 9                                             NA
#> 10                                            NA
#> 11                                            NA
#> 12                                            NA
#> 13                                            NA
#> 14                                            NA
#> 15                                            NA
#> 16                                            NA
#> 17                                            NA
#> 18                                            NA
#> 19                                            NA
#> 20                                            NA
#> 21                                            NA
#> 22                                            NA
#> 23                                            NA
#> 24                                            NA
#> 25                                            NA
#> 26                                            NA
#> 27                                            NA
#> 28                                            NA
#> 29                                            NA
#> 30                                            NA
#> 31                                            NA
#> 32                                            NA
#> 33                                            NA
#> 34                                            NA
#>    admin_metadata.gafs.visualization.custom_colors
#> 1                                               NA
#> 2                                               NA
#> 3                                               NA
#> 4                                               NA
#> 5                                               NA
#> 6                                               NA
#> 7                                               NA
#> 8                                               NA
#> 9                                               NA
#> 10                                              NA
#> 11                                              NA
#> 12                                              NA
#> 13                                              NA
#> 14                                              NA
#> 15                                              NA
#> 16                                              NA
#> 17                                              NA
#> 18                                              NA
#> 19                                              NA
#> 20                                              NA
#> 21                                              NA
#> 22                                              NA
#> 23                                              NA
#> 24                                              NA
#> 25                                              NA
#> 26                                              NA
#> 27                                              NA
#> 28                                              NA
#> 29                                              NA
#> 30                                              NA
#> 31                                              NA
#> 32                                              NA
#> 33                                              NA
#> 34                                              NA
#>    admin_metadata.gafs.visualization.div_params
#> 1                                          NULL
#> 2                                          NULL
#> 3                                          NULL
#> 4                                          NULL
#> 5                                          NULL
#> 6                                          NULL
#> 7                                          NULL
#> 8                                          NULL
#> 9                                          NULL
#> 10                                         NULL
#> 11                                         NULL
#> 12                                         NULL
#> 13                                         NULL
#> 14                                         NULL
#> 15                                         NULL
#> 16                                         NULL
#> 17                                         NULL
#> 18                                         NULL
#> 19                                         NULL
#> 20                                         NULL
#> 21                                         NULL
#> 22                                         NULL
#> 23                                         NULL
#> 24                                         NULL
#> 25                                         NULL
#> 26                                         NULL
#> 27                                         NULL
#> 28                                         NULL
#> 29                                         NULL
#> 30                                         NULL
#> 31                                         NULL
#> 32                                         NULL
#> 33                                         NULL
#> 34                                         NULL
#>    admin_metadata.gafs.visualization.bin_params
#> 1                                          NULL
#> 2                                          NULL
#> 3                                          NULL
#> 4                                          NULL
#> 5                                          NULL
#> 6                                          NULL
#> 7                                          NULL
#> 8                                          NULL
#> 9                                          NULL
#> 10                                         NULL
#> 11                                         NULL
#> 12                                         NULL
#> 13                                         NULL
#> 14                                         NULL
#> 15                                         NULL
#> 16                                         NULL
#> 17                                         NULL
#> 18                                         NULL
#> 19                                         NULL
#> 20                                         NULL
#> 21                                         NULL
#> 22                                         NULL
#> 23                                         NULL
#> 24                                         NULL
#> 25                                         NULL
#> 26                                         NULL
#> 27                                         NULL
#> 28                                         NULL
#> 29                                         NULL
#> 30                                         NULL
#> 31                                         NULL
#> 32                                         NULL
#> 33                                         NULL
#> 34                                         NULL
#>    admin_metadata.gafs.visualization.axis_type_params
#> 1                                                NULL
#> 2                                                NULL
#> 3                                                NULL
#> 4                                                NULL
#> 5                                                NULL
#> 6                                                NULL
#> 7                                                NULL
#> 8                                                NULL
#> 9                                                NULL
#> 10                                               NULL
#> 11                                               NULL
#> 12                                               NULL
#> 13                                               NULL
#> 14                                               NULL
#> 15                                               NULL
#> 16                                               NULL
#> 17                                               NULL
#> 18                                               NULL
#> 19                                               NULL
#> 20                                               NULL
#> 21                                               NULL
#> 22                                               NULL
#> 23                                               NULL
#> 24                                               NULL
#> 25                                               NULL
#> 26                                               NULL
#> 27                                               NULL
#> 28                                               NULL
#> 29                                               NULL
#> 30                                               NULL
#> 31                                               NULL
#> 32                                               NULL
#> 33                                               NULL
#> 34                                               NULL
#>    admin_metadata.gafs.visualization.missing_data
#> 1                                            NULL
#> 2                                            NULL
#> 3                                            NULL
#> 4                                            NULL
#> 5                                            NULL
#> 6                                            NULL
#> 7                                            NULL
#> 8                                            NULL
#> 9                                            NULL
#> 10                                           NULL
#> 11                                           NULL
#> 12                                           NULL
#> 13                                           NULL
#> 14                                           NULL
#> 15                                           NULL
#> 16                                           NULL
#> 17                                           NULL
#> 18                                           NULL
#> 19                                           NULL
#> 20                                           NULL
#> 21                                           NULL
#> 22                                           NULL
#> 23                                           NULL
#> 24                                           NULL
#> 25                                           NULL
#> 26                                           NULL
#> 27                                           NULL
#> 28                                           NULL
#> 29                                           NULL
#> 30                                           NULL
#> 31                                           NULL
#> 32                                           NULL
#> 33                                           NULL
#> 34                                           NULL
#>    admin_metadata.gafs.visualization.remove_chart  admin_metadata.gafs.topics
#> 1                                 pie, stackedBar GAFS_0008, NA, GAFS, NA, NA
#> 2                                            NULL                        NULL
#> 3                                            NULL                        NULL
#> 4                                            NULL                        NULL
#> 5                                            NULL                        NULL
#> 6                                            NULL                        NULL
#> 7                                            NULL                        NULL
#> 8                                            NULL                        NULL
#> 9                                            NULL                        NULL
#> 10                                           NULL                        NULL
#> 11                                           NULL                        NULL
#> 12                                           NULL                        NULL
#> 13                                           NULL                        NULL
#> 14                                           NULL                        NULL
#> 15                                           NULL                        NULL
#> 16                                           NULL                        NULL
#> 17                                           NULL                        NULL
#> 18                                           NULL                        NULL
#> 19                                           NULL                        NULL
#> 20                                           NULL                        NULL
#> 21                                           NULL                        NULL
#> 22                                           NULL                        NULL
#> 23                                           NULL                        NULL
#> 24                                           NULL                        NULL
#> 25                                           NULL                        NULL
#> 26                                           NULL                        NULL
#> 27                                           NULL                        NULL
#> 28                                           NULL                        NULL
#> 29                                           NULL                        NULL
#> 30                                           NULL                        NULL
#> 31                                           NULL                        NULL
#> 32                                           NULL                        NULL
#> 33                                           NULL                        NULL
#> 34                                           NULL                        NULL
#>            admin_metadata.gafs.tags
#> 1  GAFS_0008, feature-topic-profile
#> 2                              NULL
#> 3                              NULL
#> 4                              NULL
#> 5                              NULL
#> 6                              NULL
#> 7                              NULL
#> 8                              NULL
#> 9                              NULL
#> 10                             NULL
#> 11                             NULL
#> 12                             NULL
#> 13                             NULL
#> 14                             NULL
#> 15                             NULL
#> 16                             NULL
#> 17                             NULL
#> 18                             NULL
#> 19                             NULL
#> 20                             NULL
#> 21                             NULL
#> 22                             NULL
#> 23                             NULL
#> 24                             NULL
#> 25                             NULL
#> 26                             NULL
#> 27                             NULL
#> 28                             NULL
#> 29                             NULL
#> 30                             NULL
#> 31                             NULL
#> 32                             NULL
#> 33                             NULL
#> 34                             NULL
#> 
```
