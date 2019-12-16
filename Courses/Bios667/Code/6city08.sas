%let progname=6city08.sas;
%let pdfout  =6city08.pdf;

* 6citym.sas
* xref: Biometrics(88) p1049, table 1.
* input: 6city.dat
* output:
* does  - random-effects logistic regression
        - random effect U ~ normal(0, sigma2)
        - random effect Z ~ normal(0, 1) and include sigma*Z in eta
***************************************************;
title1 "*** Six-city Study - random-effects models ***";
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

  label y      = "Respiratory illness 0=no 1=yes";
  label ms     = "Mother smoking      0=no 1=yes";
  label age    = "Age (years) - 9               ";
  label msxage = "age x ms                      ";
  label count  = "number with this pattern      ";
  run;
***************************************************;
title2 "random z ~ normal(0, 1)";
proc nlmixed data=A qpoints=20;
  parms int = -2 ms_ = 0.3 age_ = -0.1 sigma = 2;
  eta = int + ms_ * ms + age_ * age + sigma * z;
  p = 1/(1+exp(-eta));
  model y ~ binary(p);
  random z ~ normal(0, 1)  subject=id;
  replicate count;
  run;
***************************************************;
title2 "random u ~ normal(0, sigma*sigma)  ";
proc nlmixed data=A qpoints=20;
  parms int = -2 ms_ = 0.3 age_ = -0.1 sigma = 2;
  eta = int + ms_ * ms + age_ * age + u;
  p = 1/(1+exp(-eta));
  model y ~ binary(p);
  random u ~ normal(0, sigma*sigma)  subject=id;
  replicate count;
  predict u out=U;
  run;
