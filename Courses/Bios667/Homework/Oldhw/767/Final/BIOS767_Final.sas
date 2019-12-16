/****************************************
BIOS767 Final Exam
April 29, 2019
Program: BIOS767_FINAL.sas
Data: babies1.dat.txt babies2.dat.txt
*****************************************/

libname in '\\Client\H$\Desktop\Spring2019\BIOS_767\Final\';

/*read in data*/
data babies1; *long;
   INFILE '\\Client\H$\Desktop\Spring2019\BIOS_767\Final\babies1.dat.txt' firstobs=2;
   INPUT id age birthorder birthwt ;
run;

data babies2; *wide;
   INFILE '\\Client\H$\Desktop\Spring2019\BIOS_767\Final\babies2.dat.txt' firstobs=2;
   INPUT id age1 birthwt1 age2 birthwt2 age3 birthwt3 age4 birthwt4 age5 birthwt5;
run;

/*check: no missings for age --no missing values*/
proc means data=babies1 missing;
	var age;
run;

/*check: no missings for birthwt -no missing values*/
proc means data=babies1 missing;
	var birthwt;
run;


/*format data*/
data babies1_a;
	set babies1;
	age2=age-20;
	age=age2;
	low_bw=(birthwt<3000);
	drop age2;
run;

data babies2_a;
	set babies2;
	age1a=age1-20;
	age2a=age2-20;
	age3a=age3-20;
	age4a=age4-20;
	age5a=age5-20;
	low_bw1=(birthwt1<3000);
	low_bw2=(birthwt2<3000);
	low_bw3=(birthwt3<3000);
	low_bw4=(birthwt4<3000);
	low_bw5=(birthwt5<3000);
	age1=age1a;
	age2=age2a;
	age3=age3a;
	age4=age4a;
	age5=age5a;
	drop age1a age2a age3a age4a age5a;
run;


/*check age: SD, min, max--all good*/
proc means data=babies1_a missing mean std median min max;
	var age;
run;

/*check low_bw*/
proc means data=babies1_a missing mean std median min max;
	class low_bw;
	var birthwt;
run;

proc means data=babies1_a N missing mean std median min max;
	var birthwt;
run;

/*(1A) graphical and numerical summaries*/

proc means data=babies1_a;
	class birthorder;
	var age;
run;

proc means data=babies1_a N missing mean std median min max;
	class birthorder;
	var birthwt;
run;

proc means data=babies1_a;
	class low_bw;
	var birthwt;
run;

/*(1B) Fit model M1: E[Y_ij]=\alpha_j+ \beta_j(age_{ij}-20)*/

proc mixed data=babies1_a method=ML;
	class id birthorder(ref=first);	
	model birthwt=birthorder birthorder*age/ noint s chisq;
	repeated birthorder / type=un subject=id r;
run;

/*(1C) Test H_0:\beta_1=\beta_2=...=\beta_5*/
proc mixed data=babies1_a method=ML;
class id birthorder(ref=first);
model birthwt=birthorder age/noint s chisq;
repeated birthorder / type=un subject=id;
run;


/*(1D) Test H_0:\beta_j=0*/
proc mixed data=babies1_a method=ML;
	class id birthorder(ref=first);
	model birthwt=birthorder /noint s chisq;
	repeated birthorder / type=un subject=id;
run;
/*(1E) Test H_0: \beta_1=0 where \beta_1=...=\beta_5*/

/*(1F) Test H_0: \beta_1=0 where \alpha_1=...=\alpha_5*/
proc mixed data=babies1_a method=ML;
	class id birthorder(ref=first);
	model birthwt=age /s chisq;
	repeated birthorder/ type=un subject=id;
run;


/*(1G) Fit model M2: E[Y_ij]=\alpha+\beta(age_{ij}-20)*/
ods output solutionF = pGout;
proc mixed data=babies1_a method=ML;
	class id birthorder(ref=first);
	model birthwt=age/ s chisq outp = OUTP ;
	repeated birthorder / type=un subject=id;
run;


/*(1H) Fit model M3: probit(E[Y^*_{ij}])=\theta + phi(age_{ij}-20)*/ 


proc genmod data=babies1_a descending;
class id;
model low_bw=age/d=bin link=probit;
repeated subject = id / type = un ;
output pred = pred l = lower u = upper out = pred_output;
run;

/*(1I) M3 Estimates and CI*/
proc export data = pred_output
	outfile = "\\Client\H$\Desktop\Spring2019\BIOS_767\Final\qI.csv"
	dbms = csv
	replace;
run;


/*(1J) Fit model M4: probit(E[Y^*_{ij}|U_i]=\gamma + \delta(age_{ij}-20)+ U_i*/

proc nlmixed data=babies1_a qpoints=50;
  parms 
          int      =  -0.2917
          age_    =   -0.0303
          sigmasq  =  1;

  eta = int + age_*age + u;
  p = probnorm(eta);
  model  low_bw ~ binary(p);
  random u ~ normal(0, sigmasq)  subject=id;
  run;


/*(1K) ICC*/
data A;
  array beta{2} _temporary_  (-0.4063  -0.04342);
  array x_ij{2} _temporary_  (1  -5 ) ;*  time 1;
  array x_ik{2} _temporary_  (1   5) ;*  time 3;
  retain  sigmasq  0.8933  seed 2017767   nsim 1e5;
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

/*(1L)--no SAS write summary*/


  array beta{2} _temporary_  (-0.4063  -0.04342);
  array x_ij{2} _temporary_  (1  -5 ) ;*  time 1;
  array x_ik{2} _temporary_  (1   5) ;*  time 3;
  retain  sigmasq  0.8933  seed 2017767   nsim 1e5;

proc iml;
beta  =  {-0.4063  -0.04342};
x_ij  =  {1, -5}; * time 1, dose 0;
x_ik  =  {1, 5 }; * time 4, dose 0;
sigma =  sqrt(0.8933);
seed  =  j(1e5, 1, 2017767);
b_i   =  sigma * rannor(seed); * random effects;

eta_ij = b_i + t(x_ij) * beta;
eta_ik = b_i + t(x_ik) * beta;
nu_ij  = cdf('logistic', eta_ij); * conditional mean;
nu_ik  = cdf('logistic', eta_ik); * conditional mean;
mu_ij  = mean(nu_ij)         ; * E[Y_ij]  by double expectation;
mu_ik  = mean(nu_ik)         ; * E[Y_ik]  by double expectation;
mu_ijk = mean(nu_ij # nu_ik) ; * E[Y_ij Y_ik]  by double expectation;

* Y_ij;
* total variance = between + within;
total_ij   = mu_ij * (1 - mu_ij)   ;* Bernoulli;
between_ij = var(nu_ij)            ;* var(conditional mean);
within_ij  = mean(nu_ij#(1-nu_ij)) ;* E[conditional variance];
icc_ij = between_ij / total_ij;
print mu_ij  total_ij  within_ij  between_ij  icc_ij ;

* Repeat for Y_ik;
total_ik   = mu_ik * (1 - mu_ik)   ;* Bernoulli;
between_ik = var(nu_ik)            ;* var(conditional mean);
within_ik  = mean(nu_ik#(1-nu_ik)) ;* E[conditional variance];
icc_ik = between_ik / total_ik;
print mu_ik  total_ik  within_ik  between_ik  icc_ik ;


* correlation between Y_ij and Y_ik;
r_ijk = (mu_ijk - mu_ij * mu_ik) / sqrt(total_ij * total_ik);
print "corr(Y_ij, Y_ik): " ;
print r_ijk ;

or_ijk  = mu_ijk * (1 - mu_ij - mu_ik + mu_ijk)
               / (mu_ij - mu_ijk) / (mu_ik - mu_ijk); * odds ratio;
print "O.R.(Y_ij, Y_ik): " ;
print or_ijk ;
