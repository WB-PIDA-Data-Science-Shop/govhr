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
#> [1] 104
#> 
#> $value
#>    @search.score                        id                                 idno
#> 1       30.69842   META_WB_MPO_GGBALPRIMCD 7a5b5994-5d58-4f84-b9dd-745d47d41b94
#> 2       26.32472 META_WB_MPO_NECONPRVTPCKN c06fbf71-7e41-43f9-ac09-6a887657b2c0
#> 3       25.10906   META_WB_MPO_NYGDPMKTPCD b40ec5aa-46b4-4236-8208-75ed056fc0b4
#> 4       25.10906   META_WB_MPO_GGEXPINTPCN 3a1a10f1-9576-4864-b37f-7472903343b3
#> 5       24.92497  META_WB_MPO_NEEXPGNFSCNZ 109693e4-17a7-4603-b85b-df209de73ea1
#> 6       24.92497   META_WB_MPO_GGBALOVRLCN e9e68717-89bf-43c6-b6e9-4f6560d95a11
#> 7       24.92497   META_WB_MPO_GGBALOVRLCD 859e8798-f252-4835-88b8-641859334fc2
#> 8       24.78201  META_WB_MPO_NEEXPGNFSKDZ a7c87601-8870-4693-9fbd-74bfcd16f1d8
#> 9       24.78201  META_WB_MPO_NEIMPGNFSKDZ d354b7d6-84c9-48aa-bc3d-ca40a15a9a5f
#> 10      24.78201   META_WB_MPO_NYGDPMKTPCN e29d21ff-df06-4fd1-a274-c63400006a80
#> 11      24.78201  META_WB_MPO_NYGDPMKTPKNZ 879b7497-468a-4425-ab81-a3d31e71e9a8
#> 12      24.38526          META_WB_MPO_POV2 038f91a4-373e-4518-8f30-c6fede87ce8e
#> 13      24.24845          META_WB_MPO_POV3 f726b67f-e51c-4467-9937-d79e3e3edcd2
#> 14      24.13780   META_WB_MPO_FPCPITOTLXN 4c35692b-c581-48f1-b15c-a4aa91769a9b
#> 15      24.13780   META_WB_MPO_NEIMPGNFSKD 43dde719-fb4e-4354-9754-65fb50a851c2
#> 16      24.10855   META_WB_MPO_NYGDPMKTPKD 0dfbb467-a830-41bc-8f8f-c7233d89e91b
#> 17      24.01382  META_WB_MPO_NECONGOVTCNZ 5c2773ca-da49-4900-91c7-58d713a207d7
#> 18      24.01382  META_WB_MPO_FPCPITOTLXNZ 439d46fe-8e6a-48c2-a3b0-93dbcebba565
#> 19      24.01382   META_WB_MPO_NEEXPGNFSCN 93b706e8-25a0-4151-89ba-e6e19c1029f7
#> 20      24.01382   META_WB_MPO_NEEXPGNFSKN 06aca565-f972-4487-9411-ddbf850e5196
#> 21      23.86765   META_WB_MPO_BNCABFUNDCD c51eaa5e-e1e7-40de-8eef-df8ab1f0e3de
#> 22      23.86765   META_WB_MPO_NVAGRTOTLKD 74a14a60-10a1-4d42-98c2-e00f86029178
#> 23      23.86765  META_WB_MPO_NYGDPMKTPCNZ 76f9fe15-2eb4-48e9-9657-a3db2667ca3b
#> 24      23.48132  META_WB_MPO_NEGDIFTOTKN_ 7a0df92c-6e6e-4c86-8e81-c35ed6f030cd
#> 25      23.26396          META_WB_MPO_POV1 af08c7a1-873d-415a-8cdb-2656b859e9a6
#> 26      23.26336                    WB_MPO 16ffd22e-c3b6-477d-bb16-45c423263eb0
#> 27      22.84469  META_WB_MPO_BNCABFUNDCD_ b36587c9-dac3-4ec3-ad20-7a10b0905c95
#> 28      22.64331   META_WB_MPO_GGEXPTOTLCD 045d144c-8dee-428d-bcc0-b069bfaf2f79
#> 29      22.64331  META_WB_MPO_NEEXPGNFSKNZ bd4b43b7-cb3d-4724-bcea-bffb1746c028
#> 30      22.32571   META_WB_MPO_GGDBTTOTLCD 150f9817-21ce-425b-9e0a-84a126800234
#> 31      22.32571  META_WB_MPO_NVAGRTOTLCNZ d3697223-3152-4253-bfe9-42c6740011cd
#> 32      22.32571   META_WB_MPO_NECONGOVTCN d414ecc7-c477-4328-91c6-759f3f0fd8cf
#> 33      22.32571  META_WB_MPO_NEGDIFTOTKDZ c6fdd358-391e-4076-92f2-097bbbd7fc92
#> 34      22.32571   META_WB_MPO_BFCAFTOTLCD b4d324f5-75bc-47d2-aa83-93362aa9d539
#> 35      22.21044   META_WB_MPO_GGBALPRIMCN 7ad2c2ae-4685-4249-9230-85686a409847
#> 36      22.21044   META_WB_MPO_GGREVTOTLCD 2a12a3d3-d968-4294-8ebe-abdf37d48f1a
#> 37      22.21044   META_WB_MPO_BFCAFFFDICD 8f5c7b62-ce7a-49b8-92c3-fc1fe7e64494
#> 38      22.21044   META_WB_MPO_NEIMPGNFSCN fdf4269f-a74c-492e-8839-8c08097f578c
#> 39      21.57168   META_WB_MPO_NECONGOVTKD 59bb914a-e4e7-4d35-9ff3-590327aa9aa2
#> 40      21.57168  META_WB_MPO_NECONPRVTKNZ ba2095e3-b381-4ed2-b27b-3e31cbf4574c
#> 41      21.57168  META_WB_MPO_NEGDIFTOTCNZ b5d9c413-61e4-4e32-9a37-3bc7b1fc0eb7
#> 42      21.47692  META_WB_MPO_GGBALOVRLCD_ d31c7795-6246-4103-832d-e260cd0ae079
#> 43      21.08393  META_WB_MPO_GGBALPRIMCD_ e3c845e8-8a13-472e-8372-4285899ffa32
#> 44      20.60861     META_WB_MPO_SPPOPTOTL a4707329-948b-4afa-bdd5-80d3fc5f44ae
#> 45      20.60861   META_WB_MPO_ENENRGHGEKT ac596a77-81b6-4c85-9bd4-88333895b0eb
#> 46      20.60861  META_WB_MPO_NEIMPGNFSKNZ 2b42471a-4f58-4cb8-b559-3ed0168ee5b0
#> 47      20.56989  META_WB_MPO_NEGDIFTOTKNZ 5c77c602-1c9d-418e-ba72-b2303208dd8e
#> 48      20.56989   META_WB_MPO_NVAGRTOTLKN 65dd0d66-4a05-486a-9a39-aaec756e1bc8
#> 49      20.56989  META_WB_MPO_NVINDTOTLKDZ 53a00c41-c78e-4ce7-b123-de7633ea51c5
#> 50      20.56989   META_WB_MPO_NVSRVTOTLKN d25890a1-d711-4197-b8c8-aea43e55e197
#>         type    subtype disaggregation_types isDelete cfPath doc_type
#> 1  indicator timeseries              Vintage       NA     NA       NA
#> 2  indicator timeseries              Vintage       NA     NA       NA
#> 3  indicator timeseries              Vintage       NA     NA       NA
#> 4  indicator timeseries              Vintage       NA     NA       NA
#> 5  indicator timeseries              Vintage       NA     NA       NA
#> 6  indicator timeseries              Vintage       NA     NA       NA
#> 7  indicator timeseries              Vintage       NA     NA       NA
#> 8  indicator timeseries              Vintage       NA     NA       NA
#> 9  indicator timeseries              Vintage       NA     NA       NA
#> 10 indicator timeseries              Vintage       NA     NA       NA
#> 11 indicator timeseries              Vintage       NA     NA       NA
#> 12 indicator timeseries              Vintage       NA     NA       NA
#> 13 indicator timeseries              Vintage       NA     NA       NA
#> 14 indicator timeseries              Vintage       NA     NA       NA
#> 15 indicator timeseries              Vintage       NA     NA       NA
#> 16 indicator timeseries              Vintage       NA     NA       NA
#> 17 indicator timeseries              Vintage       NA     NA       NA
#> 18 indicator timeseries              Vintage       NA     NA       NA
#> 19 indicator timeseries              Vintage       NA     NA       NA
#> 20 indicator timeseries              Vintage       NA     NA       NA
#> 21 indicator timeseries              Vintage       NA     NA       NA
#> 22 indicator timeseries              Vintage       NA     NA       NA
#> 23 indicator timeseries              Vintage       NA     NA       NA
#> 24 indicator timeseries              Vintage       NA     NA       NA
#> 25 indicator timeseries              Vintage       NA     NA       NA
#> 26   dataset       <NA>                            NA     NA       NA
#> 27 indicator timeseries              Vintage       NA     NA       NA
#> 28 indicator timeseries              Vintage       NA     NA       NA
#> 29 indicator timeseries              Vintage       NA     NA       NA
#> 30 indicator timeseries              Vintage       NA     NA       NA
#> 31 indicator timeseries              Vintage       NA     NA       NA
#> 32 indicator timeseries              Vintage       NA     NA       NA
#> 33 indicator timeseries              Vintage       NA     NA       NA
#> 34 indicator timeseries              Vintage       NA     NA       NA
#> 35 indicator timeseries              Vintage       NA     NA       NA
#> 36 indicator timeseries              Vintage       NA     NA       NA
#> 37 indicator timeseries                            NA     NA       NA
#> 38 indicator timeseries              Vintage       NA     NA       NA
#> 39 indicator timeseries              Vintage       NA     NA       NA
#> 40 indicator timeseries              Vintage       NA     NA       NA
#> 41 indicator timeseries              Vintage       NA     NA       NA
#> 42 indicator timeseries              Vintage       NA     NA       NA
#> 43 indicator timeseries              Vintage       NA     NA       NA
#> 44 indicator timeseries              Vintage       NA     NA       NA
#> 45 indicator timeseries              Vintage       NA     NA       NA
#> 46 indicator timeseries              Vintage       NA     NA       NA
#> 47 indicator timeseries              Vintage       NA     NA       NA
#> 48 indicator timeseries              Vintage       NA     NA       NA
#> 49 indicator timeseries              Vintage       NA     NA       NA
#> 50 indicator timeseries              Vintage       NA     NA       NA
#>       remove_chart_type data_confidentiality_code data_confidentiality_name
#> 1       stackedBar, pie                        PU                    Public
#> 2  stackedBar, pie, map                        PU                    Public
#> 3       stackedBar, pie                        PU                    Public
#> 4  stackedBar, pie, map                        PU                    Public
#> 5       stackedBar, pie                        PU                    Public
#> 6  stackedBar, pie, map                        PU                    Public
#> 7       stackedBar, pie                        PU                    Public
#> 8       stackedBar, pie                        PU                    Public
#> 9       stackedBar, pie                        PU                    Public
#> 10 stackedBar, pie, map                        PU                    Public
#> 11      stackedBar, pie                        PU                    Public
#> 12      stackedBar, pie                        PU                    Public
#> 13      stackedBar, pie                        PU                    Public
#> 14      stackedBar, pie                        PU                    Public
#> 15      stackedBar, pie                        PU                    Public
#> 16      stackedBar, pie                        PU                    Public
#> 17      stackedBar, pie                        PU                    Public
#> 18      stackedBar, pie                        PU                    Public
#> 19 stackedBar, pie, map                        PU                    Public
#> 20 stackedBar, pie, map                        PU                    Public
#> 21      stackedBar, pie                        PU                    Public
#> 22      stackedBar, pie                        PU                    Public
#> 23      stackedBar, pie                        PU                    Public
#> 24      stackedBar, pie                        PU                    Public
#> 25      stackedBar, pie                        PU                    Public
#> 26                 <NA>                        PU                    Public
#> 27      stackedBar, pie                        PU                    Public
#> 28      stackedBar, pie                        PU                    Public
#> 29      stackedBar, pie                        PU                    Public
#> 30      stackedBar, pie                        PU                    Public
#> 31      stackedBar, pie                        PU                    Public
#> 32 stackedBar, pie, map                        PU                    Public
#> 33      stackedBar, pie                        PU                    Public
#> 34      stackedBar, pie                        PU                    Public
#> 35 stackedBar, pie, map                        PU                    Public
#> 36      stackedBar, pie                        PU                    Public
#> 37      stackedBar, pie                        PU                    Public
#> 38 stackedBar, pie, map                        PU                    Public
#> 39      stackedBar, pie                        PU                    Public
#> 40      stackedBar, pie                        PU                    Public
#> 41      stackedBar, pie                        PU                    Public
#> 42      stackedBar, pie                        PU                    Public
#> 43      stackedBar, pie                        PU                    Public
#> 44      stackedBar, pie                        PU                    Public
#> 45      stackedBar, pie                        PU                    Public
#> 46      stackedBar, pie                        PU                    Public
#> 47      stackedBar, pie                        PU                    Public
#> 48 stackedBar, pie, map                        PU                    Public
#> 49      stackedBar, pie                        PU                    Public
#> 50 stackedBar, pie, map                        PU                    Public
#>    dsd_name dsd_version
#> 1   DATA360         1.2
#> 2   DATA360         1.2
#> 3   DATA360         1.2
#> 4   DATA360         1.2
#> 5   DATA360         1.2
#> 6   DATA360         1.2
#> 7   DATA360         1.2
#> 8   DATA360         1.2
#> 9   DATA360         1.2
#> 10  DATA360         1.2
#> 11  DATA360         1.2
#> 12  DATA360         1.2
#> 13  DATA360         1.2
#> 14  DATA360         1.2
#> 15  DATA360         1.2
#> 16  DATA360         1.2
#> 17  DATA360         1.2
#> 18  DATA360         1.2
#> 19  DATA360         1.2
#> 20  DATA360         1.2
#> 21  DATA360         1.2
#> 22  DATA360         1.2
#> 23  DATA360         1.2
#> 24  DATA360         1.2
#> 25  DATA360         1.2
#> 26     <NA>        <NA>
#> 27  DATA360         1.2
#> 28  DATA360         1.2
#> 29  DATA360         1.2
#> 30  DATA360         1.2
#> 31  DATA360         1.2
#> 32  DATA360         1.2
#> 33  DATA360         1.2
#> 34  DATA360         1.2
#> 35  DATA360         1.2
#> 36  DATA360         1.2
#> 37  DATA360         1.2
#> 38  DATA360         1.2
#> 39  DATA360         1.2
#> 40  DATA360         1.2
#> 41  DATA360         1.2
#> 42  DATA360         1.2
#> 43  DATA360         1.2
#> 44  DATA360         1.2
#> 45  DATA360         1.2
#> 46  DATA360         1.2
#> 47  DATA360         1.2
#> 48  DATA360         1.2
#> 49  DATA360         1.2
#> 50  DATA360         1.2
#>                                                                                                                                                                                                                      dsd_codelist
#> 1  DATA_SOURCE, FREQ, REF_AREA, INDICATOR, SEX, AGE, URBANISATION, UNIT_MEASURE, COMP_BREAKDOWN_1, COMP_BREAKDOWN_2, COMP_BREAKDOWN_3, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 2  DATA_SOURCE, FREQ, REF_AREA, INDICATOR, SEX, AGE, URBANISATION, UNIT_MEASURE, COMP_BREAKDOWN_1, COMP_BREAKDOWN_2, COMP_BREAKDOWN_3, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 3  DATA_SOURCE, FREQ, REF_AREA, INDICATOR, SEX, AGE, URBANISATION, UNIT_MEASURE, COMP_BREAKDOWN_1, COMP_BREAKDOWN_2, COMP_BREAKDOWN_3, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 4  DATA_SOURCE, FREQ, REF_AREA, INDICATOR, SEX, AGE, URBANISATION, UNIT_MEASURE, COMP_BREAKDOWN_1, COMP_BREAKDOWN_2, COMP_BREAKDOWN_3, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 5  DATA_SOURCE, FREQ, REF_AREA, INDICATOR, SEX, AGE, URBANISATION, UNIT_MEASURE, COMP_BREAKDOWN_1, COMP_BREAKDOWN_2, COMP_BREAKDOWN_3, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 6  DATA_SOURCE, FREQ, REF_AREA, INDICATOR, SEX, AGE, URBANISATION, UNIT_MEASURE, COMP_BREAKDOWN_1, COMP_BREAKDOWN_2, COMP_BREAKDOWN_3, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 7  DATA_SOURCE, FREQ, REF_AREA, INDICATOR, SEX, AGE, URBANISATION, UNIT_MEASURE, COMP_BREAKDOWN_1, COMP_BREAKDOWN_2, COMP_BREAKDOWN_3, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 8  DATA_SOURCE, FREQ, REF_AREA, INDICATOR, SEX, AGE, URBANISATION, UNIT_MEASURE, COMP_BREAKDOWN_1, COMP_BREAKDOWN_2, COMP_BREAKDOWN_3, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 9  DATA_SOURCE, FREQ, REF_AREA, INDICATOR, SEX, AGE, URBANISATION, UNIT_MEASURE, COMP_BREAKDOWN_1, COMP_BREAKDOWN_2, COMP_BREAKDOWN_3, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 10 DATA_SOURCE, FREQ, REF_AREA, INDICATOR, SEX, AGE, URBANISATION, UNIT_MEASURE, COMP_BREAKDOWN_1, COMP_BREAKDOWN_2, COMP_BREAKDOWN_3, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 11 DATA_SOURCE, FREQ, REF_AREA, INDICATOR, SEX, AGE, URBANISATION, UNIT_MEASURE, COMP_BREAKDOWN_1, COMP_BREAKDOWN_2, COMP_BREAKDOWN_3, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 12 DATA_SOURCE, FREQ, REF_AREA, INDICATOR, SEX, AGE, URBANISATION, UNIT_MEASURE, COMP_BREAKDOWN_1, COMP_BREAKDOWN_2, COMP_BREAKDOWN_3, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 13 DATA_SOURCE, FREQ, REF_AREA, INDICATOR, SEX, AGE, URBANISATION, UNIT_MEASURE, COMP_BREAKDOWN_1, COMP_BREAKDOWN_2, COMP_BREAKDOWN_3, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 14 DATA_SOURCE, FREQ, REF_AREA, INDICATOR, SEX, AGE, URBANISATION, UNIT_MEASURE, COMP_BREAKDOWN_1, COMP_BREAKDOWN_2, COMP_BREAKDOWN_3, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 15 DATA_SOURCE, FREQ, REF_AREA, INDICATOR, SEX, AGE, URBANISATION, UNIT_MEASURE, COMP_BREAKDOWN_1, COMP_BREAKDOWN_2, COMP_BREAKDOWN_3, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 16 DATA_SOURCE, FREQ, REF_AREA, INDICATOR, SEX, AGE, URBANISATION, UNIT_MEASURE, COMP_BREAKDOWN_1, COMP_BREAKDOWN_2, COMP_BREAKDOWN_3, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 17 DATA_SOURCE, FREQ, REF_AREA, INDICATOR, SEX, AGE, URBANISATION, UNIT_MEASURE, COMP_BREAKDOWN_1, COMP_BREAKDOWN_2, COMP_BREAKDOWN_3, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 18 DATA_SOURCE, FREQ, REF_AREA, INDICATOR, SEX, AGE, URBANISATION, UNIT_MEASURE, COMP_BREAKDOWN_1, COMP_BREAKDOWN_2, COMP_BREAKDOWN_3, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 19 DATA_SOURCE, FREQ, REF_AREA, INDICATOR, SEX, AGE, URBANISATION, UNIT_MEASURE, COMP_BREAKDOWN_1, COMP_BREAKDOWN_2, COMP_BREAKDOWN_3, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 20 DATA_SOURCE, FREQ, REF_AREA, INDICATOR, SEX, AGE, URBANISATION, UNIT_MEASURE, COMP_BREAKDOWN_1, COMP_BREAKDOWN_2, COMP_BREAKDOWN_3, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 21 DATA_SOURCE, FREQ, REF_AREA, INDICATOR, SEX, AGE, URBANISATION, UNIT_MEASURE, COMP_BREAKDOWN_1, COMP_BREAKDOWN_2, COMP_BREAKDOWN_3, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 22 DATA_SOURCE, FREQ, REF_AREA, INDICATOR, SEX, AGE, URBANISATION, UNIT_MEASURE, COMP_BREAKDOWN_1, COMP_BREAKDOWN_2, COMP_BREAKDOWN_3, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 23 DATA_SOURCE, FREQ, REF_AREA, INDICATOR, SEX, AGE, URBANISATION, UNIT_MEASURE, COMP_BREAKDOWN_1, COMP_BREAKDOWN_2, COMP_BREAKDOWN_3, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 24 DATA_SOURCE, FREQ, REF_AREA, INDICATOR, SEX, AGE, URBANISATION, UNIT_MEASURE, COMP_BREAKDOWN_1, COMP_BREAKDOWN_2, COMP_BREAKDOWN_3, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 25 DATA_SOURCE, FREQ, REF_AREA, INDICATOR, SEX, AGE, URBANISATION, UNIT_MEASURE, COMP_BREAKDOWN_1, COMP_BREAKDOWN_2, COMP_BREAKDOWN_3, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 26                                                                                                                                                                                                                               
#> 27 DATA_SOURCE, FREQ, REF_AREA, INDICATOR, SEX, AGE, URBANISATION, UNIT_MEASURE, COMP_BREAKDOWN_1, COMP_BREAKDOWN_2, COMP_BREAKDOWN_3, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 28 DATA_SOURCE, FREQ, REF_AREA, INDICATOR, SEX, AGE, URBANISATION, UNIT_MEASURE, COMP_BREAKDOWN_1, COMP_BREAKDOWN_2, COMP_BREAKDOWN_3, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 29 DATA_SOURCE, FREQ, REF_AREA, INDICATOR, SEX, AGE, URBANISATION, UNIT_MEASURE, COMP_BREAKDOWN_1, COMP_BREAKDOWN_2, COMP_BREAKDOWN_3, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 30 DATA_SOURCE, FREQ, REF_AREA, INDICATOR, SEX, AGE, URBANISATION, UNIT_MEASURE, COMP_BREAKDOWN_1, COMP_BREAKDOWN_2, COMP_BREAKDOWN_3, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 31 DATA_SOURCE, FREQ, REF_AREA, INDICATOR, SEX, AGE, URBANISATION, UNIT_MEASURE, COMP_BREAKDOWN_1, COMP_BREAKDOWN_2, COMP_BREAKDOWN_3, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 32 DATA_SOURCE, FREQ, REF_AREA, INDICATOR, SEX, AGE, URBANISATION, UNIT_MEASURE, COMP_BREAKDOWN_1, COMP_BREAKDOWN_2, COMP_BREAKDOWN_3, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 33 DATA_SOURCE, FREQ, REF_AREA, INDICATOR, SEX, AGE, URBANISATION, UNIT_MEASURE, COMP_BREAKDOWN_1, COMP_BREAKDOWN_2, COMP_BREAKDOWN_3, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 34 DATA_SOURCE, FREQ, REF_AREA, INDICATOR, SEX, AGE, URBANISATION, UNIT_MEASURE, COMP_BREAKDOWN_1, COMP_BREAKDOWN_2, COMP_BREAKDOWN_3, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 35 DATA_SOURCE, FREQ, REF_AREA, INDICATOR, SEX, AGE, URBANISATION, UNIT_MEASURE, COMP_BREAKDOWN_1, COMP_BREAKDOWN_2, COMP_BREAKDOWN_3, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 36 DATA_SOURCE, FREQ, REF_AREA, INDICATOR, SEX, AGE, URBANISATION, UNIT_MEASURE, COMP_BREAKDOWN_1, COMP_BREAKDOWN_2, COMP_BREAKDOWN_3, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 37 DATA_SOURCE, FREQ, REF_AREA, INDICATOR, SEX, AGE, URBANISATION, UNIT_MEASURE, COMP_BREAKDOWN_1, COMP_BREAKDOWN_2, COMP_BREAKDOWN_3, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 38 DATA_SOURCE, FREQ, REF_AREA, INDICATOR, SEX, AGE, URBANISATION, UNIT_MEASURE, COMP_BREAKDOWN_1, COMP_BREAKDOWN_2, COMP_BREAKDOWN_3, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 39 DATA_SOURCE, FREQ, REF_AREA, INDICATOR, SEX, AGE, URBANISATION, UNIT_MEASURE, COMP_BREAKDOWN_1, COMP_BREAKDOWN_2, COMP_BREAKDOWN_3, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 40 DATA_SOURCE, FREQ, REF_AREA, INDICATOR, SEX, AGE, URBANISATION, UNIT_MEASURE, COMP_BREAKDOWN_1, COMP_BREAKDOWN_2, COMP_BREAKDOWN_3, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 41 DATA_SOURCE, FREQ, REF_AREA, INDICATOR, SEX, AGE, URBANISATION, UNIT_MEASURE, COMP_BREAKDOWN_1, COMP_BREAKDOWN_2, COMP_BREAKDOWN_3, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 42 DATA_SOURCE, FREQ, REF_AREA, INDICATOR, SEX, AGE, URBANISATION, UNIT_MEASURE, COMP_BREAKDOWN_1, COMP_BREAKDOWN_2, COMP_BREAKDOWN_3, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 43 DATA_SOURCE, FREQ, REF_AREA, INDICATOR, SEX, AGE, URBANISATION, UNIT_MEASURE, COMP_BREAKDOWN_1, COMP_BREAKDOWN_2, COMP_BREAKDOWN_3, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 44 DATA_SOURCE, FREQ, REF_AREA, INDICATOR, SEX, AGE, URBANISATION, UNIT_MEASURE, COMP_BREAKDOWN_1, COMP_BREAKDOWN_2, COMP_BREAKDOWN_3, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 45 DATA_SOURCE, FREQ, REF_AREA, INDICATOR, SEX, AGE, URBANISATION, UNIT_MEASURE, COMP_BREAKDOWN_1, COMP_BREAKDOWN_2, COMP_BREAKDOWN_3, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 46 DATA_SOURCE, FREQ, REF_AREA, INDICATOR, SEX, AGE, URBANISATION, UNIT_MEASURE, COMP_BREAKDOWN_1, COMP_BREAKDOWN_2, COMP_BREAKDOWN_3, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 47 DATA_SOURCE, FREQ, REF_AREA, INDICATOR, SEX, AGE, URBANISATION, UNIT_MEASURE, COMP_BREAKDOWN_1, COMP_BREAKDOWN_2, COMP_BREAKDOWN_3, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 48 DATA_SOURCE, FREQ, REF_AREA, INDICATOR, SEX, AGE, URBANISATION, UNIT_MEASURE, COMP_BREAKDOWN_1, COMP_BREAKDOWN_2, COMP_BREAKDOWN_3, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 49 DATA_SOURCE, FREQ, REF_AREA, INDICATOR, SEX, AGE, URBANISATION, UNIT_MEASURE, COMP_BREAKDOWN_1, COMP_BREAKDOWN_2, COMP_BREAKDOWN_3, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
#> 50 DATA_SOURCE, FREQ, REF_AREA, INDICATOR, SEX, AGE, URBANISATION, UNIT_MEASURE, COMP_BREAKDOWN_1, COMP_BREAKDOWN_2, COMP_BREAKDOWN_3, AGG_METHOD, UNIT_TYPE, DECIMALS, DATABASE_ID, TIME_FORMAT, UNIT_MULT, OBS_STATUS, OBS_CONF
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
#> 35        NA
#> 36        NA
#> 37        NA
#> 38        NA
#> 39        NA
#> 40        NA
#> 41        NA
#> 42        NA
#> 43        NA
#> 44        NA
#> 45        NA
#> 46        NA
#> 47        NA
#> 48        NA
#> 49        NA
#> 50        NA
#>                                                                      metadata_information.title
#> 1                                      Metadata for Primary Fiscal Balance, Value, Millions USD
#> 2                             Metadata for Private Consumption per capita, Volume, Millions LCU
#> 3                      Metadata for Gross Domestic Product at Market Price, Value, Millions USD
#> 4                                           Metadata for Interest Payments, Value, Millions LCU
#> 5                                      Metadata for GNFS Exports, Value, Millions LCU, % change
#> 6                                      Metadata for Overall Fiscal Balance, Value, Millions LCU
#> 7                                      Metadata for Overall Fiscal Balance, Value, Millions USD
#> 8                           Metadata for GNFS Exports, Volume, Millions 2015 real USD, % change
#> 9                           Metadata for GNFS Imports, Volume, Millions 2015 real USD, % change
#> 10                     Metadata for Gross Domestic Product at Market Price, Value, Millions LCU
#> 11          Metadata for Gross Domestic Product at Market Price, Volume, Millions LCU, % change
#> 12                            Metadata for Lower middle-income poverty rate ($3.65 in 2017 PPP)
#> 13                            Metadata for Upper middle-income poverty rate ($6.85 in 2017 PPP)
#> 14                                    Metadata for Consumer Price Index, Implicit Deflator, LCU
#> 15                                    Metadata for GNFS Imports, Volume, Millions 2015 real USD
#> 16          Metadata for Gross Domestic Product at Market Price, Volume, Millions 2015 real USD
#> 17                           Metadata for Government Consumption, Value, Millions LCU, % change
#> 18                      Metadata for Inflation Rate (Consumer Price Index), Value, % change LCU
#> 19                                               Metadata for GNFS Exports, Value, Millions LCU
#> 20                                              Metadata for GNFS Exports, Volume, Millions LCU
#> 21                                    Metadata for Current Account Balance, Value, Millions USD
#> 22                                     Metadata for Agriculture, Volume, Millions 2015 real USD
#> 23           Metadata for Gross Domestic Product at Market Price, Value, Millions LCU, % change
#> 24                                           Metadata for Gross Fixed Investment, LCU, % of GDP
#> 25                                  Metadata for International poverty rate ($2.15 in 2017 PPP)
#> 26                                                                  Macro Poverty Outlook (MPO)
#> 27                                          Metadata for Current Account Balance, USD, % of GDP
#> 28                                          Metadata for Total Expenditure, Value, Millions USD
#> 29                                    Metadata for GNFS Exports, Volume, Millions LCU, % change
#> 30 Metadata for General Government Debt Stock (Millions of Local Currency), Value, Millions USD
#> 31                                      Metadata for Agriculture, Value, Millions LCU, % change
#> 32                                     Metadata for Government Consumption, Value, Millions LCU
#> 33                Metadata for Gross Fixed Investment, Volume, Millions 2015 real USD, % change
#> 34                      Metadata for Capital and Financial Account Balance, Value, Millions USD
#> 35                                     Metadata for Primary Fiscal Balance, Value, Millions LCU
#> 36                                   Metadata for Total Revenue and Grants, Value, Millions USD
#> 37                      Metadata for Net Foreign Direct Investment Outflow, Value, Millions USD
#> 38                                               Metadata for GNFS Imports, Value, Millions LCU
#> 39                          Metadata for Government Consumption, Volume, Millions 2015 real USD
#> 40                             Metadata for Private Consumption, Volume, Millions LCU, % change
#> 41                           Metadata for Gross Fixed Investment, Value, Millions LCU, % change
#> 42                                           Metadata for Overall Fiscal Balance, USD, % of GDP
#> 43                                           Metadata for Primary Fiscal Balance, USD, % of GDP
#> 44                                                  Metadata for Population, Millions of People
#> 45                          Metadata for Emissions: Energy, fuel combustion activities (ktCO2e)
#> 46                                    Metadata for GNFS Imports, Volume, Millions LCU, % change
#> 47                          Metadata for Gross Fixed Investment, Volume, Millions LCU, % change
#> 48                                               Metadata for Agriculture, Volume, Millions LCU
#> 49                     Metadata for Industry, Volume, Millions 2015 real USD, Millions % change
#> 50                                                  Metadata for Services, Volume, Millions LCU
#>               metadata_information.idno metadata_information.prod_date
#> 1               META_WB_MPO_GGBALPRIMCD                     2024-07-02
#> 2             META_WB_MPO_NECONPRVTPCKN                     2024-07-02
#> 3               META_WB_MPO_NYGDPMKTPCD                     2024-07-02
#> 4               META_WB_MPO_GGEXPINTPCN                     2024-07-02
#> 5              META_WB_MPO_NEEXPGNFSCNZ                     2024-07-02
#> 6               META_WB_MPO_GGBALOVRLCN                     2024-07-02
#> 7               META_WB_MPO_GGBALOVRLCD                     2024-07-02
#> 8              META_WB_MPO_NEEXPGNFSKDZ                     2024-07-02
#> 9              META_WB_MPO_NEIMPGNFSKDZ                     2024-07-02
#> 10              META_WB_MPO_NYGDPMKTPCN                     2024-07-02
#> 11             META_WB_MPO_NYGDPMKTPKNZ                     2024-07-02
#> 12                     META_WB_MPO_POV2                     2024-07-02
#> 13                     META_WB_MPO_POV3                     2024-07-02
#> 14              META_WB_MPO_FPCPITOTLXN                     2024-07-02
#> 15              META_WB_MPO_NEIMPGNFSKD                     2024-07-02
#> 16              META_WB_MPO_NYGDPMKTPKD                     2024-07-02
#> 17             META_WB_MPO_NECONGOVTCNZ                     2024-07-02
#> 18             META_WB_MPO_FPCPITOTLXNZ                     2024-07-02
#> 19              META_WB_MPO_NEEXPGNFSCN                     2024-07-02
#> 20              META_WB_MPO_NEEXPGNFSKN                     2024-07-02
#> 21              META_WB_MPO_BNCABFUNDCD                     2024-07-02
#> 22              META_WB_MPO_NVAGRTOTLKD                     2024-07-02
#> 23             META_WB_MPO_NYGDPMKTPCNZ                     2024-07-02
#> 24             META_WB_MPO_NEGDIFTOTKN_                     2024-07-02
#> 25                     META_WB_MPO_POV1                     2024-07-02
#> 26 16ffd22e-c3b6-477d-bb16-45c423263eb0                           <NA>
#> 27             META_WB_MPO_BNCABFUNDCD_                     2024-07-02
#> 28              META_WB_MPO_GGEXPTOTLCD                     2024-07-02
#> 29             META_WB_MPO_NEEXPGNFSKNZ                     2024-07-02
#> 30              META_WB_MPO_GGDBTTOTLCD                     2024-07-02
#> 31             META_WB_MPO_NVAGRTOTLCNZ                     2024-07-02
#> 32              META_WB_MPO_NECONGOVTCN                     2024-07-02
#> 33             META_WB_MPO_NEGDIFTOTKDZ                     2024-07-02
#> 34              META_WB_MPO_BFCAFTOTLCD                     2024-07-02
#> 35              META_WB_MPO_GGBALPRIMCN                     2024-07-02
#> 36              META_WB_MPO_GGREVTOTLCD                     2024-07-02
#> 37              META_WB_MPO_BFCAFFFDICD                     2024-07-02
#> 38              META_WB_MPO_NEIMPGNFSCN                     2024-07-02
#> 39              META_WB_MPO_NECONGOVTKD                     2024-07-02
#> 40             META_WB_MPO_NECONPRVTKNZ                     2024-07-02
#> 41             META_WB_MPO_NEGDIFTOTCNZ                     2024-07-02
#> 42             META_WB_MPO_GGBALOVRLCD_                     2024-07-02
#> 43             META_WB_MPO_GGBALPRIMCD_                     2024-07-02
#> 44                META_WB_MPO_SPPOPTOTL                     2024-07-02
#> 45              META_WB_MPO_ENENRGHGEKT                     2024-07-02
#> 46             META_WB_MPO_NEIMPGNFSKNZ                     2024-07-02
#> 47             META_WB_MPO_NEGDIFTOTKNZ                     2024-07-02
#> 48              META_WB_MPO_NVAGRTOTLKN                     2024-07-02
#> 49             META_WB_MPO_NVINDTOTLKDZ                     2024-07-02
#> 50              META_WB_MPO_NVSRVTOTLKN                     2024-07-02
#>    metadata_information.version_statement.version
#> 1                                             1.1
#> 2                                             1.1
#> 3                                             1.1
#> 4                                             1.1
#> 5                                             1.1
#> 6                                             1.1
#> 7                                             1.1
#> 8                                             1.1
#> 9                                             1.1
#> 10                                            1.1
#> 11                                            1.1
#> 12                                            1.1
#> 13                                            1.1
#> 14                                            1.1
#> 15                                            1.1
#> 16                                            1.1
#> 17                                            1.1
#> 18                                            1.1
#> 19                                            1.1
#> 20                                            1.1
#> 21                                            1.1
#> 22                                            1.1
#> 23                                            1.1
#> 24                                            1.1
#> 25                                            1.1
#> 26                                           <NA>
#> 27                                            1.1
#> 28                                            1.1
#> 29                                            1.1
#> 30                                            1.1
#> 31                                            1.1
#> 32                                            1.1
#> 33                                            1.1
#> 34                                            1.1
#> 35                                            1.1
#> 36                                            1.1
#> 37                                            1.1
#> 38                                            1.1
#> 39                                            1.1
#> 40                                            1.1
#> 41                                            1.1
#> 42                                            1.1
#> 43                                            1.1
#> 44                                            1.1
#> 45                                            1.1
#> 46                                            1.1
#> 47                                            1.1
#> 48                                            1.1
#> 49                                            1.1
#> 50                                            1.1
#>    metadata_information.version_statement.version_date
#> 1                                           2025-03-17
#> 2                                           2025-03-17
#> 3                                           2025-03-17
#> 4                                           2025-03-17
#> 5                                           2025-03-17
#> 6                                           2025-03-17
#> 7                                           2025-03-17
#> 8                                           2025-03-17
#> 9                                           2025-03-17
#> 10                                          2025-03-17
#> 11                                          2025-03-17
#> 12                                          2025-03-17
#> 13                                          2025-03-17
#> 14                                          2025-03-17
#> 15                                          2025-03-17
#> 16                                          2025-03-17
#> 17                                          2025-03-17
#> 18                                          2025-03-17
#> 19                                          2025-03-17
#> 20                                          2025-03-17
#> 21                                          2025-03-17
#> 22                                          2025-03-17
#> 23                                          2025-03-17
#> 24                                          2025-03-17
#> 25                                          2025-03-17
#> 26                                                <NA>
#> 27                                          2025-03-17
#> 28                                          2025-03-17
#> 29                                          2025-03-17
#> 30                                          2025-03-17
#> 31                                          2025-03-17
#> 32                                          2025-03-17
#> 33                                          2025-03-17
#> 34                                          2025-03-17
#> 35                                          2025-03-17
#> 36                                          2025-03-17
#> 37                                          2025-03-17
#> 38                                          2025-03-17
#> 39                                          2025-03-17
#> 40                                          2025-03-17
#> 41                                          2025-03-17
#> 42                                          2025-03-17
#> 43                                          2025-03-17
#> 44                                          2025-03-17
#> 45                                          2025-03-17
#> 46                                          2025-03-17
#> 47                                          2025-03-17
#> 48                                          2025-03-17
#> 49                                          2025-03-17
#> 50                                          2025-03-17
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
#> 35                                                  NA
#> 36                                                  NA
#> 37                                                  NA
#> 38                                                  NA
#> 39                                                  NA
#> 40                                                  NA
#> 41                                                  NA
#> 42                                                  NA
#> 43                                                  NA
#> 44                                                  NA
#> 45                                                  NA
#> 46                                                  NA
#> 47                                                  NA
#> 48                                                  NA
#> 49                                                  NA
#> 50                                                  NA
#>    metadata_information.version_statement.version_notes
#> 1             Updated title formatting for consistency.
#> 2             Updated title formatting for consistency.
#> 3             Updated title formatting for consistency.
#> 4             Updated title formatting for consistency.
#> 5             Updated title formatting for consistency.
#> 6             Updated title formatting for consistency.
#> 7             Updated title formatting for consistency.
#> 8             Updated title formatting for consistency.
#> 9             Updated title formatting for consistency.
#> 10            Updated title formatting for consistency.
#> 11            Updated title formatting for consistency.
#> 12            Updated title formatting for consistency.
#> 13            Updated title formatting for consistency.
#> 14            Updated title formatting for consistency.
#> 15            Updated title formatting for consistency.
#> 16            Updated title formatting for consistency.
#> 17            Updated title formatting for consistency.
#> 18            Updated title formatting for consistency.
#> 19            Updated title formatting for consistency.
#> 20            Updated title formatting for consistency.
#> 21            Updated title formatting for consistency.
#> 22            Updated title formatting for consistency.
#> 23            Updated title formatting for consistency.
#> 24            Updated title formatting for consistency.
#> 25            Updated title formatting for consistency.
#> 26                                                 <NA>
#> 27            Updated title formatting for consistency.
#> 28            Updated title formatting for consistency.
#> 29            Updated title formatting for consistency.
#> 30            Updated title formatting for consistency.
#> 31            Updated title formatting for consistency.
#> 32            Updated title formatting for consistency.
#> 33            Updated title formatting for consistency.
#> 34            Updated title formatting for consistency.
#> 35            Updated title formatting for consistency.
#> 36            Updated title formatting for consistency.
#> 37            Updated title formatting for consistency.
#> 38            Updated title formatting for consistency.
#> 39            Updated title formatting for consistency.
#> 40            Updated title formatting for consistency.
#> 41            Updated title formatting for consistency.
#> 42            Updated title formatting for consistency.
#> 43            Updated title formatting for consistency.
#> 44            Updated title formatting for consistency.
#> 45            Updated title formatting for consistency.
#> 46            Updated title formatting for consistency.
#> 47            Updated title formatting for consistency.
#> 48            Updated title formatting for consistency.
#> 49            Updated title formatting for consistency.
#> 50            Updated title formatting for consistency.
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
#> 26                                                    NULL
#> 27 Development Economics Data Group, DECDG, World Bank, NA
#> 28 Development Economics Data Group, DECDG, World Bank, NA
#> 29 Development Economics Data Group, DECDG, World Bank, NA
#> 30 Development Economics Data Group, DECDG, World Bank, NA
#> 31 Development Economics Data Group, DECDG, World Bank, NA
#> 32 Development Economics Data Group, DECDG, World Bank, NA
#> 33 Development Economics Data Group, DECDG, World Bank, NA
#> 34 Development Economics Data Group, DECDG, World Bank, NA
#> 35 Development Economics Data Group, DECDG, World Bank, NA
#> 36 Development Economics Data Group, DECDG, World Bank, NA
#> 37 Development Economics Data Group, DECDG, World Bank, NA
#> 38 Development Economics Data Group, DECDG, World Bank, NA
#> 39 Development Economics Data Group, DECDG, World Bank, NA
#> 40 Development Economics Data Group, DECDG, World Bank, NA
#> 41 Development Economics Data Group, DECDG, World Bank, NA
#> 42 Development Economics Data Group, DECDG, World Bank, NA
#> 43 Development Economics Data Group, DECDG, World Bank, NA
#> 44 Development Economics Data Group, DECDG, World Bank, NA
#> 45 Development Economics Data Group, DECDG, World Bank, NA
#> 46 Development Economics Data Group, DECDG, World Bank, NA
#> 47 Development Economics Data Group, DECDG, World Bank, NA
#> 48 Development Economics Data Group, DECDG, World Bank, NA
#> 49 Development Economics Data Group, DECDG, World Bank, NA
#> 50 Development Economics Data Group, DECDG, World Bank, NA
#>    series_description.idno series_description.doi
#> 1       WB_MPO_GGBALPRIMCD                     NA
#> 2     WB_MPO_NECONPRVTPCKN                     NA
#> 3       WB_MPO_NYGDPMKTPCD                     NA
#> 4       WB_MPO_GGEXPINTPCN                     NA
#> 5      WB_MPO_NEEXPGNFSCNZ                     NA
#> 6       WB_MPO_GGBALOVRLCN                     NA
#> 7       WB_MPO_GGBALOVRLCD                     NA
#> 8      WB_MPO_NEEXPGNFSKDZ                     NA
#> 9      WB_MPO_NEIMPGNFSKDZ                     NA
#> 10      WB_MPO_NYGDPMKTPCN                     NA
#> 11     WB_MPO_NYGDPMKTPKNZ                     NA
#> 12             WB_MPO_POV2                     NA
#> 13             WB_MPO_POV3                     NA
#> 14      WB_MPO_FPCPITOTLXN                     NA
#> 15      WB_MPO_NEIMPGNFSKD                     NA
#> 16      WB_MPO_NYGDPMKTPKD                     NA
#> 17     WB_MPO_NECONGOVTCNZ                     NA
#> 18     WB_MPO_FPCPITOTLXNZ                     NA
#> 19      WB_MPO_NEEXPGNFSCN                     NA
#> 20      WB_MPO_NEEXPGNFSKN                     NA
#> 21      WB_MPO_BNCABFUNDCD                     NA
#> 22      WB_MPO_NVAGRTOTLKD                     NA
#> 23     WB_MPO_NYGDPMKTPCNZ                     NA
#> 24     WB_MPO_NEGDIFTOTKN_                     NA
#> 25             WB_MPO_POV1                     NA
#> 26                    <NA>                     NA
#> 27     WB_MPO_BNCABFUNDCD_                     NA
#> 28      WB_MPO_GGEXPTOTLCD                     NA
#> 29     WB_MPO_NEEXPGNFSKNZ                     NA
#> 30      WB_MPO_GGDBTTOTLCD                     NA
#> 31     WB_MPO_NVAGRTOTLCNZ                     NA
#> 32      WB_MPO_NECONGOVTCN                     NA
#> 33     WB_MPO_NEGDIFTOTKDZ                     NA
#> 34      WB_MPO_BFCAFTOTLCD                     NA
#> 35      WB_MPO_GGBALPRIMCN                     NA
#> 36      WB_MPO_GGREVTOTLCD                     NA
#> 37      WB_MPO_BFCAFFFDICD                     NA
#> 38      WB_MPO_NEIMPGNFSCN                     NA
#> 39      WB_MPO_NECONGOVTKD                     NA
#> 40     WB_MPO_NECONPRVTKNZ                     NA
#> 41     WB_MPO_NEGDIFTOTCNZ                     NA
#> 42     WB_MPO_GGBALOVRLCD_                     NA
#> 43     WB_MPO_GGBALPRIMCD_                     NA
#> 44        WB_MPO_SPPOPTOTL                     NA
#> 45      WB_MPO_ENENRGHGEKT                     NA
#> 46     WB_MPO_NEIMPGNFSKNZ                     NA
#> 47     WB_MPO_NEGDIFTOTKNZ                     NA
#> 48      WB_MPO_NVAGRTOTLKN                     NA
#> 49     WB_MPO_NVINDTOTLKDZ                     NA
#> 50      WB_MPO_NVSRVTOTLKN                     NA
#>                                                            series_description.name
#> 1                                      Primary Fiscal Balance, Value, Millions USD
#> 2                             Private Consumption per capita, Volume, Millions LCU
#> 3                      Gross Domestic Product at Market Price, Value, Millions USD
#> 4                                           Interest Payments, Value, Millions LCU
#> 5                                      GNFS Exports, Value, Millions LCU, % change
#> 6                                      Overall Fiscal Balance, Value, Millions LCU
#> 7                                      Overall Fiscal Balance, Value, Millions USD
#> 8                           GNFS Exports, Volume, Millions 2015 real USD, % change
#> 9                           GNFS Imports, Volume, Millions 2015 real USD, % change
#> 10                     Gross Domestic Product at Market Price, Value, Millions LCU
#> 11          Gross Domestic Product at Market Price, Volume, Millions LCU, % change
#> 12                            Lower middle-income poverty rate ($3.65 in 2017 PPP)
#> 13                            Upper middle-income poverty rate ($6.85 in 2017 PPP)
#> 14                                    Consumer Price Index, Implicit Deflator, LCU
#> 15                                    GNFS Imports, Volume, Millions 2015 real USD
#> 16          Gross Domestic Product at Market Price, Volume, Millions 2015 real USD
#> 17                           Government Consumption, Value, Millions LCU, % change
#> 18                      Inflation Rate (Consumer Price Index), Value, % change LCU
#> 19                                               GNFS Exports, Value, Millions LCU
#> 20                                              GNFS Exports, Volume, Millions LCU
#> 21                                    Current Account Balance, Value, Millions USD
#> 22                                     Agriculture, Volume, Millions 2015 real USD
#> 23           Gross Domestic Product at Market Price, Value, Millions LCU, % change
#> 24                                           Gross Fixed Investment, LCU, % of GDP
#> 25                                  International poverty rate ($2.15 in 2017 PPP)
#> 26                                                     Macro Poverty Outlook (MPO)
#> 27                                          Current Account Balance, USD, % of GDP
#> 28                                          Total Expenditure, Value, Millions USD
#> 29                                    GNFS Exports, Volume, Millions LCU, % change
#> 30 General Government Debt Stock (Millions of Local Currency), Value, Millions USD
#> 31                                      Agriculture, Value, Millions LCU, % change
#> 32                                     Government Consumption, Value, Millions LCU
#> 33                Gross Fixed Investment, Volume, Millions 2015 real USD, % change
#> 34                      Capital and Financial Account Balance, Value, Millions USD
#> 35                                     Primary Fiscal Balance, Value, Millions LCU
#> 36                                   Total Revenue and Grants, Value, Millions USD
#> 37                      Net Foreign Direct Investment Outflow, Value, Millions USD
#> 38                                               GNFS Imports, Value, Millions LCU
#> 39                          Government Consumption, Volume, Millions 2015 real USD
#> 40                             Private Consumption, Volume, Millions LCU, % change
#> 41                           Gross Fixed Investment, Value, Millions LCU, % change
#> 42                                           Overall Fiscal Balance, USD, % of GDP
#> 43                                           Primary Fiscal Balance, USD, % of GDP
#> 44                                                  Population, Millions of People
#> 45                          Emissions: Energy, fuel combustion activities (ktCO2e)
#> 46                                    GNFS Imports, Volume, Millions LCU, % change
#> 47                          Gross Fixed Investment, Volume, Millions LCU, % change
#> 48                                               Agriculture, Volume, Millions LCU
#> 49                     Industry, Volume, Millions 2015 real USD, Millions % change
#> 50                                                  Services, Volume, Millions LCU
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
#> 35                              NA                         WB_MPO
#> 36                              NA                         WB_MPO
#> 37                              NA                         WB_MPO
#> 38                              NA                         WB_MPO
#> 39                              NA                         WB_MPO
#> 40                              NA                         WB_MPO
#> 41                              NA                         WB_MPO
#> 42                              NA                         WB_MPO
#> 43                              NA                         WB_MPO
#> 44                              NA                         WB_MPO
#> 45                              NA                         WB_MPO
#> 46                              NA                         WB_MPO
#> 47                              NA                         WB_MPO
#> 48                              NA                         WB_MPO
#> 49                              NA                         WB_MPO
#> 50                              NA                         WB_MPO
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
#> 19            Macro Poverty Outlook                                <NA>
#> 20            Macro Poverty Outlook                                <NA>
#> 21            Macro Poverty Outlook                                <NA>
#> 22            Macro Poverty Outlook                                <NA>
#> 23            Macro Poverty Outlook                                <NA>
#> 24            Macro Poverty Outlook                                <NA>
#> 25            Macro Poverty Outlook                                <NA>
#> 26      Macro Poverty Outlook (MPO)                          2025-10-10
#> 27            Macro Poverty Outlook                                <NA>
#> 28            Macro Poverty Outlook                                <NA>
#> 29            Macro Poverty Outlook                                <NA>
#> 30            Macro Poverty Outlook                                <NA>
#> 31            Macro Poverty Outlook                                <NA>
#> 32            Macro Poverty Outlook                                <NA>
#> 33            Macro Poverty Outlook                                <NA>
#> 34            Macro Poverty Outlook                                <NA>
#> 35            Macro Poverty Outlook                                <NA>
#> 36            Macro Poverty Outlook                                <NA>
#> 37            Macro Poverty Outlook                                <NA>
#> 38            Macro Poverty Outlook                                <NA>
#> 39            Macro Poverty Outlook                                <NA>
#> 40            Macro Poverty Outlook                                <NA>
#> 41            Macro Poverty Outlook                                <NA>
#> 42            Macro Poverty Outlook                                <NA>
#> 43            Macro Poverty Outlook                                <NA>
#> 44            Macro Poverty Outlook                                <NA>
#> 45            Macro Poverty Outlook                                <NA>
#> 46            Macro Poverty Outlook                                <NA>
#> 47            Macro Poverty Outlook                                <NA>
#> 48            Macro Poverty Outlook                                <NA>
#> 49            Macro Poverty Outlook                                <NA>
#> 50            Macro Poverty Outlook                                <NA>
#>    series_description.date_released series_description.measurement_unit
#> 1                                NA                          US dollars
#> 2                                NA                   Domestic currency
#> 3                                NA                          US dollars
#> 4                                NA                   Domestic currency
#> 5                                NA                          Percentage
#> 6                                NA                   Domestic currency
#> 7                                NA                          US dollars
#> 8                                NA                          Percentage
#> 9                                NA                          Percentage
#> 10                               NA                   Domestic currency
#> 11                               NA                          Percentage
#> 12                               NA                              Number
#> 13                               NA                              Number
#> 14                               NA                   Domestic currency
#> 15                               NA                          US dollars
#> 16                               NA                          US dollars
#> 17                               NA                          Percentage
#> 18                               NA                          Percentage
#> 19                               NA                   Domestic currency
#> 20                               NA                   Domestic currency
#> 21                               NA                          US dollars
#> 22                               NA                          US dollars
#> 23                               NA                          Percentage
#> 24                               NA                          Percentage
#> 25                               NA                              Number
#> 26                               NA                                <NA>
#> 27                               NA                          Percentage
#> 28                               NA                          US dollars
#> 29                               NA                          Percentage
#> 30                               NA                          US dollars
#> 31                               NA                          Percentage
#> 32                               NA                   Domestic currency
#> 33                               NA                          Percentage
#> 34                               NA                          US dollars
#> 35                               NA                   Domestic currency
#> 36                               NA                          US dollars
#> 37                               NA                          US dollars
#> 38                               NA                   Domestic currency
#> 39                               NA                          US dollars
#> 40                               NA                          Percentage
#> 41                               NA                          Percentage
#> 42                               NA                          Percentage
#> 43                               NA                          Percentage
#> 44                               NA                              Number
#> 45                               NA                              Number
#> 46                               NA                          Percentage
#> 47                               NA                          Percentage
#> 48                               NA                   Domestic currency
#> 49                               NA                          Percentage
#> 50                               NA                   Domestic currency
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
#> 26 {"update_schedule":null,"update_frequency":"annual"}
#> 27                                                 <NA>
#> 28                                                 <NA>
#> 29                                                 <NA>
#> 30                                                 <NA>
#> 31                                                 <NA>
#> 32                                                 <NA>
#> 33                                                 <NA>
#> 34                                                 <NA>
#> 35                                                 <NA>
#> 36                                                 <NA>
#> 37                                                 <NA>
#> 38                                                 <NA>
#> 39                                                 <NA>
#> 40                                                 <NA>
#> 41                                                 <NA>
#> 42                                                 <NA>
#> 43                                                 <NA>
#> 44                                                 <NA>
#> 45                                                 <NA>
#> 46                                                 <NA>
#> 47                                                 <NA>
#> 48                                                 <NA>
#> 49                                                 <NA>
#> 50                                                 <NA>
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
#> 26                           <NA>                             NA
#> 27                         Annual                             NA
#> 28                         Annual                             NA
#> 29                         Annual                             NA
#> 30                         Annual                             NA
#> 31                         Annual                             NA
#> 32                         Annual                             NA
#> 33                         Annual                             NA
#> 34                         Annual                             NA
#> 35                         Annual                             NA
#> 36                         Annual                             NA
#> 37                         Annual                             NA
#> 38                         Annual                             NA
#> 39                         Annual                             NA
#> 40                         Annual                             NA
#> 41                         Annual                             NA
#> 42                         Annual                             NA
#> 43                         Annual                             NA
#> 44                         Annual                             NA
#> 45                         Annual                             NA
#> 46                         Annual                             NA
#> 47                         Annual                             NA
#> 48                         Annual                             NA
#> 49                         Annual                             NA
#> 50                         Annual                             NA
#>                                                series_description.definition_short
#> 1                                      Primary Fiscal Balance, Value, Millions USD
#> 2                             Private Consumption per capita, Volume, Millions LCU
#> 3                      Gross Domestic Product at Market Price, Value, Millions USD
#> 4                                           Interest Payments, Value, Millions LCU
#> 5                                      GNFS Exports, Value, Millions LCU, % change
#> 6                                      Overall Fiscal Balance, Value, Millions LCU
#> 7                                      Overall Fiscal Balance, Value, Millions USD
#> 8                           GNFS Exports, Volume, Millions 2015 real USD, % change
#> 9                           GNFS Imports, Volume, Millions 2015 real USD, % change
#> 10                     Gross Domestic Product at Market Price, Value, Millions LCU
#> 11          Gross Domestic Product at Market Price, Volume, Millions LCU, % change
#> 12                            Lower middle-income poverty rate ($3.65 in 2017 PPP)
#> 13                            Upper middle-income poverty rate ($6.85 in 2017 PPP)
#> 14                                    Consumer Price Index, Implicit Deflator, LCU
#> 15                                    GNFS Imports, Volume, Millions 2015 real USD
#> 16          Gross Domestic Product at Market Price, Volume, Millions 2015 real USD
#> 17                           Government Consumption, Value, Millions LCU, % change
#> 18                      Inflation Rate (Consumer Price Index), Value, % change LCU
#> 19                                               GNFS Exports, Value, Millions LCU
#> 20                                              GNFS Exports, Volume, Millions LCU
#> 21                                    Current Account Balance, Value, Millions USD
#> 22                                     Agriculture, Volume, Millions 2015 real USD
#> 23           Gross Domestic Product at Market Price, Value, Millions LCU, % change
#> 24                                           Gross Fixed Investment, LCU, % of GDP
#> 25                                  International poverty rate ($2.15 in 2017 PPP)
#> 26                                                                            <NA>
#> 27                                          Current Account Balance, USD, % of GDP
#> 28                                          Total Expenditure, Value, Millions USD
#> 29                                    GNFS Exports, Volume, Millions LCU, % change
#> 30 General Government Debt Stock (Millions of Local Currency), Value, Millions USD
#> 31                                      Agriculture, Value, Millions LCU, % change
#> 32                                     Government Consumption, Value, Millions LCU
#> 33                Gross Fixed Investment, Volume, Millions 2015 real USD, % change
#> 34                      Capital and Financial Account Balance, Value, Millions USD
#> 35                                     Primary Fiscal Balance, Value, Millions LCU
#> 36                                   Total Revenue and Grants, Value, Millions USD
#> 37                      Net Foreign Direct Investment Outflow, Value, Millions USD
#> 38                                               GNFS Imports, Value, Millions LCU
#> 39                          Government Consumption, Volume, Millions 2015 real USD
#> 40                             Private Consumption, Volume, Millions LCU, % change
#> 41                           Gross Fixed Investment, Value, Millions LCU, % change
#> 42                                           Overall Fiscal Balance, USD, % of GDP
#> 43                                           Primary Fiscal Balance, USD, % of GDP
#> 44                                                  Population, Millions of People
#> 45                          Emissions: Energy, fuel combustion activities (ktCO2e)
#> 46                                    GNFS Imports, Volume, Millions LCU, % change
#> 47                          Gross Fixed Investment, Volume, Millions LCU, % change
#> 48                                               Agriculture, Volume, Millions LCU
#> 49                     Industry, Volume, Millions 2015 real USD, Millions % change
#> 50                                                  Services, Volume, Millions LCU
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
#> 26 The Macro Poverty Outlook (MPO) analyzes macroeconomic and poverty developments in 147 developing countries. The report is released twice annually for the Spring and Annual Meetings of the World Bank and the International Monetary Fund. The MPO consists of individual country notes that provide an overview of recent developments, forecasts of major macroeconomic variables and poverty during 2024-2026, and a discussion of critical challenges for economic growth, macroeconomic stability, and poverty reduction moving forward.\n\nFor further details, please refer to https://www.worldbank.org/en/publication/macro-poverty-outlook
#> 27                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 28                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 29                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 30                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 31                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 32                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 33                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 34                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 35                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 36                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 37                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 38                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 39                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 40                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 41                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 42                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 43                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 44                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 45                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 46                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 47                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 48                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 49                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 50                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
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
#> 35                                     NA
#> 36                                     NA
#> 37                                     NA
#> 38                                     NA
#> 39                                     NA
#> 40                                     NA
#> 41                                     NA
#> 42                                     NA
#> 43                                     NA
#> 44                                     NA
#> 45                                     NA
#> 46                                     NA
#> 47                                     NA
#> 48                                     NA
#> 49                                     NA
#> 50                                     NA
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
#> 26                                                                                          <NA>
#> 27 Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 28 Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 29 Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 30 Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 31 Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 32 Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 33 Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 34 Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 35 Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 36 Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 37 Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 38 Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 39 Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 40 Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 41 Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 42 Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 43 Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 44 Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 45 Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 46 Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 47 Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 48 Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 49 Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
#> 50 Please refer to: https://mtimodelling.worldbank.org/resources/MTI_Macro_Econometric_Model.pdf
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
#> 35                            NA                            NA
#> 36                            NA                            NA
#> 37                            NA                            NA
#> 38                            NA                            NA
#> 39                            NA                            NA
#> 40                            NA                            NA
#> 41                            NA                            NA
#> 42                            NA                            NA
#> 43                            NA                            NA
#> 44                            NA                            NA
#> 45                            NA                            NA
#> 46                            NA                            NA
#> 47                            NA                            NA
#> 48                            NA                            NA
#> 49                            NA                            NA
#> 50                            NA                            NA
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
#> 35                         NA                                NA
#> 36                         NA                                NA
#> 37                         NA                                NA
#> 38                         NA                                NA
#> 39                         NA                                NA
#> 40                         NA                                NA
#> 41                         NA                                NA
#> 42                         NA                                NA
#> 43                         NA                                NA
#> 44                         NA                                NA
#> 45                         NA                                NA
#> 46                         NA                                NA
#> 47                         NA                                NA
#> 48                         NA                                NA
#> 49                         NA                                NA
#> 50                         NA                                NA
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
#> 35                              NA                                       NA
#> 36                              NA                                       NA
#> 37                              NA                                       NA
#> 38                              NA                                       NA
#> 39                              NA                                       NA
#> 40                              NA                                       NA
#> 41                              NA                                       NA
#> 42                              NA                                       NA
#> 43                              NA                                       NA
#> 44                              NA                                       NA
#> 45                              NA                                       NA
#> 46                              NA                                       NA
#> 47                              NA                                       NA
#> 48                              NA                                       NA
#> 49                              NA                                       NA
#> 50                              NA                                       NA
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
#> 35                              NA                            NA
#> 36                              NA                            NA
#> 37                              NA                            NA
#> 38                              NA                            NA
#> 39                              NA                            NA
#> 40                              NA                            NA
#> 41                              NA                            NA
#> 42                              NA                            NA
#> 43                              NA                            NA
#> 44                              NA                            NA
#> 45                              NA                            NA
#> 46                              NA                            NA
#> 47                              NA                            NA
#> 48                              NA                            NA
#> 49                              NA                            NA
#> 50                              NA                            NA
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
#> 35                           NA                                    NA
#> 36                           NA                                    NA
#> 37                           NA                                    NA
#> 38                           NA                                    NA
#> 39                           NA                                    NA
#> 40                           NA                                    NA
#> 41                           NA                                    NA
#> 42                           NA                                    NA
#> 43                           NA                                    NA
#> 44                           NA                                    NA
#> 45                           NA                                    NA
#> 46                           NA                                    NA
#> 47                           NA                                    NA
#> 48                           NA                                    NA
#> 49                           NA                                    NA
#> 50                           NA                                    NA
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
#> 35                                NA
#> 36                                NA
#> 37                                NA
#> 38                                NA
#> 39                                NA
#> 40                                NA
#> 41                                NA
#> 42                                NA
#> 43                                NA
#> 44                                NA
#> 45                                NA
#> 46                                NA
#> 47                                NA
#> 48                                NA
#> 49                                NA
#> 50                                NA
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
#> 26                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              <NA>
#> 27 You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 28 You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 29 You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 30 You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 31 You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 32 You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 33 You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 34 You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 35 You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 36 You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 37 You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 38 You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 39 You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 40 You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 41 You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 42 You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 43 You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 44 You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 45 You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 46 You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 47 You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 48 You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 49 You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
#> 50 You are encouraged to use the Datasets to benefit yourself and others in creative ways. You may extract, download, and make copies of the data contained in the Datasets, and you may share that data with third parties according to these terms of use.\nUnless specifically labeled otherwise, these Datasets are provided to you under a Creative Commons Attribution 4.0 International License (CC BY 4.0), with the additional terms below.  The basic terms may be accessed here.  When you download or use the Datasets, you are agreeing to comply with the terms of a CC BY 4.0 license, and also agreeing to the following mandatory and binding addition:\nAny and all disputes arising under this License that cannot be settled amicably shall be resolved in accordance with the following procedure:\n  Pursuant to a notice of mediation communicated by reasonable means by either You or the Licensor to the other, the dispute shall be submitted to non-binding mediation conducted in accordance with rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with those communicated in the notice of mediation. The language used in the mediation proceedings shall be English unless otherwise agreed.\n  If any such dispute has not been settled within 45 days following the date on which the notice of mediation is provided, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other, elect to have the dispute referred to and finally determined by arbitration. The arbitration shall be conducted in accordance with the rules designated by the Licensor in the copyright notice published with the Work, or if none then in accordance with the UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable\nYou agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known). When sharing or facilitating access to the Datasets, you agree to include the same acknowledgment requirement in any sub-licenses of the data that you grant, and a requirement that any sub-licensees do the same. You may meet this requirement by providing the uniform resource locator (URL) of these terms of use.\nYou may use our application programming interfaces (APIs) to facilitate access to the Datasets, whether through a separate Web site or through another type of software application.
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
#> 26                                      <NA>
#> 27                                        PU
#> 28                                        PU
#> 29                                        PU
#> 30                                        PU
#> 31                                        PU
#> 32                                        PU
#> 33                                        PU
#> 34                                        PU
#> 35                                        PU
#> 36                                        PU
#> 37                                        PU
#> 38                                        PU
#> 39                                        PU
#> 40                                        PU
#> 41                                        PU
#> 42                                        PU
#> 43                                        PU
#> 44                                        PU
#> 45                                        PU
#> 46                                        PU
#> 47                                        PU
#> 48                                        PU
#> 49                                        PU
#> 50                                        PU
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
#> 26                                                               <NA>
#> 27 https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 28 https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 29 https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 30 https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 31 https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 32 https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 33 https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 34 https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 35 https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 36 https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 37 https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 38 https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 39 https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 40 https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 41 https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 42 https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 43 https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 44 https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 45 https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 46 https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 47 https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 48 https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 49 https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
#> 50 https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets
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
#> 26 World Bank. (Year). Macro Poverty Outlook. Washington, DC: World Bank. https://www.worldbank.org/en/publication/macro-poverty-outlook
#> 27                                                                                                                                  <NA>
#> 28                                                                                                                                  <NA>
#> 29                                                                                                                                  <NA>
#> 30                                                                                                                                  <NA>
#> 31                                                                                                                                  <NA>
#> 32                                                                                                                                  <NA>
#> 33                                                                                                                                  <NA>
#> 34                                                                                                                                  <NA>
#> 35                                                                                                                                  <NA>
#> 36                                                                                                                                  <NA>
#> 37                                                                                                                                  <NA>
#> 38                                                                                                                                  <NA>
#> 39                                                                                                                                  <NA>
#> 40                                                                                                                                  <NA>
#> 41                                                                                                                                  <NA>
#> 42                                                                                                                                  <NA>
#> 43                                                                                                                                  <NA>
#> 44                                                                                                                                  <NA>
#> 45                                                                                                                                  <NA>
#> 46                                                                                                                                  <NA>
#> 47                                                                                                                                  <NA>
#> 48                                                                                                                                  <NA>
#> 49                                                                                                                                  <NA>
#> 50                                                                                                                                  <NA>
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
#> 35                              NA                                           NA
#> 36                              NA                                           NA
#> 37                              NA                                           NA
#> 38                              NA                                           NA
#> 39                              NA                                           NA
#> 40                              NA                                           NA
#> 41                              NA                                           NA
#> 42                              NA                                           NA
#> 43                              NA                                           NA
#> 44                              NA                                           NA
#> 45                              NA                                           NA
#> 46                              NA                                           NA
#> 47                              NA                                           NA
#> 48                              NA                                           NA
#> 49                              NA                                           NA
#> 50                              NA                                           NA
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
#> 26                            NA                                149
#> 27                            NA                                 NA
#> 28                            NA                                 NA
#> 29                            NA                                 NA
#> 30                            NA                                 NA
#> 31                            NA                                 NA
#> 32                            NA                                 NA
#> 33                            NA                                 NA
#> 34                            NA                                 NA
#> 35                            NA                                 NA
#> 36                            NA                                 NA
#> 37                            NA                                 NA
#> 38                            NA                                 NA
#> 39                            NA                                 NA
#> 40                            NA                                 NA
#> 41                            NA                                 NA
#> 42                            NA                                 NA
#> 43                            NA                                 NA
#> 44                            NA                                 NA
#> 45                            NA                                 NA
#> 46                            NA                                 NA
#> 47                            NA                                 NA
#> 48                            NA                                 NA
#> 49                            NA                                 NA
#> 50                            NA                                 NA
#>                                                             series_description.csv_link
#> 1    https://data360files.worldbank.org/data360-data/data/WB_MPO/WB_MPO_GGBALPRIMCD.csv
#> 2  https://data360files.worldbank.org/data360-data/data/WB_MPO/WB_MPO_NECONPRVTPCKN.csv
#> 3    https://data360files.worldbank.org/data360-data/data/WB_MPO/WB_MPO_NYGDPMKTPCD.csv
#> 4    https://data360files.worldbank.org/data360-data/data/WB_MPO/WB_MPO_GGEXPINTPCN.csv
#> 5   https://data360files.worldbank.org/data360-data/data/WB_MPO/WB_MPO_NEEXPGNFSCNZ.csv
#> 6    https://data360files.worldbank.org/data360-data/data/WB_MPO/WB_MPO_GGBALOVRLCN.csv
#> 7    https://data360files.worldbank.org/data360-data/data/WB_MPO/WB_MPO_GGBALOVRLCD.csv
#> 8   https://data360files.worldbank.org/data360-data/data/WB_MPO/WB_MPO_NEEXPGNFSKDZ.csv
#> 9   https://data360files.worldbank.org/data360-data/data/WB_MPO/WB_MPO_NEIMPGNFSKDZ.csv
#> 10   https://data360files.worldbank.org/data360-data/data/WB_MPO/WB_MPO_NYGDPMKTPCN.csv
#> 11  https://data360files.worldbank.org/data360-data/data/WB_MPO/WB_MPO_NYGDPMKTPKNZ.csv
#> 12          https://data360files.worldbank.org/data360-data/data/WB_MPO/WB_MPO_POV2.csv
#> 13          https://data360files.worldbank.org/data360-data/data/WB_MPO/WB_MPO_POV3.csv
#> 14   https://data360files.worldbank.org/data360-data/data/WB_MPO/WB_MPO_FPCPITOTLXN.csv
#> 15   https://data360files.worldbank.org/data360-data/data/WB_MPO/WB_MPO_NEIMPGNFSKD.csv
#> 16   https://data360files.worldbank.org/data360-data/data/WB_MPO/WB_MPO_NYGDPMKTPKD.csv
#> 17  https://data360files.worldbank.org/data360-data/data/WB_MPO/WB_MPO_NECONGOVTCNZ.csv
#> 18  https://data360files.worldbank.org/data360-data/data/WB_MPO/WB_MPO_FPCPITOTLXNZ.csv
#> 19   https://data360files.worldbank.org/data360-data/data/WB_MPO/WB_MPO_NEEXPGNFSCN.csv
#> 20   https://data360files.worldbank.org/data360-data/data/WB_MPO/WB_MPO_NEEXPGNFSKN.csv
#> 21   https://data360files.worldbank.org/data360-data/data/WB_MPO/WB_MPO_BNCABFUNDCD.csv
#> 22   https://data360files.worldbank.org/data360-data/data/WB_MPO/WB_MPO_NVAGRTOTLKD.csv
#> 23  https://data360files.worldbank.org/data360-data/data/WB_MPO/WB_MPO_NYGDPMKTPCNZ.csv
#> 24  https://data360files.worldbank.org/data360-data/data/WB_MPO/WB_MPO_NEGDIFTOTKN_.csv
#> 25          https://data360files.worldbank.org/data360-data/data/WB_MPO/WB_MPO_POV1.csv
#> 26               https://data360files.worldbank.org/data360-data/data/WB_MPO/WB_MPO.csv
#> 27  https://data360files.worldbank.org/data360-data/data/WB_MPO/WB_MPO_BNCABFUNDCD_.csv
#> 28   https://data360files.worldbank.org/data360-data/data/WB_MPO/WB_MPO_GGEXPTOTLCD.csv
#> 29  https://data360files.worldbank.org/data360-data/data/WB_MPO/WB_MPO_NEEXPGNFSKNZ.csv
#> 30   https://data360files.worldbank.org/data360-data/data/WB_MPO/WB_MPO_GGDBTTOTLCD.csv
#> 31  https://data360files.worldbank.org/data360-data/data/WB_MPO/WB_MPO_NVAGRTOTLCNZ.csv
#> 32   https://data360files.worldbank.org/data360-data/data/WB_MPO/WB_MPO_NECONGOVTCN.csv
#> 33  https://data360files.worldbank.org/data360-data/data/WB_MPO/WB_MPO_NEGDIFTOTKDZ.csv
#> 34   https://data360files.worldbank.org/data360-data/data/WB_MPO/WB_MPO_BFCAFTOTLCD.csv
#> 35   https://data360files.worldbank.org/data360-data/data/WB_MPO/WB_MPO_GGBALPRIMCN.csv
#> 36   https://data360files.worldbank.org/data360-data/data/WB_MPO/WB_MPO_GGREVTOTLCD.csv
#> 37   https://data360files.worldbank.org/data360-data/data/WB_MPO/WB_MPO_BFCAFFFDICD.csv
#> 38   https://data360files.worldbank.org/data360-data/data/WB_MPO/WB_MPO_NEIMPGNFSCN.csv
#> 39   https://data360files.worldbank.org/data360-data/data/WB_MPO/WB_MPO_NECONGOVTKD.csv
#> 40  https://data360files.worldbank.org/data360-data/data/WB_MPO/WB_MPO_NECONPRVTKNZ.csv
#> 41  https://data360files.worldbank.org/data360-data/data/WB_MPO/WB_MPO_NEGDIFTOTCNZ.csv
#> 42  https://data360files.worldbank.org/data360-data/data/WB_MPO/WB_MPO_GGBALOVRLCD_.csv
#> 43  https://data360files.worldbank.org/data360-data/data/WB_MPO/WB_MPO_GGBALPRIMCD_.csv
#> 44     https://data360files.worldbank.org/data360-data/data/WB_MPO/WB_MPO_SPPOPTOTL.csv
#> 45   https://data360files.worldbank.org/data360-data/data/WB_MPO/WB_MPO_ENENRGHGEKT.csv
#> 46  https://data360files.worldbank.org/data360-data/data/WB_MPO/WB_MPO_NEIMPGNFSKNZ.csv
#> 47  https://data360files.worldbank.org/data360-data/data/WB_MPO/WB_MPO_NEGDIFTOTKNZ.csv
#> 48   https://data360files.worldbank.org/data360-data/data/WB_MPO/WB_MPO_NVAGRTOTLKN.csv
#> 49  https://data360files.worldbank.org/data360-data/data/WB_MPO/WB_MPO_NVINDTOTLKDZ.csv
#> 50   https://data360files.worldbank.org/data360-data/data/WB_MPO/WB_MPO_NVSRVTOTLKN.csv
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
#> 35                            NA
#> 36                            NA
#> 37                            NA
#> 38                            NA
#> 39                            NA
#> 40                            NA
#> 41                            NA
#> 42                            NA
#> 43                            NA
#> 44                            NA
#> 45                            NA
#> 46                            NA
#> 47                            NA
#> 48                            NA
#> 49                            NA
#> 50                            NA
#>                                                                 series_description.json_link
#> 1    https://data360files.worldbank.org/data360-data/metadata/WB_MPO/WB_MPO_GGBALPRIMCD.json
#> 2  https://data360files.worldbank.org/data360-data/metadata/WB_MPO/WB_MPO_NECONPRVTPCKN.json
#> 3    https://data360files.worldbank.org/data360-data/metadata/WB_MPO/WB_MPO_NYGDPMKTPCD.json
#> 4    https://data360files.worldbank.org/data360-data/metadata/WB_MPO/WB_MPO_GGEXPINTPCN.json
#> 5   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/WB_MPO_NEEXPGNFSCNZ.json
#> 6    https://data360files.worldbank.org/data360-data/metadata/WB_MPO/WB_MPO_GGBALOVRLCN.json
#> 7    https://data360files.worldbank.org/data360-data/metadata/WB_MPO/WB_MPO_GGBALOVRLCD.json
#> 8   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/WB_MPO_NEEXPGNFSKDZ.json
#> 9   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/WB_MPO_NEIMPGNFSKDZ.json
#> 10   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/WB_MPO_NYGDPMKTPCN.json
#> 11  https://data360files.worldbank.org/data360-data/metadata/WB_MPO/WB_MPO_NYGDPMKTPKNZ.json
#> 12          https://data360files.worldbank.org/data360-data/metadata/WB_MPO/WB_MPO_POV2.json
#> 13          https://data360files.worldbank.org/data360-data/metadata/WB_MPO/WB_MPO_POV3.json
#> 14   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/WB_MPO_FPCPITOTLXN.json
#> 15   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/WB_MPO_NEIMPGNFSKD.json
#> 16   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/WB_MPO_NYGDPMKTPKD.json
#> 17  https://data360files.worldbank.org/data360-data/metadata/WB_MPO/WB_MPO_NECONGOVTCNZ.json
#> 18  https://data360files.worldbank.org/data360-data/metadata/WB_MPO/WB_MPO_FPCPITOTLXNZ.json
#> 19   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/WB_MPO_NEEXPGNFSCN.json
#> 20   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/WB_MPO_NEEXPGNFSKN.json
#> 21   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/WB_MPO_BNCABFUNDCD.json
#> 22   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/WB_MPO_NVAGRTOTLKD.json
#> 23  https://data360files.worldbank.org/data360-data/metadata/WB_MPO/WB_MPO_NYGDPMKTPCNZ.json
#> 24  https://data360files.worldbank.org/data360-data/metadata/WB_MPO/WB_MPO_NEGDIFTOTKN_.json
#> 25          https://data360files.worldbank.org/data360-data/metadata/WB_MPO/WB_MPO_POV1.json
#> 26               https://data360files.worldbank.org/data360-data/datasetmetadata/WB_MPO.json
#> 27  https://data360files.worldbank.org/data360-data/metadata/WB_MPO/WB_MPO_BNCABFUNDCD_.json
#> 28   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/WB_MPO_GGEXPTOTLCD.json
#> 29  https://data360files.worldbank.org/data360-data/metadata/WB_MPO/WB_MPO_NEEXPGNFSKNZ.json
#> 30   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/WB_MPO_GGDBTTOTLCD.json
#> 31  https://data360files.worldbank.org/data360-data/metadata/WB_MPO/WB_MPO_NVAGRTOTLCNZ.json
#> 32   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/WB_MPO_NECONGOVTCN.json
#> 33  https://data360files.worldbank.org/data360-data/metadata/WB_MPO/WB_MPO_NEGDIFTOTKDZ.json
#> 34   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/WB_MPO_BFCAFTOTLCD.json
#> 35   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/WB_MPO_GGBALPRIMCN.json
#> 36   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/WB_MPO_GGREVTOTLCD.json
#> 37   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/WB_MPO_BFCAFFFDICD.json
#> 38   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/WB_MPO_NEIMPGNFSCN.json
#> 39   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/WB_MPO_NECONGOVTKD.json
#> 40  https://data360files.worldbank.org/data360-data/metadata/WB_MPO/WB_MPO_NECONPRVTKNZ.json
#> 41  https://data360files.worldbank.org/data360-data/metadata/WB_MPO/WB_MPO_NEGDIFTOTCNZ.json
#> 42  https://data360files.worldbank.org/data360-data/metadata/WB_MPO/WB_MPO_GGBALOVRLCD_.json
#> 43  https://data360files.worldbank.org/data360-data/metadata/WB_MPO/WB_MPO_GGBALPRIMCD_.json
#> 44     https://data360files.worldbank.org/data360-data/metadata/WB_MPO/WB_MPO_SPPOPTOTL.json
#> 45   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/WB_MPO_ENENRGHGEKT.json
#> 46  https://data360files.worldbank.org/data360-data/metadata/WB_MPO/WB_MPO_NEIMPGNFSKNZ.json
#> 47  https://data360files.worldbank.org/data360-data/metadata/WB_MPO/WB_MPO_NEGDIFTOTKNZ.json
#> 48   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/WB_MPO_NVAGRTOTLKN.json
#> 49  https://data360files.worldbank.org/data360-data/metadata/WB_MPO/WB_MPO_NVINDTOTLKDZ.json
#> 50   https://data360files.worldbank.org/data360-data/metadata/WB_MPO/WB_MPO_NVSRVTOTLKN.json
#>                                                                                        series_description.api_link
#> 1    https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_GGBALPRIMCD
#> 2  https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_NECONPRVTPCKN
#> 3    https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_NYGDPMKTPCD
#> 4    https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_GGEXPINTPCN
#> 5   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_NEEXPGNFSCNZ
#> 6    https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_GGBALOVRLCN
#> 7    https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_GGBALOVRLCD
#> 8   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_NEEXPGNFSKDZ
#> 9   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_NEIMPGNFSKDZ
#> 10   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_NYGDPMKTPCN
#> 11  https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_NYGDPMKTPKNZ
#> 12          https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_POV2
#> 13          https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_POV3
#> 14   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_FPCPITOTLXN
#> 15   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_NEIMPGNFSKD
#> 16   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_NYGDPMKTPKD
#> 17  https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_NECONGOVTCNZ
#> 18  https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_FPCPITOTLXNZ
#> 19   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_NEEXPGNFSCN
#> 20   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_NEEXPGNFSKN
#> 21   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_BNCABFUNDCD
#> 22   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_NVAGRTOTLKD
#> 23  https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_NYGDPMKTPCNZ
#> 24  https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_NEGDIFTOTKN_
#> 25          https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_POV1
#> 26                                https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO
#> 27  https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_BNCABFUNDCD_
#> 28   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_GGEXPTOTLCD
#> 29  https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_NEEXPGNFSKNZ
#> 30   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_GGDBTTOTLCD
#> 31  https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_NVAGRTOTLCNZ
#> 32   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_NECONGOVTCN
#> 33  https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_NEGDIFTOTKDZ
#> 34   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_BFCAFTOTLCD
#> 35   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_GGBALPRIMCN
#> 36   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_GGREVTOTLCD
#> 37   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_BFCAFFFDICD
#> 38   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_NEIMPGNFSCN
#> 39   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_NECONGOVTKD
#> 40  https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_NECONPRVTKNZ
#> 41  https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_NEGDIFTOTCNZ
#> 42  https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_GGBALOVRLCD_
#> 43  https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_GGBALPRIMCD_
#> 44     https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_SPPOPTOTL
#> 45   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_ENENRGHGEKT
#> 46  https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_NEIMPGNFSKNZ
#> 47  https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_NEGDIFTOTKNZ
#> 48   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_NVAGRTOTLKN
#> 49  https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_NVINDTOTLKDZ
#> 50   https://data360api.worldbank.org/data360/data?top=1000&skip=0&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_NVSRVTOTLKN
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
#> 26                                103                                 NA
#> 27                                 NA                                 NA
#> 28                                 NA                                 NA
#> 29                                 NA                                 NA
#> 30                                 NA                                 NA
#> 31                                 NA                                 NA
#> 32                                 NA                                 NA
#> 33                                 NA                                 NA
#> 34                                 NA                                 NA
#> 35                                 NA                                 NA
#> 36                                 NA                                 NA
#> 37                                 NA                                 NA
#> 38                                 NA                                 NA
#> 39                                 NA                                 NA
#> 40                                 NA                                 NA
#> 41                                 NA                                 NA
#> 42                                 NA                                 NA
#> 43                                 NA                                 NA
#> 44                                 NA                                 NA
#> 45                                 NA                                 NA
#> 46                                 NA                                 NA
#> 47                                 NA                                 NA
#> 48                                 NA                                 NA
#> 49                                 NA                                 NA
#> 50                                 NA                                 NA
#>                                                                                    series_description.api_explorer_link
#> 1    http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_GGBALPRIMCD
#> 2  http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_NECONPRVTPCKN
#> 3    http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_NYGDPMKTPCD
#> 4    http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_GGEXPINTPCN
#> 5   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_NEEXPGNFSCNZ
#> 6    http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_GGBALOVRLCN
#> 7    http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_GGBALOVRLCD
#> 8   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_NEEXPGNFSKDZ
#> 9   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_NEIMPGNFSKDZ
#> 10   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_NYGDPMKTPCN
#> 11  http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_NYGDPMKTPKNZ
#> 12          http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_POV2
#> 13          http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_POV3
#> 14   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_FPCPITOTLXN
#> 15   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_NEIMPGNFSKD
#> 16   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_NYGDPMKTPKD
#> 17  http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_NECONGOVTCNZ
#> 18  http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_FPCPITOTLXNZ
#> 19   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_NEEXPGNFSCN
#> 20   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_NEEXPGNFSKN
#> 21   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_BNCABFUNDCD
#> 22   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_NVAGRTOTLKD
#> 23  http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_NYGDPMKTPCNZ
#> 24  http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_NEGDIFTOTKN_
#> 25          http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_POV1
#> 26                                http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO
#> 27  http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_BNCABFUNDCD_
#> 28   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_GGEXPTOTLCD
#> 29  http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_NEEXPGNFSKNZ
#> 30   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_GGDBTTOTLCD
#> 31  http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_NVAGRTOTLCNZ
#> 32   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_NECONGOVTCN
#> 33  http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_NEGDIFTOTKDZ
#> 34   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_BFCAFTOTLCD
#> 35   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_GGBALPRIMCN
#> 36   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_GGREVTOTLCD
#> 37   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_BFCAFFFDICD
#> 38   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_NEIMPGNFSCN
#> 39   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_NECONGOVTKD
#> 40  http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_NECONPRVTKNZ
#> 41  http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_NEGDIFTOTCNZ
#> 42  http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_GGBALOVRLCD_
#> 43  http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_GGBALPRIMCD_
#> 44     http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_SPPOPTOTL
#> 45   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_ENENRGHGEKT
#> 46  http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_NEIMPGNFSKNZ
#> 47  http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_NEGDIFTOTKNZ
#> 48   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_NVAGRTOTLKN
#> 49  http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_NVINDTOTLKDZ
#> 50   http://datacatalog.worldbank.org/data360/api/execute?tab=Data&id=1&DATABASE_ID=WB_MPO&INDICATOR=WB_MPO_NVSRVTOTLKN
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
#> 35                                NULL
#> 36                                NULL
#> 37                                NULL
#> 38                                NULL
#> 39                                NULL
#> 40                                NULL
#> 41                                NULL
#> 42                                NULL
#> 43                                NULL
#> 44                                NULL
#> 45                                NULL
#> 46                                NULL
#> 47                                NULL
#> 48                                NULL
#> 49                                NULL
#> 50                                NULL
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
#> 35                                           NA
#> 36                                           NA
#> 37                                           NA
#> 38                                           NA
#> 39                                           NA
#> 40                                           NA
#> 41                                           NA
#> 42                                           NA
#> 43                                           NA
#> 44                                           NA
#> 45                                           NA
#> 46                                           NA
#> 47                                           NA
#> 48                                           NA
#> 49                                           NA
#> 50                                           NA
#>    series_description.version_statement.version_date
#> 1                                         2025-10-10
#> 2                                         2025-10-10
#> 3                                         2025-10-10
#> 4                                         2025-10-10
#> 5                                         2025-10-10
#> 6                                         2025-10-10
#> 7                                         2025-10-10
#> 8                                         2025-10-10
#> 9                                         2025-10-10
#> 10                                        2025-10-10
#> 11                                        2025-10-10
#> 12                                        2025-10-10
#> 13                                        2025-10-10
#> 14                                        2025-10-10
#> 15                                        2025-10-10
#> 16                                        2025-10-10
#> 17                                        2025-10-10
#> 18                                        2025-10-10
#> 19                                        2025-10-10
#> 20                                        2025-10-10
#> 21                                        2025-10-10
#> 22                                        2025-10-10
#> 23                                        2025-10-10
#> 24                                        2025-10-10
#> 25                                        2025-10-10
#> 26                                              <NA>
#> 27                                        2025-10-10
#> 28                                        2025-10-10
#> 29                                        2025-10-10
#> 30                                        2025-10-10
#> 31                                        2025-10-10
#> 32                                        2025-10-10
#> 33                                        2025-10-10
#> 34                                        2025-10-10
#> 35                                        2025-10-10
#> 36                                        2025-10-10
#> 37                                        2025-10-10
#> 38                                        2025-10-10
#> 39                                        2025-10-10
#> 40                                        2025-10-10
#> 41                                        2025-10-10
#> 42                                        2025-10-10
#> 43                                        2025-10-10
#> 44                                        2025-10-10
#> 45                                        2025-10-10
#> 46                                        2025-10-10
#> 47                                        2025-10-10
#> 48                                        2025-10-10
#> 49                                        2025-10-10
#> 50                                        2025-10-10
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
#> 35                                                NA
#> 36                                                NA
#> 37                                                NA
#> 38                                                NA
#> 39                                                NA
#> 40                                                NA
#> 41                                                NA
#> 42                                                NA
#> 43                                                NA
#> 44                                                NA
#> 45                                                NA
#> 46                                                NA
#> 47                                                NA
#> 48                                                NA
#> 49                                                NA
#> 50                                                NA
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
#> 35                                                 NA
#> 36                                                 NA
#> 37                                                 NA
#> 38                                                 NA
#> 39                                                 NA
#> 40                                                 NA
#> 41                                                 NA
#> 42                                                 NA
#> 43                                                 NA
#> 44                                                 NA
#> 45                                                 NA
#> 46                                                 NA
#> 47                                                 NA
#> 48                                                 NA
#> 49                                                 NA
#> 50                                                 NA
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
#> 35                       NULL
#> 36                       NULL
#> 37                       NULL
#> 38                       NULL
#> 39                       NULL
#> 40                       NULL
#> 41                       NULL
#> 42                       NULL
#> 43                       NULL
#> 44                       NULL
#> 45                       NULL
#> 46                       NULL
#> 47                       NULL
#> 48                       NULL
#> 49                       NULL
#> 50                       NULL
#>                                                                           series_description.alternate_identifiers
#> 1    EFIDATA360_IND_ID, WB.MPO.GGBALPRIMCD, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 2  EFIDATA360_IND_ID, WB.MPO.NECONPRVTPCKN, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 3    EFIDATA360_IND_ID, WB.MPO.NYGDPMKTPCD, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 4    EFIDATA360_IND_ID, WB.MPO.GGEXPINTPCN, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 5   EFIDATA360_IND_ID, WB.MPO.NEEXPGNFSCNZ, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 6    EFIDATA360_IND_ID, WB.MPO.GGBALOVRLCN, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 7    EFIDATA360_IND_ID, WB.MPO.GGBALOVRLCD, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 8   EFIDATA360_IND_ID, WB.MPO.NEEXPGNFSKDZ, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 9   EFIDATA360_IND_ID, WB.MPO.NEIMPGNFSKDZ, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 10   EFIDATA360_IND_ID, WB.MPO.NYGDPMKTPCN, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 11  EFIDATA360_IND_ID, WB.MPO.NYGDPMKTPKNZ, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 12          EFIDATA360_IND_ID, WB.MPO.POV2, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 13          EFIDATA360_IND_ID, WB.MPO.POV3, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 14   EFIDATA360_IND_ID, WB.MPO.FPCPITOTLXN, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 15   EFIDATA360_IND_ID, WB.MPO.NEIMPGNFSKD, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 16   EFIDATA360_IND_ID, WB.MPO.NYGDPMKTPKD, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 17  EFIDATA360_IND_ID, WB.MPO.NECONGOVTCNZ, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 18  EFIDATA360_IND_ID, WB.MPO.FPCPITOTLXNZ, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 19   EFIDATA360_IND_ID, WB.MPO.NEEXPGNFSCN, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 20   EFIDATA360_IND_ID, WB.MPO.NEEXPGNFSKN, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 21   EFIDATA360_IND_ID, WB.MPO.BNCABFUNDCD, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 22   EFIDATA360_IND_ID, WB.MPO.NVAGRTOTLKD, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 23  EFIDATA360_IND_ID, WB.MPO.NYGDPMKTPCNZ, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 24  EFIDATA360_IND_ID, WB.MPO.NEGDIFTOTKN_, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 25          EFIDATA360_IND_ID, WB.MPO.POV1, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 26                                                                                                            NULL
#> 27  EFIDATA360_IND_ID, WB.MPO.BNCABFUNDCD_, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 28   EFIDATA360_IND_ID, WB.MPO.GGEXPTOTLCD, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 29  EFIDATA360_IND_ID, WB.MPO.NEEXPGNFSKNZ, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 30   EFIDATA360_IND_ID, WB.MPO.GGDBTTOTLCD, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 31  EFIDATA360_IND_ID, WB.MPO.NVAGRTOTLCNZ, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 32   EFIDATA360_IND_ID, WB.MPO.NECONGOVTCN, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 33  EFIDATA360_IND_ID, WB.MPO.NEGDIFTOTKDZ, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 34   EFIDATA360_IND_ID, WB.MPO.BFCAFTOTLCD, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 35   EFIDATA360_IND_ID, WB.MPO.GGBALPRIMCN, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 36   EFIDATA360_IND_ID, WB.MPO.GGREVTOTLCD, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 37   EFIDATA360_IND_ID, WB.MPO.BFCAFFFDICD, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 38   EFIDATA360_IND_ID, WB.MPO.NEIMPGNFSCN, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 39   EFIDATA360_IND_ID, WB.MPO.NECONGOVTKD, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 40  EFIDATA360_IND_ID, WB.MPO.NECONPRVTKNZ, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 41  EFIDATA360_IND_ID, WB.MPO.NEGDIFTOTCNZ, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 42  EFIDATA360_IND_ID, WB.MPO.GGBALOVRLCD_, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 43  EFIDATA360_IND_ID, WB.MPO.GGBALPRIMCD_, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 44     EFIDATA360_IND_ID, WB.MPO.SPPOPTOTL, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 45   EFIDATA360_IND_ID, WB.MPO.ENENRGHGEKT, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 46  EFIDATA360_IND_ID, WB.MPO.NEIMPGNFSKNZ, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 47  EFIDATA360_IND_ID, WB.MPO.NEGDIFTOTKNZ, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 48   EFIDATA360_IND_ID, WB.MPO.NVAGRTOTLKN, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 49  EFIDATA360_IND_ID, WB.MPO.NVINDTOTLKDZ, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
#> 50   EFIDATA360_IND_ID, WB.MPO.NVSRVTOTLKN, ProsperityData360, https://prosperitydata360.worldbank.org/en/home, NA
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
#> 26                         NULL
#> 27                  English, EN
#> 28                  English, EN
#> 29                  English, EN
#> 30                  English, EN
#> 31                  English, EN
#> 32                  English, EN
#> 33                  English, EN
#> 34                  English, EN
#> 35                  English, EN
#> 36                  English, EN
#> 37                  English, EN
#> 38                  English, EN
#> 39                  English, EN
#> 40                  English, EN
#> 41                  English, EN
#> 42                  English, EN
#> 43                  English, EN
#> 44                  English, EN
#> 45                  English, EN
#> 46                  English, EN
#> 47                  English, EN
#> 48                  English, EN
#> 49                  English, EN
#> 50                  English, EN
#>                                    series_description.dimensions
#> 1  NA, NA, Geographic area, Vintage, Country/economy, Region, NA
#> 2  NA, NA, Geographic area, Vintage, Country/economy, Region, NA
#> 3  NA, NA, Geographic area, Vintage, Country/economy, Region, NA
#> 4  NA, NA, Geographic area, Vintage, Country/economy, Region, NA
#> 5  NA, NA, Geographic area, Vintage, Country/economy, Region, NA
#> 6  NA, NA, Geographic area, Vintage, Country/economy, Region, NA
#> 7  NA, NA, Geographic area, Vintage, Country/economy, Region, NA
#> 8  NA, NA, Geographic area, Vintage, Country/economy, Region, NA
#> 9  NA, NA, Geographic area, Vintage, Country/economy, Region, NA
#> 10 NA, NA, Geographic area, Vintage, Country/economy, Region, NA
#> 11 NA, NA, Geographic area, Vintage, Country/economy, Region, NA
#> 12 NA, NA, Geographic area, Vintage, Country/economy, Region, NA
#> 13 NA, NA, Geographic area, Vintage, Country/economy, Region, NA
#> 14 NA, NA, Geographic area, Vintage, Country/economy, Region, NA
#> 15 NA, NA, Geographic area, Vintage, Country/economy, Region, NA
#> 16 NA, NA, Geographic area, Vintage, Country/economy, Region, NA
#> 17 NA, NA, Geographic area, Vintage, Country/economy, Region, NA
#> 18 NA, NA, Geographic area, Vintage, Country/economy, Region, NA
#> 19 NA, NA, Geographic area, Vintage, Country/economy, Region, NA
#> 20 NA, NA, Geographic area, Vintage, Country/economy, Region, NA
#> 21 NA, NA, Geographic area, Vintage, Country/economy, Region, NA
#> 22 NA, NA, Geographic area, Vintage, Country/economy, Region, NA
#> 23 NA, NA, Geographic area, Vintage, Country/economy, Region, NA
#> 24 NA, NA, Geographic area, Vintage, Country/economy, Region, NA
#> 25 NA, NA, Geographic area, Vintage, Country/economy, Region, NA
#> 26                                                          NULL
#> 27 NA, NA, Geographic area, Vintage, Country/economy, Region, NA
#> 28 NA, NA, Geographic area, Vintage, Country/economy, Region, NA
#> 29 NA, NA, Geographic area, Vintage, Country/economy, Region, NA
#> 30 NA, NA, Geographic area, Vintage, Country/economy, Region, NA
#> 31 NA, NA, Geographic area, Vintage, Country/economy, Region, NA
#> 32 NA, NA, Geographic area, Vintage, Country/economy, Region, NA
#> 33 NA, NA, Geographic area, Vintage, Country/economy, Region, NA
#> 34 NA, NA, Geographic area, Vintage, Country/economy, Region, NA
#> 35 NA, NA, Geographic area, Vintage, Country/economy, Region, NA
#> 36 NA, NA, Geographic area, Vintage, Country/economy, Region, NA
#> 37 NA, NA, Geographic area, Vintage, Country/economy, Region, NA
#> 38 NA, NA, Geographic area, Vintage, Country/economy, Region, NA
#> 39 NA, NA, Geographic area, Vintage, Country/economy, Region, NA
#> 40 NA, NA, Geographic area, Vintage, Country/economy, Region, NA
#> 41 NA, NA, Geographic area, Vintage, Country/economy, Region, NA
#> 42 NA, NA, Geographic area, Vintage, Country/economy, Region, NA
#> 43 NA, NA, Geographic area, Vintage, Country/economy, Region, NA
#> 44 NA, NA, Geographic area, Vintage, Country/economy, Region, NA
#> 45 NA, NA, Geographic area, Vintage, Country/economy, Region, NA
#> 46 NA, NA, Geographic area, Vintage, Country/economy, Region, NA
#> 47 NA, NA, Geographic area, Vintage, Country/economy, Region, NA
#> 48 NA, NA, Geographic area, Vintage, Country/economy, Region, NA
#> 49 NA, NA, Geographic area, Vintage, Country/economy, Region, NA
#> 50 NA, NA, Geographic area, Vintage, Country/economy, Region, NA
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
#> 35                                     NULL
#> 36                                     NULL
#> 37                                     NULL
#> 38                                     NULL
#> 39                                     NULL
#> 40                                     NULL
#> 41                                     NULL
#> 42                                     NULL
#> 43                                     NULL
#> 44                                     NULL
#> 45                                     NULL
#> 46                                     NULL
#> 47                                     NULL
#> 48                                     NULL
#> 49                                     NULL
#> 50                                     NULL
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
#> 35                                              NULL
#> 36                                              NULL
#> 37                                              NULL
#> 38                                              NULL
#> 39                                              NULL
#> 40                                              NULL
#> 41                                              NULL
#> 42                                              NULL
#> 43                                              NULL
#> 44                                              NULL
#> 45                                              NULL
#> 46                                              NULL
#> 47                                              NULL
#> 48                                              NULL
#> 49                                              NULL
#> 50                                              NULL
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
#> 26                                                                                      NULL
#> 27 Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 28 Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 29 Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 30 Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 31 Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 32 Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 33 Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 34 Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 35 Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 36 Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 37 Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 38 Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 39 Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 40 Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 41 Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 42 Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 43 Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 44 Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 45 Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 46 Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 47 Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 48 Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 49 Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 50 Macro Poverty Outlook, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
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
#> 35                                     NULL
#> 36                                     NULL
#> 37                                     NULL
#> 38                                     NULL
#> 39                                     NULL
#> 40                                     NULL
#> 41                                     NULL
#> 42                                     NULL
#> 43                                     NULL
#> 44                                     NULL
#> 45                                     NULL
#> 46                                     NULL
#> 47                                     NULL
#> 48                                     NULL
#> 49                                     NULL
#> 50                                     NULL
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
#> 35                                     NULL
#> 36                                     NULL
#> 37                                     NULL
#> 38                                     NULL
#> 39                                     NULL
#> 40                                     NULL
#> 41                                     NULL
#> 42                                     NULL
#> 43                                     NULL
#> 44                                     NULL
#> 45                                     NULL
#> 46                                     NULL
#> 47                                     NULL
#> 48                                     NULL
#> 49                                     NULL
#> 50                                     NULL
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    series_description.topics
#> 1                                                                                                                                                                                                                                                                                                                                                                                P3, P3_000001, P3_000008, Prosperity, Economic Policy, Fiscal Policy, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 2                                                                                                                                                                                                                                                                                                                                                                              P3, P3_000001, P3_000007, Prosperity, Economic Policy, Growth and Jobs, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 3                                                                                                                                                                                                                                                                                                                                                                              P3, P3_000001, P3_000007, Prosperity, Economic Policy, Growth and Jobs, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 4                                                                                                                                                                                                                                                                                                                                                                                P3, P3_000001, P3_000008, Prosperity, Economic Policy, Fiscal Policy, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 5                                                                                                                                                                                                                                                                                                                                                         P3, P3_000006, P3_000028, Prosperity, Trade, Investment and Competitiveness, Trade Outcomes, NA, P3, P3_000006, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 6                                                                                                                                                                                                                                                                                                                                                                                P3, P3_000001, P3_000008, Prosperity, Economic Policy, Fiscal Policy, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 7                                                                                                                                                                                                                                                                                                                                                                                P3, P3_000001, P3_000008, Prosperity, Economic Policy, Fiscal Policy, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 8                                                                                                                                                                                                                                                                                                                                                         P3, P3_000006, P3_000028, Prosperity, Trade, Investment and Competitiveness, Trade Outcomes, NA, P3, P3_000006, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 9                                                                                                                                                                                                                                                                                                                                                         P3, P3_000006, P3_000028, Prosperity, Trade, Investment and Competitiveness, Trade Outcomes, NA, P3, P3_000006, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 10                                                                                                                                                                                                                                                                                                                                                                             P3, P3_000001, P3_000007, Prosperity, Economic Policy, Growth and Jobs, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 11                                                                                                                                                                                                                                                                                                                                                                             P3, P3_000001, P3_000007, Prosperity, Economic Policy, Growth and Jobs, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 12                                                                                                                                                                                                                                                                                                                                                                                             P3, P3_000004, P3_000020, Prosperity, Poverty, Poverty, NA, P3, P3_000004, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 13                                                                                                                                                                                                                                                                                                                                                                                             P3, P3_000004, P3_000020, Prosperity, Poverty, Poverty, NA, P3, P3_000004, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 14                                                                                                                                                                                                                                                                                                                                                                    P3, P3_000001, P3_000009, Prosperity, Economic Policy, Macro-financial Policies, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 15                                                                                                                                                                                                                                                                                                                                                        P3, P3_000006, P3_000028, Prosperity, Trade, Investment and Competitiveness, Trade Outcomes, NA, P3, P3_000006, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 16                                                                                                                                                                                                                                                                                                                                                                             P3, P3_000001, P3_000007, Prosperity, Economic Policy, Growth and Jobs, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 17                                                                                                                                                                                                                                                                                                                                                                               P3, P3_000001, P3_000008, Prosperity, Economic Policy, Fiscal Policy, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 18                                                                                                                                                                                                                                                                                                                                                                    P3, P3_000001, P3_000009, Prosperity, Economic Policy, Macro-financial Policies, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 19                                                                                                                                                                                                                                                                                                                                                        P3, P3_000006, P3_000028, Prosperity, Trade, Investment and Competitiveness, Trade Outcomes, NA, P3, P3_000006, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 20                                                                                                                                                                                                                                                                                                                                                        P3, P3_000006, P3_000028, Prosperity, Trade, Investment and Competitiveness, Trade Outcomes, NA, P3, P3_000006, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 21                                                                                                                                                                                                                                                                                                                                                                    P3, P3_000001, P3_000009, Prosperity, Economic Policy, Macro-financial Policies, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 22                                                                                                                                                                                                                                                                                                                                                                             P3, P3_000001, P3_000007, Prosperity, Economic Policy, Growth and Jobs, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 23                                                                                                                                                                                                                                                                                                                                                                             P3, P3_000001, P3_000007, Prosperity, Economic Policy, Growth and Jobs, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 24                                                                                                                                                                                                                                                                                                                                                                               P3, P3_000001, P3_000008, Prosperity, Economic Policy, Fiscal Policy, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 25                                                                                                                                        P3, P3_000004, P3_000020, P4, P4_000034, P4_000040, GAFS_0008, Prosperity, Poverty, Poverty, Infrastructure, Urban, Resilience and Land, Housing, Trends in the Determinants of Food Security Outcomes, NA, P3, P3_000004, NA, P4, P4_000034, NA, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, GAFS, NA, NA, NA, NA, NA, NA, NA
#> 26 P3, P3_000001, P3_000006, P3_000004, P3_000007, P3_000008, P3_000009, P3_000020, P3_000028, Prosperity, Economic Policy, Trade, Investment and Competitiveness, Poverty, Growth and Jobs, Fiscal Policy, Macro-financial Policies, Poverty, Trade Outcomes, NA, P3, P3, P3, P3_000001, P3_000001, P3_000001, P3_000004, P3_000006, WB Practice Groups, Data360 Topic L1, Data360 Topic L1, Data360 Topic L1, Data360 Topic L2, Data360 Topic L2, Data360 Topic L2, Data360 Topic L2, Data360 Topic L2, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> 27                                                                                                                                                                                                                                                                                                                                                                    P3, P3_000001, P3_000009, Prosperity, Economic Policy, Macro-financial Policies, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 28                                                                                                                                                                                                                                                                                                                                                                               P3, P3_000001, P3_000008, Prosperity, Economic Policy, Fiscal Policy, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 29                                                                                                                                                                                                                                                                                                                                                        P3, P3_000006, P3_000028, Prosperity, Trade, Investment and Competitiveness, Trade Outcomes, NA, P3, P3_000006, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 30                                                                                                                                                                                                                                                                                                                                                                               P3, P3_000001, P3_000008, Prosperity, Economic Policy, Fiscal Policy, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 31                                                                                                                                                                                                                                                                                                                                                                             P3, P3_000001, P3_000007, Prosperity, Economic Policy, Growth and Jobs, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 32                                                                                                                                                                                                                                                                                                                                                                               P3, P3_000001, P3_000008, Prosperity, Economic Policy, Fiscal Policy, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 33                                                                                                                                                                                                                                                                                                                                                                               P3, P3_000001, P3_000008, Prosperity, Economic Policy, Fiscal Policy, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 34                                                                                                                                                                                                                                                                                                                                                                    P3, P3_000001, P3_000009, Prosperity, Economic Policy, Macro-financial Policies, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 35                                                                                                                                                                                                                                                                                                                                                                               P3, P3_000001, P3_000008, Prosperity, Economic Policy, Fiscal Policy, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 36                                                                                                                                                                                                                                                                                                                                                                               P3, P3_000001, P3_000008, Prosperity, Economic Policy, Fiscal Policy, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 37                                                                                                                                                                                                                                                                                                                                                                    P3, P3_000001, P3_000009, Prosperity, Economic Policy, Macro-financial Policies, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 38                                                                                                                                                                                                                                                                                                                                                        P3, P3_000006, P3_000028, Prosperity, Trade, Investment and Competitiveness, Trade Outcomes, NA, P3, P3_000006, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 39                                                                                                                                                                                                                                                                                                                                                                               P3, P3_000001, P3_000008, Prosperity, Economic Policy, Fiscal Policy, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 40                                                                                                                                                                                                                                                                                                                                                                             P3, P3_000001, P3_000007, Prosperity, Economic Policy, Growth and Jobs, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 41                                                                                                                                                                                                                                                                                                                                                                               P3, P3_000001, P3_000008, Prosperity, Economic Policy, Fiscal Policy, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 42                                                                                                                                                                                                                                                                                                                                                                               P3, P3_000001, P3_000008, Prosperity, Economic Policy, Fiscal Policy, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 43                                                                                                                                                                                                                                                                                                                                                                               P3, P3_000001, P3_000008, Prosperity, Economic Policy, Fiscal Policy, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 44                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                P3, Prosperity, NA, WB Practice Groups, NA
#> 45                                                                                                                                                                                                                                                                                                                                                                             P3, P3_000001, P3_000007, Prosperity, Economic Policy, Growth and Jobs, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 46                                                                                                                                                                                                                                                                                                                                                        P3, P3_000006, P3_000028, Prosperity, Trade, Investment and Competitiveness, Trade Outcomes, NA, P3, P3_000006, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 47                                                                                                                                                                                                                                                                                                                                                                               P3, P3_000001, P3_000008, Prosperity, Economic Policy, Fiscal Policy, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 48                                                                                                                                                                                                                                                                                                                                                                             P3, P3_000001, P3_000007, Prosperity, Economic Policy, Growth and Jobs, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 49                                                                                                                                                                                                                                                                                                                                                                             P3, P3_000001, P3_000007, Prosperity, Economic Policy, Growth and Jobs, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#> 50                                                                                                                                                                                                                                                                                                                                                                             P3, P3_000001, P3_000007, Prosperity, Economic Policy, Growth and Jobs, NA, P3, P3_000001, WB Practice Groups, Data360 Topic L1, Data360 Topic L2, NA, NA, NA
#>    series_description.time_periods
#> 1                   1980, 2027, NA
#> 2                   1980, 2027, NA
#> 3                   1980, 2027, NA
#> 4                   1980, 2027, NA
#> 5                   1980, 2027, NA
#> 6                   1980, 2027, NA
#> 7                   1980, 2027, NA
#> 8                   1980, 2027, NA
#> 9                   1980, 2027, NA
#> 10                  1980, 2027, NA
#> 11                  1980, 2027, NA
#> 12                  1980, 2027, NA
#> 13                  1980, 2027, NA
#> 14                  1980, 2027, NA
#> 15                  1980, 2027, NA
#> 16                  1980, 2027, NA
#> 17                  1980, 2027, NA
#> 18                  1980, 2027, NA
#> 19                  1980, 2027, NA
#> 20                  1980, 2027, NA
#> 21                  1980, 2027, NA
#> 22                  1980, 2027, NA
#> 23                  1980, 2027, NA
#> 24                  1980, 2027, NA
#> 25                  1980, 2027, NA
#> 26                  1980, 2027, NA
#> 27                  1980, 2027, NA
#> 28                  1980, 2027, NA
#> 29                  1980, 2027, NA
#> 30                  1980, 2027, NA
#> 31                  1980, 2027, NA
#> 32                  1980, 2027, NA
#> 33                  1980, 2027, NA
#> 34                  1980, 2027, NA
#> 35                  1980, 2027, NA
#> 36                  1980, 2027, NA
#> 37                  1980, 2027, NA
#> 38                  1980, 2027, NA
#> 39                  1980, 2027, NA
#> 40                  1980, 2027, NA
#> 41                  1980, 2027, NA
#> 42                  1980, 2027, NA
#> 43                  1980, 2027, NA
#> 44                  1980, 2027, NA
#> 45                  1980, 2027, NA
#> 46                  1980, 2027, NA
#> 47                  1980, 2027, NA
#> 48                  1980, 2027, NA
#> 49                  1980, 2027, NA
#> 50                  1980, 2027, NA
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         series_description.ref_country
#> 1  Afghanistan, Angola, Albania, United Arab Emirates, Argentina, Armenia, Azerbaijan, Burundi, Benin, Burkina Faso, Bangladesh, Bulgaria, Bahrain, Bahamas, The, Bosnia and Herzegovina, Belarus, Belize, Bolivia, Brazil, Barbados, Bhutan, Botswana, Central African Republic, Chile, China, Cote d'Ivoire, Cameroon, Congo, Dem. Rep., Congo, Rep., Colombia, Comoros, Cabo Verde, Costa Rica, Djibouti, Dominica, Dominican Republic, Algeria, Ecuador, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Micronesia, Fed. Sts., Gabon, Georgia, Ghana, Guinea, Gambia, The, Guinea-Bissau, Equatorial Guinea, Grenada, Guatemala, Guyana, Honduras, Croatia, Haiti, Indonesia, India, Iran, Islamic Rep., Iraq, Jamaica, Jordan, Kazakhstan, Kenya, Kyrgyz Republic, Cambodia, Kiribati, Kuwait, Lao PDR, Lebanon, Liberia, Libya, St. Lucia, Sri Lanka, Lesotho, Morocco, Moldova, Madagascar, Maldives, Mexico, Marshall Islands, North Macedonia, Mali, Myanmar, Montenegro, Mongolia, Mozambique, Mauritania, Mauritius, Malawi, Malaysia, Namibia, Niger, Nigeria, Nicaragua, Nepal, Nauru, Oman, Pakistan, Panama, Peru, Philippines, Palau, Papua New Guinea, Poland, Paraguay, West Bank and Gaza, Qatar, Romania, Russian Federation, Rwanda, Saudi Arabia, Sudan, Senegal, Solomon Islands, Sierra Leone, El Salvador, Somalia, Serbia, South Sudan, Sao Tome and Principe, Suriname, Eswatini, Seychelles, Syrian Arab Republic, Chad, Togo, Thailand, Tajikistan, Timor-Leste, Tonga, Trinidad and Tobago, Tunisia, Turkiye, Tuvalu, Tanzania, Uganda, Ukraine, Uruguay, Uzbekistan, St. Vincent and the Grenadines, Viet Nam, Vanuatu, Samoa, Kosovo, Yemen, Rep., South Africa, Zambia, Zimbabwe, AFG, AGO, ALB, ARE, ARG, ARM, AZE, BDI, BEN, BFA, BGD, BGR, BHR, BHS, BIH, BLR, BLZ, BOL, BRA, BRB, BTN, BWA, CAF, CHL, CHN, CIV, CMR, COD, COG, COL, COM, CPV, CRI, DJI, DMA, DOM, DZA, ECU, EGY, ERI, ETH, FJI, FSM, GAB, GEO, GHA, GIN, GMB, GNB, GNQ, GRD, GTM, GUY, HND, HRV, HTI, IDN, IND, IRN, IRQ, JAM, JOR, KAZ, KEN, KGZ, KHM, KIR, KWT, LAO, LBN, LBR, LBY, LCA, LKA, LSO, MAR, MDA, MDG, MDV, MEX, MHL, MKD, MLI, MMR, MNE, MNG, MOZ, MRT, MUS, MWI, MYS, NAM, NER, NGA, NIC, NPL, NRU, OMN, PAK, PAN, PER, PHL, PLW, PNG, POL, PRY, PSE, QAT, ROU, RUS, RWA, SAU, SDN, SEN, SLB, SLE, SLV, SOM, SRB, SSD, STP, SUR, SWZ, SYC, SYR, TCD, TGO, THA, TJK, TLS, TON, TTO, TUN, TUR, TUV, TZA, UGA, UKR, URY, UZB, VCT, VNM, VUT, WSM, XKX, YEM, ZAF, ZMB, ZWE
#> 2  Afghanistan, Angola, Albania, United Arab Emirates, Argentina, Armenia, Azerbaijan, Burundi, Benin, Burkina Faso, Bangladesh, Bulgaria, Bahrain, Bahamas, The, Bosnia and Herzegovina, Belarus, Belize, Bolivia, Brazil, Barbados, Bhutan, Botswana, Central African Republic, Chile, China, Cote d'Ivoire, Cameroon, Congo, Dem. Rep., Congo, Rep., Colombia, Comoros, Cabo Verde, Costa Rica, Djibouti, Dominica, Dominican Republic, Algeria, Ecuador, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Micronesia, Fed. Sts., Gabon, Georgia, Ghana, Guinea, Gambia, The, Guinea-Bissau, Equatorial Guinea, Grenada, Guatemala, Guyana, Honduras, Croatia, Haiti, Indonesia, India, Iran, Islamic Rep., Iraq, Jamaica, Jordan, Kazakhstan, Kenya, Kyrgyz Republic, Cambodia, Kiribati, Kuwait, Lao PDR, Lebanon, Liberia, Libya, St. Lucia, Sri Lanka, Lesotho, Morocco, Moldova, Madagascar, Maldives, Mexico, Marshall Islands, North Macedonia, Mali, Myanmar, Montenegro, Mongolia, Mozambique, Mauritania, Mauritius, Malawi, Malaysia, Namibia, Niger, Nigeria, Nicaragua, Nepal, Nauru, Oman, Pakistan, Panama, Peru, Philippines, Palau, Papua New Guinea, Poland, Paraguay, West Bank and Gaza, Qatar, Romania, Russian Federation, Rwanda, Saudi Arabia, Sudan, Senegal, Solomon Islands, Sierra Leone, El Salvador, Somalia, Serbia, South Sudan, Sao Tome and Principe, Suriname, Eswatini, Seychelles, Syrian Arab Republic, Chad, Togo, Thailand, Tajikistan, Timor-Leste, Tonga, Trinidad and Tobago, Tunisia, Turkiye, Tuvalu, Tanzania, Uganda, Ukraine, Uruguay, Uzbekistan, St. Vincent and the Grenadines, Viet Nam, Vanuatu, Samoa, Kosovo, Yemen, Rep., South Africa, Zambia, Zimbabwe, AFG, AGO, ALB, ARE, ARG, ARM, AZE, BDI, BEN, BFA, BGD, BGR, BHR, BHS, BIH, BLR, BLZ, BOL, BRA, BRB, BTN, BWA, CAF, CHL, CHN, CIV, CMR, COD, COG, COL, COM, CPV, CRI, DJI, DMA, DOM, DZA, ECU, EGY, ERI, ETH, FJI, FSM, GAB, GEO, GHA, GIN, GMB, GNB, GNQ, GRD, GTM, GUY, HND, HRV, HTI, IDN, IND, IRN, IRQ, JAM, JOR, KAZ, KEN, KGZ, KHM, KIR, KWT, LAO, LBN, LBR, LBY, LCA, LKA, LSO, MAR, MDA, MDG, MDV, MEX, MHL, MKD, MLI, MMR, MNE, MNG, MOZ, MRT, MUS, MWI, MYS, NAM, NER, NGA, NIC, NPL, NRU, OMN, PAK, PAN, PER, PHL, PLW, PNG, POL, PRY, PSE, QAT, ROU, RUS, RWA, SAU, SDN, SEN, SLB, SLE, SLV, SOM, SRB, SSD, STP, SUR, SWZ, SYC, SYR, TCD, TGO, THA, TJK, TLS, TON, TTO, TUN, TUR, TUV, TZA, UGA, UKR, URY, UZB, VCT, VNM, VUT, WSM, XKX, YEM, ZAF, ZMB, ZWE
#> 3  Afghanistan, Angola, Albania, United Arab Emirates, Argentina, Armenia, Azerbaijan, Burundi, Benin, Burkina Faso, Bangladesh, Bulgaria, Bahrain, Bahamas, The, Bosnia and Herzegovina, Belarus, Belize, Bolivia, Brazil, Barbados, Bhutan, Botswana, Central African Republic, Chile, China, Cote d'Ivoire, Cameroon, Congo, Dem. Rep., Congo, Rep., Colombia, Comoros, Cabo Verde, Costa Rica, Djibouti, Dominica, Dominican Republic, Algeria, Ecuador, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Micronesia, Fed. Sts., Gabon, Georgia, Ghana, Guinea, Gambia, The, Guinea-Bissau, Equatorial Guinea, Grenada, Guatemala, Guyana, Honduras, Croatia, Haiti, Indonesia, India, Iran, Islamic Rep., Iraq, Jamaica, Jordan, Kazakhstan, Kenya, Kyrgyz Republic, Cambodia, Kiribati, Kuwait, Lao PDR, Lebanon, Liberia, Libya, St. Lucia, Sri Lanka, Lesotho, Morocco, Moldova, Madagascar, Maldives, Mexico, Marshall Islands, North Macedonia, Mali, Myanmar, Montenegro, Mongolia, Mozambique, Mauritania, Mauritius, Malawi, Malaysia, Namibia, Niger, Nigeria, Nicaragua, Nepal, Nauru, Oman, Pakistan, Panama, Peru, Philippines, Palau, Papua New Guinea, Poland, Paraguay, West Bank and Gaza, Qatar, Romania, Russian Federation, Rwanda, Saudi Arabia, Sudan, Senegal, Solomon Islands, Sierra Leone, El Salvador, Somalia, Serbia, South Sudan, Sao Tome and Principe, Suriname, Eswatini, Seychelles, Syrian Arab Republic, Chad, Togo, Thailand, Tajikistan, Timor-Leste, Tonga, Trinidad and Tobago, Tunisia, Turkiye, Tuvalu, Tanzania, Uganda, Ukraine, Uruguay, Uzbekistan, St. Vincent and the Grenadines, Viet Nam, Vanuatu, Samoa, Kosovo, Yemen, Rep., South Africa, Zambia, Zimbabwe, AFG, AGO, ALB, ARE, ARG, ARM, AZE, BDI, BEN, BFA, BGD, BGR, BHR, BHS, BIH, BLR, BLZ, BOL, BRA, BRB, BTN, BWA, CAF, CHL, CHN, CIV, CMR, COD, COG, COL, COM, CPV, CRI, DJI, DMA, DOM, DZA, ECU, EGY, ERI, ETH, FJI, FSM, GAB, GEO, GHA, GIN, GMB, GNB, GNQ, GRD, GTM, GUY, HND, HRV, HTI, IDN, IND, IRN, IRQ, JAM, JOR, KAZ, KEN, KGZ, KHM, KIR, KWT, LAO, LBN, LBR, LBY, LCA, LKA, LSO, MAR, MDA, MDG, MDV, MEX, MHL, MKD, MLI, MMR, MNE, MNG, MOZ, MRT, MUS, MWI, MYS, NAM, NER, NGA, NIC, NPL, NRU, OMN, PAK, PAN, PER, PHL, PLW, PNG, POL, PRY, PSE, QAT, ROU, RUS, RWA, SAU, SDN, SEN, SLB, SLE, SLV, SOM, SRB, SSD, STP, SUR, SWZ, SYC, SYR, TCD, TGO, THA, TJK, TLS, TON, TTO, TUN, TUR, TUV, TZA, UGA, UKR, URY, UZB, VCT, VNM, VUT, WSM, XKX, YEM, ZAF, ZMB, ZWE
#> 4  Afghanistan, Angola, Albania, United Arab Emirates, Argentina, Armenia, Azerbaijan, Burundi, Benin, Burkina Faso, Bangladesh, Bulgaria, Bahrain, Bahamas, The, Bosnia and Herzegovina, Belarus, Belize, Bolivia, Brazil, Barbados, Bhutan, Botswana, Central African Republic, Chile, China, Cote d'Ivoire, Cameroon, Congo, Dem. Rep., Congo, Rep., Colombia, Comoros, Cabo Verde, Costa Rica, Djibouti, Dominica, Dominican Republic, Algeria, Ecuador, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Micronesia, Fed. Sts., Gabon, Georgia, Ghana, Guinea, Gambia, The, Guinea-Bissau, Equatorial Guinea, Grenada, Guatemala, Guyana, Honduras, Croatia, Haiti, Indonesia, India, Iran, Islamic Rep., Iraq, Jamaica, Jordan, Kazakhstan, Kenya, Kyrgyz Republic, Cambodia, Kiribati, Kuwait, Lao PDR, Lebanon, Liberia, Libya, St. Lucia, Sri Lanka, Lesotho, Morocco, Moldova, Madagascar, Maldives, Mexico, Marshall Islands, North Macedonia, Mali, Myanmar, Montenegro, Mongolia, Mozambique, Mauritania, Mauritius, Malawi, Malaysia, Namibia, Niger, Nigeria, Nicaragua, Nepal, Nauru, Oman, Pakistan, Panama, Peru, Philippines, Palau, Papua New Guinea, Poland, Paraguay, West Bank and Gaza, Qatar, Romania, Russian Federation, Rwanda, Saudi Arabia, Sudan, Senegal, Solomon Islands, Sierra Leone, El Salvador, Somalia, Serbia, South Sudan, Sao Tome and Principe, Suriname, Eswatini, Seychelles, Syrian Arab Republic, Chad, Togo, Thailand, Tajikistan, Timor-Leste, Tonga, Trinidad and Tobago, Tunisia, Turkiye, Tuvalu, Tanzania, Uganda, Ukraine, Uruguay, Uzbekistan, St. Vincent and the Grenadines, Viet Nam, Vanuatu, Samoa, Kosovo, Yemen, Rep., South Africa, Zambia, Zimbabwe, AFG, AGO, ALB, ARE, ARG, ARM, AZE, BDI, BEN, BFA, BGD, BGR, BHR, BHS, BIH, BLR, BLZ, BOL, BRA, BRB, BTN, BWA, CAF, CHL, CHN, CIV, CMR, COD, COG, COL, COM, CPV, CRI, DJI, DMA, DOM, DZA, ECU, EGY, ERI, ETH, FJI, FSM, GAB, GEO, GHA, GIN, GMB, GNB, GNQ, GRD, GTM, GUY, HND, HRV, HTI, IDN, IND, IRN, IRQ, JAM, JOR, KAZ, KEN, KGZ, KHM, KIR, KWT, LAO, LBN, LBR, LBY, LCA, LKA, LSO, MAR, MDA, MDG, MDV, MEX, MHL, MKD, MLI, MMR, MNE, MNG, MOZ, MRT, MUS, MWI, MYS, NAM, NER, NGA, NIC, NPL, NRU, OMN, PAK, PAN, PER, PHL, PLW, PNG, POL, PRY, PSE, QAT, ROU, RUS, RWA, SAU, SDN, SEN, SLB, SLE, SLV, SOM, SRB, SSD, STP, SUR, SWZ, SYC, SYR, TCD, TGO, THA, TJK, TLS, TON, TTO, TUN, TUR, TUV, TZA, UGA, UKR, URY, UZB, VCT, VNM, VUT, WSM, XKX, YEM, ZAF, ZMB, ZWE
#> 5  Afghanistan, Angola, Albania, United Arab Emirates, Argentina, Armenia, Azerbaijan, Burundi, Benin, Burkina Faso, Bangladesh, Bulgaria, Bahrain, Bahamas, The, Bosnia and Herzegovina, Belarus, Belize, Bolivia, Brazil, Barbados, Bhutan, Botswana, Central African Republic, Chile, China, Cote d'Ivoire, Cameroon, Congo, Dem. Rep., Congo, Rep., Colombia, Comoros, Cabo Verde, Costa Rica, Djibouti, Dominica, Dominican Republic, Algeria, Ecuador, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Micronesia, Fed. Sts., Gabon, Georgia, Ghana, Guinea, Gambia, The, Guinea-Bissau, Equatorial Guinea, Grenada, Guatemala, Guyana, Honduras, Croatia, Haiti, Indonesia, India, Iran, Islamic Rep., Iraq, Jamaica, Jordan, Kazakhstan, Kenya, Kyrgyz Republic, Cambodia, Kiribati, Kuwait, Lao PDR, Lebanon, Liberia, Libya, St. Lucia, Sri Lanka, Lesotho, Morocco, Moldova, Madagascar, Maldives, Mexico, Marshall Islands, North Macedonia, Mali, Myanmar, Montenegro, Mongolia, Mozambique, Mauritania, Mauritius, Malawi, Malaysia, Namibia, Niger, Nigeria, Nicaragua, Nepal, Nauru, Oman, Pakistan, Panama, Peru, Philippines, Palau, Papua New Guinea, Poland, Paraguay, West Bank and Gaza, Qatar, Romania, Russian Federation, Rwanda, Saudi Arabia, Sudan, Senegal, Solomon Islands, Sierra Leone, El Salvador, Somalia, Serbia, South Sudan, Sao Tome and Principe, Suriname, Eswatini, Seychelles, Syrian Arab Republic, Chad, Togo, Thailand, Tajikistan, Timor-Leste, Tonga, Trinidad and Tobago, Tunisia, Turkiye, Tuvalu, Tanzania, Uganda, Ukraine, Uruguay, Uzbekistan, St. Vincent and the Grenadines, Viet Nam, Vanuatu, Samoa, Kosovo, Yemen, Rep., South Africa, Zambia, Zimbabwe, AFG, AGO, ALB, ARE, ARG, ARM, AZE, BDI, BEN, BFA, BGD, BGR, BHR, BHS, BIH, BLR, BLZ, BOL, BRA, BRB, BTN, BWA, CAF, CHL, CHN, CIV, CMR, COD, COG, COL, COM, CPV, CRI, DJI, DMA, DOM, DZA, ECU, EGY, ERI, ETH, FJI, FSM, GAB, GEO, GHA, GIN, GMB, GNB, GNQ, GRD, GTM, GUY, HND, HRV, HTI, IDN, IND, IRN, IRQ, JAM, JOR, KAZ, KEN, KGZ, KHM, KIR, KWT, LAO, LBN, LBR, LBY, LCA, LKA, LSO, MAR, MDA, MDG, MDV, MEX, MHL, MKD, MLI, MMR, MNE, MNG, MOZ, MRT, MUS, MWI, MYS, NAM, NER, NGA, NIC, NPL, NRU, OMN, PAK, PAN, PER, PHL, PLW, PNG, POL, PRY, PSE, QAT, ROU, RUS, RWA, SAU, SDN, SEN, SLB, SLE, SLV, SOM, SRB, SSD, STP, SUR, SWZ, SYC, SYR, TCD, TGO, THA, TJK, TLS, TON, TTO, TUN, TUR, TUV, TZA, UGA, UKR, URY, UZB, VCT, VNM, VUT, WSM, XKX, YEM, ZAF, ZMB, ZWE
#> 6  Afghanistan, Angola, Albania, United Arab Emirates, Argentina, Armenia, Azerbaijan, Burundi, Benin, Burkina Faso, Bangladesh, Bulgaria, Bahrain, Bahamas, The, Bosnia and Herzegovina, Belarus, Belize, Bolivia, Brazil, Barbados, Bhutan, Botswana, Central African Republic, Chile, China, Cote d'Ivoire, Cameroon, Congo, Dem. Rep., Congo, Rep., Colombia, Comoros, Cabo Verde, Costa Rica, Djibouti, Dominica, Dominican Republic, Algeria, Ecuador, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Micronesia, Fed. Sts., Gabon, Georgia, Ghana, Guinea, Gambia, The, Guinea-Bissau, Equatorial Guinea, Grenada, Guatemala, Guyana, Honduras, Croatia, Haiti, Indonesia, India, Iran, Islamic Rep., Iraq, Jamaica, Jordan, Kazakhstan, Kenya, Kyrgyz Republic, Cambodia, Kiribati, Kuwait, Lao PDR, Lebanon, Liberia, Libya, St. Lucia, Sri Lanka, Lesotho, Morocco, Moldova, Madagascar, Maldives, Mexico, Marshall Islands, North Macedonia, Mali, Myanmar, Montenegro, Mongolia, Mozambique, Mauritania, Mauritius, Malawi, Malaysia, Namibia, Niger, Nigeria, Nicaragua, Nepal, Nauru, Oman, Pakistan, Panama, Peru, Philippines, Palau, Papua New Guinea, Poland, Paraguay, West Bank and Gaza, Qatar, Romania, Russian Federation, Rwanda, Saudi Arabia, Sudan, Senegal, Solomon Islands, Sierra Leone, El Salvador, Somalia, Serbia, South Sudan, Sao Tome and Principe, Suriname, Eswatini, Seychelles, Syrian Arab Republic, Chad, Togo, Thailand, Tajikistan, Timor-Leste, Tonga, Trinidad and Tobago, Tunisia, Turkiye, Tuvalu, Tanzania, Uganda, Ukraine, Uruguay, Uzbekistan, St. Vincent and the Grenadines, Viet Nam, Vanuatu, Samoa, Kosovo, Yemen, Rep., South Africa, Zambia, Zimbabwe, AFG, AGO, ALB, ARE, ARG, ARM, AZE, BDI, BEN, BFA, BGD, BGR, BHR, BHS, BIH, BLR, BLZ, BOL, BRA, BRB, BTN, BWA, CAF, CHL, CHN, CIV, CMR, COD, COG, COL, COM, CPV, CRI, DJI, DMA, DOM, DZA, ECU, EGY, ERI, ETH, FJI, FSM, GAB, GEO, GHA, GIN, GMB, GNB, GNQ, GRD, GTM, GUY, HND, HRV, HTI, IDN, IND, IRN, IRQ, JAM, JOR, KAZ, KEN, KGZ, KHM, KIR, KWT, LAO, LBN, LBR, LBY, LCA, LKA, LSO, MAR, MDA, MDG, MDV, MEX, MHL, MKD, MLI, MMR, MNE, MNG, MOZ, MRT, MUS, MWI, MYS, NAM, NER, NGA, NIC, NPL, NRU, OMN, PAK, PAN, PER, PHL, PLW, PNG, POL, PRY, PSE, QAT, ROU, RUS, RWA, SAU, SDN, SEN, SLB, SLE, SLV, SOM, SRB, SSD, STP, SUR, SWZ, SYC, SYR, TCD, TGO, THA, TJK, TLS, TON, TTO, TUN, TUR, TUV, TZA, UGA, UKR, URY, UZB, VCT, VNM, VUT, WSM, XKX, YEM, ZAF, ZMB, ZWE
#> 7  Afghanistan, Angola, Albania, United Arab Emirates, Argentina, Armenia, Azerbaijan, Burundi, Benin, Burkina Faso, Bangladesh, Bulgaria, Bahrain, Bahamas, The, Bosnia and Herzegovina, Belarus, Belize, Bolivia, Brazil, Barbados, Bhutan, Botswana, Central African Republic, Chile, China, Cote d'Ivoire, Cameroon, Congo, Dem. Rep., Congo, Rep., Colombia, Comoros, Cabo Verde, Costa Rica, Djibouti, Dominica, Dominican Republic, Algeria, Ecuador, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Micronesia, Fed. Sts., Gabon, Georgia, Ghana, Guinea, Gambia, The, Guinea-Bissau, Equatorial Guinea, Grenada, Guatemala, Guyana, Honduras, Croatia, Haiti, Indonesia, India, Iran, Islamic Rep., Iraq, Jamaica, Jordan, Kazakhstan, Kenya, Kyrgyz Republic, Cambodia, Kiribati, Kuwait, Lao PDR, Lebanon, Liberia, Libya, St. Lucia, Sri Lanka, Lesotho, Morocco, Moldova, Madagascar, Maldives, Mexico, Marshall Islands, North Macedonia, Mali, Myanmar, Montenegro, Mongolia, Mozambique, Mauritania, Mauritius, Malawi, Malaysia, Namibia, Niger, Nigeria, Nicaragua, Nepal, Nauru, Oman, Pakistan, Panama, Peru, Philippines, Palau, Papua New Guinea, Poland, Paraguay, West Bank and Gaza, Qatar, Romania, Russian Federation, Rwanda, Saudi Arabia, Sudan, Senegal, Solomon Islands, Sierra Leone, El Salvador, Somalia, Serbia, South Sudan, Sao Tome and Principe, Suriname, Eswatini, Seychelles, Syrian Arab Republic, Chad, Togo, Thailand, Tajikistan, Timor-Leste, Tonga, Trinidad and Tobago, Tunisia, Turkiye, Tuvalu, Tanzania, Uganda, Ukraine, Uruguay, Uzbekistan, St. Vincent and the Grenadines, Viet Nam, Vanuatu, Samoa, Kosovo, Yemen, Rep., South Africa, Zambia, Zimbabwe, AFG, AGO, ALB, ARE, ARG, ARM, AZE, BDI, BEN, BFA, BGD, BGR, BHR, BHS, BIH, BLR, BLZ, BOL, BRA, BRB, BTN, BWA, CAF, CHL, CHN, CIV, CMR, COD, COG, COL, COM, CPV, CRI, DJI, DMA, DOM, DZA, ECU, EGY, ERI, ETH, FJI, FSM, GAB, GEO, GHA, GIN, GMB, GNB, GNQ, GRD, GTM, GUY, HND, HRV, HTI, IDN, IND, IRN, IRQ, JAM, JOR, KAZ, KEN, KGZ, KHM, KIR, KWT, LAO, LBN, LBR, LBY, LCA, LKA, LSO, MAR, MDA, MDG, MDV, MEX, MHL, MKD, MLI, MMR, MNE, MNG, MOZ, MRT, MUS, MWI, MYS, NAM, NER, NGA, NIC, NPL, NRU, OMN, PAK, PAN, PER, PHL, PLW, PNG, POL, PRY, PSE, QAT, ROU, RUS, RWA, SAU, SDN, SEN, SLB, SLE, SLV, SOM, SRB, SSD, STP, SUR, SWZ, SYC, SYR, TCD, TGO, THA, TJK, TLS, TON, TTO, TUN, TUR, TUV, TZA, UGA, UKR, URY, UZB, VCT, VNM, VUT, WSM, XKX, YEM, ZAF, ZMB, ZWE
#> 8  Afghanistan, Angola, Albania, United Arab Emirates, Argentina, Armenia, Azerbaijan, Burundi, Benin, Burkina Faso, Bangladesh, Bulgaria, Bahrain, Bahamas, The, Bosnia and Herzegovina, Belarus, Belize, Bolivia, Brazil, Barbados, Bhutan, Botswana, Central African Republic, Chile, China, Cote d'Ivoire, Cameroon, Congo, Dem. Rep., Congo, Rep., Colombia, Comoros, Cabo Verde, Costa Rica, Djibouti, Dominica, Dominican Republic, Algeria, Ecuador, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Micronesia, Fed. Sts., Gabon, Georgia, Ghana, Guinea, Gambia, The, Guinea-Bissau, Equatorial Guinea, Grenada, Guatemala, Guyana, Honduras, Croatia, Haiti, Indonesia, India, Iran, Islamic Rep., Iraq, Jamaica, Jordan, Kazakhstan, Kenya, Kyrgyz Republic, Cambodia, Kiribati, Kuwait, Lao PDR, Lebanon, Liberia, Libya, St. Lucia, Sri Lanka, Lesotho, Morocco, Moldova, Madagascar, Maldives, Mexico, Marshall Islands, North Macedonia, Mali, Myanmar, Montenegro, Mongolia, Mozambique, Mauritania, Mauritius, Malawi, Malaysia, Namibia, Niger, Nigeria, Nicaragua, Nepal, Nauru, Oman, Pakistan, Panama, Peru, Philippines, Palau, Papua New Guinea, Poland, Paraguay, West Bank and Gaza, Qatar, Romania, Russian Federation, Rwanda, Saudi Arabia, Sudan, Senegal, Solomon Islands, Sierra Leone, El Salvador, Somalia, Serbia, South Sudan, Sao Tome and Principe, Suriname, Eswatini, Seychelles, Syrian Arab Republic, Chad, Togo, Thailand, Tajikistan, Timor-Leste, Tonga, Trinidad and Tobago, Tunisia, Turkiye, Tuvalu, Tanzania, Uganda, Ukraine, Uruguay, Uzbekistan, St. Vincent and the Grenadines, Viet Nam, Vanuatu, Samoa, Kosovo, Yemen, Rep., South Africa, Zambia, Zimbabwe, AFG, AGO, ALB, ARE, ARG, ARM, AZE, BDI, BEN, BFA, BGD, BGR, BHR, BHS, BIH, BLR, BLZ, BOL, BRA, BRB, BTN, BWA, CAF, CHL, CHN, CIV, CMR, COD, COG, COL, COM, CPV, CRI, DJI, DMA, DOM, DZA, ECU, EGY, ERI, ETH, FJI, FSM, GAB, GEO, GHA, GIN, GMB, GNB, GNQ, GRD, GTM, GUY, HND, HRV, HTI, IDN, IND, IRN, IRQ, JAM, JOR, KAZ, KEN, KGZ, KHM, KIR, KWT, LAO, LBN, LBR, LBY, LCA, LKA, LSO, MAR, MDA, MDG, MDV, MEX, MHL, MKD, MLI, MMR, MNE, MNG, MOZ, MRT, MUS, MWI, MYS, NAM, NER, NGA, NIC, NPL, NRU, OMN, PAK, PAN, PER, PHL, PLW, PNG, POL, PRY, PSE, QAT, ROU, RUS, RWA, SAU, SDN, SEN, SLB, SLE, SLV, SOM, SRB, SSD, STP, SUR, SWZ, SYC, SYR, TCD, TGO, THA, TJK, TLS, TON, TTO, TUN, TUR, TUV, TZA, UGA, UKR, URY, UZB, VCT, VNM, VUT, WSM, XKX, YEM, ZAF, ZMB, ZWE
#> 9  Afghanistan, Angola, Albania, United Arab Emirates, Argentina, Armenia, Azerbaijan, Burundi, Benin, Burkina Faso, Bangladesh, Bulgaria, Bahrain, Bahamas, The, Bosnia and Herzegovina, Belarus, Belize, Bolivia, Brazil, Barbados, Bhutan, Botswana, Central African Republic, Chile, China, Cote d'Ivoire, Cameroon, Congo, Dem. Rep., Congo, Rep., Colombia, Comoros, Cabo Verde, Costa Rica, Djibouti, Dominica, Dominican Republic, Algeria, Ecuador, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Micronesia, Fed. Sts., Gabon, Georgia, Ghana, Guinea, Gambia, The, Guinea-Bissau, Equatorial Guinea, Grenada, Guatemala, Guyana, Honduras, Croatia, Haiti, Indonesia, India, Iran, Islamic Rep., Iraq, Jamaica, Jordan, Kazakhstan, Kenya, Kyrgyz Republic, Cambodia, Kiribati, Kuwait, Lao PDR, Lebanon, Liberia, Libya, St. Lucia, Sri Lanka, Lesotho, Morocco, Moldova, Madagascar, Maldives, Mexico, Marshall Islands, North Macedonia, Mali, Myanmar, Montenegro, Mongolia, Mozambique, Mauritania, Mauritius, Malawi, Malaysia, Namibia, Niger, Nigeria, Nicaragua, Nepal, Nauru, Oman, Pakistan, Panama, Peru, Philippines, Palau, Papua New Guinea, Poland, Paraguay, West Bank and Gaza, Qatar, Romania, Russian Federation, Rwanda, Saudi Arabia, Sudan, Senegal, Solomon Islands, Sierra Leone, El Salvador, Somalia, Serbia, South Sudan, Sao Tome and Principe, Suriname, Eswatini, Seychelles, Syrian Arab Republic, Chad, Togo, Thailand, Tajikistan, Timor-Leste, Tonga, Trinidad and Tobago, Tunisia, Turkiye, Tuvalu, Tanzania, Uganda, Ukraine, Uruguay, Uzbekistan, St. Vincent and the Grenadines, Viet Nam, Vanuatu, Samoa, Kosovo, Yemen, Rep., South Africa, Zambia, Zimbabwe, AFG, AGO, ALB, ARE, ARG, ARM, AZE, BDI, BEN, BFA, BGD, BGR, BHR, BHS, BIH, BLR, BLZ, BOL, BRA, BRB, BTN, BWA, CAF, CHL, CHN, CIV, CMR, COD, COG, COL, COM, CPV, CRI, DJI, DMA, DOM, DZA, ECU, EGY, ERI, ETH, FJI, FSM, GAB, GEO, GHA, GIN, GMB, GNB, GNQ, GRD, GTM, GUY, HND, HRV, HTI, IDN, IND, IRN, IRQ, JAM, JOR, KAZ, KEN, KGZ, KHM, KIR, KWT, LAO, LBN, LBR, LBY, LCA, LKA, LSO, MAR, MDA, MDG, MDV, MEX, MHL, MKD, MLI, MMR, MNE, MNG, MOZ, MRT, MUS, MWI, MYS, NAM, NER, NGA, NIC, NPL, NRU, OMN, PAK, PAN, PER, PHL, PLW, PNG, POL, PRY, PSE, QAT, ROU, RUS, RWA, SAU, SDN, SEN, SLB, SLE, SLV, SOM, SRB, SSD, STP, SUR, SWZ, SYC, SYR, TCD, TGO, THA, TJK, TLS, TON, TTO, TUN, TUR, TUV, TZA, UGA, UKR, URY, UZB, VCT, VNM, VUT, WSM, XKX, YEM, ZAF, ZMB, ZWE
#> 10 Afghanistan, Angola, Albania, United Arab Emirates, Argentina, Armenia, Azerbaijan, Burundi, Benin, Burkina Faso, Bangladesh, Bulgaria, Bahrain, Bahamas, The, Bosnia and Herzegovina, Belarus, Belize, Bolivia, Brazil, Barbados, Bhutan, Botswana, Central African Republic, Chile, China, Cote d'Ivoire, Cameroon, Congo, Dem. Rep., Congo, Rep., Colombia, Comoros, Cabo Verde, Costa Rica, Djibouti, Dominica, Dominican Republic, Algeria, Ecuador, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Micronesia, Fed. Sts., Gabon, Georgia, Ghana, Guinea, Gambia, The, Guinea-Bissau, Equatorial Guinea, Grenada, Guatemala, Guyana, Honduras, Croatia, Haiti, Indonesia, India, Iran, Islamic Rep., Iraq, Jamaica, Jordan, Kazakhstan, Kenya, Kyrgyz Republic, Cambodia, Kiribati, Kuwait, Lao PDR, Lebanon, Liberia, Libya, St. Lucia, Sri Lanka, Lesotho, Morocco, Moldova, Madagascar, Maldives, Mexico, Marshall Islands, North Macedonia, Mali, Myanmar, Montenegro, Mongolia, Mozambique, Mauritania, Mauritius, Malawi, Malaysia, Namibia, Niger, Nigeria, Nicaragua, Nepal, Nauru, Oman, Pakistan, Panama, Peru, Philippines, Palau, Papua New Guinea, Poland, Paraguay, West Bank and Gaza, Qatar, Romania, Russian Federation, Rwanda, Saudi Arabia, Sudan, Senegal, Solomon Islands, Sierra Leone, El Salvador, Somalia, Serbia, South Sudan, Sao Tome and Principe, Suriname, Eswatini, Seychelles, Syrian Arab Republic, Chad, Togo, Thailand, Tajikistan, Timor-Leste, Tonga, Trinidad and Tobago, Tunisia, Turkiye, Tuvalu, Tanzania, Uganda, Ukraine, Uruguay, Uzbekistan, St. Vincent and the Grenadines, Viet Nam, Vanuatu, Samoa, Kosovo, Yemen, Rep., South Africa, Zambia, Zimbabwe, AFG, AGO, ALB, ARE, ARG, ARM, AZE, BDI, BEN, BFA, BGD, BGR, BHR, BHS, BIH, BLR, BLZ, BOL, BRA, BRB, BTN, BWA, CAF, CHL, CHN, CIV, CMR, COD, COG, COL, COM, CPV, CRI, DJI, DMA, DOM, DZA, ECU, EGY, ERI, ETH, FJI, FSM, GAB, GEO, GHA, GIN, GMB, GNB, GNQ, GRD, GTM, GUY, HND, HRV, HTI, IDN, IND, IRN, IRQ, JAM, JOR, KAZ, KEN, KGZ, KHM, KIR, KWT, LAO, LBN, LBR, LBY, LCA, LKA, LSO, MAR, MDA, MDG, MDV, MEX, MHL, MKD, MLI, MMR, MNE, MNG, MOZ, MRT, MUS, MWI, MYS, NAM, NER, NGA, NIC, NPL, NRU, OMN, PAK, PAN, PER, PHL, PLW, PNG, POL, PRY, PSE, QAT, ROU, RUS, RWA, SAU, SDN, SEN, SLB, SLE, SLV, SOM, SRB, SSD, STP, SUR, SWZ, SYC, SYR, TCD, TGO, THA, TJK, TLS, TON, TTO, TUN, TUR, TUV, TZA, UGA, UKR, URY, UZB, VCT, VNM, VUT, WSM, XKX, YEM, ZAF, ZMB, ZWE
#> 11 Afghanistan, Angola, Albania, United Arab Emirates, Argentina, Armenia, Azerbaijan, Burundi, Benin, Burkina Faso, Bangladesh, Bulgaria, Bahrain, Bahamas, The, Bosnia and Herzegovina, Belarus, Belize, Bolivia, Brazil, Barbados, Bhutan, Botswana, Central African Republic, Chile, China, Cote d'Ivoire, Cameroon, Congo, Dem. Rep., Congo, Rep., Colombia, Comoros, Cabo Verde, Costa Rica, Djibouti, Dominica, Dominican Republic, Algeria, Ecuador, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Micronesia, Fed. Sts., Gabon, Georgia, Ghana, Guinea, Gambia, The, Guinea-Bissau, Equatorial Guinea, Grenada, Guatemala, Guyana, Honduras, Croatia, Haiti, Indonesia, India, Iran, Islamic Rep., Iraq, Jamaica, Jordan, Kazakhstan, Kenya, Kyrgyz Republic, Cambodia, Kiribati, Kuwait, Lao PDR, Lebanon, Liberia, Libya, St. Lucia, Sri Lanka, Lesotho, Morocco, Moldova, Madagascar, Maldives, Mexico, Marshall Islands, North Macedonia, Mali, Myanmar, Montenegro, Mongolia, Mozambique, Mauritania, Mauritius, Malawi, Malaysia, Namibia, Niger, Nigeria, Nicaragua, Nepal, Nauru, Oman, Pakistan, Panama, Peru, Philippines, Palau, Papua New Guinea, Poland, Paraguay, West Bank and Gaza, Qatar, Romania, Russian Federation, Rwanda, Saudi Arabia, Sudan, Senegal, Solomon Islands, Sierra Leone, El Salvador, Somalia, Serbia, South Sudan, Sao Tome and Principe, Suriname, Eswatini, Seychelles, Syrian Arab Republic, Chad, Togo, Thailand, Tajikistan, Timor-Leste, Tonga, Trinidad and Tobago, Tunisia, Turkiye, Tuvalu, Tanzania, Uganda, Ukraine, Uruguay, Uzbekistan, St. Vincent and the Grenadines, Viet Nam, Vanuatu, Samoa, Kosovo, Yemen, Rep., South Africa, Zambia, Zimbabwe, AFG, AGO, ALB, ARE, ARG, ARM, AZE, BDI, BEN, BFA, BGD, BGR, BHR, BHS, BIH, BLR, BLZ, BOL, BRA, BRB, BTN, BWA, CAF, CHL, CHN, CIV, CMR, COD, COG, COL, COM, CPV, CRI, DJI, DMA, DOM, DZA, ECU, EGY, ERI, ETH, FJI, FSM, GAB, GEO, GHA, GIN, GMB, GNB, GNQ, GRD, GTM, GUY, HND, HRV, HTI, IDN, IND, IRN, IRQ, JAM, JOR, KAZ, KEN, KGZ, KHM, KIR, KWT, LAO, LBN, LBR, LBY, LCA, LKA, LSO, MAR, MDA, MDG, MDV, MEX, MHL, MKD, MLI, MMR, MNE, MNG, MOZ, MRT, MUS, MWI, MYS, NAM, NER, NGA, NIC, NPL, NRU, OMN, PAK, PAN, PER, PHL, PLW, PNG, POL, PRY, PSE, QAT, ROU, RUS, RWA, SAU, SDN, SEN, SLB, SLE, SLV, SOM, SRB, SSD, STP, SUR, SWZ, SYC, SYR, TCD, TGO, THA, TJK, TLS, TON, TTO, TUN, TUR, TUV, TZA, UGA, UKR, URY, UZB, VCT, VNM, VUT, WSM, XKX, YEM, ZAF, ZMB, ZWE
#> 12 Afghanistan, Angola, Albania, United Arab Emirates, Argentina, Armenia, Azerbaijan, Burundi, Benin, Burkina Faso, Bangladesh, Bulgaria, Bahrain, Bahamas, The, Bosnia and Herzegovina, Belarus, Belize, Bolivia, Brazil, Barbados, Bhutan, Botswana, Central African Republic, Chile, China, Cote d'Ivoire, Cameroon, Congo, Dem. Rep., Congo, Rep., Colombia, Comoros, Cabo Verde, Costa Rica, Djibouti, Dominica, Dominican Republic, Algeria, Ecuador, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Micronesia, Fed. Sts., Gabon, Georgia, Ghana, Guinea, Gambia, The, Guinea-Bissau, Equatorial Guinea, Grenada, Guatemala, Guyana, Honduras, Croatia, Haiti, Indonesia, India, Iran, Islamic Rep., Iraq, Jamaica, Jordan, Kazakhstan, Kenya, Kyrgyz Republic, Cambodia, Kiribati, Kuwait, Lao PDR, Lebanon, Liberia, Libya, St. Lucia, Sri Lanka, Lesotho, Morocco, Moldova, Madagascar, Maldives, Mexico, Marshall Islands, North Macedonia, Mali, Myanmar, Montenegro, Mongolia, Mozambique, Mauritania, Mauritius, Malawi, Malaysia, Namibia, Niger, Nigeria, Nicaragua, Nepal, Nauru, Oman, Pakistan, Panama, Peru, Philippines, Palau, Papua New Guinea, Poland, Paraguay, West Bank and Gaza, Qatar, Romania, Russian Federation, Rwanda, Saudi Arabia, Sudan, Senegal, Solomon Islands, Sierra Leone, El Salvador, Somalia, Serbia, South Sudan, Sao Tome and Principe, Suriname, Eswatini, Seychelles, Syrian Arab Republic, Chad, Togo, Thailand, Tajikistan, Timor-Leste, Tonga, Trinidad and Tobago, Tunisia, Turkiye, Tuvalu, Tanzania, Uganda, Ukraine, Uruguay, Uzbekistan, St. Vincent and the Grenadines, Viet Nam, Vanuatu, Samoa, Kosovo, Yemen, Rep., South Africa, Zambia, Zimbabwe, AFG, AGO, ALB, ARE, ARG, ARM, AZE, BDI, BEN, BFA, BGD, BGR, BHR, BHS, BIH, BLR, BLZ, BOL, BRA, BRB, BTN, BWA, CAF, CHL, CHN, CIV, CMR, COD, COG, COL, COM, CPV, CRI, DJI, DMA, DOM, DZA, ECU, EGY, ERI, ETH, FJI, FSM, GAB, GEO, GHA, GIN, GMB, GNB, GNQ, GRD, GTM, GUY, HND, HRV, HTI, IDN, IND, IRN, IRQ, JAM, JOR, KAZ, KEN, KGZ, KHM, KIR, KWT, LAO, LBN, LBR, LBY, LCA, LKA, LSO, MAR, MDA, MDG, MDV, MEX, MHL, MKD, MLI, MMR, MNE, MNG, MOZ, MRT, MUS, MWI, MYS, NAM, NER, NGA, NIC, NPL, NRU, OMN, PAK, PAN, PER, PHL, PLW, PNG, POL, PRY, PSE, QAT, ROU, RUS, RWA, SAU, SDN, SEN, SLB, SLE, SLV, SOM, SRB, SSD, STP, SUR, SWZ, SYC, SYR, TCD, TGO, THA, TJK, TLS, TON, TTO, TUN, TUR, TUV, TZA, UGA, UKR, URY, UZB, VCT, VNM, VUT, WSM, XKX, YEM, ZAF, ZMB, ZWE
#> 13 Afghanistan, Angola, Albania, United Arab Emirates, Argentina, Armenia, Azerbaijan, Burundi, Benin, Burkina Faso, Bangladesh, Bulgaria, Bahrain, Bahamas, The, Bosnia and Herzegovina, Belarus, Belize, Bolivia, Brazil, Barbados, Bhutan, Botswana, Central African Republic, Chile, China, Cote d'Ivoire, Cameroon, Congo, Dem. Rep., Congo, Rep., Colombia, Comoros, Cabo Verde, Costa Rica, Djibouti, Dominica, Dominican Republic, Algeria, Ecuador, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Micronesia, Fed. Sts., Gabon, Georgia, Ghana, Guinea, Gambia, The, Guinea-Bissau, Equatorial Guinea, Grenada, Guatemala, Guyana, Honduras, Croatia, Haiti, Indonesia, India, Iran, Islamic Rep., Iraq, Jamaica, Jordan, Kazakhstan, Kenya, Kyrgyz Republic, Cambodia, Kiribati, Kuwait, Lao PDR, Lebanon, Liberia, Libya, St. Lucia, Sri Lanka, Lesotho, Morocco, Moldova, Madagascar, Maldives, Mexico, Marshall Islands, North Macedonia, Mali, Myanmar, Montenegro, Mongolia, Mozambique, Mauritania, Mauritius, Malawi, Malaysia, Namibia, Niger, Nigeria, Nicaragua, Nepal, Nauru, Oman, Pakistan, Panama, Peru, Philippines, Palau, Papua New Guinea, Poland, Paraguay, West Bank and Gaza, Qatar, Romania, Russian Federation, Rwanda, Saudi Arabia, Sudan, Senegal, Solomon Islands, Sierra Leone, El Salvador, Somalia, Serbia, South Sudan, Sao Tome and Principe, Suriname, Eswatini, Seychelles, Syrian Arab Republic, Chad, Togo, Thailand, Tajikistan, Timor-Leste, Tonga, Trinidad and Tobago, Tunisia, Turkiye, Tuvalu, Tanzania, Uganda, Ukraine, Uruguay, Uzbekistan, St. Vincent and the Grenadines, Viet Nam, Vanuatu, Samoa, Kosovo, Yemen, Rep., South Africa, Zambia, Zimbabwe, AFG, AGO, ALB, ARE, ARG, ARM, AZE, BDI, BEN, BFA, BGD, BGR, BHR, BHS, BIH, BLR, BLZ, BOL, BRA, BRB, BTN, BWA, CAF, CHL, CHN, CIV, CMR, COD, COG, COL, COM, CPV, CRI, DJI, DMA, DOM, DZA, ECU, EGY, ERI, ETH, FJI, FSM, GAB, GEO, GHA, GIN, GMB, GNB, GNQ, GRD, GTM, GUY, HND, HRV, HTI, IDN, IND, IRN, IRQ, JAM, JOR, KAZ, KEN, KGZ, KHM, KIR, KWT, LAO, LBN, LBR, LBY, LCA, LKA, LSO, MAR, MDA, MDG, MDV, MEX, MHL, MKD, MLI, MMR, MNE, MNG, MOZ, MRT, MUS, MWI, MYS, NAM, NER, NGA, NIC, NPL, NRU, OMN, PAK, PAN, PER, PHL, PLW, PNG, POL, PRY, PSE, QAT, ROU, RUS, RWA, SAU, SDN, SEN, SLB, SLE, SLV, SOM, SRB, SSD, STP, SUR, SWZ, SYC, SYR, TCD, TGO, THA, TJK, TLS, TON, TTO, TUN, TUR, TUV, TZA, UGA, UKR, URY, UZB, VCT, VNM, VUT, WSM, XKX, YEM, ZAF, ZMB, ZWE
#> 14 Afghanistan, Angola, Albania, United Arab Emirates, Argentina, Armenia, Azerbaijan, Burundi, Benin, Burkina Faso, Bangladesh, Bulgaria, Bahrain, Bahamas, The, Bosnia and Herzegovina, Belarus, Belize, Bolivia, Brazil, Barbados, Bhutan, Botswana, Central African Republic, Chile, China, Cote d'Ivoire, Cameroon, Congo, Dem. Rep., Congo, Rep., Colombia, Comoros, Cabo Verde, Costa Rica, Djibouti, Dominica, Dominican Republic, Algeria, Ecuador, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Micronesia, Fed. Sts., Gabon, Georgia, Ghana, Guinea, Gambia, The, Guinea-Bissau, Equatorial Guinea, Grenada, Guatemala, Guyana, Honduras, Croatia, Haiti, Indonesia, India, Iran, Islamic Rep., Iraq, Jamaica, Jordan, Kazakhstan, Kenya, Kyrgyz Republic, Cambodia, Kiribati, Kuwait, Lao PDR, Lebanon, Liberia, Libya, St. Lucia, Sri Lanka, Lesotho, Morocco, Moldova, Madagascar, Maldives, Mexico, Marshall Islands, North Macedonia, Mali, Myanmar, Montenegro, Mongolia, Mozambique, Mauritania, Mauritius, Malawi, Malaysia, Namibia, Niger, Nigeria, Nicaragua, Nepal, Nauru, Oman, Pakistan, Panama, Peru, Philippines, Palau, Papua New Guinea, Poland, Paraguay, West Bank and Gaza, Qatar, Romania, Russian Federation, Rwanda, Saudi Arabia, Sudan, Senegal, Solomon Islands, Sierra Leone, El Salvador, Somalia, Serbia, South Sudan, Sao Tome and Principe, Suriname, Eswatini, Seychelles, Syrian Arab Republic, Chad, Togo, Thailand, Tajikistan, Timor-Leste, Tonga, Trinidad and Tobago, Tunisia, Turkiye, Tuvalu, Tanzania, Uganda, Ukraine, Uruguay, Uzbekistan, St. Vincent and the Grenadines, Viet Nam, Vanuatu, Samoa, Kosovo, Yemen, Rep., South Africa, Zambia, Zimbabwe, AFG, AGO, ALB, ARE, ARG, ARM, AZE, BDI, BEN, BFA, BGD, BGR, BHR, BHS, BIH, BLR, BLZ, BOL, BRA, BRB, BTN, BWA, CAF, CHL, CHN, CIV, CMR, COD, COG, COL, COM, CPV, CRI, DJI, DMA, DOM, DZA, ECU, EGY, ERI, ETH, FJI, FSM, GAB, GEO, GHA, GIN, GMB, GNB, GNQ, GRD, GTM, GUY, HND, HRV, HTI, IDN, IND, IRN, IRQ, JAM, JOR, KAZ, KEN, KGZ, KHM, KIR, KWT, LAO, LBN, LBR, LBY, LCA, LKA, LSO, MAR, MDA, MDG, MDV, MEX, MHL, MKD, MLI, MMR, MNE, MNG, MOZ, MRT, MUS, MWI, MYS, NAM, NER, NGA, NIC, NPL, NRU, OMN, PAK, PAN, PER, PHL, PLW, PNG, POL, PRY, PSE, QAT, ROU, RUS, RWA, SAU, SDN, SEN, SLB, SLE, SLV, SOM, SRB, SSD, STP, SUR, SWZ, SYC, SYR, TCD, TGO, THA, TJK, TLS, TON, TTO, TUN, TUR, TUV, TZA, UGA, UKR, URY, UZB, VCT, VNM, VUT, WSM, XKX, YEM, ZAF, ZMB, ZWE
#> 15 Afghanistan, Angola, Albania, United Arab Emirates, Argentina, Armenia, Azerbaijan, Burundi, Benin, Burkina Faso, Bangladesh, Bulgaria, Bahrain, Bahamas, The, Bosnia and Herzegovina, Belarus, Belize, Bolivia, Brazil, Barbados, Bhutan, Botswana, Central African Republic, Chile, China, Cote d'Ivoire, Cameroon, Congo, Dem. Rep., Congo, Rep., Colombia, Comoros, Cabo Verde, Costa Rica, Djibouti, Dominica, Dominican Republic, Algeria, Ecuador, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Micronesia, Fed. Sts., Gabon, Georgia, Ghana, Guinea, Gambia, The, Guinea-Bissau, Equatorial Guinea, Grenada, Guatemala, Guyana, Honduras, Croatia, Haiti, Indonesia, India, Iran, Islamic Rep., Iraq, Jamaica, Jordan, Kazakhstan, Kenya, Kyrgyz Republic, Cambodia, Kiribati, Kuwait, Lao PDR, Lebanon, Liberia, Libya, St. Lucia, Sri Lanka, Lesotho, Morocco, Moldova, Madagascar, Maldives, Mexico, Marshall Islands, North Macedonia, Mali, Myanmar, Montenegro, Mongolia, Mozambique, Mauritania, Mauritius, Malawi, Malaysia, Namibia, Niger, Nigeria, Nicaragua, Nepal, Nauru, Oman, Pakistan, Panama, Peru, Philippines, Palau, Papua New Guinea, Poland, Paraguay, West Bank and Gaza, Qatar, Romania, Russian Federation, Rwanda, Saudi Arabia, Sudan, Senegal, Solomon Islands, Sierra Leone, El Salvador, Somalia, Serbia, South Sudan, Sao Tome and Principe, Suriname, Eswatini, Seychelles, Syrian Arab Republic, Chad, Togo, Thailand, Tajikistan, Timor-Leste, Tonga, Trinidad and Tobago, Tunisia, Turkiye, Tuvalu, Tanzania, Uganda, Ukraine, Uruguay, Uzbekistan, St. Vincent and the Grenadines, Viet Nam, Vanuatu, Samoa, Kosovo, Yemen, Rep., South Africa, Zambia, Zimbabwe, AFG, AGO, ALB, ARE, ARG, ARM, AZE, BDI, BEN, BFA, BGD, BGR, BHR, BHS, BIH, BLR, BLZ, BOL, BRA, BRB, BTN, BWA, CAF, CHL, CHN, CIV, CMR, COD, COG, COL, COM, CPV, CRI, DJI, DMA, DOM, DZA, ECU, EGY, ERI, ETH, FJI, FSM, GAB, GEO, GHA, GIN, GMB, GNB, GNQ, GRD, GTM, GUY, HND, HRV, HTI, IDN, IND, IRN, IRQ, JAM, JOR, KAZ, KEN, KGZ, KHM, KIR, KWT, LAO, LBN, LBR, LBY, LCA, LKA, LSO, MAR, MDA, MDG, MDV, MEX, MHL, MKD, MLI, MMR, MNE, MNG, MOZ, MRT, MUS, MWI, MYS, NAM, NER, NGA, NIC, NPL, NRU, OMN, PAK, PAN, PER, PHL, PLW, PNG, POL, PRY, PSE, QAT, ROU, RUS, RWA, SAU, SDN, SEN, SLB, SLE, SLV, SOM, SRB, SSD, STP, SUR, SWZ, SYC, SYR, TCD, TGO, THA, TJK, TLS, TON, TTO, TUN, TUR, TUV, TZA, UGA, UKR, URY, UZB, VCT, VNM, VUT, WSM, XKX, YEM, ZAF, ZMB, ZWE
#> 16 Afghanistan, Angola, Albania, United Arab Emirates, Argentina, Armenia, Azerbaijan, Burundi, Benin, Burkina Faso, Bangladesh, Bulgaria, Bahrain, Bahamas, The, Bosnia and Herzegovina, Belarus, Belize, Bolivia, Brazil, Barbados, Bhutan, Botswana, Central African Republic, Chile, China, Cote d'Ivoire, Cameroon, Congo, Dem. Rep., Congo, Rep., Colombia, Comoros, Cabo Verde, Costa Rica, Djibouti, Dominica, Dominican Republic, Algeria, Ecuador, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Micronesia, Fed. Sts., Gabon, Georgia, Ghana, Guinea, Gambia, The, Guinea-Bissau, Equatorial Guinea, Grenada, Guatemala, Guyana, Honduras, Croatia, Haiti, Indonesia, India, Iran, Islamic Rep., Iraq, Jamaica, Jordan, Kazakhstan, Kenya, Kyrgyz Republic, Cambodia, Kiribati, Kuwait, Lao PDR, Lebanon, Liberia, Libya, St. Lucia, Sri Lanka, Lesotho, Morocco, Moldova, Madagascar, Maldives, Mexico, Marshall Islands, North Macedonia, Mali, Myanmar, Montenegro, Mongolia, Mozambique, Mauritania, Mauritius, Malawi, Malaysia, Namibia, Niger, Nigeria, Nicaragua, Nepal, Nauru, Oman, Pakistan, Panama, Peru, Philippines, Palau, Papua New Guinea, Poland, Paraguay, West Bank and Gaza, Qatar, Romania, Russian Federation, Rwanda, Saudi Arabia, Sudan, Senegal, Solomon Islands, Sierra Leone, El Salvador, Somalia, Serbia, South Sudan, Sao Tome and Principe, Suriname, Eswatini, Seychelles, Syrian Arab Republic, Chad, Togo, Thailand, Tajikistan, Timor-Leste, Tonga, Trinidad and Tobago, Tunisia, Turkiye, Tuvalu, Tanzania, Uganda, Ukraine, Uruguay, Uzbekistan, St. Vincent and the Grenadines, Viet Nam, Vanuatu, Samoa, Kosovo, Yemen, Rep., South Africa, Zambia, Zimbabwe, AFG, AGO, ALB, ARE, ARG, ARM, AZE, BDI, BEN, BFA, BGD, BGR, BHR, BHS, BIH, BLR, BLZ, BOL, BRA, BRB, BTN, BWA, CAF, CHL, CHN, CIV, CMR, COD, COG, COL, COM, CPV, CRI, DJI, DMA, DOM, DZA, ECU, EGY, ERI, ETH, FJI, FSM, GAB, GEO, GHA, GIN, GMB, GNB, GNQ, GRD, GTM, GUY, HND, HRV, HTI, IDN, IND, IRN, IRQ, JAM, JOR, KAZ, KEN, KGZ, KHM, KIR, KWT, LAO, LBN, LBR, LBY, LCA, LKA, LSO, MAR, MDA, MDG, MDV, MEX, MHL, MKD, MLI, MMR, MNE, MNG, MOZ, MRT, MUS, MWI, MYS, NAM, NER, NGA, NIC, NPL, NRU, OMN, PAK, PAN, PER, PHL, PLW, PNG, POL, PRY, PSE, QAT, ROU, RUS, RWA, SAU, SDN, SEN, SLB, SLE, SLV, SOM, SRB, SSD, STP, SUR, SWZ, SYC, SYR, TCD, TGO, THA, TJK, TLS, TON, TTO, TUN, TUR, TUV, TZA, UGA, UKR, URY, UZB, VCT, VNM, VUT, WSM, XKX, YEM, ZAF, ZMB, ZWE
#> 17 Afghanistan, Angola, Albania, United Arab Emirates, Argentina, Armenia, Azerbaijan, Burundi, Benin, Burkina Faso, Bangladesh, Bulgaria, Bahrain, Bahamas, The, Bosnia and Herzegovina, Belarus, Belize, Bolivia, Brazil, Barbados, Bhutan, Botswana, Central African Republic, Chile, China, Cote d'Ivoire, Cameroon, Congo, Dem. Rep., Congo, Rep., Colombia, Comoros, Cabo Verde, Costa Rica, Djibouti, Dominica, Dominican Republic, Algeria, Ecuador, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Micronesia, Fed. Sts., Gabon, Georgia, Ghana, Guinea, Gambia, The, Guinea-Bissau, Equatorial Guinea, Grenada, Guatemala, Guyana, Honduras, Croatia, Haiti, Indonesia, India, Iran, Islamic Rep., Iraq, Jamaica, Jordan, Kazakhstan, Kenya, Kyrgyz Republic, Cambodia, Kiribati, Kuwait, Lao PDR, Lebanon, Liberia, Libya, St. Lucia, Sri Lanka, Lesotho, Morocco, Moldova, Madagascar, Maldives, Mexico, Marshall Islands, North Macedonia, Mali, Myanmar, Montenegro, Mongolia, Mozambique, Mauritania, Mauritius, Malawi, Malaysia, Namibia, Niger, Nigeria, Nicaragua, Nepal, Nauru, Oman, Pakistan, Panama, Peru, Philippines, Palau, Papua New Guinea, Poland, Paraguay, West Bank and Gaza, Qatar, Romania, Russian Federation, Rwanda, Saudi Arabia, Sudan, Senegal, Solomon Islands, Sierra Leone, El Salvador, Somalia, Serbia, South Sudan, Sao Tome and Principe, Suriname, Eswatini, Seychelles, Syrian Arab Republic, Chad, Togo, Thailand, Tajikistan, Timor-Leste, Tonga, Trinidad and Tobago, Tunisia, Turkiye, Tuvalu, Tanzania, Uganda, Ukraine, Uruguay, Uzbekistan, St. Vincent and the Grenadines, Viet Nam, Vanuatu, Samoa, Kosovo, Yemen, Rep., South Africa, Zambia, Zimbabwe, AFG, AGO, ALB, ARE, ARG, ARM, AZE, BDI, BEN, BFA, BGD, BGR, BHR, BHS, BIH, BLR, BLZ, BOL, BRA, BRB, BTN, BWA, CAF, CHL, CHN, CIV, CMR, COD, COG, COL, COM, CPV, CRI, DJI, DMA, DOM, DZA, ECU, EGY, ERI, ETH, FJI, FSM, GAB, GEO, GHA, GIN, GMB, GNB, GNQ, GRD, GTM, GUY, HND, HRV, HTI, IDN, IND, IRN, IRQ, JAM, JOR, KAZ, KEN, KGZ, KHM, KIR, KWT, LAO, LBN, LBR, LBY, LCA, LKA, LSO, MAR, MDA, MDG, MDV, MEX, MHL, MKD, MLI, MMR, MNE, MNG, MOZ, MRT, MUS, MWI, MYS, NAM, NER, NGA, NIC, NPL, NRU, OMN, PAK, PAN, PER, PHL, PLW, PNG, POL, PRY, PSE, QAT, ROU, RUS, RWA, SAU, SDN, SEN, SLB, SLE, SLV, SOM, SRB, SSD, STP, SUR, SWZ, SYC, SYR, TCD, TGO, THA, TJK, TLS, TON, TTO, TUN, TUR, TUV, TZA, UGA, UKR, URY, UZB, VCT, VNM, VUT, WSM, XKX, YEM, ZAF, ZMB, ZWE
#> 18 Afghanistan, Angola, Albania, United Arab Emirates, Argentina, Armenia, Azerbaijan, Burundi, Benin, Burkina Faso, Bangladesh, Bulgaria, Bahrain, Bahamas, The, Bosnia and Herzegovina, Belarus, Belize, Bolivia, Brazil, Barbados, Bhutan, Botswana, Central African Republic, Chile, China, Cote d'Ivoire, Cameroon, Congo, Dem. Rep., Congo, Rep., Colombia, Comoros, Cabo Verde, Costa Rica, Djibouti, Dominica, Dominican Republic, Algeria, Ecuador, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Micronesia, Fed. Sts., Gabon, Georgia, Ghana, Guinea, Gambia, The, Guinea-Bissau, Equatorial Guinea, Grenada, Guatemala, Guyana, Honduras, Croatia, Haiti, Indonesia, India, Iran, Islamic Rep., Iraq, Jamaica, Jordan, Kazakhstan, Kenya, Kyrgyz Republic, Cambodia, Kiribati, Kuwait, Lao PDR, Lebanon, Liberia, Libya, St. Lucia, Sri Lanka, Lesotho, Morocco, Moldova, Madagascar, Maldives, Mexico, Marshall Islands, North Macedonia, Mali, Myanmar, Montenegro, Mongolia, Mozambique, Mauritania, Mauritius, Malawi, Malaysia, Namibia, Niger, Nigeria, Nicaragua, Nepal, Nauru, Oman, Pakistan, Panama, Peru, Philippines, Palau, Papua New Guinea, Poland, Paraguay, West Bank and Gaza, Qatar, Romania, Russian Federation, Rwanda, Saudi Arabia, Sudan, Senegal, Solomon Islands, Sierra Leone, El Salvador, Somalia, Serbia, South Sudan, Sao Tome and Principe, Suriname, Eswatini, Seychelles, Syrian Arab Republic, Chad, Togo, Thailand, Tajikistan, Timor-Leste, Tonga, Trinidad and Tobago, Tunisia, Turkiye, Tuvalu, Tanzania, Uganda, Ukraine, Uruguay, Uzbekistan, St. Vincent and the Grenadines, Viet Nam, Vanuatu, Samoa, Kosovo, Yemen, Rep., South Africa, Zambia, Zimbabwe, AFG, AGO, ALB, ARE, ARG, ARM, AZE, BDI, BEN, BFA, BGD, BGR, BHR, BHS, BIH, BLR, BLZ, BOL, BRA, BRB, BTN, BWA, CAF, CHL, CHN, CIV, CMR, COD, COG, COL, COM, CPV, CRI, DJI, DMA, DOM, DZA, ECU, EGY, ERI, ETH, FJI, FSM, GAB, GEO, GHA, GIN, GMB, GNB, GNQ, GRD, GTM, GUY, HND, HRV, HTI, IDN, IND, IRN, IRQ, JAM, JOR, KAZ, KEN, KGZ, KHM, KIR, KWT, LAO, LBN, LBR, LBY, LCA, LKA, LSO, MAR, MDA, MDG, MDV, MEX, MHL, MKD, MLI, MMR, MNE, MNG, MOZ, MRT, MUS, MWI, MYS, NAM, NER, NGA, NIC, NPL, NRU, OMN, PAK, PAN, PER, PHL, PLW, PNG, POL, PRY, PSE, QAT, ROU, RUS, RWA, SAU, SDN, SEN, SLB, SLE, SLV, SOM, SRB, SSD, STP, SUR, SWZ, SYC, SYR, TCD, TGO, THA, TJK, TLS, TON, TTO, TUN, TUR, TUV, TZA, UGA, UKR, URY, UZB, VCT, VNM, VUT, WSM, XKX, YEM, ZAF, ZMB, ZWE
#> 19 Afghanistan, Angola, Albania, United Arab Emirates, Argentina, Armenia, Azerbaijan, Burundi, Benin, Burkina Faso, Bangladesh, Bulgaria, Bahrain, Bahamas, The, Bosnia and Herzegovina, Belarus, Belize, Bolivia, Brazil, Barbados, Bhutan, Botswana, Central African Republic, Chile, China, Cote d'Ivoire, Cameroon, Congo, Dem. Rep., Congo, Rep., Colombia, Comoros, Cabo Verde, Costa Rica, Djibouti, Dominica, Dominican Republic, Algeria, Ecuador, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Micronesia, Fed. Sts., Gabon, Georgia, Ghana, Guinea, Gambia, The, Guinea-Bissau, Equatorial Guinea, Grenada, Guatemala, Guyana, Honduras, Croatia, Haiti, Indonesia, India, Iran, Islamic Rep., Iraq, Jamaica, Jordan, Kazakhstan, Kenya, Kyrgyz Republic, Cambodia, Kiribati, Kuwait, Lao PDR, Lebanon, Liberia, Libya, St. Lucia, Sri Lanka, Lesotho, Morocco, Moldova, Madagascar, Maldives, Mexico, Marshall Islands, North Macedonia, Mali, Myanmar, Montenegro, Mongolia, Mozambique, Mauritania, Mauritius, Malawi, Malaysia, Namibia, Niger, Nigeria, Nicaragua, Nepal, Nauru, Oman, Pakistan, Panama, Peru, Philippines, Palau, Papua New Guinea, Poland, Paraguay, West Bank and Gaza, Qatar, Romania, Russian Federation, Rwanda, Saudi Arabia, Sudan, Senegal, Solomon Islands, Sierra Leone, El Salvador, Somalia, Serbia, South Sudan, Sao Tome and Principe, Suriname, Eswatini, Seychelles, Syrian Arab Republic, Chad, Togo, Thailand, Tajikistan, Timor-Leste, Tonga, Trinidad and Tobago, Tunisia, Turkiye, Tuvalu, Tanzania, Uganda, Ukraine, Uruguay, Uzbekistan, St. Vincent and the Grenadines, Viet Nam, Vanuatu, Samoa, Kosovo, Yemen, Rep., South Africa, Zambia, Zimbabwe, AFG, AGO, ALB, ARE, ARG, ARM, AZE, BDI, BEN, BFA, BGD, BGR, BHR, BHS, BIH, BLR, BLZ, BOL, BRA, BRB, BTN, BWA, CAF, CHL, CHN, CIV, CMR, COD, COG, COL, COM, CPV, CRI, DJI, DMA, DOM, DZA, ECU, EGY, ERI, ETH, FJI, FSM, GAB, GEO, GHA, GIN, GMB, GNB, GNQ, GRD, GTM, GUY, HND, HRV, HTI, IDN, IND, IRN, IRQ, JAM, JOR, KAZ, KEN, KGZ, KHM, KIR, KWT, LAO, LBN, LBR, LBY, LCA, LKA, LSO, MAR, MDA, MDG, MDV, MEX, MHL, MKD, MLI, MMR, MNE, MNG, MOZ, MRT, MUS, MWI, MYS, NAM, NER, NGA, NIC, NPL, NRU, OMN, PAK, PAN, PER, PHL, PLW, PNG, POL, PRY, PSE, QAT, ROU, RUS, RWA, SAU, SDN, SEN, SLB, SLE, SLV, SOM, SRB, SSD, STP, SUR, SWZ, SYC, SYR, TCD, TGO, THA, TJK, TLS, TON, TTO, TUN, TUR, TUV, TZA, UGA, UKR, URY, UZB, VCT, VNM, VUT, WSM, XKX, YEM, ZAF, ZMB, ZWE
#> 20 Afghanistan, Angola, Albania, United Arab Emirates, Argentina, Armenia, Azerbaijan, Burundi, Benin, Burkina Faso, Bangladesh, Bulgaria, Bahrain, Bahamas, The, Bosnia and Herzegovina, Belarus, Belize, Bolivia, Brazil, Barbados, Bhutan, Botswana, Central African Republic, Chile, China, Cote d'Ivoire, Cameroon, Congo, Dem. Rep., Congo, Rep., Colombia, Comoros, Cabo Verde, Costa Rica, Djibouti, Dominica, Dominican Republic, Algeria, Ecuador, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Micronesia, Fed. Sts., Gabon, Georgia, Ghana, Guinea, Gambia, The, Guinea-Bissau, Equatorial Guinea, Grenada, Guatemala, Guyana, Honduras, Croatia, Haiti, Indonesia, India, Iran, Islamic Rep., Iraq, Jamaica, Jordan, Kazakhstan, Kenya, Kyrgyz Republic, Cambodia, Kiribati, Kuwait, Lao PDR, Lebanon, Liberia, Libya, St. Lucia, Sri Lanka, Lesotho, Morocco, Moldova, Madagascar, Maldives, Mexico, Marshall Islands, North Macedonia, Mali, Myanmar, Montenegro, Mongolia, Mozambique, Mauritania, Mauritius, Malawi, Malaysia, Namibia, Niger, Nigeria, Nicaragua, Nepal, Nauru, Oman, Pakistan, Panama, Peru, Philippines, Palau, Papua New Guinea, Poland, Paraguay, West Bank and Gaza, Qatar, Romania, Russian Federation, Rwanda, Saudi Arabia, Sudan, Senegal, Solomon Islands, Sierra Leone, El Salvador, Somalia, Serbia, South Sudan, Sao Tome and Principe, Suriname, Eswatini, Seychelles, Syrian Arab Republic, Chad, Togo, Thailand, Tajikistan, Timor-Leste, Tonga, Trinidad and Tobago, Tunisia, Turkiye, Tuvalu, Tanzania, Uganda, Ukraine, Uruguay, Uzbekistan, St. Vincent and the Grenadines, Viet Nam, Vanuatu, Samoa, Kosovo, Yemen, Rep., South Africa, Zambia, Zimbabwe, AFG, AGO, ALB, ARE, ARG, ARM, AZE, BDI, BEN, BFA, BGD, BGR, BHR, BHS, BIH, BLR, BLZ, BOL, BRA, BRB, BTN, BWA, CAF, CHL, CHN, CIV, CMR, COD, COG, COL, COM, CPV, CRI, DJI, DMA, DOM, DZA, ECU, EGY, ERI, ETH, FJI, FSM, GAB, GEO, GHA, GIN, GMB, GNB, GNQ, GRD, GTM, GUY, HND, HRV, HTI, IDN, IND, IRN, IRQ, JAM, JOR, KAZ, KEN, KGZ, KHM, KIR, KWT, LAO, LBN, LBR, LBY, LCA, LKA, LSO, MAR, MDA, MDG, MDV, MEX, MHL, MKD, MLI, MMR, MNE, MNG, MOZ, MRT, MUS, MWI, MYS, NAM, NER, NGA, NIC, NPL, NRU, OMN, PAK, PAN, PER, PHL, PLW, PNG, POL, PRY, PSE, QAT, ROU, RUS, RWA, SAU, SDN, SEN, SLB, SLE, SLV, SOM, SRB, SSD, STP, SUR, SWZ, SYC, SYR, TCD, TGO, THA, TJK, TLS, TON, TTO, TUN, TUR, TUV, TZA, UGA, UKR, URY, UZB, VCT, VNM, VUT, WSM, XKX, YEM, ZAF, ZMB, ZWE
#> 21 Afghanistan, Angola, Albania, United Arab Emirates, Argentina, Armenia, Azerbaijan, Burundi, Benin, Burkina Faso, Bangladesh, Bulgaria, Bahrain, Bahamas, The, Bosnia and Herzegovina, Belarus, Belize, Bolivia, Brazil, Barbados, Bhutan, Botswana, Central African Republic, Chile, China, Cote d'Ivoire, Cameroon, Congo, Dem. Rep., Congo, Rep., Colombia, Comoros, Cabo Verde, Costa Rica, Djibouti, Dominica, Dominican Republic, Algeria, Ecuador, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Micronesia, Fed. Sts., Gabon, Georgia, Ghana, Guinea, Gambia, The, Guinea-Bissau, Equatorial Guinea, Grenada, Guatemala, Guyana, Honduras, Croatia, Haiti, Indonesia, India, Iran, Islamic Rep., Iraq, Jamaica, Jordan, Kazakhstan, Kenya, Kyrgyz Republic, Cambodia, Kiribati, Kuwait, Lao PDR, Lebanon, Liberia, Libya, St. Lucia, Sri Lanka, Lesotho, Morocco, Moldova, Madagascar, Maldives, Mexico, Marshall Islands, North Macedonia, Mali, Myanmar, Montenegro, Mongolia, Mozambique, Mauritania, Mauritius, Malawi, Malaysia, Namibia, Niger, Nigeria, Nicaragua, Nepal, Nauru, Oman, Pakistan, Panama, Peru, Philippines, Palau, Papua New Guinea, Poland, Paraguay, West Bank and Gaza, Qatar, Romania, Russian Federation, Rwanda, Saudi Arabia, Sudan, Senegal, Solomon Islands, Sierra Leone, El Salvador, Somalia, Serbia, South Sudan, Sao Tome and Principe, Suriname, Eswatini, Seychelles, Syrian Arab Republic, Chad, Togo, Thailand, Tajikistan, Timor-Leste, Tonga, Trinidad and Tobago, Tunisia, Turkiye, Tuvalu, Tanzania, Uganda, Ukraine, Uruguay, Uzbekistan, St. Vincent and the Grenadines, Viet Nam, Vanuatu, Samoa, Kosovo, Yemen, Rep., South Africa, Zambia, Zimbabwe, AFG, AGO, ALB, ARE, ARG, ARM, AZE, BDI, BEN, BFA, BGD, BGR, BHR, BHS, BIH, BLR, BLZ, BOL, BRA, BRB, BTN, BWA, CAF, CHL, CHN, CIV, CMR, COD, COG, COL, COM, CPV, CRI, DJI, DMA, DOM, DZA, ECU, EGY, ERI, ETH, FJI, FSM, GAB, GEO, GHA, GIN, GMB, GNB, GNQ, GRD, GTM, GUY, HND, HRV, HTI, IDN, IND, IRN, IRQ, JAM, JOR, KAZ, KEN, KGZ, KHM, KIR, KWT, LAO, LBN, LBR, LBY, LCA, LKA, LSO, MAR, MDA, MDG, MDV, MEX, MHL, MKD, MLI, MMR, MNE, MNG, MOZ, MRT, MUS, MWI, MYS, NAM, NER, NGA, NIC, NPL, NRU, OMN, PAK, PAN, PER, PHL, PLW, PNG, POL, PRY, PSE, QAT, ROU, RUS, RWA, SAU, SDN, SEN, SLB, SLE, SLV, SOM, SRB, SSD, STP, SUR, SWZ, SYC, SYR, TCD, TGO, THA, TJK, TLS, TON, TTO, TUN, TUR, TUV, TZA, UGA, UKR, URY, UZB, VCT, VNM, VUT, WSM, XKX, YEM, ZAF, ZMB, ZWE
#> 22 Afghanistan, Angola, Albania, United Arab Emirates, Argentina, Armenia, Azerbaijan, Burundi, Benin, Burkina Faso, Bangladesh, Bulgaria, Bahrain, Bahamas, The, Bosnia and Herzegovina, Belarus, Belize, Bolivia, Brazil, Barbados, Bhutan, Botswana, Central African Republic, Chile, China, Cote d'Ivoire, Cameroon, Congo, Dem. Rep., Congo, Rep., Colombia, Comoros, Cabo Verde, Costa Rica, Djibouti, Dominica, Dominican Republic, Algeria, Ecuador, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Micronesia, Fed. Sts., Gabon, Georgia, Ghana, Guinea, Gambia, The, Guinea-Bissau, Equatorial Guinea, Grenada, Guatemala, Guyana, Honduras, Croatia, Haiti, Indonesia, India, Iran, Islamic Rep., Iraq, Jamaica, Jordan, Kazakhstan, Kenya, Kyrgyz Republic, Cambodia, Kiribati, Kuwait, Lao PDR, Lebanon, Liberia, Libya, St. Lucia, Sri Lanka, Lesotho, Morocco, Moldova, Madagascar, Maldives, Mexico, Marshall Islands, North Macedonia, Mali, Myanmar, Montenegro, Mongolia, Mozambique, Mauritania, Mauritius, Malawi, Malaysia, Namibia, Niger, Nigeria, Nicaragua, Nepal, Nauru, Oman, Pakistan, Panama, Peru, Philippines, Palau, Papua New Guinea, Poland, Paraguay, West Bank and Gaza, Qatar, Romania, Russian Federation, Rwanda, Saudi Arabia, Sudan, Senegal, Solomon Islands, Sierra Leone, El Salvador, Somalia, Serbia, South Sudan, Sao Tome and Principe, Suriname, Eswatini, Seychelles, Syrian Arab Republic, Chad, Togo, Thailand, Tajikistan, Timor-Leste, Tonga, Trinidad and Tobago, Tunisia, Turkiye, Tuvalu, Tanzania, Uganda, Ukraine, Uruguay, Uzbekistan, St. Vincent and the Grenadines, Viet Nam, Vanuatu, Samoa, Kosovo, Yemen, Rep., South Africa, Zambia, Zimbabwe, AFG, AGO, ALB, ARE, ARG, ARM, AZE, BDI, BEN, BFA, BGD, BGR, BHR, BHS, BIH, BLR, BLZ, BOL, BRA, BRB, BTN, BWA, CAF, CHL, CHN, CIV, CMR, COD, COG, COL, COM, CPV, CRI, DJI, DMA, DOM, DZA, ECU, EGY, ERI, ETH, FJI, FSM, GAB, GEO, GHA, GIN, GMB, GNB, GNQ, GRD, GTM, GUY, HND, HRV, HTI, IDN, IND, IRN, IRQ, JAM, JOR, KAZ, KEN, KGZ, KHM, KIR, KWT, LAO, LBN, LBR, LBY, LCA, LKA, LSO, MAR, MDA, MDG, MDV, MEX, MHL, MKD, MLI, MMR, MNE, MNG, MOZ, MRT, MUS, MWI, MYS, NAM, NER, NGA, NIC, NPL, NRU, OMN, PAK, PAN, PER, PHL, PLW, PNG, POL, PRY, PSE, QAT, ROU, RUS, RWA, SAU, SDN, SEN, SLB, SLE, SLV, SOM, SRB, SSD, STP, SUR, SWZ, SYC, SYR, TCD, TGO, THA, TJK, TLS, TON, TTO, TUN, TUR, TUV, TZA, UGA, UKR, URY, UZB, VCT, VNM, VUT, WSM, XKX, YEM, ZAF, ZMB, ZWE
#> 23 Afghanistan, Angola, Albania, United Arab Emirates, Argentina, Armenia, Azerbaijan, Burundi, Benin, Burkina Faso, Bangladesh, Bulgaria, Bahrain, Bahamas, The, Bosnia and Herzegovina, Belarus, Belize, Bolivia, Brazil, Barbados, Bhutan, Botswana, Central African Republic, Chile, China, Cote d'Ivoire, Cameroon, Congo, Dem. Rep., Congo, Rep., Colombia, Comoros, Cabo Verde, Costa Rica, Djibouti, Dominica, Dominican Republic, Algeria, Ecuador, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Micronesia, Fed. Sts., Gabon, Georgia, Ghana, Guinea, Gambia, The, Guinea-Bissau, Equatorial Guinea, Grenada, Guatemala, Guyana, Honduras, Croatia, Haiti, Indonesia, India, Iran, Islamic Rep., Iraq, Jamaica, Jordan, Kazakhstan, Kenya, Kyrgyz Republic, Cambodia, Kiribati, Kuwait, Lao PDR, Lebanon, Liberia, Libya, St. Lucia, Sri Lanka, Lesotho, Morocco, Moldova, Madagascar, Maldives, Mexico, Marshall Islands, North Macedonia, Mali, Myanmar, Montenegro, Mongolia, Mozambique, Mauritania, Mauritius, Malawi, Malaysia, Namibia, Niger, Nigeria, Nicaragua, Nepal, Nauru, Oman, Pakistan, Panama, Peru, Philippines, Palau, Papua New Guinea, Poland, Paraguay, West Bank and Gaza, Qatar, Romania, Russian Federation, Rwanda, Saudi Arabia, Sudan, Senegal, Solomon Islands, Sierra Leone, El Salvador, Somalia, Serbia, South Sudan, Sao Tome and Principe, Suriname, Eswatini, Seychelles, Syrian Arab Republic, Chad, Togo, Thailand, Tajikistan, Timor-Leste, Tonga, Trinidad and Tobago, Tunisia, Turkiye, Tuvalu, Tanzania, Uganda, Ukraine, Uruguay, Uzbekistan, St. Vincent and the Grenadines, Viet Nam, Vanuatu, Samoa, Kosovo, Yemen, Rep., South Africa, Zambia, Zimbabwe, AFG, AGO, ALB, ARE, ARG, ARM, AZE, BDI, BEN, BFA, BGD, BGR, BHR, BHS, BIH, BLR, BLZ, BOL, BRA, BRB, BTN, BWA, CAF, CHL, CHN, CIV, CMR, COD, COG, COL, COM, CPV, CRI, DJI, DMA, DOM, DZA, ECU, EGY, ERI, ETH, FJI, FSM, GAB, GEO, GHA, GIN, GMB, GNB, GNQ, GRD, GTM, GUY, HND, HRV, HTI, IDN, IND, IRN, IRQ, JAM, JOR, KAZ, KEN, KGZ, KHM, KIR, KWT, LAO, LBN, LBR, LBY, LCA, LKA, LSO, MAR, MDA, MDG, MDV, MEX, MHL, MKD, MLI, MMR, MNE, MNG, MOZ, MRT, MUS, MWI, MYS, NAM, NER, NGA, NIC, NPL, NRU, OMN, PAK, PAN, PER, PHL, PLW, PNG, POL, PRY, PSE, QAT, ROU, RUS, RWA, SAU, SDN, SEN, SLB, SLE, SLV, SOM, SRB, SSD, STP, SUR, SWZ, SYC, SYR, TCD, TGO, THA, TJK, TLS, TON, TTO, TUN, TUR, TUV, TZA, UGA, UKR, URY, UZB, VCT, VNM, VUT, WSM, XKX, YEM, ZAF, ZMB, ZWE
#> 24 Afghanistan, Angola, Albania, United Arab Emirates, Argentina, Armenia, Azerbaijan, Burundi, Benin, Burkina Faso, Bangladesh, Bulgaria, Bahrain, Bahamas, The, Bosnia and Herzegovina, Belarus, Belize, Bolivia, Brazil, Barbados, Bhutan, Botswana, Central African Republic, Chile, China, Cote d'Ivoire, Cameroon, Congo, Dem. Rep., Congo, Rep., Colombia, Comoros, Cabo Verde, Costa Rica, Djibouti, Dominica, Dominican Republic, Algeria, Ecuador, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Micronesia, Fed. Sts., Gabon, Georgia, Ghana, Guinea, Gambia, The, Guinea-Bissau, Equatorial Guinea, Grenada, Guatemala, Guyana, Honduras, Croatia, Haiti, Indonesia, India, Iran, Islamic Rep., Iraq, Jamaica, Jordan, Kazakhstan, Kenya, Kyrgyz Republic, Cambodia, Kiribati, Kuwait, Lao PDR, Lebanon, Liberia, Libya, St. Lucia, Sri Lanka, Lesotho, Morocco, Moldova, Madagascar, Maldives, Mexico, Marshall Islands, North Macedonia, Mali, Myanmar, Montenegro, Mongolia, Mozambique, Mauritania, Mauritius, Malawi, Malaysia, Namibia, Niger, Nigeria, Nicaragua, Nepal, Nauru, Oman, Pakistan, Panama, Peru, Philippines, Palau, Papua New Guinea, Poland, Paraguay, West Bank and Gaza, Qatar, Romania, Russian Federation, Rwanda, Saudi Arabia, Sudan, Senegal, Solomon Islands, Sierra Leone, El Salvador, Somalia, Serbia, South Sudan, Sao Tome and Principe, Suriname, Eswatini, Seychelles, Syrian Arab Republic, Chad, Togo, Thailand, Tajikistan, Timor-Leste, Tonga, Trinidad and Tobago, Tunisia, Turkiye, Tuvalu, Tanzania, Uganda, Ukraine, Uruguay, Uzbekistan, St. Vincent and the Grenadines, Viet Nam, Vanuatu, Samoa, Kosovo, Yemen, Rep., South Africa, Zambia, Zimbabwe, AFG, AGO, ALB, ARE, ARG, ARM, AZE, BDI, BEN, BFA, BGD, BGR, BHR, BHS, BIH, BLR, BLZ, BOL, BRA, BRB, BTN, BWA, CAF, CHL, CHN, CIV, CMR, COD, COG, COL, COM, CPV, CRI, DJI, DMA, DOM, DZA, ECU, EGY, ERI, ETH, FJI, FSM, GAB, GEO, GHA, GIN, GMB, GNB, GNQ, GRD, GTM, GUY, HND, HRV, HTI, IDN, IND, IRN, IRQ, JAM, JOR, KAZ, KEN, KGZ, KHM, KIR, KWT, LAO, LBN, LBR, LBY, LCA, LKA, LSO, MAR, MDA, MDG, MDV, MEX, MHL, MKD, MLI, MMR, MNE, MNG, MOZ, MRT, MUS, MWI, MYS, NAM, NER, NGA, NIC, NPL, NRU, OMN, PAK, PAN, PER, PHL, PLW, PNG, POL, PRY, PSE, QAT, ROU, RUS, RWA, SAU, SDN, SEN, SLB, SLE, SLV, SOM, SRB, SSD, STP, SUR, SWZ, SYC, SYR, TCD, TGO, THA, TJK, TLS, TON, TTO, TUN, TUR, TUV, TZA, UGA, UKR, URY, UZB, VCT, VNM, VUT, WSM, XKX, YEM, ZAF, ZMB, ZWE
#> 25 Afghanistan, Angola, Albania, United Arab Emirates, Argentina, Armenia, Azerbaijan, Burundi, Benin, Burkina Faso, Bangladesh, Bulgaria, Bahrain, Bahamas, The, Bosnia and Herzegovina, Belarus, Belize, Bolivia, Brazil, Barbados, Bhutan, Botswana, Central African Republic, Chile, China, Cote d'Ivoire, Cameroon, Congo, Dem. Rep., Congo, Rep., Colombia, Comoros, Cabo Verde, Costa Rica, Djibouti, Dominica, Dominican Republic, Algeria, Ecuador, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Micronesia, Fed. Sts., Gabon, Georgia, Ghana, Guinea, Gambia, The, Guinea-Bissau, Equatorial Guinea, Grenada, Guatemala, Guyana, Honduras, Croatia, Haiti, Indonesia, India, Iran, Islamic Rep., Iraq, Jamaica, Jordan, Kazakhstan, Kenya, Kyrgyz Republic, Cambodia, Kiribati, Kuwait, Lao PDR, Lebanon, Liberia, Libya, St. Lucia, Sri Lanka, Lesotho, Morocco, Moldova, Madagascar, Maldives, Mexico, Marshall Islands, North Macedonia, Mali, Myanmar, Montenegro, Mongolia, Mozambique, Mauritania, Mauritius, Malawi, Malaysia, Namibia, Niger, Nigeria, Nicaragua, Nepal, Nauru, Oman, Pakistan, Panama, Peru, Philippines, Palau, Papua New Guinea, Poland, Paraguay, West Bank and Gaza, Qatar, Romania, Russian Federation, Rwanda, Saudi Arabia, Sudan, Senegal, Solomon Islands, Sierra Leone, El Salvador, Somalia, Serbia, South Sudan, Sao Tome and Principe, Suriname, Eswatini, Seychelles, Syrian Arab Republic, Chad, Togo, Thailand, Tajikistan, Timor-Leste, Tonga, Trinidad and Tobago, Tunisia, Turkiye, Tuvalu, Tanzania, Uganda, Ukraine, Uruguay, Uzbekistan, St. Vincent and the Grenadines, Viet Nam, Vanuatu, Samoa, Kosovo, Yemen, Rep., South Africa, Zambia, Zimbabwe, AFG, AGO, ALB, ARE, ARG, ARM, AZE, BDI, BEN, BFA, BGD, BGR, BHR, BHS, BIH, BLR, BLZ, BOL, BRA, BRB, BTN, BWA, CAF, CHL, CHN, CIV, CMR, COD, COG, COL, COM, CPV, CRI, DJI, DMA, DOM, DZA, ECU, EGY, ERI, ETH, FJI, FSM, GAB, GEO, GHA, GIN, GMB, GNB, GNQ, GRD, GTM, GUY, HND, HRV, HTI, IDN, IND, IRN, IRQ, JAM, JOR, KAZ, KEN, KGZ, KHM, KIR, KWT, LAO, LBN, LBR, LBY, LCA, LKA, LSO, MAR, MDA, MDG, MDV, MEX, MHL, MKD, MLI, MMR, MNE, MNG, MOZ, MRT, MUS, MWI, MYS, NAM, NER, NGA, NIC, NPL, NRU, OMN, PAK, PAN, PER, PHL, PLW, PNG, POL, PRY, PSE, QAT, ROU, RUS, RWA, SAU, SDN, SEN, SLB, SLE, SLV, SOM, SRB, SSD, STP, SUR, SWZ, SYC, SYR, TCD, TGO, THA, TJK, TLS, TON, TTO, TUN, TUR, TUV, TZA, UGA, UKR, URY, UZB, VCT, VNM, VUT, WSM, XKX, YEM, ZAF, ZMB, ZWE
#> 26 Afghanistan, Angola, Albania, United Arab Emirates, Argentina, Armenia, Azerbaijan, Burundi, Benin, Burkina Faso, Bangladesh, Bulgaria, Bahrain, Bahamas, The, Bosnia and Herzegovina, Belarus, Belize, Bolivia, Brazil, Barbados, Bhutan, Botswana, Central African Republic, Chile, China, Cote d'Ivoire, Cameroon, Congo, Dem. Rep., Congo, Rep., Colombia, Comoros, Cabo Verde, Costa Rica, Djibouti, Dominica, Dominican Republic, Algeria, Ecuador, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Micronesia, Fed. Sts., Gabon, Georgia, Ghana, Guinea, Gambia, The, Guinea-Bissau, Equatorial Guinea, Grenada, Guatemala, Guyana, Honduras, Croatia, Haiti, Indonesia, India, Iran, Islamic Rep., Iraq, Jamaica, Jordan, Kazakhstan, Kenya, Kyrgyz Republic, Cambodia, Kiribati, Kuwait, Lao PDR, Lebanon, Liberia, Libya, St. Lucia, Sri Lanka, Lesotho, Morocco, Moldova, Madagascar, Maldives, Mexico, Marshall Islands, North Macedonia, Mali, Myanmar, Montenegro, Mongolia, Mozambique, Mauritania, Mauritius, Malawi, Malaysia, Namibia, Niger, Nigeria, Nicaragua, Nepal, Nauru, Oman, Pakistan, Panama, Peru, Philippines, Palau, Papua New Guinea, Poland, Paraguay, West Bank and Gaza, Qatar, Romania, Russian Federation, Rwanda, Saudi Arabia, Sudan, Senegal, Solomon Islands, Sierra Leone, El Salvador, Somalia, Serbia, South Sudan, Sao Tome and Principe, Suriname, Eswatini, Seychelles, Syrian Arab Republic, Chad, Togo, Thailand, Tajikistan, Timor-Leste, Tonga, Trinidad and Tobago, Tunisia, Turkiye, Tuvalu, Tanzania, Uganda, Ukraine, Uruguay, Uzbekistan, St. Vincent and the Grenadines, Viet Nam, Vanuatu, Samoa, Kosovo, Yemen, Rep., South Africa, Zambia, Zimbabwe, AFG, AGO, ALB, ARE, ARG, ARM, AZE, BDI, BEN, BFA, BGD, BGR, BHR, BHS, BIH, BLR, BLZ, BOL, BRA, BRB, BTN, BWA, CAF, CHL, CHN, CIV, CMR, COD, COG, COL, COM, CPV, CRI, DJI, DMA, DOM, DZA, ECU, EGY, ERI, ETH, FJI, FSM, GAB, GEO, GHA, GIN, GMB, GNB, GNQ, GRD, GTM, GUY, HND, HRV, HTI, IDN, IND, IRN, IRQ, JAM, JOR, KAZ, KEN, KGZ, KHM, KIR, KWT, LAO, LBN, LBR, LBY, LCA, LKA, LSO, MAR, MDA, MDG, MDV, MEX, MHL, MKD, MLI, MMR, MNE, MNG, MOZ, MRT, MUS, MWI, MYS, NAM, NER, NGA, NIC, NPL, NRU, OMN, PAK, PAN, PER, PHL, PLW, PNG, POL, PRY, PSE, QAT, ROU, RUS, RWA, SAU, SDN, SEN, SLB, SLE, SLV, SOM, SRB, SSD, STP, SUR, SWZ, SYC, SYR, TCD, TGO, THA, TJK, TLS, TON, TTO, TUN, TUR, TUV, TZA, UGA, UKR, URY, UZB, VCT, VNM, VUT, WSM, XKX, YEM, ZAF, ZMB, ZWE
#> 27 Afghanistan, Angola, Albania, United Arab Emirates, Argentina, Armenia, Azerbaijan, Burundi, Benin, Burkina Faso, Bangladesh, Bulgaria, Bahrain, Bahamas, The, Bosnia and Herzegovina, Belarus, Belize, Bolivia, Brazil, Barbados, Bhutan, Botswana, Central African Republic, Chile, China, Cote d'Ivoire, Cameroon, Congo, Dem. Rep., Congo, Rep., Colombia, Comoros, Cabo Verde, Costa Rica, Djibouti, Dominica, Dominican Republic, Algeria, Ecuador, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Micronesia, Fed. Sts., Gabon, Georgia, Ghana, Guinea, Gambia, The, Guinea-Bissau, Equatorial Guinea, Grenada, Guatemala, Guyana, Honduras, Croatia, Haiti, Indonesia, India, Iran, Islamic Rep., Iraq, Jamaica, Jordan, Kazakhstan, Kenya, Kyrgyz Republic, Cambodia, Kiribati, Kuwait, Lao PDR, Lebanon, Liberia, Libya, St. Lucia, Sri Lanka, Lesotho, Morocco, Moldova, Madagascar, Maldives, Mexico, Marshall Islands, North Macedonia, Mali, Myanmar, Montenegro, Mongolia, Mozambique, Mauritania, Mauritius, Malawi, Malaysia, Namibia, Niger, Nigeria, Nicaragua, Nepal, Nauru, Oman, Pakistan, Panama, Peru, Philippines, Palau, Papua New Guinea, Poland, Paraguay, West Bank and Gaza, Qatar, Romania, Russian Federation, Rwanda, Saudi Arabia, Sudan, Senegal, Solomon Islands, Sierra Leone, El Salvador, Somalia, Serbia, South Sudan, Sao Tome and Principe, Suriname, Eswatini, Seychelles, Syrian Arab Republic, Chad, Togo, Thailand, Tajikistan, Timor-Leste, Tonga, Trinidad and Tobago, Tunisia, Turkiye, Tuvalu, Tanzania, Uganda, Ukraine, Uruguay, Uzbekistan, St. Vincent and the Grenadines, Viet Nam, Vanuatu, Samoa, Kosovo, Yemen, Rep., South Africa, Zambia, Zimbabwe, AFG, AGO, ALB, ARE, ARG, ARM, AZE, BDI, BEN, BFA, BGD, BGR, BHR, BHS, BIH, BLR, BLZ, BOL, BRA, BRB, BTN, BWA, CAF, CHL, CHN, CIV, CMR, COD, COG, COL, COM, CPV, CRI, DJI, DMA, DOM, DZA, ECU, EGY, ERI, ETH, FJI, FSM, GAB, GEO, GHA, GIN, GMB, GNB, GNQ, GRD, GTM, GUY, HND, HRV, HTI, IDN, IND, IRN, IRQ, JAM, JOR, KAZ, KEN, KGZ, KHM, KIR, KWT, LAO, LBN, LBR, LBY, LCA, LKA, LSO, MAR, MDA, MDG, MDV, MEX, MHL, MKD, MLI, MMR, MNE, MNG, MOZ, MRT, MUS, MWI, MYS, NAM, NER, NGA, NIC, NPL, NRU, OMN, PAK, PAN, PER, PHL, PLW, PNG, POL, PRY, PSE, QAT, ROU, RUS, RWA, SAU, SDN, SEN, SLB, SLE, SLV, SOM, SRB, SSD, STP, SUR, SWZ, SYC, SYR, TCD, TGO, THA, TJK, TLS, TON, TTO, TUN, TUR, TUV, TZA, UGA, UKR, URY, UZB, VCT, VNM, VUT, WSM, XKX, YEM, ZAF, ZMB, ZWE
#> 28 Afghanistan, Angola, Albania, United Arab Emirates, Argentina, Armenia, Azerbaijan, Burundi, Benin, Burkina Faso, Bangladesh, Bulgaria, Bahrain, Bahamas, The, Bosnia and Herzegovina, Belarus, Belize, Bolivia, Brazil, Barbados, Bhutan, Botswana, Central African Republic, Chile, China, Cote d'Ivoire, Cameroon, Congo, Dem. Rep., Congo, Rep., Colombia, Comoros, Cabo Verde, Costa Rica, Djibouti, Dominica, Dominican Republic, Algeria, Ecuador, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Micronesia, Fed. Sts., Gabon, Georgia, Ghana, Guinea, Gambia, The, Guinea-Bissau, Equatorial Guinea, Grenada, Guatemala, Guyana, Honduras, Croatia, Haiti, Indonesia, India, Iran, Islamic Rep., Iraq, Jamaica, Jordan, Kazakhstan, Kenya, Kyrgyz Republic, Cambodia, Kiribati, Kuwait, Lao PDR, Lebanon, Liberia, Libya, St. Lucia, Sri Lanka, Lesotho, Morocco, Moldova, Madagascar, Maldives, Mexico, Marshall Islands, North Macedonia, Mali, Myanmar, Montenegro, Mongolia, Mozambique, Mauritania, Mauritius, Malawi, Malaysia, Namibia, Niger, Nigeria, Nicaragua, Nepal, Nauru, Oman, Pakistan, Panama, Peru, Philippines, Palau, Papua New Guinea, Poland, Paraguay, West Bank and Gaza, Qatar, Romania, Russian Federation, Rwanda, Saudi Arabia, Sudan, Senegal, Solomon Islands, Sierra Leone, El Salvador, Somalia, Serbia, South Sudan, Sao Tome and Principe, Suriname, Eswatini, Seychelles, Syrian Arab Republic, Chad, Togo, Thailand, Tajikistan, Timor-Leste, Tonga, Trinidad and Tobago, Tunisia, Turkiye, Tuvalu, Tanzania, Uganda, Ukraine, Uruguay, Uzbekistan, St. Vincent and the Grenadines, Viet Nam, Vanuatu, Samoa, Kosovo, Yemen, Rep., South Africa, Zambia, Zimbabwe, AFG, AGO, ALB, ARE, ARG, ARM, AZE, BDI, BEN, BFA, BGD, BGR, BHR, BHS, BIH, BLR, BLZ, BOL, BRA, BRB, BTN, BWA, CAF, CHL, CHN, CIV, CMR, COD, COG, COL, COM, CPV, CRI, DJI, DMA, DOM, DZA, ECU, EGY, ERI, ETH, FJI, FSM, GAB, GEO, GHA, GIN, GMB, GNB, GNQ, GRD, GTM, GUY, HND, HRV, HTI, IDN, IND, IRN, IRQ, JAM, JOR, KAZ, KEN, KGZ, KHM, KIR, KWT, LAO, LBN, LBR, LBY, LCA, LKA, LSO, MAR, MDA, MDG, MDV, MEX, MHL, MKD, MLI, MMR, MNE, MNG, MOZ, MRT, MUS, MWI, MYS, NAM, NER, NGA, NIC, NPL, NRU, OMN, PAK, PAN, PER, PHL, PLW, PNG, POL, PRY, PSE, QAT, ROU, RUS, RWA, SAU, SDN, SEN, SLB, SLE, SLV, SOM, SRB, SSD, STP, SUR, SWZ, SYC, SYR, TCD, TGO, THA, TJK, TLS, TON, TTO, TUN, TUR, TUV, TZA, UGA, UKR, URY, UZB, VCT, VNM, VUT, WSM, XKX, YEM, ZAF, ZMB, ZWE
#> 29 Afghanistan, Angola, Albania, United Arab Emirates, Argentina, Armenia, Azerbaijan, Burundi, Benin, Burkina Faso, Bangladesh, Bulgaria, Bahrain, Bahamas, The, Bosnia and Herzegovina, Belarus, Belize, Bolivia, Brazil, Barbados, Bhutan, Botswana, Central African Republic, Chile, China, Cote d'Ivoire, Cameroon, Congo, Dem. Rep., Congo, Rep., Colombia, Comoros, Cabo Verde, Costa Rica, Djibouti, Dominica, Dominican Republic, Algeria, Ecuador, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Micronesia, Fed. Sts., Gabon, Georgia, Ghana, Guinea, Gambia, The, Guinea-Bissau, Equatorial Guinea, Grenada, Guatemala, Guyana, Honduras, Croatia, Haiti, Indonesia, India, Iran, Islamic Rep., Iraq, Jamaica, Jordan, Kazakhstan, Kenya, Kyrgyz Republic, Cambodia, Kiribati, Kuwait, Lao PDR, Lebanon, Liberia, Libya, St. Lucia, Sri Lanka, Lesotho, Morocco, Moldova, Madagascar, Maldives, Mexico, Marshall Islands, North Macedonia, Mali, Myanmar, Montenegro, Mongolia, Mozambique, Mauritania, Mauritius, Malawi, Malaysia, Namibia, Niger, Nigeria, Nicaragua, Nepal, Nauru, Oman, Pakistan, Panama, Peru, Philippines, Palau, Papua New Guinea, Poland, Paraguay, West Bank and Gaza, Qatar, Romania, Russian Federation, Rwanda, Saudi Arabia, Sudan, Senegal, Solomon Islands, Sierra Leone, El Salvador, Somalia, Serbia, South Sudan, Sao Tome and Principe, Suriname, Eswatini, Seychelles, Syrian Arab Republic, Chad, Togo, Thailand, Tajikistan, Timor-Leste, Tonga, Trinidad and Tobago, Tunisia, Turkiye, Tuvalu, Tanzania, Uganda, Ukraine, Uruguay, Uzbekistan, St. Vincent and the Grenadines, Viet Nam, Vanuatu, Samoa, Kosovo, Yemen, Rep., South Africa, Zambia, Zimbabwe, AFG, AGO, ALB, ARE, ARG, ARM, AZE, BDI, BEN, BFA, BGD, BGR, BHR, BHS, BIH, BLR, BLZ, BOL, BRA, BRB, BTN, BWA, CAF, CHL, CHN, CIV, CMR, COD, COG, COL, COM, CPV, CRI, DJI, DMA, DOM, DZA, ECU, EGY, ERI, ETH, FJI, FSM, GAB, GEO, GHA, GIN, GMB, GNB, GNQ, GRD, GTM, GUY, HND, HRV, HTI, IDN, IND, IRN, IRQ, JAM, JOR, KAZ, KEN, KGZ, KHM, KIR, KWT, LAO, LBN, LBR, LBY, LCA, LKA, LSO, MAR, MDA, MDG, MDV, MEX, MHL, MKD, MLI, MMR, MNE, MNG, MOZ, MRT, MUS, MWI, MYS, NAM, NER, NGA, NIC, NPL, NRU, OMN, PAK, PAN, PER, PHL, PLW, PNG, POL, PRY, PSE, QAT, ROU, RUS, RWA, SAU, SDN, SEN, SLB, SLE, SLV, SOM, SRB, SSD, STP, SUR, SWZ, SYC, SYR, TCD, TGO, THA, TJK, TLS, TON, TTO, TUN, TUR, TUV, TZA, UGA, UKR, URY, UZB, VCT, VNM, VUT, WSM, XKX, YEM, ZAF, ZMB, ZWE
#> 30 Afghanistan, Angola, Albania, United Arab Emirates, Argentina, Armenia, Azerbaijan, Burundi, Benin, Burkina Faso, Bangladesh, Bulgaria, Bahrain, Bahamas, The, Bosnia and Herzegovina, Belarus, Belize, Bolivia, Brazil, Barbados, Bhutan, Botswana, Central African Republic, Chile, China, Cote d'Ivoire, Cameroon, Congo, Dem. Rep., Congo, Rep., Colombia, Comoros, Cabo Verde, Costa Rica, Djibouti, Dominica, Dominican Republic, Algeria, Ecuador, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Micronesia, Fed. Sts., Gabon, Georgia, Ghana, Guinea, Gambia, The, Guinea-Bissau, Equatorial Guinea, Grenada, Guatemala, Guyana, Honduras, Croatia, Haiti, Indonesia, India, Iran, Islamic Rep., Iraq, Jamaica, Jordan, Kazakhstan, Kenya, Kyrgyz Republic, Cambodia, Kiribati, Kuwait, Lao PDR, Lebanon, Liberia, Libya, St. Lucia, Sri Lanka, Lesotho, Morocco, Moldova, Madagascar, Maldives, Mexico, Marshall Islands, North Macedonia, Mali, Myanmar, Montenegro, Mongolia, Mozambique, Mauritania, Mauritius, Malawi, Malaysia, Namibia, Niger, Nigeria, Nicaragua, Nepal, Nauru, Oman, Pakistan, Panama, Peru, Philippines, Palau, Papua New Guinea, Poland, Paraguay, West Bank and Gaza, Qatar, Romania, Russian Federation, Rwanda, Saudi Arabia, Sudan, Senegal, Solomon Islands, Sierra Leone, El Salvador, Somalia, Serbia, South Sudan, Sao Tome and Principe, Suriname, Eswatini, Seychelles, Syrian Arab Republic, Chad, Togo, Thailand, Tajikistan, Timor-Leste, Tonga, Trinidad and Tobago, Tunisia, Turkiye, Tuvalu, Tanzania, Uganda, Ukraine, Uruguay, Uzbekistan, St. Vincent and the Grenadines, Viet Nam, Vanuatu, Samoa, Kosovo, Yemen, Rep., South Africa, Zambia, Zimbabwe, AFG, AGO, ALB, ARE, ARG, ARM, AZE, BDI, BEN, BFA, BGD, BGR, BHR, BHS, BIH, BLR, BLZ, BOL, BRA, BRB, BTN, BWA, CAF, CHL, CHN, CIV, CMR, COD, COG, COL, COM, CPV, CRI, DJI, DMA, DOM, DZA, ECU, EGY, ERI, ETH, FJI, FSM, GAB, GEO, GHA, GIN, GMB, GNB, GNQ, GRD, GTM, GUY, HND, HRV, HTI, IDN, IND, IRN, IRQ, JAM, JOR, KAZ, KEN, KGZ, KHM, KIR, KWT, LAO, LBN, LBR, LBY, LCA, LKA, LSO, MAR, MDA, MDG, MDV, MEX, MHL, MKD, MLI, MMR, MNE, MNG, MOZ, MRT, MUS, MWI, MYS, NAM, NER, NGA, NIC, NPL, NRU, OMN, PAK, PAN, PER, PHL, PLW, PNG, POL, PRY, PSE, QAT, ROU, RUS, RWA, SAU, SDN, SEN, SLB, SLE, SLV, SOM, SRB, SSD, STP, SUR, SWZ, SYC, SYR, TCD, TGO, THA, TJK, TLS, TON, TTO, TUN, TUR, TUV, TZA, UGA, UKR, URY, UZB, VCT, VNM, VUT, WSM, XKX, YEM, ZAF, ZMB, ZWE
#> 31 Afghanistan, Angola, Albania, United Arab Emirates, Argentina, Armenia, Azerbaijan, Burundi, Benin, Burkina Faso, Bangladesh, Bulgaria, Bahrain, Bahamas, The, Bosnia and Herzegovina, Belarus, Belize, Bolivia, Brazil, Barbados, Bhutan, Botswana, Central African Republic, Chile, China, Cote d'Ivoire, Cameroon, Congo, Dem. Rep., Congo, Rep., Colombia, Comoros, Cabo Verde, Costa Rica, Djibouti, Dominica, Dominican Republic, Algeria, Ecuador, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Micronesia, Fed. Sts., Gabon, Georgia, Ghana, Guinea, Gambia, The, Guinea-Bissau, Equatorial Guinea, Grenada, Guatemala, Guyana, Honduras, Croatia, Haiti, Indonesia, India, Iran, Islamic Rep., Iraq, Jamaica, Jordan, Kazakhstan, Kenya, Kyrgyz Republic, Cambodia, Kiribati, Kuwait, Lao PDR, Lebanon, Liberia, Libya, St. Lucia, Sri Lanka, Lesotho, Morocco, Moldova, Madagascar, Maldives, Mexico, Marshall Islands, North Macedonia, Mali, Myanmar, Montenegro, Mongolia, Mozambique, Mauritania, Mauritius, Malawi, Malaysia, Namibia, Niger, Nigeria, Nicaragua, Nepal, Nauru, Oman, Pakistan, Panama, Peru, Philippines, Palau, Papua New Guinea, Poland, Paraguay, West Bank and Gaza, Qatar, Romania, Russian Federation, Rwanda, Saudi Arabia, Sudan, Senegal, Solomon Islands, Sierra Leone, El Salvador, Somalia, Serbia, South Sudan, Sao Tome and Principe, Suriname, Eswatini, Seychelles, Syrian Arab Republic, Chad, Togo, Thailand, Tajikistan, Timor-Leste, Tonga, Trinidad and Tobago, Tunisia, Turkiye, Tuvalu, Tanzania, Uganda, Ukraine, Uruguay, Uzbekistan, St. Vincent and the Grenadines, Viet Nam, Vanuatu, Samoa, Kosovo, Yemen, Rep., South Africa, Zambia, Zimbabwe, AFG, AGO, ALB, ARE, ARG, ARM, AZE, BDI, BEN, BFA, BGD, BGR, BHR, BHS, BIH, BLR, BLZ, BOL, BRA, BRB, BTN, BWA, CAF, CHL, CHN, CIV, CMR, COD, COG, COL, COM, CPV, CRI, DJI, DMA, DOM, DZA, ECU, EGY, ERI, ETH, FJI, FSM, GAB, GEO, GHA, GIN, GMB, GNB, GNQ, GRD, GTM, GUY, HND, HRV, HTI, IDN, IND, IRN, IRQ, JAM, JOR, KAZ, KEN, KGZ, KHM, KIR, KWT, LAO, LBN, LBR, LBY, LCA, LKA, LSO, MAR, MDA, MDG, MDV, MEX, MHL, MKD, MLI, MMR, MNE, MNG, MOZ, MRT, MUS, MWI, MYS, NAM, NER, NGA, NIC, NPL, NRU, OMN, PAK, PAN, PER, PHL, PLW, PNG, POL, PRY, PSE, QAT, ROU, RUS, RWA, SAU, SDN, SEN, SLB, SLE, SLV, SOM, SRB, SSD, STP, SUR, SWZ, SYC, SYR, TCD, TGO, THA, TJK, TLS, TON, TTO, TUN, TUR, TUV, TZA, UGA, UKR, URY, UZB, VCT, VNM, VUT, WSM, XKX, YEM, ZAF, ZMB, ZWE
#> 32 Afghanistan, Angola, Albania, United Arab Emirates, Argentina, Armenia, Azerbaijan, Burundi, Benin, Burkina Faso, Bangladesh, Bulgaria, Bahrain, Bahamas, The, Bosnia and Herzegovina, Belarus, Belize, Bolivia, Brazil, Barbados, Bhutan, Botswana, Central African Republic, Chile, China, Cote d'Ivoire, Cameroon, Congo, Dem. Rep., Congo, Rep., Colombia, Comoros, Cabo Verde, Costa Rica, Djibouti, Dominica, Dominican Republic, Algeria, Ecuador, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Micronesia, Fed. Sts., Gabon, Georgia, Ghana, Guinea, Gambia, The, Guinea-Bissau, Equatorial Guinea, Grenada, Guatemala, Guyana, Honduras, Croatia, Haiti, Indonesia, India, Iran, Islamic Rep., Iraq, Jamaica, Jordan, Kazakhstan, Kenya, Kyrgyz Republic, Cambodia, Kiribati, Kuwait, Lao PDR, Lebanon, Liberia, Libya, St. Lucia, Sri Lanka, Lesotho, Morocco, Moldova, Madagascar, Maldives, Mexico, Marshall Islands, North Macedonia, Mali, Myanmar, Montenegro, Mongolia, Mozambique, Mauritania, Mauritius, Malawi, Malaysia, Namibia, Niger, Nigeria, Nicaragua, Nepal, Nauru, Oman, Pakistan, Panama, Peru, Philippines, Palau, Papua New Guinea, Poland, Paraguay, West Bank and Gaza, Qatar, Romania, Russian Federation, Rwanda, Saudi Arabia, Sudan, Senegal, Solomon Islands, Sierra Leone, El Salvador, Somalia, Serbia, South Sudan, Sao Tome and Principe, Suriname, Eswatini, Seychelles, Syrian Arab Republic, Chad, Togo, Thailand, Tajikistan, Timor-Leste, Tonga, Trinidad and Tobago, Tunisia, Turkiye, Tuvalu, Tanzania, Uganda, Ukraine, Uruguay, Uzbekistan, St. Vincent and the Grenadines, Viet Nam, Vanuatu, Samoa, Kosovo, Yemen, Rep., South Africa, Zambia, Zimbabwe, AFG, AGO, ALB, ARE, ARG, ARM, AZE, BDI, BEN, BFA, BGD, BGR, BHR, BHS, BIH, BLR, BLZ, BOL, BRA, BRB, BTN, BWA, CAF, CHL, CHN, CIV, CMR, COD, COG, COL, COM, CPV, CRI, DJI, DMA, DOM, DZA, ECU, EGY, ERI, ETH, FJI, FSM, GAB, GEO, GHA, GIN, GMB, GNB, GNQ, GRD, GTM, GUY, HND, HRV, HTI, IDN, IND, IRN, IRQ, JAM, JOR, KAZ, KEN, KGZ, KHM, KIR, KWT, LAO, LBN, LBR, LBY, LCA, LKA, LSO, MAR, MDA, MDG, MDV, MEX, MHL, MKD, MLI, MMR, MNE, MNG, MOZ, MRT, MUS, MWI, MYS, NAM, NER, NGA, NIC, NPL, NRU, OMN, PAK, PAN, PER, PHL, PLW, PNG, POL, PRY, PSE, QAT, ROU, RUS, RWA, SAU, SDN, SEN, SLB, SLE, SLV, SOM, SRB, SSD, STP, SUR, SWZ, SYC, SYR, TCD, TGO, THA, TJK, TLS, TON, TTO, TUN, TUR, TUV, TZA, UGA, UKR, URY, UZB, VCT, VNM, VUT, WSM, XKX, YEM, ZAF, ZMB, ZWE
#> 33 Afghanistan, Angola, Albania, United Arab Emirates, Argentina, Armenia, Azerbaijan, Burundi, Benin, Burkina Faso, Bangladesh, Bulgaria, Bahrain, Bahamas, The, Bosnia and Herzegovina, Belarus, Belize, Bolivia, Brazil, Barbados, Bhutan, Botswana, Central African Republic, Chile, China, Cote d'Ivoire, Cameroon, Congo, Dem. Rep., Congo, Rep., Colombia, Comoros, Cabo Verde, Costa Rica, Djibouti, Dominica, Dominican Republic, Algeria, Ecuador, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Micronesia, Fed. Sts., Gabon, Georgia, Ghana, Guinea, Gambia, The, Guinea-Bissau, Equatorial Guinea, Grenada, Guatemala, Guyana, Honduras, Croatia, Haiti, Indonesia, India, Iran, Islamic Rep., Iraq, Jamaica, Jordan, Kazakhstan, Kenya, Kyrgyz Republic, Cambodia, Kiribati, Kuwait, Lao PDR, Lebanon, Liberia, Libya, St. Lucia, Sri Lanka, Lesotho, Morocco, Moldova, Madagascar, Maldives, Mexico, Marshall Islands, North Macedonia, Mali, Myanmar, Montenegro, Mongolia, Mozambique, Mauritania, Mauritius, Malawi, Malaysia, Namibia, Niger, Nigeria, Nicaragua, Nepal, Nauru, Oman, Pakistan, Panama, Peru, Philippines, Palau, Papua New Guinea, Poland, Paraguay, West Bank and Gaza, Qatar, Romania, Russian Federation, Rwanda, Saudi Arabia, Sudan, Senegal, Solomon Islands, Sierra Leone, El Salvador, Somalia, Serbia, South Sudan, Sao Tome and Principe, Suriname, Eswatini, Seychelles, Syrian Arab Republic, Chad, Togo, Thailand, Tajikistan, Timor-Leste, Tonga, Trinidad and Tobago, Tunisia, Turkiye, Tuvalu, Tanzania, Uganda, Ukraine, Uruguay, Uzbekistan, St. Vincent and the Grenadines, Viet Nam, Vanuatu, Samoa, Kosovo, Yemen, Rep., South Africa, Zambia, Zimbabwe, AFG, AGO, ALB, ARE, ARG, ARM, AZE, BDI, BEN, BFA, BGD, BGR, BHR, BHS, BIH, BLR, BLZ, BOL, BRA, BRB, BTN, BWA, CAF, CHL, CHN, CIV, CMR, COD, COG, COL, COM, CPV, CRI, DJI, DMA, DOM, DZA, ECU, EGY, ERI, ETH, FJI, FSM, GAB, GEO, GHA, GIN, GMB, GNB, GNQ, GRD, GTM, GUY, HND, HRV, HTI, IDN, IND, IRN, IRQ, JAM, JOR, KAZ, KEN, KGZ, KHM, KIR, KWT, LAO, LBN, LBR, LBY, LCA, LKA, LSO, MAR, MDA, MDG, MDV, MEX, MHL, MKD, MLI, MMR, MNE, MNG, MOZ, MRT, MUS, MWI, MYS, NAM, NER, NGA, NIC, NPL, NRU, OMN, PAK, PAN, PER, PHL, PLW, PNG, POL, PRY, PSE, QAT, ROU, RUS, RWA, SAU, SDN, SEN, SLB, SLE, SLV, SOM, SRB, SSD, STP, SUR, SWZ, SYC, SYR, TCD, TGO, THA, TJK, TLS, TON, TTO, TUN, TUR, TUV, TZA, UGA, UKR, URY, UZB, VCT, VNM, VUT, WSM, XKX, YEM, ZAF, ZMB, ZWE
#> 34 Afghanistan, Angola, Albania, United Arab Emirates, Argentina, Armenia, Azerbaijan, Burundi, Benin, Burkina Faso, Bangladesh, Bulgaria, Bahrain, Bahamas, The, Bosnia and Herzegovina, Belarus, Belize, Bolivia, Brazil, Barbados, Bhutan, Botswana, Central African Republic, Chile, China, Cote d'Ivoire, Cameroon, Congo, Dem. Rep., Congo, Rep., Colombia, Comoros, Cabo Verde, Costa Rica, Djibouti, Dominica, Dominican Republic, Algeria, Ecuador, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Micronesia, Fed. Sts., Gabon, Georgia, Ghana, Guinea, Gambia, The, Guinea-Bissau, Equatorial Guinea, Grenada, Guatemala, Guyana, Honduras, Croatia, Haiti, Indonesia, India, Iran, Islamic Rep., Iraq, Jamaica, Jordan, Kazakhstan, Kenya, Kyrgyz Republic, Cambodia, Kiribati, Kuwait, Lao PDR, Lebanon, Liberia, Libya, St. Lucia, Sri Lanka, Lesotho, Morocco, Moldova, Madagascar, Maldives, Mexico, Marshall Islands, North Macedonia, Mali, Myanmar, Montenegro, Mongolia, Mozambique, Mauritania, Mauritius, Malawi, Malaysia, Namibia, Niger, Nigeria, Nicaragua, Nepal, Nauru, Oman, Pakistan, Panama, Peru, Philippines, Palau, Papua New Guinea, Poland, Paraguay, West Bank and Gaza, Qatar, Romania, Russian Federation, Rwanda, Saudi Arabia, Sudan, Senegal, Solomon Islands, Sierra Leone, El Salvador, Somalia, Serbia, South Sudan, Sao Tome and Principe, Suriname, Eswatini, Seychelles, Syrian Arab Republic, Chad, Togo, Thailand, Tajikistan, Timor-Leste, Tonga, Trinidad and Tobago, Tunisia, Turkiye, Tuvalu, Tanzania, Uganda, Ukraine, Uruguay, Uzbekistan, St. Vincent and the Grenadines, Viet Nam, Vanuatu, Samoa, Kosovo, Yemen, Rep., South Africa, Zambia, Zimbabwe, AFG, AGO, ALB, ARE, ARG, ARM, AZE, BDI, BEN, BFA, BGD, BGR, BHR, BHS, BIH, BLR, BLZ, BOL, BRA, BRB, BTN, BWA, CAF, CHL, CHN, CIV, CMR, COD, COG, COL, COM, CPV, CRI, DJI, DMA, DOM, DZA, ECU, EGY, ERI, ETH, FJI, FSM, GAB, GEO, GHA, GIN, GMB, GNB, GNQ, GRD, GTM, GUY, HND, HRV, HTI, IDN, IND, IRN, IRQ, JAM, JOR, KAZ, KEN, KGZ, KHM, KIR, KWT, LAO, LBN, LBR, LBY, LCA, LKA, LSO, MAR, MDA, MDG, MDV, MEX, MHL, MKD, MLI, MMR, MNE, MNG, MOZ, MRT, MUS, MWI, MYS, NAM, NER, NGA, NIC, NPL, NRU, OMN, PAK, PAN, PER, PHL, PLW, PNG, POL, PRY, PSE, QAT, ROU, RUS, RWA, SAU, SDN, SEN, SLB, SLE, SLV, SOM, SRB, SSD, STP, SUR, SWZ, SYC, SYR, TCD, TGO, THA, TJK, TLS, TON, TTO, TUN, TUR, TUV, TZA, UGA, UKR, URY, UZB, VCT, VNM, VUT, WSM, XKX, YEM, ZAF, ZMB, ZWE
#> 35 Afghanistan, Angola, Albania, United Arab Emirates, Argentina, Armenia, Azerbaijan, Burundi, Benin, Burkina Faso, Bangladesh, Bulgaria, Bahrain, Bahamas, The, Bosnia and Herzegovina, Belarus, Belize, Bolivia, Brazil, Barbados, Bhutan, Botswana, Central African Republic, Chile, China, Cote d'Ivoire, Cameroon, Congo, Dem. Rep., Congo, Rep., Colombia, Comoros, Cabo Verde, Costa Rica, Djibouti, Dominica, Dominican Republic, Algeria, Ecuador, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Micronesia, Fed. Sts., Gabon, Georgia, Ghana, Guinea, Gambia, The, Guinea-Bissau, Equatorial Guinea, Grenada, Guatemala, Guyana, Honduras, Croatia, Haiti, Indonesia, India, Iran, Islamic Rep., Iraq, Jamaica, Jordan, Kazakhstan, Kenya, Kyrgyz Republic, Cambodia, Kiribati, Kuwait, Lao PDR, Lebanon, Liberia, Libya, St. Lucia, Sri Lanka, Lesotho, Morocco, Moldova, Madagascar, Maldives, Mexico, Marshall Islands, North Macedonia, Mali, Myanmar, Montenegro, Mongolia, Mozambique, Mauritania, Mauritius, Malawi, Malaysia, Namibia, Niger, Nigeria, Nicaragua, Nepal, Nauru, Oman, Pakistan, Panama, Peru, Philippines, Palau, Papua New Guinea, Poland, Paraguay, West Bank and Gaza, Qatar, Romania, Russian Federation, Rwanda, Saudi Arabia, Sudan, Senegal, Solomon Islands, Sierra Leone, El Salvador, Somalia, Serbia, South Sudan, Sao Tome and Principe, Suriname, Eswatini, Seychelles, Syrian Arab Republic, Chad, Togo, Thailand, Tajikistan, Timor-Leste, Tonga, Trinidad and Tobago, Tunisia, Turkiye, Tuvalu, Tanzania, Uganda, Ukraine, Uruguay, Uzbekistan, St. Vincent and the Grenadines, Viet Nam, Vanuatu, Samoa, Kosovo, Yemen, Rep., South Africa, Zambia, Zimbabwe, AFG, AGO, ALB, ARE, ARG, ARM, AZE, BDI, BEN, BFA, BGD, BGR, BHR, BHS, BIH, BLR, BLZ, BOL, BRA, BRB, BTN, BWA, CAF, CHL, CHN, CIV, CMR, COD, COG, COL, COM, CPV, CRI, DJI, DMA, DOM, DZA, ECU, EGY, ERI, ETH, FJI, FSM, GAB, GEO, GHA, GIN, GMB, GNB, GNQ, GRD, GTM, GUY, HND, HRV, HTI, IDN, IND, IRN, IRQ, JAM, JOR, KAZ, KEN, KGZ, KHM, KIR, KWT, LAO, LBN, LBR, LBY, LCA, LKA, LSO, MAR, MDA, MDG, MDV, MEX, MHL, MKD, MLI, MMR, MNE, MNG, MOZ, MRT, MUS, MWI, MYS, NAM, NER, NGA, NIC, NPL, NRU, OMN, PAK, PAN, PER, PHL, PLW, PNG, POL, PRY, PSE, QAT, ROU, RUS, RWA, SAU, SDN, SEN, SLB, SLE, SLV, SOM, SRB, SSD, STP, SUR, SWZ, SYC, SYR, TCD, TGO, THA, TJK, TLS, TON, TTO, TUN, TUR, TUV, TZA, UGA, UKR, URY, UZB, VCT, VNM, VUT, WSM, XKX, YEM, ZAF, ZMB, ZWE
#> 36 Afghanistan, Angola, Albania, United Arab Emirates, Argentina, Armenia, Azerbaijan, Burundi, Benin, Burkina Faso, Bangladesh, Bulgaria, Bahrain, Bahamas, The, Bosnia and Herzegovina, Belarus, Belize, Bolivia, Brazil, Barbados, Bhutan, Botswana, Central African Republic, Chile, China, Cote d'Ivoire, Cameroon, Congo, Dem. Rep., Congo, Rep., Colombia, Comoros, Cabo Verde, Costa Rica, Djibouti, Dominica, Dominican Republic, Algeria, Ecuador, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Micronesia, Fed. Sts., Gabon, Georgia, Ghana, Guinea, Gambia, The, Guinea-Bissau, Equatorial Guinea, Grenada, Guatemala, Guyana, Honduras, Croatia, Haiti, Indonesia, India, Iran, Islamic Rep., Iraq, Jamaica, Jordan, Kazakhstan, Kenya, Kyrgyz Republic, Cambodia, Kiribati, Kuwait, Lao PDR, Lebanon, Liberia, Libya, St. Lucia, Sri Lanka, Lesotho, Morocco, Moldova, Madagascar, Maldives, Mexico, Marshall Islands, North Macedonia, Mali, Myanmar, Montenegro, Mongolia, Mozambique, Mauritania, Mauritius, Malawi, Malaysia, Namibia, Niger, Nigeria, Nicaragua, Nepal, Nauru, Oman, Pakistan, Panama, Peru, Philippines, Palau, Papua New Guinea, Poland, Paraguay, West Bank and Gaza, Qatar, Romania, Russian Federation, Rwanda, Saudi Arabia, Sudan, Senegal, Solomon Islands, Sierra Leone, El Salvador, Somalia, Serbia, South Sudan, Sao Tome and Principe, Suriname, Eswatini, Seychelles, Syrian Arab Republic, Chad, Togo, Thailand, Tajikistan, Timor-Leste, Tonga, Trinidad and Tobago, Tunisia, Turkiye, Tuvalu, Tanzania, Uganda, Ukraine, Uruguay, Uzbekistan, St. Vincent and the Grenadines, Viet Nam, Vanuatu, Samoa, Kosovo, Yemen, Rep., South Africa, Zambia, Zimbabwe, AFG, AGO, ALB, ARE, ARG, ARM, AZE, BDI, BEN, BFA, BGD, BGR, BHR, BHS, BIH, BLR, BLZ, BOL, BRA, BRB, BTN, BWA, CAF, CHL, CHN, CIV, CMR, COD, COG, COL, COM, CPV, CRI, DJI, DMA, DOM, DZA, ECU, EGY, ERI, ETH, FJI, FSM, GAB, GEO, GHA, GIN, GMB, GNB, GNQ, GRD, GTM, GUY, HND, HRV, HTI, IDN, IND, IRN, IRQ, JAM, JOR, KAZ, KEN, KGZ, KHM, KIR, KWT, LAO, LBN, LBR, LBY, LCA, LKA, LSO, MAR, MDA, MDG, MDV, MEX, MHL, MKD, MLI, MMR, MNE, MNG, MOZ, MRT, MUS, MWI, MYS, NAM, NER, NGA, NIC, NPL, NRU, OMN, PAK, PAN, PER, PHL, PLW, PNG, POL, PRY, PSE, QAT, ROU, RUS, RWA, SAU, SDN, SEN, SLB, SLE, SLV, SOM, SRB, SSD, STP, SUR, SWZ, SYC, SYR, TCD, TGO, THA, TJK, TLS, TON, TTO, TUN, TUR, TUV, TZA, UGA, UKR, URY, UZB, VCT, VNM, VUT, WSM, XKX, YEM, ZAF, ZMB, ZWE
#> 37 Afghanistan, Angola, Albania, United Arab Emirates, Argentina, Armenia, Azerbaijan, Burundi, Benin, Burkina Faso, Bangladesh, Bulgaria, Bahrain, Bahamas, The, Bosnia and Herzegovina, Belarus, Belize, Bolivia, Brazil, Barbados, Bhutan, Botswana, Central African Republic, Chile, China, Cote d'Ivoire, Cameroon, Congo, Dem. Rep., Congo, Rep., Colombia, Comoros, Cabo Verde, Costa Rica, Djibouti, Dominica, Dominican Republic, Algeria, Ecuador, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Micronesia, Fed. Sts., Gabon, Georgia, Ghana, Guinea, Gambia, The, Guinea-Bissau, Equatorial Guinea, Grenada, Guatemala, Guyana, Honduras, Croatia, Haiti, Indonesia, India, Iran, Islamic Rep., Iraq, Jamaica, Jordan, Kazakhstan, Kenya, Kyrgyz Republic, Cambodia, Kiribati, Kuwait, Lao PDR, Lebanon, Liberia, Libya, St. Lucia, Sri Lanka, Lesotho, Morocco, Moldova, Madagascar, Maldives, Mexico, Marshall Islands, North Macedonia, Mali, Myanmar, Montenegro, Mongolia, Mozambique, Mauritania, Mauritius, Malawi, Malaysia, Namibia, Niger, Nigeria, Nicaragua, Nepal, Nauru, Oman, Pakistan, Panama, Peru, Philippines, Palau, Papua New Guinea, Poland, Paraguay, West Bank and Gaza, Qatar, Romania, Russian Federation, Rwanda, Saudi Arabia, Sudan, Senegal, Solomon Islands, Sierra Leone, El Salvador, Somalia, Serbia, South Sudan, Sao Tome and Principe, Suriname, Eswatini, Seychelles, Syrian Arab Republic, Chad, Togo, Thailand, Tajikistan, Timor-Leste, Tonga, Trinidad and Tobago, Tunisia, Turkiye, Tuvalu, Tanzania, Uganda, Ukraine, Uruguay, Uzbekistan, St. Vincent and the Grenadines, Viet Nam, Vanuatu, Samoa, Kosovo, Yemen, Rep., South Africa, Zambia, Zimbabwe, AFG, AGO, ALB, ARE, ARG, ARM, AZE, BDI, BEN, BFA, BGD, BGR, BHR, BHS, BIH, BLR, BLZ, BOL, BRA, BRB, BTN, BWA, CAF, CHL, CHN, CIV, CMR, COD, COG, COL, COM, CPV, CRI, DJI, DMA, DOM, DZA, ECU, EGY, ERI, ETH, FJI, FSM, GAB, GEO, GHA, GIN, GMB, GNB, GNQ, GRD, GTM, GUY, HND, HRV, HTI, IDN, IND, IRN, IRQ, JAM, JOR, KAZ, KEN, KGZ, KHM, KIR, KWT, LAO, LBN, LBR, LBY, LCA, LKA, LSO, MAR, MDA, MDG, MDV, MEX, MHL, MKD, MLI, MMR, MNE, MNG, MOZ, MRT, MUS, MWI, MYS, NAM, NER, NGA, NIC, NPL, NRU, OMN, PAK, PAN, PER, PHL, PLW, PNG, POL, PRY, PSE, QAT, ROU, RUS, RWA, SAU, SDN, SEN, SLB, SLE, SLV, SOM, SRB, SSD, STP, SUR, SWZ, SYC, SYR, TCD, TGO, THA, TJK, TLS, TON, TTO, TUN, TUR, TUV, TZA, UGA, UKR, URY, UZB, VCT, VNM, VUT, WSM, XKX, YEM, ZAF, ZMB, ZWE
#> 38 Afghanistan, Angola, Albania, United Arab Emirates, Argentina, Armenia, Azerbaijan, Burundi, Benin, Burkina Faso, Bangladesh, Bulgaria, Bahrain, Bahamas, The, Bosnia and Herzegovina, Belarus, Belize, Bolivia, Brazil, Barbados, Bhutan, Botswana, Central African Republic, Chile, China, Cote d'Ivoire, Cameroon, Congo, Dem. Rep., Congo, Rep., Colombia, Comoros, Cabo Verde, Costa Rica, Djibouti, Dominica, Dominican Republic, Algeria, Ecuador, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Micronesia, Fed. Sts., Gabon, Georgia, Ghana, Guinea, Gambia, The, Guinea-Bissau, Equatorial Guinea, Grenada, Guatemala, Guyana, Honduras, Croatia, Haiti, Indonesia, India, Iran, Islamic Rep., Iraq, Jamaica, Jordan, Kazakhstan, Kenya, Kyrgyz Republic, Cambodia, Kiribati, Kuwait, Lao PDR, Lebanon, Liberia, Libya, St. Lucia, Sri Lanka, Lesotho, Morocco, Moldova, Madagascar, Maldives, Mexico, Marshall Islands, North Macedonia, Mali, Myanmar, Montenegro, Mongolia, Mozambique, Mauritania, Mauritius, Malawi, Malaysia, Namibia, Niger, Nigeria, Nicaragua, Nepal, Nauru, Oman, Pakistan, Panama, Peru, Philippines, Palau, Papua New Guinea, Poland, Paraguay, West Bank and Gaza, Qatar, Romania, Russian Federation, Rwanda, Saudi Arabia, Sudan, Senegal, Solomon Islands, Sierra Leone, El Salvador, Somalia, Serbia, South Sudan, Sao Tome and Principe, Suriname, Eswatini, Seychelles, Syrian Arab Republic, Chad, Togo, Thailand, Tajikistan, Timor-Leste, Tonga, Trinidad and Tobago, Tunisia, Turkiye, Tuvalu, Tanzania, Uganda, Ukraine, Uruguay, Uzbekistan, St. Vincent and the Grenadines, Viet Nam, Vanuatu, Samoa, Kosovo, Yemen, Rep., South Africa, Zambia, Zimbabwe, AFG, AGO, ALB, ARE, ARG, ARM, AZE, BDI, BEN, BFA, BGD, BGR, BHR, BHS, BIH, BLR, BLZ, BOL, BRA, BRB, BTN, BWA, CAF, CHL, CHN, CIV, CMR, COD, COG, COL, COM, CPV, CRI, DJI, DMA, DOM, DZA, ECU, EGY, ERI, ETH, FJI, FSM, GAB, GEO, GHA, GIN, GMB, GNB, GNQ, GRD, GTM, GUY, HND, HRV, HTI, IDN, IND, IRN, IRQ, JAM, JOR, KAZ, KEN, KGZ, KHM, KIR, KWT, LAO, LBN, LBR, LBY, LCA, LKA, LSO, MAR, MDA, MDG, MDV, MEX, MHL, MKD, MLI, MMR, MNE, MNG, MOZ, MRT, MUS, MWI, MYS, NAM, NER, NGA, NIC, NPL, NRU, OMN, PAK, PAN, PER, PHL, PLW, PNG, POL, PRY, PSE, QAT, ROU, RUS, RWA, SAU, SDN, SEN, SLB, SLE, SLV, SOM, SRB, SSD, STP, SUR, SWZ, SYC, SYR, TCD, TGO, THA, TJK, TLS, TON, TTO, TUN, TUR, TUV, TZA, UGA, UKR, URY, UZB, VCT, VNM, VUT, WSM, XKX, YEM, ZAF, ZMB, ZWE
#> 39 Afghanistan, Angola, Albania, United Arab Emirates, Argentina, Armenia, Azerbaijan, Burundi, Benin, Burkina Faso, Bangladesh, Bulgaria, Bahrain, Bahamas, The, Bosnia and Herzegovina, Belarus, Belize, Bolivia, Brazil, Barbados, Bhutan, Botswana, Central African Republic, Chile, China, Cote d'Ivoire, Cameroon, Congo, Dem. Rep., Congo, Rep., Colombia, Comoros, Cabo Verde, Costa Rica, Djibouti, Dominica, Dominican Republic, Algeria, Ecuador, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Micronesia, Fed. Sts., Gabon, Georgia, Ghana, Guinea, Gambia, The, Guinea-Bissau, Equatorial Guinea, Grenada, Guatemala, Guyana, Honduras, Croatia, Haiti, Indonesia, India, Iran, Islamic Rep., Iraq, Jamaica, Jordan, Kazakhstan, Kenya, Kyrgyz Republic, Cambodia, Kiribati, Kuwait, Lao PDR, Lebanon, Liberia, Libya, St. Lucia, Sri Lanka, Lesotho, Morocco, Moldova, Madagascar, Maldives, Mexico, Marshall Islands, North Macedonia, Mali, Myanmar, Montenegro, Mongolia, Mozambique, Mauritania, Mauritius, Malawi, Malaysia, Namibia, Niger, Nigeria, Nicaragua, Nepal, Nauru, Oman, Pakistan, Panama, Peru, Philippines, Palau, Papua New Guinea, Poland, Paraguay, West Bank and Gaza, Qatar, Romania, Russian Federation, Rwanda, Saudi Arabia, Sudan, Senegal, Solomon Islands, Sierra Leone, El Salvador, Somalia, Serbia, South Sudan, Sao Tome and Principe, Suriname, Eswatini, Seychelles, Syrian Arab Republic, Chad, Togo, Thailand, Tajikistan, Timor-Leste, Tonga, Trinidad and Tobago, Tunisia, Turkiye, Tuvalu, Tanzania, Uganda, Ukraine, Uruguay, Uzbekistan, St. Vincent and the Grenadines, Viet Nam, Vanuatu, Samoa, Kosovo, Yemen, Rep., South Africa, Zambia, Zimbabwe, AFG, AGO, ALB, ARE, ARG, ARM, AZE, BDI, BEN, BFA, BGD, BGR, BHR, BHS, BIH, BLR, BLZ, BOL, BRA, BRB, BTN, BWA, CAF, CHL, CHN, CIV, CMR, COD, COG, COL, COM, CPV, CRI, DJI, DMA, DOM, DZA, ECU, EGY, ERI, ETH, FJI, FSM, GAB, GEO, GHA, GIN, GMB, GNB, GNQ, GRD, GTM, GUY, HND, HRV, HTI, IDN, IND, IRN, IRQ, JAM, JOR, KAZ, KEN, KGZ, KHM, KIR, KWT, LAO, LBN, LBR, LBY, LCA, LKA, LSO, MAR, MDA, MDG, MDV, MEX, MHL, MKD, MLI, MMR, MNE, MNG, MOZ, MRT, MUS, MWI, MYS, NAM, NER, NGA, NIC, NPL, NRU, OMN, PAK, PAN, PER, PHL, PLW, PNG, POL, PRY, PSE, QAT, ROU, RUS, RWA, SAU, SDN, SEN, SLB, SLE, SLV, SOM, SRB, SSD, STP, SUR, SWZ, SYC, SYR, TCD, TGO, THA, TJK, TLS, TON, TTO, TUN, TUR, TUV, TZA, UGA, UKR, URY, UZB, VCT, VNM, VUT, WSM, XKX, YEM, ZAF, ZMB, ZWE
#> 40 Afghanistan, Angola, Albania, United Arab Emirates, Argentina, Armenia, Azerbaijan, Burundi, Benin, Burkina Faso, Bangladesh, Bulgaria, Bahrain, Bahamas, The, Bosnia and Herzegovina, Belarus, Belize, Bolivia, Brazil, Barbados, Bhutan, Botswana, Central African Republic, Chile, China, Cote d'Ivoire, Cameroon, Congo, Dem. Rep., Congo, Rep., Colombia, Comoros, Cabo Verde, Costa Rica, Djibouti, Dominica, Dominican Republic, Algeria, Ecuador, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Micronesia, Fed. Sts., Gabon, Georgia, Ghana, Guinea, Gambia, The, Guinea-Bissau, Equatorial Guinea, Grenada, Guatemala, Guyana, Honduras, Croatia, Haiti, Indonesia, India, Iran, Islamic Rep., Iraq, Jamaica, Jordan, Kazakhstan, Kenya, Kyrgyz Republic, Cambodia, Kiribati, Kuwait, Lao PDR, Lebanon, Liberia, Libya, St. Lucia, Sri Lanka, Lesotho, Morocco, Moldova, Madagascar, Maldives, Mexico, Marshall Islands, North Macedonia, Mali, Myanmar, Montenegro, Mongolia, Mozambique, Mauritania, Mauritius, Malawi, Malaysia, Namibia, Niger, Nigeria, Nicaragua, Nepal, Nauru, Oman, Pakistan, Panama, Peru, Philippines, Palau, Papua New Guinea, Poland, Paraguay, West Bank and Gaza, Qatar, Romania, Russian Federation, Rwanda, Saudi Arabia, Sudan, Senegal, Solomon Islands, Sierra Leone, El Salvador, Somalia, Serbia, South Sudan, Sao Tome and Principe, Suriname, Eswatini, Seychelles, Syrian Arab Republic, Chad, Togo, Thailand, Tajikistan, Timor-Leste, Tonga, Trinidad and Tobago, Tunisia, Turkiye, Tuvalu, Tanzania, Uganda, Ukraine, Uruguay, Uzbekistan, St. Vincent and the Grenadines, Viet Nam, Vanuatu, Samoa, Kosovo, Yemen, Rep., South Africa, Zambia, Zimbabwe, AFG, AGO, ALB, ARE, ARG, ARM, AZE, BDI, BEN, BFA, BGD, BGR, BHR, BHS, BIH, BLR, BLZ, BOL, BRA, BRB, BTN, BWA, CAF, CHL, CHN, CIV, CMR, COD, COG, COL, COM, CPV, CRI, DJI, DMA, DOM, DZA, ECU, EGY, ERI, ETH, FJI, FSM, GAB, GEO, GHA, GIN, GMB, GNB, GNQ, GRD, GTM, GUY, HND, HRV, HTI, IDN, IND, IRN, IRQ, JAM, JOR, KAZ, KEN, KGZ, KHM, KIR, KWT, LAO, LBN, LBR, LBY, LCA, LKA, LSO, MAR, MDA, MDG, MDV, MEX, MHL, MKD, MLI, MMR, MNE, MNG, MOZ, MRT, MUS, MWI, MYS, NAM, NER, NGA, NIC, NPL, NRU, OMN, PAK, PAN, PER, PHL, PLW, PNG, POL, PRY, PSE, QAT, ROU, RUS, RWA, SAU, SDN, SEN, SLB, SLE, SLV, SOM, SRB, SSD, STP, SUR, SWZ, SYC, SYR, TCD, TGO, THA, TJK, TLS, TON, TTO, TUN, TUR, TUV, TZA, UGA, UKR, URY, UZB, VCT, VNM, VUT, WSM, XKX, YEM, ZAF, ZMB, ZWE
#> 41 Afghanistan, Angola, Albania, United Arab Emirates, Argentina, Armenia, Azerbaijan, Burundi, Benin, Burkina Faso, Bangladesh, Bulgaria, Bahrain, Bahamas, The, Bosnia and Herzegovina, Belarus, Belize, Bolivia, Brazil, Barbados, Bhutan, Botswana, Central African Republic, Chile, China, Cote d'Ivoire, Cameroon, Congo, Dem. Rep., Congo, Rep., Colombia, Comoros, Cabo Verde, Costa Rica, Djibouti, Dominica, Dominican Republic, Algeria, Ecuador, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Micronesia, Fed. Sts., Gabon, Georgia, Ghana, Guinea, Gambia, The, Guinea-Bissau, Equatorial Guinea, Grenada, Guatemala, Guyana, Honduras, Croatia, Haiti, Indonesia, India, Iran, Islamic Rep., Iraq, Jamaica, Jordan, Kazakhstan, Kenya, Kyrgyz Republic, Cambodia, Kiribati, Kuwait, Lao PDR, Lebanon, Liberia, Libya, St. Lucia, Sri Lanka, Lesotho, Morocco, Moldova, Madagascar, Maldives, Mexico, Marshall Islands, North Macedonia, Mali, Myanmar, Montenegro, Mongolia, Mozambique, Mauritania, Mauritius, Malawi, Malaysia, Namibia, Niger, Nigeria, Nicaragua, Nepal, Nauru, Oman, Pakistan, Panama, Peru, Philippines, Palau, Papua New Guinea, Poland, Paraguay, West Bank and Gaza, Qatar, Romania, Russian Federation, Rwanda, Saudi Arabia, Sudan, Senegal, Solomon Islands, Sierra Leone, El Salvador, Somalia, Serbia, South Sudan, Sao Tome and Principe, Suriname, Eswatini, Seychelles, Syrian Arab Republic, Chad, Togo, Thailand, Tajikistan, Timor-Leste, Tonga, Trinidad and Tobago, Tunisia, Turkiye, Tuvalu, Tanzania, Uganda, Ukraine, Uruguay, Uzbekistan, St. Vincent and the Grenadines, Viet Nam, Vanuatu, Samoa, Kosovo, Yemen, Rep., South Africa, Zambia, Zimbabwe, AFG, AGO, ALB, ARE, ARG, ARM, AZE, BDI, BEN, BFA, BGD, BGR, BHR, BHS, BIH, BLR, BLZ, BOL, BRA, BRB, BTN, BWA, CAF, CHL, CHN, CIV, CMR, COD, COG, COL, COM, CPV, CRI, DJI, DMA, DOM, DZA, ECU, EGY, ERI, ETH, FJI, FSM, GAB, GEO, GHA, GIN, GMB, GNB, GNQ, GRD, GTM, GUY, HND, HRV, HTI, IDN, IND, IRN, IRQ, JAM, JOR, KAZ, KEN, KGZ, KHM, KIR, KWT, LAO, LBN, LBR, LBY, LCA, LKA, LSO, MAR, MDA, MDG, MDV, MEX, MHL, MKD, MLI, MMR, MNE, MNG, MOZ, MRT, MUS, MWI, MYS, NAM, NER, NGA, NIC, NPL, NRU, OMN, PAK, PAN, PER, PHL, PLW, PNG, POL, PRY, PSE, QAT, ROU, RUS, RWA, SAU, SDN, SEN, SLB, SLE, SLV, SOM, SRB, SSD, STP, SUR, SWZ, SYC, SYR, TCD, TGO, THA, TJK, TLS, TON, TTO, TUN, TUR, TUV, TZA, UGA, UKR, URY, UZB, VCT, VNM, VUT, WSM, XKX, YEM, ZAF, ZMB, ZWE
#> 42 Afghanistan, Angola, Albania, United Arab Emirates, Argentina, Armenia, Azerbaijan, Burundi, Benin, Burkina Faso, Bangladesh, Bulgaria, Bahrain, Bahamas, The, Bosnia and Herzegovina, Belarus, Belize, Bolivia, Brazil, Barbados, Bhutan, Botswana, Central African Republic, Chile, China, Cote d'Ivoire, Cameroon, Congo, Dem. Rep., Congo, Rep., Colombia, Comoros, Cabo Verde, Costa Rica, Djibouti, Dominica, Dominican Republic, Algeria, Ecuador, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Micronesia, Fed. Sts., Gabon, Georgia, Ghana, Guinea, Gambia, The, Guinea-Bissau, Equatorial Guinea, Grenada, Guatemala, Guyana, Honduras, Croatia, Haiti, Indonesia, India, Iran, Islamic Rep., Iraq, Jamaica, Jordan, Kazakhstan, Kenya, Kyrgyz Republic, Cambodia, Kiribati, Kuwait, Lao PDR, Lebanon, Liberia, Libya, St. Lucia, Sri Lanka, Lesotho, Morocco, Moldova, Madagascar, Maldives, Mexico, Marshall Islands, North Macedonia, Mali, Myanmar, Montenegro, Mongolia, Mozambique, Mauritania, Mauritius, Malawi, Malaysia, Namibia, Niger, Nigeria, Nicaragua, Nepal, Nauru, Oman, Pakistan, Panama, Peru, Philippines, Palau, Papua New Guinea, Poland, Paraguay, West Bank and Gaza, Qatar, Romania, Russian Federation, Rwanda, Saudi Arabia, Sudan, Senegal, Solomon Islands, Sierra Leone, El Salvador, Somalia, Serbia, South Sudan, Sao Tome and Principe, Suriname, Eswatini, Seychelles, Syrian Arab Republic, Chad, Togo, Thailand, Tajikistan, Timor-Leste, Tonga, Trinidad and Tobago, Tunisia, Turkiye, Tuvalu, Tanzania, Uganda, Ukraine, Uruguay, Uzbekistan, St. Vincent and the Grenadines, Viet Nam, Vanuatu, Samoa, Kosovo, Yemen, Rep., South Africa, Zambia, Zimbabwe, AFG, AGO, ALB, ARE, ARG, ARM, AZE, BDI, BEN, BFA, BGD, BGR, BHR, BHS, BIH, BLR, BLZ, BOL, BRA, BRB, BTN, BWA, CAF, CHL, CHN, CIV, CMR, COD, COG, COL, COM, CPV, CRI, DJI, DMA, DOM, DZA, ECU, EGY, ERI, ETH, FJI, FSM, GAB, GEO, GHA, GIN, GMB, GNB, GNQ, GRD, GTM, GUY, HND, HRV, HTI, IDN, IND, IRN, IRQ, JAM, JOR, KAZ, KEN, KGZ, KHM, KIR, KWT, LAO, LBN, LBR, LBY, LCA, LKA, LSO, MAR, MDA, MDG, MDV, MEX, MHL, MKD, MLI, MMR, MNE, MNG, MOZ, MRT, MUS, MWI, MYS, NAM, NER, NGA, NIC, NPL, NRU, OMN, PAK, PAN, PER, PHL, PLW, PNG, POL, PRY, PSE, QAT, ROU, RUS, RWA, SAU, SDN, SEN, SLB, SLE, SLV, SOM, SRB, SSD, STP, SUR, SWZ, SYC, SYR, TCD, TGO, THA, TJK, TLS, TON, TTO, TUN, TUR, TUV, TZA, UGA, UKR, URY, UZB, VCT, VNM, VUT, WSM, XKX, YEM, ZAF, ZMB, ZWE
#> 43 Afghanistan, Angola, Albania, United Arab Emirates, Argentina, Armenia, Azerbaijan, Burundi, Benin, Burkina Faso, Bangladesh, Bulgaria, Bahrain, Bahamas, The, Bosnia and Herzegovina, Belarus, Belize, Bolivia, Brazil, Barbados, Bhutan, Botswana, Central African Republic, Chile, China, Cote d'Ivoire, Cameroon, Congo, Dem. Rep., Congo, Rep., Colombia, Comoros, Cabo Verde, Costa Rica, Djibouti, Dominica, Dominican Republic, Algeria, Ecuador, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Micronesia, Fed. Sts., Gabon, Georgia, Ghana, Guinea, Gambia, The, Guinea-Bissau, Equatorial Guinea, Grenada, Guatemala, Guyana, Honduras, Croatia, Haiti, Indonesia, India, Iran, Islamic Rep., Iraq, Jamaica, Jordan, Kazakhstan, Kenya, Kyrgyz Republic, Cambodia, Kiribati, Kuwait, Lao PDR, Lebanon, Liberia, Libya, St. Lucia, Sri Lanka, Lesotho, Morocco, Moldova, Madagascar, Maldives, Mexico, Marshall Islands, North Macedonia, Mali, Myanmar, Montenegro, Mongolia, Mozambique, Mauritania, Mauritius, Malawi, Malaysia, Namibia, Niger, Nigeria, Nicaragua, Nepal, Nauru, Oman, Pakistan, Panama, Peru, Philippines, Palau, Papua New Guinea, Poland, Paraguay, West Bank and Gaza, Qatar, Romania, Russian Federation, Rwanda, Saudi Arabia, Sudan, Senegal, Solomon Islands, Sierra Leone, El Salvador, Somalia, Serbia, South Sudan, Sao Tome and Principe, Suriname, Eswatini, Seychelles, Syrian Arab Republic, Chad, Togo, Thailand, Tajikistan, Timor-Leste, Tonga, Trinidad and Tobago, Tunisia, Turkiye, Tuvalu, Tanzania, Uganda, Ukraine, Uruguay, Uzbekistan, St. Vincent and the Grenadines, Viet Nam, Vanuatu, Samoa, Kosovo, Yemen, Rep., South Africa, Zambia, Zimbabwe, AFG, AGO, ALB, ARE, ARG, ARM, AZE, BDI, BEN, BFA, BGD, BGR, BHR, BHS, BIH, BLR, BLZ, BOL, BRA, BRB, BTN, BWA, CAF, CHL, CHN, CIV, CMR, COD, COG, COL, COM, CPV, CRI, DJI, DMA, DOM, DZA, ECU, EGY, ERI, ETH, FJI, FSM, GAB, GEO, GHA, GIN, GMB, GNB, GNQ, GRD, GTM, GUY, HND, HRV, HTI, IDN, IND, IRN, IRQ, JAM, JOR, KAZ, KEN, KGZ, KHM, KIR, KWT, LAO, LBN, LBR, LBY, LCA, LKA, LSO, MAR, MDA, MDG, MDV, MEX, MHL, MKD, MLI, MMR, MNE, MNG, MOZ, MRT, MUS, MWI, MYS, NAM, NER, NGA, NIC, NPL, NRU, OMN, PAK, PAN, PER, PHL, PLW, PNG, POL, PRY, PSE, QAT, ROU, RUS, RWA, SAU, SDN, SEN, SLB, SLE, SLV, SOM, SRB, SSD, STP, SUR, SWZ, SYC, SYR, TCD, TGO, THA, TJK, TLS, TON, TTO, TUN, TUR, TUV, TZA, UGA, UKR, URY, UZB, VCT, VNM, VUT, WSM, XKX, YEM, ZAF, ZMB, ZWE
#> 44 Afghanistan, Angola, Albania, United Arab Emirates, Argentina, Armenia, Azerbaijan, Burundi, Benin, Burkina Faso, Bangladesh, Bulgaria, Bahrain, Bahamas, The, Bosnia and Herzegovina, Belarus, Belize, Bolivia, Brazil, Barbados, Bhutan, Botswana, Central African Republic, Chile, China, Cote d'Ivoire, Cameroon, Congo, Dem. Rep., Congo, Rep., Colombia, Comoros, Cabo Verde, Costa Rica, Djibouti, Dominica, Dominican Republic, Algeria, Ecuador, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Micronesia, Fed. Sts., Gabon, Georgia, Ghana, Guinea, Gambia, The, Guinea-Bissau, Equatorial Guinea, Grenada, Guatemala, Guyana, Honduras, Croatia, Haiti, Indonesia, India, Iran, Islamic Rep., Iraq, Jamaica, Jordan, Kazakhstan, Kenya, Kyrgyz Republic, Cambodia, Kiribati, Kuwait, Lao PDR, Lebanon, Liberia, Libya, St. Lucia, Sri Lanka, Lesotho, Morocco, Moldova, Madagascar, Maldives, Mexico, Marshall Islands, North Macedonia, Mali, Myanmar, Montenegro, Mongolia, Mozambique, Mauritania, Mauritius, Malawi, Malaysia, Namibia, Niger, Nigeria, Nicaragua, Nepal, Nauru, Oman, Pakistan, Panama, Peru, Philippines, Palau, Papua New Guinea, Poland, Paraguay, West Bank and Gaza, Qatar, Romania, Russian Federation, Rwanda, Saudi Arabia, Sudan, Senegal, Solomon Islands, Sierra Leone, El Salvador, Somalia, Serbia, South Sudan, Sao Tome and Principe, Suriname, Eswatini, Seychelles, Syrian Arab Republic, Chad, Togo, Thailand, Tajikistan, Timor-Leste, Tonga, Trinidad and Tobago, Tunisia, Turkiye, Tuvalu, Tanzania, Uganda, Ukraine, Uruguay, Uzbekistan, St. Vincent and the Grenadines, Viet Nam, Vanuatu, Samoa, Kosovo, Yemen, Rep., South Africa, Zambia, Zimbabwe, AFG, AGO, ALB, ARE, ARG, ARM, AZE, BDI, BEN, BFA, BGD, BGR, BHR, BHS, BIH, BLR, BLZ, BOL, BRA, BRB, BTN, BWA, CAF, CHL, CHN, CIV, CMR, COD, COG, COL, COM, CPV, CRI, DJI, DMA, DOM, DZA, ECU, EGY, ERI, ETH, FJI, FSM, GAB, GEO, GHA, GIN, GMB, GNB, GNQ, GRD, GTM, GUY, HND, HRV, HTI, IDN, IND, IRN, IRQ, JAM, JOR, KAZ, KEN, KGZ, KHM, KIR, KWT, LAO, LBN, LBR, LBY, LCA, LKA, LSO, MAR, MDA, MDG, MDV, MEX, MHL, MKD, MLI, MMR, MNE, MNG, MOZ, MRT, MUS, MWI, MYS, NAM, NER, NGA, NIC, NPL, NRU, OMN, PAK, PAN, PER, PHL, PLW, PNG, POL, PRY, PSE, QAT, ROU, RUS, RWA, SAU, SDN, SEN, SLB, SLE, SLV, SOM, SRB, SSD, STP, SUR, SWZ, SYC, SYR, TCD, TGO, THA, TJK, TLS, TON, TTO, TUN, TUR, TUV, TZA, UGA, UKR, URY, UZB, VCT, VNM, VUT, WSM, XKX, YEM, ZAF, ZMB, ZWE
#> 45 Afghanistan, Angola, Albania, United Arab Emirates, Argentina, Armenia, Azerbaijan, Burundi, Benin, Burkina Faso, Bangladesh, Bulgaria, Bahrain, Bahamas, The, Bosnia and Herzegovina, Belarus, Belize, Bolivia, Brazil, Barbados, Bhutan, Botswana, Central African Republic, Chile, China, Cote d'Ivoire, Cameroon, Congo, Dem. Rep., Congo, Rep., Colombia, Comoros, Cabo Verde, Costa Rica, Djibouti, Dominica, Dominican Republic, Algeria, Ecuador, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Micronesia, Fed. Sts., Gabon, Georgia, Ghana, Guinea, Gambia, The, Guinea-Bissau, Equatorial Guinea, Grenada, Guatemala, Guyana, Honduras, Croatia, Haiti, Indonesia, India, Iran, Islamic Rep., Iraq, Jamaica, Jordan, Kazakhstan, Kenya, Kyrgyz Republic, Cambodia, Kiribati, Kuwait, Lao PDR, Lebanon, Liberia, Libya, St. Lucia, Sri Lanka, Lesotho, Morocco, Moldova, Madagascar, Maldives, Mexico, Marshall Islands, North Macedonia, Mali, Myanmar, Montenegro, Mongolia, Mozambique, Mauritania, Mauritius, Malawi, Malaysia, Namibia, Niger, Nigeria, Nicaragua, Nepal, Nauru, Oman, Pakistan, Panama, Peru, Philippines, Palau, Papua New Guinea, Poland, Paraguay, West Bank and Gaza, Qatar, Romania, Russian Federation, Rwanda, Saudi Arabia, Sudan, Senegal, Solomon Islands, Sierra Leone, El Salvador, Somalia, Serbia, South Sudan, Sao Tome and Principe, Suriname, Eswatini, Seychelles, Syrian Arab Republic, Chad, Togo, Thailand, Tajikistan, Timor-Leste, Tonga, Trinidad and Tobago, Tunisia, Turkiye, Tuvalu, Tanzania, Uganda, Ukraine, Uruguay, Uzbekistan, St. Vincent and the Grenadines, Viet Nam, Vanuatu, Samoa, Kosovo, Yemen, Rep., South Africa, Zambia, Zimbabwe, AFG, AGO, ALB, ARE, ARG, ARM, AZE, BDI, BEN, BFA, BGD, BGR, BHR, BHS, BIH, BLR, BLZ, BOL, BRA, BRB, BTN, BWA, CAF, CHL, CHN, CIV, CMR, COD, COG, COL, COM, CPV, CRI, DJI, DMA, DOM, DZA, ECU, EGY, ERI, ETH, FJI, FSM, GAB, GEO, GHA, GIN, GMB, GNB, GNQ, GRD, GTM, GUY, HND, HRV, HTI, IDN, IND, IRN, IRQ, JAM, JOR, KAZ, KEN, KGZ, KHM, KIR, KWT, LAO, LBN, LBR, LBY, LCA, LKA, LSO, MAR, MDA, MDG, MDV, MEX, MHL, MKD, MLI, MMR, MNE, MNG, MOZ, MRT, MUS, MWI, MYS, NAM, NER, NGA, NIC, NPL, NRU, OMN, PAK, PAN, PER, PHL, PLW, PNG, POL, PRY, PSE, QAT, ROU, RUS, RWA, SAU, SDN, SEN, SLB, SLE, SLV, SOM, SRB, SSD, STP, SUR, SWZ, SYC, SYR, TCD, TGO, THA, TJK, TLS, TON, TTO, TUN, TUR, TUV, TZA, UGA, UKR, URY, UZB, VCT, VNM, VUT, WSM, XKX, YEM, ZAF, ZMB, ZWE
#> 46 Afghanistan, Angola, Albania, United Arab Emirates, Argentina, Armenia, Azerbaijan, Burundi, Benin, Burkina Faso, Bangladesh, Bulgaria, Bahrain, Bahamas, The, Bosnia and Herzegovina, Belarus, Belize, Bolivia, Brazil, Barbados, Bhutan, Botswana, Central African Republic, Chile, China, Cote d'Ivoire, Cameroon, Congo, Dem. Rep., Congo, Rep., Colombia, Comoros, Cabo Verde, Costa Rica, Djibouti, Dominica, Dominican Republic, Algeria, Ecuador, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Micronesia, Fed. Sts., Gabon, Georgia, Ghana, Guinea, Gambia, The, Guinea-Bissau, Equatorial Guinea, Grenada, Guatemala, Guyana, Honduras, Croatia, Haiti, Indonesia, India, Iran, Islamic Rep., Iraq, Jamaica, Jordan, Kazakhstan, Kenya, Kyrgyz Republic, Cambodia, Kiribati, Kuwait, Lao PDR, Lebanon, Liberia, Libya, St. Lucia, Sri Lanka, Lesotho, Morocco, Moldova, Madagascar, Maldives, Mexico, Marshall Islands, North Macedonia, Mali, Myanmar, Montenegro, Mongolia, Mozambique, Mauritania, Mauritius, Malawi, Malaysia, Namibia, Niger, Nigeria, Nicaragua, Nepal, Nauru, Oman, Pakistan, Panama, Peru, Philippines, Palau, Papua New Guinea, Poland, Paraguay, West Bank and Gaza, Qatar, Romania, Russian Federation, Rwanda, Saudi Arabia, Sudan, Senegal, Solomon Islands, Sierra Leone, El Salvador, Somalia, Serbia, South Sudan, Sao Tome and Principe, Suriname, Eswatini, Seychelles, Syrian Arab Republic, Chad, Togo, Thailand, Tajikistan, Timor-Leste, Tonga, Trinidad and Tobago, Tunisia, Turkiye, Tuvalu, Tanzania, Uganda, Ukraine, Uruguay, Uzbekistan, St. Vincent and the Grenadines, Viet Nam, Vanuatu, Samoa, Kosovo, Yemen, Rep., South Africa, Zambia, Zimbabwe, AFG, AGO, ALB, ARE, ARG, ARM, AZE, BDI, BEN, BFA, BGD, BGR, BHR, BHS, BIH, BLR, BLZ, BOL, BRA, BRB, BTN, BWA, CAF, CHL, CHN, CIV, CMR, COD, COG, COL, COM, CPV, CRI, DJI, DMA, DOM, DZA, ECU, EGY, ERI, ETH, FJI, FSM, GAB, GEO, GHA, GIN, GMB, GNB, GNQ, GRD, GTM, GUY, HND, HRV, HTI, IDN, IND, IRN, IRQ, JAM, JOR, KAZ, KEN, KGZ, KHM, KIR, KWT, LAO, LBN, LBR, LBY, LCA, LKA, LSO, MAR, MDA, MDG, MDV, MEX, MHL, MKD, MLI, MMR, MNE, MNG, MOZ, MRT, MUS, MWI, MYS, NAM, NER, NGA, NIC, NPL, NRU, OMN, PAK, PAN, PER, PHL, PLW, PNG, POL, PRY, PSE, QAT, ROU, RUS, RWA, SAU, SDN, SEN, SLB, SLE, SLV, SOM, SRB, SSD, STP, SUR, SWZ, SYC, SYR, TCD, TGO, THA, TJK, TLS, TON, TTO, TUN, TUR, TUV, TZA, UGA, UKR, URY, UZB, VCT, VNM, VUT, WSM, XKX, YEM, ZAF, ZMB, ZWE
#> 47 Afghanistan, Angola, Albania, United Arab Emirates, Argentina, Armenia, Azerbaijan, Burundi, Benin, Burkina Faso, Bangladesh, Bulgaria, Bahrain, Bahamas, The, Bosnia and Herzegovina, Belarus, Belize, Bolivia, Brazil, Barbados, Bhutan, Botswana, Central African Republic, Chile, China, Cote d'Ivoire, Cameroon, Congo, Dem. Rep., Congo, Rep., Colombia, Comoros, Cabo Verde, Costa Rica, Djibouti, Dominica, Dominican Republic, Algeria, Ecuador, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Micronesia, Fed. Sts., Gabon, Georgia, Ghana, Guinea, Gambia, The, Guinea-Bissau, Equatorial Guinea, Grenada, Guatemala, Guyana, Honduras, Croatia, Haiti, Indonesia, India, Iran, Islamic Rep., Iraq, Jamaica, Jordan, Kazakhstan, Kenya, Kyrgyz Republic, Cambodia, Kiribati, Kuwait, Lao PDR, Lebanon, Liberia, Libya, St. Lucia, Sri Lanka, Lesotho, Morocco, Moldova, Madagascar, Maldives, Mexico, Marshall Islands, North Macedonia, Mali, Myanmar, Montenegro, Mongolia, Mozambique, Mauritania, Mauritius, Malawi, Malaysia, Namibia, Niger, Nigeria, Nicaragua, Nepal, Nauru, Oman, Pakistan, Panama, Peru, Philippines, Palau, Papua New Guinea, Poland, Paraguay, West Bank and Gaza, Qatar, Romania, Russian Federation, Rwanda, Saudi Arabia, Sudan, Senegal, Solomon Islands, Sierra Leone, El Salvador, Somalia, Serbia, South Sudan, Sao Tome and Principe, Suriname, Eswatini, Seychelles, Syrian Arab Republic, Chad, Togo, Thailand, Tajikistan, Timor-Leste, Tonga, Trinidad and Tobago, Tunisia, Turkiye, Tuvalu, Tanzania, Uganda, Ukraine, Uruguay, Uzbekistan, St. Vincent and the Grenadines, Viet Nam, Vanuatu, Samoa, Kosovo, Yemen, Rep., South Africa, Zambia, Zimbabwe, AFG, AGO, ALB, ARE, ARG, ARM, AZE, BDI, BEN, BFA, BGD, BGR, BHR, BHS, BIH, BLR, BLZ, BOL, BRA, BRB, BTN, BWA, CAF, CHL, CHN, CIV, CMR, COD, COG, COL, COM, CPV, CRI, DJI, DMA, DOM, DZA, ECU, EGY, ERI, ETH, FJI, FSM, GAB, GEO, GHA, GIN, GMB, GNB, GNQ, GRD, GTM, GUY, HND, HRV, HTI, IDN, IND, IRN, IRQ, JAM, JOR, KAZ, KEN, KGZ, KHM, KIR, KWT, LAO, LBN, LBR, LBY, LCA, LKA, LSO, MAR, MDA, MDG, MDV, MEX, MHL, MKD, MLI, MMR, MNE, MNG, MOZ, MRT, MUS, MWI, MYS, NAM, NER, NGA, NIC, NPL, NRU, OMN, PAK, PAN, PER, PHL, PLW, PNG, POL, PRY, PSE, QAT, ROU, RUS, RWA, SAU, SDN, SEN, SLB, SLE, SLV, SOM, SRB, SSD, STP, SUR, SWZ, SYC, SYR, TCD, TGO, THA, TJK, TLS, TON, TTO, TUN, TUR, TUV, TZA, UGA, UKR, URY, UZB, VCT, VNM, VUT, WSM, XKX, YEM, ZAF, ZMB, ZWE
#> 48 Afghanistan, Angola, Albania, United Arab Emirates, Argentina, Armenia, Azerbaijan, Burundi, Benin, Burkina Faso, Bangladesh, Bulgaria, Bahrain, Bahamas, The, Bosnia and Herzegovina, Belarus, Belize, Bolivia, Brazil, Barbados, Bhutan, Botswana, Central African Republic, Chile, China, Cote d'Ivoire, Cameroon, Congo, Dem. Rep., Congo, Rep., Colombia, Comoros, Cabo Verde, Costa Rica, Djibouti, Dominica, Dominican Republic, Algeria, Ecuador, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Micronesia, Fed. Sts., Gabon, Georgia, Ghana, Guinea, Gambia, The, Guinea-Bissau, Equatorial Guinea, Grenada, Guatemala, Guyana, Honduras, Croatia, Haiti, Indonesia, India, Iran, Islamic Rep., Iraq, Jamaica, Jordan, Kazakhstan, Kenya, Kyrgyz Republic, Cambodia, Kiribati, Kuwait, Lao PDR, Lebanon, Liberia, Libya, St. Lucia, Sri Lanka, Lesotho, Morocco, Moldova, Madagascar, Maldives, Mexico, Marshall Islands, North Macedonia, Mali, Myanmar, Montenegro, Mongolia, Mozambique, Mauritania, Mauritius, Malawi, Malaysia, Namibia, Niger, Nigeria, Nicaragua, Nepal, Nauru, Oman, Pakistan, Panama, Peru, Philippines, Palau, Papua New Guinea, Poland, Paraguay, West Bank and Gaza, Qatar, Romania, Russian Federation, Rwanda, Saudi Arabia, Sudan, Senegal, Solomon Islands, Sierra Leone, El Salvador, Somalia, Serbia, South Sudan, Sao Tome and Principe, Suriname, Eswatini, Seychelles, Syrian Arab Republic, Chad, Togo, Thailand, Tajikistan, Timor-Leste, Tonga, Trinidad and Tobago, Tunisia, Turkiye, Tuvalu, Tanzania, Uganda, Ukraine, Uruguay, Uzbekistan, St. Vincent and the Grenadines, Viet Nam, Vanuatu, Samoa, Kosovo, Yemen, Rep., South Africa, Zambia, Zimbabwe, AFG, AGO, ALB, ARE, ARG, ARM, AZE, BDI, BEN, BFA, BGD, BGR, BHR, BHS, BIH, BLR, BLZ, BOL, BRA, BRB, BTN, BWA, CAF, CHL, CHN, CIV, CMR, COD, COG, COL, COM, CPV, CRI, DJI, DMA, DOM, DZA, ECU, EGY, ERI, ETH, FJI, FSM, GAB, GEO, GHA, GIN, GMB, GNB, GNQ, GRD, GTM, GUY, HND, HRV, HTI, IDN, IND, IRN, IRQ, JAM, JOR, KAZ, KEN, KGZ, KHM, KIR, KWT, LAO, LBN, LBR, LBY, LCA, LKA, LSO, MAR, MDA, MDG, MDV, MEX, MHL, MKD, MLI, MMR, MNE, MNG, MOZ, MRT, MUS, MWI, MYS, NAM, NER, NGA, NIC, NPL, NRU, OMN, PAK, PAN, PER, PHL, PLW, PNG, POL, PRY, PSE, QAT, ROU, RUS, RWA, SAU, SDN, SEN, SLB, SLE, SLV, SOM, SRB, SSD, STP, SUR, SWZ, SYC, SYR, TCD, TGO, THA, TJK, TLS, TON, TTO, TUN, TUR, TUV, TZA, UGA, UKR, URY, UZB, VCT, VNM, VUT, WSM, XKX, YEM, ZAF, ZMB, ZWE
#> 49 Afghanistan, Angola, Albania, United Arab Emirates, Argentina, Armenia, Azerbaijan, Burundi, Benin, Burkina Faso, Bangladesh, Bulgaria, Bahrain, Bahamas, The, Bosnia and Herzegovina, Belarus, Belize, Bolivia, Brazil, Barbados, Bhutan, Botswana, Central African Republic, Chile, China, Cote d'Ivoire, Cameroon, Congo, Dem. Rep., Congo, Rep., Colombia, Comoros, Cabo Verde, Costa Rica, Djibouti, Dominica, Dominican Republic, Algeria, Ecuador, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Micronesia, Fed. Sts., Gabon, Georgia, Ghana, Guinea, Gambia, The, Guinea-Bissau, Equatorial Guinea, Grenada, Guatemala, Guyana, Honduras, Croatia, Haiti, Indonesia, India, Iran, Islamic Rep., Iraq, Jamaica, Jordan, Kazakhstan, Kenya, Kyrgyz Republic, Cambodia, Kiribati, Kuwait, Lao PDR, Lebanon, Liberia, Libya, St. Lucia, Sri Lanka, Lesotho, Morocco, Moldova, Madagascar, Maldives, Mexico, Marshall Islands, North Macedonia, Mali, Myanmar, Montenegro, Mongolia, Mozambique, Mauritania, Mauritius, Malawi, Malaysia, Namibia, Niger, Nigeria, Nicaragua, Nepal, Nauru, Oman, Pakistan, Panama, Peru, Philippines, Palau, Papua New Guinea, Poland, Paraguay, West Bank and Gaza, Qatar, Romania, Russian Federation, Rwanda, Saudi Arabia, Sudan, Senegal, Solomon Islands, Sierra Leone, El Salvador, Somalia, Serbia, South Sudan, Sao Tome and Principe, Suriname, Eswatini, Seychelles, Syrian Arab Republic, Chad, Togo, Thailand, Tajikistan, Timor-Leste, Tonga, Trinidad and Tobago, Tunisia, Turkiye, Tuvalu, Tanzania, Uganda, Ukraine, Uruguay, Uzbekistan, St. Vincent and the Grenadines, Viet Nam, Vanuatu, Samoa, Kosovo, Yemen, Rep., South Africa, Zambia, Zimbabwe, AFG, AGO, ALB, ARE, ARG, ARM, AZE, BDI, BEN, BFA, BGD, BGR, BHR, BHS, BIH, BLR, BLZ, BOL, BRA, BRB, BTN, BWA, CAF, CHL, CHN, CIV, CMR, COD, COG, COL, COM, CPV, CRI, DJI, DMA, DOM, DZA, ECU, EGY, ERI, ETH, FJI, FSM, GAB, GEO, GHA, GIN, GMB, GNB, GNQ, GRD, GTM, GUY, HND, HRV, HTI, IDN, IND, IRN, IRQ, JAM, JOR, KAZ, KEN, KGZ, KHM, KIR, KWT, LAO, LBN, LBR, LBY, LCA, LKA, LSO, MAR, MDA, MDG, MDV, MEX, MHL, MKD, MLI, MMR, MNE, MNG, MOZ, MRT, MUS, MWI, MYS, NAM, NER, NGA, NIC, NPL, NRU, OMN, PAK, PAN, PER, PHL, PLW, PNG, POL, PRY, PSE, QAT, ROU, RUS, RWA, SAU, SDN, SEN, SLB, SLE, SLV, SOM, SRB, SSD, STP, SUR, SWZ, SYC, SYR, TCD, TGO, THA, TJK, TLS, TON, TTO, TUN, TUR, TUV, TZA, UGA, UKR, URY, UZB, VCT, VNM, VUT, WSM, XKX, YEM, ZAF, ZMB, ZWE
#> 50 Afghanistan, Angola, Albania, United Arab Emirates, Argentina, Armenia, Azerbaijan, Burundi, Benin, Burkina Faso, Bangladesh, Bulgaria, Bahrain, Bahamas, The, Bosnia and Herzegovina, Belarus, Belize, Bolivia, Brazil, Barbados, Bhutan, Botswana, Central African Republic, Chile, China, Cote d'Ivoire, Cameroon, Congo, Dem. Rep., Congo, Rep., Colombia, Comoros, Cabo Verde, Costa Rica, Djibouti, Dominica, Dominican Republic, Algeria, Ecuador, Egypt, Arab Rep., Eritrea, Ethiopia, Fiji, Micronesia, Fed. Sts., Gabon, Georgia, Ghana, Guinea, Gambia, The, Guinea-Bissau, Equatorial Guinea, Grenada, Guatemala, Guyana, Honduras, Croatia, Haiti, Indonesia, India, Iran, Islamic Rep., Iraq, Jamaica, Jordan, Kazakhstan, Kenya, Kyrgyz Republic, Cambodia, Kiribati, Kuwait, Lao PDR, Lebanon, Liberia, Libya, St. Lucia, Sri Lanka, Lesotho, Morocco, Moldova, Madagascar, Maldives, Mexico, Marshall Islands, North Macedonia, Mali, Myanmar, Montenegro, Mongolia, Mozambique, Mauritania, Mauritius, Malawi, Malaysia, Namibia, Niger, Nigeria, Nicaragua, Nepal, Nauru, Oman, Pakistan, Panama, Peru, Philippines, Palau, Papua New Guinea, Poland, Paraguay, West Bank and Gaza, Qatar, Romania, Russian Federation, Rwanda, Saudi Arabia, Sudan, Senegal, Solomon Islands, Sierra Leone, El Salvador, Somalia, Serbia, South Sudan, Sao Tome and Principe, Suriname, Eswatini, Seychelles, Syrian Arab Republic, Chad, Togo, Thailand, Tajikistan, Timor-Leste, Tonga, Trinidad and Tobago, Tunisia, Turkiye, Tuvalu, Tanzania, Uganda, Ukraine, Uruguay, Uzbekistan, St. Vincent and the Grenadines, Viet Nam, Vanuatu, Samoa, Kosovo, Yemen, Rep., South Africa, Zambia, Zimbabwe, AFG, AGO, ALB, ARE, ARG, ARM, AZE, BDI, BEN, BFA, BGD, BGR, BHR, BHS, BIH, BLR, BLZ, BOL, BRA, BRB, BTN, BWA, CAF, CHL, CHN, CIV, CMR, COD, COG, COL, COM, CPV, CRI, DJI, DMA, DOM, DZA, ECU, EGY, ERI, ETH, FJI, FSM, GAB, GEO, GHA, GIN, GMB, GNB, GNQ, GRD, GTM, GUY, HND, HRV, HTI, IDN, IND, IRN, IRQ, JAM, JOR, KAZ, KEN, KGZ, KHM, KIR, KWT, LAO, LBN, LBR, LBY, LCA, LKA, LSO, MAR, MDA, MDG, MDV, MEX, MHL, MKD, MLI, MMR, MNE, MNG, MOZ, MRT, MUS, MWI, MYS, NAM, NER, NGA, NIC, NPL, NRU, OMN, PAK, PAN, PER, PHL, PLW, PNG, POL, PRY, PSE, QAT, ROU, RUS, RWA, SAU, SDN, SEN, SLB, SLE, SLV, SOM, SRB, SSD, STP, SUR, SWZ, SYC, SYR, TCD, TGO, THA, TJK, TLS, TON, TTO, TUN, TUR, TUV, TZA, UGA, UKR, URY, UZB, VCT, VNM, VUT, WSM, XKX, YEM, ZAF, ZMB, ZWE
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
#> 35                                NULL
#> 36                                NULL
#> 37                                NULL
#> 38                                NULL
#> 39                                NULL
#> 40                                NULL
#> 41                                NULL
#> 42                                NULL
#> 43                                NULL
#> 44                                NULL
#> 45                                NULL
#> 46                                NULL
#> 47                                NULL
#> 48                                NULL
#> 49                                NULL
#> 50                                NULL
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
#> 35                                             NULL
#> 36                                             NULL
#> 37                                             NULL
#> 38                                             NULL
#> 39                                             NULL
#> 40                                             NULL
#> 41                                             NULL
#> 42                                             NULL
#> 43                                             NULL
#> 44                                             NULL
#> 45                                             NULL
#> 46                                             NULL
#> 47                                             NULL
#> 48                                             NULL
#> 49                                             NULL
#> 50                                             NULL
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
#> 26 CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, You are free to:\nShare — copy and redistribute the material in any medium or format for any purpose, even commercially.\nAdapt — remix, transform, and build upon the material for any purpose, even commercially.\nThe licensor cannot revoke these freedoms as long as you follow the license terms.\nUnder the following terms:\nAttribution — You must give appropriate credit , provide a link to the license, and indicate if changes were made . You may do so in any reasonable manner, but not in any way that suggests the licensor endorses you or your use.\nNo additional restrictions — You may not apply legal terms or technological measures that legally restrict others from doing anything the license permits.\nNotices:\nYou do not have to comply with the license for elements of the material in the public domain or where your use is permitted by an applicable exception or limitation .\n\nNo warranties are given. The license may not give you all of the permissions necessary for your intended use. For example, other rights such as publicity, privacy, or moral rights may limit how you use the material.
#> 27                            CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 28                            CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 29                            CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 30                            CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 31                            CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 32                            CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 33                            CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 34                            CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 35                            CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 36                            CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 37                            CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 38                            CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 39                            CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 40                            CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 41                            CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 42                            CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 43                            CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 44                            CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 45                            CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 46                            CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 47                            CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 48                            CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 49                            CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
#> 50                            CC BY 4.0, https://creativecommons.org/licenses/by/4.0/, This work is provided under a Creative Commons 4.0 Attribution International License, with the following mandatory and binding addition:i. Any and all disputes arising under this License that cannot be settled amicably shall be submitted to mediation in accordance with the WIPO Mediation Rules in effect at the time the work was published. If the request for mediation is not resolved within forty-five (45) days of the request, either You or the Licensor may, pursuant to a notice of arbitration communicated by reasonable means to the other party refer the dispute to final and binding arbitration to be conducted in accordance with UNCITRAL Arbitration Rules as then in force. The arbitral tribunal shall consist of a sole arbitrator and the language of the proceedings shall be English unless otherwise agreed. The place of arbitration shall be where the Licensor has its headquarters. The arbitral proceedings shall be conducted remotely (e.g., via telephone conference or written submissions) whenever practicable, or held at the World Bank headquarters in Washington DC.
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
#> 26                      NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA
#> 27 DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 28 DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 29 DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 30 DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 31 DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 32 DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 33 DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 34 DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 35 DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 36 DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 37 DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 38 DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 39 DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 40 DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 41 DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 42 DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 43 DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 44 DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 45 DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 46 DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 47 DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 48 DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 49 DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
#> 50 DDH, NA, https://datacatalog.worldbank.org/int/search/dataset/0038389/Macro-Poverty-Outlook, NA
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
#> 35                                 NULL
#> 36                                 NULL
#> 37                                 NULL
#> 38                                 NULL
#> 39                                 NULL
#> 40                                 NULL
#> 41                                 NULL
#> 42                                 NULL
#> 43                                 NULL
#> 44                                 NULL
#> 45                                 NULL
#> 46                                 NULL
#> 47                                 NULL
#> 48                                 NULL
#> 49                                 NULL
#> 50                                 NULL
#>                                                                                                        series_description.sources
#> 1  NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 2                                       NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org, NA, NA
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
#> 23 NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 24 NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 25 NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 26                                                        NA, NA, NA, World Bank (WB), NA, NA, https://www.worldbank.org/, NA, NA
#> 27 NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 28 NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 29 NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 30 NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 31 NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 32 NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 33 NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 34 NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 35 NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 36 NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 37 NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 38 NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 39                                      NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org, NA, NA
#> 40                                      NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org, NA, NA
#> 41                                      NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org, NA, NA
#> 42 NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 43 NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 44 NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 45                                      NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org, NA, NA
#> 46 NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 47                                      NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org, NA, NA
#> 48 NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 49 NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
#> 50 NA, NA, Macro Poverty Outlook, World Bank (WB), NA, NA, https://www.worldbank.org/en/publication/macro-poverty-outlook, NA, NA
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
#> 35                     NULL                                  NULL
#> 36                     NULL                                  NULL
#> 37                     NULL                                  NULL
#> 38                     NULL                                  NULL
#> 39                     NULL                                  NULL
#> 40                     NULL                                  NULL
#> 41                     NULL                                  NULL
#> 42                     NULL                                  NULL
#> 43                     NULL                                  NULL
#> 44                     NULL                                  NULL
#> 45                     NULL                                  NULL
#> 46                     NULL                                  NULL
#> 47                     NULL                                  NULL
#> 48                     NULL                                  NULL
#> 49                     NULL                                  NULL
#> 50                     NULL                                  NULL
#>                                                                         tags
#> 1  WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 2                                                                       NULL
#> 3  WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 4  WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 5  WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 6  WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 7  WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 8  WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 9  WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 10 WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 11 WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 12                                           WB_MPO, feature-dataset-profile
#> 13                                           WB_MPO, feature-dataset-profile
#> 14 WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 15 WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 16 WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 17 WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 18 WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 19 WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 20 WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 21 WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 22 WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 23 WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 24 WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 25         WB_MPO, GAFS_0008, feature-dataset-profile, feature-topic-profile
#> 26                                                                      NULL
#> 27 WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 28 WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 29 WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 30 WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 31 WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 32 WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 33 WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 34 WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 35 WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 36 WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 37 WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 38 WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 39                                                                      NULL
#> 40                                                                      NULL
#> 41                                                                      NULL
#> 42 WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 43 WB_MPO, Bar Chart, feature-dataset-profile, feature-dataset-profile-chart
#> 44                                                                      NULL
#> 45                                                                      NULL
#> 46                                                                      NULL
#> 47                                                                      NULL
#> 48                                                                      NULL
#> 49                                                                      NULL
#> 50                                                                      NULL
#>                                                        additional.metadata_link
#> 1                                                                          NULL
#> 2                                                                          NULL
#> 3                                                                          NULL
#> 4                                                                          NULL
#> 5                                                                          NULL
#> 6                                                                          NULL
#> 7                                                                          NULL
#> 8                                                                          NULL
#> 9                                                                          NULL
#> 10                                                                         NULL
#> 11                                                                         NULL
#> 12                                                                         NULL
#> 13                                                                         NULL
#> 14                                                                         NULL
#> 15                                                                         NULL
#> 16                                                                         NULL
#> 17                                                                         NULL
#> 18                                                                         NULL
#> 19                                                                         NULL
#> 20                                                                         NULL
#> 21                                                                         NULL
#> 22                                                                         NULL
#> 23                                                                         NULL
#> 24                                                                         NULL
#> 25                                                                         NULL
#> 26                                                                         NULL
#> 27                                                                         NULL
#> 28                                                                         NULL
#> 29                                                                         NULL
#> 30                                                                         NULL
#> 31                                                                         NULL
#> 32                                                                         NULL
#> 33                                                                         NULL
#> 34                                                                         NULL
#> 35                                                                         NULL
#> 36                                                                         NULL
#> 37                                                                         NULL
#> 38                                                                         NULL
#> 39                                                                         NULL
#> 40                                                                         NULL
#> 41                                                                         NULL
#> 42                                                                         NULL
#> 43                                                                         NULL
#> 44 primary, META_WB_WDI_SP_POP_TOTL, WB_WDI, World Development Indicators (WDI)
#> 45                                                                         NULL
#> 46                                                                         NULL
#> 47                                                                         NULL
#> 48                                                                         NULL
#> 49                                                                         NULL
#> 50                                                                         NULL
#>    additional.visualization.scale_type additional.visualization.legend_type
#> 1                                 <NA>                                 <NA>
#> 2                                 <NA>                                 <NA>
#> 3                                 <NA>                                 <NA>
#> 4                                 <NA>                                 <NA>
#> 5                                 <NA>                                 <NA>
#> 6                            diverging                                 <NA>
#> 7                            diverging                                 <NA>
#> 8                                 <NA>                                 <NA>
#> 9                                 <NA>                                 <NA>
#> 10                                <NA>                                 <NA>
#> 11                                <NA>                                 <NA>
#> 12                                <NA>                                 <NA>
#> 13                                <NA>                                 <NA>
#> 14                                <NA>                                 <NA>
#> 15                                <NA>                                 <NA>
#> 16                                <NA>                                 <NA>
#> 17                                <NA>                                 <NA>
#> 18                                <NA>                                 <NA>
#> 19                                <NA>                                 <NA>
#> 20                                <NA>                                 <NA>
#> 21                           diverging                                 <NA>
#> 22                                <NA>                                 <NA>
#> 23                                <NA>                                 <NA>
#> 24                                <NA>                                 <NA>
#> 25                                <NA>                                 <NA>
#> 26                                <NA>                                 <NA>
#> 27                           diverging                                 <NA>
#> 28                                <NA>                                 <NA>
#> 29                                <NA>                                 <NA>
#> 30                                <NA>                                 <NA>
#> 31                           diverging                                 <NA>
#> 32                                <NA>                                 <NA>
#> 33                           diverging                                 <NA>
#> 34                           diverging                                 <NA>
#> 35                                <NA>                                 <NA>
#> 36                                <NA>                                 <NA>
#> 37                           diverging                                 <NA>
#> 38                                <NA>                                 <NA>
#> 39                                <NA>                                 <NA>
#> 40                                <NA>                                 <NA>
#> 41                           diverging                                 <NA>
#> 42                           diverging                               binned
#> 43                                <NA>                                 <NA>
#> 44                                <NA>                                 <NA>
#> 45                                <NA>                                 <NA>
#> 46                                <NA>                                 <NA>
#> 47                                <NA>                                 <NA>
#> 48                                <NA>                                 <NA>
#> 49                                <NA>                                 <NA>
#> 50                                <NA>                                 <NA>
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
#> 35                                 NA                             NA
#> 36                                 NA                             NA
#> 37                                 NA                             NA
#> 38                                 NA                             NA
#> 39                                 NA                             NA
#> 40                                 NA                             NA
#> 41                                 NA                             NA
#> 42                                 NA                             NA
#> 43                                 NA                             NA
#> 44                                 NA                             NA
#> 45                                 NA                             NA
#> 46                                 NA                             NA
#> 47                                 NA                             NA
#> 48                                 NA                             NA
#> 49                                 NA                             NA
#> 50                                 NA                             NA
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
#> 35                                   NA
#> 36                                   NA
#> 37                                   NA
#> 38                                   NA
#> 39                                   NA
#> 40                                   NA
#> 41                                   NA
#> 42                                   NA
#> 43                                   NA
#> 44                                   NA
#> 45                                   NA
#> 46                                   NA
#> 47                                   NA
#> 48                                   NA
#> 49                                   NA
#> 50                                   NA
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
#> 35                                          NA
#> 36                                          NA
#> 37                                          NA
#> 38                                          NA
#> 39                                          NA
#> 40                                          NA
#> 41                                          NA
#> 42                                          NA
#> 43                                          NA
#> 44                                          NA
#> 45                                          NA
#> 46                                          NA
#> 47                                          NA
#> 48                                          NA
#> 49                                          NA
#> 50                                          NA
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
#> 35                                    NA                                   NA
#> 36                                    NA                                   NA
#> 37                                    NA                                   NA
#> 38                                    NA                                   NA
#> 39                                    NA                                   NA
#> 40                                    NA                                   NA
#> 41                                    NA                                   NA
#> 42                                    NA                                   NA
#> 43                                    NA                                   NA
#> 44                                    NA                                   NA
#> 45                                    NA                                   NA
#> 46                                    NA                                   NA
#> 47                                    NA                                   NA
#> 48                                    NA                                   NA
#> 49                                    NA                                   NA
#> 50                                    NA                                   NA
#>    additional.visualization.div_params
#> 1                                 NULL
#> 2                                 NULL
#> 3                                 NULL
#> 4                                 NULL
#> 5                                 NULL
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
#> 17                                NULL
#> 18                                NULL
#> 19                                NULL
#> 20                                NULL
#> 21                           NA, 0, NA
#> 22                                NULL
#> 23                                NULL
#> 24                                NULL
#> 25                                NULL
#> 26                                NULL
#> 27                           NA, 0, NA
#> 28                                NULL
#> 29                                NULL
#> 30                                NULL
#> 31                           NA, 0, NA
#> 32                                NULL
#> 33                           NA, 0, NA
#> 34                           NA, 0, NA
#> 35                                NULL
#> 36                                NULL
#> 37                           NA, 0, NA
#> 38                                NULL
#> 39                                NULL
#> 40                                NULL
#> 41                           NA, 0, NA
#> 42                           NA, 0, NA
#> 43                                NULL
#> 44                                NULL
#> 45                                NULL
#> 46                                NULL
#> 47                                NULL
#> 48                                NULL
#> 49                                NULL
#> 50                                NULL
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
#> 35                                      NULL
#> 36                                      NULL
#> 37                                      NULL
#> 38                                      NULL
#> 39                                      NULL
#> 40                                      NULL
#> 41                                      NULL
#> 42                                      NULL
#> 43                                      NULL
#> 44                                      NULL
#> 45                                      NULL
#> 46                                      NULL
#> 47                                      NULL
#> 48                                      NULL
#> 49                                      NULL
#> 50                                      NULL
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
#> 35                                NULL                                  NULL
#> 36                                NULL                                  NULL
#> 37                                NULL                                  NULL
#> 38                                NULL                                  NULL
#> 39                                NULL                                  NULL
#> 40                                NULL                                  NULL
#> 41                                NULL                                  NULL
#> 42                   7, percentile, NA                                  NULL
#> 43                                NULL                                  NULL
#> 44                                NULL                                  NULL
#> 45                                NULL                                  NULL
#> 46                                NULL                                  NULL
#> 47                                NULL                                  NULL
#> 48                                NULL                                  NULL
#> 49                                NULL                                  NULL
#> 50                                NULL                                  NULL
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
#> 35      NA
#> 36      NA
#> 37      NA
#> 38      NA
#> 39      NA
#> 40      NA
#> 41      NA
#> 42      NA
#> 43      NA
#> 44      NA
#> 45      NA
#> 46      NA
#> 47      NA
#> 48      NA
#> 49      NA
#> 50      NA
#>                                                                                            disaggregation_codes
#> 1  COMP_BREAKDOWN_1, WB_MPO_VINTAGE_AM_2024, WB_MPO_VINTAGE_SM_2024, WB_MPO_VINTAGE_SM_2025, Custom Dimension 1
#> 2  COMP_BREAKDOWN_1, WB_MPO_VINTAGE_AM_2024, WB_MPO_VINTAGE_SM_2024, WB_MPO_VINTAGE_SM_2025, Custom Dimension 1
#> 3  COMP_BREAKDOWN_1, WB_MPO_VINTAGE_AM_2024, WB_MPO_VINTAGE_SM_2024, WB_MPO_VINTAGE_SM_2025, Custom Dimension 1
#> 4  COMP_BREAKDOWN_1, WB_MPO_VINTAGE_AM_2024, WB_MPO_VINTAGE_SM_2024, WB_MPO_VINTAGE_SM_2025, Custom Dimension 1
#> 5  COMP_BREAKDOWN_1, WB_MPO_VINTAGE_AM_2024, WB_MPO_VINTAGE_SM_2024, WB_MPO_VINTAGE_SM_2025, Custom Dimension 1
#> 6  COMP_BREAKDOWN_1, WB_MPO_VINTAGE_AM_2024, WB_MPO_VINTAGE_SM_2024, WB_MPO_VINTAGE_SM_2025, Custom Dimension 1
#> 7  COMP_BREAKDOWN_1, WB_MPO_VINTAGE_AM_2024, WB_MPO_VINTAGE_SM_2024, WB_MPO_VINTAGE_SM_2025, Custom Dimension 1
#> 8  COMP_BREAKDOWN_1, WB_MPO_VINTAGE_AM_2024, WB_MPO_VINTAGE_SM_2024, WB_MPO_VINTAGE_SM_2025, Custom Dimension 1
#> 9  COMP_BREAKDOWN_1, WB_MPO_VINTAGE_AM_2024, WB_MPO_VINTAGE_SM_2024, WB_MPO_VINTAGE_SM_2025, Custom Dimension 1
#> 10 COMP_BREAKDOWN_1, WB_MPO_VINTAGE_AM_2024, WB_MPO_VINTAGE_SM_2024, WB_MPO_VINTAGE_SM_2025, Custom Dimension 1
#> 11 COMP_BREAKDOWN_1, WB_MPO_VINTAGE_AM_2024, WB_MPO_VINTAGE_SM_2024, WB_MPO_VINTAGE_SM_2025, Custom Dimension 1
#> 12 COMP_BREAKDOWN_1, WB_MPO_VINTAGE_AM_2024, WB_MPO_VINTAGE_SM_2024, WB_MPO_VINTAGE_SM_2025, Custom Dimension 1
#> 13 COMP_BREAKDOWN_1, WB_MPO_VINTAGE_AM_2024, WB_MPO_VINTAGE_SM_2024, WB_MPO_VINTAGE_SM_2025, Custom Dimension 1
#> 14 COMP_BREAKDOWN_1, WB_MPO_VINTAGE_AM_2024, WB_MPO_VINTAGE_SM_2024, WB_MPO_VINTAGE_SM_2025, Custom Dimension 1
#> 15 COMP_BREAKDOWN_1, WB_MPO_VINTAGE_AM_2024, WB_MPO_VINTAGE_SM_2024, WB_MPO_VINTAGE_SM_2025, Custom Dimension 1
#> 16 COMP_BREAKDOWN_1, WB_MPO_VINTAGE_AM_2024, WB_MPO_VINTAGE_SM_2024, WB_MPO_VINTAGE_SM_2025, Custom Dimension 1
#> 17 COMP_BREAKDOWN_1, WB_MPO_VINTAGE_AM_2024, WB_MPO_VINTAGE_SM_2024, WB_MPO_VINTAGE_SM_2025, Custom Dimension 1
#> 18 COMP_BREAKDOWN_1, WB_MPO_VINTAGE_AM_2024, WB_MPO_VINTAGE_SM_2024, WB_MPO_VINTAGE_SM_2025, Custom Dimension 1
#> 19 COMP_BREAKDOWN_1, WB_MPO_VINTAGE_AM_2024, WB_MPO_VINTAGE_SM_2024, WB_MPO_VINTAGE_SM_2025, Custom Dimension 1
#> 20 COMP_BREAKDOWN_1, WB_MPO_VINTAGE_AM_2024, WB_MPO_VINTAGE_SM_2024, WB_MPO_VINTAGE_SM_2025, Custom Dimension 1
#> 21 COMP_BREAKDOWN_1, WB_MPO_VINTAGE_AM_2024, WB_MPO_VINTAGE_SM_2024, WB_MPO_VINTAGE_SM_2025, Custom Dimension 1
#> 22 COMP_BREAKDOWN_1, WB_MPO_VINTAGE_AM_2024, WB_MPO_VINTAGE_SM_2024, WB_MPO_VINTAGE_SM_2025, Custom Dimension 1
#> 23 COMP_BREAKDOWN_1, WB_MPO_VINTAGE_AM_2024, WB_MPO_VINTAGE_SM_2024, WB_MPO_VINTAGE_SM_2025, Custom Dimension 1
#> 24 COMP_BREAKDOWN_1, WB_MPO_VINTAGE_AM_2024, WB_MPO_VINTAGE_SM_2024, WB_MPO_VINTAGE_SM_2025, Custom Dimension 1
#> 25 COMP_BREAKDOWN_1, WB_MPO_VINTAGE_AM_2024, WB_MPO_VINTAGE_SM_2024, WB_MPO_VINTAGE_SM_2025, Custom Dimension 1
#> 26                                                                                                         NULL
#> 27 COMP_BREAKDOWN_1, WB_MPO_VINTAGE_AM_2024, WB_MPO_VINTAGE_SM_2024, WB_MPO_VINTAGE_SM_2025, Custom Dimension 1
#> 28 COMP_BREAKDOWN_1, WB_MPO_VINTAGE_AM_2024, WB_MPO_VINTAGE_SM_2024, WB_MPO_VINTAGE_SM_2025, Custom Dimension 1
#> 29 COMP_BREAKDOWN_1, WB_MPO_VINTAGE_AM_2024, WB_MPO_VINTAGE_SM_2024, WB_MPO_VINTAGE_SM_2025, Custom Dimension 1
#> 30 COMP_BREAKDOWN_1, WB_MPO_VINTAGE_AM_2024, WB_MPO_VINTAGE_SM_2024, WB_MPO_VINTAGE_SM_2025, Custom Dimension 1
#> 31 COMP_BREAKDOWN_1, WB_MPO_VINTAGE_AM_2024, WB_MPO_VINTAGE_SM_2024, WB_MPO_VINTAGE_SM_2025, Custom Dimension 1
#> 32 COMP_BREAKDOWN_1, WB_MPO_VINTAGE_AM_2024, WB_MPO_VINTAGE_SM_2024, WB_MPO_VINTAGE_SM_2025, Custom Dimension 1
#> 33 COMP_BREAKDOWN_1, WB_MPO_VINTAGE_AM_2024, WB_MPO_VINTAGE_SM_2024, WB_MPO_VINTAGE_SM_2025, Custom Dimension 1
#> 34 COMP_BREAKDOWN_1, WB_MPO_VINTAGE_AM_2024, WB_MPO_VINTAGE_SM_2024, WB_MPO_VINTAGE_SM_2025, Custom Dimension 1
#> 35 COMP_BREAKDOWN_1, WB_MPO_VINTAGE_AM_2024, WB_MPO_VINTAGE_SM_2024, WB_MPO_VINTAGE_SM_2025, Custom Dimension 1
#> 36 COMP_BREAKDOWN_1, WB_MPO_VINTAGE_AM_2024, WB_MPO_VINTAGE_SM_2024, WB_MPO_VINTAGE_SM_2025, Custom Dimension 1
#> 37                                                                                                         NULL
#> 38 COMP_BREAKDOWN_1, WB_MPO_VINTAGE_AM_2024, WB_MPO_VINTAGE_SM_2024, WB_MPO_VINTAGE_SM_2025, Custom Dimension 1
#> 39 COMP_BREAKDOWN_1, WB_MPO_VINTAGE_AM_2024, WB_MPO_VINTAGE_SM_2024, WB_MPO_VINTAGE_SM_2025, Custom Dimension 1
#> 40 COMP_BREAKDOWN_1, WB_MPO_VINTAGE_AM_2024, WB_MPO_VINTAGE_SM_2024, WB_MPO_VINTAGE_SM_2025, Custom Dimension 1
#> 41 COMP_BREAKDOWN_1, WB_MPO_VINTAGE_AM_2024, WB_MPO_VINTAGE_SM_2024, WB_MPO_VINTAGE_SM_2025, Custom Dimension 1
#> 42 COMP_BREAKDOWN_1, WB_MPO_VINTAGE_AM_2024, WB_MPO_VINTAGE_SM_2024, WB_MPO_VINTAGE_SM_2025, Custom Dimension 1
#> 43 COMP_BREAKDOWN_1, WB_MPO_VINTAGE_AM_2024, WB_MPO_VINTAGE_SM_2024, WB_MPO_VINTAGE_SM_2025, Custom Dimension 1
#> 44 COMP_BREAKDOWN_1, WB_MPO_VINTAGE_AM_2024, WB_MPO_VINTAGE_SM_2024, WB_MPO_VINTAGE_SM_2025, Custom Dimension 1
#> 45 COMP_BREAKDOWN_1, WB_MPO_VINTAGE_AM_2024, WB_MPO_VINTAGE_SM_2024, WB_MPO_VINTAGE_SM_2025, Custom Dimension 1
#> 46 COMP_BREAKDOWN_1, WB_MPO_VINTAGE_AM_2024, WB_MPO_VINTAGE_SM_2024, WB_MPO_VINTAGE_SM_2025, Custom Dimension 1
#> 47 COMP_BREAKDOWN_1, WB_MPO_VINTAGE_AM_2024, WB_MPO_VINTAGE_SM_2024, WB_MPO_VINTAGE_SM_2025, Custom Dimension 1
#> 48 COMP_BREAKDOWN_1, WB_MPO_VINTAGE_AM_2024, WB_MPO_VINTAGE_SM_2024, WB_MPO_VINTAGE_SM_2025, Custom Dimension 1
#> 49 COMP_BREAKDOWN_1, WB_MPO_VINTAGE_AM_2024, WB_MPO_VINTAGE_SM_2024, WB_MPO_VINTAGE_SM_2025, Custom Dimension 1
#> 50 COMP_BREAKDOWN_1, WB_MPO_VINTAGE_AM_2024, WB_MPO_VINTAGE_SM_2024, WB_MPO_VINTAGE_SM_2025, Custom Dimension 1
#>    admin_metadata.gafs.visualization  admin_metadata.gafs.topics
#> 1                                 NA                        NULL
#> 2                                 NA                        NULL
#> 3                                 NA                        NULL
#> 4                                 NA                        NULL
#> 5                                 NA                        NULL
#> 6                                 NA                        NULL
#> 7                                 NA                        NULL
#> 8                                 NA                        NULL
#> 9                                 NA                        NULL
#> 10                                NA                        NULL
#> 11                                NA                        NULL
#> 12                                NA                        NULL
#> 13                                NA                        NULL
#> 14                                NA                        NULL
#> 15                                NA                        NULL
#> 16                                NA                        NULL
#> 17                                NA                        NULL
#> 18                                NA                        NULL
#> 19                                NA                        NULL
#> 20                                NA                        NULL
#> 21                                NA                        NULL
#> 22                                NA                        NULL
#> 23                                NA                        NULL
#> 24                                NA                        NULL
#> 25                                NA GAFS_0008, NA, GAFS, NA, NA
#> 26                                NA                        NULL
#> 27                                NA                        NULL
#> 28                                NA                        NULL
#> 29                                NA                        NULL
#> 30                                NA                        NULL
#> 31                                NA                        NULL
#> 32                                NA                        NULL
#> 33                                NA                        NULL
#> 34                                NA                        NULL
#> 35                                NA                        NULL
#> 36                                NA                        NULL
#> 37                                NA                        NULL
#> 38                                NA                        NULL
#> 39                                NA                        NULL
#> 40                                NA                        NULL
#> 41                                NA                        NULL
#> 42                                NA                        NULL
#> 43                                NA                        NULL
#> 44                                NA                        NULL
#> 45                                NA                        NULL
#> 46                                NA                        NULL
#> 47                                NA                        NULL
#> 48                                NA                        NULL
#> 49                                NA                        NULL
#> 50                                NA                        NULL
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
#> 25 GAFS_0008, feature-topic-profile
#> 26                             NULL
#> 27                             NULL
#> 28                             NULL
#> 29                             NULL
#> 30                             NULL
#> 31                             NULL
#> 32                             NULL
#> 33                             NULL
#> 34                             NULL
#> 35                             NULL
#> 36                             NULL
#> 37                             NULL
#> 38                             NULL
#> 39                             NULL
#> 40                             NULL
#> 41                             NULL
#> 42                             NULL
#> 43                             NULL
#> 44                             NULL
#> 45                             NULL
#> 46                             NULL
#> 47                             NULL
#> 48                             NULL
#> 49                             NULL
#> 50                             NULL
#> 
#> $`@odata.nextLink`
#> [1] "https://itsda-dataexp-prd.search.windows.net/indexes/data360-metadata/docs?api-version=2020-06-30&$count=true&search=WB_MPO&$skip=50"
#> 
```
