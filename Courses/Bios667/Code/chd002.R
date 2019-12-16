# chd002.r : Loglinear regression for counts, residuals
#                  Overdispersion
#**************************************************************

# assume current directory has been set, e.g.: setwd("c:/abc/xyz/...")

# read data
infile = "chd.dat"
x = read.table(infile,  header=T)

# generate a PDF file
pdf(file = 'chd002.pdf', onefile=T)  # send plots to this PDF file
lpy  = log(x$py)  # log person-years

#*******************************************************************************

# only smoking as a covariate, Table 11.7

fit1 = glm(x$cases ~ x$smoking,
           offset = lpy,
           family = poisson)

print(names(fit1))

r   = fit1$y - fit1$fitted.values
sr  = r / sqrt(fit1$fitted.values)
phi = sum(sr^2) / fit1$df.residual

plot(fit1$fitted.values, sr)
title(main = "CHD data, standardized residuals versus fitted values \
     cases ~ smoking ")


plot(fit1$fitted.values, sr^2)
lines(lowess(fit1$fitted.values, sr^2), col=2)
title(main = "CHD data, squared std residuals versus fitted values\
             cases ~ smoking" )


# overlay the estimated multipliers (variance = multiplier * mu )
mu   = 0:40
v_nb = 1 + 0.2942 * mu      # NB
lines(mu, v_nb, col = 3)
abline(phi, 0,  col = 4)    # scale
abline(1, 0, lty = 2)       # perfect Poisson

#**************************************************************************
# Table 11.5

fit2 = glm(x$cases ~ x$smoking + x$bp + x$personality, 
           offset = lpy,
           family = poisson)


r   = fit2$y - fit2$fitted.values
sr  = r / sqrt(fit2$fitted.values)
phi = sum(sr^2) / fit2$df.residual

plot(fit2$fitted.values, sr)
title(main = "CHD data, standardized residuals versus fitted values \
     cases ~ smoking + bp + personality ")


plot(fit2$fitted.values, sr^2)
lines(lowess(fit2$fitted.values, sr^2), col=2)
title(main = "CHD data, squared std residuals versus fitted values\
      cases ~ smoking + bp + personality ")

# overlay the estimated multipliers (variance = multiplier * mu )
mu = 0:40
v_nb = 1 + 0.0007 * mu       # NB
lines(mu, v_nb, col = 3)
abline(phi, 0,  col = 4)     # scale
abline(1, 0, lty = 2)        # perfect Poisson variance




dev.off()  # close the pdf file

