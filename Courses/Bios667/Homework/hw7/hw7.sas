%let progname = hw7.sas;
filename INF  "respir.dat";
%let pdfout = hw7sas.pdf;
ods pdf file="&pdfout";


data A;
infile INF firstobs = 2;
input id clinic treat $ y0 y1 y2 y3 y4;
run;

*put data in long format;
data B;
set A;
time=0; y=y0; output;
time=1; y=y1; output;
time=2; y=y2; output;
time=3; y=y3; output;
time=4; y=y4; output;
keep id clinic treat time y;
;
*sort data by treatment;
proc sort data = A; 
by clinic treat; 
run;

*Descriptive Statistics;
proc corr data = A  cov;
  var y0 y1 y2 y3 y4;
  by clinic treat;
  run;

*13.1.1 and 13.1.2;
proc genmod descending data=B;
class time(ref='0') treat(ref='P') id / param=ref ;
model y = time time*treat / link=logit dist=bin;
REPEATED SUBJECT=id / WITHINSUBJECT=time LOGOR=FULLCLUST;
contrast 'Treatment Effect' 
time*treat  1,
time*treat 0 1, 
time*treat 0 0 1,
time*treat 0 0 0 1 /wald;
run;

*13.1.3;
proc genmod descending data=B;
class time(ref='0') treat(ref='P') clinic(ref="1") id / param=ref ;
model y = time clinic time*treat time*clinic time*treat*clinic / link=logit dist=bin;
REPEATED SUBJECT=id / WITHINSUBJECT=time LOGOR=FULLCLUST;
contrast 'Treatment Effect' 
time*treat*clinic  1,
time*treat*clinic 0 1, 
time*treat*clinic 0 0 1,
time*treat*clinic 0 0 0 1 /wald;
run;

*13.1.4;
proc genmod descending data=B;
class time(ref='0') treat(ref='P') clinic(ref="1") id / param=ref ;
model y = time clinic time*treat time*clinic / link=logit dist=bin;
REPEATED SUBJECT=id / WITHINSUBJECT=time LOGOR=FULLCLUST;
output out=pred1 predicted=phat;
run;

*model predicted probabilities;
proc print data=pred1;
run;
ods pdf close;
