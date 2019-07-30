library(tidyverse)
library(modelr)

#create linear model
sim1_mod <- lm(y ~ x, data = sim1)

#generate evenly spaced grid of values 
#over the region where our data lies
grid <- sim1 %>% 
  data_grid(x)

#add predictions
grid <- grid %>% 
  add_predictions(sim1_mod)

#plot the linear model with the data
ggplot(sim1, aes(x)) +
  geom_point(aes(y = y)) +
  geom_line(aes(y = pred), data = grid, colour = "red", size = 1)

#add residuals
sim1 <- sim1 %>%
  add_residuals(sim1_mod)

#plot resid against x
ggplot(sim1, aes(x, resid)) + 
  geom_ref_line(h = 0) +
  geom_point()


