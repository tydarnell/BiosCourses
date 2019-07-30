library(tidyverse)

args =commandArgs(trailingOnly=True)

#match with collaborators
matched <- read_csv(args[1])








write.csv(top_collabs, file='top10.csv', row.names = FALSE)
