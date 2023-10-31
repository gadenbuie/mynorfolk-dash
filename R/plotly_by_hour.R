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
