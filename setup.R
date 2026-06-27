#!/usr/bin/env Rscript
packages <- c("rvest", "zoo", "sqldf", "ggmap", "gmapsdistance", "dplyr", "leaflet")
install.packages(packages[!packages %in% installed.packages()[,"Package"]])
