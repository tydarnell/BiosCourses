%let progname = tlc013.sas;
%let pdfout   = tlc013.pdf;

* input: tlc.dat
* output:
* xref:
* does: The TLC Trial
        Sensitivity to extreme values
        Group "A" only
        63.9 -> 36.9
        "between" estimate changes from 27.8 to 27.1
        "within"  estimate changes from 30.0 to 22.5
        "Intercept" estimate changes from 20.76 to 20.22

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

data A1;
  set A;
  timefactor = time;
  if (group = "A");
  run;
 
data A2;
  set A1;
  if (lead  = 63.9) then lead = 36.9;
  run;
 
*******************************************************************;

title2 "1. Original data, random intercept";
proc mixed data = A1;
  class  id timefactor;
  model  lead = timefactor / s ;
  random intercept / subject = id type = un g gcorr v vcorr;
  run;

*******************************************************************;

title2 "2. Value 63.9 changed to 36.9, random intercept";
proc mixed data = A2;
  class  id timefactor;
  model  lead = timefactor / s ;
  random intercept / subject = id type = un g gcorr v vcorr;
  run;

