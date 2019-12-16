%let progname=6city09.sas;
%let pdfout  =6city09.pdf;

* xref: Biometrics(88) p1049
* input: 6CITY.DAT
* output:
* does  - The "fixed-effects" model
        - conditional likelihood
        - proc logistic
        - proc phreg
***************************************************;
title1 "&progname: Six-city Study - conditional likelihood ***";
filename INF "6city.dat";
ods pdf file = "&pdfout";
options nocenter errors=3;
***************************************************;
data A0;
  infile INF firstobs=2;
  input y7 - y10 ms count;
  run;
***************************************************;
data A (keep = id y one age ms msxage count y7-y10);
  set A0;
  retain id 0 one 1;
  * get data and coding as in Biometrics(88) p1049 paper;
  id + 1;

  y = y7;  age =-2; msxage = ms * age; output;
  y = y8;  age =-1; msxage = ms * age; output;
  y = y9;  age = 0; msxage = ms * age; output;
  y = y10; age = 1; msxage = ms * age; output;

  label y      = "Respiratory illness (0=no, 1=yes)";
  label ms     = "Mother smoking (0=no, 1=yes)";
  label age    = "Age (years) - 9";
  label msxage = "Age x MS";
  label count  = "Number of children with this pattern";
  run;
***************************************************;
title2 '1. LOGISTIC, model y (event="1") = age msxage';
proc logistic data = A descending;
  model y (event="1")  = age msxage;
  strata id;
  freq count;
  run;
***************************************************;
title2 "2. PHREG, model id * y (0) = age msxage / ties =  discrete";
proc phreg data=A;
  model id * y (0) = age msxage / ties =  discrete;
  strata id;
  freq count;
  run;

