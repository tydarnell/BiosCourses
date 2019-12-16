%let progname=6city11.sas;
%let pdfout  =6city11.pdf;
                        
* 6cityj.sas
* xref: Biometrics(88) p1049, table 1.
* input: 6city.dat
* output:
* does  - Proc nlmixed
        - Bug in "replicate" with "empirical"
***************************************************;
title1 "*** BIOS 767: Six-city Study - random-effects models ***";
filename INF "6city.dat";
ods pdf file = "&pdfout";
options nocenter errors=3;
***************************************************;
data A0;
  infile INF firstobs=2;
  input y7 - y10 ms count;
  run;
***************************************************;
* Expnaded data set;
data E0;
  set A0;
  do i = 1 to count;
    output;
  end;
  drop count i;
  run;
***************************************************;
data A (keep = id y one age ms msxage count y7-y10);
  set A0;
  retain id 0 one 1;
  * get data and coding as in Biometrics(88) p1049 paper;
  id + 1;

  y = y7;  age =-2; msxage=ms * age; output;
  y = y8;  age =-1; msxage=ms * age; output;
  y = y9;  age = 0; msxage=ms * age; output;
  y = y10; age = 1; msxage=ms * age; output;

  label y      = "Respiratory illness 0=no 1=yes";
  label ms     = "Mother smoking      0=no 1=yes";
  label age    = "Age (years) - 9               ";
  label msxage = "age x ms                      ";
  label count  = "number with this pattern      ";
  run;
***************************************************;
data E (keep = id y one age ms msxage       y7-y10);
  set E0;
  retain id 0 one 1;
  * get data and coding as in Biometrics(88) p1049 paper;
  id + 1;

  y = y7;  age =-2; msxage=ms * age; output;
  y = y8;  age =-1; msxage=ms * age; output;
  y = y9;  age = 0; msxage=ms * age; output;
  y = y10; age = 1; msxage=ms * age; output;

  label y      = "Respiratory illness 0=no 1=yes";
  label ms     = "Mother smoking      0=no 1=yes";
  label age    = "Age (years) - 9               ";
  label msxage = "age x ms                      ";
  run;
***************************************************;
title2 "1. Expanded data set";
proc nlmixed data = E qpoints = 25;
  parms int_ = -3 ms_ = 0.4 age_ = -0.2 sigmasq = 5;
  eta = int_ + ms_ * ms + age_ * age + u;
  p = 1 / (1 + exp(-eta));
  model y ~ binary(p);
  random u ~ normal(0, sigmasq)  subject=id;
  run;
***************************************************;
title2 "2. Using replicate";
proc nlmixed data = A qpoints = 25;
  parms int_ = -3 ms_ = 0.4 age_ = -0.2 sigmasq = 5;
  eta = int_ + ms_ * ms + age_ * age + u;
  p = 1 / (1 + exp(-eta));
  model y ~ binary(p);
  random u ~ normal(0, sigmasq)  subject=id;
  replicate count;
  run;
***************************************************;
title2 "3. Expanded data set and empirical";
proc nlmixed data = E qpoints = 25 empirical;
  parms int_ = -3 ms_ = 0.4 age_ = -0.2 sigmasq = 5;
  eta = int_ + ms_ * ms + age_ * age + u;
  p = 1 / (1 + exp(-eta));
  model y ~ binary(p);
  random u ~ normal(0, sigmasq)  subject=id;
  run;
***************************************************;
title2 "4. Using replicate and empirical";
proc nlmixed data = A qpoints = 25 empirical;
  parms int_ = -3 ms_ = 0.4 age_ = -0.2 sigmasq = 5;
  eta = int_ + ms_ * ms + age_ * age + u;
  p = 1 / (1 + exp(-eta));
  model y ~ binary(p);
  random u ~ normal(0, sigmasq)  subject=id;
  replicate count;
  run;
*--------------------------------------------------;
endsas;
Output:
                1         2         3         4
            Standard   Standard  Standard   Standard
Parameter      Error      Error     Error      Error

int_          0.2190     0.2190    0.2166     1.7642
ms_           0.2731     0.2731    0.2735     1.9508
age_         0.06768    0.06768   0.06789     0.2062
sigmasq       0.8008     0.8008    0.8256     3.6234

1. Expanded data set
2. Using replicate
3. Expanded data set and empirical
4. Using replicate and empirical

------------------------------------------------------------------------------------

System:

NOTE: Copyright (c) 2002-2012 by SAS Institute Inc., Cary, NC, USA. 
NOTE: SAS (r) Proprietary Software 9.4 (TS1M1) 
      Licensed to UNIVERSITY OF NORTH CAROLINA CHAPEL HILL - SFA T&R, Site 70022629.
NOTE: This session is executing on the W32_7PRO  platform.

NOTE: Updated analytical products:
      
      SAS/STAT 13.1
      SAS/ETS 13.1
      SAS/OR 13.1
      SAS/IML 13.1
      SAS/QC 13.1

NOTE: Additional host information:

 W32_7PRO WIN 6.1.7601 Service Pack 1 Workstation

