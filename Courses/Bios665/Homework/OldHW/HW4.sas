**************************************************************
Title: Bios 665 HW 4
Name: Cheynna Crowley
Date Due: 10/05/17
Output: BIOS665_HW4.cacrowle
**************************************************************;
%LET job=BIOS665_HW4;
%LET onyen=cacrowle;
%LET outdir=\\Client\H$\Desktop\Fall2017\BIOS665\HW;

OPTIONS NODATE MERGENOBY=WARN VARINITCHK=WARN LS=72 FORMCHAR="|----|+|---+=|-/\<>*" ;
ODS PDF FILE="&outdir\&job._&onyen..PDF" STYLE=JOURNAL;


/*Read in Data*/
data Q1;
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

proc print data=Q1;
run;

/*Question 1*/
title'Question 1';
proc logistic data=Q1 order=data;
freq count;
class edu region /param=reference;
model agree = edu region / scale=none aggregate;
run;

/*Question 2*/
title'Question 2A and 2B';
proc logistic data=Q1 order=data;
freq count; 
class edu region/param=ref; 
model agree(ref='neu')= edu region/link=glogit scale=none aggregate; 
run;

title'Question 2 C';
proc logistic data=Q1 order=data;
freq count; 
class edu region/param=ref; 
model agree(ref='dis')= edu region/link=glogit scale=none aggregate; 
run;


/*Question 3*/

data Q3;
input trt $ dose favor $ count @@;
datalines;
A 1 fav 21 A 1 unfav 39
A 10 fav 24 A 10 unfav 36
A 100 fav 42 A 100 unfav 18
B 1 fav 23 B 1 unfav 37
B 10 fav 31 B 10 unfav 29
B 100 fav 50 B 100 unfav 10
;
run;

data Q3_a;
set Q3;
log_dose=log10(dose);
run;

title'Question 3A i';
proc logistic data=Q3_a descending;
where trt='A';
freq count;
model favor = log_dose / scale=none
aggregate selection=forward include=1 details covb;
run;



data Q3_b;
input trt $ dose fav total @@;
 i_A=(trt='A');
 i_B= (trt='B');
ldose = log(dose);
datalines;
A 1 21 60
A 10 24 60
A 100 42 60
;
run;
title 'Question 3A ii';
ods graphics on;
proc probit data=Q3_b log10 plot=ippplot;
where trt='A';
model fav/total = dose / dist=logistic lackfit
inversecl (prob=.25 .50 .75);
run;
ods graphics off;

title 'Question 3A iii';
ods graphics on;
proc probit data=Q3_b log10 plot=ippplot;
where trt='A';
model fav/total = dose / lackfit
inversecl (prob=.25 .50 .75);
run;
ods graphics off;

title'Question 3B';

data q3_B;
 input trt $ dose resp $ count @@;
 i_A=(trt='A');
 i_B= (trt='B');
 ldose=log10(dose);
 datalines;
A 1 fav 21 A 1 1unfav 39
A 10 fav 24 A 10 1unfav 36
A 100 fav 42 A 100 1unfav 18
B 2 fav 23 B 2 1unfav 37
B 20 fav 31 B 20 1unfav 29
B 200 fav 50 B 200 1unfav 10
;
run;


proc logistic data=q3_B descending;
 freq count;
 model resp=i_a i_b ldose*i_a ldose*i_b / noint scale=none aggregate 
 covb;
 contrast "equal slope" ldose*i_A 1 ldose*i_B -1;
run;


/*Question 3 B iii*/
title 'Question 3B iii';
proc logistic data=q3_b descending outest=estimate
(drop= intercept _link_ _lnlike_) covout;
freq count;
model resp = i_a i_b ldose /
noint scale=none aggregate covb;
run;

proc iml;
  use estimate;
  start fieller;
  title 'Confidence Intervals';
  use estimate;
  read all into beta where (_type_='PARMS');
  beta=beta`;
  read all into cov where (_type_='COV');
  ratio=(k`*beta)/(h`*beta);
  expratio=exp(ratio);
  a=(h`*beta)**2-(3.84)*(h`*cov*h);
  b=2*(3.84*(k`*cov*h)-(k`*beta)*(h`*beta));
  c=(k`*beta)**2-(3.84)*(k`*cov*k);
  disc=((b**2-4*a*c));
  if (disc <= 0 | a <= 0) then do;
    print "Confidence Interval Cannot Be Computed", ratio;
    stop;
  end;
  sroot=sqrt(disc);
  l_b=((-b)-sroot)/(2*a);
  u_b=((-b)+sroot)/(2*a);
  exp_l_b=exp(l_b);
  exp_u_b=exp(u_b);
  interval=l_b||u_b;
  exp_int=exp_l_b||exp_u_b;
  lname={"L_BOUND","U_BOUND"};
  k_prime=k`;
  h_prime=h`;
  print "95% Confidence Interval for Ratio Based on Fieller",
        k_prime, h_prime, ratio, interval[colname=lname];
  print "95% Confidence Interval for exp(Ratio) Based on Fieller",
        k_prime, h_prime, expratio, exp_int[colname=lname];
  finish fieller;
  k={1 -1 0}`;
  h={0 0 1}`;
  run fieller;
  k={-1 0 0}`;
  h={ 0 0 1}`;
  run fieller;
  k={0 -1 0}`;
  h={0  0 1}`;
  run fieller;
  k={-1 -1 0}`;
  h={0 0 1}`;
  run fieller;


/*Question 4*/

data Q4;
input mat_age $ birth_order $ disorder total ;
datalines;
20-24 1 128 329462
20-24 2 152 326735
20-24 3 71 175682
25-29 1 54 114987
25-29 2 112 208692
25-29 3 101 207060
30-34 1 41 39473
30-34 2 79 83224
30-34 3 109 117312
35-39 1 38 14202
35-39 2 89 28478
35-39 3 99 45015
40 1 22 3046
40 2 44 5381
40 3 83 8654
;
run;
data Q4_a;
set Q4;
total_per=total/100000;
ltotal=log(total_per);
run;
*mat_age $ birth_order $ disorder;
*proc contents data=Q4;
*run;


proc genmod data=Q4_a;
class mat_age (ref='20-24') birth_order (ref='1')/param=ref;
model disorder  = mat_age birth_order / dist=poisson
link=log offset=ltotal;
run;
