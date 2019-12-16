%let progname = fat000.sas;
%let pdfout   = fat000.pdf;

* input: fat.dat
* output:
* xref:
* does:
        MIT Growth and Development Study, descriptive

*******************************************************************;
title "&progname: MIT Growth and Development Study";

filename INF  "fat.dat";
ods pdf file = "&pdfout";
*******************************************************************;

data A;
  infile INF firstobs = 2;
  input id age agemen time pbf;
  time_0 = max(time, 0);

  label
    id     = "Subject ID"
    age    = "Current Age (years)"
    agemen = "Age at menarche (years)"
    time   = "Time relative to Menarche (years)"
    pbf    = "Percent Body Fat"
  ;
  run;

title2 "Summaries, time span,  observations per subject";

proc means data = A;
  run;

proc univariate data = A; var pbf; run;

proc summary data = A nway;
  var time;
  class id;
  output out = B1 mean=tmean min=tmin max=tmax n=n;
  run;

data B1;
  set B1;
  tspan = tmax - tmin;
  label
    n      = "Observations per subject"
    tmin   = "Min time (years)"
    tmax   = "Max time (years)"
    tmean  = "Mean time (years)"
    tspan  = "Total followup time (years)"
  ;
  run;

proc means data = B1;
  var tmean tmin tmax tspan n;
  run;

proc freq data = B1;
  table  n;
  run;
