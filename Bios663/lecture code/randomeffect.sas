************************************************************************;
* lympho.sas                                                           *;
*                                                                      *;
* To study the effects of four drugs (A, B, C, and D, where D is a     *;
* placebo), four (4) mice from each of five (5) litters were used,     *;
* where litters were treated as blocks. Drugs were randomly assigned   *;
* to the mice within each litter. Lymphocyte counts (thousands per     *;
* cubic millimeter) were measured on each mouse.                       *;
*                                                                      *;
* Source: Mead, R., R.N. Curnow, and A.M. Hasted. 1993. Statistical    *;
*         Methods in Agriculture and Experimental Biology. Chapman     *;
*         and Hall, London, p65-66. S540.S7.M4.1993                    *;
************************************************************************;
Title1 "Drug Effects on Lymphocyte Counts";
Options PS=55 LS=80 PageNo=1 Nodate;

Data Lympho;
 Input Drug $ Litter LCytes;
 Label Drug="Drug" Litter="Litter" LCytes="Lymphocyte Counts";
Datalines;
A 1 7.1
B 1 6.7
C 1 7.1
D 1 6.7
A 2 6.1
B 2 5.1
C 2 5.8
D 2 5.4
A 3 6.9
B 3 5.9
C 3 6.2
D 3 5.7
A 4 5.6
B 4 5.1
C 4 5.0
D 4 5.2
A 5 6.4
B 5 5.8
C 5 6.2
D 5 5.3
;

Proc Print Data=Lympho Label;
Run;

Proc Plot Data=Lympho;
 Plot LCytes*Litter="*" $ Drug;
Run; 

/* Fit an RBD Model */
Proc Mixed Data=Lympho Method=REML CovTest;
 Class Litter Drug;
 Model LCytes = Drug;
 Random Litter;
 /* Compare drugs to the placebo level, one-tailed test */
 LSMeans Drug / Adjust=Dunnett PDiff=Control("D");
 LSMeans Drug / Adjust=Dunnett PDiff=ControlU("D");
Run;


*Screamer Study;

data screamer;
input subject control bear music both;
cards;
1   45    33    8    37
5   23    16    13    9
6   22    28    31    12
7   46    46    30    16
8   68    58    68    48
10   13    13    7    8
11   18    27    17    9
13   35    32    51    4
15   49    44    21    27
16   57    57    74    16
19   36    30    46    30
21   33    21    21    21
;

data screamer2(keep=subject trt scream);
set screamer;
trt='control'; scream=control; output;
trt='bear'; scream=bear; output;
trt='music'; scream=music; output;
trt='both'; scream=both; output;
run;

proc mixed data=screamer2;
class subject trt;
model scream=trt/s;
repeated/type=cs subject=subject r;
contrast 'bear-both' trt 1 -1 0 0;
contrast 'bear-control' trt 1 0 -1 0;
contrast 'bear-music' trt 1 0 0 -1;
contrast 'both-control' trt 0 1 -1 0;
contrast 'both-music' trt 0 1 0 -1;
contrast 'control-music' trt 0 0 1 -1;
run;


proc corr data=screamer cov;
var control bear music both;
run;

proc mixed data=screamer2 dfbw noclprint;
class subject trt;
model scream=trt/s;
repeated/type=un subject=subject r;
contrast 'bear-both' trt 1 -1 0 0;
contrast 'bear-control' trt 1 0 -1 0;
contrast 'bear-music' trt 1 0 0 -1;
contrast 'both-control' trt 0 1 -1 0;
contrast 'both-music' trt 0 1 0 -1;
contrast 'control-music' trt 0 0 1 -1;
run;


/*
Schizophrenia trial data

   PANSS scores for patients in six treamtent groups.
	positive and negative symptom scale (want it to decrease)
	positive sumptoms are hallucinations/delusions
	negative symptoms are social withdrawal and apathy
   Treatment codes:
      1=haloperidol
      2=placebo
      3=risperidone10
      4=risperidone16
      5=risperidone2
      6=risperidone6

Times of meaasurement: -1 0 1 2 4 6 8 (weeks)

Followed by:
   treatment code
   1/0=dropout due to inadequate response/other
*/
data new;
input pre base w1 w2 w4 w6 w8 trt dropout;
cards;
84 112 . 117 . . . 2 1
117 101 63 67 87 63 62 6 0
76 103 127 . . . . 4 1
78 93 93 49 40 46 62 1 0
62 52 50 45 44 47 52 3 0
66 77 94 . . . . 5 1
71 55 62 64 70 72 65 5 0
82 77 60 61 82 83 93 3 1
86 82 80 79 108 . . 6 1
73 60 79 55 58 65 51 1 0
68 56 79 89 . . . 2 1
85 83 86 81 72 . . 4 1
69 56 54 56 44 38 36 4 0
69 76 54 51 65 . . 5 1
88 93 74 77 54 55 47 3 0
81 79 76 59 82 90 99 6 0
87 84 70 55 74 . . 1 1
108 87 104 95 99 . . 2 1
77 81 81 79 73 66 67 3 0
71 78 60 62 80 65 81 5 0
92 103 95 83 86 83 86 4 0
77 69 44 60 58 70 68 2 0
83 77 66 89 72 81 . 1 1
70 64 51 45 67 . . 6 0
93 110 93 101 92 91 107 4 0
68 71 73 75 72 62 73 1 0
79 96 78 84 . . . 2 0
104 135 70 55 55 42 45 6 0
107 96 70 75 65 57 47 3 0
80 99 104 90 105 104 . 5 1
72 72 64 53 60 98 98 2 0
112 85 68 64 111 . . 5 1
65 91 61 49 53 . . 1 0
76 76 56 50 43 43 40 3 0
92 106 93 84 89 89 . 4 1
84 84 99 105 98 . . 1 1
94 106 76 75 84 88 88 2 1
80 72 69 77 70 75 72 4 0
66 54 56 51 50 46 48 6 0
71 79 74 71 . . . 5 1
88 100 81 75 72 78 88 3 0
83 93 54 51 40 47 37 6 0
104 96 90 . . . . 2 1
76 78 83 79 54 . . 5 1
66 67 66 44 . . . 3 0
83 91 80 85 109 69 89 3 0
114 135 62 84 66 42 70 6 0
106 147 69 83 79 97 57 5 0
117 128 86 65 69 112 105 4 0
102 113 105 116 95 113 111 2 0
85 101 79 59 77 79 134 1 1
119 111 84 94 83 108 . 2 1
62 91 85 68 68 64 63 6 0
97 108 84 95 89 92 116 5 0
79 126 87 56 55 31 35 4 0
119 139 112 141 . . . 1 1
82 87 85 109 93 118 92 3 0
115 114 91 97 115 88 99 3 0
94 118 116 153 . . . 2 1
85 97 79 74 70 78 93 4 0
109 125 107 97 92 88 84 6 0
88 107 124 114 132 113 . 5 1
85 98 121 . . . . 1 1
91 89 90 66 76 101 113 2 0
76 98 78 64 55 57 62 1 0
99 109 107 116 97 133 . 5 1
93 106 75 55 68 74 72 4 0
83 94 104 80 89 96 82 6 0
98 106 92 88 71 79 80 3 0
65 84 81 78 71 61 67 6 0
63 78 78 56 59 56 44 1 0
73 76 76 77 70 85 82 4 0
87 67 74 70 68 66 99 3 0
93 83 77 68 65 . . 5 0
73 72 57 57 53 55 48 2 0
101 108 100 119 96 94 88 6 0
76 79 84 73 79 . . 3 0
78 84 72 68 59 64 62 5 0
71 64 72 65 64 80 . 2 0
89 90 96 86 78 78 86 1 0
61 78 78 . . . . 4 1
62 62 52 52 41 45 . 5 0
77 74 68 69 63 69 59 4 0
94 87 72 57 85 71 51 6 0
115 119 97 91 100 106 . 6 0
99 78 71 66 78 76 . 4 1
86 98 98 96 80 . . 1 0
100 94 103 94 99 93 92 3 0
90 88 60 . . . . 5 0
103 95 110 107 86 95 108 2 0
93 93 90 91 94 102 109 1 1
91 104 111 102 107 107 111 4 0
112 101 112 113 141 . . 5 1
89 89 91 96 94 77 75 6 0
88 97 97 . . . . 2 0
83 76 81 90 88 . . 3 1
124 123 126 104 101 94 93 1 0
122 123 113 104 121 . . 2 0
108 104 106 102 . . . 3 1
119 109 92 109 76 110 93 5 0
97 114 120 92 86 100 94 6 0
93 88 56 59 48 62 72 4 0
95 92 112 108 97 100 97 4 0
102 100 90 91 90 98 . 2 1
92 101 84 78 82 80 75 5 0
95 92 75 71 63 82 79 6 0
88 91 91 97 95 99 . 1 1
70 73 80 67 77 71 57 3 0
82 83 92 88 100 . . 5 1
69 78 55 49 52 63 55 6 0
87 87 69 52 62 60 81 4 0
83 83 90 77 81 . . 3 0
63 77 57 64 52 52 47 2 0
85 110 97 80 79 . . 1 1
82 110 87 95 61 56 59 6 0
70 83 96 46 53 59 88 4 0
84 128 60 46 71 . . 5 0
93 102 119 112 98 90 80 1 0
107 129 131 . . . . 3 1
115 121 103 84 62 144 . 2 1
112 145 134 138 103 96 86 4 0
105 140 109 76 63 54 . 5 0
98 121 98 76 56 55 61 3 0
116 137 85 56 60 49 59 6 0
144 161 116 85 . . . 1 1
103 110 87 66 72 104 . 2 1
91 103 78 78 85 . . 5 1
74 85 80 77 93 . . 6 0
102 111 79 63 65 64 63 4 0
90 111 97 81 113 . . 3 1
82 64 68 66 106 . . 1 1
72 77 95 . . . . 2 0
65 73 73 75 69 . . 5 1
88 96 72 76 85 . . 4 1
74 62 58 65 59 47 49 4 0
80 110 95 92 103 93 . 1 1
63 62 72 78 74 75 70 6 0
85 101 65 44 36 33 37 3 0
85 96 51 62 63 . . 4 0
79 97 126 114 . . . 5 1
86 101 134 . . . . 2 1
61 92 96 96 . . . 4 1
116 120 103 86 111 . . 1 1
101 111 122 . . . . 2 1
62 84 80 72 . . . 3 1
96 113 121 . . . . 5 1
110 119 104 87 99 94 . 6 1
83 78 91 87 92 88 93 5 0
66 84 93 75 79 79 73 2 0
85 112 121 137 . . . 1 1
85 87 63 48 50 65 . 3 1
67 58 87 79 89 . . 4 1
87 108 105 84 118 . . 6 1
101 103 100 83 100 105 . 3 1
88 91 87 110 125 . . 2 1
82 83 73 82 80 76 86 1 0
67 66 56 53 . . . 6 0
107 120 117 102 115 . . 5 1
120 120 114 102 80 71 87 4 0
62 80 65 73 . . . 1 1
61 111 50 58 49 51 50 4 0
92 98 95 91 91 89 93 3 0
82 87 81 78 73 98 106 1 0
64 76 67 56 52 47 40 5 0
112 111 111 119 124 . . 6 1
105 78 84 91 107 . . 2 1
79 106 102 95 95 . . 6 1
61 60 52 49 45 46 50 1 0
83 123 122 122 . . . 2 1
116 121 109 116 120 116 116 3 0
82 76 61 59 77 89 97 4 0
102 104 142 142 . . . 5 1
78 77 61 66 59 55 52 2 0
96 103 95 98 98 98 109 5 0
80 89 113 84 84 . . 4 0
78 89 65 63 56 50 45 3 0
88 75 79 76 79 86 91 1 0
82 90 54 51 78 107 114 6 0
80 99 98 92 112 . . 1 1
110 107 114 101 96 103 102 3 0
70 76 76 . . . . 2 0
73 77 53 49 49 43 44 5 0
63 70 60 55 54 54 56 6 0
102 95 88 90 61 70 70 4 0
96 115 71 88 94 84 83 6 0
103 118 114 102 103 60 52 3 0
77 89 86 78 75 75 66 2 0
87 99 106 122 . . . 5 1
101 101 . . . . . 1 0
95 102 112 . . . . 4 1
66 81 71 . . . . 3 0
74 77 84 64 . . . 5 1
95 117 90 72 74 94 74 4 0
81 78 74 62 60 73 82 1 0
71 60 60 56 60 62 58 6 0
63 71 96 96 97 . . 2 0
96 108 94 94 106 . . 6 1
111 126 126 . . . . 2 0
80 79 83 82 79 83 90 5 0
79 78 . . . . . 4 0
71 77 80 . . . . 1 0
86 73 60 70 77 67 81 3 0
78 65 55 52 48 43 48 6 0
70 78 71 75 66 85 72 4 0
74 79 70 73 87 81 86 2 0
78 87 83 89 98 107 . 1 1
106 104 118 126 . . . 3 1
67 75 75 71 78 82 76 5 0
88 95 87 101 104 . . 6 1
112 111 101 97 106 96 117 4 1
73 . . . . . . 3 0
84 80 69 82 90 . . 2 1
80 71 73 71 61 56 58 1 0
81 79 71 63 80 92 . 5 1
77 84 72 87 93 . . 1 1
102 93 97 98 97 112 81 4 0
84 99 91 80 73 83 68 1 0
104 91 86 . . . . 2 1
109 95 87 100 101 96 114 6 0
100 131 120 . . . . 3 1
100 120 115 82 102 64 78 6 0
91 110 106 115 131 128 125 1 0
102 98 100 72 92 96 89 5 0
114 104 . . . . . 2 1
115 139 148 . . . . 3 1
102 121 87 107 . . . 4 0
119 113 118 . . . . 2 1
86 116 108 . . . . 5 0
104 120 133 . . . . 1 1
101 92 95 90 . . . 6 0
113 . 120 . 126 122 118 4 0
79 61 64 55 58 56 69 3 0
101 98 102 85 86 101 94 1 0
82 96 92 99 89 86 81 4 0
93 110 82 91 94 94 101 6 0
62 81 78 78 74 64 54 2 0
63 55 51 51 47 51 97 5 1
90 113 102 93 111 106 . 6 0
78 87 77 76 76 78 73 3 0
88 79 89 93 84 88 . 4 1
60 69 42 56 67 . . 5 1
119 132 138 110 119 110 106 2 0
99 97 105 105 . . . 1 0
86 79 91 73 89 . . 1 1
87 83 97 95 . . . 6 0
60 84 60 94 82 97 . 2 1
87 98 103 65 72 77 51 4 0
81 78 60 61 49 55 52 3 0
113 69 66 54 43 43 53 5 0
87 116 108 96 101 83 73 3 0
72 61 58 56 55 83 . 2 1
83 98 91 65 77 . . 6 0
95 96 108 103 103 129 . 5 1
60 85 69 70 53 56 58 4 0
77 104 67 81 78 . . 1 0
110 116 118 114 121 115 117 2 0
103 110 112 . 133 . . 1 0
104 109 104 103 99 88 103 5 1
106 107 99 101 86 84 86 6 0
74 75 75 68 59 50 59 3 0
103 108 98 97 80 82 96 4 0
119 108 101 91 83 84 75 6 0
107 117 113 112 108 108 107 5 0
100 94 88 81 79 73 78 4 0
118 125 126 126 124 132 125 3 0
81 84 83 81 84 81 87 2 0
91 83 80 88 85 85 79 1 0
73 63 73 82 75 64 69 5 0
106 97 101 109 114 . . 5 1
103 86 94 86 93 109 . 2 1
66 64 63 55 58 43 60 3 0
95 113 130 . . . . 1 1
83 84 . . . . . 4 0
72 94 87 97 . . . 6 1
69 67 66 62 64 62 60 4 0
93 . 129 . . . . 3 0
107 97 82 81 69 89 69 5 0
101 94 98 111 110 . . 1 1
88 94 81 86 84 81 84 2 0
72 65 57 62 . . . 6 0
95 106 93 . . . . 1 1
108 105 79 78 77 78 76 2 0
72 71 98 . . . . 3 1
76 80 87 . . . . 5 1
90 83 102 78 84 61 77 4 0
93 110 73 73 78 69 64 6 0
75 96 . . . . . 4 0
72 90 74 74 92 . . 2 1
86 95 85 76 78 72 85 6 0
85 82 79 73 68 64 66 3 0
72 87 87 92 . . . 5 1
94 73 87 91 . . . 1 0
77 87 73 69 54 69 52 3 0
80 121 79 74 64 60 65 4 0
83 63 66 39 58 73 95 2 0
102 102 102 109 107 95 80 5 1
89 95 52 55 45 44 40 6 0
90 79 81 79 93 . . 5 0
84 82 87 74 85 79 65 6 0
108 105 53 53 44 44 44 1 0
93 78 54 54 83 97 77 3 0
90 105 71 61 63 63 65 4 0
97 96 82 73 85 81 89 2 0
76 83 84 . . . . 6 0
99 95 76 79 77 83 79 4 0
88 102 62 56 99 80 61 3 0
86 96 85 88 114 100 . 2 1
72 67 75 64 63 62 63 1 0
115 144 161 . . . . 5 1
112 109 123 113 113 110 99 3 0
85 116 92 104 . . . 1 1
70 73 63 60 62 59 58 5 0
85 109 48 48 . . . 4 0
87 113 101 93 96 91 88 2 0
86 92 96 81 75 92 95 6 0
87 90 61 69 45 83 . 5 1
74 100 102 . . . . 1 0
100 98 113 . . . . 4 0
75 101 . . . . . 3 0
118 120 83 67 58 60 68 6 0
68 97 118 . . . . 2 1
85 88 108 . . . . 3 1
87 100 54 53 58 44 . 4 0
91 99 94 . . . . 2 1
110 119 118 . . . . 1 1
84 89 58 . . . . 6 0
91 105 116 130 . . . 5 1
82 84 67 80 67 77 74 1 0
94 99 123 . . . . 2 1
84 89 123 121 . . . 5 1
74 65 58 55 58 . . 6 0
84 75 92 117 . . . 4 1
77 96 65 79 75 76 . 3 1
66 81 57 57 65 . . 6 0
90 91 62 65 . . . 4 1
90 94 84 93 84 84 94 6 0
76 74 82 103 . . . 4 1
90 90 100 113 . . . 2 1
101 129 113 116 114 . . 1 1
83 94 77 74 64 . . 5 0
75 72 60 65 67 75 . 3 1
90 71 76 . . . . 5 1
97 112 94 76 103 77 93 6 0
117 107 103 73 103 99 96 3 0
102 99 86 92 130 . . 2 1
118 127 116 131 . . . 1 1
103 124 112 89 110 . . 4 0
94 99 135 . . . . 3 1
91 102 109 111 108 . . 1 1
92 92 106 95 87 86 92 1 0
79 70 66 63 55 46 57 6 0
78 77 65 61 47 42 65 3 0
67 60 51 49 51 52 54 5 0
89 111 97 94 . . . 2 1
73 62 60 56 54 53 54 4 0
74 65 87 79 59 54 60 1 0
73 73 74 68 . . . 2 1
69 74 77 72 64 67 . 3 0
73 84 72 67 59 60 59 5 0
76 77 47 40 40 40 38 6 0
79 75 52 46 . . . 4 0
97 108 94 114 112 98 98 3 0
76 79 91 103 115 93 98 5 0
78 85 74 74 78 . . 2 1
96 104 75 73 76 75 71 1 0
94 139 87 89 66 63 60 4 0
104 108 80 85 69 71 72 6 0
103 81 114 135 . . . 2 1
99 122 70 72 73 . . 6 0
110 115 120 123 123 117 120 4 0
94 49 50 44 52 51 51 3 0
78 105 100 109 91 95 69 1 0
82 53 43 45 70 128 . 5 1
96 127 98 152 . . . 1 1
85 129 109 92 79 64 63 6 0
97 124 107 115 135 152 . 3 1
78 90 66 104 113 119 . 4 1
109 99 79 113 120 122 . 2 1
109 127 92 144 145 155 . 3 1
118 121 128 133 . . . 5 1
76 64 62 82 83 74 65 1 0
71 76 48 52 37 43 47 6 0
70 73 81 87 . . . 3 1
79 74 60 54 49 45 . 1 0
84 92 72 78 . . . 2 1
87 85 49 57 61 . . 5 0
70 84 56 60 56 52 48 4 0
80 91 85 52 60 . . 3 0
68 68 52 47 38 42 38 6 0
77 79 93 81 79 88 93 1 1
65 77 96 . . . . 5 1
87 90 86 80 77 65 62 4 0
65 78 97 . . . . 2 1
74 67 77 85 113 122 106 2 0
108 104 89 93 100 104 90 5 0
119 93 81 76 67 54 56 6 0
98 93 97 104 107 94 98 1 0
65 68 75 81 77 73 76 4 0
76 75 99 . . . . 3 0
104 92 90 . 71 . . 1 0
85 95 94 99 97 94 96 5 0
98 88 107 100 90 98 88 6 0
84 97 73 62 79 67 . 4 0
83 76 75 81 . . . 3 1
95 91 88 100 94 . . 2 1
62 73 81 . . . . 4 0
72 60 52 55 46 39 42 3 0
91 102 94 93 87 . . 6 1
82 67 108 . . . . 5 1
86 90 94 115 72 74 73 1 0
113 105 102 89 69 51 49 2 0
119 122 118 101 117 111 . 3 1
92 101 98 92 92 . . 5 1
81 73 75 65 64 66 62 1 0
92 90 85 96 100 89 95 2 0
70 80 72 75 69 59 72 6 0
90 80 84 77 85 . . 2 1
90 96 92 99 102 . . 5 1
95 93 96 84 85 98 78 3 0
70 67 74 62 92 . . 1 1
81 91 93 74 78 77 72 4 0
69 88 60 49 65 46 47 1 0
86 93 86 94 . . . 2 1
97 79 86 91 66 57 106 4 0
98 113 99 98 84 98 95 6 0
99 94 107 104 . . . 3 1
61 74 60 55 69 58 50 5 0
104 120 130 . . . . 2 1
82 87 92 103 . . . 1 1
79 78 81 119 . . . 5 1
117 134 119 131 114 129 133 6 0
81 92 94 91 75 90 96 1 0
87 96 78 77 77 117 114 4 0
72 77 67 52 43 47 43 2 0
94 119 118 . . . . 3 0
62 65 55 42 47 46 49 6 0
76 76 91 84 69 69 76 4 0
77 84 77 62 52 61 61 1 0
71 82 73 77 72 70 72 3 0
83 79 75 74 . . . 2 1
70 76 58 65 59 51 37 5 0
74 80 70 51 44 41 44 6 0
70 92 98 . . . . 1 1
81 87 58 62 59 69 60 4 0
78 77 72 73 63 69 69 3 0
94 99 110 81 86 . . 2 1
69 78 61 68 86 . . 5 1
75 74 62 70 58 59 57 4 0
74 99 77 73 86 . . 2 1
84 80 78 . . . . 3 0
91 92 81 68 57 . . 6 0
72 75 70 69 71 . . 1 0
78 72 71 62 61 59 57 2 0
67 70 57 57 52 47 . 6 0
78 59 49 49 37 39 43 5 0
83 77 82 73 63 52 56 1 0
90 108 98 86 89 . . 4 0
76 77 71 60 58 49 40 3 0
71 67 61 66 58 55 53 5 0
80 84 79 75 64 73 . 6 0
75 66 62 68 69 74 73 3 0
88 91 90 90 104 . . 2 1
96 100 100 . . . . 4 1
82 91 . . . . . 1 0
76 72 . . . . . 2 0
63 91 91 79 70 64 58 5 0
116 125 102 76 70 74 64 4 0
91 107 48 73 75 54 56 1 0
118 132 120 156 . . . 2 1
95 96 60 47 53 46 43 5 0
95 103 92 81 42 80 . 6 1
108 110 113 100 . . . 3 1
89 84 83 94 . . . 5 1
107 119 121 . . . . 6 1
99 101 108 . . . . 4 1
99 107 84 100 122 . . 1 1
76 93 103 . . . . 2 1
68 81 96 . . . . 3 1
64 60 93 116 . . . 2 1
89 73 88 92 77 72 72 2 0
102 101 95 65 54 53 65 3 0
119 112 105 98 77 87 78 4 0
120 120 114 104 107 . . 6 1
108 108 110 . . . . 1 1
71 69 64 46 38 32 36 5 0
80 73 75 65 34 40 40 1 0
81 81 79 73 67 69 63 4 0
86 86 82 82 70 64 64 5 0
60 60 55 49 38 40 38 6 0
81 81 84 78 54 54 53 3 0
104 105 110 95 93 . . 2 1
85 85 85 83 95 86 80 1 0
77 96 75 67 74 74 93 4 0
78 92 84 . . . . 3 0
74 90 87 93 91 91 97 6 0
62 75 67 60 91 . . 2 1
82 105 92 81 75 . . 5 0
91 88 101 76 71 69 58 5 0
74 84 72 68 69 60 60 3 0
88 91 98 77 71 62 60 6 0
79 94 86 73 71 69 59 1 0
80 91 106 65 57 56 45 4 0
95 107 111 95 97 109 . 2 1
74 85 62 62 49 57 52 2 0
79 92 . . . . . 6 0
70 80 69 58 53 52 49 5 0
104 68 77 66 62 61 64 4 0
80 77 82 70 66 60 55 1 0
72 87 78 68 62 60 55 3 0
70 93 75 67 56 49 51 6 0
68 90 72 83 90 79 59 4 0
97 107 103 100 88 83 77 3 0
99 117 118 111 121 . . 1 1
69 85 82 85 79 73 78 5 0
77 110 99 118 92 88 74 2 0
66 79 97 93 73 61 56 4 0
93 105 135 . . . . 2 1
69 89 87 82 76 61 64 6 0
111 108 100 74 72 . . 3 0
85 100 86 . . . . 4 1
88 89 69 69 55 54 60 5 0
91 105 74 89 75 89 . 3 1
120 117 117 . . . . 6 0
;

proc means;
var base w1 w2 w4 w6 w8;
run;

data new2;
set new;
trtnew=trt;
if trt>2 then trtnew=3; 
id=_N_;
y=base; time=0; t=0; output;
y=w1; time=1; t=1; output;
y=w2; time=2; t=2; output;
y=w4; time=4; t=4; output;
y=w6; time=6; t=6; output;
y=w8; time=8; t=8; output;
run;
proc sort; by trtnew time; run;
proc means; var y; by trtnew time; run;

proc mixed data=new2 noclprint;
class id trtnew time t;
model y=trtnew time time*trtnew/s;
repeated t/type=un subject=id r;
estimate 'time 1 vs. baseline haloperidol1 - diff for placebo' 
	time*trtnew -1 1 0 0 0 0 1 -1 0 0 0 0 0 0 0 0 0 0/e;
estimate 'time 1 vs. baseline haloperidol1 - diff for risperidone' 
	time*trtnew 0 0 0 0 0 0 1 -1 0 0 0 0 -1 1 0 0 0 0/e;
estimate 'time 2 vs. baseline haloperidol1 - diff for placebo' 
	time*trtnew -1 0 1 0 0 0 1 0 -1 0 0 0 0 0 0 0 0 0/e;
estimate 'time 2 vs. baseline haloperidol1 - diff for risperidone' 
	time*trtnew 0 0 0 0 0 0 1 0 -1 0 0 0 -1 0 1 0 0 0/e;
estimate 'time 4 vs. baseline haloperidol1 - diff for placebo' 
	time*trtnew -1 0 0 1 0 0 1 0 0 -1 0 0 0 0 0 0 0 0/e;
estimate 'time 4 vs. baseline haloperidol1 - diff for risperidone' 
	time*trtnew 0 0 0 0 0 0 1 0 0 -1 0 0 -1 0 0 1 0 0/e;
estimate 'time 6 vs. baseline haloperidol1 - diff for placebo' 
	time*trtnew -1 0 0 0 1 0 1 0 0 0 -1 0 0 0 0 0 0 0 0/e;
estimate 'time 6 vs. baseline haloperidol1 - diff for risperidone' 
	time*trtnew 0 0 0 0 0 0 1 0 0 0 -1 0 -1 0 0 0 1 0/e;
estimate 'time 8 vs. baseline haloperidol1 - diff for placebo' 
	time*trtnew -1 0 0 0 0 1 1 0 0 0 0 -1 0 0 0 0 0 0 0/e;
estimate 'time 8 vs. baseline haloperidol1 - diff for risperidone' 
	time*trtnew 0 0 0 0 0 0 1 0 0 0 0 -1 -1 0 0 0 0 1/ e;
run;

proc mixed data=new2 noclprint method=ml;
class id trtnew time t;
model y=trtnew time time*trtnew/s;
repeated t/type=un subject=id r;
run;

proc mixed data=new2 noclprint method=ml;
class id trtnew t;
model y=trtnew time time*trtnew/s;
repeated t/type=un subject=id r;
run;


data new3;
set new;
trtnew=trt;
if trt>2 then trtnew=3; 
id=_N_;
y=w1; time=1; t=1; output;
y=w2; time=2; t=2; output;
y=w4; time=4; t=4; output;
y=w6; time=6; t=6; output;
y=w8; time=8; t=8; output;
run;

proc mixed data=new3 noclprint;
class id trtnew time t;
model y=trtnew time base/s;
repeated t / type=un subject=id r;
run;





