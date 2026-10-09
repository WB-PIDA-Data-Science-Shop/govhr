# Benchmark: three ways to compute estimate_movement_rates()
#
# All three produce the same table; they differ in how each person's
# positions at one snapshot are paired with their positions at the next:
#
#   pairwise    roll_snapshot_pairs() + .compute_transition_pair(): one join
#               on personnel_id per consecutive snapshot pair (the
#               implementation estimate_movement_rates() used up to govhr 0.4.1)
#   data_table  the current estimate_movement_rates() data.frame method:
#               number the snapshots and join every position at snapshot k
#               to the same person's positions at k + 1, in one pass
#   duckdb      estimate_movement_rates() on a DuckDB table (tbl_dbi method):
#               the same steps as SQL. The panel is written to a temporary
#               DuckDB file before timing starts, and the timed run includes
#               collect()ing the result
#
# Every method runs with group_cols = c("est_id", "paygrade") and
# salary_col = "salary", so the salary statistics are timed too.
#
# Panels go from 1e3 rows up to `max_rows` in powers of 10. A method is
# skipped at a size when its projected run time exceeds `time_budget`, or
# its projected peak memory exceeds the RAM currently available; the sweep
# stops when the panel itself no longer fits. Results are printed as they
# arrive and saved (CSV + log-log plot) to data-raw/bench/results/, the CSV
# after every size, so a run stopped part way keeps what it has measured.
#
# Usage, from the package root:
#   Rscript data-raw/bench/movement_rates.R                 # up to 1e8 rows
#   Rscript data-raw/bench/movement_rates.R 1e7             # up to 1e7 rows
#   Rscript data-raw/bench/movement_rates.R 1e9 character 3600 duckdb
#
# Arguments (all optional, positional):
#   max_rows     largest panel size, default 1e8
#   id_type      "character" (default, like real HRMIS ids) or "integer"
#   time_budget  max seconds for one run of one method, default 3600
#   methods      comma-separated subset of the methods above, default all
#
# Memory: peak memory is measured with gc() ("max used"), i.e. R heap only,
# so it is not reported for duckdb, whose memory lives outside R. DuckDB's
# memory limit is set to 80% of the RAM free when it connects, so beyond
# that it spills to disk.
#
# data-raw/ is listed in .Rbuildignore, so this is not part of the package.

suppressMessages(library(data.table))

# benchmark the working tree; skipped if the functions are already loaded
if (!exists("estimate_movement_rates")) pkgload::load_all(quiet = TRUE)

args <- commandArgs(trailingOnly = TRUE)
max_rows <- if (length(args) >= 1) as.numeric(args[1]) else 1e8
id_type <- if (length(args) >= 2) args[2] else "character"
time_budget <- if (length(args) >= 3) as.numeric(args[3]) else 3600
method_names <- if (length(args) >= 4) strsplit(args[4], ",")[[1]] else NULL
stopifnot(id_type %in% c("character", "integer"))

n_snaps <- 15L          # annual snapshots, as in a typical HRMIS extract
check_max_rows <- 1e7   # compare outputs across methods up to this size
results_dir <- file.path("data-raw", "bench", "results")
group_cols <- c("est_id", "paygrade")
salary_col <- "salary"

# ---- synthetic contracts panel --------------------------------------------

# ~n_rows contract-snapshot rows over n_snaps annual snapshots. ~5% of people
# are missing from any given snapshot (so there are leavers and entrants),
# each person is promoted one paygrade every 3-8 years, ~3% of rows sit in a
# different establishment than the person's usual one (transfers), and ~10%
# of rows are a second contract one paygrade up. ~3% of contracts are
# inactive. Rows are ordered by snapshot and shuffled by person within it.
make_contracts <- function(n_rows, id_type, seed = 1) {
  set.seed(seed)
  n_people <- max(10L, as.integer(ceiling(n_rows / n_snaps / 0.95 / 1.1)))
  perm <- sample.int(n_people)
  # format each id once per person, not once per row
  person_id <- if (id_type == "character") sprintf("E%09d", seq_len(n_people)) else seq_len(n_people)
  person_grade <- sample(1:6, n_people, replace = TRUE)
  person_speed <- sample(3:8, n_people, replace = TRUE)
  person_est <- sample(sprintf("E%02d", 1:20), n_people, replace = TRUE)
  snap_dates <- as.Date(sprintf("%d-01-01", 2009L + seq_len(n_snaps)))

  panel <- data.table(
    .p = rep.int(perm, n_snaps),
    .s = rep(seq_len(n_snaps), each = n_people)
  )
  panel <- panel[stats::runif(.N) > 0.05]
  panel[, .g := pmin(10L, person_grade[.p] + .s %/% person_speed[.p])]

  # second contracts, one paygrade up
  second <- panel[stats::runif(.N) < 0.1][, .g := pmin(10L, .g + 1L)]
  panel <- rbind(panel, second)
  setorder(panel, .s)

  n <- nrow(panel)
  panel[, `:=`(
    personnel_id = person_id[.p],
    ref_date = snap_dates[.s],
    est_id = person_est[.p],
    paygrade = sprintf("G%02d", .g),
    salary = 1000 * .g + round(stats::runif(n, 0, 500)),
    start_date = snap_dates[.s] - sample.int(3000L, n, replace = TRUE),
    end_date = as.Date(NA),
    contract_type = "permanent"
  )]
  panel[stats::runif(n) < 0.03, est_id := sprintf("E%02d", sample.int(20L, .N, replace = TRUE))]
  panel[stats::runif(n) < 0.03, contract_type := "inactive"]

  panel[, c(".p", ".s", ".g") := NULL][]
}

# ---- the three methods ----------------------------------------------------

key_cols <- c("from_group", "to_group", "from_period", "to_period")

method_pairwise <- function(panel) {
  # roll_snapshot_pairs() keys the panel in place; it is generated already
  # ordered by ref_date, so this only sets the attribute (dropped after)
  on.exit(setattr(panel, "sorted", NULL))
  all_periods <- roll_snapshot_pairs(
    panel_dt = panel, date_col = "ref_date", f = .compute_transition_pair,
    ref_date_col = "ref_date", group_cols = group_cols,
    personnel_id_col = "personnel_id", start_date_col = "start_date",
    end_date_col = "end_date", contract_type_col = "contract_type",
    salary_col = salary_col
  )
  setnames(all_periods, c("t0_date", "t1_date", "period_prob"),
           c("from_period", "to_period", "movement_rate"))
  out <- all_periods[, c("from_group", "to_group", "movement_rate", "from_period",
                         "to_period", "n_pop", "n_moves", "mean_salary_t0",
                         "mean_salary_t1", "mean_salary_change",
                         "median_salary_change", "mean_salary_pct_change"),
                     with = FALSE]
  out <- out[from_group != to_group & from_group != "NA" & to_group != "NA"]
  setkeyv(out, key_cols)[]
}

method_data_table <- function(panel) {
  estimate_movement_rates(panel, group_cols = group_cols, salary_col = salary_col)
}

# `panel` here is a lazy DuckDB table; see duckdb_input()
method_duckdb <- function(panel) {
  out <- as.data.table(dplyr::collect(
    estimate_movement_rates(panel, group_cols = group_cols, salary_col = salary_col)
  ))
  setkeyv(out, key_cols)[]
}

methods <- list(
  pairwise = method_pairwise,
  data_table = method_data_table,
  duckdb = method_duckdb
)
if (!is.null(method_names)) {
  stopifnot(all(method_names %in% names(methods)))
  methods <- methods[method_names]
}

# write the panel to a temporary, file-backed DuckDB database (so DuckDB can
# spill to disk) and return the lazy table plus a function that cleans up
duckdb_input <- function(panel) {
  path <- tempfile(fileext = ".duckdb")
  con <- suppressMessages(DBI::dbConnect(duckdb::duckdb(), dbdir = path))
  if (is.finite(available_bytes())) {
    DBI::dbExecute(con, sprintf(
      "SET memory_limit = '%dMB'", as.integer(0.8 * available_bytes() / 2^20)
    ))
  }
  DBI::dbWriteTable(con, "contracts", panel)
  list(
    table = dplyr::tbl(con, "contracts"),
    close = function() {
      DBI::dbDisconnect(con, shutdown = TRUE)
      unlink(path)
    }
  )
}

# ---- measurement helpers --------------------------------------------------

available_bytes <- function() {
  if (requireNamespace("ps", quietly = TRUE)) ps::ps_system_memory()$avail else Inf
}

# R heap in use now, and the most used since the last reset (both in bytes).
# object.size() is no use here: it counts every element of a character
# vector as its own string, wildly overstating a panel's real footprint
heap_bytes <- function() sum(gc()[, 2]) * 2^20
start_peak <- function() {
  base <- heap_bytes()
  invisible(gc(reset = TRUE))
  base
}
peak_since <- function(base) sum(gc()[, 6]) * 2^20 - base

# median elapsed seconds over `reps` runs, and the peak R-heap growth (bytes)
# over the input panel during the first run
measure <- function(f, panel, reps) {
  base <- start_peak()
  times <- numeric(reps)
  for (r in seq_len(reps)) {
    times[r] <- system.time(out <- f(panel))[["elapsed"]]
    if (r == 1L) peak <- peak_since(base)
    if (r < reps) rm(out)
  }
  list(seconds = stats::median(times), peak_bytes = peak, out = out)
}

reps_for <- function(n) if (n <= 1e5) 10L else if (n <= 1e6) 5L else if (n <= 1e7) 3L else 1L

fmt_bytes <- function(b) sprintf("%.1f GB", b / 1e9)

# ---- sweep ----------------------------------------------------------------

sizes <- 10^(3:9)
sizes <- sizes[sizes <= max_rows]

cat(sprintf(
  "estimate_movement_rates() benchmark | R %s | data.table %s (%d threads) | %s ids | RAM available %s\n\n",
  as.character(getRversion()), as.character(packageVersion("data.table")),
  getDTthreads(), id_type, fmt_bytes(available_bytes())
))

dir.create(results_dir, showWarnings = FALSE, recursive = TRUE)
stamp <- format(Sys.time(), "%Y%m%d-%H%M%S")
csv <- file.path(results_dir, sprintf("movement_rates_%s_%s.csv", id_type, stamp))

# (re)write everything measured so far
save_results <- function() {
  results <- rbindlist(rows)
  results[, speedup_vs_pairwise := NA_real_]
  if ("pairwise" %in% results$method) {
    pairwise_times <- results[method == "pairwise", .(rows, pairwise_seconds = seconds)]
    results[pairwise_times, speedup_vs_pairwise := i.pairwise_seconds / seconds, on = "rows"]
  }
  results[, `:=`(id_type = id_type, threads = getDTthreads(),
                 r_version = as.character(getRversion()))]
  fwrite(results, csv)
  invisible(results)
}

last <- list()  # per method: n, seconds, peak bytes per row at its last run
rows <- list()
gen_peak_per_row <- NA_real_  # building a panel peaks at ~2x its final size
data_per_row <- NA_real_      # heap held by the finished panel

for (n in sizes) {
  # don't spend time building a panel nothing can run on
  if (!is.na(gen_peak_per_row)) {
    avail <- 0.9 * available_bytes()
    # duckdb's peak is not measured (NA): it needs little R memory beyond
    # the panel, so count it as 0
    method_bytes <- function(l) (data_per_row + max(0, l$peak_per_row, na.rm = TRUE)) * n
    fits <- vapply(last, function(l) method_bytes(l) <= avail, logical(1))
    stop_why <- if (gen_peak_per_row * n > avail) {
      sprintf("building the panel alone needs ~%s", fmt_bytes(gen_peak_per_row * n))
    } else if (!any(fits)) {
      sprintf("the leanest method needs ~%s with the panel",
              fmt_bytes(min(vapply(last, method_bytes, 1))))
    }
    if (!is.null(stop_why)) {
      cat(sprintf("stopping at %s rows: %s, %s available\n",
                  format(n, big.mark = ","), stop_why, fmt_bytes(available_bytes())))
      break
    }
  }

  base <- start_peak()
  panel <- make_contracts(n, id_type)
  gen_peak_per_row <- peak_since(base) / nrow(panel)
  data_per_row <- (heap_bytes() - base) / nrow(panel)
  reps <- reps_for(n)
  outs <- list()

  for (m in names(methods)) {
    skip <- NA_character_
    if (m == "duckdb" && !requireNamespace("duckdb", quietly = TRUE)) {
      skip <- "duckdb is not installed"
    } else if (!is.null(last[[m]])) {
      scale <- nrow(panel) / last[[m]]$n
      proj_time <- last[[m]]$seconds * scale * 1.2
      proj_mem <- last[[m]]$peak_per_row * nrow(panel)
      if (proj_time > time_budget) {
        skip <- sprintf("projected %.0fs > budget %.0fs", proj_time, time_budget)
      } else if (!is.na(proj_mem) && proj_mem > 0.9 * available_bytes()) {
        skip <- sprintf("projected peak %s > 90%% of available %s",
                        fmt_bytes(proj_mem), fmt_bytes(available_bytes()))
      }
    }
    if (!is.na(skip)) {
      res <- list(seconds = NA_real_, peak_bytes = NA_real_)
    } else {
      if (m == "duckdb") {
        db <- duckdb_input(panel)
        res <- measure(methods[[m]], db$table, reps)
        db$close()
        res$peak_bytes <- NA_real_  # outside the R heap
      } else {
        res <- measure(methods[[m]], panel, reps)
      }
      outs[[m]] <- res$out
      last[[m]] <- list(n = nrow(panel), seconds = res$seconds,
                        peak_per_row = res$peak_bytes / nrow(panel))
    }

    # compare each output with the first method's at this size
    matches <- NA
    if (n <= check_max_rows && !is.null(outs[[m]])) {
      matches <- isTRUE(all.equal(outs[[m]], outs[[1L]], check.attributes = FALSE))
    }

    rows[[length(rows) + 1L]] <- data.table(
      rows = nrow(panel), method = m, reps = if (is.na(skip)) reps else 0L,
      seconds = res$seconds, peak_gb = res$peak_bytes / 1e9,
      matches_first = matches, skipped = skip
    )
    cat(sprintf("%13s rows  %-10s  %s\n", format(nrow(panel), big.mark = ","), m,
                if (is.na(skip)) sprintf("%9.3fs  peak %8s%s", res$seconds,
                                         if (is.na(res$peak_bytes)) "n/a" else fmt_bytes(res$peak_bytes),
                                         if (isFALSE(matches)) "  OUTPUT DIFFERS" else "")
                else paste("skipped:", skip)))
  }
  rm(panel, outs); invisible(gc())
  save_results()
}

results <- save_results()
cat("\n")
print(results[, .(rows, method, seconds, peak_gb, speedup_vs_pairwise, matches_first, skipped)])

# ---- plot -----------------------------------------------------------------

plot_dt <- melt(
  results[!is.na(seconds)],
  id.vars = c("rows", "method"), measure.vars = c("seconds", "peak_gb"),
  variable.name = "metric"
)[!is.na(value)]
plot_dt[, metric := factor(metric, c("seconds", "peak_gb"),
                           c("Median run time (s)", "Peak R heap above input (GB)"))]
p <- ggplot2::ggplot(plot_dt, ggplot2::aes(rows, value, colour = method)) +
  ggplot2::geom_line() +
  ggplot2::geom_point() +
  ggplot2::scale_x_log10() +
  ggplot2::scale_y_log10() +
  ggplot2::facet_wrap(~metric, scales = "free_y") +
  ggplot2::labs(
    x = "Panel rows", y = NULL, colour = NULL,
    title = "estimate_movement_rates(): pairwise vs data.table (one join) vs DuckDB",
    subtitle = sprintf("%s ids, %d snapshots, group_cols = %s, salary_col = \"%s\", %d data.table threads",
                       id_type, n_snaps, paste(group_cols, collapse = " + "), salary_col,
                       getDTthreads())
  ) +
  ggplot2::theme_bw()
png_file <- sub("\\.csv$", ".png", csv)
ggplot2::ggsave(png_file, p, width = 9, height = 4.5, dpi = 120)

cat("\nsaved", csv, "and", png_file, "\n")
