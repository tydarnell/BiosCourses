proc power;
   twosamplemeans test=diff
      meandiff = .
      stddev = 1
      npergroup = 10 20 50 100 200
      power = 0.8 0.9;
run;

proc power;
   onewayanova test=overall
      groupmeans = 3 | 7 | 8
      stddev = 1
      npergroup = 50
      power = .;
run;

proc power;
   onewayanova test=contrast
      contrast = (1 0 -1)
      groupmeans = 3 | 7 | 8
      stddev = 4
      groupns = (10 30 30)
      power = .;
run;

proc power;
   twosamplefreq test=pchi
      oddsratio = 2.5
      refproportion = 0.3
      groupweights = (1 2)
      ntotal = .
      power = 0.8;
run;
