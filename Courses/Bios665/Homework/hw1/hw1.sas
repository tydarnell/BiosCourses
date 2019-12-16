data fav;
input treat $ outcome $ count;
datalines;
placebo f 23
placebo u 52
treatment f 38
treatment u 37
;

proc freq;
weight count;
tables treat*outcome / chisq;
run;

ods select RiskDiffCol1 Measures;
proc freq order=data;
weight count;
tables treat*outcome / riskdiff (correct) measures;
run;

data dose;
input treat $ outcome $ count;
datalines;
High S 7
High U 3
Low S 2
Low U 5
;
proc freq order=data;
weight count;
tables treat*outcome / nocol;
exact or;
run;

data eyes;
input placebo $ newtreat $ count;
datalines;
clear clear 132
clear notclear 22
notclear clear 53
notclear notclear 33
;
ods select McNemarsTest;
proc freq order=data;
weight count;
tables placebo*newtreat/ agree;
exact mcnem;
run;

data screening;
input disease $ outcome $ count @@;
datalines;
present + 106 present - 24
absent + 22 absent - 48
;

proc freq data=screening order=data;
weight count;
tables disease * outcome / riskdiff alpha=.01;
run;

*problem 5;

*part a;
proc power;
twosamplefreq test=fisher
groupproportions= (.67 .43)
power=.9
ntotal=.;
run;


*part b;
proc power;
twosamplefreq test=fisher
alpha=.05
groupproportions= (.7,.85)
power=.85
groupweights= (1 2)
ntotal=.;
run;


*part c;
proc power;
twosamplefreq test=fisher
groupproportions= (.67 .43)
power=.9
ntotal=.;
run;
