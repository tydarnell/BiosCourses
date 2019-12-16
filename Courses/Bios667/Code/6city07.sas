%let progname=6city07.sas;
%let pdfout  =6city07.pdf;
                        
* xref: Biometrics(88) p1049, table 1.
* input: 6CITY.DAT
* output:
* does  - Random-effects logistic regression
        - Allow variance components to differ by MS status
        - Random intercept and slope
***************************************************;
title1 "*** BIOS 767: Six-city Study - random-effects models ***";
filename INF "6city.dat";
ods pdf file = "&pdfout";
options nocenter errors=3;
***************************************************;
data A0;
  infile INF  firstobs=2;
  input y7 - y10 ms count;
  run;
***************************************************;
data A (keep = id y one age ms msxage count);
  set A0;
  retain id 0 one 1;
  * get data and coding as in Biometrics(88) p1049 paper;
  id + 1;

  y = y7;  age =-2; msxage=ms * age; output;
  y = y8;  age =-1; msxage=ms * age; output;
  y = y9;  age = 0; msxage=ms * age; output;
  y = y10; age = 1; msxage=ms * age; output;

  label y      = "Respiratory illness (0=no 1=yes)";
  label ms     = "Mother smoking (0=no 1=yes)";
  label age    = "Age (years) - 9               ";
  label msxage = "age * ms                      ";
  label count  = "Number with this pattern      ";
  run;

***************************************************;

title2 "1. Variance components the same in both MS groups";
proc nlmixed data=A qpoints = 15;
  parms one_  = -3  ms_ = 0.4 age_ = -0.2  log_sigma2 = 1.5 ;
  eta = one_ + ms_ * ms + age_ * age + u;
  p   = 1 / (1 + exp(-eta));
  model  y ~ binary(p);
  random u ~ normal(0, exp(log_sigma2))  subject=id;
  replicate count;
  run;

***************************************************;

title2 "2. Variance components differ by MS status";
proc nlmixed data=A qpoints = 15;
  parms one_  = -3  ms_ = 0.4 age_ = -0.2
        gamma0 = 1.5 gamma1  = 0 ;
  eta = one_ + ms_ * ms + age_ * age + u;
  p = 1 / (1 + exp(-eta));
  log_sigma2 = gamma0 + gamma1 * ms;
  model  y ~ binary(p);
  random u ~ normal(0, exp(log_sigma2))  subject=id;
  replicate count;
  run;

***************************************************;

title2 "3. Two random effects";
proc nlmixed data=A qpoints = 15;
  parms one_  = -3  ms_ = 0.4 age_ = -0.2  
    sigma11 4 sigma21 0 sigma22 1;
  eta = one_ + ms_ * ms + age_ * age + u1 + u2 * age ;
  p   = 1 / (1 + exp(-eta));
  model  y ~ binary(p);
  * Syntax: u1 u2 ... normal([mean vector], [lower half of cov matrix]);
  random u1 u2 ~ normal([0, 0],[sigma11, sigma21, sigma22])
         subject = id;
  replicate count;
  run;
