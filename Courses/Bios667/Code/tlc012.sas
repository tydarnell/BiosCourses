%let progname = tlc012.sas;
%let pdfout   = tlc012.pdf;

* input: tlc.dat
* output:
* xref:
* does: The TLC Trial
        A mixed model with random intercept and slope

*******************************************************************;
title1 "&progname Treatment of Lead Exposed Children (TLC) Trial";

filename INF   "tlc.dat";
ods pdf file = "&pdfout";

*******************************************************************;

data A;
  infile INF  firstobs=2;
  input id group $ lead0 lead1 lead4 lead6;
  baseline = lead0;
  lead = lead0; time = 0; output;
  lead = lead1; time = 1; output;
  lead = lead4; time = 4; output;
  lead = lead6; time = 6; output;
  keep id group time lead;
  label lead = "Blood lead level (ug/dL)";
  label time = "Time (week)";
  run;

data A;
  set A;
  timefactor = time;
  run;
 
proc sort data = A; by group id time; run;

*******************************************************************;

title2 "1. Mixed model, random intercept, by group";
proc mixed data = A;
  class  id timefactor;
  model  lead = timefactor / s ;
  random intercept / subject = id type = un g gcorr v vcorr;
  by group;
  run;

*******************************************************************;

title2 "2. Mixed model, random intercept and slope, by group";
proc mixed data = A;
  class  id timefactor;
  model  lead = timefactor / s ;
  random intercept time / subject = id type = un g gcorr v vcorr;
  by group;
  run;

