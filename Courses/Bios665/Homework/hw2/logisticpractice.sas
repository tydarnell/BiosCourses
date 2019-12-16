data ski;
input vitc cold count;
cards;
1 1 17
1 0 122
0 1 31
0 0 109
;
proc logistic descending;
freq count;
model cold=vitc;
run;

data uti;
input diagnosis $ trt $ cure $ count;
cards;
complicated A cured 78
complicated A not 28
complicated B cured 101
complicated B not 11
complicated C cured 68
complicated C not 46
uncomplicated A cured 40
uncomplicated A not 5
uncomplicated B cured 54
uncomplicated B not 5
uncomplicated C cured 34
uncomplicated C not 6
;


proc logistic;
freq count;
class diagnosis trt/param=ref;
model cure=diagnosis|trt;
run;
proc logistic;
freq count;
class diagnosis trt/param=ref;
model cure=diagnosis trt;
run;
