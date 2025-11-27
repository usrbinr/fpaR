library(tidyverse)
library(contoso)
devtools::document()
devtools::load_all()

## create 5-5-4 calendar

x <-  contoso::sales |> fpaR::mtd(order_date,margin,calendar_type = "445")




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



## changes to complete claendar-------------------


## summarize data table
summary_dbi <- x@datum@data |>
  dplyr::ungroup() |>
  make_db_tbl() |>
  dplyr::mutate(
    date = lubridate::floor_date(!!x@datum@date_quo,unit = !!x@time_unit@value)
    ,time_unit=!!x@time_unit@value
  ) |>
  dplyr::summarise(
    !!x@value@value_vec:= sum(!!x@value@value_quo,na.rm=TRUE)
    ,.by=c(date,!!!x@datum@group_quo)
  )

#create calendar table
if(x@datum@calendar_type=="standard"){


  calendar_dbi <- seq_date_sql(start_date = x@datum@min_date,end_date = x@datum@max_date,time_unit = x@time_unit@value,con=dbplyr::remote_con(x@datum@data))

}else{

  calendar_dbi <- seq_date_sql(start_date = start_date,end_date = x@datum@max_date,time_unit = x@time_unit@value,con=dbplyr::remote_con(x@datum@data))

}



# Expand calendar table with cross join of groups
if(x@datum@group_indicator){

  calendar_dbi <- calendar_dbi |>
    dplyr::cross_join(
      summary_dbi |>
        dplyr::distinct(!!!x@datum@group_quo)
    )
  # dplyr::mutate(
  #   missing_date_indicator=dplyr::if_else(is.na(!!x@value@value_quo),1,0)
  #   ,!!x@value@value_vec:= dplyr::coalesce(!!x@value@value_quo, 0)
  # )

}

# Perform a full join to ensure all time frames are represented
full_dbi <- dplyr::full_join(
  calendar_dbi
  ,summary_dbi
  ,by = dplyr::join_by(date,!!!x@datum@group_quo)
) |>
  dplyr::mutate(
    missing_date_indicator=dplyr::if_else(is.na(!!x@value@value_quo),1,0)
    ,!!x@value@value_vec:= dplyr::coalesce(!!x@value@value_quo, 0)
  )
