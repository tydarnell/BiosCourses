*
BIOS 767 HW 7
Cheynna Crowley
Problem 14.2 
;

*set wd;
libname hw7 '\\Client\H$\Desktop\Spring2019\BIOS_767\Homework\HW07\';

*read in data;
DATA skin;
   INFILE '\\Client\H$\Desktop\UNC_FINAL\UNC Classwork\Spring_2019\BIOS_767\Code and Data\skin.dat.txt' firstobs=2 ;
   INPUT id $ center age skin gender exposure y treatment year ;
RUN;



*14.2.0;
proc freq data=skin;
tables center*treatment center*gender center*year treatment*year treatment*skin;
run;

proc means data=skin;
class center;
var exposure;
run;

proc means data=skin;
class skin;
var exposure;
run;

proc means data=skin;
class treatment;
var exposure;
run;

proc means data=skin;
class gender;
var exposure;
run;


proc means data=skin;
class center;
var age ;
run;


proc means data=skin;
class treatment;
var age ;
run;

proc means data=skin;
class gender;
var age ;
run;


proc means data=skin;
class skin;
var age ;
run;
*14.2.1 proc glm mixzed;
/*
proc glimmix data=skin method=quad(qpoints=50);
class id treatment(ref=first);
model y=year treatment treatment*year/dist=poisson link=log s;
random intercept /subject=id type=un;
run;
*/


proc glimmix data=skin method=quad(qpoints=50);
ods output solutionr=bluptable;
class id treatment(ref=first);
model y=year treatment*year/dist=poisson link=log s cl chisq;
random intercept /subject=id type=un solution ;
run;

data skin2;
set skin;
trt_year=treatment*year;
run;

proc genmod data=skin2;
class id;
model y = year trt_year / dist=poisson link=log type3;
repeated subject=id;
run;

proc nlmixed data=skin2 qpoints=50;
  parms 
          int      =   -1.3171
          time_    =    -0.0212
          time2_   =  0.0485
          sigmasq  = 4 ;

  eta = int + time_*year + time2_*trt_year + u;
  p = exp(eta);
  model  y ~ poisson(p);
  random u ~ normal(0, sigmasq)  subject=id;
  run;

  proc print data=bluptable;
  run;


*14.2.5 proc glm mixzed;

proc means data=bluptable;
var estimate;
run;

data bluptable2;
set bluptable;
id = compress(subject,'', 'a');
run;


proc export data=bluptable 
   outfile='\\Client\H$\Desktop\Spring2019\BIOS_767\Homework\HW07\blup.csv'  
   dbms=csv
   replace;
run;

proc sort data=skin;
by id;
run;

proc sort data=bluptable2;
by id;
run;

data graph;
	merge skin bluptable2;
	by id;
run;



proc sgplot data=graph;
	scatter x=age y=estimate/markerattrs=(symbol=circlefilled color=black);
	xaxis label='Age';
	yaxis label='Predicted Values';
	Title 'Predictions by Age';
run;


proc sgplot data=graph;
	scatter x=exposure y=estimate/markerattrs=(symbol=circlefilled color=black);
	xaxis label='Number of Previous Skin Cancers';
	yaxis label='Predicted Values';
	Title 'Predictions by Number of Previous Skin Cancers';
run;


/*14.2.7*/

proc glimmix data=skin method=quad(qpoints=50);
class id treatment(ref=first);
model y=year exposure age treatment*year skin*treatment exposure*treatment age*treatment/dist=poisson link=log s cl chisq;
random intercept /subject=id type=un solution ;
run;


proc glimmix data=skin method=quad(qpoints=50);
class id treatment(ref=first);
model y=year skin exposure age treatment*year /dist=poisson link=log s cl chisq;
random intercept /subject=id type=un solution ;
run;
