************************************Logistic Regression I: Dichotomous Response****************************************;
*Dichotomous Explanatory Variables;
data coronary;
input sex ecg ca count @@;
datalines;
0 0 0 11 0 0 1 4
0 1 0 10 0 1 1 8
1 0 0 9 1 0 1 9
1 1 0 6 1 1 1 21
;
run;

proc logistic descending;
  freq count;
  model ca=sex ecg / scale=none aggregate;
run;

proc logistic descending;
  freq count;
  model ca=sex ecg;
  output out=predict pred=prob;
run;
proc print data=predict;
run;

*Alternative Methods of Assessing Goodness of Fit;
ods select FitStatistics ParameterEstimates;
proc logistic descending;
freq count;
model ca=sex ecg sex*ecg;
run;

*Using the CLASS Statement;
data sentence;
input type $ prior $ sentence $ count @@;
datalines;
nrb some y 42 nrb some n 109
nrb none y 17 nrb none n 75
other some y 33 other some n 175
other none y 53 other none n 359
;
run;

proc logistic descending;
class type prior(ref=first) / param=ref;
freq count;
model sentence = type prior / scale=none aggregate;
run;

ods select GoodnessOfFit;
proc logistic descending;
class type prior (ref=first) / param=ref;
freq count;
model sentence = type / scale=none aggregate=(type prior);
run;

ods select ClassLevelInfo GoodnessOfFit
ParameterEstimates OddsRatios;
proc logistic data=sentence descending;
class type prior(ref=¡¯none¡¯);
freq count;
model sentence = type prior / scale=none aggregate;
run;

*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<Qualitative Explanatory Variables;
data uti;
input diagnosis : $13. treatment $ response $ count @@;
datalines;
complicated A cured 78 complicated A not 28
complicated B cured 101 complicated B not 11
complicated C cured 68 complicated C not 46
uncomplicated A cured 40 uncomplicated A not 5
uncomplicated B cured 54 uncomplicated B not 5
uncomplicated C cured 34 uncomplicated C not 6
;
run;

ods select FitStatistics;
proc logistic;
freq count;
class diagnosis treatment /param=ref;
model response = diagnosis|treatment;
run;

ods select FitStatistics GoodnessOfFit
           TypeIII OddsRatios;
proc logistic;
freq count;
class diagnosis treatment;
model response = diagnosis treatment /
scale=none aggregate;
run;

ods select ClparmPL CloddsPL;
proc logistic;
freq count;
class diagnosis treatment;
model response = diagnosis treatment /
scale=none aggregate clodds=pl clparm=pl;
run;

ods select ContrastTest ContrastEstimate;
proc logistic;
freq count;
class diagnosis treatment /param=ref;
model response = diagnosis treatment;
contrast ¡¯B versus A¡¯ treatment -1 1
/ estimate=exp;
contrast ¡¯A¡¯ treatment 1 0;
contrast ¡¯joint test¡¯ treatment 1 0,
treatment 0 1;
run;

*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<Continuous and Ordinal Explanatory Variables;
data coronary;
  input sex ecg age ca @@ ;
  datalines;
0 0 28 0 1 0 42 1 0 1 46 0 1 1 45 0
0 0 34 0 1 0 44 1 0 1 48 1 1 1 45 1
0 0 38 0 1 0 45 0 0 1 49 0 1 1 45 1
0 0 41 1 1 0 46 0 0 1 49 0 1 1 46 1
0 0 44 0 1 0 48 0 0 1 52 0 1 1 48 1
0 0 45 1 1 0 50 0 0 1 53 1 1 1 57 1
0 0 46 0 1 0 52 1 0 1 54 1 1 1 57 1
0 0 47 0 1 0 52 1 0 1 55 0 1 1 59 1
0 0 50 0 1 0 54 0 0 1 57 1 1 1 60 1
0 0 51 0 1 0 55 0 0 2 46 1 1 1 63 1
0 0 51 0 1 0 59 1 0 2 48 0 1 2 35 0
0 0 53 0 1 0 59 1 0 2 57 1 1 2 37 1
0 0 55 1 1 1 32 0 0 2 60 1 1 2 43 1
0 0 59 0 1 1 37 0 1 0 30 0 1 2 47 1
0 0 60 1 1 1 38 1 1 0 34 0 1 2 48 1
0 1 32 1 1 1 38 1 1 0 36 1 1 2 49 0
0 1 33 0 1 1 42 1 1 0 38 1 1 2 58 1
0 1 35 0 1 1 43 0 1 0 39 0 1 2 59 1
0 1 39 0 1 1 43 1 1 0 42 0 1 2 60 1
0 1 40 0 1 1 44 1
;
run;

proc logistic descending;
model ca=sex ecg age ecg*ecg age*age
sex*ecg sex*age ecg*age /
selection=forward include=3 details lackfit;
run;

proc logistic descending;
model ca=sex ecg age;
units age=10;
run;

data uti2;
input diagnosis : $13. treatment $ response trials;
datalines;
complicated A 78 106
complicated B 101 112
complicated C 68 114
uncomplicated A 40 45
uncomplicated B 54 59
uncomplicated C 34 40
;
proc logistic data=uti2;
class diagnosis treatment / param=ref;
model response/trials = diagnosis treatment/
influence;
run;

proc logistic;
class diagnosis treatment / param=ref;
model response/trials = diagnosis/
scale=none aggregate=(treatment diagnosis) influence iplots;
run;

*Maximum Likelihood Estimation Problems and Alternatives;
data quasi;
input treatA treatB response count @@;
datalines;
0 0 0 0 0 0 1 0
0 1 0 2 0 1 1 0
1 0 0 0 1 0 1 8
1 1 0 6 1 1 1 21
;
proc logistic;
freq count;
model response = TreatA TreatB;
run;

data complete;
input gender region count response @@;
datalines;
0 0 0 1 0 0 5 0
0 1 1 1 0 1 0 0
1 0 0 1 1 0 175 0
1 1 53 1 1 1 0 0
;
proc logistic;
freq count;
model response = gender region;
run;

*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<Exact Methods in Logistic Regression;
data liver;
input time $ group $ status $ count @@;
datalines;
early antidote severe 6 early antidote not 12
early control severe 6 early control not 2
delayed antidote severe 3 delayed antidote not 4
delayed control severe 3 delayed control not 0
late antidote severe 5 late antidote not 1
late control severe 6 late control not 0
;
run;

proc logistic descending;
freq count;
class time(ref=¡¯early¡¯) group(ref=¡¯control¡¯) /param=ref;
model status = time group / scale=none aggregate clparm=wald;
exact ¡¯Model 1¡¯ intercept time group /
estimate=both;
exact ¡¯Joint Test¡¯ time group / joint;
run;

data exercise;
input location $ program $ outcome $ count @@;
datalines;
downtown office good 12 downtown office not 5
downtown home good 3 downtown home not 5
satellite office good 6 satellite office not 1
satellite home good 1 satellite home not 3
;
run;
proc logistic;
freq count;
class location program(ref=first) /param=ref;
model outcome = location program;
exact program / estimate=both;
run;

*Using the CATMOD and GENMOD Procedures for Logistic;
*Regression;
proc catmod data=sentence order=data;
weight count;
model sentence = type prior;
run;

*Fitting Logistic RegressionModels with PROC GENMOD;
proc genmod data=uti;
freq count;
class diagnosis treatment;
model response = diagnosis treatment /
link=logit dist=binomial type3
aggregate=(diagnosis treatment);
run;


contrast ¡¯A-B¡¯ treat 1 -1 0;
proc genmod data=uti;
freq count;
class diagnosis treatment;
model response = diagnosis treatment /
link=logit dist=binomial;
contrast ¡¯treatment¡¯ treatment 1 0 -1 ,
treatment 0 1 -1;
contrast ¡¯A-B¡¯ treatment 1 -1 0;
contrast ¡¯A-C¡¯ treatment 1 0 -1;
run;


*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<Logistic Regression II: Polytomous Response;
data arthritis;
length treatment $7. sex $6.;
input sex $ treatment $ improve $ count @@;
datalines;
female active marked 16 female active some 5 female active none 6
female placebo marked 6 female placebo some 7 female placebo none 19
male active marked 5 male active some 2 male active none 7
male placebo marked 1 male placebo some 0 male placebo none 10
;
run;

proc logistic order=data;
freq count;
class treatment sex / param=reference;
model improve = sex treatment / scale=none aggregate;
run;

proc logistic order=data;
freq count;
class sex treatment / param=reference;
model improve = sex treatment sex*treatment /
selection=forward start=2;
run;

data respire;
input air $ exposure $ smoking $ level count @@;
datalines;
low no non 1 158 low no non 2 9
low no ex 1 167 low no ex 2 19
low no cur 1 307 low no cur 2 102
low yes non 1 26 low yes non 2 5
low yes ex 1 38 low yes ex 2 12
low yes cur 1 94 low yes cur 2 48
high no non 1 94 high no non 2 7
high no ex 1 67 high no ex 2 8
high no cur 1 184 high no cur 2 65
high yes non 1 32 high yes non 2 3
high yes ex 1 39 high yes ex 2 11
high yes cur 1 77 high yes cur 2 48
low no non 3 5 low no non 4 0
low no ex 3 5 low no ex 4 3
low no cur 3 83 low no cur 4 68
low yes non 3 5 low yes non 4 1
low yes ex 3 4 low yes ex 4 4
low yes cur 3 46 low yes cur 4 60
high no non 3 5 high no non 4 1
high no ex 3 4 high no ex 4 3
high no cur 3 33 high no cur 4 36
high yes non 3 6 high yes non 4 1
high yes ex 3 4 high yes ex 4 2
high yes cur 3 39 high yes cur 4 51
;
run;

proc logistic descending;
freq count;
class air exposure(ref=¡¯no¡¯) smoking / param=reference;
model level = air exposure smoking
air*exposure air*smoking exposure*smoking /
selection=forward include=3 scale=none
aggregate=(air exposure smoking);
run;

**<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<Nominal Response: Generalized Logits Model;
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
run;
proc catmod order=data;
weight count;
model style=school program school*program;
run;
proc catmod order=data;
weight count;
model style=school program;
run;


data survey;
input age sex race poverty function $ count @@;
datalines;
1 0 0 0 major 5.361 1 0 0 0 other 1.329 1 0 0 0 not 102.228
1 0 0 1 major 20.565 1 0 0 1 other 13.952 1 0 0 1 not 336.160
1 0 0 2 major 21.299 1 0 0 2 other 5.884 1 0 0 2 not 284.931
1 0 1 0 major 53.314 1 0 1 0 other 16.402 1 0 1 0 not 827.900
1 0 1 1 major 102.076 1 0 1 1 other 36.551 1 0 1 1 not 1518.796
1 0 1 2 major 52.338 1 0 1 2 other 21.105 1 0 1 2 not 666.909
1 1 0 0 major 1.172 1 1 0 0 other 1.199 1 1 0 0 not 87.292
1 1 0 1 major 11.169 1 1 0 1 other 2.945 1 1 0 1 not 304.234
1 1 0 2 major 15.286 1 1 0 2 other 3.665 1 1 0 2 not 302.511
1 1 1 0 major 21.882 1 1 1 0 other 16.979 1 1 1 0 not 846.270
1 1 1 1 major 52.354 1 1 1 1 other 33.106 1 1 1 1 not 1452.895
1 1 1 2 major 28.203 1 1 1 2 other 11.455 1 1 1 2 not 687.109
2 0 0 0 major .915 2 0 0 0 other 1.711 2 0 0 0 not 91.071
2 0 0 1 major 12.591 2 0 0 1 other 8.026 2 0 0 1 not 326.930
2 0 0 2 major 21.059 2 0 0 2 other 6.993 2 0 0 2 not 313.633
2 0 1 0 major 36.384 2 0 1 0 other 27.558 2 0 1 0 not 888.833
2 0 1 1 major 85.974 2 0 1 1 other 42.755 2 0 1 1 not 1509.87
2 0 1 2 major 40.112 2 0 1 2 other 23.493 2 0 1 2 not 725.004
2 1 0 0 major 5.876 2 1 0 0 other 2.550 2 1 0 0 not 115.968
2 1 0 1 major 8.772 2 1 0 1 other 6.922 2 1 0 1 not 344.076
2 1 0 2 major 17.385 2 1 0 2 other 2.354 2 1 0 2 not 286.68
2 1 1 0 major 42.741 2 1 1 0 other 31.025 2 1 1 0 not 817.478
2 1 1 1 major 72.688 2 1 1 1 other 35.979 2 1 1 1 not 1499.816
2 1 1 2 major 26.296 2 1 1 2 other 29.321 2 1 1 2 not 716.860
;
run;

proc catmod order=data;
direct poverty;
weight count;
model function=age|sex|race|poverty@2;
run;

proc catmod order=data;
direct poverty;
weight count;
model function=age sex race poverty
age*sex sex*race race*poverty;
run;

proc catmod order=data;
direct poverty;
weight count;
model function=age sex race poverty
age*sex race*poverty /pred=freq;
run;

********************************************************************************************;
*<<<<<<<<<<<<<<<<<<<<<<<<<<<Conditional Logistic Regression;********************************;

*Clinical Trials Study Analysis;
*Analysis Using the LOGISTIC Procedure;
data trial;
drop center1 i_sex1 age1 initial1 improve1 trtsex1 trtinit1
trtage1 isexage1 isexint1 iageint1;
retain center1 i_sex1 age1 initial1 improve1 trtsex1 trtinit1
trtage1 isexage1 isexint1 iageint1 0;
input center treat $ sex $ age improve initial @@;
/* compute model terms for each observation */
i_sex=(sex=¡¯m¡¯); i_trt=(treat=¡¯t¡¯);
trtsex=i_sex*i_trt; trtinit=i_trt*initial;
trtage=i_trt*age; isexage=i_sex*age;
isexinit=i_sex*initial;iageinit=age*initial;
/* compute differences for paired observation */
if (center=center1) then do;
pair=10*improve + improve1;
i_sex=i_sex1-i_sex;
age=age1-age;
initial=initial1-initial;
trtsex=trtsex1-trtsex;
trtinit=trtinit1-trtinit;
trtage=trtage1-trtage;
isexage=isexage1-isexage;
isexinit=isexint1-isexinit;
iageinit=iageint1-iageinit;
if (pair=10 or pair=1) then do;
/* output discordant pair observations */
improve=(pair=1); output trial; end;
end;
else do;
center1=center; age1=age;
initial1=initial; i_sex1=i_sex; improve1=improve;
trtsex1=trtsex; trtinit1=trtinit; trtage1=trtage;
isexage1=isexage; isexint1=isexinit; iageint1=iageinit;
end;
datalines;
1 t f 27 0 1 1 p f 32 0 2 41 t f 13 1 2 41 p m 22 0 3
2 t f 41 1 3 2 p f 47 0 1 42 t m 31 1 1 42 p f 21 1 3
3 t m 19 1 4 3 p m 31 0 4 43 t f 19 1 3 43 p m 35 1 3
4 t m 55 1 1 4 p m 24 1 3 44 t m 31 1 3 44 p f 37 0 2
5 t f 51 1 4 5 p f 44 0 2 45 t f 44 0 1 45 p f 41 1 1
6 t m 23 0 1 6 p f 44 1 3 46 t m 41 1 2 46 p m 41 0 1
7 t m 31 1 2 7 p f 39 0 2 47 t m 41 1 2 47 p f 21 0 4
8 t m 22 0 1 8 p m 54 1 4 48 t f 51 1 2 48 p m 22 1 1
9 t m 37 1 3 9 p m 63 0 2 49 t f 62 1 3 49 p f 32 0 3
10 t m 33 0 3 10 p f 43 0 3 50 t m 21 0 1 50 p m 34 0 1
11 t f 32 1 1 11 p m 33 0 3 51 t m 55 1 3 51 p f 35 1 2
12 t m 47 1 4 12 p m 24 0 4 52 t f 61 0 1 52 p m 19 0 1
13 t m 55 1 3 13 p f 38 1 1 53 t m 43 1 2 53 p m 31 0 2
14 t f 33 0 1 14 p f 28 1 2 54 t f 44 1 1 54 p f 41 1 1
15 t f 48 1 1 15 p f 42 0 1 55 t m 67 1 2 55 p m 41 0 1
16 t m 55 1 3 16 p m 52 0 1 56 t m 41 0 2 56 p m 21 1 4
17 t m 30 0 4 17 p m 48 1 4 57 t f 51 1 3 57 p m 51 0 2
18 t f 31 1 2 18 p m 27 1 3 58 t m 62 1 3 58 p m 54 1 3
19 t m 66 1 3 19 p f 54 0 1 59 t m 22 0 1 59 p f 22 0 1
20 t f 45 0 2 20 p f 66 1 2 60 t m 42 1 2 60 p f 29 1 2
21 t m 19 1 4 21 p f 20 1 4 61 t f 51 1 1 61 p f 31 0 1
22 t m 34 1 4 22 p f 31 0 1 62 t m 27 0 2 62 p m 32 1 2
23 t f 46 0 1 23 p m 30 1 2 63 t m 31 1 1 63 p f 21 0 1
24 t m 48 1 3 24 p f 62 0 4 64 t m 35 0 3 64 p m 33 1 3
25 t m 50 1 4 25 p m 45 1 4 65 t m 67 1 2 65 p m 19 0 1
26 t m 57 1 3 26 p f 43 0 3 66 t m 41 0 2 66 p m 62 1 4
27 t f 13 0 2 27 p m 22 1 3 67 t f 31 1 2 67 p m 45 1 3
28 t m 31 1 1 28 p f 21 0 1 68 t m 34 1 1 68 p f 54 0 1
29 t m 35 1 3 29 p m 35 1 3 69 t f 21 0 1 69 p m 34 1 4
30 t f 36 1 3 30 p f 37 0 3 70 t m 64 1 3 70 p m 51 0 1
31 t f 45 0 1 31 p f 41 1 1 71 t f 61 1 3 71 p m 34 1 3
32 t m 13 1 2 32 p m 42 0 1 72 t m 33 0 1 72 p f 43 0 1
33 t m 14 0 4 33 p f 22 1 2 73 t f 36 0 2 73 p m 37 0 3
34 t f 15 1 2 34 p m 24 0 1 74 t m 21 1 1 74 p m 55 0 1
35 t f 19 1 3 35 p f 31 0 1 75 t f 47 0 2 75 p f 42 1 3
36 t m 20 0 2 36 p m 32 1 3 76 t f 51 1 4 76 p m 44 0 2
37 t m 23 1 3 37 p f 35 0 1 77 t f 23 1 1 77 p m 41 1 3
38 t f 23 0 1 38 p m 21 1 1 78 t m 31 0 2 78 p f 23 1 4
39 t m 24 1 4 39 p m 30 1 3 79 t m 22 0 1 79 p m 19 1 4
40 t m 57 1 3 40 p f 43 1 3
;
proc logistic data=trial descending;
model improve = initial age i_sex
isexage isexinit iageinit
trtsex trtinit trtage /
selection=forward include=3 details;
run;

proc logistic data=trial descending;
model improve = ;
run;

*Analysis Using the PHREG Procedure;
data trial2;
input center treat $ sex $ age improve initial @@;
/* create indicator variables for sex and interaction terms */
improve=2-improve;
isex=(sex=¡¯m¡¯);
itreat=(treat=¡¯t¡¯);
sex_age=isex*age;
treat_age=itreat*age;
sex_treat=isex*itreat;
sex_initial=isex*initial;
treat_initial=itreat*initial;
age_initial=age*initial;
datalines;
1 t f 27 0 1 1 p f 32 0 2 41 t f 13 1 2 41 p m 22 0 3
2 t f 41 1 3 2 p f 47 0 1 42 t m 31 1 1 42 p f 21 1 3
3 t m 19 1 4 3 p m 31 0 4 43 t f 19 1 3 43 p m 35 1 3
4 t m 55 1 1 4 p m 24 1 3 44 t m 31 1 3 44 p f 37 0 2
5 t f 51 1 4 5 p f 44 0 2 45 t f 44 0 1 45 p f 41 1 1
6 t m 23 0 1 6 p f 44 1 3 46 t m 41 1 2 46 p m 41 0 1
7 t m 31 1 2 7 p f 39 0 2 47 t m 41 1 2 47 p f 21 0 4
8 t m 22 0 1 8 p m 54 1 4 48 t f 51 1 2 48 p m 22 1 1
9 t m 37 1 3 9 p m 63 0 2 49 t f 62 1 3 49 p f 32 0 3
10 t m 33 0 3 10 p f 43 0 3 50 t m 21 0 1 50 p m 34 0 1
11 t f 32 1 1 11 p m 33 0 3 51 t m 55 1 3 51 p f 35 1 2
12 t m 47 1 4 12 p m 24 0 4 52 t f 61 0 1 52 p m 19 0 1
13 t m 55 1 3 13 p f 38 1 1 53 t m 43 1 2 53 p m 31 0 2
14 t f 33 0 1 14 p f 28 1 2 54 t f 44 1 1 54 p f 41 1 1
15 t f 48 1 1 15 p f 42 0 1 55 t m 67 1 2 55 p m 41 0 1
16 t m 55 1 3 16 p m 52 0 1 56 t m 41 0 2 56 p m 21 1 4
17 t m 30 0 4 17 p m 48 1 4 57 t f 51 1 3 57 p m 51 0 2
18 t f 31 1 2 18 p m 27 1 3 58 t m 62 1 3 58 p m 54 1 3
19 t m 66 1 3 19 p f 54 0 1 59 t m 22 0 1 59 p f 22 0 1
20 t f 45 0 2 20 p f 66 1 2 60 t m 42 1 2 60 p f 29 1 2
21 t m 19 1 4 21 p f 20 1 4 61 t f 51 1 1 61 p f 31 0 1
22 t m 34 1 4 22 p f 31 0 1 62 t m 27 0 2 62 p m 32 1 2
23 t f 46 0 1 23 p m 30 1 2 63 t m 31 1 1 63 p f 21 0 1
24 t m 48 1 3 24 p f 62 0 4 64 t m 35 0 3 64 p m 33 1 3
25 t m 50 1 4 25 p m 45 1 4 65 t m 67 1 2 65 p m 19 0 1
26 t m 57 1 3 26 p f 43 0 3 66 t m 41 0 2 66 p m 62 1 4
27 t f 13 0 2 27 p m 22 1 3 67 t f 31 1 2 67 p m 45 1 3
28 t m 31 1 1 28 p f 21 0 1 68 t m 34 1 1 68 p f 54 0 1
29 t m 35 1 3 29 p m 35 1 3 69 t f 21 0 1 69 p m 34 1 4
30 t f 36 1 3 30 p f 37 0 3 70 t m 64 1 3 70 p m 51 0 1
31 t f 45 0 1 31 p f 41 1 1 71 t f 61 1 3 71 p m 34 1 3
32 t m 13 1 2 32 p m 42 0 1 72 t m 33 0 1 72 p f 43 0 1
33 t m 14 0 4 33 p f 22 1 2 73 t f 36 0 2 73 p m 37 0 3
34 t f 15 1 2 34 p m 24 0 1 74 t m 21 1 1 74 p m 55 0 1
35 t f 19 1 3 35 p f 31 0 1 75 t f 47 0 2 75 p f 42 1 3
36 t m 20 0 2 36 p m 32 1 3 76 t f 51 1 4 76 p m 44 0 2
37 t m 23 1 3 37 p f 35 0 1 77 t f 23 1 1 77 p m 41 1 3
38 t f 23 0 1 38 p m 21 1 1 78 t m 31 0 2 78 p f 23 1 4
39 t m 24 1 4 39 p m 30 1 3 79 t m 22 0 1 79 p m 19 1 4
40 t m 57 1 3 40 p f 43 1 3
;
proc phreg data=trial2 nosummary;
strata center;
model improve = initial age isex itreat
sex_age sex_initial age_initial
sex_treat treat_initial treat_age / ties=discrete
selection=forward include=4 details;
run;

*Crossover Design Studies;
data cross1 (drop=count);
input age $ sequence $ time1 $ time2 $ count;
do i=1 to count;
output;
end;
datalines;
older AB F F 12
older AB F U 12
older AB U F 6
older AB U U 20
older BP F F 8
older BP F U 5
older BP U F 6
older BP U U 31
older PA F F 5
older PA F U 3
older PA U F 22
older PA U U 20
younger BA F F 19
younger BA F U 3
younger BA U F 25
younger BA U U 3
younger AP F F 25
younger AP F U 6
younger AP U F 6
younger AP U U 13
younger PB F F 13
younger PB F U 5
younger PB U F 21
younger PB U U 11
;
data cross2; set cross1;
subject=_n_;
period1=1;
druga = (substr(sequence, 1, 1)=¡¯A¡¯);
drugb = (substr(sequence, 1, 1)=¡¯B¡¯);
carrya=0;
carryb=0;
response =(time1=¡¯F¡¯);
output;
period1=0;
druga = (substr(sequence, 2, 1)=¡¯A¡¯);
drugb = (substr(sequence, 2, 1)=¡¯B¡¯);
carrya = (substr(sequence, 1, 1)=¡¯A¡¯);
carryb = (substr(sequence, 1, 1)=¡¯B¡¯);
response =(time2=¡¯F¡¯);
output;
run;

proc phreg data=cross3 nosummary;
  strata subject;
  model response = period1 druga drugb period1_older
  carrya carryb / ties=discrete;
run;

proc phreg data=cross3 nosummary;
strata subject;
model response = period1 druga drugb
period1_older / ties=discrete;
A_B: test druga=drugb;
run;


data exercise;
input Sequence $ ID $ Period1 Period2 High Medium Baseline
Response CarryHigh CarryMedium @@;
strata=sequence||id;
DichotResponse = 2-(Response >0);
datalines;
HML 1 1 0 1 0 0 3 0 0 HML 1 0 1 0 1 0 1 1 0 HML 1 0 0 0 0 0 0 0 1
HML 2 1 0 1 0 0 3 0 0 HML 2 0 1 0 1 0 2 1 0 HML 2 0 0 0 0 0 0 0 1
HML 3 1 0 1 0 1 3 0 0 HML 3 0 1 0 1 0 2 1 0 HML 3 0 0 0 0 0 0 0 1
HML 4 1 0 1 0 0 2 0 0 HML 4 0 1 0 1 0 0 1 0 HML 4 0 0 0 0 0 2 0 1
HML 5 1 0 1 0 0 3 0 0 HML 5 0 1 0 1 0 0 1 0 HML 5 0 0 0 0 0 1 0 1
HML 6 1 0 1 0 1 2 0 0 HML 6 0 1 0 1 0 1 1 0 HML 6 0 0 0 0 0 2 0 1
HML 7 1 0 1 0 0 3 0 0 HML 7 0 1 0 1 0 1 1 0 HML 7 0 0 0 0 0 2 0 1
HML 8 1 0 1 0 0 3 0 0 HML 8 0 1 0 1 0 2 1 0 HML 8 0 0 0 0 0 1 0 1
HML 9 1 0 1 0 1 2 0 0 HML 9 0 1 0 1 0 1 1 0 HML 9 0 0 0 0 0 1 0 1
HML 10 1 0 1 0 0 1 0 0 HML 10 0 1 0 1 0 1 1 0 HML 10 0 0 0 0 0 0 0 1
HML 11 1 0 1 0 0 2 0 0 HML 11 0 1 0 1 0 0 1 0 HML 11 0 0 0 0 0 0 0 1
HML 12 1 0 1 0 0 3 0 0 HML 12 0 1 0 1 0 0 1 0 HML 12 0 0 0 0 0 0 0 1
HML 13 1 0 1 0 0 1 0 0 HML 13 0 1 0 1 0 3 1 0 HML 13 0 0 0 0 0 1 0 1
HML 14 1 0 1 0 0 2 0 0 HML 14 0 1 0 1 0 2 1 0 HML 14 0 0 0 0 0 0 0 1
HML 15 1 0 1 0 1 2 0 0 HML 15 0 1 0 1 0 2 1 0 HML 15 0 0 0 0 0 0 0 1
HML 16 1 0 1 0 1 2 0 0 HML 16 0 1 0 1 0 2 1 0 HML 16 0 0 0 0 0 0 0 1
HML 17 1 0 1 0 1 2 0 0 HML 17 0 1 0 1 0 2 1 0 HML 17 0 0 0 0 0 3 0 1
HML 18 1 0 1 0 0 2 0 0 HML 18 0 1 0 1 0 2 1 0 HML 18 0 0 0 0 0 2 0 1
HML 19 1 0 1 0 0 2 0 0 HML 19 0 1 0 1 0 0 1 0 HML 19 0 0 0 0 0 2 0 1
HML 20 1 0 1 0 0 3 0 0 HML 20 0 1 0 1 0 0 1 0 HML 20 0 0 0 0 0 1 0 1
HML 21 1 0 1 0 0 1 0 0 HML 21 0 1 0 1 0 1 1 0 HML 21 0 0 0 0 0 0 0 1
HML 22 1 0 1 0 0 2 0 0 HML 22 0 1 0 1 0 0 1 0 HML 22 0 0 0 0 0 2 0 1
HML 23 1 0 1 0 0 2 0 0 HML 23 0 1 0 1 0 1 1 0 HML 23 0 0 0 0 0 1 0 1
HML 24 1 0 1 0 1 3 0 0 HML 24 0 1 0 1 0 1 1 0 HML 24 0 0 0 0 0 0 0 1
HML 25 1 0 1 0 0 3 0 0 HML 25 0 1 0 1 0 2 1 0 HML 25 0 0 0 0 0 1 0 1
HML 26 1 0 1 0 0 3 0 0 HML 26 0 1 0 1 0 2 1 0 HML 26 0 0 0 0 0 0 0 1
HLM 1 1 0 1 0 0 3 0 0 HLM 1 0 1 0 0 0 0 1 0 HLM 1 0 0 0 1 0 2 0 0
HLM 2 1 0 1 0 0 2 0 0 HLM 2 0 1 0 0 0 1 1 0 HLM 2 0 0 0 1 0 1 0 0
HLM 3 1 0 1 0 1 2 0 0 HLM 3 0 1 0 0 0 2 1 0 HLM 3 0 0 0 1 0 2 0 0
HLM 4 1 0 1 0 0 2 0 0 HLM 4 0 1 0 0 0 2 1 0 HLM 4 0 0 0 1 0 1 0 0
HLM 5 1 0 1 0 0 3 0 0 HLM 5 0 1 0 0 0 1 1 0 HLM 5 0 0 0 1 0 1 0 0
HLM 6 1 0 1 0 1 1 0 0 HLM 6 0 1 0 0 0 0 1 0 HLM 6 0 0 0 1 0 1 0 0
HLM 7 1 0 1 0 0 2 0 0 HLM 7 0 1 0 0 0 1 1 0 HLM 7 0 0 0 1 0 1 0 0
HLM 8 1 0 1 0 0 2 0 0 HLM 8 0 1 0 0 0 1 1 0 HLM 8 0 0 0 1 0 1 0 0
HLM 9 1 0 1 0 1 2 0 0 HLM 9 0 1 0 0 0 1 1 0 HLM 9 0 0 0 1 0 0 0 0
HLM 10 1 0 1 0 0 2 0 0 HLM 10 0 1 0 0 0 0 1 0 HLM 10 0 0 0 1 0 2 0 0
HLM 11 1 0 1 0 0 3 0 0 HLM 11 0 1 0 0 0 0 1 0 HLM 11 0 0 0 1 0 1 0 0
HLM 12 1 0 1 0 0 1 0 0 HLM 12 0 1 0 0 0 1 1 0 HLM 12 0 0 0 1 0 0 0 0
HLM 13 1 0 1 0 0 0 0 0 HLM 13 0 1 0 0 0 1 1 0 HLM 13 0 0 0 1 0 0 0 0
HLM 14 1 0 1 0 0 3 0 0 HLM 14 0 1 0 0 0 0 1 0 HLM 14 0 0 0 1 0 2 0 0
HLM 15 1 0 1 0 1 0 0 0 HLM 15 0 1 0 0 0 2 1 0 HLM 15 0 0 0 1 0 0 0 0
HLM 16 1 0 1 0 1 3 0 0 HLM 16 0 1 0 0 0 0 1 0 HLM 16 0 0 0 1 0 1 0 0
HLM 17 1 0 1 0 1 2 0 0 HLM 17 0 1 0 0 0 0 1 0 HLM 17 0 0 0 1 0 1 0 0
HLM 18 1 0 1 0 0 3 0 0 HLM 18 0 1 0 0 0 1 1 0 HLM 18 0 0 0 1 0 1 0 0
HLM 19 1 0 1 0 0 3 0 0 HLM 19 0 1 0 0 0 0 1 0 HLM 19 0 0 0 1 0 1 0 0
HLM 20 1 0 1 0 0 2 0 0 HLM 20 0 1 0 0 0 1 1 0 HLM 20 0 0 0 1 0 2 0 0
HLM 21 1 0 1 0 0 2 0 0 HLM 21 0 1 0 0 0 0 1 0 HLM 21 0 0 0 1 0 2 0 0
HLM 22 1 0 1 0 0 1 0 0 HLM 22 0 1 0 0 0 1 1 0 HLM 22 0 0 0 1 0 3 0 0
HLM 23 1 0 1 0 0 3 0 0 HLM 23 0 1 0 0 0 1 1 0 HLM 23 0 0 0 1 0 2 0 0
HLM 24 1 0 1 0 1 2 0 0 HLM 24 0 1 0 0 0 1 1 0 HLM 24 0 0 0 1 0 2 0 0
MHL 1 1 0 0 1 0 1 0 0 MHL 1 0 1 1 0 0 2 0 1 MHL 1 0 0 0 0 0 0 1 0
MHL 2 1 0 0 1 0 0 0 0 MHL 2 0 1 1 0 0 3 0 1 MHL 2 0 0 0 0 0 1 1 0
MHL 3 1 0 0 1 1 2 0 0 MHL 3 0 1 1 0 0 2 0 1 MHL 3 0 0 0 0 0 0 1 0
MHL 4 1 0 0 1 0 1 0 0 MHL 4 0 1 1 0 0 3 0 1 MHL 4 0 0 0 0 0 1 1 0
MHL 5 1 0 0 1 0 1 0 0 MHL 5 0 1 1 0 0 2 0 1 MHL 5 0 0 0 0 0 2 1 0
MHL 6 1 0 0 1 1 0 0 0 MHL 6 0 1 1 0 0 3 0 1 MHL 6 0 0 0 0 0 0 1 0
MHL 7 1 0 0 1 0 2 0 0 MHL 7 0 1 1 0 0 1 0 1 MHL 7 0 0 0 0 0 1 1 0
MHL 8 1 0 0 1 0 1 0 0 MHL 8 0 1 1 0 0 1 0 1 MHL 8 0 0 0 0 0 2 1 0
MHL 9 1 0 0 1 1 0 0 0 MHL 9 0 1 1 0 0 2 0 1 MHL 9 0 0 0 0 0 0 1 0
MHL 10 1 0 0 1 0 0 0 0 MHL 10 0 1 1 0 0 2 0 1 MHL 10 0 0 0 0 0 0 1 0
MHL 11 1 0 0 1 0 2 0 0 MHL 11 0 1 1 0 0 1 0 1 MHL 11 0 0 0 0 0 0 1 0
MHL 12 1 0 0 1 0 0 0 0 MHL 12 0 1 1 0 0 1 0 1 MHL 12 0 0 0 0 0 0 1 0
MHL 13 1 0 0 1 0 1 0 0 MHL 13 0 1 1 0 0 2 0 1 MHL 13 0 0 0 0 0 1 1 0
MHL 14 1 0 0 1 0 1 0 0 MHL 14 0 1 1 0 0 3 0 1 MHL 14 0 0 0 0 0 1 1 0
MHL 15 1 0 0 1 1 0 0 0 MHL 15 0 1 1 0 0 3 0 1 MHL 15 0 0 0 0 0 1 1 0
MHL 16 1 0 0 1 1 1 0 0 MHL 16 0 1 1 0 0 3 0 1 MHL 16 0 0 0 0 0 0 1 0
MHL 17 1 0 0 1 1 0 0 0 MHL 17 0 1 1 0 0 2 0 1 MHL 17 0 0 0 0 0 1 1 0
MHL 18 1 0 0 1 0 1 0 0 MHL 18 0 1 1 0 0 2 0 1 MHL 18 0 0 0 0 0 2 1 0
MHL 19 1 0 0 1 0 2 0 0 MHL 19 0 1 1 0 0 3 0 1 MHL 19 0 0 0 0 0 1 1 0
MHL 20 1 0 0 1 0 1 0 0 MHL 20 0 1 1 0 0 3 0 1 MHL 20 0 0 0 0 0 0 1 0
MLH 1 1 0 0 1 0 1 0 0 MLH 1 0 1 0 0 0 0 0 1 MLH 1 0 0 1 0 0 2 0 0
MLH 2 1 0 0 1 0 1 0 0 MLH 2 0 1 0 0 0 1 0 1 MLH 2 0 0 1 0 0 3 0 0
MLH 3 1 0 0 1 1 0 0 0 MLH 3 0 1 0 0 0 1 0 1 MLH 3 0 0 1 0 0 2 0 0
MLH 4 1 0 0 1 0 0 0 0 MLH 4 0 1 0 0 0 0 0 1 MLH 4 0 0 1 0 0 3 0 0
MLH 5 1 0 0 1 0 1 0 0 MLH 5 0 1 0 0 0 0 0 1 MLH 5 0 0 1 0 0 3 0 0
MLH 6 1 0 0 1 1 2 0 0 MLH 6 0 1 0 0 0 1 0 1 MLH 6 0 0 1 0 0 3 0 0
MLH 7 1 0 0 1 0 0 0 0 MLH 7 0 1 0 0 0 0 0 1 MLH 7 0 0 1 0 0 2 0 0
MLH 8 1 0 0 1 0 2 0 0 MLH 8 0 1 0 0 0 1 0 1 MLH 8 0 0 1 0 0 2 0 0
MLH 9 1 0 0 1 1 0 0 0 MLH 9 0 1 0 0 0 0 0 1 MLH 9 0 0 1 0 0 3 0 0
MLH 10 1 0 0 1 0 2 0 0 MLH 10 0 1 0 0 0 2 0 1 MLH 10 0 0 1 0 0 1 0 0
MLH 11 1 0 0 1 0 1 0 0 MLH 11 0 1 0 0 0 2 0 1 MLH 11 0 0 1 0 0 1 0 0
MLH 12 1 0 0 1 0 1 0 0 MLH 12 0 1 0 0 0 0 0 1 MLH 12 0 0 1 0 0 3 0 0
MLH 13 1 0 0 1 0 1 0 0 MLH 13 0 1 0 0 0 0 0 1 MLH 13 0 0 1 0 0 0 0 0
MLH 14 1 0 0 1 0 1 0 0 MLH 14 0 1 0 0 0 2 0 1 MLH 14 0 0 1 0 0 3 0 0
MLH 15 1 0 0 1 1 0 0 0 MLH 15 0 1 0 0 0 1 0 1 MLH 15 0 0 1 0 0 2 0 0
MLH 16 1 0 0 1 1 0 0 0 MLH 16 0 1 0 0 0 0 0 1 MLH 16 0 0 1 0 0 1 0 0
MLH 17 1 0 0 1 1 2 0 0 MLH 17 0 1 0 0 0 0 0 1 MLH 17 0 0 1 0 0 3 0 0
MLH 18 1 0 0 1 0 1 0 0 MLH 18 0 1 0 0 0 1 0 1 MLH 18 0 0 1 0 0 2 0 0
MLH 19 1 0 0 1 0 1 0 0 MLH 19 0 1 0 0 0 1 0 1 MLH 19 0 0 1 0 0 3 0 0
MLH 20 1 0 0 1 0 1 0 0 MLH 20 0 1 0 0 0 0 0 1 MLH 20 0 0 1 0 0 2 0 0
MLH 21 1 0 0 1 0 0 0 0 MLH 21 0 1 0 0 0 0 0 1 MLH 21 0 0 1 0 0 2 0 0
MLH 22 1 0 0 1 0 0 0 0 MLH 22 0 1 0 0 0 1 0 1 MLH 22 0 0 1 0 0 3 0 0
MLH 23 1 0 0 1 0 1 0 0 MLH 23 0 1 0 0 0 2 0 1 MLH 23 0 0 1 0 0 2 0 0
MLH 24 1 0 0 1 1 1 0 0 MLH 24 0 1 0 0 0 2 0 1 MLH 24 0 0 1 0 0 2 0 0
MLH 25 1 0 0 1 0 1 0 0 MLH 25 0 1 0 0 0 1 0 1 MLH 25 0 0 1 0 0 2 0 0
MLH 26 1 0 0 1 0 1 0 0 MLH 26 0 1 0 0 0 2 0 1 MLH 26 0 0 1 0 0 2 0 0
MLH 27 1 0 0 1 0 0 0 0 MLH 27 0 1 0 0 0 1 0 1 MLH 27 0 0 1 0 0 2 0 0
MLH 28 1 0 0 1 0 0 0 0 MLH 28 0 1 0 0 0 1 0 1 MLH 28 0 0 1 0 0 3 0 0
MLH 29 1 0 0 1 0 2 0 0 MLH 29 0 1 0 0 0 1 0 1 MLH 29 0 0 1 0 0 2 0 0
MLH 30 1 0 0 1 1 1 0 0 MLH 30 0 1 0 0 0 1 0 1 MLH 30 0 0 1 0 0 3 0 0
MLH 31 1 0 0 1 0 1 0 0 MLH 31 0 1 0 0 0 1 0 1 MLH 31 0 0 1 0 0 1 0 0
MLH 32 1 0 0 1 0 1 0 0 MLH 32 0 1 0 0 0 1 0 1 MLH 32 0 0 1 0 0 2 0 0
LHM 1 1 0 0 0 0 2 0 0 LHM 1 0 1 1 0 0 2 0 0 LHM 1 0 0 0 1 0 2 1 0
LHM 2 1 0 0 0 0 0 0 0 LHM 2 0 1 1 0 0 3 0 0 LHM 2 0 0 0 1 0 1 1 0
LHM 3 1 0 0 0 1 0 0 0 LHM 3 0 1 1 0 0 2 0 0 LHM 3 0 0 0 1 0 1 1 0
LHM 4 1 0 0 0 0 2 0 0 LHM 4 0 1 1 0 0 3 0 0 LHM 4 0 0 0 1 0 0 1 0
LHM 5 1 0 0 0 0 2 0 0 LHM 5 0 1 1 0 0 1 0 0 LHM 5 0 0 0 1 0 1 1 0
LHM 6 1 0 0 0 1 1 0 0 LHM 6 0 1 1 0 0 0 0 0 LHM 6 0 0 0 1 0 1 1 0
LHM 7 1 0 0 0 0 1 0 0 LHM 7 0 1 1 0 0 0 0 0 LHM 7 0 0 0 1 0 1 1 0
LHM 8 1 0 0 0 0 2 0 0 LHM 8 0 1 1 0 0 3 0 0 LHM 8 0 0 0 1 0 1 1 0
LHM 9 1 0 0 0 1 0 0 0 LHM 9 0 1 1 0 0 3 0 0 LHM 9 0 0 0 1 0 1 1 0
LHM 10 1 0 0 0 0 2 0 0 LHM 10 0 1 1 0 0 3 0 0 LHM 10 0 0 0 1 0 2 1 0
LHM 11 1 0 0 0 0 0 0 0 LHM 11 0 1 1 0 0 1 0 0 LHM 11 0 0 0 1 0 2 1 0
LHM 12 1 0 0 0 0 2 0 0 LHM 12 0 1 1 0 0 1 0 0 LHM 12 0 0 0 1 0 1 1 0
LHM 13 1 0 0 0 0 0 0 0 LHM 13 0 1 1 0 0 2 0 0 LHM 13 0 0 0 1 0 2 1 0
LHM 14 1 0 0 0 0 1 0 0 LHM 14 0 1 1 0 0 3 0 0 LHM 14 0 0 0 1 0 1 1 0
LHM 15 1 0 0 0 1 2 0 0 LHM 15 0 1 1 0 0 2 0 0 LHM 15 0 0 0 1 0 2 1 0
LHM 16 1 0 0 0 1 0 0 0 LHM 16 0 1 1 0 0 3 0 0 LHM 16 0 0 0 1 0 1 1 0
LHM 17 1 0 0 0 1 0 0 0 LHM 17 0 1 1 0 0 2 0 0 LHM 17 0 0 0 1 0 1 1 0
LHM 18 1 0 0 0 0 1 0 0 LHM 18 0 1 1 0 0 3 0 0 LHM 18 0 0 0 1 0 0 1 0
LHM 19 1 0 0 0 0 1 0 0 LHM 19 0 1 1 0 0 0 0 0 LHM 19 0 0 0 1 0 0 1 0
LHM 20 1 0 0 0 0 1 0 0 LHM 20 0 1 1 0 0 2 0 0 LHM 20 0 0 0 1 0 1 1 0
LHM 21 1 0 0 0 0 1 0 0 LHM 21 0 1 1 0 0 1 0 0 LHM 21 0 0 0 1 0 1 1 0
LHM 22 1 0 0 0 0 2 0 0 LHM 22 0 1 1 0 0 1 0 0 LHM 22 0 0 0 1 0 0 1 0
LHM 23 1 0 0 0 0 2 0 0 LHM 23 0 1 1 0 0 2 0 0 LHM 23 0 0 0 1 0 1 1 0
LHM 24 1 0 0 0 1 2 0 0 LHM 24 0 1 1 0 0 3 0 0 LHM 24 0 0 0 1 0 1 1 0
LMH 1 1 0 0 0 0 0 0 0 LMH 1 0 1 0 1 0 2 0 0 LMH 1 0 0 1 0 0 3 0 1
LMH 2 1 0 0 0 0 1 0 0 LMH 2 0 1 0 1 0 2 0 0 LMH 2 0 0 1 0 0 3 0 1
LMH 3 1 0 0 0 1 1 0 0 LMH 3 0 1 0 1 0 1 0 0 LMH 3 0 0 1 0 0 2 0 1
LMH 4 1 0 0 0 0 1 0 0 LMH 4 0 1 0 1 0 2 0 0 LMH 4 0 0 1 0 0 3 0 1
LMH 5 1 0 0 0 0 1 0 0 LMH 5 0 1 0 1 0 1 0 0 LMH 5 0 0 1 0 0 2 0 1
LMH 6 1 0 0 0 1 2 0 0 LMH 6 0 1 0 1 0 0 0 0 LMH 6 0 0 1 0 0 3 0 1
LMH 7 1 0 0 0 0 3 0 0 LMH 7 0 1 0 1 0 0 0 0 LMH 7 0 0 1 0 0 2 0 1
LMH 8 1 0 0 0 0 2 0 0 LMH 8 0 1 0 1 0 2 0 0 LMH 8 0 0 1 0 0 3 0 1
LMH 9 1 0 0 0 1 1 0 0 LMH 9 0 1 0 1 0 1 0 0 LMH 9 0 0 1 0 0 2 0 1
LMH 10 1 0 0 0 0 3 0 0 LMH 10 0 1 0 1 0 2 0 0 LMH 10 0 0 1 0 0 3 0 1
LMH 11 1 0 0 0 0 1 0 0 LMH 11 0 1 0 1 0 1 0 0 LMH 11 0 0 1 0 0 3 0 1
LMH 12 1 0 0 0 0 1 0 0 LMH 12 0 1 0 1 0 2 0 0 LMH 12 0 0 1 0 0 3 0 1
LMH 13 1 0 0 0 0 0 0 0 LMH 13 0 1 0 1 0 1 0 0 LMH 13 0 0 1 0 0 1 0 1
LMH 14 1 0 0 0 0 0 0 0 LMH 14 0 1 0 1 0 2 0 0 LMH 14 0 0 1 0 0 2 0 1
LMH 15 1 0 0 0 1 0 0 0 LMH 15 0 1 0 1 0 1 0 0 LMH 15 0 0 1 0 0 1 0 1
LMH 16 1 0 0 0 1 1 0 0 LMH 16 0 1 0 1 0 2 0 0 LMH 16 0 0 1 0 0 0 0 1
LMH 17 1 0 0 0 1 2 0 0 LMH 17 0 1 0 1 0 1 0 0 LMH 17 0 0 1 0 0 0 0 1
LMH 18 1 0 0 0 0 1 0 0 LMH 18 0 1 0 1 0 0 0 0 LMH 18 0 0 1 0 0 1 0 1
LMH 19 1 0 0 0 0 1 0 0 LMH 19 0 1 0 1 0 2 0 0 LMH 19 0 0 1 0 0 2 0 1
LMH 20 1 0 0 0 0 0 0 0 LMH 20 0 1 0 1 0 2 0 0 LMH 20 0 0 1 0 0 3 0 1
LMH 21 1 0 0 0 0 0 0 0 LMH 21 0 1 0 1 0 1 0 0 LMH 21 0 0 1 0 0 1 0 1
LMH 22 1 0 0 0 0 0 0 0 LMH 22 0 1 0 1 0 2 0 0 LMH 22 0 0 1 0 0 2 0 1
LMH 23 1 0 0 0 0 0 0 0 LMH 23 0 1 0 1 0 1 0 0 LMH 23 0 0 1 0 0 2 0 1
LMH 24 1 0 0 0 1 0 0 0 LMH 24 0 1 0 1 0 2 0 0 LMH 24 0 0 1 0 0 2 0 1
;

proc phreg data=exercise nosummary;
strata strata;
model DichotResponse = period1 period2 high medium baseline
CarryHigh CarryMedium / ties=discrete;
Reduce: test CarryHigh=CarryMedium=period1=period2=0;
run;

ods select ResidualChiSq ParameterEstimates TestStmts;
proc phreg data=exercise nosummary;
strata strata;
model DichotResponse = high medium baseline
/ selection=forward rl include=2 details ties=discrete;
Treat: test high = medium = 0;
run;

*******************General Conditional Logistic Regression;
data diagnosis;
input std1 $ test1 $ std2 $ test2 $ count;
do i=1 to count;
output;
end;
datalines;
Neg Neg Neg Neg 509
Neg Neg Neg Pos 4
Neg Neg Pos Neg 17
Neg Neg Pos Pos 3
Neg Pos Neg Neg 13
Neg Pos Neg Pos 8
Neg Pos Pos Neg 0
Neg Pos Pos Pos 8
Pos Neg Neg Neg 14
Pos Neg Neg Pos 1
Pos Neg Pos Neg 17
Pos Neg Pos Pos 9
Pos Pos Neg Neg 7
Pos Pos Neg Pos 4
Pos Pos Pos Neg 9
Pos Pos Pos Pos 170
;
run;

data diagnosis2;
set diagnosis;
drop std1 test1 std2 test2;
subject=_n_;
time=0; procedure=0;
response=std1; output;
time=0; procedure=1;
response=test1; output;
time=1; procedure=0;
response=std2; output;
time=1; procedure=1;
response=test2; output;
run;
data diagnosis3;
set diagnosis2;
outcome = 2 - (response=¡¯Neg¡¯);
time_procedure=time*procedure;
proc phreg data=diagnosis3 nosummary;
strata subject;
model outcome=time procedure
time_procedure /ties=discrete;
run;
proc phreg data=diagnosis3 nosummary;
strata subject;
model outcome=time procedure time_procedure
/ties=discrete selection=forward include=2 details rl;
run;

*Paired Observations in a Retrospective Matched Study;

*1:1 Conditional Logistic Regression;
data match1;
drop id1 gall1 hyper1 age1 est1 nonest1 gallest1;
retain id1 gall1 hyper1 age1 est1 nonest1 gallest1 0;
input id case age est gall hyper nonest @@;
gallest=est*gall;
if (id = id1) then do;
gall=gall1-gall; hyper=hyper1-hyper; age=age1-age;
est=est1-est; nonest=nonest1-nonest;
gallest=gallest1-gallest;
output;
end;
else do;
id1=id; gall1=gall; hyper1=hyper; age1=age;
est1=est; nonest1=nonest; gallest1=gallest;
end;
datalines;
1 1 74 1 0 0 1 1 0 75 0 0 0 0
2 1 67 1 0 0 1 2 0 67 0 0 1 1
3 1 76 1 0 1 1 3 0 76 1 0 1 1
4 1 71 1 0 0 0 4 0 70 1 1 0 1
5 1 69 1 1 0 1 5 0 69 1 0 1 1
6 1 70 1 0 1 1 6 0 71 0 0 0 0
7 1 65 1 1 0 1 7 0 65 0 0 0 0
8 1 68 1 1 1 1 8 0 68 0 0 1 1
9 1 61 0 0 0 1 9 0 61 0 0 0 1
10 1 64 1 0 0 1 10 0 65 0 0 0 0
11 1 68 1 1 0 1 11 0 69 1 1 0 0
12 1 74 1 0 0 1 12 0 74 1 0 0 0
13 1 67 1 1 0 1 13 0 68 1 0 1 1
14 1 62 1 1 0 1 14 0 62 0 1 0 0
15 1 71 1 1 0 1 15 0 71 1 0 1 1
16 1 83 1 0 1 1 16 0 82 0 0 0 0
17 1 70 0 0 0 1 17 0 70 0 0 1 1
18 1 74 1 0 0 1 18 0 75 0 0 0 0
19 1 70 1 0 0 1 19 0 70 0 0 0 0
20 1 66 1 0 1 1 20 0 66 1 0 0 1
21 1 77 1 0 0 1 21 0 77 1 1 1 1
22 1 66 1 0 1 1 22 0 67 0 0 1 1
23 1 71 1 0 1 0 23 0 72 0 0 0 0
24 1 80 1 0 0 1 24 0 79 0 0 0 0
25 1 64 1 0 0 1 25 0 64 1 0 0 1
26 1 63 1 0 0 1 26 0 63 1 0 1 1
27 1 72 0 1 0 1 27 0 72 0 0 1 0
28 1 57 1 0 0 0 28 0 57 1 0 1 1
29 1 74 0 1 0 1 29 0 74 0 0 0 1
30 1 62 1 0 1 1 30 0 62 1 0 0 1
31 1 73 1 0 1 1 31 0 72 1 0 0 1
32 1 71 1 0 1 1 32 0 71 1 0 1 1
33 1 64 0 0 1 1 33 0 65 1 0 0 1
34 1 63 1 0 0 1 34 0 64 0 0 0 1
35 1 79 1 1 1 1 35 0 78 1 1 1 1
36 1 80 1 0 0 1 36 0 81 0 0 1 1
37 1 82 1 0 1 1 37 0 82 0 0 0 1
38 1 71 1 0 1 1 38 0 71 0 0 1 1
39 1 83 1 0 1 1 39 0 83 0 0 0 1
40 1 61 1 0 1 1 40 0 60 0 0 0 1
41 1 71 1 0 0 1 41 0 71 0 0 0 0
42 1 69 1 0 1 1 42 0 69 0 1 0 1
43 1 77 1 0 0 1 43 0 76 1 0 1 1
44 1 64 1 0 0 0 44 0 64 1 0 0 0
45 1 79 0 1 0 0 45 0 82 1 0 0 1
46 1 72 1 0 0 1 46 0 72 1 0 0 1
47 1 82 1 1 1 1 47 0 81 0 0 0 0
48 1 73 1 0 1 1 48 0 74 1 0 0 1
49 1 69 1 0 0 1 49 0 68 0 0 0 1
50 1 79 1 0 1 1 50 0 79 0 0 0 1
51 1 72 1 0 0 0 51 0 71 1 0 1 1
52 1 72 1 0 1 1 52 0 72 1 0 1 1
53 1 65 1 0 1 1 53 0 67 0 0 0 0
54 1 67 1 0 1 1 54 0 66 1 0 0 1
55 1 64 1 1 0 1 55 0 63 0 0 0 1
56 1 62 1 0 0 0 56 0 63 0 0 0 0
57 1 83 0 1 1 1 57 0 83 0 1 0 0
58 1 81 1 0 0 1 58 0 79 0 0 0 0
59 1 67 1 0 0 1 59 0 66 1 0 1 1
60 1 73 1 1 1 1 60 0 72 1 0 0 1
61 1 67 1 1 0 1 61 0 67 1 1 0 1
62 1 74 1 0 1 1 62 0 75 0 0 0 1
63 1 68 1 1 0 1 63 0 69 1 0 0 1
;
proc logistic;
model case = gall est hyper age nonest /
noint selection=forward details;
run;
data match2;
input id case age est gall hyper nonest @@;
case=2-case;
datalines;
1 1 74 1 0 0 1 1 0 75 0 0 0 0
2 1 67 1 0 0 1 2 0 67 0 0 1 1
3 1 76 1 0 1 1 3 0 76 1 0 1 1
4 1 71 1 0 0 0 4 0 70 1 1 0 1
5 1 69 1 1 0 1 5 0 69 1 0 1 1
6 1 70 1 0 1 1 6 0 71 0 0 0 0
7 1 65 1 1 0 1 7 0 65 0 0 0 0
8 1 68 1 1 1 1 8 0 68 0 0 1 1
9 1 61 0 0 0 1 9 0 61 0 0 0 1
10 1 64 1 0 0 1 10 0 65 0 0 0 0
11 1 68 1 1 0 1 11 0 69 1 1 0 0
12 1 74 1 0 0 1 12 0 74 1 0 0 0
13 1 67 1 1 0 1 13 0 68 1 0 1 1
14 1 62 1 1 0 1 14 0 62 0 1 0 0
15 1 71 1 1 0 1 15 0 71 1 0 1 1
16 1 83 1 0 1 1 16 0 82 0 0 0 0
17 1 70 0 0 0 1 17 0 70 0 0 1 1
18 1 74 1 0 0 1 18 0 75 0 0 0 0
19 1 70 1 0 0 1 19 0 70 0 0 0 0
20 1 66 1 0 1 1 20 0 66 1 0 0 1
21 1 77 1 0 0 1 21 0 77 1 1 1 1
22 1 66 1 0 1 1 22 0 67 0 0 1 1
23 1 71 1 0 1 0 23 0 72 0 0 0 0
24 1 80 1 0 0 1 24 0 79 0 0 0 0
25 1 64 1 0 0 1 25 0 64 1 0 0 1
26 1 63 1 0 0 1 26 0 63 1 0 1 1
27 1 72 0 1 0 1 27 0 72 0 0 1 0
28 1 57 1 0 0 0 28 0 57 1 0 1 1
29 1 74 0 1 0 1 29 0 74 0 0 0 1
30 1 62 1 0 1 1 30 0 62 1 0 0 1
31 1 73 1 0 1 1 31 0 72 1 0 0 1
32 1 71 1 0 1 1 32 0 71 1 0 1 1
33 1 64 0 0 1 1 33 0 65 1 0 0 1
34 1 63 1 0 0 1 34 0 64 0 0 0 1
35 1 79 1 1 1 1 35 0 78 1 1 1 1
36 1 80 1 0 0 1 36 0 81 0 0 1 1
37 1 82 1 0 1 1 37 0 82 0 0 0 1
38 1 71 1 0 1 1 38 0 71 0 0 1 1
39 1 83 1 0 1 1 39 0 83 0 0 0 1
40 1 61 1 0 1 1 40 0 60 0 0 0 1
41 1 71 1 0 0 1 41 0 71 0 0 0 0
42 1 69 1 0 1 1 42 0 69 0 1 0 1
43 1 77 1 0 0 1 43 0 76 1 0 1 1
44 1 64 1 0 0 0 44 0 64 1 0 0 0
45 1 79 0 1 0 0 45 0 82 1 0 0 1
46 1 72 1 0 0 1 46 0 72 1 0 0 1
47 1 82 1 1 1 1 47 0 81 0 0 0 0
48 1 73 1 0 1 1 48 0 74 1 0 0 1
49 1 69 1 0 0 1 49 0 68 0 0 0 1
50 1 79 1 0 1 1 50 0 79 0 0 0 1
51 1 72 1 0 0 0 51 0 71 1 0 1 1
52 1 72 1 0 1 1 52 0 72 1 0 1 1
53 1 65 1 0 1 1 53 0 67 0 0 0 0
54 1 67 1 0 1 1 54 0 66 1 0 0 1
55 1 64 1 1 0 1 55 0 63 0 0 0 1
56 1 62 1 0 0 0 56 0 63 0 0 0 0
57 1 83 0 1 1 1 57 0 83 0 1 0 0
58 1 81 1 0 0 1 58 0 79 0 0 0 0
59 1 67 1 0 0 1 59 0 66 1 0 1 1
60 1 73 1 1 1 1 60 0 72 1 0 0 1
61 1 67 1 1 0 1 61 0 67 1 1 0 1
62 1 74 1 0 1 1 62 0 75 0 0 0 1
63 1 68 1 1 0 1 63 0 69 1 0 0 1
;

proc phreg;
strata id;
model case = gall est hyper age nonest /
selection=forward details rl;
run;

data matched;
input id outcome lung vaccine @@;
outcome=2-outcome;
lung_vac=lung*vaccine;
datalines;
1 1 0 0 1 0 1 0 1 0 0 0 2 1 0 0 2 0 0 0 2 0 1 0
3 1 0 1 3 0 0 1 3 0 0 0 4 1 1 0 4 0 0 0 4 0 1 0
5 1 1 0 5 0 0 1 5 0 0 1 6 1 0 0 6 0 0 0 6 0 0 1
7 1 0 0 7 0 0 0 7 0 0 1 8 1 1 1 8 0 0 0 8 0 0 1
9 1 0 0 9 0 0 1 9 0 0 0 10 1 0 0 10 0 1 0 10 0 0 0
11 1 1 0 11 0 0 1 11 0 0 0 12 1 1 1 12 0 0 1 12 0 0 0
13 1 0 0 13 0 0 1 13 0 1 0 14 1 0 0 14 0 0 0 14 0 0 1
15 1 1 0 15 0 0 0 15 0 0 1 16 1 0 1 16 0 0 1 16 0 0 1
17 1 0 0 17 0 1 0 17 0 0 0 18 1 1 0 18 0 0 1 18 0 0 1
19 1 1 0 19 0 0 1 19 0 0 1 20 1 0 0 20 0 0 0 20 0 0 0
21 1 0 0 21 0 0 1 21 0 0 1 22 1 0 1 22 0 0 0 22 0 1 0
23 1 1 1 23 0 0 0 23 0 0 0 24 1 0 0 24 0 0 1 24 0 0 1
25 1 1 0 25 0 1 0 25 0 0 0 26 1 1 1 26 0 0 0 26 0 0 0
27 1 1 0 27 0 0 1 27 0 0 0 28 1 0 1 28 0 1 0 28 0 0 0
29 1 0 0 29 0 0 0 29 0 1 1 30 1 0 0 30 0 0 0 30 0 0 0
31 1 0 0 31 0 0 0 31 0 0 1 32 1 1 0 32 0 0 0 32 0 0 0
33 1 0 1 33 0 0 0 33 0 0 0 34 1 0 0 34 0 1 0 34 0 0 0
35 1 1 0 35 0 1 1 35 0 0 0 36 1 0 1 36 0 0 0 36 0 0 1
37 1 0 1 37 0 0 0 37 0 0 1 38 1 1 1 38 0 0 1 38 0 0 0
39 1 0 0 39 0 0 1 39 0 0 1 40 1 0 0 40 0 0 0 40 0 1 1
41 1 1 0 41 0 0 0 41 0 0 1 42 1 1 0 42 0 0 0 42 0 0 0
43 1 0 0 43 0 0 1 43 0 0 0 44 1 1 0 44 0 0 0 44 0 0 0
45 1 1 0 45 0 0 0 45 0 0 0 46 1 1 0 46 0 1 1 46 0 0 0
47 1 0 1 47 0 0 0 47 0 0 1 48 1 0 0 48 0 0 0 48 0 0 0
49 1 1 0 49 0 1 0 49 0 1 1 50 1 1 1 50 0 0 0 50 0 0 1
51 1 1 0 51 0 0 1 51 0 0 1 52 1 0 1 52 0 0 0 52 0 0 0
53 1 0 1 53 0 0 1 53 0 0 1 54 1 1 0 54 0 0 0 54 0 0 0
55 1 0 0 55 0 0 1 55 0 0 0 56 1 0 0 56 0 0 0 56 0 1 0
57 1 1 1 57 0 1 0 57 0 0 0 58 1 1 0 58 0 0 1 58 0 0 1
59 1 0 0 59 0 0 0 59 0 1 1 60 1 0 0 60 0 0 0 60 0 0 1
61 1 0 1 61 0 0 0 61 0 0 1 62 1 0 0 62 0 0 0 62 0 0 1
63 1 0 0 63 0 0 1 63 0 0 0 64 1 0 0 64 0 1 0 64 0 0 0
65 1 1 1 65 0 0 0 65 0 1 0 66 1 1 1 66 0 0 1 66 0 1 0
67 1 0 0 67 0 0 0 67 0 0 1 68 1 0 0 68 0 0 1 68 0 0 1
69 1 1 1 69 0 0 1 69 0 0 1 70 1 0 0 70 0 0 1 70 0 1 1
71 1 0 0 71 0 0 0 71 0 0 1 72 1 1 0 72 0 0 0 72 0 0 0
73 1 1 0 73 0 0 1 73 0 0 0 74 1 0 0 74 0 0 0 74 0 0 1
75 1 0 0 75 0 0 1 75 0 0 0 76 1 0 0 76 0 0 0 76 0 0 0
77 1 0 1 77 0 0 0 77 0 0 1 78 1 0 0 78 0 0 1 78 0 0 0
79 1 1 0 79 0 0 1 79 0 0 1 80 1 0 1 80 0 0 0 80 0 0 0
81 1 0 0 81 0 1 1 81 0 0 1 82 1 1 1 82 0 1 0 82 0 0 0
83 1 0 1 83 0 0 0 83 0 0 1 84 1 0 0 84 0 0 0 84 0 0 1
85 1 1 0 85 0 0 0 85 0 0 0 86 1 0 0 86 0 1 1 86 0 1 0
87 1 1 1 87 0 0 0 87 0 0 0 88 1 0 0 88 0 0 0 88 0 0 0
89 1 0 0 89 0 0 1 89 0 1 1 90 1 0 0 90 0 0 0 90 0 0 0
91 1 0 1 91 0 0 0 91 0 0 1 92 1 0 0 92 0 1 1 92 0 0 0
93 1 0 1 93 0 0 0 93 0 1 0 94 1 1 0 94 0 0 0 94 0 0 0
95 1 1 1 95 0 0 1 95 0 0 0 96 1 1 0 96 0 0 1 96 0 0 1
97 1 1 1 97 0 0 0 97 0 0 1 98 1 0 0 98 0 0 0 98 0 1 1
99 1 0 1 99 0 1 1 99 0 0 1 100 1 1 0 100 0 0 0 100 0 0 0
101 1 0 0 101 0 0 0 101 0 0 0 102 1 0 1 102 0 0 0 102 0 0 0
103 1 0 1 103 0 0 0 103 0 0 0 104 1 1 0 104 0 0 1 104 0 1 0
105 1 1 0 105 0 1 0 105 0 0 0 106 1 0 0 106 0 0 0 106 0 0 1
107 1 0 0 107 0 0 1 107 0 0 1 108 1 1 1 108 0 0 0 108 0 0 1
109 1 0 1 109 0 0 0 109 0 0 0 110 1 0 0 110 0 0 0 110 0 0 0
111 1 1 0 111 0 0 1 111 0 0 1 112 1 0 0 112 0 0 1 112 0 0 0
113 1 0 1 113 0 0 0 113 0 1 0 114 1 1 1 114 0 0 1 114 0 0 1
115 1 1 1 115 0 0 1 115 0 0 1 116 1 0 0 116 0 0 1 116 0 1 0
117 1 0 1 117 0 0 0 117 0 0 0 118 1 1 0 118 0 1 0 118 0 0 0
119 1 1 0 119 0 0 0 119 0 0 0 120 1 1 0 120 0 0 0 120 0 0 1
121 1 0 0 121 0 0 1 121 0 0 0 122 1 0 1 122 0 0 0 122 0 0 0
123 1 1 0 123 0 0 0 123 0 1 1 124 1 0 0 124 0 0 1 124 0 0 0
125 1 1 0 125 0 1 0 125 0 0 0 126 1 1 1 126 0 0 0 126 0 0 0
127 1 1 0 127 0 0 1 127 0 0 0 128 1 0 1 128 0 1 0 128 0 0 0
129 1 0 0 129 0 0 0 129 0 1 1 130 1 0 0 130 0 0 0 130 0 0 0
131 1 0 0 131 0 0 0 131 0 0 1 132 1 1 0 132 0 0 0 132 0 0 1
133 1 0 1 133 0 0 0 133 0 0 0 134 1 0 0 134 0 1 0 134 0 0 1
135 1 1 0 135 0 1 1 135 0 0 0 136 1 0 0 136 0 0 0 136 0 0 0
137 1 0 0 137 0 0 0 137 0 0 1 138 1 1 0 138 0 0 0 138 0 0 0
139 1 0 0 139 0 0 0 139 0 0 0 140 1 0 0 140 0 0 1 140 0 1 1
141 1 1 1 141 0 0 0 141 0 0 1 142 1 1 0 142 0 0 0 142 0 0 0
143 1 0 0 143 0 0 1 143 0 1 1 144 1 1 1 144 0 0 1 144 0 0 1
145 1 1 0 145 0 0 1 145 0 0 0 146 1 1 0 146 0 1 0 146 0 0 0
147 1 0 1 147 0 0 0 147 0 0 1 148 1 0 0 148 0 0 1 148 0 0 0
149 1 1 0 149 0 1 0 149 0 1 0 150 1 1 1 150 0 0 0 150 0 0 1
;
proc freq;
tables outcome*lung outcome*vaccine /nocol nopct;
run;
proc phreg;
strata id;
model outcome = lung vaccine lung_vac /
selection=forward details ties=discrete;
run;

proc phreg;
strata id;
model outcome = lung vaccine lung_vac /
selection=forward details include=2 ties=discrete rl;
run;

*Exact Conditional Logistic Regression in the Stratified Setting;
data animal;
input animal treatment $ response $ @@;
if treatment=¡¯S¡¯ then delete;
else if treatment=¡¯C¡¯ then ordtreat=1;
else if treatment=¡¯DA¡¯ then ordtreat=2;
else if treatment=¡¯D1¡¯ then ordtreat=3;
else if treatment=¡¯D2¡¯ then ordtreat=4;
datalines;
1 S no 1 C no 1 C no 1 D2 yes 1 D1 yes
2 S no 2 D2 yes 2 C no 2 D1 yes
3 S no 3 C yes 3 D1 yes 3 DA no 3 C no
4 S no 4 C no 4 D1 yes 4 DA no 4 C no
5 S yes 5 C no 5 DA no 5 D1 no 5 C no
6 S no 6 C no 6 D1 yes 6 DA no 6 C no
7 S no 7 C no 7 D1 yes 7 DA no 7 C no
8 S yes 8 C yes 8 D1 yes
;
proc logistic data=animal descending exactonly;
class animal /param=ref;
model response = animal ordtreat;
exact ¡¯parm¡¯ ordtreat / estimate=parm;
run;

data animal2;
set animal;
if response = ¡¯yes¡¯ then event = 1;
else event = 2;
run;

ods select ResidualChiSq ParameterEstimates;
proc phreg data=animal2;
strata animal;
model event = ordtreat /selection=forward
details ties=discrete slentry=.05;
run;


ods output ExactTests=try1 ExactParmEst=try2;
proc logistic data=animal descending;
class animal /param=ref;
model response = animal ordtreat;
exact ¡¯parm¡¯ ordtreat / estimate=both;
run;
proc template;
define table ExactTests2;
parent=Stat.Logistic.Exacttests;
column Label Effect Test Statistic ExactPValue MidPValue;
define ExactPValue;
parent =Stat.Logistic.ExactPValue;
format=D8.6;
end;
end;
data _null_;
title2 ¡¯Listing of ExactTests Using a Customized Template¡¯;
set try1;
file print ods=(template=¡¯ExactTests2¡¯);
put _ods_;
run;

*Quantal Bioassay Analysis;
data bacteria;
input dose status $ count @@;
ldose=log(dose);
sq_ldose=ldose*ldose;
datalines;
1200 dead 0 1200 alive 5
12000 dead 0 12000 alive 5
120000 dead 2 120000 alive 3
1200000 dead 4 1200000 alive 2
12000000 dead 5 12000000 alive 1
120000000 dead 5 120000000 alive 0
;
proc print;
run;
proc logistic data=bacteria descending;
freq count;
model status = ldose sq_ldose / scale=none aggregate
selection=forward start=1 details covb;
run;

*Analysis of the Peptide Data;
data assay;
input drug $ dose status $ count;
int_n=(drug=¡¯n¡¯);
int_s=(drug=¡¯s¡¯);
ldose=log(dose);
ldose_n=int_n*ldose;
ldose_s=int_s*ldose;
sqldose_n=int_n*ldose*ldose;
sqldose_s=int_s*ldose*ldose;
datalines;
n 0.01 dead 0
n 0.01 alive 30
n .03 dead 1
n .03 alive 29
n .10 dead 1
n .10 alive 9
n .30 dead 1
n .30 alive 9
n 1.00 dead 4
n 1.00 alive 6
n 3.00 dead 4
n 3.00 alive 6
n 10.00 dead 5
n 10.00 alive 5
n 30.00 dead 7
n 30.00 alive 3
s .30 dead 0
s .30 alive 10
s 1.00 dead 0
s 1.00 alive 10
s 3.00 dead 1
s 3.00 alive 9
s 10.00 dead 4
s 10.00 alive 6
s 30.00 dead 5
s 30.00 alive 5
s 100.00 dead 8
s 100.00 alive 2
;
proc logistic data=assay descending;
freq count;
model status = int_n int_s ldose_n ldose_s
sqldose_n sqldose_s / noint
scale=none aggregate
start=4 selection=forward details;
eq_slope: test ldose_n=ldose_s;
run;

proc logistic data=assay descending outest=estimate
(drop= intercept _link_ _lnlike_) covout;
freq count;
model status = int_n int_s ldose /
noint scale=none aggregate covb;
run;

proc iml;
use estimate;
start fieller;
title ¡¯Confidence Intervals¡¯;
use estimate;
read all into beta where (_type_=¡¯PARMS¡¯);
beta=beta¡®;
read all into cov where (_type_=¡¯COV¡¯);
ratio=(k¡®*beta) / (h¡®*beta);
a=(h¡®*beta)**2-(3.84)*(h¡®*cov*h);
b=2*(3.84*(k¡®*cov*h)-(k¡®*beta)*(h¡®*beta));
c=(k¡®*beta)**2 -(3.84)*(k¡®*cov*k);
disc=((b**2)-4*a*c);
if (disc<=0 | a<=0) then do;
print "confidence interval can¡¯t be computed", ratio;
stop; end;
sroot=sqrt(disc);
l_b=((-b)-sroot)/(2*a);
u_b=((-b)+sroot)/(2*a);
interval=l_b||u_b;
lname={"l_bound", "u_bound"};
print "95 % ci for ratio based on fieller", ratio interval[colname=lname];
finish fieller;
k={ 1 -1 0 }¡®;
h={ 0 0 1 }¡®;
run fieller;
k={-1 0 0 }¡®;
h={ 0 0 1 }¡®;
run fieller;
k={ 0 -1 0 }¡®;
h={ 0 0 1 }¡®;
run fieller;

data adverse;
input diagnos $ dose status $ count @@;
i_diagII=(diagnos=¡¯II¡¯);
i_diagI= (diagnos=¡¯I¡¯);
doseI=i_diagI*dose;
doseII=i_diagII*dose;
diagdose=i_diagII*dose;
if doseI > 0 then ldoseI=log(doseI); else ldoseI=0;
if doseII > 0 then ldoseII=log(doseII); else ldoseII=0;
datalines;
I 1 adverse 3 I 1 no 26
I 5 adverse 7 I 5 no 26
I 10 adverse 10 I 10 no 22
I 12 adverse 14 I 12 no 18
I 15 adverse 18 I 15 no 14
II 1 adverse 6 II 1 no 26
II 5 adverse 20 II 5 no 12
II 10 adverse 26 II 10 no 6
II 12 adverse 28 II 12 no 4
II 15 adverse 31 II 15 no 1
;
proc freq data=adverse;
weight count;
tables dose*status diagnos*status diagnos*dose*status /
nopct nocol cmh;
run;

proc logistic data=adverse outest=estimate
(drop= intercept _link_ _lnlike_) covout;
freq count;
model status = i_diagI i_diagII doseI doseII /
noint scale=none aggregate;
eq_slope: test doseI=doseII;
run;

proc logistic data=adverse;
freq count;
model status = i_diagI i_diagII ldoseI ldoseII /
noint scale=none aggregate;
eq_slope: test ldoseI=ldoseII;
run;

*************************************************************************Poisson Regression***************************;
*Simple Poisson Counts Example;
data melanoma;
input type $ site $ count;
datalines;
Hutchinson¡¯s Head&Neck 22
Hutchinson¡¯s Trunk 2
Hutchinson¡¯s Extremities 10
Superficial Head&Neck 16
Superficial Trunk 54
Superficial Extremities 115
Nodular Head&Neck 19
Nodular Trunk 33
Nodular Extremities 73
Indeterminate Head&Neck 11
Indeterminate Trunk 17
Indeterminate Extremities 28
;
run;

proc genmod;
class type site;
model count=type|site / dist=poisson link=log type3;
run;

*Poisson Regression for Incidence Densities;
data melanoma;
input age $ region $ cases total;
ltotal=log(total);
datalines;
35-44 south 75 220407
45-54 south 68 198119
55-64 south 63 134084
65-74 south 45 70708
75+ south 27 34233
<35 south 64 1074246
35-44 north 76 564535
45-54 north 98 592983
55-64 north 104 450740
65-74 north 63 270908
75+ north 80 161850
<35 north 61 2880262
;
proc genmod data=melanoma order=data;
class age region;
model cases = age region
/ dist=poisson link=log offset=ltotal;
run;

data lri;
input id count risk passive crowding ses agegroup race @@;
logrisk =log(risk/52);
datalines;
1 0 42 1 0 2 2 0 96 1 41 1 0 1 2 0 191 0 44 1 0 0 2 0
2 0 43 1 0 0 2 0 97 1 26 1 1 2 2 0 192 0 45 0 0 0 2 1
3 0 41 1 0 1 2 0 98 0 36 0 0 0 2 0 193 0 42 0 0 0 2 0
4 1 36 0 1 0 2 0 99 0 34 0 0 0 2 0 194 1 31 0 0 0 2 1
5 1 31 0 0 0 2 0 100 1 3 1 1 2 3 1 195 0 35 0 0 0 2 0
6 0 43 1 0 0 2 0 101 0 45 1 0 0 2 0 196 1 35 1 0 0 2 0
7 0 45 0 0 0 2 0 102 0 38 0 0 1 2 0 197 1 27 1 0 1 2 0
8 0 42 0 0 0 2 1 103 0 41 1 1 1 2 1 198 1 33 0 0 0 2 0
9 0 45 0 0 0 2 1 104 1 37 0 1 0 2 0 199 0 39 1 0 1 2 0
10 0 35 1 1 0 2 0 105 0 40 0 0 0 2 0 200 3 40 0 1 2 2 0
11 0 43 0 0 0 2 0 106 1 35 1 0 0 2 0 201 4 26 1 0 1 2 0
12 2 38 0 0 0 2 0 107 0 28 0 1 2 2 0 202 0 14 1 1 1 1 1
13 0 41 0 0 0 2 0 108 3 33 0 1 2 2 0 203 0 39 0 1 1 2 0
14 0 12 1 1 0 1 0 109 0 38 0 0 0 2 0 204 0 4 1 1 1 3 0
15 0 6 0 0 0 3 0 110 0 42 1 1 2 2 1 205 1 27 1 1 1 2 1
16 0 43 0 0 0 2 0 111 0 40 1 1 2 2 0 206 0 36 1 0 0 2 1
17 2 39 1 0 1 2 0 112 0 38 0 0 0 2 0 207 0 30 1 0 2 2 1
18 0 43 0 1 0 2 0 113 2 37 0 1 1 2 0 208 0 34 0 1 0 2 0
19 2 37 0 0 0 2 1 114 1 42 0 1 0 2 0 209 1 40 1 1 1 2 0
20 0 31 1 1 1 2 0 115 5 37 1 1 1 2 1 210 0 6 1 0 1 1 1
21 0 45 0 1 0 2 0 116 0 38 0 0 0 2 0 211 1 40 1 1 1 2 0
22 1 29 1 1 1 2 1 117 0 4 0 0 0 3 0 212 2 43 0 1 0 2 0
23 1 35 1 1 1 2 0 118 2 37 1 1 1 2 0 213 0 36 1 1 1 2 0
24 3 20 1 1 2 2 0 119 0 39 1 0 1 2 0 214 0 35 1 1 1 2 1
25 1 23 1 1 1 2 0 120 0 42 1 1 0 2 0 215 1 35 1 1 2 2 0
26 1 37 1 0 0 2 0 121 0 40 1 0 0 2 0 216 0 43 1 0 1 2 0
27 0 49 0 0 0 2 0 122 0 36 1 0 0 2 0 217 0 33 1 1 2 2 0
28 0 35 0 0 0 2 0 123 1 42 0 1 1 2 0 218 0 36 0 1 1 2 1
29 3 44 1 1 1 2 0 124 1 39 0 0 0 2 0 219 1 41 0 0 0 2 0
30 0 37 1 0 0 2 0 125 2 29 0 0 0 2 0 220 0 41 1 1 0 2 1
31 2 39 0 1 1 2 0 126 3 37 1 1 2 2 1 221 1 42 0 0 0 2 1
32 0 41 0 0 0 2 0 127 0 40 1 0 0 2 0 222 0 33 0 1 2 2 1
33 1 46 1 1 2 2 0 128 0 40 0 0 0 2 0 223 0 40 1 1 2 2 0
34 0 5 1 1 2 3 1 129 0 39 0 0 0 2 0 224 0 40 1 1 1 2 1
35 1 29 0 0 0 2 0 130 0 40 1 0 1 2 0 225 0 40 0 0 2 2 0
36 0 31 0 1 0 2 0 131 1 32 0 0 0 2 0 226 0 28 1 0 1 2 0
37 0 22 1 1 2 2 0 132 0 46 1 0 1 2 0 227 0 47 0 0 0 2 1
38 1 22 1 1 2 2 1 133 4 39 1 1 0 2 0 228 0 18 1 1 2 2 1
39 0 47 0 0 0 2 0 134 0 37 0 0 0 2 0 229 0 45 1 0 0 2 0
40 1 46 1 1 1 2 1 135 0 51 0 0 1 2 0 230 0 35 0 0 0 2 0
41 0 37 0 0 0 2 0 136 1 39 1 1 0 2 0 231 1 17 1 0 1 1 1
42 1 39 0 0 0 2 0 137 1 34 1 1 0 2 0 232 0 40 0 0 0 2 0
43 0 33 0 1 1 2 1 138 1 14 0 1 0 1 0 233 0 29 1 1 2 2 0
44 0 34 1 0 1 2 0 139 2 15 1 0 0 2 0 234 1 35 1 1 1 2 0
45 3 32 1 1 1 2 0 140 1 34 1 1 0 2 1 235 0 40 0 0 2 2 0
46 3 22 0 0 0 2 0 141 0 43 0 1 0 2 0 236 1 22 1 1 1 2 0
47 1 6 1 0 2 3 0 142 1 33 0 0 0 2 0 237 0 42 0 0 0 2 0
48 0 38 0 0 0 2 0 143 3 34 1 0 0 2 1 238 0 34 1 1 1 2 1
49 1 43 0 1 0 2 0 144 0 48 0 0 0 2 0 239 6 38 1 0 1 2 0
50 2 36 0 1 0 2 0 145 4 26 1 1 0 2 0 240 0 25 0 0 1 2 1
51 0 43 0 0 0 2 0 146 0 30 0 1 2 2 1 241 0 39 0 1 0 2 0
52 0 24 1 0 0 2 0 147 0 41 1 1 1 2 0 242 1 35 0 1 2 2 1
53 0 25 1 0 1 2 1 148 0 34 0 1 1 2 0 243 1 36 1 1 1 2 1
54 0 41 0 0 0 2 0 149 0 43 0 1 0 2 0 244 0 23 1 0 0 2 0
55 0 43 0 0 0 2 0 150 1 31 1 0 1 2 0 245 4 30 1 1 1 2 0
56 2 31 0 1 1 2 0 151 0 26 1 0 1 2 0 246 1 41 1 1 1 2 1
57 3 28 1 1 1 2 0 152 0 37 0 0 0 2 0 247 0 37 0 1 1 2 0
58 1 22 0 0 1 2 1 153 0 44 0 0 0 2 0 248 0 46 1 1 0 2 0
59 1 11 1 1 1 1 0 154 0 40 1 0 0 2 0 249 0 45 1 1 0 2 1
60 3 41 0 1 1 2 0 155 0 8 1 1 1 3 1 250 1 38 1 1 1 2 0
61 0 31 0 0 1 2 0 156 0 40 1 1 1 2 1 251 0 10 1 1 1 1 0
62 0 11 0 0 1 1 1 157 1 45 0 0 0 2 0 252 0 30 1 1 2 2 0
63 0 44 0 1 0 2 0 158 0 4 0 0 2 3 0 253 0 32 0 1 2 2 0
64 0 9 1 0 0 3 1 159 1 36 0 1 0 2 0 254 0 46 1 0 0 2 0
65 0 36 1 1 1 2 0 160 3 37 1 1 1 2 0 255 5 35 1 1 2 2 1
66 0 29 1 0 0 2 0 161 0 15 1 0 0 1 0 256 0 44 0 0 0 2 0
67 0 27 0 1 0 2 1 162 1 27 1 0 1 2 1 257 0 41 0 1 1 2 0
68 0 36 0 1 0 2 0 163 2 31 0 1 0 2 0 258 2 36 1 0 1 2 0
69 1 33 1 0 0 2 0 164 0 42 0 0 0 2 0 259 0 34 1 1 1 2 1
70 2 13 1 1 2 1 1 165 0 42 1 0 0 2 0 260 1 30 0 1 0 2 1
71 0 38 0 0 0 2 0 166 1 38 0 0 0 2 0 261 1 27 1 0 0 2 0
72 0 41 0 0 0 2 1 167 0 44 1 0 0 2 0 262 0 48 1 0 0 2 0
73 0 41 1 0 2 2 0 168 0 45 0 0 0 2 0 263 1 6 0 1 2 3 1
74 0 35 0 0 1 2 0 169 0 34 0 1 0 2 0 264 0 38 1 1 0 2 1
75 0 45 0 0 0 2 0 170 2 41 0 0 0 2 0 265 0 29 1 1 1 2 1
76 4 38 1 0 2 2 1 171 2 30 1 1 1 2 0 266 1 43 0 1 2 2 1
77 1 42 1 0 0 2 1 172 0 44 0 0 0 2 0 267 0 43 0 1 0 2 0
78 1 42 1 1 2 2 1 173 0 40 1 0 0 2 0 268 0 37 1 0 2 2 0
79 6 36 1 1 0 2 0 174 2 31 0 0 0 2 0 269 1 23 1 1 0 2 1
80 2 23 1 1 1 2 1 175 0 41 1 0 0 2 0 270 0 44 0 0 1 2 0
81 1 32 0 0 1 2 0 176 0 41 0 0 0 2 0 271 0 5 0 1 1 3 1
82 0 41 0 1 0 2 0 177 0 39 1 0 0 2 0 272 0 25 1 0 2 2 0
83 0 50 0 0 0 2 0 178 0 40 1 0 0 2 0 273 0 25 1 0 1 2 0
84 0 42 1 1 1 2 1 179 2 35 1 0 2 2 0 274 1 28 1 1 1 2 1
85 1 30 0 0 0 2 0 180 1 43 1 0 0 2 0 275 0 7 0 1 0 3 1
86 2 47 0 1 0 2 0 181 2 39 0 0 0 2 0 276 0 32 0 0 0 2 0
87 1 35 1 1 2 2 0 182 0 35 1 1 0 2 0 277 0 41 0 0 0 2 0
88 1 38 1 0 1 2 1 183 0 37 0 0 0 2 0 278 1 33 1 1 2 2 1
89 1 38 1 1 1 2 1 184 3 37 0 0 0 2 0 279 2 36 1 1 2 2 0
90 1 38 1 1 1 2 1 185 0 43 0 0 0 2 0 280 0 31 0 0 0 2 0
91 0 32 1 1 1 2 0 186 0 42 0 0 0 2 0 281 0 18 0 0 0 2 0
92 1 3 1 0 1 3 1 187 0 42 0 0 0 2 0 282 1 32 1 0 2 2 0
93 0 26 1 0 0 2 1 188 0 38 0 0 0 2 0 283 0 22 1 1 2 2 1
94 0 35 1 0 0 2 0 189 0 36 1 0 0 2 0 284 0 35 0 0 0 2 1
95 3 37 1 0 0 2 0 190 0 39 0 1 0 2 0
;

proc genmod data=lri;
class ses id race agegroup;
model count = passive crowding ses race agegroup /
dist=poisson offset=logrisk type3;
run;

proc genmod data=lri;
class ses id race agegroup;
model count = passive crowding ses race agegroup /
dist=poisson offset=logrisk type3 scale=pearson;
run;

*********************************************************************Weighted Least Squares********************************************;

*Using PROC CATMOD for Weighted Least Squares Analysis;
data colds;
input sex $ residence $ periods count @@;
datalines;
female rural 0 45 female rural 1 64 female rural 2 71
female urban 0 80 female urban 1 104 female urban 2 116
male rural 0 84 male rural 1 124 male rural 2 82
male urban 0 106 male urban 1 117 male urban 2 87
;
run;
proc catmod;
weight count;
response means;
model periods = sex residence sex*residence /freq prob;
run;

proc catmod;
weight count;
response means;
model periods = sex residence;
run;

proc catmod;
weight count;
response means;
model periods = sex;
run;

proc catmod;
population sex residence;
weight count;
response means;
model periods = sex;
run;

*Analysis of Means: Performing Contrast Tests;
data cpain;
input dstatus $ invest $ treat $ status $ count @@;
datalines;
I A active poor 3 I A active fair 2 I A active moderate 2
I A active good 1 I A active excel 0
I A placebo poor 7 I A placebo fair 0 I A placebo moderate 1
I A placebo good 1 I A placebo excel 1
I B active poor 1 I B active fair 6 I B active moderate 1
I B active good 5 I B active excel 3
I B placebo poor 5 I B placebo fair 4 I B placebo moderate 2
I B placebo good 3 I B placebo excel 3
II A active poor 1 II A active fair 0 II A active moderate 1
II A active good 2 II A active excel 2
II A placebo poor 1 II A placebo fair 1 II A placebo moderate 0
II A placebo good 1 II A placebo excel 1
II B active poor 0 II B active fair 1 II B active moderate 1
II B active good 1 II B active excel 6
II B placebo poor 3 II B placebo fair 1 II B placebo moderate 1
II B placebo good 5 II B placebo excel 0
III A active poor 2 III A active fair 0 III A active moderate 3
III A active good 3 III A active excel 2
III A placebo poor 5 III A placebo fair 0 III A placebo moderate 0
III A placebo good 8 III A placebo excel 1
III B active poor 2 III B active fair 4 III B active moderate 1
III B active good 10 III B active excel 3
III B placebo poor 2 III B placebo fair 5 III B placebo moderate 1
III B placebo good 4 III B placebo excel 2
IV A active poor 8 IV A active fair 1 IV A active moderate 3
IV A active good 4 IV A active excel 0
IV A placebo poor 5 IV A placebo fair 0 IV A placebo moderate 3
IV A placebo good 3 IV A placebo excel 0
IV B active poor 1 IV B active fair 5 IV B active moderate 2
IV B active good 3 IV B active excel 1
IV B placebo poor 3 IV B placebo fair 4 IV B placebo moderate 3
IV B placebo good 4 IV B placebo excel 2
;
proc catmod order=data;
weight count;
response 1 2 3 4 5;
model status=dstatus|invest|treat;
run;

*Analysis of Proportions: Occupational Data;
data byss;
input workplace $ em_years $ smoking $ status $ count @@;
datalines ;
dusty <10 yes yes 30 dusty <10 yes no 203
dusty <10 no yes 7 dusty <10 no no 119
dusty >=10 yes yes 57 dusty >=10 yes no 161
dusty >=10 no yes 11 dusty >=10 no no 81
notdusty <10 yes yes 14 notdusty <10 yes no 1340
notdusty <10 no yes 12 notdusty <10 no no 1004
notdusty >=10 yes yes 24 notdusty >=10 yes no 1360
notdusty >=10 no yes 10 notdusty >=10 no no 986
;
run;

proc catmod order=data;
weight count;
response marginals;
model status = workplace|em_years|smoking;
run;

proc catmod order=data;
weight count;
response marginals;
model status = workplace|em_years workplace|smoking
em_years|smoking;
run;

proc catmod order=data;
weight count;
response marginals;
model status = workplace|em_years workplace|smoking
em_years|smoking;
run;

data pain (drop=h0-h8);
input center initial $ treat $ h0-h8;
array hours h0-h8;
do i=1 to 9;
no_hours=i-1; count=hours(i); output;
end;
datalines;
1 some placebo 1 0 3 0 2 2 4 4 2
1 some treat_a 2 1 0 2 1 2 4 5 1
1 some treat_b 0 0 0 1 0 3 7 6 2
1 some treat_ba 0 0 0 0 1 3 5 4 6
1 lot placebo 6 1 2 2 2 3 7 3 0
1 lot treat_a 6 3 1 2 4 4 7 1 0
1 lot treat_b 3 1 0 4 2 3 11 4 0
1 lot treat_ba 0 0 0 1 1 7 9 6 2
2 some placebo 2 0 2 1 3 1 2 5 4
2 some treat_a 0 0 0 1 1 1 8 1 7
2 some treat_b 0 2 0 1 0 1 4 6 6
2 some treat_ba 0 0 0 1 3 0 4 7 5
2 lot placebo 7 2 3 2 3 2 3 2 2
2 lot treat_a 3 1 0 0 3 2 9 7 1
2 lot treat_b 0 0 0 1 1 5 8 7 4
2 lot treat_ba 0 1 0 0 1 2 8 9 5
3 some placebo 5 0 0 1 3 1 4 4 5
3 some treat_a 1 0 0 1 3 5 3 3 6
3 some treat_b 3 0 1 1 0 0 3 7 11
3 some treat_ba 0 0 0 1 1 4 2 4 13
3 lot placebo 6 0 2 2 2 6 1 2 1
3 lot treat_a 4 2 1 5 1 1 3 2 3
3 lot treat_b 5 0 2 3 1 0 2 6 7
3 lot treat_ba 3 2 1 0 0 2 5 9 4
4 some placebo 1 0 1 1 4 1 1 0 10
4 some treat_a 0 0 0 1 0 2 2 1 13
4 some treat_b 0 0 0 1 1 1 1 5 11
4 some treat_ba 1 0 0 0 0 2 2 2 14
4 lot placebo 4 0 1 3 2 1 1 2 2
4 lot treat_a 0 1 3 1 1 6 1 3 6
4 lot treat_b 0 0 0 0 2 7 2 2 9
4 lot treat_ba 1 0 3 0 1 2 3 4 8
;
proc print data=pain(obs=9);
run;

proc catmod;
weight count;
response 0 .125 .25 .375 .5 .625 .75 .875 1;
model no_hours = center initial treat
treat*initial;
run;

proc catmod;
weight count;
response 0 .125 .25 .375 .5 .625 .75 .875 1;
model no_hours = center initial
treat(initial);
run;

data wbeing;
input #1 b1-b5 _type_ $ _name_ $8. #2 b6-b10;
datalines;
7.24978 7.18991 7.35960 7.31937 7.55184 parms
7.93726 7.92509 7.82815 7.73696 8.16791
0.01110 0.00101 0.00177 -0.00018 -0.00082 cov b1
0.00189 -0.00123 0.00434 0.00158 -0.00050
0.00101 0.02342 0.00144 0.00369 0.25300 cov b2
0.00118 -0.00629 -0.00059 0.00212 -0.00098
0.00177 0.00144 0.01060 0.00157 0.00226 cov b3
0.00140 -0.00088 -0.00055 0.00211 0.00239
-0.00018 0.00369 0.00157 0.02298 0.00918 cov b4
-0.00140 -0.00232 0.00023 0.00066 -0.00010
-0.00082 0.00253 0.00226 0.00918 0.01921 cov b5
0.00039 0.00034 -0.00013 0.00240 0.00213
0.00189 0.00118 0.00140 -0.00140 0.00039 cov b6
0.00739 0.00019 0.00146 -0.00082 0.00076
-0.00123 -0.00629 -0.00088 -0.00232 0.00034 cov b7
0.00019 0.01172 0.00183 0.00029 0.00083
0.00434 -0.00059 -0.00055 0.00023 -0.00013 cov b8
0.00146 0.00183 0.01050 -0.00173 0.00011
0.00158 0.00212 0.00211 0.00066 0.00240 cov b9
-0.00082 0.00029 -0.00173 0.01335 0.00140
-0.00050 -0.00098 0.00239 -0.00010 0.00213 cov b10
0.00076 0.00083 0.00011 0.00140 0.01430
;

*The FACTOR Statement;
proc catmod data=wbeing;
response read b1-b10;
factors sex $ 2, age $ 5 /
_response_ = sex|age
profile = (female ¡¯25-34¡¯,
female ¡¯35-44¡¯,
female ¡¯45-54¡¯,
female ¡¯55-64¡¯,
female ¡¯65-74¡¯,
male ¡¯25-34¡¯,
male ¡¯35-44¡¯,
male ¡¯45-54¡¯,
male ¡¯55-64¡¯,
male ¡¯65-74¡¯);
model _f_ = _response_;
run;

*Preliminary Analysis;
proc catmod data=wbeing;
response read b1-b10;
factors sex $ 2, age $ 5 /
_response_ = sex age
profile = (male ¡¯25-34¡¯ ,
male ¡¯35-44¡¯,
male ¡¯45-54¡¯ ,
male ¡¯55-64¡¯,
male ¡¯65-74¡¯ ,
female ¡¯25-34¡¯,
female ¡¯35-44¡¯,
female ¡¯45-54¡¯,
female ¡¯55-64¡¯ ,
female ¡¯65-74¡¯);
model _f_ = _response_;
proc catmod data=wbeing;
response read b1-b10;
factors sex $ 2, age $ 5 /
_response_ = sex age
profile = (female ¡¯25-34¡¯,
female ¡¯35-44¡¯,
female ¡¯45-54¡¯,
female ¡¯55-64¡¯,
female ¡¯65-74¡¯,
male ¡¯25-34¡¯,
male ¡¯35-44¡¯,
male ¡¯45-54¡¯,
male ¡¯55-64¡¯,
male ¡¯65-74¡¯);
model _f_ = ( 1 0 0 ,
1 0 0 ,
1 0 0 ,
1 0 0 ,
1 0 1 ,
1 1 0 ,
1 1 0 ,
1 1 0 ,
1 1 0 ,
1 1 1 ) (1=¡¯Intercept¡¯, 2=¡¯Sex¡¯, 3=¡¯65-74¡¯)
/ pred;

*Modeling Rank Measures of Association Statistics;
proc freq data=cpain;
weight count;
tables dstatus*invest*treat*status/ measures;
run;

data MannWhitney;
input b1-b8 _type_ $ _name_ $8.;
datalines;
.6000 .6011 .6042 .8389 .5130 .5947 .5000 .4922 parms
.03091 .0000 .0000 .0000 .0000 .0000 .0000 .0000 cov b1
.0000 .00918 .0000 .0000 .0000 .0000 .0000 .0000 cov b2
.0000 .0000 .3280 .0000 .0000 .0000 .0000 .0000 cov b3
.0000 .0000 .0000 .0084 .0000 .0000 .0000 .0000 cov b4
.0000 .0000 .0000 .0000 .0129 .0000 .0000 .0000 cov b5
.0000 .0000 .0000 .0000 .0000 .0093 .0000 .0000 cov b6
.0000 .0000 .0000 .0000 .0000 .0000 .0101 .0000 cov b7
.0000 .0000 .0000 .0000 .0000 .0000 .0000 .0112 cov b8
;
proc catmod data=MannWhitney;
response read b1-b8;
factors diagnosis $ 4 , invest $ 2 /
_response_ = diagnosis invest
profile = (I A,
I B,
II A,
II B,
III A,
III B,
IV A,
IV B);
model _f_ = _response_ / cov;
run;

*****************************************************Modeling Repeated Measurements Data with WLS*****************;
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

proc catmod;
weight count;
response marginals;
model druga*drugb*drugc=_response_ / oneway cov;
repeated drug 3 / _response_=drug;
run;

data church;
input gender $ attend0 $ attend3 $ attend6 $ count;
datalines;
F Y Y Y 904
F Y Y N 88
F Y N Y 25
F Y N N 51
F N Y Y 33
F N Y N 22
F N N Y 30
F N N N 158
M Y Y Y 391
M Y Y N 36
M Y N Y 12
M Y N N 26
M N Y Y 15
M N Y N 21
M N N Y 18
M N N N 143
;
proc catmod order=data;
weight count;
response marginals;
model attend0*attend3*attend6=gender|_response_ / oneway;
repeated year;
run;

proc freq;
weight count;
by gender;
tables attend0 attend3 attend6;
run;

proc catmod order=data;
weight count;
response marginals;
model attend0*attend3*attend6=gender _response_ / noprofile;
repeated year;
run;

*Two Populations, Polytomous Response;
data vision;
input gender $ right left count;
datalines;
F 1 1 1520
F 1 2 266
F 1 3 124
F 1 4 66
F 2 1 234
F 2 2 1512
F 2 3 432
F 2 4 78
F 3 1 117
F 3 2 362
F 3 3 1772
F 3 4 205
F 4 1 36
F 4 2 82
F 4 3 179
F 4 4 492
M 1 1 821
M 1 2 112
M 1 3 85
M 1 4 35
M 2 1 116
M 2 2 494
M 2 3 145
M 2 4 27
M 3 1 72
M 3 2 151
M 3 3 583
M 3 4 87
M 4 1 43
M 4 2 34
M 4 3 106
M 4 4 331
;

proc catmod;
weight count;
response marginals;
model right*left=gender _response_(gender=¡¯F¡¯)
_response_(gender=¡¯M¡¯);
repeated eye 2;
run;

proc catmod;
weight count;
response means;
model right*left=gender _response_(gender=¡¯F¡¯)
_response_(gender=¡¯M¡¯) / noprofile;
repeated eye;
run;

*Multiple Repeated Measurement Factors;
data diagnos;
input std1 $ test1 $ std2 $ test2 $ count;
datalines;
Neg Neg Neg Neg 509
Neg Neg Neg Pos 4
Neg Neg Pos Neg 17
Neg Neg Pos Pos 3
Neg Pos Neg Neg 13
Neg Pos Neg Pos 8
Neg Pos Pos Neg 0
Neg Pos Pos Pos 8
Pos Neg Neg Neg 14
Pos Neg Neg Pos 1
Pos Neg Pos Neg 17
Pos Neg Pos Pos 9
Pos Pos Neg Neg 7
Pos Pos Neg Pos 4
Pos Pos Pos Neg 9
Pos Pos Pos Pos 170
;
proc catmod;
weight count;
response marginals;
model std1*test1*std2*test2=_response_ / oneway;
repeated time 2, trtment 2 / _response_=time|trtment;
run;

proc catmod;
weight count;
response marginals;
model std1*test1*std2*test2=_response_ / noprofile;
repeated time 2, trtment 2 / _response_=trtment;
run;

*Advanced Topic: FurtherWeighted Least Squares Applications;
data wheeze;
input wheeze9 $ wheeze10 $ wheeze11 $ wheeze12 $ count;
datalines;
Present Present Present Present 94
Present Present Present Absent 30
Present Present Absent Present 15
Present Present Absent Absent 28
Present Absent Present Present 14
Present Absent Present Absent 9
Present Absent Absent Present 12
Present Absent Absent Absent 63
Absent Present Present Present 19
Absent Present Present Absent 15
Absent Present Absent Present 10
Absent Present Absent Absent 44
Absent Absent Present Present 17
Absent Absent Present Absent 42
Absent Absent Absent Present 35
Absent Absent Absent Absent 572
;
proc catmod order=data;
weight count;
response marginals;
model wheeze9*wheeze10*wheeze11*wheeze12=_response_ / oneway;
repeated age;
run;

proc catmod order=data;
weight count;
response marginals;
model wheeze9*wheeze10*wheeze11*wheeze12=(1 9,
1 10,
1 11,
1 12)
(1=¡¯Intercept¡¯,
2=¡¯Linear Age¡¯)
/ noprofile;
run;

proc catmod order=data;
weight count;
response logits;
model wheeze9*wheeze10*wheeze11*wheeze12=(1 9,
1 10,
1 11,
1 12)
(1=¡¯Intercept¡¯,
2=¡¯Linear Age¡¯) / noprofile;
run;
data resp;
input center id treatment $ sex $ age baseline visit1-visit4 @@;
datalines;
1 1 P M 46 0 0 0 0 0 2 1 P F 39 0 0 0 0 0
1 2 P M 28 0 0 0 0 0 2 2 A M 25 0 0 1 1 1
1 3 A M 23 1 1 1 1 1 2 3 A M 58 1 1 1 1 1
1 4 P M 44 1 1 1 1 0 2 4 P F 51 1 1 0 1 1
1 5 P F 13 1 1 1 1 1 2 5 P F 32 1 0 0 1 1
1 6 A M 34 0 0 0 0 0 2 6 P M 45 1 1 0 0 0
1 7 P M 43 0 1 0 1 1 2 7 P F 44 1 1 1 1 1
1 8 A M 28 0 0 0 0 0 2 8 P F 48 0 0 0 0 0
1 9 A M 31 1 1 1 1 1 2 9 A M 26 0 1 1 1 1
1 10 P M 37 1 0 1 1 0 2 10 A M 14 0 1 1 1 1
1 11 A M 30 1 1 1 1 1 2 11 P F 48 0 0 0 0 0
1 12 A M 14 0 1 1 1 0 2 12 A M 13 1 1 1 1 1
1 13 P M 23 1 1 0 0 0 2 13 P M 20 0 1 1 1 1
1 14 P M 30 0 0 0 0 0 2 14 A M 37 1 1 0 0 1
1 15 P M 20 1 1 1 1 1 2 15 A M 25 1 1 1 1 1
1 16 A M 22 0 0 0 0 1 2 16 A M 20 0 0 0 0 0
1 17 P M 25 0 0 0 0 0 2 17 P F 58 0 1 0 0 0
1 18 A F 47 0 0 1 1 1 2 18 P M 38 1 1 0 0 0
1 19 P F 31 0 0 0 0 0 2 19 A M 55 1 1 1 1 1
1 20 A M 20 1 1 0 1 0 2 20 A M 24 1 1 1 1 1
1 21 A M 26 0 1 0 1 0 2 21 P F 36 1 1 0 0 1
1 22 A M 46 1 1 1 1 1 2 22 P M 36 0 1 1 1 1
1 23 A M 32 1 1 1 1 1 2 23 A F 60 1 1 1 1 1
1 24 A M 48 0 1 0 0 0 2 24 P M 15 1 0 0 1 1
1 25 P F 35 0 0 0 0 0 2 25 A M 25 1 1 1 1 0
1 26 A M 26 0 0 0 0 0 2 26 A M 35 1 1 1 1 1
1 27 P M 23 1 1 0 1 1 2 27 A M 19 1 1 0 1 1
1 28 P F 36 0 1 1 0 0 2 28 P F 31 1 1 1 1 1
1 29 P M 19 0 1 1 0 0 2 29 A M 21 1 1 1 1 1
1 30 A M 28 0 0 0 0 0 2 30 A F 37 0 1 1 1 1
1 31 P M 37 0 0 0 0 0 2 31 P M 52 0 1 1 1 1
1 32 A M 23 0 1 1 1 1 2 32 A M 55 0 0 1 1 0
1 33 A M 30 1 1 1 1 0 2 33 P M 19 1 0 0 1 1
1 34 P M 15 0 0 1 1 0 2 34 P M 20 1 0 1 1 1
1 35 A M 26 0 0 0 1 0 2 35 P M 42 1 0 0 0 0
1 36 P F 45 0 0 0 0 0 2 36 A M 41 1 1 1 1 1
1 37 A M 31 0 0 1 0 0 2 37 A M 52 0 0 0 0 0
1 38 A M 50 0 0 0 0 0 2 38 P F 47 0 1 1 0 1
1 39 P M 28 0 0 0 0 0 2 39 P M 11 1 1 1 1 1
1 40 P M 26 0 0 0 0 0 2 40 P M 14 0 0 0 1 0
1 41 P M 14 0 0 0 0 1 2 41 P M 15 1 1 1 1 1
1 42 A M 31 0 0 1 0 0 2 42 P M 66 1 1 1 1 1
1 43 P M 13 1 1 1 1 1 2 43 A M 34 0 1 1 0 1
1 44 P M 27 0 0 0 0 0 2 44 P M 43 0 0 0 0 0
1 45 P M 26 0 1 0 1 1 2 45 P M 33 1 1 1 0 1
1 46 P M 49 0 0 0 0 0 2 46 P M 48 1 1 0 0 0
1 47 P M 63 0 0 0 0 0 2 47 A M 20 0 1 1 1 1
1 48 A M 57 1 1 1 1 1 2 48 P F 39 1 0 1 0 0
1 49 P M 27 1 1 1 1 1 2 49 A M 28 0 1 0 0 0
1 50 A M 22 0 0 1 1 1 2 50 P F 38 0 0 0 0 0
1 51 A M 15 0 0 1 1 1 2 51 A M 43 1 1 1 1 0
1 52 P M 43 0 0 0 1 0 2 52 A F 39 0 1 1 1 1
1 53 A F 32 0 0 0 1 0 2 53 A M 68 0 1 1 1 1
1 54 A M 11 1 1 1 1 0 2 54 A F 63 1 1 1 1 1
1 55 P M 24 1 1 1 1 1 2 55 A M 31 1 1 1 1 1
1 56 A M 25 0 1 1 0 1
;

proc catmod data=resp;
population treatment center;
response logits;
model visit1*visit2*visit3*visit4 =
( 1 1 1 1 0 0 1 0 0 1 0 0 1,
1 1 1 0 1 0 0 1 0 0 1 0 1,
1 1 1 0 0 1 0 0 1 0 0 1 1,
1 1 1 0 0 0 0 0 0 0 0 0 1,
1 1 0 1 0 0 1 0 0 0 0 0 0,
1 1 0 0 1 0 0 1 0 0 0 0 0,
1 1 0 0 0 1 0 0 1 0 0 0 0,
1 1 0 0 0 0 0 0 0 0 0 0 0,
1 0 1 1 0 0 0 0 0 1 0 0 0,
1 0 1 0 1 0 0 0 0 0 1 0 0,
1 0 1 0 0 1 0 0 0 0 0 1 0,
1 0 1 0 0 0 0 0 0 0 0 0 0,
1 0 0 1 0 0 0 0 0 0 0 0 0,
1 0 0 0 1 0 0 0 0 0 0 0 0,
1 0 0 0 0 1 0 0 0 0 0 0 0,
1 0 0 0 0 0 0 0 0 0 0 0 0)
(1=¡¯Intercept¡¯, 2=¡¯treatment¡¯, 3=¡¯center¡¯,
4=¡¯visit1¡¯, 5=¡¯visit2¡¯, 6=¡¯visit3¡¯, 7=¡¯tr*visit1¡¯,
8=¡¯tr*visit2¡¯, 9=¡¯tr*visit3¡¯, 10=¡¯ct*visit1¡¯,
11=¡¯ct*visit2¡¯, 12=¡¯ct*visit3¡¯, 13=¡¯trt*ct¡¯);

proc catmod data=resp;
population treatment center;
response logits;
model visit1*visit2*visit3*visit4 =
( 1 1 1 1 0 0 ,
1 1 1 0 1 0 ,
1 1 1 0 0 1 ,
1 1 1 0 0 0 ,
1 1 0 1 0 0 ,
1 1 0 0 1 0 ,
1 1 0 0 0 1 ,
1 1 0 0 0 0 ,
1 0 1 1 0 0 ,
1 0 1 0 1 0 ,
1 0 1 0 0 1 ,
1 0 1 0 0 0 ,
1 0 0 1 0 0 ,
1 0 0 0 1 0 ,
1 0 0 0 0 1 ,
1 0 0 0 0 0 )
(1=¡¯Intercept¡¯, 2=¡¯treatment¡¯, 3=¡¯center¡¯,
4=¡¯visit1¡¯, 5=¡¯visit2¡¯, 6=¡¯visit3¡¯ );
contrast ¡¯treatment¡¯ all_parms 0 1 0 0 0 0 ;
contrast ¡¯center¡¯ all_parms 0 0 1 0 0 0 ;
contrast ¡¯visit¡¯ all_parms 0 0 0 1 0 0,
all_parms 0 0 0 0 1 0,
all_parms 0 0 0 0 0 1;
run;

*************************************************Generalized Estimating Equations**************************;
*Generalized Estimating Equations;
*Generalized Estimating Equations Methodology;
data children;
input id city$ @@;
do i=1 to 4;
input age smoke symptom @@;
output;
end;
datalines;
1 steelcity 8 0 1 9 0 1 10 0 1 11 0 0
2 steelcity 8 2 1 9 2 1 10 2 1 11 1 0
3 steelcity 8 2 1 9 2 0 10 1 0 11 0 0
4 greenhills 8 0 0 9 1 1 10 1 1 11 0 0
5 steelcity 8 0 0 9 1 0 10 1 0 11 1 0
6 greenhills 8 0 1 9 0 0 10 0 0 11 0 1
7 steelcity 8 1 1 9 1 1 10 0 1 11 0 0
8 greenhills 8 1 0 9 1 0 10 1 0 11 2 0
9 greenhills 8 2 1 9 2 0 10 1 1 11 1 0
10 steelcity 8 0 0 9 0 0 10 0 0 11 1 0
11 steelcity 8 1 1 9 0 0 10 0 0 11 0 1
12 greenhills 8 0 0 9 0 0 10 0 0 11 0 0
13 steelcity 8 2 1 9 2 1 10 1 0 11 0 1
14 greenhills 8 0 1 9 0 1 10 0 0 11 0 0
15 steelcity 8 2 0 9 0 0 10 0 0 11 2 1
16 greenhills 8 1 0 9 1 0 10 0 0 11 1 0
17 greenhills 8 0 0 9 0 1 10 0 1 11 1 1
18 steelcity 8 1 1 9 2 1 10 0 0 11 1 0
19 steelcity 8 2 1 9 1 0 10 0 1 11 0 0
20 greenhills 8 0 0 9 0 1 10 0 1 11 0 0
21 steelcity 8 1 0 9 1 0 10 1 0 11 2 1
22 greenhills 8 0 1 9 0 1 10 0 0 11 0 0
23 steelcity 8 1 1 9 1 0 10 0 1 11 0 0
24 greenhills 8 1 0 9 1 1 10 1 1 11 2 1
25 greenhills 8 0 1 9 0 0 10 0 0 11 0 0
;

proc genmod data=children descending;
class id city;
model symptom = city age smoke /
link=logit dist=bin type3;
repeated subject=id / type=exch covb corrw;
run;

ods select Estimates;
proc genmod data=children descending;
class id city;
model symptom = city age smoke /
link=logit dist=bin type3;
repeated subject=id / type=exch covb corrw;
estimate ¡¯smoking¡¯ smoke 1 / exp;
run;

*************************************************Crossover Example******************************;
data cross (drop=count);
input age $ sequence $ time1 $ time2 $ count;
do i=1 to count;
output;
end;
datalines;
older AB F F 12
older AB F U 12
older AB U F 6
older AB U U 20
older BP F F 8
older BP F U 5
older BP U F 6
older BP U U 31
older PA F F 5
older PA F U 3
older PA U F 22
older PA U U 20
younger BA F F 19
younger BA F U 3
younger BA U F 25
younger BA U U 3
younger AP F F 25
younger AP F U 6
younger AP U F 6
younger AP U U 13
younger PB F F 13
younger PB F U 5
younger PB U F 21
younger PB U U 11
;

data cross2;
set cross;
subject=_n_;
period=1;
drug = substr(sequence, 1, 1);
carry=¡¯N¡¯;
response = time1;
output;
period=0;
drug = substr(sequence, 2, 1);
carry = substr(sequence, 1, 1);
if carry=¡¯P¡¯ then carry=¡¯N¡¯;
response = time2;
output;
run;
proc print data=cross2(obs=15);
run;

proc genmod data=cross2;
class subject age drug carry;
model response = period age drug
period*age carry
drug*age / dist=bin type3;
repeated subject=subject/type=unstr;
run;

ods select Contrasts;
proc genmod data=cross2;
class subject age drug carry;
model response = period age drug
period*age carry
drug*age / dist=bin type3;
repeated subject=subject/type=unstr;
contrast ¡¯carry¡¯ carry 1 0 -1,
carry 0 1 -1;
contrast ¡¯inter¡¯ age*drug 1 0 -1 -1 0 1 ,
age*drug 0 1 -1 0 -1 1 ;
contrast ¡¯joint¡¯ carry 1 0 -1,
carry 0 1 -1,
age*drug 1 0 -1 -1 0 1 ,
age*drug 0 1 -1 0 -1 1 ;
run;

ods select GEEEmpPEst Type3 GEEWCorr;
proc genmod data=cross2;
class subject age drug;
model response = period age drug
period*age
/ dist=bin type3;
repeated subject=subject/type=unstr corrw;
run;

ods select Contrasts;
proc genmod data=cross2;
class subject age drug;
model response = period age drug
period*age
/ dist=bin type3;
repeated subject=subject/type=unstr;
contrast ¡¯A versus B¡¯ drug 1 -1 0;
run;

**Respiratory Data;
data resp;
input center id treatment $ sex $ age baseline
visit1-visit4 @@;
visit=1; outcome=visit1; output;
visit=2; outcome=visit2; output;
visit=3; outcome=visit3; output;
visit=4; outcome=visit4; output;
datalines;
1 53 A F 32 1 2 2 4 2 2 30 A F 37 1 3 4 4 4
1 18 A F 47 2 2 3 4 4 2 52 A F 39 2 3 4 4 4
1 54 A M 11 4 4 4 4 2 2 23 A F 60 4 4 3 3 4
1 12 A M 14 2 3 3 3 2 2 54 A F 63 4 4 4 4 4
1 51 A M 15 0 2 3 3 3 2 12 A M 13 4 4 4 4 4
1 20 A M 20 3 3 2 3 1 2 10 A M 14 1 4 4 4 4
1 16 A M 22 1 2 2 2 3 2 27 A M 19 3 3 2 3 3
1 50 A M 22 2 1 3 4 4 2 16 A M 20 2 4 4 4 3
1 3 A M 23 3 3 4 4 3 2 47 A M 20 2 1 1 0 0
1 32 A M 23 2 3 4 4 4 2 29 A M 21 3 3 4 4 4
1 56 A M 25 2 3 3 2 3 2 20 A M 24 4 4 4 4 4
1 35 A M 26 1 2 2 3 2 2 2 A M 25 3 4 3 3 1
1 26 A M 26 2 2 2 2 2 2 15 A M 25 3 4 4 3 3
1 21 A M 26 2 4 1 4 2 2 25 A M 25 2 2 4 4 4
1 8 A M 28 1 2 2 1 2 2 9 A M 26 2 3 4 4 4
1 30 A M 28 0 0 1 2 1 2 49 A M 28 2 3 2 2 1
1 33 A M 30 3 3 4 4 2 2 55 A M 31 4 4 4 4 4
1 11 A M 30 3 4 4 4 3 2 43 A M 34 2 4 4 2 4
1 42 A M 31 1 2 3 1 1 2 26 A M 35 4 4 4 4 4
1 9 A M 31 3 3 4 4 4 2 14 A M 37 4 3 2 2 4
1 37 A M 31 0 2 3 2 1 2 36 A M 41 3 4 4 3 4
1 23 A M 32 3 4 4 3 3 2 51 A M 43 3 3 4 4 2
1 6 A M 34 1 1 2 1 1 2 37 A M 52 1 2 1 2 2
1 22 A M 46 4 3 4 3 4 2 19 A M 55 4 4 4 4 4
1 24 A M 48 2 3 2 0 2 2 32 A M 55 2 2 3 3 1
1 38 A M 50 2 2 2 2 2 2 3 A M 58 4 4 4 4 4
1 48 A M 57 3 3 4 3 4 2 53 A M 68 2 3 3 3 4
1 5 P F 13 4 4 4 4 4 2 28 P F 31 3 4 4 4 4
1 19 P F 31 2 1 0 2 2 2 5 P F 32 3 2 2 3 4
1 25 P F 35 1 0 0 0 0 2 21 P F 36 3 3 2 1 3
1 28 P F 36 2 3 3 2 2 2 50 P F 38 1 2 0 0 0
1 36 P F 45 2 2 2 2 1 2 1 P F 39 1 2 1 1 2
1 43 P M 13 3 4 4 4 4 2 48 P F 39 3 2 3 0 0
1 41 P M 14 2 2 1 2 3 2 7 P F 44 3 4 4 4 4
1 34 P M 15 2 2 3 3 2 2 38 P F 47 2 3 3 2 3
1 29 P M 19 2 3 3 0 0 2 8 P F 48 2 2 1 0 0
1 15 P M 20 4 4 4 4 4 2 11 P F 48 2 2 2 2 2
1 13 P M 23 3 3 1 1 1 2 4 P F 51 3 4 2 4 4
1 27 P M 23 4 4 2 4 4 2 17 P F 58 1 4 2 2 0
1 55 P M 24 3 4 4 4 3 2 39 P M 11 3 4 4 4 4
1 17 P M 25 1 1 2 2 2 2 40 P M 14 2 1 2 3 2
1 45 P M 26 2 4 2 4 3 2 24 P M 15 3 2 2 3 3
1 40 P M 26 1 2 1 2 2 2 41 P M 15 4 3 3 3 4
1 44 P M 27 1 2 2 1 2 2 33 P M 19 4 2 2 3 3
1 49 P M 27 3 3 4 3 3 2 13 P M 20 1 4 4 4 4
1 39 P M 28 2 1 1 1 1 2 34 P M 20 3 2 4 4 4
1 2 P M 28 2 0 0 0 0 2 45 P M 33 3 3 3 2 3
1 14 P M 30 1 0 0 0 0 2 22 P M 36 2 4 3 3 4
1 10 P M 37 3 2 3 3 2 2 18 P M 38 4 3 0 0 0
1 31 P M 37 1 0 0 0 0 2 35 P M 42 3 2 2 2 2
1 7 P M 43 2 3 2 4 4 2 44 P M 43 2 1 0 0 0
1 52 P M 43 1 1 1 3 2 2 6 P M 45 3 4 2 1 2
1 4 P M 44 3 4 3 4 2 2 46 P M 48 4 4 0 0 0
1 1 P M 46 2 2 2 2 2 2 31 P M 52 2 3 4 3 4
1 46 P M 49 2 2 2 2 2 2 42 P M 66 3 3 3 4 4
1 47 P M 63 2 2 2 2 2
;
data resp2; set resp;
dichot=(outcome=3 or outcome=4);
di_base = (baseline=3 or baseline=4);
run;
proc genmod descending;
class id center treatment visit;
model dichot = center treatment visit /
link=logit dist=bin type3;
repeated subject=id*center / type=unstr;
run;
proc genmod descending;
class id center sex treatment visit;
model dichot = treatment sex age center di_base
visit visit*treatment treatment*center/
link=logit dist=bin type3;
repeated subject=id*center / type=exch;
run;

proc genmod descending;
class id center sex treatment visit;
model dichot = center sex treatment age di_base
/ link=logit dist=bin type3;
repeated subject=id*center / type=exch corrw;
run;

proc genmod descending;
class id center sex treatment visit;
model dichot = center sex treatment age di_base
/ link=logit dist=bin type3;
repeated subject=id*center / type=unstr corrw;
run;

%include ¡¯macros.sas¡¯;
ods output GEEModInfo=clustout
Type3=scoreout;
proc genmod descending data=resp2;
class id center sex treatment visit;
model dichot = treatment sex center age di_base
visit / link=logit dist=bin type3 wald;
repeated subject=id*center / type=exch;
run;
%geef;

*Diagnostic Data;
data diagnos;
input std1 $ test1 $ std2 $ test2 $ count;
do i=1 to count;
output;
end;
datalines;
Neg Neg Neg Neg 509
Neg Neg Neg Pos 4
Neg Neg Pos Neg 17
Neg Neg Pos Pos 3
Neg Pos Neg Neg 13
Neg Pos Neg Pos 8
Neg Pos Pos Neg 0
Neg Pos Pos Pos 8
Pos Neg Neg Neg 14
Pos Neg Neg Pos 1
Pos Neg Pos Neg 17
Pos Neg Pos Pos 9
Pos Pos Neg Neg 7
Pos Pos Neg Pos 4
Pos Pos Pos Neg 9
Pos Pos Pos Pos 170
;
data diagnos2;
set diagnos;
drop std1 test1 std2 test2;
subject=_n_;
time=1; procedure=¡¯standard¡¯;
response=std1; output;
time=1; procedure=¡¯test¡¯;
response=test1; output;
time=2; procedure=¡¯standard¡¯;
response=std2; output;
time=2; procedure=¡¯test¡¯;
response=test2; output;
run;

proc genmod descending;
class subject time procedure;
model response = time procedure time*procedure /
link=logit dist=bin type3;
repeated subject=subject /type=exch;
run;

proc genmod descending;
class subject time procedure;
model response = time procedure /
link=logit dist=bin type3;
repeated subject=subject / type=exch corrw;
run;


***********************************************Using GEE for Count Data******************************;
data fracture;
input ID age center $ treatment $ year1 year2 year3 @@;
total=year1+year2+year3;
lmonths=log(12);
datalines;
1 56 A p 0 0 0 2 71 A p 1 0 0 3 60 A p 0 0 1 4 71 A p 0 1 0
5 78 A p 0 0 0 6 67 A p 0 0 0 7 49 A p 0 0 0
9 75 A p 1 0 0 8 68 A p 0 0 0 11 82 A p 0 0 0
13 56 A p 0 0 0 12 71 A p 0 0 0 15 66 A p 1 0 0
17 78 A p 0 0 0 16 63 A p 0 2 0 19 61 A p 0 0 0
21 75 A p 1 0 0 20 68 A p 0 0 0 23 63 A p 1 1 1
25 54 A p 0 0 0 24 65 A p 0 0 0 27 71 A p 0 0 0
29 56 A p 0 0 0 28 64 A p 0 0 0 31 78 A p 0 0 2
33 76 A p 0 0 0 32 61 A p 0 0 0 35 76 A p 0 0 0
37 74 A p 0 0 0 36 56 A p 0 0 0 39 62 A p 0 0 0
41 56 A p 0 0 0 40 72 A p 0 0 1 43 76 A p 0 0 0
45 75 A p 0 0 0 44 77 A p 2 2 0 47 78 A p 0 0 0
49 71 A p 0 0 0 48 68 A p 0 0 0 51 74 A p 0 0 0
53 69 A p 0 0 0 52 78 A p 1 0 0 55 81 A p 2 0 1
57 68 A p 0 0 0 56 77 A p 0 0 0 59 77 A p 0 0 0
61 75 A p 0 0 0 60 83 A p 0 0 0 63 72 A p 0 0 0 64 88 A p 0 0 0
65 69 A p 0 0 0 66 55 A p 0 0 0 67 76 A p 0 0 0 68 55 A p 0 0 0
69 63 A t 0 0 2 70 52 A t 0 0 0 71 56 A t 0 0 0 72 52 A t 0 0 0
73 74 A t 0 0 0 74 61 A t 0 0 0 75 69 A t 0 0 0 76 61 A t 0 0 0
77 84 A t 0 0 0 78 76 A t 0 1 0 79 59 A t 0 0 1 80 76 A t 0 0 0
81 66 A t 0 0 1 82 78 A t 0 0 1 83 77 A t 0 0 0 84 75 A t 1 0 0
85 75 A t 0 0 0 86 62 A t 0 0 0 87 67 A t 0 0 0 88 62 A t 0 0 0
89 71 A t 0 0 0 90 63 A t 0 0 0 92 68 A t 0 0 0
93 69 A t 0 0 0 94 61 A t 0 0 0 96 61 A t 0 0 0
97 67 A t 0 0 0 98 77 A t 0 0 0 91 70 A t 0 0 1 102 81 A t 0 0 0
95 49 A t 0 0 0 106 55 A t 0 0 0
99 63 A t 2 1 0 100 52 A t 0 0 0 101 48 A t 0 0 0
103 71 A t 0 0 0 104 61 A t 0 0 0 105 74 A t 0 0 0
107 67 A t 0 0 0 108 56 A t 0 0 0 109 54 A t 0 0 0
111 56 A t 0 0 0 112 77 A t 1 0 0 113 65 A t 0 0 0
115 66 A t 0 0 0 116 71 A t 0 0 0 117 71 A t 0 0 0 128 71 A t 0 0 0
119 86 A t 1 0 0 120 81 A t 0 0 0 121 64 A t 0 0 0 132 76 A t 0 0 0
123 71 A t 0 0 0 124 76 A t 0 0 0 125 66 A t 0 0 0 136 76 A t 0 0 0
1 68 B p 0 0 0 2 63 B p 0 0 0 3 66 B p 0 0 0 4 63 B p 0 0 0
5 70 B p 0 1 0 6 62 B p 0 0 0 7 54 B p 1 0 0 8 66 B p 0 0 0
9 71 B p 0 0 0 10 76 B p 0 0 0 11 72 B p 0 0 1 12 65 B p 0 1 0
13 55 B p 0 1 0 14 59 B p 0 0 2 15 61 B p 1 0 0 16 56 B p 0 1 0
17 54 B p 0 0 0 18 68 B p 0 0 0 19 68 B p 0 0 0 20 81 B p 0 0 0
21 81 B p 1 0 0 22 61 B p 2 0 1 23 72 B p 1 0 0 24 67 B p 0 0 0
25 56 B p 0 0 0 26 66 B p 0 0 0 27 71 B p 0 1 0 28 75 B p 0 1 0
29 76 B p 0 0 0 30 73 B p 2 0 0 31 56 B p 0 0 0 32 89 B p 0 0 0
33 56 B p 0 0 0 34 78 B p 0 0 0 35 55 B p 0 0 0 36 73 B p 0 0 1
37 71 B p 0 0 0 38 56 B p 0 0 0 39 69 B p 0 0 0 40 77 B p 0 0 0
41 89 B p 0 0 0 42 63 B p 0 0 0 43 67 B p 0 0 0 44 73 B p 0 0 0
45 60 B p 0 0 0 46 67 B p 0 0 0 47 56 B p 0 0 0 48 78 B p 0 0 0
49 73 B t 1 0 0 50 76 B t 0 0 0 51 61 B t 0 0 0 52 81 B t 0 0 0
53 55 B t 0 0 0 54 82 B t 0 0 0 55 78 B t 0 0 0 56 60 B t 0 0 0
57 56 B t 0 0 0 58 83 B t 0 0 0 59 55 B t 0 0 0 60 60 B t 0 0 0
61 80 B t 0 0 0 62 78 B t 0 0 0 63 67 B t 0 0 0 64 67 B t 0 0 0
65 56 B t 0 0 0 66 72 B t 0 0 0 67 71 B t 0 0 0 68 83 B t 0 0 0
69 66 B t 0 0 0 70 71 B t 0 0 1 71 78 B t 1 0 2 72 61 B t 0 0 0
73 56 B t 0 0 0 74 61 B t 0 0 0 75 55 B t 0 0 0 76 69 B t 1 1 0
77 71 B t 0 0 0 78 76 B t 0 0 0 79 56 B t 0 0 0 80 75 B t 0 0 0
81 89 B t 0 0 0 82 77 B t 0 0 0 83 77 B t 1 0 0 84 73 B t 0 0 0
85 60 B t 0 0 0 86 61 B t 0 0 0 87 79 B t 0 0 0 88 71 B t 0 0 0
89 61 B t 0 0 0 90 79 B t 0 0 0 91 87 B t 1 0 0 92 55 B t 0 0 0
93 55 B t 0 0 0 94 79 B t 0 0 0 95 66 B t 0 0 0 96 49 B t 0 0 0
97 56 B t 0 0 0 98 64 B t 0 0 0 99 88 B t 0 0 0 100 62 B t 1 0 0
101 80 B t 0 0 1 102 65 B t 0 0 0 103 57 B t 0 0 1 104 85 B t 0 0 0
;

data fracture2;
set fracture;
drop year1-year3;
year=1; fractures=year1; output;
year=2; fractures=year2; output;
do; if center = A then do;
if (ID=85 or ID=66 or ID=124 or ID=51) then lmonths=log(6); end;
if center = B then do;
if (ID=29 or ID=45 or ID=55) then lmonths=log(6); end;
end;
year=3; fractures=year3; output;
run;

proc genmod;
class id treatment center year;
model fractures = center treatment age year treatment*center
treatment*year/
dist=poisson type3 offset=lmonths;
repeated subject=id*center / type=exch corrw;
run;

proc genmod;
class id treatment center year;
model fractures = center treatment age year /
dist=poisson type3 offset=lmonths;
repeated subject=id(center) / type=exch corrw;
run;

*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<Fitting the Proportional Odds Model;
proc genmod data=resp2 descending;
class id center sex treatment visit;
model outcome = treatment sex center age baseline
visit visit*treatment /
link=clogit dist=mult type3;
repeated subject=id*center / type=ind;
run;

proc genmod data=resp2 descending;
class id center sex treatment visit;
model outcome = treatment center baseline
visit visit*treatment /
link=clogit dist=mult type3;
repeated subject=id*center / type=ind;
run;

*****************<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<GEE Analyses for Data with Missing Values;
data skincross;
input subject gender $ sequence $ Time1 $ Time2 $ @@;
datalines;
1 m AB Y Y 101 m PA Y Y 201 f AP Y Y
2 m AB Y . 102 m PA Y Y 202 f AP Y Y
3 m AB Y Y 103 m PA Y Y 203 f AP Y Y
4 m AB Y . 104 m PA Y Y 204 f AP Y Y
5 m AB Y Y 105 m PA Y Y 205 f AP Y Y
6 m AB Y . 106 m PA Y N 206 f AP Y Y
7 m AB Y . 107 m PA Y . 207 f AP Y Y
8 m AB Y Y 108 m PA Y N 208 f AP Y Y
9 m AB Y Y 109 m PA N . 209 f AP Y Y
10 m AB Y Y 110 m PA N Y 210 f AP Y Y
11 m AB Y . 111 m PA N Y 211 f AP Y Y
12 m AB Y Y 112 m PA N Y 212 f AP Y Y
13 m AB Y N 113 m PA N . 213 f AP Y Y
14 m AB Y N 114 m PA N . 214 f AP Y .
15 m AB Y N 115 m PA N Y 215 f AP Y .
16 m AB Y N 116 m PA N Y 216 f AP Y .
17 m AB Y N 117 m PA N Y 217 f AP Y Y
18 m AB Y N 118 m PA N Y 218 f AP Y Y
19 m AB Y . 119 m PA N Y 219 f AP Y Y
20 m AB Y N 120 m PA N Y 220 f AP Y Y
21 m AB Y N 121 m PA N Y 221 f AP Y .
22 m AB Y N 122 m PA N Y 222 f AP Y Y
23 m AB Y . 123 m PA N Y 223 f AP Y Y
24 m AB Y N 124 m PA N Y 224 f AP Y Y
25 m AB N Y 125 m PA N Y 225 f AP Y Y
26 m AB N . 126 m PA N Y 226 f AP Y N
27 m AB N . 127 m PA N Y 227 f AP Y N
28 m AB N . 128 m PA N Y 228 f AP Y N
29 m AB N Y 129 m PA N Y 229 f AP Y .
30 m AB N Y 130 m PA N Y 230 f AP Y N
31 m AB N . 131 m PA N . 231 f AP Y N
32 m AB N N 132 m PA N N 232 f AP N Y
33 m AB N N 133 m PA N N 233 f AP N Y
34 m AB N N 134 m PA N N 234 f AP N Y
35 m AB N N 135 m PA N N 235 f AP N Y
36 m AB N N 136 m PA N . 236 f AP N Y
37 m AB N N 137 m PA N N 237 f AP N Y
38 m AB N N 138 m PA N N 238 f AP N N
39 m AB N N 139 m PA N . 239 f AP N N
40 m AB N N 140 m PA N N 240 f AP N N
41 m AB N . 141 m PA N N 241 f AP N N
42 m AB N N 142 m PA N N 242 f AP N N
43 m AB N N 143 m PA N N 243 f AP N N
44 m AB N N 144 m PA N N 244 f AP N N
45 m AB N . 145 m PA N N 245 f AP N N
46 m AB N N 146 m PA N N 246 f AP N N
47 m AB N N 147 m PA N N 247 f AP N N
48 m AB N N 148 m PA N N 248 f AP N N
49 m AB N N 149 m PA N N 249 f AP N N
50 m AB N N 150 m PA N . 250 f AP N N
51 m BP Y Y 151 f BA Y Y 251 f PB Y .
52 m BP Y Y 152 f BA Y Y 252 f PB Y Y
53 m BP Y Y 153 f BA Y Y 253 f PB Y Y
54 m BP Y Y 154 f BA Y . 254 f PB Y Y
55 m BP Y Y 155 f BA Y Y 255 f PB Y Y
56 m BP Y Y 156 f BA Y Y 256 f PB Y .
57 m BP Y Y 157 f BA Y Y 257 f PB Y Y
58 m BP Y Y 158 f BA Y Y 258 f PB Y .
59 m BP Y N 159 f BA Y Y 259 f PB Y Y
60 m BP Y . 160 f BA Y Y 260 f PB Y Y
61 m BP Y N 161 f BA Y . 261 f PB Y Y
62 m BP Y . 162 f BA Y . 262 f PB Y .
63 m BP Y N 163 f BA Y Y 263 f PB Y .
64 m BP N Y 164 f BA Y Y 264 f PB Y N
65 m BP N Y 165 f BA Y Y 265 f PB Y N
66 m BP N Y 166 f BA Y Y 266 f PB Y N
67 m BP N Y 167 f BA Y Y 267 f PB Y N
68 m BP N Y 168 f BA Y Y 268 f PB Y N
69 m BP N Y 169 f BA Y Y 269 f PB N Y
70 m BP N . 170 f BA Y . 270 f PB N Y
71 m BP N N 171 f BA Y N 271 f PB N Y
72 m BP N N 172 f BA Y N 272 f PB N .
73 m BP N N 173 f BA N Y 273 f PB N .
74 m BP N N 174 f BA N Y 274 f PB N Y
75 m BP N N 175 f BA N . 275 f PB N Y
76 m BP N N 176 f BA N Y 276 f PB N Y
77 m BP N N 177 f BA N Y 277 f PB N .
78 m BP N N 178 f BA N Y 278 f PB N Y
79 m BP N N 179 f BA N . 279 f PB N Y
80 m BP N N 180 f BA N . 280 f PB N Y
81 m BP N . 181 f BA N Y 281 f PB N Y
82 m BP N N 182 f BA N Y 282 f PB N Y
83 m BP N . 183 f BA N Y 283 f PB N Y
84 m BP N N 184 f BA N Y 284 f PB N Y
85 m BP N . 185 f BA N Y 285 f PB N Y
86 m BP N N 186 f BA N Y 286 f PB N Y
87 m BP N N 187 f BA N Y 287 f PB N Y
88 m BP N N 188 f BA N Y 288 f PB N Y
89 m BP N N 189 f BA N Y 289 f PB N Y
90 m BP N N 190 f BA N Y 290 f PB N N
91 m BP N N 191 f BA N Y 291 f PB N N
92 m BP N . 192 f BA N Y 292 f PB N .
93 m BP N N 193 f BA N Y 293 f PB N N
94 m BP N N 194 f BA N Y 294 f PB N N
95 m BP N N 195 f BA N Y 295 f PB N N
96 m BP N N 196 f BA N Y 296 f PB N N
97 m BP N N 197 f BA N Y 297 f PB N N
98 m BP N N 198 f BA N N 298 f PB N N
99 m BP N N 199 f BA N N 299 f PB N N
100 m BP N . 200 f BA N N 300 f PB N N
;
data skincross2;
set skincross;
period=1;
treatment=substr(sequence, 1, 1);
carryA=0;
carryB=0;
response=Time1;
output;
period=2;
Treatment=substr(sequence, 2, 1);
carrya=(substr(sequence, 1, 1)=¡¯A¡¯);
carryb=(substr(sequence, 1, 1)=¡¯B¡¯);
response=Time2;
output;
run;

proc genmod data=skincross2 descending;
class subject treatment period gender;
model response = treatment period carrya carryb
gender gender*period /type3
dist=bin link=logit;
repeated subject=subject / type=exch;
run;

proc genmod data=skincross2 descending;
class subject treatment period gender;
model response = treatment period gender*period
gender /type3
dist=bin link=logit;
repeated subject=subject / type=exch;
estimate ¡¯OR:A-B¡¯ treatment 1 -1 0 /exp;
estimate ¡¯OR:A-P¡¯ treatment 1 0 -1 / exp;
estimate ¡¯OR:B-P¡¯ treatment 0 1 -1 / exp;
run;

data colds;
input area gender $ year1 $ year2 $ year3 $ count @@;
if year1 =¡¯ ¡¯ and year2 =¡¯ ¡¯ and year3=¡¯ ¡¯ then pattern =¡¯mmm¡¯;
else if year1=¡¯ ¡¯ and year2=¡¯ ¡¯ then pattern=¡¯mmh¡¯;
else if year1=¡¯ ¡¯ and year3=¡¯ ¡¯ then pattern= ¡¯mhm¡¯;
else if year2=¡¯ ¡¯ and year3 =¡¯ ¡¯ then pattern =¡¯hmm¡¯;
else if year1=¡¯ ¡¯ then pattern= ¡¯mhh¡¯;
else if year2=¡¯ ¡¯ then pattern=¡¯hmh¡¯;
else if year3=¡¯ ¡¯ then pattern=¡¯hhm¡¯;
else pattern= ¡¯hhh¡¯;
do i=1 to count; output; end;
datalines;
1 m y y y 80 1 m y y n 46 1 m y n y 38 1 m y n n 61
1 m n y y 57 1 m n y n 60 1 m n n y 59 1 m n n n 121
1 m y y . 20 1 m y n . 14 1 m n y . 14 1 m n n . 39
1 m y . y 16 1 m y . n 5 1 m n . y 15 1 m n . n 13
1 m . y y 47 1 m . y n 32 1 m . n y 32 1 m . n n 50
1 m y . . 141 1 m n . . 191 1 m . y . 87 1 m . n . 83
1 m . . y 156 1 m . . n 173
1 f y y y 109 1 f y y n 48 1 f y n y 39 1 f y n n 47
1 f n y y 45 1 f n y n 43 1 f n n y 47 1 f n n n 79
1 f y y . 34 1 f y n . 10 1 f n y . 19 1 f n n . 28
1 f y . y 13 1 f y . n 8 1 f n . y 14 1 f n . n 9
1 f . y y 60 1 f . y n 15 1 f . n y 30 1 f . n n 39
1 f y . . 170 1 f n . . 155 1 f . y . 91 1 f . n . 84
1 f . . y 173 1 f . . n 152
2 m y y y 59 2 m y y n 31 2 m y n y 22 2 m y n n 30
2 m n y y 35 2 m n y n 15 2 m n n y 41 2 m n n n 55
2 m y y . 44 2 m y n . 23 2 m n y . 28 2 m n n . 41
2 m y . y 7 2 m y . n 4 2 m n . y 10 2 m n . n 16
2 m . y y 26 2 m . y n 26 2 m . n y 23 2 m . n n 22
2 m y . . 129 2 m n . . 140 2 m . y . 65 2 m . n . 88
2 m . . y 129 2 m . . n 167
2 f y y y 94 2 f y y n 31 2 f y n y 11 2 f y n n 32
2 f n y y 28 2 f n y n 21 2 f n n y 30 2 f n n n 45
2 f y y . 34 2 f y n . 17 2 f n y . 10 2 f n n . 28
2 f y . y 9 2 f y . n 4 2 f n . y 6 2 f n . n 6
2 f . y y 23 2 f . y n 11 2 f . n y 11 2 f . n n 7
2 f y . . 133 2 f n . . 91 2 f . y . 85 2 f . n . 51
2 f . . y 116 2 f . . n 113
;

data colds2; set colds;
data colds2; set colds;
drop year1 year2 year3;
subject=_n_;
resp= year1; year=1; output;
resp=year2; year=2; output;
resp=year3; year=3; output;
run;

proc genmod;
class subject area gender year pattern;
model resp = pattern area gender pattern*area pattern*gender
year area*gender area*year gender*year/
dist=bin link=logit type3;
repeated subject=subject / type=exch;
run;

proc genmod;
class subject area gender year ;
model resp = area gender year/
dist=bin link=logit type3;
repeated subject=subject / type=exch;
run;

proc genmod;
class subject area gender year ;
model resp = area gender year/
dist=bin link=logit type3;
repeated subject=subject / type=exch;
run;

*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<Alternating Logistic Regression;
proc genmod data=resp2 descending;
class id treatment sex center visit;
model dichot = center sex treatment age di_base visit
/ dist=bin type3 link=logit;
repeated subject=id*center / logor=exch;
run;

proc genmod data=resp2 descending;
class id treatment sex center visit;
model dichot = center sex treatment age di_base visit
/ dist=bin type3 link=logit;
repeated subject=id*center / logor=logorvar(center) corrw;
run;

data dent;
input patient center trt $ baseline ldose resp @@;
datalines;
2 1 ACL 0 5.29832 0 131 1 TL 0 3.91202 2
1 1 ACH 1 5.99146 1 3 1 TH 0 4.60517 1
130 1 P 0 0.00000 0 132 1 P 0 0.00000 0
4 1 P 0 0.00000 0 133 1 P 0 0.00000 0
5 1 P 0 0.00000 0 134 2 ACH 0 5.99146 4
6 1 TL 1 3.91202 2 135 2 ACL 0 5.29832 4
7 1 ACH 0 5.99146 1 136 2 TH 0 4.60517 3
8 1 ACL 0 5.29832 0 137 2 ACL 0 5.29832 4
9 1 TL 1 3.91202 0 138 2 TL 0 3.91202 3
10 1 TL 1 3.91202 4 139 2 P 0 0.00000 4
11 1 ACL 0 5.29832 2 140 2 TL 0 3.91202 3
12 1 ACH 0 5.99146 0 141 2 TL 0 3.91202 3
13 1 P 0 0.00000 0 142 2 ACL 1 5.29832 3
14 1 TL 0 3.91202 0 143 2 ACH 0 5.99146 1
15 1 P 0 0.00000 0 144 2 ACH 0 5.99146 3
16 1 TH 1 4.60517 4 145 2 P 0 0.00000 1
17 1 TH 0 4.60517 2 146 2 P 0 0.00000 0
18 1 ACH 0 5.99146 1 147 2 ACH 0 5.99146 4
19 1 ACL 0 5.29832 0 148 2 TL 0 3.91202 2
20 1 TH 0 4.60517 3 149 2 TH 0 4.60517 3
21 1 P 1 0.00000 1 150 2 P 0 0.00000 0
22 1 TH 1 4.60517 0 151 2 TH 0 4.60517 2
23 1 TL 0 3.91202 2 152 2 ACL 1 5.29832 3
24 1 ACL 1 5.29832 0 153 2 TH 0 4.60517 2
25 1 P 0 0.00000 0 154 2 ACH 0 5.99146 3
26 1 ACH 0 5.99146 0 155 2 ACL 0 5.29832 1
27 1 ACL 0 5.29832 0 156 2 ACL 0 5.29832 0
28 1 P 0 0.00000 0 157 2 ACL 0 5.29832 3
29 1 ACH 0 5.99146 2 158 2 TH 0 4.60517 3
30 1 TL 0 3.91202 0 159 2 ACL 0 5.29832 1
31 1 P 0 0.00000 0 160 2 TL 0 3.91202 3
32 1 ACH 0 5.99146 1 161 2 P 0 0.00000 2
33 1 TL 0 3.91202 0 162 2 TH 0 4.60517 3
34 1 TH 1 4.60517 4 163 2 TH 0 4.60517 4
35 1 TL 0 3.91202 2 164 2 ACH 0 5.99146 3
36 1 ACH 0 5.99146 0 165 2 TH 0 4.60517 2
37 1 ACL 1 5.29832 1 166 2 P 0 0.00000 3
38 1 ACL 0 5.29832 3 167 2 ACH 0 5.99146 1
39 1 TH 0 4.60517 2 168 2 P 0 0.00000 2
40 1 TH 0 4.60517 0 169 2 TL 1 3.91202 2
41 1 ACL 0 5.29832 2 170 2 P 0 0.00000 0
42 1 TL 0 3.91202 3 171 2 TL 0 3.91202 0
43 1 ACL 0 5.29832 2 172 2 TL 0 3.91202 3
44 1 ACL 0 5.29832 0 173 2 ACH 1 5.99146 2
45 1 TH 0 4.60517 2 174 2 ACL 0 5.29832 3
46 1 ACH 0 5.99146 0 175 2 P 0 0.00000 4
47 1 P 0 0.00000 0 176 2 TL 1 3.91202 0
48 1 ACL 0 5.29832 0 177 2 ACH 0 5.99146 1
49 1 TL 0 3.91202 0 178 2 ACH 1 5.99146 2
50 1 TL 0 3.91202 2 179 2 ACL 0 5.29832 2
51 1 TL 0 3.91202 0 180 2 ACL 0 5.29832 2
52 1 ACH 0 5.99146 4 181 2 TH 0 4.60517 2
53 1 TH 0 4.60517 4 182 2 TL 0 3.91202 3
54 1 TH 0 4.60517 0 183 2 TH 0 4.60517 3
55 1 P 0 0.00000 0 184 2 ACH 0 5.99146 1
56 1 ACH 0 5.99146 3 185 2 P 0 0.00000 1
57 1 ACH 0 5.99146 2 186 2 ACL 0 5.29832 1
58 1 P 0 0.00000 0 187 2 TH 0 4.60517 2
59 1 TH 0 4.60517 0 188 2 ACH 1 5.99146 3
60 1 P 0 0.00000 0 189 2 TH 0 4.60517 2
61 1 TL 0 3.91202 1 190 2 TL 0 3.91202 3
62 1 P 0 0.00000 0 191 2 P 0 0.00000 1
63 1 TH 1 4.60517 1 192 2 TL 0 3.91202 3
64 1 TL 0 3.91202 0 193 2 P 0 0.00000 0
65 1 ACH 0 5.99146 2 194 2 TH 0 4.60517 2
66 1 ACL 0 5.29832 2 195 2 ACH 0 5.99146 4
67 1 P 0 0.00000 2 196 2 ACH 0 5.99146 2
68 1 TH 0 4.60517 1 197 2 ACL 0 5.29832 3
69 1 ACH 0 5.99146 0 198 2 P 0 0.00000 0
70 1 P 0 0.00000 0 199 2 P 0 0.00000 3
71 1 TL 0 3.91202 0 200 2 ACL 0 5.29832 0
72 1 ACH 0 5.99146 2 201 2 ACL 1 5.29832 4
73 1 P 0 0.00000 0 202 2 TH 0 4.60517 3
74 1 TL 0 3.91202 2 203 2 P 0 0.00000 1
75 1 TH 0 4.60517 2 204 2 TH 0 4.60517 1
76 1 ACL 1 5.29832 0 205 2 TH 0 4.60517 3
77 1 TH 1 4.60517 0 206 2 TL 0 3.91202 3
78 1 ACL 0 5.29832 0 207 2 TL 0 3.91202 3
79 1 ACL 1 5.29832 3 208 2 TL 0 3.91202 3
80 1 ACH 0 5.99146 2 209 2 ACL 0 5.29832 2
81 1 ACL 0 5.29832 0 210 2 ACH 0 5.99146 3
82 1 P 0 0.00000 0 211 2 TL 1 3.91202 1
83 1 TH 0 4.60517 0 212 2 ACH 0 5.99146 3
84 1 ACH 0 5.99146 1 213 2 P 0 0.00000 2
85 1 TL 0 3.91202 0 214 2 P 0 0.00000 0
86 1 TH 0 4.60517 3 215 2 TL 0 3.91202 0
87 1 ACH 0 5.99146 0 216 2 TH 0 4.60517 4
88 1 P 0 0.00000 0 217 2 ACH 0 5.99146 2
89 1 ACH 0 5.99146 1 218 2 P 0 0.00000 0
90 1 TL 0 3.91202 0 219 2 TH 0 4.60517 2
91 1 ACL 0 5.29832 1 220 2 TL 0 3.91202 1
92 1 TH 0 4.60517 0 221 2 ACH 0 5.99146 2
93 1 ACL 0 5.29832 1 222 2 TL 0 3.91202 4
94 1 TL 1 3.91202 1 223 2 TH 0 4.60517 2
95 1 TL 1 3.91202 3 224 2 TH 1 4.60517 1
96 1 P 0 0.00000 0 225 2 ACH 0 5.99146 1
97 1 TH 0 4.60517 0 226 2 ACL 0 5.29832 4
98 1 ACL 0 5.29832 0 227 2 P 1 0.00000 3
99 1 P 1 0.00000 0 228 2 ACL 0 5.29832 2
100 1 ACH 0 5.99146 2 229 2 TL 0 3.91202 0
101 1 TH 0 4.60517 0 230 2 ACL 0 5.29832 1
102 1 TL 0 3.91202 0 231 2 ACH 0 5.99146 3
103 1 ACL 0 5.29832 1 232 2 ACL 0 5.29832 3
104 1 TL 0 3.91202 0 233 2 P 0 0.00000 1
105 1 P 0 0.00000 1 234 2 ACL 0 5.29832 4
106 1 ACL 0 5.29832 0 235 2 ACH 0 5.99146 1
107 1 TH 1 4.60517 2 236 2 TH 0 4.60517 1
108 1 P 0 0.00000 0 237 2 ACL 0 5.29832 0
109 1 ACH 0 5.99146 1 238 2 ACL 1 5.29832 4
110 1 TH 1 4.60517 1 239 2 ACL 0 5.29832 3
111 1 TL 0 3.91202 0 240 2 P 0 0.00000 0
112 1 ACH 0 5.99146 0 241 2 P 1 0.00000 3
113 1 TL 0 3.91202 0 242 2 TL 0 3.91202 2
114 1 ACH 0 5.99146 1 243 2 P 0 0.00000 0
115 1 P 0 0.00000 0 244 2 TH 0 4.60517 3
116 1 ACL 0 5.29832 0 245 2 TL 1 3.91202 4
117 1 P 0 0.00000 0 246 2 ACH 1 5.99146 1
118 1 ACH 0 5.99146 3 247 2 P 0 0.00000 1
119 1 TH 0 4.60517 3 248 2 TH 0 4.60517 4
120 1 ACL 0 5.29832 2 249 2 TL 0 3.91202 0
121 1 TH 0 4.60517 2 250 2 TL 0 3.91202 3
122 1 TH 0 4.60517 1 251 2 ACH 0 5.99146 3
123 1 TL 0 3.91202 0 252 2 TH 0 4.60517 3
124 1 ACH 0 5.99146 0 253 2 ACH 0 5.99146 1
125 1 ACL 0 5.29832 0 254 2 TH 0 4.60517 3
126 1 TH 1 4.60517 0 255 2 ACL 0 5.29832 0
127 1 ACL 0 5.29832 0 256 2 TL 0 3.91202 3
128 1 ACH 0 5.99146 1 257 2 P 0 0.00000 1
129 1 ACL 0 5.29832 3 258 2 ACH 0 5.99146 3
;
proc logistic data=dent descending;
class patient center baseline trt;
model resp = center baseline trt;
run;

proc freq data=dent;
tables center*resp baseline*resp trt*resp /
nocol norow nopct;
run;

data dent2; set dent;
do; if resp=4 then presp =1;
else presp=0; logtype=4; output; end;
do; if resp=4 or resp=3 then presp=1;
else presp=0; logtype=3 ; output; end;
do; if resp=4 or resp=3 or resp=2 then presp=1;
else presp=0; logtype=2; output; end;
do; if resp=4 or resp=3 or resp=2 or resp=1 then presp=1;
else presp=0; logtype=1; output; end;
run;

proc genmod descending order=data;
class logtype patient center baseline trt;
model presp = center baseline trt logtype
logtype*center logtype*baseline logtype*trt /
link=logit dist=bin type3;
repeated subject=patient / type=unstr;
run;

proc genmod descending order=data;
class logtype patient center baseline trt;
model presp = center trt baseline logtype
logtype*center logtype*trt /
link=logit dist=bin type3;
repeated subject=patient / type=unstr;
run;

*Using GEE to Account for Overdispersion: Univariate Outcome;
data lri;
input id count risk passive crowding ses agegroup race @@;
logrisk =log(risk/52);
datalines;
1 0 42 1 0 2 2 0 96 1 41 1 0 1 2 0 191 0 44 1 0 0 2 0
2 0 43 1 0 0 2 0 97 1 26 1 1 2 2 0 192 0 45 0 0 0 2 1
3 0 41 1 0 1 2 0 98 0 36 0 0 0 2 0 193 0 42 0 0 0 2 0
4 1 36 0 1 0 2 0 99 0 34 0 0 0 2 0 194 1 31 0 0 0 2 1
5 1 31 0 0 0 2 0 100 1 3 1 1 2 3 1 195 0 35 0 0 0 2 0
6 0 43 1 0 0 2 0 101 0 45 1 0 0 2 0 196 1 35 1 0 0 2 0
7 0 45 0 0 0 2 0 102 0 38 0 0 1 2 0 197 1 27 1 0 1 2 0
8 0 42 0 0 0 2 1 103 0 41 1 1 1 2 1 198 1 33 0 0 0 2 0
9 0 45 0 0 0 2 1 104 1 37 0 1 0 2 0 199 0 39 1 0 1 2 0
10 0 35 1 1 0 2 0 105 0 40 0 0 0 2 0 200 3 40 0 1 2 2 0
11 0 43 0 0 0 2 0 106 1 35 1 0 0 2 0 201 4 26 1 0 1 2 0
12 2 38 0 0 0 2 0 107 0 28 0 1 2 2 0 202 0 14 1 1 1 1 1
13 0 41 0 0 0 2 0 108 3 33 0 1 2 2 0 203 0 39 0 1 1 2 0
14 0 12 1 1 0 1 0 109 0 38 0 0 0 2 0 204 0 4 1 1 1 3 0
15 0 6 0 0 0 3 0 110 0 42 1 1 2 2 1 205 1 27 1 1 1 2 1
16 0 43 0 0 0 2 0 111 0 40 1 1 2 2 0 206 0 36 1 0 0 2 1
17 2 39 1 0 1 2 0 112 0 38 0 0 0 2 0 207 0 30 1 0 2 2 1
18 0 43 0 1 0 2 0 113 2 37 0 1 1 2 0 208 0 34 0 1 0 2 0
19 2 37 0 0 0 2 1 114 1 42 0 1 0 2 0 209 1 40 1 1 1 2 0
20 0 31 1 1 1 2 0 115 5 37 1 1 1 2 1 210 0 6 1 0 1 1 1
21 0 45 0 1 0 2 0 116 0 38 0 0 0 2 0 211 1 40 1 1 1 2 0
22 1 29 1 1 1 2 1 117 0 4 0 0 0 3 0 212 2 43 0 1 0 2 0
23 1 35 1 1 1 2 0 118 2 37 1 1 1 2 0 213 0 36 1 1 1 2 0
24 3 20 1 1 2 2 0 119 0 39 1 0 1 2 0 214 0 35 1 1 1 2 1
25 1 23 1 1 1 2 0 120 0 42 1 1 0 2 0 215 1 35 1 1 2 2 0
26 1 37 1 0 0 2 0 121 0 40 1 0 0 2 0 216 0 43 1 0 1 2 0
27 0 49 0 0 0 2 0 122 0 36 1 0 0 2 0 217 0 33 1 1 2 2 0
28 0 35 0 0 0 2 0 123 1 42 0 1 1 2 0 218 0 36 0 1 1 2 1
29 3 44 1 1 1 2 0 124 1 39 0 0 0 2 0 219 1 41 0 0 0 2 0
30 0 37 1 0 0 2 0 125 2 29 0 0 0 2 0 220 0 41 1 1 0 2 1
31 2 39 0 1 1 2 0 126 3 37 1 1 2 2 1 221 1 42 0 0 0 2 1
32 0 41 0 0 0 2 0 127 0 40 1 0 0 2 0 222 0 33 0 1 2 2 1
33 1 46 1 1 2 2 0 128 0 40 0 0 0 2 0 223 0 40 1 1 2 2 0
34 0 5 1 1 2 3 1 129 0 39 0 0 0 2 0 224 0 40 1 1 1 2 1
35 1 29 0 0 0 2 0 130 0 40 1 0 1 2 0 225 0 40 0 0 2 2 0
36 0 31 0 1 0 2 0 131 1 32 0 0 0 2 0 226 0 28 1 0 1 2 0
37 0 22 1 1 2 2 0 132 0 46 1 0 1 2 0 227 0 47 0 0 0 2 1
38 1 22 1 1 2 2 1 133 4 39 1 1 0 2 0 228 0 18 1 1 2 2 1
39 0 47 0 0 0 2 0 134 0 37 0 0 0 2 0 229 0 45 1 0 0 2 0
40 1 46 1 1 1 2 1 135 0 51 0 0 1 2 0 230 0 35 0 0 0 2 0
41 0 37 0 0 0 2 0 136 1 39 1 1 0 2 0 231 1 17 1 0 1 1 1
42 1 39 0 0 0 2 0 137 1 34 1 1 0 2 0 232 0 40 0 0 0 2 0
43 0 33 0 1 1 2 1 138 1 14 0 1 0 1 0 233 0 29 1 1 2 2 0
44 0 34 1 0 1 2 0 139 2 15 1 0 0 2 0 234 1 35 1 1 1 2 0
45 3 32 1 1 1 2 0 140 1 34 1 1 0 2 1 235 0 40 0 0 2 2 0
46 3 22 0 0 0 2 0 141 0 43 0 1 0 2 0 236 1 22 1 1 1 2 0
47 1 6 1 0 2 3 0 142 1 33 0 0 0 2 0 237 0 42 0 0 0 2 0
48 0 38 0 0 0 2 0 143 3 34 1 0 0 2 1 238 0 34 1 1 1 2 1
49 1 43 0 1 0 2 0 144 0 48 0 0 0 2 0 239 6 38 1 0 1 2 0
50 2 36 0 1 0 2 0 145 4 26 1 1 0 2 0 240 0 25 0 0 1 2 1
51 0 43 0 0 0 2 0 146 0 30 0 1 2 2 1 241 0 39 0 1 0 2 0
52 0 24 1 0 0 2 0 147 0 41 1 1 1 2 0 242 1 35 0 1 2 2 1
53 0 25 1 0 1 2 1 148 0 34 0 1 1 2 0 243 1 36 1 1 1 2 1
54 0 41 0 0 0 2 0 149 0 43 0 1 0 2 0 244 0 23 1 0 0 2 0
55 0 43 0 0 0 2 0 150 1 31 1 0 1 2 0 245 4 30 1 1 1 2 0
56 2 31 0 1 1 2 0 151 0 26 1 0 1 2 0 246 1 41 1 1 1 2 1
57 3 28 1 1 1 2 0 152 0 37 0 0 0 2 0 247 0 37 0 1 1 2 0
58 1 22 0 0 1 2 1 153 0 44 0 0 0 2 0 248 0 46 1 1 0 2 0
59 1 11 1 1 1 1 0 154 0 40 1 0 0 2 0 249 0 45 1 1 0 2 1
60 3 41 0 1 1 2 0 155 0 8 1 1 1 3 1 250 1 38 1 1 1 2 0
61 0 31 0 0 1 2 0 156 0 40 1 1 1 2 1 251 0 10 1 1 1 1 0
62 0 11 0 0 1 1 1 157 1 45 0 0 0 2 0 252 0 30 1 1 2 2 0
63 0 44 0 1 0 2 0 158 0 4 0 0 2 3 0 253 0 32 0 1 2 2 0
64 0 9 1 0 0 3 1 159 1 36 0 1 0 2 0 254 0 46 1 0 0 2 0
65 0 36 1 1 1 2 0 160 3 37 1 1 1 2 0 255 5 35 1 1 2 2 1
66 0 29 1 0 0 2 0 161 0 15 1 0 0 1 0 256 0 44 0 0 0 2 0
67 0 27 0 1 0 2 1 162 1 27 1 0 1 2 1 257 0 41 0 1 1 2 0
68 0 36 0 1 0 2 0 163 2 31 0 1 0 2 0 258 2 36 1 0 1 2 0
69 1 33 1 0 0 2 0 164 0 42 0 0 0 2 0 259 0 34 1 1 1 2 1
70 2 13 1 1 2 1 1 165 0 42 1 0 0 2 0 260 1 30 0 1 0 2 1
71 0 38 0 0 0 2 0 166 1 38 0 0 0 2 0 261 1 27 1 0 0 2 0
72 0 41 0 0 0 2 1 167 0 44 1 0 0 2 0 262 0 48 1 0 0 2 0
73 0 41 1 0 2 2 0 168 0 45 0 0 0 2 0 263 1 6 0 1 2 3 1
74 0 35 0 0 1 2 0 169 0 34 0 1 0 2 0 264 0 38 1 1 0 2 1
75 0 45 0 0 0 2 0 170 2 41 0 0 0 2 0 265 0 29 1 1 1 2 1
76 4 38 1 0 2 2 1 171 2 30 1 1 1 2 0 266 1 43 0 1 2 2 1
77 1 42 1 0 0 2 1 172 0 44 0 0 0 2 0 267 0 43 0 1 0 2 0
78 1 42 1 1 2 2 1 173 0 40 1 0 0 2 0 268 0 37 1 0 2 2 0
79 6 36 1 1 0 2 0 174 2 31 0 0 0 2 0 269 1 23 1 1 0 2 1
80 2 23 1 1 1 2 1 175 0 41 1 0 0 2 0 270 0 44 0 0 1 2 0
81 1 32 0 0 1 2 0 176 0 41 0 0 0 2 0 271 0 5 0 1 1 3 1
82 0 41 0 1 0 2 0 177 0 39 1 0 0 2 0 272 0 25 1 0 2 2 0
83 0 50 0 0 0 2 0 178 0 40 1 0 0 2 0 273 0 25 1 0 1 2 0
84 0 42 1 1 1 2 1 179 2 35 1 0 2 2 0 274 1 28 1 1 1 2 1
85 1 30 0 0 0 2 0 180 1 43 1 0 0 2 0 275 0 7 0 1 0 3 1
86 2 47 0 1 0 2 0 181 2 39 0 0 0 2 0 276 0 32 0 0 0 2 0
87 1 35 1 1 2 2 0 182 0 35 1 1 0 2 0 277 0 41 0 0 0 2 0
88 1 38 1 0 1 2 1 183 0 37 0 0 0 2 0 278 1 33 1 1 2 2 1
89 1 38 1 1 1 2 1 184 3 37 0 0 0 2 0 279 2 36 1 1 2 2 0
90 1 38 1 1 1 2 1 185 0 43 0 0 0 2 0 280 0 31 0 0 0 2 0
91 0 32 1 1 1 2 0 186 0 42 0 0 0 2 0 281 0 18 0 0 0 2 0
92 1 3 1 0 1 3 1 187 0 42 0 0 0 2 0 282 1 32 1 0 2 2 0
93 0 26 1 0 0 2 1 188 0 38 0 0 0 2 0 283 0 22 1 1 2 2 1
94 0 35 1 0 0 2 0 189 0 36 1 0 0 2 0 284 0 35 0 0 0 2 1
95 3 37 1 0 0 2 0 190 0 39 0 1 0 2 0
;

proc genmod data=lri;
class ses id race agegroup;
model count = passive crowding ses race agegroup/
dist=poisson link=log offset=logrisk type3;
run;

proc genmod data=lri;
class id ses race agegroup;
model count = passive crowding ses race agegroup /
dist=poisson link=log offset=logrisk type3;
repeated subject=id / type=ind;
run;

*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<Macro for AdjustedWald Statistic;
%macro geef;
data temp1;
set clustout;
drop Label1 cvalue1;
if Label1=¡¯Number of Clusters¡¯;
run;
data temp2;
set scoreout;
drop ProbChiSq;
run;
data temp3;
merge temp1 temp2;
run;
data temp4; set temp3;
retain nclusters; drop nvalue1;
if _n_=1 then nclusters=nvalue1;
run;
data temp5;
set temp4;
drop ChiSq nclusters d;
d=nclusters-1;
NewF= ((d-df+1)*ChiSq)/(d*df);
ProbF=1-cdf(¡¯F¡¯, NewF,df,d-df+1);
run;
/* Set the ODS path to include your store first (this
sets the search path order so that ODS looks in your
store first, followed by the default store */
ods path sasuser.templat (update)
sashelp.tmplmst (read);
/* Print the path to the log to make sure you will get
what you expect */
*ods path show;
/* Define your table, and store it */
proc template;
define table GEEType3F;
parent=Stat.Genmod.Type3GEESc;
header "#F-Statistics for Type 3 GEE Analysis##";
column Source DF i NewF ProbF;
define NewF;
parent = Common.ANOVA.FValue;
end;
end;
run;
title1;
data _null_;
set temp5;
file print ods=(template=¡¯GEEType3F¡¯);
put _ods_;
run;
;
%mend geef;

*******************************************************************************************;
*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<Loglinear Models<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<;
data bicycle;
input type $ helmet $ count;
datalines;
Mountain Yes 34
Mountain No 32
Other Yes 10
Other No 24
;
run;

proc catmod;
weight count;
model type*helmet=_response_ / noprofile noresponse noiter noparm;
loglin type helmet;
run;

proc freq order=data;
weight count;
tables type*helmet / nopercent norow chisq;
run;

*Loglinear Model for the s  r Table;
data melanoma;
input type $ site $ count;
datalines;
Hutchinson¡¯s Head&Neck 22
Hutchinson¡¯s Trunk 2
Hutchinson¡¯s Extremities 10
Superficial Head&Neck 16
Superficial Trunk 54
Superficial Extremities 115
Nodular Head&Neck 19
Nodular Trunk 33
Nodular Extremities 73
Indeterminate Head&Neck 11
Indeterminate Trunk 17
Indeterminate Extremities 28
;
run;

proc catmod;
weight count;
model type*site=_response_ / noresponse noiter noparm;
loglin type site;
run; quit;

ods select Type3;
proc genmod;
class type site;
model count=type|site / link=log dist=poisson type3;
run;

*Three-Way Contingency Tables;
data satisfac;
input managmnt $ supervis $ worker $ count;
datalines;
Bad Low Low 103
Bad Low High 87
Bad High Low 32
Bad High High 42
Good Low Low 59
Good Low High 109
Good High Low 78
Good High High 205
;
proc catmod order=data;
weight count;
model managmnt*supervis*worker=_response_
/ noresponse noiter noparm;
loglin managmnt|supervis|worker;
run;

proc catmod order=data;
weight count;
model managmnt*supervis*worker=_response_
/ noprofile noresponse noiter p=freq;
loglin managmnt|supervis managmnt|worker supervis|worker;
run;

proc catmod order=data;
weight count;
model managmnt*supervis*worker=_response_
/ noprofile noresponse noiter noparm;
loglin managmnt|supervis managmnt|worker;
proc catmod order=data;
weight count;
model managmnt*supervis*worker=_response_
/ noprofile noresponse noiter noparm;
loglin managmnt|supervis supervis|worker;
proc catmod order=data;
weight count;
model managmnt*supervis*worker=_response_
/ noprofile noresponse noiter noparm;
loglin managmnt|worker supervis|worker;
run;

data cancer;
input news $ radio $ reading $ lectures $ knowledg $ count;
datalines;
Yes Yes Yes Yes Good 23
Yes Yes Yes Yes Poor 8
Yes Yes Yes No Good 102
Yes Yes Yes No Poor 67
Yes Yes No Yes Good 8
Yes Yes No Yes Poor 4
Yes Yes No No Good 35
Yes Yes No No Poor 59
Yes No Yes Yes Good 27
Yes No Yes Yes Poor 18
Yes No Yes No Good 201
Yes No Yes No Poor 177
Yes No No Yes Good 7
Yes No No Yes Poor 6
Yes No No No Good 75
Yes No No No Poor 156
No Yes Yes Yes Good 1
No Yes Yes Yes Poor 3
No Yes Yes No Good 16
No Yes Yes No Poor 16
No Yes No Yes Good 4
No Yes No Yes Poor 3
No Yes No No Good 13
No Yes No No Poor 50
No No Yes Yes Good 3
No No Yes Yes Poor 8
No No Yes No Good 67
No No Yes No Poor 83
No No No Yes Good 2
No No No Yes Poor 10
No No No No Good 84
No No No No Poor 393
;
proc catmod order=data;
weight count;
model news*radio*reading*lectures*knowledg=_response_
/ noresponse noiter noparm;
loglin news|radio|reading|lectures news|radio|reading|knowledg
news|radio|lectures|knowledg news|reading|lectures|knowledg
radio|reading|lectures|knowledg;
run;

proc catmod order=data;
weight count;
model news*radio*reading*lectures*knowledg=_response_
/ noprofile noresponse noiter noparm;
loglin news|radio|reading news|radio|lectures
news|radio|knowledg news|reading|lectures
news|reading|knowledg news|lectures|knowledg
radio|reading|lectures radio|reading|knowledg
radio|lectures|knowledg reading|lectures|knowledg;
run;

proc catmod order=data;
weight count;
model news*radio*reading*lectures*knowledg=_response_
/ noprofile noresponse noiter noparm;
loglin news|radio radio|reading
radio|lectures radio|knowledg
news|reading|knowledg news|lectures|knowledg
reading|lectures|knowledg;
run;

proc catmod order=data;
weight count;
model news*radio*reading*lectures*knowledg=_response_
/ noprofile noresponse noiter noparm;
loglin news|radio radio|lectures
radio|knowledg news|reading|knowledg
news|lectures|knowledg reading|lectures|knowledg;
run;

proc catmod order=data;
weight count;
model news*radio*reading*lectures*knowledg=_response_
/ noprofile noresponse noiter noparm;
loglin news|radio radio|lectures
radio|knowledg reading|knowledg
news|knowledg lectures|knowledg
news*reading(knowledg=¡¯Good¡¯)
news*reading(knowledg=¡¯Poor¡¯)
news*lectures(knowledg=¡¯Good¡¯)
news*lectures(knowledg=¡¯Poor¡¯)
reading*lectures(knowledg=¡¯Good¡¯)
reading*lectures(knowledg=¡¯Poor¡¯);
run;

proc catmod order=data;
weight count;
model news*radio*reading*lectures*knowledg=_response_
/ noprofile noresponse noiter;
loglin news|radio radio|lectures
radio|knowledg reading|knowledg
news|knowledg lectures|knowledg
news*reading(knowledg=¡¯Good¡¯)
news*reading(knowledg=¡¯Poor¡¯)
news*lectures(knowledg=¡¯Good¡¯)
reading*lectures(knowledg=¡¯Poor¡¯);
run;

*Correspondence Between Logistic Models and Loglinear Models;
proc catmod data=satisfac order=data;
weight count;
model worker=managmnt supervis
/ noprofile noresponse noiter p=freq;
run;

*************************************************************Categorized Time-to-Event Data***************;

*Mantel-Cox Test;
data clinical;
input time $ treatment $ status $ count @@;
datalines;
0-1 control recur 15 0-1 control not 50
0-1 active recur 12 0-1 active not 69
1-2 control recur 13 1-2 control not 30
1-2 active recur 7 1-2 active not 59
2-3 control recur 7 2-3 control not 17
2-3 active recur 10 2-3 active not 45
;
proc freq order=data;
weight count;
tables time*treatment*status / cmh;
run;

data duodenal;
input center time $ treatment $ status $ count @@;
datalines;
1 0-2 A healed 15 1 0-2 A not 19
1 0-2 P healed 15 1 0-2 P not 24
1 2-4 A healed 17 1 2-4 A not 2
1 2-4 P healed 17 1 2-4 P not 7
2 0-2 A healed 17 2 0-2 A not 27
2 0-2 P healed 12 2 0-2 P not 28
2 2-4 A healed 17 2 2-4 A not 10
2 2-4 P healed 13 2 2-4 P not 15
3 0-2 A healed 7 3 0-2 A not 33
3 0-2 P healed 3 3 0-2 P not 35
3 2-4 A healed 17 3 2-4 A not 16
3 2-4 P healed 17 3 2-4 P not 18
;
proc freq;
weight count;
tables center*time*treatment*status / cmh;
run;

*Piecewise Exponential Models;
*An Application of the Proportional Hazards Piecewise Exponential Model;
data vda;
input treatment $ time $ failure months;
nmonths=log(months);
datalines;
vda _0-6 23 3894
vda 7-24 32 10872
vda 25-60 45 18720
vh _0-6 9 2016
vh 7-24 5 5724
vh 25-60 10 10440
;
proc genmod data=vda;
class treatment time;
model failure = time treatment
/ dist=poisson link=log offset=nmonths;
run;
data vda;
input treatment time $ failure months;
smonths=100000*months;
datalines;
1 _0-6 23 3894
1 7-24 32 10872
1 25-60 45 18720
0 _0-6 9 2016
0 7-24 5 5724
0 25-60 10 10440
;
proc logistic;
class time/param=ref;
model failure/smonths = time treatment time*treatment /
scale=none include=2 selection=forward;
run;











