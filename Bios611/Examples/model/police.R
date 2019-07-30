library(tidyverse)
library(reshape2)

police=read_csv("https://raw.githubusercontent.com/fivethirtyeight/data/master/police-locals/police-locals.csv")

police_df = police %>%
  melt(id=c('city', 'police_force_size')) %>%
  mutate(fraction=as.numeric(value))

ggplot(data=police_df,aes(y=fraction,x=police_force_size,group=variable))+
  geom_point(aes(color=variable))+
  geom_smooth(aes(color=variable),method=lm,se=F)+facet_wrap(~variable)

model=lm(fraction~police_force_size*variable,police_df)

predictions = police_df %>%
  data_grid(police_force_size, variable) %>%
  gather_predictions(model)