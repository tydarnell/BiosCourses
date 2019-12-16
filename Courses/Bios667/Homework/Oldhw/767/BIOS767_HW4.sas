* BIOS 767 HW 5   ;
* Cheynna Crowley ;
* 2/20/19	      ;

data epilepsy;
   INFILE '\\Client\H$\Desktop\Spring2019\BIOS_767\Homework\HW04\epilepsy.dat' firstobs=2;
   INPUT id treatment age y0 y1 y2 y3 y4;
run;

proc print data=epilepsy(obs=5);run;

*question 13.2.1;
data  epilepsy_a;
	set epilepsy;
	y=y0; time=0; logweek=log(8) ; OUTPUT;
	y=y1; time=1; logweek=log(2); OUTPUT;
	y=y2; time=2; logweek=log(2); OUTPUT;
	y=y3; time=3; logweek=log(2); OUTPUT;
	y=y4; time=4; logweek=log(2); OUTPUT;
DROP y0-y4;
run;


proc print data=epilepsy_a(obs=10);run;

title'Question 13.2.1';
proc genmod data=epilepsy_a;
  class  time(ref='0') treatment(ref='0') id / param=ref ;
  model y =   time treatment time*treatment / d=poisson offset=logweek ;
  repeated subject=id / withinsubject=time type=un;
  contrast 'Interaction Terms' 
time*treatment  1,
time*treatment 0 1, 
time*treatment 0 0 1,
time*treatment 0 0 0 1 /wald;
run;

*question 13.2.3;


data epilepsy_b;
set epilepsy;
	y=y0; ptime=0; time=0; logweek=log(8) ; OUTPUT;
	y=y1; ptime=1; time=1; logweek=log(2);  OUTPUT;
	y=y2; ptime=1; time=2; logweek=log(2); OUTPUT;
	y=y3; ptime=1; time=3; logweek=log(2); OUTPUT;
	y=y4; ptime=1; time=4; logweek=log(2); OUTPUT;
DROP y0-y4;
run;


proc print data=epilepsy_b(obs=10);run;

title'Question 13.2.3';
proc genmod data=epilepsy_b;
  class  time(ref='0') treatment(ref='0') id / param=ref ;
  model y =   ptime treatment ptime*treatment / d=poisson offset=logweek ;
  repeated subject=id / withinsubject=time type=un; 
contrast 'Beta 3' 
ptime*treatment  1 / wald;
run;


*13.2.5;

data epilepsy_c;
	set epilepsy;
	IF id=49 THEN DELETE;
run;

*repeat of 13.2.1;

data  epilepsy_ac;
	set epilepsy_c;
	y=y0; time=0; logweek=log(8) ; OUTPUT;
	y=y1; time=1; logweek=log(2); OUTPUT;
	y=y2; time=2; logweek=log(2); OUTPUT;
	y=y3; time=3; logweek=log(2); OUTPUT;
	y=y4; time=4; logweek=log(2); OUTPUT;
DROP y0-y4;
run;


proc print data=epilepsy_ac(obs=10);run;

title'Question 13.2.5a';
proc genmod data=epilepsy_ac;
  class  time(ref='0') treatment(ref='0') id / param=ref ;
  model y =   time treatment time*treatment / d=poisson offset=logweek ;
  repeated subject=id / withinsubject=time type=un;
  contrast 'Interaction Terms' 
time*treatment  1,
time*treatment 0 1, 
time*treatment 0 0 1,
time*treatment 0 0 0 1 /wald;
run;



*repeat of 13.2.3;
data epilepsy_bc;
set epilepsy_c;
	y=y0; ptime=0; time=0; logweek=log(8) ; OUTPUT;
	y=y1; ptime=1; time=1; logweek=log(2);  OUTPUT;
	y=y2; ptime=1; time=2; logweek=log(2); OUTPUT;
	y=y3; ptime=1; time=3; logweek=log(2); OUTPUT;
	y=y4; ptime=1; time=4; logweek=log(2); OUTPUT;
DROP y0-y4;
run;


proc print data=epilepsy_bc(obs=10);run;

title'Question 13.2.5b';
proc genmod data=epilepsy_bc;
  class  time(ref='0') treatment(ref='0') id / param=ref ;
  model y =   ptime treatment ptime*treatment / d=poisson offset=logweek ;
  repeated subject=id / withinsubject=time type=un; 
contrast 'Beta 3' 
ptime*treatment  1 / wald;
run;
