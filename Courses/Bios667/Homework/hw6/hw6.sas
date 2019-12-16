
data ncgs; 
input group id y0-y4;
datalines;
1  1    178  246  295  228  274
1  2    254  260  278  245  340
1  3    185  232  215  220  292
1  4    219  268  241  260  320
1  5    205  232  265  242  230
1  6    182  213  173  200  193
1  7    310  334  290  286  248
1  8    191  204  227  228  196
1  9    245  270  209  255  213
1  10  229  200  238  259  221
1  11  245  293  261  297  231
1  12  240  313  251  307  291
1  13  234  281  277  235  210
1  14  210  252  275  235  237
1  15  275  231  285  238  251
1  16  269  332  300  320  335
1  17  148  180  184  231  184
1  18  181  194  212  217  205
1  19  165  242  250  249  312
1  20  293  276  276  278  306
1  21  195  190  205  217  238
1  22  210  230  249  240  194
1  23  212  224  246  271  256
1  24  243  271  304  273  318
1  25  259  279  296  262  283
1  26  202  214  192  239  172
1  27  184  192  205  253  217
1  28  238  272  297  282  251
1  29  263  283  248  334  271
1  30  144  226  261  227  283
1  31  220  272  222  246  253
1  32  225  260  253  202  265
1  33  224  273  242  274    .  
1  34  307  252  316  258  283
1  35  313  300  313  317  397
1  36  231  252  267  299    .  
1  37  206  177  194  194  212
1  38  285  291  291  268  260
1  39  250  269    .      .      .  
1  40  175  214    .      .      .  
1  41  201  219  220    .      .  
1  42  268  296  314  330    .  
1  43  202  186  253    .      .  
1  44  260  268    .      .      .  
1  45  209  207  167    .      .  
1  46  197  218    .      .      .  
1  47  248  262    .      .      .  
1  48  212  253  225    .      .  
1  49  276  326  304    .      .  
1  50  163  179  199    .      .  
1  51  239  243  265    .      .  
1  52  204  203  198    .      .  
1  53  247  211  225    .      .  
1  54  195  250  272    .      .  
1  55  228  228  279    .      .  
1  56  290  264  260    .      .  
1  57  284  288  268  261    .  
1  58  217  231  276  257    .  
1  59  209  200  269  233    .  
1  60  200  261  264  300    .  
1  61  227  247    .      .    220
1  62  193  189    .    232  211
2  63  251  262  239  234  248
2  64  233  218  230  251  273
2  65  250  258  258  286  240
2  66  141  143  157  162  169
2  67  418  371  363  384  387
2  68  229  218  228  244  179
2  69  271  289  270  296  346
2  70  312  323  318  383  310
2  71  194  220  214  256  204
2  72  211  232  189  230  231
2  73  205  299  278  259  266
2  74  191  248  283  268  233
2  75  249  217  236  266  235
2  76  301  270  282  287  268
2  77  201  214  247  274  224
2  78  251  257  237  266    .  
2  79  277  242  249  293  306
2  80  294  313  295  295  271
2  81  212  236  235  272  287
2  82  230  315  300  305  341
2  83  206  242  236  239    .  
2  84  246  205  249  225  236
2  85  245  192  215  214  242
2  86  179  202  194  239  234
2  87  165  142  188  192  200
2  88  262  274  245  275  278
2  89  212  216  228  221  223
2  90  285  292  300  319  277
2  91  166  171  166  186  220
2  92  179  206  214  189  250
2  93  298  280  280  328  318
2  94  238  267  269  268  280
2  95  172  180  216  183    .  
2  96  191  208  162  218  206
2  97  282  282    .      .      .  
2  98  213  249  219  209    .  
2  99  171  188    .      .      .  
2  100  242  268    .      .      .  
2  101  197  224  214    .      .  
2  102  230  228  266    .      .  
2  103  373  309  332    .      .  
;
run;

/* Q2: Compute descriptive statistics with proc corr ... */
proc print data=ncgs;
run;

proc sort data = ncgs; by group; run;
ods graphics on;
proc corr data = ncgs plots=matrix(histogram) noprob;
by group;
var y0-y4;
run;

data ncgslong (drop = y1-y4); set ncgs;
baseline = y0;
month = 0; chol = y0; output;
month = 6; chol = y1; output;
month = 12; chol = y2; output;
month = 20; chol = y3; output;
month = 24; chol = y4; output;
run;

proc sort data = ncgslong;
by group month;
run;

proc means nway data = ncgslong noprint;
by group month;
var chol;
output out = ncgsmeans mean = average;
run;

proc sgplot data = ncgsmeans;
series x = month y = average / group = group markers;
run;

proc mixed data = ncgslong;
class month (ref='0') id group (ref='2');
model chol = month group month * group / s chisq;
repeated month / type = un subject=id r;
run;

data chl;
  set ncgslong;
  treat = (group = 1);
  t0 = (month = 0);
  t6 = (month = 6);
  t12 = (month = 12);
  t20 = (month = 20);
  t24 = (month =24);
  run;


proc mixed data = chl order=data;
     class id month;
     model chol = t6 t12 t20 t24 treat*t6 treat*t12 treat*t20 treat*t24 / s chisq;
     repeated month / type=un subject=id r;
     contrast '3 DF Test of Interaction' 
          treat*t6 1, treat*t12 1, treat*t20 1, treat*t24 1 / chisq;
run;

data quad;
set ncgslong;
t=month;
x=(group=1);
t2=month*month;
xt=x*month;
xt2=x*t2;
run;


proc mixed data = quad order=data;
     class id month;
     model chol = t t2 xt xt2 / s chisq;
     repeated month / type=un subject=id r;
	 contrast 'test of interaction' xt 1, xt2 1 / chisq;
run;


data diff;
  set chl;
  if (month > 0);
  change =chol-baseline;
  run;

proc print data=diff;
run;

proc mixed data=diff  order=data;
     class id month;
     model change = treat t12 t20 t24  treat*t12 treat*t20 treat*t24/ s chisq;
     repeated month / type=un subject=id r;
     contrast 'Test of Main Effect and Interaction' 
          treat 1,treat*t12 1, treat*t20 1, treat*t24 1 / chisq;
run;



proc mixed data=diff  order=data;
     class id month;
     model change = baseline treat t12 t20 t24  treat*t12 treat*t20 treat*t24/ s chisq;
     repeated month / type=un subject=id r;
     contrast 'Test of Main Effect and Interaction' 
          treat 1,treat*t12 1, treat*t20 1, treat*t24 1 / chisq;
run;

proc mixed data=diff  order=data method=ML;
     class id month;
     model change = baseline treat t12 t20 t24  treat*t12 treat*t20 treat*t24/ s chisq;
     repeated month / type=un subject=id r group=group;
     contrast 'Test of Main Effect and Interaction' 
          treat 1,treat*t12 1, treat*t20 1, treat*t24 1 / chisq;
run;

proc mixed data=diff  order=data method=ML;
     class id month;
     model change = baseline t12 t20 t24 / s chisq;
     repeated month / type=un subject=id r group=group;
run;
