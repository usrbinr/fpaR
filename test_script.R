

pak::pak(c("RPostgres","RMariaDB"))

pak::pak("dittodb")

library(dittodb)

con_lite <- DBI::dbConnect(RSQLite::SQLite())

DBI::dbWriteTable(con_lite,"sales",sales,)

sales_lite <- dplyr::tbl(con_lite,"sales")

DBI::dbDisconnect(con_lite)



con_maria <- DBI::dbConnect(RMariaDB::MariaDB())

DBI::dbWriteTable(con_maria,"sales",sales)

sales_maria <- dplyr::tbl(con_maria,"sales")

con <- dbConnect(RPostgres::Postgres())


con_maria <- DBI::dbConnect(RPostgres::Postgres())

DBI::dbWriteTable(con_maria,"sales",sales)

sales_maria <- dplyr::tbl(con_maria,"sales")

con_lite <- DBI::dbConnect(RSQLite::SQLite())

DBI::dbWriteTable(con,"sales",sales)



get_an_airline <- function(con) {
  return(dbGetQuery(con, "SELECT mpg  FROM mtcars LIMIT 1"))
}


con <- DBI::dbConnect(RSQLite::SQLite())

DBI::dbWriteTable(con,"mtcars",mtcars)

get_an_airline(con)

DBI::dbListTables(con)

start_db_capturing(con)

con <- DBI::dbConnect(RSQLite::SQLite())

DBI::dbWriteTable(con,"mtcars",mtcars)


get_an_airline(con)
DBI::dbDisconnect(con)

stop_db_capturing()


with_mock_db({
  # con <- DBI::dbConnect(
  #   RMariaDB::MariaDB(),
  #   dbname = "nycflights"
  # )



  test_that("We get one airline", {
    one_airline <- get_an_airline(con)
    expect_s3_class(one_airline, "data.frame")
    expect_equal(nrow(one_airline), 1)
    expect_equal(one_airline$mpg, 21)
  })
})
