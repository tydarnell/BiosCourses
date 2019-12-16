%let progname=6city06.sas;
%let pdfout  =6city06.pdf;
                        
* 6cityj.sas
* xref: Biometrics(88) p1049, table 1.
* input: 6CITY.DAT
* output:
* does  - Random-effects
            - Example proc nlmixed
            - Options "qpoints" and "empirical"
        - Marginal model (attenuation)
***************************************************;
title1 "*** BIOS 767: Six-city Study - random-effects models ***";
filename INF "6city.dat";
ods pdf file = "&pdfout";
options nocenter errors=3;
***************************************************;
data A0;
  infile INF firstobs=2;
  retain id 0 ;
  input y7 - y10 ms count;
  id + 1;
  run;
***************************************************;
data A (keep = id y age ms count);
  set A0;
  * set up as in the Biometrics(1988) paper;

  y = y7;  age =-2; output;
  y = y8;  age =-1; output;
  y = y9;  age = 0; output;
  y = y10; age = 1; output;

  label y      = "Respiratory illness 0=no 1=yes";
  label ms     = "Mother smoking      0=no 1=yes";
  label age    = "Child's age (years) - 9       ";
  label count  = "Number with this pattern      ";
  run;
***************************************************;
data A;
  set A;
  agefactor = age;
  msxage    = ms * age;
  label msxage = "Age x MS";
  run;
***************************************************;
title2 "1. proc nlmixed, default qpoints";
proc nlmixed data=A;
  parms int_ = -2 ms_ = 0.3 age_ = -0.1 sigmasq = 2;
  eta = int_ + ms_ * ms + age_ * age + u;
  p = 1 / (1 + exp(-eta));
  model y ~ binary(p);
  random u ~ normal(0, sigmasq)  subject=id;
  replicate count;
  run;
***************************************************;
title2 "2. proc nlmixed qpoints = 25";
proc nlmixed data=A qpoints=25;
  parms int_ = -2 ms_ = 0.3 age_ = -0.1 sigmasq = 2;
  eta = int_ + ms_ * ms + age_ * age + u;
  p = 1 / (1 + exp(-eta));
  model y ~ binary(p);
  random u ~ normal(0, sigmasq)  subject=id;
  replicate count;
  predict u out=U;
  run;
***************************************************;
title2 "Predicted random effects (posterior mode)";
proc contents data=U;
  run;

proc print data=U (obs=32);
  var id ms age pred stderrpred lower upper; 
  run;

data U;
  merge A0 U; by id;
  if first.id;
  s = y7 + y8 + y9 + y10;
  run;

proc freq data = U; table pred; weight count;
  run;

proc means data = U; var   pred; freq   count;
  run;

proc sort data = U; by pred y7 y8 y9 y10 ms;
  run;

proc print data=U;
  var id count ms y7 y8 y9 y10 s pred;
  sum count;
  run;

***************************************************;
title2 "3. GEE: 1 + MS + age, exchangeable working correlation ";
proc genmod data=A descending;
  class id agefactor;
  model y = ms age / d=b scale=1 noscale;
  repeated subject=id / withinsubject=agefactor  type=exch corrw;
  freq count;
  run;
