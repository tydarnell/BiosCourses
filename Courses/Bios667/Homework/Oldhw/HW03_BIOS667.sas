/***************************/
/*BIOS 667 HW 3 Question 2 */
/*Cheynna Crowley          */
/* Due November 1          */
/***************************/

*Step 1: Read in TLC data;
filename INF   "\\Client\H$\Desktop\Fall2017\BIOS667\tlc.dat";

data A;
  infile INF  firstobs=2;
  input id group $ lead0 lead1 lead4 lead6;
  baseline = lead0;
  lead = lead0; time = 0; output;
  lead = lead1; time = 1; output;
  lead = lead4; time = 4; output;
  lead = lead6; time = 6; output;
  keep id group time lead baseline;
  label lead = "Blood lead level (ug/dL)";
  label time = "Time (week)";
  run;
*Step 1A: Create Indicator Variables for Time;
data B;
	set A;
time0=0;
time1=0;
time4=0;
time6=0;
if time=0 then time0=1;
if time=1 then time1=1;
if time=4 then time4=1;
if time=6 then time6=1;
run;

*step 1C: create a placebo dataset;
data Placebo;
set B;
if group='P';
run;

*step 1D: create a active dataset;
data Active;
set B;
if group='A';
run;
*Step 2: Run model for Active and Placebo;
  proc mixed data = Active ;
  class id  time;
  model lead = time1 time4 time6 baseline*time1 baseline*time4 baseline*time6  /covb s noint ;
  repeated time/ subject = id type = un r rcorr ;
  run;


  proc mixed data = Placebo ;
  class id  time;
  model lead = time1 time4 time6 baseline*time1 baseline*time4 baseline*time6  /covb s noint ;
  repeated time/ subject = id type = un r rcorr ;
  run;




*Step 2: Linear regression model for Active;

*Step 3: Linear regression model for placebo;

*Test statistic based on Beta A , Beta P, Variance A and Variance P;
