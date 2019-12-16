%let progname = tlc32.sas;
%let pdfout   = tlc32.pdf;
* input: tlc.dat
* output:
* xref:
* does: Various regression models for d := y2 - y1
        Define y1 = baseline
        Define y2 = average of weeks 1, 4, 6.

*******************************************************************;
title1 "&progname Treatment of Lead Exposed Children (TLC) Trial";
title2 "d := (week1 + week4 + week6) / 3  - week0";

filename INF "tlc.dat";
ods pdf file="&pdfout";
*******************************************************************;

data A;
  infile INF  firstobs=2;
  input    id group $  week0 week1 week4 week6;
  y1 = week0;   * baseline;
  y2 = (week1 + week4 + week6) / 3;   * post-baseline mean;
  d  = y2 - y1;
  label 
    id    = "Subject ID"
    group = "Treatment group (P=Placebo, A=Succimer)"
    week0 = "Week 0 blood lead level (æg/dL)"
    week1 = "Week 1 blood lead level (æg/dL)"
    week4 = "Week 4 blood lead level (æg/dL)"
    week6 = "Week 6 blood lead level (æg/dL)"
    y1    = "Baseline"
    y2    = "Post-baseline mean"
    d     = "Change, post - baseline"
  ;
  run;

proc sort data = A; by group; run;

proc corr data = A cov;
  var y1 y2;
  by group; 
  run;

proc genmod data = A;
  model d = y1;
  by group;
  title2 "0. d = y1,  by group";
  ;
  run;

proc genmod data = A;
  class group (ref="P");
  model d = group;
  title2 "1. d = group";
  run;

proc genmod data = A;
  class group;
  model d = group  y1 ;
  title2 "2. d = group   y1";
  run;

proc genmod data = A;
  class group;
  model y2 = group  y1 ;
  title2 "3. y2 = group   y1";
  run;


proc genmod data = A;
  class group;
  model d = group y1 (group)  ;
  title2 "4. d = group  y1 (group), equivalent to group | y1 ";
  run;

proc genmod data = A;
  class group;
  model d = group | y1 ;
  title2 "5. d = group | y1 ";
  run;

  run;
