# icc6.r :
# xref: icc2.sas
#
# does  - Logistic regression with a random intercept
#       - Compute marginal quantities
#           - Using simulation
#           - Using numerical integration
#
# Suppose that:
#        logit(nu_ij) = b_i - 3,
#        logit(nu_ik) = b_i - 4,
#        b_i ~ Normal(0, 4)

#**********************************************************;
var2cor <- function(v) {
  # returns corr matrix;
  s = 1 / sqrt(diag(v));
  return (s * t(s * v));
}
#**********************************************************;

print("*** Simulation ***");

G= matrix(c(3.7307,-0.0653,-0.0653,0.9861), nrow=2, ncol=2,byrow = TRUE);  
U   = chol(G);   

seed<-NULL
seed = matrix(667,nrow=1e6,ncol=ncol(G));
seed <-as.data.frame(seed)

t<-NULL
t$V1<-rnorm(seed$V1)
t$V2<-rnorm(seed$V2)


#U is 2x2
#1*2
#dim(U)
t<-as.data.frame(t)
dim(t)
dim(U)
b_i = t * U; 

#dim(b_i)

#sigma11<-3.73;
#sigma12<-(-0.0653);
#sigma22<-0.986;

#b_i1 <- sigma1 * rnorm(1e6);               #  random effect1;
#b_i2 <-sigma2 * rnorm(1e6);                #  random effect1;


#conditional logit1 placebo:drug=0 and time=0 logit=intercept +bi
l_00   <- 4.32 + b_i[,1];                          #  conditional logit
nu_00 <- 1 / (1 + exp(-1*l_00));                    # conditional mean
mu_00  <- mean(nu_00);                            #  marginal mean, E[Y_ij]

#conditional logit1 placebo:drug=0 and time=3 logit=intercept +bi +(B1+bi2)*3
l_03   <- 4.32 + b_i[,1] +(-0.0957+b_i[,2])*3;       #  conditional logit
nu_03 <- 1 / (1 + exp(- l_03));             # conditional mean
mu_03  <- mean(nu_03);                      #  marginal mean, E[Y_ij]

#conditional logit1 placebo:drug=0 and time=6 logit=intercept +bi +(B1+bi2)*6
l_06   <- 4.32 + b_i[,1] +(-0.0957+b_i[,2])*6;       #  conditional logit
nu_06 <- 1 / (1 + exp(- l_06));             # conditional mean
mu_06  <- mean(nu_06);                      #  marginal mean, E[Y_ij]


print("mu_00 mu03 mu06");
print(c(mu_00, mu_03, mu_06));

#conditional logit1 active:drug=1 and time=0 logit=intercept +bi
l_10   <- 4.32 + b_i[,1];                          #  conditional logit
nu_10 <- 1 / (1 + exp(- l_10));             # conditional mean
mu_10  <- mean(nu_10);                      #  marginal mean, E[Y_ij]

#conditional logit1 active:drug=1 and time=3 logit=intercept +bi +(B1+bi2)*3+(B2*3)
l_13   <- 4.32 + b_i[,1] +(-0.0957+b_i[,2])*3 + (-0.942*3);       #  conditional logit
nu_13 <- 1 / (1 + exp(- l_13));             # conditional mean
mu_13  <- mean(nu_13);                      #  marginal mean, E[Y_ij]

#conditional logit1 active:drug=1 and time=6 logit=intercept +bi +(B1+bi2)*6+(B2*6)
l_16   <- 4.32 + b_i[,1] +(-0.0957+b_i[,2])*6 +(-0.942*6) ;       #  conditional logit
nu_16 <- 1 / (1 + exp(- l_16));             # conditional mean
mu_16  <- mean(nu_16);                      #  marginal mean, E[Y_ij]

print("mu_10 mu13 mu16");
print(c(mu_10, mu_13, mu_16));


###calculate the estimated marginal correlation matrix for placebo t=0,3,6
mu_003 <- mean(nu_00 * nu_03);              #  E[Y_ij Y_ik]; t=0 t=3
mu_006 <- mean(nu_00 * nu_06);              #  E[Y_ij Y_ik]; t=0 t=3
mu_036 <- mean(nu_03 * nu_06);              #  E[Y_ij Y_ik]; t=0 t=3

print("mu_003 mu_006 mu_036");
print(c(mu_003, mu_006 ,mu_036));


cov_003<- mu_003 - mu_00 * mu_03; 
cov_006<- mu_006 - mu_00 * mu_06;
cov_036<- mu_036 - mu_03 * mu_06; 
print("cov_003 cov_006 cov_036");
print(c(cov_003, cov_006 ,cov_036));

var_00 <- mu_00 * (1 - mu_00); 
var_03 <- mu_03 * (1 - mu_03); 
var_06 <- mu_06 * (1 - mu_06); 

print("var_003 var_006 var_036");
print(c(var_00, var_03 ,var_06));


cor_003<- cov_003 / sqrt(var_00 * var_03);
cor_006<- cov_006 / sqrt(var_00 * var_06); 
cor_036<- cov_036 / sqrt(var_03 * var_06); 

print("cor_003 cor_006 cor_036");
print(c(cor_003, cor_006 ,cor_036));

print("ICC for Y_06:");
var_total   <- var_06;                      
var_between <- var(nu_06);                  
icc_06      <- var_between / var_total;     
print("var_between  var_total  icc_06:");
print(c(var_between, var_total, icc_06));



