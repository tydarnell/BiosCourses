library(tidyverse)
library(nycflights13)

flights%>%
  group_by(year,month,day)%>%
  summarise(mean=mean(dep_delay,na.rm=T))

(not_cancelled <- flights %>%
  filter(!is.na(dep_delay), !is.na(arr_delay)))

delays <- not_cancelled %>% group_by(tailnum)%>%
  summarise(
    delay=mean(arr_delay)
  )

ggplot(data=delays,aes(x=delay))+geom_freqpoly(binwidth=10)

not_cancelled %>%
  group_by(year,month,day)%>%
  summarise(avg_delay1=mean(arr_delay),
            avg_delay2=mean(arr_delay[arr_delay>0]))

daily <- group_by(flights,year,month,day)
(per_day <- summarise(daily,flights=n()))

(per_month <- summarise(per_day,flights=sum(flights)))

(per_year <- summarise(per_month,flights=sum(flights
                                             )))
delay_info <-
  flights %>%
  group_by(flight) %>%
  summarise(n = n(),
            fifteen_early = mean(arr_delay == -15, na.rm = T),
            fifteen_late = mean(arr_delay == 15, na.rm = T),
            ten_always = mean(arr_delay == 10, na.rm = T),
            thirty_early = mean(arr_delay == -30, na.rm = T),
            thirty_late = mean(arr_delay == 30, na.rm = T),
            percentage_on_time = mean(arr_delay == 0, na.rm = T),
            twohours = mean(arr_delay > 120, na.rm = T))



