options ls=70;

data filen;
infile "FILEN.DAT";
input subject year cohort date days timsess height weight age area temp barm 
	hum avtrel avtrsp avfvc;
label subject="subject id"
      year="year of study"
	cohort="Ozone Dosage Level Group"
	date="Date of Study, Julian Date"
	days="# Days After 12-31-79"
	timsess="Time of Session"
	height="Height (cm)"
	weight="Weight (kg)"
	age="Age (years)"
	area="Body Surface Area (M**2)"
	temp="Air Temperature (deg C)"
	barm="Barometric Pressure (mmHg)"
	hum="Relative Humidity %"
	avtrel="Average Treadmill Elevation (deg)"
	avtrsp="Average Speed of Treadmill (mph)"
	avfvc="Average Forced Vital Capacity (mL)";
run;

data filen_2;
set filen;
int=avtrel*avtrsp;
bmi=10000*weight/(height*height);
tim2=timsess*timsess;
intercept=1;
run;
/*
proc means; var bmi avtrsp; run;
proc univariate; var timsess; run;
proc reg; model avfvc=bmi; run;
*/
proc print data=filen_2;
run;

/*Then, we created the scaled SSCP.*/

proc princomp data=filen_2 noint;
    var intercept height weight bmi area age avtrel avtrsp int temp barm hum;
run;

/* Making Correlation Matrix */

proc princomp data=filen_2;
    var height weight bmi area age avtrel avtrsp int temp barm hum;
run;
