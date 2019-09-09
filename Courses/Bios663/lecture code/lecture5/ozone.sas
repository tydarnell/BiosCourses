options ls=70;

data ozone;
infile 'C:\Users\tydar\OneDrive\Documents\Bios663\lecture code\lecture5\ozone.txt';
input personal outdoor home time_out;
run;


proc reg data=ozone;
model personal=outdoor home time_out;
run;

*hypothesis testing ;
proc reg data=ozone;
model personal=outdoor home time_out;
test outdoor-home=0, home-time_out=0;
run;

*covariance matrix ;
proc reg data=ozone;
model personal=outdoor home time_out/covb;
run;

*standardized residuals (student residuals) ;
proc reg data=ozone;
model personal=outdoor home time_out/r;
run;


