library(testthat)
library(dplyr)
library(lubridate)

library(testthat)
library(dplyr)

library(testthat)
library(dplyr)

library(testthat)
library(dplyr)

# -------------------------------------------------------------------------
# SETUP
# -------------------------------------------------------------------------
df_test <- contoso::sales |> head(500) |> collect()

describe("Time Intelligence Manual Execution Tests", {

  # --- Year Related ---

  it("ytd returns a non-empty tibble", {
    result <- df_test |> group_by(store_key) |>
      ytd(order_date, margin, calendar_type = "standard") |>
      calculate() |> collect()
    expect_s3_class(result, "data.frame")
    expect_gt(nrow(result), 0)
  })

  it("pytd returns a non-empty tibble", {
    result <- df_test |> group_by(store_key) |>
      pytd(order_date, margin, calendar_type = "standard", lag_n = 1) |>
      calculate() |> collect()
    expect_s3_class(result, "data.frame")
    expect_gt(nrow(result), 0)
  })

  it("yoytd returns a non-empty tibble", {
    result <- df_test |> group_by(store_key) |>
      yoytd(order_date, margin, calendar_type = "standard", lag_n = 1) |>
      calculate() |> collect()
    expect_s3_class(result, "data.frame")
    expect_gt(nrow(result), 0)
  })

  it("yoy returns a non-empty tibble", {
    result <- df_test |> group_by(store_key) |>
      yoy(order_date, margin, calendar_type = "standard", lag_n = 1) |>
      calculate() |> collect()
    expect_s3_class(result, "data.frame")
    expect_gt(nrow(result), 0)
  })

  it("ytdopy returns a non-empty tibble", {
    result <- df_test |> group_by(store_key) |>
      ytdopy(order_date, margin, calendar_type = "standard", lag_n = 1) |>
      calculate() |> collect()
    expect_s3_class(result, "data.frame")
    expect_gt(nrow(result), 0)
  })

  # --- Quarter Related ---

  it("qtd returns a non-empty tibble", {
    result <- df_test |> group_by(store_key) |>
      qtd(order_date, margin, calendar_type = "standard") |>
      calculate() |> collect()
    expect_s3_class(result, "data.frame")
    expect_gt(nrow(result), 0)
  })

  it("pqtd returns a non-empty tibble", {
    result <- df_test |> group_by(store_key) |>
      pqtd(order_date, margin, calendar_type = "standard", lag_n = 1) |>
      calculate() |> collect()
    expect_s3_class(result, "data.frame")
    expect_gt(nrow(result), 0)
  })

  it("qoqtd returns a non-empty tibble", {
    result <- df_test |> group_by(store_key) |>
      qoqtd(order_date, margin, calendar_type = "standard", lag_n = 1) |>
      calculate() |> collect()
    expect_s3_class(result, "data.frame")
    expect_gt(nrow(result), 0)
  })

  it("qoq returns a non-empty tibble", {
    result <- df_test |> group_by(store_key) |>
      qoq(order_date, margin, calendar_type = "standard", lag_n = 1) |>
      calculate() |> collect()
    expect_s3_class(result, "data.frame")
    expect_gt(nrow(result), 0)
  })

  it("qtdopq returns a non-empty tibble", {
    result <- df_test |> group_by(store_key) |>
      qtdopq(order_date, margin, calendar_type = "standard", lag_n = 1) |>
      calculate() |> collect()
    expect_s3_class(result, "data.frame")
    expect_gt(nrow(result), 0)
  })

  # --- Month Related ---

  it("mtd returns a non-empty tibble", {
    result <- df_test |> group_by(store_key) |>
      mtd(order_date, margin, calendar_type = "standard") |>
      calculate() |> collect()
    expect_s3_class(result, "data.frame")
    expect_gt(nrow(result), 0)
  })

  it("pmtd returns a non-empty tibble", {
    result <- df_test |> group_by(store_key) |>
      pmtd(order_date, margin, calendar_type = "standard", lag_n = 1) |>
      calculate() |> collect()
    expect_s3_class(result, "data.frame")
    expect_gt(nrow(result), 0)
  })

  it("momtd returns a non-empty tibble", {
    result <- df_test |> group_by(store_key) |>
      momtd(order_date, margin, calendar_type = "standard", lag_n = 1) |>
      calculate() |> collect()
    expect_s3_class(result, "data.frame")
    expect_gt(nrow(result), 0)
  })

  it("mom returns a non-empty tibble", {
    result <- df_test |> group_by(store_key) |>
      mom(order_date, margin, calendar_type = "standard", lag_n = 1) |>
      calculate() |> collect()
    expect_s3_class(result, "data.frame")
    expect_gt(nrow(result), 0)
  })

  it("mtdopm returns a non-empty tibble", {
    result <- df_test |> group_by(store_key) |>
      mtdopm(order_date, margin, calendar_type = "standard", lag_n = 1) |>
      calculate() |> collect()
    expect_s3_class(result, "data.frame")
    expect_gt(nrow(result), 0)
  })

  # --- Week Related ---

  it("wtd returns a non-empty tibble", {
    result <- df_test |> group_by(store_key) |>
      wtd(order_date, margin, calendar_type = "standard") |>
      calculate() |> collect()
    expect_s3_class(result, "data.frame")
    expect_gt(nrow(result), 0)
  })

  it("pwtd returns a non-empty tibble", {
    result <- df_test |> group_by(store_key) |>
      pwtd(order_date, margin, calendar_type = "standard", lag_n = 1) |>
      calculate() |> collect()
    expect_s3_class(result, "data.frame")
    expect_gt(nrow(result), 0)
  })

  it("wowtd returns a non-empty tibble", {
    result <- df_test |> group_by(store_key) |>
      wowtd(order_date, margin, calendar_type = "standard", lag_n = 1) |>
      calculate() |> collect()
    expect_s3_class(result, "data.frame")
    expect_gt(nrow(result), 0)
  })

  it("wow returns a non-empty tibble", {
    result <- df_test |> group_by(store_key) |>
      wow(order_date, margin, calendar_type = "standard", lag_n = 1) |>
      calculate() |> collect()
    expect_s3_class(result, "data.frame")
    expect_gt(nrow(result), 0)
  })

  it("wtdopw returns a non-empty tibble", {
    result <- df_test |> group_by(store_key) |>
      wtdopw(order_date, margin, calendar_type = "standard", lag_n = 1) |>
      calculate() |> collect()
    expect_s3_class(result, "data.frame")
    expect_gt(nrow(result), 0)
  })

  # --- All/Day Related ---

  it("atd returns a non-empty tibble", {
    result <- df_test |> group_by(store_key) |>
      atd(order_date, margin, calendar_type = "standard") |>
      calculate() |> collect()
    expect_s3_class(result, "data.frame")
    expect_gt(nrow(result), 0)
  })

  it("dod returns a non-empty tibble", {
    result <- df_test |> group_by(store_key) |>
      dod(order_date, margin, calendar_type = "standard", lag_n = 1) |>
      calculate() |> collect()
    expect_s3_class(result, "data.frame")
    expect_gt(nrow(result), 0)
  })

})
