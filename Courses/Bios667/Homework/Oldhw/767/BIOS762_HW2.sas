* BIOS 762 HW 2
* Cheynna Crowley
*
*



*******************************************************************;
filename INF "\\Client\H$\Desktop\Spring2019\BIOS_767\Homework\HW02\impairment.dat";

*******************************************************************;
data A;
  infile INF  firstobs=2;
  input id LE SES MI;
  label 
    id    = "Subject ID"
    LE = "Life Events"
    SES = "Socioeconomic Status "
    MI = "Mental Impairment (y)"
  ;
  run;

/*problem 11.3.1 and problem 11.3.3*/
title 'Problem 11.3.1 and 11.3.3';
proc genmod data=A;
model MI = LE / dist=mult link=cumlogit type3 aggregate;
run;

proc logistic data=A;
model MI = LE/ scale=none aggregate;
run;


/*problem 11.3.6 and problem 11.3.7*/
title 'Problem 11.3.6 and 11.3.7';
proc genmod data=A;
model MI = LE SES / dist=mult link=cumlogit type3 aggregate;
run;


/*problem 11.3.9*/

title 'Problem 11.3.9';

data A2;
set A;
if(MI=1 ) then MI2=1;
if(MI=2 or MI=3) then MI2=2;
if(MI=4) then MI2=3;
run;

proc genmod data=A2;
model MI2 = LE SES / dist=mult link=cumlogit type3 aggregate;
run;
