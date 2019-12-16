*
BIOS 767 HW 5
Cheynna Crowley
Problem 8.1 
;

*set wd;
libname hw5 '\\Client\H$\Desktop\Spring2019\BIOS_767\Homework\HW05\';

*read in data;
DATA exercise;
   INFILE '\\Client\H$\Desktop\Spring2019\BIOS_767\Homework\HW05\exercise.dat' firstobs=2 ;
   INPUT id $ program $ y1 y2 y3 y4 y5 y6 y7;
RUN;

*

data exercise_new;
	set exercise;
	keep id program y  visit;
	y=y1 ; visit=1; output;
	y=y2; visit=2; output;
	y=y3; visit=3; output;
	y=y4; visit=4; output;
	y=y5; visit=5; output;
	y=y6; visit=6; output;
	y=y7; visit=7; output;
	label visit ="Visit Number";
	label y= "Strength";
run;



*output wide format;
proc export data=exercise_new 
   outfile='\\Client\H$\Desktop\Spring2019\BIOS_767\Homework\HW05\exercise_new.csv'  
   dbms=csv
   replace;
run;


data exercise_new;
	set exercise;
	keep id program y  visit;
	y=y1 ; visit=1; output;
	y=y2; visit=2; output;
	y=y3; visit=3; output;
	y=y4; visit=4; output;
	y=y5; visit=5; output;
	y=y6; visit=6; output;
	y=y7; visit=7; output;
	label visit ="Visit Number";
	label y= "Strength";

run;
*simple descriptive statistics;

proc means data=exercise N NMISS MEAN MEDIAN STD MIN MAX;
var y1 y2 y3 y4 y5 y6 y7;
run;


proc print data=exercise_new(obs=15);run;
ods output solutionr=bluptable;
PROC MIXED data=exercise3 ;
	CLASS id trt;
	MODEL strength= trt days trt*days/S cl CHISQ OUTPRED=yhat;
	RANDOM INTERCEPT days/TYPE=UN SUBJECT=id SOLUTION G V;
RUN;


proc print data=yhat;
run;

proc export data=bluptable 
   outfile='\\Client\H$\Desktop\Spring2019\BIOS_767\Homework\HW05\blup.csv'  
   dbms=csv
   replace;
run;
/*
PROC MIXED data=exercise_new;
CLASS id program;
MODEL y=program visit program*visit / S CHISQ;
REPEATED /TYPE=SP(EXP)(visit) LOCAL SUBJECT=id;
RANDOM INTERCEPT visit /TYPE=UN SUBJECT=id G V;
run;
*/





*;
/* 8.1.1 */

proc sort data=exercise;
by id;
run;

proc transpose data=exercise out=exercise1;
	by id program;
		var y1-y7;
run;
proc sql;
	create table exercise2 as
	select program, _name_, mean(col1) as mean
	from exercise1
	group by program, _name_;
quit;
data exercise2;
	set exercise2;
	if _name_='y1' then days=0;
	if _name_='y2' then days=2;
	if _name_='y3' then days=4;
	if _name_='y4' then days=6;
	if _name_='y5' then days=8;
	if _name_='y6' then days=10;
	if _name_='y7' then days=12;
	label program='Treatment Group';
run;
proc sgplot data=exercise2;
	series x=days y=mean/group=program;
	scatter x=days y=mean/group=program markerattrs=(symbol=circlefilled);
	xaxis label='Days' values=(0 to 12 by 2);;
	yaxis label='Strength';
	Title 'Mean Strength Vs. Time (Days) by Treatment Group';
run;

/* 8.1.3 */
data exercise3;
	set exercise1;
	if program=1 then trt=0;
	if program=2 then trt=1;
	strength=col1;
	if _name_='y1' then days=0;
	if _name_='y2' then days=2;
	if _name_='y3' then days=4;
	if _name_='y4' then days=6;
	if _name_='y5' then days=8;
	if _name_='y6' then days=10;
	if _name_='y7' then days=12;
	drop program col1 _name_;
run;

proc mixed data=exercise3;
	class id;
	model strength = days trt days*trt / s chisq;
	random intercept days /subject=id type=un g gcorr v vcorr;
run;

/* 8.1.8 */

proc mixed data=exercise3;
	class id ;
	model strength = days trt days*trt / s chisq;
	random intercept days /subject=id type=un solution g gcorr v vcorr;
run;

/* 8.1.9 */
data twenty4;
	set exercise3;
	if id=24;
run;

proc glm data=twenty4;
	model strength = days;
run;

data graph;
	do days=0 to 12 by 2;
	y1=87.8+.45*days;
	y2=86.84+.33*days;
	output;
	end;
run;
data graph;
	set graph;
	if days=0 then y3=87;
	if days=2 then y3=89;
	if days=4 then y3=91;
	if days=6 then y3=90;
	if days=8 then y3=91;
	label y1='OLS';
run;
data exercise2_;
	set exercise2;
	where program=2;
run;
data graph;
	merge graph exercise2_;
	by days;
run;
	

proc sgplot data=graph;
	series x=days y=mean/ markers lineattrs=(color=black) markerattrs=(symbol=circlefilled color=black) legendlabel='Estimated Population Mean for Program 2';
	scatter x=days y=y3/markerattrs=(symbol=circlefilled color=red) legendlabel='Subject 24';
	series x=days y=y1/legendlabel='OLS' lineattrs=(color=black pattern=dash);
	series x=days y =y2/ legendlabel='EBLUP' lineattrs=(color=black pattern=longdashshortdash thickness=2);
	xaxis label='Days' values=(0 to 12 by 2);;
	yaxis label='Strength';
	Title 'Mean Strength Vs. Time (Days) by Treatment Group';
run;


***************************************************;
*read in data;
DATA exercise;
   INFILE '\\Client\H$\Desktop\Spring2019\BIOS_767\Homework\HW05\exercise.dat' firstobs=2 ;
   INPUT id $ program $ y1 y2 y3 y4 y5 y6 y7;
RUN;

*8.1.0: simple descriptive statistics;
proc means data=exercise N NMISS MEAN MEDIAN STD MIN MAX;
var y1 y2 y3 y4 y5 y6 y7;
run;

proc means data=exercise N NMISS MEAN MEDIAN STD MIN MAX;
class program;
var y1 y2 y3 y4 y5 y6 y7;
run;

*8.1.2 transform the data;

data exercise_new;
	set exercise;
	keep id program y  visit;
	y=y1 ; visit=1; output;
	y=y2; visit=2; output;
	y=y3; visit=3; output;
	y=y4; visit=4; output;
	y=y5; visit=5; output;
	y=y6; visit=6; output;
	y=y7; visit=7; output;
	label visit ="Visit Number";
	label y= "Strength";
run;


*output wide format;
proc export data=exercise_new 
   outfile='\\Client\H$\Desktop\Spring2019\BIOS_767\Homework\HW05\exercise_new.csv'  
   dbms=csv
   replace;
run;


*8.1.3;
PROC MIXED data=exercise_new ;
	CLASS id  program (ref=last);
	MODEL y= program visit program*visit/S cl CHISQ OUTPRED=yhat;
	RANDOM INTERCEPT visit/TYPE=UN SUBJECT=id SOLUTION G V;
RUN;

*8.1.4;
