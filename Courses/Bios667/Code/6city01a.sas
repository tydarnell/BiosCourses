%let progname=6city01A.sas;
%let pdfout  =6city01A.pdf;

* xref: Biometrics(1988) page 1049, table 1.
* input: 6city.dat
* output:
* does  - GEE using proc genmod.
        - link: logit
        - working corr: indep, exch, ar(1), unstructured
        - Expanded data set, not using "freq count" in genmod
***************************************************;
title1 "&progname:  Six-City Study - marginal models";
filename INF   "6city.dat";
ods pdf file = "&pdfout";
options nocenter errors=3;
***************************************************;
data A;
  infile INF firstobs=2;
  input y7 - y10 ms count;
  do i = 1 to count; output; end;
  drop i;
  run;
***************************************************;
proc corr data=A noprob;
  var y7 - y10;
  by ms;
  title2 "Descriptive  stats";
  run;
***************************************************;
data B (keep = id y one age ms);
  set A;
  retain id 0 one 1;
  * set up as in the Biometrics(1988) paper;
  id + 1;

  y = y7;  age =-2; output;
  y = y8;  age =-1; output;
  y = y9;  age = 0; output;
  y = y10; age = 1; output;

  label y      = "Respiratory illness 0=no 1=yes";
  label ms     = "Mother smoking      0=no 1=yes";
  label age    = "Child's age (years) - 9       ";
  run;
***************************************************;
data B;
  set B;
  agefactor = age;
  msxage    = ms * age;
  label msxage = "Age x MS";
  run;
***************************************************;
proc genmod data=B;
  class id agefactor;
  model y / one =    ms age msxage / d=b scale=1 noscale;
  repeated subject=id / withinsubject=agefactor  type=indep corrw;
  title2 "1. GEE: 1 + MS + age + MSxAge, independence working correlation ";
  run;
***************************************************;
proc genmod data=B;
  class id agefactor;
  model y / one =    ms age msxage / d=b scale=1 noscale;
  repeated subject=id / withinsubject=agefactor  type=exch corrw;
  title2 "2. GEE: 1 + MS + age + MSxAge, exchangeable working correlation ";
  run;
***************************************************;
proc genmod data=B;
  class id agefactor;
  model y / one =    ms age msxage / d=b scale=1 noscale;
  repeated subject=id / withinsubject=agefactor  type=ar(1) corrw;
  title2 "3. GEE: 1 + MS + age + MSxAge, 1st-order autoregressive working correlation ";
  run;
***************************************************;
proc genmod data=B;
  class id agefactor;
  model y / one   =    ms age msxage / d=b scale=1 noscale;
  repeated subject=id / withinsubject=agefactor type=un corrw;
  title2 "4. GEE:  1 + MS + age + MSxAge, unstructured  working correlation ";
  run;
