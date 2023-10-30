top_requests <- function(x, ..., n = 10) {
  x |>
    filter(...) |>
    count(service_request_type, sort = TRUE) |>
    slice_max(n, n = n, with_ties = FALSE) |>
    mutate(service_request_type = fct_reorder(service_request_type, n))
}

plot_top_requests <- function(norfolk, ..., n = 10) {
  norfolk |>
    top_requests(..., n = n) |>
    ggplot() +
    aes(n, service_request_type) +
    geom_col() +
    labs(x = NULL, y = NULL)
}

plotly_top_requests <- function(norfolk, ..., n = 10) {
  norfolk |>
    top_requests(..., n = n) |>
    mutate(n_text = paste(scales::number(n, big.mark = ","), "requests")) |>
    plotly::plot_ly(
      x = ~n,
      y = ~service_request_type,
      hovertemplate = "%{hovertext}<extra></extra>",
      hovertext = ~ n_text,
      type = "bar",
      orientation = "h",
      name = ""
    ) |>
    plotly::layout(
      xaxis = list(title = ""),
      yaxis = list(title = "", ticksuffix = " ", tickfont = list(size = 16)),
      hoverlabel = list(namelength = 0)
    ) |>
    plotly::config(displayModeBar = F)
}
