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
#> 1       41.75548  META_MP_PJ_POV1 af08c7a1-873d-415a-8cdb-2656b859e9a6
#> 2       40.71597   META_GGDBTTOTL 150f9817-21ce-425b-9e0a-84a126800234
#> 3       36.88676   META_NEGDIFTOT f2bd3acf-3cc3-44eb-9ef7-efda0bdfee62
#> 4       36.84671   META_NYGDPFCST e971d916-dd08-4319-bd12-fcf00500ac8e
#> 5       35.50560   META_BFCAFTOTL b4d324f5-75bc-47d2-aa83-93362aa9d539
#> 6       35.50560   META_GGBALOVRL 859e8798-f252-4835-88b8-641859334fc2
#> 7       35.44806   META_BFCAFFFDI 8f5c7b62-ce7a-49b8-92c3-fc1fe7e64494
#> 8       34.45058  META_MP_PJ_POV3 f726b67f-e51c-4467-9937-d79e3e3edcd2
#> 9       34.34486 META_FPCPITOTLXN 4c35692b-c581-48f1-b15c-a4aa91769a9b
#> 10      34.21430   META_GGREVTOTL 2a12a3d3-d968-4294-8ebe-abdf37d48f1a
#> 11      33.92168   META_FPCPITOTL 439d46fe-8e6a-48c2-a3b0-93dbcebba565
#> 12      33.92168   META_GGEXPTOTL 045d144c-8dee-428d-bcc0-b069bfaf2f79
#> 13      32.93506  META_MP_PJ_POV2 038f91a4-373e-4518-8f30-c6fede87ce8e
#> 14      32.86073   META_GGEXPINTP 3a1a10f1-9576-4864-b37f-7472903343b3
#> 15      32.86073   META_NECONGOVT d414ecc7-c477-4328-91c6-759f3f0fd8cf
#> 16      32.86073   META_NEEXPGNFS 93b706e8-25a0-4151-89ba-e6e19c1029f7
#> 17      32.86073   META_NVAGRTOTL 8c60b15a-e28e-4b07-8344-4ca68e458aa9
#> 18      32.09888   META_BNCABFUND c51eaa5e-e1e7-40de-8eef-df8ab1f0e3de
#> 19      32.09888   META_NYGDPMKTP b40ec5aa-46b4-4236-8208-75ed056fc0b4
#> 20      31.56806   META_GGBALPRIM 7a5b5994-5d58-4f84-b9dd-745d47d41b94
#> 21      31.56806   META_NEIMPGNFS fdf4269f-a74c-492e-8839-8c08097f578c
#> 22      31.46592   META_NVINDTOTL 45fea94a-003b-40eb-94c3-83894800908c
#> 23      30.30080   META_ENATMCO2E 67f559f9-baf2-437e-9357-0c521be02fa9
#> 24      30.30080   META_ENTOTGHGE 4e9229ec-6825-46d3-9696-b47ee5236497
#> 25      29.57003   META_NECONPRVT eb28a228-e24c-4c85-a8f0-a2341ce1f653
#> 26      29.57003   META_SPPOPTOTL a4707329-948b-4afa-bdd5-80d3fc5f44ae
#> 27      29.57003   META_ENENRGHGE ac596a77-81b6-4c85-9bd4-88333895b0eb
#> 28      29.49413     META_NYGDPPC 80ca1711-e306-4de6-abc7-bd2b0ef397b6
#> 29      28.41245   META_CONPRVTPC 0cf71f79-f85f-427f-81d0-9977a81b0e94
#> 30      28.41245 META_NECONPRVTXN 33dc17d0-7388-425d-b668-747e98219bde
#> 31      28.41245  META_NEGDIFTOTK 3c05b471-da76-4f75-b873-51fa9ba29e20
#> 32      28.05600   META_NVSRVTOTL 61b904f5-3524-44bd-90dc-359483e13a21
#> 33      28.05600 META_NYGDPMKTPXN e07a12b9-2a47-4d28-bd55-f5324cd4d521
#> 34      26.99010           WB_MPO 16ffd22e-c3b6-477d-bb16-45c423263eb0
#>         type    subtype                  disaggregation_types isDelete cfPath
#> 1  indicator timeseries                               Vintage       NA     NA
#> 2  indicator timeseries              Vintage, Unit of measure       NA     NA
#> 3  indicator timeseries Price Basis, Vintage, Unit of measure       NA     NA
#> 4  indicator timeseries Price Basis, Vintage, Unit of measure       NA     NA
#> 5  indicator timeseries                               Vintage       NA     NA
#> 6  indicator timeseries              Vintage, Unit of measure       NA     NA
#> 7  indicator timeseries              Vintage, Unit of measure       NA     NA
#> 8  indicator timeseries                               Vintage       NA     NA
#> 9  indicator timeseries                               Vintage       NA     NA
#> 10 indicator timeseries                               Vintage       NA     NA
#> 11 indicator timeseries                               Vintage       NA     NA
#> 12 indicator timeseries                               Vintage       NA     NA
#> 13 indicator timeseries                               Vintage       NA     NA
#> 14 indicator timeseries                               Vintage       NA     NA
#> 15 indicator timeseries Price Basis, Vintage, Unit of measure       NA     NA
#> 16 indicator timeseries Price Basis, Vintage, Unit of measure       NA     NA
#> 17 indicator timeseries Price Basis, Vintage, Unit of measure       NA     NA
#> 18 indicator timeseries              Vintage, Unit of measure       NA     NA
#> 19 indicator timeseries Price Basis, Vintage, Unit of measure       NA     NA
#> 20 indicator timeseries              Vintage, Unit of measure       NA     NA
#> 21 indicator timeseries Price Basis, Vintage, Unit of measure       NA     NA
#> 22 indicator timeseries Price Basis, Vintage, Unit of measure       NA     NA
#> 23 indicator timeseries                               Vintage       NA     NA
#> 24 indicator timeseries              Vintage, Unit of measure       NA     NA
#> 25 indicator timeseries Price Basis, Vintage, Unit of measure       NA     NA
#> 26 indicator timeseries                               Vintage       NA     NA
#> 27 indicator timeseries              Vintage, Unit of measure       NA     NA
#> 28 indicator timeseries              Vintage, Unit of measure       NA     NA
#> 29 indicator timeseries              Vintage, Unit of measure       NA     NA
#> 30 indicator timeseries                               Vintage       NA     NA
#> 31 indicator timeseries                               Vintage       NA     NA
#> 32 indicator timeseries Price Basis, Vintage, Unit of measure       NA     NA
#> 33 indicator timeseries                               Vintage       NA     NA
#> 34   dataset       <NA>                                             NA     NA
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
#> 18       NA      stackedBar, pie                        PU
#> 19       NA      stackedBar, pie                        PU
#> 20       NA      stackedBar, pie                        PU
#> 21       NA stackedBar, pie, map                        PU
#> 22       NA stackedBar, pie, map                        PU
#> 23       NA      stackedBar, pie                        PU
#> 24       NA      stackedBar, pie                        PU
#> 25       NA stackedBar, pie, map                        PU
#> 26       NA      stackedBar, pie                        PU
#> 27       NA      stackedBar, pie                        PU
#> 28       NA      stackedBar, pie                        PU
#> 29       NA      stackedBar, pie                        PU
#> 30       NA      stackedBar, pie                        PU
#> 31       NA      stackedBar, pie                        PU
#> 32       NA stackedBar, pie, map                        PU
#> 33       NA stackedBar, pie, map                        PU
#> 34       NA                 <NA>                        PU
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
#> 29                    Public   DS_MPO       1.0.0
#> 30                    Public   DS_MPO       1.0.0
#> 31                    Public   DS_MPO       1.0.0
#> 32                    Public   DS_MPO       1.0.0
#> 33                    Public   DS_MPO       1.0.0
#> 34                    Public     <NA>        <NA>
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
#> 29 DATABASE_ID, INDICATOR, VINTAGE, AGG_METHOD, TIME_FORMAT, REF_AREA, FREQ, UNIT_MEASURE, OBS_STATUS, PRICE_BASIS, OBS_CONF, UNIT_MULT, UNIT_TYPE, DECIMALS
#> 30 DATABASE_ID, INDICATOR, VINTAGE, AGG_METHOD, TIME_FORMAT, REF_AREA, FREQ, UNIT_MEASURE, OBS_STATUS, PRICE_BASIS, OBS_CONF, UNIT_MULT, UNIT_TYPE, DECIMALS
#> 31 DATABASE_ID, INDICATOR, VINTAGE, AGG_METHOD, TIME_FORMAT, REF_AREA, FREQ, UNIT_MEASURE, OBS_STATUS, PRICE_BASIS, OBS_CONF, UNIT_MULT, UNIT_TYPE, DECIMALS
#> 32 DATABASE_ID, INDICATOR, VINTAGE, AGG_METHOD, TIME_FORMAT, REF_AREA, FREQ, UNIT_MEASURE, OBS_STATUS, PRICE_BASIS, OBS_CONF, UNIT_MULT, UNIT_TYPE, DECIMALS
#> 33 DATABASE_ID, INDICATOR, VINTAGE, AGG_METHOD, TIME_FORMAT, REF_AREA, FREQ, UNIT_MEASURE, OBS_STATUS, PRICE_BASIS, OBS_CONF, UNIT_MULT, UNIT_TYPE, DECIMALS
#> 34                                                                                                                                                          
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
#> 4                            Metadata for Gross Domestic Product (GDP) at Factor Cost
#> 5                                  Metadata for Capital and Financial Account Balance
#> 6                                                 Metadata for Overall Fiscal Balance
#> 7                                  Metadata for Net Foreign Direct Investment Outflow
#> 8  Metadata for Upper middle-income poverty rate ($6.85 in 2017 PPP), MPO projections
#> 9                                Metadata for Consumer Price Index, Implicit Deflator
#> 10                                              Metadata for Total Revenue and Grants
#> 11                                                        Metadata for Inflation Rate
#> 12                                                     Metadata for Total Expenditure
#> 13 Metadata for Lower middle-income poverty rate ($3.65 in 2017 PPP), MPO projections
#> 14                                                     Metadata for Interest Payments
#> 15                                                Metadata for Government Consumption
#> 16                          Metadata for Goods and Non-Factor Services (GNFS) Exports
#> 17                                              Metadata for Agriculture, Value Added
#> 18                                               Metadata for Current Account Balance
#> 19                          Metadata for Gross Domestic Product (GDP) at Market Price
#> 20                                                Metadata for Primary Fiscal Balance
#> 21                          Metadata for Goods and Non-Factor Services (GNFS) Imports
#> 22                                                 Metadata for Industry, Value Added
#> 23                                        Metadata for Emissions: Total CO2 emissions
#> 24                                        Metadata for Emissions: Total GHG emissions
#> 25                                                   Metadata for Private Consumption
#> 26                                           Metadata for Population, MPO Projections
#> 27                         Metadata for Emissions: Energy, fuel combustion activities
#> 28                                        Metadata for GDP per capita at Market Price
#> 29                                        Metadata for Private Consumption per capita
#> 30                                Metadata for Private Consumption, Implicit Deflator
#> 31                           Metadata for Gross Fixed Investment as percentage of GDP
#> 32                                                 Metadata for Services, Value Added
#> 33       Metadata for Gross Domestic Product (GDP) at Market Price, Implicit Deflator
#> 34                                                              Macro Poverty Outlook
#>               metadata_information.idno metadata_information.prod_date
#> 1                       META_MP_PJ_POV1                     2024-07-02
#> 2                        META_GGDBTTOTL                     2024-07-02
#> 3                        META_NEGDIFTOT                     2024-07-02
#> 4                        META_NYGDPFCST                     2024-07-02
#> 5                        META_BFCAFTOTL                     2024-07-02
#> 6                        META_GGBALOVRL                     2024-07-02
#> 7                        META_BFCAFFFDI                     2024-07-02
#> 8                       META_MP_PJ_POV3                     2024-07-02
#> 9                      META_FPCPITOTLXN                     2024-07-02
#> 10                       META_GGREVTOTL                     2024-07-02
#> 11                       META_FPCPITOTL                     2024-07-02
#> 12                       META_GGEXPTOTL                     2024-07-02
#> 13                      META_MP_PJ_POV2                     2024-07-02
#> 14                       META_GGEXPINTP                     2024-07-02
#> 15                       META_NECONGOVT                     2024-07-02
#> 16                       META_NEEXPGNFS                     2024-07-02
#> 17                       META_NVAGRTOTL                     2024-07-02
#> 18                       META_BNCABFUND                     2024-07-02
#> 19                       META_NYGDPMKTP                     2024-07-02
#> 20                       META_GGBALPRIM                     2024-07-02
#> 21                       META_NEIMPGNFS                     2024-07-02
#> 22                       META_NVINDTOTL                     2024-07-02
#> 23                       META_ENATMCO2E                     2024-07-02
#> 24                       META_ENTOTGHGE                     2024-07-02
#> 25                       META_NECONPRVT                     2024-07-02
#> 26                       META_SPPOPTOTL                     2024-07-02
#> 27                       META_ENENRGHGE                     2024-07-02
#> 28                         META_NYGDPPC                     2024-07-02
#> 29                       META_CONPRVTPC                     2024-07-02
#> 30                     META_NECONPRVTXN                     2024-07-02
#> 31                      META_NEGDIFTOTK                     2024-07-02
#> 32                       META_NVSRVTOTL                     2024-07-02
#> 33                     META_NYGDPMKTPXN                     2024-07-02
#> 34 16ffd22e-c3b6-477d-bb16-45c423263eb0                           <NA>
#>    metadata_information.version_statement.version
#> 1                                            <NA>
#> 2                                            <NA>
#> 3                                            <NA>
#> 4                                            <NA>
#> 5                                            <NA>
#> 6                                            <NA>
#> 7                                            <NA>
#> 8                                            <NA>
#> 9                                            <NA>
#> 10                                           <NA>
#> 11                                           <NA>
#> 12                                            1.1
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
#> 1                                           2026-10-14
#> 2                                           2026-10-14
#> 3                                           2026-10-14
#> 4                                           2026-10-14
#> 5                                           2026-10-14
#> 6                                           2026-10-14
#> 7                                           2026-10-14
#> 8                                           2026-10-14
#> 9                                           2026-10-14
#> 10                                          2026-10-14
#> 11                                          2026-10-14
#> 12                                          2026-10-14
#> 13                                          2026-10-14
#> 14                                          2026-10-14
#> 15                                          2026-10-14
#> 16                                          2026-10-14
#> 17                                          2026-10-14
#> 18                                          2026-10-14
#> 19                                          2026-10-14
#> 20                                          2026-10-14
#> 21                                          2026-10-14
#> 22                                          2026-10-14
#> 23                                          2026-10-14
#> 24                                          2026-10-14
#> 25                                          2026-10-14
#> 26                                          2026-10-14
#> 27                                          2026-10-14
#> 28                                          2026-10-14
#> 29                                          2026-10-14
#> 30                                          2026-10-14
#> 31                                          2026-10-14
#> 32                                          2026-10-14
#> 33                                          2026-10-14
#> 34                                                <NA>
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
#> 29 Metadata updated by automated Data360 publishing pipeline
#> 30 Metadata updated by automated Data360 publishing pipeline
#> 31 Metadata updated by automated Data360 publishing pipeline
#> 32 Metadata updated by automated Data360 publishing pipeline
#> 33 Metadata updated by automated Data360 publishing pipeline
#> 34                                                      <NA>
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
#> 29 Development Economics Data Group, DECDG, World Bank, NA
#> 30 Development Economics Data Group, DECDG, World Bank, NA
#> 31 Development Economics Data Group, DECDG, World Bank, NA
#> 32 Development Economics Data Group, DECDG, World Bank, NA
#> 33 Development Economics Data Group, DECDG, World Bank, NA
#> 34                                                    NULL
#>    series_description.idno series_description.doi
#> 1               MP_PJ_POV1                     NA
#> 2                GGDBTTOTL                     NA
#> 3                NEGDIFTOT                     NA
#> 4                NYGDPFCST                     NA
#> 5                BFCAFTOTL                     NA
#> 6                GGBALOVRL                     NA
#> 7                BFCAFFFDI                     NA
#> 8               MP_PJ_POV3                     NA
#> 9              FPCPITOTLXN                     NA
#> 10               GGREVTOTL                     NA
#> 11               FPCPITOTL                     NA
#> 12               GGEXPTOTL                     NA
#> 13              MP_PJ_POV2                     NA
#> 14               GGEXPINTP                     NA
#> 15               NECONGOVT                     NA
#> 16               NEEXPGNFS                     NA
#> 17               NVAGRTOTL                     NA
#> 18               BNCABFUND                     NA
#> 19               NYGDPMKTP                     NA
#> 20               GGBALPRIM                     NA
#> 21               NEIMPGNFS                     NA
#> 22               NVINDTOTL                     NA
#> 23               ENATMCO2E                     NA
#> 24               ENTOTGHGE                     NA
#> 25               NECONPRVT                     NA
#> 26               SPPOPTOTL                     NA
#> 27               ENENRGHGE                     NA
#> 28                 NYGDPPC                     NA
#> 29               CONPRVTPC                     NA
#> 30             NECONPRVTXN                     NA
#> 31              NEGDIFTOTK                     NA
#> 32               NVSRVTOTL                     NA
#> 33             NYGDPMKTPXN                     NA
#> 34                    <NA>                     NA
#>                                                  series_description.name
#> 1        International poverty rate ($2.15 in 2017 PPP), MPO projections
#> 2                                          General Government Debt Stock
#> 3                                                 Gross Fixed Investment
#> 4                            Gross Domestic Product (GDP) at Factor Cost
#> 5                                  Capital and Financial Account Balance
#> 6                                                 Overall Fiscal Balance
#> 7                                  Net Foreign Direct Investment Outflow
#> 8  Upper middle-income poverty rate ($6.85 in 2017 PPP), MPO projections
#> 9                                Consumer Price Index, Implicit Deflator
#> 10                                              Total Revenue and Grants
#> 11                                                        Inflation Rate
#> 12                                                     Total Expenditure
#> 13 Lower middle-income poverty rate ($3.65 in 2017 PPP), MPO projections
#> 14                                                     Interest Payments
#> 15                                                Government Consumption
#> 16                          Goods and Non-Factor Services (GNFS) Exports
#> 17                                              Agriculture, Value Added
#> 18                                               Current Account Balance
#> 19                          Gross Domestic Product (GDP) at Market Price
#> 20                                                Primary Fiscal Balance
#> 21                          Goods and Non-Factor Services (GNFS) Imports
#> 22                                                 Industry, Value Added
#> 23                                        Emissions: Total CO2 emissions
#> 24                                        Emissions: Total GHG emissions
#> 25                                                   Private Consumption
#> 26                                           Population, MPO Projections
#> 27                         Emissions: Energy, fuel combustion activities
#> 28                                        GDP per capita at Market Price
#> 29                                        Private Consumption per capita
#> 30                                Private Consumption, Implicit Deflator
#> 31                           Gross Fixed Investment as percentage of GDP
#> 32                                                 Services, Value Added
#> 33       Gross Domestic Product (GDP) at Market Price, Implicit Deflator
#> 34                                                 Macro Poverty Outlook
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
#> 29                           WB_MPO                                <NA>
#> 30                           WB_MPO                                <NA>
#> 31                           WB_MPO                                <NA>
#> 32                           WB_MPO                                <NA>
#> 33                           WB_MPO                                <NA>
#> 34            Macro Poverty Outlook                          2026-10-14
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
#> 4        US dollars (Millions), Domestic currency (Millions), Percentage change per annum
#> 5                                                                   US dollars (Millions)
#> 6                  Domestic currency (Millions), Percentage of GDP, US dollars (Millions)
#> 7                                                Percentage of GDP, US dollars (Millions)
#> 8                                                                Percentage of population
#> 9                                                                                   Index
#> 10                                                                  US dollars (Millions)
#> 11                                                            Percentage change per annum
#> 12                                                                  US dollars (Millions)
#> 13                                                               Percentage of population
#> 14                                                           Domestic currency (Millions)
#> 15       Percentage change per annum, Domestic currency (Millions), US dollars (Millions)
#> 16       Domestic currency (Millions), Percentage change per annum, US dollars (Millions)
#> 17       Percentage change per annum, Domestic currency (Millions), US dollars (Millions)
#> 18                                               Percentage of GDP, US dollars (Millions)
#> 19       US dollars (Millions), Domestic currency (Millions), Percentage change per annum
#> 20                 US dollars (Millions), Percentage of GDP, Domestic currency (Millions)
#> 21       Percentage change per annum, US dollars (Millions), Domestic currency (Millions)
#> 22       Domestic currency (Millions), Percentage change per annum, US dollars (Millions)
#> 23                                                                      Kilotonnes of CO2
#> 24                              Percentage change per annum, Kilotonnes of CO2-equivalent
#> 25       Percentage change per annum, Domestic currency (Millions), US dollars (Millions)
#> 26                                                                     Persons (Millions)
#> 27 Percentage change per annum, Kilotonnes of CO2-equivalent, Percentage of GHG emissions
#> 28       US dollars (Millions), Percentage change per annum, Domestic currency (Millions)
#> 29       Domestic currency (Millions), US dollars (Millions), Percentage change per annum
#> 30                                                                                  Index
#> 31                                                                      Percentage of GDP
#> 32       US dollars (Millions), Domestic currency (Millions), Percentage change per annum
#> 33                                                                                  Index
#> 34                                                                                   <NA>
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
#> 29                                                 <NA>
#> 30                                                 <NA>
#> 31                                                 <NA>
#> 32                                                 <NA>
#> 33                                                 <NA>
#> 34 {"update_schedule":null,"update_frequency":"annual"}
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
#> 29                         Annual                             NA
#> 30                         Annual                             NA
#> 31                         Annual                             NA
#> 32                         Annual                             NA
#> 33                         Annual                             NA
#> 34                           <NA>                             NA
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
#> 29                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 30                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 31                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 32                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 33                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 34 The Macro Poverty Outlook (MPO) analyzes macroeconomic and poverty developments in 147 developing countries. The report is released twice annually for the Spring and Annual Meetings of the World Bank and the International Monetary Fund. The MPO consists of individual country notes that provide an overview of recent developments, forecasts of major macroeconomic variables and poverty during 2024-2026, and a discussion of critical challenges for economic growth, macroeconomic stability, and poverty reduction moving forward.\n\nFor further details, please refer to https://www.worldbank.org/en/publication/macro-poverty-outlook
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
#> 29 Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 30 Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 31 Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 32 Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 33 Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 34                                                                                          <NA>
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
#> 29 You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 30 You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 31 You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 32 You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 33 You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 34                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              <NA>
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
#> 29                                        PU
#> 30                                        PU
#> 31                                        PU
#> 32                                        PU
#> 33                                        PU
#> 34                                      <NA>
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
#> 29 https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 30 https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 31 https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 32 https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 33 https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 34                                                               <NA>
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
#> 29                                                                                                                                  <NA>
#> 30                                                                                                                                  <NA>
#> 31                                                                                                                                  <NA>
#> 32                                                                                                                                  <NA>
#> 33                                                                                                                                  <NA>
#> 34 World Bank. (Year). Macro Poverty Outlook. Washington, DC: World Bank. https://www.worldbank.org/en/publication/macro-poverty-outlook
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
#> 29                            NA                                 NA
#> 30                            NA                                 NA
#> 31                            NA                                 NA
#> 32                            NA                                 NA
#> 33                            NA                                 NA
#> 34                            NA                                150
#>                                                    series_description.csv_link
#> 1   https://data360files.worldbank.org/data360-data/data/WB_MPO/MP_PJ_POV1.csv
#> 2    https://data360files.worldbank.org/data360-data/data/WB_MPO/GGDBTTOTL.csv
#> 3    https://data360files.worldbank.org/data360-data/data/WB_MPO/NEGDIFTOT.csv
#> 4    https://data360files.worldbank.org/data360-data/data/WB_MPO/NYGDPFCST.csv
#> 5    https://data360files.worldbank.org/data360-data/data/WB_MPO/BFCAFTOTL.csv
#> 6    https://data360files.worldbank.org/data360-data/data/WB_MPO/GGBALOVRL.csv
#> 7    https://data360files.worldbank.org/data360-data/data/WB_MPO/BFCAFFFDI.csv
#> 8   https://data360files.worldbank.org/data360-data/data/WB_MPO/MP_PJ_POV3.csv
#> 9  https://data360files.worldbank.org/data360-data/data/WB_MPO/FPCPITOTLXN.csv
#> 10   https://data360files.worldbank.org/data360-data/data/WB_MPO/GGREVTOTL.csv
#> 11   https://data360files.worldbank.org/data360-data/data/WB_MPO/FPCPITOTL.csv
#> 12   https://data360files.worldbank.org/data360-data/data/WB_MPO/GGEXPTOTL.csv
#> 13  https://data360files.worldbank.org/data360-data/data/WB_MPO/MP_PJ_POV2.csv
#> 14   https://data360files.worldbank.org/data360-data/data/WB_MPO/GGEXPINTP.csv
#> 15   https://data360files.worldbank.org/data360-data/data/WB_MPO/NECONGOVT.csv
#> 16   https://data360files.worldbank.org/data360-data/data/WB_MPO/NEEXPGNFS.csv
#> 17   https://data360files.worldbank.org/data360-data/data/WB_MPO/NVAGRTOTL.csv
#> 18   https://data360files.worldbank.org/data360-data/data/WB_MPO/BNCABFUND.csv
#> 19   https://data360files.worldbank.org/data360-data/data/WB_MPO/NYGDPMKTP.csv
#> 20   https://data360files.worldbank.org/data360-data/data/WB_MPO/GGBALPRIM.csv
#> 21   https://data360files.worldbank.org/data360-data/data/WB_MPO/NEIMPGNFS.csv
#> 22   https://data360files.worldbank.org/data360-data/data/WB_MPO/NVINDTOTL.csv
#> 23   https://data360files.worldbank.org/data360-data/data/WB_MPO/ENATMCO2E.csv
#> 24   https://data360files.worldbank.org/data360-data/data/WB_MPO/ENTOTGHGE.csv
#> 25   https://data360files.worldbank.org/data360-data/data/WB_MPO/NECONPRVT.csv
#> 26   https://data360files.worldbank.org/data360-data/data/WB_MPO/SPPOPTOTL.csv
#> 27   https://data360files.worldbank.org/data360-data/data/WB_MPO/ENENRGHGE.csv
#> 28     https://data360files.worldbank.org/data360-data/data/WB_MPO/NYGDPPC.csv
#> 29   https://data360files.worldbank.org/data360-data/data/WB_MPO/CONPRVTPC.csv
#> 30 https://data360files.worldbank.org/data360-data/data/WB_MPO/NECONPRVTXN.csv
#> 31  https://data360files.worldbank.org/data360-data/data/WB_MPO/NEGDIFTOTK.csv
#> 32   https://data360files.worldbank.org/data360-data/data/WB_MPO/NVSRVTOTL.csv
#> 33 https://data360files.worldbank.org/data360-data/data/WB_MPO/NYGDPMKTPXN.csv
#> 34      https://data360files.worldbank.org/data360-data/data/WB_MPO/WB_MPO.csv
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
#> 4    https://data360files.worldbank.org/data360-data/metadata/WB_MPO/NYGDPFCST.json
#> 5    https://data360files.worldbank.org/data360-data/metadata/WB_MPO/BFCAFTOTL.json
#> 6    https://data360files.worldbank.org/data360-data/metadata/WB_MPO/GGBALOVRL.json
#> 7    https://data360files.worldbank.org/data360-data/metadata/WB_MPO/BFCAFFFDI.json
#> 8   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/MP_PJ_POV3.json
#> 9  https://data360files.worldbank.org/data360-data/metadata/WB_MPO/FPCPITOTLXN.json
#> 10   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/GGREVTOTL.json
#> 11   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/FPCPITOTL.json
#> 12   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/GGEXPTOTL.json
#> 13  https://data360files.worldbank.org/data360-data/metadata/WB_MPO/MP_PJ_POV2.json
#> 14   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/GGEXPINTP.json
#> 15   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/NECONGOVT.json
#> 16   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/NEEXPGNFS.json
#> 17   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/NVAGRTOTL.json
#> 18   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/BNCABFUND.json
#> 19   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/NYGDPMKTP.json
#> 20   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/GGBALPRIM.json
#> 21   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/NEIMPGNFS.json
#> 22   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/NVINDTOTL.json
#> 23   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/ENATMCO2E.json
#> 24   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/ENTOTGHGE.json
#> 25   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/NECONPRVT.json
#> 26   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/SPPOPTOTL.json
#> 27   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/ENENRGHGE.json
#> 28     https://data360files.worldbank.org/data360-data/metadata/WB_MPO/NYGDPPC.json
#> 29   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/CONPRVTPC.json
#> 30 https://data360files.worldbank.org/data360-data/metadata/WB_MPO/NECONPRVTXN.json
#> 31  https://data360files.worldbank.org/data360-data/metadata/WB_MPO/NEGDIFTOTK.json
#> 32   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/NVSRVTOTL.json
#> 33 https://data360files.worldbank.org/data360-data/metadata/WB_MPO/NYGDPMKTPXN.json
#> 34      https://data360files.worldbank.org/data360-data/datasetmetadata/WB_MPO.json
#>                                                                               series_description.api_link
#> 1   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=MP_PJ_POV1
#> 2    https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=GGDBTTOTL
#> 3    https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=NEGDIFTOT
#> 4    https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=NYGDPFCST
#> 5    https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=BFCAFTOTL
#> 6    https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=GGBALOVRL
#> 7    https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=BFCAFFFDI
#> 8   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=MP_PJ_POV3
#> 9  https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=FPCPITOTLXN
#> 10   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=GGREVTOTL
#> 11   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=FPCPITOTL
#> 12   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=GGEXPTOTL
#> 13  https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=MP_PJ_POV2
#> 14   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=GGEXPINTP
#> 15   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=NECONGOVT
#> 16   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=NEEXPGNFS
#> 17   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=NVAGRTOTL
#> 18   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=BNCABFUND
#> 19   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=NYGDPMKTP
#> 20   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=GGBALPRIM
#> 21   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=NEIMPGNFS
#> 22   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=NVINDTOTL
#> 23   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=ENATMCO2E
#> 24   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=ENTOTGHGE
#> 25   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=NECONPRVT
#> 26   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=SPPOPTOTL
#> 27   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=ENENRGHGE
#> 28     https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=NYGDPPC
#> 29   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=CONPRVTPC
#> 30 https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=NECONPRVTXN
#> 31  https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=NEGDIFTOTK
#> 32   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=NVSRVTOTL
#> 33 https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=NYGDPMKTPXN
#> 34                       https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO
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
#> 29                                 NA                                 NA
#> 30                                 NA                                 NA
#> 31                                 NA                                 NA
#> 32                                 NA                                 NA
#> 33                                 NA                                 NA
#> 34                                 33                                 NA
#>                                                                           series_description.api_explorer_link
#> 1   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=MP_PJ_POV1
#> 2    http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=GGDBTTOTL
#> 3    http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=NEGDIFTOT
#> 4    http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=NYGDPFCST
#> 5    http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=BFCAFTOTL
#> 6    http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=GGBALOVRL
#> 7    http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=BFCAFFFDI
#> 8   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=MP_PJ_POV3
#> 9  http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=FPCPITOTLXN
#> 10   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=GGREVTOTL
#> 11   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=FPCPITOTL
#> 12   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=GGEXPTOTL
#> 13  http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=MP_PJ_POV2
#> 14   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=GGEXPINTP
#> 15   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=NECONGOVT
#> 16   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=NEEXPGNFS
#> 17   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=NVAGRTOTL
#> 18   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=BNCABFUND
#> 19   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=NYGDPMKTP
#> 20   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=GGBALPRIM
#> 21   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=NEIMPGNFS
#> 22   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=NVINDTOTL
#> 23   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=ENATMCO2E
#> 24   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=ENTOTGHGE
#> 25   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=NECONPRVT
#> 26   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=SPPOPTOTL
#> 27   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=ENENRGHGE
#> 28     http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=NYGDPPC
#> 29   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=CONPRVTPC
#> 30 http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=NECONPRVTXN
#> 31  http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=NEGDIFTOTK
#> 32   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=NVSRVTOTL
#> 33 http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=NYGDPMKTPXN
#> 34                       http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO
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
#> 1                                         2026-10-14
#> 2                                         2026-10-14
#> 3                                         2026-10-14
#> 4                                         2026-10-14
#> 5                                         2026-10-14
#> 6                                         2026-10-14
#> 7                                         2026-10-14
#> 8                                         2026-10-14
#> 9                                         2026-10-14
#> 10                                        2026-10-14
#> 11                                        2026-10-14
#> 12                                        2026-10-14
#> 13                                        2026-10-14
#> 14                                        2026-10-14
#> 15                                        2026-10-14
#> 16                                        2026-10-14
#> 17                                        2026-10-14
#> 18                                        2026-10-14
#> 19                                        2026-10-14
#> 20                                        2026-10-14
#> 21                                        2026-10-14
#> 22                                        2026-10-14
#> 23                                        2026-10-14
#> 24                                        2026-10-14
#> 25                                        2026-10-14
#> 26                                        2026-10-14
#> 27                                        2026-10-14
#> 28                                        2026-10-14
#> 29                                        2026-10-14
#> 30                                        2026-10-14
#> 31                                        2026-10-14
#> 32                                        2026-10-14
#> 33                                        2026-10-14
#> 34                                              <NA>
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
#> 4    EFIDATA360_IND_ID, WB.MPO.NYGDPFCSTCD, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 5    EFIDATA360_IND_ID, WB.MPO.BFCAFTOTLCD, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 6    EFIDATA360_IND_ID, WB.MPO.GGBALOVRLCD, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 7    EFIDATA360_IND_ID, WB.MPO.BFCAFFFDICD, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 8           EFIDATA360_IND_ID, WB.MPO.POV3, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 9    EFIDATA360_IND_ID, WB.MPO.FPCPITOTLXN, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 10   EFIDATA360_IND_ID, WB.MPO.GGREVTOTLCD, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 11  EFIDATA360_IND_ID, WB.MPO.FPCPITOTLXNZ, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 12   EFIDATA360_IND_ID, WB.MPO.GGEXPTOTLCD, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 13          EFIDATA360_IND_ID, WB.MPO.POV2, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 14   EFIDATA360_IND_ID, WB.MPO.GGEXPINTPCN, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 15   EFIDATA360_IND_ID, WB.MPO.NECONGOVTCN, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 16   EFIDATA360_IND_ID, WB.MPO.NEEXPGNFSCN, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 17   EFIDATA360_IND_ID, WB.MPO.NVAGRTOTLCN, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 18   EFIDATA360_IND_ID, WB.MPO.BNCABFUNDCD, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 19   EFIDATA360_IND_ID, WB.MPO.NYGDPMKTPCD, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 20   EFIDATA360_IND_ID, WB.MPO.GGBALPRIMCD, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 21   EFIDATA360_IND_ID, WB.MPO.NEIMPGNFSCN, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 22   EFIDATA360_IND_ID, WB.MPO.NVINDTOTLCN, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 23   EFIDATA360_IND_ID, WB.MPO.ENATMCO2EKT, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 24   EFIDATA360_IND_ID, WB.MPO.ENTOTGHGEKT, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 25   EFIDATA360_IND_ID, WB.MPO.NECONPRVTCN, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 26     EFIDATA360_IND_ID, WB.MPO.SPPOPTOTL, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 27   EFIDATA360_IND_ID, WB.MPO.ENENRGHGEKT, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 28     EFIDATA360_IND_ID, WB.MPO.NYGDPPCKD, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 29 EFIDATA360_IND_ID, WB.MPO.NECONPRVTPCKD, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 30   EFIDATA360_IND_ID, WB.MPO.NECONPRVTXN, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 31  EFIDATA360_IND_ID, WB.MPO.NEGDIFTOTKD_, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 32   EFIDATA360_IND_ID, WB.MPO.NVSRVTOTLCN, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 33   EFIDATA360_IND_ID, WB.MPO.NYGDPMKTPXN, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 34                                                                                                            NULL
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
#> 29                  English, EN
#> 30                  English, EN
#> 31                  English, EN
#> 32                  English, EN
#> 33                  English, EN
#> 34                         NULL
#>                                                                                                                                                                                           series_description.dimensions
#> 1                                                                                                               NA, NA, NA, NA, Geographic area, Time period, Price Basis, Vintage, Country/economy, Region, NA, NA, NA
#> 2                                        NA, NA, NA, NA, NA, Time period, Price Basis, Vintage, Geographic area, Unit of measure, NA, NA, NA, Country/economy, Region, Domestic currency, Percentage of GDP, US dollars
#> 3                              NA, NA, NA, NA, NA, Time period, Price Basis, Vintage, Geographic area, Unit of measure, NA, NA, NA, Country/economy, Region, Domestic currency, Percentage change per annum, US dollars
#> 4                              NA, NA, NA, NA, NA, Time period, Price Basis, Vintage, Geographic area, Unit of measure, NA, NA, NA, Country/economy, Region, Domestic currency, Percentage change per annum, US dollars
#> 5                                                                                                               NA, NA, NA, NA, Geographic area, Time period, Price Basis, Vintage, Country/economy, Region, NA, NA, NA
#> 6                                        NA, NA, NA, NA, NA, Time period, Price Basis, Vintage, Geographic area, Unit of measure, NA, NA, NA, Country/economy, Region, Domestic currency, Percentage of GDP, US dollars
#> 7                                                           NA, NA, NA, NA, NA, Time period, Price Basis, Vintage, Unit of measure, Geographic area, NA, NA, NA, Percentage of GDP, US dollars, Country/economy, Region
#> 8                                                                                                               NA, NA, NA, NA, Geographic area, Time period, Price Basis, Vintage, Country/economy, Region, NA, NA, NA
#> 9                                                                                                               NA, NA, NA, NA, Geographic area, Time period, Price Basis, Vintage, Country/economy, Region, NA, NA, NA
#> 10                                                                                                              NA, NA, NA, NA, Geographic area, Time period, Price Basis, Vintage, Country/economy, Region, NA, NA, NA
#> 11                                                                                                              NA, NA, NA, NA, Geographic area, Time period, Price Basis, Vintage, Country/economy, Region, NA, NA, NA
#> 12                                                                                                              NA, NA, NA, NA, Geographic area, Time period, Price Basis, Vintage, Country/economy, Region, NA, NA, NA
#> 13                                                                                                              NA, NA, NA, NA, Geographic area, Time period, Price Basis, Vintage, Country/economy, Region, NA, NA, NA
#> 14                                                                                                              NA, NA, NA, NA, Geographic area, Time period, Price Basis, Vintage, Country/economy, Region, NA, NA, NA
#> 15                             NA, NA, NA, NA, NA, Time period, Price Basis, Vintage, Geographic area, Unit of measure, NA, NA, NA, Country/economy, Region, Domestic currency, Percentage change per annum, US dollars
#> 16                             NA, NA, NA, NA, NA, Time period, Price Basis, Vintage, Geographic area, Unit of measure, NA, NA, NA, Country/economy, Region, Domestic currency, Percentage change per annum, US dollars
#> 17                             NA, NA, NA, NA, NA, Time period, Price Basis, Vintage, Geographic area, Unit of measure, NA, NA, NA, Country/economy, Region, Domestic currency, Percentage change per annum, US dollars
#> 18                                                          NA, NA, NA, NA, NA, Time period, Price Basis, Vintage, Unit of measure, Geographic area, NA, NA, NA, Percentage of GDP, US dollars, Country/economy, Region
#> 19                             NA, NA, NA, NA, NA, Time period, Price Basis, Vintage, Geographic area, Unit of measure, NA, NA, NA, Country/economy, Region, Domestic currency, Percentage change per annum, US dollars
#> 20                                       NA, NA, NA, NA, NA, Time period, Price Basis, Vintage, Geographic area, Unit of measure, NA, NA, NA, Country/economy, Region, Domestic currency, Percentage of GDP, US dollars
#> 21                             NA, NA, NA, NA, NA, Time period, Price Basis, Vintage, Geographic area, Unit of measure, NA, NA, NA, Country/economy, Region, Domestic currency, Percentage change per annum, US dollars
#> 22                             NA, NA, NA, NA, NA, Time period, Price Basis, Vintage, Geographic area, Unit of measure, NA, NA, NA, Country/economy, Region, Domestic currency, Percentage change per annum, US dollars
#> 23                                                                                                              NA, NA, NA, NA, Geographic area, Time period, Price Basis, Vintage, Country/economy, Region, NA, NA, NA
#> 24                              NA, NA, NA, NA, NA, Unit of measure, Time period, Price Basis, Vintage, Geographic area, Kilotonnes of CO2-equivalent, Percentage change per annum, NA, NA, NA, Country/economy, Region
#> 25                             NA, NA, NA, NA, NA, Time period, Price Basis, Vintage, Geographic area, Unit of measure, NA, NA, NA, Country/economy, Region, Domestic currency, Percentage change per annum, US dollars
#> 26                                                                                                              NA, NA, NA, NA, Geographic area, Time period, Price Basis, Vintage, Country/economy, Region, NA, NA, NA
#> 27 NA, NA, NA, NA, NA, Time period, Price Basis, Vintage, Geographic area, Unit of measure, NA, NA, NA, Country/economy, Region, Kilotonnes of CO2-equivalent, Percentage change per annum, Percentage of GHG emissions
#> 28                             NA, NA, NA, NA, NA, Time period, Price Basis, Vintage, Geographic area, Unit of measure, NA, NA, NA, Country/economy, Region, Domestic currency, Percentage change per annum, US dollars
#> 29                             NA, NA, NA, NA, NA, Time period, Price Basis, Vintage, Geographic area, Unit of measure, NA, NA, NA, Country/economy, Region, Domestic currency, Percentage change per annum, US dollars
#> 30                                                                                                              NA, NA, NA, NA, Geographic area, Time period, Price Basis, Vintage, Country/economy, Region, NA, NA, NA
#> 31                                                                                                              NA, NA, NA, NA, Geographic area, Time period, Price Basis, Vintage, Country/economy, Region, NA, NA, NA
#> 32                             NA, NA, NA, NA, NA, Time period, Price Basis, Vintage, Geographic area, Unit of measure, NA, NA, NA, Country/economy, Region, Domestic currency, Percentage change per annum, US dollars
#> 33                                                                                                              NA, NA, NA, NA, Geographic area, Time period, Price Basis, Vintage, Country/economy, Region, NA, NA, NA
#> 34                                                                                                                                                                                                                 NULL
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
#> 29 Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 30 Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 31 Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 32 Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 33 Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 34                                                                                      NULL
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
#> 4                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  P3, P3_000001, P3_000007, Prosperity, Economic Policy, Growth and Jobs, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 5                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         P3, P3_000001, P3_000009, Prosperity, Economic Policy, Macro-financial Policies, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 6                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    P3, P3_000001, P3_000008, Prosperity, Economic Policy, Fiscal Policy, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 7                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         P3, P3_000001, P3_000009, Prosperity, Economic Policy, Macro-financial Policies, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 8                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  P3, P3_000004, P3_000020, Prosperity, Poverty, Poverty, NA, P3, P3_000004, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 9                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         P3, P3_000001, P3_000009, Prosperity, Economic Policy, Macro-financial Policies, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 10                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   P3, P3_000001, P3_000008, Prosperity, Economic Policy, Fiscal Policy, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 11                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        P3, P3_000001, P3_000009, Prosperity, Economic Policy, Macro-financial Policies, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 12                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   P3, P3_000001, P3_000008, Prosperity, Economic Policy, Fiscal Policy, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 13                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 P3, P3_000004, P3_000020, Prosperity, Poverty, Poverty, NA, P3, P3_000004, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 14                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   P3, P3_000001, P3_000008, Prosperity, Economic Policy, Fiscal Policy, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 15                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   P3, P3_000001, P3_000008, Prosperity, Economic Policy, Fiscal Policy, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 16                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            P3, P3_000006, P3_000028, Prosperity, Trade, Investment and Competitiveness, Trade Outcomes, NA, P3, P3_000006, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 17                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 P3, P3_000001, P3_000007, Prosperity, Economic Policy, Growth and Jobs, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 18                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        P3, P3_000001, P3_000009, Prosperity, Economic Policy, Macro-financial Policies, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 19                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 P3, P3_000001, P3_000007, Prosperity, Economic Policy, Growth and Jobs, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 20                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   P3, P3_000001, P3_000008, Prosperity, Economic Policy, Fiscal Policy, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 21                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            P3, P3_000006, P3_000028, Prosperity, Trade, Investment and Competitiveness, Trade Outcomes, NA, P3, P3_000006, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 22                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 P3, P3_000001, P3_000007, Prosperity, Economic Policy, Growth and Jobs, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 23                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 P3, P3_000001, P3_000007, Prosperity, Economic Policy, Growth and Jobs, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 24                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 P3, P3_000001, P3_000007, Prosperity, Economic Policy, Growth and Jobs, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 25                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 P3, P3_000001, P3_000007, Prosperity, Economic Policy, Growth and Jobs, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 26                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    P3, Prosperity, NA, WB Practice Groups, NA
#> 27                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 P3, P3_000001, P3_000007, Prosperity, Economic Policy, Growth and Jobs, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 28                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 P3, P3_000001, P3_000007, Prosperity, Economic Policy, Growth and Jobs, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 29                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 P3, P3_000001, P3_000007, Prosperity, Economic Policy, Growth and Jobs, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 30                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 P3, P3_000001, P3_000007, Prosperity, Economic Policy, Growth and Jobs, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 31                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   P3, P3_000001, P3_000008, Prosperity, Economic Policy, Fiscal Policy, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 32                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 P3, P3_000001, P3_000007, Prosperity, Economic Policy, Growth and Jobs, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 33                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 P3, P3_000001, P3_000007, Prosperity, Economic Policy, Growth and Jobs, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 34 P3, P3_000001, P3_000006, P3_000004, P3_000007, P3_000008, P3_000009, P3_000020, P3_000028, Prosperity, Economic Policy, Trade, Investment and Competitiveness, Poverty, Growth and Jobs, Fiscal Policy, Macro-financial Policies, Poverty, Trade Outcomes, NA, P3, P3, P3, P3_000001, P3_000001, P3_000001, P3_000004, P3_000006, WB Practice Groups, Data360 Topic L1, Data360 Topic L1, Data360 Topic L1, Data360 Topic L2, Data360 Topic L2, Data360 Topic L2, Data360 Topic L2, Data360 Topic L2, https://fmr.worldbank.org/FMR/sdmx/v2/structure/codelist/WB.DATA360/CL_D360_TOPICS/1.0, https://fmr.worldbank.org/FMR/sdmx/v2/structure/hierarchy/WB.DATA360/H_D360_TOPICS/1.0, https://fmr.worldbank.org/FMR/sdmx/v2/structure/hierarchy/WB.DATA360/H_D360_TOPICS/1.0, https://fmr.worldbank.org/FMR/sdmx/v2/structure/hierarchy/WB.DATA360/H_D360_TOPICS/1.0, https://fmr.worldbank.org/FMR/sdmx/v2/structure/hierarchy/WB.DATA360/H_D360_TOPICS/1.0, https://fmr.worldbank.org/FMR/sdmx/v2/structure/hierarchy/WB.DATA360/H_D360_TOPICS/1.0, https://fmr.worldbank.org/FMR/sdmx/v2/structure/hierarchy/WB.DATA360/H_D360_TOPICS/1.0, https://fmr.worldbank.org/FMR/sdmx/v2/structure/hierarchy/WB.DATA360/H_D360_TOPICS/1.0, https://fmr.worldbank.org/FMR/sdmx/v2/structure/hierarchy/WB.DATA360/H_D360_TOPICS/1.0
#>    series_description.time_periods
#> 1                   2010, 2028, NA
#> 2                   1980, 2028, NA
#> 3                   1980, 2028, NA
#> 4                   1980, 2028, NA
#> 5                   1980, 2026, NA
#> 6                   1980, 2028, NA
#> 7                   1980, 2028, NA
#> 8                   2010, 2028, NA
#> 9                   1980, 2028, NA
#> 10                  1980, 2028, NA
#> 11                  1981, 2028, NA
#> 12                  1980, 2028, NA
#> 13                  2010, 2028, NA
#> 14                  1980, 2028, NA
#> 15                  1980, 2028, NA
#> 16                  1980, 2028, NA
#> 17                  1980, 2028, NA
#> 18                  1980, 2028, NA
#> 19                  1980, 2028, NA
#> 20                  1980, 2028, NA
#> 21                  1980, 2028, NA
#> 22                  1980, 2028, NA
#> 23                  1990, 2028, NA
#> 24                  1990, 2028, NA
#> 25                  1980, 2028, NA
#> 26                  1980, 2028, NA
#> 27                  1990, 2028, NA
#> 28                  1980, 2028, NA
#> 29                  1980, 2028, NA
#> 30                  1980, 2028, NA
#> 31                  1980, 2028, NA
#> 32                  1980, 2028, NA
#> 33                  1980, 2028, NA
#> 34                  1980, 2028, NA
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 series_description.ref_country
#> 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      Benin, El Salvador, Mexico, Ethiopia, Mauritania, Poland, Albania, Dominican Republic, Guinea-Bissau, South Sudan, Russian Federation, Liberia, Guinea, São Tomé and Príncipe, Côte d’Ivoire, Senegal, Kenya, Indonesia, Uganda, Mali, Panama, St. Lucia, Chad, Uruguay, Nigeria, Vietnam, China, Sierra Leone, Syrian Arab Republic, Georgia, Montenegro, Zimbabwe, Iran, Islamic Rep., Burkina Faso, Belarus, Sri Lanka, Congo, Rep., Marshall Islands, Malaysia, Cabo Verde, Croatia, Eswatini, Haiti, Grenada, Costa Rica, Suriname, Jamaica, Nicaragua, Mozambique, Uzbekistan, Pakistan, Namibia, India, Botswana, Togo, Peru, Thailand, Kyrgyz Republic, Cameroon, Djibouti, Guatemala, Central African Republic, Serbia, Colombia, Bolivia, Brazil, Tanzania, Timor-Leste, Kiribati, Seychelles, Madagascar, Barbados, Ghana, Tajikistan, Niger, Congo, Dem. Rep., Argentina, Bangladesh, Mongolia, Iraq, Romania, Zambia, West Bank and Gaza, Bulgaria, Gabon, Armenia, Honduras, Nepal, Lesotho, South Africa, Burundi, Comoros, Moldova, Angola, Ecuador, Morocco, Mauritius, Malawi, Belize, Kosovo, Kazakhstan, Lao PDR, Paraguay, Sudan, Bhutan, Türkiye, Somalia, Federal Republic of, Philippines, Chile, Rwanda, Gambia, The, Tunisia, Lebanon, Equatorial Guinea, Fiji, BEN, SLV, MEX, ETH, MRT, POL, ALB, DOM, GNB, SSD, RUS, LBR, GIN, STP, CIV, SEN, KEN, IDN, UGA, MLI, PAN, LCA, TCD, URY, NGA, VNM, CHN, SLE, SYR, GEO, MNE, ZWE, IRN, BFA, BLR, LKA, COG, MHL, MYS, CPV, HRV, SWZ, HTI, GRD, CRI, SUR, JAM, NIC, MOZ, UZB, PAK, NAM, IND, BWA, TGO, PER, THA, KGZ, CMR, DJI, GTM, CAF, SRB, COL, BOL, BRA, TZA, TLS, KIR, SYC, MDG, BRB, GHA, TJK, NER, COD, ARG, BGD, MNG, IRQ, ROU, ZMB, PSE, BGR, GAB, ARM, HND, NPL, LSO, ZAF, BDI, COM, MDA, AGO, ECU, MAR, MUS, MWI, BLZ, XKX, KAZ, LAO, PRY, SDN, BTN, TUR, SOM, PHL, CHL, RWA, GMB, TUN, LBN, GNQ, FJI
#> 2                                                   Iraq, Cameroon, Cabo Verde, Haiti, Bolivia, Equatorial Guinea, Chad, Belarus, Indonesia, Grenada, Central African Republic, South Sudan, Mexico, Saudi Arabia, Yemen, Rep., Peru, Belize, Comoros, Costa Rica, Zimbabwe, Jamaica, Georgia, Russian Federation, Rwanda, Angola, Micronesia, Fed. Sts., Guyana, São Tomé and Príncipe, Croatia, Guatemala, Colombia, Bahamas, The, Mongolia, Kosovo, Niger, Timor-Leste, Bahrain, Nigeria, Maldives, Sri Lanka, Djibouti, Pakistan, Turkmenistan, Oman, Afghanistan, St. Lucia, North Macedonia, Nepal, Moldova, Liberia, Qatar, Uruguay, Tunisia, Samoa, Guinea-Bissau, Mali, South Africa, Argentina, Côte d’Ivoire, Lao PDR, Madagascar, Seychelles, Ghana, Nicaragua, Barbados, Mauritania, Ethiopia, Bangladesh, Eritrea, Paraguay, Tanzania, St. Vincent and the Grenadines, Namibia, Tajikistan, Türkiye, Bulgaria, China, Poland, Botswana, Suriname, Congo, Dem. Rep., Kazakhstan, Bhutan, Serbia, Jordan, India, El Salvador, Eswatini, Solomon Islands, Philippines, Gambia, The, Malaysia, Myanmar, Kiribati, Armenia, Brazil, Syrian Arab Republic, Burundi, Palau, Sierra Leone, Gabon, Senegal, Mauritius, Uzbekistan, Bosnia and Herzegovina, Ukraine, Lebanon, Kenya, Vanuatu, Lesotho, Vietnam, Papua New Guinea, Albania, Egypt, Arab Rep., Zambia, West Bank and Gaza, Algeria, Somalia, Federal Republic of, Trinidad and Tobago, Morocco, Tonga, Kuwait, Burkina Faso, Sudan, Panama, Benin, Fiji, Kyrgyz Republic, Ecuador, Uganda, Thailand, Libya, Dominican Republic, Togo, Cambodia, Malawi, Romania, Honduras, Montenegro, Azerbaijan, Chile, Congo, Rep., United Arab Emirates, Dominica, Mozambique, Iran, Islamic Rep., Guinea, IRQ, CMR, CPV, HTI, BOL, GNQ, TCD, BLR, IDN, GRD, CAF, SSD, MEX, SAU, YEM, PER, BLZ, COM, CRI, ZWE, JAM, GEO, RUS, RWA, AGO, FSM, GUY, STP, HRV, GTM, COL, BHS, MNG, XKX, NER, TLS, BHR, NGA, MDV, LKA, DJI, PAK, TKM, OMN, AFG, LCA, MKD, NPL, MDA, LBR, QAT, URY, TUN, WSM, GNB, MLI, ZAF, ARG, CIV, LAO, MDG, SYC, GHA, NIC, BRB, MRT, ETH, BGD, ERI, PRY, TZA, VCT, NAM, TJK, TUR, BGR, CHN, POL, BWA, SUR, COD, KAZ, BTN, SRB, JOR, IND, SLV, SWZ, SLB, PHL, GMB, MYS, MMR, KIR, ARM, BRA, SYR, BDI, PLW, SLE, GAB, SEN, MUS, UZB, BIH, UKR, LBN, KEN, VUT, LSO, VNM, PNG, ALB, EGY, ZMB, PSE, DZA, SOM, TTO, MAR, TON, KWT, BFA, SDN, PAN, BEN, FJI, KGZ, ECU, UGA, THA, LBY, DOM, TGO, KHM, MWI, ROU, HND, MNE, AZE, CHL, COG, ARE, DMA, MOZ, IRN, GIN
#> 3                                                                                                                                                                                                                                                                                                                                                        Tunisia, Vietnam, South Africa, Rwanda, Samoa, Morocco, Bulgaria, Romania, Thailand, Kazakhstan, Guatemala, Afghanistan, Peru, Djibouti, Tanzania, Kosovo, Belarus, Nigeria, Cameroon, Zimbabwe, Philippines, Panama, Madagascar, Indonesia, Bosnia and Herzegovina, Mauritania, Mexico, Myanmar, Iraq, Gabon, Uganda, Syrian Arab Republic, Zambia, Congo, Rep., Dominican Republic, Costa Rica, Vanuatu, Saudi Arabia, Haiti, Russian Federation, Mongolia, Algeria, Georgia, Bahrain, Iran, Islamic Rep., Azerbaijan, Kiribati, Nicaragua, Mauritius, Sri Lanka, Guinea-Bissau, Kenya, Côte d’Ivoire, Tajikistan, Solomon Islands, Qatar, Belize, El Salvador, Croatia, Burkina Faso, Oman, Namibia, Poland, Libya, Niger, Senegal, Liberia, Bangladesh, Jamaica, Honduras, West Bank and Gaza, Ghana, Ecuador, Argentina, Kuwait, Moldova, Burundi, Bahamas, The, Yemen, Rep., Benin, Uzbekistan, Mozambique, Botswana, Timor-Leste, Türkiye, Nepal, Bolivia, Kyrgyz Republic, Cambodia, Guinea, Pakistan, Eswatini, Togo, Jordan, Bhutan, Paraguay, Egypt, Arab Rep., Marshall Islands, United Arab Emirates, Maldives, Albania, Gambia, The, Sierra Leone, Sudan, Chad, Seychelles, Uruguay, Lebanon, North Macedonia, Comoros, Malaysia, China, Somalia, Federal Republic of, Serbia, Angola, Central African Republic, Lesotho, Brazil, Ethiopia, Ukraine, Armenia, Congo, Dem. Rep., Cabo Verde, India, Mali, Chile, Montenegro, Equatorial Guinea, Malawi, Eritrea, Colombia, TUN, VNM, ZAF, RWA, WSM, MAR, BGR, ROU, THA, KAZ, GTM, AFG, PER, DJI, TZA, XKX, BLR, NGA, CMR, ZWE, PHL, PAN, MDG, IDN, BIH, MRT, MEX, MMR, IRQ, GAB, UGA, SYR, ZMB, COG, DOM, CRI, VUT, SAU, HTI, RUS, MNG, DZA, GEO, BHR, IRN, AZE, KIR, NIC, MUS, LKA, GNB, KEN, CIV, TJK, SLB, QAT, BLZ, SLV, HRV, BFA, OMN, NAM, POL, LBY, NER, SEN, LBR, BGD, JAM, HND, PSE, GHA, ECU, ARG, KWT, MDA, BDI, BHS, YEM, BEN, UZB, MOZ, BWA, TLS, TUR, NPL, BOL, KGZ, KHM, GIN, PAK, SWZ, TGO, JOR, BTN, PRY, EGY, MHL, ARE, MDV, ALB, GMB, SLE, SDN, TCD, SYC, URY, LBN, MKD, COM, MYS, CHN, SOM, SRB, AGO, CAF, LSO, BRA, ETH, UKR, ARM, COD, CPV, IND, MLI, CHL, MNE, GNQ, MWI, ERI, COL
#> 4                                                  Bangladesh, Vanuatu, Paraguay, Ghana, Mozambique, Afghanistan, Kazakhstan, Panama, Marshall Islands, Bahrain, Nicaragua, Argentina, Azerbaijan, Sri Lanka, Kosovo, Senegal, Barbados, Costa Rica, Armenia, Comoros, Zimbabwe, Eswatini, Bahamas, The, Gambia, The, Mexico, Angola, China, Tajikistan, Guinea, Ukraine, Cameroon, Uganda, Uruguay, Sierra Leone, Papua New Guinea, St. Vincent and the Grenadines, Zambia, Guinea-Bissau, St. Lucia, Gabon, United Arab Emirates, Fiji, Morocco, Myanmar, Egypt, Arab Rep., Jordan, Peru, Albania, Equatorial Guinea, Mauritius, Tuvalu, Bhutan, Burkina Faso, Pakistan, Kuwait, Rwanda, Seychelles, Indonesia, Syrian Arab Republic, Dominica, Nigeria, Bolivia, Mongolia, Kyrgyz Republic, Kenya, Tanzania, Montenegro, Romania, Bosnia and Herzegovina, Congo, Rep., Micronesia, Fed. Sts., Belize, El Salvador, Trinidad and Tobago, Chile, India, Eritrea, Congo, Dem. Rep., South Africa, Namibia, Mauritania, Uzbekistan, Tonga, Chad, Turkmenistan, Ethiopia, Brazil, Grenada, Algeria, Yemen, Rep., Georgia, Palau, Lesotho, Niger, Iran, Islamic Rep., Thailand, Côte d’Ivoire, Maldives, Suriname, Tunisia, Togo, Poland, Cabo Verde, Vietnam, Belarus, South Sudan, North Macedonia, Mali, São Tomé and Príncipe, Guyana, Madagascar, Iraq, Kiribati, Malawi, West Bank and Gaza, Samoa, Lebanon, Malaysia, Guatemala, Türkiye, Lao PDR, Timor-Leste, Botswana, Haiti, Moldova, Nepal, Russian Federation, Saudi Arabia, Dominican Republic, Liberia, Honduras, Colombia, Oman, Ecuador, Serbia, Croatia, Libya, Bulgaria, Qatar, Sudan, Jamaica, Central African Republic, Philippines, Cambodia, Benin, Solomon Islands, Djibouti, Burundi, BGD, VUT, PRY, GHA, MOZ, AFG, KAZ, PAN, MHL, BHR, NIC, ARG, AZE, LKA, XKX, SEN, BRB, CRI, ARM, COM, ZWE, SWZ, BHS, GMB, MEX, AGO, CHN, TJK, GIN, UKR, CMR, UGA, URY, SLE, PNG, VCT, ZMB, GNB, LCA, GAB, ARE, FJI, MAR, MMR, EGY, JOR, PER, ALB, GNQ, MUS, TUV, BTN, BFA, PAK, KWT, RWA, SYC, IDN, SYR, DMA, NGA, BOL, MNG, KGZ, KEN, TZA, MNE, ROU, BIH, COG, FSM, BLZ, SLV, TTO, CHL, IND, ERI, COD, ZAF, NAM, MRT, UZB, TON, TCD, TKM, ETH, BRA, GRD, DZA, YEM, GEO, PLW, LSO, NER, IRN, THA, CIV, MDV, SUR, TUN, TGO, POL, CPV, VNM, BLR, SSD, MKD, MLI, STP, GUY, MDG, IRQ, KIR, MWI, PSE, WSM, LBN, MYS, GTM, TUR, LAO, TLS, BWA, HTI, MDA, NPL, RUS, SAU, DOM, LBR, HND, COL, OMN, ECU, SRB, HRV, LBY, BGR, QAT, SDN, JAM, CAF, PHL, KHM, BEN, SLB, DJI, BDI
#> 5                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      Uzbekistan, São Tomé and Príncipe, Maldives, Azerbaijan, Honduras, Saudi Arabia, Argentina, Kuwait, Peru, Uruguay, Sierra Leone, Malaysia, Syrian Arab Republic, Nigeria, Paraguay, Kazakhstan, China, Tunisia, Iraq, Solomon Islands, Lebanon, Belize, Timor-Leste, Oman, Bahamas, The, Sri Lanka, Mongolia, Bahrain, Trinidad and Tobago, Eritrea, Jamaica, Nicaragua, Ukraine, Russian Federation, Belarus, El Salvador, Qatar, Papua New Guinea, Mexico, Fiji, Vanuatu, UZB, STP, MDV, AZE, HND, SAU, ARG, KWT, PER, URY, SLE, MYS, SYR, NGA, PRY, KAZ, CHN, TUN, IRQ, SLB, LBN, BLZ, TLS, OMN, BHS, LKA, MNG, BHR, TTO, ERI, JAM, NIC, UKR, RUS, BLR, SLV, QAT, PNG, MEX, FJI, VUT
#> 6                                                   Nicaragua, Burkina Faso, Jamaica, Iran, Islamic Rep., Samoa, Egypt, Arab Rep., Panama, Angola, Tonga, Congo, Rep., Saudi Arabia, Seychelles, Côte d’Ivoire, Philippines, Ukraine, Senegal, Congo, Dem. Rep., Kenya, Timor-Leste, Brazil, Burundi, Ecuador, Solomon Islands, Chad, Armenia, Costa Rica, Papua New Guinea, Chile, Dominican Republic, Mexico, Guinea, Tunisia, Sri Lanka, Algeria, Bahrain, Botswana, Uruguay, Bangladesh, Tajikistan, Mongolia, Uzbekistan, Liberia, Zimbabwe, Kazakhstan, Nigeria, Grenada, Poland, Rwanda, Kiribati, Albania, Suriname, São Tomé and Príncipe, Colombia, Namibia, Djibouti, Syrian Arab Republic, Uganda, Russian Federation, Mauritania, Lebanon, Turkmenistan, Maldives, Azerbaijan, Cambodia, United Arab Emirates, Cabo Verde, Fiji, Palau, St. Vincent and the Grenadines, Qatar, Madagascar, Kosovo, Mali, North Macedonia, Kyrgyz Republic, Morocco, Romania, Malawi, Mauritius, Argentina, West Bank and Gaza, Haiti, Peru, Libya, Pakistan, Lao PDR, Yemen, Rep., El Salvador, Eritrea, China, Gambia, The, Jordan, Thailand, Micronesia, Fed. Sts., Trinidad and Tobago, Croatia, Gabon, Nepal, Benin, South Sudan, Bolivia, Bosnia and Herzegovina, Vietnam, Vanuatu, Mozambique, Comoros, Togo, Guinea-Bissau, Dominica, India, Bahamas, The, Somalia, Federal Republic of, Bulgaria, St. Lucia, Eswatini, Belarus, Sudan, Myanmar, Belize, Guatemala, Cameroon, Guyana, Oman, Central African Republic, Bhutan, Zambia, Equatorial Guinea, Malaysia, Kuwait, Serbia, Moldova, Tanzania, Honduras, Lesotho, Ghana, Georgia, Paraguay, South Africa, Niger, Türkiye, Indonesia, Afghanistan, Iraq, Montenegro, Sierra Leone, Barbados, Ethiopia, NIC, BFA, JAM, IRN, WSM, EGY, PAN, AGO, TON, COG, SAU, SYC, CIV, PHL, UKR, SEN, COD, KEN, TLS, BRA, BDI, ECU, SLB, TCD, ARM, CRI, PNG, CHL, DOM, MEX, GIN, TUN, LKA, DZA, BHR, BWA, URY, BGD, TJK, MNG, UZB, LBR, ZWE, KAZ, NGA, GRD, POL, RWA, KIR, ALB, SUR, STP, COL, NAM, DJI, SYR, UGA, RUS, MRT, LBN, TKM, MDV, AZE, KHM, ARE, CPV, FJI, PLW, VCT, QAT, MDG, XKX, MLI, MKD, KGZ, MAR, ROU, MWI, MUS, ARG, PSE, HTI, PER, LBY, PAK, LAO, YEM, SLV, ERI, CHN, GMB, JOR, THA, FSM, TTO, HRV, GAB, NPL, BEN, SSD, BOL, BIH, VNM, VUT, MOZ, COM, TGO, GNB, DMA, IND, BHS, SOM, BGR, LCA, SWZ, BLR, SDN, MMR, BLZ, GTM, CMR, GUY, OMN, CAF, BTN, ZMB, GNQ, MYS, KWT, SRB, MDA, TZA, HND, LSO, GHA, GEO, PRY, ZAF, NER, TUR, IDN, AFG, IRQ, MNE, SLE, BRB, ETH
#> 7                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     Philippines, Timor-Leste, Gabon, Oman, Afghanistan, Saudi Arabia, Ecuador, Eswatini, Togo, Haiti, Honduras, Mongolia, Montenegro, Niger, Jordan, Chile, Kyrgyz Republic, Qatar, Tanzania, West Bank and Gaza, Albania, Chad, Croatia, Poland, Nigeria, São Tomé and Príncipe, Guyana, Sudan, Vanuatu, Papua New Guinea, Armenia, Vietnam, Cameroon, Georgia, Eritrea, Micronesia, Fed. Sts., Azerbaijan, Uzbekistan, Bahamas, The, Pakistan, Türkiye, Tonga, El Salvador, Thailand, Nicaragua, Benin, Kenya, Côte d’Ivoire, Guinea, Peru, Bulgaria, Belarus, Malaysia, Mauritania, Mali, Egypt, Arab Rep., Seychelles, Russian Federation, Kosovo, Bangladesh, Moldova, India, Bosnia and Herzegovina, Mexico, Solomon Islands, Trinidad and Tobago, Romania, South Africa, Angola, Morocco, Iran, Islamic Rep., Ghana, South Sudan, Jamaica, Burkina Faso, Burundi, Cambodia, Guinea-Bissau, Zimbabwe, Congo, Rep., Guatemala, Lebanon, Iraq, Sierra Leone, Indonesia, Bhutan, Maldives, Panama, Ukraine, Belize, China, Suriname, Botswana, Kuwait, Tunisia, Samoa, Madagascar, Uganda, Nepal, Uruguay, Zambia, Dominican Republic, Costa Rica, Equatorial Guinea, Fiji, Kazakhstan, Rwanda, Brazil, Paraguay, Namibia, Argentina, Serbia, North Macedonia, Cabo Verde, Malawi, Lesotho, Bahrain, Yemen, Rep., Tajikistan, Syrian Arab Republic, Sri Lanka, Mauritius, Bolivia, Mozambique, PHL, TLS, GAB, OMN, AFG, SAU, ECU, SWZ, TGO, HTI, HND, MNG, MNE, NER, JOR, CHL, KGZ, QAT, TZA, PSE, ALB, TCD, HRV, POL, NGA, STP, GUY, SDN, VUT, PNG, ARM, VNM, CMR, GEO, ERI, FSM, AZE, UZB, BHS, PAK, TUR, TON, SLV, THA, NIC, BEN, KEN, CIV, GIN, PER, BGR, BLR, MYS, MRT, MLI, EGY, SYC, RUS, XKX, BGD, MDA, IND, BIH, MEX, SLB, TTO, ROU, ZAF, AGO, MAR, IRN, GHA, SSD, JAM, BFA, BDI, KHM, GNB, ZWE, COG, GTM, LBN, IRQ, SLE, IDN, BTN, MDV, PAN, UKR, BLZ, CHN, SUR, BWA, KWT, TUN, WSM, MDG, UGA, NPL, URY, ZMB, DOM, CRI, GNQ, FJI, KAZ, RWA, BRA, PRY, NAM, ARG, SRB, MKD, CPV, MWI, LSO, BHR, YEM, TJK, SYR, LKA, MUS, BOL, MOZ
#> 8                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        Botswana, Benin, Nepal, Senegal, Tajikistan, Fiji, Chile, Namibia, Jamaica, Mauritius, Russian Federation, Thailand, Mali, Montenegro, Malaysia, Gambia, The, Barbados, Belize, Cameroon, Cabo Verde, Philippines, Côte d’Ivoire, Nicaragua, Kyrgyz Republic, West Bank and Gaza, Chad, China, Serbia, Panama, Guinea, Guinea-Bissau, Sri Lanka, Congo, Rep., Liberia, Maldives, Armenia, Bhutan, Bulgaria, Lesotho, Kenya, Mexico, Mongolia, Rwanda, Sierra Leone, Ecuador, Congo, Dem. Rep., Moldova, Croatia, Eswatini, Tunisia, Bangladesh, Uzbekistan, Togo, South Africa, Grenada, Poland, Nigeria, Iran, Islamic Rep., Bosnia and Herzegovina, St. Lucia, Mauritania, Uruguay, Syrian Arab Republic, Lao PDR, Malawi, Marshall Islands, Morocco, Vietnam, Haiti, Brazil, Dominican Republic, Sudan, Suriname, Belarus, São Tomé and Príncipe, Angola, Madagascar, Ethiopia, Argentina, Iraq, South Sudan, Costa Rica, Somalia, Federal Republic of, Tonga, Uganda, Georgia, Kazakhstan, Albania, Gabon, Paraguay, Türkiye, Niger, Tanzania, Central African Republic, Colombia, Bolivia, Comoros, Peru, Honduras, Djibouti, Kiribati, Mozambique, Kosovo, El Salvador, Romania, Equatorial Guinea, Zambia, Burkina Faso, Indonesia, Zimbabwe, Seychelles, Lebanon, India, Ghana, Pakistan, Guatemala, North Macedonia, BWA, BEN, NPL, SEN, TJK, FJI, CHL, NAM, JAM, MUS, RUS, THA, MLI, MNE, MYS, GMB, BRB, BLZ, CMR, CPV, PHL, CIV, NIC, KGZ, PSE, TCD, CHN, SRB, PAN, GIN, GNB, LKA, COG, LBR, MDV, ARM, BTN, BGR, LSO, KEN, MEX, MNG, RWA, SLE, ECU, COD, MDA, HRV, SWZ, TUN, BGD, UZB, TGO, ZAF, GRD, POL, NGA, IRN, BIH, LCA, MRT, URY, SYR, LAO, MWI, MHL, MAR, VNM, HTI, BRA, DOM, SDN, SUR, BLR, STP, AGO, MDG, ETH, ARG, IRQ, SSD, CRI, SOM, TON, UGA, GEO, KAZ, ALB, GAB, PRY, TUR, NER, TZA, CAF, COL, BOL, COM, PER, HND, DJI, KIR, MOZ, XKX, SLV, ROU, GNQ, ZMB, BFA, IDN, ZWE, SYC, LBN, IND, GHA, PAK, GTM, MKD
#> 9                                                                   Namibia, Morocco, Ukraine, Burundi, Mali, Guyana, Vanuatu, Uganda, Azerbaijan, Dominica, Belarus, Liberia, Bulgaria, Haiti, Pakistan, Solomon Islands, Seychelles, Senegal, Equatorial Guinea, Eswatini, Timor-Leste, Syrian Arab Republic, Micronesia, Fed. Sts., Trinidad and Tobago, Peru, Oman, Fiji, Honduras, Dominican Republic, Kenya, Angola, Afghanistan, Botswana, Kazakhstan, Bahamas, The, Lao PDR, Tanzania, Chile, Montenegro, Tajikistan, Qatar, Saudi Arabia, Malawi, Congo, Dem. Rep., Jordan, Rwanda, Eritrea, Sudan, Cabo Verde, Côte d’Ivoire, United Arab Emirates, Maldives, Costa Rica, Iran, Islamic Rep., Sri Lanka, Panama, Zimbabwe, São Tomé and Príncipe, Türkiye, India, Zambia, Mongolia, El Salvador, Mozambique, Sierra Leone, China, Gambia, The, Guatemala, South Sudan, Russian Federation, Georgia, Cameroon, Guinea-Bissau, Libya, Uzbekistan, Belize, Indonesia, Comoros, Tunisia, Nepal, Romania, Congo, Rep., Poland, Cambodia, Croatia, Bosnia and Herzegovina, Bangladesh, Central African Republic, Kyrgyz Republic, Lebanon, Niger, Armenia, Benin, Jamaica, Albania, St. Lucia, Somalia, Federal Republic of, St. Vincent and the Grenadines, Brazil, Guinea, Bhutan, Philippines, Yemen, Rep., Colombia, Ethiopia, Mexico, Algeria, Bolivia, Turkmenistan, Togo, Mauritania, Samoa, Chad, Palau, Bahrain, Mauritius, Myanmar, Kosovo, Barbados, Ghana, Kiribati, Nicaragua, Vietnam, West Bank and Gaza, Suriname, Ecuador, Paraguay, Moldova, Djibouti, Gabon, Grenada, Tonga, Thailand, North Macedonia, Malaysia, Iraq, Lesotho, Papua New Guinea, Egypt, Arab Rep., Madagascar, South Africa, Serbia, Burkina Faso, Nigeria, Uruguay, Kuwait, NAM, MAR, UKR, BDI, MLI, GUY, VUT, UGA, AZE, DMA, BLR, LBR, BGR, HTI, PAK, SLB, SYC, SEN, GNQ, SWZ, TLS, SYR, FSM, TTO, PER, OMN, FJI, HND, DOM, KEN, AGO, AFG, BWA, KAZ, BHS, LAO, TZA, CHL, MNE, TJK, QAT, SAU, MWI, COD, JOR, RWA, ERI, SDN, CPV, CIV, ARE, MDV, CRI, IRN, LKA, PAN, ZWE, STP, TUR, IND, ZMB, MNG, SLV, MOZ, SLE, CHN, GMB, GTM, SSD, RUS, GEO, CMR, GNB, LBY, UZB, BLZ, IDN, COM, TUN, NPL, ROU, COG, POL, KHM, HRV, BIH, BGD, CAF, KGZ, LBN, NER, ARM, BEN, JAM, ALB, LCA, SOM, VCT, BRA, GIN, BTN, PHL, YEM, COL, ETH, MEX, DZA, BOL, TKM, TGO, MRT, WSM, TCD, PLW, BHR, MUS, MMR, XKX, BRB, GHA, KIR, NIC, VNM, PSE, SUR, ECU, PRY, MDA, DJI, GAB, GRD, TON, THA, MKD, MYS, IRQ, LSO, PNG, EGY, MDG, ZAF, SRB, BFA, NGA, URY, KWT
#> 10                                                                     Barbados, Belarus, Syrian Arab Republic, China, Guyana, North Macedonia, Equatorial Guinea, Grenada, Nepal, Somalia, Federal Republic of, Tonga, Zambia, Libya, Armenia, Russian Federation, Lesotho, Eritrea, Senegal, Bhutan, Seychelles, Azerbaijan, Palau, Papua New Guinea, Iraq, Jamaica, Colombia, Nigeria, Serbia, Thailand, Cameroon, St. Lucia, Kazakhstan, West Bank and Gaza, Madagascar, Sri Lanka, Ethiopia, Ghana, Kyrgyz Republic, Suriname, Oman, Pakistan, Bulgaria, Chile, Uruguay, Morocco, Mongolia, Kuwait, United Arab Emirates, Congo, Dem. Rep., Fiji, Zimbabwe, Lebanon, Djibouti, Iran, Islamic Rep., El Salvador, Tunisia, Egypt, Arab Rep., Cabo Verde, Eswatini, Burkina Faso, Saudi Arabia, Bahamas, The, Dominican Republic, Sudan, Lao PDR, Jordan, Solomon Islands, Myanmar, Benin, Guatemala, Trinidad and Tobago, Romania, Ecuador, Mozambique, Mauritania, Ukraine, Comoros, Mauritius, Qatar, Uganda, Nicaragua, Panama, Central African Republic, Paraguay, Brazil, Chad, Samoa, Côte d’Ivoire, Liberia, Tanzania, India, Philippines, Dominica, Moldova, Togo, Uzbekistan, Belize, South Sudan, Kosovo, Poland, Timor-Leste, Guinea, Bolivia, Botswana, Tajikistan, Gabon, Namibia, St. Vincent and the Grenadines, Angola, Costa Rica, Türkiye, South Africa, Croatia, Kenya, São Tomé and Príncipe, Mexico, Montenegro, Vanuatu, Maldives, Congo, Rep., Sierra Leone, Algeria, Indonesia, Honduras, Bahrain, Malawi, Guinea-Bissau, Mali, Afghanistan, Rwanda, Albania, Kiribati, Peru, Niger, Cambodia, Bangladesh, Burundi, Vietnam, Bosnia and Herzegovina, Malaysia, Georgia, Micronesia, Fed. Sts., Haiti, Gambia, The, Argentina, Yemen, Rep., BRB, BLR, SYR, CHN, GUY, MKD, GNQ, GRD, NPL, SOM, TON, ZMB, LBY, ARM, RUS, LSO, ERI, SEN, BTN, SYC, AZE, PLW, PNG, IRQ, JAM, COL, NGA, SRB, THA, CMR, LCA, KAZ, PSE, MDG, LKA, ETH, GHA, KGZ, SUR, OMN, PAK, BGR, CHL, URY, MAR, MNG, KWT, ARE, COD, FJI, ZWE, LBN, DJI, IRN, SLV, TUN, EGY, CPV, SWZ, BFA, SAU, BHS, DOM, SDN, LAO, JOR, SLB, MMR, BEN, GTM, TTO, ROU, ECU, MOZ, MRT, UKR, COM, MUS, QAT, UGA, NIC, PAN, CAF, PRY, BRA, TCD, WSM, CIV, LBR, TZA, IND, PHL, DMA, MDA, TGO, UZB, BLZ, SSD, XKX, POL, TLS, GIN, BOL, BWA, TJK, GAB, NAM, VCT, AGO, CRI, TUR, ZAF, HRV, KEN, STP, MEX, MNE, VUT, MDV, COG, SLE, DZA, IDN, HND, BHR, MWI, GNB, MLI, AFG, RWA, ALB, KIR, PER, NER, KHM, BGD, BDI, VNM, BIH, MYS, GEO, FSM, HTI, GMB, ARG, YEM
#> 11                                                                                             Albania, Kenya, Niger, Paraguay, Maldives, Oman, Lao PDR, Congo, Rep., Türkiye, Uzbekistan, Senegal, São Tomé and Príncipe, Bhutan, Equatorial Guinea, Bolivia, Namibia, Tanzania, Angola, Mongolia, Fiji, Mauritania, Pakistan, Eswatini, Nicaragua, Qatar, Morocco, Poland, Mali, Dominica, Solomon Islands, Romania, Belarus, Peru, Mauritius, Trinidad and Tobago, United Arab Emirates, Guinea-Bissau, Turkmenistan, Vietnam, Cambodia, Colombia, Kyrgyz Republic, Moldova, Somalia, Federal Republic of, Timor-Leste, Congo, Dem. Rep., Egypt, Arab Rep., Lesotho, Saudi Arabia, Ukraine, Russian Federation, Chile, Grenada, Jamaica, Zimbabwe, India, Bangladesh, Burundi, Thailand, Sierra Leone, Micronesia, Fed. Sts., Belize, Iraq, Côte d’Ivoire, Azerbaijan, Georgia, Costa Rica, Sudan, Uganda, Tonga, Vanuatu, Guinea, Honduras, Guyana, Palau, El Salvador, Yemen, Rep., Armenia, St. Lucia, Nigeria, Haiti, Lebanon, Zambia, Madagascar, Mexico, Bosnia and Herzegovina, Kuwait, Samoa, Tunisia, Central African Republic, China, Brazil, Comoros, Eritrea, Indonesia, Papua New Guinea, Burkina Faso, Malawi, Uruguay, Philippines, Libya, Panama, Algeria, North Macedonia, Suriname, Togo, Serbia, Jordan, Croatia, Bahamas, The, Djibouti, Cameroon, Seychelles, St. Vincent and the Grenadines, Afghanistan, Ecuador, Iran, Islamic Rep., Montenegro, Ethiopia, Benin, Kosovo, Bulgaria, Dominican Republic, Barbados, Tajikistan, Liberia, Gabon, Kazakhstan, Cabo Verde, Ghana, Botswana, Myanmar, South Africa, South Sudan, Sri Lanka, Nepal, Chad, Kiribati, Malaysia, Mozambique, Rwanda, West Bank and Gaza, Guatemala, Bahrain, Gambia, The, ALB, KEN, NER, PRY, MDV, OMN, LAO, COG, TUR, UZB, SEN, STP, BTN, GNQ, BOL, NAM, TZA, AGO, MNG, FJI, MRT, PAK, SWZ, NIC, QAT, MAR, POL, MLI, DMA, SLB, ROU, BLR, PER, MUS, TTO, ARE, GNB, TKM, VNM, KHM, COL, KGZ, MDA, SOM, TLS, COD, EGY, LSO, SAU, UKR, RUS, CHL, GRD, JAM, ZWE, IND, BGD, BDI, THA, SLE, FSM, BLZ, IRQ, CIV, AZE, GEO, CRI, SDN, UGA, TON, VUT, GIN, HND, GUY, PLW, SLV, YEM, ARM, LCA, NGA, HTI, LBN, ZMB, MDG, MEX, BIH, KWT, WSM, TUN, CAF, CHN, BRA, COM, ERI, IDN, PNG, BFA, MWI, URY, PHL, LBY, PAN, DZA, MKD, SUR, TGO, SRB, JOR, HRV, BHS, DJI, CMR, SYC, VCT, AFG, ECU, IRN, MNE, ETH, BEN, XKX, BGR, DOM, BRB, TJK, LBR, GAB, KAZ, CPV, GHA, BWA, MMR, ZAF, SSD, LKA, NPL, TCD, KIR, MYS, MOZ, RWA, PSE, GTM, BHR, GMB
#> 12                                                                     Eswatini, Equatorial Guinea, Argentina, Gambia, The, Indonesia, Mali, Thailand, Pakistan, Zimbabwe, Central African Republic, Djibouti, Bahrain, Bolivia, Palau, Kiribati, Colombia, South Sudan, Benin, Timor-Leste, Uzbekistan, St. Lucia, Peru, Honduras, India, Seychelles, São Tomé and Príncipe, West Bank and Gaza, Mozambique, Panama, Burkina Faso, Congo, Dem. Rep., Cambodia, China, Nepal, Gabon, Madagascar, Oman, Saudi Arabia, Sri Lanka, Qatar, Solomon Islands, North Macedonia, Kazakhstan, Guyana, Tunisia, Albania, Dominica, Romania, Sierra Leone, Uruguay, Tajikistan, Kuwait, Poland, Bosnia and Herzegovina, Chad, Nigeria, Cabo Verde, Bahamas, The, Algeria, Fiji, Botswana, Rwanda, Moldova, Serbia, Russian Federation, Bulgaria, Iran, Islamic Rep., Lao PDR, Jamaica, Croatia, Libya, Eritrea, Papua New Guinea, Haiti, United Arab Emirates, Mauritius, Mexico, Myanmar, Georgia, Guatemala, Costa Rica, Ukraine, Tanzania, Maldives, Ghana, Suriname, Azerbaijan, Afghanistan, Somalia, Federal Republic of, Vanuatu, Iraq, Syrian Arab Republic, Montenegro, Samoa, Brazil, Uganda, Chile, Burundi, Mauritania, Nicaragua, Mongolia, Micronesia, Fed. Sts., Lesotho, Kyrgyz Republic, Trinidad and Tobago, Angola, Belarus, Namibia, Vietnam, Kenya, Senegal, Egypt, Arab Rep., Yemen, Rep., South Africa, Togo, Malawi, Guinea-Bissau, Sudan, Cameroon, Guinea, Philippines, Ethiopia, Grenada, Morocco, Niger, El Salvador, Bhutan, Armenia, Lebanon, Côte d’Ivoire, Türkiye, Barbados, Dominican Republic, Kosovo, Belize, Comoros, St. Vincent and the Grenadines, Zambia, Tonga, Ecuador, Paraguay, Jordan, Malaysia, Bangladesh, Congo, Rep., Liberia, SWZ, GNQ, ARG, GMB, IDN, MLI, THA, PAK, ZWE, CAF, DJI, BHR, BOL, PLW, KIR, COL, SSD, BEN, TLS, UZB, LCA, PER, HND, IND, SYC, STP, PSE, MOZ, PAN, BFA, COD, KHM, CHN, NPL, GAB, MDG, OMN, SAU, LKA, QAT, SLB, MKD, KAZ, GUY, TUN, ALB, DMA, ROU, SLE, URY, TJK, KWT, POL, BIH, TCD, NGA, CPV, BHS, DZA, FJI, BWA, RWA, MDA, SRB, RUS, BGR, IRN, LAO, JAM, HRV, LBY, ERI, PNG, HTI, ARE, MUS, MEX, MMR, GEO, GTM, CRI, UKR, TZA, MDV, GHA, SUR, AZE, AFG, SOM, VUT, IRQ, SYR, MNE, WSM, BRA, UGA, CHL, BDI, MRT, NIC, MNG, FSM, LSO, KGZ, TTO, AGO, BLR, NAM, VNM, KEN, SEN, EGY, YEM, ZAF, TGO, MWI, GNB, SDN, CMR, GIN, PHL, ETH, GRD, MAR, NER, SLV, BTN, ARM, LBN, CIV, TUR, BRB, DOM, XKX, BLZ, COM, VCT, ZMB, TON, ECU, PRY, JOR, MYS, BGD, COG, LBR
#> 13                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             Congo, Dem. Rep., Syrian Arab Republic, South Africa, Türkiye, Albania, Panama, Togo, Haiti, Argentina, Guinea-Bissau, Liberia, Gabon, Congo, Rep., Honduras, Senegal, Uzbekistan, Georgia, Brazil, Madagascar, India, Chile, Sierra Leone, Uruguay, Zimbabwe, Malaysia, Côte d’Ivoire, Lao PDR, Gambia, The, Grenada, Barbados, Benin, China, Eswatini, Mauritania, Vanuatu, El Salvador, Serbia, Belarus, Tanzania, Armenia, Colombia, Nigeria, Pakistan, Lesotho, Mongolia, Seychelles, Angola, South Sudan, Malawi, Kazakhstan, Tajikistan, Thailand, Zambia, Guinea, Djibouti, Dominican Republic, Indonesia, Jamaica, Montenegro, Lebanon, Kyrgyz Republic, Belize, Comoros, Nepal, Kosovo, Cabo Verde, Suriname, Chad, Burundi, Fiji, Bolivia, Cameroon, Mali, Sudan, Central African Republic, Romania, Morocco, Kiribati, Bangladesh, Rwanda, Paraguay, Namibia, Guatemala, Philippines, Mauritius, Poland, Ecuador, Ethiopia, Burkina Faso, Moldova, Croatia, Russian Federation, Sri Lanka, Bhutan, Equatorial Guinea, Costa Rica, Kenya, Botswana, Nicaragua, Bulgaria, Mozambique, Peru, Vietnam, Egypt, Arab Rep., Somalia, Federal Republic of, Iran, Islamic Rep., St. Lucia, Tunisia, Niger, Iraq, Marshall Islands, Ghana, West Bank and Gaza, São Tomé and Príncipe, Timor-Leste, Uganda, COD, SYR, ZAF, TUR, ALB, PAN, TGO, HTI, ARG, GNB, LBR, GAB, COG, HND, SEN, UZB, GEO, BRA, MDG, IND, CHL, SLE, URY, ZWE, MYS, CIV, LAO, GMB, GRD, BRB, BEN, CHN, SWZ, MRT, VUT, SLV, SRB, BLR, TZA, ARM, COL, NGA, PAK, LSO, MNG, SYC, AGO, SSD, MWI, KAZ, TJK, THA, ZMB, GIN, DJI, DOM, IDN, JAM, MNE, LBN, KGZ, BLZ, COM, NPL, XKX, CPV, SUR, TCD, BDI, FJI, BOL, CMR, MLI, SDN, CAF, ROU, MAR, KIR, BGD, RWA, PRY, NAM, GTM, PHL, MUS, POL, ECU, ETH, BFA, MDA, HRV, RUS, LKA, BTN, GNQ, CRI, KEN, BWA, NIC, BGR, MOZ, PER, VNM, EGY, SOM, IRN, LCA, TUN, NER, IRQ, MHL, GHA, PSE, STP, TLS, UGA
#> 14                                                                     Bolivia, Tajikistan, Serbia, Argentina, Brazil, South Sudan, Guinea, Mongolia, Kyrgyz Republic, Lebanon, Côte d’Ivoire, Malaysia, Qatar, Botswana, Thailand, Tanzania, North Macedonia, Egypt, Arab Rep., Montenegro, Maldives, Guinea-Bissau, Iraq, Croatia, Comoros, Seychelles, Central African Republic, Poland, St. Vincent and the Grenadines, São Tomé and Príncipe, Mozambique, Rwanda, Samoa, Peru, Nigeria, Armenia, Niger, Timor-Leste, Burundi, Bahamas, The, Congo, Rep., Vietnam, Micronesia, Fed. Sts., Bangladesh, Sudan, Barbados, Eswatini, Zambia, Lesotho, China, Guyana, Yemen, Rep., Namibia, Zimbabwe, St. Lucia, West Bank and Gaza, Romania, Tonga, Cabo Verde, Uganda, Georgia, Cameroon, Iran, Islamic Rep., Angola, Bahrain, Jamaica, Sri Lanka, Uzbekistan, Syrian Arab Republic, Dominica, Kuwait, Somalia, Federal Republic of, Uruguay, Djibouti, Albania, El Salvador, Pakistan, Tunisia, Equatorial Guinea, Oman, Trinidad and Tobago, Türkiye, Philippines, Jordan, Panama, Colombia, Ghana, Lao PDR, Togo, Algeria, Benin, Ecuador, Chad, Burkina Faso, Afghanistan, Gambia, The, Vanuatu, Morocco, Sierra Leone, Bhutan, Haiti, Guatemala, Belarus, Bulgaria, Malawi, Myanmar, Gabon, Kazakhstan, Solomon Islands, Ukraine, Nicaragua, Bosnia and Herzegovina, Russian Federation, Liberia, Suriname, Dominican Republic, Palau, South Africa, Kiribati, Kenya, Azerbaijan, Costa Rica, Mauritius, Cambodia, Fiji, Nepal, Chile, Congo, Dem. Rep., Mali, Mexico, Saudi Arabia, Madagascar, United Arab Emirates, Papua New Guinea, Grenada, India, Paraguay, Belize, Libya, Ethiopia, Honduras, Kosovo, Mauritania, Senegal, Moldova, Eritrea, Indonesia, BOL, TJK, SRB, ARG, BRA, SSD, GIN, MNG, KGZ, LBN, CIV, MYS, QAT, BWA, THA, TZA, MKD, EGY, MNE, MDV, GNB, IRQ, HRV, COM, SYC, CAF, POL, VCT, STP, MOZ, RWA, WSM, PER, NGA, ARM, NER, TLS, BDI, BHS, COG, VNM, FSM, BGD, SDN, BRB, SWZ, ZMB, LSO, CHN, GUY, YEM, NAM, ZWE, LCA, PSE, ROU, TON, CPV, UGA, GEO, CMR, IRN, AGO, BHR, JAM, LKA, UZB, SYR, DMA, KWT, SOM, URY, DJI, ALB, SLV, PAK, TUN, GNQ, OMN, TTO, TUR, PHL, JOR, PAN, COL, GHA, LAO, TGO, DZA, BEN, ECU, TCD, BFA, AFG, GMB, VUT, MAR, SLE, BTN, HTI, GTM, BLR, BGR, MWI, MMR, GAB, KAZ, SLB, UKR, NIC, BIH, RUS, LBR, SUR, DOM, PLW, ZAF, KIR, KEN, AZE, CRI, MUS, KHM, FJI, NPL, CHL, COD, MLI, MEX, SAU, MDG, ARE, PNG, GRD, IND, PRY, BLZ, LBY, ETH, HND, XKX, MRT, SEN, MDA, ERI, IDN
#> 15                                                                                                                                                                                                                                                                                                                                                       Nigeria, Maldives, Uganda, Uzbekistan, Malaysia, Bahamas, The, India, Senegal, Kenya, Guatemala, Montenegro, Mali, Vietnam, Zimbabwe, Panama, Argentina, Congo, Rep., Namibia, Mexico, Botswana, Lesotho, Serbia, Mongolia, Kosovo, Haiti, Kyrgyz Republic, Gabon, Kiribati, United Arab Emirates, Jordan, Mauritius, Peru, Cabo Verde, Egypt, Arab Rep., Mauritania, Samoa, Colombia, North Macedonia, Bosnia and Herzegovina, Belarus, Croatia, Afghanistan, Costa Rica, Marshall Islands, Honduras, Chad, Cameroon, Azerbaijan, Bulgaria, Malawi, Qatar, Paraguay, Bhutan, Algeria, Seychelles, Armenia, Albania, Myanmar, Pakistan, Eswatini, Oman, Thailand, West Bank and Gaza, Bangladesh, Iran, Islamic Rep., Kazakhstan, Kuwait, Iraq, Gambia, The, Zambia, Chile, Georgia, Guinea-Bissau, Belize, El Salvador, Tanzania, Guinea, Ecuador, Yemen, Rep., Brazil, Nepal, Morocco, Nicaragua, Lebanon, Moldova, South Africa, Libya, Romania, Bahrain, Burundi, Ghana, Comoros, Central African Republic, Saudi Arabia, Congo, Dem. Rep., Ukraine, Cambodia, Sri Lanka, Ethiopia, Timor-Leste, Poland, Uruguay, Sierra Leone, Türkiye, Indonesia, Benin, Sudan, Tajikistan, Bolivia, Somalia, Federal Republic of, Mozambique, Angola, Russian Federation, Tunisia, Syrian Arab Republic, Jamaica, Togo, Dominican Republic, Rwanda, Vanuatu, Liberia, Niger, Solomon Islands, Burkina Faso, China, Eritrea, Côte d’Ivoire, Madagascar, Philippines, Equatorial Guinea, Djibouti, NGA, MDV, UGA, UZB, MYS, BHS, IND, SEN, KEN, GTM, MNE, MLI, VNM, ZWE, PAN, ARG, COG, NAM, MEX, BWA, LSO, SRB, MNG, XKX, HTI, KGZ, GAB, KIR, ARE, JOR, MUS, PER, CPV, EGY, MRT, WSM, COL, MKD, BIH, BLR, HRV, AFG, CRI, MHL, HND, TCD, CMR, AZE, BGR, MWI, QAT, PRY, BTN, DZA, SYC, ARM, ALB, MMR, PAK, SWZ, OMN, THA, PSE, BGD, IRN, KAZ, KWT, IRQ, GMB, ZMB, CHL, GEO, GNB, BLZ, SLV, TZA, GIN, ECU, YEM, BRA, NPL, MAR, NIC, LBN, MDA, ZAF, LBY, ROU, BHR, BDI, GHA, COM, CAF, SAU, COD, UKR, KHM, LKA, ETH, TLS, POL, URY, SLE, TUR, IDN, BEN, SDN, TJK, BOL, SOM, MOZ, AGO, RUS, TUN, SYR, JAM, TGO, DOM, RWA, VUT, LBR, NER, SLB, BFA, CHN, ERI, CIV, MDG, PHL, GNQ, DJI
#> 16                                                                                                                                                                                                                                                                                                                                          Sri Lanka, Mongolia, Iraq, Madagascar, Malawi, South Africa, Bahrain, Guinea-Bissau, Yemen, Rep., Costa Rica, Uzbekistan, Montenegro, Ukraine, Congo, Dem. Rep., Cabo Verde, Zimbabwe, Romania, Peru, Gambia, The, Armenia, Afghanistan, Haiti, Marshall Islands, Bahamas, The, Samoa, Tunisia, Algeria, Libya, Moldova, El Salvador, Chad, Benin, Indonesia, Vietnam, Egypt, Arab Rep., Poland, Ghana, Syrian Arab Republic, Uruguay, Tajikistan, Bosnia and Herzegovina, Bangladesh, Nepal, Kenya, Botswana, Türkiye, Azerbaijan, Georgia, Kuwait, North Macedonia, Dominican Republic, Saudi Arabia, Colombia, Nigeria, Maldives, Thailand, Lebanon, Malaysia, Argentina, Guatemala, Belize, Mexico, Somalia, Federal Republic of, Kosovo, Niger, Vanuatu, Belarus, Honduras, Senegal, India, Kyrgyz Republic, Guinea, Eritrea, Rwanda, Equatorial Guinea, Namibia, Pakistan, Chile, Congo, Rep., Uganda, Burkina Faso, Solomon Islands, Jordan, Nicaragua, Eswatini, Philippines, Paraguay, Croatia, Timor-Leste, Bolivia, Oman, Mozambique, Russian Federation, Qatar, Brazil, Comoros, Morocco, Kazakhstan, Liberia, China, Djibouti, Central African Republic, Zambia, Serbia, Togo, Burundi, Ethiopia, Bhutan, Albania, Tanzania, Angola, Cameroon, Myanmar, West Bank and Gaza, Côte d’Ivoire, Lesotho, Ecuador, Mauritania, Gabon, Bulgaria, Sierra Leone, Jamaica, United Arab Emirates, Mali, Mauritius, Panama, Sudan, Naoero, Cambodia, Kiribati, Seychelles, Iran, Islamic Rep., LKA, MNG, IRQ, MDG, MWI, ZAF, BHR, GNB, YEM, CRI, UZB, MNE, UKR, COD, CPV, ZWE, ROU, PER, GMB, ARM, AFG, HTI, MHL, BHS, WSM, TUN, DZA, LBY, MDA, SLV, TCD, BEN, IDN, VNM, EGY, POL, GHA, SYR, URY, TJK, BIH, BGD, NPL, KEN, BWA, TUR, AZE, GEO, KWT, MKD, DOM, SAU, COL, NGA, MDV, THA, LBN, MYS, ARG, GTM, BLZ, MEX, SOM, XKX, NER, VUT, BLR, HND, SEN, IND, KGZ, GIN, ERI, RWA, GNQ, NAM, PAK, CHL, COG, UGA, BFA, SLB, JOR, NIC, SWZ, PHL, PRY, HRV, TLS, BOL, OMN, MOZ, RUS, QAT, BRA, COM, MAR, KAZ, LBR, CHN, DJI, CAF, ZMB, SRB, TGO, BDI, ETH, BTN, ALB, TZA, AGO, CMR, MMR, PSE, CIV, LSO, ECU, MRT, GAB, BGR, SLE, JAM, ARE, MLI, MUS, PAN, SDN, NRU, KHM, KIR, SYC, IRN
#> 17                                                 Malawi, Tajikistan, Sudan, Russian Federation, Nicaragua, Suriname, Solomon Islands, Egypt, Arab Rep., Mauritania, Liberia, Mali, Ukraine, Samoa, Benin, Panama, Bolivia, Zambia, El Salvador, Micronesia, Fed. Sts., Turkmenistan, Mauritius, Chile, Romania, Kuwait, Peru, China, Equatorial Guinea, Bosnia and Herzegovina, Madagascar, Bulgaria, Cabo Verde, West Bank and Gaza, India, Marshall Islands, Costa Rica, Seychelles, Brazil, Dominican Republic, Jordan, Gambia, The, Oman, Djibouti, Morocco, São Tomé and Príncipe, Dominica, Ethiopia, Uruguay, Algeria, Tuvalu, Colombia, Yemen, Rep., Eritrea, Poland, Botswana, Palau, Grenada, Zimbabwe, Nepal, Vietnam, Guyana, Kenya, Malaysia, Kosovo, United Arab Emirates, Tonga, Libya, Myanmar, Iraq, Honduras, Kiribati, Tanzania, Ecuador, Sierra Leone, Belarus, Fiji, Central African Republic, Bahrain, Togo, Vanuatu, Sri Lanka, Cambodia, South Sudan, Lao PDR, Albania, Nigeria, Burundi, Iran, Islamic Rep., Barbados, Philippines, Mozambique, Bhutan, Thailand, Syrian Arab Republic, Papua New Guinea, Chad, Bahamas, The, Haiti, Armenia, Côte d’Ivoire, Guinea-Bissau, Azerbaijan, Tunisia, Uzbekistan, Belize, Montenegro, St. Vincent and the Grenadines, Angola, Kazakhstan, Congo, Dem. Rep., Lesotho, North Macedonia, Jamaica, Indonesia, Trinidad and Tobago, South Africa, Ghana, Comoros, Croatia, Cameroon, Moldova, Maldives, Argentina, Bangladesh, Türkiye, Georgia, Senegal, St. Lucia, Qatar, Namibia, Pakistan, Timor-Leste, Congo, Rep., Uganda, Mongolia, Afghanistan, Rwanda, Guinea, Kyrgyz Republic, Serbia, Niger, Lebanon, Burkina Faso, Gabon, Mexico, Guatemala, Paraguay, Eswatini, Saudi Arabia, MWI, TJK, SDN, RUS, NIC, SUR, SLB, EGY, MRT, LBR, MLI, UKR, WSM, BEN, PAN, BOL, ZMB, SLV, FSM, TKM, MUS, CHL, ROU, KWT, PER, CHN, GNQ, BIH, MDG, BGR, CPV, PSE, IND, MHL, CRI, SYC, BRA, DOM, JOR, GMB, OMN, DJI, MAR, STP, DMA, ETH, URY, DZA, TUV, COL, YEM, ERI, POL, BWA, PLW, GRD, ZWE, NPL, VNM, GUY, KEN, MYS, XKX, ARE, TON, LBY, MMR, IRQ, HND, KIR, TZA, ECU, SLE, BLR, FJI, CAF, BHR, TGO, VUT, LKA, KHM, SSD, LAO, ALB, NGA, BDI, IRN, BRB, PHL, MOZ, BTN, THA, SYR, PNG, TCD, BHS, HTI, ARM, CIV, GNB, AZE, TUN, UZB, BLZ, MNE, VCT, AGO, KAZ, COD, LSO, MKD, JAM, IDN, TTO, ZAF, GHA, COM, HRV, CMR, MDA, MDV, ARG, BGD, TUR, GEO, SEN, LCA, QAT, NAM, PAK, TLS, COG, UGA, MNG, AFG, RWA, GIN, KGZ, SRB, NER, LBN, BFA, GAB, MEX, GTM, PRY, SWZ, SAU
#> 18                                                  Mongolia, Timor-Leste, Brazil, Qatar, Jordan, North Macedonia, Nigeria, Ghana, Pakistan, Malawi, Angola, South Sudan, St. Lucia, Russian Federation, Bhutan, Uruguay, Congo, Rep., Gambia, The, Kenya, Malaysia, Ethiopia, Burkina Faso, Gabon, Eritrea, St. Vincent and the Grenadines, Poland, Mexico, Guyana, Serbia, Thailand, Honduras, Colombia, Vanuatu, Belize, Mali, Sri Lanka, Zambia, Türkiye, Tanzania, Niger, Burundi, Egypt, Arab Rep., Botswana, Lao PDR, Cameroon, Guinea, Uzbekistan, Morocco, Mauritius, Palau, Iran, Islamic Rep., Congo, Dem. Rep., Central African Republic, Barbados, Ukraine, Kiribati, Syrian Arab Republic, Trinidad and Tobago, Samoa, Algeria, Grenada, Maldives, Tunisia, Equatorial Guinea, Micronesia, Fed. Sts., Albania, Oman, Senegal, Indonesia, China, Afghanistan, Bosnia and Herzegovina, Bahrain, Seychelles, Benin, Azerbaijan, São Tomé and Príncipe, Bulgaria, Kuwait, Vietnam, Kazakhstan, Romania, Georgia, Costa Rica, Zimbabwe, Turkmenistan, Sierra Leone, United Arab Emirates, Cabo Verde, Panama, Belarus, Lebanon, Chile, Nepal, Togo, Armenia, Fiji, Iraq, Somalia, Federal Republic of, Côte d’Ivoire, Moldova, Tajikistan, Papua New Guinea, Dominican Republic, Tonga, Peru, Sudan, Rwanda, Suriname, Mauritania, Madagascar, Chad, Bahamas, The, India, Cambodia, Philippines, West Bank and Gaza, Kyrgyz Republic, Yemen, Rep., Myanmar, Saudi Arabia, Lesotho, Montenegro, El Salvador, Uganda, Bolivia, Croatia, Jamaica, Kosovo, Ecuador, Comoros, Dominica, Guatemala, Mozambique, South Africa, Solomon Islands, Paraguay, Liberia, Haiti, Nicaragua, Guinea-Bissau, Eswatini, Namibia, Argentina, Libya, Bangladesh, Djibouti, MNG, TLS, BRA, QAT, JOR, MKD, NGA, GHA, PAK, MWI, AGO, SSD, LCA, RUS, BTN, URY, COG, GMB, KEN, MYS, ETH, BFA, GAB, ERI, VCT, POL, MEX, GUY, SRB, THA, HND, COL, VUT, BLZ, MLI, LKA, ZMB, TUR, TZA, NER, BDI, EGY, BWA, LAO, CMR, GIN, UZB, MAR, MUS, PLW, IRN, COD, CAF, BRB, UKR, KIR, SYR, TTO, WSM, DZA, GRD, MDV, TUN, GNQ, FSM, ALB, OMN, SEN, IDN, CHN, AFG, BIH, BHR, SYC, BEN, AZE, STP, BGR, KWT, VNM, KAZ, ROU, GEO, CRI, ZWE, TKM, SLE, ARE, CPV, PAN, BLR, LBN, CHL, NPL, TGO, ARM, FJI, IRQ, SOM, CIV, MDA, TJK, PNG, DOM, TON, PER, SDN, RWA, SUR, MRT, MDG, TCD, BHS, IND, KHM, PHL, PSE, KGZ, YEM, MMR, SAU, LSO, MNE, SLV, UGA, BOL, HRV, JAM, XKX, ECU, COM, DMA, GTM, MOZ, ZAF, SLB, PRY, LBR, HTI, NIC, GNB, SWZ, NAM, ARG, LBY, BGD, DJI
#> 19 Cambodia, Kyrgyz Republic, Botswana, Eswatini, Kenya, Kosovo, India, Vietnam, Burundi, El Salvador, China, Angola, Equatorial Guinea, Fiji, Micronesia, Fed. Sts., Jamaica, Lebanon, Ecuador, Romania, Liberia, Chile, Guyana, Mongolia, Gambia, The, Yemen, Rep., Vanuatu, Myanmar, Benin, Algeria, Trinidad and Tobago, Syrian Arab Republic, St. Vincent and the Grenadines, Seychelles, Dominica, Bangladesh, Pakistan, Tajikistan, Dominican Republic, Bahrain, Kuwait, Uganda, Thailand, Mauritius, Nigeria, Philippines, Bahamas, The, Malaysia, Kiribati, Morocco, Samoa, Honduras, Nepal, Zambia, Argentina, Palau, Maldives, Grenada, Uruguay, Congo, Dem. Rep., Belarus, Rwanda, Tunisia, Central African Republic, Iraq, Congo, Rep., Bulgaria, Cameroon, Cabo Verde, Barbados, Naoero, Tonga, Colombia, Papua New Guinea, Oman, Türkiye, South Sudan, Tanzania, Croatia, Niger, Qatar, Solomon Islands, Nicaragua, Namibia, Tuvalu, Jordan, Sudan, Zimbabwe, Turkmenistan, Chad, Ethiopia, St. Lucia, Lesotho, Mozambique, Egypt, Arab Rep., Eritrea, Bhutan, Sri Lanka, Kazakhstan, Belize, Madagascar, Uzbekistan, Senegal, West Bank and Gaza, Guinea, Timor-Leste, Azerbaijan, Côte d’Ivoire, Bolivia, Mali, Togo, Mexico, Serbia, Montenegro, Lao PDR, Haiti, North Macedonia, Afghanistan, Paraguay, Albania, Mauritania, Sierra Leone, Guatemala, South Africa, Somalia, Federal Republic of, Djibouti, United Arab Emirates, Ghana, Moldova, Marshall Islands, Costa Rica, Panama, Guinea-Bissau, São Tomé and Príncipe, Ukraine, Russian Federation, Gabon, Burkina Faso, Suriname, Georgia, Comoros, Libya, Poland, Brazil, Peru, Saudi Arabia, Indonesia, Bosnia and Herzegovina, Malawi, Iran, Islamic Rep., Armenia, KHM, KGZ, BWA, SWZ, KEN, XKX, IND, VNM, BDI, SLV, CHN, AGO, GNQ, FJI, FSM, JAM, LBN, ECU, ROU, LBR, CHL, GUY, MNG, GMB, YEM, VUT, MMR, BEN, DZA, TTO, SYR, VCT, SYC, DMA, BGD, PAK, TJK, DOM, BHR, KWT, UGA, THA, MUS, NGA, PHL, BHS, MYS, KIR, MAR, WSM, HND, NPL, ZMB, ARG, PLW, MDV, GRD, URY, COD, BLR, RWA, TUN, CAF, IRQ, COG, BGR, CMR, CPV, BRB, NRU, TON, COL, PNG, OMN, TUR, SSD, TZA, HRV, NER, QAT, SLB, NIC, NAM, TUV, JOR, SDN, ZWE, TKM, TCD, ETH, LCA, LSO, MOZ, EGY, ERI, BTN, LKA, KAZ, BLZ, MDG, UZB, SEN, PSE, GIN, TLS, AZE, CIV, BOL, MLI, TGO, MEX, SRB, MNE, LAO, HTI, MKD, AFG, PRY, ALB, MRT, SLE, GTM, ZAF, SOM, DJI, ARE, GHA, MDA, MHL, CRI, PAN, GNB, STP, UKR, RUS, GAB, BFA, SUR, GEO, COM, LBY, POL, BRA, PER, SAU, IDN, BIH, MWI, IRN, ARM
#> 20                                                                     Kuwait, Sierra Leone, Tunisia, Djibouti, Morocco, Montenegro, Benin, Bangladesh, Fiji, Paraguay, Malawi, Panama, India, Bhutan, Saudi Arabia, Belarus, Mongolia, Kazakhstan, Burundi, Solomon Islands, Vietnam, Ecuador, Cambodia, Kyrgyz Republic, Brazil, North Macedonia, Maldives, Congo, Dem. Rep., Kiribati, Papua New Guinea, Iran, Islamic Rep., Samoa, Namibia, Gambia, The, Uzbekistan, Syrian Arab Republic, São Tomé and Príncipe, Ukraine, South Africa, Tanzania, United Arab Emirates, El Salvador, Uganda, Lebanon, Mauritius, Qatar, Dominican Republic, Moldova, Pakistan, Bolivia, Bahrain, Cameroon, Lesotho, Ethiopia, Albania, Liberia, Thailand, Ghana, Chile, Sudan, Congo, Rep., Nicaragua, Peru, Nepal, Guinea, Bahamas, The, Barbados, Mali, Senegal, Somalia, Federal Republic of, Egypt, Arab Rep., Algeria, Kenya, Guyana, Afghanistan, Angola, Croatia, Colombia, Georgia, Mexico, Armenia, South Sudan, Malaysia, Sri Lanka, Kosovo, Bulgaria, Romania, Comoros, Rwanda, Palau, Eswatini, Belize, Oman, Vanuatu, Serbia, Burkina Faso, Chad, Philippines, Cabo Verde, Mauritania, China, Poland, Yemen, Rep., Grenada, West Bank and Gaza, Zimbabwe, Haiti, Iraq, Myanmar, Micronesia, Fed. Sts., Zambia, Jamaica, Argentina, Guinea-Bissau, Uruguay, Libya, Suriname, Türkiye, Nigeria, Timor-Leste, Lao PDR, Dominica, Azerbaijan, Russian Federation, Indonesia, Guatemala, St. Vincent and the Grenadines, Costa Rica, Botswana, Seychelles, Niger, Togo, Madagascar, Honduras, Tonga, Gabon, Central African Republic, Côte d’Ivoire, St. Lucia, Jordan, Tajikistan, Eritrea, Trinidad and Tobago, Mozambique, Equatorial Guinea, Bosnia and Herzegovina, KWT, SLE, TUN, DJI, MAR, MNE, BEN, BGD, FJI, PRY, MWI, PAN, IND, BTN, SAU, BLR, MNG, KAZ, BDI, SLB, VNM, ECU, KHM, KGZ, BRA, MKD, MDV, COD, KIR, PNG, IRN, WSM, NAM, GMB, UZB, SYR, STP, UKR, ZAF, TZA, ARE, SLV, UGA, LBN, MUS, QAT, DOM, MDA, PAK, BOL, BHR, CMR, LSO, ETH, ALB, LBR, THA, GHA, CHL, SDN, COG, NIC, PER, NPL, GIN, BHS, BRB, MLI, SEN, SOM, EGY, DZA, KEN, GUY, AFG, AGO, HRV, COL, GEO, MEX, ARM, SSD, MYS, LKA, XKX, BGR, ROU, COM, RWA, PLW, SWZ, BLZ, OMN, VUT, SRB, BFA, TCD, PHL, CPV, MRT, CHN, POL, YEM, GRD, PSE, ZWE, HTI, IRQ, MMR, FSM, ZMB, JAM, ARG, GNB, URY, LBY, SUR, TUR, NGA, TLS, LAO, DMA, AZE, RUS, IDN, GTM, VCT, CRI, BWA, SYC, NER, TGO, MDG, HND, TON, GAB, CAF, CIV, LCA, JOR, TJK, ERI, TTO, MOZ, GNQ, BIH
#> 21                                                                                                                                                                                                                                                                                                                                          Senegal, Moldova, Uruguay, Ukraine, Armenia, Nepal, Egypt, Arab Rep., Seychelles, Vietnam, Central African Republic, Congo, Dem. Rep., Libya, Somalia, Federal Republic of, United Arab Emirates, Philippines, Niger, Angola, Benin, Lesotho, Maldives, Qatar, Guinea-Bissau, Saudi Arabia, Thailand, Romania, Eswatini, Tanzania, Mauritius, Pakistan, Samoa, Brazil, Haiti, Sierra Leone, Mali, Gambia, The, Togo, Georgia, Syrian Arab Republic, Burundi, Kiribati, Vanuatu, Nigeria, Dominican Republic, Oman, Morocco, El Salvador, Ghana, Nicaragua, Kosovo, Uganda, Kuwait, Zimbabwe, Côte d’Ivoire, Mozambique, Tunisia, Iraq, China, Iran, Islamic Rep., Eritrea, Myanmar, Djibouti, Burkina Faso, Ecuador, Peru, Chile, Bahamas, The, Colombia, Sri Lanka, Honduras, Panama, Paraguay, Belarus, Ethiopia, Timor-Leste, Bolivia, Jamaica, Serbia, Kazakhstan, Azerbaijan, Algeria, Tajikistan, Poland, Rwanda, Russian Federation, Sudan, Kenya, Gabon, Yemen, Rep., Comoros, Cambodia, Chad, Albania, Cabo Verde, Kyrgyz Republic, Afghanistan, Bosnia and Herzegovina, Costa Rica, Jordan, Zambia, Bulgaria, Mauritania, Malawi, Liberia, West Bank and Gaza, Belize, Naoero, Botswana, Congo, Rep., Namibia, Mexico, Mongolia, Guatemala, Madagascar, Montenegro, Indonesia, Bhutan, Solomon Islands, Malaysia, Cameroon, Uzbekistan, Argentina, Marshall Islands, South Africa, Croatia, Guinea, Bahrain, Lebanon, Equatorial Guinea, North Macedonia, Bangladesh, India, Türkiye, SEN, MDA, URY, UKR, ARM, NPL, EGY, SYC, VNM, CAF, COD, LBY, SOM, ARE, PHL, NER, AGO, BEN, LSO, MDV, QAT, GNB, SAU, THA, ROU, SWZ, TZA, MUS, PAK, WSM, BRA, HTI, SLE, MLI, GMB, TGO, GEO, SYR, BDI, KIR, VUT, NGA, DOM, OMN, MAR, SLV, GHA, NIC, XKX, UGA, KWT, ZWE, CIV, MOZ, TUN, IRQ, CHN, IRN, ERI, MMR, DJI, BFA, ECU, PER, CHL, BHS, COL, LKA, HND, PAN, PRY, BLR, ETH, TLS, BOL, JAM, SRB, KAZ, AZE, DZA, TJK, POL, RWA, RUS, SDN, KEN, GAB, YEM, COM, KHM, TCD, ALB, CPV, KGZ, AFG, BIH, CRI, JOR, ZMB, BGR, MRT, MWI, LBR, PSE, BLZ, NRU, BWA, COG, NAM, MEX, MNG, GTM, MDG, MNE, IDN, BTN, SLB, MYS, CMR, UZB, ARG, MHL, ZAF, HRV, GIN, BHR, LBN, GNQ, MKD, BGD, IND, TUR
#> 22                                                 Mali, Rwanda, Mauritania, Zimbabwe, Kenya, Croatia, Paraguay, Equatorial Guinea, Chad, Djibouti, Uganda, Nigeria, Turkmenistan, Central African Republic, Moldova, Iran, Islamic Rep., Egypt, Arab Rep., Niger, Vietnam, Sri Lanka, Mauritius, Cambodia, Nicaragua, Romania, Senegal, Serbia, Sudan, Qatar, China, Montenegro, Ecuador, Kuwait, Marshall Islands, Syrian Arab Republic, Cabo Verde, Mongolia, Bulgaria, Kosovo, Suriname, Guatemala, Afghanistan, Iraq, Namibia, Bosnia and Herzegovina, Malaysia, Botswana, Gabon, Ukraine, Grenada, Guyana, Bolivia, Türkiye, Saudi Arabia, Dominican Republic, Colombia, Madagascar, St. Lucia, Tuvalu, São Tomé and Príncipe, Indonesia, Angola, Mozambique, Guinea, Mexico, Chile, Azerbaijan, Palau, Zambia, Micronesia, Fed. Sts., Panama, Dominica, Philippines, Seychelles, Barbados, Benin, Lesotho, Fiji, United Arab Emirates, Costa Rica, Ghana, Uzbekistan, Argentina, Guinea-Bissau, Bahrain, Cameroon, Lebanon, Albania, South Africa, Malawi, Morocco, Belarus, Samoa, Ethiopia, West Bank and Gaza, Solomon Islands, Congo, Rep., Uruguay, Myanmar, Burkina Faso, Jamaica, El Salvador, Bhutan, Pakistan, Tunisia, Kiribati, Libya, Peru, Lao PDR, Congo, Dem. Rep., Maldives, India, Vanuatu, St. Vincent and the Grenadines, Haiti, Côte d’Ivoire, Russian Federation, Eritrea, Tanzania, Trinidad and Tobago, Algeria, Yemen, Rep., Thailand, Jordan, Timor-Leste, Poland, Honduras, Armenia, Belize, Gambia, The, North Macedonia, Liberia, Kyrgyz Republic, Bangladesh, Eswatini, Papua New Guinea, Comoros, Nepal, Kazakhstan, Burundi, Oman, Brazil, Togo, Tajikistan, Bahamas, The, Sierra Leone, Georgia, South Sudan, Tonga, MLI, RWA, MRT, ZWE, KEN, HRV, PRY, GNQ, TCD, DJI, UGA, NGA, TKM, CAF, MDA, IRN, EGY, NER, VNM, LKA, MUS, KHM, NIC, ROU, SEN, SRB, SDN, QAT, CHN, MNE, ECU, KWT, MHL, SYR, CPV, MNG, BGR, XKX, SUR, GTM, AFG, IRQ, NAM, BIH, MYS, BWA, GAB, UKR, GRD, GUY, BOL, TUR, SAU, DOM, COL, MDG, LCA, TUV, STP, IDN, AGO, MOZ, GIN, MEX, CHL, AZE, PLW, ZMB, FSM, PAN, DMA, PHL, SYC, BRB, BEN, LSO, FJI, ARE, CRI, GHA, UZB, ARG, GNB, BHR, CMR, LBN, ALB, ZAF, MWI, MAR, BLR, WSM, ETH, PSE, SLB, COG, URY, MMR, BFA, JAM, SLV, BTN, PAK, TUN, KIR, LBY, PER, LAO, COD, MDV, IND, VUT, VCT, HTI, CIV, RUS, ERI, TZA, TTO, DZA, YEM, THA, JOR, TLS, POL, HND, ARM, BLZ, GMB, MKD, LBR, KGZ, BGD, SWZ, PNG, COM, NPL, KAZ, BDI, OMN, BRA, TGO, TJK, BHS, SLE, GEO, SSD, TON
#> 23                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       Kosovo, Tuvalu, Marshall Islands, West Bank and Gaza, Naoero, XKX, TUV, MHL, PSE, NRU
#> 24                                                                                                           Djibouti, Zimbabwe, Saudi Arabia, Thailand, Congo, Dem. Rep., Lesotho, Ethiopia, Nigeria, Maldives, Liberia, Colombia, Sierra Leone, Somalia, Federal Republic of, Tonga, Madagascar, Tunisia, Armenia, South Africa, Belize, Guinea-Bissau, Serbia, Solomon Islands, Pakistan, Sudan, Ukraine, Senegal, Yemen, Rep., Russian Federation, Georgia, Palau, Bolivia, Cabo Verde, Nepal, Mongolia, Comoros, Ghana, Bulgaria, Togo, Poland, Myanmar, Jamaica, Iraq, Cambodia, Niger, Vanuatu, Tajikistan, Seychelles, Iran, Islamic Rep., Albania, Eritrea, Mexico, Afghanistan, Uruguay, St. Vincent and the Grenadines, Gambia, The, Grenada, Bosnia and Herzegovina, Brazil, Côte d’Ivoire, Tanzania, Papua New Guinea, Panama, El Salvador, Haiti, Oman, Uzbekistan, Qatar, Uganda, Mauritius, Congo, Rep., Jordan, Zambia, China, Guinea, Vietnam, Dominican Republic, Montenegro, Indonesia, Namibia, South Sudan, Morocco, São Tomé and Príncipe, Algeria, Chad, Bahamas, The, Benin, Burkina Faso, Kuwait, Chile, Lebanon, Kiribati, Libya, Belarus, Lao PDR, Ecuador, Guyana, Dominica, Kyrgyz Republic, Peru, Mali, Rwanda, Fiji, Moldova, Micronesia, Fed. Sts., Malaysia, Eswatini, Trinidad and Tobago, Nicaragua, Kazakhstan, Paraguay, Suriname, Honduras, Egypt, Arab Rep., Malawi, Mozambique, Azerbaijan, Barbados, Türkiye, St. Lucia, Burundi, Philippines, Bangladesh, Bhutan, Syrian Arab Republic, United Arab Emirates, Guatemala, Gabon, Croatia, India, Central African Republic, North Macedonia, Sri Lanka, Romania, Costa Rica, Mauritania, Cameroon, Bahrain, Angola, Argentina, Kenya, Equatorial Guinea, Samoa, Timor-Leste, Botswana, DJI, ZWE, SAU, THA, COD, LSO, ETH, NGA, MDV, LBR, COL, SLE, SOM, TON, MDG, TUN, ARM, ZAF, BLZ, GNB, SRB, SLB, PAK, SDN, UKR, SEN, YEM, RUS, GEO, PLW, BOL, CPV, NPL, MNG, COM, GHA, BGR, TGO, POL, MMR, JAM, IRQ, KHM, NER, VUT, TJK, SYC, IRN, ALB, ERI, MEX, AFG, URY, VCT, GMB, GRD, BIH, BRA, CIV, TZA, PNG, PAN, SLV, HTI, OMN, UZB, QAT, UGA, MUS, COG, JOR, ZMB, CHN, GIN, VNM, DOM, MNE, IDN, NAM, SSD, MAR, STP, DZA, TCD, BHS, BEN, BFA, KWT, CHL, LBN, KIR, LBY, BLR, LAO, ECU, GUY, DMA, KGZ, PER, MLI, RWA, FJI, MDA, FSM, MYS, SWZ, TTO, NIC, KAZ, PRY, SUR, HND, EGY, MWI, MOZ, AZE, BRB, TUR, LCA, BDI, PHL, BGD, BTN, SYR, ARE, GTM, GAB, HRV, IND, CAF, MKD, LKA, ROU, CRI, MRT, CMR, BHR, AGO, ARG, KEN, GNQ, WSM, TLS, BWA
#> 25                                                                                                                                                                                                                                                                                                                                                       Burkina Faso, Burundi, Kuwait, Togo, Mauritius, Thailand, Moldova, Philippines, Sudan, Afghanistan, Solomon Islands, Syrian Arab Republic, Tanzania, Benin, Jordan, Guinea, Armenia, Uzbekistan, Mauritania, Kiribati, Tunisia, Maldives, Ghana, Mali, Bhutan, Colombia, Kazakhstan, Vietnam, Sierra Leone, Namibia, Gabon, Chad, Pakistan, Oman, Iraq, Central African Republic, Panama, Marshall Islands, Samoa, Argentina, Bulgaria, Yemen, Rep., Sri Lanka, Guatemala, Congo, Rep., Bolivia, Kyrgyz Republic, Equatorial Guinea, Uganda, El Salvador, Serbia, Jamaica, Nigeria, Congo, Dem. Rep., Rwanda, Mongolia, Ethiopia, Mozambique, Liberia, Niger, Azerbaijan, Russian Federation, Qatar, Zambia, Croatia, Djibouti, Belarus, South Africa, Bahamas, The, China, India, Malawi, Peru, Indonesia, Somalia, Federal Republic of, Türkiye, Kenya, Haiti, Chile, Romania, Algeria, Eswatini, Egypt, Arab Rep., Iran, Islamic Rep., Nicaragua, Georgia, United Arab Emirates, Gambia, The, Tajikistan, Comoros, Honduras, Bangladesh, Senegal, Paraguay, Cambodia, Lebanon, Seychelles, Montenegro, Belize, Morocco, Uruguay, Côte d’Ivoire, Guinea-Bissau, Madagascar, Costa Rica, Myanmar, Cabo Verde, Angola, Poland, Mexico, Cameroon, Bosnia and Herzegovina, Brazil, Vanuatu, Eritrea, West Bank and Gaza, Malaysia, Nepal, Timor-Leste, Bahrain, Dominican Republic, Ukraine, Kosovo, Lesotho, Libya, Saudi Arabia, Albania, Zimbabwe, Botswana, North Macedonia, Ecuador, BFA, BDI, KWT, TGO, MUS, THA, MDA, PHL, SDN, AFG, SLB, SYR, TZA, BEN, JOR, GIN, ARM, UZB, MRT, KIR, TUN, MDV, GHA, MLI, BTN, COL, KAZ, VNM, SLE, NAM, GAB, TCD, PAK, OMN, IRQ, CAF, PAN, MHL, WSM, ARG, BGR, YEM, LKA, GTM, COG, BOL, KGZ, GNQ, UGA, SLV, SRB, JAM, NGA, COD, RWA, MNG, ETH, MOZ, LBR, NER, AZE, RUS, QAT, ZMB, HRV, DJI, BLR, ZAF, BHS, CHN, IND, MWI, PER, IDN, SOM, TUR, KEN, HTI, CHL, ROU, DZA, SWZ, EGY, IRN, NIC, GEO, ARE, GMB, TJK, COM, HND, BGD, SEN, PRY, KHM, LBN, SYC, MNE, BLZ, MAR, URY, CIV, GNB, MDG, CRI, MMR, CPV, AGO, POL, MEX, CMR, BIH, BRA, VUT, ERI, PSE, MYS, NPL, TLS, BHR, DOM, UKR, XKX, LSO, LBY, SAU, ALB, ZWE, BWA, MKD, ECU
#> 26 Bolivia, Oman, Vanuatu, Myanmar, Kazakhstan, Poland, Gambia, The, Brazil, Montenegro, Sri Lanka, Mongolia, Chad, St. Lucia, Naoero, Peru, Uruguay, Ukraine, West Bank and Gaza, Bangladesh, Namibia, Mozambique, Russian Federation, South Africa, Eswatini, Tonga, Saudi Arabia, Tanzania, Turkmenistan, North Macedonia, Suriname, Libya, Guatemala, Kyrgyz Republic, Croatia, Guyana, Sierra Leone, Kosovo, Barbados, Bahrain, Rwanda, Burundi, Afghanistan, Eritrea, Albania, Côte d’Ivoire, Cameroon, Costa Rica, Comoros, Lesotho, Madagascar, Somalia, Federal Republic of, Bhutan, Algeria, Tajikistan, Mali, Colombia, Guinea, Syrian Arab Republic, Ghana, Serbia, Kiribati, Djibouti, Nigeria, Trinidad and Tobago, Bahamas, The, Belarus, South Sudan, Malaysia, Pakistan, Timor-Leste, Zambia, Jordan, Uganda, Uzbekistan, Central African Republic, Honduras, Marshall Islands, Iraq, Zimbabwe, Sudan, Paraguay, Tuvalu, Chile, Benin, Seychelles, Belize, Samoa, Yemen, Rep., Lebanon, Romania, Tunisia, Papua New Guinea, Armenia, Ecuador, Burkina Faso, Iran, Islamic Rep., Jamaica, Qatar, Grenada, Dominican Republic, Georgia, Guinea-Bissau, Senegal, Cambodia, Gabon, Palau, Congo, Dem. Rep., Morocco, Mexico, Botswana, Vietnam, Micronesia, Fed. Sts., Argentina, São Tomé and Príncipe, Azerbaijan, St. Vincent and the Grenadines, Nicaragua, Haiti, Fiji, Türkiye, India, Mauritania, Kuwait, Mauritius, Malawi, Bulgaria, Dominica, Kenya, Congo, Rep., Nepal, Maldives, Panama, Togo, Thailand, Moldova, Egypt, Arab Rep., United Arab Emirates, Indonesia, Bosnia and Herzegovina, China, Solomon Islands, Lao PDR, Angola, Liberia, Philippines, Equatorial Guinea, Niger, Cabo Verde, El Salvador, Ethiopia, BOL, OMN, VUT, MMR, KAZ, POL, GMB, BRA, MNE, LKA, MNG, TCD, LCA, NRU, PER, URY, UKR, PSE, BGD, NAM, MOZ, RUS, ZAF, SWZ, TON, SAU, TZA, TKM, MKD, SUR, LBY, GTM, KGZ, HRV, GUY, SLE, XKX, BRB, BHR, RWA, BDI, AFG, ERI, ALB, CIV, CMR, CRI, COM, LSO, MDG, SOM, BTN, DZA, TJK, MLI, COL, GIN, SYR, GHA, SRB, KIR, DJI, NGA, TTO, BHS, BLR, SSD, MYS, PAK, TLS, ZMB, JOR, UGA, UZB, CAF, HND, MHL, IRQ, ZWE, SDN, PRY, TUV, CHL, BEN, SYC, BLZ, WSM, YEM, LBN, ROU, TUN, PNG, ARM, ECU, BFA, IRN, JAM, QAT, GRD, DOM, GEO, GNB, SEN, KHM, GAB, PLW, COD, MAR, MEX, BWA, VNM, FSM, ARG, STP, AZE, VCT, NIC, HTI, FJI, TUR, IND, MRT, KWT, MUS, MWI, BGR, DMA, KEN, COG, NPL, MDV, PAN, TGO, THA, MDA, EGY, ARE, IDN, BIH, CHN, SLB, LAO, AGO, LBR, PHL, GNQ, NER, CPV, SLV, ETH
#> 27                                                                                                           Congo, Dem. Rep., Lebanon, Niger, El Salvador, Uganda, Ghana, Madagascar, Haiti, Uzbekistan, Burkina Faso, Barbados, Cambodia, Chile, North Macedonia, Bangladesh, Sierra Leone, Kazakhstan, Croatia, Guinea, Bahrain, Poland, Angola, Tajikistan, Senegal, Samoa, Cabo Verde, Nicaragua, Papua New Guinea, Kuwait, Mozambique, Algeria, Gabon, São Tomé and Príncipe, Kenya, Burundi, Pakistan, Montenegro, Mexico, Qatar, Malaysia, Tanzania, Guatemala, Honduras, Brazil, India, Zimbabwe, Iraq, Tonga, Guyana, Congo, Rep., Bahamas, The, Paraguay, Kiribati, Yemen, Rep., China, Egypt, Arab Rep., Ethiopia, Lao PDR, Iran, Islamic Rep., Solomon Islands, Uruguay, Tunisia, Serbia, Guinea-Bissau, Botswana, Russian Federation, Romania, Palau, Ecuador, United Arab Emirates, Mauritania, South Sudan, Dominican Republic, Chad, Lesotho, Ukraine, Albania, Rwanda, Bulgaria, Türkiye, Peru, Mongolia, Libya, Liberia, Equatorial Guinea, Azerbaijan, Fiji, Suriname, Morocco, Panama, Timor-Leste, Sudan, Trinidad and Tobago, Eritrea, Myanmar, Micronesia, Fed. Sts., Somalia, Federal Republic of, Belize, Togo, Saudi Arabia, Vanuatu, Moldova, Nepal, St. Lucia, Dominica, Namibia, Belarus, Bhutan, Armenia, Philippines, Zambia, Malawi, Costa Rica, Georgia, Maldives, Mauritius, South Africa, Gambia, The, Vietnam, Djibouti, Bolivia, Mali, Benin, Comoros, Nigeria, Afghanistan, Syrian Arab Republic, St. Vincent and the Grenadines, Central African Republic, Kyrgyz Republic, Eswatini, Argentina, Jamaica, Seychelles, Grenada, Oman, Indonesia, Sri Lanka, Cameroon, Côte d’Ivoire, Jordan, Thailand, Colombia, Bosnia and Herzegovina, COD, LBN, NER, SLV, UGA, GHA, MDG, HTI, UZB, BFA, BRB, KHM, CHL, MKD, BGD, SLE, KAZ, HRV, GIN, BHR, POL, AGO, TJK, SEN, WSM, CPV, NIC, PNG, KWT, MOZ, DZA, GAB, STP, KEN, BDI, PAK, MNE, MEX, QAT, MYS, TZA, GTM, HND, BRA, IND, ZWE, IRQ, TON, GUY, COG, BHS, PRY, KIR, YEM, CHN, EGY, ETH, LAO, IRN, SLB, URY, TUN, SRB, GNB, BWA, RUS, ROU, PLW, ECU, ARE, MRT, SSD, DOM, TCD, LSO, UKR, ALB, RWA, BGR, TUR, PER, MNG, LBY, LBR, GNQ, AZE, FJI, SUR, MAR, PAN, TLS, SDN, TTO, ERI, MMR, FSM, SOM, BLZ, TGO, SAU, VUT, MDA, NPL, LCA, DMA, NAM, BLR, BTN, ARM, PHL, ZMB, MWI, CRI, GEO, MDV, MUS, ZAF, GMB, VNM, DJI, BOL, MLI, BEN, COM, NGA, AFG, SYR, VCT, CAF, KGZ, SWZ, ARG, JAM, SYC, GRD, OMN, IDN, LKA, CMR, CIV, JOR, THA, COL, BIH
#> 28 Türkiye, Trinidad and Tobago, Lebanon, Chad, Costa Rica, Moldova, Saudi Arabia, Mozambique, Myanmar, Eswatini, Iraq, Dominica, Azerbaijan, Croatia, Sudan, Congo, Rep., Rwanda, Vanuatu, South Africa, Suriname, Haiti, North Macedonia, Guinea, Jordan, Barbados, Argentina, Paraguay, Sierra Leone, Bhutan, Iran, Islamic Rep., Syrian Arab Republic, Colombia, Mauritania, Grenada, Pakistan, Togo, Palau, Naoero, Mauritius, Tonga, Tanzania, Cambodia, Djibouti, Botswana, Guyana, Mexico, Côte d’Ivoire, Nicaragua, Seychelles, Kiribati, Cameroon, Egypt, Arab Rep., Thailand, China, Bolivia, India, Peru, Central African Republic, El Salvador, Somalia, Federal Republic of, Afghanistan, Romania, Kazakhstan, Serbia, Nepal, Uzbekistan, Fiji, Kyrgyz Republic, Maldives, Oman, Lao PDR, West Bank and Gaza, Georgia, Timor-Leste, Ethiopia, Liberia, Armenia, Burkina Faso, Namibia, United Arab Emirates, Bulgaria, Uganda, Guatemala, Madagascar, Chile, Burundi, Ghana, Marshall Islands, Kosovo, Indonesia, Kuwait, St. Vincent and the Grenadines, Equatorial Guinea, Ukraine, Eritrea, Belize, Albania, Papua New Guinea, Yemen, Rep., Bahrain, Poland, Bangladesh, Brazil, Montenegro, Tajikistan, Belarus, Cabo Verde, Panama, Gabon, Morocco, Angola, Comoros, Mongolia, Algeria, Niger, Zambia, Tuvalu, Nigeria, Zimbabwe, Samoa, Solomon Islands, Uruguay, Malaysia, São Tomé and Príncipe, Micronesia, Fed. Sts., Sri Lanka, Ecuador, Jamaica, South Sudan, Tunisia, Congo, Dem. Rep., Vietnam, Bahamas, The, Guinea-Bissau, Lesotho, Senegal, Russian Federation, Qatar, Bosnia and Herzegovina, Dominican Republic, Honduras, Mali, Philippines, Libya, Malawi, Turkmenistan, Kenya, Gambia, The, Benin, St. Lucia, TUR, TTO, LBN, TCD, CRI, MDA, SAU, MOZ, MMR, SWZ, IRQ, DMA, AZE, HRV, SDN, COG, RWA, VUT, ZAF, SUR, HTI, MKD, GIN, JOR, BRB, ARG, PRY, SLE, BTN, IRN, SYR, COL, MRT, GRD, PAK, TGO, PLW, NRU, MUS, TON, TZA, KHM, DJI, BWA, GUY, MEX, CIV, NIC, SYC, KIR, CMR, EGY, THA, CHN, BOL, IND, PER, CAF, SLV, SOM, AFG, ROU, KAZ, SRB, NPL, UZB, FJI, KGZ, MDV, OMN, LAO, PSE, GEO, TLS, ETH, LBR, ARM, BFA, NAM, ARE, BGR, UGA, GTM, MDG, CHL, BDI, GHA, MHL, XKX, IDN, KWT, VCT, GNQ, UKR, ERI, BLZ, ALB, PNG, YEM, BHR, POL, BGD, BRA, MNE, TJK, BLR, CPV, PAN, GAB, MAR, AGO, COM, MNG, DZA, NER, ZMB, TUV, NGA, ZWE, WSM, SLB, URY, MYS, STP, FSM, LKA, ECU, JAM, SSD, TUN, COD, VNM, BHS, GNB, LSO, SEN, RUS, QAT, BIH, DOM, HND, MLI, PHL, LBY, MWI, TKM, KEN, GMB, BEN, LCA
#> 29                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Angola, Peru, Mongolia, Marshall Islands, Tunisia, Pakistan, Uruguay, Guinea, Madagascar, Mexico, Cambodia, Georgia, Kosovo, Libya, Romania, Algeria, Ukraine, Côte d’Ivoire, Bolivia, Bahamas, The, Uzbekistan, Bulgaria, El Salvador, Comoros, Malaysia, Belarus, Paraguay, Togo, Serbia, Sudan, Congo, Rep., Qatar, Honduras, Armenia, Gabon, Türkiye, Saudi Arabia, Kazakhstan, Afghanistan, Malawi, Mozambique, Iraq, India, Mauritius, Bangladesh, Chad, Oman, Egypt, Arab Rep., Zimbabwe, Djibouti, Dominican Republic, Burkina Faso, Panama, Somalia, Federal Republic of, Congo, Dem. Rep., Moldova, Azerbaijan, Tajikistan, Eswatini, Kuwait, Eritrea, Lebanon, Guinea-Bissau, West Bank and Gaza, Kiribati, North Macedonia, Argentina, Thailand, Costa Rica, Seychelles, Nicaragua, Bosnia and Herzegovina, Niger, Bhutan, Samoa, Uganda, Croatia, Brazil, Vietnam, Botswana, Zambia, Rwanda, Kenya, Namibia, Lesotho, Cameroon, Equatorial Guinea, Nepal, China, Timor-Leste, Poland, Burundi, Albania, Iran, Islamic Rep., Tanzania, South Africa, Colombia, Benin, United Arab Emirates, Belize, Senegal, Vanuatu, Haiti, Bahrain, Chile, Indonesia, Gambia, The, Liberia, Ecuador, Central African Republic, Mauritania, Philippines, Morocco, Guatemala, Solomon Islands, Ethiopia, Sri Lanka, Montenegro, Russian Federation, Ghana, Mali, Kyrgyz Republic, Sierra Leone, Cabo Verde, AGO, PER, MNG, MHL, TUN, PAK, URY, GIN, MDG, MEX, KHM, GEO, XKX, LBY, ROU, DZA, UKR, CIV, BOL, BHS, UZB, BGR, SLV, COM, MYS, BLR, PRY, TGO, SRB, SDN, COG, QAT, HND, ARM, GAB, TUR, SAU, KAZ, AFG, MWI, MOZ, IRQ, IND, MUS, BGD, TCD, OMN, EGY, ZWE, DJI, DOM, BFA, PAN, SOM, COD, MDA, AZE, TJK, SWZ, KWT, ERI, LBN, GNB, PSE, KIR, MKD, ARG, THA, CRI, SYC, NIC, BIH, NER, BTN, WSM, UGA, HRV, BRA, VNM, BWA, ZMB, RWA, KEN, NAM, LSO, CMR, GNQ, NPL, CHN, TLS, POL, BDI, ALB, IRN, TZA, ZAF, COL, BEN, ARE, BLZ, SEN, VUT, HTI, BHR, CHL, IDN, GMB, LBR, ECU, CAF, MRT, PHL, MAR, GTM, SLB, ETH, LKA, MNE, RUS, GHA, MLI, KGZ, SLE, CPV
#> 30                                                                                                                                                                                                                                                                                                                                                                              Tajikistan, Sri Lanka, Nepal, Gambia, The, Djibouti, Vietnam, Congo, Rep., Eswatini, Honduras, India, Paraguay, South Africa, Azerbaijan, Chad, Namibia, Eritrea, Uganda, Philippines, Somalia, Federal Republic of, Kiribati, Peru, Ukraine, Moldova, Botswana, El Salvador, Lesotho, Poland, Montenegro, Cabo Verde, Sierra Leone, Côte d’Ivoire, Tanzania, West Bank and Gaza, Jamaica, Malawi, Algeria, Romania, Morocco, North Macedonia, Kenya, Chile, Uzbekistan, Equatorial Guinea, Togo, Angola, Panama, Benin, Pakistan, Kuwait, Senegal, Ghana, Saudi Arabia, Syrian Arab Republic, Mozambique, Qatar, Costa Rica, Mauritania, Iraq, Rwanda, Kyrgyz Republic, Myanmar, Ethiopia, Jordan, Kosovo, Croatia, Mexico, Kazakhstan, Central African Republic, Bahrain, Indonesia, Bhutan, Libya, Sudan, Serbia, Niger, Nicaragua, Guinea-Bissau, Solomon Islands, Russian Federation, Timor-Leste, Madagascar, Uruguay, Georgia, Zambia, Guinea, Guatemala, Bolivia, Mali, Albania, Yemen, Rep., Oman, Zimbabwe, China, Haiti, Nigeria, Mongolia, Congo, Dem. Rep., Maldives, Burkina Faso, Colombia, Samoa, Iran, Islamic Rep., Bosnia and Herzegovina, Egypt, Arab Rep., Brazil, Seychelles, Gabon, Vanuatu, Cambodia, Dominican Republic, Argentina, Afghanistan, United Arab Emirates, Türkiye, Belize, Comoros, Liberia, Bangladesh, Malaysia, Bulgaria, Lebanon, Mauritius, Cameroon, Belarus, Burundi, Bahamas, The, Ecuador, Thailand, Armenia, Tunisia, TJK, LKA, NPL, GMB, DJI, VNM, COG, SWZ, HND, IND, PRY, ZAF, AZE, TCD, NAM, ERI, UGA, PHL, SOM, KIR, PER, UKR, MDA, BWA, SLV, LSO, POL, MNE, CPV, SLE, CIV, TZA, PSE, JAM, MWI, DZA, ROU, MAR, MKD, KEN, CHL, UZB, GNQ, TGO, AGO, PAN, BEN, PAK, KWT, SEN, GHA, SAU, SYR, MOZ, QAT, CRI, MRT, IRQ, RWA, KGZ, MMR, ETH, JOR, XKX, HRV, MEX, KAZ, CAF, BHR, IDN, BTN, LBY, SDN, SRB, NER, NIC, GNB, SLB, RUS, TLS, MDG, URY, GEO, ZMB, GIN, GTM, BOL, MLI, ALB, YEM, OMN, ZWE, CHN, HTI, NGA, MNG, COD, MDV, BFA, COL, WSM, IRN, BIH, EGY, BRA, SYC, GAB, VUT, KHM, DOM, ARG, AFG, ARE, TUR, BLZ, COM, LBR, BGD, MYS, BGR, LBN, MUS, CMR, BLR, BDI, BHS, ECU, THA, ARM, TUN
#> 31                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Gambia, The, Qatar, Poland, Burkina Faso, Iran, Islamic Rep., Sudan, Albania, Kazakhstan, Seychelles, Eritrea, Iraq, Zimbabwe, Namibia, Peru, Bolivia, Mali, Nicaragua, Moldova, Honduras, Kosovo, Mozambique, Armenia, Brazil, Malawi, Mauritania, Indonesia, Ukraine, Afghanistan, Timor-Leste, United Arab Emirates, Chile, Chad, Uganda, Senegal, Mauritius, India, South Africa, Samoa, Uzbekistan, Angola, Eswatini, El Salvador, Burundi, Mongolia, Nepal, Thailand, Equatorial Guinea, Belize, Botswana, Niger, Montenegro, Pakistan, Serbia, Bahrain, Central African Republic, Guinea-Bissau, Paraguay, Colombia, Cabo Verde, Cameroon, Saudi Arabia, Kenya, Bangladesh, Romania, West Bank and Gaza, Uruguay, Tanzania, Kyrgyz Republic, Panama, Liberia, Togo, Argentina, Bahamas, The, Tunisia, Belarus, Guinea, Türkiye, Costa Rica, Djibouti, Congo, Dem. Rep., Bosnia and Herzegovina, Bulgaria, Solomon Islands, Croatia, Comoros, China, Algeria, Côte d’Ivoire, Azerbaijan, Philippines, Ecuador, Dominican Republic, Georgia, Russian Federation, Guatemala, Oman, Ghana, Kuwait, Mexico, Rwanda, Bhutan, Kiribati, Egypt, Arab Rep., Ethiopia, Vanuatu, Gabon, Malaysia, Sri Lanka, Zambia, Somalia, Federal Republic of, Lesotho, Madagascar, Lebanon, Vietnam, Congo, Rep., Tajikistan, Morocco, Benin, Libya, Sierra Leone, Marshall Islands, North Macedonia, Haiti, Cambodia, GMB, QAT, POL, BFA, IRN, SDN, ALB, KAZ, SYC, ERI, IRQ, ZWE, NAM, PER, BOL, MLI, NIC, MDA, HND, XKX, MOZ, ARM, BRA, MWI, MRT, IDN, UKR, AFG, TLS, ARE, CHL, TCD, UGA, SEN, MUS, IND, ZAF, WSM, UZB, AGO, SWZ, SLV, BDI, MNG, NPL, THA, GNQ, BLZ, BWA, NER, MNE, PAK, SRB, BHR, CAF, GNB, PRY, COL, CPV, CMR, SAU, KEN, BGD, ROU, PSE, URY, TZA, KGZ, PAN, LBR, TGO, ARG, BHS, TUN, BLR, GIN, TUR, CRI, DJI, COD, BIH, BGR, SLB, HRV, COM, CHN, DZA, CIV, AZE, PHL, ECU, DOM, GEO, RUS, GTM, OMN, GHA, KWT, MEX, RWA, BTN, KIR, EGY, ETH, VUT, GAB, MYS, LKA, ZMB, SOM, LSO, MDG, LBN, VNM, COG, TJK, MAR, BEN, LBY, SLE, MHL, MKD, HTI, KHM
#> 32                                                              Tonga, Sierra Leone, Vanuatu, Guatemala, Uzbekistan, Iran, Islamic Rep., Panama, Paraguay, Burundi, Libya, Botswana, Bahamas, The, Bahrain, Bulgaria, Yemen, Rep., Philippines, Vietnam, Jordan, Lao PDR, Indonesia, Pakistan, Seychelles, Trinidad and Tobago, Uruguay, Côte d’Ivoire, Türkiye, Eswatini, Iraq, Congo, Dem. Rep., Honduras, Niger, Eritrea, Bosnia and Herzegovina, North Macedonia, Mauritania, Congo, Rep., Dominican Republic, Lebanon, Timor-Leste, Belize, Bolivia, Gabon, Poland, Dominica, Syrian Arab Republic, India, Mauritius, Sudan, Grenada, Nepal, Georgia, South Sudan, Mongolia, Haiti, Afghanistan, Saudi Arabia, Guinea, Tanzania, São Tomé and Príncipe, El Salvador, Algeria, Oman, Tunisia, Zambia, Maldives, Barbados, Central African Republic, Morocco, St. Lucia, Gambia, The, Thailand, Kazakhstan, Cabo Verde, Mali, Fiji, Uganda, Bhutan, China, Ethiopia, Malawi, Lesotho, Ghana, Moldova, Namibia, Colombia, Romania, Mozambique, Montenegro, Brazil, Senegal, Equatorial Guinea, Bangladesh, South Africa, Albania, Jamaica, Rwanda, Benin, Liberia, Kosovo, Tajikistan, Belarus, Myanmar, Micronesia, Fed. Sts., Nicaragua, Qatar, Togo, Burkina Faso, Kiribati, United Arab Emirates, Mexico, Costa Rica, Guinea-Bissau, Nigeria, Ecuador, Samoa, Angola, West Bank and Gaza, Sri Lanka, Kyrgyz Republic, Croatia, Cambodia, Serbia, Chile, Marshall Islands, Ukraine, Russian Federation, Azerbaijan, Turkmenistan, Chad, Kuwait, Djibouti, Armenia, Madagascar, Zimbabwe, Malaysia, Egypt, Arab Rep., Guyana, Cameroon, Argentina, Comoros, Palau, Solomon Islands, St. Vincent and the Grenadines, Peru, Kenya, Suriname, Papua New Guinea, TON, SLE, VUT, GTM, UZB, IRN, PAN, PRY, BDI, LBY, BWA, BHS, BHR, BGR, YEM, PHL, VNM, JOR, LAO, IDN, PAK, SYC, TTO, URY, CIV, TUR, SWZ, IRQ, COD, HND, NER, ERI, BIH, MKD, MRT, COG, DOM, LBN, TLS, BLZ, BOL, GAB, POL, DMA, SYR, IND, MUS, SDN, GRD, NPL, GEO, SSD, MNG, HTI, AFG, SAU, GIN, TZA, STP, SLV, DZA, OMN, TUN, ZMB, MDV, BRB, CAF, MAR, LCA, GMB, THA, KAZ, CPV, MLI, FJI, UGA, BTN, CHN, ETH, MWI, LSO, GHA, MDA, NAM, COL, ROU, MOZ, MNE, BRA, SEN, GNQ, BGD, ZAF, ALB, JAM, RWA, BEN, LBR, XKX, TJK, BLR, MMR, FSM, NIC, QAT, TGO, BFA, KIR, ARE, MEX, CRI, GNB, NGA, ECU, WSM, AGO, PSE, LKA, KGZ, HRV, KHM, SRB, CHL, MHL, UKR, RUS, AZE, TKM, TCD, KWT, DJI, ARM, MDG, ZWE, MYS, EGY, GUY, CMR, ARG, COM, PLW, SLB, VCT, PER, KEN, SUR, PNG
#> 33                                                  Poland, Panama, Guinea, Oman, Indonesia, Mexico, Algeria, Eswatini, Comoros, Morocco, Eritrea, Jordan, Libya, Fiji, Armenia, Kuwait, Haiti, Ukraine, Somalia, Federal Republic of, Togo, Djibouti, Bolivia, Central African Republic, Nigeria, West Bank and Gaza, Croatia, Vietnam, South Africa, Chad, Seychelles, Dominican Republic, Cambodia, Colombia, Romania, Sierra Leone, Kenya, Yemen, Rep., Mozambique, Solomon Islands, Bahrain, St. Vincent and the Grenadines, Benin, Grenada, Zambia, Bhutan, Kiribati, Iraq, Angola, China, Tanzania, Belize, Congo, Dem. Rep., Burundi, Uzbekistan, Moldova, Ethiopia, Namibia, Suriname, Honduras, Senegal, United Arab Emirates, Guatemala, Qatar, Syrian Arab Republic, Sudan, Botswana, Niger, Albania, Serbia, Rwanda, Belarus, India, Pakistan, Burkina Faso, Georgia, Mauritius, Jamaica, Malawi, Bosnia and Herzegovina, Lesotho, Côte d’Ivoire, Madagascar, Mongolia, Kazakhstan, Lao PDR, Philippines, Malaysia, Gambia, The, Guinea-Bissau, Iran, Islamic Rep., Brazil, Tunisia, St. Lucia, Barbados, Saudi Arabia, Palau, Trinidad and Tobago, Costa Rica, Lebanon, Dominica, Gabon, Guyana, Azerbaijan, Paraguay, Liberia, Türkiye, Egypt, Arab Rep., South Sudan, Equatorial Guinea, Mauritania, Cabo Verde, Bulgaria, Ecuador, Samoa, Tajikistan, Sri Lanka, Uruguay, Congo, Rep., Peru, Argentina, Bangladesh, Tonga, Montenegro, Bahamas, The, Cameroon, Vanuatu, Timor-Leste, Ghana, Nicaragua, Russian Federation, Micronesia, Fed. Sts., North Macedonia, Kosovo, Chile, Papua New Guinea, Turkmenistan, São Tomé and Príncipe, Afghanistan, Myanmar, Zimbabwe, Mali, Nepal, Thailand, Maldives, Uganda, Kyrgyz Republic, El Salvador, POL, PAN, GIN, OMN, IDN, MEX, DZA, SWZ, COM, MAR, ERI, JOR, LBY, FJI, ARM, KWT, HTI, UKR, SOM, TGO, DJI, BOL, CAF, NGA, PSE, HRV, VNM, ZAF, TCD, SYC, DOM, KHM, COL, ROU, SLE, KEN, YEM, MOZ, SLB, BHR, VCT, BEN, GRD, ZMB, BTN, KIR, IRQ, AGO, CHN, TZA, BLZ, COD, BDI, UZB, MDA, ETH, NAM, SUR, HND, SEN, ARE, GTM, QAT, SYR, SDN, BWA, NER, ALB, SRB, RWA, BLR, IND, PAK, BFA, GEO, MUS, JAM, MWI, BIH, LSO, CIV, MDG, MNG, KAZ, LAO, PHL, MYS, GMB, GNB, IRN, BRA, TUN, LCA, BRB, SAU, PLW, TTO, CRI, LBN, DMA, GAB, GUY, AZE, PRY, LBR, TUR, EGY, SSD, GNQ, MRT, CPV, BGR, ECU, WSM, TJK, LKA, URY, COG, PER, ARG, BGD, TON, MNE, BHS, CMR, VUT, TLS, GHA, NIC, RUS, FSM, MKD, XKX, CHL, PNG, TKM, STP, AFG, MMR, ZWE, MLI, NPL, THA, MDV, UGA, KGZ, SLV
#> 34 Sri Lanka, Mongolia, Iraq, Madagascar, Malawi, South Africa, Bahrain, Guinea-Bissau, Yemen, Rep., Costa Rica, Uzbekistan, Montenegro, Ukraine, Congo, Dem. Rep., Cabo Verde, Zimbabwe, Romania, Peru, Gambia, The, Armenia, Afghanistan, Haiti, Marshall Islands, Bahamas, The, Samoa, Tunisia, Algeria, Libya, Moldova, El Salvador, Chad, Benin, Indonesia, Vietnam, Egypt, Arab Rep., Poland, Ghana, Syrian Arab Republic, Uruguay, Tajikistan, Bosnia and Herzegovina, Bangladesh, Nepal, Kenya, Botswana, Türkiye, Azerbaijan, Georgia, Kuwait, North Macedonia, Dominican Republic, Saudi Arabia, Colombia, Nigeria, Maldives, Thailand, Lebanon, Malaysia, Argentina, Guatemala, Belize, Mexico, Somalia, Federal Republic of, Kosovo, Niger, Vanuatu, Belarus, Honduras, Senegal, India, Kyrgyz Republic, Guinea, Eritrea, Rwanda, Equatorial Guinea, Namibia, Pakistan, Chile, Congo, Rep., Uganda, Burkina Faso, Solomon Islands, Jordan, Nicaragua, Eswatini, Philippines, Paraguay, Croatia, Timor-Leste, Bolivia, Oman, Mozambique, Russian Federation, Qatar, Brazil, Comoros, Morocco, Kazakhstan, Liberia, China, Djibouti, Central African Republic, Zambia, Serbia, Togo, Burundi, Ethiopia, Bhutan, Albania, Tanzania, Angola, Cameroon, Myanmar, West Bank and Gaza, Côte d’Ivoire, Lesotho, Ecuador, Mauritania, Gabon, Bulgaria, Sierra Leone, Jamaica, United Arab Emirates, Mali, Mauritius, Panama, Sudan, Naoero, Cambodia, Kiribati, Seychelles, Iran, Islamic Rep., Tonga, Palau, St. Vincent and the Grenadines, Grenada, Papua New Guinea, South Sudan, São Tomé and Príncipe, Lao PDR, Guyana, Dominica, Fiji, Micronesia, Fed. Sts., Trinidad and Tobago, Suriname, Barbados, St. Lucia, Turkmenistan, Tuvalu, LKA, MNG, IRQ, MDG, MWI, ZAF, BHR, GNB, YEM, CRI, UZB, MNE, UKR, COD, CPV, ZWE, ROU, PER, GMB, ARM, AFG, HTI, MHL, BHS, WSM, TUN, DZA, LBY, MDA, SLV, TCD, BEN, IDN, VNM, EGY, POL, GHA, SYR, URY, TJK, BIH, BGD, NPL, KEN, BWA, TUR, AZE, GEO, KWT, MKD, DOM, SAU, COL, NGA, MDV, THA, LBN, MYS, ARG, GTM, BLZ, MEX, SOM, XKX, NER, VUT, BLR, HND, SEN, IND, KGZ, GIN, ERI, RWA, GNQ, NAM, PAK, CHL, COG, UGA, BFA, SLB, JOR, NIC, SWZ, PHL, PRY, HRV, TLS, BOL, OMN, MOZ, RUS, QAT, BRA, COM, MAR, KAZ, LBR, CHN, DJI, CAF, ZMB, SRB, TGO, BDI, ETH, BTN, ALB, TZA, AGO, CMR, MMR, PSE, CIV, LSO, ECU, MRT, GAB, BGR, SLE, JAM, ARE, MLI, MUS, PAN, SDN, NRU, KHM, KIR, SYC, IRN, TON, PLW, VCT, GRD, PNG, SSD, STP, LAO, GUY, DMA, FJI, FSM, TTO, SUR, BRB, LCA, TKM, TUV
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
#> 29                            CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 30                            CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 31                            CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 32                            CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 33                            CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 34 CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, You are free to:\nShare — copy and redistribute the material in any medium or format for any purpose, even commercially.\nAdapt — remix, transform, and build upon the material for any purpose, even commercially.\nThe licensor cannot revoke these freedoms as long as you follow the license terms.\nUnder the following terms:\nAttribution — You must give appropriate credit , provide a link to the license, and indicate if changes were made . You may do so in any reasonable manner, but not in any way that suggests the licensor endorses you or your use.\nNo additional restrictions — You may not apply legal terms or technological measures that legally restrict others from doing anything the license permits.\nNotices:\nYou do not have to comply with the license for elements of the material in the public domain or where your use is permitted by an applicable exception or limitation .\n\nNo warranties are given. The license may not give you all of the permissions necessary for your intended use. For example, other rights such as publicity, privacy, or moral rights may limit how you use the material.
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
#> 29 DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 30 DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 31 DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 32 DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 33 DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 34                      NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
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
#> 21 NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 22 NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 23                                      NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org, NA, NA
#> 24                                      NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org, NA, NA
#> 25                                      NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org, NA, NA
#> 26 NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 27                                      NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org, NA, NA
#> 28 NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 29                                      NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org, NA, NA
#> 30                                      NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org, NA, NA
#> 31                                      NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org, NA, NA
#> 32 NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 33 NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 34                                                        NA, NA, NA, World Bank (WB), NA, NA, https://www.worldbank.org/, NA, NA
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
#> 4                                                                       NULL
#> 5  WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 6  WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 7  WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 8                                            WB_MPO, feature-dataset-profile
#> 9  WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 10 WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 11 WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 12 WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 13                                           WB_MPO, feature-dataset-profile
#> 14 WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 15 WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 16 WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 17 WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 18 WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 19 WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 20 WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 21 WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 22                                                                      NULL
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
#> 25                                                                            NULL
#> 26    primary, META_WB_WDI_SP_POP_TOTL, WB_WDI, World Development Indicators (WDI)
#> 27                                                                            NULL
#> 28 primary, META_WB_WDI_NY_GDP_PCAP_KD, WB_WDI, World Development Indicators (WDI)
#> 29                                                                            NULL
#> 30                                                                            NULL
#> 31                                                                            NULL
#> 32                                                                            NULL
#> 33 primary, META_WB_WDI_NY_GDP_DEFL_ZS, WB_WDI, World Development Indicators (WDI)
#> 34                                                                            NULL
#>    additional.visualization.scale_type additional.visualization.legend_type
#> 1                                 <NA>                                   NA
#> 2                                 <NA>                                   NA
#> 3                                 <NA>                                   NA
#> 4                                 <NA>                                   NA
#> 5                            diverging                                   NA
#> 6                            diverging                                   NA
#> 7                            diverging                                   NA
#> 8                                 <NA>                                   NA
#> 9                                 <NA>                                   NA
#> 10                                <NA>                                   NA
#> 11                                <NA>                                   NA
#> 12                                <NA>                                   NA
#> 13                                <NA>                                   NA
#> 14                                <NA>                                   NA
#> 15                                <NA>                                   NA
#> 16                                <NA>                                   NA
#> 17                           diverging                                   NA
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
#> 2                                 NULL
#> 3                                 NULL
#> 4                                 NULL
#> 5                            NA, 0, NA
#> 6                            NA, 0, NA
#> 7                            NA, 0, NA
#> 8                                 NULL
#> 9                                 NULL
#> 10                                NULL
#> 11                                NULL
#> 12                                NULL
#> 13                                NULL
#> 14                                NULL
#> 15                                NULL
#> 16                                NULL
#> 17                           NA, 0, NA
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
#>                                                                                                                                           disaggregation_codes
#> 1                                                                                           VINTAGE, V_AM2025, V_AM2026, V_SM2024, V_SM2025, V_SM2026, Vintage
#> 2                                VINTAGE, UNIT_MEASURE, V_AM2024, V_AM2025, V_AM2026, V_SM2024, V_SM2025, V_SM2026, PT_GDP, USD, XDC, Vintage, Unit of measure
#> 3  PRICE_BASIS, VINTAGE, UNIT_MEASURE, C, K, V_SM2025, V_AM2026, V_AM2025, V_SM2026, V_SM2024, V_AM2024, USD, PC_A, XDC, Price Basis, Vintage, Unit of measure
#> 4  PRICE_BASIS, VINTAGE, UNIT_MEASURE, K, C, V_SM2025, V_AM2026, V_AM2025, V_SM2024, V_SM2026, V_AM2024, USD, PC_A, XDC, Price Basis, Vintage, Unit of measure
#> 5                                                                                                     VINTAGE, V_AM2024, V_AM2026, V_SM2024, V_SM2026, Vintage
#> 6                                VINTAGE, UNIT_MEASURE, V_AM2024, V_AM2025, V_AM2026, V_SM2024, V_SM2025, V_SM2026, PT_GDP, USD, XDC, Vintage, Unit of measure
#> 7                                     VINTAGE, UNIT_MEASURE, V_AM2024, V_AM2025, V_AM2026, V_SM2024, V_SM2025, V_SM2026, PT_GDP, USD, Vintage, Unit of measure
#> 8                                                                                           VINTAGE, V_AM2025, V_AM2026, V_SM2024, V_SM2025, V_SM2026, Vintage
#> 9                                                                                 VINTAGE, V_AM2024, V_AM2025, V_AM2026, V_SM2024, V_SM2025, V_SM2026, Vintage
#> 10                                                                                VINTAGE, V_AM2024, V_AM2025, V_AM2026, V_SM2024, V_SM2025, V_SM2026, Vintage
#> 11                                                                                          VINTAGE, V_AM2025, V_AM2026, V_SM2024, V_SM2025, V_SM2026, Vintage
#> 12                                                                                VINTAGE, V_AM2024, V_AM2025, V_AM2026, V_SM2024, V_SM2025, V_SM2026, Vintage
#> 13                                                                                          VINTAGE, V_AM2025, V_AM2026, V_SM2024, V_SM2025, V_SM2026, Vintage
#> 14                                                                                VINTAGE, V_AM2024, V_AM2025, V_AM2026, V_SM2024, V_SM2025, V_SM2026, Vintage
#> 15 PRICE_BASIS, VINTAGE, UNIT_MEASURE, K, C, V_SM2025, V_AM2026, V_AM2025, V_SM2024, V_SM2026, V_AM2024, XDC, USD, PC_A, Price Basis, Vintage, Unit of measure
#> 16 PRICE_BASIS, VINTAGE, UNIT_MEASURE, K, C, V_SM2025, V_AM2026, V_AM2025, V_SM2024, V_SM2026, V_AM2024, XDC, USD, PC_A, Price Basis, Vintage, Unit of measure
#> 17 PRICE_BASIS, VINTAGE, UNIT_MEASURE, C, K, V_SM2025, V_AM2026, V_SM2026, V_SM2024, V_AM2024, V_AM2025, XDC, USD, PC_A, Price Basis, Vintage, Unit of measure
#> 18                                    VINTAGE, UNIT_MEASURE, V_AM2024, V_AM2025, V_AM2026, V_SM2024, V_SM2025, V_SM2026, PT_GDP, USD, Vintage, Unit of measure
#> 19 PRICE_BASIS, VINTAGE, UNIT_MEASURE, K, C, V_AM2024, V_SM2025, V_AM2026, V_AM2025, V_SM2024, V_SM2026, XDC, USD, PC_A, Price Basis, Vintage, Unit of measure
#> 20                               VINTAGE, UNIT_MEASURE, V_AM2024, V_AM2025, V_AM2026, V_SM2024, V_SM2025, V_SM2026, PT_GDP, USD, XDC, Vintage, Unit of measure
#> 21 PRICE_BASIS, VINTAGE, UNIT_MEASURE, K, C, V_AM2025, V_SM2024, V_SM2026, V_AM2024, V_SM2025, V_AM2026, XDC, USD, PC_A, Price Basis, Vintage, Unit of measure
#> 22 PRICE_BASIS, VINTAGE, UNIT_MEASURE, K, C, V_SM2025, V_AM2026, V_AM2025, V_SM2024, V_SM2026, V_AM2024, XDC, USD, PC_A, Price Basis, Vintage, Unit of measure
#> 23                                                                                VINTAGE, V_SM2025, V_AM2026, V_AM2025, V_SM2026, V_AM2024, V_SM2024, Vintage
#> 24                                  VINTAGE, UNIT_MEASURE, V_AM2024, V_AM2025, V_AM2026, V_SM2024, V_SM2025, V_SM2026, KT_CO2E, PC_A, Vintage, Unit of measure
#> 25 PRICE_BASIS, VINTAGE, UNIT_MEASURE, K, C, V_SM2025, V_AM2026, V_AM2025, V_SM2024, V_SM2026, V_AM2024, XDC, USD, PC_A, Price Basis, Vintage, Unit of measure
#> 26                                                                                VINTAGE, V_AM2024, V_AM2025, V_AM2026, V_SM2024, V_SM2025, V_SM2026, Vintage
#> 27                       VINTAGE, UNIT_MEASURE, V_AM2024, V_AM2025, V_AM2026, V_SM2024, V_SM2025, V_SM2026, KT_CO2E, PC_A, PT_EM_GHG, Vintage, Unit of measure
#> 28                                 VINTAGE, UNIT_MEASURE, V_AM2024, V_AM2025, V_AM2026, V_SM2024, V_SM2025, V_SM2026, PC_A, USD, XDC, Vintage, Unit of measure
#> 29                                           VINTAGE, UNIT_MEASURE, V_AM2025, V_AM2026, V_SM2024, V_SM2025, V_SM2026, PC_A, USD, XDC, Vintage, Unit of measure
#> 30                                                                                VINTAGE, V_AM2024, V_AM2025, V_AM2026, V_SM2024, V_SM2025, V_SM2026, Vintage
#> 31                                                                                          VINTAGE, V_AM2025, V_AM2026, V_SM2024, V_SM2025, V_SM2026, Vintage
#> 32 PRICE_BASIS, VINTAGE, UNIT_MEASURE, K, C, V_SM2025, V_AM2026, V_AM2025, V_SM2024, V_SM2026, V_AM2024, XDC, USD, PC_A, Price Basis, Vintage, Unit of measure
#> 33                                                                                VINTAGE, V_AM2024, V_AM2025, V_AM2026, V_SM2024, V_SM2025, V_SM2026, Vintage
#> 34                                                                                                                                                        NULL
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
#> 1                                pie, stacked_bar GAFS_0008, NA, GAFS, NA, NA
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
