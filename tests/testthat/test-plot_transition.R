# ---- plot_transition and plot_transition_flows --------------------------------

# a and b move from A, so A is the busiest group and is numbered 1
careers <- data.frame(
  personnel_id = c("a", "a", "b", "b", "c", "c"),
  ref_date = as.Date(rep(c("2020-01-01", "2021-01-01"), times = 3)),
  unit = c("A", "B", "A", "C", "B", "A")
)

test_that("plot_transition counts moves alike from moves or from counts", {
  from_moves <- plot_transition(detect_transition(careers, group_col = "unit"))
  from_counts <- plot_transition(
    compute_transition(careers, group_col = "unit"),
    weight_col = "transitions"
  )

  nodes <- from_moves$data
  expect_equal(as.character(nodes$name), c("A", "B", "C"))
  expect_equal(as.integer(as.character(nodes$node_id)), 1:3)
  expect_equal(from_counts$data$strength, nodes$strength)

  expect_s3_class(
    plot_transition(detect_transition(careers, group_col = "unit"), interactive = TRUE),
    "girafe"
  )

  # the deprecated name still draws the same network, interactively by default
  lifecycle::expect_deprecated(
    network <- plot_transition_network(detect_transition(careers, group_col = "unit")),
    "plot_transition\\(\\)"
  )
  expect_s3_class(network, "girafe")
})

test_that("plot_transition_flows draws inflows above zero and outflows below", {
  plot <- compute_transition(careers, group_col = "unit") |>
    compute_transition_flows() |>
    plot_transition_flows()

  expect_true(all(plot$data$transitions_inflow >= 0))
  expect_true(all(plot$data$transitions_outflow <= 0))
  expect_equal(-sum(plot$data$transitions_outflow), sum(plot$data$transitions_inflow))
  expect_s3_class(plot$facet, "FacetWrap")
})
