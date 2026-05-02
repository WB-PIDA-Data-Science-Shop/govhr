test_that("pct_change: output schema is correct", {
  dt <- data.table::data.table(
    grp  = c("A", "A", "A"),
    time = as.Date(c("2020-01-01", "2021-01-01", "2022-01-01")),
    val  = c(100, 110, 121)
  )
  out <- compute_volatility(dt, col = "val", agg_fn = "sum",
                            vol_fn = "pct_change", time = "time", groups = "grp")
  expect_s3_class(out, "data.table")
  expect_true(all(c("grp", "time", "indicator", "value", "pct_change") %in% names(out)))
})

test_that("pct_change: first period per group is NA", {
  dt <- data.table::data.table(
    grp  = c("A", "A", "B", "B"),
    time = rep(as.Date(c("2020-01-01", "2021-01-01")), 2),
    val  = c(100, 110, 200, 220)
  )
  out <- compute_volatility(dt, col = "val", agg_fn = "sum",
                            vol_fn = "pct_change", time = "time", groups = "grp")
  first_rows <- out[out$time == as.Date("2020-01-01"), ]
  expect_true(all(is.na(first_rows$pct_change)))
})

test_that("pct_change: values are computed correctly per group", {
  dt <- data.table::data.table(
    grp  = c("A", "A", "B", "B"),
    time = rep(as.Date(c("2020-01-01", "2021-01-01")), 2),
    val  = c(100, 110, 200, 220)
  )
  out <- compute_volatility(dt, col = "val", agg_fn = "sum",
                            vol_fn = "pct_change", time = "time", groups = "grp")
  out <- data.table::setorder(out, grp, time)
  expect_equal(out[grp == "A" & time == as.Date("2021-01-01"), pct_change], 0.1)
  expect_equal(out[grp == "B" & time == as.Date("2021-01-01"), pct_change], 0.1)
})

test_that("pct_change: multiple col — each indicator computed independently", {
  dt <- data.table::data.table(
    grp   = c("A", "A"),
    time  = as.Date(c("2020-01-01", "2021-01-01")),
    val1  = c(100, 200),
    val2  = c(50, 100)
  )
  out <- compute_volatility(dt, col = c("val1", "val2"), agg_fn = "sum",
                            vol_fn = "pct_change", time = "time", groups = "grp")
  # Both should have pct_change = 1.0 at second period, not cross-contaminate
  expect_equal(out[indicator == "val1_sum" & time == as.Date("2021-01-01"), pct_change], 1.0)
  expect_equal(out[indicator == "val2_sum" & time == as.Date("2021-01-01"), pct_change], 1.0)
})

test_that("pct_change: cross-indicator contamination is absent (regression)", {
  # This is the bug that was fixed: shifting across interleaved indicators
  dt <- data.table::data.table(
    grp   = c("A", "A"),
    time  = as.Date(c("2020-01-01", "2021-01-01")),
    val1  = c(1000, 1100),
    val2  = c(0, 0)   # zero allowance — pct_change of 0->0 is NaN, NOT Inf
  )
  out <- compute_volatility(dt, col = c("val1", "val2"), agg_fn = "sum",
                            vol_fn = "pct_change", time = "time", groups = "grp")
  v1_t2 <- out[indicator == "val1_sum" & time == as.Date("2021-01-01"), pct_change]
  # Should be 0.1, not Inf (which would happen if shift crossed into val2 row)
  expect_equal(v1_t2, 0.1)
  expect_false(is.infinite(v1_t2))
})

test_that("pct_change: groups = NULL works (no grouping)", {
  dt <- data.table::data.table(
    time = as.Date(c("2020-01-01", "2021-01-01", "2022-01-01")),
    val  = c(100, 110, 121)
  )
  out <- compute_volatility(dt, col = "val", agg_fn = "sum",
                            vol_fn = "pct_change", time = "time", groups = NULL)
  expect_equal(nrow(out), 3L)
  expect_true(is.na(out[time == as.Date("2020-01-01"), pct_change]))
  expect_equal(out[time == as.Date("2021-01-01"), pct_change], 0.1)
})

test_that("pct_change: data.frame input is accepted", {
  df <- data.frame(
    grp  = c("A", "A"),
    time = as.Date(c("2020-01-01", "2021-01-01")),
    val  = c(100, 110)
  )
  out <- compute_volatility(df, col = "val", agg_fn = "sum",
                            vol_fn = "pct_change", time = "time", groups = "grp")
  expect_s3_class(out, "data.table")
  expect_equal(nrow(out), 2L)
})

test_that("pct_change: implicit gaps are filled with NA before shifting", {
  # Group A has 2020, 2021, 2022; Group B only 2020, 2022 (missing 2021).
  # After grid expansion over (grp, indicator, time), B's 2021 is imputed as NA.
  # shift() then sees NA at position 2, so 2022 pct_change is also NA.
  dt <- data.table::data.table(
    grp  = c("A", "A", "A", "B", "B"),
    time = as.Date(c("2020-01-01", "2021-01-01", "2022-01-01",
                     "2020-01-01", "2022-01-01")),
    val  = c(100, 110, 121, 200, 240)
  )
  out <- compute_volatility(dt, col = "val", agg_fn = "sum",
                            vol_fn = "pct_change", time = "time", groups = "grp")
  b_2021 <- out[grp == "B" & time == as.Date("2021-01-01"), value]
  b_2022 <- out[grp == "B" & time == as.Date("2022-01-01"), pct_change]
  # Imputed 2021 value should be NA
  expect_true(is.na(b_2021))
  # Because 2021 is NA, shift at 2022 sees NA => pct_change is also NA
  expect_true(is.na(b_2022))
})

test_that("pct_change: zero denominator produces NaN not error", {
  dt <- data.table::data.table(
    grp  = c("A", "A"),
    time = as.Date(c("2020-01-01", "2021-01-01")),
    val  = c(0, 0)
  )
  out <- compute_volatility(dt, col = "val", agg_fn = "sum",
                            vol_fn = "pct_change", time = "time", groups = "grp")
  expect_true(is.nan(out[time == as.Date("2021-01-01"), pct_change]))
})

test_that("pct_change: value goes from zero to positive produces Inf", {
  dt <- data.table::data.table(
    grp  = c("A", "A"),
    time = as.Date(c("2020-01-01", "2021-01-01")),
    val  = c(0, 100)
  )
  out <- compute_volatility(dt, col = "val", agg_fn = "sum",
                            vol_fn = "pct_change", time = "time", groups = "grp")
  expect_true(is.infinite(out[time == as.Date("2021-01-01"), pct_change]))
})

test_that("sd: returns one row per group with correct value", {
  dt <- data.table::data.table(
    grp  = c("A", "A", "A"),
    time = as.Date(c("2020-01-01", "2021-01-01", "2022-01-01")),
    val  = c(10, 20, 30)
  )
  out <- compute_volatility(dt, col = "val", agg_fn = "sum",
                            vol_fn = "sd", time = "time", groups = "grp")
  expect_equal(nrow(out), 1L)
  expect_named(out, c("grp", "sd"))
  expect_equal(out$sd, sd(c(10, 20, 30)))
})

test_that("cv: returns one row per group with correct value", {
  dt <- data.table::data.table(
    grp  = c("A", "A", "A"),
    time = as.Date(c("2020-01-01", "2021-01-01", "2022-01-01")),
    val  = c(10, 20, 30)
  )
  out <- compute_volatility(dt, col = "val", agg_fn = "sum",
                            vol_fn = "cv", time = "time", groups = "grp")
  expect_equal(nrow(out), 1L)
  expect_named(out, c("grp", "cv"))
  expect_equal(out$cv, sd(c(10, 20, 30)) / mean(c(10, 20, 30)))
})

test_that("rolling_sd: output has correct number of rows and NAs for fill", {
  dt <- data.table::data.table(
    grp  = c("A", "A", "A", "A"),
    time = as.Date(c("2020-01-01", "2021-01-01", "2022-01-01", "2023-01-01")),
    val  = c(10, 20, 30, 40)
  )
  out <- compute_volatility(dt, col = "val", agg_fn = "sum",
                            vol_fn = "rolling_sd", time = "time",
                            groups = "grp", window_size = 3)
  expect_equal(nrow(out), 4L)
  expect_equal(sum(is.na(out$rolling_sd)), 2L)  # first 2 rows fill = NA
})

test_that("rolling_cv: computes correctly at first full window", {
  vals <- c(10, 20, 30, 40)
  dt <- data.table::data.table(
    grp  = "A",
    time = as.Date(c("2020-01-01", "2021-01-01", "2022-01-01", "2023-01-01")),
    val  = vals
  )
  out <- compute_volatility(dt, col = "val", agg_fn = "sum",
                            vol_fn = "rolling_cv", time = "time",
                            groups = "grp", window_size = 3)
  expected_cv <- sd(vals[1:3]) / mean(vals[1:3])
  expect_equal(out[time == as.Date("2022-01-01"), rolling_cv], expected_cv)
})

test_that("rolling_pct_change: computes window start-to-end change", {
  dt <- data.table::data.table(
    grp  = "A",
    time = as.Date(c("2020-01-01", "2021-01-01", "2022-01-01")),
    val  = c(100, 150, 200)
  )
  out <- compute_volatility(dt, col = "val", agg_fn = "sum",
                            vol_fn = "rolling_pct_change", time = "time",
                            groups = "grp", window_size = 3)
  # window of [100, 150, 200]: (200 - 100) / 100 = 1.0
  expect_equal(out[time == as.Date("2022-01-01"), rolling_pct_change], 1.0)
})

test_that("invalid vol_fn is rejected", {
  dt <- data.table::data.table(
    grp  = "A",
    time = as.Date(c("2020-01-01", "2021-01-01")),
    val  = c(100, 110)
  )
  expect_error(
    compute_volatility(dt, col = "val", agg_fn = "sum",
                       vol_fn = "banana", time = "time", groups = "grp")
  )
})

test_that("single time period: pct_change returns all NA", {
  dt <- data.table::data.table(
    grp  = c("A", "B"),
    time = as.Date(c("2020-01-01", "2020-01-01")),
    val  = c(100, 200)
  )
  out <- compute_volatility(dt, col = "val", agg_fn = "sum",
                            vol_fn = "pct_change", time = "time", groups = "grp")
  expect_true(all(is.na(out$pct_change)))
})

test_that("multiple groups: pct_change computed independently per group", {
  dt <- data.table::data.table(
    grp1 = c("A", "A", "B", "B"),
    grp2 = c("X", "X", "X", "X"),
    time = rep(as.Date(c("2020-01-01", "2021-01-01")), 2),
    val  = c(100, 110, 200, 260)
  )
  out <- compute_volatility(dt, col = "val", agg_fn = "sum",
                            vol_fn = "pct_change", time = "time",
                            groups = c("grp1", "grp2"))
  expect_equal(out[grp1 == "A" & time == as.Date("2021-01-01"), pct_change], 0.1)
  expect_equal(out[grp1 == "B" & time == as.Date("2021-01-01"), pct_change], 0.3)
})

test_that("NAs in col: sum(NA, na.rm=TRUE) = 0, downstream pct_change reflects that", {
  # Note: agg_fn = "sum" uses na.rm = TRUE, so sum(NA) = 0, not NA.
  # This means the 2021 aggregated value is 0, and pct_change at 2021 = (0-100)/100 = -1.
  # At 2022, pct_change = (121 - 0) / 0 = Inf.
  dt <- data.table::data.table(
    grp  = c("A", "A", "A"),
    time = as.Date(c("2020-01-01", "2021-01-01", "2022-01-01")),
    val  = c(100, NA, 121)
  )
  out <- compute_volatility(dt, col = "val", agg_fn = "sum",
                            vol_fn = "pct_change", time = "time", groups = "grp")
  expect_equal(out[time == as.Date("2021-01-01"), value], 0)
  expect_equal(out[time == as.Date("2021-01-01"), pct_change], -1)
  expect_true(is.infinite(out[time == as.Date("2022-01-01"), pct_change]))
})

test_that("constant series: sd = 0, cv = 0", {
  dt <- data.table::data.table(
    grp  = c("A", "A", "A"),
    time = as.Date(c("2020-01-01", "2021-01-01", "2022-01-01")),
    val  = c(50, 50, 50)
  )
  out_sd <- compute_volatility(dt, col = "val", agg_fn = "sum",
                               vol_fn = "sd", time = "time", groups = "grp")
  out_cv <- compute_volatility(dt, col = "val", agg_fn = "sum",
                               vol_fn = "cv", time = "time", groups = "grp")
  expect_equal(out_sd$sd, 0)
  expect_equal(out_cv$cv, 0)
})
