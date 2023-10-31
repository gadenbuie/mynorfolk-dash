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
      yaxis = list(title = "", ticksuffix = " ", tickfont = list(size = 16))
    ) |>
    plotly::config(displayModeBar = F)
}

plotly_by_hour <- function(data) {
  data |>
    mutate(
      hour = lubridate::hour(creation_date),
      service_request_category = fct_rev(service_request_category)
    ) |>
    plotly::plot_ly(
      hovertemplate = "%{y}"
    ) |>
    plotly::add_histogram(
      x = ~hour,
      color = ~ service_request_category,
      type = "histogram"
    ) |>
    plotly::layout(
      xaxis = list(title = "Hour", range = c(0, 24)),
      yaxis = list(title = "", overlaying = "y", side = "left"),
      barmode = "stack",
      legend = list(orientation = "h", y = -0.2)
    ) |>
    plotly::config(displayModeBar = FALSE)
}
