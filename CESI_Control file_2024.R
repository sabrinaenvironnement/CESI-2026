#######################################################################
#
#    -###- CANADIAN ENVIRONMENTAL SUSTAINABILITY INDICATORS -###-
#              -- Water Quantity Indicator Calculator --
#
#  This project contains scripts used to automate the calculation
#          of CESI water quantity indicator
#
#  Environment and Climate Change Canada
#  Created: March 2024
#  Updated: April 2024
#
#######################################################################


# Assuming hydat database has been downloaded and is available. If not, run:
download_hydat()

### STEP 1 - Download all the library and packages in common for all files

# load necessary libraries, the order in which you import them is important not
# to mask certain functions (specifically select from dplyr)
library(readxl)    # for importing excel file
library(tidyhydat) # for interacting with hydat database
library(tidyverse) # to merge dataframes
library(zoo)       # For working with time series
library(evir)      # For POT
library(lfstat)    # for fitting curves to low flow statistics ************
library(purrr)     # function 'possibly' is easiest way to deal with errors
library(zyp)       # for function in Mann-Kendall test      **************
library(MASS)      # for function in Negative Binomial & hurdle tests
library(countreg)  # for hurdle test
#If countreg does not work, run the three codes below before rerunning it:
#     install.packages("devtools")
#     devtools::install_github("r-forge/countreg/pkg")
#     library(pscl)

library(trend)     # for wald-wolfowitz stationarity test
library(EnvStats)  # for outlier test
library(sf)        # to create spatial objects
library(terra)     # to work with raster data
library(corrplot)  # for colourbar legend
library(automap)   # to model variogram
library(gstat)     # for Kriging
library(tidyverse) # to merge dataframes, includes library dplyr
library(png)       # to create image

#if needed:
library(lmom)
library(lattice)

### STEP 3 - Reference to all the CESI file needed for this project
source('./R/CESI data sorting functions.R')
source('./R/CESI indicator functions.R')
source('./R/CESI trend functions.R')
source('./R/CESI mapping functions.R')

### STEP 2 - Define variables
##once it is all working, set up the control file with all the data that has dates 
given_year <- 2021
map.year <- given_year #year for water quantity at monitoring stations map
yrs.of.ref <- c((given_year-30):(given_year-1))   #30-year reference period from 1991-2020 if given year is 2021
yrs.for.class <- c((given_year-21):(given_year)) #years in which to classify yield 2000-2021
yrs.for.trend <- c((1970:given_year)) #period for calculating trends
RHBN <- filter(RHBN, Evaluation_Year==2020, DATA_TYPE=="Q")
yrs.of.int <- c(1970:given_year) #period of interest

#variables used in étiage/drought script
n.day <- 7  #number of days for rolling average
return.freq <- 5 #return frequency in years for n.day average
perc <- 0.9 #percentile for threshold dry spell duration
summer.beg <- "05-01" #first day of summer period
summer.end <- "10-01" #last day of summer period


#variables used in rendement/trend
smallest.min <- min(min(yrs.of.ref), map.year, min(yrs.for.class),min(yrs.for.trend))
biggest.max <- max(max(yrs.of.ref), map.year, max(yrs.for.class),max(yrs.for.trend))
yrs.range <- c(smallest.min:biggest.max)
time <-  365*24*3600 #number of seconds in a year
thres.high <- 0.85
thres.low <- 0.15

#Import list of RHBN stations
# Three options for creating hydrometric station list for calculations. Only RHBN stations are used.
# 1-simplest command which should work if hydat was up to date
# stations<- hy_stations() %>% filter(RHBN)  %>% select(STATION_NUMBER)
# 2-also simple but creates dependency
# stations <- read.csv("./Dependencies/RHBN_U.csv", header = TRUE)
# 3-a bit more complex, but with no dependency
url <- "https://collaboration.cmc.ec.gc.ca/cmc/hydrometrics/www/RHBN/RHBN_Metadata.xlsx"
destfile <- "./Output/RHBN_Metadata.xlsx"
download.file(url, destfile, method = "curl")
stations <- read_xlsx(destfile, range="A3:P1286")
stations <- stations[-(1),]
stations <- filter(stations, Evaluation_Year==(given_year-1), DATA_TYPE=="Q")


### STEP 4 - Run the CESI scripts for all the data production
source('./R/CESI crue.R')
source('./R/CESI étiage.R')
source('./R/CESI rendement.R')

#the last script will run with the data produced from the previous scripts, make sure it is working.
source('./R/CESI statistiques.R')






