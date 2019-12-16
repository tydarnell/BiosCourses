**************************************************************
Title: Bios 665 FINAL
Name: Cheynna Crowley
Date Due: 10/05/17
Output: BIOS665_FINAL.cacrowle
**************************************************************;
%LET job=BIOS665_FINAL;
%LET onyen=cacrowle;
%LET outdir=\\Client\H$\Desktop\Fall2017\BIOS665\HW;

OPTIONS NODATE MERGENOBY=WARN VARINITCHK=WARN LS=72 FORMCHAR="|----|+|---+=|-/\<>*" ;
ODS PDF FILE="&outdir\&job._&onyen..PDF" STYLE=JOURNAL;
/*********************************
Part 1
*********************************/

/*Read in Data*/
data P1;
input tumor $ treat $ PN_symptom $ count;
datalines;
small A none 15
small A sm_wh 25
small A quite 18
small A vmuch 12
small B none 10
small B sm_wh 25
small B quite 15
small B vmuch 18
small C none 13
small C sm_wh 26
small C quite 16
small C vmuch 10
med A none 11
med A sm_wh 19
med A quite 23
med A vmuch 12
med B none 8
med B sm_wh 15
med B quite 20
med B vmuch 20
med C none 9
med C sm_wh 19
med C quite 22
med C vmuch 10
larg A none 6
larg A sm_wh 8
larg A quite 20
larg A vmuch 22
larg B none 5
larg B sm_wh 5
larg B quite 15
larg B vmuch 30
larg C none 8
larg C sm_wh 8
larg C quite 19
larg C vmuch 22
;
run;

/*see if matches*/
proc freq data=P1 order=data;
weight count;
table tumor*treat*pn_symptom;
run;

data q1;
set P1;
small_med=0;
none_sw=0;
if tumor='small' or tumor='med' then small_med=1;
if PN_symptom='none' or PN_symptom='sm_wh' then none_sw=1;
run;

data q1_b;
set P1;
large=0;
quit_vm=0;
if tumor='larg' then large=1;
if PN_symptom='quite' or PN_symptom='vmuch' then quit_vm=1;
run;

title'Question 1 and 2';
proc freq data=q1;
weight count;
table treat*small_med*none_sw/nocol nopct chisq cmh(mf);;
run;

*title'Question 1 and 2';
*proc freq data=q1_b;
*weight count;
*table treat*large*quit_vm/nocol nopct chisq cmh(mf);;
*run;

title'Question 3';
proc freq data=P1 order=data;
weight count;
table treat*tumor*pn_symptom/nocol nopct chisq cmh(mf);;
run;


title'Question 4: TRT A';
proc freq data=P1 order=data;
weight count;
where treat='A';
table tumor*PN_symptom/cmh;
exact SCORR;
run;


title'Question 4: TRT B';
proc freq data=P1 order=data;
weight count;
where treat='B';
table tumor*PN_symptom/cmh;
exact SCORR;
run;

title'Question 4: TRT C';
proc freq data=P1 order=data;
weight count;
where treat='C';
table tumor*PN_symptom/cmh;
exact SCORR;
run;

title'Question 5';
proc freq data=q1;
weight count;
table tumor*treat*none_sw/nocol nopct chisq cmh(mf);
run;

title'Question 6';
proc freq data=P1 order=data;
weight count;
table tumor*PN_symptom*treat/nocol nopct chisq cmh;
run;

title'Question 7 and 8';
proc logistic data=q1_b alpha=0.05 order=data;
freq count;
class treat (ref='B') tumor(ref='small') / param=ref;
model quit_vm(event=last)=treat tumor;
run;

title'Question 9 and 10';
proc logistic data=P1 order=data;
freq count; 
class treat(ref='B') tumor(ref='small') /param=ref; 
model PN_symptom(ref='none')= treat tumor /link=glogit scale=none aggregate; 
run;


/*********************************
Part 2
*********************************/
data P2;
set '\\Client\H$\Desktop\Fall2017\BIOS665\rheumarth.sas7bdat';
run;


* 3 ordinal response -> proc logistic  
response ordered from good to poor
Include main effects for treatment(ref=placebo), sex (ref=MALE), and age of the patient as explanatory variables, 
;

proc contents data=P2;
run;
title'Question 11 and 12:Month 1';
proc logistic data=P2 order=data;
where month=1;
class sex(ref='M') trt(ref='P') /param=ref order=data; 
model status(ref='3')= sex trt age/ scale=none aggregate; 
run;


title'Question 11 and 12 :Month 3';
proc logistic data=P2 order=data;
where month=3;
class sex(ref='M') trt(ref='P') /param=ref; 
model status(ref='3')= sex trt age/ scale=none aggregate; 
run;


title'Question 11 and 12:Month 5';
proc logistic data=P2 order=data;
where month=5;
class sex(ref='M') trt(ref='P') /param=ref; 
model status(ref='3')= sex trt age/ scale=none aggregate; 
run;


title'Question 13';
proc logistic data=P2 order=data out=final_1 ; 
where month=1; 
class sex(ref='M') trt(ref='P') /param=ref;
model status= sex trt age/ link=clogit scale=none aggregate unequalslopes ;
poage: test age_3=age_2;
posex: test SEXF_3=SEXF_2;
potrt: test TRTA_3=TRTA_2;
run;

proc contents data=final_1;
run;


/*see if sex needs to be seperate slope*/
proc logistic data=P2 order=data; 
where month=1; 
class sex(ref='M') trt(ref='P') /param=ref;
model status= sex trt age/ link=clogit scale=none aggregate unequalslopes=sex;
run;


title'Question 14';

title'Question 15';
proc genmod data=P2 descending;
class id trt(ref='P') sex(ref='M') base_status(ref='1') month(ref='1');
model status=trt age sex base_status month trt*month/link=clogit dist=mult type3;
repeated subject=id /type=ind;
run;
proc genmod data=P2 descending;
class id trt(ref='P') sex(ref='M') base_status(ref='1') month(ref='1');
model status=trt age sex base_status month/link=clogit dist=mult type3;
repeated subject=id /type=ind;
run;

proc contents data=P2;
run;


title'Question 16';

proc genmod data=P2 descending;
class id trt(ref='P') sex(ref='M') base_status(ref='1') month(ref='1');
model status=trt age sex base_status month/link=clogit dist=mult type3;
repeated subject=id /type=ind;
estimate 'OR: Treatment' trt 1 -1  /exp;
lsmeans/pdiff exp cl;
run;
title'Question 17';



title'Question 18';
proc genmod data=P2 descending;
class id trt(ref='P') sex(ref='M') base_status(ref='1') month(ref='1')/ param=reference;
model improve = trt month base_status sex age trt*month/link=logit dist=bin type3;
repeated subject=id /type=exch covb corrw;
run;


proc genmod data=P2 descending;
class id trt(ref='P') sex(ref='M') base_status(ref='1') month(ref='1')/ param=reference;
model improve = trt month base_status sex age/link=logit dist=bin type3;
repeated subject=id /type=exch covb corrw;
estimate 'OR: Treatment' trt 1 -1  /exp;
lsmeans/pdiff exp cl;
run;
title'Question 19';




title'Question 20';

data Q20;
input physician $ patient $ count @@;
datalines;
vp vp 12 vp p 2
vp f 4 vp g 2 vp vg 3
p vp 3 p p 7
p f 3 p g 4 
p vg 2 f vp 2
f p 3 f f 9
f g 2 f vg 4
g vp 2 g p 5
g f 1 g g 6
g vg 4 vg vp 4
vg p 3 vg f 3
vg g 2 vg vg 8
;
run;
proc freq data=Q20 order=data;
weight count;
table physician*patient/agree norow nocol nopct;
run;



/*********************************
Part 3
**********************************/

/*read in data*/
data P3;
input time $ sex $ age $ admissions count;
log_add=log(admissions);
datalines;
1846_1848 male 2_15 4057 404
1846_1848 male gt15 4359 354
1846_1848 female 2_15 3331 362
1846_1848 female gt15 6481 369
1849_1850 male 2_15 4412 718
1849_1850 male gt15 4438 631
1849_1850 female 2_15 3538 602
1849_1850 female gt15 6416 634
;
run;
title'Question 21';
proc genmod data=P3 order=data; 
class time sex(ref='male') age /param=ref;
model count=time sex age/dist=poisson offset=log_add type3;
run;



title'Question 22';
proc genmod data=P3 order=data; 
class time sex(ref='male') age /param=ref;
model count=time sex age time*sex time*age sex*age time*sex*age/dist=poisson offset=log_add type3;
run;

proc genmod data=P3 order=data; 
class time sex(ref='male') age /param=ref;
model count=time sex age time*sex time*age sex*age/dist=poisson offset=log_add type3;
run;

proc genmod data=P3 order=data; 
class time sex(ref='male') age /param=ref;
model count=time sex age time*sex sex*age/dist=poisson offset=log_add type3;
run;


proc genmod data=P3 order=data; 
class time sex(ref='male') age /param=ref;
model count=time sex age sex*age/dist=poisson offset=log_add type3;
run;
