plot1 <- ggplot(bball,aes(x=SOS,y=wl,color=ncaa))+
  facet_wrap(~ncaa)+theme(strip.text.x = element_blank())+geom_point()+
  geom_smooth(method='lm',se=F)+ labs(
    title="Win Loss Percentage against Strength of Schedule",
    x = "Strength of Schedule",
    y = "Win Loss Percentage",
    color = "Tournament Berth")+ 
  scale_color_manual(labels = c("No","Yes"), values = c("red","blue"))

plot2 <- ggplot(bball,aes(y=SRS,color=ncaa))+geom_boxplot(aes(group=ncaa))+
  labs(
    title="Box Plot of SRS Ratings",
    color = "Tournament Berth")+
  scale_color_manual(labels = c("No","Yes"), values = c("red","blue"))+
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank())

plot3 <- ggplot(first10out,aes(x=SOS,y=wl))+geom_point(aes(color=Conf))+
  geom_label_repel(aes(label = School))+
  labs(
    title="Win Loss Percentage against Strength of Schedule",
    x = "Strength of Schedule for Highest SRS Teams without a Tournament Berth",
    y = "Win Loss Percentage",color="Conference")