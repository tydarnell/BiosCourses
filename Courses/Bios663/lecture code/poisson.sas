title 'POISSON REGRESSION';

data a;
input age matings;
datalines;
27	0
28	1
28	1
28	1
28	3
29	0
29	0
29	0
29	2
29	2
29	2
30	1
32	2
33	4
33	3
33	3
33	3
33	2
34	1
34	1
34	2
34	3
36	5
36	6
37	1
37	1
37	6
38	2
39	1
41	3
42	4
43	0
43	2
43	3
43	4
43	9
44	3
45	5
47	7
48	2
52	9
;
proc genmod;
 model matings = age / dist  = poisson 
                       lrci covb;
proc genmod;
 model matings = age age*age / dist  = poisson 
                               lrci covb;
run;
quit;

title 'Ceriodaphnia Data';

proc import datafile = 'C:\Users\feizou\Desktop\Teaching\Bios663-2019\Spring2019\lecture18\ceriodaphnia.csv'
 out = Ceriodaphnia
 dbms = CSV
 REPLACE
 ;



proc genmod;
model Cerio = Conc Strain / dist = poisson
lrci covb;
run; quit;



title 'Skin Cancer Data';


proc import datafile = 'C:\Users\feizou\Desktop\Teaching\Bios663-2019\Spring2019\lecture18\skincancer.csv'
 out = skin
 dbms = CSV
 REPLACE
 ;

data skin;
  set skin;
   lpop = log(pop);
run;

 proc print;
   run;

proc genmod;
class age city;
model y = age city/ dist = poisson 
                    offset= lpop 
                    lrci;
run;

proc genmod;
class age city;
model y/pop = age city/ dist = poisson
lrci;
run;

proc genmod;
class age city;
model y/pop = age city/ dist = bin
lrci;
run;


