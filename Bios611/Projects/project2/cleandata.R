ratings %<>% select(-one_of('Rk','X4','X10','X12'))
stats %<>% select(-one_of('Rk','X17'))
stats%<>% mutate(ncaa=factor(str_detect(School,"NCAA")*1))
stats %<>% mutate(School=str_trim(str_replace(stats$School,"NCAA", ""),side="right"))