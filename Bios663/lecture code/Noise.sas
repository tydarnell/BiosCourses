options ls=70;

proc import datafile = 'C:\Users\feizou\Desktop\Teaching\Bios663-2019\Spring2019\lecture9\NOISESIZETYPESIDE.csv'
 out = noise
 dbms = CSV
 REPLACE
 ;

proc print;

/*
NOISE = Noise level reading (decibels) 
SIZE = Vehicle size: 1 small 2 medium 3 large 
TYPE = 1 standard silencer 2 Octel filter 
SIDE = 1 right side 2 left side of car 

and
\item SIZE1, which takes the value 1 for small cars and 0 otherwise
\item SIZE2, which takes the value 1 for medium cars and 0 otherwise
\item S1TYPE1, which takes the value 1 for small cars with the standard filter and zero otherwise
\item S2TYPE1, which takes the value 1 for medium cars with the standard filter and zero otherwise
*/

data noise2;
set noise;
if size=1 then size1=1; else size1=0;
if size=2 then size2=1; else size2=0;
if type=1 then type1=1; else type1=0;
if size=1 and type = 1 then s1type1=1; else s1type1=0;
if size=2 and type=1 then s2type1=1; else s2type1=0;
run;

proc print;
run;

proc glm;
 class size;
 model noise=size;
 lsmeans size/pdiff adjust=SCHEFFE;
 contrast 'large vs medium' size 1 -1 0;
 run;


proc glm;
model noise=size1 size2 type1 s1type1 s2type1/solution;
estimate 'Grand Mean'
        intercept 6 size1 2 size2 2 type1 3 s1type1 1 s2type1 1/divisor=6;
estimate 'Marg Mean: Small'
        intercept 2 size1 2 size2 0 type1 1 s1type1 1 s2type1 0/divisor=2;
estimate 'Marg Mean: Medium'
        intercept 2 size1 0 size2 2 type1 1 s1type1 0 s2type1 1/divisor=2;
estimate 'Marg Mean: Large'
        intercept 2 size1 0 size2 0 type1 1 s1type1 0 s2type1 0/divisor=2;
estimate 'Marg Mean: Standard'
        intercept 3 size1 1 size2 1 type1 3 s1type1 1 s2type1 1/divisor=3;
estimate 'Marg Mean: Octel'
        intercept 3 size1 1 size2 1 type1 0 s1type1 0 s2type1 0/divisor=3;

contrast 'Interaction Silencer by Size'
        intercept 0 size1 0 size2 0 type1 0 s1type1 1 s2type1 0,
        intercept 0 size1 0 size2 0 type1 0 s1type1 0 s2type1 1;

contrast 'Main Effect Vehicle Size'
        intercept 0 size1 2 size2 0 type1 0 s1type1 1 s2type1 0,
        intercept 0 size1 0 size2 2 type1 0 s1type1 0 s2type1 1;

contrast 'Main Effect Silencer'
        intercept 0 size1 0 size2 0 type1 3 s1type1 1 s2type1 1;
run;

proc glm;
model noise=size1 size2 type1 s1type1 s2type1/solution;
contrast 'SME Silencer at Size Small'
        intercept 0 size1 0 size2 0 type1 1 s1type1 1 s2type1 0;
contrast 'SME Silencer at Size Medium'
        intercept 0 size1 0 size2 0 type1 1 s1type1 0 s2type1 1;
contrast 'SME Silencer at Size Large'
        intercept 0 size1 0 size2 0 type1 1 s1type1 0 s2type1 0;
run;


proc glm;
model noise=size1 size2 type1 s1type1 s2type1/solution;
contrast 'SME Size at Standard Silencer'
        intercept 0 size1 1 size2 -1 type1 0 s1type1 1 s2type1 -1,
        intercept 0 size1 1 size2 0 type1 0 s1type1 1 s2type1 0;
contrast 'SME Size at Octel Silencer'
        intercept 0 size1 1 size2 -1 type1 0 s1type1 0 s2type1 0,
        intercept 0 size1 1 size2 0 type1 0 s1type1 0 s2type1 0;
run;

