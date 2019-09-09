options ls=70;

data ski;
input vitc cold count;
cards;
1 1 17
1 0 122
0 1 31
0 0 109
;
proc logistic descending;
freq count;
model cold=vitc;
run;

proc freq data = ski;
  weight count;
  tables cold*vitc / fisher chisq;
  exact fisher or;
run;

data uti;
input diagnosis $ trt $ cure $ count;
cards;
complicated A cured 78
complicated A not 28
complicated B cured 101
complicated B not 11
complicated C cured 68
complicated C not 46
uncomplicated A cured 40
uncomplicated A not 5
uncomplicated B cured 54
uncomplicated B not 5
uncomplicated C cured 34
uncomplicated C not 6
;
proc logistic;
freq count;
class diagnosis trt/param=ref;
model cure=diagnosis|trt;
run;
proc logistic;
freq count;
class diagnosis trt/param=ref;
model cure=diagnosis trt;
run;

proc logistic;
freq count;
class diagnosis trt/param=ref;
model cure=diagnosis trt;
contrast 'B vs. A' trt -1 1/estimate=exp;
/* ESTIMATE=EXP option requests that the OR is printed */
run;

proc logistic;
freq count;
class diagnosis trt/param=ref;
model cure=diagnosis trt/scale=none aggregate;
/* SCALE produces goodness-of-fit statistics */
/* AGGREGATE tells LOGISTIC to treat each unique combination of */
/* explanatory variables as a distinct group in computing the GOF stats */
run;

proc logistic;
freq count;
class diagnosis trt/param=ref;
model cure=diagnosis trt/influence;
run;



proc import datafile = 'C:\Users\feizou\Desktop\Teaching\Bios663-2019\Spring2019\lecture17\pbcnew.csv'
 out = pbc
 dbms = CSV
 REPLACE
 ;

 proc print data=pbc(obs=10);
  run;


data pbc;
 set pbc;
 drug=1;
if drug0='placebo' then drug=0;
sex=1;
if sex0='male' then sex=0;
ascites=0;
if ascites0='present' then ascites=1;
if ascites0='.' then ascites='.';
hepatom=0;
if hepatom0='present' then hepatom=1;
if hepatom0='.' then hepatom='.';
spiders=0;
if spiders0='present' then spiders=1;
if spiders0='.' then spiders='.';

edema=0.5;
if edema0='edemadespitediuretictherapy' then 
   edema=1;
if edema0='noedema' then edema=0;
if edema0='.' then edema='.';
run;


proc print data=pbc(obs=10);
run;


proc means;
var age bili chol albumin copper alk_phos sgot trig platelet protime;
run;

proc freq;
tables status drug sex ascites hepatom spiders edema stage;
run;

data pbc;
set pbc;
age=age/365-50;
alk_phos=alk_phos/1000;
edema_d=0;
edema_nd=0;
if edema=1 then edema_d=1;
if edema=.5 then edema_nd=1;
stage1=0; stage2=0; stage3=0; stage4=0;
if stage=1 then stage1=1;
if stage=2 then stage2=1;
if stage=3 then stage3=1;
if stage=4 then stage4=1;
run;

proc logistic descending;
model status=drug sex ascites hepatom 
 spiders edema_d edema_nd stage2
 stage3 stage4 age bili chol albumin 
 copper alk_phos sgot trig platelet
protime;
run;


proc logistic descending;
model status=drug sex ascites spiders stage2 stage3 stage4 age bili copper
alk_phos protime;
run;
