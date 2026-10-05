
# ---- compute_transition ------------------------------------------------------
# Backs both the transition panel and the pre-computed analytics cache. Every
# test runs on a data frame (data.table method) and on a duckdb table (tbl_dbi
# method), so the two implementations are held to the same behaviour.

backends <- c("data.frame", "duckdb")

# run compute_transition() on `data` or a duckdb copy of it, and return an
# in-memory data frame sorted the same way for both backends
run_transition <- function(backend, data, ...) {
  if (backend == "duckdb") {
    skip_if_not_installed("duckdb")
    skip_if_not_installed("dbplyr")

    # silence duckdb's notice about where it stores extensions
    con <- suppressMessages(DBI::dbConnect(duckdb::duckdb()))
    on.exit(DBI::dbDisconnect(con, shutdown = TRUE))

    DBI::dbWriteTable(con, "careers", data)
    data <- dplyr::tbl(con, "careers")
  }

  result <- as.data.frame(dplyr::collect(compute_transition(data, ...)))

  sort_cols <- intersect(
    c("contract_id", "from_date", "ref_date", "from", "to"),
    names(result)
  )
  result <- result[do.call(order, unname(result[sort_cols])), ]
  rownames(result) <- NULL

  result
}

careers <- data.frame(
  contract_id = c("a", "a", "a", "a", "b", "b"),
  ref_date = as.Date(c(
    "2020-01-01", "2021-01-01", "2022-01-01", "2023-01-01",
    "2020-01-01", "2021-01-01"
  )),
  paygrade = c("G1", "G1", "G2", "G3", "G5", "G5"),
  unit = c("U1", "U1", "U1", "U1", "U2", "U2"),
  stringsAsFactors = FALSE
)

# `a` holds two paygrades in 2021, so its position that period is undefined
doubled <- data.frame(
  contract_id = c("a", "a", "a", "b", "b"),
  ref_date = as.Date(c(
    "2020-01-01", "2021-01-01", "2021-01-01",
    "2020-01-01", "2021-01-01"
  )),
  paygrade = c("G1", "G2", "G3", "G1", "G2"),
  stringsAsFactors = FALSE
)

for (backend in backends) {
  test_that(paste(backend, "- collapses consecutive periods into spells"), {
    result <- run_transition(
      backend,
      careers,
      id_col = "contract_id",
      group_cols = "paygrade"
    )

    # a: G1 (2020-2021) -> G2 (2022) -> G3 (2023) is two transitions, not three
    expect_equal(nrow(result), 2L)
    expect_equal(result$from, c("G1", "G2"))
    expect_equal(result$to, c("G2", "G3"))
  })

  test_that(paste(backend, "- dates each row to the move itself"), {
    result <- run_transition(
      backend,
      careers,
      id_col = "contract_id",
      group_cols = "paygrade"
    )

    # the move out of G1 lands in 2022, when G2 is first observed, not in 2020
    # when G1 began; `from_date` keeps the origin spell's start
    expect_equal(result$ref_date, as.Date(c("2022-01-01", "2023-01-01")))
    expect_equal(result$from_date, as.Date(c("2020-01-01", "2022-01-01")))
  })

  test_that(paste(backend, "- does not pile moves onto the panel start"), {
    # every entity begins its first spell at the earliest date in the panel,
    # so dating by the origin spell backdated all first moves onto that period
    starts_together <- data.frame(
      contract_id = rep(c("a", "b", "c"), each = 3),
      ref_date = rep(
        as.Date(c("2020-01-01", "2021-01-01", "2022-01-01")),
        times = 3
      ),
      paygrade = c(
        "G1", "G1", "G2", # a moves in 2022
        "G1", "G1", "G2", # b moves in 2022
        "G1", "G2", "G2" # c moves in 2021
      ),
      stringsAsFactors = FALSE
    )

    counts <- run_transition(
      backend,
      starts_together,
      id_col = "contract_id",
      group_cols = "paygrade"
    ) |>
      (\(x) table(x$ref_date))()

    expect_false("2020-01-01" %in% names(counts))
    expect_equal(as.integer(counts[["2021-01-01"]]), 1L)
    expect_equal(as.integer(counts[["2022-01-01"]]), 2L)
  })

  test_that(paste(backend, "- leaves terminal spells undated"), {
    everyone <- run_transition(
      backend,
      careers,
      id_col = "contract_id",
      group_cols = "paygrade",
      return_all = TRUE
    )

    terminal <- everyone[is.na(everyone$to), ]

    expect_true(all(is.na(terminal$ref_date)))
    expect_true(all(!is.na(terminal$from_date)))
  })

  test_that(paste(backend, "- keeps non-movers only when return_all is TRUE"), {
    movers_only <- run_transition(
      backend,
      careers,
      id_col = "contract_id",
      group_cols = "paygrade"
    )
    everyone <- run_transition(
      backend,
      careers,
      id_col = "contract_id",
      group_cols = "paygrade",
      return_all = TRUE
    )

    # b never leaves G5
    expect_false("b" %in% movers_only$contract_id)
    expect_true("b" %in% everyone$contract_id)
    expect_true(is.na(everyone$to[everyone$contract_id == "b"]))
  })

  test_that(paste(backend, "- drops entities with duplicate periods"), {
    expect_warning(
      result <- run_transition(
        backend,
        doubled,
        id_col = "contract_id",
        group_cols = "paygrade"
      ),
      "not uniquely identified"
    )

    # the whole of `a` goes, not just its surplus record; `b` is untouched
    expect_false("a" %in% result$contract_id)
    expect_equal(result$contract_id, "b")
    expect_equal(result$from, "G1")
    expect_equal(result$to, "G2")
  })

  test_that(paste(backend, "- reports how much it drops"), {
    # one surplus record, three dropped in total, one offending id
    expect_warning(
      run_transition(
        backend,
        doubled,
        id_col = "contract_id",
        group_cols = "paygrade"
      ),
      "1 record\\(s\\) are not uniquely identified.*3 record\\(s\\).*1 affected"
    )
  })

  test_that(paste(backend, "- stays quiet when records are unique"), {
    expect_no_warning(
      run_transition(
        backend,
        careers,
        id_col = "contract_id",
        group_cols = "paygrade"
      )
    )
  })

  test_that(paste(backend, "- combines multiple grouping columns"), {
    result <- run_transition(
      backend,
      careers,
      id_col = "contract_id",
      group_cols = c("paygrade", "unit")
    )

    expect_equal(result$from, c("G1 | U1", "G2 | U1"))
    expect_equal(result$to, c("G2 | U1", "G3 | U1"))
  })

  test_that(paste(backend, "- summarize counts moves by from, to and date"), {
    result <- run_transition(
      backend,
      careers,
      id_col = "contract_id",
      group_cols = "paygrade",
      summarize = TRUE
    )

    expect_named(result, c("from", "to", "ref_date", "transitions"))
    expect_equal(result$from, c("G1", "G2"))
    expect_equal(result$to, c("G2", "G3"))
    expect_equal(result$ref_date, as.Date(c("2022-01-01", "2023-01-01")))
    expect_equal(as.integer(result$transitions), c(1L, 1L))
  })

  test_that(paste(backend, "- rejects misspelled arguments"), {
    expect_error(
      run_transition(
        backend,
        careers,
        id_col = "contract_id",
        group_cols = "paygrade",
        sumarize = TRUE
      ),
      "must be empty"
    )
  })
}
