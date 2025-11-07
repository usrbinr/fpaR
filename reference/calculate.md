# Calculate

Calculate

Calculate

## Arguments

- x:

  segment object

## Value

dbi object

dbi object

## Examples

``` r
if (FALSE) { # \dontrun{
x <- ytd(sales,.date=order_date,.value=quantity,calendar_type="standard")
calculate(x)
} # }
if (FALSE) { # \dontrun{
sales |>
    group_by(store_key) |>
    abc(category_values = c(.3,.5,.75,.85)) |>
    calculate()
} # }
```
