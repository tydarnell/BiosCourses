library(tidyverse)
library(magrittr)
library(knitr)
library(ggrepel)

stats <- read_csv("stats.txt",col_names = T,skip=1)
ratings <- read_csv("ratings.txt",col_names = T,skip=1)

