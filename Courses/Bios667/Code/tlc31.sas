%let progname = tlc31.sas;
* input: tlc.dat
* output:
* xref:
* does: descriptive statistics

*******************************************************************;
title1 "&progname Treatment of Lead Exposed Children (TLC) Trial";
filename INF "tlc.dat";
%let pdfout = tlc31.pdf;
*******************************************************************;

data A;
  infile INF  firstobs=2;
  input id group $ lead0 lead1 lead4 lead6;
  label 
    id    = "Subject ID"
    group = "Treatment group (P=Placebo, A=Succimer)"
    lead0 = "Week 0 blood lead level (æg/dL)"
    lead1 = "Week 1 blood lead level (æg/dL)"
    lead4 = "Week 4 blood lead level (æg/dL)"
    lead6 = "Week 6 blood lead level (æg/dL)"
  ;
  run;

proc sort data = A; by group; run;

ods pdf file="&pdfout";

proc corr data = A  cov;
  var lead0 lead1 lead4 lead6;
  by group;
  run;


********************************************************************************;

title2 "Summary: mean, sd, #obs";

proc summary data = A  nway;
  class group;
  var  lead0 lead1 lead4 lead6;
  output
    out  = B
    mean = lead0 lead1 lead4 lead6
    std  = std0  std1  std4  std6
    n    = n0    n1    n4    n6
  ;
  run;

proc print   data = B;
  var group  lead0 lead1 lead4 lead6 ;
  run;

proc print   data = B;
  var group  n0 n1 n4 n6 std0  std1  std4  std6 ;
  run;

********************************************************************************;

* use proc tabulate;
proc tabulate data=A;
   class group;
   var lead0 lead1 lead4 lead6;
   table group, (lead0 lead1 lead4 lead6) * (n mean median qrange std) ;
run;


* transposed;
proc tabulate data=A;
   class group;
   var lead0 lead1 lead4 lead6;
   table (lead0 lead1 lead4 lead6), group * (n mean median qrange std) ;
run;

ods pdf close;
