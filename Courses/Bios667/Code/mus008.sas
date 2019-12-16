%let progname = mus008.sas;
* input:  muscatine.dat
* xref:
     Obesity Muscatine Coronary Risk Factor Study
     Chapter 13, Section 13.4, Table 13.4
     Shows how to use zdata with zrep
***************************************************;
title1 "&progname: Marginal Logistic Regression Model for Obesity Muscatine Coronary Risk Factor Study";
filename INF   "muscatine.dat";
ods pdf file = "mus008.pdf";
***************************************************;

data A;
  infile INF firstobs = 2;
  input id gender baseage age occasion obesity;
  if not missing(obesity);
  cage  = age - 12;
  cage2 = cage * cage;
  cage3 = cage * cage2;
  label
     obesity = "Obesity (0=no, 1=yes)"
     cage    = "Current age (years, minus 12)"
     cage2   = "Current age (years, minus 12) squared"
     cage3   = "Current age (years, minus 12) cubed"
     baseage = "Baseline age (years)"
     gender  = "Gender (0=Male, 1=Female)"
     occasion= "Occasion (1=1977, 2=1979, 3=1981)";
   ;
  run;
*********************************************************************;

title2 "1. Table 13.4";
proc genmod descending data = A;
  class id occasion;  
  model  obesity = gender cage cage2 / dist = bin link = logit;
  repeated subject = id / withinsubject=occasion 
      logor = zrep( (1 2) 1 0,
                    (1 3) 0 1,
                    (2 3) 1 0);
run;

*********************************************************************;
data Z;
  input z1 z2;
  cards;
  1 0
  0 1
  1 0
  ;
  run;

*********************************************************************;

title2 "2. Table 13.4";
proc genmod descending data = A;
  class id occasion;  
  model obesity = gender cage cage2 / dist = bin link = logit;
  repeated subject = id / withinsubject = occasion
      logor = zrep zdata = Z zrow = (z1 z2);
run;


