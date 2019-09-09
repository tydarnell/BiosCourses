fun.1=function(x) -x^2
p <- ggplot(data = data.frame(x = 0), mapping = aes(x = x))
p+stat_function(fun=fun.1)+ xlim(-10,10)+ylim(-100,10)+geom_hline(yintercept = -25)+
  geom_vline(xintercept = -5)+geom_vline(xintercept = 5)+theme_bw()+
  theme(axis.title.y=element_blank() ,axis.text.x=element_blank(),axis.text.y=element_blank())+xlab("w")