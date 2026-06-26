#!/usr/bin/env Rscript
packages <- c("corrplot", "lubridate", "naniar", "rpart.plot", "stringr", "tidymodels", "vip")
install.packages(packages[!packages %in% installed.packages()[,"Package"]])
