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

sim1a <- tibble(
  x = rep(1:10, each = 3),
  y = x * 1.5 + 6 + rt(length(x), df = 2)
)


best=optim(c(0, 0), measure_distance, data = sim1a)
mod1a=lm(y~x,sim1a)

coef(mod1a)
best$par