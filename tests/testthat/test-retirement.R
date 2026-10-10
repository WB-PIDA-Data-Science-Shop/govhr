# Tests for project_retirement() ---------------------------------------------

# the latest date is 2021-07-01, so the default 10-year horizon projects the
# year-ends from 2021 to 2030
# a turns 60 in 2022 and holds two contracts in unit A on the latest date
# b turned 60 before the latest date, so is not projected
# c turns 60 in 2025, in unit B
# d left before the latest date and e is a pensioner on it, so neither is
#   projected
# f turns 60 beyond the horizon and has no unit
projection_panel <- utils::read.csv(
  text = "
personnel_id,ref_date,employment_status,unit,birth_date,pay
a,2020-07-01,active,A,1962-03-01,100
d,2020-07-01,active,A,1963-01-01,50
a,2021-07-01,active,A,1962-03-01,100
a,2021-07-01,active,A,1962-03-01,40
b,2021-07-01,active,A,1961-03-01,70
c,2021-07-01,active,B,1965-10-01,200
e,2021-07-01,pensioner,B,1964-01-01,30
f,2021-07-01,active,,1980-01-01,10
",
  colClasses = c(ref_date = "Date", birth_date = "Date"),
  na.strings = ""
)

test_that("project_retirement projects only the current active workforce", {
  result <- project_retirement(projection_panel)

  expect_equal(result$ref_date, as.Date(paste0(2021:2030, "-12-31")))
  # a, b, c and f, with a counted once despite two contracts
  expect_equal(result$headcount, rep(4L, 10))
  expect_equal(result$projected_retirements, c(0, 1, 0, 0, 1, 0, 0, 0, 0, 0))
  expect_equal(result$projected_retirement_rate, result$projected_retirements / 4)
  expect_false("projected_cost" %in% names(result))
})

test_that("project_retirement costs each group's retirees separately", {
  result <- project_retirement(
    projection_panel,
    group_cols = "unit",
    measure_col = "pay"
  )

  # every unit in the current workforce appears in every projected year
  expect_equal(nrow(result), 3L * 10L)

  retiring <- result[result$projected_retirements > 0, ]
  expect_equal(retiring$ref_date, as.Date(c("2022-12-31", "2025-12-31")))
  expect_equal(retiring$unit, c("A", "B"))
  expect_equal(retiring$headcount, c(2L, 1L))
  # both of a's contracts are costed
  expect_equal(retiring$projected_cost, c((100 + 40) * 0.6, 200 * 0.6))
  expect_equal(sum(result$projected_cost), (100 + 40 + 200) * 0.6)
})

test_that("project_retirement stops at the horizon", {
  result <- project_retirement(projection_panel, horizon = 3)

  expect_equal(result$ref_date, as.Date(paste0(2021:2023, "-12-31")))
  expect_equal(result$projected_retirements, c(0, 1, 0))
})

test_that("project_retirement rejects ref_date as a group", {
  expect_error(
    project_retirement(projection_panel, group_cols = "ref_date"),
    "ref_date"
  )
})

test_that("project_retirement gives the same result on a database table", {
  skip_if_not_installed("dbplyr")
  skip_if_not_installed("duckdb")

  con <- DBI::dbConnect(duckdb::duckdb())
  remote <- dplyr::copy_to(con, projection_panel, "projection_panel")

  for (group_cols in list(NULL, "unit")) {
    for (measure_col in list(NULL, "pay")) {
      sort_keys <- c("ref_date", group_cols)

      expected <- project_retirement(
        projection_panel,
        group_cols = group_cols,
        measure_col = measure_col
      ) |>
        dplyr::arrange(dplyr::across(dplyr::all_of(sort_keys))) |>
        as.data.frame()

      result <- project_retirement(
        remote,
        group_cols = group_cols,
        measure_col = measure_col
      ) |>
        dplyr::collect() |>
        dplyr::arrange(dplyr::across(dplyr::all_of(sort_keys))) |>
        as.data.frame()

      # SQL returns every count as a double
      expect_equal(result, expected, ignore_attr = TRUE)
    }
  }

  DBI::dbDisconnect(con, shutdown = TRUE)
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