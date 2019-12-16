data rashd;
input high low gender rash count @@;
datalines;
1 0 0 1 16 1 0 0 0 32
1 0 1 1 21 1 0 1 0 37
0 1 0 1 16 0 1 0 0 49
0 1 1 1 27 0 1 1 0 27
0 0 0 1 34 0 0 0 0 22
0 0 1 1 39 0 0 1 0 15 
run;

proc print data=rashd;
run;


proc logistic descending data=rashd;
freq count;
model rash = high low gender gender*high gender*low;
contrast "contrast1" high 0 low 0 gender 0 gender*high 1 gender*low -1;

data rash2;
input dose $ gender $ rash $ count;
cards;
placebo male norash 34
placebo male rash 22
placebo female norash 39
placebo female rash 15
low male norash 16
low male rash 49
low female norash 27
low female rash 27
high male norash 16
high male rash 32
high female norash 21
high female rash 37
;

data rash3;
input dose gender rash count @@;
datalines;
2 0 1 16 2 0 0 32
2 1 1 21 2 1 0 37
1 0 1 16 1 0 0 49
1 1 1 27 1 1 0 27
0 0 1 34 0 0 0 22
0 1 1 39 0 1 0 15 
run;

proc logistic data=rash2;
oddsratio dose;
freq count;
class dose gender/param=ref;
model rash=dose|gender / aggregate;
run;



proc logistic data=rash3;
oddsratio dose;
class dose (ref="0") gender (ref="0");
freq count;
model rash=dose gender / aggregate;
run;

proc logistic data=rash2;
oddsratio dose;
freq count;
class dose (ref="placebo") gender (ref="male")/param=ref;
model rash(event="rash")=dose gender / aggregate;
run;


proc logistic data=rash2;
freq count;
class dose (ref="placebo") gender (ref="male")/param=ref;
model rash(event="rash")=dose gender;
output out=predict pred=prob;
run;

proc print data=predict;
run;

data health;
input west stress response count @@;
datalines;
0 0 1 53 	0 0 0 20
0 1 1 109 	0 1 0 97
0 2 1 85 	0 2 0 76
1 0 1 51 	1 0 0 37
1 1 1 67 	1 1 0 59
1 2 1 118 	1 2 0 92
;

proc logistic data=health order=freq;
freq count;
class west (ref="0") stress (ref="0") / param=ref;
model response(event="1")=west stress / scale=none aggregate;
oddsratio stress/ cl=both ;
run;

proc logistic data=health order=freq;
freq count;
class west (ref="0") stress (ref="0") / param=ref;
model response(event="1")=west|stress;
run;

proc logistic data=health order=freq;
freq count;
class west (ref="0") stress (ref="0") / param=ref;
model response(event="1")=west stress;
output out=predict pred=prob;
run;

proc print data=predict;
run;

data acc;
input gender $ before $ after $ count @@;
n_after=(after='acc');
datalines;
male acc acc 10 	male acc noacc 18
male noacc acc 2 	male noacc noacc 10
female acc acc 22 	female acc noacc 37
female noacc acc 15	female noacc noacc 19
;

proc print data=acc;
run;

proc freq order=data;
weight count;
tables gender * before * after /
nocol nopct chisq cmh(mf);
run;

proc freq order=data;
weight count;
tables gender * before * after / cmh(mf);
exact comor eqor;
run;
