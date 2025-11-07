#'
#'
#'
#' complete_calendar <- function(x){
#'
#'
#'   #validate date column
#'   column_names <- colnames(x)
#'
#'
#'   assertthat::assert_that(
#'     any(column_names %in% "date"),msg = cli::format_error("Please the rename the date column to {.field date}")
#'   )
#'
#'
#'   # summaryize calendar date
#'   calendar_tbl<- x |>
#'     count(date) |>
#'     select(-n)
#'
#'   # create attibutes
#'   out <- calendar_dbi |>
#'     dplyr::mutate(
#'       year_start_date=lubridate::floor_date(date,unit = "year")
#'       ,year_end_date=lubridate::ceiling_date(date,unit = "year")-1
#'       ,quarter_start_date=lubridate::floor_date(date,unit = "quarter")
#'       ,quarter_end_date=lubridate::ceiling_date(date,unit = "quarter")-1
#'       ,month_start_date=lubridate::floor_date(date,unit = "month")
#'       ,month_end_date=lubridate::ceiling_date(date,unit = "month")-1
#'       ,week_start_date=lubridate::floor_date(date,unit = "week")
#'       ,week_end_date=lubridate::ceiling_date(date,unit = "week")-1
#'       ,day_of_week=lubridate::wday(date,label = FALSE)
#'       ,day_of_week_label=lubridate::wday(date,label = TRUE)
#'       ,days_in_year=year_end_date-year_start_date
#'       ,days_in_quarter=quarter_end_date-quarter_start_date
#'       ,days_in_month=days_in_month(date)
#'       ,days_complete_in_week=date-week_start_date
#'       ,days_remaining_in_week=week_end_date-date
#'       ,days_remaining_in_quarter=quarter_end_date-date
#'       ,days_remaining_in_month=month_end_date-date
#'       ,days_remaining_in_year=year_end_date-date
#'       ,days_complete_in_year=date-year_start_date
#'       ,days_complete_in_quarter=date-quarter_start_date
#'       ,days_complete_in_month=date-month_start_date
#'       ,days_complete_in_year=date-year_start_date
#'       ,weekend_indicator=if_else(day_of_week_label %in% c("Saturday","Sunday"),1,0)
#'     ) |>
#'     mutate(
#'       across(contains("date"),\(x) as.Date(x))
#'     )
#'
#'   return(out)
#'
#' }
