
*Homework 1 Bios 667;

DATA tlc ;    
INPUT id group $ lead0 lead1 lead4 lead6; 
 DATALINES;
  1      P     30.8    26.9    25.8    23.8
  2      A     26.5    14.8    19.5    21.0
  3      A     25.8    23.0    19.1    23.2
  4      P     24.7    24.5    22.0    22.5
  5      A     20.4     2.8     3.2     9.4
  6      A     20.4     5.4     4.5    11.9
  7      P     28.6    20.8    19.2    18.4
  8      P     33.7    31.6    28.5    25.1
  9      P     19.7    14.9    15.3    14.7
 10      P     31.1    31.2    29.2    30.1
 11      P     19.8    17.5    20.5    27.5
 12      A     24.8    23.1    24.6    30.9
 13      P     21.4    26.3    19.5    19.0
 14      A     27.9     6.3    18.5    16.3
 15      P     21.1    20.3    18.4    20.8
 16      P     20.6    23.9    19.0    17.0
 17      P     24.0    16.7    21.7    20.3
 18      P     37.6    33.7    34.4    31.4
 19      A     35.3    25.5    26.3    30.3
 20      A     28.6    15.8    22.9    25.9
 21      P     31.9    27.9    27.3    34.2
 22      A     29.6    15.8    23.7    23.4
 23      A     21.5     6.5     7.1    16.0
 24      P     26.2    26.8    25.3    24.8
 25      A     21.8    12.0    16.8    19.2
 26      A     23.0     4.2     4.0    16.2
 27      A     22.2    11.5     9.5    14.5
 28      P     20.5    21.1    17.4    21.1
 29      A     25.0     3.9    12.8    12.7
 30      P     33.3    26.2    34.0    28.2
 31      A     26.0    21.4    21.0    22.4
 32      A     19.7    13.2    14.6    11.6
 33      P     27.9    21.6    23.6    27.7
 34      P     24.7    21.2    22.9    21.9
 35      P     28.8    26.4    23.8    22.0
 36      A     29.6    17.5    21.0    24.2
 37      P     32.0    30.2    30.2    27.5
 38      P     21.8    19.3    16.4    17.6
 39      A     24.4    16.4    11.6    16.6
 40      A     33.7    14.9    14.5    63.9
 41      P     24.9    20.9    22.2    19.8
 42      P     19.8    18.9    18.9    15.5
 43      A     26.7     6.4     5.1    15.1
 44      A     26.8    20.4    19.3    23.8
 45      A     20.2    10.6     9.0    16.0
 46      P     35.4    30.4    26.5    28.1
 47      P     25.3    23.9    22.2    27.2
 48      A     20.2    17.5    17.4    18.6
 49      A     24.5    10.0    15.6    15.2
 50      P     20.3    21.0    16.7    13.5
 51      P     20.4    17.2    15.9    17.7
 52      P     24.1    20.1    17.9    18.7
 53      A     27.1    14.9    18.1    21.3
 54      A     34.7    39.0    28.8    34.7
 55      P     28.5    32.6    27.5    22.8
 56      P     26.6    22.4    21.8    21.0
 57      A     24.5     5.1     8.2    23.6
 58      P     20.5    17.5    19.6    18.4
 59      P     25.2    25.1    23.4    22.2
 60      P     34.7    39.5    38.6    43.3
 61      P     30.3    29.4    33.1    28.4
 62      P     26.6    25.3    25.1    27.9
 63      P     20.7    19.3    21.9    21.8
 64      A     27.7     4.0     4.2    11.7
 65      A     24.3    24.3    18.4    27.8
 66      A     36.6    23.3    40.4    39.3
 67      P     28.9    28.9    32.8    31.8
 68      A     34.0    10.7    12.6    21.2
 69      A     32.6    19.0    16.3    18.6
 70      A     29.2     9.2     8.3    18.4
 71      A     26.4    15.3    24.6    32.4
 72      A     21.8    10.6    14.4    18.7
 73      P     27.2    28.5    35.0    30.5
 74      P     22.4    22.0    19.1    18.7
 75      P     32.5    25.1    27.8    27.3
 76      P     24.9    23.6    21.2    21.1
 77      P     24.6    25.0    21.7    23.9
 78      P     23.1    20.9    21.7    19.9
 79      A     21.1     5.6     7.3    12.3
 80      P     25.8    21.9    23.6    24.8
 81      P     30.0    27.6    24.0    23.7
 82      A     22.1    21.0     8.6    24.6
 83      P     20.0    22.7    21.2    20.5
 84      P     38.1    40.8    38.0    32.7
 85      A     28.9    12.5    16.7    22.2
 86      P     25.1    28.1    27.5    24.8
 87      A     19.8    11.6    13.0    23.1
 88      P     22.1    21.1    21.5    20.6
 89      A     23.5     7.9    12.4    18.9
 90      A     29.1    16.8    15.1    18.8
 91      A     30.3     3.5     3.0    11.5
 92      P     25.4    24.3    22.7    20.1
 93      A     30.6    28.2    27.0    25.5
 94      A     22.4     7.1    17.2    18.7
 95      A     31.2    10.8    19.8    22.2
 96      A     31.4     3.9     7.0    17.8
 97      A     41.1    15.1    10.9    27.1
 98      A     29.4    22.1    25.3     4.1
 99      A     21.9     7.6    10.8    13.0
100      A     20.7     8.1    25.7    12.3
   ;
RUN;

proc ttest data=tlc sides=2 alpha=0.05 h0=0;
 	title "Two sample t-test example";
 	class group; 
	var lead0;
   run;

data A;
  set tlc;
  dif1 = (lead4) - (4*lead1) + (3*lead0);
  dif2 = (3*lead6) - (5*lead4) + (2*lead1);
  run;


  ***********************************************;

title3 "proc IML";

proc iml ;

***************************************************;
start hot1(y, mu0);
 * Hotelling's T^2 one-sample multivariate test;
 * y = data matrix, mu0 = column vector;

  n = nrow(y);
  d = ncol(y);
  ybar = t(mean(y));
  r = ybar - mu0;
  s = cov(y);
  a = solve(s, r);
  t2 = n * (t(r) * a);                * ~ T^2(d, n-1) under H0;
  t2_df1 = d;
  t2_df2 = n - 1;
  f   = t2 * (n - d) / (d * (n - 1)); * ~ F(d, n-d) under H0;
  f_df1 = d;
  f_df2 = n - d;
  pval = 1 - probf(f, f_df1, f_df2);
  maxroot = t2 / (n - 1);

  print "Hotelling's T^2 one-sample test";
  print n d;
  print ybar s;
  print "T^2:" ,  t2  t2_df1 t2_df2 ;
  print "F:"   ,  f   f_df1  f_df2;
  print pval;
  print "The max eigenvalue of E^{-1} H: "  maxroot;

  print "Coefficients:", a  [format=16.10];
  a2 = a / sqrt(a[##]);      print "Norm=1:", a2 [format=16.10];
  a3 = a / sqrt(t2*(n-1)/n); print "sas:",    a3 [format=16.10];

finish;
******************************************************;

* IML execution starts here;

use A;

print "Group: A";
read all var  {dif1 dif2} into y where (group = "A");
run hot1(y, j(2, 1, 0));

print "Group: P";
read all var  {dif1 dif2} into y where (group = "P");
run hot1(y, j(2, 1, 0));

******************************************************;


title3 "proc IML";

proc iml ;

***************************************************;
start ls1(y, mu0);
 * Large-sample one-sample multivariate test;
 * y = data matrix, mu0 = column vector;

  n = nrow(y);
  d = ncol(y);
  ybar = t(mean(y));
  r = ybar - mu0;
  s = cov(y);
  a = solve(s, r);
  x2 = n * (t(r) * a);          * ~ X^2(d) under H0, large n;
  x2_df = d;
  pval = 1 - probchi(x2, x2_df);

  print "Large sample-based one-sample test";
  print n d;
  print ybar s;
  print "X^2:" ,  x2  x2_df ;
  print pval;

finish;
******************************************************;

* IML execution starts here;

use A;

print "Group: A";
read all var  {dif1 dif2} into y where (group = "A");
run ls1(y, j(2, 1, 0));

print "Group: P";
read all var  {dif1 dif2} into y where (group = "P");
run ls1(y, j(2, 1, 0));



*******************************************************************
Question 5
*******************************************************************;

DATA brock ;    
INPUT id vocab1 vocab2 vocab3 vocab4; 
 DATALINES;
   1   1.75   2.60    3.76    3.68
   2   0.90   2.47    2.44    3.43
   3   0.80   0.93    0.40    2.27
   4   2.42   4.15    4.56    4.21
   5  -1.31  -1.31   -0.66   -2.22
   6  -1.56   1.67    0.18    2.33
   7   1.09   1.50    0.52    2.33
   8  -1.92   1.03    0.50    3.04
   9  -1.61   0.29    0.73    3.24
  10   2.47   3.64    2.87    5.38
  11  -0.95   0.41    0.21    1.82
  12   1.66   2.74    2.40    2.17
  13   2.07   4.92    4.46    4.71
  14   3.30   6.10    7.19    7.46
  15   2.75   2.53    4.28    5.93
  16   2.25   3.38    5.79    4.40
  17   2.08   1.74    4.12    3.62
  18   0.14   0.01    1.48    2.78
  19   0.13   3.19    0.60    3.14
  20   2.19   2.65    3.27    2.73
  21  -0.64  -1.31   -0.37    4.09
  22   2.02   3.45    5.32    6.01
  23   2.05   1.80    3.91    2.49
  24   1.48   0.47    3.63    3.88
  25   1.97   2.54    3.26    5.62
  26   1.35   4.63    3.54    5.24
  27  -0.56  -0.36    1.14    1.34
  28   0.26   0.08    1.17    2.15
  29   1.22   1.41    4.66    2.62
  30  -1.43   0.80   -0.03    1.04
  31  -1.17   1.66    2.11    1.42
  32   1.68   1.71    4.07    3.30
  33  -0.47   0.93    1.30    0.76
  34   2.18   6.42    4.64    4.82
  35   4.21   7.08    6.00    5.65
  36   8.26   9.55   10.24   10.58
  37   1.24   4.90    2.42    2.54
  38   5.94   6.56    9.36    7.72
  39   0.87   3.36    2.58    1.73
  40  -0.09   2.29    3.08    3.35
  41   3.24   4.78    3.52    4.84
  42   1.03   2.10    3.88    2.81
  43   3.58   4.67    3.83    5.19
  44   1.41   1.75    3.70    3.77
  45  -0.65  -0.11    2.40    3.53
  46   1.52   3.04    2.74    2.63
  47   0.57   2.71    1.90    2.41
  48   2.18   2.96    4.78    3.34
  49   1.10   2.65    1.72    2.96
  50   0.15   2.69    2.69    3.50
  51  -1.27   1.26    0.71    2.68
  52   2.81   5.19    6.33    5.93
  53   2.62   3.54    4.86    5.80
  54   0.11   2.25    1.56    3.92
  55   0.61   1.14    1.35    0.53
  56  -2.19  -0.42    1.54    1.16
  57   1.55   2.42    1.11    2.18
  58  -0.04   0.50    2.60    2.61
  59   3.10   2.00    3.92    3.91
  60  -0.29   2.62    1.60    1.86
  61   2.28   3.39    4.91    3.89
  62   2.57   5.78    5.12    4.98
  63  -2.19   0.71    1.56    2.31
  64  -0.04   2.44    1.79    2.64
  ;
  run;


data B;
set brock;
  dif1 = vocab2 - vocab1;
  dif2 = vocab3 - vocab2;
  dif3 = vocab4 - vocab3;
  run;


title3 "proc IML";

proc iml ;

***************************************************;
start hot1(y, mu0);
 * Hotelling's T^2 one-sample multivariate test;
 * y = data matrix, mu0 = column vector;

  n = nrow(y);
  d = ncol(y);
  ybar = t(mean(y));
  r = ybar - mu0;
  s = cov(y);
  a = solve(s, r);
  t2 = n * (t(r) * a);                * ~ T^2(d, n-1) under H0;
  t2_df1 = d;
  t2_df2 = n - 1;
  f   = t2 * (n - d) / (d * (n - 1)); * ~ F(d, n-d) under H0;
  f_df1 = d;
  f_df2 = n - d;
  pval = 1 - probf(f, f_df1, f_df2);
  maxroot = t2 / (n - 1);

  print "Hotelling's T^2 one-sample test";
  print n d;
  print ybar s;
  print "T^2:" ,  t2  t2_df1 t2_df2 ;
  print "F:"   ,  f   f_df1  f_df2;
  print pval;
  print "The max eigenvalue of E^{-1} H: "  maxroot;

  print "Coefficients:", a  [format=16.10];
  a2 = a / sqrt(a[##]);      print "Norm=1:", a2 [format=16.10];
  a3 = a / sqrt(t2*(n-1)/n); print "sas:",    a3 [format=16.10];

finish;
******************************************************;

* IML execution starts here;

use B;

print "Group: Brock";
read all var  {dif1 dif2 dif3} into y;
run hot1(y, j(3, 1, 0));


****************************/;

data C;
set brock;
  dif1 = 2*vocab2 - vocab1 -vocab3 ;
  dif2 = 2*vocab3 - vocab2 -vocab4;
  run;


title3 "proc IML";

proc iml ;

***************************************************;
start hot1(y, mu0);
 * Hotelling's T^2 one-sample multivariate test;
 * y = data matrix, mu0 = column vector;

  n = nrow(y);
  d = ncol(y);
  ybar = t(mean(y));
  r = ybar - mu0;
  s = cov(y);
  a = solve(s, r);
  t2 = n * (t(r) * a);                * ~ T^2(d, n-1) under H0;
  t2_df1 = d;
  t2_df2 = n - 1;
  f   = t2 * (n - d) / (d * (n - 1)); * ~ F(d, n-d) under H0;
  f_df1 = d;
  f_df2 = n - d;
  pval = 1 - probf(f, f_df1, f_df2);
  maxroot = t2 / (n - 1);

  print "Hotelling's T^2 one-sample test";
  print n d;
  print ybar s;
  print "T^2:" ,  t2  t2_df1 t2_df2 ;
  print "F:"   ,  f   f_df1  f_df2;
  print pval;
  print "The max eigenvalue of E^{-1} H: "  maxroot;

  print "Coefficients:", a  [format=16.10];
  a2 = a / sqrt(a[##]);      print "Norm=1:", a2 [format=16.10];
  a3 = a / sqrt(t2*(n-1)/n); print "sas:",    a3 [format=16.10];

finish;
******************************************************;

* IML execution starts here;

use C;

print "Group: Brock";
read all var  {dif1 dif2} into y;
run hot1(y, j(2, 1, 0));
