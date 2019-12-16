data arthritis;
input sex $ treatment $ improve $ count @@;
datalines;
female active marked 16 female active some 5 female active none 6
female placebo marked 6 female placebo some 7 female placebo none 19
male active marked 5 male active some 2 male active none 7
male placebo marked 1 male placebo some 0 male placebo none 10
;

proc logistic order=data;
freq count;
class treatment sex / param=reference;
model improve = sex treatment / scale=none aggregate;
run;

data respire;
input air $ exposure $ smoking $ level count @@;
datalines;
low no non 1 158 low no non 2 9
low no ex 1 167 low no ex 2 19
low no cur 1 307 low no cur 2 102
low yes non 1 26 low yes non 2 5
low yes ex 1 38 low yes ex 2 12
low yes cur 1 94 low yes cur 2 48
high no non 1 94 high no non 2 7
high no ex 1 67 high no ex 2 8
high no cur 1 184 high no cur 2 65
high yes non 1 32 high yes non 2 3
high yes ex 1 39 high yes ex 2 11
high yes cur 1 77 high yes cur 2 48
low no non 3 5 low no non 4 0
low no ex 3 5 low no ex 4 3
low no cur 3 83 low no cur 4 68
low yes non 3 5 low yes non 4 1
low yes ex 3 4 low yes ex 4 4
low yes cur 3 46 low yes cur 4 60
high no non 3 5 high no non 4 1
high no ex 3 4 high no ex 4 3
high no cur 3 33 high no cur 4 36
high yes non 3 6 high yes non 4 1
high yes ex 3 4 high yes ex 4 2
high yes cur 3 39 high yes cur 4 51
;

proc logistic descending;
freq count;
class air exposure(ref='no') smoking / param=reference;
model level = air exposure smoking
air*exposure air*smoking exposure*smoking /
selection=forward include=3 scale=none
aggregate=(air exposure smoking);
run;
