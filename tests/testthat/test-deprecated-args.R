# Renamed arguments keep working for one deprecation cycle. See NEWS.md.

make_panel <- function() {
  set.seed(1)
  data.frame(
    personnel_id = rep(1:50, 2),
    ref_date = rep(as.Date(c("2020-01-01", "2021-01-01")), each = 50),
    gender = rep(c("f", "m"), 50),
    employment_status = "active",
    wage = runif(100, 1000, 5000)
  )
}

# Capture every warning so unrelated ones (data.table coercion notes, domain
# warnings) do not leak into the reporter.
with_warnings <- function(expr) {
  seen <- character(0)
  value <- withCallingHandlers(
    expr,
    warning = function(w) {
      seen <<- c(seen, conditionMessage(w))
      invokeRestart("muffleWarning")
    }
  )
  list(value = value, warnings = seen)
}

expect_deprecated <- function(res, arg) {
  expect_true(
    any(grepl(paste0("`", arg, "` is deprecated"), res$warnings, fixed = TRUE)),
    info = paste0("expected a deprecation warning for `", arg, "`")
  )
}

test_that("`group` still works and matches `group_col`", {
  data <- make_panel()

  res <- with_warnings(
    compute_growth(data, group = "gender", measure_col = "wage")
  )
  expect_deprecated(res, "group")
  expect_equal(
    res$value,
    compute_growth(data, group_col = "gender", measure_col = "wage")
  )
})

test_that("`groups` still works and matches `group_cols`", {
  data <- make_panel()

  res <- with_warnings(
    compute_fastsummary(data, cols = "wage", groups = "gender")
  )
  expect_deprecated(res, "groups")
  expect_equal(
    res$value,
    with_warnings(
      compute_fastsummary(data, cols = "wage", group_cols = "gender")
    )$value
  )
})

test_that("supplying both the old and the new name is an error", {
  data <- make_panel()

  expect_error(
    suppressWarnings(
      compute_growth(
        data,
        group_col = "gender",
        group = "gender",
        measure_col = "wage"
      )
    ),
    "not both"
  )
})
