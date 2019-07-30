sim1l = loess(y ~ x, data = sim1)

grid <- sim1 %>% 
  data_grid(x)

#add predictions
grid <- grid %>% 
  add_predictions(sim1l)

ggplot(sim1, aes(x)) +
  geom_point(aes(y = y)) +
  geom_line(aes(y = pred), data = grid, colour = "red", size = 1)

sim1 <- sim1 %>%
  add_residuals(sim1l)

#plot resid against x
ggplot(sim1, aes(x, resid)) + 
  geom_ref_line(h = 0) +
  geom_point()

#compare to geom_smooth
ggplot(sim1,aes(x=x,y=y))+
  geom_point()+
  geom_smooth()