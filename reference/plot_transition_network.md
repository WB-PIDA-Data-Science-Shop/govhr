# Plot Transition Network

Draws career transitions as a directed graph, with edge width
proportional to the number of transitions and node size to degree
centrality. Networks of ten or more nodes are labelled by index rather
than by name.

## Usage

``` r
plot_transition_network(.data)
```

## Arguments

- .data:

  Data frame with \`from\` and \`to\` columns, as returned by
  \[detect_career_transition()\].

## Value

A ggiraph girafe object.
