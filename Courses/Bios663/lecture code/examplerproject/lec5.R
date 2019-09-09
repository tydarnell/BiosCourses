library(tidyverse)
library(readxl)
library(pracma)
library(matlib)
library(knitr)
library(data.table)

ozone=fread("ozone.txt")
n=nrow(ozone)
x=model.matrix(~outdoor+home+time_out,data=ozone)
y=ozone$personal
bhat=solve(t(x)%*%x)%*%t(x)%*%y
