%let progname = respir05.sas;
ods pdf file = "respir05.pdf";

* input: 
* output:
* xref:
* does: 
    Use simulation to approximate expected values.
    Simulate a large number of independent realizations.
    The sample mean approximates the population mean (expected value).
    The sample variance approximates the population variance.
            
*******************************************************************;
title1 "&progname: Use simulation to approximate expected values";
filename INF  "respir.dat";
*******************************************************************;
*simulation;
title2 "active"; 
data A;

  retain seed 2019
  /* estimates copied from sas output */
  int_        -1.4709
  t1_          0.3672
  t2_         -0.1001
  t3_          0.5550
  t4_         -0.2812
  c2_          2.0234
  t1c2_       -0.1181
  t2c2_       -0.7780
  t3c2_       -0.9729
  t4c2_        0.2951
  t1trt_       1.6854
  t2trt_       2.5982
  t3trt_       2.1978
  t4trt_       1.4891
  logsigma     0.9082
  ;

  * covariates;
  trt= 1; * 0=Placebo, 1=Active;
  t1 = 1; * Time 1 (the first time after baseline);

  t1trt = t1 * trt;
  sigma = exp(logsigma);

  do i = 1 to 1e5;
    b = sigma * rannor(seed);
    eta =    int_
         + t1    * t1_
         + t1trt * t1trt_
         + b;
    nu = cdf("logistic", eta);  * Conditional mean;
    cond_var = nu * (1 - nu);   * Conditional variance;
    output;
  end;
  keep nu cond_var;

  run;

***************************************************;
proc means data = A;
  var nu cond_var;
  run;


data a4;

  retain seed 2019
  /* estimates copied from sas output */
  int_        -1.4709
  t1_          0.3672
  t2_         -0.1001
  t3_          0.5550
  t4_         -0.2812
  c2_          2.0234
  t1c2_       -0.1181
  t2c2_       -0.7780
  t3c2_       -0.9729
  t4c2_        0.2951
  t1trt_       1.6854
  t2trt_       2.5982
  t3trt_       2.1978
  t4trt_       1.4891
  logsigma     0.9082
  ;

  * covariates;
  trt= 0; * 0=Placebo, 1=Active;
  t1 = 1; * Time 1 (the first time after baseline);

  t1trt = t1 * trt;
  sigma = exp(logsigma);

  do i = 1 to 1e5;
    b = sigma * rannor(seed);
    eta =    int_
         + t1    * t1_
         + t1trt * t1trt_
         + b;
    nu = cdf("logistic", eta);  * Conditional mean;
    cond_var = nu * (1 - nu);   * Conditional variance;
    output;
  end;
  keep nu cond_var;

  run;
title2 "placebo";
***************************************************;
proc means data = A4;
  var nu cond_var;
  run;

  *part 6;
  title2 "part6 placebo";
data a6;

  retain seed 2019
  /* estimates copied from sas output */
  int_        -1.4709
  t1_          0.3672
  t2_         -0.1001
  t3_          0.5550
  t4_         -0.2812
  c2_          2.0234
  t1c2_       -0.1181
  t2c2_       -0.7780
  t3c2_       -0.9729
  t4c2_        0.2951
  t1trt_       1.6854
  t2trt_       2.5982
  t3trt_       2.1978
  t4trt_       1.4891
  logsigma     0.9082
  ;

  * covariates;
  trt= 0; * 0=Placebo, 1=Active;
  t1 = 1; * Time 1 (the first time after baseline);

  t1trt = t1 * trt;
  sigma = exp(logsigma);

  do i = 1 to 1e5;
    b = sigma * rannor(seed);
	eta0= int_+b;
	eta1 =    int_
         + t1    * t1_
         + t1trt * t1trt_
         + b;
    nu0 = cdf("logistic", eta0); 
	nu1 = cdf("logistic", eta1);
    nu01=nu0*nu1;
    output;
  end;
  keep nu0 nu1 nu01;

  run;
***************************************************;
proc means data = a6;
  var nu0 nu1 nu01;
  run;
