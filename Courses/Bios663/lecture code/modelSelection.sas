options ls=70;

data a; do i = 1 to 500;
x1 = 10 + 5*rannor(0); * Normal(10, 25);
x2 = exp(3*rannor(0)); * lognormal;
x3 = 5+10*ranuni(0); * uniform;
x4 = 100 + 50*rannor(0); * Normal(100, 2500);
x5 = x1 + 3*rannor(0); * normal bimodal;
x6 = 2*x2 + ranexp(0); * lognormal and exponential mixture;
x7 = 0.5*exp(4*rannor(0)); * lognormal;
x8 = 10 +8*ranuni(0); * uniform;
x9 = x2 + x8 + 2*rannor(0); * lognormal, uniform and normal mix;
x10 = 200 +90*rannor(0); * normal(200, 8100);
y = 3*x2 - 4*x8 + 5*x9 + 3*rannor(0);
* true model with no intercept term;
output; end;


/*run all possible models*/
proc reg data=a outest=est;
model y=x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 /
selection=adjrsq sse aic ;
output out=out p=p r=r; run; quit;

/*run all possible models without intercept*/
proc reg data=a outest=est0;
model y=x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 /
noint selection=adjrsq sse aic ;
output out=out0 p=p r=r; run; quit;

/*forward selection*/
proc reg data=a outest=est1;
model y=x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 /
slentry=0.15 selection=forward
ss2 sse aic;
output out=out1 p=p r=r; run; quit;

/*backward selection*/
proc reg data=a outest=est2;
model y=x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 /
slstay=0.15 selection=backward
ss2 sse aic;
output out=out1 p=p r=r; run; quit;

/*stepwise selection*/
proc reg data=a outest=est3;
model y=x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 /
slstay=0.15 slentry=0.15 selection=stepwise
ss2 sse aic;
output out=out3 p=p r=r; run; quit;

/*stepwise group selection*/
proc reg data=a outest=est4;
model y={x1 x2} x3 x4 x5 x6 x7 x8 x9 x10 /
selection=stepwise slstay=0.15 slentry=0.15
groupnames='x1 x2' 'x3' 'x4' 'x5' 'x6'
'x7' 'x8' 'x9' 'x10';



  
