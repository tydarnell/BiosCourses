**************************************************************
Title: Bios 665 HW 3
Name: Cheynna Crowley
Date Due: 10/05/17
Output: BIOS665_HW3.cacrowle
**************************************************************;




%LET job=BIOS665_HW3;
%LET onyen=cacrowle;
%LET outdir=\\Client\H$\Desktop\Fall2017\BIOS665\HW;

OPTIONS NODATE MERGENOBY=WARN VARINITCHK=WARN LS=72 FORMCHAR="|----|+|---+=|-/\<>*" ;
ODS PDF FILE="&outdir\&job._&onyen..PDF" STYLE=JOURNAL;


/*Question 1*/
title'Question 1';
data soft;
input gender $ trt $ headache $ count @@;
datalines;
male Exp y 22 male Exp n 34
male Plac y 37 male Plac n 18
female Exp y 19 female Exp n 37
female Plac y 37 female Plac n 20
;
run;

proc freq data=soft order=data;
weight count;
tables gender*trt*headache / chisq cmh nocol nopct;
run;

proc freq data=soft order=data;
weight count; 
where gender='female';
tables trt*headache / chisq cmh nocol nopct;
run;


/*Question 2*/
title'Question 2';
data drink;
input gender $ response $ count @@;
datalines;
male UN 15 female UN 15 
male NEU 30 female NEU 25
male FAV 55 female FAV 60
;
run;

proc freq data=drink order=data;
weight count;
table gender*response / cmh chisq nocol nopct;
run;


proc freq data=drink order=data;
weight count;
table gender*response / cmh chisq nocol nopct
scores=rank;
run;



proc freq data=drink order=data;
weight count;
table gender*response / cmh chisq nocol nopct
scores=modridit;
run;


/*Question 3*/
title'Question 3';
data Q3;
input center $ trt $ response $ count @@;
datalines;
c1 Test good 32 c1 Test poor 11
c1 Plac good 23 c1 Plac poor 20
c2 Test good 29 c2 Test poor 5
c2 Plac good 15 c2 Plac poor 17
;
run;


proc freq data=Q3 order=data;
weight count;
tables center*trt*response / all nocol nopct;
run;

proc freq data=Q3 order=data;
weight count;
tables center*trt*response / all nocol nopct
scores=modridit;
run;

ods pdf close;
