pull_count <- function(x) {
  x |> count(name = ".n") |> pull(.data$.n)
}
