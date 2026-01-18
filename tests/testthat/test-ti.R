library(testthat)
library(dplyr)
library(lubridate)

# We skip these tests if 'contoso' isn't available, preventing errors on systems without the data
skip_if_not_installed("contoso")

describe("Year-related functions (YTD)", {

  it("calculates YTD margin with standard calendar (grouped)", {
    result <- contoso::sales |>
      group_by(store_key) |>
      ytd(order_date, margin, "standard") |>
      calculate() |>
      collect()

    expect_s3_class(result, "data.frame")
    expect_true("ytd_margin" %in% names(result))
    expect_gt(nrow(result), 0)
  })

  it("calculates YTD margin with 445 calendar (grouped by customer)", {
    result <- contoso::sales |>
      group_by(customer_key) |>
      ytd(order_date, margin, "445") |>
      calculate() |>
      collect() # Added collect() to ensure we get data back

    expect_true("ytd_margin" %in% names(result))
    expect_gt(nrow(result), 0)
  })
})

describe("Quarter, Month, Week to Date (QTD, MTD, WTD)", {

  it("calculates QTD, MTD, WTD correctly", {
    # QTD Standard
    res_qtd <- contoso::sales |>
      qtd(order_date, margin, "standard") |>
      calculate() |>
      collect()
    expect_true("qtd_margin" %in% names(res_qtd))

    # MTD 445
    res_mtd <- contoso::sales |>
      mtd(order_date, margin, "445") |>
      calculate() |>
      collect()
    expect_true("mtd_margin" %in% names(res_mtd))

    # WTD Standard
    res_wtd <- contoso::sales |>
      wtd(order_date, margin, "standard") |>
      calculate() |>
      collect()
    expect_true("wtd_margin" %in% names(res_wtd))
  })

  it("calculates ATD (All-to-date)", {
    result <- contoso::sales |>
      group_by(store_key) |>
      atd(order_date, margin, "445") |>
      calculate() |>
      collect()

    expect_true("atd_margin" %in% names(result))
  })
})

describe("Period Over Period (YOY, QOQ, MOM, WOW, DOD)", {

  it("calculates YOY margin and filters specific store", {
    result <- contoso::sales |>
      group_by(store_key) |>
      yoy(order_date, margin, "standard", 1) |>
      calculate() |>
      collect() |> # Collect before filtering in R if strictly checking logic, or keep lazy if supported
      filter(store_key == "999999")

    expect_true("yoy_margin" %in% names(result))
  })

  it("calculates QOQ, MOM, WOW, DOD", {
    # QOQ
    res_qoq <- contoso::sales |> qoq(order_date, margin, "standard") |> calculate() |> collect()
    expect_true("qoq_margin" %in% names(res_qoq))

    # MOM
    res_mom <- contoso::sales |> mom(order_date, margin, "445") |> calculate() |> collect()
    expect_true("mom_margin" %in% names(res_mom))

    # WOW
    res_wow <- contoso::sales |> wow(order_date, margin, "standard") |> calculate() |> collect()
    expect_true("wow_margin" %in% names(res_wow))

    # DOD
    res_dod <- contoso::sales |> dod(order_date, margin, "standard") |> calculate() |> collect()
    expect_true("dod_margin" %in% names(res_dod))
  })
})

describe("Prior Period to Current YTD/QTD/MTD", {

  it("calculates YOYTD (Year Over Year To Date)", {
    result <- contoso::sales |>
      fpaR::yoytd(order_date, margin, "standard", 1) |>
      calculate() |>
      collect()

    expect_true("pytd_margin" %in% names(result)) # Based on your filter snippet
    expect_true("ytd_margin" %in% names(result))
  })

  it("calculates QOQTD and MOMTD", {
    # QOQTD
    res_qoqtd <- contoso::sales |> fpaR::qoqtd(order_date, margin, "standard", 1) |> calculate() |> collect()
    expect_true("pqtd_margin" %in% names(res_qoqtd))

    # MOMTD
    res_momtd <- contoso::sales |> fpaR::momtd(order_date, margin, "standard", 1) |> calculate() |> collect()
    expect_true("pmtd_margin" %in% names(res_momtd))
  })

  it("calculates WOWTD", {
    result <- contoso::sales |>
      fpaR::wowtd(order_date, margin, calendar_type = "standard", lag_n = 1) |>
      calculate() |>
      collect()

    expect_s3_class(result, "data.frame")
  })
})

describe("Prior To Date Functions (PYTD, PQTD, PMTD, PWTD)", {

  it("calculates pure Prior YTD/QTD/MTD/WTD columns", {
    # PYTD
    res_pytd <- contoso::sales |> fpaR::pytd(order_date, margin, "standard", 1) |> calculate() |> collect()
    expect_true("pytd_margin" %in% names(res_pytd))

    # PQTD
    res_pqtd <- contoso::sales |> fpaR::pqtd(order_date, margin, "standard", 1) |> calculate() |> collect()
    expect_true("pqtd_margin" %in% names(res_pqtd))

    # PWTD
    res_pwtd <- contoso::sales |> fpaR::pwtd(order_date, margin, "standard", 1) |> calculate() |> collect()
    expect_true("pwtd_margin" %in% names(res_pwtd))
  })
})

describe("Complex Comparisons (YTDOPY, MTDOPM, etc)", {

  it("calculates YTD over Prior Year", {
    result <- contoso::sales |>
      fpaR::ytdopy(order_date, margin, calendar_type="standard", lag_n = 1) |>
      calculate() |>
      collect()

    expect_true("yoy_margin" %in% names(result))
  })

  it("calculates MTD over Prior Month", {
    result <- contoso::sales |>
      fpaR::mtdopm(order_date, margin, calendar_type="standard", lag_n = 1) |>
      calculate() |>
      collect()

    expect_true("mom_margin" %in% names(result))
  })
})

describe("Special Functions (ABC, Cohort)", {

  it("performs ABC analysis", {
    result <- contoso::sales |>
      group_by(store_key) |>
      fpaR::abc(category_values = c(.3,.5,.7,.8), .value = margin) |>
      calculate() |>
      collect()

    # Typically ABC adds a category/class column, check for that or the value
    expect_gt(nrow(result), 0)
  })

  it("performs Cohort analysis", {
    result <- contoso::sales |>
      group_by(store_key) |>
      fpaR::cohort(.date = order_date, .value = margin, time_unit = "month", period_label = FALSE) |>
      calculate() |>
      collect()

    expect_gt(nrow(result), 0)
  })
})
