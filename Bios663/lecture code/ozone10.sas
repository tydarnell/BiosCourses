options ls=70;


proc import datafile = 'C:\Users\feizou\Desktop\Teaching\Bios663-2019\Spring2019\lecture9\ozone.csv'
 out = ozone
 dbms = CSV
 REPLACE
 ;

proc print data=ozone (OBS=50);
run;

proc means min max data=ozone;
run;


proc univariate plot data=ozone;
var personal;
id subject;
run;

proc capability data=ozone;
qqplot personal outdoor home time_out;
histogram time_out;
run;

proc corr noprob data=ozone;
var personal outdoor home time_out;
run;

proc corr data=ozone;
var personal outdoor home time_out;
run;


proc reg data=ozone;
model personal=outdoor home time_out;
output out=out rstudent=studresid predicted=predicted h=leverage;
run;
proc plot data=out;
plot studresid*predicted/vref=0;
run;
proc capability data=out;
qqplot studresid;
run;


proc univariate plot normal data=out;
var studresid;

proc capability data=out;
histogram studresid/kernel;
run;

proc reg data=ozone;
model personal=outdoor home time_out;
output out=out rstudent=studresid predicted=predicted h=leverage;
run;

proc sort data=out;
by descending leverage;
run;
data out_l;
set out (obs=10);
p=4; n=64;
F=((leverage-(1/n)/(p-1)))/((1-leverage)/(n-p));
pvalue=1-probf(F,p-1,n-p);
if pvalue <=0.05/n then BONF="*";
else BONF=" "; *Bonferroni correction;
label Bonf="Signif at 0.05/n?";
run;
proc print data=out_l uniform label noobs;
var subject personal outdoor home time_out leverage F pvalue Bonf;
run;

ods listing;
ods graphics off;
proc univariate plot data=out;
var studresid;
run;
