library(tidyverse)
library(knitr)

etable=function(exposure,disease){
  t=table(exposure,disease)[2:1,2:1]
  rownames(t)=c('E+','E-')
  colnames(t)=c('D+','D-')
  kable(t)
}