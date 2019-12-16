**************************************************************
Title: Bios 665 HW 5
Name: Cheynna Crowley
Date Due: 11/28/17
Output: BIOS665_HW5.cacrowle
**************************************************************;
%LET job=BIOS665_HW5;
%LET onyen=cacrowle;
%LET outdir=\\Client\H$\Desktop\Fall2017\BIOS665\HW;

OPTIONS NODATE MERGENOBY=WARN VARINITCHK=WARN LS=72 FORMCHAR="|----|+|---+=|-/\<>*" ;
ODS PDF FILE="&outdir\&job._&onyen..PDF" STYLE=JOURNAL;


/*Read in Data*/
data Q1;
input interval treatment $ censor count @@;
datalines;
0 exper 1 2 0 exper 0 1
1 exper 1 1 1 exper 0 2
2 exper 1 10 2 exper 0 8
3 exper 1 15 3 exper 0 17
4 exper 1 60 
0 exist 1 2 0 exist 0 2
1 exist 1 2 1 exist 0 5
2 exist 1 7 2 exist 0 14
3 exist 1 10 3 exist 0 35
4 exist 1 39 
;
run;

ods graphics on;
proc lifetest data=Q1 method=lt plot=(s,ls) interval=0 to 4 by 1;
freq count;
strata treatment;
time interval*censor(1);
ods output Lifetest.Stratum1.LifeTableEstimates=my (keep=STRATUM treatment LowerTime UpperTime Survival StdErr);
ods output Lifetest.Stratum2.LifeTableEstimates=my2 (keep=STRATUM treatment LowerTime UpperTime Survival StdErr);
run;
ods graphics off;

data all;
set my my2;
run;
proc print data=all noobs;
run;

/*Question 1c*/

data q1c;
input time $ treatment $ status $ count @@;
datalines;
0-6 exist caries 2 0-6 exist noc  112
0-6 exper caries 1 0-6 exper noc 113
6-12 exist caries 5 6-12 exist noc 105
6-12 exper caries 2 6-12 exper noc 110
12-18 exist caries 14 12-18 exist noc 84
12-18 exper caries 8 12-18 exper noc 92
18-24 exist caries 35 18-24 exist noc 39
18-24 exper caries 17 18-24 exper noc 60
;
run;

proc freq data=q1c order=data;
weight count;
tables time*treatment*status /cmh;
run;

/*Question 2*/
data q2;
input time $ treatment $  nmonth count;
datalines;
_0-6 exst 684 2
_0-6 exper 687 1
6-12 exst 651 5
6-12 exper 669 2
12-18 exst 567 14
12-18 exper 606 8
18-24 exst 369 35
18-24 exper 456 17
;
run;
proc contents data=q2;
run;

proc logistic data=q2;
class treatment time/param=ref;
model count/nmonth=time treatment time*treatment /scale=none;
run;
/*question 3b*/
proc logistic data=q2;
class treatment time/param=ref;
model count/nmonth=time treatment time*treatment /scale=none ;
run;

/*question 2c*/
proc logistic data=q2  ;
class treatment time/param=ref;
model count/nmonth=time treatment /scale=none;
Oddsratio treatment;
run;

/*Question 3*/
/*Read in data*/
data Q3;
set '\\Client\H$\Desktop\Fall2017\BIOS665\repeated.sas7bdat';
run;

proc genmod data=Q3 ;
class id time(ref='2') base(ref='Good') age_group(ref='15-24') drug(ref='1');
model health =drug time base age_group /link=logit dist=bin type3;
repeated subject=id / type=exch covb corrw;
run;
/*Use 15-24 year old women in the control group with a 
good health assessment at randomization as your reference group, 
and use 3 months post-randomization as your reference visit.  
model health =drug(ref=1) time(ref=2) base(ref='Good') age_group(ref='15-24') 
*/


/*question 3b*/
proc genmod data=Q3 ;
class id time(ref='2') base(ref='Good') age_group(ref='15-24') drug(ref='1');
model health =drug time base age_group 
drug*time drug*base drug*age_group time*base time*age_group base*age_group /link=logit dist=bin type3;
repeated subject=id / type=exch covb corrw;
run;


proc genmod data=Q3 ;
class id time(ref='2') base(ref='Good') age_group(ref='15-24') drug(ref='1');
model health =drug time base age_group drug*time drug*base drug*age_group  /link=logit dist=bin type3;
repeated subject=id / type=exch covb corrw;
run;

proc genmod data=Q3 ;
class id time(ref='2') base(ref='Good') age_group(ref='15-24') drug(ref='1');
model health =drug time base age_group drug*time drug*base/link=logit dist=bin type3;
repeated subject=id / type=exch covb corrw;
run;

proc genmod data=Q3 ;
class id time(ref='2') base(ref='Good') age_group(ref='15-24') drug(ref='1');
model health =drug time base age_group drug*time/link=logit dist=bin type3;
repeated subject=id / type=exch covb corrw;
run;

/*Question 3c*/

proc genmod data=Q3 ;
class id time(ref='2') base(ref='Good') age_group(ref='15-24') drug(ref='1');
model health =drug time base age_group /link=logit dist=bin type3;
repeated subject=id / type=exchange;
estimate 'OR: Treatment' drug 1 -1 /exp;
lsmeans/pdiff exp cl;
run;

/*Question 4*/

data Q4;
input edu $ region $ agree $ count;
datalines;
col west agree 48
col west neu 15
col west dis 18
col mid agree 21
col mid neu 19
col mid dis 13
col east agree 52
col east neu 28
col east dis 28
hs west agree 24
hs west neu 23
hs west dis 46
hs mid agree 21
hs mid neu 20
hs mid dis 22
hs east agree 23
hs east neu 18
hs east dis 48
lt_hs west agree 28
lt_hs west neu 15
lt_hs west dis 13
lt_hs mid agree 17
lt_hs mid neu 16
lt_hs mid dis 15
lt_hs east agree 24
lt_hs east neu 17
lt_hs east dis 15
;
run;

proc freq data=Q4;
weight count;
tables edu*agree/cmh;
run;

data Q4_c;
input edu $ region $ agree $ count;
datalines;
3 west 3 48
3 west 2 15
3 west 1 18
3 mid 3 21
3 mid 2 19
3 mid 1 13
3 east 3 52
3 east 2 28
3 east 1 28
2 west 3 24
2 west 2 23
2 west 1 46
2 mid 3 21
2 mid 2 20
2 mid 1 22
2 east 3 23
2 east 2 18
2 east 1 48
1 west 3 28
1 west 2 15
1 west 1 13
1 mid 3 17
1 mid 2 16
1 mid 1 15
1 east 3 24
1 east 2 17
1 east 1 15
;
run;
proc freq data=Q4_c;
weight count;
tables edu*agree/cmh;
run;
