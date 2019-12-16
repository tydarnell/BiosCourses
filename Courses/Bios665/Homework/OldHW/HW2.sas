
**************************************************************
Title: Bios 665 HW 2
Name: Cheynna Crowley
Date Due: 9/28/17
Output: BIOS665_HW2.cacrowle
**************************************************************;
%LET job=BIOS665_HW2;
%LET onyen=cacrowle;
%LET outdir=\\Client\H$\Desktop\Fall2017\BIOS665\HW;

OPTIONS NODATE MERGENOBY=WARN VARINITCHK=WARN LS=72 FORMCHAR="|----|+|---+=|-/\<>*" ;
ODS PDF FILE="&outdir\&job._&onyen..PDF" STYLE=JOURNAL;

*Question 1;
data Q1; 
input res stress ca count @@;
*residence: 0=Urban 1=Rural; 
*stress: 0=Low 1=Medium 2=High;
* 0=unfavorable 1=favorable;
datalines;
0 0 0 20	0 0 1 64
0 1 0 50	0 1 1 76
0 2 0 100	0 2 1 122
1 0 0 30	1 0 1 55
1 1 0 60	1 1 1 68
1 2 0 90	1 2 1 115
; 
run;

*Q1b:
Provide a quantity that expresses the effect of high stress
(as compared to low stress) on favorable response (vs. unfavorable response),
and provide a 99% two-sided confidence interval for this quantity.
How would you estimate this quantity and its 99% confidence interval by hand,
given the computer output?  Show your calculations.;

ods graphics on;
title 'Question 1b: effect of high stress compared to low stress';
proc logistic data=Q1 alpha=0.01;
freq count;
class res(ref=first) stress (ref=first) / param=ref;
model ca (event=last) = stress res /scale=none aggregate clparm=wald alpha=0.01; 
oddsratio stress/ cl=both ;
run;

*Q1d: 
Provide predicted probabilities for favorable response for each of the following:
a.	An individual from an urban area with low stress.
b.	An individual from a rural area with medium stress.;
title 'Question 1d: Find Predicted Probabilities';
proc logistic data=Q1 ;
freq count; 
class res(ref=first) stress (ref=first);
model ca (event=last) = res stress; 
output out=predict pred=prob;
run; 
proc print data=predict;
run;

*Question 3;
data Q3_cat; 
input dose $ ca count @@;
*dose: 1=low(1Mg) 2=Med (10MG) 3=High (100MB); 
* 0=unfavorable 1=favorable;
datalines;
dose1 0	39 	dose1 1 21
dose10 0 36 dose10 1 24
dose100 0 18 dose100 1 42
; 
run;

*Use logistic regression to describe the relationship
between favorable response (vs. unfavorable response) and dose;
*a.	Mathematically specify the model, treating dose as categorical, and interpret the parameters.
Use dose=1 mg as the reference group.;
title'Q3ai: Specify the Model with Dose Categorical';
proc logistic data=Q3_cat alpha=0.05;
freq count;
class dose (ref='dose1') / param=ref;
model ca(event=last)=dose ;
run;

*ii.Now, re-specify the model mathematically, treating dose as continuous and using a log10 transformation.
Interpret these model parameters.;
title'Question 3aii: Dose Continuous and log10 Transform';
data Q3_cont; 
input dose ca count @@;
*dose: 1=low(1Mg) 2=Med (10MG) 3=High (100MB); 
* 0=unfavorable 1=favorable;
datalines;
1 0	39 1 1 21
10 0 36 10 1 24
100 0 18 100 1 42
; 
run;

data Q3_cont1;
set Q3_cont;
doselog=log10(dose);
run;

proc logistic data=Q3_cont1;
freq count;
model ca (event='1')=doselog;
run;

ods pdf close;
