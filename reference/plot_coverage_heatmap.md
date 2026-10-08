# Plot coverage by variable and group

Plots a heatmap of coverage, with groups across and variables down, from
coverage already computed.

## Usage

``` r
plot_coverage_heatmap(data, group_col = "ref_date")
```

## Arguments

- data:

  Data frame with `variable`, `coverage` and the column named in
  `group_col`, such as the output of
  `compute_coverage(group_cols = group_col)`.

- group_col:

  Character. Column whose values run across the heatmap. Default
  `"ref_date"`.

## Value

A plotly object.

## See also

[`compute_coverage()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_coverage.md),
which computes the coverage.

## Examples

``` r
hr <- data.frame(
  ref_date = as.Date(c("2020-01-01", "2020-01-01", "2021-01-01")),
  gender = c("F", NA, "M")
)
plot_coverage_heatmap(compute_coverage(hr, group_cols = "ref_date"))

{"x":{"visdat":{"822e67d53014":["function () ","plotlyVisDat"]},"cur_data":"822e67d53014","attrs":{"822e67d53014":{"x":{},"y":{},"z":{},"colorscale":[["0","#d32f2f"],["0.5","#f9a825"],["1","#388e3c"]],"zmin":0,"zmax":1,"xgap":2,"ygap":2,"hovertemplate":"Group: %{x}<br>Variable: %{y}<br>Coverage: %{z:.0%}<extra><\/extra>","colorbar":{"title":"Coverage","tickformat":".0%"},"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"heatmap"}},"layout":{"margin":{"b":40,"l":60,"t":25,"r":10},"xaxis":{"domain":[0,1],"automargin":true,"title":"Group"},"yaxis":{"domain":[0,1],"automargin":true,"title":"Variable","type":"category","categoryorder":"array","categoryarray":["gender"]},"scene":{"zaxis":{"title":"coverage"}},"hovermode":"closest","showlegend":false,"legend":{"yanchor":"top","y":0.5}},"source":"A","config":{"modeBarButtonsToAdd":["hoverclosest","hovercompare"],"showSendToCloud":false},"data":[{"colorbar":{"title":"Coverage","ticklen":2,"tickformat":".0%","len":0.5,"lenmode":"fraction","y":1,"yanchor":"top"},"colorscale":[["0","#d32f2f"],["0.5","#f9a825"],["1","#388e3c"]],"showscale":true,"x":["2020-01-01","2021-01-01"],"y":["gender","gender"],"z":[0.5,1],"zmin":0,"zmax":1,"xgap":2,"ygap":2,"hovertemplate":"Group: %{x}<br>Variable: %{y}<br>Coverage: %{z:.0%}<extra><\/extra>","type":"heatmap","xaxis":"x","yaxis":"y","frame":null}],"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.20000000000000001,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}
```
