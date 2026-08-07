# Package termstrc => fitting a yield curve using the Svensson method (6 parameters)

# export to excel:
# https://stackoverflow.com/questions/19414605/export-data-from-r-to-excel

# convert a list to a dataframe
# https://stackoverflow.com/questions/4227223/convert-a-list-to-a-data-frame

# dataframe csv adjustment
# https://stackoverflow.com/questions/24829027/unimplemented-type-list-when-trying-to-write-table

# creating a govbonds-type input data list
# https://stackoverflow.com/questions/40028279/how-to-estimate-static-yield-curve-with-termstrc-package-in-r
# https://stackoverflow.com/questions/26814186/fail-to-create-couponbonds-object-in-termstrc-package-using-r
# https://quant.stackexchange.com/questions/4808/using-the-termstrc-package-in-r
# https://stackoverflow.com/questions/15915575/termstrc-datastream-import-estim-nss-dyncouponbonds

# possible to fit a yield curve from discount bond/STRIPS data => see links above

library(writexl)
library(plyr)
library(openxlsx)
library(termstrc)
library(readxl)

# import and formatting of sample bond data
bond_data = read.xlsx("bonds.xlsx")
bond_data
ISIN <- as.character(bond_data$ISIN)
typeof(ISIN)
MATURITYDATE <- as.Date(bond_data$MATURITY)
typeof(MATURITYDATE)
attributes(MATURITYDATE)
COUPONRATE = as.double(bond_data$COUPONRATE)
typeof(COUPONRATE)
# for ACTUAL, analysis-ready bond data:
# create a govbonds-type list using the guidelines from termstrc.pdf (govbonds, page 31)

# default built-in termstrc bond data
data("govbonds")
govbonds
class(govbonds)
typeof(govbonds)
attributes(govbonds)
str(govbonds$GERMANY)

# bond data properties
attributes(govbonds$GERMANY$MATURITYDATE)
typeof(govbonds$GERMANY$MATURITYDATE)
attributes(govbonds$GERMANY$ISIN)
typeof(govbonds$GERMANY$ISIN)
attributes(govbonds$GERMANY$COUPONRATE)
typeof(govbonds$GERMANY$COUPONRATE)

# source: https://github.com/datarob/termstrc/blob/master/R/estim_nss_couponbonds.R

# BEWARE: long processing time
sve = estim_nss.couponbonds(govbonds, c("GERMANY"), matrange = c(0,30), method = "sv", 
                            startparam = NULL, tauconstr = NULL,
                            # tauconstr consistent with the historical US Fed tau parameters range
                            # source: https://www.federalreserve.gov/data/yield-curve-tables/feds200628_1.html
                            constrOptimOptions = list(control = list(maxit = 2000), outer.iterations = 500, outer.eps = 1e-04))

# startparam set to NULL => optimal parameters searched automatically
# tauconstr set to NULL => determined based on the input data
# constrOptimOptions => default number of iterations


class(sve$spsearch$GERMANY)

# initial parameters search algorithm
sve$spsearch$GERMANY
sve$spsearch$GERMANY$optind

parameters = sve$opt_result$GERMANY$par # optimal parameters
typeof(parameters)
sve$startparam # inital parameters

# source code: https://github.com/datarob/termstrc/tree/master/R

sve$m$GERMANY # maturities (Act/Act daycount convention)
sve$duration$GERMANY # duration, MD, weights (inverse duration)
sve$p # actual dirty prices
sve$phat # prices estimated using the optimal parameters (opt_result)
sve$y # yields derived from actual dirty prices (continuous compounding)
sve$yhat # yields derived from estimated dirty prices
# average absolute yield errors => function aabse (termstrc.pdf, page 5)
# weighted squared price errors => function loss_function (termstrc.pdf, page 40)

# export to excel
# Svensson spot rate formula for parameters is provided in the companion paper
# journal_of_statistical_software.pdf (page 7)
parameters
parameters_df = data.frame(parameter = names(parameters),
                           value     = as.numeric(parameters),
                           row.names = NULL)
parameters_df
write_xlsx(parameters_df, path = "parameters.xlsx")