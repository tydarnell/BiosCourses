%let progname = mus001.sas;
* input:  muscatine.dat
* xref:
     Obesity Muscatine Coronary Risk Factor Study
     Chapter 13, Section 13.4, Tables 13.1-13.5
     Descriptive and marginal logistic regression model
       with pairwise odds ratios
***************************************************;
title1 "&progname: Marginal Logistic Regression Model for Obesity Muscatine Coronary Risk Factor Study";
filename INF   "muscatine.dat";
ods pdf file = "mus001.pdf";
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

proc freq data = A;
  table 
    baseage * age 
    occasion * age
    baseage * occasion
    / nocol norow nopercent
  ;
  run;

proc freq data = A;
  table 
    baseage * age / noprint out = B;
  run;
data B;
  set B;
  occasion = 1 + (age - baseage) /2;
  run;

proc print data = B; var baseage age occasion; run;


proc sort data = A; by id occasion; run;

title2 "Table 13.1";
proc tabulate data=A;
   class gender baseage occasion;
   var obesity ;
   table  (gender * baseage), (occasion * obesity) * (mean) ;
run;

proc tabulate data=A;
   class  gender baseage occasion;
   var    obesity ;
   table  (gender * baseage), (occasion * obesity) * (n) ;
run;

***************************************************;

title2 "Count # obs per subject";
proc freq data = A;
  table id / noprint out = B;
  run;
proc freq data = B;
  table   count;
  run;

*********************************************************************;
data B;
  set A; by id;
  if first.id;
  run;

proc freq data = B;
  table gender * baseage;
  run;

*********************************************************************;

title2 "Response patterns";

data A1 (keep = id y1) 
     A2 (keep = id y2)
     A3 (keep = id y3) ;
  set A;
  y1 = obesity;
  y2 = obesity;
  y3 = obesity;
  if occasion = 1 then output A1; else
  if occasion = 2 then output A2; else
  if occasion = 3 then output A3;
  run;

data A123;
  merge A1 A2 A3; by id;
  run;

proc freq data = A123;
  table y1 * y2 * y3 / missing noprint out = B123;
  run;

proc sort  data = B123; by descending count; run;

proc print data = B123;
  var y1 y2 y3  count;
  sum count;
  run;

proc freq data = A123 order=freq;
  table y1 * y2 * y3 / missing list;
  title2 "With order=freq and the list option";
  run;

*********************************************************************;

title2 "1. Table 13.2";
proc genmod descending data = A;
     class id occasion;  
     model obesity = gender cage cage2   gender * cage   gender * cage2
          / dist = bin link = logit;
     contrast "Age X Gender Interaction"
              gender * cage 1, gender * cage2 1 / wald;
     repeated subject = id / withinsubject = occasion logor = fullclust;
run;

*********************************************************************;

title2 "2. Table 13.3";
proc genmod descending data = A;
     class id occasion;  
     model  obesity = gender cage cage2 / dist = bin link = logit covb;
     repeated subject = id / withinsubject = occasion logor = fullclust;
run;

*********************************************************************;

title2 "3. Table 13.4";
proc genmod descending data = A;
  class id occasion;  
  model  obesity = gender cage cage2 / dist = bin link = logit;
  repeated subject = id / withinsubject=occasion 
      logor = zrep( (1 2) 1 0,
                    (1 3) 0 1,
                    (2 3) 1 0);
run;

*********************************************************************;

title2 "4. Table 13.5";
proc genmod descending data = A;
  class id occasion;
  model  obesity = gender cage cage2 cage3 / dist = bin link = logit;
  repeated subject = id / withinsubject = occasion logor = fullclust corrb;
run;


