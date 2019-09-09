options ls=70;

proc import 
datafile = 'C:\Users\feizou\Desktop\Teaching\Bios663-2019\Spring2019\data\CathedralChurch.csv'
 out = romanesque
 dbms = CSV
 REPLACE
 ;

 proc print data=romanesque;
  run;


 data romanesque; set romanesque;
heightsq=height*height; heightcu=heightsq*height;
run;

proc reg data=romanesque;
model length=height heightsq heightcu/tol vif ss1;
output out=out pred=pred;
run;

symbol1 color=black i=none v=star;
symbol2 color=black v=point line=1 i=RC;
/* RL for linear, RQ for quadratic */
proc gplot data=out;
plot length*height=1 pred*height=2/overlay;
run;

/* Linear Spline */
data romanesque; set romanesque;
ht_a=0;
ht_b=0;
if height>70 then ht_a=height-70;
if height>77 then ht_b=height-77;
run;

proc reg;
model length=height ht_a ht_b;
run;

/*Categorize dependent variable */
data romanesque; set romanesque;
medium=1; tall=0;
if height<70.1 then medium=0;
if height>77 then medium=0;
if height>77 then tall=1;
run;

proc print data = romanesque;
run;

proc reg data=romanesque;
model length=medium tall/ss1;
run;


/*othorgonal polynomial model fit*/
proc standard data=romanesque out=two (rename=(height=ht_c length=length_c)) m=0;
var height length;
run;

proc iml;
use romanesque;
read all var "height" into x;
read all var "Cathedral" into id;
poly=orpol(x,3);
lqc=poly[,2:4];
create four var {ht_o1 ht_o2 ht_o3};
append from lqc;
close four;
quit;
run;

data five; merge two four; run;
proc print data = five;
 run;


proc print data=five; 
var Cathedral length_c ht_o1 ht_o2 ht_o3; 
run;


proc reg data=five;
model length_c=ht_o1 ht_o2 ht_o3/tol vif 
ss1;
run;







data x;
do x = 1 to 8 by 0.025;
y = exp(x + normal(7));
output;
end;
run;

proc transreg data=x details;
title2 Defaults;
model boxcox(y) = identity(x);
run;


proc import datafile = 'C:\Users\feizou\Desktop\Teaching\Bios663-2019\Spring2019\lecture9\ozone.csv'
 out = ozone
 dbms = CSV
 REPLACE
 ;

 
proc IML;
use ozone;
read all var "personal" into y;
lny=log(y);
n=nrow(y);
one=j(n,1,1);
avglog=lny`*one/n;
print avglog;
geomean=exp(avglog);
print geomean;
geomeany=geomean#one;
create gmean var {geomeany};
append from geomeany;
close gmean;
quit;
run;

data ozonex;
merge gmean ozone;
y_2=((personal**2)-1)/(2*(geomeany**(2-1)));
y_1_5=((personal**1.5)-1)/(1.5*(geomeany**(1.5-1)));
y_1=((personal**1)-1)/(1*(geomeany**(1-1)));
y_5=((personal**0.5)-1)/(0.5*(geomeany**(0.5-1)));
y_0=geomeany*log(personal);
y_m5=((personal**(-0.5))-1)/(-0.5*(geomeany**(-0.5-1)));
y_m1=((personal**(-1))-1)/(-1*(geomeany**(-1-1)));
y_m1_5=((personal**(-1.5))-1)/(-1.5*(geomeany**(-1.5-1)));
y_m2=((personal**(-2))-1)/(-2*(geomeany**(-2-1)));
run;

proc transreg data=ozone ss2 details;
title2 Defaults;
model boxcox(personal) =
identity(outdoor home time_out);
run;

