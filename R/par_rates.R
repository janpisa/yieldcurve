# package yieldcurves
# source: https://cran.r-project.org/web/packages/yieldcurves/refman/yieldcurves.html#yc_zero_to_par

# zero-coupon yield conversion to par rates

library(yieldcurves)
library(readxl)
library(writexl)

# import zero-coupon yields (annual/semi-annual compounding based on the "frequency" argument)
# source: https://github.com/charlescoverdale/yieldcurves/blob/main/R/conversions.R

zeros = read.xlsx("zero_to_par.xlsx")
zeros

maturities = as.double(zeros$maturity)
maturities
zero_rates = as.double(zeros$zero)
zero_rates

# annually compounded par rates (Czech bonds)
par_rate = yc_zero_to_par(maturities, zero_rates, frequency = 1)
par_rate
typeof(par_rate)

# convert a list to a dataframe
par_df = data.frame(par_rate, row.names = NULL)
par_df
# export par rates to excel
write_xlsx(par_df, path = "par_rates.xlsx")

# function yc_svensson
# shortcut version for fitting a Svensson zero-coupon yield curve 
# compatible with observed zero-coupon yields (from STRIPS)
# CAUTION: check the compounding convention of the input zero yields

# function yc_zspread
# shortcut option for the calculation of a Z-Spread over a benchmark curve
# CAUTION: daycount convention