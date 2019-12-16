*Outlier SAS Code;

/*******************************************************
EXAMPLE DATASET: The example dataset has been expanded to include more predictors
and more observations.

Variables:  case = id
			pubs = # of publications 
			time = years since phd
			cits = # of citations
			salary = salary
			female = gender -> female=1 male=0
			age = age of the professor
			rank = 0 = assistant professor
                   1 = associate professor
                   2 = full professor
********************************************************/

data phd;
input case time pubs cits salary female age rank;
cards;
1	3	18	50	51876	1	34	1
2	6	3	26	54511	1	38	0
3	3	2	50	53425	1	31	0
4	8	17	34	61863	0	38	1
5	9	11	41	52926	1	39	1
6	6	6	37	47034	0	34	0
7	16	38	48	66432	0	52	2
8	10	48	56	61100	0	45	2
9	2	9	19	41934	0	40	0
10	5	22	29	47454	0	37	0
11	5	30	28	49832	1	44	1
12	6	21	31	47047	0	49	1
13	7	10	25	39115	1	35	1
14	11	27	40	59677	0	44	1
15	18	37	61	61458	0	59	2
16	6	8	32	54528	0	35	1
17	9	13	36	60327	1	40	1
18	7	6	69	56600	0	41	1
19	7	12	47	52542	1	44	1
20	3	29	29	50455	1	54	0
21	7	29	35	51647	1	38	1
22	5	7	35	42895	0	51	1
23	7	6	18	53740	0	34	0
24	13	69	90	75822	0	61	2
25	5	11	60	56596	0	33	1
26	8	9	30	55682	1	38	2
27	8	20	27	62091	1	41	1
28	7	41	35	42162	1	57	0
29	2	3	14	52646	1	39	0
30	13	27	56	74199	0	50	2
31	5	14	50	50729	0	59	0
32	3	23	25	70011	0	41	1
33	1	1	35	37939	0	41	0
34	3	7	1	39652	0	30	0
35	9	19	69	68987	0	54	1
36	3	11	69	55579	0	49	0
37	9	31	27	54671	0	41	2
38	3	9	50	57704	0	55	0
39	4	12	32	44045	1	48	0
40	10	32	33	51122	0	49	2
41	1	26	45	47082	0	57	1
42	11	12	54	60009	0	43	2
43	5	9	47	58632	0	68	0
44	1	6	29	38340	0	39	0
45	21	39	69	71219	0	59	2
46	7	16	47	53712	1	56	1
47	5	12	43	54782	1	51	0
48	16	50	55	83503	0	49	2
49	5	18	33	47212	0	36	0
50	4	16	28	52840	1	45	0
51	5	5	42	53650	0	52	0
52	11	20	24	50931	0	37	2
53	16	50	31	66784	1	42	2
54	3	6	27	49751	1	39	1
55	4	19	83	74343	1	60	1
56	4	11	49	57710	1	41	1
57	5	13	14	52676	0	39	1
58	6	3	36	41195	1	49	0
59	4	8	34	45662	1	44	0
60	8	11	70	47606	1	59	1
61	3	25	27	44301	1	41	2
62	4	4	28	58582	1	38	0
;
run;

/* All-Possible-Regressions Procedures */

proc reg data = phd;
model salary = time pubs cits age / selection = rsquare adjrsq aic sbc;
run;

/* Automatic search procedures */

/* Forward selection*/

proc stepwise data=phd;
model salary = time cits pubs age / forward slentry=.2;
run;

/* Backward elimination */

proc stepwise data=phd;
model salary = time cits pubs age / backward slstay=.1; 
run;

/* Stepwise regression */

proc stepwise data=phd;
model salary = time cits pubs age / stepwise;
run;

/* stepwise procedure has a bunch of options - here are a few */
/* model y = x1 x2 x3 / slentry=0.5; /* sig level for selection */
/* model y = x1 x2 x3 / slstay=0.1;  /* signif. level for elimination */
/* model y = x1 x2 x3 / include=2;   /* force in first 2 variables */
/* model y = x1 x2 x3 / start=2;     /* start with 2 variables */
/* model y = x1 x2 x3 / details;     /* more details of R^2, F stats */
