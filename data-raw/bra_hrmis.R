library(dplyr)
library(readxl)
library(furrr)
library(writexl)
library(digest)
library(labourR)
library(readr)
library(here)

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

# anonymize the CPF
bra_hrmis <- bra_hrmis |>
  mutate(
    CPF = map_chr(CPF, digest, algo = "sha256")
  )

# import clean data -------------------------------------------------------
bra_hrmis_contract <- read_rds(
  here("spielplatz", "data", "bra_hrmis_contract.rds")
) |>
  filter(
    lubridate::year(ref_date) >= 2014
  )

bra_hrmis_personnel <- read_rds(
  here("spielplatz", "data", "bra_hrmis_personnel.rds")
) |>
  filter(
    lubridate::year(ref_date) >= 2014
  )

bra_hrmis_est <- read_rds(
  here("spielplatz", "data", "bra_hrmis_establishment.rds")
)

# write-out ---------------------------------------------------------------
usethis::use_data(bra_hrmis, overwrite = TRUE)

# modules
usethis::use_data(bra_hrmis_contract, overwrite = TRUE)
usethis::use_data(bra_hrmis_personnel, overwrite = TRUE)
usethis::use_data(bra_hrmis_est, overwrite = TRUE)
