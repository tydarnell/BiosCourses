/***************************/
/*BIOS 667 HW 4 Question 2 */
/*Cheynna Crowley          */
/* Due November 13         */
/***************************/
%LET job=BIOS667_HW4;
%LET onyen=cacrowle;
%LET outdir=\\Client\H$\Desktop\Fall2017\BIOS667;

OPTIONS NODATE MERGENOBY=WARN VARINITCHK=WARN LS=72 FORMCHAR="|----|+|---+=|-/\<>*" ;
ODS PDF FILE="&outdir\&job._&onyen..PDF" STYLE=JOURNAL;
*Step 1: Read in TLC data;
filename INF   "\\Client\H$\Desktop\Fall2017\BIOS667\fat160.dat";
data FAT;
  infile INF firstobs = 2;
  input id age agemen time pbf;
  time_0 = max(time, 0); *0;
  time_0n = min(time, 0);
  label
    id     = "Subject ID"
    age    = "Current Age (years)"
    agemen = "Age at menarche (years)"
    time   = "Time relative to Menarche (years)"
    pbf    = "Percent Body Fat"
  ;
  run;



 *fit a linear mixed model with intercept B1, slope B2 before menarche  and slope after menarche B3
;

 proc mixed data = fat method = reml noclprint  = 10 covtest;
 class id;
 model pbf = time_0  time_0n / s  outp = OUTP  outpm=outpm;
 random intercept time_0  time_0n
          / subject = id type = un g v = 14 vcorr = 14;
     run;

*create a table For subject with ID 14, report a table with 4 columns;
*the observation times (relative to menarche),
the observed values, the ftted values and the subject-specfic predicted values.;
*pm is fitted values, and p is subject specific.
*fix mixed model dataset;
data outp2;
set outp;
if id=14;
pred_p=pred;
StdErrPred_p=StdErrPred;
keep id time pbf pred_p StdErrPred_p;
run;

proc sort data=outp2;
by id time pbf;
run;

data outpm2;
set outpm;
if id=14;
pred_pm=pred;
StdErrPred_pm=StdErrPred;
keep id time pbf pred_pm StdErrPred_pm;
run;
proc sort data=outpm2;
by id time pbf;
run;

data print;
merge outp2 outpm2;
by id time pbf;
run;

proc print data=print;
run;

PROC SGPLOT DATA = print;
label pred_p ='Subject Specific Predicted Values';
label pred_pm='Fitted Values';
SERIES X = time Y = pbf;
SERIES X = time Y = pred_p;
SERIES X = time Y = pred_pm;
TITLE 'Subject 12 Observed, Fitted, Predicted Values';
  RUN;

  ods pdf close;
