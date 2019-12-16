%let progname = iml04.sas;
%let pdfout   = iml04.pdf;

* input:
* output:
* xref:
* does: Simulation

*******************************************************************;
title1 "&progname: Simulation ";

ods pdf file = "&pdfout";

*******************************************************************;

proc iml ;

* IML execution starts here;

  n = 1000;          * number of subjects;

  mu = {26, 25, 24, 24} ;   * mean vector;

  sigma = {
    25     15       15       23 ,
    15     59       44       36 ,
    15     44       62       33 ,
    23     36       33       85
  };  * cov matrix;

  * Simulation ->;

  U   = root(sigma);
  UtU = U` * U;

  seed = j(n, ncol(sigma), 2019667);
  z    = rannor(seed) * U;
  y    = z + repeat(t(mu), n, 1);

  ybar   = t(mean(y));
  s      = cov(y);

  print "Upper Cholesky root:";
  print U   [format=8.1] ;
  print sigma, UtU;  * verify: sigma == UtU;
  print "Simulation: n = " n;
  print "mu, sample mean:";
  print mu  ybar ;
  print "sigma, sample covariance:";
  print sigma,  s  ;
