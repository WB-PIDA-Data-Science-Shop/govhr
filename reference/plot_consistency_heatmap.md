# Plot value consistency by variable and group

Plots a heatmap of value consistency, with groups across and variables
down, from consistency already computed.

## Usage

``` r
plot_consistency_heatmap(data, group_col = "ref_date")
```

## Arguments

- data:

  Data frame with `variable`, `value_consistency` and the column named
  in `group_col`: one row per group and variable, such as
  [`compute_value_consistency()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_value_consistency.md)
  results for several value columns stacked with a `variable` column
  naming each.

- group_col:

  Character. Column whose values run across the heatmap. Default
  `"ref_date"`.

## Value

A plotly object.

## See also

[`compute_value_consistency()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_value_consistency.md),
which computes the consistency.

## Examples

``` r
hr <- data.frame(
  personnel_id = c("a", "a", "b"),
  ref_date = as.Date(c("2020-01-01", "2021-01-01", "2020-01-01")),
  birth_date = as.Date(c("1980-01-01", "1981-01-01", "1990-01-01"))
)
hr |>
  compute_value_consistency("personnel_id", "birth_date", group_cols = "ref_date") |>
  transform(variable = "birth_date") |>
  plot_consistency_heatmap()

{"x":{"visdat":{"822e7fc85b46":["function () ","plotlyVisDat"]},"cur_data":"822e7fc85b46","attrs":{"822e7fc85b46":{"x":{},"y":{},"z":{},"colorscale":[["0","#d32f2f"],["0.5","#f9a825"],["1","#388e3c"]],"zmin":0,"zmax":1,"xgap":2,"ygap":2,"hovertemplate":"Group: %{x}<br>Variable: %{y}<br>Consistency: %{z:.0%}<extra><\/extra>","colorbar":{"title":"Consistency","tickformat":".0%"},"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"heatmap"}},"layout":{"margin":{"b":40,"l":60,"t":25,"r":10},"xaxis":{"domain":[0,1],"automargin":true,"title":"Group"},"yaxis":{"domain":[0,1],"automargin":true,"title":"Variable","type":"category","categoryorder":"array","categoryarray":["birth_date"]},"scene":{"zaxis":{"title":"value_consistency"}},"hovermode":"closest","showlegend":false,"legend":{"yanchor":"top","y":0.5}},"source":"A","config":{"modeBarButtonsToAdd":["hoverclosest","hovercompare"],"showSendToCloud":false},"data":[{"colorbar":{"title":"Consistency","ticklen":2,"tickformat":".0%","len":0.5,"lenmode":"fraction","y":1,"yanchor":"top"},"colorscale":[["0","#d32f2f"],["0.5","#f9a825"],["1","#388e3c"]],"showscale":true,"x":["2020-01-01","2021-01-01"],"y":["birth_date","birth_date"],"z":[1,1],"zmin":0,"zmax":1,"xgap":2,"ygap":2,"hovertemplate":"Group: %{x}<br>Variable: %{y}<br>Consistency: %{z:.0%}<extra><\/extra>","type":"heatmap","xaxis":"x","yaxis":"y","frame":null}],"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.20000000000000001,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}
```
