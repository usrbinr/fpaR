devtools::check(remote=TRUE,manual = TRUE)

pkgdown::build_site(examples = FALSE)
devtools::document()

.Last.error
pak::pak("tinytable")
renv::snapshot()
pak::pak("tidyverse")
