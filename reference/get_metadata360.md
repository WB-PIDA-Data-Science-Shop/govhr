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
#> [1] 34
#> 
#> $value
#>    @search.score               id                                 idno
#> 1       38.34245   META_GGDBTTOTL 150f9817-21ce-425b-9e0a-84a126800234
#> 2       34.04229   META_BFCAFFFDI 8f5c7b62-ce7a-49b8-92c3-fc1fe7e64494
#> 3       33.25835   META_FPCPITOTL 439d46fe-8e6a-48c2-a3b0-93dbcebba565
#> 4       33.25835   META_GGEXPTOTL 045d144c-8dee-428d-bcc0-b069bfaf2f79
#> 5       32.07540  META_MP_PJ_POV2 038f91a4-373e-4518-8f30-c6fede87ce8e
#> 6       31.72411   META_BNCABFUND c51eaa5e-e1e7-40de-8eef-df8ab1f0e3de
#> 7       31.72411   META_NYGDPMKTP b40ec5aa-46b4-4236-8208-75ed056fc0b4
#> 8       31.65362   META_BFCAFTOTL b4d324f5-75bc-47d2-aa83-93362aa9d539
#> 9       31.65362   META_GGBALOVRL 859e8798-f252-4835-88b8-641859334fc2
#> 10      31.60952 META_FPCPITOTLXN 4c35692b-c581-48f1-b15c-a4aa91769a9b
#> 11      31.47523   META_GGREVTOTL 2a12a3d3-d968-4294-8ebe-abdf37d48f1a
#> 12      31.27308  META_MP_PJ_POV3 f726b67f-e51c-4467-9937-d79e3e3edcd2
#> 13      31.15333   META_NEGDIFTOT f2bd3acf-3cc3-44eb-9ef7-efda0bdfee62
#> 14      31.12061   META_NYGDPFCST e971d916-dd08-4319-bd12-fcf00500ac8e
#> 15      29.40237   META_GGEXPINTP 3a1a10f1-9576-4864-b37f-7472903343b3
#> 16      29.40237   META_NECONGOVT d414ecc7-c477-4328-91c6-759f3f0fd8cf
#> 17      29.40237   META_NEEXPGNFS 93b706e8-25a0-4151-89ba-e6e19c1029f7
#> 18      29.40237   META_NVAGRTOTL 8c60b15a-e28e-4b07-8344-4ca68e458aa9
#> 19      29.10869           WB_MPO 16ffd22e-c3b6-477d-bb16-45c423263eb0
#> 20      28.86429   META_NVINDTOTL 45fea94a-003b-40eb-94c3-83894800908c
#> 21      28.84815   META_GGBALPRIM 7a5b5994-5d58-4f84-b9dd-745d47d41b94
#> 22      28.84815   META_NEIMPGNFS fdf4269f-a74c-492e-8839-8c08097f578c
#> 23      26.43771   META_NVSRVTOTL 61b904f5-3524-44bd-90dc-359483e13a21
#> 24      26.43771 META_NYGDPMKTPXN e07a12b9-2a47-4d28-bd55-f5324cd4d521
#> 25      26.42717   META_ENATMCO2E 67f559f9-baf2-437e-9357-0c521be02fa9
#> 26      26.42717   META_ENTOTGHGE 4e9229ec-6825-46d3-9696-b47ee5236497
#> 27      25.92885   META_ENENRGHGE ac596a77-81b6-4c85-9bd4-88333895b0eb
#> 28      25.92885   META_NECONPRVT eb28a228-e24c-4c85-a8f0-a2341ce1f653
#> 29      25.92885   META_SPPOPTOTL a4707329-948b-4afa-bdd5-80d3fc5f44ae
#> 30      25.57678     META_NYGDPPC 80ca1711-e306-4de6-abc7-bd2b0ef397b6
#> 31      25.35613   META_CONPRVTPC 0cf71f79-f85f-427f-81d0-9977a81b0e94
#> 32      25.35613 META_NECONPRVTXN 33dc17d0-7388-425d-b668-747e98219bde
#> 33      25.35613  META_NEGDIFTOTK 3c05b471-da76-4f75-b873-51fa9ba29e20
#> 34      24.60142  META_MP_PJ_POV1 af08c7a1-873d-415a-8cdb-2656b859e9a6
#>         type    subtype                  disaggregation_types isDelete cfPath
#> 1  indicator timeseries              Vintage, Unit of measure       NA     NA
#> 2  indicator timeseries              Vintage, Unit of measure       NA     NA
#> 3  indicator timeseries                               Vintage       NA     NA
#> 4  indicator timeseries                               Vintage       NA     NA
#> 5  indicator timeseries                               Vintage       NA     NA
#> 6  indicator timeseries              Vintage, Unit of measure       NA     NA
#> 7  indicator timeseries Price Basis, Vintage, Unit of measure       NA     NA
#> 8  indicator timeseries                               Vintage       NA     NA
#> 9  indicator timeseries              Vintage, Unit of measure       NA     NA
#> 10 indicator timeseries                               Vintage       NA     NA
#> 11 indicator timeseries                               Vintage       NA     NA
#> 12 indicator timeseries                               Vintage       NA     NA
#> 13 indicator timeseries Price Basis, Vintage, Unit of measure       NA     NA
#> 14 indicator timeseries Price Basis, Vintage, Unit of measure       NA     NA
#> 15 indicator timeseries                               Vintage       NA     NA
#> 16 indicator timeseries Price Basis, Vintage, Unit of measure       NA     NA
#> 17 indicator timeseries Price Basis, Vintage, Unit of measure       NA     NA
#> 18 indicator timeseries Price Basis, Vintage, Unit of measure       NA     NA
#> 19   dataset       <NA>                                             NA     NA
#> 20 indicator timeseries Price Basis, Vintage, Unit of measure       NA     NA
#> 21 indicator timeseries              Vintage, Unit of measure       NA     NA
#> 22 indicator timeseries Price Basis, Vintage, Unit of measure       NA     NA
#> 23 indicator timeseries Price Basis, Vintage, Unit of measure       NA     NA
#> 24 indicator timeseries                               Vintage       NA     NA
#> 25 indicator timeseries                               Vintage       NA     NA
#> 26 indicator timeseries              Vintage, Unit of measure       NA     NA
#> 27 indicator timeseries              Vintage, Unit of measure       NA     NA
#> 28 indicator timeseries Price Basis, Vintage, Unit of measure       NA     NA
#> 29 indicator timeseries                               Vintage       NA     NA
#> 30 indicator timeseries              Vintage, Unit of measure       NA     NA
#> 31 indicator timeseries              Vintage, Unit of measure       NA     NA
#> 32 indicator timeseries                               Vintage       NA     NA
#> 33 indicator timeseries                               Vintage       NA     NA
#> 34 indicator timeseries                               Vintage       NA     NA
#>    doc_type    remove_chart_type data_confidentiality_code
#> 1        NA      stackedBar, pie                        PU
#> 2        NA      stackedBar, pie                        PU
#> 3        NA      stackedBar, pie                        PU
#> 4        NA      stackedBar, pie                        PU
#> 5        NA      stackedBar, pie                        PU
#> 6        NA      stackedBar, pie                        PU
#> 7        NA      stackedBar, pie                        PU
#> 8        NA      stackedBar, pie                        PU
#> 9        NA      stackedBar, pie                        PU
#> 10       NA      stackedBar, pie                        PU
#> 11       NA      stackedBar, pie                        PU
#> 12       NA      stackedBar, pie                        PU
#> 13       NA stackedBar, pie, map                        PU
#> 14       NA      stackedBar, pie                        PU
#> 15       NA stackedBar, pie, map                        PU
#> 16       NA stackedBar, pie, map                        PU
#> 17       NA stackedBar, pie, map                        PU
#> 18       NA stackedBar, pie, map                        PU
#> 19       NA                 <NA>                        PU
#> 20       NA stackedBar, pie, map                        PU
#> 21       NA      stackedBar, pie                        PU
#> 22       NA stackedBar, pie, map                        PU
#> 23       NA stackedBar, pie, map                        PU
#> 24       NA stackedBar, pie, map                        PU
#> 25       NA      stackedBar, pie                        PU
#> 26       NA      stackedBar, pie                        PU
#> 27       NA      stackedBar, pie                        PU
#> 28       NA stackedBar, pie, map                        PU
#> 29       NA      stackedBar, pie                        PU
#> 30       NA      stackedBar, pie                        PU
#> 31       NA      stackedBar, pie                        PU
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
#> 19                    Public     <NA>        <NA>
#> 20                    Public   DS_MPO       1.0.0
#> 21                    Public   DS_MPO       1.0.0
#> 22                    Public   DS_MPO       1.0.0
#> 23                    Public   DS_MPO       1.0.0
#> 24                    Public   DS_MPO       1.0.0
#> 25                    Public   DS_MPO       1.0.0
#> 26                    Public   DS_MPO       1.0.0
#> 27                    Public   DS_MPO       1.0.0
#> 28                    Public   DS_MPO       1.0.0
#> 29                    Public   DS_MPO       1.0.0
#> 30                    Public   DS_MPO       1.0.0
#> 31                    Public   DS_MPO       1.0.0
#> 32                    Public   DS_MPO       1.0.0
#> 33                    Public   DS_MPO       1.0.0
#> 34                    Public   DS_MPO       1.0.0
#>                                                                                                                                                 dsd_codelist
#> 1  FREQ, REF_AREA, INDICATOR, PRICE_BASIS, VINTAGE, UNIT_MEASURE, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 2  FREQ, REF_AREA, INDICATOR, PRICE_BASIS, VINTAGE, UNIT_MEASURE, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 3  FREQ, REF_AREA, INDICATOR, PRICE_BASIS, VINTAGE, UNIT_MEASURE, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 4  FREQ, REF_AREA, INDICATOR, PRICE_BASIS, VINTAGE, UNIT_MEASURE, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 5  FREQ, REF_AREA, INDICATOR, PRICE_BASIS, VINTAGE, UNIT_MEASURE, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 6  FREQ, REF_AREA, INDICATOR, PRICE_BASIS, VINTAGE, UNIT_MEASURE, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 7  FREQ, REF_AREA, INDICATOR, PRICE_BASIS, VINTAGE, UNIT_MEASURE, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 8  FREQ, REF_AREA, INDICATOR, PRICE_BASIS, VINTAGE, UNIT_MEASURE, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 9  FREQ, REF_AREA, INDICATOR, PRICE_BASIS, VINTAGE, UNIT_MEASURE, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 10 FREQ, REF_AREA, INDICATOR, PRICE_BASIS, VINTAGE, UNIT_MEASURE, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 11 FREQ, REF_AREA, INDICATOR, PRICE_BASIS, VINTAGE, UNIT_MEASURE, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 12 FREQ, REF_AREA, INDICATOR, PRICE_BASIS, VINTAGE, UNIT_MEASURE, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 13 FREQ, REF_AREA, INDICATOR, PRICE_BASIS, VINTAGE, UNIT_MEASURE, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 14 FREQ, REF_AREA, INDICATOR, PRICE_BASIS, VINTAGE, UNIT_MEASURE, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 15 FREQ, REF_AREA, INDICATOR, PRICE_BASIS, VINTAGE, UNIT_MEASURE, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 16 FREQ, REF_AREA, INDICATOR, PRICE_BASIS, VINTAGE, UNIT_MEASURE, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 17 FREQ, REF_AREA, INDICATOR, PRICE_BASIS, VINTAGE, UNIT_MEASURE, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 18 FREQ, REF_AREA, INDICATOR, PRICE_BASIS, VINTAGE, UNIT_MEASURE, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 19                                                                                                                                                          
#> 20 FREQ, REF_AREA, INDICATOR, PRICE_BASIS, VINTAGE, UNIT_MEASURE, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 21 FREQ, REF_AREA, INDICATOR, PRICE_BASIS, VINTAGE, UNIT_MEASURE, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 22 FREQ, REF_AREA, INDICATOR, PRICE_BASIS, VINTAGE, UNIT_MEASURE, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 23 FREQ, REF_AREA, INDICATOR, PRICE_BASIS, VINTAGE, UNIT_MEASURE, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 24 FREQ, REF_AREA, INDICATOR, PRICE_BASIS, VINTAGE, UNIT_MEASURE, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 25 FREQ, REF_AREA, INDICATOR, PRICE_BASIS, VINTAGE, UNIT_MEASURE, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 26 FREQ, REF_AREA, INDICATOR, PRICE_BASIS, VINTAGE, UNIT_MEASURE, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 27 FREQ, REF_AREA, INDICATOR, PRICE_BASIS, VINTAGE, UNIT_MEASURE, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 28 FREQ, REF_AREA, INDICATOR, PRICE_BASIS, VINTAGE, UNIT_MEASURE, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 29 FREQ, REF_AREA, INDICATOR, PRICE_BASIS, VINTAGE, UNIT_MEASURE, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 30 FREQ, REF_AREA, INDICATOR, PRICE_BASIS, VINTAGE, UNIT_MEASURE, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 31 FREQ, REF_AREA, INDICATOR, PRICE_BASIS, VINTAGE, UNIT_MEASURE, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 32 FREQ, REF_AREA, INDICATOR, PRICE_BASIS, VINTAGE, UNIT_MEASURE, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 33 FREQ, REF_AREA, INDICATOR, PRICE_BASIS, VINTAGE, UNIT_MEASURE, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 34 INDICATOR, VINTAGE, REF_AREA, FREQ, PRICE_BASIS, DATABASE_ID, AGG_METHOD, TIME_FORMAT, UNIT_MEASURE, OBS_STATUS, OBS_CONF, UNIT_MULT, UNIT_TYPE, DECIMALS
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
#> 1                                          Metadata for General Government Debt Stock
#> 2                                  Metadata for Net Foreign Direct Investment Outflow
#> 3                                                         Metadata for Inflation Rate
#> 4                                                      Metadata for Total Expenditure
#> 5  Metadata for Lower middle-income poverty rate ($3.65 in 2017 PPP), MPO projections
#> 6                                                Metadata for Current Account Balance
#> 7                                 Metadata for Gross Domestic Product at Market Price
#> 8                                  Metadata for Capital and Financial Account Balance
#> 9                                                 Metadata for Overall Fiscal Balance
#> 10                               Metadata for Consumer Price Index, Implicit Deflator
#> 11                                              Metadata for Total Revenue and Grants
#> 12 Metadata for Upper middle-income poverty rate ($6.85 in 2017 PPP), MPO projections
#> 13                                                Metadata for Gross Fixed Investment
#> 14                                 Metadata for Gross Domestic Product at Factor Cost
#> 15                                                     Metadata for Interest Payments
#> 16                                                Metadata for Government Consumption
#> 17                          Metadata for Goods and Non-Factor Services (GNFS) Exports
#> 18                                              Metadata for Agriculture, Value Added
#> 19                                                              Macro Poverty Outlook
#> 20                                                 Metadata for Industry, Value Added
#> 21                                                Metadata for Primary Fiscal Balance
#> 22                          Metadata for Goods and Non-Factor Services (GNFS) Imports
#> 23                                                 Metadata for Services, Value Added
#> 24             Metadata for Gross Domestic Product at Market Price, Implicit Deflator
#> 25                                        Metadata for Emissions: Total CO2 emissions
#> 26                                        Metadata for Emissions: Total GHG emissions
#> 27                         Metadata for Emissions: Energy, fuel combustion activities
#> 28                                                   Metadata for Private Consumption
#> 29                                           Metadata for Population, MPO Projections
#> 30                                        Metadata for GDP per capita at Market Price
#> 31                                        Metadata for Private Consumption per capita
#> 32                                Metadata for Private Consumption, Implicit Deflator
#> 33                           Metadata for Gross Fixed Investment as percentage of GDP
#> 34       Metadata for International poverty rate ($2.15 in 2017 PPP), MPO projections
#>               metadata_information.idno metadata_information.prod_date
#> 1                        META_GGDBTTOTL                     2024-07-02
#> 2                        META_BFCAFFFDI                     2024-07-02
#> 3                        META_FPCPITOTL                     2024-07-02
#> 4                        META_GGEXPTOTL                     2024-07-02
#> 5                       META_MP_PJ_POV2                     2024-07-02
#> 6                        META_BNCABFUND                     2024-07-02
#> 7                        META_NYGDPMKTP                     2024-07-02
#> 8                        META_BFCAFTOTL                     2024-07-02
#> 9                        META_GGBALOVRL                     2024-07-02
#> 10                     META_FPCPITOTLXN                     2024-07-02
#> 11                       META_GGREVTOTL                     2024-07-02
#> 12                      META_MP_PJ_POV3                     2024-07-02
#> 13                       META_NEGDIFTOT                     2024-07-02
#> 14                       META_NYGDPFCST                     2024-07-02
#> 15                       META_GGEXPINTP                     2024-07-02
#> 16                       META_NECONGOVT                     2024-07-02
#> 17                       META_NEEXPGNFS                     2024-07-02
#> 18                       META_NVAGRTOTL                     2024-07-02
#> 19 16ffd22e-c3b6-477d-bb16-45c423263eb0                           <NA>
#> 20                       META_NVINDTOTL                     2024-07-02
#> 21                       META_GGBALPRIM                     2024-07-02
#> 22                       META_NEIMPGNFS                     2024-07-02
#> 23                       META_NVSRVTOTL                     2024-07-02
#> 24                     META_NYGDPMKTPXN                     2024-07-02
#> 25                       META_ENATMCO2E                     2024-07-02
#> 26                       META_ENTOTGHGE                     2024-07-02
#> 27                       META_ENENRGHGE                     2024-07-02
#> 28                       META_NECONPRVT                     2024-07-02
#> 29                       META_SPPOPTOTL                     2024-07-02
#> 30                         META_NYGDPPC                     2024-07-02
#> 31                       META_CONPRVTPC                     2024-07-02
#> 32                     META_NECONPRVTXN                     2024-07-02
#> 33                      META_NEGDIFTOTK                     2024-07-02
#> 34                      META_MP_PJ_POV1                     2024-07-02
#>    metadata_information.version_statement.version
#> 1                                            <NA>
#> 2                                            <NA>
#> 3                                            <NA>
#> 4                                             1.1
#> 5                                            <NA>
#> 6                                            <NA>
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
#> 1                                           2026-06-05
#> 2                                           2026-06-05
#> 3                                           2026-06-05
#> 4                                           2026-06-05
#> 5                                           2026-06-05
#> 6                                           2026-06-05
#> 7                                           2026-06-05
#> 8                                           2026-06-05
#> 9                                           2026-06-05
#> 10                                          2026-06-05
#> 11                                          2026-06-05
#> 12                                          2026-06-05
#> 13                                          2026-06-05
#> 14                                          2026-06-05
#> 15                                          2026-06-05
#> 16                                          2026-06-05
#> 17                                          2026-06-05
#> 18                                          2026-06-05
#> 19                                                <NA>
#> 20                                          2026-06-05
#> 21                                          2026-06-05
#> 22                                          2026-06-05
#> 23                                          2026-06-05
#> 24                                          2026-06-05
#> 25                                          2026-06-05
#> 26                                          2026-06-05
#> 27                                          2026-06-05
#> 28                                          2026-06-05
#> 29                                          2026-06-05
#> 30                                          2026-06-05
#> 31                                          2026-06-05
#> 32                                          2026-06-05
#> 33                                          2026-06-05
#> 34                                          2026-06-05
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
#> 19                                                      <NA>
#> 20 Metadata updated by automated Data360 publishing pipeline
#> 21 Metadata updated by automated Data360 publishing pipeline
#> 22 Metadata updated by automated Data360 publishing pipeline
#> 23 Metadata updated by automated Data360 publishing pipeline
#> 24 Metadata updated by automated Data360 publishing pipeline
#> 25 Metadata updated by automated Data360 publishing pipeline
#> 26 Metadata updated by automated Data360 publishing pipeline
#> 27 Metadata updated by automated Data360 publishing pipeline
#> 28 Metadata updated by automated Data360 publishing pipeline
#> 29 Metadata updated by automated Data360 publishing pipeline
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
#> 19                                                    NULL
#> 20 Development Economics Data Group, DECDG, World Bank, NA
#> 21 Development Economics Data Group, DECDG, World Bank, NA
#> 22 Development Economics Data Group, DECDG, World Bank, NA
#> 23 Development Economics Data Group, DECDG, World Bank, NA
#> 24 Development Economics Data Group, DECDG, World Bank, NA
#> 25 Development Economics Data Group, DECDG, World Bank, NA
#> 26 Development Economics Data Group, DECDG, World Bank, NA
#> 27 Development Economics Data Group, DECDG, World Bank, NA
#> 28 Development Economics Data Group, DECDG, World Bank, NA
#> 29 Development Economics Data Group, DECDG, World Bank, NA
#> 30 Development Economics Data Group, DECDG, World Bank, NA
#> 31 Development Economics Data Group, DECDG, World Bank, NA
#> 32 Development Economics Data Group, DECDG, World Bank, NA
#> 33 Development Economics Data Group, DECDG, World Bank, NA
#> 34 Development Economics Data Group, DECDG, World Bank, NA
#>    series_description.idno series_description.doi
#> 1                GGDBTTOTL                     NA
#> 2                BFCAFFFDI                     NA
#> 3                FPCPITOTL                     NA
#> 4                GGEXPTOTL                     NA
#> 5               MP_PJ_POV2                     NA
#> 6                BNCABFUND                     NA
#> 7                NYGDPMKTP                     NA
#> 8                BFCAFTOTL                     NA
#> 9                GGBALOVRL                     NA
#> 10             FPCPITOTLXN                     NA
#> 11               GGREVTOTL                     NA
#> 12              MP_PJ_POV3                     NA
#> 13               NEGDIFTOT                     NA
#> 14               NYGDPFCST                     NA
#> 15               GGEXPINTP                     NA
#> 16               NECONGOVT                     NA
#> 17               NEEXPGNFS                     NA
#> 18               NVAGRTOTL                     NA
#> 19                    <NA>                     NA
#> 20               NVINDTOTL                     NA
#> 21               GGBALPRIM                     NA
#> 22               NEIMPGNFS                     NA
#> 23               NVSRVTOTL                     NA
#> 24             NYGDPMKTPXN                     NA
#> 25               ENATMCO2E                     NA
#> 26               ENTOTGHGE                     NA
#> 27               ENENRGHGE                     NA
#> 28               NECONPRVT                     NA
#> 29               SPPOPTOTL                     NA
#> 30                 NYGDPPC                     NA
#> 31               CONPRVTPC                     NA
#> 32             NECONPRVTXN                     NA
#> 33              NEGDIFTOTK                     NA
#> 34              MP_PJ_POV1                     NA
#>                                                  series_description.name
#> 1                                          General Government Debt Stock
#> 2                                  Net Foreign Direct Investment Outflow
#> 3                                                         Inflation Rate
#> 4                                                      Total Expenditure
#> 5  Lower middle-income poverty rate ($3.65 in 2017 PPP), MPO projections
#> 6                                                Current Account Balance
#> 7                                 Gross Domestic Product at Market Price
#> 8                                  Capital and Financial Account Balance
#> 9                                                 Overall Fiscal Balance
#> 10                               Consumer Price Index, Implicit Deflator
#> 11                                              Total Revenue and Grants
#> 12 Upper middle-income poverty rate ($6.85 in 2017 PPP), MPO projections
#> 13                                                Gross Fixed Investment
#> 14                                 Gross Domestic Product at Factor Cost
#> 15                                                     Interest Payments
#> 16                                                Government Consumption
#> 17                          Goods and Non-Factor Services (GNFS) Exports
#> 18                                              Agriculture, Value Added
#> 19                                                 Macro Poverty Outlook
#> 20                                                 Industry, Value Added
#> 21                                                Primary Fiscal Balance
#> 22                          Goods and Non-Factor Services (GNFS) Imports
#> 23                                                 Services, Value Added
#> 24             Gross Domestic Product at Market Price, Implicit Deflator
#> 25                                        Emissions: Total CO2 emissions
#> 26                                        Emissions: Total GHG emissions
#> 27                         Emissions: Energy, fuel combustion activities
#> 28                                                   Private Consumption
#> 29                                           Population, MPO Projections
#> 30                                        GDP per capita at Market Price
#> 31                                        Private Consumption per capita
#> 32                                Private Consumption, Implicit Deflator
#> 33                           Gross Fixed Investment as percentage of GDP
#> 34       International poverty rate ($2.15 in 2017 PPP), MPO projections
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
#> 1             Macro Poverty Outlook                                <NA>
#> 2             Macro Poverty Outlook                                <NA>
#> 3             Macro Poverty Outlook                                <NA>
#> 4             Macro Poverty Outlook                                <NA>
#> 5             Macro Poverty Outlook                                <NA>
#> 6             Macro Poverty Outlook                                <NA>
#> 7             Macro Poverty Outlook                                <NA>
#> 8             Macro Poverty Outlook                                <NA>
#> 9             Macro Poverty Outlook                                <NA>
#> 10            Macro Poverty Outlook                                <NA>
#> 11            Macro Poverty Outlook                                <NA>
#> 12            Macro Poverty Outlook                                <NA>
#> 13            Macro Poverty Outlook                                <NA>
#> 14            Macro Poverty Outlook                                <NA>
#> 15            Macro Poverty Outlook                                <NA>
#> 16            Macro Poverty Outlook                                <NA>
#> 17            Macro Poverty Outlook                                <NA>
#> 18            Macro Poverty Outlook                                <NA>
#> 19            Macro Poverty Outlook                          2026-06-05
#> 20            Macro Poverty Outlook                                <NA>
#> 21            Macro Poverty Outlook                                <NA>
#> 22            Macro Poverty Outlook                                <NA>
#> 23            Macro Poverty Outlook                                <NA>
#> 24            Macro Poverty Outlook                                <NA>
#> 25            Macro Poverty Outlook                                <NA>
#> 26            Macro Poverty Outlook                                <NA>
#> 27            Macro Poverty Outlook                                <NA>
#> 28            Macro Poverty Outlook                                <NA>
#> 29            Macro Poverty Outlook                                <NA>
#> 30            Macro Poverty Outlook                                <NA>
#> 31            Macro Poverty Outlook                                <NA>
#> 32            Macro Poverty Outlook                                <NA>
#> 33            Macro Poverty Outlook                                <NA>
#> 34            Macro Poverty Outlook                                <NA>
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
#> 1                  Percentage of GDP, Domestic currency (Millions), US dollars (Millions)
#> 2                                                Percentage of GDP, US dollars (Millions)
#> 3                                                             Percentage change per annum
#> 4                                                                   US dollars (Millions)
#> 5                                                                Percentage of population
#> 6                                                Percentage of GDP, US dollars (Millions)
#> 7        Percentage change per annum, Domestic currency (Millions), US dollars (Millions)
#> 8                                                                   US dollars (Millions)
#> 9                  Percentage of GDP, Domestic currency (Millions), US dollars (Millions)
#> 10                                                                                  Index
#> 11                                                                  US dollars (Millions)
#> 12                                                               Percentage of population
#> 13       Percentage change per annum, Domestic currency (Millions), US dollars (Millions)
#> 14       Percentage change per annum, Domestic currency (Millions), US dollars (Millions)
#> 15                                                           Domestic currency (Millions)
#> 16       Percentage change per annum, Domestic currency (Millions), US dollars (Millions)
#> 17       Percentage change per annum, Domestic currency (Millions), US dollars (Millions)
#> 18       Percentage change per annum, Domestic currency (Millions), US dollars (Millions)
#> 19                                                                                   <NA>
#> 20       Percentage change per annum, Domestic currency (Millions), US dollars (Millions)
#> 21                 Percentage of GDP, Domestic currency (Millions), US dollars (Millions)
#> 22       Percentage change per annum, Domestic currency (Millions), US dollars (Millions)
#> 23       Percentage change per annum, Domestic currency (Millions), US dollars (Millions)
#> 24                                                                                  Index
#> 25                                                                      Kilotonnes of CO2
#> 26                              Percentage change per annum, Kilotonnes of CO2-equivalent
#> 27 Percentage of GHG emissions, Percentage change per annum, Kilotonnes of CO2-equivalent
#> 28       Percentage change per annum, Domestic currency (Millions), US dollars (Millions)
#> 29                                                                     Persons (Millions)
#> 30       Percentage change per annum, Domestic currency (Millions), US dollars (Millions)
#> 31       Percentage change per annum, Domestic currency (Millions), US dollars (Millions)
#> 32                                                                                  Index
#> 33                                                                      Percentage of GDP
#> 34                                                               Percentage of population
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
#> 19 {"update_schedule":null,"update_frequency":"annual"}
#> 20                                                 <NA>
#> 21                                                 <NA>
#> 22                                                 <NA>
#> 23                                                 <NA>
#> 24                                                 <NA>
#> 25                                                 <NA>
#> 26                                                 <NA>
#> 27                                                 <NA>
#> 28                                                 <NA>
#> 29                                                 <NA>
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
#> 19                           <NA>                             NA
#> 20                         Annual                             NA
#> 21                         Annual                             NA
#> 22                         Annual                             NA
#> 23                         Annual                             NA
#> 24                         Annual                             NA
#> 25                         Annual                             NA
#> 26                         Annual                             NA
#> 27                         Annual                             NA
#> 28                         Annual                             NA
#> 29                         Annual                             NA
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
#> 19 The Macro Poverty Outlook (MPO) analyzes macroeconomic and poverty developments in 147 developing countries. The report is released twice annually for the Spring and Annual Meetings of the World Bank and the International Monetary Fund. The MPO consists of individual country notes that provide an overview of recent developments, forecasts of major macroeconomic variables and poverty during 2024-2026, and a discussion of critical challenges for economic growth, macroeconomic stability, and poverty reduction moving forward.\n\nFor further details, please refer to https://www.worldbank.org/en/publication/macro-poverty-outlook
#> 20                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 21                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 22                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 23                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 24                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 25                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 26                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 27                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 28                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 29                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
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
#> 19                                                                                          <NA>
#> 20 Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 21 Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 22 Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 23 Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 24 Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 25 Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 26 Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 27 Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 28 Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 29 Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
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
#> 19                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              <NA>
#> 20 You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 21 You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 22 You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 23 You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 24 You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 25 You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 26 You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 27 You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 28 You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 29 You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
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
#> 19                                      <NA>
#> 20                                        PU
#> 21                                        PU
#> 22                                        PU
#> 23                                        PU
#> 24                                        PU
#> 25                                        PU
#> 26                                        PU
#> 27                                        PU
#> 28                                        PU
#> 29                                        PU
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
#> 19                                                               <NA>
#> 20 https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 21 https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 22 https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 23 https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 24 https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 25 https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 26 https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 27 https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 28 https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 29 https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
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
#> 19 World Bank. (Year). Macro Poverty Outlook. Washington, DC: World Bank. https://www.worldbank.org/en/publication/macro-poverty-outlook
#> 20                                                                                                                                  <NA>
#> 21                                                                                                                                  <NA>
#> 22                                                                                                                                  <NA>
#> 23                                                                                                                                  <NA>
#> 24                                                                                                                                  <NA>
#> 25                                                                                                                                  <NA>
#> 26                                                                                                                                  <NA>
#> 27                                                                                                                                  <NA>
#> 28                                                                                                                                  <NA>
#> 29                                                                                                                                  <NA>
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
#> 19                            NA                                149
#> 20                            NA                                 NA
#> 21                            NA                                 NA
#> 22                            NA                                 NA
#> 23                            NA                                 NA
#> 24                            NA                                 NA
#> 25                            NA                                 NA
#> 26                            NA                                 NA
#> 27                            NA                                 NA
#> 28                            NA                                 NA
#> 29                            NA                                 NA
#> 30                            NA                                 NA
#> 31                            NA                                 NA
#> 32                            NA                                 NA
#> 33                            NA                                 NA
#> 34                            NA                                 NA
#>                                                    series_description.csv_link
#> 1    https://data360files.worldbank.org/data360-data/data/WB_MPO/GGDBTTOTL.csv
#> 2    https://data360files.worldbank.org/data360-data/data/WB_MPO/BFCAFFFDI.csv
#> 3    https://data360files.worldbank.org/data360-data/data/WB_MPO/FPCPITOTL.csv
#> 4    https://data360files.worldbank.org/data360-data/data/WB_MPO/GGEXPTOTL.csv
#> 5   https://data360files.worldbank.org/data360-data/data/WB_MPO/MP_PJ_POV2.csv
#> 6    https://data360files.worldbank.org/data360-data/data/WB_MPO/BNCABFUND.csv
#> 7    https://data360files.worldbank.org/data360-data/data/WB_MPO/NYGDPMKTP.csv
#> 8    https://data360files.worldbank.org/data360-data/data/WB_MPO/BFCAFTOTL.csv
#> 9    https://data360files.worldbank.org/data360-data/data/WB_MPO/GGBALOVRL.csv
#> 10 https://data360files.worldbank.org/data360-data/data/WB_MPO/FPCPITOTLXN.csv
#> 11   https://data360files.worldbank.org/data360-data/data/WB_MPO/GGREVTOTL.csv
#> 12  https://data360files.worldbank.org/data360-data/data/WB_MPO/MP_PJ_POV3.csv
#> 13   https://data360files.worldbank.org/data360-data/data/WB_MPO/NEGDIFTOT.csv
#> 14   https://data360files.worldbank.org/data360-data/data/WB_MPO/NYGDPFCST.csv
#> 15   https://data360files.worldbank.org/data360-data/data/WB_MPO/GGEXPINTP.csv
#> 16   https://data360files.worldbank.org/data360-data/data/WB_MPO/NECONGOVT.csv
#> 17   https://data360files.worldbank.org/data360-data/data/WB_MPO/NEEXPGNFS.csv
#> 18   https://data360files.worldbank.org/data360-data/data/WB_MPO/NVAGRTOTL.csv
#> 19      https://data360files.worldbank.org/data360-data/data/WB_MPO/WB_MPO.csv
#> 20   https://data360files.worldbank.org/data360-data/data/WB_MPO/NVINDTOTL.csv
#> 21   https://data360files.worldbank.org/data360-data/data/WB_MPO/GGBALPRIM.csv
#> 22   https://data360files.worldbank.org/data360-data/data/WB_MPO/NEIMPGNFS.csv
#> 23   https://data360files.worldbank.org/data360-data/data/WB_MPO/NVSRVTOTL.csv
#> 24 https://data360files.worldbank.org/data360-data/data/WB_MPO/NYGDPMKTPXN.csv
#> 25   https://data360files.worldbank.org/data360-data/data/WB_MPO/ENATMCO2E.csv
#> 26   https://data360files.worldbank.org/data360-data/data/WB_MPO/ENTOTGHGE.csv
#> 27   https://data360files.worldbank.org/data360-data/data/WB_MPO/ENENRGHGE.csv
#> 28   https://data360files.worldbank.org/data360-data/data/WB_MPO/NECONPRVT.csv
#> 29   https://data360files.worldbank.org/data360-data/data/WB_MPO/SPPOPTOTL.csv
#> 30     https://data360files.worldbank.org/data360-data/data/WB_MPO/NYGDPPC.csv
#> 31   https://data360files.worldbank.org/data360-data/data/WB_MPO/CONPRVTPC.csv
#> 32 https://data360files.worldbank.org/data360-data/data/WB_MPO/NECONPRVTXN.csv
#> 33  https://data360files.worldbank.org/data360-data/data/WB_MPO/NEGDIFTOTK.csv
#> 34  https://data360files.worldbank.org/data360-data/data/WB_MPO/MP_PJ_POV1.csv
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
#> 1    https://data360files.worldbank.org/data360-data/metadata/WB_MPO/GGDBTTOTL.json
#> 2    https://data360files.worldbank.org/data360-data/metadata/WB_MPO/BFCAFFFDI.json
#> 3    https://data360files.worldbank.org/data360-data/metadata/WB_MPO/FPCPITOTL.json
#> 4    https://data360files.worldbank.org/data360-data/metadata/WB_MPO/GGEXPTOTL.json
#> 5   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/MP_PJ_POV2.json
#> 6    https://data360files.worldbank.org/data360-data/metadata/WB_MPO/BNCABFUND.json
#> 7    https://data360files.worldbank.org/data360-data/metadata/WB_MPO/NYGDPMKTP.json
#> 8    https://data360files.worldbank.org/data360-data/metadata/WB_MPO/BFCAFTOTL.json
#> 9    https://data360files.worldbank.org/data360-data/metadata/WB_MPO/GGBALOVRL.json
#> 10 https://data360files.worldbank.org/data360-data/metadata/WB_MPO/FPCPITOTLXN.json
#> 11   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/GGREVTOTL.json
#> 12  https://data360files.worldbank.org/data360-data/metadata/WB_MPO/MP_PJ_POV3.json
#> 13   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/NEGDIFTOT.json
#> 14   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/NYGDPFCST.json
#> 15   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/GGEXPINTP.json
#> 16   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/NECONGOVT.json
#> 17   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/NEEXPGNFS.json
#> 18   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/NVAGRTOTL.json
#> 19      https://data360files.worldbank.org/data360-data/datasetmetadata/WB_MPO.json
#> 20   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/NVINDTOTL.json
#> 21   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/GGBALPRIM.json
#> 22   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/NEIMPGNFS.json
#> 23   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/NVSRVTOTL.json
#> 24 https://data360files.worldbank.org/data360-data/metadata/WB_MPO/NYGDPMKTPXN.json
#> 25   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/ENATMCO2E.json
#> 26   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/ENTOTGHGE.json
#> 27   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/ENENRGHGE.json
#> 28   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/NECONPRVT.json
#> 29   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/SPPOPTOTL.json
#> 30     https://data360files.worldbank.org/data360-data/metadata/WB_MPO/NYGDPPC.json
#> 31   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/CONPRVTPC.json
#> 32 https://data360files.worldbank.org/data360-data/metadata/WB_MPO/NECONPRVTXN.json
#> 33  https://data360files.worldbank.org/data360-data/metadata/WB_MPO/NEGDIFTOTK.json
#> 34  https://data360files.worldbank.org/data360-data/metadata/WB_MPO/MP_PJ_POV1.json
#>                                                                               series_description.api_link
#> 1    https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=GGDBTTOTL
#> 2    https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=BFCAFFFDI
#> 3    https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=FPCPITOTL
#> 4    https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=GGEXPTOTL
#> 5   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=MP_PJ_POV2
#> 6    https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=BNCABFUND
#> 7    https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=NYGDPMKTP
#> 8    https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=BFCAFTOTL
#> 9    https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=GGBALOVRL
#> 10 https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=FPCPITOTLXN
#> 11   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=GGREVTOTL
#> 12  https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=MP_PJ_POV3
#> 13   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=NEGDIFTOT
#> 14   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=NYGDPFCST
#> 15   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=GGEXPINTP
#> 16   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=NECONGOVT
#> 17   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=NEEXPGNFS
#> 18   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=NVAGRTOTL
#> 19                       https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO
#> 20   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=NVINDTOTL
#> 21   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=GGBALPRIM
#> 22   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=NEIMPGNFS
#> 23   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=NVSRVTOTL
#> 24 https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=NYGDPMKTPXN
#> 25   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=ENATMCO2E
#> 26   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=ENTOTGHGE
#> 27   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=ENENRGHGE
#> 28   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=NECONPRVT
#> 29   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=SPPOPTOTL
#> 30     https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=NYGDPPC
#> 31   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=CONPRVTPC
#> 32 https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=NECONPRVTXN
#> 33  https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=NEGDIFTOTK
#> 34  https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=MP_PJ_POV1
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
#> 19                                 33                                 NA
#> 20                                 NA                                 NA
#> 21                                 NA                                 NA
#> 22                                 NA                                 NA
#> 23                                 NA                                 NA
#> 24                                 NA                                 NA
#> 25                                 NA                                 NA
#> 26                                 NA                                 NA
#> 27                                 NA                                 NA
#> 28                                 NA                                 NA
#> 29                                 NA                                 NA
#> 30                                 NA                                 NA
#> 31                                 NA                                 NA
#> 32                                 NA                                 NA
#> 33                                 NA                                 NA
#> 34                                 NA                                 NA
#>                                                                           series_description.api_explorer_link
#> 1    http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=GGDBTTOTL
#> 2    http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=BFCAFFFDI
#> 3    http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=FPCPITOTL
#> 4    http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=GGEXPTOTL
#> 5   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=MP_PJ_POV2
#> 6    http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=BNCABFUND
#> 7    http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=NYGDPMKTP
#> 8    http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=BFCAFTOTL
#> 9    http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=GGBALOVRL
#> 10 http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=FPCPITOTLXN
#> 11   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=GGREVTOTL
#> 12  http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=MP_PJ_POV3
#> 13   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=NEGDIFTOT
#> 14   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=NYGDPFCST
#> 15   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=GGEXPINTP
#> 16   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=NECONGOVT
#> 17   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=NEEXPGNFS
#> 18   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=NVAGRTOTL
#> 19                       http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO
#> 20   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=NVINDTOTL
#> 21   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=GGBALPRIM
#> 22   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=NEIMPGNFS
#> 23   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=NVSRVTOTL
#> 24 http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=NYGDPMKTPXN
#> 25   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=ENATMCO2E
#> 26   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=ENTOTGHGE
#> 27   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=ENENRGHGE
#> 28   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=NECONPRVT
#> 29   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=SPPOPTOTL
#> 30     http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=NYGDPPC
#> 31   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=CONPRVTPC
#> 32 http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=NECONPRVTXN
#> 33  http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=NEGDIFTOTK
#> 34  http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=MP_PJ_POV1
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
#> 1                                         2026-06-05
#> 2                                         2026-06-05
#> 3                                         2026-06-05
#> 4                                         2026-06-05
#> 5                                         2026-06-05
#> 6                                         2026-06-05
#> 7                                         2026-06-05
#> 8                                         2026-06-05
#> 9                                         2026-06-05
#> 10                                        2026-06-05
#> 11                                        2026-06-05
#> 12                                        2026-06-05
#> 13                                        2026-06-05
#> 14                                        2026-06-05
#> 15                                        2026-06-05
#> 16                                        2026-06-05
#> 17                                        2026-06-05
#> 18                                        2026-06-05
#> 19                                              <NA>
#> 20                                        2026-06-05
#> 21                                        2026-06-05
#> 22                                        2026-06-05
#> 23                                        2026-06-05
#> 24                                        2026-06-05
#> 25                                        2026-06-05
#> 26                                        2026-06-05
#> 27                                        2026-06-05
#> 28                                        2026-06-05
#> 29                                        2026-06-05
#> 30                                        2026-06-05
#> 31                                        2026-06-05
#> 32                                        2026-06-05
#> 33                                        2026-06-05
#> 34                                        2026-06-05
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
#> 1    EFIDATA360_IND_ID, WB.MPO.GGDBTTOTLCD, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 2    EFIDATA360_IND_ID, WB.MPO.BFCAFFFDICD, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 3   EFIDATA360_IND_ID, WB.MPO.FPCPITOTLXNZ, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 4    EFIDATA360_IND_ID, WB.MPO.GGEXPTOTLCD, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 5           EFIDATA360_IND_ID, WB.MPO.POV2, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 6    EFIDATA360_IND_ID, WB.MPO.BNCABFUNDCD, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 7    EFIDATA360_IND_ID, WB.MPO.NYGDPMKTPCD, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 8    EFIDATA360_IND_ID, WB.MPO.BFCAFTOTLCD, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 9    EFIDATA360_IND_ID, WB.MPO.GGBALOVRLCD, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 10   EFIDATA360_IND_ID, WB.MPO.FPCPITOTLXN, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 11   EFIDATA360_IND_ID, WB.MPO.GGREVTOTLCD, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 12          EFIDATA360_IND_ID, WB.MPO.POV3, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 13   EFIDATA360_IND_ID, WB.MPO.NEGDIFTOTCN, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 14   EFIDATA360_IND_ID, WB.MPO.NYGDPFCSTCD, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 15   EFIDATA360_IND_ID, WB.MPO.GGEXPINTPCN, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 16   EFIDATA360_IND_ID, WB.MPO.NECONGOVTCN, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 17   EFIDATA360_IND_ID, WB.MPO.NEEXPGNFSCN, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 18   EFIDATA360_IND_ID, WB.MPO.NVAGRTOTLCN, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 19                                                                                                            NULL
#> 20   EFIDATA360_IND_ID, WB.MPO.NVINDTOTLCN, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 21   EFIDATA360_IND_ID, WB.MPO.GGBALPRIMCD, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 22   EFIDATA360_IND_ID, WB.MPO.NEIMPGNFSCN, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 23   EFIDATA360_IND_ID, WB.MPO.NVSRVTOTLCN, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 24   EFIDATA360_IND_ID, WB.MPO.NYGDPMKTPXN, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 25   EFIDATA360_IND_ID, WB.MPO.ENATMCO2EKT, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 26   EFIDATA360_IND_ID, WB.MPO.ENTOTGHGEKT, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 27   EFIDATA360_IND_ID, WB.MPO.ENENRGHGEKT, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 28   EFIDATA360_IND_ID, WB.MPO.NECONPRVTCN, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 29     EFIDATA360_IND_ID, WB.MPO.SPPOPTOTL, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 30     EFIDATA360_IND_ID, WB.MPO.NYGDPPCKD, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 31 EFIDATA360_IND_ID, WB.MPO.NECONPRVTPCKD, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 32   EFIDATA360_IND_ID, WB.MPO.NECONPRVTXN, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 33  EFIDATA360_IND_ID, WB.MPO.NEGDIFTOTKD_, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 34          EFIDATA360_IND_ID, WB.MPO.POV1, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
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
#> 19                         NULL
#> 20                  English, EN
#> 21                  English, EN
#> 22                  English, EN
#> 23                  English, EN
#> 24                  English, EN
#> 25                  English, EN
#> 26                  English, EN
#> 27                  English, EN
#> 28                  English, EN
#> 29                  English, EN
#> 30                  English, EN
#> 31                  English, EN
#> 32                  English, EN
#> 33                  English, EN
#> 34                  English, EN
#>                                                                                                                                                                                           series_description.dimensions
#> 1                                        NA, NA, NA, NA, NA, Time period, Price Basis, Vintage, Geographic area, Unit of measure, NA, NA, NA, Country/economy, Region, Domestic currency, Percentage of GDP, US dollars
#> 2                                                           NA, NA, NA, NA, NA, Time period, Price Basis, Vintage, Unit of measure, Geographic area, NA, NA, NA, Percentage of GDP, US dollars, Country/economy, Region
#> 3                                                                                                               NA, NA, NA, NA, Geographic area, Time period, Price Basis, Vintage, Country/economy, Region, NA, NA, NA
#> 4                                                                                                               NA, NA, NA, NA, Geographic area, Time period, Price Basis, Vintage, Country/economy, Region, NA, NA, NA
#> 5                                                                                                               NA, NA, NA, NA, Geographic area, Time period, Price Basis, Vintage, Country/economy, Region, NA, NA, NA
#> 6                                                           NA, NA, NA, NA, NA, Time period, Price Basis, Vintage, Unit of measure, Geographic area, NA, NA, NA, Percentage of GDP, US dollars, Country/economy, Region
#> 7                              NA, NA, NA, NA, NA, Time period, Price Basis, Vintage, Geographic area, Unit of measure, NA, NA, NA, Country/economy, Region, Domestic currency, Percentage change per annum, US dollars
#> 8                                                                                                               NA, NA, NA, NA, Geographic area, Time period, Price Basis, Vintage, Country/economy, Region, NA, NA, NA
#> 9                                        NA, NA, NA, NA, NA, Time period, Price Basis, Vintage, Geographic area, Unit of measure, NA, NA, NA, Country/economy, Region, Domestic currency, Percentage of GDP, US dollars
#> 10                                                                                                              NA, NA, NA, NA, Geographic area, Time period, Price Basis, Vintage, Country/economy, Region, NA, NA, NA
#> 11                                                                                                              NA, NA, NA, NA, Geographic area, Time period, Price Basis, Vintage, Country/economy, Region, NA, NA, NA
#> 12                                                                                                              NA, NA, NA, NA, Geographic area, Time period, Price Basis, Vintage, Country/economy, Region, NA, NA, NA
#> 13                             NA, NA, NA, NA, NA, Time period, Price Basis, Vintage, Geographic area, Unit of measure, NA, NA, NA, Country/economy, Region, Domestic currency, Percentage change per annum, US dollars
#> 14                             NA, NA, NA, NA, NA, Time period, Price Basis, Vintage, Geographic area, Unit of measure, NA, NA, NA, Country/economy, Region, Domestic currency, Percentage change per annum, US dollars
#> 15                                                                                                              NA, NA, NA, NA, Geographic area, Time period, Price Basis, Vintage, Country/economy, Region, NA, NA, NA
#> 16                             NA, NA, NA, NA, NA, Time period, Price Basis, Vintage, Geographic area, Unit of measure, NA, NA, NA, Country/economy, Region, Domestic currency, Percentage change per annum, US dollars
#> 17                             NA, NA, NA, NA, NA, Time period, Price Basis, Vintage, Geographic area, Unit of measure, NA, NA, NA, Country/economy, Region, Domestic currency, Percentage change per annum, US dollars
#> 18                             NA, NA, NA, NA, NA, Time period, Price Basis, Vintage, Geographic area, Unit of measure, NA, NA, NA, Country/economy, Region, Domestic currency, Percentage change per annum, US dollars
#> 19                                                                                                                                                                                                                 NULL
#> 20                             NA, NA, NA, NA, NA, Time period, Price Basis, Vintage, Geographic area, Unit of measure, NA, NA, NA, Country/economy, Region, Domestic currency, Percentage change per annum, US dollars
#> 21                                       NA, NA, NA, NA, NA, Time period, Price Basis, Vintage, Geographic area, Unit of measure, NA, NA, NA, Country/economy, Region, Domestic currency, Percentage of GDP, US dollars
#> 22                             NA, NA, NA, NA, NA, Time period, Price Basis, Vintage, Geographic area, Unit of measure, NA, NA, NA, Country/economy, Region, Domestic currency, Percentage change per annum, US dollars
#> 23                             NA, NA, NA, NA, NA, Time period, Price Basis, Vintage, Geographic area, Unit of measure, NA, NA, NA, Country/economy, Region, Domestic currency, Percentage change per annum, US dollars
#> 24                                                                                                              NA, NA, NA, NA, Geographic area, Time period, Price Basis, Vintage, Country/economy, Region, NA, NA, NA
#> 25                                                                                                              NA, NA, NA, NA, Geographic area, Time period, Price Basis, Vintage, Country/economy, Region, NA, NA, NA
#> 26                              NA, NA, NA, NA, NA, Unit of measure, Time period, Price Basis, Vintage, Geographic area, Kilotonnes of CO2-equivalent, Percentage change per annum, NA, NA, NA, Country/economy, Region
#> 27 NA, NA, NA, NA, NA, Time period, Price Basis, Vintage, Geographic area, Unit of measure, NA, NA, NA, Country/economy, Region, Kilotonnes of CO2-equivalent, Percentage change per annum, Percentage of GHG emissions
#> 28                             NA, NA, NA, NA, NA, Time period, Price Basis, Vintage, Geographic area, Unit of measure, NA, NA, NA, Country/economy, Region, Domestic currency, Percentage change per annum, US dollars
#> 29                                                                                                              NA, NA, NA, NA, Geographic area, Time period, Price Basis, Vintage, Country/economy, Region, NA, NA, NA
#> 30                             NA, NA, NA, NA, NA, Time period, Price Basis, Vintage, Geographic area, Unit of measure, NA, NA, NA, Country/economy, Region, Domestic currency, Percentage change per annum, US dollars
#> 31                             NA, NA, NA, NA, NA, Time period, Price Basis, Vintage, Geographic area, Unit of measure, NA, NA, NA, Country/economy, Region, Domestic currency, Percentage change per annum, US dollars
#> 32                                                                                                              NA, NA, NA, NA, Geographic area, Time period, Price Basis, Vintage, Country/economy, Region, NA, NA, NA
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
#> 19                                                                                      NULL
#> 20 Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 21 Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 22 Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 23 Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 24 Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 25 Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 26 Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 27 Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 28 Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 29 Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
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
#> 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    P3, P3_000001, P3_000008, Prosperity, Economic Policy, Fiscal Policy, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         P3, P3_000001, P3_000009, Prosperity, Economic Policy, Macro-financial Policies, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 3                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         P3, P3_000001, P3_000009, Prosperity, Economic Policy, Macro-financial Policies, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 4                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    P3, P3_000001, P3_000008, Prosperity, Economic Policy, Fiscal Policy, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 5                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  P3, P3_000004, P3_000020, Prosperity, Poverty, Poverty, NA, P3, P3_000004, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 6                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         P3, P3_000001, P3_000009, Prosperity, Economic Policy, Macro-financial Policies, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 7                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  P3, P3_000001, P3_000007, Prosperity, Economic Policy, Growth and Jobs, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 8                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         P3, P3_000001, P3_000009, Prosperity, Economic Policy, Macro-financial Policies, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 9                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    P3, P3_000001, P3_000008, Prosperity, Economic Policy, Fiscal Policy, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 10                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        P3, P3_000001, P3_000009, Prosperity, Economic Policy, Macro-financial Policies, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 11                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   P3, P3_000001, P3_000008, Prosperity, Economic Policy, Fiscal Policy, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 12                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 P3, P3_000004, P3_000020, Prosperity, Poverty, Poverty, NA, P3, P3_000004, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 13                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   P3, P3_000001, P3_000008, Prosperity, Economic Policy, Fiscal Policy, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 14                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 P3, P3_000001, P3_000007, Prosperity, Economic Policy, Growth and Jobs, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 15                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   P3, P3_000001, P3_000008, Prosperity, Economic Policy, Fiscal Policy, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 16                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   P3, P3_000001, P3_000008, Prosperity, Economic Policy, Fiscal Policy, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 17                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            P3, P3_000006, P3_000028, Prosperity, Trade, Investment and Competitiveness, Trade Outcomes, NA, P3, P3_000006, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 18                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 P3, P3_000001, P3_000007, Prosperity, Economic Policy, Growth and Jobs, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 19 P3, P3_000001, P3_000006, P3_000004, P3_000007, P3_000008, P3_000009, P3_000020, P3_000028, Prosperity, Economic Policy, Trade, Investment and Competitiveness, Poverty, Growth and Jobs, Fiscal Policy, Macro-financial Policies, Poverty, Trade Outcomes, NA, P3, P3, P3, P3_000001, P3_000001, P3_000001, P3_000004, P3_000006, WB Practice Groups, Data360 Topic L1, Data360 Topic L1, Data360 Topic L1, Data360 Topic L2, Data360 Topic L2, Data360 Topic L2, Data360 Topic L2, Data360 Topic L2, https://fmr.worldbank.org/FMR/sdmx/v2/structure/codelist/WB.DATA360/CL_D360_TOPICS/1.0, https://fmr.worldbank.org/FMR/sdmx/v2/structure/hierarchy/WB.DATA360/H_D360_TOPICS/1.0, https://fmr.worldbank.org/FMR/sdmx/v2/structure/hierarchy/WB.DATA360/H_D360_TOPICS/1.0, https://fmr.worldbank.org/FMR/sdmx/v2/structure/hierarchy/WB.DATA360/H_D360_TOPICS/1.0, https://fmr.worldbank.org/FMR/sdmx/v2/structure/hierarchy/WB.DATA360/H_D360_TOPICS/1.0, https://fmr.worldbank.org/FMR/sdmx/v2/structure/hierarchy/WB.DATA360/H_D360_TOPICS/1.0, https://fmr.worldbank.org/FMR/sdmx/v2/structure/hierarchy/WB.DATA360/H_D360_TOPICS/1.0, https://fmr.worldbank.org/FMR/sdmx/v2/structure/hierarchy/WB.DATA360/H_D360_TOPICS/1.0, https://fmr.worldbank.org/FMR/sdmx/v2/structure/hierarchy/WB.DATA360/H_D360_TOPICS/1.0
#> 20                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 P3, P3_000001, P3_000007, Prosperity, Economic Policy, Growth and Jobs, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 21                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   P3, P3_000001, P3_000008, Prosperity, Economic Policy, Fiscal Policy, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 22                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            P3, P3_000006, P3_000028, Prosperity, Trade, Investment and Competitiveness, Trade Outcomes, NA, P3, P3_000006, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 23                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 P3, P3_000001, P3_000007, Prosperity, Economic Policy, Growth and Jobs, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 24                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 P3, P3_000001, P3_000007, Prosperity, Economic Policy, Growth and Jobs, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 25                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 P3, P3_000001, P3_000007, Prosperity, Economic Policy, Growth and Jobs, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 26                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 P3, P3_000001, P3_000007, Prosperity, Economic Policy, Growth and Jobs, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 27                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 P3, P3_000001, P3_000007, Prosperity, Economic Policy, Growth and Jobs, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 28                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 P3, P3_000001, P3_000007, Prosperity, Economic Policy, Growth and Jobs, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 29                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    P3, Prosperity, NA, WB Practice Groups, NA
#> 30                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 P3, P3_000001, P3_000007, Prosperity, Economic Policy, Growth and Jobs, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 31                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 P3, P3_000001, P3_000007, Prosperity, Economic Policy, Growth and Jobs, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 32                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 P3, P3_000001, P3_000007, Prosperity, Economic Policy, Growth and Jobs, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 33                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   P3, P3_000001, P3_000008, Prosperity, Economic Policy, Fiscal Policy, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 34                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            P3, P3_000004, P3_000020, P4, P4_000034, P4_000040, GAFS_0008, Prosperity, Poverty, Poverty, Infrastructure, Urban, Resilience and Land, Housing, Trends in the Determinants of Food Security Outcomes, NA, P3, P3_000004, NA, P4, P4_000034, NA, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, GAFS, NA, NA, NA, NA, NA, NA, NA
#>    series_description.time_periods
#> 1                   1980, 2028, NA
#> 2                   1980, 2028, NA
#> 3                   1981, 2028, NA
#> 4                   1980, 2028, NA
#> 5                   2010, 2028, NA
#> 6                   1980, 2028, NA
#> 7                   1980, 2028, NA
#> 8                   1980, 2026, NA
#> 9                   1980, 2028, NA
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
#> 21                  1980, 2028, NA
#> 22                  1980, 2028, NA
#> 23                  1980, 2028, NA
#> 24                  1980, 2028, NA
#> 25                  1990, 2028, NA
#> 26                  1990, 2028, NA
#> 27                  1990, 2028, NA
#> 28                  1980, 2028, NA
#> 29                  1980, 2028, NA
#> 30                  1980, 2028, NA
#> 31                  1980, 2028, NA
#> 32                  1980, 2028, NA
#> 33                  1980, 2028, NA
#> 34                  2010, 2028, NA
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             series_description.ref_country
#> 1                                                  Madagascar, Malawi, Malaysia, Serbia, Seychelles, Sierra Leone, Solomon Islands, Somalia, Federal Republic of, South Africa, South Sudan, Sri Lanka, St. Lucia, St. Vincent and the Grenadines, Sudan, Suriname, Tajikistan, Tanzania, Thailand, Timor-Leste, Togo, Tonga, Trinidad and Tobago, Tunisia, Türkiye, Uganda, Ukraine, United Arab Emirates, Uruguay, Uzbekistan, São Tomé and Príncipe, Syrian Arab Republic, Chad, Vietnam, Vanuatu, Samoa, Kosovo, Yemen, Rep., Zambia, Zimbabwe, Armenia, China, Algeria, Iran, Islamic Rep., Kenya, Cambodia, Libya, Mauritania, West Bank and Gaza, Saudi Arabia, Albania, Côte d’Ivoire, Cameroon, Congo, Rep., Costa Rica, Ecuador, Guinea, Gambia, The, Guatemala, Honduras, Haiti, Indonesia, Bolivia, Bosnia and Herzegovina, Botswana, Brazil, Bulgaria, Burkina Faso, Burundi, Cabo Verde, Central African Republic, Chile, Colombia, Comoros, Congo, Dem. Rep., Croatia, Djibouti, Dominica, Dominican Republic, Jamaica, Jordan, Kazakhstan, Kiribati, Kuwait, Kyrgyz Republic, Lao PDR, Lebanon, Lesotho, Liberia, Maldives, Mali, Mauritius, Mexico, Micronesia, Fed. Sts., Moldova, Mongolia, Montenegro, Grenada, Guyana, India, Iraq, Morocco, North Macedonia, Myanmar, Mozambique, Niger, Nigeria, Nicaragua, Oman, Pakistan, Peru, Philippines, Palau, Papua New Guinea, Poland, Qatar, Romania, Russian Federation, Rwanda, El Salvador, Angola, Argentina, Azerbaijan, Bahamas, The, Bahrain, Bangladesh, Barbados, Belarus, Belize, Benin, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Gabon, Georgia, Ghana, Guinea-Bissau, Equatorial Guinea, Namibia, Nepal, Panama, Paraguay, Senegal, Eswatini, Bhutan, Afghanistan, MDG, MWI, MYS, SRB, SYC, SLE, SLB, SOM, ZAF, SSD, LKA, LCA, VCT, SDN, SUR, TJK, TZA, THA, TLS, TGO, TON, TTO, TUN, TUR, UGA, UKR, ARE, URY, UZB, STP, SYR, TCD, VNM, VUT, WSM, XKX, YEM, ZMB, ZWE, ARM, CHN, DZA, IRN, KEN, KHM, LBY, MRT, PSE, SAU, ALB, CIV, CMR, COG, CRI, ECU, GIN, GMB, GTM, HND, HTI, IDN, BOL, BIH, BWA, BRA, BGR, BFA, BDI, CPV, CAF, CHL, COL, COM, COD, HRV, DJI, DMA, DOM, JAM, JOR, KAZ, KIR, KWT, KGZ, LAO, LBN, LSO, LBR, MDV, MLI, MUS, MEX, FSM, MDA, MNG, MNE, GRD, GUY, IND, IRQ, MAR, MKD, MMR, MOZ, NER, NGA, NIC, OMN, PAK, PER, PHL, PLW, PNG, POL, QAT, ROU, RUS, RWA, SLV, AGO, ARG, AZE, BHS, BHR, BGD, BRB, BLR, BLZ, BEN, EGY, ERI, ETH, FJI, GAB, GEO, GHA, GNB, GNQ, NAM, NPL, PAN, PRY, SEN, SWZ, BTN, AFG
#> 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                 Madagascar, Malawi, Serbia, Seychelles, Sierra Leone, Solomon Islands, South Africa, South Sudan, Sri Lanka, Sudan, Suriname, Tajikistan, Tanzania, Thailand, Timor-Leste, Togo, Tonga, Trinidad and Tobago, Tunisia, Türkiye, Uganda, Ukraine, Uruguay, São Tomé and Príncipe, Syrian Arab Republic, Chad, Uzbekistan, Vietnam, Vanuatu, Samoa, Kosovo, Yemen, Rep., Zambia, Zimbabwe, Armenia, China, Iran, Islamic Rep., Kenya, Cambodia, Mauritania, West Bank and Gaza, Saudi Arabia, Albania, Côte d’Ivoire, Congo, Rep., Costa Rica, Ecuador, Guinea, Guatemala, Honduras, Haiti, Indonesia, Maldives, Bosnia and Herzegovina, Botswana, Brazil, Bulgaria, Burkina Faso, Burundi, Cabo Verde, Chile, Croatia, Dominican Republic, Jamaica, Jordan, Kazakhstan, Kuwait, Kyrgyz Republic, Lebanon, Lesotho, Malaysia, Mali, Mauritius, Mexico, Micronesia, Fed. Sts., Moldova, Mongolia, Montenegro, Guyana, India, Iraq, Morocco, North Macedonia, Mozambique, Niger, Nigeria, Nicaragua, Oman, Pakistan, Peru, Philippines, Papua New Guinea, Poland, Qatar, Romania, Russian Federation, Rwanda, El Salvador, Angola, Argentina, Azerbaijan, Bahamas, The, Bahrain, Bangladesh, Belarus, Belize, Benin, Egypt, Arab Rep., Eritrea, Fiji, Gabon, Georgia, Ghana, Guinea-Bissau, Equatorial Guinea, Namibia, Nepal, Panama, Paraguay, Eswatini, Bolivia, Bhutan, Afghanistan, Cameroon, MDG, MWI, SRB, SYC, SLE, SLB, ZAF, SSD, LKA, SDN, SUR, TJK, TZA, THA, TLS, TGO, TON, TTO, TUN, TUR, UGA, UKR, URY, STP, SYR, TCD, UZB, VNM, VUT, WSM, XKX, YEM, ZMB, ZWE, ARM, CHN, IRN, KEN, KHM, MRT, PSE, SAU, ALB, CIV, COG, CRI, ECU, GIN, GTM, HND, HTI, IDN, MDV, BIH, BWA, BRA, BGR, BFA, BDI, CPV, CHL, HRV, DOM, JAM, JOR, KAZ, KWT, KGZ, LBN, LSO, MYS, MLI, MUS, MEX, FSM, MDA, MNG, MNE, GUY, IND, IRQ, MAR, MKD, MOZ, NER, NGA, NIC, OMN, PAK, PER, PHL, PNG, POL, QAT, ROU, RUS, RWA, SLV, AGO, ARG, AZE, BHS, BHR, BGD, BLR, BLZ, BEN, EGY, ERI, FJI, GAB, GEO, GHA, GNB, GNQ, NAM, NPL, PAN, PRY, SWZ, BOL, BTN, AFG, CMR
#> 3                                                                                             Madagascar, Malawi, Senegal, Serbia, Seychelles, Sierra Leone, Solomon Islands, Somalia, Federal Republic of, South Africa, South Sudan, Sri Lanka, St. Lucia, St. Vincent and the Grenadines, Sudan, Suriname, Tajikistan, Tanzania, Thailand, Timor-Leste, Togo, Tonga, Trinidad and Tobago, Tunisia, Türkiye, Uganda, Ukraine, United Arab Emirates, Uruguay, Bolivia, Bosnia and Herzegovina, Botswana, Brazil, Bulgaria, Burkina Faso, Burundi, Cabo Verde, Cambodia, Cameroon, Central African Republic, Chad, Chile, China, Colombia, Comoros, Congo, Dem. Rep., Congo, Rep., Costa Rica, Côte d’Ivoire, Croatia, Djibouti, Dominica, Jamaica, Jordan, Kazakhstan, Kenya, Kiribati, Kosovo, Kuwait, Kyrgyz Republic, Lao PDR, Lebanon, Lesotho, Liberia, Libya, Malaysia, Maldives, Mali, Mauritania, Mauritius, Mexico, Micronesia, Fed. Sts., Moldova, Mongolia, Montenegro, Uzbekistan, Vanuatu, Vietnam, Yemen, Rep., Zambia, Zimbabwe, Albania, Algeria, Angola, Armenia, Azerbaijan, Bahamas, The, Bahrain, Bangladesh, Barbados, Belarus, Belize, Benin, Morocco, Mozambique, Myanmar, Namibia, Nepal, Nicaragua, Niger, Nigeria, North Macedonia, Oman, Gambia, The, Georgia, Ghana, Grenada, Guatemala, Guinea, Guinea-Bissau, Guyana, Haiti, Honduras, India, Indonesia, Iran, Islamic Rep., Iraq, Afghanistan, Dominican Republic, Ecuador, Egypt, Arab Rep., El Salvador, Equatorial Guinea, Bhutan, Pakistan, Palau, West Bank and Gaza, Panama, Papua New Guinea, Paraguay, Peru, Philippines, Poland, Qatar, Romania, Russian Federation, Rwanda, Samoa, São Tomé and Príncipe, Saudi Arabia, Eritrea, Eswatini, Ethiopia, Fiji, Gabon, MDG, MWI, SEN, SRB, SYC, SLE, SLB, SOM, ZAF, SSD, LKA, LCA, VCT, SDN, SUR, TJK, TZA, THA, TLS, TGO, TON, TTO, TUN, TUR, UGA, UKR, ARE, URY, BOL, BIH, BWA, BRA, BGR, BFA, BDI, CPV, KHM, CMR, CAF, TCD, CHL, CHN, COL, COM, COD, COG, CRI, CIV, HRV, DJI, DMA, JAM, JOR, KAZ, KEN, KIR, XKX, KWT, KGZ, LAO, LBN, LSO, LBR, LBY, MYS, MDV, MLI, MRT, MUS, MEX, FSM, MDA, MNG, MNE, UZB, VUT, VNM, YEM, ZMB, ZWE, ALB, DZA, AGO, ARM, AZE, BHS, BHR, BGD, BRB, BLR, BLZ, BEN, MAR, MOZ, MMR, NAM, NPL, NIC, NER, NGA, MKD, OMN, GMB, GEO, GHA, GRD, GTM, GIN, GNB, GUY, HTI, HND, IND, IDN, IRN, IRQ, AFG, DOM, ECU, EGY, SLV, GNQ, BTN, PAK, PLW, PSE, PAN, PNG, PRY, PER, PHL, POL, QAT, ROU, RUS, RWA, WSM, STP, SAU, ERI, SWZ, ETH, FJI, GAB
#> 4                                                  Malawi, Serbia, Seychelles, Sierra Leone, Solomon Islands, Somalia, Federal Republic of, South Africa, South Sudan, Sri Lanka, St. Lucia, St. Vincent and the Grenadines, Sudan, Suriname, Tajikistan, Tanzania, Thailand, Timor-Leste, Togo, Tonga, Trinidad and Tobago, Tunisia, Türkiye, Uganda, Ukraine, United Arab Emirates, Uruguay, São Tomé and Príncipe, Syrian Arab Republic, Chad, Uzbekistan, Vietnam, Vanuatu, Samoa, Kosovo, Yemen, Rep., Zambia, Zimbabwe, Armenia, China, Algeria, Iran, Islamic Rep., Kenya, Cambodia, Libya, Mauritania, West Bank and Gaza, Saudi Arabia, Albania, Côte d’Ivoire, Cameroon, Congo, Rep., Costa Rica, Ecuador, Guinea, Gambia, The, Guatemala, Honduras, Haiti, Indonesia, Bosnia and Herzegovina, Botswana, Brazil, Bulgaria, Burkina Faso, Burundi, Cabo Verde, Central African Republic, Chile, Colombia, Comoros, Congo, Dem. Rep., Croatia, Djibouti, Dominica, Dominican Republic, Jordan, Kazakhstan, Kiribati, Kuwait, Kyrgyz Republic, Lao PDR, Lebanon, Lesotho, Liberia, Madagascar, Malaysia, Maldives, Mali, Mauritius, Mexico, Micronesia, Fed. Sts., Moldova, Mongolia, Montenegro, Grenada, Guyana, India, Iraq, Jamaica, Morocco, North Macedonia, Myanmar, Mozambique, Niger, Nigeria, Nicaragua, Oman, Pakistan, Peru, Philippines, Palau, Papua New Guinea, Poland, Qatar, Romania, Russian Federation, Rwanda, El Salvador, Angola, Argentina, Azerbaijan, Bahamas, The, Bahrain, Bangladesh, Barbados, Belarus, Belize, Benin, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Gabon, Georgia, Ghana, Guinea-Bissau, Equatorial Guinea, Namibia, Nepal, Panama, Paraguay, Senegal, Eswatini, Bolivia, Bhutan, Afghanistan, MWI, SRB, SYC, SLE, SLB, SOM, ZAF, SSD, LKA, LCA, VCT, SDN, SUR, TJK, TZA, THA, TLS, TGO, TON, TTO, TUN, TUR, UGA, UKR, ARE, URY, STP, SYR, TCD, UZB, VNM, VUT, WSM, XKX, YEM, ZMB, ZWE, ARM, CHN, DZA, IRN, KEN, KHM, LBY, MRT, PSE, SAU, ALB, CIV, CMR, COG, CRI, ECU, GIN, GMB, GTM, HND, HTI, IDN, BIH, BWA, BRA, BGR, BFA, BDI, CPV, CAF, CHL, COL, COM, COD, HRV, DJI, DMA, DOM, JOR, KAZ, KIR, KWT, KGZ, LAO, LBN, LSO, LBR, MDG, MYS, MDV, MLI, MUS, MEX, FSM, MDA, MNG, MNE, GRD, GUY, IND, IRQ, JAM, MAR, MKD, MMR, MOZ, NER, NGA, NIC, OMN, PAK, PER, PHL, PLW, PNG, POL, QAT, ROU, RUS, RWA, SLV, AGO, ARG, AZE, BHS, BHR, BGD, BRB, BLR, BLZ, BEN, EGY, ERI, ETH, FJI, GAB, GEO, GHA, GNB, GNQ, NAM, NPL, PAN, PRY, SEN, SWZ, BOL, BTN, AFG
#> 5                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           Madagascar, Malawi, Bolivia, Botswana, Brazil, Burkina Faso, Cabo Verde, Cameroon, Central African Republic, Chad, Chile, Colombia, Comoros, Congo, Dem. Rep., Congo, Rep., Costa Rica, Côte d’Ivoire, Croatia, Djibouti, Kiribati, Kyrgyz Republic, Lao PDR, Lesotho, Liberia, Mali, Mauritania, Mauritius, Moldova, Mongolia, Tajikistan, Tanzania, Thailand, Timor-Leste, Togo, Tunisia, Türkiye, Uganda, Uruguay, Uzbekistan, Vanuatu, Vietnam, Zambia, Zimbabwe, Albania, Angola, Argentina, Armenia, Bangladesh, Belarus, Benin, Montenegro, Morocco, Mozambique, Namibia, Nicaragua, Niger, Nigeria, China, Dominican Republic, Ecuador, Egypt, Arab Rep., El Salvador, Bhutan, Pakistan, West Bank and Gaza, Panama, Paraguay, Peru, Philippines, Romania, Rwanda, São Tomé and Príncipe, Senegal, Serbia, Seychelles, Sierra Leone, Bulgaria, Burundi, Kenya, Somalia, Federal Republic of, South Africa, South Sudan, Sri Lanka, St. Lucia, Eswatini, Ethiopia, Fiji, Gabon, Gambia, The, Georgia, Ghana, Grenada, Guatemala, Guinea, Guinea-Bissau, Haiti, Honduras, India, Indonesia, Kazakhstan, Sudan, Suriname, Syrian Arab Republic, Iran, Islamic Rep., Jamaica, Iraq, Malaysia, Barbados, Belize, Lebanon, Equatorial Guinea, Russian Federation, Nepal, MDG, MWI, BOL, BWA, BRA, BFA, CPV, CMR, CAF, TCD, CHL, COL, COM, COD, COG, CRI, CIV, HRV, DJI, KIR, KGZ, LAO, LSO, LBR, MLI, MRT, MUS, MDA, MNG, TJK, TZA, THA, TLS, TGO, TUN, TUR, UGA, URY, UZB, VUT, VNM, ZMB, ZWE, ALB, AGO, ARG, ARM, BGD, BLR, BEN, MNE, MAR, MOZ, NAM, NIC, NER, NGA, CHN, DOM, ECU, EGY, SLV, BTN, PAK, PSE, PAN, PRY, PER, PHL, ROU, RWA, STP, SEN, SRB, SYC, SLE, BGR, BDI, KEN, SOM, ZAF, SSD, LKA, LCA, SWZ, ETH, FJI, GAB, GMB, GEO, GHA, GRD, GTM, GIN, GNB, HTI, HND, IND, IDN, KAZ, SDN, SUR, SYR, IRN, JAM, IRQ, MYS, BRB, BLZ, LBN, GNQ, RUS, NPL
#> 6                                                  Madagascar, Malawi, Serbia, Seychelles, Sierra Leone, Solomon Islands, Somalia, Federal Republic of, South Africa, South Sudan, Sri Lanka, St. Lucia, St. Vincent and the Grenadines, Sudan, Suriname, Tajikistan, Tanzania, Thailand, Timor-Leste, Togo, Tonga, Trinidad and Tobago, Tunisia, Türkiye, Uganda, Ukraine, United Arab Emirates, Uruguay, São Tomé and Príncipe, Syrian Arab Republic, Chad, Uzbekistan, Vietnam, Vanuatu, Samoa, Kosovo, Yemen, Rep., Zambia, Zimbabwe, Armenia, China, Algeria, Iran, Islamic Rep., Kenya, Cambodia, Libya, Mauritania, West Bank and Gaza, Saudi Arabia, Albania, Côte d’Ivoire, Cameroon, Congo, Rep., Costa Rica, Ecuador, Guinea, Gambia, The, Guatemala, Honduras, Haiti, Indonesia, Maldives, Bosnia and Herzegovina, Botswana, Brazil, Bulgaria, Burkina Faso, Burundi, Cabo Verde, Central African Republic, Chile, Colombia, Comoros, Congo, Dem. Rep., Croatia, Djibouti, Dominica, Dominican Republic, Jamaica, Jordan, Kazakhstan, Kiribati, Kuwait, Kyrgyz Republic, Lao PDR, Lebanon, Lesotho, Liberia, Malaysia, Mali, Mauritius, Mexico, Micronesia, Fed. Sts., Moldova, Mongolia, Montenegro, Grenada, Guyana, India, Iraq, Morocco, North Macedonia, Myanmar, Mozambique, Niger, Nigeria, Nicaragua, Oman, Pakistan, Peru, Philippines, Palau, Papua New Guinea, Poland, Qatar, Romania, Russian Federation, Rwanda, El Salvador, Angola, Argentina, Azerbaijan, Bahamas, The, Bahrain, Bangladesh, Barbados, Belarus, Belize, Benin, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Gabon, Georgia, Ghana, Guinea-Bissau, Equatorial Guinea, Namibia, Nepal, Panama, Paraguay, Senegal, Eswatini, Bolivia, Bhutan, Afghanistan, MDG, MWI, SRB, SYC, SLE, SLB, SOM, ZAF, SSD, LKA, LCA, VCT, SDN, SUR, TJK, TZA, THA, TLS, TGO, TON, TTO, TUN, TUR, UGA, UKR, ARE, URY, STP, SYR, TCD, UZB, VNM, VUT, WSM, XKX, YEM, ZMB, ZWE, ARM, CHN, DZA, IRN, KEN, KHM, LBY, MRT, PSE, SAU, ALB, CIV, CMR, COG, CRI, ECU, GIN, GMB, GTM, HND, HTI, IDN, MDV, BIH, BWA, BRA, BGR, BFA, BDI, CPV, CAF, CHL, COL, COM, COD, HRV, DJI, DMA, DOM, JAM, JOR, KAZ, KIR, KWT, KGZ, LAO, LBN, LSO, LBR, MYS, MLI, MUS, MEX, FSM, MDA, MNG, MNE, GRD, GUY, IND, IRQ, MAR, MKD, MMR, MOZ, NER, NGA, NIC, OMN, PAK, PER, PHL, PLW, PNG, POL, QAT, ROU, RUS, RWA, SLV, AGO, ARG, AZE, BHS, BHR, BGD, BRB, BLR, BLZ, BEN, EGY, ERI, ETH, FJI, GAB, GEO, GHA, GNB, GNQ, NAM, NPL, PAN, PRY, SEN, SWZ, BOL, BTN, AFG
#> 7  Madagascar, Malawi, Malaysia, Senegal, Serbia, Seychelles, Sierra Leone, Solomon Islands, Somalia, Federal Republic of, South Africa, South Sudan, Sri Lanka, St. Lucia, St. Vincent and the Grenadines, Sudan, Suriname, Syrian Arab Republic, Tajikistan, Tanzania, Thailand, Timor-Leste, Togo, Tonga, Trinidad and Tobago, Tunisia, Türkiye, Tuvalu, Uganda, Ukraine, United Arab Emirates, Uruguay, Uzbekistan, Chad, Vietnam, Vanuatu, Samoa, Kosovo, Yemen, Rep., Zambia, Zimbabwe, Armenia, China, Algeria, Iran, Islamic Rep., Kenya, Cambodia, Libya, Mauritania, West Bank and Gaza, Saudi Arabia, Albania, Côte d’Ivoire, Cameroon, Congo, Rep., Costa Rica, Ecuador, Guinea, Gambia, The, Guatemala, Honduras, Haiti, Indonesia, Maldives, Bolivia, Bosnia and Herzegovina, Botswana, Brazil, Bulgaria, Burkina Faso, Burundi, Cabo Verde, Central African Republic, Chile, Colombia, Comoros, Congo, Dem. Rep., Croatia, Djibouti, Dominica, Dominican Republic, Jamaica, Jordan, Kazakhstan, Kiribati, Kuwait, Kyrgyz Republic, Lao PDR, Lebanon, Lesotho, Liberia, Mali, Marshall Islands, Mauritius, Mexico, Micronesia, Fed. Sts., Moldova, Mongolia, Montenegro, Guyana, India, Iraq, Morocco, North Macedonia, Myanmar, Mozambique, Niger, Nigeria, Nicaragua, Oman, Pakistan, Peru, Philippines, Palau, Papua New Guinea, Poland, Qatar, Romania, Russian Federation, Rwanda, El Salvador, São Tomé and Príncipe, Angola, Argentina, Azerbaijan, Bahamas, The, Bahrain, Bangladesh, Barbados, Belarus, Belize, Benin, Bhutan, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Gabon, Georgia, Ghana, Guinea-Bissau, Equatorial Guinea, Grenada, Namibia, Nauru, Nepal, Panama, Paraguay, Eswatini, Afghanistan, MDG, MWI, MYS, SEN, SRB, SYC, SLE, SLB, SOM, ZAF, SSD, LKA, LCA, VCT, SDN, SUR, SYR, TJK, TZA, THA, TLS, TGO, TON, TTO, TUN, TUR, TUV, UGA, UKR, ARE, URY, UZB, TCD, VNM, VUT, WSM, XKX, YEM, ZMB, ZWE, ARM, CHN, DZA, IRN, KEN, KHM, LBY, MRT, PSE, SAU, ALB, CIV, CMR, COG, CRI, ECU, GIN, GMB, GTM, HND, HTI, IDN, MDV, BOL, BIH, BWA, BRA, BGR, BFA, BDI, CPV, CAF, CHL, COL, COM, COD, HRV, DJI, DMA, DOM, JAM, JOR, KAZ, KIR, KWT, KGZ, LAO, LBN, LSO, LBR, MLI, MHL, MUS, MEX, FSM, MDA, MNG, MNE, GUY, IND, IRQ, MAR, MKD, MMR, MOZ, NER, NGA, NIC, OMN, PAK, PER, PHL, PLW, PNG, POL, QAT, ROU, RUS, RWA, SLV, STP, AGO, ARG, AZE, BHS, BHR, BGD, BRB, BLR, BLZ, BEN, BTN, EGY, ERI, ETH, FJI, GAB, GEO, GHA, GNB, GNQ, GRD, NAM, NRU, NPL, PAN, PRY, SWZ, AFG
#> 8                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  São Tomé and Príncipe, Syrian Arab Republic, Trinidad and Tobago, Tunisia, Ukraine, Uruguay, Uzbekistan, Vanuatu, China, Saudi Arabia, Timor-Leste, Honduras, Maldives, Lebanon, Malaysia, Mexico, Mongolia, Iraq, Jamaica, Kazakhstan, Kuwait, Sri Lanka, Nigeria, Nicaragua, Oman, Peru, Papua New Guinea, Qatar, Russian Federation, Solomon Islands, El Salvador, Argentina, Azerbaijan, Bahamas, The, Bahrain, Belarus, Belize, Eritrea, Fiji, Sierra Leone, Paraguay, STP, SYR, TTO, TUN, UKR, URY, UZB, VUT, CHN, SAU, TLS, HND, MDV, LBN, MYS, MEX, MNG, IRQ, JAM, KAZ, KWT, LKA, NGA, NIC, OMN, PER, PNG, QAT, RUS, SLB, SLV, ARG, AZE, BHS, BHR, BLR, BLZ, ERI, FJI, SLE, PRY
#> 9                                                  Madagascar, Malawi, Malaysia, Serbia, Seychelles, Sierra Leone, Solomon Islands, Somalia, Federal Republic of, South Africa, South Sudan, Sri Lanka, St. Lucia, St. Vincent and the Grenadines, Sudan, Suriname, Syrian Arab Republic, Tajikistan, Tanzania, Thailand, Timor-Leste, Togo, Tonga, Trinidad and Tobago, Tunisia, Türkiye, Uganda, Ukraine, United Arab Emirates, Uruguay, Uzbekistan, São Tomé and Príncipe, Chad, Vietnam, Vanuatu, Samoa, Kosovo, Yemen, Rep., Zambia, Zimbabwe, Armenia, China, Algeria, Iran, Islamic Rep., Kenya, Cambodia, Libya, Mauritania, West Bank and Gaza, Saudi Arabia, Albania, Côte d’Ivoire, Cameroon, Congo, Rep., Costa Rica, Ecuador, Guinea, Gambia, The, Guatemala, Honduras, Haiti, Indonesia, Maldives, Bolivia, Bosnia and Herzegovina, Botswana, Brazil, Bulgaria, Burkina Faso, Burundi, Cabo Verde, Central African Republic, Chile, Colombia, Comoros, Congo, Dem. Rep., Croatia, Djibouti, Dominica, Dominican Republic, Jamaica, Jordan, Kazakhstan, Kiribati, Kuwait, Kyrgyz Republic, Lao PDR, Lebanon, Lesotho, Liberia, Mali, Mauritius, Mexico, Micronesia, Fed. Sts., Moldova, Mongolia, Montenegro, Grenada, Guyana, India, Iraq, Morocco, North Macedonia, Myanmar, Mozambique, Niger, Nigeria, Nicaragua, Oman, Pakistan, Peru, Philippines, Palau, Papua New Guinea, Poland, Qatar, Romania, Russian Federation, Rwanda, El Salvador, Angola, Argentina, Azerbaijan, Bahamas, The, Bahrain, Bangladesh, Barbados, Belarus, Belize, Benin, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Gabon, Georgia, Ghana, Guinea-Bissau, Equatorial Guinea, Namibia, Nepal, Panama, Paraguay, Senegal, Eswatini, Bhutan, Afghanistan, MDG, MWI, MYS, SRB, SYC, SLE, SLB, SOM, ZAF, SSD, LKA, LCA, VCT, SDN, SUR, SYR, TJK, TZA, THA, TLS, TGO, TON, TTO, TUN, TUR, UGA, UKR, ARE, URY, UZB, STP, TCD, VNM, VUT, WSM, XKX, YEM, ZMB, ZWE, ARM, CHN, DZA, IRN, KEN, KHM, LBY, MRT, PSE, SAU, ALB, CIV, CMR, COG, CRI, ECU, GIN, GMB, GTM, HND, HTI, IDN, MDV, BOL, BIH, BWA, BRA, BGR, BFA, BDI, CPV, CAF, CHL, COL, COM, COD, HRV, DJI, DMA, DOM, JAM, JOR, KAZ, KIR, KWT, KGZ, LAO, LBN, LSO, LBR, MLI, MUS, MEX, FSM, MDA, MNG, MNE, GRD, GUY, IND, IRQ, MAR, MKD, MMR, MOZ, NER, NGA, NIC, OMN, PAK, PER, PHL, PLW, PNG, POL, QAT, ROU, RUS, RWA, SLV, AGO, ARG, AZE, BHS, BHR, BGD, BRB, BLR, BLZ, BEN, EGY, ERI, ETH, FJI, GAB, GEO, GHA, GNB, GNQ, NAM, NPL, PAN, PRY, SEN, SWZ, BTN, AFG
#> 10                                                                 Malawi, Malaysia, Serbia, Seychelles, Sierra Leone, Solomon Islands, Somalia, Federal Republic of, South Africa, South Sudan, Sri Lanka, St. Lucia, St. Vincent and the Grenadines, Sudan, Suriname, Syrian Arab Republic, Tajikistan, Tanzania, Thailand, Timor-Leste, Togo, Tonga, Trinidad and Tobago, Tunisia, Türkiye, Uganda, Ukraine, United Arab Emirates, Uruguay, Uzbekistan, São Tomé and Príncipe, Chad, Vietnam, Vanuatu, Samoa, Kosovo, Yemen, Rep., Zambia, Zimbabwe, Armenia, China, Algeria, Iran, Islamic Rep., Kenya, Cambodia, Libya, Mauritania, West Bank and Gaza, Saudi Arabia, Albania, Côte d’Ivoire, Cameroon, Congo, Rep., Costa Rica, Ecuador, Guinea, Gambia, The, Guatemala, Honduras, Haiti, Indonesia, Bosnia and Herzegovina, Botswana, Brazil, Bulgaria, Burkina Faso, Burundi, Cabo Verde, Central African Republic, Chile, Colombia, Comoros, Congo, Dem. Rep., Croatia, Djibouti, Dominica, Dominican Republic, Jordan, Kazakhstan, Kiribati, Kuwait, Kyrgyz Republic, Lao PDR, Lebanon, Lesotho, Liberia, Madagascar, Maldives, Mali, Mauritius, Mexico, Micronesia, Fed. Sts., Moldova, Mongolia, Montenegro, Grenada, Guyana, India, Iraq, Jamaica, Morocco, North Macedonia, Myanmar, Mozambique, Niger, Nigeria, Nicaragua, Oman, Pakistan, Peru, Philippines, Palau, Papua New Guinea, Poland, Qatar, Romania, Russian Federation, Rwanda, El Salvador, Angola, Azerbaijan, Bahamas, The, Bahrain, Bangladesh, Barbados, Belarus, Belize, Benin, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Gabon, Georgia, Ghana, Guinea-Bissau, Equatorial Guinea, Namibia, Nepal, Panama, Paraguay, Senegal, Eswatini, Bolivia, Bhutan, Afghanistan, MWI, MYS, SRB, SYC, SLE, SLB, SOM, ZAF, SSD, LKA, LCA, VCT, SDN, SUR, SYR, TJK, TZA, THA, TLS, TGO, TON, TTO, TUN, TUR, UGA, UKR, ARE, URY, UZB, STP, TCD, VNM, VUT, WSM, XKX, YEM, ZMB, ZWE, ARM, CHN, DZA, IRN, KEN, KHM, LBY, MRT, PSE, SAU, ALB, CIV, CMR, COG, CRI, ECU, GIN, GMB, GTM, HND, HTI, IDN, BIH, BWA, BRA, BGR, BFA, BDI, CPV, CAF, CHL, COL, COM, COD, HRV, DJI, DMA, DOM, JOR, KAZ, KIR, KWT, KGZ, LAO, LBN, LSO, LBR, MDG, MDV, MLI, MUS, MEX, FSM, MDA, MNG, MNE, GRD, GUY, IND, IRQ, JAM, MAR, MKD, MMR, MOZ, NER, NGA, NIC, OMN, PAK, PER, PHL, PLW, PNG, POL, QAT, ROU, RUS, RWA, SLV, AGO, AZE, BHS, BHR, BGD, BRB, BLR, BLZ, BEN, EGY, ERI, ETH, FJI, GAB, GEO, GHA, GNB, GNQ, NAM, NPL, PAN, PRY, SEN, SWZ, BOL, BTN, AFG
#> 11                                                 Malawi, Serbia, Seychelles, Sierra Leone, Solomon Islands, Somalia, Federal Republic of, South Africa, South Sudan, Sri Lanka, St. Lucia, St. Vincent and the Grenadines, Sudan, Suriname, Tajikistan, Tanzania, Thailand, Timor-Leste, Togo, Tonga, Trinidad and Tobago, Tunisia, Türkiye, Uganda, Ukraine, United Arab Emirates, Uruguay, São Tomé and Príncipe, Syrian Arab Republic, Chad, Uzbekistan, Vietnam, Vanuatu, Samoa, Kosovo, Yemen, Rep., Zambia, Zimbabwe, Armenia, China, Algeria, Iran, Islamic Rep., Kenya, Cambodia, Libya, Mauritania, West Bank and Gaza, Saudi Arabia, Albania, Côte d’Ivoire, Cameroon, Congo, Rep., Costa Rica, Ecuador, Guinea, Gambia, The, Guatemala, Honduras, Haiti, Indonesia, Bosnia and Herzegovina, Botswana, Brazil, Bulgaria, Burkina Faso, Burundi, Cabo Verde, Central African Republic, Chile, Colombia, Comoros, Congo, Dem. Rep., Croatia, Djibouti, Dominica, Dominican Republic, Jordan, Kazakhstan, Kiribati, Kuwait, Kyrgyz Republic, Lao PDR, Lebanon, Lesotho, Liberia, Madagascar, Malaysia, Maldives, Mali, Mauritius, Mexico, Micronesia, Fed. Sts., Moldova, Mongolia, Montenegro, Grenada, Guyana, India, Iraq, Jamaica, Morocco, North Macedonia, Myanmar, Mozambique, Niger, Nigeria, Nicaragua, Oman, Pakistan, Peru, Philippines, Palau, Papua New Guinea, Poland, Qatar, Romania, Russian Federation, Rwanda, El Salvador, Angola, Argentina, Azerbaijan, Bahamas, The, Bahrain, Bangladesh, Barbados, Belarus, Belize, Benin, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Gabon, Georgia, Ghana, Guinea-Bissau, Equatorial Guinea, Namibia, Nepal, Panama, Paraguay, Senegal, Eswatini, Bolivia, Bhutan, Afghanistan, MWI, SRB, SYC, SLE, SLB, SOM, ZAF, SSD, LKA, LCA, VCT, SDN, SUR, TJK, TZA, THA, TLS, TGO, TON, TTO, TUN, TUR, UGA, UKR, ARE, URY, STP, SYR, TCD, UZB, VNM, VUT, WSM, XKX, YEM, ZMB, ZWE, ARM, CHN, DZA, IRN, KEN, KHM, LBY, MRT, PSE, SAU, ALB, CIV, CMR, COG, CRI, ECU, GIN, GMB, GTM, HND, HTI, IDN, BIH, BWA, BRA, BGR, BFA, BDI, CPV, CAF, CHL, COL, COM, COD, HRV, DJI, DMA, DOM, JOR, KAZ, KIR, KWT, KGZ, LAO, LBN, LSO, LBR, MDG, MYS, MDV, MLI, MUS, MEX, FSM, MDA, MNG, MNE, GRD, GUY, IND, IRQ, JAM, MAR, MKD, MMR, MOZ, NER, NGA, NIC, OMN, PAK, PER, PHL, PLW, PNG, POL, QAT, ROU, RUS, RWA, SLV, AGO, ARG, AZE, BHS, BHR, BGD, BRB, BLR, BLZ, BEN, EGY, ERI, ETH, FJI, GAB, GEO, GHA, GNB, GNQ, NAM, NPL, PAN, PRY, SEN, SWZ, BOL, BTN, AFG
#> 12                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                Madagascar, Malawi, Tonga, Bolivia, Botswana, Brazil, Bulgaria, Burkina Faso, Cabo Verde, Cameroon, Central African Republic, Chad, Chile, China, Colombia, Comoros, Congo, Dem. Rep., Congo, Rep., Costa Rica, Côte d’Ivoire, Croatia, Djibouti, Kiribati, Marshall Islands, Kyrgyz Republic, Lao PDR, Lesotho, Liberia, Malaysia, Maldives, Mali, Mauritania, Mauritius, Mexico, Moldova, Mongolia, Tajikistan, Tanzania, Thailand, Togo, Tunisia, Türkiye, Uganda, Uruguay, Uzbekistan, Vietnam, Zambia, Zimbabwe, Albania, Angola, Argentina, Armenia, Bangladesh, Belarus, Benin, Kosovo, Montenegro, Morocco, Mozambique, Namibia, Nicaragua, Niger, Nigeria, North Macedonia, Dominican Republic, Ecuador, El Salvador, Bhutan, Pakistan, West Bank and Gaza, Panama, Paraguay, Peru, Philippines, Poland, Romania, Russian Federation, Rwanda, São Tomé and Príncipe, Senegal, Serbia, Seychelles, Sierra Leone, Kenya, Somalia, Federal Republic of, South Africa, South Sudan, Sri Lanka, St. Lucia, Eswatini, Ethiopia, Fiji, Gabon, Gambia, The, Georgia, Ghana, Grenada, Guatemala, Guinea, Guinea-Bissau, Haiti, Honduras, Indonesia, Kazakhstan, Sudan, Suriname, Iran, Islamic Rep., Jamaica, Iraq, Barbados, Belize, Syrian Arab Republic, Lebanon, Equatorial Guinea, India, Nepal, MDG, MWI, TON, BOL, BWA, BRA, BGR, BFA, CPV, CMR, CAF, TCD, CHL, CHN, COL, COM, COD, COG, CRI, CIV, HRV, DJI, KIR, MHL, KGZ, LAO, LSO, LBR, MYS, MDV, MLI, MRT, MUS, MEX, MDA, MNG, TJK, TZA, THA, TGO, TUN, TUR, UGA, URY, UZB, VNM, ZMB, ZWE, ALB, AGO, ARG, ARM, BGD, BLR, BEN, XKX, MNE, MAR, MOZ, NAM, NIC, NER, NGA, MKD, DOM, ECU, SLV, BTN, PAK, PSE, PAN, PRY, PER, PHL, POL, ROU, RUS, RWA, STP, SEN, SRB, SYC, SLE, KEN, SOM, ZAF, SSD, LKA, LCA, SWZ, ETH, FJI, GAB, GMB, GEO, GHA, GRD, GTM, GIN, GNB, HTI, HND, IDN, KAZ, SDN, SUR, IRN, JAM, IRQ, BRB, BLZ, SYR, LBN, GNQ, IND, NPL
#> 13                                                                                                                                                                                                                                                                                                                                   Madagascar, Malawi, Malaysia, Senegal, Serbia, Seychelles, Sierra Leone, Solomon Islands, Somalia, Federal Republic of, South Africa, Sri Lanka, Sudan, Tajikistan, Tanzania, Thailand, Timor-Leste, Togo, Tunisia, Türkiye, Uganda, Ukraine, Uruguay, Uzbekistan, Syrian Arab Republic, Chad, Vietnam, Vanuatu, Samoa, Kosovo, Yemen, Rep., Zambia, Zimbabwe, Armenia, China, Algeria, Iran, Islamic Rep., Kenya, Cambodia, Libya, Mauritania, West Bank and Gaza, Saudi Arabia, Albania, Côte d’Ivoire, Cameroon, Congo, Rep., Costa Rica, Ecuador, Guinea, Gambia, The, Guatemala, Honduras, Haiti, Indonesia, Maldives, Bolivia, Bosnia and Herzegovina, Botswana, Brazil, Bulgaria, Burkina Faso, Burundi, Cabo Verde, Central African Republic, Chile, Colombia, Comoros, Congo, Dem. Rep., Croatia, Djibouti, Dominican Republic, Kazakhstan, Kiribati, Kuwait, Kyrgyz Republic, Lebanon, Liberia, Mali, Marshall Islands, Mauritius, Mexico, Moldova, Mongolia, Montenegro, Lesotho, India, Iraq, Jamaica, Jordan, Morocco, North Macedonia, Myanmar, Mozambique, Niger, Nigeria, Nicaragua, Oman, Pakistan, Peru, Philippines, Poland, Qatar, Romania, Russian Federation, Rwanda, El Salvador, United Arab Emirates, Angola, Argentina, Azerbaijan, Bahamas, The, Bahrain, Bangladesh, Belarus, Belize, Benin, Bhutan, Egypt, Arab Rep., Eritrea, Ethiopia, Gabon, Georgia, Ghana, Guinea-Bissau, Equatorial Guinea, Namibia, Nepal, Panama, Paraguay, Eswatini, Afghanistan, MDG, MWI, MYS, SEN, SRB, SYC, SLE, SLB, SOM, ZAF, LKA, SDN, TJK, TZA, THA, TLS, TGO, TUN, TUR, UGA, UKR, URY, UZB, SYR, TCD, VNM, VUT, WSM, XKX, YEM, ZMB, ZWE, ARM, CHN, DZA, IRN, KEN, KHM, LBY, MRT, PSE, SAU, ALB, CIV, CMR, COG, CRI, ECU, GIN, GMB, GTM, HND, HTI, IDN, MDV, BOL, BIH, BWA, BRA, BGR, BFA, BDI, CPV, CAF, CHL, COL, COM, COD, HRV, DJI, DOM, KAZ, KIR, KWT, KGZ, LBN, LBR, MLI, MHL, MUS, MEX, MDA, MNG, MNE, LSO, IND, IRQ, JAM, JOR, MAR, MKD, MMR, MOZ, NER, NGA, NIC, OMN, PAK, PER, PHL, POL, QAT, ROU, RUS, RWA, SLV, ARE, AGO, ARG, AZE, BHS, BHR, BGD, BLR, BLZ, BEN, BTN, EGY, ERI, ETH, GAB, GEO, GHA, GNB, GNQ, NAM, NPL, PAN, PRY, SWZ, AFG
#> 14                                                Madagascar, Malawi, Malaysia, Senegal, Serbia, Seychelles, Sierra Leone, Solomon Islands, South Africa, South Sudan, Sri Lanka, St. Lucia, St. Vincent and the Grenadines, Sudan, Suriname, Tajikistan, Tanzania, Thailand, Timor-Leste, Togo, Tonga, Trinidad and Tobago, Tunisia, Türkiye, Tuvalu, Uganda, Ukraine, United Arab Emirates, Uruguay, Uzbekistan, Syrian Arab Republic, Chad, Vietnam, Vanuatu, Samoa, Kosovo, Yemen, Rep., Zambia, Zimbabwe, Armenia, China, Algeria, Iran, Islamic Rep., Kenya, Cambodia, Libya, Mauritania, West Bank and Gaza, Saudi Arabia, Albania, Côte d’Ivoire, Cameroon, Congo, Rep., Costa Rica, Ecuador, Guinea, Gambia, The, Guatemala, Honduras, Haiti, Indonesia, Maldives, Bolivia, Bosnia and Herzegovina, Botswana, Brazil, Bulgaria, Burkina Faso, Burundi, Cabo Verde, Central African Republic, Chile, Colombia, Comoros, Congo, Dem. Rep., Croatia, Djibouti, Dominica, Dominican Republic, Jamaica, Jordan, Kazakhstan, Kiribati, Kuwait, Kyrgyz Republic, Lao PDR, Lebanon, Lesotho, Liberia, Mali, Marshall Islands, Mauritius, Mexico, Micronesia, Fed. Sts., Moldova, Mongolia, Montenegro, Grenada, Guyana, India, Iraq, Morocco, North Macedonia, Myanmar, Mozambique, Niger, Nigeria, Nicaragua, Oman, Pakistan, Peru, Philippines, Palau, Papua New Guinea, Poland, Qatar, Romania, Russian Federation, Rwanda, El Salvador, São Tomé and Príncipe, Angola, Argentina, Azerbaijan, Bahamas, The, Bahrain, Bangladesh, Barbados, Belarus, Belize, Benin, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Gabon, Georgia, Ghana, Guinea-Bissau, Equatorial Guinea, Namibia, Nepal, Panama, Paraguay, Eswatini, Bhutan, Afghanistan, MDG, MWI, MYS, SEN, SRB, SYC, SLE, SLB, ZAF, SSD, LKA, LCA, VCT, SDN, SUR, TJK, TZA, THA, TLS, TGO, TON, TTO, TUN, TUR, TUV, UGA, UKR, ARE, URY, UZB, SYR, TCD, VNM, VUT, WSM, XKX, YEM, ZMB, ZWE, ARM, CHN, DZA, IRN, KEN, KHM, LBY, MRT, PSE, SAU, ALB, CIV, CMR, COG, CRI, ECU, GIN, GMB, GTM, HND, HTI, IDN, MDV, BOL, BIH, BWA, BRA, BGR, BFA, BDI, CPV, CAF, CHL, COL, COM, COD, HRV, DJI, DMA, DOM, JAM, JOR, KAZ, KIR, KWT, KGZ, LAO, LBN, LSO, LBR, MLI, MHL, MUS, MEX, FSM, MDA, MNG, MNE, GRD, GUY, IND, IRQ, MAR, MKD, MMR, MOZ, NER, NGA, NIC, OMN, PAK, PER, PHL, PLW, PNG, POL, QAT, ROU, RUS, RWA, SLV, STP, AGO, ARG, AZE, BHS, BHR, BGD, BRB, BLR, BLZ, BEN, EGY, ERI, ETH, FJI, GAB, GEO, GHA, GNB, GNQ, NAM, NPL, PAN, PRY, SWZ, BTN, AFG
#> 15                                                 Malawi, Serbia, Seychelles, Sierra Leone, Solomon Islands, Somalia, Federal Republic of, South Africa, South Sudan, Sri Lanka, St. Lucia, St. Vincent and the Grenadines, Sudan, Suriname, Tajikistan, Tanzania, Thailand, Timor-Leste, Togo, Tonga, Trinidad and Tobago, Tunisia, Türkiye, Uganda, Ukraine, United Arab Emirates, Uruguay, Uzbekistan, São Tomé and Príncipe, Syrian Arab Republic, Chad, Vietnam, Vanuatu, Samoa, Kosovo, Yemen, Rep., Zambia, Zimbabwe, Armenia, China, Algeria, Iran, Islamic Rep., Kenya, Cambodia, Libya, Mauritania, West Bank and Gaza, Saudi Arabia, Albania, Côte d’Ivoire, Cameroon, Congo, Rep., Costa Rica, Ecuador, Guinea, Gambia, The, Guatemala, Honduras, Haiti, Indonesia, Bosnia and Herzegovina, Botswana, Brazil, Bulgaria, Burkina Faso, Burundi, Cabo Verde, Central African Republic, Chile, Colombia, Comoros, Congo, Dem. Rep., Croatia, Djibouti, Dominica, Dominican Republic, Jordan, Kazakhstan, Kiribati, Kuwait, Kyrgyz Republic, Lao PDR, Lebanon, Lesotho, Liberia, Madagascar, Malaysia, Maldives, Mali, Mauritius, Mexico, Micronesia, Fed. Sts., Moldova, Mongolia, Montenegro, Grenada, Guyana, India, Iraq, Jamaica, Morocco, North Macedonia, Myanmar, Mozambique, Niger, Nigeria, Nicaragua, Oman, Pakistan, Peru, Philippines, Palau, Papua New Guinea, Poland, Qatar, Romania, Russian Federation, Rwanda, El Salvador, Angola, Argentina, Azerbaijan, Bahamas, The, Bahrain, Bangladesh, Barbados, Belarus, Belize, Benin, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Gabon, Georgia, Ghana, Guinea-Bissau, Equatorial Guinea, Namibia, Nepal, Panama, Paraguay, Senegal, Eswatini, Bolivia, Bhutan, Afghanistan, MWI, SRB, SYC, SLE, SLB, SOM, ZAF, SSD, LKA, LCA, VCT, SDN, SUR, TJK, TZA, THA, TLS, TGO, TON, TTO, TUN, TUR, UGA, UKR, ARE, URY, UZB, STP, SYR, TCD, VNM, VUT, WSM, XKX, YEM, ZMB, ZWE, ARM, CHN, DZA, IRN, KEN, KHM, LBY, MRT, PSE, SAU, ALB, CIV, CMR, COG, CRI, ECU, GIN, GMB, GTM, HND, HTI, IDN, BIH, BWA, BRA, BGR, BFA, BDI, CPV, CAF, CHL, COL, COM, COD, HRV, DJI, DMA, DOM, JOR, KAZ, KIR, KWT, KGZ, LAO, LBN, LSO, LBR, MDG, MYS, MDV, MLI, MUS, MEX, FSM, MDA, MNG, MNE, GRD, GUY, IND, IRQ, JAM, MAR, MKD, MMR, MOZ, NER, NGA, NIC, OMN, PAK, PER, PHL, PLW, PNG, POL, QAT, ROU, RUS, RWA, SLV, AGO, ARG, AZE, BHS, BHR, BGD, BRB, BLR, BLZ, BEN, EGY, ERI, ETH, FJI, GAB, GEO, GHA, GNB, GNQ, NAM, NPL, PAN, PRY, SEN, SWZ, BOL, BTN, AFG
#> 16                                                                                                                                                                                                                                                                                                                                   Madagascar, Malawi, Malaysia, Senegal, Serbia, Seychelles, Sierra Leone, Solomon Islands, Somalia, Federal Republic of, South Africa, Sri Lanka, Sudan, Tajikistan, Tanzania, Thailand, Timor-Leste, Togo, Tunisia, Türkiye, Uganda, Ukraine, Uruguay, Uzbekistan, Syrian Arab Republic, Chad, Vietnam, Vanuatu, Samoa, Kosovo, Yemen, Rep., Zambia, Zimbabwe, Armenia, China, Algeria, Iran, Islamic Rep., Kenya, Cambodia, Libya, Mauritania, West Bank and Gaza, Saudi Arabia, Albania, Côte d’Ivoire, Cameroon, Congo, Rep., Costa Rica, Ecuador, Guinea, Gambia, The, Guatemala, Honduras, Haiti, Indonesia, Maldives, Bolivia, Bosnia and Herzegovina, Botswana, Brazil, Bulgaria, Burkina Faso, Burundi, Cabo Verde, Central African Republic, Chile, Colombia, Comoros, Congo, Dem. Rep., Croatia, Djibouti, Dominican Republic, Kazakhstan, Kiribati, Kuwait, Kyrgyz Republic, Lebanon, Liberia, Mali, Marshall Islands, Mauritius, Mexico, Moldova, Mongolia, Montenegro, Lesotho, India, Iraq, Jamaica, Jordan, Morocco, North Macedonia, Myanmar, Mozambique, Niger, Nigeria, Nicaragua, Oman, Pakistan, Peru, Philippines, Poland, Qatar, Romania, Russian Federation, Rwanda, El Salvador, United Arab Emirates, Angola, Argentina, Azerbaijan, Bahamas, The, Bahrain, Bangladesh, Belarus, Belize, Benin, Bhutan, Egypt, Arab Rep., Eritrea, Ethiopia, Gabon, Georgia, Ghana, Guinea-Bissau, Equatorial Guinea, Namibia, Nepal, Panama, Paraguay, Eswatini, Afghanistan, MDG, MWI, MYS, SEN, SRB, SYC, SLE, SLB, SOM, ZAF, LKA, SDN, TJK, TZA, THA, TLS, TGO, TUN, TUR, UGA, UKR, URY, UZB, SYR, TCD, VNM, VUT, WSM, XKX, YEM, ZMB, ZWE, ARM, CHN, DZA, IRN, KEN, KHM, LBY, MRT, PSE, SAU, ALB, CIV, CMR, COG, CRI, ECU, GIN, GMB, GTM, HND, HTI, IDN, MDV, BOL, BIH, BWA, BRA, BGR, BFA, BDI, CPV, CAF, CHL, COL, COM, COD, HRV, DJI, DOM, KAZ, KIR, KWT, KGZ, LBN, LBR, MLI, MHL, MUS, MEX, MDA, MNG, MNE, LSO, IND, IRQ, JAM, JOR, MAR, MKD, MMR, MOZ, NER, NGA, NIC, OMN, PAK, PER, PHL, POL, QAT, ROU, RUS, RWA, SLV, ARE, AGO, ARG, AZE, BHS, BHR, BGD, BLR, BLZ, BEN, BTN, EGY, ERI, ETH, GAB, GEO, GHA, GNB, GNQ, NAM, NPL, PAN, PRY, SWZ, AFG
#> 17                                                                                                                                                                                                                                                                                                                       Madagascar, Malawi, Malaysia, Senegal, Serbia, Seychelles, Sierra Leone, Solomon Islands, Somalia, Federal Republic of, South Africa, Sri Lanka, Sudan, Tajikistan, Tanzania, Thailand, Timor-Leste, Togo, Tunisia, Türkiye, Uganda, Ukraine, Uruguay, Uzbekistan, Syrian Arab Republic, Chad, Vietnam, Vanuatu, Samoa, Kosovo, Yemen, Rep., Zambia, Zimbabwe, Armenia, China, Algeria, Iran, Islamic Rep., Kenya, Cambodia, Libya, Mauritania, West Bank and Gaza, Saudi Arabia, Albania, Côte d’Ivoire, Cameroon, Congo, Rep., Costa Rica, Ecuador, Guinea, Gambia, The, Guatemala, Honduras, Haiti, Indonesia, Maldives, Bolivia, Bosnia and Herzegovina, Botswana, Brazil, Bulgaria, Burkina Faso, Burundi, Cabo Verde, Central African Republic, Chile, Colombia, Comoros, Congo, Dem. Rep., Croatia, Djibouti, Dominican Republic, Kazakhstan, Kiribati, Kuwait, Kyrgyz Republic, Lebanon, Liberia, Mali, Marshall Islands, Mauritius, Mexico, Moldova, Mongolia, Montenegro, Lesotho, India, Iraq, Jamaica, Jordan, Morocco, North Macedonia, Myanmar, Mozambique, Niger, Nigeria, Nicaragua, Oman, Pakistan, Peru, Philippines, Poland, Qatar, Romania, Russian Federation, Rwanda, El Salvador, United Arab Emirates, Angola, Argentina, Azerbaijan, Bahamas, The, Bahrain, Bangladesh, Belarus, Belize, Benin, Bhutan, Egypt, Arab Rep., Eritrea, Ethiopia, Gabon, Georgia, Ghana, Guinea-Bissau, Equatorial Guinea, Namibia, Nauru, Nepal, Panama, Paraguay, Eswatini, Afghanistan, MDG, MWI, MYS, SEN, SRB, SYC, SLE, SLB, SOM, ZAF, LKA, SDN, TJK, TZA, THA, TLS, TGO, TUN, TUR, UGA, UKR, URY, UZB, SYR, TCD, VNM, VUT, WSM, XKX, YEM, ZMB, ZWE, ARM, CHN, DZA, IRN, KEN, KHM, LBY, MRT, PSE, SAU, ALB, CIV, CMR, COG, CRI, ECU, GIN, GMB, GTM, HND, HTI, IDN, MDV, BOL, BIH, BWA, BRA, BGR, BFA, BDI, CPV, CAF, CHL, COL, COM, COD, HRV, DJI, DOM, KAZ, KIR, KWT, KGZ, LBN, LBR, MLI, MHL, MUS, MEX, MDA, MNG, MNE, LSO, IND, IRQ, JAM, JOR, MAR, MKD, MMR, MOZ, NER, NGA, NIC, OMN, PAK, PER, PHL, POL, QAT, ROU, RUS, RWA, SLV, ARE, AGO, ARG, AZE, BHS, BHR, BGD, BLR, BLZ, BEN, BTN, EGY, ERI, ETH, GAB, GEO, GHA, GNB, GNQ, NAM, NRU, NPL, PAN, PRY, SWZ, AFG
#> 18                                                Madagascar, Malawi, Malaysia, Senegal, Serbia, Seychelles, Sierra Leone, Solomon Islands, South Africa, South Sudan, Sri Lanka, St. Lucia, St. Vincent and the Grenadines, Sudan, Suriname, Tajikistan, Tanzania, Thailand, Timor-Leste, Togo, Tonga, Trinidad and Tobago, Tunisia, Türkiye, Tuvalu, Uganda, Ukraine, United Arab Emirates, Uruguay, Uzbekistan, Syrian Arab Republic, Chad, Vietnam, Vanuatu, Samoa, Kosovo, Yemen, Rep., Zambia, Zimbabwe, Armenia, China, Algeria, Iran, Islamic Rep., Kenya, Cambodia, Libya, Mauritania, West Bank and Gaza, Saudi Arabia, Albania, Côte d’Ivoire, Cameroon, Congo, Rep., Costa Rica, Ecuador, Guinea, Gambia, The, Guatemala, Honduras, Haiti, Indonesia, Maldives, Bolivia, Bosnia and Herzegovina, Botswana, Brazil, Bulgaria, Burkina Faso, Burundi, Cabo Verde, Central African Republic, Chile, Colombia, Comoros, Congo, Dem. Rep., Croatia, Djibouti, Dominica, Dominican Republic, Jamaica, Jordan, Kazakhstan, Kiribati, Kuwait, Kyrgyz Republic, Lao PDR, Lebanon, Lesotho, Liberia, Mali, Marshall Islands, Mauritius, Mexico, Micronesia, Fed. Sts., Moldova, Mongolia, Montenegro, Grenada, Guyana, India, Iraq, Morocco, North Macedonia, Myanmar, Mozambique, Niger, Nigeria, Nicaragua, Oman, Pakistan, Peru, Philippines, Palau, Papua New Guinea, Poland, Qatar, Romania, Russian Federation, Rwanda, El Salvador, São Tomé and Príncipe, Angola, Argentina, Azerbaijan, Bahamas, The, Bahrain, Bangladesh, Barbados, Belarus, Belize, Benin, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Gabon, Georgia, Ghana, Guinea-Bissau, Equatorial Guinea, Namibia, Nepal, Panama, Paraguay, Eswatini, Bhutan, Afghanistan, MDG, MWI, MYS, SEN, SRB, SYC, SLE, SLB, ZAF, SSD, LKA, LCA, VCT, SDN, SUR, TJK, TZA, THA, TLS, TGO, TON, TTO, TUN, TUR, TUV, UGA, UKR, ARE, URY, UZB, SYR, TCD, VNM, VUT, WSM, XKX, YEM, ZMB, ZWE, ARM, CHN, DZA, IRN, KEN, KHM, LBY, MRT, PSE, SAU, ALB, CIV, CMR, COG, CRI, ECU, GIN, GMB, GTM, HND, HTI, IDN, MDV, BOL, BIH, BWA, BRA, BGR, BFA, BDI, CPV, CAF, CHL, COL, COM, COD, HRV, DJI, DMA, DOM, JAM, JOR, KAZ, KIR, KWT, KGZ, LAO, LBN, LSO, LBR, MLI, MHL, MUS, MEX, FSM, MDA, MNG, MNE, GRD, GUY, IND, IRQ, MAR, MKD, MMR, MOZ, NER, NGA, NIC, OMN, PAK, PER, PHL, PLW, PNG, POL, QAT, ROU, RUS, RWA, SLV, STP, AGO, ARG, AZE, BHS, BHR, BGD, BRB, BLR, BLZ, BEN, EGY, ERI, ETH, FJI, GAB, GEO, GHA, GNB, GNQ, NAM, NPL, PAN, PRY, SWZ, BTN, AFG
#> 19 Madagascar, Malawi, Serbia, Seychelles, Sierra Leone, Solomon Islands, South Africa, South Sudan, Sri Lanka, Sudan, Suriname, Tajikistan, Tanzania, Thailand, Timor-Leste, Togo, Tonga, Trinidad and Tobago, Tunisia, Türkiye, Uganda, Ukraine, Uruguay, São Tomé and Príncipe, Syrian Arab Republic, Chad, Uzbekistan, Vietnam, Vanuatu, Samoa, Kosovo, Yemen, Rep., Zambia, Zimbabwe, Armenia, China, Iran, Islamic Rep., Kenya, Cambodia, Mauritania, West Bank and Gaza, Saudi Arabia, Albania, Côte d’Ivoire, Congo, Rep., Costa Rica, Ecuador, Guinea, Guatemala, Honduras, Haiti, Indonesia, Maldives, Bosnia and Herzegovina, Botswana, Brazil, Bulgaria, Burkina Faso, Burundi, Cabo Verde, Chile, Croatia, Dominican Republic, Jamaica, Jordan, Kazakhstan, Kuwait, Kyrgyz Republic, Lebanon, Lesotho, Malaysia, Mali, Mauritius, Mexico, Micronesia, Fed. Sts., Moldova, Mongolia, Montenegro, Guyana, India, Iraq, Morocco, North Macedonia, Mozambique, Niger, Nigeria, Nicaragua, Oman, Pakistan, Peru, Philippines, Papua New Guinea, Poland, Qatar, Romania, Russian Federation, Rwanda, El Salvador, Angola, Argentina, Azerbaijan, Bahamas, The, Bahrain, Bangladesh, Belarus, Belize, Benin, Egypt, Arab Rep., Eritrea, Fiji, Gabon, Georgia, Ghana, Guinea-Bissau, Equatorial Guinea, Namibia, Nepal, Panama, Paraguay, Eswatini, Bolivia, Bhutan, Afghanistan, Cameroon, Somalia, Federal Republic of, St. Lucia, St. Vincent and the Grenadines, United Arab Emirates, Algeria, Libya, Gambia, The, Central African Republic, Colombia, Comoros, Congo, Dem. Rep., Djibouti, Dominica, Kiribati, Lao PDR, Liberia, Grenada, Myanmar, Palau, Barbados, Ethiopia, Senegal, Marshall Islands, Tuvalu, Nauru, MDG, MWI, SRB, SYC, SLE, SLB, ZAF, SSD, LKA, SDN, SUR, TJK, TZA, THA, TLS, TGO, TON, TTO, TUN, TUR, UGA, UKR, URY, STP, SYR, TCD, UZB, VNM, VUT, WSM, XKX, YEM, ZMB, ZWE, ARM, CHN, IRN, KEN, KHM, MRT, PSE, SAU, ALB, CIV, COG, CRI, ECU, GIN, GTM, HND, HTI, IDN, MDV, BIH, BWA, BRA, BGR, BFA, BDI, CPV, CHL, HRV, DOM, JAM, JOR, KAZ, KWT, KGZ, LBN, LSO, MYS, MLI, MUS, MEX, FSM, MDA, MNG, MNE, GUY, IND, IRQ, MAR, MKD, MOZ, NER, NGA, NIC, OMN, PAK, PER, PHL, PNG, POL, QAT, ROU, RUS, RWA, SLV, AGO, ARG, AZE, BHS, BHR, BGD, BLR, BLZ, BEN, EGY, ERI, FJI, GAB, GEO, GHA, GNB, GNQ, NAM, NPL, PAN, PRY, SWZ, BOL, BTN, AFG, CMR, SOM, LCA, VCT, ARE, DZA, LBY, GMB, CAF, COL, COM, COD, DJI, DMA, KIR, LAO, LBR, GRD, MMR, PLW, BRB, ETH, SEN, MHL, TUV, NRU
#> 20                                                Madagascar, Malawi, Malaysia, Senegal, Serbia, Seychelles, Sierra Leone, Solomon Islands, South Africa, South Sudan, Sri Lanka, St. Lucia, St. Vincent and the Grenadines, Sudan, Suriname, Tajikistan, Tanzania, Thailand, Timor-Leste, Togo, Tonga, Trinidad and Tobago, Tunisia, Türkiye, Tuvalu, Uganda, Ukraine, United Arab Emirates, Uruguay, Uzbekistan, Syrian Arab Republic, Chad, Vietnam, Vanuatu, Samoa, Kosovo, Yemen, Rep., Zambia, Zimbabwe, Armenia, China, Algeria, Iran, Islamic Rep., Kenya, Cambodia, Libya, Mauritania, West Bank and Gaza, Saudi Arabia, Albania, Côte d’Ivoire, Cameroon, Congo, Rep., Costa Rica, Ecuador, Guinea, Gambia, The, Guatemala, Honduras, Haiti, Indonesia, Maldives, Bolivia, Bosnia and Herzegovina, Botswana, Brazil, Bulgaria, Burkina Faso, Burundi, Cabo Verde, Central African Republic, Chile, Colombia, Comoros, Congo, Dem. Rep., Croatia, Djibouti, Dominica, Dominican Republic, Jamaica, Jordan, Kazakhstan, Kiribati, Kuwait, Kyrgyz Republic, Lao PDR, Lebanon, Lesotho, Liberia, Mali, Marshall Islands, Mauritius, Mexico, Micronesia, Fed. Sts., Moldova, Mongolia, Montenegro, Grenada, Guyana, India, Iraq, Morocco, North Macedonia, Myanmar, Mozambique, Niger, Nigeria, Nicaragua, Oman, Pakistan, Peru, Philippines, Palau, Papua New Guinea, Poland, Qatar, Romania, Russian Federation, Rwanda, El Salvador, São Tomé and Príncipe, Angola, Argentina, Azerbaijan, Bahamas, The, Bahrain, Bangladesh, Barbados, Belarus, Belize, Benin, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Gabon, Georgia, Ghana, Guinea-Bissau, Equatorial Guinea, Namibia, Nepal, Panama, Paraguay, Eswatini, Bhutan, Afghanistan, MDG, MWI, MYS, SEN, SRB, SYC, SLE, SLB, ZAF, SSD, LKA, LCA, VCT, SDN, SUR, TJK, TZA, THA, TLS, TGO, TON, TTO, TUN, TUR, TUV, UGA, UKR, ARE, URY, UZB, SYR, TCD, VNM, VUT, WSM, XKX, YEM, ZMB, ZWE, ARM, CHN, DZA, IRN, KEN, KHM, LBY, MRT, PSE, SAU, ALB, CIV, CMR, COG, CRI, ECU, GIN, GMB, GTM, HND, HTI, IDN, MDV, BOL, BIH, BWA, BRA, BGR, BFA, BDI, CPV, CAF, CHL, COL, COM, COD, HRV, DJI, DMA, DOM, JAM, JOR, KAZ, KIR, KWT, KGZ, LAO, LBN, LSO, LBR, MLI, MHL, MUS, MEX, FSM, MDA, MNG, MNE, GRD, GUY, IND, IRQ, MAR, MKD, MMR, MOZ, NER, NGA, NIC, OMN, PAK, PER, PHL, PLW, PNG, POL, QAT, ROU, RUS, RWA, SLV, STP, AGO, ARG, AZE, BHS, BHR, BGD, BRB, BLR, BLZ, BEN, EGY, ERI, ETH, FJI, GAB, GEO, GHA, GNB, GNQ, NAM, NPL, PAN, PRY, SWZ, BTN, AFG
#> 21                                                 Madagascar, Malawi, Malaysia, Serbia, Seychelles, Sierra Leone, Solomon Islands, Somalia, Federal Republic of, South Africa, South Sudan, Sri Lanka, St. Lucia, St. Vincent and the Grenadines, Sudan, Suriname, Tajikistan, Tanzania, Thailand, Timor-Leste, Togo, Tonga, Trinidad and Tobago, Tunisia, Türkiye, Uganda, Ukraine, United Arab Emirates, Uruguay, Uzbekistan, São Tomé and Príncipe, Syrian Arab Republic, Chad, Vietnam, Vanuatu, Samoa, Kosovo, Yemen, Rep., Zambia, Zimbabwe, Armenia, China, Algeria, Iran, Islamic Rep., Kenya, Cambodia, Libya, Mauritania, West Bank and Gaza, Saudi Arabia, Albania, Côte d’Ivoire, Cameroon, Congo, Rep., Costa Rica, Ecuador, Guinea, Gambia, The, Guatemala, Honduras, Haiti, Indonesia, Maldives, Bolivia, Bosnia and Herzegovina, Botswana, Brazil, Bulgaria, Burkina Faso, Burundi, Cabo Verde, Central African Republic, Chile, Colombia, Comoros, Congo, Dem. Rep., Croatia, Djibouti, Dominica, Dominican Republic, Jamaica, Jordan, Kazakhstan, Kiribati, Kuwait, Kyrgyz Republic, Lao PDR, Lebanon, Lesotho, Liberia, Mali, Mauritius, Mexico, Micronesia, Fed. Sts., Moldova, Mongolia, Montenegro, Grenada, Guyana, India, Iraq, Morocco, North Macedonia, Myanmar, Mozambique, Niger, Nigeria, Nicaragua, Oman, Pakistan, Peru, Philippines, Palau, Papua New Guinea, Poland, Qatar, Romania, Russian Federation, Rwanda, El Salvador, Angola, Argentina, Azerbaijan, Bahamas, The, Bahrain, Bangladesh, Barbados, Belarus, Belize, Benin, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Gabon, Georgia, Ghana, Guinea-Bissau, Equatorial Guinea, Namibia, Nepal, Panama, Paraguay, Senegal, Eswatini, Bhutan, Afghanistan, MDG, MWI, MYS, SRB, SYC, SLE, SLB, SOM, ZAF, SSD, LKA, LCA, VCT, SDN, SUR, TJK, TZA, THA, TLS, TGO, TON, TTO, TUN, TUR, UGA, UKR, ARE, URY, UZB, STP, SYR, TCD, VNM, VUT, WSM, XKX, YEM, ZMB, ZWE, ARM, CHN, DZA, IRN, KEN, KHM, LBY, MRT, PSE, SAU, ALB, CIV, CMR, COG, CRI, ECU, GIN, GMB, GTM, HND, HTI, IDN, MDV, BOL, BIH, BWA, BRA, BGR, BFA, BDI, CPV, CAF, CHL, COL, COM, COD, HRV, DJI, DMA, DOM, JAM, JOR, KAZ, KIR, KWT, KGZ, LAO, LBN, LSO, LBR, MLI, MUS, MEX, FSM, MDA, MNG, MNE, GRD, GUY, IND, IRQ, MAR, MKD, MMR, MOZ, NER, NGA, NIC, OMN, PAK, PER, PHL, PLW, PNG, POL, QAT, ROU, RUS, RWA, SLV, AGO, ARG, AZE, BHS, BHR, BGD, BRB, BLR, BLZ, BEN, EGY, ERI, ETH, FJI, GAB, GEO, GHA, GNB, GNQ, NAM, NPL, PAN, PRY, SEN, SWZ, BTN, AFG
#> 22                                                                                                                                                                                                                                                                                                                       Madagascar, Malawi, Malaysia, Senegal, Serbia, Seychelles, Sierra Leone, Solomon Islands, Somalia, Federal Republic of, South Africa, Sri Lanka, Sudan, Tajikistan, Tanzania, Thailand, Timor-Leste, Togo, Tunisia, Türkiye, Uganda, Ukraine, Uruguay, Uzbekistan, Syrian Arab Republic, Chad, Vietnam, Vanuatu, Samoa, Kosovo, Yemen, Rep., Zambia, Zimbabwe, Armenia, China, Algeria, Iran, Islamic Rep., Kenya, Cambodia, Libya, Mauritania, West Bank and Gaza, Saudi Arabia, Albania, Côte d’Ivoire, Cameroon, Congo, Rep., Costa Rica, Ecuador, Guinea, Gambia, The, Guatemala, Honduras, Haiti, Indonesia, Maldives, Bolivia, Bosnia and Herzegovina, Botswana, Brazil, Bulgaria, Burkina Faso, Burundi, Cabo Verde, Central African Republic, Chile, Colombia, Comoros, Congo, Dem. Rep., Croatia, Djibouti, Dominican Republic, Kazakhstan, Kiribati, Kuwait, Kyrgyz Republic, Lebanon, Liberia, Mali, Marshall Islands, Mauritius, Mexico, Moldova, Mongolia, Montenegro, Lesotho, India, Iraq, Jamaica, Jordan, Morocco, North Macedonia, Myanmar, Mozambique, Niger, Nigeria, Nicaragua, Oman, Pakistan, Peru, Philippines, Poland, Qatar, Romania, Russian Federation, Rwanda, El Salvador, United Arab Emirates, Angola, Argentina, Azerbaijan, Bahamas, The, Bahrain, Bangladesh, Belarus, Belize, Benin, Bhutan, Egypt, Arab Rep., Eritrea, Ethiopia, Gabon, Georgia, Ghana, Guinea-Bissau, Equatorial Guinea, Namibia, Nauru, Nepal, Panama, Paraguay, Eswatini, Afghanistan, MDG, MWI, MYS, SEN, SRB, SYC, SLE, SLB, SOM, ZAF, LKA, SDN, TJK, TZA, THA, TLS, TGO, TUN, TUR, UGA, UKR, URY, UZB, SYR, TCD, VNM, VUT, WSM, XKX, YEM, ZMB, ZWE, ARM, CHN, DZA, IRN, KEN, KHM, LBY, MRT, PSE, SAU, ALB, CIV, CMR, COG, CRI, ECU, GIN, GMB, GTM, HND, HTI, IDN, MDV, BOL, BIH, BWA, BRA, BGR, BFA, BDI, CPV, CAF, CHL, COL, COM, COD, HRV, DJI, DOM, KAZ, KIR, KWT, KGZ, LBN, LBR, MLI, MHL, MUS, MEX, MDA, MNG, MNE, LSO, IND, IRQ, JAM, JOR, MAR, MKD, MMR, MOZ, NER, NGA, NIC, OMN, PAK, PER, PHL, POL, QAT, ROU, RUS, RWA, SLV, ARE, AGO, ARG, AZE, BHS, BHR, BGD, BLR, BLZ, BEN, BTN, EGY, ERI, ETH, GAB, GEO, GHA, GNB, GNQ, NAM, NRU, NPL, PAN, PRY, SWZ, AFG
#> 23                                                             Madagascar, Malawi, Malaysia, Senegal, Serbia, Seychelles, Sierra Leone, Solomon Islands, South Africa, South Sudan, Sri Lanka, St. Lucia, St. Vincent and the Grenadines, Sudan, Suriname, Tajikistan, Tanzania, Thailand, Timor-Leste, Togo, Tonga, Trinidad and Tobago, Tunisia, Türkiye, Uganda, Ukraine, United Arab Emirates, Uruguay, Uzbekistan, Syrian Arab Republic, Chad, Vietnam, Vanuatu, Samoa, Kosovo, Yemen, Rep., Zambia, Zimbabwe, Armenia, China, Algeria, Iran, Islamic Rep., Kenya, Cambodia, Libya, Mauritania, West Bank and Gaza, Saudi Arabia, Albania, Côte d’Ivoire, Cameroon, Congo, Rep., Costa Rica, Ecuador, Guinea, Gambia, The, Guatemala, Honduras, Haiti, Indonesia, Maldives, Bolivia, Bosnia and Herzegovina, Botswana, Brazil, Bulgaria, Burkina Faso, Burundi, Cabo Verde, Central African Republic, Chile, Colombia, Comoros, Congo, Dem. Rep., Croatia, Djibouti, Dominica, Dominican Republic, Jamaica, Jordan, Kazakhstan, Kiribati, Kuwait, Kyrgyz Republic, Lao PDR, Lebanon, Lesotho, Liberia, Mali, Marshall Islands, Mauritius, Mexico, Micronesia, Fed. Sts., Moldova, Mongolia, Montenegro, Grenada, Guyana, India, Iraq, Morocco, North Macedonia, Myanmar, Mozambique, Niger, Nigeria, Nicaragua, Oman, Pakistan, Peru, Philippines, Palau, Papua New Guinea, Poland, Qatar, Romania, Russian Federation, Rwanda, El Salvador, São Tomé and Príncipe, Angola, Argentina, Azerbaijan, Bahamas, The, Bahrain, Bangladesh, Barbados, Belarus, Belize, Benin, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Gabon, Georgia, Ghana, Guinea-Bissau, Equatorial Guinea, Namibia, Nepal, Panama, Paraguay, Eswatini, Bhutan, Afghanistan, MDG, MWI, MYS, SEN, SRB, SYC, SLE, SLB, ZAF, SSD, LKA, LCA, VCT, SDN, SUR, TJK, TZA, THA, TLS, TGO, TON, TTO, TUN, TUR, UGA, UKR, ARE, URY, UZB, SYR, TCD, VNM, VUT, WSM, XKX, YEM, ZMB, ZWE, ARM, CHN, DZA, IRN, KEN, KHM, LBY, MRT, PSE, SAU, ALB, CIV, CMR, COG, CRI, ECU, GIN, GMB, GTM, HND, HTI, IDN, MDV, BOL, BIH, BWA, BRA, BGR, BFA, BDI, CPV, CAF, CHL, COL, COM, COD, HRV, DJI, DMA, DOM, JAM, JOR, KAZ, KIR, KWT, KGZ, LAO, LBN, LSO, LBR, MLI, MHL, MUS, MEX, FSM, MDA, MNG, MNE, GRD, GUY, IND, IRQ, MAR, MKD, MMR, MOZ, NER, NGA, NIC, OMN, PAK, PER, PHL, PLW, PNG, POL, QAT, ROU, RUS, RWA, SLV, STP, AGO, ARG, AZE, BHS, BHR, BGD, BRB, BLR, BLZ, BEN, EGY, ERI, ETH, FJI, GAB, GEO, GHA, GNB, GNQ, NAM, NPL, PAN, PRY, SWZ, BTN, AFG
#> 24                                                 Malawi, Malaysia, Serbia, Seychelles, Sierra Leone, Solomon Islands, Somalia, Federal Republic of, South Africa, South Sudan, Sri Lanka, St. Lucia, St. Vincent and the Grenadines, Sudan, Suriname, Tajikistan, Tanzania, Thailand, Timor-Leste, Togo, Tonga, Trinidad and Tobago, Tunisia, Türkiye, Uganda, Ukraine, United Arab Emirates, Uruguay, Uzbekistan, Syrian Arab Republic, Chad, Vietnam, Vanuatu, Samoa, Kosovo, Yemen, Rep., Zambia, Zimbabwe, Armenia, China, Algeria, Iran, Islamic Rep., Kenya, Cambodia, Libya, Mauritania, West Bank and Gaza, Saudi Arabia, Albania, Côte d’Ivoire, Cameroon, Congo, Rep., Costa Rica, Ecuador, Guinea, Gambia, The, Guatemala, Honduras, Haiti, Indonesia, Maldives, Bosnia and Herzegovina, Botswana, Brazil, Bulgaria, Burkina Faso, Burundi, Cabo Verde, Central African Republic, Chile, Colombia, Comoros, Congo, Dem. Rep., Croatia, Djibouti, Dominica, Dominican Republic, Jordan, Kazakhstan, Kiribati, Kuwait, Kyrgyz Republic, Lao PDR, Lebanon, Lesotho, Liberia, Madagascar, Mali, Mauritius, Mexico, Micronesia, Fed. Sts., Moldova, Mongolia, Montenegro, Guyana, India, Iraq, Jamaica, Morocco, North Macedonia, Myanmar, Mozambique, Niger, Nigeria, Nicaragua, Oman, Pakistan, Peru, Philippines, Palau, Papua New Guinea, Poland, Qatar, Romania, Russian Federation, Rwanda, El Salvador, São Tomé and Príncipe, Angola, Argentina, Azerbaijan, Bahamas, The, Bahrain, Bangladesh, Barbados, Belarus, Belize, Benin, Bhutan, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Gabon, Georgia, Ghana, Guinea-Bissau, Equatorial Guinea, Grenada, Namibia, Nepal, Panama, Paraguay, Senegal, Eswatini, Bolivia, Afghanistan, MWI, MYS, SRB, SYC, SLE, SLB, SOM, ZAF, SSD, LKA, LCA, VCT, SDN, SUR, TJK, TZA, THA, TLS, TGO, TON, TTO, TUN, TUR, UGA, UKR, ARE, URY, UZB, SYR, TCD, VNM, VUT, WSM, XKX, YEM, ZMB, ZWE, ARM, CHN, DZA, IRN, KEN, KHM, LBY, MRT, PSE, SAU, ALB, CIV, CMR, COG, CRI, ECU, GIN, GMB, GTM, HND, HTI, IDN, MDV, BIH, BWA, BRA, BGR, BFA, BDI, CPV, CAF, CHL, COL, COM, COD, HRV, DJI, DMA, DOM, JOR, KAZ, KIR, KWT, KGZ, LAO, LBN, LSO, LBR, MDG, MLI, MUS, MEX, FSM, MDA, MNG, MNE, GUY, IND, IRQ, JAM, MAR, MKD, MMR, MOZ, NER, NGA, NIC, OMN, PAK, PER, PHL, PLW, PNG, POL, QAT, ROU, RUS, RWA, SLV, STP, AGO, ARG, AZE, BHS, BHR, BGD, BRB, BLR, BLZ, BEN, BTN, EGY, ERI, ETH, FJI, GAB, GEO, GHA, GNB, GNQ, GRD, NAM, NPL, PAN, PRY, SEN, SWZ, BOL, AFG
#> 25                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    Kosovo, West Bank and Gaza, Marshall Islands, Tuvalu, Nauru, XKX, PSE, MHL, TUV, NRU
#> 26                                                                                       Madagascar, Malawi, Senegal, Serbia, Seychelles, Sierra Leone, Solomon Islands, Somalia, Federal Republic of, South Africa, South Sudan, Sri Lanka, St. Lucia, St. Vincent and the Grenadines, Sudan, Suriname, Tajikistan, Tanzania, Thailand, Timor-Leste, Togo, Tonga, Trinidad and Tobago, Tunisia, Türkiye, Uganda, Ukraine, United Arab Emirates, Uruguay, São Tomé and Príncipe, Syrian Arab Republic, Chad, Uzbekistan, Vietnam, Vanuatu, Samoa, Yemen, Rep., Zambia, Zimbabwe, Armenia, China, Algeria, Iran, Islamic Rep., Kenya, Cambodia, Libya, Mauritania, Saudi Arabia, Albania, Côte d’Ivoire, Cameroon, Congo, Rep., Costa Rica, Ecuador, Guinea, Gambia, The, Guatemala, Honduras, Haiti, Indonesia, Bolivia, Bosnia and Herzegovina, Botswana, Brazil, Bulgaria, Burkina Faso, Burundi, Cabo Verde, Central African Republic, Chile, Colombia, Comoros, Congo, Dem. Rep., Croatia, Djibouti, Dominica, Dominican Republic, Jamaica, Jordan, Kazakhstan, Kiribati, Kuwait, Kyrgyz Republic, Lao PDR, Lebanon, Lesotho, Liberia, Malaysia, Maldives, Mali, Mauritius, Mexico, Micronesia, Fed. Sts., Moldova, Mongolia, Montenegro, Grenada, Guyana, India, Iraq, Morocco, North Macedonia, Myanmar, Mozambique, Niger, Nigeria, Nicaragua, Oman, Pakistan, Peru, Philippines, Palau, Papua New Guinea, Poland, Qatar, Romania, Russian Federation, Rwanda, El Salvador, Angola, Argentina, Azerbaijan, Bahamas, The, Bahrain, Bangladesh, Barbados, Belarus, Belize, Benin, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Gabon, Georgia, Ghana, Guinea-Bissau, Equatorial Guinea, Namibia, Nepal, Panama, Paraguay, Eswatini, Bhutan, Afghanistan, MDG, MWI, SEN, SRB, SYC, SLE, SLB, SOM, ZAF, SSD, LKA, LCA, VCT, SDN, SUR, TJK, TZA, THA, TLS, TGO, TON, TTO, TUN, TUR, UGA, UKR, ARE, URY, STP, SYR, TCD, UZB, VNM, VUT, WSM, YEM, ZMB, ZWE, ARM, CHN, DZA, IRN, KEN, KHM, LBY, MRT, SAU, ALB, CIV, CMR, COG, CRI, ECU, GIN, GMB, GTM, HND, HTI, IDN, BOL, BIH, BWA, BRA, BGR, BFA, BDI, CPV, CAF, CHL, COL, COM, COD, HRV, DJI, DMA, DOM, JAM, JOR, KAZ, KIR, KWT, KGZ, LAO, LBN, LSO, LBR, MYS, MDV, MLI, MUS, MEX, FSM, MDA, MNG, MNE, GRD, GUY, IND, IRQ, MAR, MKD, MMR, MOZ, NER, NGA, NIC, OMN, PAK, PER, PHL, PLW, PNG, POL, QAT, ROU, RUS, RWA, SLV, AGO, ARG, AZE, BHS, BHR, BGD, BRB, BLR, BLZ, BEN, EGY, ERI, ETH, FJI, GAB, GEO, GHA, GNB, GNQ, NAM, NPL, PAN, PRY, SWZ, BTN, AFG
#> 27                                                                                       Madagascar, Malawi, Senegal, Serbia, Seychelles, Sierra Leone, Solomon Islands, Somalia, Federal Republic of, South Africa, South Sudan, Sri Lanka, St. Lucia, St. Vincent and the Grenadines, Sudan, Suriname, Tajikistan, Tanzania, Thailand, Timor-Leste, Togo, Tonga, Trinidad and Tobago, Tunisia, Türkiye, Uganda, Ukraine, United Arab Emirates, Uruguay, São Tomé and Príncipe, Syrian Arab Republic, Chad, Uzbekistan, Vietnam, Vanuatu, Samoa, Yemen, Rep., Zambia, Zimbabwe, Armenia, China, Algeria, Iran, Islamic Rep., Kenya, Cambodia, Libya, Mauritania, Saudi Arabia, Albania, Côte d’Ivoire, Cameroon, Congo, Rep., Costa Rica, Ecuador, Guinea, Gambia, The, Guatemala, Honduras, Haiti, Indonesia, Bolivia, Bosnia and Herzegovina, Botswana, Brazil, Bulgaria, Burkina Faso, Burundi, Cabo Verde, Central African Republic, Chile, Colombia, Comoros, Congo, Dem. Rep., Croatia, Djibouti, Dominica, Dominican Republic, Jamaica, Jordan, Kazakhstan, Kiribati, Kuwait, Kyrgyz Republic, Lao PDR, Lebanon, Lesotho, Liberia, Malaysia, Maldives, Mali, Mauritius, Mexico, Micronesia, Fed. Sts., Moldova, Mongolia, Montenegro, Grenada, Guyana, India, Iraq, Morocco, North Macedonia, Myanmar, Mozambique, Niger, Nigeria, Nicaragua, Oman, Pakistan, Peru, Philippines, Palau, Papua New Guinea, Poland, Qatar, Romania, Russian Federation, Rwanda, El Salvador, Angola, Argentina, Azerbaijan, Bahamas, The, Bahrain, Bangladesh, Barbados, Belarus, Belize, Benin, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Gabon, Georgia, Ghana, Guinea-Bissau, Equatorial Guinea, Namibia, Nepal, Panama, Paraguay, Eswatini, Bhutan, Afghanistan, MDG, MWI, SEN, SRB, SYC, SLE, SLB, SOM, ZAF, SSD, LKA, LCA, VCT, SDN, SUR, TJK, TZA, THA, TLS, TGO, TON, TTO, TUN, TUR, UGA, UKR, ARE, URY, STP, SYR, TCD, UZB, VNM, VUT, WSM, YEM, ZMB, ZWE, ARM, CHN, DZA, IRN, KEN, KHM, LBY, MRT, SAU, ALB, CIV, CMR, COG, CRI, ECU, GIN, GMB, GTM, HND, HTI, IDN, BOL, BIH, BWA, BRA, BGR, BFA, BDI, CPV, CAF, CHL, COL, COM, COD, HRV, DJI, DMA, DOM, JAM, JOR, KAZ, KIR, KWT, KGZ, LAO, LBN, LSO, LBR, MYS, MDV, MLI, MUS, MEX, FSM, MDA, MNG, MNE, GRD, GUY, IND, IRQ, MAR, MKD, MMR, MOZ, NER, NGA, NIC, OMN, PAK, PER, PHL, PLW, PNG, POL, QAT, ROU, RUS, RWA, SLV, AGO, ARG, AZE, BHS, BHR, BGD, BRB, BLR, BLZ, BEN, EGY, ERI, ETH, FJI, GAB, GEO, GHA, GNB, GNQ, NAM, NPL, PAN, PRY, SWZ, BTN, AFG
#> 28                                                                                                                                                                                                                                                                                                                                   Madagascar, Malawi, Malaysia, Senegal, Serbia, Seychelles, Sierra Leone, Solomon Islands, Somalia, Federal Republic of, South Africa, Sri Lanka, Sudan, Tajikistan, Tanzania, Thailand, Timor-Leste, Togo, Tunisia, Türkiye, Uganda, Ukraine, Uruguay, Uzbekistan, Syrian Arab Republic, Chad, Vietnam, Vanuatu, Samoa, Kosovo, Yemen, Rep., Zambia, Zimbabwe, Armenia, China, Algeria, Iran, Islamic Rep., Kenya, Cambodia, Libya, Mauritania, West Bank and Gaza, Saudi Arabia, Albania, Côte d’Ivoire, Cameroon, Congo, Rep., Costa Rica, Ecuador, Guinea, Gambia, The, Guatemala, Honduras, Haiti, Indonesia, Maldives, Bolivia, Bosnia and Herzegovina, Botswana, Brazil, Bulgaria, Burkina Faso, Burundi, Cabo Verde, Central African Republic, Chile, Colombia, Comoros, Congo, Dem. Rep., Croatia, Djibouti, Dominican Republic, Kazakhstan, Kiribati, Kuwait, Kyrgyz Republic, Lebanon, Liberia, Mali, Marshall Islands, Mauritius, Mexico, Moldova, Mongolia, Montenegro, Lesotho, India, Iraq, Jamaica, Jordan, Morocco, North Macedonia, Myanmar, Mozambique, Niger, Nigeria, Nicaragua, Oman, Pakistan, Peru, Philippines, Poland, Qatar, Romania, Russian Federation, Rwanda, El Salvador, United Arab Emirates, Angola, Argentina, Azerbaijan, Bahamas, The, Bahrain, Bangladesh, Belarus, Belize, Benin, Bhutan, Egypt, Arab Rep., Eritrea, Ethiopia, Gabon, Georgia, Ghana, Guinea-Bissau, Equatorial Guinea, Namibia, Nepal, Panama, Paraguay, Eswatini, Afghanistan, MDG, MWI, MYS, SEN, SRB, SYC, SLE, SLB, SOM, ZAF, LKA, SDN, TJK, TZA, THA, TLS, TGO, TUN, TUR, UGA, UKR, URY, UZB, SYR, TCD, VNM, VUT, WSM, XKX, YEM, ZMB, ZWE, ARM, CHN, DZA, IRN, KEN, KHM, LBY, MRT, PSE, SAU, ALB, CIV, CMR, COG, CRI, ECU, GIN, GMB, GTM, HND, HTI, IDN, MDV, BOL, BIH, BWA, BRA, BGR, BFA, BDI, CPV, CAF, CHL, COL, COM, COD, HRV, DJI, DOM, KAZ, KIR, KWT, KGZ, LBN, LBR, MLI, MHL, MUS, MEX, MDA, MNG, MNE, LSO, IND, IRQ, JAM, JOR, MAR, MKD, MMR, MOZ, NER, NGA, NIC, OMN, PAK, PER, PHL, POL, QAT, ROU, RUS, RWA, SLV, ARE, AGO, ARG, AZE, BHS, BHR, BGD, BLR, BLZ, BEN, BTN, EGY, ERI, ETH, GAB, GEO, GHA, GNB, GNQ, NAM, NPL, PAN, PRY, SWZ, AFG
#> 29 Malawi, Serbia, Seychelles, Sierra Leone, Solomon Islands, Somalia, Federal Republic of, South Africa, South Sudan, Sri Lanka, St. Lucia, St. Vincent and the Grenadines, Sudan, Suriname, Tajikistan, Tanzania, Thailand, Timor-Leste, Togo, Tonga, Trinidad and Tobago, Tunisia, Türkiye, Tuvalu, Uganda, Ukraine, United Arab Emirates, Uruguay, São Tomé and Príncipe, Syrian Arab Republic, Chad, Uzbekistan, Vietnam, Vanuatu, Samoa, Kosovo, Yemen, Rep., Zambia, Zimbabwe, Armenia, China, Algeria, Iran, Islamic Rep., Kenya, Cambodia, Libya, Mauritania, West Bank and Gaza, Saudi Arabia, Albania, Côte d’Ivoire, Cameroon, Congo, Rep., Costa Rica, Ecuador, Guinea, Gambia, The, Guatemala, Honduras, Haiti, Indonesia, Bosnia and Herzegovina, Botswana, Brazil, Bulgaria, Burkina Faso, Burundi, Cabo Verde, Central African Republic, Chile, Colombia, Comoros, Congo, Dem. Rep., Croatia, Djibouti, Dominica, Dominican Republic, Jamaica, Jordan, Kazakhstan, Kiribati, Kuwait, Kyrgyz Republic, Lao PDR, Lebanon, Lesotho, Liberia, Madagascar, Malaysia, Maldives, Mali, Marshall Islands, Mauritius, Mexico, Micronesia, Fed. Sts., Moldova, Mongolia, Montenegro, Grenada, Guyana, India, Iraq, Morocco, North Macedonia, Myanmar, Mozambique, Niger, Nigeria, Nicaragua, Oman, Pakistan, Peru, Philippines, Palau, Papua New Guinea, Poland, Qatar, Romania, Russian Federation, Rwanda, El Salvador, Angola, Argentina, Azerbaijan, Bahamas, The, Bahrain, Bangladesh, Barbados, Belarus, Belize, Benin, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Gabon, Georgia, Ghana, Guinea-Bissau, Equatorial Guinea, Namibia, Nauru, Nepal, Panama, Paraguay, Senegal, Eswatini, Bolivia, Bhutan, Afghanistan, MWI, SRB, SYC, SLE, SLB, SOM, ZAF, SSD, LKA, LCA, VCT, SDN, SUR, TJK, TZA, THA, TLS, TGO, TON, TTO, TUN, TUR, TUV, UGA, UKR, ARE, URY, STP, SYR, TCD, UZB, VNM, VUT, WSM, XKX, YEM, ZMB, ZWE, ARM, CHN, DZA, IRN, KEN, KHM, LBY, MRT, PSE, SAU, ALB, CIV, CMR, COG, CRI, ECU, GIN, GMB, GTM, HND, HTI, IDN, BIH, BWA, BRA, BGR, BFA, BDI, CPV, CAF, CHL, COL, COM, COD, HRV, DJI, DMA, DOM, JAM, JOR, KAZ, KIR, KWT, KGZ, LAO, LBN, LSO, LBR, MDG, MYS, MDV, MLI, MHL, MUS, MEX, FSM, MDA, MNG, MNE, GRD, GUY, IND, IRQ, MAR, MKD, MMR, MOZ, NER, NGA, NIC, OMN, PAK, PER, PHL, PLW, PNG, POL, QAT, ROU, RUS, RWA, SLV, AGO, ARG, AZE, BHS, BHR, BGD, BRB, BLR, BLZ, BEN, EGY, ERI, ETH, FJI, GAB, GEO, GHA, GNB, GNQ, NAM, NRU, NPL, PAN, PRY, SEN, SWZ, BOL, BTN, AFG
#> 30 Madagascar, Malawi, Malaysia, Senegal, Serbia, Seychelles, Sierra Leone, Solomon Islands, Somalia, Federal Republic of, South Africa, South Sudan, Sri Lanka, St. Lucia, St. Vincent and the Grenadines, Sudan, Suriname, Tajikistan, Tanzania, Thailand, Timor-Leste, Togo, Tonga, Trinidad and Tobago, Tunisia, Türkiye, Tuvalu, Uganda, Ukraine, Uruguay, Uzbekistan, São Tomé and Príncipe, Syrian Arab Republic, Chad, Vietnam, Vanuatu, Samoa, Kosovo, Yemen, Rep., Zambia, Zimbabwe, Armenia, China, Algeria, Iran, Islamic Rep., Kenya, Cambodia, Libya, Mauritania, West Bank and Gaza, Saudi Arabia, Albania, Côte d’Ivoire, Cameroon, Congo, Rep., Costa Rica, Ecuador, Guinea, Gambia, The, Guatemala, Honduras, Haiti, Indonesia, Bolivia, Bosnia and Herzegovina, Botswana, Brazil, Bulgaria, Burkina Faso, Burundi, Cabo Verde, Central African Republic, Chile, Colombia, Comoros, Congo, Dem. Rep., Croatia, Djibouti, Dominica, Dominican Republic, Kazakhstan, Kiribati, Kuwait, Kyrgyz Republic, Lao PDR, Lebanon, Liberia, Mali, Marshall Islands, Mauritius, Mexico, Micronesia, Fed. Sts., Moldova, Mongolia, Montenegro, Lesotho, Grenada, Guyana, India, Iraq, Jamaica, Jordan, Morocco, North Macedonia, Myanmar, Mozambique, Niger, Nigeria, Nicaragua, Oman, Pakistan, Peru, Philippines, Palau, Papua New Guinea, Poland, Qatar, Romania, Russian Federation, Rwanda, El Salvador, United Arab Emirates, Angola, Argentina, Azerbaijan, Bahamas, The, Bahrain, Bangladesh, Barbados, Belarus, Belize, Benin, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Gabon, Georgia, Ghana, Guinea-Bissau, Equatorial Guinea, Namibia, Nauru, Nepal, Maldives, Panama, Paraguay, Eswatini, Bhutan, Afghanistan, MDG, MWI, MYS, SEN, SRB, SYC, SLE, SLB, SOM, ZAF, SSD, LKA, LCA, VCT, SDN, SUR, TJK, TZA, THA, TLS, TGO, TON, TTO, TUN, TUR, TUV, UGA, UKR, URY, UZB, STP, SYR, TCD, VNM, VUT, WSM, XKX, YEM, ZMB, ZWE, ARM, CHN, DZA, IRN, KEN, KHM, LBY, MRT, PSE, SAU, ALB, CIV, CMR, COG, CRI, ECU, GIN, GMB, GTM, HND, HTI, IDN, BOL, BIH, BWA, BRA, BGR, BFA, BDI, CPV, CAF, CHL, COL, COM, COD, HRV, DJI, DMA, DOM, KAZ, KIR, KWT, KGZ, LAO, LBN, LBR, MLI, MHL, MUS, MEX, FSM, MDA, MNG, MNE, LSO, GRD, GUY, IND, IRQ, JAM, JOR, MAR, MKD, MMR, MOZ, NER, NGA, NIC, OMN, PAK, PER, PHL, PLW, PNG, POL, QAT, ROU, RUS, RWA, SLV, ARE, AGO, ARG, AZE, BHS, BHR, BGD, BRB, BLR, BLZ, BEN, EGY, ERI, ETH, FJI, GAB, GEO, GHA, GNB, GNQ, NAM, NRU, NPL, MDV, PAN, PRY, SWZ, BTN, AFG
#> 31                                                                                                                                                                                                                                                                                                                                                                                                                                                      Madagascar, Malawi, Malaysia, Senegal, Serbia, Seychelles, Sierra Leone, Solomon Islands, Somalia, Federal Republic of, South Africa, Sri Lanka, Sudan, Tajikistan, Tanzania, Thailand, Timor-Leste, Togo, Tunisia, Türkiye, Uganda, Ukraine, Uruguay, Uzbekistan, Bolivia, Bosnia and Herzegovina, Botswana, Brazil, Bulgaria, Burkina Faso, Burundi, Cabo Verde, Cambodia, Cameroon, Central African Republic, Chad, Chile, China, Colombia, Comoros, Congo, Dem. Rep., Congo, Rep., Costa Rica, Côte d’Ivoire, Croatia, Djibouti, Dominican Republic, Kazakhstan, Kenya, Kiribati, Kosovo, Kuwait, Kyrgyz Republic, Lebanon, Liberia, Libya, Mali, Marshall Islands, Mauritania, Mauritius, Mexico, Moldova, Mongolia, Montenegro, Lesotho, United Arab Emirates, Vanuatu, Vietnam, Zambia, Zimbabwe, Albania, Algeria, Angola, Argentina, Armenia, Azerbaijan, Bahamas, The, Bahrain, Bangladesh, Belarus, Belize, Benin, Morocco, Mozambique, Namibia, Nepal, Nicaragua, Niger, North Macedonia, Gambia, The, Georgia, Ghana, Guatemala, Guinea, Guinea-Bissau, Haiti, Honduras, India, Indonesia, Iran, Islamic Rep., Iraq, Afghanistan, Ecuador, Egypt, Arab Rep., El Salvador, Equatorial Guinea, Bhutan, Oman, Pakistan, West Bank and Gaza, Panama, Paraguay, Peru, Philippines, Poland, Qatar, Romania, Russian Federation, Rwanda, Saudi Arabia, Eritrea, Eswatini, Ethiopia, Gabon, Samoa, MDG, MWI, MYS, SEN, SRB, SYC, SLE, SLB, SOM, ZAF, LKA, SDN, TJK, TZA, THA, TLS, TGO, TUN, TUR, UGA, UKR, URY, UZB, BOL, BIH, BWA, BRA, BGR, BFA, BDI, CPV, KHM, CMR, CAF, TCD, CHL, CHN, COL, COM, COD, COG, CRI, CIV, HRV, DJI, DOM, KAZ, KEN, KIR, XKX, KWT, KGZ, LBN, LBR, LBY, MLI, MHL, MRT, MUS, MEX, MDA, MNG, MNE, LSO, ARE, VUT, VNM, ZMB, ZWE, ALB, DZA, AGO, ARG, ARM, AZE, BHS, BHR, BGD, BLR, BLZ, BEN, MAR, MOZ, NAM, NPL, NIC, NER, MKD, GMB, GEO, GHA, GTM, GIN, GNB, HTI, HND, IND, IDN, IRN, IRQ, AFG, ECU, EGY, SLV, GNQ, BTN, OMN, PAK, PSE, PAN, PRY, PER, PHL, POL, QAT, ROU, RUS, RWA, SAU, ERI, SWZ, ETH, GAB, WSM
#> 32                                                                                                                                                                                                                                                                                                                                                          Malawi, Malaysia, Serbia, Seychelles, Sierra Leone, Solomon Islands, Somalia, Federal Republic of, South Africa, Sri Lanka, Sudan, Tajikistan, Tanzania, Thailand, Timor-Leste, Togo, Tunisia, Türkiye, Uganda, Ukraine, Uruguay, Uzbekistan, Syrian Arab Republic, Chad, Vietnam, Vanuatu, Samoa, Kosovo, Yemen, Rep., Zambia, Zimbabwe, Armenia, China, Algeria, Iran, Islamic Rep., Kenya, Cambodia, Libya, Mauritania, West Bank and Gaza, Saudi Arabia, Albania, Côte d’Ivoire, Cameroon, Congo, Rep., Costa Rica, Ecuador, Guinea, Gambia, The, Guatemala, Honduras, Haiti, Indonesia, Maldives, Bosnia and Herzegovina, Botswana, Brazil, Bulgaria, Burkina Faso, Burundi, Cabo Verde, Central African Republic, Chile, Colombia, Comoros, Congo, Dem. Rep., Croatia, Djibouti, Dominican Republic, Kazakhstan, Kiribati, Kuwait, Kyrgyz Republic, Lebanon, Liberia, Madagascar, Mali, Mauritius, Mexico, Moldova, Mongolia, Montenegro, Lesotho, India, Iraq, Jamaica, Jordan, Morocco, North Macedonia, Myanmar, Mozambique, Niger, Nigeria, Nicaragua, Oman, Pakistan, Peru, Philippines, Poland, Qatar, Romania, Russian Federation, Rwanda, El Salvador, United Arab Emirates, Angola, Argentina, Azerbaijan, Bahamas, The, Bahrain, Bangladesh, Belarus, Belize, Benin, Bhutan, Egypt, Arab Rep., Eritrea, Ethiopia, Gabon, Georgia, Ghana, Guinea-Bissau, Equatorial Guinea, Namibia, Nepal, Panama, Paraguay, Senegal, Eswatini, Bolivia, Afghanistan, MWI, MYS, SRB, SYC, SLE, SLB, SOM, ZAF, LKA, SDN, TJK, TZA, THA, TLS, TGO, TUN, TUR, UGA, UKR, URY, UZB, SYR, TCD, VNM, VUT, WSM, XKX, YEM, ZMB, ZWE, ARM, CHN, DZA, IRN, KEN, KHM, LBY, MRT, PSE, SAU, ALB, CIV, CMR, COG, CRI, ECU, GIN, GMB, GTM, HND, HTI, IDN, MDV, BIH, BWA, BRA, BGR, BFA, BDI, CPV, CAF, CHL, COL, COM, COD, HRV, DJI, DOM, KAZ, KIR, KWT, KGZ, LBN, LBR, MDG, MLI, MUS, MEX, MDA, MNG, MNE, LSO, IND, IRQ, JAM, JOR, MAR, MKD, MMR, MOZ, NER, NGA, NIC, OMN, PAK, PER, PHL, POL, QAT, ROU, RUS, RWA, SLV, ARE, AGO, ARG, AZE, BHS, BHR, BGD, BLR, BLZ, BEN, BTN, EGY, ERI, ETH, GAB, GEO, GHA, GNB, GNQ, NAM, NPL, PAN, PRY, SEN, SWZ, BOL, AFG
#> 33                                                                                                                                                                                                                                                                                                                                                                                                                                                      Madagascar, Malawi, Senegal, Serbia, Seychelles, Sierra Leone, Solomon Islands, Somalia, Federal Republic of, South Africa, Sri Lanka, Sudan, Tajikistan, Tanzania, Thailand, Timor-Leste, Togo, Tunisia, Türkiye, Uganda, Ukraine, Uruguay, Bolivia, Bosnia and Herzegovina, Botswana, Brazil, Bulgaria, Burkina Faso, Burundi, Cabo Verde, Cambodia, Cameroon, Central African Republic, Chad, Chile, China, Colombia, Comoros, Congo, Dem. Rep., Congo, Rep., Costa Rica, Côte d’Ivoire, Croatia, Djibouti, Kazakhstan, Kenya, Kiribati, Kosovo, Kuwait, Kyrgyz Republic, Lebanon, Liberia, Libya, Malaysia, Mali, Marshall Islands, Mauritania, Mauritius, Mexico, Moldova, Mongolia, Montenegro, Lesotho, United Arab Emirates, Uzbekistan, Vanuatu, Vietnam, Zambia, Zimbabwe, Albania, Algeria, Angola, Argentina, Armenia, Azerbaijan, Bahamas, The, Bahrain, Bangladesh, Belarus, Belize, Benin, Morocco, Mozambique, Namibia, Nepal, Nicaragua, Niger, North Macedonia, Gambia, The, Georgia, Ghana, Guatemala, Guinea, Guinea-Bissau, Haiti, Honduras, India, Indonesia, Iran, Islamic Rep., Iraq, Afghanistan, Dominican Republic, Ecuador, Egypt, Arab Rep., El Salvador, Equatorial Guinea, Bhutan, Oman, Pakistan, West Bank and Gaza, Panama, Paraguay, Peru, Philippines, Poland, Qatar, Romania, Russian Federation, Rwanda, Saudi Arabia, Eritrea, Eswatini, Ethiopia, Gabon, Samoa, MDG, MWI, SEN, SRB, SYC, SLE, SLB, SOM, ZAF, LKA, SDN, TJK, TZA, THA, TLS, TGO, TUN, TUR, UGA, UKR, URY, BOL, BIH, BWA, BRA, BGR, BFA, BDI, CPV, KHM, CMR, CAF, TCD, CHL, CHN, COL, COM, COD, COG, CRI, CIV, HRV, DJI, KAZ, KEN, KIR, XKX, KWT, KGZ, LBN, LBR, LBY, MYS, MLI, MHL, MRT, MUS, MEX, MDA, MNG, MNE, LSO, ARE, UZB, VUT, VNM, ZMB, ZWE, ALB, DZA, AGO, ARG, ARM, AZE, BHS, BHR, BGD, BLR, BLZ, BEN, MAR, MOZ, NAM, NPL, NIC, NER, MKD, GMB, GEO, GHA, GTM, GIN, GNB, HTI, HND, IND, IDN, IRN, IRQ, AFG, DOM, ECU, EGY, SLV, GNQ, BTN, OMN, PAK, PSE, PAN, PRY, PER, PHL, POL, QAT, ROU, RUS, RWA, SAU, ERI, SWZ, ETH, GAB, WSM
#> 34                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  Madagascar, Malawi, Bolivia, Botswana, Brazil, Burkina Faso, Burundi, Cabo Verde, Cameroon, Central African Republic, Chad, Chile, Colombia, Comoros, Congo, Dem. Rep., Congo, Rep., Costa Rica, Côte d’Ivoire, Croatia, Djibouti, Kiribati, Kyrgyz Republic, Lao PDR, Lesotho, Liberia, Mali, Mauritania, Mexico, Mongolia, Tajikistan, Tanzania, Thailand, Timor-Leste, Togo, Tunisia, Türkiye, Uganda, Uruguay, Uzbekistan, Vietnam, Zambia, Zimbabwe, Albania, Angola, Argentina, Armenia, Bangladesh, Belarus, Benin, Montenegro, Morocco, Mozambique, Namibia, Nicaragua, Niger, Nigeria, China, Dominican Republic, Ecuador, El Salvador, Bhutan, Pakistan, West Bank and Gaza, Panama, Paraguay, Peru, Philippines, Romania, Rwanda, São Tomé and Príncipe, Senegal, Serbia, Seychelles, Sierra Leone, Bulgaria, Kenya, Somalia, Federal Republic of, South Africa, South Sudan, Sri Lanka, St. Lucia, Eswatini, Ethiopia, Fiji, Gabon, Gambia, The, Georgia, Ghana, Grenada, Guatemala, Guinea, Guinea-Bissau, Haiti, Honduras, India, Indonesia, Kazakhstan, Sudan, Suriname, Syrian Arab Republic, Iran, Islamic Rep., Jamaica, Iraq, Malaysia, Barbados, Belize, Lebanon, Mauritius, Moldova, Equatorial Guinea, Russian Federation, Nepal, MDG, MWI, BOL, BWA, BRA, BFA, BDI, CPV, CMR, CAF, TCD, CHL, COL, COM, COD, COG, CRI, CIV, HRV, DJI, KIR, KGZ, LAO, LSO, LBR, MLI, MRT, MEX, MNG, TJK, TZA, THA, TLS, TGO, TUN, TUR, UGA, URY, UZB, VNM, ZMB, ZWE, ALB, AGO, ARG, ARM, BGD, BLR, BEN, MNE, MAR, MOZ, NAM, NIC, NER, NGA, CHN, DOM, ECU, SLV, BTN, PAK, PSE, PAN, PRY, PER, PHL, ROU, RWA, STP, SEN, SRB, SYC, SLE, BGR, KEN, SOM, ZAF, SSD, LKA, LCA, SWZ, ETH, FJI, GAB, GMB, GEO, GHA, GRD, GTM, GIN, GNB, HTI, HND, IND, IDN, KAZ, SDN, SUR, SYR, IRN, JAM, IRQ, MYS, BRB, BLZ, LBN, MUS, MDA, GNQ, RUS, NPL
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
#> 19 CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, You are free to:\nShare — copy and redistribute the material in any medium or format for any purpose, even commercially.\nAdapt — remix, transform, and build upon the material for any purpose, even commercially.\nThe licensor cannot revoke these freedoms as long as you follow the license terms.\nUnder the following terms:\nAttribution — You must give appropriate credit , provide a link to the license, and indicate if changes were made . You may do so in any reasonable manner, but not in any way that suggests the licensor endorses you or your use.\nNo additional restrictions — You may not apply legal terms or technological measures that legally restrict others from doing anything the license permits.\nNotices:\nYou do not have to comply with the license for elements of the material in the public domain or where your use is permitted by an applicable exception or limitation .\n\nNo warranties are given. The license may not give you all of the permissions necessary for your intended use. For example, other rights such as publicity, privacy, or moral rights may limit how you use the material.
#> 20                            CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 21                            CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 22                            CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 23                            CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 24                            CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 25                            CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 26                            CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 27                            CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 28                            CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 29                            CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
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
#> 19                      NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 20 DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 21 DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 22 DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 23 DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 24 DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 25 DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 26 DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 27 DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 28 DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 29 DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
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
#> 3  NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 4  NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 5  NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 6  NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 7  NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 8  NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 9  NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 10 NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 11 NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 12 NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 13                                      NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org, NA, NA
#> 14 NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 15 NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 16 NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 17 NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 18 NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 19                                                        NA, NA, NA, World Bank (WB), NA, NA, https://www.worldbank.org/, NA, NA
#> 20 NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 21 NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 22 NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 23 NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 24 NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 25                                      NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org, NA, NA
#> 26                                      NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org, NA, NA
#> 27                                      NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org, NA, NA
#> 28                                      NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org, NA, NA
#> 29 NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 30 NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 31                                      NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org, NA, NA
#> 32                                      NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org, NA, NA
#> 33                                      NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org, NA, NA
#> 34 NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
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
#> 1  WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 2  WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 3  WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 4  WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 5                                            WB_MPO, feature-dataset-profile
#> 6  WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 7  WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 8  WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 9  WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 10 WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 11 WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 12                                           WB_MPO, feature-dataset-profile
#> 13                                                                      NULL
#> 14                                                                      NULL
#> 15 WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 16 WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 17 WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 18 WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 19                                                                      NULL
#> 20                                                                      NULL
#> 21 WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 22 WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 23                                                                      NULL
#> 24                                                                      NULL
#> 25                                                                      NULL
#> 26                                                                      NULL
#> 27                                                                      NULL
#> 28                                                                      NULL
#> 29                                                                      NULL
#> 30                                                                      NULL
#> 31                                                                      NULL
#> 32                                                                      NULL
#> 33                                                                      NULL
#> 34         WB_MPO, GAFS_0008, feature-dataset-profile, feature-topic-profile
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
#> 24 primary, META_WB_WDI_NY_GDP_DEFL_ZS, WB_WDI, World Development Indicators (WDI)
#> 25                                                                            NULL
#> 26                                                                            NULL
#> 27                                                                            NULL
#> 28                                                                            NULL
#> 29    primary, META_WB_WDI_SP_POP_TOTL, WB_WDI, World Development Indicators (WDI)
#> 30 primary, META_WB_WDI_NY_GDP_PCAP_KD, WB_WDI, World Development Indicators (WDI)
#> 31                                                                            NULL
#> 32                                                                            NULL
#> 33                                                                            NULL
#> 34                                                                            NULL
#>    additional.visualization.scale_type additional.visualization.legend_type
#> 1                                 <NA>                                   NA
#> 2                            diverging                                   NA
#> 3                                 <NA>                                   NA
#> 4                                 <NA>                                   NA
#> 5                                 <NA>                                   NA
#> 6                            diverging                                   NA
#> 7                                 <NA>                                   NA
#> 8                            diverging                                   NA
#> 9                            diverging                                   NA
#> 10                                <NA>                                   NA
#> 11                                <NA>                                   NA
#> 12                                <NA>                                   NA
#> 13                                <NA>                                   NA
#> 14                                <NA>                                   NA
#> 15                                <NA>                                   NA
#> 16                                <NA>                                   NA
#> 17                                <NA>                                   NA
#> 18                           diverging                                   NA
#> 19                                <NA>                                   NA
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
#> 2                            NA, 0, NA
#> 3                                 NULL
#> 4                                 NULL
#> 5                                 NULL
#> 6                            NA, 0, NA
#> 7                                 NULL
#> 8                            NA, 0, NA
#> 9                            NA, 0, NA
#> 10                                NULL
#> 11                                NULL
#> 12                                NULL
#> 13                                NULL
#> 14                                NULL
#> 15                                NULL
#> 16                                NULL
#> 17                                NULL
#> 18                           NA, 0, NA
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
#> 1                                VINTAGE, UNIT_MEASURE, V_AM2024, V_AM2025, V_SM2024, V_SM2025, V_SM2026, PT_GDP, USD, XDC, Vintage, Unit of measure
#> 2                                     VINTAGE, UNIT_MEASURE, V_AM2024, V_AM2025, V_SM2024, V_SM2025, V_SM2026, PT_GDP, USD, Vintage, Unit of measure
#> 3                                                                                           VINTAGE, V_AM2025, V_SM2024, V_SM2025, V_SM2026, Vintage
#> 4                                                                                 VINTAGE, V_AM2024, V_AM2025, V_SM2024, V_SM2025, V_SM2026, Vintage
#> 5                                                                                           VINTAGE, V_AM2025, V_SM2024, V_SM2025, V_SM2026, Vintage
#> 6                                     VINTAGE, UNIT_MEASURE, V_AM2024, V_AM2025, V_SM2024, V_SM2025, V_SM2026, PT_GDP, USD, Vintage, Unit of measure
#> 7  PRICE_BASIS, VINTAGE, UNIT_MEASURE, K, C, V_SM2025, V_AM2025, V_SM2024, V_SM2026, V_AM2024, XDC, USD, PC_A, Price Basis, Vintage, Unit of measure
#> 8                                                                                                     VINTAGE, V_AM2024, V_SM2024, V_SM2026, Vintage
#> 9                                VINTAGE, UNIT_MEASURE, V_AM2024, V_AM2025, V_SM2024, V_SM2025, V_SM2026, PT_GDP, USD, XDC, Vintage, Unit of measure
#> 10                                                                                VINTAGE, V_AM2024, V_AM2025, V_SM2024, V_SM2025, V_SM2026, Vintage
#> 11                                                                                VINTAGE, V_AM2024, V_AM2025, V_SM2024, V_SM2025, V_SM2026, Vintage
#> 12                                                                                          VINTAGE, V_AM2025, V_SM2024, V_SM2025, V_SM2026, Vintage
#> 13 PRICE_BASIS, VINTAGE, UNIT_MEASURE, C, K, V_AM2024, V_AM2025, V_SM2024, V_SM2025, V_SM2026, PC_A, USD, XDC, Price Basis, Vintage, Unit of measure
#> 14 PRICE_BASIS, VINTAGE, UNIT_MEASURE, C, K, V_AM2025, V_SM2024, V_SM2026, V_AM2024, V_SM2025, USD, PC_A, XDC, Price Basis, Vintage, Unit of measure
#> 15                                                                                VINTAGE, V_AM2024, V_AM2025, V_SM2024, V_SM2025, V_SM2026, Vintage
#> 16 PRICE_BASIS, VINTAGE, UNIT_MEASURE, C, K, V_AM2024, V_AM2025, V_SM2024, V_SM2025, V_SM2026, PC_A, USD, XDC, Price Basis, Vintage, Unit of measure
#> 17 PRICE_BASIS, VINTAGE, UNIT_MEASURE, C, K, V_AM2024, V_AM2025, V_SM2024, V_SM2025, V_SM2026, PC_A, USD, XDC, Price Basis, Vintage, Unit of measure
#> 18 PRICE_BASIS, VINTAGE, UNIT_MEASURE, K, C, V_SM2025, V_AM2025, V_SM2026, V_SM2024, V_AM2024, XDC, USD, PC_A, Price Basis, Vintage, Unit of measure
#> 19                                                                                                                                              NULL
#> 20 PRICE_BASIS, VINTAGE, UNIT_MEASURE, C, K, V_AM2024, V_AM2025, V_SM2024, V_SM2025, V_SM2026, PC_A, USD, XDC, Price Basis, Vintage, Unit of measure
#> 21                               VINTAGE, UNIT_MEASURE, V_AM2024, V_AM2025, V_SM2024, V_SM2025, V_SM2026, PT_GDP, USD, XDC, Vintage, Unit of measure
#> 22 PRICE_BASIS, VINTAGE, UNIT_MEASURE, C, K, V_SM2025, V_AM2025, V_AM2024, V_SM2026, V_SM2024, USD, PC_A, XDC, Price Basis, Vintage, Unit of measure
#> 23 PRICE_BASIS, VINTAGE, UNIT_MEASURE, K, C, V_AM2025, V_AM2024, V_SM2025, V_SM2026, V_SM2024, USD, PC_A, XDC, Price Basis, Vintage, Unit of measure
#> 24                                                                                VINTAGE, V_AM2024, V_AM2025, V_SM2024, V_SM2025, V_SM2026, Vintage
#> 25                                                                                VINTAGE, V_AM2024, V_AM2025, V_SM2024, V_SM2025, V_SM2026, Vintage
#> 26                                  VINTAGE, UNIT_MEASURE, V_AM2024, V_AM2025, V_SM2024, V_SM2025, V_SM2026, KT_CO2E, PC_A, Vintage, Unit of measure
#> 27                       VINTAGE, UNIT_MEASURE, V_AM2024, V_AM2025, V_SM2024, V_SM2025, V_SM2026, KT_CO2E, PC_A, PT_EM_GHG, Vintage, Unit of measure
#> 28 PRICE_BASIS, VINTAGE, UNIT_MEASURE, C, K, V_SM2025, V_AM2025, V_SM2024, V_SM2026, V_AM2024, XDC, USD, PC_A, Price Basis, Vintage, Unit of measure
#> 29                                                                                VINTAGE, V_AM2024, V_AM2025, V_SM2024, V_SM2025, V_SM2026, Vintage
#> 30                                 VINTAGE, UNIT_MEASURE, V_AM2024, V_AM2025, V_SM2024, V_SM2025, V_SM2026, PC_A, USD, XDC, Vintage, Unit of measure
#> 31                                           VINTAGE, UNIT_MEASURE, V_AM2025, V_SM2024, V_SM2025, V_SM2026, PC_A, USD, XDC, Vintage, Unit of measure
#> 32                                                                                VINTAGE, V_AM2024, V_AM2025, V_SM2024, V_SM2025, V_SM2026, Vintage
#> 33                                                                                          VINTAGE, V_AM2025, V_SM2024, V_SM2025, V_SM2026, Vintage
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
#> 1                                            NULL                        NULL
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
#> 34                                pie, stackedBar GAFS_0008, NA, GAFS, NA, NA
#>            admin_metadata.gafs.tags
#> 1                              NULL
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
#> 34 GAFS_0008, feature-topic-profile
#> 
```
