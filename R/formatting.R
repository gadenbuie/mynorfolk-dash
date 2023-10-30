`%||%` <- rlang::`%||%`

number <- scales::number_format(big.mark = ",")

new_change_with_caret_formatter <- function(caret_more = NULL, caret_less = NULL) {
  caret_more <- format(caret_more %||% '<i class="bi bi-caret-up-fill"></i>')
  caret_less <- format(caret_less %||% '<i class="bi bi-caret-down-fill"></i>')

  function(then, now, ..., when = "yesterday", more = "more than", less = "less than") {
    diff <- now - then
    if (diff == 0) {
      return(paste0("No change", ...))
    }
    ret <- paste0(
      "<span>",
      if (diff > 0) caret_more else caret_less,
      " ",
      scales::number(abs(diff), big.mark = ","),
      if (diff > 0) paste0(" ", more),
      if (diff < 0) paste0(" ", less),
      if (!is.null(when)) paste0(" ", when),
      ...,
      "</span>"
    )
    htmltools::HTML(ret)
  }
}

change <- new_change_with_caret_formatter()
