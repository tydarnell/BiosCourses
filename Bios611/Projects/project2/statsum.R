statsum <- bball%>%group_by(ncaa)%>%
  summarise(mean_to=mean(TOV),mean_wl=mean(wl)*100,mean_sos=mean(SOS),
            mean_3s=mean(threes)*100,mean_fg=mean(fg)*100,mean_ft=mean(ft)*100,
            mean_SRS=mean(SRS))

Not_in_tourney <- bball%>%filter(ncaa==0)
In_tourney <- bball%>%filter(ncaa==1)
first10out=bball%>% filter(ncaa==0)%>%top_n(SRS,n=10)%>%select(School,SRS,SOS,wl,Conf)

tourney_conf=bball%>%filter(ncaa==1)%>%
  group_by(Conf)%>%summarise(count=n())%>%arrange(desc(count))

conferences=top_n(tourney_conf,5)

not.mean=Not_in_tourney %>% select(TOV,wl,SOS,threes,fg,ft,SRS)
colnames(not.mean)= c("Turnovers", "Win-Loss %","SOS","3 Point %","Field Goal %","Free Throw %", "SRS")

in.mean=In_tourney %>% select(TOV,wl,SOS,threes,fg,ft,SRS)
colnames(in.mean)= c("Turnovers", "Win-Loss %","SOS","3 Point %","Field Goal %","Free Throw %", "SRS")