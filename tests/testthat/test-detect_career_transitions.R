library(testthat)
library(data.table)
library(lubridate)

# Example contract dataset
contract_dt <- data.table(
  personnel_id = c(1,1,1,2,2,2,3,3),
  ref_date = ymd(c("2020-01-01","2021-01-01","2022-01-01",
                   "2020-01-01","2021-01-01","2022-01-01",
                   "2020-01-01","2021-01-01")),
  job_role = c("Analyst","Analyst","Manager",
               "Clerk","Clerk","Clerk",
               "Admin","Admin"),
  department = c("Finance","Finance","Finance",
                 "HR","HR","HR",
                 "IT","IT"),
  decision_score = c(10,15,20,5,5,5,1,2)
)

test_that("detect_career_transitions detects transitions correctly", {
  res <- detect_career_transitions(contract_dt,
                                   vars = c("job_role","department"),
                                   decision_var = "decision_score")

  # Output columns
  expect_true(all(c("personnel_id","start_date","ref_date","attribute","from","to") %in% names(res)))

  # Personnel 1: job_role change from Analyst -> Manager at 2022
  expect_true(any(res$personnel_id == 1 & res$attribute == "job_role" & res$to == "Manager"))

  # Department should not change
  expect_false(any(res$attribute == "department" & res$personnel_id == 2))

  # Start dates should be prior ref_date
  expect_true(all(res$start_date < res$ref_date, na.rm = TRUE))
})

test_that("detect_career_transitions handles no transitions", {
  contract_no_change <- data.table(
    personnel_id = c(1,1,1),
    ref_date = ymd(c("2020-01-01","2021-01-01","2022-01-01")),
    job_role = c("Analyst","Analyst","Analyst"),
    department = c("Finance","Finance","Finance"),
    decision_score = c(5,5,5)
  )

  res <- detect_career_transitions(contract_no_change,
                                   vars = c("job_role","department"),
                                   decision_var = "decision_score")

  expect_equal(nrow(res), 0)
})

test_that("detect_career_transitions respects decision_fn", {
  # Decision_fn = min instead of max
  contract_fn <- data.table(
    personnel_id = c(1,1),
    ref_date = ymd(c("2020-01-01","2021-01-01")),
    job_role = c("Analyst","Manager"),
    department = c("Finance","Finance"),
    decision_score = c(10,5)
  )

  res <- detect_career_transitions(contract_fn,
                                   vars = c("job_role"),
                                   decision_var = "decision_score",
                                   decision_fn = min)

  # The min function should pick the lower score
  expect_equal(res$to, "Manager")
})

test_that("detect_career_transitions works with multiple personnel", {
  res <- detect_career_transitions(contract_dt,
                                   vars = c("job_role"),
                                   decision_var = "decision_score")

  expect_true(all(res$personnel_id %in% 1:3))
  expect_true(all(res$attribute == "job_role"))
})

# test_that("detect_career_transitions works with large datasets", {
#   skip_on_cran()
#   n_personnel <- 5000
#   years <- 2015:2025
#   n_rows <- n_personnel * length(years)

#   dt_large <- data.table(
#     personnel_id = rep(1:n_personnel, each = length(years)),
#     ref_date = rep(ymd(paste0(years,"-01-01")), times = n_personnel),
#     job_role = sample(c("Analyst","Manager","Clerk"), n_rows, replace = TRUE),
#     department = sample(c("HR","Finance","IT"), n_rows, replace = TRUE),
#     decision_score = sample(1:100, n_rows, replace = TRUE)
#   )

#   start_time <- Sys.time()
#   res <- detect_career_transitions(dt_large,
#                                    vars = c("job_role","department"),
#                                    decision_var = "decision_score")
#   end_time <- Sys.time()

#   runtime <- as.numeric(difftime(end_time, start_time, units = "secs"))
#   message(sprintf("Runtime for %d rows: %.2f seconds", n_rows, runtime))

#   res
#   expect_true(all(res$attribute %in% c("job_role","department")))
#   expect_true(all(res$personnel_id %in% 1:n_personnel))
# })
