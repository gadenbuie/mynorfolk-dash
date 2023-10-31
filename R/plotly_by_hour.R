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
      xaxis = list(
        title = "",
        range = c(0, 24),
        dtick = 3,
        tickvals = seq(0, 21, 3),
        ticktext = c("12am", paste0(seq(3, 9, 3), "am"), "12pm", paste0(seq(3, 9, 3), "pm"))
      ),
      yaxis = list(title = "", overlaying = "y", side = "left"),
      barmode = "stack",
      legend = list(orientation = "h", y = -0.2)
    ) |>
    plotly::config(displayModeBar = FALSE)
}
