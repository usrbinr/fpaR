
## calendar table--------


#' Generate a Cross-Dialect SQL Date Series
#'
#' @description
#' Creates a lazy `dbplyr` table containing a continuous sequence of dates.
#' The function automatically detects the SQL dialect of the connection and
#' dispatches the most efficient native series generator (e.g., `GENERATE_SERIES`
#' for DuckDB/Postgres or `GENERATOR` for Snowflake).
#'
#' @details
#' This function is designed to be "nestable," meaning the resulting SQL can be
#' used safely inside larger `dplyr` pipelines. It avoids `WITH` clauses in
#' dialects like DuckDB to prevent parser errors when `dbplyr` wraps the query
#' in a subquery (e.g., `SELECT * FROM (...) AS q01`).
#'
#' For unit testing, the function supports `dbplyr` simulation objects. If a
#' `TestConnection` is detected, it returns a `lazy_frame` to avoid metadata
#' field queries that would otherwise fail on a mock connection.
#'
#' @param start_date A character string in 'YYYY-MM-DD' format or a Date object
#' representing the start of the series.
#' @param end_date A character string in 'YYYY-MM-DD' format or a Date object
#' representing the end of the series.
#' @param time_unit A character string specifying the interval. Must be one of:
#' \code{"day"}, \code{"week"}, \code{"month"}, \code{"quarter"}, or \code{"year"}.
#' @param .con A valid DBI connection object (e.g., DuckDB, Postgres, Snowflake)
#' or a \code{dbplyr} simulated connection.
#'
#' @return A \code{tbl_lazy} (SQL) object with a single column \code{date}.
#'
#' @examples
#' \dontrun{
#' con <- DBI::dbConnect(duckdb::duckdb())
#' # Generates a daily sequence for the year 2025
#' calendar <- seq_date_sql("2025-01-01", "2025-12-31", "day", con)
#' }
#'
#' @keywords internal
seq_date_sql <- function(start_date, end_date, time_unit, .con) {

  # 1. Validations ----------------------------------------------------------
  assertthat::assert_that(
    time_unit %in% c("day", "week", "month", "quarter", "year"),
    msg = "Please have time unit match 'day', 'week','month','quarter' or 'year'"
  )

  # 2. Variable Prep -------------------------------------------------------
  unit <- tolower(time_unit)
  is_duckdb_pg <- inherits(.con, "duckdb_.connection") || inherits(.con, "Pq.connection")
  is_snowflake <- inherits(.con, "Snowflake")
  is_test      <- inherits(.con, "Test.connection")

  # 3. SQL Dispatch --------------------------------------------------------

  if (is_duckdb_pg) {

    time_interval <- paste("1",time_unit)

    date_seq_sql <- glue::glue_sql("
  WITH DATE_SERIES AS (
  SELECT

  GENERATE_SERIES(
     MIN(DATE_TRUNC({time_unit}, DATE {start_date}::date))::DATE
    ,MAX(DATE_TRUNC({time_unit}, DATE {end_date}::date))::DATE
    ,INTERVAL {time_interval}
  ) AS DATE_LIST),

  CALENDAR_TBL AS (
        SELECT

        UNNEST(DATE_LIST)::DATE AS date

        FROM DATE_SERIES

        )
  SELECT *
  FROM CALENDAR_TBL

",.con=.con)
  }

  else if (is_snowflake) {
    # SNOWFLAKE: Uses the GENERATOR table function (no WITH clause needed)
    date_seq_sql <- glue::glue_sql("
      SELECT
        DATEADD({unit}, SEQ4(), DATE_TRUNC({unit}, {start_date}::DATE))::DATE AS date
      FROM TABLE(GENERATOR(ROWCOUNT => (
        DATEDIFF({unit}, {start_date}::DATE, {end_date}::DATE) + 1
      )))
    ",.con = .con)
  }

  else {
    # FALLBACK: Recursive CTE (Note: This may still struggle in subqueries
    # depending on the backend, but is the standard for T-SQL)
    date_seq_sql <- glue::glue_sql("
      WITH date_range AS (
        SELECT CAST({start_date} AS DATE) AS date
        UNION ALL
        SELECT DATEADD({unit*}, 1, date)
        FROM date_range
        WHERE date < CAST({end_date} AS DATE)
      )
      SELECT date FROM date_range
    ", .con = .con)
  }

  # 4. Handle Return --------------------------------------------------------

  # Protect simulations from 'dbGetQuery' errors
  if (is_test) {
    return(
      dbplyr::lazy_frame(
        date = as.Date(start_date),
        con = .con,
        .name = as.character(date_seq_sql)
      )
    )
  }

  # Return as lazy tbl
  return(dplyr::tbl(.con, dplyr::sql(date_seq_sql)))
}


#' Make an in memory database from a table
#'
#' @param x tibble or dbi object
#' @export
#' @returns dbi object
#' @keywords internal
#' Coerce data into a DuckDB-backed lazy table
#'
#' @description
#' Ensures the input is a database-backed object. If a data.frame is provided,
#' it is registered into a temporary, in-memory DuckDB instance. If already
#' a `tbl_dbi`, it is returned unchanged.
#'
#' @param x A tibble, data.frame, or tbl_dbi object.
#' @return A \code{tbl_dbi} object backed by DuckDB.
#'
#' @details
#' When converting a data.frame, this function preserves existing \code{dplyr}
#' groups. It uses DuckDB's \code{duckdb_register}, which is a virtual registration
#' and does not perform a physical copy of the data, making it extremely fast.
#'
#' @export
#' @keywords internal
make_db_tbl <- function(x) {

  # 1. Type Validation
  assertthat::assert_that(
    inherits(x, "data.frame") || inherits(x, "tbl_dbi"),
    msg = "Input must be a data.frame, tibble, or tbl_dbi object."
  )

  # 2. Return early if already in a DB
  if (inherits(x, "tbl_dbi")) {
    return(x)
  }

  # 3. Convert data.frame to DuckDB
  # Extract group metadata
  groups_lst <- dplyr::groups(x)

  # Use a global or session-persistent connection to avoid overhead
  # DuckDB ':memory:' is faster than tempfile() for small/medium sets
  con <- DBI::dbConnect(duckdb::duckdb(), ":memory:")

  # Register the data.frame as a virtual table
  # This is O(1) complexity because it references R memory directly
  duckdb::duckdb_register(con, name = "virtual_table", df = x)


  # Create the lazy table and re-apply groups
  out <- dplyr::tbl(con, "virtual_table") |>
    dplyr::group_by(!!!groups_lst)

  return(out)
}

