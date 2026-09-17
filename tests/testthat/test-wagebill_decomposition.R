test_that("mid-panel gap produces exit then entry, not a fabricated collapse", {
  d <- data.frame(
    dept = "A",
    ref_date = as.Date(c("2020-01-01", "2023-01-01")),  # 2021, 2022 missing
    gross_salary_lcu = c(100000, 130000)
  )

  res <- compute_growth_decomposition(d, group_cols = "dept")

  expect_equal(res[res$ref_date == as.Date("2021-01-01"), "transition_type"] |> dplyr::pull(), "exit")
  expect_equal(res[res$ref_date == as.Date("2022-01-01"), "transition_type"] |> dplyr::pull(), "exit")
  expect_equal(res[res$ref_date == as.Date("2023-01-01"), "transition_type"] |> dplyr::pull(), "entry")

  expect_equal(res[res$ref_date == as.Date("2021-01-01"), "exit_effect"] |> dplyr::pull(), -100000)
  expect_equal(res[res$ref_date == as.Date("2023-01-01"), "entry_effect"] |> dplyr::pull(), 130000)
  # nothing should look like an ordinary continuing-period effect across the gap
  expect_true(is.na(res[res$ref_date == as.Date("2021-01-01"), "total_effect"] |> dplyr::pull()) == FALSE)
})

test_that("entry/exit effects telescope to the correct total wagebill change", {
  d <- data.frame(
    dept = "A",
    ref_date = as.Date(c("2020-01-01", "2023-01-01")),
    gross_salary_lcu = c(100000, 130000)
  )
  res <- compute_growth_decomposition(d, group_cols = "dept")
  expect_equal(sum(res$total_effect, na.rm = TRUE), 130000 - 100000)
})

test_that("a group entering mid-panel is classified entry, not a fabricated collapse before it existed", {
  d <- data.frame(
    dept = c("A", "A", "B"),
    ref_date = as.Date(c("2020-01-01", "2021-01-01", "2021-01-01")),
    gross_salary_lcu = c(100000, 105000, 50000)
  )
  res <- compute_growth_decomposition(d, group_cols = "dept")
  b_2020 <- res[res$dept == "B" & res$ref_date == as.Date("2020-01-01"), ]
  b_2021 <- res[res$dept == "B" & res$ref_date == as.Date("2021-01-01"), ]
  expect_equal(b_2020$transition_type, "exit")     # dept B didn't exist yet
  expect_equal(b_2021$transition_type, "entry")   # first real appearance
  expect_equal(b_2021$entry_effect, 50000)
})

test_that("the very first period in the panel is 'start', not 'entry' (left-censoring)", {
  d <- data.frame(
    dept = "A",
    ref_date = as.Date(c("2020-01-01", "2021-01-01")),
    gross_salary_lcu = c(100000, 105000)
  )
  res <- compute_growth_decomposition(d, group_cols = "dept")
  first_row <- res[res$ref_date == as.Date("2020-01-01"), ]
  expect_equal(first_row$transition_type, "start")
  expect_true(is.na(first_row$total_effect))
  expect_true(is.na(first_row$entry_effect))  # not conflated with a genuine entry
})

test_that("a balanced panel is entirely 'continuing' after the first period", {
  d <- data.frame(
    dept = "A",
    ref_date = as.Date(c("2020-01-01", "2021-01-01", "2022-01-01")),
    gross_salary_lcu = c(100000, 105000, 110000)
  )
  res <- compute_growth_decomposition(d, group_cols = "dept")
  expect_equal(res$transition_type, c("start", "continuing", "continuing"))
  expect_true(all(is.na(res$entry_effect)))
  expect_true(all(is.na(res$exit_effect)))
})

test_that("a multi-period gap has no 'gap' label -- only entry/exit", {
  d <- data.frame(
    dept = "A",
    ref_date = as.Date(c("2020-01-01", "2023-01-01")),  # 2021, 2022 missing
    gross_salary_lcu = c(100000, 130000)
  )
  res <- compute_growth_decomposition(d, group_cols = "dept")
  expect_false("gap" %in% res$transition_type)
  types <- setNames(res$transition_type, as.character(res$ref_date))
  expect_equal(unname(types["2021-01-01"]), "exit")
  expect_equal(unname(types["2022-01-01"]), "exit")
  expect_equal(unname(types["2023-01-01"]), "entry")
})

test_that("exit_effect fires once at the boundary, zero for the rest of the gap", {
  d <- data.frame(
    dept = "A",
    ref_date = as.Date(c("2020-01-01", "2023-01-01")),
    gross_salary_lcu = c(100000, 130000)
  )
  res <- compute_growth_decomposition(d, group_cols = "dept")
  eff <- setNames(res$exit_effect, as.character(res$ref_date))
  expect_equal(unname(eff["2021-01-01"]), -100000)  # the real drop
  expect_equal(unname(eff["2022-01-01"]), 0)         # still gone, no new change
})

test_that("telescoping holds across gaps of any length", {
  d <- data.frame(
    dept = "A",
    ref_date = as.Date(c("2020-01-01", "2025-01-01")),  # 4-period gap
    gross_salary_lcu = c(100000, 145000)
  )
  res <- compute_growth_decomposition(d, group_cols = "dept")
  expect_equal(sum(res$total_effect, na.rm = TRUE), 145000 - 100000)
})

# FHK --------------------------------------------------------------------
test_that("pure composition shift with no pay changes shows up entirely as between_effect", {
  raw <- data.frame(
    dept = c(rep("A", 100), rep("A", 50), rep("B", 100), rep("B", 150)),
    ref_date = as.Date(c(
      rep("2020-01-01", 100), rep("2021-01-01", 50),
      rep("2020-01-01", 100), rep("2021-01-01", 150)
    )),
    gross_salary_lcu = c(rep(1000, 100), rep(1000, 50),   # dept A: 100 -> 50 people, same pay
                          rep(2000, 100), rep(2000, 150))  # dept B: 100 -> 150 people, same pay
  )
  gd <- compute_growth_decomposition(raw, group_cols = "dept")
  wd <- compute_wage_decomposition(gd) 

  row2021 <- wd[ref_date == as.Date("2021-01-01")]
  expect_equal(row2021$within_effect, 0, tolerance = 1e-8)
  expect_equal(row2021$cross_effect, 0, tolerance = 1e-8)
  expect_equal(row2021$between_effect, 250, tolerance = 1e-8)
  expect_gt(row2021$between_effect, 0)
  expect_equal(row2021$total_effect, row2021$avg_compensation - row2021$avg_compensation_lag)
})

test_that("pure within-group raises with no reallocation shows up entirely as within_effect", {
  raw <- data.frame(
    dept = rep(c("A", "B"), c(200, 200)),
    ref_date = rep(as.Date(c("2020-01-01", "2021-01-01")), c(100, 100)) |> rep(2),
    gross_salary_lcu = c(rep(1000, 100), rep(1100, 100),   # dept A raised
                          rep(2000, 100), rep(2200, 100))  # dept B raised, same headcount
  )
  gd <- compute_growth_decomposition(raw, group_cols = "dept")
  wd <- compute_wage_decomposition(gd)

  row2021 <- wd[ref_date == as.Date("2021-01-01")]
  expect_equal(row2021$between_effect, 0, tolerance = 1e-8)
  expect_equal(row2021$cross_effect, 0, tolerance = 1e-8)
  expect_gt(row2021$within_effect, 0)
  expect_equal(row2021$total_effect, row2021$avg_compensation - row2021$avg_compensation_lag)
})

test_that("identity holds with entry, exit, and within effects all present at once", {
  raw <- data.frame(
    dept = c(rep("A", 2), rep("B", 1), rep("C", 1)),
    ref_date = as.Date(c("2020-01-01", "2021-01-01", "2020-01-01", "2021-01-01")),
    gross_salary_lcu = c(100000, 105000,     # dept A: continuing, small raise
                          80000,             # dept B: present in 2020 only (exits)
                          60000)             # dept C: present in 2021 only (enters)
  )
  gd <- compute_growth_decomposition(raw, group_cols = "dept")
  wd <- compute_wage_decomposition(gd)

  row2021 <- wd[ref_date == as.Date("2021-01-01")]
  expect_true(row2021$entry_effect != 0)
  expect_true(row2021$exit_effect != 0)
  expect_equal(row2021$total_effect, row2021$avg_compensation - row2021$avg_compensation_lag)
})

test_that("the panel's first period has NA total_effect, not a spurious number", {
  raw <- data.frame(
    dept = "A", ref_date = c(as.Date("2020-01-01"), as.Date("2021-01-01")), gross_salary_lcu = c(100000, 100000)
  )
  gd <- compute_growth_decomposition(raw, group_cols = "dept")
  wd <- compute_wage_decomposition(gd, group_cols = "dept")
  expect_true(is.na(wd$total_effect[1]))
  expect_true(is.na(wd$avg_compensation_lag[1]))
})

test_that("group_cols = 'country' computes composition separately per country", {
  raw <- data.frame(
    country = rep(c("X", "Y"), each = 4),
    dept = rep(c("A", "B"), 4),
    ref_date = rep(as.Date(c("2020-01-01", "2021-01-01")), each = 2, times = 2),
    gross_salary_lcu = c(1000, 2000, 1000, 2000,   # country X: no change
                          1000, 2000, 1500, 2000)  # country Y: dept A raised
  )
  gd <- compute_growth_decomposition(raw, group_cols = c("country", "dept"))
  wd <- compute_wage_decomposition(gd, group_cols = "country")

  x_2021 <- wd[country == "X" & ref_date == as.Date("2021-01-01")]
  y_2021 <- wd[country == "Y" & ref_date == as.Date("2021-01-01")]
  expect_equal(x_2021$total_effect, 0, tolerance = 1e-8)
  expect_gt(y_2021$within_effect, 0)
})
