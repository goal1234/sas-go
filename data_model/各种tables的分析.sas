data respires;
  input treat $ outcome $ count;
  datalines;
placebo f 16
placebo u 48
test    f 40
test    u 20
;

proc freq;
  weight count;
  tables treat*outcome;  *这个是对所有的进行回归;
run;

data respire;
input treat $ outcome $ @@;
datalines;
placebo f placebo f placebo f
placebo f placebo f
placebo u placebo u placebo u
placebo u placebo u placebo u
placebo u placebo u placebo u
placebo u
test f test f test f
test f test f test f
test f test f
test u test u test u
test u test u test u
test u test u test u
test u test u test u
test u test u test u
test u test u test u
test u test u
;

proc freq;
  tables treat*outcome;
run;

data arthrit;
length treat $7. sex $6. ;
input sex $ treat $ improve $ count @@;
datalines;
female active marked 16 female active some 5 female active none 6
female placebo marked 6 female placebo some 7 female placebo none 19
male  active marked 5 male active some 2 male active none 7
male placebo marked 1 male placebo some 0 male placebo none 10
;
run;

proc freq order = data;
  weight count;
  tables treat*improve;
run;

proc freq order = data;
  weight count;
  tables sex*treat*improve/ncol nopct;
run;

*******************************************the 2*2 table*******************************;
data respire;
input treat $ outcome $ count;
datalines;
placebo f 16
placebo u 48
test f 40
test u 20
;
proc freq;
weight count;
tables treat*outcome / chisq;
run;

*Exact Tests;
data severe;
input treat $ outcome $ count;
datalines;
Test f 10
Test u 2
Control f 2
Control u 4
;
proc freq order=data;
  weight count;
  tables treat*outcome / chisq nocol;
run;

*Exact p-values for Chi-Square Statistics;
proc freq order = data;
  weight count;
  tables treat*outcome/chisq nocol;
  exact chisq;
run;

*Difference in Proportions;
ods select RiskDiffColl Measures;
data respire2;
  input treat $ outcome $ count @@;
  datalines;
test    f 40 test    u 20
placebo f 16 placebo u 48
;
proc freq order = data;
  weight count;
  tables treat*outcome/riskdiff measures;
run;

*Odds Ratio and Relative Risk;
data stress;
input stress $ outcome $ count;
datalines;
low f 48
low u 12
high f 96
high u 94
;
proc freq order=data;
  weight count;
  tables stress*outcome / chisq measures nocol nopct;
run;

data respire;
input treat $ outcome $ count;
datalines;
test yes 29
test no 16
placebo yes 14
placebo no 31
;
proc freq order=data;
weight count;
tables treat*outcome / all nocol nopct;
run;

*Exact Confidence Limits for the Odds Ratio;
data severe;
input treat $ outcome $ count;
datalines;
Test f 10
Test u 2
Control f 2
Control u 4
;
proc freq order=data;
  weight count;
  tables treat*outcome / nocol;
exact or;
run;

*Sensitivity and Specificity;
data approval;
input hus_resp $ wif_resp $ count;
datalines;
yes yes 20
yes no 5
no yes 10
no no 10
;
ods select McNemarsTest;
proc freq order=data;
weight count;
tables hus_resp*wif_resp / agree;
run;


****************************************Sets of 2  2 Tables***********************;
*Respiratory Data Example;
data respire;
input center treatment $ response $ count @@;
datalines;
1 test y 29 1 test n 16
1 placebo y 14 1 placebo n 31
2 test y 37 2 test n 8
2 placebo y 24 2 placebo n 21
;

proc freq order=data;
weight count;
tables center*treatment*response /
nocol nopct chisq cmh;
run;

*Health Policy Data;
data stress;
input region $ stress $ outcome $ count @@;
datalines;
urban low f 48 urban low u 12
urban high f 96 urban high u 94
rural low f 55 rural low u 135
rural high f 7 rural high u 53
;

proc freq order=data;
  weight count;
  tables region*stress*outcome / chisq cmh nocol nopct;
run;

data soft;
input gender $ country $ question $ count @@;
datalines;
male American y 29 male American n 6
male British y 19 male British n 15
female American y 7 female American n 23
female British y 24 female British n 29
;
proc freq order=data;
weight count;
tables gender*country*question /
chisq cmh nocol nopct;
run;

*Measures of Association;
data ca;
input gender $ ECG $ disease $ count;
datalines;
female <0.1 yes 4
female <0.1 no 11
female >=0.1 yes 8
female >=0.1 no 10
male <0.1 yes 9
male <0.1 no 9
male >=0.1 yes 21
male >=0.1 no 6
;
proc freq;
weight count;
tables gender*disease / nocol nopct chisq;
tables gender*ECG*disease / nocol nopct cmh chisq measures;
run;

*************************************************************Sets of 2 * r and s * 2 Tables****************************;
data arth;
input gender $ treat $ response $ count @@;
datalines;
female test none 6 female test some 5 female test marked 16
female placebo none 19 female placebo some 7 female placebo marked 6
male test none 7 male test some 2 male test marked 5
male placebo none 10 male placebo some 0 male placebo marked 1
;
proc freq data=arth order=data;
weight count;
tables treat*response / chisq nocol nopct;
run;

*Choosing Scores;
*Analyzing the Arthritis Data;
data arth;
input gender $ treat $ response $ count @@;
datalines;
female test none 6 female test some 5 female test marked 16
female placebo none 19 female placebo some 7 female placebo marked 6
male test none 7 male test some 2 male test marked 5
male placebo none 10 male placebo some 0 male placebo marked 1
;
proc freq data=arth order=data;
weight count;
tables gender*treat*response / cmh nocol nopct;
run;

proc freq data=arth order=data;
weight count;
tables gender*treat*response/cmh scores=modridit nocol nopct;
run;

*Colds Example;
data colds;
input gender $ residence $ per_cold count @@;
datalines;
female urban 0 45 female urban 1 64 female urban 2 71
female rural 0 80 female rural 1 104 female rural 2 116
male urban 0 84 male urban 1 124 male urban 2 82
male rural 0 106 male rural 1 117 male rural 2 87
;
proc freq data=colds order=data;
weight count;
tables gender*residence*per_cold / all nocol nopct;
run;

*Sets of s  2 Tables;
*Analysis of Smokeless Tobacco Data;
data tobacco;
length risk $11. ;
input f_usage $ risk $ usage $ count @@;
datalines;
no minimal no 59 no minimal yes 25
no moderate no 169 no moderate yes 29
no substantial no 196 no substantial yes 9
yes minimal no 11 yes minimal yes 8
yes moderate no 33 yes moderate yes 11
yes substantial no 22 yes substantial yes 2
;

proc freq;
  weight count;
  tables f_usage*risk*usage /cmh chisq measures trend;
  tables f_usage*risk*usage /cmh scores=modridit;
run;

*Pain Data Analysis;data pain;
input diagnosis $ treatment $ response $ count @@;
datalines;
I placebo no 26 I placebo yes 6
I dosage1 no 26 I dosage1 yes 7
I dosage2 no 23 I dosage2 yes 9
I dosage3 no 18 I dosage3 yes 14
I dosage4 no 9 I dosage4 yes 23
II placebo no 26 II placebo yes 6
II dosage1 no 12 II dosage1 yes 20
II dosage2 no 13 II dosage2 yes 20
II dosage3 no 1 II dosage3 yes 31
II dosage4 no 1 II dosage4 yes 31
;
proc freq order=data;
  weight count;
  tables treatment*response / chisq;
  tables diagnosis*treatment*response / chisq cmh;
  tables diagnosis*treatment*response / scores=modridit cmh;
run;

proc freq order=data;
  weight count;
  tables diagnosis*response*treatment / cmh;
  tables diagnosis*treatment*response / cmh;
run;

**********************************************The s  r Table*********************;
data neighbor;
  length party $ 11 neighborhood $ 10;
  input party $ neighborhood $ count @@;
datalines;
democrat longview 360 democrat bayside 221
democrat sheffeld 140 democrat highland 160
republican longview 316 republican bayside 208
republican sheffeld 97 republican highland 106
independent longview 160 independent bayside 200
independent sheffeld 311 independent highland 291
;

proc freq ;
  weight count;
  tables party*neighborhood / chisq cmh nocol nopct;
run;

*Mean Score Test;
data pain;
input treatment $ hours count @@;
datalines;
placebo 0 6 placebo 1 9 placebo 2 6 placebo 3 3 placebo 4 1
standard 0 1 standard 1 4 standard 2 6 standard 3 6 standard 4 8
test 0 2 test 1 5 test 2 6 test 3 8 test 4 6
;
proc freq;
  weight count;
  tables treatment*hours/ cmh nocol nopct;
run;

*Correlation Test;

data wash;
  input treatment $ washability $ count @@;
  datalines;
  water low 27 water medium 14 water high 5
  standard low 10 standard medium 17 standard high 26
  super low 5 super medium 12 super high 50
;
proc freq order=data;
  weight count;
  tables treatment*washability / chisq cmh nocol nopct;
  tables treatment*washability / scores=modridit cmh
  noprint nocol nopct;
run;

*Exact Tests for Association;
data market;
length AdSource $ 9. ;
input car $ AdSource $ count @@;
datalines;
sporty paper 3 sporty radio 4 sporty tv 0 sporty magazine 3
sedan paper 0 sedan radio 2 sedan tv 4 sedan magazine 0
utility paper 2 utility radio 2 utility tv 5 utility magazine 5
;
run;
proc freq;
weight count;
table car*AdSource / norow nocol nopct;
exact fisher pchi lrchi;
run;

*Test of Correlation;
data disorder;
input dose outcome count @@;
datalines;
25 0 1 25 1 1 25 2 1 25 3 0
50 0 1 50 1 2 50 2 1 50 3 1
75 0 0 75 1 0 75 2 2 75 3 2
100 0 0 100 1 0 100 2 7 100 3 0
;

proc freq;
weight count;
tables dose*outcome / nocol norow nopct;
exact mhchi;
run;

data wash;
input treatment $ washability $ count @@;
datalines;
water low 27 water medium 14 water high 5
standard low 10 standard medium 17 standard high 26
super low 5 super medium 12 super high 50
;
proc freq order=data;
weight count;
tables treatment*washability / measures noprint nocol nopct cl;
tables treatment*washability / measures scores=rank noprint cl;
run;

*exact p-value for the Spearman’s rank test;
data soccer;
input grades $ degree $ count @@;
datalines;
1-2 low 3 1-2 medium 1 1-2 high 0
3-4 low 3 3-4 medium 2 3-4 high 1
5-6 low 1 5-6 medium 3 5-6 high 2
;
run;

proc freq order=data;
weight count;
tables grades*degree / nocol nopct norow;
exact scorr;
run;

*Nominal Measures of Association;
data neighbor;
length party $ 11 neighborhood $ 10;
input party $ neighborhood $ count @@;
datalines;
democrat longview 360 democrat bayside 221
democrat sheffeld 140 democrat highland 160
republican longview 316 republican bayside 208
republican sheffeld 97 republican highland 106
independent longview 160 independent bayside 200
independent sheffeld 311 independent highland 291
;
proc freq ;
weight count;
tables party*neighborhood / chisq measures nocol nopct;
run;


data classify;
input no_rater w_rater count @@;
datalines;
1 1 38 1 2 5 1 3 0 1 4 1
2 1 33 2 2 11 2 3 3 2 4 0
3 1 10 3 2 14 3 3 5 3 4 6
4 1 3 4 2 7 4 3 3 4 4 10
;
proc freq;
weight count;
tables no_rater*w_rater / agree norow nocol nopct;
run;

data pilot;
input rater1 rater2 count @@;
datalines;
1 1 4 1 2 0 1 3 1 1 4 0
2 1 0 2 2 2 2 3 6 2 4 1
3 1 1 3 2 0 3 3 2 3 4 1
4 1 0 4 2 2 4 3 1 4 4 3
;
proc freq;
weight count;
tables rater1*rater2 /norow nocol nopct;
exact kappa;
run;

*Test for Ordered Differences;
data operate;
input hospital trt $ severity $ wt @@;
datalines;
1 v+d none 23 1 v+d slight 7 1 v+d moderate 2
1 v+a none 23 1 v+a slight 10 1 v+a moderate 5
1 v+h none 20 1 v+h slight 13 1 v+h moderate 5
1 gre none 24 1 gre slight 10 1 gre moderate 6
2 v+d none 18 2 v+d slight 6 2 v+d moderate 1
2 v+a none 18 2 v+a slight 6 2 v+a moderate 2
2 v+h none 13 2 v+h slight 13 2 v+h moderate 2
2 gre none 9 2 gre slight 15 2 gre moderate 2
3 v+d none 8 3 v+d slight 6 3 v+d moderate 3
3 v+a none 12 3 v+a slight 4 3 v+a moderate 4
3 v+h none 11 3 v+h slight 6 3 v+h moderate 2
3 gre none 7 3 gre slight 7 3 gre moderate 4
4 v+d none 12 4 v+d slight 9 4 v+d moderate 1
4 v+a none 15 4 v+a slight 3 4 v+a moderate 2
4 v+h none 14 4 v+h slight 8 4 v+h moderate 3
4 gre none 13 4 gre slight 6 4 gre moderate 4
;

proc freq order=data;
weight wt;
tables trt*severity / norow nocol nopct jt;
run;

************************************************Sets of s  r Tables*******************************;
*Dumping Syndrome Data;

data operate;
input hospital trt $ severity $ wt @@;
datalines;
1 v+d none 23 1 v+d slight 7 1 v+d moderate 2
1 v+a none 23 1 v+a slight 10 1 v+a moderate 5
1 v+h none 20 1 v+h slight 13 1 v+h moderate 5
1 gre none 24 1 gre slight 10 1 gre moderate 6
2 v+d none 18 2 v+d slight 6 2 v+d moderate 1
2 v+a none 18 2 v+a slight 6 2 v+a moderate 2
2 v+h none 13 2 v+h slight 13 2 v+h moderate 2
2 gre none 9 2 gre slight 15 2 gre moderate 2
3 v+d none 8 3 v+d slight 6 3 v+d moderate 3
3 v+a none 12 3 v+a slight 4 3 v+a moderate 4
3 v+h none 11 3 v+h slight 6 3 v+h moderate 2
3 gre none 7 3 gre slight 7 3 gre moderate 4
4 v+d none 12 4 v+d slight 9 4 v+d moderate 1
4 v+a none 15 4 v+a slight 3 4 v+a moderate 2
4 v+h none 14 4 v+h slight 8 4 v+h moderate 3
4 gre none 13 4 gre slight 6 4 gre moderate 4
;
proc freq order=data;
weight wt;
tables hospital*trt*severity / cmh;
tables hospital*trt*severity / cmh scores=modridit;
run;

*Shoulder Harness Data;
data shoulder;
input area $ location $ size $ usage $ count @@;
datalines;
coast urban large no 174 coast urban large yes 69
coast urban medium no 134 coast urban medium yes 56
coast urban small no 150 coast urban small yes 54
coast rural large no 52 coast rural large yes 14
coast rural medium no 31 coast rural medium yes 14
coast rural small no 25 coast rural small yes 17
piedmont urban large no 127 piedmont urban large yes 62
piedmont urban medium no 94 piedmont urban medium yes 63
piedmont urban small no 112 piedmont urban small yes 93
piedmont rural large no 35 piedmont rural large yes 29
piedmont rural medium no 32 piedmont rural medium yes 30
piedmont rural small no 46 piedmont rural small yes 34
mountain urban large no 111 mountain urban large yes 26
mountain urban medium no 120 mountain urban medium yes 47
mountain urban small no 145 mountain urban small yes 68
mountain rural large no 62 mountain rural large yes 31
mountain rural medium no 44 mountain rural medium yes 32
mountain rural small no 85 mountain rural small yes 43
;
proc freq;
  weight count;
  tables size*usage / chisq;
  tables area*location*size*usage / cmh scores=modridit;
  tables area*size*usage / noprint cmh scores=modridit;
  tables location*size*usage / noprint cmh scores=modridit;
run;

*Learning Preference Data;
data school;
  input school program $ style $ count @@;
  datalines;
1 regular self 10 1 regular team 17 1 regular class 26
1 after self 5 1 after team 12 1 after class 50
2 regular self 21 2 regular team 17 2 regular class 26
2 after self 16 2 after team 12 2 after class 36
3 regular self 15 3 regular team 15 3 regular class 16
3 after self 12 3 after team 12 3 after class 20
;
proc freq;
  weight count;
  tables school*program*style / cmh chisq measures;
run;



data pump;
input subject time $ response $ @@;
datalines;
1 before no 1 after no 2 before no 2 after no
3 before no 3 after no 4 before no 4 after no
5 before no 5 after no 6 before no 6 after no
7 before no 7 after no 8 before no 8 after no
9 before no 9 after no 10 before no 10 after no
11 before no 11 after no 12 before no 12 after no
13 before no 13 after no 14 before no 14 after no
15 before no 15 after no 16 before no 16 after no
17 before no 17 after no 18 before no 18 after no
19 before no 19 after no 20 before no 20 after no
21 before no 21 after no 22 before no 22 after no
23 before no 23 after no 24 before no 24 after no
25 before no 25 after no 26 before no 26 after no
27 before no 27 after no 28 before no 28 after no
29 before no 29 after no 30 before no 30 after no
31 before no 31 after no 32 before no 32 after no
33 before no 33 after no 34 before no 34 after no
35 before no 35 after no 36 before no 36 after no
37 before no 37 after no 38 before no 38 after no
39 before no 39 after no 40 before no 40 after no
41 before no 41 after no 42 before no 42 after no
43 before no 43 after no 44 before no 44 after no
45 before no 45 after no 46 before no 46 after no
47 before no 47 after no 48 before no 48 after no
49 before no 49 after yes 50 before no 50 after yes
51 before no 51 after yes 52 before no 52 after yes
53 before no 53 after yes 54 before no 54 after yes
55 before no 55 after yes 56 before no 56 after yes
57 before no 57 after yes 58 before no 58 after yes
59 before no 59 after yes 60 before no 60 after yes
61 before no 61 after yes 62 before no 62 after yes
63 before no 63 after yes 64 before yes 64 after no
65 before yes 65 after no 66 before yes 66 after no
67 before yes 67 after no 68 before yes 68 after no
69 before yes 69 after yes 70 before yes 70 after yes
71 before yes 71 after yes 72 before yes 72 after yes
73 before yes 73 after yes 74 before yes 74 after yes
75 before yes 75 after yes 76 before yes 76 after yes
77 before yes 77 after yes 78 before yes 78 after yes
79 before yes 79 after yes 80 before yes 80 after yes
81 before yes 81 after yes 82 before yes 82 after yes
83 before yes 83 after yes 84 before yes 84 after yes
85 before yes 85 after yes 86 before yes 86 after yes
87 before yes 87 after yes
;
proc freq;
tables subject*time*response/ noprint cmh out=freqtab;
run;
data shoes;
input before $ after $ count ;
datalines;
yes yes 19
yes no 5
no yes 15
no no 48
;
proc freq;
weight count;
tables before*after / agree;
run;


data drug;
input druga $ drugb $ drugc $ count;
datalines;
F F F 6
F F U 16
F U F 2
F U U 4
U F F 2
U F U 4
U U F 6
U U U 6
;
data drug2; set drug;
keep patient drug response;
retain patient 0;
do i=1 to count;
patient=patient+1;
drug=’A’; response=druga; output;
drug=’B’; response=drugb; output;
drug=’C’; response=drugc; output;
end;
proc freq;
tables patient*drug*response / noprint cmh;
run;


data cold;
keep id day drainage;
input id day1-day4;
day=1; drainage=day1; output;
day=2; drainage=day2; output;
day=3; drainage=day3; output;
day=4; drainage=day4; output;
datalines;
1 1 1 2 2
2 0 0 0 0
3 1 1 1 1
4 1 1 1 1
5 0 2 2 0
6 2 0 0 0
7 2 2 1 2
8 1 1 1 0
9 3 2 1 1
10 2 2 2 3
11 1 0 1 1
12 2 3 2 2
13 1 3 2 1
14 2 1 1 1
15 2 3 3 3
16 2 1 1 1
17 1 1 1 1
18 2 2 2 2
19 3 1 1 1
20 1 1 2 1
21 2 1 1 2
22 2 2 2 2
23 1 1 1 1
24 2 2 3 1
25 2 0 0 0
26 1 1 1 1
27 0 1 1 0
28 1 1 1 1
29 1 1 1 0
30 3 3 3 3
;
proc freq;
tables id*day*drainage / cmh noprint;
tables id*day*drainage / cmh noprint scores=rank;
run;

data animals;
keep id pulse severity;
input id sev2 sev4 sev6 sev8 sev10;
pulse=2; severity=sev2; output;
pulse=4; severity=sev4; output;
pulse=6; severity=sev6; output;
pulse=8; severity=sev8; output;
pulse=10; severity=sev10; output;
datalines;
6 0 0 5 0 3
7 0 3 3 4 5
8 0 3 4 3 2
9 2 2 3 0 4
10 0 0 4 4 3
12 0 0 0 4 4
13 0 4 4 4 0
15 0 4 0 0 0
16 0 3 0 1 1
17 . . 0 1 0
19 0 0 1 1 0
20 . 0 0 2 2
21 0 0 2 3 3
22 . 0 0 3 0
;
proc freq;
tables id*pulse*severity / noprint cmh;
tables id*pulse*severity / noprint cmh2 scores=rank;
tables id*pulse*severity / noprint cmh2 scores=ridit;
tables id*pulse*severity / noprint cmh2 scores=modridit;
run;

proc freq data=animals;
where id notin(17,20,22);
tables id*pulse*severity / noprint cmh;
tables id*pulse*severity / noprint cmh scores=rank;
run;

data ph_vmax;
keep subject ph vmax;
input subject vmax1-vmax4;
ph=6.5; vmax=vmax1; output;
ph=6.9; vmax=vmax2; output;
ph=7.4; vmax=vmax3; output;
ph=7.9; vmax=vmax4; output;
datalines;
1 . 284 310 326
2 . . 261 292
3 . 213 224 240
4 . 222 235 247
5 . . 270 286
6 . . 210 218
7 . 216 234 237
8 . 236 273 283
9 220 249 270 281
10 166 218 244 .
11 227 258 282 286
12 216 . 284 .
13 . . 257 284
14 204 234 268 .
15 . . 258 267
16 . 193 224 235
17 185 222 252 263
18 . 238 301 300
19 . 198 240 .
20 . 235 255 .
21 . 216 238 .
22 . 197 212 219
23 . 234 238 .
24 . . 295 281
25 . . 261 272
;
proc freq;
tables subject*ph*vmax / noprint cmh2;
tables subject*ph*vmax / noprint cmh2 scores=modridit;
run;

*****************************************************Nonparametric Methods*************************************;

*Wilcoxon-Mann-Whitney Test;
data sodium;
input group $ subject intake;
datalines;
Normal 1 10.2
Normal 2 2.2
Normal 3 0.0
Normal 4 2.6
Normal 5 0.0
Normal 6 43.1
Normal 7 45.8
Normal 8 63.6
Normal 9 1.8
Normal 10 0.0
Normal 11 3.7
Normal 12 0.0
Hyperten 1 92.8
Hyperten 2 54.8
Hyperten 3 51.6
Hyperten 4 61.7
Hyperten 5 250.8
Hyperten 6 84.5
Hyperten 7 34.7
Hyperten 8 62.2
Hyperten 9 11.0
Hyperten 10 39.1
;
proc freq;
  tables group*intake / noprint cmh2 scores=rank;
run;

proc freq;
tables group*intake / noprint chisq scores=rank;
run;

proc npar1way wilcoxon;
class group;
var intake;
run;

*********************************************Kruskal-Wallis Test****************************************;
data cortisol;
input group $ subject cortisol;
datalines;
I 1 262
I 2 307
I 3 211
I 4 323
I 5 454
I 6 339
I 7 304
I 8 154
I 9 287
I 10 356
II 1 465
II 2 501
II 3 455
II 4 355
II 5 468
II 6 362
III 1 343
III 2 772
III 3 207
III 4 1048
III 5 838
III 6 687
;
proc freq;
  tables group*cortisol / noprint cmh2 scores=rank;
run;

proc npar1way wilcoxon;
  class group;
  var cortisol;
run;

*Friedman’s Chi-Square Test;
data electrod;
  input subject resist1-resist5;
  type=1; resist=resist1; output;
  type=2; resist=resist2; output;
  type=3; resist=resist3; output;
  type=4; resist=resist4; output;
  type=5; resist=resist5; output;
datalines;
1 500 400 98 200 250
2 660 600 600 75 310
3 250 370 220 250 220
4 72 140 240 33 54
5 135 300 450 430 70
6 27 84 135 190 180
7 100 50 82 73 78
8 105 180 32 58 32
9 90 180 220 34 64
10 200 290 320 280 135
11 15 45 75 88 80
12 160 200 300 300 220
13 250 400 50 50 92
14 170 310 230 20 150
15 66 1000 1050 280 220
16 107 48 26 45 51
;
proc freq;
  tables subject*type*resist / noprint cmh2 scores=rank;
run;


*Aligned Ranks Test for Randomized Complete Blocks;
proc standard mean=0;
by subject;
var resist;
proc rank;
var resist;
proc freq;
tables subject*type*resist / noprint cmh2;
run;

*Durbin’s Test for Balanced Incomplete Blocks;
data tracing;
keep subject angle time;
input subject angle1 angle2 time1 time2;
angle=angle1; time=time1; output;
angle=angle2; time=time2; output;
datalines;
1 0.0 22.5 7 15
2 0.0 45.0 20 72
3 0.0 67.5 8 26
4 0.0 90.0 33 36
5 22.5 0.0 16 7
6 22.5 45.0 68 67
7 22.5 67.5 33 64
8 22.5 90.0 34 12
9 45.0 0.0 96 10
10 45.0 22.5 59 29
11 45.0 67.5 17 9
12 45.0 90.0 100 15
13 67.5 0.0 32 16
14 67.5 22.5 32 19
15 67.5 45.0 39 36
16 67.5 90.0 44 54
17 90.0 0.0 38 16
18 90.0 22.5 12 17
19 90.0 45.0 11 37
20 90.0 67.5 6 56
;
proc freq;
tables subject*angle*time / noprint cmh2 scores=rank;
run;

*Rank Analysis of Covariance;
data exercise;
input sex $ case duration vo2max @@;
datalines;
M 1 706 41.5 M 2 732 45.9 M 3 930 54.5 M 4 900 60.3
M 5 903 60.5 M 6 976 64.6 M 7 819 47.4 M 8 922 57.0
M 9 600 40.2 M 10 540 35.2 M 11 560 33.8 M 12 637 38.8
M 13 593 38.9 M 14 719 49.5 M 15 615 37.1 M 16 589 32.2
M 17 478 31.3 M 18 620 33.8 M 19 710 43.7 M 20 600 41.7
M 21 660 41.0 M 22 644 45.9 M 23 582 35.8 M 24 503 29.1
M 25 747 47.2 M 26 600 30.0 M 27 491 34.1 M 28 694 38.1
M 29 586 28.7 M 30 612 37.1 M 31 610 34.5 M 32 539 34.4
M 33 559 35.1 M 34 653 40.9 M 35 733 45.4 M 36 596 36.9
M 37 580 41.6 M 38 550 22.7 M 39 497 31.9 M 40 605 42.5
M 41 552 37.4 M 42 640 48.2 M 43 500 33.6 M 44 603 45.0
F 1 660 38.1 F 2 628 38.4 F 3 637 41.7 F 4 575 33.5
F 5 590 28.6 F 6 600 23.9 F 7 562 29.6 F 8 495 27.3
F 9 540 33.2 F 10 470 26.6 F 11 408 23.6 F 12 387 23.1
F 13 564 36.6 F 14 603 35.8 F 15 420 28.0 F 16 573 33.8
F 17 602 33.6 F 18 430 21.0 F 19 508 31.2 F 20 565 31.2
F 21 464 23.7 F 22 495 24.5 F 23 461 30.5 F 24 540 25.9
F 25 588 32.7 F 26 498 26.9 F 27 483 24.6 F 28 554 28.8
F 29 521 25.9 F 30 436 24.4 F 31 398 26.3 F 32 366 23.2
F 33 439 24.6 F 34 549 28.8 F 35 360 19.6 F 36 566 31.4
F 37 407 26.6 F 38 602 30.6 F 39 488 27.5 F 40 526 30.9
F 41 524 33.9 F 42 562 32.3 F 43 496 26.9
;
run;

proc rank out=ranks;
var duration vo2max;
run;

proc reg noprint;
model vo2max=duration;
output out=residual r=resid;
run;

proc freq;
tables sex*resid / noprint cmh2;
run;
data caries;
input center id group $ before after @@;
datalines;
1 1 W 7 11 1 2 W 20 24 1 3 W 21 25 1 4 W 1 2
1 5W 3 7 1 6W 2023 1 7W 913 1 8W 2 4
1 9 SF 11 13 1 10 SF 15 18 1 11 APF 7 10 1 12 APF 17 17
1 13 APF 9 11 1 14 APF 1 5 1 15 APF 3 7 2 1 W 10 14
2 2W 1317 2 3W 3 4 2 4W 4 7 2 5W 4 9
2 6 SF 15 18 2 7 SF 6 8 2 8 SF 4 6 2 9 SF 18 19
2 10 SF 11 12 2 11 SF 9 9 2 12 SF 4 7 2 13 SF 5 7
2 14 SF 11 14 2 15 SF 4 6 2 16 APF 4 4 2 17 APF 7 7
2 18 APF 0 4 2 19 APF 3 3 2 20 APF 0 1 2 21 APF 8 8
3 1W 2 4 3 2W 1318 3 3W 912 3 4W 1518
3 5 W 13 17 3 6 W 2 5 3 7 W 9 12 3 8 SF 4 6
3 9 SF 10 14 3 10 SF 7 11 3 11 SF 14 15 3 12 SF 7 10
3 13 SF 3 6 3 14 SF 9 12 3 15 SF 8 10 3 16 SF 19 19
3 17 SF 10 13 3 18 APF 10 12 3 19 APF 7 11 3 20 APF 13 12
3 21 APF 5 8 3 22 APF 1 3 3 23 APF 8 9 3 24 APF 4 5
3 25 APF 4 7 3 26 APF 14 14 3 27 APF 8 10 3 28 APF 3 5
3 29 APF 11 12 3 30 APF 16 18 3 31 APF 8 8 3 32 APF 0 1
3 33 APF 3 4
;
run;

proc rank nplus1 ties=mean out=ranks;
by center;
var before after;
run;

proc reg noprint;
by center;
model after=before;
output out=residual r=resid;
run;

proc freq;
tables center*group*resid / noprint cmh2;
run;









