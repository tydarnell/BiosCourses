%let progname=iml01.sas;
%let pdfout  =iml01.pdf;
                        
* xref:    
* input:   
* output:
* does:

***************************************************;
title1 "*** BIOS 667, iml ***";
ods pdf file = "&pdfout";
options nocenter errors=3;
***************************************************;
proc iml;
  n  = 10;
  x1 = j(n, 1, 1);
  x2 = (1 : n)`;
  x3 = x2 ## 2 ;
  print x1 x2 x3;
  x       = x1 || x2 || x3;
  print x;
  p       = ncol(x);
  xtx     = x` * x;
  xtxixt  = solve(xtx, X`);
  h       = x * xtxixt;
  rowsums = h[,+];
  sumh    = sum(rowsums);
  rowssq  = h[,##];
  sumsq   = sum(rowssq);
  dh      = vecdiag(h);
  sumdh   = dh[+];

  print n p;
  print h;
  print sumdh sumh sumsq;
  print rowsums dh rowssq ;

