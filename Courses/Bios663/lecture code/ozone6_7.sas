options ls=70;

data ozone;
infile 'C:\Users\tydar\OneDrive\Documents\Bios663\lecture code\lecture5\ozone.txt';
input personal outdoor home time_out;
run;


proc reg data=ozone;
model personal=outdoor home time_out;
run;

proc reg data=ozone;
model personal=outdoor home time_out;
test outdoor-home=0, home-time_out=0;
test outdoor-home=0, outdoor-time_out=0;
run;

proc reg;
model personal=outdoor home time_out/r;
run;

proc reg;
model personal=outdoor home time_out;
output out=resid student=standresid rstudent=studresid;
run;

proc print data=resid;
var personal standresid studresid;
run;

*uncorrected SS ;
proc glm data=ozone;
model personal= outdoor home time_out/int;
run;

*corrected SS (corrected overall test) ;
proc glm data=ozone;
model personal= outdoor home time_out;
run;

*intecept only ;
proc glm data=ozone;
model personal= /;
run;
