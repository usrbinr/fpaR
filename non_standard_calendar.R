

devtools::load_all()

x <- mom(sales,order_date,revenue,"standard",lag_n=1)


x |> complete_calendar()

pacman::p_load(tidyverse,contoso,fpaR,rlang,devtools,usethis)

## need to figureo ou thow to cumsum of quarters so that I can the sequentenalil quarter

options(tibble.print_min=150)
options(tibble.print_max = 250)

getOption("tibble.print_min")
create_non_standard_calendar <- function(start_date,end_date,days_in_week,weeks_in_quarter,quarters_in_year,pattern,irregular_years){

  start_date="2021-01-01"
  end_date="2022-01-01"
  days_in_week=7
  wday_start=6
  weeks_in_quarter=13
  quarters_in_year=4
  pattern="5-5-4"
  irregular_years=NA


date_tbl <- tibble(
  date=seq.Date(from=start_date,to = end_date)
)

out <- date_tbl |>
  mutate(
    date_id=row_number()
  ) |>
  mutate(
    week=cumsum(if_else(date_id %% days_in_week==0,1,0))
    ,quarter=if_else(week %%weeks_in_quarter==0,1,0)
  ) |>
  mutate(
    new_quarter_indicator=if_else(quarter==1&min(date_id)==date_id,1,0)
    ,.by=quarter
  )

return(out)

}

library(tidyverse)

create_non_standard_calendar() |> print(n=100)
