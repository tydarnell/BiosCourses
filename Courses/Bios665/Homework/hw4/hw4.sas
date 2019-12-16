*Problem 1;
data mot;
input initial $ location $ response $ count;
datalines;
none east low 62
none east med 70
none east high 65
none mw low 67
none mw med 78
none mw high 68
none west low 35
none west med 21
none west high 18
low east low 19
low east med 14
low east high 15
low mw low 19
low mw med 27
low mw high 24
low west low 45
low west med 33
low west high 24
avg east low 21
avg east med 22
avg east high 19
avg mw low 50
avg mw med 38
avg mw high 29
avg west low 19
avg west med 14
avg west high 15
;
run;

proc print data=mot;
run;

proc logistic descending order=data data=mot;
freq count;
class initial (ref="none") location (ref="east") /param=reference;
model response = initial location / scale=none aggregate;
run;

*Problem 2;
proc logistic descending order=data data=mot;
freq count;
class initial (ref="none") location (ref="east") /param=reference;
model response(ref='med') = initial location / link=glogit scale=none aggregate;
run;

*high vs low;
proc logistic descending order=data data=mot;
freq count;
class initial (ref="none") location (ref="east") /param=reference;
model response(ref='low') = initial location / link=glogit scale=none aggregate;
run;

*Problem 3;
data drug;
input treat $ dose response count @@;
int_a=(treat='a');
int_b=(treat='b');
ldose=log(dose);
datalines;
a 1 1 20   a 1 0 65
a 10 1 31  a 10 0 54
a 100 1 47 a 100 0 38
b 2 1 19   b 2 0 66
b 20 1 36  b 20 0 49
b 200 1 60 b 200 0 25
;
run; 

proc print data=drug;
run;

data druga;
set drug;
lndose=log(dose);
run;

proc logistic data=druga descending;
where treat='a';
freq count;
model response = lndose lndose*lndose / scale=none
aggregate selection=forward include=1 details covb;
run;

data drugap;
input treat $ dose fav total @@;
 ia=(trt='a');
 ib= (trt='b');
ldose = log(dose);
datalines;
a 1 20 85
a 10 31 85
a 100 47 85
;
run;

ods graphics on;
proc probit data=drugap log plot=ippplot;
model fav/total = dose / lackfit
inversecl (prob=.25 .50 .75);
run;
ods graphics off;

*part b;
proc logistic data=drug descending;
freq count;
model response = int_a int_b
ldose * int_a ldose * int_b
ldose * int_a * ldose * int_a
ldose * int_b * ldose * int_b
/ noint
scale=none aggregate
include=4 selection=forward details;
eq_slope: test int_aldose=int_bldose;
run;

*Proc iml;
proc logistic data=drug descending outest=estimate
(drop= intercept _link_ _lnlike_) covout;
freq count;
model response = int_a int_b ldose /
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


*problem 4;
data birth;
input age $ order $ cases total @@;
ltotal=log(total)-log(100000);
datalines;
20-24 1 128 329462 20-24 2 152 326735 20-24 3 71 175682
25-29 1 54 114987 25-29 2 112 208692 25-29 3 101 207060
30-34 1 41 39473 30-34 2 79 83224 30-34 3 109 117312
35-39 1 38 14202 35-39 2 89 28478 35-39 3 99 45015
40+   1 22 3046 40+    2 44 5381 40+    3 83 8654
;
run;

proc genmod data=birth;
class age (ref='20-24') order (ref='1') / param=ref;
model cases = age order / dist=poisson link=log offset=ltotal;
run;
