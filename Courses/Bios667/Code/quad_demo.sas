%let progname=quad_demo.sas;
%let pdfout  =quad_demo.pdf;
                        
* does  - Using quad() for numerical integration

***************************************************;
ods pdf file = "&pdfout";
options nocenter errors=3;
title "Using quad() in SAS/IML for numerical integration";
***********************************************************;

proc iml;

* A function we want to integrate;
start f(x);
  fx  = 1 / x;
  return(fx);
finish;

* A function we want to integrate;
start g(z);
  gz  = pdf("normal", z);
  return(gz);
finish;

call quad(integ_f, "f", {1   2});   * (1, 2);
call quad(integ_g, "g", {.M .P});   * (-infinity, +infinity);

print "Integrate f(x) = 1/x over (1,2)";
print "Integrate g(x) = the standard normal pdf over (-infinity, +infinity)";

print "The results:";
print integ_f integ_g;

print "The approximation errors:";
ef = integ_f - log(2);
eg = integ_g - 1;

print ef eg;
