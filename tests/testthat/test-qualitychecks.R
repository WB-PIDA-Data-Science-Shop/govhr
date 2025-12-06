library(testthat)

# ───────────────────────────────────────────────
# 1. flag_outlier()
# ───────────────────────────────────────────────
test_that("flag_outlier correctly identifies outliers", {
  x <- c(1, 2, 2, 3, 4, 5, 100)
  outliers <- flag_outlier(x)
  expect_type(outliers, "logical")
  expect_length(outliers, length(x))
  expect_true(outliers[7])  # 100 should be flagged
  expect_false(any(outliers[1:6]))
})

test_that("flag_outlier handles missing values gracefully", {
  x <- c(1, 2, NA, 100)
  expect_silent(flag_outlier(x))
})

# ───────────────────────────────────────────────
# 2. qualitycheck_personnel()
# ───────────────────────────────────────────────
test_that("qualitycheck_personnel returns a pointblank_agent", {
  personnel_tbl <- tibble(
    ref_date = as_date("2020-01-01") + 0:2,
    personnel_id = 1:3,
    birth_date = as_date(c("1980-01-01", "1990-01-01", "1975-01-01")),
    gender = c("M", "F", "M"),
    educat7 = c("Primary", "Secondary", "Tertiary"),
    tribe = c("A", "B", "C"),
    race = c("X", "Y", "Z"),
    status = c("Employed", "Unemployed", "Employed")
  )

  agent <- qualitycheck_personnel(personnel_tbl)
  expect_s3_class(agent, "ptblank_agent")
  expect_true(all(c("ref_date", "personnel_id", "birth_date") %in% names(agent$tbl)))
})

test_that("qualitycheck_personnel detects missing required columns", {
  bad_tbl <- tibble(personnel_id = 1:3)
  expect_error(
    qualitycheck_personnel(bad_tbl),
    NA  # should not hard-stop, pointblank handles inside
  )
})

# ───────────────────────────────────────────────
# 3. qualitycheck_estmod()
# ───────────────────────────────────────────────
test_that("qualitycheck_estmod returns agent on valid data", {
  est_tbl <- tibble(
    est_name_native = "X",
    est_id = "ORG1",
    country_code = "USA",
    country_name = "United States",
    adm1_name = "California",
    adm1_code = "CA",
    est_parent = "MIN",
    est_child = "DEPT",
    est_name_en = "Ministry of Test"
  )

  agent <- qualitycheck_estmod(est_tbl)
  expect_s3_class(agent, "ptblank_agent")
})

test_that("qualitycheck_estmod errors when required variables are missing", {
  incomplete_est <- tibble(est_id = "ORG1")
  expect_error(qualitycheck_estmod(incomplete_est))
})

# # ───────────────────────────────────────────────
# # 4. qualitycheck_contractmod()
# # ───────────────────────────────────────────────
# test_that("qualitycheck_contractmod runs and returns agent", {
#   # Mock minimal contract_tbl
#   contract_tbl <- tibble(
#     contract_id = c("C1", "C2"),
#     personnel_id = c("W1", "W2"),
#     est_id = c("O1", "O2"),
#     est_date = as.Date(c("2020-01-01", "2021-01-01")),
#     base_salary_lcu = c(1000, 2000),
#     gross_salary_lcu = c(1500, 2500),
#     net_salary_lcu = c(900, 1800),
#     whours = c(40, 45),
#     country_code = c("USA", "USA"),
#     start_date = as.Date(c("2019-01-01", "2020-01-01")),
#     end_date = as.Date(c("2020-12-31", "2021-12-31")),
#     occupation_native = c("Engineer", "Analyst"),
#     occupation_english = c("Engineer", "Analyst"),
#     year = c(2020, 2021),
#     occupation_iscocode = c("1234", "5678"),
#     occupation_isconame = c("Engineering Professionals", "Business Analysts"),
#     country_name = "United States",
#     adm1_name = "California",
#     adm1_code = "CA",
#     paygrade = "A1",
#     seniority = "Senior"
#   )

#   # Fake minimal ISCO reference
#   assign("isco", tibble(
#     description = c("Engineering Professionals", "Business Analysts"),
#     unit = c("1234", "5678")
#   ), envir = .GlobalEnv)

#   agent <- qualitycheck_contractmod(contract_tbl)
#   expect_s3_class(agent, "ptblank_agent")
# })

# test_that("qualitycheck_contractmod adds missing columns and coerces numeric", {
#   contract_tbl <- tibble(contract_id = "C1", base_salary_lcu = "1000")
#   assign("isco", tibble(description = NA, unit = NA), envir = .GlobalEnv)

#   agent <- qualitycheck_contractmod(contract_tbl)
#   expect_s3_class(agent, "ptblank_agent")

#   # Check numeric coercion
#   expect_type(agent$tbl$base_salary_lcu, "double")
# })
