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
    MES_REFERENCIA == 9 &
      ANO_PAGAMENTO >= 2014
  )

contract_inactive <- contract_inactive_list |>
  bind_rows() |>
  filter(
    MES_REFERENCIA == 9 &
      ANO_PAGAMENTO >= 2014
  )

bra_hrmis <- contract_active |>
  bind_rows(
    contract_inactive
  )


### first lets select the set of people we will take
set.seed(123)
  
personnel_list <- 
  bra_hrmis |>
  dplyr::distinct(CPF) |>
  dplyr::slice_sample(n = 1000) |>
  dplyr::pull(CPF)

# anonymize the CPF
bra_hrmis <- 
  bra_hrmis |>
  dplyr::filter(CPF %in% personnel_list) |>
  mutate(
    CPF = purrr::map_chr(CPF, digest, algo = "sha256")
  )

# import clean data -------------------------------------------------------
### lets select the data to be lazy loaded
contract_tbl <- arrow::read_parquet("spielplatz/data/contract_alagoas_tbl.parquet")
personnel_tbl <- arrow::read_parquet("spielplatz/data/personnel_alagoas_tbl.parquet")
est_tbl <- arrow::read_parquet("spielplatz/data/est_alagoas_tbl.parquet")


edu_levels <- c(
  "No education",
  "Primary incomplete",
  "Primary complete",
  "Secondary incomplete",
  "Secondary complete",
  "Higher than secondary but not university",
  "University incomplete or complete"
)

bra_hrmis_personnel <-
personnel_tbl |>
  dplyr::filter(personnel_id %in% personnel_list) |>
  dplyr::collect() |>
  # tibble::as_tibble() |>
  dplyr::mutate(
    educat7 = factor(educat7, levels = edu_levels, ordered = TRUE)
  )

bra_hrmis_contract <-
contract_tbl |>
  dplyr::filter(personnel_id %in% bra_hrmis_personnel$personnel_id) |>
  dplyr::collect()
  # tibble::as_tibble()

bra_hrmis_est <-
  est_tbl |>
  dplyr::filter(est_id %in% unique(bra_hrmis_contract$est_id)) |>
  dplyr::collect() 
  # tibble::as_tibble()


# write-out ---------------------------------------------------------------
usethis::use_data(bra_hrmis, overwrite = TRUE)

# modules
usethis::use_data(bra_hrmis_contract, overwrite = TRUE)
usethis::use_data(bra_hrmis_personnel, overwrite = TRUE)
usethis::use_data(bra_hrmis_est, overwrite = TRUE)
