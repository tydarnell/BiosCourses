%let progname = chd001.sas;
* input:  chd.dat
* xref:
     Study of Risk Factors for Coronary Heart Disease (CHD)
     Loglinear (Poisson) Regression Model
     Residuals and over-dispersion
     Plots
***************************************************;
filename INF "chd.dat";
title1 "&progname: Risk Factors for Coronary Heart Disease (CHD)";
ods pdf file = "chd001.pdf";
ods graphics on;
***************************************************;
data A;
  infile INF firstobs=2;
  retain id 0;  * create a "subject id";
  id + 1;
  input smoking bp personality  cases py;
  lpy  = log(py) ; * log denominator;

  label
  smoking     = "Smoking (0/10/20/30 0/1-10/11-20/30+ cig/day)"
  bp          = "Blood pressure (0:<140, 1:>=140 mm Hg systolic)"
  personality = "Behavior (0=Type B, 1=Type A)"
  cases       = "Number of cases of CHD"
  py          = "Person-years (denominator)"
  lpy         = "Log person-years"
  ;
  run;

***************************************************;

proc genmod data = A   plots = all;
  model cases = smoking personality bp / d = poisson offset = lpy;
  output out = B115  resraw=resraw reschi=reschi stdreschi=stdreschi
         pred=fitted xbeta=xbeta stdxbeta=stdxbeta
    ;
  title2 "1.A Poisson ";
  run;

data B115;
  set  B115;
  xbeta = xbeta - lpy;       * SAS includes the offset in XBETA;
  rate = exp(xbeta);         * or: rate = pred / py;
  lo95 = exp(xbeta - 1.96 * stdxbeta);
  up95 = exp(xbeta + 1.96 * stdxbeta);
  p0   = exp(-rate);         * Poisson probability of 0;
  p1   = exp(-rate) * rate;  * Poisson probability of 1;
  pa1  = 1 - (p0 + p1);      * Poisson probability of >1;
  label p0 = "P(0  events in 1 person-year";
  label p1 = "P(1  event  in 1 person-year";
  label pa1= "P(>1 event  in 1 person-year";

run;


proc print data = B115;
  var smoking bp personality py cases fitted resraw reschi stdreschi;
  sum py cases fitted resraw;
  run;

proc print data = B115;
  var smoking bp personality rate lo95 up95 p0 p1 pa1;
  run;

proc genmod data = A   plots = all;
  model cases =         personality bp / d = poisson offset = lpy;
  title2 "1.B Poisson, without smoking ";
  run;
***************************************************;
                  *** Overdispersion ***;


* Ideally, the same covariates should be in the model;

title2 "3.b Poisson, unrestricted phi ";
proc genmod data = A;
  model cases = smoking  personality bp / d = poisson offset = lpy pscale;
  run;

title2 "4.b Negative-Binomial  ";
proc genmod data = A;
  model cases = smoking  personality bp / d = negbin offset = lpy;
  run;

title2 "5.b(1) Poisson, normal intercept";
proc nlmixed data = A;
      parms b_1  -5.42 b_smoking 0.027 b_personality 0.75 b_bp 0.75 logsigma 0;
      eta    = lpy + b_1 + b_smoking * smoking + b_personality * personality
               + b_bp * bp + e; * linear predictor;
      lambda = exp(eta);                          * mean;
      model cases ~ poisson(lambda);
      random e ~ normal(0,exp(2*logsigma)) subject = id;
      run;


title2 "5.b(2) Poisson, normal intercept, empirical se";
proc nlmixed data = A  empirical;
      parms b_1  -5.42 b_smoking 0.027 b_personality 0.75 b_bp 0.75 logsigma 0;
      eta    = lpy + b_1 + b_smoking * smoking + b_personality * personality
               + b_bp * bp + e; * linear predictor;
      lambda = exp(eta);                          * mean;
      model cases ~ poisson(lambda);
      random e ~ normal(0,exp(2*logsigma)) subject = id;
      run;

***************************************************;

ods graphics off;
ods _all_ close;
