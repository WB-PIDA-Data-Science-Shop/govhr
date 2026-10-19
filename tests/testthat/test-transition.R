
# ---- detect_transition and compute_transition --------------------------------
# Backs both the transition panel and the pre-computed analytics cache. Every
# test runs on a data frame (data.table method) and on a duckdb table (tbl_dbi
# method), so the two implementations are held to the same behaviour.

backends <- c("data.frame", "duckdb")

# run `fun` on `data` or a duckdb copy of it, and return an in-memory data
# frame sorted the same way for both backends
run_transition <- function(backend, fun, data, ...) {
  if (backend == "duckdb") {
    skip_if_not_installed("duckdb")
    skip_if_not_installed("dbplyr")

    # silence duckdb's notice about where it stores extensions
    con <- suppressMessages(DBI::dbConnect(duckdb::duckdb()))
    on.exit(DBI::dbDisconnect(con, shutdown = TRUE))

    DBI::dbWriteTable(con, "careers", data)
    data <- dplyr::tbl(con, "careers")
  }

  result <- as.data.frame(dplyr::collect(fun(data, ...)))

  sort_cols <- intersect(
    c("personnel_id", "from_date", "ref_date", "from", "to"),
    names(result)
  )
  result <- result[do.call(order, unname(result[sort_cols])), ]
  rownames(result) <- NULL

  result
}

# `a` stays in G1 for two periods and then moves twice; `b` never moves
careers <- data.frame(
  personnel_id = c("a", "a", "a", "a", "b", "b"),
  ref_date = as.Date(c(
    "2020-01-01", "2021-01-01", "2022-01-01", "2023-01-01",
    "2020-01-01", "2021-01-01"
  )),
  paygrade = c("G1", "G1", "G2", "G3", "G5", "G5"),
  unit = c("U1", "U1", "U1", "U1", "U2", "U2"),
  stringsAsFactors = FALSE
)

# `a` holds A and B, then A and C, then only A. `b` holds A through two
# records, then A and B. `c` holds A, joins B, then moves to C. `d` never moves
several <- data.frame(
  personnel_id = c(
    "a", "a", "a", "a", "a",
    "b", "b", "b", "b",
    "c", "c", "c", "c",
    "d", "d"
  ),
  ref_date = as.Date(c(
    "2020-01-01", "2020-01-01", "2021-01-01", "2021-01-01", "2022-01-01",
    "2020-01-01", "2020-01-01", "2021-01-01", "2021-01-01",
    "2020-01-01", "2021-01-01", "2021-01-01", "2022-01-01",
    "2020-01-01", "2021-01-01"
  )),
  paygrade = c(
    "A", "B", "A", "C", "A",
    "A", "A", "A", "B",
    "A", "A", "B", "C",
    "A", "A"
  ),
  stringsAsFactors = FALSE
)

# `a` leaves after 2020 and returns to a new paygrade; `b` leaves after 2020,
# returns to the same paygrade and then moves; `c` is seen on every date
returns <- data.frame(
  personnel_id = c("a", "a", "a", "b", "b", "b", "c", "c", "c", "c"),
  ref_date = as.Date(c(
    "2020-01-01", "2022-01-01", "2023-01-01",
    "2020-01-01", "2022-01-01", "2023-01-01",
    "2020-01-01", "2021-01-01", "2022-01-01", "2023-01-01"
  )),
  paygrade = c("G1", "G2", "G3", "G1", "G1", "G2", "G5", "G5", "G5", "G5"),
  stringsAsFactors = FALSE
)

for (backend in backends) {
  test_that(paste(backend, "- collapses a stay and dates each move by its arrival"), {
    result <- run_transition(
      backend,
      detect_transition,
      careers,
      group_col = "paygrade"
    )

    # G1 (2020-2021) -> G2 (2022) -> G3 (2023) is two moves. each lands when
    # the new group is first seen, not when the old one began
    expect_equal(result[["personnel_id"]], c("a", "a"))
    expect_equal(result[["from"]], c("G1", "G2"))
    expect_equal(result[["to"]], c("G2", "G3"))
    expect_equal(
      result[["from_date"]],
      as.Date(c("2020-01-01", "2022-01-01"))
    )
    expect_equal(
      result[["ref_date"]],
      as.Date(c("2022-01-01", "2023-01-01"))
    )
  })

  test_that(paste(backend, "- pairs every group held with every group joined"), {
    result <- run_transition(
      backend,
      detect_transition,
      several,
      group_col = "paygrade"
    )

    # a: A and B -> A and C is A -> C and B -> C, and dropping C joins nothing.
    # b: its two records in A count once. c: each origin is dated by when its
    # group was joined. d never moves
    expect_equal(result[["personnel_id"]], c("a", "a", "b", "c", "c", "c"))
    expect_equal(result[["from"]], c("A", "B", "A", "A", "A", "B"))
    expect_equal(result[["to"]], c("C", "C", "B", "B", "C", "C"))
    expect_equal(
      result[["from_date"]],
      as.Date(c(
        "2020-01-01", "2020-01-01", "2020-01-01",
        "2020-01-01", "2020-01-01", "2021-01-01"
      ))
    )
    expect_equal(
      result[["ref_date"]],
      as.Date(c(
        "2021-01-01", "2021-01-01", "2021-01-01",
        "2021-01-01", "2022-01-01", "2022-01-01"
      ))
    )
  })

  test_that(paste(backend, "- compute_transition divides moves by the previous headcount"), {
    # c holds G1 through two records in 2020, but is one of three people in G1
    rates <- data.frame(
      personnel_id = c("a", "b", "c", "c", "d", "a", "b", "c", "d"),
      ref_date = as.Date(rep(c("2020-01-01", "2021-01-01"), times = c(5, 4))),
      paygrade = c("G1", "G1", "G1", "G1", "G2", "G3", "G1", "G3", "G3"),
      stringsAsFactors = FALSE
    )

    result <- run_transition(
      backend,
      compute_transition,
      rates,
      group_col = "paygrade"
    )

    expect_named(
      result,
      c("from", "to", "ref_date", "transitions", "transition_rate")
    )
    expect_equal(result[["from"]], c("G1", "G2"))
    expect_equal(result[["to"]], c("G3", "G3"))
    expect_equal(as.integer(result[["transitions"]]), c(2L, 1L))
    expect_equal(result[["transition_rate"]], c(2 / 3, 1))
  })

  test_that(paste(backend, "- a return after a separation starts a new career"), {
    result <- run_transition(
      backend,
      detect_transition,
      returns,
      group_col = "paygrade"
    )

    # a's G1 -> G2 spans its absence in 2021, and b's return to G1 starts a
    # new stay, so its move out of G1 dates from the return
    expect_equal(result[["personnel_id"]], c("a", "b"))
    expect_equal(result[["from"]], c("G2", "G1"))
    expect_equal(result[["to"]], c("G3", "G2"))
    expect_equal(
      result[["from_date"]],
      as.Date(c("2022-01-01", "2022-01-01"))
    )
  })

  test_that(paste(backend, "- across_separations counts moves across a separation"), {
    result <- run_transition(
      backend,
      detect_transition,
      returns,
      group_col = "paygrade",
      across_separations = TRUE
    )

    expect_equal(result[["personnel_id"]], c("a", "a", "b"))
    expect_equal(result[["from"]], c("G1", "G2", "G1"))
    expect_equal(result[["to"]], c("G2", "G3", "G2"))
    expect_equal(
      result[["from_date"]],
      as.Date(c("2020-01-01", "2022-01-01", "2020-01-01"))
    )

    # with nobody observed in 2021, moving from 2020 to 2022 is no separation
    biennial <- returns[returns[["ref_date"]] != as.Date("2021-01-01"), ]

    expect_equal(
      run_transition(backend, detect_transition, biennial, group_col = "paygrade"),
      result
    )
  })

  test_that(paste(backend, "- drop_duplicates drops entities with several records on a date"), {
    # `a` holds two paygrades in 2021
    doubled <- data.frame(
      personnel_id = c("a", "a", "a", "b", "b"),
      ref_date = as.Date(c(
        "2020-01-01", "2021-01-01", "2021-01-01",
        "2020-01-01", "2021-01-01"
      )),
      paygrade = c("G1", "G2", "G3", "G1", "G2"),
      stringsAsFactors = FALSE
    )

    # one surplus record, three dropped in total, one offending id
    expect_warning(
      result <- run_transition(
        backend,
        detect_transition,
        doubled,
        group_col = "paygrade",
        drop_duplicates = TRUE
      ),
      "1 record\\(s\\) are not uniquely identified.*3 record\\(s\\).*1 affected"
    )
    expect_equal(result[["personnel_id"]], "b")

    # by default `a` stays, moving from G1 to both groups it joins
    expect_no_warning(
      kept <- run_transition(
        backend,
        detect_transition,
        doubled,
        group_col = "paygrade"
      )
    )
    expect_equal(kept[["personnel_id"]], c("a", "a", "b"))


    # compute_transition() drops duplicates once, before detecting the moves,
    # so it warns once. `a` is dropped from the headcount too, leaving b alone
    # in G1
    warnings <- capture_warnings(
      counts <- run_transition(
        backend,
        compute_transition,
        doubled,
        group_col = "paygrade",
        drop_duplicates = TRUE
      )
    )
    expect_length(warnings, 1)
    expect_equal(counts[["from"]], "G1")
    expect_equal(counts[["to"]], "G2")
    expect_equal(counts[["transition_rate"]], 1)
  })

  test_that(paste(backend, "- compute_transition counts the moves detect_transition finds"), {
    moves <- run_transition(
      backend,
      detect_transition,
      careers,
      group_col = "paygrade"
    )
    counts <- run_transition(
      backend,
      compute_transition,
      careers,
      group_col = "paygrade"
    )

    expect_equal(counts[["from"]], moves[["from"]])
    expect_equal(counts[["to"]], moves[["to"]])
    expect_equal(counts[["ref_date"]], moves[["ref_date"]])
    expect_equal(as.integer(counts[["transitions"]]), c(1L, 1L))
    expect_equal(counts[["transition_rate"]], c(1, 1))
  })
}

test_that("detect_transition takes a single group column", {
  expect_error(
    detect_transition(careers, group_col = c("paygrade", "unit")),
    "single column"
  )
})

test_that("detect_transition and compute_transition reject unknown arguments", {
  expect_error(
    detect_transition(careers, group_col = "paygrade", acros_separations = TRUE),
    "must be empty"
  )
  # the former `group_cols` and `summarize` arguments are no longer accepted
  expect_error(
    detect_transition(careers, group_cols = "paygrade"),
    "must be empty"
  )
  expect_error(
    compute_transition(careers, group_col = "paygrade", summarize = TRUE),
    "must be empty"
  )
})
