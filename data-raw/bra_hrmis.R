library(dplyr)
library(readxl)
library(furrr)
library(writexl)
library(digest)
library(labourR)
library(readr)
library(here)
library(purrr)
library(arrow)

devtools::load_all()

# read-in data ------------------------------------------------------------
file_path <- "//egvpi/egvpi/data/harmonization/HRM/BRA/data-raw/6. Wage Bill AL/3. Microdados"

plan(multisession, workers = 6)

contract_active_list <-
  list.files(path = file_path,
             pattern = "^Ativos_[0-9]{4}\\.xlsx$",
             full.names = T) |>
  future_map(\(file) read_xlsx(file, na = c("", "-"), col_types = "text"))

contract_inactive_list <-
  list.files(path = file_path,
             pattern = "^Inativos_[0-9]{4}\\.xlsx$",
             full.names = T) |>
  future_map(\(file) read_xlsx(file, na = c("", "-"), col_types = "text"))

# combine data ------------------------------------------------------------
contract_active <- contract_active_list |>
  bind_rows() |>
  filter(
    # MES_REFERENCIA == 9 &
      ANO_PAGAMENTO >= 2014
  )

contract_inactive <- contract_inactive_list |>
  bind_rows() |>
  filter(
    # MES_REFERENCIA == 9 &
      ANO_PAGAMENTO >= 2014
  )

bra_hrmis <- contract_active |>
  bind_rows(
    contract_inactive
  )


### first lets select the set of people we will take
set.seed(123)
  


# import clean data -------------------------------------------------------
### lets select the data to be lazy loaded
contract_tbl <- arrow::read_parquet("spielplatz/data/contract_alagoas_tbl.parquet")
personnel_tbl <- arrow::read_parquet("spielplatz/data/personnel_alagoas_tbl.parquet")
est_tbl <- arrow::read_parquet("spielplatz/data/est_alagoas_tbl.parquet")
allowance_tbl <- arrow::read_parquet("spielplatz/data/allowance_alagoas_tbl.parquet")


### aligning the data with the latest dictionary
personnel_tbl <- 
  personnel_tbl |>
  mutate(employment_status = case_when(
    employment_status == "inactive" ~ "pensioner",
    .default = "active"
  ))


# edu_levels <- c(
#   "No education",
#   "Primary incomplete",
#   "Primary complete",
#   "Secondary incomplete",
#   "Secondary complete",
#   "Higher than secondary but not university",
#   "University incomplete or complete"
# )

## compute the employment start date for each individual
empstart_tbl <- 
  contract_tbl |> 
  group_by(personnel_id) |>
  filter(start_date == min(start_date)) |> 
  select(personnel_id, start_date) |>
  rename(first_employment_date = "start_date") |>
  distinct()

personnel_tbl <-
  personnel_tbl |> 
  left_join(empstart_tbl, by = "personnel_id")

### lets quickly prepare the establishment data
# Extended English stopwords — add all the noise tokens
my_stopwords <- c(
  # standard English
  "a","an","the","and","or","of","in","to","for","with","on","at","by",
  "from","is","are","was","were","be","been","being","have","has","had",
  "do","does","did","will","would","could","should","may","might","shall",
  "can","that","this","it","its","as","not","but","if","so","up","out","into",
  # domain noise — generic gov/place terms that add no COFOG signal
  "s","al","alagoas","alagoa","alagoana","ahdual","dos","state","sec",
  "official","process","company","personnel","support","secretariat",
  "secretary","department","agency","board","institute","foundation",
  "general","office"
)

# Enriched taxonomy — every content token from bucket 2 placed correctly
cofog_taxonomy <- c(
  "General Public Services" = "executive legislative government administration financial fiscal
                               affairs external affairs public debt ombudsman controller audit
                               planning management modernization communication regulatory expertise
                               governor vice articulation political military civil attorney auditors
                               court finance assets computer inf technology information superintendence
                               inspection oversight coordination",

  "Defence"                 = "defence military armed forces national security army navy air force
                               defense agricultural inspection",

  "Public Order and Safety" = "public order safety police fire brigade law courts prison penitentiary
                               penitential justice civil defense security violence prevention
                               resocialization correctional detention",

  "Economic Affairs"        = "economic affairs agriculture agricultural agrarian livestock fisheries
                               aquaculture rural development infrastructure transport roads road
                               transit energy industry trade tourism labor employment innovation
                               technology metrology quality standards land reform supply engineering
                               construction transportation urban development consumer protection
                               foment inspection",

  "Environmental Protection"= "environmental protection ecology water resources natural resources
                               sustainability sustainable pollution waste conservation environment",

  "Housing and Community Amenities" = "housing community amenities urban housing development
                                       water supply habitation",

  "Health"                  = "health medical hospital public health sanitation nursing clinical
                               care health sciences assistance servants employees",

  "Recreation, Culture and Religion" = "recreation culture religion sport leisure youth theater arts
                                        heritage museum library entertainment palmares zumbi cultural",

  "Education"               = "education teaching school university learning professional training
                               research science higher education knowledge",

  "Social Protection"       = "social protection assistance welfare pension retirement retirees
                               assets resocialization social inclusion women citizenship human rights
                               family poverty vulnerability"
)

cofogclass_tbl <- classify_text(
  corpus      = est_tbl |> distinct(est_id, est_name_en),
  taxonomy    = cofog_taxonomy,
  id_col      = "est_id",
  text_col    = "est_name_en",
  num_leaves  = 1,
  method      = "cosine",
  stopwords   = my_stopwords
) |>
  # keep only the top-scoring COFOG category per organization
  {\(dt) dt[, .SD[which.max(score)], by = est_id]}()

est_tbl <- 
  est_tbl |>
  left_join(cofogclass_tbl |> 
              select(est_id, class_id) |> 
              distinct() |> 
              rename(sector = "class_id"),
            by = "est_id")

est_tbl$adm1_name <- NULL
est_tbl$adm1_code <- NULL
est_tbl$est_parent <- NULL
est_tbl$est_child <- NULL

bra_hrmis_est <- est_tbl

## lets select a random set of contracts, personnel and establishments for the lazy load

# personnel_list <- 
#   bra_hrmis |>
#   dplyr::distinct(CPF) |>
#   dplyr::slice_sample(n = 1000) |>
#   dplyr::pull(CPF)

# # anonymize the CPF
# bra_hrmis <- 
#   bra_hrmis |>
#   dplyr::filter(CPF %in% personnel_list) |>
#   mutate(
#     CPF = purrr::map_chr(CPF, digest, algo = "sha256")
#   )
set.seed(123)

personnel_list <- 
  contract_tbl |>
  dplyr::distinct(personnel_id) |>
  dplyr::slice_sample(n = 2000) |>
  dplyr::pull(personnel_id)

bra_hrmis_contract <- 
  contract_tbl |>
  filter(personnel_id %in% personnel_list)

bra_hrmis_personnel <- 
  personnel_tbl |>
  filter(personnel_id %in% personnel_list)

bra_hrmis <- 
  bra_hrmis |> 
  filter(CPF %in% personnel_list)

bra_hrmis_allowance <- 
  allowance_tbl |>
  left_join(contract_tbl |> select(contract_id, personnel_id, ref_date) |> distinct(),
            by = c("contract_id", "ref_date")) |>
  filter(personnel_id %in% personnel_list)

# write-out ---------------------------------------------------------------
usethis::use_data(bra_hrmis, overwrite = TRUE)

# modules
usethis::use_data(bra_hrmis_contract, overwrite = TRUE)
usethis::use_data(bra_hrmis_personnel, overwrite = TRUE)
usethis::use_data(bra_hrmis_est, overwrite = TRUE)
usethis::use_data(bra_hrmis_allowance, overwrite = TRUE)