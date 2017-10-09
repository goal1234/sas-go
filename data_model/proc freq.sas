

*---FREQ Procedure---*;
data SummerSchool;
input Gender $ Internship $ Enrollment $ Count @@;
datalines;
boys yes yes 35 boys yes no 29
boys no yes 14 boys no no 27
girls yes yes 32 girls yes no 10
girls no yes 53 girls no no 23
;

proc freq data=SummerSchool order=data;
tables Internship*Enrollment / chisq;
weight Count;
run;

ods graphics on;
proc freq data=SummerSchool;
tables Gender*Internship*Enrollment /
chisq cmh plots(only)=freqplot(twoway=cluster);
weight Count;
run;
ods graphics off;


data SkinCondition;
input Derm1 $ Derm2 $ Count;
datalines;
terrible terrible 10
terrible poor 4
terrible marginal 1
terrible clear 0
poor terrible 5
poor poor 10
poor marginal 12
poor clear 2
marginal terrible 2
marginal poor 4
marginal marginal 12
marginal clear 5
clear terrible 0
clear poor 2
clear marginal 6
clear clear 13
;

ods graphics on;
proc freq data=SkinCondition order=data;
tables Derm1*Derm2 /
agree noprint plots=agreeplot;
test kappa;
weight Count;
run;
ods graphics off;

*----proc freq步的参数---*;
/*PROC FREQ < options > ;*/
/*BY variables ;*/
/*EXACT statistic-options < / computation-options > ;*/
/*OUTPUT <OUT=SAS-data-set > output-options ;*/
/*TABLES requests < / options > ;*/
/*TEST options ;*/
/*WEIGHT variable < / option > ;*/

ods graphics on;
proc freq;
tables treatment*response / chisq plots=freqplot;
weight wt;
run;
ods graphics off;

*---Inputting Frequency Counts---*;
data Raw;
input Subject $ R C @@;
datalines;
01 1 1 02 1 1 03 1 1 04 1 1 05 1 1
06 1 2 07 1 2 08 1 2 09 2 1 10 2 1
11 2 1 12 2 1 13 2 2 14 2 2 14 2 2
;

data CellCounts;
input R C Count @@;
datalines;
1 1 5 1 2 3
2 1 4 2 2 3
;

proc freq data=CellCounts;
tables R*C;
weight Count;
run;

*---Grouping with Formats---*;
proc format;
value Questfmt 1 ='Yes'
               2 ='No'
             8,. ='Missing';
run;

data one;
input A Freq;
datalines;
1 2
2 2
. 2
;


proc freq data=one;
  tables A;
  weight Freq;
  title 'Default';
run;

proc freq data=one;
  tables A / missprint;
  weight Freq;
  title 'MISSPRINT Option';
run;

proc freq data=one;
  tables A / missing;
  weight Freq;
  title 'MISSING Option';
run;

proc freq;
tables A A*B / out=D;
run;

*---Output Data Set of Frequencies---*;
data Color;
input Region Eyes $ Hair $ Count @@;
label Eyes ='Eye Color'
Hair ='Hair Color'
Region='Geographic Region';
datalines;
1 blue fair 23 1 blue red 7 1 blue medium 24
1 blue dark 11 1 green fair 19 1 green red 7
1 green medium 18 1 green dark 14 1 brown fair 34
1 brown red 5 1 brown medium 41 1 brown dark 40
1 brown black 3 2 blue fair 46 2 blue red 21
2 blue medium 44 2 blue dark 40 2 blue black 6
2 green fair 50 2 green red 31 2 green medium 37
2 green dark 23 2 brown fair 56 2 brown red 42
2 brown medium 53 2 brown dark 54 2 brown black 13
;

proc freq data=Color;
  tables Eyes Hair Eyes*Hair / out=FreqCount outexpect sparse;
  weight Count;
  title 'Eye and Hair Color of European Children';
run;

proc print data=FreqCount noobs;
  title2 'Output Data Set from PROC FREQ';
run;

ods graphics on;
proc freq data=Color order=freq;
  tables Hair Hair*Eyes / plots=freqplot(type=dotplot);
  tables Hair*Region / plots=freqplot(type=dotplot scale=percent);
  weight Count;
  title 'Eye and Hair Color of European Children';
run;
ods graphics off;

*---Chi-Square Goodness-of-Fit Tests---*;
proc sort data=Color;
by Region;
run;
ods graphics on;
proc freq data=Color order=data;
tables Hair / nocum chisq testp=(30 12 30 25 3)
plots(only)=deviationplot(type=dotplot);
weight Count;
by Region;
title 'Hair Color of European Children';
run;
ods graphics off;

*---Binomial Proportions---*;
proc freq data=Color order=freq;
tables Eyes / binomial(ac wilson exact) alpha=.1;
tables Hair / binomial(equiv p=.28 margin=.1);
weight Count;
title 'Hair and Eye Color of European Children';
run;

*---Analysis of a 2x2 Contingency Table---*;
proc format;
value ExpFmt 1='High Cholesterol Diet'
0='Low Cholesterol Diet';
value RspFmt 1='Yes'
0='No';
run;

data FatComp;
  input Exposure Response Count;
  label Response='Heart Disease';
datalines;
0 0 6
0 1 2
1 0 4
1 1 11
;
proc sort data=FatComp;
by descending Exposure descending Response;
run;

proc freq data=FatComp order=data;
  format Exposure ExpFmt. Response RspFmt.;
  tables Exposure*Response / chisq relrisk;
  exact pchi or;
  weight Count;
  title 'Case-Control Study of High Fat/Cholesterol Diet';
run;

*---Output Data Set of Chi-Square Statistics---*;
proc freq data=Color order=data;
  tables Eyes*Hair / expected cellchi2 norow nocol chisq;
  output out=ChiSqData n nmiss pchi lrchi;
  weight Count;
  title 'Chi-Square Tests for 3 by 5 Table of Eye and Hair Color';
run;
proc print data=ChiSqData noobs;
  title1 'Chi-Square Statistics for Eye and Hair Color';
  title2 'Output Data Set from the FREQ Procedure';
run;

*---Cochran-Mantel-Haenszel Statistics---*;
data Migraine;
input Gender $ Treatment $ Response $ Count @@;
datalines;
female Active Better 16 female Active Same 11
female Placebo Better 5 female Placebo Same 20
male Active Better 12 male Active Same 16
male Placebo Better 7 male Placebo Same 19
;

ods graphics on;
proc freq data=Migraine;
tables Gender*Treatment*Response /
relrisk plots(only)=relriskplot(stats) cmh noprint;
weight Count;
title 'Clinical Trial for Treatment of Migraine Headaches';
run;
ods graphics off;

*---Cochran-Armitage Trend Test---*;
data pain;
input Dose Adverse $ Count @@;
datalines;
0 No 26 0 Yes 6
1 No 26 1 Yes 7
2 No 23 2 Yes 9
3 No 18 3 Yes 14
4 No 9 4 Yes 23
;

ods graphics on;
proc freq data=Pain;
tables Adverse*Dose / trend measures cl
plots=mosaicplot;
test smdrc;
exact trend / maxtime=60;
weight Count;
title 'Clinical Trial for Treatment of Pain';
run;
ods graphics off;

data Hypnosis;
length Emotion $ 10;
input Subject Emotion $ SkinResponse @@;
datalines;
1 fear 23.1 1 joy 22.7 1 sadness 22.5 1 calmness 22.6
2 fear 57.6 2 joy 53.2 2 sadness 53.7 2 calmness 53.1
3 fear 10.5 3 joy 9.7 3 sadness 10.8 3 calmness 8.3
4 fear 23.6 4 joy 19.6 4 sadness 21.1 4 calmness 21.6
5 fear 11.9 5 joy 13.8 5 sadness 13.7 5 calmness 13.3
6 fear 54.6 6 joy 47.1 6 sadness 39.2 6 calmness 37.0
7 fear 21.0 7 joy 13.6 7 sadness 13.7 7 calmness 14.8
8 fear 20.3 8 joy 23.6 8 sadness 16.3 8 calmness 14.8
;

proc freq data=Hypnosis;
tables Subject*Emotion*SkinResponse /
cmh2 scores=rank noprint;
run;

proc freq data=Hypnosis;
tables Emotion*SkinResponse /
cmh2 scores=rank noprint;
run;

*---Cochran’s Q Test---*;
proc format;
value $ResponseFmt 'F'='Favorable'
'U'='Unfavorable';
run;
data drugs;
input Drug_A $ Drug_B $ Drug_C $ Count @@;
datalines;
F F F 6 U F F 2
F F U 16 U F U 4
F U F 2 U U F 6
F U U 4 U U U 6
;

proc freq data=Drugs;
  tables Drug_A Drug_B Drug_C / nocum;
  tables Drug_A*Drug_B*Drug_C / agree noprint;
  format Drug_A Drug_B Drug_C $ResponseFmt.;
  weight Count;
  title 'Study of Three Drug Treatments for a Chronic Disease';
run;


