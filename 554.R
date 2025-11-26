library(tidyverse)
library(contoso)
devtools::load_all()

## create 5-5-4 calendar

x <-  contoso::sales |> fpaR::mtd(order_date,revenue,calendar_type = "standard")


con <- dbplyr::remote_con(x@datum@data)


## find beginng date indicator

min_year <- year(x@datum@min_date)

start_year <- closest_sunday_feb1(min_year)

new_cal <- fpaR:::seq_date_sql(start_date = start_year,end_date=x@datum@max_date,time_unit = "day",con =con ) |>
  augment_calendar(.date = date)

#  this should generate a type of calendar
# need to validate year logic -- I am getting 53 weeks all the time



pattern <- "544"


days_in_week=7
weeks_in_quarter=13
quarters_in_year=4

# out <-
  new_cal |>
  dbplyr::window_order(date) |>
  select(date,day_of_week) |>
  dplyr::mutate(
      year_index=dplyr::if_else(dplyr::row_number()%%(days_in_week*weeks_in_quarter*quarters_in_year)==1,1,0)
      ,year_ns=cumsum(year_index)
  ) |>
  dplyr::mutate(
    week_index=dplyr::if_else(dplyr::row_number()%%7==1,1,0)
    ,week_ns=cumsum(week_index)
    ,.by=year_ns
  ) |>
  create_ns_month(pattern=pattern) |>
  dplyr::mutate(
    quarter_ns=dplyr::case_when(
      month_ns<=3~1
      ,month_ns<=6~2
      ,month_ns<=9~3
      ,.default=4
    )
  ) |> collect() |> arrange(date)



out |> collect() |> arrange(date)



