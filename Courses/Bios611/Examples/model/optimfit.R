library(tidyverse)
library(modelr)

# create model from data
model1 <- function(a, data) {
  a[1] + data$x * a[2]
}

#compute overall distance between predicted and actual values
#using mean absolute distance
measure_distance <- function(mod, data) {
  diff <- data$y - model1(mod, data)
  mean(abs(diff))
}

#use optim (Newton-Raphson search) to find slope and intercept
best <- optim(c(0, 0), measure_distance, data = sim1)

#plot the data and the model
ggplot(sim1, aes(x, y)) + 
  geom_point(size = 2, colour = "grey30") + 
  geom_abline(intercept = best$par[1], slope = best$par[2])

#create model using lm to compare
sim1_mod <- lm(y ~ x, data = sim1)

#optim coeffecients
best$par
#lm coeffecients
coef(sim1_mod)