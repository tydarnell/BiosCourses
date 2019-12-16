*
BIOS 767 HW 6
Cheynna Crowley
Problem 14.1 
;

*set wd;
libname hw6 '\\Client\H$\Desktop\Spring2019\BIOS_767\Homework\HW06\';

*read in data;
DATA toe;
   INFILE '\\Client\H$\Desktop\Spring2019\BIOS_767\Code and Data\toenail.dat' firstobs=2 ;
   INPUT id $ y  trt month visit;
   trt_month=trt*month;
RUN;


*14.1.1;

title'Question 14.1.1';
proc genmod data=toe descending;
class id;
model y = month trt_month / dist=binom link=logit type3 aggregate;
repeated subject=id / logor=exch;
run;

proc genmod data=toe  descending;
  class id ;
  model y = month trt_month / d = b scale=1 noscale;
  repeated subject=id / logor=exch;
  run;


title 'Question 14.1.5';

proc nlmixed data=toe qpoints=20;
  parms 
          int      =  -0.5209
          time_    =  -0.1712
          time2_   =  -0.0757
          sigmasq  =   4;

  eta = int + time_*month + time2_*trt_month + u;
  p = 1 / (1 + exp(-eta));
  model  y ~ binary(p);
  random u ~ normal(0, sigmasq)  subject=id;
  run;


title 'Question 14.1.10';
title2 'qpoints=2';
proc nlmixed data=toe qpoints=2;
  parms 
          int      =  -0.5209
          time_    =  -0.1712
          time2_   =  -0.0757
          sigmasq  =   4;

  eta = int + time_*month + time2_*trt_month + u;
  p = 1 / (1 + exp(-eta));
  model  y ~ binary(p);
  random u ~ normal(0, sigmasq)  subject=id;
  run;

  title2 'qpoints=5';
proc nlmixed data=toe qpoints=5;
  parms 
          int      =  -0.5209
          time_    =  -0.1712
          time2_   =  -0.0757
          sigmasq  =   4;

  eta = int + time_*month + time2_*trt_month + u;
  p = 1 / (1 + exp(-eta));
  model  y ~ binary(p);
  random u ~ normal(0, sigmasq)  subject=id;
  run;

title2 'qpoints=10';
proc nlmixed data=toe qpoints=10;
  parms 
          int      =  -0.5209
          time_    =  -0.1712
          time2_   =  -0.0757
          sigmasq  =   4;

  eta = int + time_*month + time2_*trt_month + u;
  p = 1 / (1 + exp(-eta));
  model  y ~ binary(p);
  random u ~ normal(0, sigmasq)  subject=id;
  run;


  title2 'qpoints=20';
proc nlmixed data=toe qpoints=20;
  parms 
          int      =  -0.5209
          time_    =  -0.1712
          time2_   =  -0.0757
          sigmasq  =   4;

  eta = int + time_*month + time2_*trt_month + u;
  p = 1 / (1 + exp(-eta));
  model  y ~ binary(p);
  random u ~ normal(0, sigmasq)  subject=id;
  run;


    title2 'qpoints=30';
proc nlmixed data=toe qpoints=30;
  parms 
          int      =  -0.5209
          time_    =  -0.1712
          time2_   =  -0.0757
          sigmasq  =   4;

  eta = int + time_*month + time2_*trt_month + u;
  p = 1 / (1 + exp(-eta));
  model  y ~ binary(p);
  random u ~ normal(0, sigmasq)  subject=id;
  run;


title2 'qpoints=50';
proc nlmixed data=toe qpoints=50;
  parms 
          int      =  -0.5209
          time_    =  -0.1712
          time2_   =  -0.0757
          sigmasq  =   4;

  eta = int + time_*month + time2_*trt_month + u;
  p = 1 / (1 + exp(-eta));
  model  y ~ binary(p);
  random u ~ normal(0, sigmasq)  subject=id;
  run;


  *question 14.1.11;


  data A;
  array beta{3} _temporary_  (-1.6971  -0.3883  -0.1424);
  array x_ij{3} _temporary_  (1  1   0 ) ;*  time 1, dose 0;
  array x_ik{3} _temporary_  (1  4   0 ) ;*  time 4, dose 0;
  retain  sigmasq  16.0121  seed 2017767   nsim 1e5;
  sigma   = sqrt(sigmasq); 

  do sim = 1 to nsim;
    b_i     = sigma * rannor(seed);  * random effects;
    eta_ij = b_i;
    eta_ik = b_i;
    do t = 1 to dim(beta);
      eta_ij = eta_ij + x_ij[t] * beta[t];
      eta_ik = eta_ik + x_ik[t] * beta[t];
    end;
    nu_ij     = cdf('logistic', eta_ij);       * conditional mean;
    nu_ik     = cdf('logistic', eta_ik);       * conditional mean;
    within_ij = nu_ij * (1 - nu_ij);
    within_ik = nu_ik * (1 - nu_ik);
    nu_ijk    = nu_ij * nu_ik;  * E[Y_ij Y_ik | b_i] ;
    output;
  end;
  keep  nu_ij nu_ik nu_ijk within_ij within_ik;
  run;


  proc means data = A;
  var nu_ij nu_ik nu_ijk within_ij within_ik;
  run;

proc summary data = A nway; 
  var nu_ij nu_ik nu_ijk within_ij within_ik;
  output out=B mean = mu_ij mu_ik mu_ijk within_ij within_ik;
  run;

  data B;
  set B;
  total_ij   = mu_ij * (1 - mu_ij);
  between_ij = total_ij - within_ij;
  icc_ij     = between_ij / total_ij;
  total_ik   = mu_ik * (1 - mu_ik);
  between_ik = total_ik - within_ik;
  icc_ik     = between_ik / total_ik;
  r_ijk      = (mu_ijk - mu_ij * mu_ik) / sqrt(total_ij * total_ik);
  or_ijk     = mu_ijk * (1 - mu_ij - mu_ik + mu_ijk)
               / (mu_ij - mu_ijk) / (mu_ik - mu_ijk); * odds ratio;
  run;

proc print data = B;
  var mu_ij total_ij within_ij between_ij icc_ij ;
  run;

proc print data = B;
  var mu_ik total_ik within_ik between_ik icc_ik ;
  run;

proc print data = B;
  var mu_ij mu_ik mu_ijk r_ijk or_ijk;
  run;



  data A;
  array beta{3} _temporary_  (-1.6971  -0.3883  -0.1424);
  array x_ij{3} _temporary_  (1  1   1 ) ;*  time 1, dose 0;
  array x_ik{3} _temporary_  (1  4   4 ) ;*  time 4, dose 0;
  retain  sigmasq  16.0121  seed 2017767   nsim 1e5;
  sigma   = sqrt(sigmasq); 

  do sim = 1 to nsim;
    b_i     = sigma * rannor(seed);  * random effects;
    eta_ij = b_i;
    eta_ik = b_i;
    do t = 1 to dim(beta);
      eta_ij = eta_ij + x_ij[t] * beta[t];
      eta_ik = eta_ik + x_ik[t] * beta[t];
    end;
    nu_ij     = cdf('logistic', eta_ij);       * conditional mean;
    nu_ik     = cdf('logistic', eta_ik);       * conditional mean;
    within_ij = nu_ij * (1 - nu_ij);
    within_ik = nu_ik * (1 - nu_ik);
    nu_ijk    = nu_ij * nu_ik;  * E[Y_ij Y_ik | b_i] ;
    output;
  end;
  keep  nu_ij nu_ik nu_ijk within_ij within_ik;
  run;


  proc means data = A;
  var nu_ij nu_ik nu_ijk within_ij within_ik;
  run;

proc summary data = A nway; 
  var nu_ij nu_ik nu_ijk within_ij within_ik;
  output out=B mean = mu_ij mu_ik mu_ijk within_ij within_ik;
  run;

  data B;
  set B;
  total_ij   = mu_ij * (1 - mu_ij);
  between_ij = total_ij - within_ij;
  icc_ij     = between_ij / total_ij;
  total_ik   = mu_ik * (1 - mu_ik);
  between_ik = total_ik - within_ik;
  icc_ik     = between_ik / total_ik;
  r_ijk      = (mu_ijk - mu_ij * mu_ik) / sqrt(total_ij * total_ik);
  or_ijk     = mu_ijk * (1 - mu_ij - mu_ik + mu_ijk)
               / (mu_ij - mu_ijk) / (mu_ik - mu_ijk); * odds ratio;
  run;

proc print data = B;
  var mu_ij total_ij within_ij between_ij icc_ij ;
  run;

proc print data = B;
  var mu_ik total_ik within_ik between_ik icc_ik ;
  run;

proc print data = B;
  var mu_ij mu_ik mu_ijk r_ijk or_ijk;
  run;



   data A;
  array beta{3} _temporary_  (-0.5209  -0.1712  -0.0757);
  array x_ij{3} _temporary_  (1  1   0 ) ;*  time 1, dose 0;
  array x_ik{3} _temporary_  (1  4   0 ) ;*  time 4, dose 0;
  retain  sigmasq  3.2294  seed 2017767   nsim 1e5;
  sigma   = sqrt(sigmasq); 

  do sim = 1 to nsim;
    b_i     = sigma * rannor(seed);  * random effects;
    eta_ij = b_i;
    eta_ik = b_i;
    do t = 1 to dim(beta);
      eta_ij = eta_ij + x_ij[t] * beta[t];
      eta_ik = eta_ik + x_ik[t] * beta[t];
    end;
    nu_ij     = cdf('logistic', eta_ij);       * conditional mean;
    nu_ik     = cdf('logistic', eta_ik);       * conditional mean;
    within_ij = nu_ij * (1 - nu_ij);
    within_ik = nu_ik * (1 - nu_ik);
    nu_ijk    = nu_ij * nu_ik;  * E[Y_ij Y_ik | b_i] ;
    output;
  end;
  keep  nu_ij nu_ik nu_ijk within_ij within_ik;
  run;


  proc means data = A;
  var nu_ij nu_ik nu_ijk within_ij within_ik;
  run;

proc summary data = A nway; 
  var nu_ij nu_ik nu_ijk within_ij within_ik;
  output out=B mean = mu_ij mu_ik mu_ijk within_ij within_ik;
  run;

  data B;
  set B;
  total_ij   = mu_ij * (1 - mu_ij);
  between_ij = total_ij - within_ij;
  icc_ij     = between_ij / total_ij;
  total_ik   = mu_ik * (1 - mu_ik);
  between_ik = total_ik - within_ik;
  icc_ik     = between_ik / total_ik;
  r_ijk      = (mu_ijk - mu_ij * mu_ik) / sqrt(total_ij * total_ik);
  or_ijk     = mu_ijk * (1 - mu_ij - mu_ik + mu_ijk)
               / (mu_ij - mu_ijk) / (mu_ik - mu_ijk); * odds ratio;
  run;

proc print data = B;
  var mu_ij total_ij within_ij between_ij icc_ij ;
  run;

proc print data = B;
  var mu_ik total_ik within_ik between_ik icc_ik ;
  run;

proc print data = B;
  var mu_ij mu_ik mu_ijk r_ijk or_ijk;
  run;



  data A;
  array beta{3} _temporary_  (-0.5209  -0.1712  -0.0757);
  array x_ij{3} _temporary_  (1  1   1 ) ;*  time 1, dose 0;
  array x_ik{3} _temporary_  (1  4   4 ) ;*  time 4, dose 0;
  retain  sigmasq  3.2294  seed 2017767   nsim 1e5;
  sigma   = sqrt(sigmasq); 

  do sim = 1 to nsim;
    b_i     = sigma * rannor(seed);  * random effects;
    eta_ij = b_i;
    eta_ik = b_i;
    do t = 1 to dim(beta);
      eta_ij = eta_ij + x_ij[t] * beta[t];
      eta_ik = eta_ik + x_ik[t] * beta[t];
    end;
    nu_ij     = cdf('logistic', eta_ij);       * conditional mean;
    nu_ik     = cdf('logistic', eta_ik);       * conditional mean;
    within_ij = nu_ij * (1 - nu_ij);
    within_ik = nu_ik * (1 - nu_ik);
    nu_ijk    = nu_ij * nu_ik;  * E[Y_ij Y_ik | b_i] ;
    output;
  end;
  keep  nu_ij nu_ik nu_ijk within_ij within_ik;
  run;


  proc means data = A;
  var nu_ij nu_ik nu_ijk within_ij within_ik;
  run;

proc summary data = A nway; 
  var nu_ij nu_ik nu_ijk within_ij within_ik;
  output out=B mean = mu_ij mu_ik mu_ijk within_ij within_ik;
  run;

  data B;
  set B;
  total_ij   = mu_ij * (1 - mu_ij);
  between_ij = total_ij - within_ij;
  icc_ij     = between_ij / total_ij;
  total_ik   = mu_ik * (1 - mu_ik);
  between_ik = total_ik - within_ik;
  icc_ik     = between_ik / total_ik;
  r_ijk      = (mu_ijk - mu_ij * mu_ik) / sqrt(total_ij * total_ik);
  or_ijk     = mu_ijk * (1 - mu_ij - mu_ik + mu_ijk)
               / (mu_ij - mu_ijk) / (mu_ik - mu_ijk); * odds ratio;
  run;

proc print data = B;
  var mu_ij total_ij within_ij between_ij icc_ij ;
  run;

proc print data = B;
  var mu_ik total_ik within_ik between_ik icc_ik ;
  run;

proc print data = B;
  var mu_ij mu_ik mu_ijk r_ijk or_ijk;
  run;

