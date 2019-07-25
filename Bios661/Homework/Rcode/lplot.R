fun.1=function(x){ (1/x-1)/(x+1)} 
p <- ggplot(data = data.frame(x = 0), mapping = aes(x = x))
p+stat_function(fun=fun.1)+ xlim(0,100)+ylim(-5,30)+theme_bw()+
  theme(axis.title.y=element_blank() ,axis.text.x=element_blank(),axis.text.y=element_blank())
