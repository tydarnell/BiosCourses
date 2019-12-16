%let progname=hw2.sas;
%let pdfout  =hwout.pdf;
                        
* xref:    
* input:   
* output:
* does:

***************************************************;
ods pdf file = "&pdfout";
options nocenter errors=3;
***************************************************;

proc iml;
  n=4;
  mu={1 2 5 9}`;
  covm = {6 3 2 1, 3 7 3 2, 2 3 8 5, 1 2 5 9};
  a= j(n,1,1/4);
  b= (1 : n)`;
  y={10 11 7 15}`;
  x = a || b;
  atb = a` * b;
  btb= b ` * b;
  print atb;
  print btb;
  EaY=a` * mu;
  print EaY;
  VaraY = a` * covm * a;
  print VaraY;
  EbY= b` * mu;
  print EbY;
  VarbY = b` * covm * b;
  print VarbY;
  cov=a` * covm * b;
  print cov;
  xtx = x` *x;
  print xtx;
  xty = x` *y;
  print xty;
  Bhat=solve(xtx,xty);
  print Bhat;
  r= y-x * Bhat;
  print r;
  xtr=x` * r;
  print xtr;
  ssr=r` * r;
  print ssr;
