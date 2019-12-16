filename INF  "exercise.dat";

DATA exercise;
   infile INF firstobs = 2;
   INPUT id $ program $ y1 y2 y3 y4 y5 y6 y7;
RUN;

proc means data=exercise N NMISS MEAN MEDIAN STD MIN MAX;
var y1 y2 y3 y4 y5 y6 y7;
run;

proc means data=exercise N NMISS MEAN MEDIAN STD MIN MAX;
class program;
var y1 y2 y3 y4 y5 y6 y7;
run;

*8.1.2 transform the data;

data exercise2;
	set exercise;
	y = y1; time = 0; output;
	y = y2; time = 2; output;
	y = y3; time = 4; output;
	y = y4; time = 6; output;
	y = y5; time = 8; output;
	y = y6; time = 10; output;
	y = y7; time = 12; output;
	drop y1 y2 y3 y4 y5 y6 y7;
run;

*8.1.3 fit model with random intercepts and slopes;

PROC MIXED DATA = exercise2;
CLASS id program;
MODEL y=program time time*program / S cl CHISQ;
RANDOM INTERCEPT time / TYPE=UN SUBJECT=ID G gcorr V;
run;


* 8.1.4 model with only random intercept (for LRT);
PROC MIXED DATA = exercise2;
CLASS id program;
MODEL y=program time time*program / S cl CHISQ;
RANDOM INTERCEPT / TYPE=UN SUBJECT=ID G gcorr V;
run;

*8.1.8 Predicted empirical BLUP intercept and slope for each subject;
PROC MIXED DATA = exercise2;
CLASS id program;
MODEL y=program time time*program / S;
RANDOM INTERCEPT time / TYPE=UN SUBJECT=ID G Solution gcorr V;
 ods output solutionr=sr(keep= id effect estimate);
run;

proc sort data=sr;
by id;
run;

proc transpose data=sr prefix=par name=test out=sr2(drop=test);
by id;
var estimate;
run;

proc print data=sr2;
run;

*8.1.9;
data n24;
	set exercise2;
	if id=24;
run;

proc glm data=n24;
	model y = time;
run;


*obtaining predicted empirical blups;
PROC MIXED DATA=exercise2;
CLASS id program;
MODEL y=program time time*program  / S CHISQ  OUTP=predict;
RANDOM INTERCEPT time / TYPE=UN SUBJECT=id G S;
run;

PROC PRINT DATA=predict;
VAR id program time y Pred StdErrPred Resid;
run;
