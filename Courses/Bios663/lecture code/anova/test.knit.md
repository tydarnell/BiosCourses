---
title: "test"
author: "Ty Darnell"
date: "April 8, 2019"
output:
  tufte::tufte_handout: default
  tufte::tufte_html: default

---




```r
library(tidyverse)
library(data.table)
library(knitr)
```


```r
noise=fread("NOISESIZETYPESIDE.csv")
tf= function(x){
  factor(as.numeric(x))
}
```


```r
noise$SIZE=factor(noise$SIZE)
noise$TYPE=factor(noise$TYPE)
noise$SIDE=factor(noise$SIDE)
```


```r
noise1=noise%>%mutate(s1=tf(SIZE==1),s2=tf(SIZE==2),s1t1=tf(SIZE==1 & TYPE==1),s2t1=tf(SIZE==2 & TYPE==1))
```

$\bm{x}$

$\ta$