DATA seizure;
   INFILE 'C:\Users\tydar\Documents\Bios667\Homework\hw3\seizure.dat' firstobs=2;
   INPUT id $ treatment age y;
RUN;

proc print data=seizure;
run;

proc genmod data=seizure;
model y = treatment / dist = poisson;
run;

proc genmod data=seizure;
class id;
model y = treatment age / dist = poisson;
repeated subject=id;
run;
