#' Plot hires and separations over time
#'
#' Draws hires, separations, both, or the net movement between them for each
#' reference date, as counts or rates, from the output of
#' [compute_movement()].
#'
#' @param data Output of [compute_movement()]. A lazy table (`tbl_dbi`) is
#'   brought into memory first.
#' @param movement_type Character. What to draw:
#'   * `"hire"` (default): hires, as a line.
#'   * `"separation"`: separations, as a line.
#'   * `"joint"`: hires and separations, as two lines.
#'   * `"net"`: hires minus separations, as bars above or below zero.
#' @param measurement_type Character. `"count"` (default) or `"rate"`.
#' @param group_col Character. A column to split the plot by group, such as
#'   `"gender"`. It should be one of the `group_cols` used in
#'   [compute_movement()]. `NULL` (default) or `"ref_date"` draws the whole
#'   workforce.
#' @param group_cols `r lifecycle::badge("deprecated")` Use `group_col`
#'   instead.
#'
#' @returns A ggplot2 object.
#'
#' @details
#' Hires are drawn in blue and separations in orange, so the colours keep
#' their meaning across movement types: in `"net"`, a blue bar means more
#' hires than separations and an orange bar the reverse.
#'
#' With one movement (`"hire"` or `"separation"`), each group gets its own
#' coloured line. With two (`"joint"` and `"net"`), each group gets its own 
#' panel instead.
#'
#' The net rate is the hire rate minus the separation rate, which is the net
#' change in headcount divided by the previous headcount, as both rates share
#' that denominator.
#'
#' Dates with no hires or separations to compare with (`NA` in `data`), such
#' as the first date, are left out of the plot.
#'
#' @examples
#' hr <- data.frame(
#'   personnel_id = c(1, 2, 1, 3, 4, 1, 3),
#'   ref_date = as.Date(c(
#'     "2020-01-01", "2020-01-01",
#'     "2021-01-01", "2021-01-01", "2021-01-01",
#'     "2022-01-01", "2022-01-01"
#'   )),
#'   employment_status = "active"
#' )
#' movement <- compute_movement(hr)
#' plot_movement(movement, movement_type = "separation", measurement_type = "rate")
#' plot_movement(movement, movement_type = "joint")
#' plot_movement(movement, movement_type = "net")
#'
#' @export
plot_movement <- function(
  data,
  movement_type = c("hire", "separation", "joint", "net"),
  measurement_type = c("count", "rate"),
  group_col = NULL,
  group_cols = lifecycle::deprecated()
) {
  movement_type <- match.arg(movement_type)
  measurement_type <- match.arg(measurement_type)

  if (lifecycle::is_present(group_cols)) {
    lifecycle::deprecate_warn(
      when = "0.4.2",
      what = "plot_movement(group_cols)",
      with = "plot_movement(group_col)"
    )
    group_col <- group_cols
  }

  if (length(group_col) > 1) {
    stop("`group_col` must be a single column")
  }

  if (identical(group_col, "ref_date")) {
    group_col <- NULL
  }

  # the compute_movement() column of each movement
  measure_cols <- if (measurement_type == "count") {
    c(hire = "hires", separation = "separations")
  } else {
    c(hire = "hire_rate", separation = "separation_rate")
  }

  # reshaping below reads columns with `[[` and binds rows, which a lazy table
  # cannot do
  if (inherits(data, "tbl_dbi")) {
    data <- dplyr::collect(data)
  }

  # one row per date, group and movement, with the measure in `value`. the
  # column is `movement`, not `movement_type`, so it cannot mask the argument
  if (movement_type == "net") {
    # computed from the wide data, so each date and group gives one bar
    plot_data <- data |>
      dplyr::select(
        dplyr::all_of(c("ref_date", group_col))
      ) |>
      dplyr::mutate(
        value = data[[measure_cols[["hire"]]]] - data[[measure_cols[["separation"]]]],
        movement = dplyr::if_else(.data[["value"]] >= 0, "hire", "separation")
      )
  } else {
    movements <- if (movement_type == "joint") {
      c("hire", "separation")
    } else {
      movement_type
    }

    plot_data <- movements |>
      purrr::map(
        \(movement) data |>
          dplyr::select(
            dplyr::all_of(c("ref_date", group_col)),
            value = dplyr::all_of(measure_cols[[movement]])
          ) |>
          dplyr::mutate(movement = movement)
      ) |>
      dplyr::bind_rows()
  }

  plot_data <- plot_data |>
    dplyr::filter(!is.na(.data[["value"]]))

  y_label <- switch(
    paste(movement_type, measurement_type),
    "hire count" = "Hires",
    "hire rate" = "Hire rate",
    "separation count" = "Separations",
    "separation rate" = "Separation rate",
    "joint count" = "Hires and separations",
    "joint rate" = "Hire and separation rates",
    "net count" = "Net movement (hires minus separations)",
    "net rate" = "Net movement rate"
  )

  # blue for hires, orange for separations, in every movement type
  movement_colours <- c(hire = "#202d85", separation = "#de4500")

  plot <- plot_data |>
    ggplot2::ggplot(
      ggplot2::aes(.data[["ref_date"]], .data[["value"]])
    ) +
    ggplot2::labs(x = "Time", y = y_label)

  if (movement_type == "net") {
    plot <- plot +
      ggplot2::geom_col(
        ggplot2::aes(fill = .data[["movement"]]),
        colour = "white",
        linewidth = 0.1
      ) +
      ggplot2::geom_hline(yintercept = 0, colour = "grey40") +
      ggplot2::scale_fill_manual(values = movement_colours, guide = "none")
  } else {
    plot <- plot +
      ggplot2::geom_point() +
      ggplot2::geom_line()
  }

  if (movement_type == "joint") {
    plot <- plot +
      ggplot2::aes(
        colour = .data[["movement"]],
        group = .data[["movement"]]
      ) +
      ggplot2::scale_colour_manual(
        values = movement_colours,
        labels = c(hire = "Hires", separation = "Separations"),
        name = NULL
      )
  }

  if (measurement_type == "rate") {
    plot <- plot +
      ggplot2::scale_y_continuous(
        labels = scales::percent_format()
      )
  }

  if (is.null(group_col)) {
    return(plot)
  }

  if (movement_type %in% c("hire", "separation")) {
    n_groups <- dplyr::n_distinct(
      plot_data[[group_col]],
      na.rm = TRUE
    )
    orange_palette <- grDevices::colorRampPalette(c("#C34729", "#F5C6A0"))(n_groups)

    plot +
      ggplot2::aes(
        colour = .data[[group_col]],
        group = .data[[group_col]]
      ) +
      ggplot2::scale_colour_manual(values = orange_palette)
  } else {
    plot +
      ggplot2::facet_wrap(
        ggplot2::vars(.data[[group_col]]),
        labeller = ggplot2::label_wrap_gen(width = 20)
      )
  }
}
