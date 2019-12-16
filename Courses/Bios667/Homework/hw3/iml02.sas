%let progname = iml02.sas;
%let pdfout   = iml02.pdf;

* input: tlc.dat
* output:
* xref:
* does: ?

*******************************************************************;
title1 "&progname: Treatment of Lead Exposed Children (TLC) Trial";

filename INF   "tlc.dat";
ods pdf file = "&pdfout";

*******************************************************************;

data A;
  infile INF  firstobs=2;
  input id group $ lead0 lead1 lead4 lead6;
  run;

*******************************************************************;

proc iml ;

* IML execution starts here;

  use A; * Choose the input data set;

  print "Group: 0=P, 1=A";
  read all var  {lead0 lead1 lead4 lead6} into y1 where (group = "A");
  read all var  {lead0 lead1 lead4 lead6} into y0 where (group = "P");

  n0 = nrow(y0); * 50;
  n1 = nrow(y1); * 50;
  ybar0 = t(mean(y0));
  ybar1 = t(mean(y1));
  s0 = cov(y0);
  s1 = cov(y1);
  sd0 = sqrt(vecdiag(s0));
  sd1 = sqrt(vecdiag(s1));

  print "Sample sizes in groups P and A:" n0 n1;
  print "Sample mean vectors:";
  print ybar0  [format= 8.1]  ybar1 [format= 8.1];
  print "Sample standard deviations:";
  print sd0 [format=8.2]   sd1 [format=8.2];
  print "Sample covariance matrices:";
  print s0  [format=8.1] , s1  [format=8.1];

***********************************************;
