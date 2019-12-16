*Problem 1;
data gi;
input center $ treat $ response count @@;
n_response=(response='1');
datalines;
a test 1 22 	a test 0 13
a placebo 1 33	a placebo 0 19
b test 1 27 	b test 0 7
b placebo 1 18	b placebo 0 15
;
run;

proc freq data=gi order=data;
weight count;
tables center*treat*response / chisq cmh(mf) nocol nopct;
run;



*Problem 2;
data rashd;
input treat $ sex $ rash count @@;
datalines;
placebo m 0 6 	placebo m 1 10 	placebo m 2 12 	placebo m 3 20
placebo f 0 7 	placebo f 1 14 	placebo f 2 19 	placebo f 3 18
low m 0 9 		low 	m 1 7 	low 	m 2 30 	low 	m 3 19 
low f 0 10		low 	f 1 17 	low 	f 2 11 	low 	f 3 16 
high m 0 19		high 	m 1 15 	high 	m 2 17	high 	m 3 5
high f 0 21 	high 	f 1 18 	high 	f 2 10 	high 	f 3 5  
;
run;

data rashp;
input treat sex rash count;
datalines;
1	1	1	44
1	0	1	56
1	1	1	33
1	0	1	37
1	1	0	10
1	0	0	9
1	1	0	21
1	0	0	19
0	0	1	42
0	1	1	51
0	0	0	6
0	1	0	7
;
run;

proc freq data=rashp order=data;
weight count;
tables sex*treat*rash / chisq cmh(mf) nocol nopct;
run;

proc logistic data=rashp order=data;
freq count;
model rash= treat sex;
oddsratio sex;
run;

proc logistic data=rashp order=data;
freq count;
class treat(ref="0") sex(ref="0") / param=ref;
model rash= treat|sex / aggregate;
oddsratio sex;
run;

*Problem 3;
data teeth;
input toothex $ jaw $ insurance count @@;
datalines;
none 	upper 0 279	none upper 1 193 	none upper 2 373
none 	lower 0 149	none lower 1 83 	none lower 2 137
one  	upper 0 69	one upper  1 21		one  upper 2 81
one  	lower 0 29	one lower  1 44 	one  lower 2 75
twoplus upper 0 45	twoplus upper 1 33 twoplus upper 2 24
twoplus lower 0 21	twoplus lower 1 12 twoplus lower 2 19
;
run;

data teeth1;
input toothex jaw $ insurance count @@;
datalines;
0	upper 0 279	0 upper 1 193 0 upper 2 373
0 	lower 0 149	0 lower 1 83  0 lower 2 137
1  	upper 0 69	1 upper 1 21  1  upper 2 81
1  	lower 0 29	1 lower 1 44  1  lower 2 75
1 	upper 0 45	1 upper 1 33  1 upper 2 24
1 	lower 0 21	1 lower 1 12  1 lower 2 19
;
run;


*Part a;
proc freq data=teeth1 order=data;
weight count;
tables jaw*toothex*insurance / all chisq cmh(mf) nocol nopct scores=modridit;
run;

*Part c;
data teeth2;
input toothex high count @@;
datalines;
0	1 510 	0 0 704
1	1 156	1 0 163
2	1 43	2 0 111
;
run;

proc freq data=teeth2 order=data;
weight count;
tables high*toothex / all chisq cmh(mf) nocol nopct;
run;

*Part d;
data teeth3;
input jaw $ toothex high count @@;
datalines;
lower 0 1 137	lower 0 0 232
lower 1 1 75	lower 1 0 73
lower 2 1 19	lower 2 0 33
upper 0 1 373	upper 0 0 472
upper 1 1 81	upper 1 0 90
upper 2 1 24	upper 2 0 78
;
run;

proc freq data=teeth3 order=data;
weight count;
tables jaw*high*toothex / all chisq cmh(mf) nocol nopct;
run;

*Problem 4;
data drug;
input druga $ drugb $ drugc $ count;
datalines;
F F F 6
F F U 16
F U F 2
F U U 4
U F F 2
U F U 4
U U F 6
U U U 6
;
run;

data drug2; set drug;
keep patient drug response;
retain patient 0;
do i=1 to count;
patient=patient+1;
drug='A'; response=druga; output;
drug='B'; response=drugb; output;
drug='C'; response=drugc; output;
end;

proc print data=drug2;
run;


proc logistic data=drug2;
class drug(ref="A") /param=ref;
strata patient;
model response(event="F")= drug / aggregate alpha=.01;
oddsratio drug;
run;

*Part c;
proc logistic data=drug2;
class drug(ref="A") /param=ref;
strata patient;
model response(event="F")= drug / alpha=.05;
contrast "b vs c" drug 1 -1;
run;