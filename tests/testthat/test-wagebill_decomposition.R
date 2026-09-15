test_that("mid-panel gap produces exit then entry, not a fabricated collapse", {
  d <- data.frame(
    dept = "A",
    ref_date = as.Date(c("2020-01-01", "2023-01-01")),  # 2021, 2022 missing
    gross_salary_lcu = c(100000, 130000)
  )
  res <- compute_growth_decomposition(d, group_cols = "dept")

  expect_equal(res[res$ref_date == as.Date("2021-01-01"), "transition_type"] |> dplyr::pull(), "exit")
  expect_equal(res[res$ref_date == as.Date("2022-01-01"), "transition_type"] |> dplyr::pull(), "gap")
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
  expect_equal(b_2020$transition_type, "gap")     # dept B didn't exist yet
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
