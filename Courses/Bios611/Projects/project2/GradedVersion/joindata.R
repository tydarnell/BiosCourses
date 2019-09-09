bball <- left_join(stats,ratings)
bball %<>% rename(wl=`W-L%`,fg=`FG%`,threes=`3P%`,ft=`FT%`)%>%
  arrange(desc(SRS))