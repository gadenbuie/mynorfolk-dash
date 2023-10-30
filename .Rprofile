source("renv/activate.R")

if (requireNamespace("later", quietly = TRUE)) {
  later::later(function() {
    qvm_v <- tryCatch(system("qvm -v", intern = TRUE), error = function(...) "")
    if (nzchar(qvm_v)) {
      qvm_path <- system("qvm path active", intern = TRUE)
      if (nzchar(qvm_path)) {
        quarto_path <- file.path(qvm_path, "quarto")
        message("Setting QUARTO_PATH=", quarto_path)
        Sys.setenv(QUARTO_PATH = quarto_path)
      }
    }
  })
}
