################################################################################
######## CREATING A UNIQUE CONTRACT DATASET FROM THE ALAGOAS HRMIS DATA ########
################################################################################

### install package from github if not already available
# remotes::install_github("worldbank/dlw")

library(dplyr)
library(readxl)
library(purrr)
library(furrr)
library(writexl)
library(pointblank)
library(labourR)
library(stringr)
library(polyglotr)
library(here)
library(tidyr)
devtools::load_all()

dir.create(
  here("inst", "extdata"),
  recursive = TRUE
)

# read-in data ------------------------------------------------------------
file_path <- "//egvpi/egvpi/data/harmonization/HRM/BRA/data-raw/6. Wage Bill AL/3. Microdados"

plan(multisession, personnels = 6)

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

#### quickly harmonize column classes
active_alagoas_tbl <- bind_rows(contract_active_list)
inactive_alagoas_tbl <- bind_rows(contract_inactive_list)

#### apparently we ought to keep only September
active_alagoas_tbl <-
  active_alagoas_tbl |>
  filter(MES_REFERENCIA == 9)

##### now we are ready to harmonize!

###### first let us confirm our data is unique at the matricula level
###### lets check how contracts there are to unique personnels
active_alagoas_tbl |>
  group_by(ANO_PAGAMENTO) |>
  summarize(unique_cpf = length(unique(CPF)), nobs = length(CPF))

active_alagoas_tbl |>
  group_by(ANO_PAGAMENTO) |>
  summarize(unique_mtr = length(unique(MATRICULA)), nobs = length(MATRICULA))

### reclassify isco occupations for the contracted or retired personnels
inactive_alagoas_tbl <-
  inactive_alagoas_tbl |>
  mutate(CARREIRA = CARGO)

occup_df <-
  bind_rows(
    active_alagoas_tbl |>
      dplyr::select(CARREIRA, CARGO) |>
      mutate(status = "active"),
    inactive_alagoas_tbl |>
      dplyr::select(CARREIRA, CARGO) |>
      mutate(status = "inactive")
  ) |>
  distinct()

### lets concatenate the set of occupations and have them all translated at once
safe_translate <- possibly(
  ~ google_translate(.x, target_language = "en", source_language = "auto"),
  otherwise = NA_character_
)

translated <- map_chr(occup_df$CARREIRA, function(x) {
  Sys.sleep(runif(1, 1, 2))   # polite delay
  safe_translate(x)
})

# occup_df <- 
#   mutate(
#     occupation_native  = str_to_lower(CARREIRA),
#     occupation_english = str_to_lower(
#       google_translate(text = CARREIRA, source_language = "pt", target_language = "en")
#     )
#   )

occup_df <-
  occup_df |>
  mutate(occupation_native = str_to_lower(CARREIRA),
         occupation_english = str_to_lower(translated))

class_occup_df <-
  occup_df |>
  mutate(id = 1:n(), text = occupation_english) |>
  dplyr::select(id, text) |>
  classify_occupation(
    isco_level = 4,
    lang = "en",
    num_leaves = 1
  )

occup_df <-
  occup_df |>
  mutate(id = 1:n()) |>
  merge(
    y = class_occup_df |>
      dplyr::select(id, iscoGroup),
    by = "id",
    all.x = TRUE
  ) |>
  rename(occupation_iscocode = "iscoGroup") |>
  merge(
    isco |>
      dplyr::select(unit, description) |>
      rename(occupation_isconame = "description"),
    by.x = "occupation_iscocode",
    by.y = "unit",
    all.x = TRUE
  ) |>
  as_tibble()

## bring the classified occupations to the original data
active_alagoas_tbl <-
  active_alagoas_tbl |>
  merge(
    occup_df |>
      dplyr::filter(status == "active" &
                      !is.na(occupation_iscocode)) |>
      dplyr::select(CARGO, CARREIRA, starts_with("occupation_")),
    by = c("CARGO", "CARREIRA"),
    all.x = TRUE
  ) |>
  as_tibble()

inactive_alagoas_tbl <-
  inactive_alagoas_tbl |>
  merge(
    occup_df |>
      dplyr::filter(status == "inactive" &
                      !is.na(occupation_iscocode)) |>
      dplyr::select(CARGO, CARREIRA, starts_with("occupation_")),
    by = c("CARGO", "CARREIRA"),
    all.x = TRUE
  ) |>
  as_tibble()

### first let us figure out how many contracts each person has per year
contract_alagoas_tbl <-
  bind_rows(
    active_alagoas_tbl |>
      transmute(contract_id = MATRICULA,
                personnel_id = CPF,
                est_id = ORGAO,
                ref_date = as.Date(paste(ANO_PAGAMENTO, MES_REFERENCIA, "01", sep = "-")),
                base_salary_lcu = SALARIO_BASE,
                allowance_lcu = ABONO_PERMANENCIA,
                gross_salary_lcu = SALARIO_BRUTO,
                net_salary_lcu = SALARIO_LIQUIDO,
                whours = as.numeric(JORNADA),
                start_date = as.Date(as.integer(DATA_ADMISSAO), origin = "1899-12-30"),
                end_date = NA,
                paygrade = CLASSE,
                seniority = NIVEL,
                occupation_native = occupation_native,
                occupation_english = occupation_english,
                occupation_iscocode = occupation_iscocode,
                occupation_isconame = occupation_isconame,
                contract_type_native = TIPO_CONTRATO,
                contract_type = case_when(TIPO_CONTRATO %in% c("EFETIVO", "EFETIVO COMISSIONADO") ~ "permanent",
                                          TIPO_CONTRATO == "EXCLUSIVAMENTE COMISSIONADO" ~ "fixed-term",
                                          TIPO_CONTRATO %in% c("TEMPORÁRIO", "TEMPOR¡RIO") ~ "short-term",
                                            is.na(TIPO_CONTRATO) ~ NA_character_,
                                            TRUE ~ "other")),
    inactive_alagoas_tbl |>
      transmute(
        contract_id = MATRICULA,
        personnel_id = CPF,
        est_id = ORGAO,
        ref_date = as.Date(paste(ANO_PAGAMENTO, MES_REFERENCIA, "01", sep = "-")),
        base_salary_lcu = NA,
        allowance_lcu = NA,
        gross_salary_lcu = VALOR_BRUTO,
        net_salary_lcu = VALOR_LIQUIDO,
        whours = 0,
        start_date = as.Date(as.integer(DATA_ADMISSAO), origin = "1899-12-30"),
        end_date = as.Date(as.integer(DATA_APOSENTADORIA), origin = "1899-12-30"),
        paygrade = CLASSE,
        seniority = NIVEL,
        occupation_native = occupation_native,
        occupation_english = occupation_english,
        occupation_iscocode = occupation_iscocode,
        occupation_isconame = occupation_isconame,
        contract_type_native = TIPO_CONTRATO,
        contract_type = NA_character_)
  )

contract_alagoas_tbl <-
  contract_alagoas_tbl %>%
  mutate(across(
    c(ends_with("_lcu"), whours),
    ~ as.numeric(.)
  ))


### quickly create the allowance harmonization
allowance_tbl <- 
  active_alagoas_tbl |>
              transmute(contract_id = MATRICULA,
                        ref_date = as.Date(paste(ANO_PAGAMENTO, MES_REFERENCIA, "01", sep = "-")),
                        ADICIONAL_TEMPO_SERVICO, 
                        COMISSAO, 
                        ABONO_PERMANENCIA, 
                        DEMAIS_GRATIFICACOES_CARREIRA,
                        DEMAIS_GRATIFICACOES_TRANSITORIAS) |>
              pivot_longer(cols = -c(contract_id, ref_date),
                           names_to = "allowance_type",
                           values_to = "allowance_lcu")


arrow::write_parquet(occup_df, 
                     "spielplatz/data/occupations_tbl.parquet",
                     compression = "zstd",
                     compression_level = 22)

arrow::write_parquet(contract_alagoas_tbl, 
                     "spielplatz/data/contract_alagoas_tbl.parquet", 
                     compression = "zstd", 
                     compression_level = 22)

arrow::write_parquet(allowance_tbl,
                     "spielplatz/data/allowance_alagoas_tbl.parquet", 
                     compression = "zstd", 
                     compression_level = 22)

