# ---- detect_workforce_flows --------------------------------------------------
# Every test runs on a data frame (data.table method) and on a duckdb table
# (tbl_dbi method), so the two implementations are held to the same behaviour.
# retirement_panel is in helper-retirement_panel.R

backends <- c("data.frame", "duckdb")

# run detect_workforce_flows() on `data` or a duckdb copy of it, and return an
# in-memory data frame sorted the same way for both backends
run_flows <- function(backend, data) {
  if (backend == "duckdb") {
    skip_if_not_installed("duckdb")
    skip_if_not_installed("dbplyr")

    # silence duckdb's notice about where it stores extensions
    con <- suppressMessages(DBI::dbConnect(duckdb::duckdb()))
    on.exit(DBI::dbDisconnect(con, shutdown = TRUE))

    DBI::dbWriteTable(con, "flows", data)
    data <- dplyr::tbl(con, "flows")
  }

  result <- as.data.frame(dplyr::collect(detect_workforce_flows(data)))
  result <- result[order(result[["ref_date"]], result[["personnel_id"]]), ]
  rownames(result) <- NULL

  result
}

# active personnel from 2020 to 2022, and pensions registered up to 2023:
# a is active throughout
# b leaves after the first date
# c joins on the last date
# d is active on a middle date only, so is both hired and separated
# e retires after 2021, with the pension registered after the last date with
#   active personnel
# f is a pensioner in 2023, but leaves after the last date with active
#   personnel, so the exit is never compared
edges <- data.frame(
  personnel_id = c(
    "a", "b", "e",
    "a", "d", "e", "f",
    "a", "c", "f",
    "e", "f"
  ),
  ref_date = as.Date(c(
    "2020-01-01", "2020-01-01", "2020-01-01",
    "2021-01-01", "2021-01-01", "2021-01-01", "2021-01-01",
    "2022-01-01", "2022-01-01", "2022-01-01",
    "2023-01-01", "2023-01-01"
  )),
  employment_status = c(rep("active", 10), rep("pensioner", 2))
)

# unevenly spaced dates, with people missing on some of them:
# a is active on every date
# b is missing in February, so leaves and is rehired in June
# c retires in January and is rehired in June, a retiree back on contract
# d is missing in February and returns in June before retiring, so the first
#   exit is a separation
gaps <- data.frame(
  personnel_id = c(
    "a", "b", "c", "d",
    "a", "c",
    "a", "b", "c", "d",
    "a", "b", "c", "d"
  ),
  ref_date = as.Date(c(
    "2020-01-01", "2020-01-01", "2020-01-01", "2020-01-01",
    "2020-02-01", "2020-02-01",
    "2020-06-01", "2020-06-01", "2020-06-01", "2020-06-01",
    "2021-01-01", "2021-01-01", "2021-01-01", "2021-01-01"
  )),
  employment_status = c(
    "active", "active", "active", "active",
    "active", "pensioner",
    "active", "active", "active", "active",
    "active", "active", "active", "pensioner"
  )
)

for (backend in backends) {
  test_that(paste0("leaves flows past the first and last dates NA (", backend, ")"), {
    result <- run_flows(backend, edges)

    expect_equal(
      result[c("personnel_id", "ref_date", "hire", "separation", "retirement")],
      data.frame(
        personnel_id = c("a", "b", "e", "a", "d", "e", "f", "a", "c", "f"),
        ref_date = rep(
          as.Date(c("2020-01-01", "2021-01-01", "2022-01-01")),
          times = c(3, 4, 3)
        ),
        hire = c(NA, NA, NA, FALSE, TRUE, FALSE, TRUE, FALSE, TRUE, FALSE),
        separation = c(FALSE, TRUE, FALSE, FALSE, TRUE, FALSE, FALSE, NA, NA, NA),
        retirement = c(FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, FALSE, NA, NA, NA)
      )
    )

    # a single date has nothing to compare with
    single_date <- run_flows(
      backend,
      edges[edges[["ref_date"]] == as.Date("2021-01-01"), ]
    )
    flow_cols <- c("prev_date", "next_date", "hire", "separation", "retirement")
    expect_true(all(is.na(single_date[flow_cols])))
  })

  test_that(paste0("compares each date with the next date in the data (", backend, ")"), {
    result <- run_flows(backend, gaps)
    dates <- as.Date(c("2020-01-01", "2020-02-01", "2020-06-01", "2021-01-01"))

    # the months between February and June are missing for everyone, so are
    # not a gap for a
    calendar <- unique(result[c("ref_date", "prev_date", "next_date")])
    expect_equal(calendar[["ref_date"]], dates)
    expect_equal(calendar[["prev_date"]], dates[c(NA, 1, 2, 3)])
    expect_equal(calendar[["next_date"]], dates[c(2, 3, 4, NA)])

    expect_equal(
      result[c("personnel_id", "ref_date", "hire", "separation", "retirement")],
      data.frame(
        personnel_id = c("a", "b", "c", "d", "a", "a", "b", "c", "d", "a", "b", "c"),
        ref_date = rep(dates, times = c(4, 1, 4, 3)),
        hire = c(NA, NA, NA, NA, FALSE, FALSE, TRUE, TRUE, TRUE, FALSE, FALSE, FALSE),
        separation = c(FALSE, TRUE, FALSE, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, NA, NA, NA),
        retirement = c(FALSE, FALSE, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, NA, NA, NA)
      )
    )
  })

  test_that(paste0("headcount changes by hires less separations and retirements (", backend, ")"), {
    panels <- list(retirement_panel = retirement_panel, edges = edges, gaps = gaps)

    for (panel_name in names(panels)) {
      panel <- panels[[panel_name]]
      flows <- run_flows(backend, panel)

      # counted from the data rather than from the flows, so a person missing
      # from the flows breaks the identity
      headcount <- panel |>
        dplyr::filter(.data[["employment_status"]] == "active") |>
        dplyr::summarise(
          headcount = dplyr::n_distinct(.data[["personnel_id"]]),
          .by = "ref_date"
        )

      hires <- flows |>
        dplyr::summarise(
          hires = sum(.data[["hire"]]),
          .by = "ref_date"
        )

      # exits are flagged on the last active date, but leave the headcount on
      # the next
      exits <- flows |>
        dplyr::filter(!is.na(.data[["next_date"]])) |>
        dplyr::summarise(
          separations = sum(.data[["separation"]]),
          retirements = sum(.data[["retirement"]]),
          .by = "next_date"
        )

      accounts <- headcount |>
        dplyr::left_join(hires, by = "ref_date") |>
        dplyr::left_join(exits, by = c("ref_date" = "next_date")) |>
        dplyr::arrange(.data[["ref_date"]]) |>
        dplyr::mutate(
          prev_headcount = dplyr::lag(.data[["headcount"]]),
          net_flows = .data[["hires"]] - .data[["separations"]] - .data[["retirements"]]
        )

      expect_equal(
        accounts[["headcount"]][-1],
        (accounts[["prev_headcount"]] + accounts[["net_flows"]])[-1],
        info = panel_name
      )
    }
  })
}
