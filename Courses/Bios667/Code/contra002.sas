%let progname = contra002.sas;
* input: contracep.dat
* output: 
* xref: contracep.txt
* does: Clinical trial of contracepting women
        Generalized mixed models for binary responses

*******************************************************************;
title "&progname: Clinical trial of contracepting women";

filename INF  "contracep.dat";       * input data;
ods pdf file = "contra002.pdf";
*******************************************************************;

data A;
  infile INF firstobs = 2;
  input id dose time y yprev r;
  time   = 1 + time;
  time2  = time * time;
  dt     = dose * time;
  dt2    = dose * time2;
  timefactor = time;

  label
    id     = "Subject ID"
    dose   = "Dose (0=low, 1=high)"
    time   = "Occasion (1, 2, 3, 4)"
    time2  = "Occasion^2 (1, 4, 9, 16)"
    y      = "Amenorrhea Status (0=no, 1=yes)"
    yprev  = "Amenorrhea Status at Previous Occasion (0=no, 1=yes)"
    r      = "Indicator of {Y is not missing} (0=missing, 1=observed)"
  ;
  run;

***************************************************;
title2 "Table 14.4: Marginal model, Unstructured Odds ratios, GEE";
* also produces initial values for nlmixed;
proc genmod data=A  descending;
  class id timefactor;
  model y = time time2 dt dt2 / d = b scale=1 noscale;
  repeated subject=id / withinsubject=timefactor logor=fullclust;
  run;

***************************************************;
title2 "Table 14.2: Generalized mixed model, MLE";
proc nlmixed data=A qpoints=50;
  parms 
          int      =   -2.2
          time_    =    0.70
          time2_   =  -0.032
          dt_      =    0.34
          dt2_     =   -0.068
          sigmasq  = 4 ;

  eta = int + time_ * time + time2_ * time2 
        + dt_ * dt + dt2_ * dt2 + u;
  p = 1 / (1 + exp(-eta));
  model  y ~ binary(p);
  random u ~ normal(0, sigmasq)  subject=id;
  run;

***************************************************;
title2 "Table 14.2 with log(sigma)";
proc nlmixed data=A qpoints=50;
  parms 
          int      =   -3.8057
          time_    =    1.1332
          time2_   =  -0.04192
          dt_      =    0.5644
          dt2_     =   -0.1096
          logsigma = 0.81113;

  eta = int + time_ * time + time2_ * time2 
        + dt_ * dt + dt2_ * dt2 + u;
  p = 1 / (1 + exp(-eta));
  model  y ~ binary(p);
  random u ~ normal(0, exp(2*logsigma))  subject=id;
  run;
