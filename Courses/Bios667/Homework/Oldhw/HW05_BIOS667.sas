/*********************************************
Name: Cheynna Crowley
Assignment: BIOS 667 HW 5
Due Date: 12/4/17
References: 
-> Codes: scs04.sas, icc2.sas, 
->Book: Chapter 9
-> Handout: nlmixed.pdf
*********************************************/
%let progname=HW05_BIOS667.sas;
%let pdfout  =HW05_BIOS667.pdf;

/*Read in Data*/
***************************************************;
title1 "*** BIOS 667, NIMH Schizophrenia Collaborative Study ***";
filename INF "\\Client\H$\Desktop\Fall2017\BIOS667\SAKAI FINAL\Code and Data\scs1.dat";

ods pdf file = "&pdfout";
options nocenter errors=3;
***************************************************;
/*Fit a Generalized Mixed Model for the SCS Data Chapter 9*/
data A;
  infile INF  firstobs = 2;
  input id imps79 group week;
  *use time and not sqrt of time;
  time = week;
  *use time as a quantitative, continuous covariate ranging from 0-6;
  y    = (imps79 > 3.4);      * Binary outcome;
  label imps79 = "Item 79 of the IMPS";
  label y      = "I(imps79 > 3.4)";
  label group  = "Group (0=placebo, 1=active)";
*define group to be 0 for placebo;
*define group to be 1 for treated patients;
  label week   = "week";
  label time   = "time (week)";
  time_group=time*group;
run;

proc sort data = A;
by id week; 
run;

*for G let g11=4, g21=0 and g22=1;
/*get initial estimates from proc logistic*/
*fit an ordinary logistic regression model ignore correlation;
*fixed effect _betas_ are intercept, time and time*group;
  proc logistic data=A;
  *class time group;
  model y=time time_group;
  run;

  *proc logistic data=A;
  *class time group;
  *model y=time time*group;
  *run;

  *
Intercept -2.5087 0.1178 453.3659 <.0001 0.081 
time 1 0.2494 0.0472 27.9636 <.0001 1.283 
time*group 1 0.2658 
  ;

/*find the estimates to use in the stimilations in code */
/*do proc lnmixed*/
/*Question a and b*/
*For G, use initial values g11 = 4 g21 =0 g22 = 1;
*do qpoints=25 in proc nlmixed;
*allow for a subject specific random intercept;
*allow for a random slop for time;
proc nlmixed data=A qpoints =25;
  parms one_  = -2.5  _time = 0.25 _time_group = -0.2  
    sigma11 4 sigma21 0 sigma22 1;
  eta = one_ + _time*time + _time_group*time_group + u1 + u2*time;
  p   = 1 / (1 + exp(-eta));
  model  y ~ binary(p);
  * Syntax: u1 u2 ... normal([mean vector], [lower half of cov matrix]);
  random u1 u2 ~ normal([0, 0],[sigma11, sigma21, sigma22])
         subject = id;
  run;


proc nlmixed data=A qpoints =25;
  parms one_  = -2.5  _time = 0.25 _time_group = -0.2  
    sigma11 4 sigma21 0 sigma22 0;
  eta = one_ + _time*time + _time_group*time_group + u1 + u2*time;
  p   = 1 / (1 + exp(-eta));
  model  y ~ binary(p);
  * Syntax: u1 u2 ... normal([mean vector], [lower half of cov matrix]);
  random u1 u2 ~ normal([0, 0],[sigma11, sigma21, sigma22])
         subject = id;
  run;


/**************
  Question cde
**************/

proc iml;
print "Simulate vectors b_i ~ N(0, G)";
G = {
3.73    -0.0653,
-0.0653   0.986
};

seed   = j(1e6, ncol(G), 667);
U      = half(G);  
print G ;

* The upper Choleski root;
b_i    = rannor(seed) * U;  
* Random effects;
* Each row in matrix "b_i" contains one simulated vector of random-effects;
l_00 =  b_i[,1] + 4.3224;
nu_00 = 1 / (1 + exp(-l_00));                    
mu_00 = mean(nu_00); 

print G ;

print a;
print "Check sample mean and sample cov matrix:";
print "sample_mean should be close to zero";
print "sample_cov  should be close to G";
sample_mean      = mean(b_i);
sample_cov       = cov(b_i);

print sample_mean;      


proc iml;

print "Simulate vectors b_i ~ N(0, G)";

G = {
3.73 -0.0653,
-0.0653 0.986
};

print G;
seed   = j(1e6, ncol(G), 667);
U      = half(G);
print U;
b_i    = rannor(seed) * U; 
b_1=b_i[,1];
b_2=b_i[,2];

/*conditional logit1 placebo:drug=0 and time=0 logit=intercept +bi*/
l_00=b_1 + 4.3224; 												*conditional logit;
nu_00 = 1 / (1 + exp(-1*l_00));    								*conditional mean;                 
mu_00 = mean(nu_00); 											*marginal mean, E[Y_ij];

/*conditional logit1 placebo:drug=0 and time=3 logit=intercept +bi +(B1+bi2)*3*/
l_03 = 4.32 + b_1 +(-0.0957+b_2)*3;   							*conditional logit;
nu_03 = 1 / (1 + exp(-1*l_03));      							*conditional mean;
mu_03 = mean(nu_03);                 							*marginal mean, E[Y_ij];

/*conditional logit1 placebo:drug=0 and time=6 logit=intercept +bi +(B1+bi2)*6*/
l_06 = 4.32 + b_1 +(-0.0957+b_2)*6;       						*conditional logit;
nu_06 = 1 / (1 + exp(-1*l_06));          	 					*conditional mean;
mu_06 = mean(nu_06);      										*marginal mean, E[Y_ij];

print "mu_00 mu03 mu06";
print mu_00, mu_03, mu_06; 

/*conditional logit1 active:drug=1 and time=0 logit=intercept +bi*/
l_10  = 4.32 + b_1;                  							*conditional logit;
nu_10 = 1 / (1 + exp(-1*l_10));             					*conditional mean;
mu_10 = mean(nu_10);                      						*marginal mean, E[Y_ij];

/*conditional logit1 active:drug=1 and time=3 logit=intercept +bi +(B1+bi2)*3+(B2*3)*/
l_13  = 4.32 + b_1 +(-0.0957+b_2)*3 + (-0.942*3);       		*conditional logit;
nu_13 = 1 / (1 + exp(-1*l_13));              					*conditional mean;
mu_13 = mean(nu_13);                      						*marginal mean, E[Y_ij];

/*conditional logit1 active:drug=1 and time=6 logit=intercept +bi +(B1+bi2)*6+(B2*6)*/
l_16  = 4.32 + b_1 +(-0.0957+b_2)*6 +(-0.942*6);   				*conditional logit;
nu_16 = 1 / (1 + exp(-1*l_16));             					*conditional mean;
mu_16 = mean(nu_16);                      						*marginal mean, E[Y_ij];


print "mu_10 mu13 mu16";
print mu_10, mu_13, mu_16; 

/*calculate the estimated marginal correlation matrix for placebo t=0,3,6*/

mu_003 = mean(nu_00#nu_03);   			 *E[Y_ij Y_ik] t=0 t=3;
mu_006 = mean(nu_00#nu_06);              *E[Y_ij Y_ik] t=0 t=3;
mu_036 = mean(nu_03#nu_06);              *E[Y_ij Y_ik] t=0 t=3;

print "mu_003 mu_006 mu_036";
print mu_003, mu_006 ,mu_036;

cov_003 = mu_003 - mu_00#mu_03; 
cov_006 = mu_006 - mu_00#mu_06;
cov_036 = mu_036 - mu_03#mu_06; 

print "cov_003 cov_006 cov_036";
print cov_003, cov_006 ,cov_036;

var_00 = mu_00#(1 - mu_00); 
var_03 = mu_03#(1 - mu_03); 
var_06 = mu_06#(1 - mu_06); 

print "var_00 var_03 var_06";
print var_00, var_03 ,var_06 ;

cor_003 = cov_003 / sqrt(var_00*var_03);
cor_006 = cov_006 / sqrt(var_00*var_06); 
cor_036 = cov_036 / sqrt(var_03*var_06); 

print "cor_003 cor_006 cor_036";
print cor_003, cor_006 ,cor_036;

/*ICC for Y_06*/

var_total = var_06;                      
var_between = var(nu_06);                  
icc_06 = var_between / var_total;    
 
print "var_between  var_total  icc_06:";
print var_between, var_total, icc_06 ;

