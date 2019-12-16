DATA mt;
   INFILE 'C:\sasdata/mt.dat' firstobs=2;
   INPUT ID $ group  rand_month  birth_month  ga_ultra  ga_est  ppnum  pd_pre  pd_post;
RUN;

proc print data=mt;
run;

Data trg2;
infile "C:\sasdata/trg.txt";
Input id $ group trg;
run;

proc print data= trg2;
run;

proc anova data=trg2;
class group;
model trg=group;
means group / hovtest=bf;
run;

