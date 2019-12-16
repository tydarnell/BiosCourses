%let progname = tlc011.sas;
%let pdfout   = tlc011.pdf;

* input: tlc.dat
* output:
* xref:
* does: The TLC Trial
        A mixed model with a random intercept
  Obtain the following:
  * OUTPM: fitted marginal means,  X*BETA
  * OUTP:  predicted subject-specific means, X*BETA + Z*b
  * EBLUP: predicted subject-specific random effects, b

Cov Parm     Subject    Estimate

UN(1,1)      id          22.0859
Residual                 33.9761
        

*******************************************************************;
title1 "&progname Treatment of Lead Exposed Children (TLC) Trial";

filename INF "tlc.dat";

*******************************************************************;

data A;
  infile INF  firstobs=2;
  input id group $ lead0 lead1 lead4 lead6;
  baseline = lead0;
  lead = lead0; time = 0; output;
  lead = lead1; time = 1; output;
  lead = lead4; time = 4; output;
  lead = lead6; time = 6; output;
  keep id group time lead;
  label lead = "Blood lead level (ug/dL)";
  label time = "Time (week)";
  run;
 
data A; set A; timefactor = time; run;

*******************************************************************;

* OUTPM: fitted marginal means,  X*BETA;
* OUTP:  predicted subject-specific means, X*BETA + Z*b;
* EBLUP: predicted subject-specific random effects, b;

ods output solutionR = EBLUP;  * output table of empirical BLUP;

title2 "Mixed Effects Model for lead level with a random intercept";

ods listing close; * silent;

title2 "1. Mixed model with a random intercept, REML";

proc mixed data =  A method = reml noclprint = 10;
  class id group timefactor;
  model lead = time group
             / outp  = OUTP
               outpm = OUTPM  vciry;    * "model / vciry" -> scaledxxx;
     random intercept
            / subject = id type = un g solution ; * "random / solution" -> EBLUP;
run;

ods listing; * talk;

***********************************************;

ods pdf file = "&pdfout";

title2 "EBLUP dataset (predicted subject-specific random effects, b)";

proc contents data = EBLUP; run;
proc print data = EBLUP;
    var  id effect estimate stderrpred tvalue probt;
    run;

proc sort data = EBLUP; by effect; run;
proc means data = EBLUP;
    by effect;
    run;

***********************************************;

title2 "OUTPM dataset (fitted marginal means,  X*BETA)";

proc contents data = OUTPM; run;
proc print data = OUTPM (obs = 52 );
    var  id pred resid stderrpred lower upper scaleddep scaledresid;
    run;

***********************************************;
title2 "OUTP dataset (predicted subject-specific means, X*BETA + Z*b)";

proc contents data = OUTP; run;
proc print data = OUTP ;
    var  id pred resid stderrpred lower upper;
    run;

ods _all_ close;
