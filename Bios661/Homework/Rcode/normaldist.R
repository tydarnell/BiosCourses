ggplot(NULL, aes(c(-3,3))) + stat_function(fun=dnorm,size=2.5,aes(color="Group 1"))+
  geom_hline(yintercept = 0,size=2.5,color="purple")+ 
  geom_area(stat = "function", fun = dnorm, aes(fill = "Group 2"), xlim = c(-3, -2)) +
  geom_area(stat = "function", fun = dnorm, aes(fill = "Group 2"), xlim = c(2, 3))+
  scale_colour_brewer(palette="Accent")+
  labs(x = "z", y = "") +theme_classic()+ theme(legend.position="none")