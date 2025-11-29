#' Validate an input is YYYY-MM-DD format
#'
#' @param x date column
#'
#' @return logical
#' @keywords internal
is_yyyy_mm_dd <- function(x) {

out <-   suppressWarnings(!is.na(lubridate::ymd(x)))

return(out)


}



#' Generate CLI actions
#'
#' @param x input to test against
#' @param word the key word to validate
#'
#' @returns list
#' @keywords internal
generate_cli_action <- function(x,word){


  # x <- "test"
  # word <- "test"
  out <- list()

  if(any(x %in% stringr::str_to_lower(word))){

    out[[word]] <- c(cli::col_green(cli::symbol$tick),stringr::str_to_title(word))

  }else{

    out[[word]] <- c(cli::col_red(cli::symbol$cross),stringr::str_to_title(word))
  }

  return(out)
}



#' Make Action field CLI args
#'
#' @param x action class
#'
#' @returns list
#' @keywords internal
make_action_cli <- function(x){

  out <- list()

  # if(any(x %in% c("aggregate"))){
  #
  #   out$aggregate <- paste0(cli::col_green(cli::symbol$tick)," Aggregate")
  #
  # }else{
  #
  #   out$aggregate <- c(cli::col_red(cli::symbol$cross),"Aggregate")
  # }

  out[1] <- generate_cli_action(x,"aggregate")

  out[2] <- generate_cli_action(x,"shift")

  out[3] <- generate_cli_action(x,"compare")

  out[4] <- generate_cli_action(x,"proportion of total")

  out[5] <- generate_cli_action(x,"count distinct")

  return(out)

}



#' Prints function header info
#'
#' @param x ti or segment obj
#'
#' @returns print
#' @keywords internal
print_fn_info <- function(x) {

  cli::cli_h1(x@fn@fn_long_name)
  cli::cli_text("Function: {.code {x@fn@fn_name}} was executed")
  cli::cli_h2("Description:")
  cli::cli_par()
  cli::cli_text(x@action@method)
}

#' Prints functions next steps
#'
#' @returns print
#' @keywords internal
print_next_steps <- function(){

  cli::cli_h2("Next Steps:")

  cli::cli_li("Use {.code calculate()} to return the results")

  cli::cli_rule()
}


#' Print action steps
#'
#' @param x an S7 class
#'
#' @returns cli messages
#' @keywords internal
print_actions_steps <- function(x){

  cli::cli_h2("Actions:")


  if(any(stringr::str_detect(x@action@value[[1]],"32m"))){


    cli::cli_text(x@action@value[[1]]," ",cli::col_blue(x@value@value_vec))

  }else{

    cli::cli_text(x@action@value[[1]])

  }

  #shift

  cli::cli_text(x@action@value[[2]]," ",cli::col_green(stats::na.omit(x@fn@lag_n))," ",cli::col_green(stats::na.omit(x@fn@shift)))

  #compare

  cli::cli_text(x@action@value[[3]]," ",cli::col_br_magenta(stats::na.omit(x@fn@compare)))


  ## prop of total

  if(any(stringr::str_detect(x@action@value[[4]],"32m"))){


    cli::cli_text(x@action@value[[4]])

  }else{

    cli::cli_text(x@action@value[[4]])

  }

  ## distinct count


  if(any(stringr::str_detect(x@action@value[[5]],"32m"))){


    cli::cli_text(x@action@value[[5]]," ",cli::col_blue(x@value@value_vec))

  }else{

    cli::cli_text(x@action@value[[5]])

  }


}




#' @title Add Comprehensive Date-Based Attributes to a Data Frame
#'
#' @description
#' This function takes a data frame and a date column and generates a wide set of
#' derived date attributes. These include start/end dates for year, quarter,
#' month, and week; day-of-week indicators; completed and remaining days in each
#' time unit; and additional convenience variables such as weekend indicators.
#'
#' It is designed for time-based feature engineering and is useful in reporting,
#' forecasting, time-series modeling, and data enrichment workflows.
#'
#' @param .data A data frame or tibble containing at least one date column.
#' @param .date A column containing `Date` values, passed using tidy-eval
#'   (e.g., `{{ date_col }}`).
#'
#' @details
#' The function creates the following groups of attributes:
#'
#' **1. Start and end dates**
#'   - `year_start_date`, `year_end_date`
#'   - `quarter_start_date`, `quarter_end_date`
#'   - `month_start_date`, `month_end_date`
#'   - `week_start_date`, `week_end_date`
#'
#' **2. Day-of-week fields**
#'   - `day_of_week` – numeric day of the week (1–7)
#'   - `day_of_week_label` – ordered factor label (e.g., Mon, Tue, …)
#'
#' **3. Duration fields**
#'   - `days_in_year` – total days in the year interval
#'   - `days_in_quarter` – total days in the quarter interval
#'   - `days_in_month` – total days in the month
#'
#' **4. Completed/remaining days**
#'   - `days_complete_in_week`, `days_remaining_in_week`
#'   - `days_complete_in_month`, `days_remaining_in_month`
#'   - `days_complete_in_quarter`, `days_remaining_in_quarter`
#'   - `days_complete_in_year`, `days_remaining_in_year`
#'
#' **5. Miscellaneous**
#'   - `weekend_indicator` – equals 1 if Saturday or Sunday; otherwise 0
#'
#' All date-derived fields ending in `_date` are coerced to class `Date`.
#'
#' @return A tibble containing the original data along with all generated
#'   date-based attributes.
#' @keywords internal

augment_standard_calendar_tbl <- function(.data,.date){

  # create attibutes
  out <- .data |>
    dplyr::mutate(
      year_start_date=lubridate::floor_date({{.date}},unit = "year")
      ,year_end_date=lubridate::ceiling_date({{.date}},unit = "year")-1
      ,quarter_start_date=lubridate::floor_date({{.date}},unit = "quarter")
      ,quarter_end_date=lubridate::ceiling_date({{.date}},unit = "quarter")-1
      ,month_start_date=lubridate::floor_date({{.date}},unit = "month")
      ,month_end_date=lubridate::ceiling_date({{.date}},unit = "month")-1
      ,week_start_date=lubridate::floor_date({{.date}},unit = "week")
      ,week_end_date=lubridate::ceiling_date({{.date}},unit = "week")-1
      ,day_of_week=lubridate::wday({{.date}},label = FALSE)
      ,day_of_week_label=lubridate::wday({{.date}},label = TRUE)
      ,day_of_year=lubridate::day({{.date}})
      ,month_of_year_label_abb=lubridate::month({{.date}},label = TRUE,abbr = TRUE)
      ,month_of_year_label_full_name=lubridate::month({{.date}},label=TRUE,abbr = FALSE)
      ,month_of_year=lubridate::month({{.date}},label=FALSE)
      ,days_in_year=year_end_date-year_start_date
      ,days_in_quarter=quarter_end_date-quarter_start_date
      ,days_in_month=lubridate::days_in_month({{.date}})
      ,days_complete_in_week={{.date}}-week_start_date
      ,days_remaining_in_week=week_end_date-{{.date}}
      ,days_remaining_in_quarter=quarter_end_date-{{.date}}
      ,days_remaining_in_month=month_end_date-{{.date}}
      ,days_remaining_in_year=year_end_date-{{.date}}
      ,days_complete_in_year={{.date}}-year_start_date
      ,days_complete_in_quarter={{.date}}-quarter_start_date
      ,days_complete_in_month={{.date}}-month_start_date
      ,days_complete_in_year={{.date}}-year_start_date

      ,weekend_indicator=dplyr::if_else(day_of_week_label %in% c("Saturday","Sunday"),1,0)
    ) |>
    dplyr::mutate(
      dplyr::across(dplyr::contains("date"),\(x) as.Date(x))
    )

  return(out)

}



#' @title Add Comprehensive Date-Based Attributes to a DBI lazy frame
#'
#' @description
#' This function takes a data frame and a date column and generates a wide set of
#' derived date attributes. These include start/end dates for year, quarter,
#' month, and week; day-of-week indicators; completed and remaining days in each
#' time unit; and additional convenience variables such as weekend indicators.
#'
#' It is designed for time-based feature engineering and is useful in reporting,
#' forecasting, time-series modeling, and data enrichment workflows.
#'
#' @param .data A data frame or tibble containing at least one date column.
#' @param .date A column containing `Date` values, passed using tidy-eval
#'   (e.g., `{{ date_col }}`).
#'
#' @details
#' The function creates the following groups of attributes:
#'
#' **1. Start and end dates**
#'   - `year_start_date`, `year_end_date`
#'   - `quarter_start_date`, `quarter_end_date`
#'   - `month_start_date`, `month_end_date`
#'   - `week_start_date`, `week_end_date`
#'
#' **2. Day-of-week fields**
#'   - `day_of_week` – numeric day of the week (1–7)
#'   - `day_of_week_label` – ordered factor label (e.g., Mon, Tue, …)
#'
#' **3. Duration fields**
#'   - `days_in_year` – total days in the year interval
#'   - `days_in_quarter` – total days in the quarter interval
#'   - `days_in_month` – total days in the month
#'
#' **4. Completed/remaining days**
#'   - `days_complete_in_week`, `days_remaining_in_week`
#'   - `days_complete_in_month`, `days_remaining_in_month`
#'   - `days_complete_in_quarter`, `days_remaining_in_quarter`
#'   - `days_complete_in_year`, `days_remaining_in_year`
#'
#' **5. Miscellaneous**
#'   - `weekend_indicator` – equals 1 if Saturday or Sunday; otherwise 0
#'
#' All date-derived fields ending in `_date` are coerced to class `Date`.
#'
#' @return A dbi containing the original data along with all generated
#'   date-based attributes.
#' @keywords internal
augment_standard_calendar_dbi <- function(.data,.date){


  date_vec <- rlang::as_label(.date)

out <-
  .data |>
  dplyr::mutate(
    year_start_date=lubridate::floor_date({{.date}},unit = "year")
    ,year_end_date=dplyr::sql(glue::glue("date_trunc('year', {date_vec}) + INTERVAL '1' YEAR"))
    ,quarter_start_date=lubridate::floor_date({{.date}},unit = "quarter")
    ,quarter_end_date=dplyr::sql(glue::glue("date_trunc('quarter', {date_vec}) + INTERVAL '1' quarter"))
    ,month_start_date=lubridate::floor_date({{.date}},unit = "month")
    ,month_end_date=dplyr::sql(glue::glue("date_trunc('month', {date_vec}) + INTERVAL '1' month"))
    ,week_start_date=lubridate::floor_date({{.date}},unit = "week")
    ,week_end_date=dplyr::sql(glue::glue("date_trunc('month', {date_vec}) + INTERVAL '1' month"))
    ,day_of_week=lubridate::wday({{.date}},label = FALSE)
    ,day_of_week_label=lubridate::wday({{.date}},label = TRUE)
    ,day_of_year=lubridate::day({{.date}})
    ,month_of_year_label_abb=lubridate::month({{.date}},label = TRUE,abbr = TRUE)
    ,month_of_year_label_full_name=lubridate::month({{.date}},label=TRUE,abbr = FALSE)
    ,month_of_year=lubridate::month({{.date}},label=FALSE)
    ,days_in_year=year_end_date-year_start_date
    ,days_in_quarter=quarter_end_date-quarter_start_date
    ,days_in_month=dplyr::sql(glue::glue("last_day({date_vec})"))
    ,days_complete_in_week={{.date}}-week_start_date
    ,days_remaining_in_week=week_end_date-{{.date}}
    ,days_remaining_in_quarter=quarter_end_date-{{.date}}
    ,days_remaining_in_month=month_end_date-{{.date}}
    ,days_remaining_in_year=year_end_date-{{.date}}
    ,days_complete_in_year={{.date}}-year_start_date
    ,days_complete_in_quarter={{.date}}-quarter_start_date
    ,days_complete_in_month={{.date}}-month_start_date
    ,days_complete_in_year={{.date}}-year_start_date
    ,weekend_indicator=dplyr::if_else(day_of_week_label %in% c("Saturday","Sunday"),1,0)
  ) |>
 dplyr::mutate(
    dplyr::across(dplyr::contains("date"),\(x) as.Date(x))
  )

return(out)

}





#' @title Add Comprehensive Date-Based Attributes to a DBI  lazy frame or tibble object
#' @name augment_standard_calendar
#' @description
#' This function takes a data frame and a date column and generates a wide set of
#' derived date attributes. These include start/end dates for year, quarter,
#' month, and week; day-of-week indicators; completed and remaining days in each
#' time unit; and additional convenience variables such as weekend indicators.
#'
#' It is designed for time-based feature engineering and is useful in reporting,
#' forecasting, time-series modeling, and data enrichment workflows.
#'
#' @param .data A data frame or tibble containing at least one date column.
#' @param .date A column containing `Date` values, passed using tidy-eval
#'   (e.g., `{{ date_col }}`).
#'
#' @details
#' The function creates the following groups of attributes:
#'
#' **1. Start and end dates**
#'   - `year_start_date`, `year_end_date`
#'   - `quarter_start_date`, `quarter_end_date`
#'   - `month_start_date`, `month_end_date`
#'   - `week_start_date`, `week_end_date`
#'
#' **2. Day-of-week fields**
#'   - `day_of_week` – numeric day of the week (1–7)
#'   - `day_of_week_label` – ordered factor label (e.g., Mon, Tue, …)
#'
#' **3. Duration fields**
#'   - `days_in_year` – total days in the year interval
#'   - `days_in_quarter` – total days in the quarter interval
#'   - `days_in_month` – total days in the month
#'
#' **4. Completed/remaining days**
#'   - `days_complete_in_week`, `days_remaining_in_week`
#'   - `days_complete_in_month`, `days_remaining_in_month`
#'   - `days_complete_in_quarter`, `days_remaining_in_quarter`
#'   - `days_complete_in_year`, `days_remaining_in_year`
#'
#' **5. Miscellaneous**
#'   - `weekend_indicator` – equals 1 if Saturday or Sunday; otherwise 0
#'
#' All date-derived fields ending in `_date` are coerced to class `Date`.
#' @export
#' @return A dbi or  tibble containing the original data along with all generated
#'   date-based attributes.
#'
augment_standard_calendar <- function(.data,.date){

  data_class <- class(.data)

  .date_var <- rlang::enquo(.date)

  assertthat::assert_that(
    any(data_class %in% c("tbl","tbl_lazy"))
    ,msg = ".data must be regular tibble or DBI lazy object"
    )

  if(any(data_class %in% "tbl_lazy")){

    out <- augment_standard_calendar_dbi(.data = .data,.date = .date_var)

    return(out)


  }


  if(any(data_class %in% "tbl")){

    out <- augment_standard_calendar_tbl(.data = .data,.date = !!.date_var)

    return(out)
  }



}


#' Finds closet sunday to February 1st
#'
#' @param year year of the date
#'
#' @returns character vector
#' @keywords internal
closest_sunday_feb1 <- function(year) {

  # Create a Date object for February 1st of the given year
  feb1 <- as.Date(paste0(year, "-02-01"))

  # Get the day of the week (0 = Sunday, 1 = Monday, ..., 6 = Saturday)
  wday <- as.integer(format(feb1, "%w"))

  # Calculate offset to the nearest Sunday
  # If wday <= 3, the closest Sunday is before; else it's after
  offset <- ifelse(wday <= 3, -wday, 7 - wday)

  # Return the closest Sunday
  feb1 + offset
}


#' Create Non-Standard Month
#'
#' @param .data non-standard calendar table
#' @param pattern '554','545' or '445'
#'
#' @returns DBI object
#'
#' @keywords internal
create_non_standard_month <- function(.data,pattern){


  valid_colnames <- c("week_ns","year_ns")
  valid_pattern <- c("544","545","445")


  assertthat::assert_that(
    pattern %in% valid_pattern
    ,msg = cli::cli_abort("Please select {.or {.val {valid_pattern}}}")
  )


  assertthat::assert_that(
    pattern %in% valid_pattern
    ,msg = cli::cli_abort("Please ensure [.val week_ns] and [.val year_ns] are in the dataset")
  )


  if(pattern=="544"){

    valid_cumulative_months <- cumsum(rep(c(5,4,4),4))

    out <-
      .data |>
      dplyr::mutate(
        .by=year
        ,month=dplyr::case_when(
          # either framing it in advance or somehow passing a arg to it
          week<=!!valid_cumulative_months[[1]]~1
          ,week<=!!valid_cumulative_months[[2]]~2
          ,week<=!!valid_cumulative_months[[3]]~3
          ,week<=!!valid_cumulative_months[[4]]~4
          ,week<=!!valid_cumulative_months[[5]]~5
          ,week<=!!valid_cumulative_months[[6]]~6
          ,week<=!!valid_cumulative_months[[7]]~7
          ,week<=!!valid_cumulative_months[[8]]~8
          ,week<=!!valid_cumulative_months[[9]]~9
          ,week<=!!valid_cumulative_months[[10]]~10
          ,week<=!!valid_cumulative_months[[11]]~11
          ,week<=!!valid_cumulative_months[[12]]~12
          ,.default=13
        )
      )
  }

  if(pattern=="445"){

    valid_cumulative_months <- cumsum(rep(c(4,4,5),4))

    out <- .data |>
      dplyr::mutate(
        .by=year
        ,month=dplyr::case_when(
          # either framing it in advance or somehow passing a arg to it
          week<=!!valid_cumulative_months[[1]]~1
          ,week<=!!valid_cumulative_months[[2]]~2
          ,week<=!!valid_cumulative_months[[3]]~3
          ,week<=!!valid_cumulative_months[[4]]~4
          ,week<=!!valid_cumulative_months[[5]]~5
          ,week<=!!valid_cumulative_months[[6]]~6
          ,week<=!!valid_cumulative_months[[7]]~7
          ,week<=!!valid_cumulative_months[[8]]~8
          ,week<=!!valid_cumulative_months[[9]]~9
          ,week<=!!valid_cumulative_months[[10]]~10
          ,week<=!!valid_cumulative_months[[11]]~11
          ,week<=!!valid_cumulative_months[[12]]~12
          ,.default=13
        )
      )
  }


  if(pattern=="454"){

    valid_cumulative_months <- cumsum(rep(c(4,5,4),4))

    out <- .data |>
      dplyr::mutate(
        .by=year
        ,month=dplyr::case_when(
          # either framing it in advance or somehow passing a arg to it
          week<=!!valid_cumulative_months[[1]]~1
          ,week<=!!valid_cumulative_months[[2]]~2
          ,week<=!!valid_cumulative_months[[3]]~3
          ,week<=!!valid_cumulative_months[[4]]~4
          ,week<=!!valid_cumulative_months[[5]]~5
          ,week<=!!valid_cumulative_months[[6]]~6
          ,week<=!!valid_cumulative_months[[7]]~7
          ,week<=!!valid_cumulative_months[[8]]~8
          ,week<=!!valid_cumulative_months[[9]]~9
          ,week<=!!valid_cumulative_months[[10]]~10
          ,week<=!!valid_cumulative_months[[11]]~11
          ,week<=!!valid_cumulative_months[[12]]~12
          ,.default=13
        )
      )
  }

  return(out)


}




#' Augment non-standard calendar
#'
#' @param .data data
#' @param pattern 554,445 or 545
#'
#' @returns DBI object
#'
augment_non_standard_calendar <- function(.data,pattern){

  #test inputs
  # pattern <- "544"

  # assign variables
  days_in_week=7
  weeks_in_quarter=13
  quarters_in_year=4
  # start_year <- closest_sunday_feb1(min_year)


  #
  # new_cal <- seq_date_sql(start_date = start_year,end_date=x@datum@max_date,time_unit = "day",con =con ) |>
  #   augment_standard_calendar(.date = date) |>
  #   dplyr::select(date,day_of_week)

  out <-
    .data |>
    dbplyr::window_order(date) |>
    dplyr::mutate(
      year_index=dplyr::if_else(dplyr::row_number()%%(days_in_week*weeks_in_quarter*quarters_in_year)==1,1,0)
      ,year=cumsum(year_index)
    ) |>
    dplyr::mutate(
      week_index=dplyr::if_else(dplyr::row_number()%%7==1,1,0)
      ,week=cumsum(week_index)
      ,.by=year
    ) |>
    create_non_standard_month(pattern=pattern) |>
    dplyr::mutate(
      quarter=dplyr::case_when(
        month<=3~1
        ,month<=6~2
        ,month<=9~3
        ,.default=4
      )
    ) |>
    dplyr::mutate(
      day=lubridate::day(date)
    ) |>
    dplyr::select(
      date,day,week,month,quarter,year
    )

  return(out)

}


utils::globalVariables(
  c(
    "desc",
    "var",
    "cum_sum",
    "prop_total",
    "row_id",
    "max_row_id",
    "dim_category",
    "cum_prop_total",
    "cum_unit_prop",
    "dim_threshold",
    ":=",
    "out_tbl",
    "dir_path",
    "map_chr",
    "as_label",
    "n",
    "prop_n",
    "lead",
    "pull",
    "relocate",
    "select",
    "order_date",
    "quantity",
    "fn_name_lower",
    "test",
    ".cluster",
    "centers_input",
    "kmeans_models",
    "kmeans_results",
    "tot.withinss",
    "sql",
    "quarter",
    "quater",
    "date_lag",
    "month",
    "week",
    "year",
    "year_start_date",
    "year_end_date",
    "quarter_start_date",
    "quarter_end_date",
    "month_start_date",
    "month_end_date",
    "week_start_date",
    "week_end_date",
    "day_of_week_label",
    "days_in_month",
    "year_index",
    "week_index",
    "day"
  )
)

