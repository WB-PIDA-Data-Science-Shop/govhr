
plot_movement <- function(
  movement_data, 
  movement_type = c("hire", "separation", "joint", "net"), 
  group_cols = NULL
) {
  movement_type <- rlang::arg_match(movement_type)

  movement <- movement_data |>
    tidyr::pivot_longer(
      c(hire_rate, separation_rate),
      names_to = "movement_type",
      values_to = "value"
    )
  
  if(movement_type == "hire") {
    movement <- movement |>
      filter(movement_type == "hire_rate")
  } else if (movement_type == "separation") {
    movement <- movement |>
      filter(movement_type == "separation_rate")
  } else if (movement_type == "net") {
    return(plot_movement_net(movement_data, group_cols))
  }

  plot <- movement |>
    ggplot2::ggplot(
      ggplot2::aes(
        x = .data[["ref_date"]],
        y = .data[["value"]],
        color = .data[["movement_type"]],
        group = .data[["movement_type"]]
      )
    ) +
    ggplot2::geom_line() +
    ggplot2::scale_color_manual(
      name = "Type of Movement",
      labels = c(
        "hire_rate" = "Hires",
        "separation_rate" = "Separations"
      ),
      values = c(
        "hire_rate" = "#202d85",
        "separation_rate" = "#de4500"
      )
    ) +
    ggplot2::labs(
      x = "Year",
      y = "Movement Rate"
    ) +
    ggplot2::scale_y_continuous(
      labels = scales::percent_format(accuracy = 0.1)
    ) +
    ggplot2::theme(
      legend.position = "bottom"
    )

  if (!is.null(group_cols)) {
    missing_cols <- setdiff(group_cols, names(movement_long))

    if (length(missing_cols) > 0) {
      rlang::abort(
        paste0("`group_cols` not found in data: ", paste(missing_cols, collapse = ", "))
      )
    }

    plot <- plot +
      ggplot2::facet_wrap(
        ggplot2::vars(!!!rlang::syms(group_cols))
      )
  }

  plot
}

plot_movement_net <- function(movement_data, group_cols = NULL) {
  movement_net_rate <- movement_data |>
    mutate(
      net_rate = hire_rate - separation_rate,
      net_rate_sign = if_else(net_rate >= 0, "positive", "negative")
    ) 
    
  plot <- movement_net_rate |>
    ggplot() +
    geom_col(
      aes(
        x = ref_date,
        y = net_rate,
        fill = net_rate_sign
      ),
      color = "white",
      linewidth = 0.1
    ) +
    theme(
      legend.position = "none"
    ) +
    # different colors depending on whether net rate is positive or negative
    scale_fill_manual(
      values = c(
        "positive" = "#202d85",
        "negative" = "#de4500"
      )
    ) +
    scale_y_continuous(
      labels = scales::percent_format(accuracy = 0.1)
    ) +
    labs(
      x = "Year",
      y = "Net Movement Rate"
    ) 

  if (!is.null(group_cols)) {
    missing_cols <- setdiff(group_cols, names(movement_net_rate))

    if (length(missing_cols) > 0) {
      rlang::abort(
        paste0("`group_cols` not found in data: ", paste(missing_cols, collapse = ", "))
      )
    }

    plot <- plot +
      ggplot2::facet_wrap(
        ggplot2::vars(!!!rlang::syms(group_cols)),
        labeller = ggplot2::labeller(
          occupation_group = \(x) stringr::str_wrap(x, width = 30)
        )
      )
  }

  plot
}