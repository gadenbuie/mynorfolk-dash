stats_today <- function(norfolk, today, yesterday) {
  opened_today <-
    norfolk |> filter(creation_date >= today)

  opened_yesterday <-
    norfolk |> filter(between(creation_date, yesterday, today))

  closed_today <-
    norfolk |>
    filter(status == "Closed", modification_date >= today)

  closed_yesterday <-
    norfolk |>
    filter(
      status == "Closed",
      between(modification_date, yesterday, today)
    )

  cancelled_today <-
    norfolk |>
    filter(status == "Cancelled", modification_date >= today)

  cancelled_yesterday <-
    norfolk |>
    filter(
      status == "Cancelled",
      between(modification_date, yesterday, today)
    )

  in_progress_total <-
      norfolk |>
      filter(status == "In progress")

  in_progress_new <-
      norfolk |>
      filter(status == "In progress", modification_date >= today)

  data <- list(
    opened = opened_today,
    closed = closed_today,
    cancelled = cancelled_today,

    opened_yesterday = opened_yesterday,
    closed_yesterday = closed_yesterday,
    cancelled_yesterday = cancelled_yesterday,

    in_progress_total = in_progress_total,
    in_progress_new = in_progress_new
  )

  counts <- lapply(data, pull_count)
  names(counts) <- paste0("n_", names(data))

  c(data, counts)
}
