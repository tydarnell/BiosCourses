data arth;
input treat $ response $ count @@;
datalines;
active none 13 active some 7 active marked 21
placebo none 29 placebo some 7 placebo marked 7
;

proc print data=arth;
run;

proc freq data=arth order=data;
weight count;
tables treat*response / chisq nocol nopct;
run;

data arth;
input gender $ treat $ response $ count @@;
datalines;
female active none 6 female active some 5 female active marked 16
female placebo none 19 female placebo some 7 female placebo marked 6
male active none 7 male active some 2 male active marked 5
male placebo none 10 male placebo some 0 male placebo marked 1
;
proc freq data=arth order=data;
weight count;
tables gender*treat*response / cmh nocol nopct;
run;
