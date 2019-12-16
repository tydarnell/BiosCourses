%let progname = mus005.sas;
* input:  muscatine.dat
* xref:
     Obesity Muscatine Coronary Risk Factor Study
     Marginal logistic regression model
     Working correlation: Unstructured, independence, AR(1), exchangeable
***************************************************;
title1 "&progname: Marginal Logistic Regression Model for Obesity Muscatine Coronary Risk Factor Study";
filename INF   "muscatine.dat";
ods pdf file = "mus005.pdf";
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


proc sort data = A; by id occasion; run;

*********************************************************************;

title2 "1. Table 13.5, but with unstructured working correlation";
proc genmod descending data = A;
     class id occasion;  
     model obesity = gender cage cage2 cage3 
          / dist = bin link = logit;
     repeated subject = id / withinsubject = occasion type = un corrw;
run;

*********************************************************************;

title2 "2. Table 13.5, but with AR(1) working correlation";
proc genmod descending data = A;
     class id occasion;  
     model obesity = gender cage cage2 cage3 
       / dist = bin link = logit;
     repeated subject = id 
       / withinsubject = occasion type = ar(1) corrw;
run;

*********************************************************************;

title2 "3. Table 13.5, but with exchangeable working correlation";
proc genmod descending data = A;
     class id occasion;  
     model obesity = gender cage cage2 cage3 
       / dist = bin link = logit;
     repeated subject = id 
       / withinsubject = occasion type = exch  corrw;
run;

*********************************************************************;

title2 "4. Table 13.5, but with independence working correlation";
* Note the "modelse" option;
proc genmod descending data = A;
     class id occasion;  
     model obesity = gender cage cage2 cage3 
       / dist = bin link = logit;
     repeated subject = id
       / withinsubject = occasion type = indep corrw modelse;
run;

*********************************************************************;

title2 "5. Table 13.5, ignoring correlation (no empirical SE estimates)";
proc genmod descending data = A;
     model obesity = gender cage cage2 cage3 
        / dist = bin link = logit;
run;

*********************************************************************;
