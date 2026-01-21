


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
#' @param week_start description
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
seq_date_sql <- function(
    .con
    ,start_date
    ,end_date
    ,calendar_type = "standard"
    ,time_unit="day"
    ,week_start = 7) {

  browser()
  # 1. Validation Logic
  # assertthat::assert_that(
  #   assertthat::is.string(time_unit),
  #   assertthat::is.string(start_date),
  #   assertthat::is.string(end_date),
  #   assertthat::is.string(calendar_type),
  #   msg = "All inputs (time_unit, start_date, end_date, calendar_type) must be a single character string."
  # )

  # assertthat::assert_that(assertthat::is.string(start_date), msg = "start_date must be a string (YYYY-MM-DD)")

  assertthat::assert_that(any(time_unit %in% c("day", "month","quarter", "week","year")),msg = "time_unit must be one of: 'day', 'week','quarter, 'month' or 'year'")

  # assertthat::assert_that(assertthat::is.string(end_date), msg = "end_date must be a string (YYYY-MM-DD)")

  assertthat::assert_that(any(calendar_type %in% c("445", "454", "544","standard")),msg = "calendar_type must be one of: '445', '454', '544' or 'standard'")

  assertthat::assert_that(assertthat::is.number(week_start) && week_start %in% 1:7,
              msg = "week_start must be an integer between 1 (Monday) and 7 (Sunday)")




## standard
if(calendar_type=='standard'){

  date_seq_sql <- glue::glue_sql("
  WITH DATE_SERIES AS (
  SELECT

  GENERATE_SERIES(
     MIN(DATE_TRUNC('day', DATE {start_date}::date))::DATE
    ,MAX(DATE_TRUNC('day', DATE {end_date}::date))::DATE
    ,INTERVAL '1 day'
  ) AS DATE_LIST),

  CALENDAR_TBL AS (
        SELECT

        UNNEST(DATE_LIST)::DATE AS date

        FROM DATE_SERIES

        )
  SELECT *
  ,EXTRACT(YEAR FROM date) AS year
  ,EXTRACT(QUARTER FROM date) AS quarter
  ,EXTRACT(month FROM date) AS month
  ,FLOOR((EXTRACT(DOY FROM date) - 1) / 7) + 1 AS week

  FROM CALENDAR_TBL

",.con=.con)
}

 ## non-standard

if(calendar_type!='standard'){


    # 2. Logic for Pattern Boundaries
    bounds <- if (calendar_type == "445") {
      c(4, 8, 13, 17, 21, 26, 30, 34, 39, 43, 47)
    } else if (calendar_type == "454") {
      c(4, 9, 13, 17, 22, 26, 30, 35, 39, 43, 48)
    } else { # 544
      c(5, 9, 13, 18, 22, 26, 31, 35, 39, 44, 48)
    }

    # 3. Namespaced SQL String
    date_seq_sql <- glue::glue_sql("
  SELECT
    sub.calendar_date AS date,
    EXTRACT(YEAR FROM (sub.f_year_start + INTERVAL '6 months'))::INT AS year,
    CASE
      WHEN sub.week_num <= {bounds[3]}  THEN 1
      WHEN sub.week_num <= {bounds[6]}  THEN 2
      WHEN sub.week_num <= {bounds[9]}  THEN 3
      ELSE 4
    END AS quarter,
    CASE
      WHEN sub.week_num <= {bounds[1]}  THEN 1
      WHEN sub.week_num <= {bounds[2]}  THEN 2
      WHEN sub.week_num <= {bounds[3]}  THEN 3
      WHEN sub.week_num <= {bounds[4]}  THEN 4
      WHEN sub.week_num <= {bounds[5]}  THEN 5
      WHEN sub.week_num <= {bounds[6]}  THEN 6
      WHEN sub.week_num <= {bounds[7]}  THEN 7
      WHEN sub.week_num <= {bounds[8]}  THEN 8
      WHEN sub.week_num <= {bounds[9]}  THEN 9
      WHEN sub.week_num <= {bounds[10]} THEN 10
      WHEN sub.week_num <= {bounds[11]} THEN 11
      ELSE 12
    END AS month,
    sub.week_num AS week
  FROM (
    SELECT
      spine.date AS calendar_date,
      spine.f_year_start,
      (FLOOR((spine.date - spine.f_year_start) / 7)::INT + 1) AS week_num
    FROM (
      SELECT
        s.date_raw AS date,
        LAST_VALUE(a.anchor_date IGNORE NULLS) OVER (ORDER BY s.date_raw) AS f_year_start
      FROM (
        SELECT UNNEST(GENERATE_SERIES({start_date}::DATE, {end_date}::DATE, INTERVAL '1 day'))::DATE AS date_raw
      ) s
      LEFT JOIN (
        SELECT yr,
               CASE WHEN ABS(target_date - prev_s) <= ABS(next_s - target_date) THEN prev_s ELSE next_s END AS anchor_date
        FROM (
          SELECT yr, target_date,
                 (target_date - CAST(CASE WHEN EXTRACT(isodow FROM target_date) = 7 THEN 0 ELSE EXTRACT(isodow FROM target_date) END AS INT))::DATE AS prev_s,
                 (target_date - CAST(CASE WHEN EXTRACT(isodow FROM target_date) = 7 THEN 0 ELSE EXTRACT(isodow FROM target_date) END AS INT) + 7)::DATE AS next_s
          FROM (
            SELECT y_gen.yr, (y_gen.yr || '-01-31')::DATE AS target_date
            FROM (SELECT UNNEST(GENERATE_SERIES(EXTRACT(YEAR FROM {start_date}::DATE)::INT - 1,
                                               EXTRACT(YEAR FROM {end_date}::DATE)::INT + 1)) AS yr) y_gen
          ) t_inner
        ) a_calc
      ) a ON s.date_raw = a.anchor_date
    ) spine
  ) sub
  WHERE sub.f_year_start IS NOT NULL
  ",.con=.con)

}
  # return out

 calendar_dbi <-  dplyr::tbl(.con,dplyr::sql(date_seq_sql))


 time_unit_lst <- list(
   year="year"
   ,quarter=c("year","quarter")
   ,month=c("year","quarter","month")
   ,week=c("year","quarter","month","week")
   ,day=c("year","quarter","month","week")
 )

 group_cols <- c("date",time_unit_lst[[time_unit]])

 ### if non-standard need differnet logic -- min date.

out <-
  calendar_dbi |>
 dplyr::mutate(
   date=lubridate::floor_date(date,unit = time_unit)
 ) |>
   dplyr::summarise(
     .by=dplyr::any_of(group_cols)
     ,n=dplyr::n()
   ) |>
   dplyr::select(-c(n))



  return(out)

}

