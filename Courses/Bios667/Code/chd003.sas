%let progname = chd003.sas;
* input:  chd.dat
* xref:   chd001.sas
     Chapter 11, Section 11.3.2
     Study of Risk Factors for Coronary Heart Disease (CHD)
     Loglinear (Poisson) Regression Model
     Over-dispersion relative to Poisson
     The "repeated" trick to obtain the robust variance estimator
***************************************************;
filename INF "chd.dat";
title1 "&progname: Risk Factors for Coronary Heart Disease (CHD)";
title2 "'repeated' statement to obtain the robust variance estimator";
ods pdf file = "chd003.pdf";
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

* Ideally, the same covariates as in Table 11.5 should be in the model;

title3 "3.b Poisson ";
proc genmod data = A;
  class id;
  model cases = smoking  personality bp  / d = poisson offset = lpy;
  repeated subject = id;
  run;

title3 "4.b Negative-Binomial  ";
proc genmod data = A;
  class id;
  model cases = smoking  personality bp  / d = negbin offset = lpy;
  repeated subject = id;
  run;

