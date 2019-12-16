%let progname = respir03.sas;
ods pdf file = "respir03.pdf";

* input: respir.dat
* output:
* xref:
* does: Mixed models

*******************************************************************;
title1 "&progname: Models";
filename INF  "respir.dat";
*******************************************************************;

data A;
     infile INF firstobs = 2;
     input id clinic treatment $ y0 y1 y2 y3 y4 ;
     label treatment = "Treatment (P=placebo, A=Active)";
     run;

***************************************************;

data B (keep = id y clinic treatment time);
  set A;
  retain id 0 one 1;

  y = y0;  time = 0; output; 
  y = y1;  time = 1; output;
  y = y2;  time = 2; output;
  y = y3;  time = 3; output;
  y = y4;  time = 4; output;

  label y = "Status (0=poor, 1=good)";
  run;

***************************************************;

data B;
  set B;

  c2  = (clinic = 2);         * clinic;
  trt = (treatment = "A");    * treatment;

  * time;
  t1 = (time = 1);
  t2 = (time = 2);
  t3 = (time = 3);
  t4 = (time = 4);

  * time x treatment;
  t1trt = t1 * trt;
  t2trt = t2 * trt;
  t3trt = t3 * trt;
  t4trt = t4 * trt;


  * time x clinic;
  t1c2  = t1 * c2;
  t2c2  = t2 * c2;
  t3c2  = t3 * c2;
  t4c2  = t4 * c2;

  * time x clinic x treatment;
  t1c2trt = t1c2 * trt;
  t2c2trt = t2c2 * trt;
  t3c2trt = t3c2 * trt;
  t4c2trt = t4c2 * trt;

  label trt    = "Treatment (0=P, 1=A)";
  label c2     = "Clinic 2 indicator";
  label t1     = "Time 1 indicator";
  label t2     = "Time 2 indicator";
  label t3     = "Time 3 indicator";
  label t4     = "Time 4 indicator";
  run;

***************************************************;
title2 "[M1] ";
proc nlmixed data = B qpoints = 50;
  parms           /* initial values */
       int_ -1.5
       t1_    1.2   t2_  1.2      t3_  1.6   t4_  0.5
       c2_ 2
       t1c2_ -0.2   t2c2_ -0.9    t3c2_ -1   t4c2_ 0.2
       logsigma 1
  ;
  eta =    int_
         + t1 * t1_  
         + t2 * t2_
         + t3 * t3_
         + t4 * t4_
         + c2    * c2_
         + t1c2  * t1c2_
         + t2c2  * t2c2_
         + t3c2  * t3c2_
         + t4c2  * t4c2_
         + b;
  nu = cdf("logistic", eta);
  model  y ~ binary(nu);
  random b ~ normal(0, exp(2 * logsigma)) subject=id;
  run;

***************************************************;

title2 "[M2] ";
proc nlmixed data = B qpoints = 50;
  parms           /* initial values */
       int_ -1.5
       t1_    0.4  t2_ -0.1    t3_  0.55   t4_ -0.3
       c2_ 2
       t1c2_ -0.1  t2c2_ -0.8  t3c2_ -1    t4c2_ 0.3
       t1trt_ 1.6  t2trt_ 2.6  t3trt_ 2.3  t4trt_ 1.4
       logsigma 1
  ;
  eta =    int_
         + t1 * t1_  
         + t2 * t2_
         + t3 * t3_
         + t4 * t4_
         + c2    * c2_
         + t1c2  * t1c2_
         + t2c2  * t2c2_
         + t3c2  * t3c2_
         + t4c2  * t4c2_
         + t1trt * t1trt_
         + t2trt * t2trt_
         + t3trt * t3trt_
         + t4trt * t4trt_
         + b;
  nu = cdf("logistic", eta);
  model  y ~ binary(nu);
  random b ~ normal(0, exp(2 * logsigma)) subject=id;
  run;

***************************************************;
title2 "[M3] ";
proc nlmixed data = B qpoints = 50;
  parms           /* initial values */
       int_ -1.5
       t1_    0.8 t2_  0.2     t3_  0.8     t4_ -0.1
       c2_ 2
       t1c2_ -1   t2c2_ -1.4   t3c2_ -1.5   t4c2_ -0.1
       t1trt_ 0.7 t2trt_ 1.9   t3trt_ 1.6   t4trt_   1
       t1c2trt_ 2 t2c2trt_ 1.4 t3c2trt_ 1.2 t4c2trt_ 0.8
       logsigma 1
  ;
  eta =    int_
         + t1 * t1_  
         + t2 * t2_
         + t3 * t3_
         + t4 * t4_
         + c2    * c2_
         + t1c2  * t1c2_
         + t2c2  * t2c2_
         + t3c2  * t3c2_
         + t4c2  * t4c2_
         + t1trt * t1trt_
         + t2trt * t2trt_
         + t3trt * t3trt_
         + t4trt * t4trt_
         + t1c2trt  * t1c2trt_
         + t2c2trt  * t2c2trt_
         + t3c2trt  * t3c2trt_
         + t4c2trt  * t4c2trt_
         + b;
  nu = cdf("logistic", eta);
  model  y ~ binary(nu);
  random b ~ normal(0, exp(2 * logsigma)) subject=id;
  run;

***************************************************;

title2 "[M4] Problem 13.1.4 with equal means at baseline";
proc genmod data = B  descending;
  class id time clinic treatment;
  model y = t1 t2 t3 t4 c2
               t1 * c2
               t2 * c2
               t3 * c2
               t4 * c2
               t1 * trt
               t2 * trt
               t3 * trt
               t4 * trt
          / dist = bin link = logit;
  repeated subject = id / withinsubject = time logor = fullclust;
  contrast "treatment * time interaction"
      t1 * trt    1 ,
      t2 * trt    1 ,
      t3 * trt    1 ,
      t4 * trt    1
         / wald;
  output out = C   pred=fitted;
run;

title2 "[M4] Problem 13.1.4, fitted values";
proc sort  data = C nodupkey; by clinic treatment time; run;

proc print data = C;
  var id clinic treatment time fitted;
  run;

proc freq data = C;
  table treatment * time / norow nocol nopercent;
  weight fitted;
  by clinic;
  run;
***************************************************;
