* BIOS 767 Homeowlr
*
*
*
*
;


data chol;
   INFILE '\\Client\H$\Desktop\Spring2019\BIOS_767\Homework\HW03\cholesterol.dat' firstobs=2;
   INPUT trt id chol0 chol6 chol12 chol20 chol24;
run;

proc sort data =chol ;
by trt; 
run;

proc summary data = chol  nway;
  class trt;
  var  chol0 chol6 chol12 chol20 chol24;
  output
    out  = chol_2
    mean = chol0 chol6 chol12 chol20 chol24
    std  = std0  std6  std12  std20 std24
	var  = var0  var6   var12 var20 var24
    n    = n0    n6    n12    n20 n24
  ;
  run;

proc print   data = chol_2;
  var trt  chol0 chol6 chol12 chol20 chol24 std0  std6  std12  std20 std24 var0  var6   var12 var20 var24;
  run;

proc print   data = chol_2;
  var trt  n0 n1 n4 n6 std0  std6  std12  std20 std24 ;
  run;

/* 5.1.4 */
proc transpose data=chol out=long;
   by id trt;
run;

/* 5.1.5 */

data long2;set long;
rename _NAME_=time col1=y;
run;


proc mixed data=long2;
	class id trt (ref='2') time(ref='chol0');
	model y = trt time trt*time / S chisq;
	repeated time / type=UN subject=id R Rcorr;
run;


/* 5.1.6 */
proc corr data=cholesterol noprob outp=OutCorr nomiss cov;
	var y1 y2 y3 y4 y5;
run;

/* 5.1.10 */


proc mixed data=long2;
	class id group (ref='2') time(ref='y1');
	model y = group time group*time/ S chisq;
	repeated time / type=UN subject=id R Rcorr;
run;
