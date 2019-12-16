


#question g;

alpha = estimates[1, 2]
beta =  estimates[2, 2]

lowbw=3000
ages=c(15,20,25,30,35,40)

temp1 = predicted[predicted$age %in% ages, ]
temp2 = temp1[,c("age","Pred","StdErrPred", "Lower","Upper")]
temp2 = unique(temp2)
temp2$prob = pnorm((3000 - temp2$Pred)/temp2$StdErrPred)
temp2$lower= pnorm((3000 - temp2$Lower)/temp2$StdErrPred)
temp2$upper= pnorm((3000 - temp2$Upper)/temp2$StdErrPred)

#     age     Pred StdErrPred    Lower    Upper         prob        lower        upper
#1    15 2989.551   36.15502 2918.602 3060.501 6.137108e-01 9.878190e-01 4.712782e-02
#5    25 3216.948   33.25655 3151.686 3282.209 3.435329e-11 2.544489e-06 1.070998e-17
#23   20 3103.249   28.30863 3047.697 3158.801 1.325190e-04 4.600342e-02 1.013732e-08
#38   30 3330.646   47.12795 3238.163 3423.128 1.142227e-12 2.168373e-07 1.375098e-19
#90   35 3444.344   64.39345 3317.980 3570.708 2.591820e-12 3.944640e-07 3.900685e-19
#930  40 3558.042   82.96032 3395.244 3720.841 8.682641e-12 9.477906e-07 1.828458e-18



#I;

alpha=-0.2917
beta=-0.0303

ages2=c(-5,0,5,10,15,20)

predicted<-read.csv("/Users/Cheynna/Desktop/Spring2019/BIOS_767/Final/qI.csv")
temp1 = predicted[predicted$age %in% ages2, ]
temp2 = temp1[,c("age","pred","lower","upper")]
temp2 = unique(temp2)





set.seed(2017)
age_2 = 5
beta  = pJ[1:2, 2]
x_ij  = c(1, age_2) # age 25 (age2 = 5)
sigmasq = pJ[3, 2]
sigma   = sqrt(sigmasq)

b_i     = rnorm(1e5, sd = sigma)   # random effects

eta_ij = b_i + t(x_ij) %*% beta
nu_ij  = pnorm(eta_ij)       # conditional mean
mu_ij  = mean(nu_ij)          # E[Y_ij]  by double expectation


# Y_ij
# total variance = between + within
total_ij   = mu_ij * (1 - mu_ij)    # Bernoulli
between_ij = var(nu_ij)             # var(conditional mean)
within_ij  = mean(nu_ij*(1-nu_ij))  # E[conditional variance]
icc_ij = between_ij / total_ij