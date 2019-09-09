library(caret)
library(tidyverse)

#data
dat.raw <- read.csv("lab10data.csv",stringsAsFactors = T)
dim(dat.raw)
sum(complete.cases(dat.raw))

preProcValues <- preProcess(dat.raw, method = c("knnImpute","center","scale"))
dat <- predict(preProcValues, dat.raw)
dim(dat)
sum(complete.cases(dat))

