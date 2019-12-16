%let progname = iml03.sas;
%let pdfout   = iml03.pdf;

* input: 
* output:
* xref:
* does: ?

*******************************************************************;
title1 "&progname: ? ";
ods pdf file = "&pdfout";

proc iml;

  n     = 50;
  sigma = 2;
  beta  = {1  1  1}`;  * same as: beta  = {1, 1, 1};
  seed  = 6672019;

  x1    = j(n, 1, 1);
  x2    = t(1:n) / n;
  x3    = repeat({0, 1}, n / 2, 1);
  x     = x1 || x2 || x3;
  y     = x * beta + sigma * rannor(j(n, 1, seed));
  xy    = x || y;
  varname = {one dose group y};
  create  A from xy [colname = varname];
  setout  A;          * select for output;
  append  from  xy;   * send xy to A;
  close   A;          * close the file;

  beta_hat = solve(x` * x, x` * y);   * OLS;
  print beta_hat;
  
*******************************************************************;

proc reg data = A;
  model y = dose group;
  run;
