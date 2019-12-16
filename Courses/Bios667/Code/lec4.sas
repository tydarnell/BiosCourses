%let progname = lec4.sas;

filename INF "tlc.dat";

DATA tlc;
INFILE INF firstobs=2;
INPUT id y1 y2 y3 y4;
y=y1; time=0; OUTPUT;
y=y2; time=1; OUTPUT;
y=y3; time=4; OUTPUT;
y=y4; time=6; OUTPUT;
DROP y1-y4;
RUN;

PROC MIXED DATA=tlc;
CLASS id time;
MODEL y = time /S CHISQ;
REPEATED time /TYPE=UN SUBJECT=id R;
CONTRAST ’Week 6 - Week 0’
time -1 0 0 1 / CHISQ;
