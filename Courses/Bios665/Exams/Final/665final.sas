*Bios 665 Final;

*read in sas table for parts 2 and 3;
data falls;
set 'C:\Users\tydar\Documents\Bios665\Exams\Final\falls.sas7bdat';
run;

*******Part 1********;
data p1;
input treat $ sex $ event $ count;
datalines;
p m none 16
p m mild 16
p m mod 12
p m sev 8
p w none 20
p w mild 16
p w mod 20
p w sev 10
l m none 7
l m mild 15
l m mod 26
l m sev 17
l w none 11
l w mild 16
l w mod 12
l w sev 21
h m none 9
h m mild 12
h m mod 12
h m sev 21
h w none 6
h w mild 16
h w mod 16
h w sev 21
;
run;

*Problem 1;

*make sure data was entered correctly;
proc freq data=p1 order=data;
weight count;
table treat*sex*event / nocol nopct;
run;

*dichotomize the data;
data q1;
retain sex dose mod_sev count;
set p1;
dose=0;
if treat="h" or treat="l" then dose=1;
mod_sev=0;
if event ="mod" or event="sev" then mod_sev=1;
keep sex dose mod_sev count;
run;

*problems 1 and 2;
proc freq data=q1;
weight count;
table sex*dose*mod_sev/nocol nopct chisq cmh(mf);
run;

*problem 3;
data q3;
retain sex treat none_mild count;
set p1;
mod_sev=0;
if event ="mod" or event="sev" then mod_sev=1;
keep sex treat mod_sev count;
run;

proc freq data=q3 order=data;
weight count;
table sex*treat*mod_sev / nocol nopct chisq cmh(mf);
run;

*problem 5;
data q5;
retain sex dose event count;
set p1;
dose=0;
if treat="h" or treat="l" then dose=1;
keep sex dose event count;
run;

proc freq data=q5 order=data;
weight count;
table sex*dose*event /cmh scores=modridit nopct norow;
run;

*problem 6;
proc freq data=p1 order=data;
weight count;
table sex*treat*event/nocol nopct chisq cmh;
run;

*problem 7;
proc freq data=q5 order=data;
weight count;
where sex="m";
table dose*event/cmh;
exact SCORR;
run;


proc freq data=q5 order=data;
weight count;
where sex="w";
table dose*event/cmh;
exact SCORR;
run;

*problem 8;
proc freq data=P1 order=data;
weight count;
where sex="m";
table treat*event/cmh;
exact SCORR;
run;


proc freq data=P1 order=data;
weight count;
where sex="w";
table treat*event/cmh;
exact SCORR;
run;


*Problem 9;
proc freq data=p1 order=data;
weight count;
where treat="p";
table sex*event /chisq nopct nocol;
run;

proc freq data=p1 order=data;
weight count;
where treat="l";
table sex*event /chisq nopct nocol;
run;

proc freq data=p1 order=data;
weight count;
where treat="h";
table sex*event /chisq nopct nocol;
run;

*problem 10;
data q10;
retain sex treat mod_sev count;
set p1;
mod_sev=0;
if event ="mod" or event="sev" then mod_sev=1;
keep sex treat mod_sev count;
run;

proc logistic descending data=q10;
freq count; 
class treat(ref='p') sex(ref='m') /param=ref; 
model mod_sev(ref="0")= treat sex /link=logit scale=none aggregate;
contrast 'high vs low' treat 1 -1 0;
output out=pred1 predicted=phat1;
run;


proc print data=pred1;
run;

*problem 14;
proc logistic descending order=data data=p1;
freq count; 
class treat sex(ref="m") /param=ref; 
model event= treat sex / scale=none aggregate;
output out=pred2 predicted=phat2;
run;

proc logistic descending order=data data=p1;
freq count; 
class treat sex(ref="m") /param=ref; 
model event= treat sex / scale=none aggregate  unequalslopes=treat;
run;

proc print data=pred2;
run;

*problem 17;
proc logistic data=p1 order=data;
freq count; 
class treat(ref='p') sex(ref='m') /param=ref; 
model event(ref='none')= treat sex /link=glogit scale=none aggregate; 
run;

*Part 2;

*problem 19;
data falls2;
set falls;
count=falls2+ falls4+ falls6+ falls8;
tribase=0;
if baseline0>5 and baseline0<10 then tribase=1;
if baseline0>10 then tribase=2;
improve= 0;
if count<baseline0 then improve=1;
run;

proc freq data=falls2 order=data;
weight count;
table tribase*treatment*improve / nocol nopct chisq cmh(mf);
run;

*problem 20;
proc genmod data=falls2;
class treatment(ref="0") tribase(ref="0") / param=ref;
model count = treatment tribase age / dist=poisson link=log scale=pearson type3;
run;

proc genmod data=falls2;
class treatment(ref="0") tribase(ref="0") / param=ref;
model count = treatment tribase age / dist=nb;
run;

*Part 3;

*Problem 23;
data falls3;
set falls;
tribase=0;
if baseline0>5 and baseline0<10 then tribase=1;
if baseline0>10 then tribase=2;
week4=falls2+ falls4;
week8= falls6+ falls8;
run;

data falls4;
set falls3;
time=1; y=week4; output;
time=2; y=week8; output;
keep subj treatment age tribase time y;
run;

*model with interaction terms;
proc genmod data=falls4 descending;
class subj treatment(ref="0") tribase(ref="0") time(ref="1") / param=ref;
model y = treatment tribase age time treatment*tribase treatment*age treatment*time / dist=poisson type3;
repeated subject=subj /type=exch covb corrw;
run;

*model with only treatment time interaction;
proc genmod data=falls4 descending;
class subj treatment(ref="0") tribase(ref="0") time(ref="1") / param=ref;
model y = treatment tribase age time treatment*time / dist=poisson type3;
repeated subject=subj /type=exch covb corrw;
estimate 'OR: Treatment' treatment 1 -1
treatment*time 1 -1/exp;
lsmeans/pdiff exp cl;
run;
