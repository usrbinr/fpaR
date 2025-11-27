library(tidyverse)
library(contoso)
devtools::document()
devtools::load_all()

## create 5-5-4 calendar

x <-  contoso::sales |> fpaR::mtd(order_date,margin,calendar_type = "standard")




## find beginng date indicator





#  this should generate a type of calendar
#  lets start with this for now -- we need to add a 5th year rebalancing logic (eg specify which year we have an extra week)
#  lets use this for a momnth over month calculation to see how we would do that






## replicate mtd to see this would work in this system


#create claendar
## take the create_Calendar output and then siply pass then through to the augmnet_ns_calendar rather than default calendar so that I
## sot aht I don't need to recreate that

# full_dbi <-
## this should say complete_calendar



  if(x@datum@calendar_type=="standard"){
    full_dbi <- create_calendar(x) |>
      dplyr::mutate(
        year=lubridate::year(date)
        ,month=lubridate::month(date)
        ,.before = 1
      )

  }


if(x@datum@calendar_type!="standard")

  full_dbi <- create_calendar(x) |>
    augment_non_standard_calendar(pattern="544")
  )
    #this should be augment_standard_calendar


out_dbi <-
  full_dbi |>
  dbplyr::window_order(date) |>
  dplyr::mutate(
    !!x@value@new_column_name_vec:=cumsum(!!x@value@value_quo)
    ,.by=c(year,month,!!!x@datum@group_quo)
  ) |>
  dplyr::mutate(
    days_in_current_period=lubridate::day(date)
  )


return(out)
