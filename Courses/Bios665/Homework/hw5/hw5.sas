*Problem 1;
data q1;
input interval treatment $ censor count @@;
datalines;
0 exper 1 2 0 exper 0 2
1 exper 1 1 1 exper 0 3
2 exper 1 9 2 exper 0 9
3 exper 1 17 3 exper 0 17
4 exper 1 58 
0 exist 1 3 0 exist 0 3
1 exist 1 2 1 exist 0 5
2 exist 1 7 2 exist 0 14
3 exist 1 12 3 exist 0 35
4 exist 1 37 
;
run;

proc lifetest data=q1 method=lt plots=(s,ls)
intervals=0 to 4 by 1;
freq count;
strata treatment;
time interval*censor(1);
run;

ods graphics on;
proc lifetest data=medical method=lt plots=(s,ls)
intervals=0 to 3 by 1;
freq count;
strata treatment;
time interval * censor(1);
ods output Lifetest.Stratum1.LifetableEstimates=my
(keep=STRATUM treatment LowerTime UpperTime Survival StdErr);
ods output Lifetest.Stratum2.LifetableEstimates=my2
(keep=STRATUM treatment LowerTime UpperTime Survival StdErr);
run;
ods graphics off;
data all;
set my my2;
run;
proc print data=all noobs;
run;


*Problem 2;

data q2;
input time $ treatment $  nmonth count;
datalines;
_0-6 exst 690 3
_0-6 exper 696 2
6-12 exst 651 5
6-12 exper 672 3
12-18 exst 567 14
12-18 exper 606 9
18-24 exst 363 35
18-24 exper 450 17
;
run;

proc logistic data=q2;
class treatment time/param=ref;
model count/nmonth=time treatment time*treatment /scale=none;
run;

proc logistic data=q2  ;
class treatment time/param=ref;
model count/nmonth=time treatment /scale=none;
Oddsratio treatment;
run;

*Problem 3;
data Q3;
set 'C:\Users\tydar\Documents\Bios665\Homework\hw5\repeated.sas7bdat';
run;

proc print data=Q3;
run;

proc genmod data=Q3 ;
class id time(ref='2') base(ref='Good') age_group(ref='15-24') drug(ref='1');
model health =drug time base age_group age_group*time /link=logit dist=bin type3;
repeated subject=id / type=exch covb corrw;
run;

/*Use 15-24 year old women in the control group with a 
good health assessment at randomization as your reference group, 
and use 3 months post-randomization as your reference visit.  
model health =drug(ref=1) time(ref=2) base(ref='Good') age_group(ref='15-24') 
*/

proc genmod data=Q3 ;
class id time(ref='2') base(ref='Good') age_group(ref='15-24') drug(ref='1');
model health =drug time base age_group 
drug*time drug*base drug*age_group time*base time*age_group base*age_group /link=logit dist=bin type3;
repeated subject=id / type=exch covb corrw;
run;

*final model;
proc genmod data=Q3 ;
class id time(ref='2') base(ref='Good') age_group(ref='15-24') drug(ref='1');
model health =drug time base age_group /link=logit dist=bin type3;
repeated subject=id / type=exch covb corrw;

run;
