library(stringr)
library(tidyverse)

sp_cw = read_lines(url("http://www.gutenberg.org/files/100/100-0.txt"))

sum(str_count(sp_cw,"\\bthee\\b"))

word_b4_thee=regex("(\\S+)\\s\\bthee\\b",ignore_case=T)

top10=sp_cw[str_detect(sp_cw,word_b4_thee)]%>%
  str_extract(pattern=word_b4_thee)%>%
  str_split(pattern=boundary("word"),simplify = T)%>%
  .[,1]%>% tibble()%>% table() %>%
  sort(decreasing=T)%>%
  head(10)