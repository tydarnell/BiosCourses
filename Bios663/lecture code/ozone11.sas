options ls=70;


proc import datafile = 'C:\Users\feizou\Desktop\Teaching\Bios663-2019\Spring2019\lecture9\ozone.csv'
 out = ozone
 dbms = CSV
 REPLACE
 ;


 proc princomp data=ozone;
var outdoor home time_out;
run;

data ozone; set ozone; int=1; run;
proc princomp data=ozone noint;
var int outdoor home time_out;
run;

/* SSCP */
proc princomp data=ozone noint cov vardef=n;
var int outdoor home time_out;
run;

/* Scaled SSCP */
proc princomp data=ozone noint;
var int outdoor home time_out;
run;

/* Covariance Matrix */
proc princomp data=ozone noint cov vardef=n;
var outdoor home time_out;
run;

/* Correlation Matrix */
proc princomp data=ozone;
var outdoor home time_out;
run;

data ozone; set ozone;
home2=home*home;
home3=home*home2;
run;
proc reg;
model personal=outdoor home home2 home3 time_out/tol vif;
run;

/* Scaled SSCP matrix */
proc princomp data=ozone noint;
var int outdoor home home2 home3 time_out;
run;
/* correlation matrix */
proc princomp data=ozone;
var outdoor home home2 home3 time_out;
run;


/* Covariance Matrix */
proc princomp data=ozone noint cov vardef=n;
var outdoor home time_out;
run;
/* Correlation Matrix */
proc princomp data=ozone;
var outdoor home time_out;
run;

