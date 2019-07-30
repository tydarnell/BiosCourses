library(tidyverse)
library(data.table)

police_csv <- read_csv("~/Bios611/import data/police-locals.csv",na="**")

police_delim <- read_delim("~/Bios611/import data/police-locals.csv",delim = ",",na="**")

police_fread <- fread("~/Bios611/import data/police-locals.csv",na="**")