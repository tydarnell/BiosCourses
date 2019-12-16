data screening;
input disease $ outcome $ count @@;
datalines;
present + 52 present - 8
absent + 20 absent - 100
;

proc freq data=screening order=data;
weight count;
tables disease*outcome / riskdiff;
run;

data eel;
input species $ loc $ count @@;
datalines;
m one 16 m two 29 m three 15
v one 12 v two 20 v three 28
;
proc freq data=eel order=data;
weight count;
tables species*loc / chisq nocol nopct;
run;
