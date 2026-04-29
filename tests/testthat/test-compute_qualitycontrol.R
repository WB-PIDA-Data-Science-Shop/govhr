# Helper: build minimal contract, personnel, est data.tables
make_contract <- function(n_contracts = 4, n_dates = 2,
                          extra_cols = TRUE) {
  dates <- as.Date("2020-01-01") + (seq_len(n_dates) - 1) * 365
  dt <- data.table::CJ(
    contract_id  = paste0("C", seq_len(n_contracts)),
    ref_date     = dates
  )
  dt[, personnel_id     := paste0("P", contract_id)]
  dt[, est_id           := "E1"]
  dt[, base_salary_lcu  := 1000]
  dt[, gross_salary_lcu := 1100]
  dt[, net_salary_lcu   := 950]
  dt[, allowance_lcu    := 100]
  dt[, whours           := 40]
  dt[, start_date       := as.Date("2015-01-01")]
  dt[, end_date         := as.Date("2025-01-01")]
  dt[, country_code     := "BR"]
  dt[, country_name     := "Brazil"]
  dt[, adm1_name        := "São Paulo"]
  dt[, adm1_code        := "SP"]
  dt[, paygrade         := "G1"]
  dt[, seniority        := "Junior"]
  dt[, occupation_native    := "Analista"]
  dt[, occupation_english   := "Analyst"]
  dt[, occupation_iscocode  := "2411"]
  dt[, occupation_isconame  := "Accountants"]
  dt[, contract_type_native := "CLT"]
  dt[, contract_type_code   := "permanent"]
  dt
}

make_personnel <- function(contract_dt) {
  unique(contract_dt[, .(personnel_id, ref_date)])[
    , `:=`(birth_date = as.Date("1985-01-01"),
           gender     = "Female",
           educat7    = "University",
           tribe      = NA_character_,
           race       = NA_character_,
           status     = "active",
           country_code = "BR")
  ][]
}

make_est <- function() {
  data.table::data.table(
    est_id         = "E1",
    est_name_native = "Ministerio",
    est_id_parent  = NA_character_,
    ref_date       = as.Date("2020-01-01"),
    country_code   = "BR"
  )
}

run_qc <- function(...) {
  ct <- make_contract(...)
  pt <- make_personnel(ct)
  et <- make_est()
  compute_qualitycontrol(ct, pt, et)
}

# -----------------------------------------------------------------------
# OUTPUT STRUCTURE
# -----------------------------------------------------------------------
test_that("output is a named list with expected top-level elements", {
  qc <- run_qc()
  expect_type(qc, "list")
  expect_named(qc, c("n_obs", "n_vars", "structure", "orphans",
                      "validation", "missingness", "volatility"))
})

test_that("n_obs and n_vars are correct", {
  ct <- make_contract(n_contracts = 3, n_dates = 2)
  pt <- make_personnel(ct)
  et <- make_est()
  qc <- compute_qualitycontrol(ct, pt, et)
  expect_equal(qc$n_obs,  nrow(ct))
  expect_equal(qc$n_vars, ncol(ct))
})

test_that("keys / salaries / date_logic are NOT in the output (removed)", {
  qc <- run_qc()
  expect_false("keys"       %in% names(qc))
  expect_false("salaries"   %in% names(qc))
  expect_false("date_logic" %in% names(qc))
})

# -----------------------------------------------------------------------
# ORPHAN CHECKS
# -----------------------------------------------------------------------
test_that("orphan check returns zero orphans when data is consistent", {
  qc <- run_qc()
  expect_equal(qc$orphans$personnel_vs_contract$n_missing,     0L)
  expect_equal(qc$orphans$establishment_vs_contract$n_missing, 0L)
})

test_that("orphan check detects personnel IDs absent from personnel_dt", {
  ct <- make_contract()
  pt <- make_personnel(ct)
  et <- make_est()
  # Add a contract row with an unknown personnel_id
  ct <- rbind(ct, data.table::data.table(
    contract_id = "C99", ref_date = as.Date("2020-01-01"),
    personnel_id = "UNKNOWN", est_id = "E1",
    base_salary_lcu = 1000, gross_salary_lcu = 1100,
    net_salary_lcu = 950, allowance_lcu = 100,
    whours = 40, start_date = as.Date("2015-01-01"),
    end_date = as.Date("2025-01-01"), country_code = "BR",
    country_name = "Brazil", adm1_name = "SP", adm1_code = "SP",
    paygrade = "G1", seniority = "Junior",
    occupation_native = "Analista", occupation_english = "Analyst",
    occupation_iscocode = "2411", occupation_isconame = "Accountants",
    contract_type_native = "CLT", contract_type_code = "permanent"
  ))
  qc <- compute_qualitycontrol(ct, pt, et)
  expect_equal(qc$orphans$personnel_vs_contract$n_missing, 1L)
})

# -----------------------------------------------------------------------
# RULE-BASED VALIDATION
# -----------------------------------------------------------------------
test_that("validation output has contract and personnel elements", {
  qc <- run_qc()
  expect_named(qc$validation, c("contract", "personnel"))
})

test_that("validation contract report has expected columns", {
  qc <- run_qc()
  expect_true(all(c("Rule", "Description", "Total Records",
                    "Passes", "Pass Rate", "Fails", "Errors") %in%
                    names(qc$validation$contract)))
})

test_that("all built-in contract rules appear in the validation report", {
  qc <- run_qc()
  expect_equal(nrow(qc$validation$contract), nrow(govhr::contract_rules))
})

test_that("all built-in personnel rules appear in the validation report", {
  qc <- run_qc()
  expect_equal(nrow(qc$validation$personnel), nrow(govhr::personnel_rules))
})

test_that("custom_rules$contract are appended and appear in the report", {
  extra <- tibble::tibble(
    rule        = "gross_salary_lcu > 0",
    name        = "positive_gross",
    description = "gross salary is positive",
    label       = "Positive gross salary"
  )
  ct <- make_contract()
  pt <- make_personnel(ct)
  et <- make_est()
  qc <- compute_qualitycontrol(ct, pt, et,
                               custom_rules = list(contract = extra))
  expect_equal(nrow(qc$validation$contract),
               nrow(govhr::contract_rules) + 1L)
  expect_true("Positive gross salary" %in% qc$validation$contract$Rule)
})

test_that("custom_rules$personnel are appended and appear in the report", {
  extra <- tibble::tibble(
    rule        = "gender %in% c('Male', 'Female')",
    name        = "valid_gender",
    description = "gender is Male or Female",
    label       = "Valid gender"
  )
  ct <- make_contract()
  pt <- make_personnel(ct)
  et <- make_est()
  qc <- compute_qualitycontrol(ct, pt, et,
                               custom_rules = list(personnel = extra))
  expect_equal(nrow(qc$validation$personnel),
               nrow(govhr::personnel_rules) + 1L)
})

test_that("validation detects failures (negative salary)", {
  ct <- make_contract()
  ct[contract_id == "C1" & ref_date == min(ref_date),
     base_salary_lcu := -500]
  pt <- make_personnel(ct)
  et <- make_est()
  qc <- compute_qualitycontrol(ct, pt, et)
  # at least one rule should report Fails > 0
  expect_true(any(qc$validation$contract$Fails > 0))
})

# -----------------------------------------------------------------------
# MISSINGNESS
# -----------------------------------------------------------------------
test_that("missingness is a data.table with expected columns", {
  qc <- run_qc()
  expect_s3_class(qc$missingness, "data.table")
  expect_true(all(c("group_var", "group_val", "target_var",
                    "n_missing", "N", "pct_missing") %in%
                    names(qc$missingness)))
})

test_that("missingness handles missing optional grouping columns gracefully", {
  ct <- make_contract()
  ct[, occupation_isconame := NULL]
  ct[, contract_type_native := NULL]
  pt <- make_personnel(ct)
  et <- make_est()
  expect_no_error(compute_qualitycontrol(ct, pt, et))
})

test_that("missingness returns empty data.table when no grouping cols present", {
  ct <- make_contract()[, .(contract_id, personnel_id, est_id, ref_date,
                             base_salary_lcu, gross_salary_lcu,
                             net_salary_lcu, allowance_lcu, whours,
                             start_date, end_date, country_code)]
  pt <- make_personnel(ct)[, .(personnel_id, ref_date, status, country_code)]
  et <- make_est()
  qc <- compute_qualitycontrol(ct, pt, et)
  expect_equal(nrow(qc$missingness), 0L)
})

# -----------------------------------------------------------------------
# VOLATILITY
# -----------------------------------------------------------------------
test_that("volatility has contract and personnel elements", {
  qc <- run_qc()
  expect_named(qc$volatility, c("contract", "personnel"))
})

test_that("volatility$contract is a flat data.table with expected columns", {
  qc <- run_qc()
  expect_s3_class(qc$volatility$contract, "data.table")
  expect_true(all(c("stat_type", "vol_fn", "vol_fn_label",
                    "group_var", "group_val", "ref_date",
                    "indicator", "value", "vol_stat") %in%
                    names(qc$volatility$contract)))
})

test_that("volatility$personnel is a flat data.table", {
  qc <- run_qc()
  expect_s3_class(qc$volatility$personnel, "data.table")
})

test_that("volatility handles missing salary columns gracefully", {
  ct <- make_contract()
  ct[, gross_salary_lcu := NULL]
  ct[, base_salary_lcu  := NULL]
  pt <- make_personnel(ct)
  et <- make_est()
  expect_no_error(compute_qualitycontrol(ct, pt, et))
})

test_that("volatility handles missing whours gracefully (no workhours_vol)", {
  ct <- make_contract()
  ct[, whours := NULL]
  pt <- make_personnel(ct)
  et <- make_est()
  qc <- expect_no_error(compute_qualitycontrol(ct, pt, et))
  # workhours_vol contributions should be absent from flat table
  expect_false("workhours_vol" %in% qc$volatility$contract$stat_type)
})

test_that("volatility handles missing gender column in personnel gracefully", {
  ct <- make_contract()
  pt <- make_personnel(ct)
  pt[, gender := NULL]
  et <- make_est()
  expect_no_error(compute_qualitycontrol(ct, pt, et))
})

test_that("volatility handles missing educat7 column in personnel gracefully", {
  ct <- make_contract()
  pt <- make_personnel(ct)
  pt[, educat7 := NULL]
  et <- make_est()
  expect_no_error(compute_qualitycontrol(ct, pt, et))
})

test_that("volatility handles missing est_id in contract_dt gracefully", {
  ct <- make_contract()
  ct[, est_id := NULL]
  pt <- make_personnel(ct)
  et <- make_est()
  expect_no_error(compute_qualitycontrol(ct, pt, et))
})

# -----------------------------------------------------------------------
# INPUT VALIDATION
# -----------------------------------------------------------------------
test_that("data.frame inputs are accepted (coerced internally)", {
  ct <- as.data.frame(make_contract())
  pt <- as.data.frame(make_personnel(data.table::as.data.table(ct)))
  et <- as.data.frame(make_est())
  expect_no_error(compute_qualitycontrol(ct, pt, et))
})

test_that("single time period runs without error", {
  ct <- make_contract(n_dates = 1)
  pt <- make_personnel(ct)
  et <- make_est()
  expect_no_error(compute_qualitycontrol(ct, pt, et))
})
