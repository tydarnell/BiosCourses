# fat003.r : Mixed models for percent body fat
# xref: fat002.sas
#****************************************************************************************

# read the data file
fat  <- read.table("fat160.dat", header=T)

# load the required library (function "lme") 
library(nlme)

#*******************************************************************************************************************

# random intercept

model0 <- lme(pbf ~ time + I(time * time), random = ~ 1 | id, data = fat)
print(summary(model0))

#*******************************************************************************************************************

# random intercept and slope for time

model1 <- lme(pbf ~ time + I(time * time),
              random = ~ 1 + time | id, data = fat)
print(summary(model1))

#*******************************************************************************************************************

# random intercept and slopes for time and time^2

model2 <- lme(pbf ~ time + I(time*time), 
              random = ~ 1 + time + I(time * time) | id, data = fat)
print(summary(model2))

