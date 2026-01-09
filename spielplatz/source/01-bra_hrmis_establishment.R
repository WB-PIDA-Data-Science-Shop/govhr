################################################################################
######## TESTING THE INTENDED HARMONIZATION PROCESS WITH THE BRAZIL DATA #######
################################################################################
library(dplyr)
library(readr)
library(polyglotr)
library(readxl)
library(purrr)
library(furrr)
library(polyglotr)
library(tidyr)
library(writexl)
library(here)

plan(multisession, personnels = 6)
set.seed(1789)

# read-in data ------------------------------------------------------------
file_path <- "//egvpi/egvpi/data/harmonization/HRM/BRA/data-raw/6. Wage Bill AL/3. Microdados"

active_alagoastbl_list <-
  list.files(path = file_path,
             pattern = "^Ativos_[0-9]{4}\\.xlsx$",
             full.names = T) |>
  future_map(\(file) read_xlsx(file, na = c("", "-"), col_types = "text"))

inactive_alagoastbl_list <-
  list.files(path = file_path,
             pattern = "^Inativos_[0-9]{4}\\.xlsx$",
             full.names = T) |>
  future_map(\(file) read_xlsx(file, na = c("", "-"), col_types = "text"))

### lets quickly label the raw data
act_list <-
  c(
    ANO_PAGAMENTO = "Year of payment (e.g., 2022)",
    MES_REFERENCIA = "Reference month (e.g., 1–12)",
    MATRICULA = "Employee registration number",
    CPF = "CPF (taxpayer ID)",
    DATA_NASCIMENTO = "Date of birth",
    GENERO = "Gender (M/F)",
    ESCOLARIDADE = "Education level",
    DATA_ADMISSAO = "Date of hiring / admission",
    ADMINISTRACAO = "Type of administration (e.g., direct, indirect, foundation)",
    TIPO_CONTRATO = "Type of contract (e.g., permanent, temporary, commissioned)",
    GRUPO = "Group (could be a functional or career group)",
    COD_ORGAO = "Establishment code",
    ORGAO = "Establishment name",
    CARREIRA = "Career (broad classification of occupation)",
    CARGO = "Position (specific job title)",
    JORNADA = "Work schedule (hours per week)",
    CLASSE = "Class (pay grade)",
    NIVEL = "Level within the class",
    DATA_ULT_PROGRESSAO = "Date of last career progression / promotion",
    SALARIO_BASE = "Base salary",
    CONTRIBUICAO_PREVIDENCIA = "Social security contribution withheld",
    ADICIONAL_TEMPO_SERVICO = "Length-of-service bonus",
    COMISSAO = "Commission or position of trust allowance",
    ABONO_PERMANENCIA = "Permanence bonus (when eligible for retirement but staying active)",
    DECISAO_JUDICIAL = "Judicial decision payments (court-ordered)",
    DEMAIS_GRATIFICACOES_TRANSITORIAS = "Other temporary bonuses / gratifications",
    DEMAIS_GRATIFICACOES_CARREIRA = "Other career-related bonuses / gratifications",
    SALARIO_BRUTO = "Gross salary (before deductions)",
    SALARIO_LIQUIDO = "Net salary (after deductions)"
  )

inact_list <- c(
  ANO_PAGAMENTO = "Year of payment (e.g., 2022)",
  MES_REFERENCIA = "Reference month (e.g., 1–12)",
  MATRICULA = "Employee registration number",
  CPF = "CPF (taxpayer ID)",
  DATA_NASCIMENTO = "Date of birth",
  GENERO = "Gender (M/F)",
  ESCOLARIDADE = "Education level",
  DATA_ADMISSAO = "Date of hiring / admission",
  DATA_APOSENTADORIA = "Date of retirement",
  ADMINISTRACAO = "Type of administration (e.g., direct, indirect, foundation)",
  TIPO_CONTRATO = "Type of contract before retirement (e.g., permanent, temporary, commissioned)",
  GRUPO = "Group (career or functional group)",
  VALOR_BRUTO = "Gross pension amount (before deductions)",
  VALOR_LIQUIDO = "Net pension amount (after deductions)",
  ORGAO = "Establishment name prior to retirement",
  CARGO = "Position held before retirement",
  CLASSE = "Class (pay grade) prior to retirement",
  NIVEL = "Level within the class"
)

####### lets combine the list of datasets into an active and inactive dataframe

#### quickly harmonize column classes
active_alagoas_tbl <- bind_rows(active_alagoastbl_list)
inactive_alagoas_tbl <- bind_rows(inactive_alagoastbl_list)

#### ready to prepare the establishment module

#### apparently we ought to keep only September
active_alagoas_tbl <-
  active_alagoas_tbl |>
  filter(MES_REFERENCIA == 9)


##### a few diagnostics
check_dt <-
  active_alagoas_tbl |>
  dplyr::select(ANO_PAGAMENTO, ORGAO) |>
  unique()

check_list <-
  active_alagoas_tbl |>
  group_by(ANO_PAGAMENTO) |>
  group_split() |>
  map(
    ~ .x |>
      group_by(ORGAO, COD_ORGAO) |>
      summarize(n = n(), .groups = "drop") |>
      pivot_wider(names_from = COD_ORGAO, values_from = n)
  )

names(check_list) <- unique(active_alagoas_tbl$ANO_PAGAMENTO)

#### we are going to create a unique identifier for establishment by
#### combining establishment name, code and year

alagoas_est_tbl <-
  active_alagoas_tbl |>
  transmute(
    est_id = ORGAO,
    est_name_native = ORGAO,
    country_code = "BRA",
    country_name = "Brazil",
    adm1_name = "Alagoas",
    adm1_code = "AL",
    est_parent = NA,
    est_child = NA
  ) |>
  unique()

#### include translation for establishment name
alagoas_est_tbl <-
  alagoas_est_tbl |>
  merge(
    tibble(
      est_name_native = unique(alagoas_est_tbl$est_name_native),
      est_name_en = polyglotr::google_translate(
        text = unique(alagoas_est_tbl$est_name_native),
        source_language = "pt"
      )
    ),
    by = "est_name_native",
    all.x = TRUE
  ) |>
  as_tibble() |>
  mutate(est_name_en = tolower(est_name_en))

#### include same data for the inactive works
alagoas_est_tbl <-
  bind_rows(
    alagoas_est_tbl,
    inactive_alagoas_tbl |>
      transmute(
        est_id = ORGAO,
        est_name_native = ORGAO,
        country_code = "BRA",
        country_name = "Brazil",
        adm1_name = "Alagoas",
        adm1_code = "AL",
        est_parent = NA,
        est_child = NA
      ) |>
      unique() |>
      mutate(est_name_en = "Alagoas Retirees")
  )

# #### write results
# alagoas_est_tbl |>
#   write_rds(
#     here("spielplatz", "data", "bra_hrmis_establishment.rds"),
#     compress = "gz"
#   )

alagoas_est_tbl |>
  qs::qsave("spielplatz/data/est_alagoas_tbl.qs")


write_xlsx(check_list, "spielplatz/data/orgao_check.xlsx")
