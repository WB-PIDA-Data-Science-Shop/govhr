library(testthat)
library(data.table)

# Every test runs on data frames (data.table methods) and on duckdb tables
# (tbl_dbi methods), so the two implementations are held to the same
# behaviour.

backends <- c("data.frame", "duckdb")

# run a tenure function on `contracts` or a duckdb copy of it, and return an
# in-memory data.table sorted by its key columns, so both backends compare
tenure_on <- function(backend, fun, contracts, ...) {
  if (backend == "duckdb") {
    skip_if_not_installed("duckdb")
    skip_if_not_installed("dbplyr")
    con <- suppressMessages(DBI::dbConnect(duckdb::duckdb()))
    on.exit(DBI::dbDisconnect(con, shutdown = TRUE))
    DBI::dbWriteTable(con, "contracts", as.data.frame(contracts))
    contracts <- dplyr::tbl(con, "contracts")
  }

  out <- data.table::as.data.table(dplyr::collect(fun(contracts, ...)))
  keys <- setdiff(names(out), c("tenure_days", "tenure_years", "spell_years"))
  data.table::setorderv(out, keys)
  out
}

# ---------------------------------------------------------------------------
# Helper: minimal contract data.table
# ---------------------------------------------------------------------------
make_contracts <- function(personnel_id,
                           contract_id,
                           start_date,
                           end_date,
                           contract_type_code = "permanent") {
  data.table::data.table(
    personnel_id  = personnel_id,
    contract_id   = contract_id,
    start_date    = as.Date(start_date),
    end_date      = as.Date(end_date),
    contract_type = contract_type_code
  )
}

ref <- "2020-01-01"

# ---- compute_tenure --------------------------------------------------------

test_that("compute_tenure() returns a data.table for a data frame", {
  dt <- make_contracts("P1", "C1", "2015-01-01", "2019-01-01")
  expect_s3_class(compute_tenure(dt, ref_date = ref), "data.table")
})

for (backend in backends) {
  run <- function(...) tenure_on(backend, compute_tenure, ...)

  # -------------------------------------------------------------------------
  # Output structure
  # -------------------------------------------------------------------------
  test_that(paste0("compute_tenure returns correct columns and one row per person (", backend, ")"), {
    dt <- make_contracts("P1", "C1", "2015-01-01", "2019-01-01")
    out <- run(dt, ref_date = ref)
    expect_named(out, c("personnel_id", "tenure_days", "tenure_years"))
    expect_equal(nrow(out), 1L)
  })

  test_that(paste0("tenure_years == tenure_days / 365.25 (", backend, ")"), {
    dt <- make_contracts("P1", "C1", "2015-01-01", "2019-01-01")
    out <- run(dt, ref_date = ref)
    expect_equal(out$tenure_years, out$tenure_days / 365.25)
  })

  # -------------------------------------------------------------------------
  # Single non-overlapping contract
  # -------------------------------------------------------------------------
  test_that(paste0("single contract: tenure equals end minus start in days (", backend, ")"), {
    dt <- make_contracts("P1", "C1", "2018-01-01", "2019-01-01")
    out <- run(dt, ref_date = ref)
    expected_days <- as.numeric(as.Date("2019-01-01") - as.Date("2018-01-01"))
    expect_equal(out$tenure_days, expected_days)
  })

  # -------------------------------------------------------------------------
  # ref_date coercion
  # -------------------------------------------------------------------------
  test_that(paste0("ref_date accepts a character string (", backend, ")"), {
    dt <- make_contracts("P1", "C1", "2018-01-01", "2019-06-01")
    expect_no_error(run(dt, ref_date = "2020-01-01"))
  })

  test_that(paste0("ref_date accepts a Date object (", backend, ")"), {
    dt <- make_contracts("P1", "C1", "2018-01-01", "2019-06-01")
    expect_no_error(run(dt, ref_date = as.Date("2020-01-01")))
  })

  test_that(paste0("character and Date ref_date give identical results (", backend, ")"), {
    dt <- make_contracts("P1", "C1", "2018-01-01", "2019-06-01")
    r1 <- run(dt, ref_date = "2020-01-01")
    r2 <- run(dt, ref_date = as.Date("2020-01-01"))
    expect_equal(r1$tenure_days, r2$tenure_days)
  })

  # -------------------------------------------------------------------------
  # Open-ended contract (end_date = NA)
  # -------------------------------------------------------------------------
  test_that(paste0("open-ended contract is capped at ref_date (", backend, ")"), {
    dt <- make_contracts("P1", "C1", "2018-01-01", NA)
    out <- run(dt, ref_date = "2020-01-01")
    expected_days <- as.numeric(as.Date("2020-01-01") - as.Date("2018-01-01"))
    expect_equal(out$tenure_days, expected_days)
  })

  # -------------------------------------------------------------------------
  # Contract starts after ref_date → excluded
  # -------------------------------------------------------------------------
  test_that(paste0("contracts starting after ref_date are excluded and return empty (", backend, ")"), {
    dt <- make_contracts("P1", "C1", "2021-01-01", "2022-01-01")
    out <- run(dt, ref_date = "2020-01-01")
    expect_equal(nrow(out), 0L)
    expect_named(out, c("personnel_id", "tenure_days", "tenure_years"))
  })

  # -------------------------------------------------------------------------
  # Inactive / pensioner filtering
  # -------------------------------------------------------------------------
  test_that(paste0("inactive contracts are excluded (", backend, ")"), {
    dt <- make_contracts("P1", "C1", "2015-01-01", "2019-01-01",
                         contract_type_code = "inactive")
    out <- run(dt, ref_date = ref)
    expect_equal(nrow(out), 0L)
  })

  test_that(paste0("pensioner contracts are excluded (", backend, ")"), {
    dt <- make_contracts("P1", "C1", "2015-01-01", "2019-01-01",
                         contract_type_code = "pensioner")
    out <- run(dt, ref_date = ref)
    expect_equal(nrow(out), 0L)
  })

  test_that(paste0("active contract is kept when mixed with inactive (", backend, ")"), {
    dt <- data.table::rbindlist(list(
      make_contracts("P1", "C1", "2015-01-01", "2019-01-01", "permanent"),
      make_contracts("P1", "C2", "2015-01-01", "2019-01-01", "inactive")
    ))
    out <- run(dt, ref_date = ref)
    expect_equal(nrow(out), 1L)
  })

  test_that(paste0("a contract with a missing type is kept (", backend, ")"), {
    dt <- make_contracts("P1", "C1", "2018-01-01", "2019-01-01", NA_character_)
    out <- run(dt, ref_date = ref)
    expect_equal(out$tenure_days, 365)
  })

  # -------------------------------------------------------------------------
  # Overlapping contracts — must not double-count days
  # -------------------------------------------------------------------------
  test_that(paste0("two fully overlapping contracts count days only once (", backend, ")"), {
    dt <- data.table::rbindlist(list(
      make_contracts("P1", "C1", "2018-01-01", "2019-06-01"),
      make_contracts("P1", "C2", "2018-06-01", "2019-01-01")  # nested inside C1
    ))
    out_overlap  <- run(dt, ref_date = ref)
    out_single   <- run(
      make_contracts("P1", "C1", "2018-01-01", "2019-06-01"),
      ref_date = ref
    )
    expect_equal(out_overlap$tenure_days, out_single$tenure_days)
  })

  test_that(paste0("two partially overlapping contracts: union counted correctly (", backend, ")"), {
    # C1: 2018-01-01 → 2018-07-01  (181 days)
    # C2: 2018-04-01 → 2018-10-01  (183 days)
    # Union: 2018-01-01 → 2018-10-01
    dt <- data.table::rbindlist(list(
      make_contracts("P1", "C1", "2018-01-01", "2018-07-01"),
      make_contracts("P1", "C2", "2018-04-01", "2018-10-01")
    ))
    out <- run(dt, ref_date = ref)
    expected_days <- as.numeric(as.Date("2018-10-01") - as.Date("2018-01-01"))
    expect_equal(out$tenure_days, expected_days)
  })

  # -------------------------------------------------------------------------
  # Adjacent contracts — boundary day must not be double-counted
  # -------------------------------------------------------------------------
  test_that(paste0("adjacent contracts (end of A == start of B) are not double-counted (", backend, ")"), {
    # C1 ends 2018-07-01, C2 starts 2018-07-01 — the boundary day belongs to C2
    dt <- data.table::rbindlist(list(
      make_contracts("P1", "C1", "2018-01-01", "2018-07-01"),
      make_contracts("P1", "C2", "2018-07-01", "2019-01-01")
    ))
    out <- run(dt, ref_date = ref)
    # Total should equal the full span without the gap
    expected_days <- as.numeric(as.Date("2019-01-01") - as.Date("2018-01-01"))
    expect_equal(out$tenure_days, expected_days)
  })

  # -------------------------------------------------------------------------
  # Non-overlapping contracts with a gap
  # -------------------------------------------------------------------------
  test_that(paste0("gap between contracts is excluded from tenure (", backend, ")"), {
    # C1: 2016-01-01 → 2017-01-01 (366 days)
    # C2: 2018-01-01 → 2019-01-01 (365 days)
    # gap of 2017 is excluded
    dt <- data.table::rbindlist(list(
      make_contracts("P1", "C1", "2016-01-01", "2017-01-01"),
      make_contracts("P1", "C2", "2018-01-01", "2019-01-01")
    ))
    out <- run(dt, ref_date = ref)
    expected_days <- as.numeric(as.Date("2017-01-01") - as.Date("2016-01-01")) +
      as.numeric(as.Date("2019-01-01") - as.Date("2018-01-01"))
    expect_equal(out$tenure_days, expected_days)
  })

  # -------------------------------------------------------------------------
  # Multiple persons — one row per person, independent calculation
  # -------------------------------------------------------------------------
  test_that(paste0("multiple persons each get their own tenure row (", backend, ")"), {
    dt <- data.table::rbindlist(list(
      make_contracts("P1", "C1", "2015-01-01", "2019-01-01"),
      make_contracts("P2", "C2", "2016-01-01", "2019-01-01")
    ))
    out <- run(dt, ref_date = ref)
    expect_equal(nrow(out), 2L)
    expect_true("P1" %in% out$personnel_id)
    expect_true("P2" %in% out$personnel_id)
    # P1 has more tenure than P2
    p1 <- out[out$personnel_id == "P1", ]$tenure_days
    p2 <- out[out$personnel_id == "P2", ]$tenure_days
    expect_gt(p1, p2)
  })

  # -------------------------------------------------------------------------
  # Panel data — a contract seen at several snapshots counts once
  # -------------------------------------------------------------------------
  test_that(paste0("panel duplicates do not inflate tenure (", backend, ")"), {
    single <- make_contracts("P1", "C1", "2015-01-01", "2019-01-01")
    panel  <- data.table::rbindlist(replicate(3, single, simplify = FALSE))
    out_single <- run(single, ref_date = ref)
    out_panel  <- run(panel,  ref_date = ref)
    expect_equal(out_single$tenure_days, out_panel$tenure_days)
  })

  test_that(paste0("a contract seen with different end dates counts to the latest one (", backend, ")"), {
    # recorded first as ending in 2017, later as ending in 2018
    dt <- make_contracts("P1", "C1", "2015-01-01", c("2017-01-01", "2018-01-01"))
    out <- run(dt, ref_date = ref)
    expect_equal(out$tenure_days, as.numeric(as.Date("2018-01-01") - as.Date("2015-01-01")))
  })

  test_that(paste0("a contract seen in two groups counts in each (", backend, ")"), {
    dt <- make_contracts("P1", "C1", "2015-01-01", "2019-01-01")
    dt <- rbind(dt, dt)[, paygrade := c("A", "B")]
    out <- run(dt, ref_date = ref, group_cols = "paygrade")
    expect_equal(out$paygrade, c("A", "B"))
    expect_equal(out$tenure_days, rep(as.numeric(as.Date("2019-01-01") - as.Date("2015-01-01")), 2))
  })

  # -------------------------------------------------------------------------
  # Custom column names
  # -------------------------------------------------------------------------
  test_that(paste0("custom column names are respected (", backend, ")"), {
    dt <- data.table::data.table(
      pid   = "P1",
      cid   = "C1",
      s_dt  = as.Date("2015-01-01"),
      e_dt  = as.Date("2019-01-01"),
      ctype = "permanent"
    )
    out <- run(
      dt,
      ref_date           = ref,
      personnel_id_col   = "pid",
      contract_id_col    = "cid",
      start_date_col     = "s_dt",
      end_date_col       = "e_dt",
      contract_type_col  = "ctype"
    )
    expect_named(out, c("pid", "tenure_days", "tenure_years"))
    expect_equal(nrow(out), 1L)
  })

  test_that(paste0("a missing column errors naming it (", backend, ")"), {
    dt <- make_contracts("P1", "C1", "2015-01-01", "2019-01-01")
    expect_error(run(dt, ref_date = ref, group_cols = "paygrade"), "paygrade")
  })
}

# ---------------------------------------------------------------------------
# Input accepts data.frame (not just data.table)
# ---------------------------------------------------------------------------
test_that("data.frame input is accepted without error", {
  df <- as.data.frame(make_contracts("P1", "C1", "2015-01-01", "2019-01-01"))
  expect_no_error(compute_tenure(df, ref_date = ref))
})

# ---------------------------------------------------------------------------
# An end-date column that is entirely missing: open-ended contracts
#
# A column of nothing but NA (e.g. created as NA, or read from a file where
# every value is empty) is logical, not Date; it must mean "no end date"
# just as missing dates do. An R quirk, so data frames only
# ---------------------------------------------------------------------------
test_that("an end-date column of logical NA means open-ended contracts, as NA dates do", {
  as_date_na <- make_contracts("P1", "C1", "2015-01-01", NA)
  as_logical_na <- data.table::copy(as_date_na)[, end_date := NA]

  expect_equal(
    compute_tenure(as_logical_na, ref_date = ref),
    compute_tenure(as_date_na, ref_date = ref)
  )
})

test_that("compute_tenure_panel(): an end-date column of logical NA means open-ended contracts", {
  # a contract seen at two snapshots: tenure runs to each snapshot
  panel <- data.table::data.table(
    personnel_id = "P1",
    contract_id = "C1",
    ref_date = as.Date(c("2020-01-01", "2021-01-01")),
    start_date = as.Date("2019-01-01"),
    end_date = NA,
    contract_type = "permanent"
  )

  out <- compute_tenure_panel(panel)

  expect_equal(out$tenure_days, c(365, 731))
})

# ---- compute_tenure_panel and compute_employment_spells ---------------------

# one person over two snapshots:
#   2019-01-01: C1 (from 2018-01-01, open, paygrade A)
#   2020-01-01: C1 (paygrade B now) and C2 (2019-03-01 to 2020-06-01, nested
#               inside C1 up to the snapshot, paygrade A)
tenure_panel_fixture <- function() {
  data.table::data.table(
    personnel_id = "P1",
    contract_id = c("C1", "C1", "C2"),
    ref_date = as.Date(c("2019-01-01", "2020-01-01", "2020-01-01")),
    start_date = as.Date(c("2018-01-01", "2018-01-01", "2019-03-01")),
    end_date = as.Date(c(NA, NA, "2020-06-01")),
    contract_type = "permanent",
    paygrade = c("A", "B", "A")
  )
}

test_that("compute_tenure_panel() and compute_employment_spells() return a data.table for a data frame", {
  expect_s3_class(compute_tenure_panel(tenure_panel_fixture()), "data.table")
  expect_s3_class(compute_employment_spells(tenure_panel_fixture()), "data.table")
})

for (backend in backends) {
  test_that(paste0("compute_tenure_panel() gives the union of each snapshot's contracts, up to the snapshot (", backend, ")"), {
    out <- tenure_on(backend, compute_tenure_panel, tenure_panel_fixture())

    expect_named(out, c("personnel_id", "ref_date", "tenure_days", "tenure_years"))
    expect_equal(out$ref_date, as.Date(c("2019-01-01", "2020-01-01")))
    # C2 is inside C1, so 2020 counts C1 alone
    expect_equal(out$tenure_days, c(365, 730))
    expect_equal(out$tenure_years, out$tenure_days / 365.25)
  })

  test_that(paste0("compute_tenure_panel() with group_cols counts each group's contracts (", backend, ")"), {
    out <- tenure_on(backend, compute_tenure_panel, tenure_panel_fixture(), group_cols = "paygrade")

    expect_named(out, c("personnel_id", "paygrade", "ref_date", "tenure_days", "tenure_years"))
    expect_equal(out$paygrade, c("A", "A", "B"))
    expect_equal(out$ref_date, as.Date(c("2019-01-01", "2020-01-01", "2020-01-01")))
    # A in 2020 is C2 alone, from 2019-03-01 to the snapshot
    expect_equal(out$tenure_days, c(365, 306, 730))
  })

  test_that(paste0("compute_tenure_panel() with nothing to count gives no rows, with the usual columns (", backend, ")"), {
    contracts <- tenure_panel_fixture()[, start_date := as.Date("2025-01-01")]

    out <- tenure_on(backend, compute_tenure_panel, contracts, group_cols = "paygrade")

    expect_equal(nrow(out), 0L)
    expect_named(out, c("personnel_id", "paygrade", "ref_date", "tenure_days", "tenure_years"))
  })

  test_that(paste0("compute_employment_spells() gives each person and group's tenure at its last snapshot (", backend, ")"), {
    # A is last seen in 2020 (through C2), B in 2020 (C1)
    out <- tenure_on(backend, compute_employment_spells, tenure_panel_fixture(), group_cols = "paygrade")

    expect_named(out, c("personnel_id", "paygrade", "ref_date", "spell_years"))
    expect_equal(out$paygrade, c("A", "B"))
    expect_equal(out$ref_date, as.Date(c("2020-01-01", "2020-01-01")))
    expect_equal(out$spell_years, c(306, 730) / 365.25)
  })

  test_that(paste0("compute_employment_spells() works with other column names (", backend, ")"), {
    contracts <- data.table::setnames(
      tenure_panel_fixture(),
      c("personnel_id", "ref_date"),
      c("pid", "snapshot")
    )

    out <- tenure_on(
      backend, compute_employment_spells, contracts,
      personnel_id_col = "pid", ref_date_col = "snapshot", group_cols = "paygrade"
    )

    expect_named(out, c("pid", "paygrade", "snapshot", "spell_years"))
    expect_equal(out$spell_years, c(306, 730) / 365.25)
  })
}

test_that("both backends agree on the bundled data, for all three functions", {
  skip_if_not_installed("duckdb")
  skip_if_not_installed("dbplyr")
  # the columns needed only: some text columns of the bundled data are not
  # valid UTF-8, which duckdb refuses
  contracts <- data.table::as.data.table(bra_hrmis_contract)[,
    .(personnel_id, contract_id, ref_date, start_date, end_date, contract_type, paygrade)
  ]

  for (args in list(
    list(compute_tenure, ref_date = "2015-01-01"),
    list(compute_tenure, ref_date = "2015-01-01", group_cols = "paygrade"),
    list(compute_tenure_panel),
    list(compute_tenure_panel, group_cols = "paygrade"),
    list(compute_employment_spells, group_cols = "paygrade")
  )) {
    from_df <- do.call(tenure_on, c(list("data.frame", args[[1]], contracts), args[-1]))
    from_db <- do.call(tenure_on, c(list("duckdb", args[[1]], contracts), args[-1]))
    expect_gt(nrow(from_df), 0L)
    expect_equal(from_db, from_df, ignore_attr = TRUE)
  }
})

test_that("an unsupported input errors", {
  for (fun in list(compute_tenure_panel, compute_employment_spells)) {
    expect_error(fun(list()), "must be a data frame or a lazy database table")
  }
  expect_error(compute_tenure(list(), ref_date = ref), "must be a data frame or a lazy database table")
})
