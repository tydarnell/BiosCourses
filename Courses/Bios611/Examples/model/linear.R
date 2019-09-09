library(tidyverse)
library(modelr)

models <- tibble(
  a1 = runif(250, -20, 40),
  a2 = runif(250, -5, 5)
)

model1 <- function(a, data) {
  a[1] + data$x * a[2]
}

measure_distance <- function(mod, data) {
  diff <- data$y - model1(mod, data)
  sqrt(mean(diff ^ 2))
}

sim1_dist <- function(a1, a2) {
  measure_distance(c(a1, a2), sim1)
}

models <- models %>% 
  mutate(dist = purrr::map2_dbl(a1, a2, sim1_dist))

grid <- expand.grid(
  a1=seq(-5,20,length=25),
  a2=seq(1,3,length=25)
) %>% 
  mutate(dist=map2_dbl(a1,a2,sim1_dist))

best <- optim(c(0,0),measure_distance,data=sim1)

sim1_mod <- lm(y ~ x, data = sim1)
