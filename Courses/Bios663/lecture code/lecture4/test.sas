PROC IMPORT OUT= WORK.test 
            DATAFILE= "C:\Users\tydar\OneDrive\Documents\Bios663\lecture code\lecture4\USmelanoma.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

proc reg data = Work.test;
model mortality = latitude;
run;

