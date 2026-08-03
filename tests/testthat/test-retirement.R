# Tests for project_retirement() ---------------------------------------------

test_that("project_retirement counts only staff whose projected retirement is after the last ref_date", {
  df <- data.frame(
    personnel_id = c(1, 2),
    ref_date = as.Date(c("2020-01-01", "2020-01-01")),
    # person 1 turns 60 in 2025 (still ahead of the data's last ref_date)
    # person 2 turned 60 in 2010 (already past it -> should be excluded)
    birth_date = as.Date(c("1965-06-15", "1950-06-15"))
  )

  out <- project_retirement(df, threshold_age = 60, birth_col = "birth_date")

  expect_equal(nrow(out), 1)
  # simplify_retirement_date defaults to TRUE, so the date collapses to Dec 31
  expect_equal(out$retirement_date, as.Date("2025-12-31"))
  expect_equal(out$indicator, 1)
})

test_that("project_retirement computes projected_cost and drops projections beyond cutoff_date", {
  df <- data.frame(
    personnel_id = c(1, 2, 3),
    ref_date = as.Date("2020-01-01"),
    wage = c(1000, 2000, 3000),
    # person 1: retires 2025 (within a 10-year cutoff of 2030)
    # person 2: already past retirement age -> excluded regardless of cutoff
    # person 3: retires 2060 -> excluded by the 10-year cutoff
    birth_date = as.Date(c("1965-06-15", "1950-06-15", "2000-06-15"))
  )

  out <- project_retirement(
    df,
    threshold_age = 60,
    birth_col = "birth_date",
    measure_col = "wage",
    cutoff_date = 10
  )

  expect_equal(nrow(out), 1)
  expect_equal(out$retirement_date, as.Date("2025-12-31"))
  expect_equal(out$projected_cost, 1000 * 0.6)
})

# Tests for compute_pension_ratio() -------------------------------------------

test_that("compute_pension_ratio computes the replacement rate only for staff who became pensioners", {
  personnel_dt <- data.table::data.table(
    personnel_id = c(1, 1, 1, 2, 2),
    ref_date = as.Date(c(
      "2019-01-01", "2020-01-01", "2021-01-01",
      "2019-01-01", "2020-01-01"
    )),
    employment_status = c("active", "active", "pensioner", "active", "active")
  )

  contract_dt <- data.table::data.table(
    personnel_id = c(1, 1, 1, 2, 2),
    ref_date = as.Date(c(
      "2019-01-01", "2020-01-01", "2021-01-01",
      "2019-01-01", "2020-01-01"
    )),
    salary = c(1000, 1200, 600, 800, 850)
  )

  out <- compute_pension_ratio(personnel_dt, contract_dt, salary_col = "salary")

  # person 2 never shows a "pensioner" status, so they shouldn't appear at all
  expect_equal(nrow(out), 1)
  expect_equal(out$personnel_id, 1)
  expect_equal(out$ref_date_active, as.Date("2020-01-01"))
  expect_equal(out$last_salary, 1200)
  expect_equal(out$ref_date_pension, as.Date("2021-01-01"))
  expect_equal(out$first_pension, 600)
  expect_equal(out$replacement_rate, 0.5)
})

test_that("compute_pension_ratio drops non-finite replacement rates (e.g. zero last_salary)", {
  personnel_dt <- data.table::data.table(
    personnel_id = c(1, 1),
    ref_date = as.Date(c("2019-01-01", "2020-01-01")),
    employment_status = c("active", "pensioner")
  )

  contract_dt <- data.table::data.table(
    personnel_id = c(1, 1),
    ref_date = as.Date(c("2019-01-01", "2020-01-01")),
    salary = c(0, 300) # last active salary of 0 -> replacement_rate = Inf
  )

  out <- compute_pension_ratio(personnel_dt, contract_dt, salary_col = "salary")

  expect_equal(nrow(out), 0)
})