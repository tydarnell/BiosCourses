data respire;
input treat $ outcome $ count;
datalines;
placebo f 16
placebo u 48
test f 40
test u 20
;

*options (for proc freq);
PROC FREQ options;
OUTPUT <OUT= SAS-data-set><output-statistic-list>;
TABLES requests / options;
WEIGHT variable;
EXACT statistic-keywords;
BY variable-list;

*proc freq- get table and statistics; 
proc freq;
weight count;
tables treat*outcome / chisq;
run;
