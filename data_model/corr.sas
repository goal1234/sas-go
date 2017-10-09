*---Getting Started: CORR Procedure---*;
*----------------- Data on Physical Fitness -----------------*
| These measurements were made on men involved in a physical |
| fitness course at N.C. State University. |
| The variables are Age (years), Weight (kg), |
| Runtime (time to run 1.5 miles in minutes), and |
| Oxygen (oxygen intake, ml per kg body weight per minute) |
| Certain values were changed to missing for the analysis. |
*------------------------------------------------------------*;
data Fitness;
input Age Weight Oxygen RunTime @@;
datalines;
44 89.47 44.609 11.37 40 75.07 45.313 10.07
44 85.84 54.297 8.65 42 68.15 59.571 8.17
38 89.02 49.874 . 47 77.45 44.811 11.63
40 75.98 45.681 11.95 43 81.19 49.091 10.85
44 81.42 39.442 13.08 38 81.87 60.055 8.63
44 73.03 50.541 10.13 45 87.66 37.388 14.03
45 66.45 44.754 11.12 47 79.15 47.273 10.60
54 83.12 51.855 10.33 49 81.42 49.156 8.95
51 69.63 40.836 10.95 51 77.91 46.672 10.00
48 91.63 46.774 10.25 49 73.37 . 10.08
57 73.37 39.407 12.63 54 79.38 46.080 11.17
52 76.32 45.441 9.63 50 70.87 54.625 8.92
51 67.25 45.118 11.08 54 91.63 39.203 12.88
51 73.71 45.790 10.47 57 59.08 50.545 9.93
49 76.32 . . 48 61.24 47.920 11.50
52 82.78 47.467 10.50
;

*---corr---*;

ods graphics on;
proc corr data=Fitness plots=matrix(histogram);
run;

*--≤Œ ˝¿Ôﬂ¿ﬂ¿--*;
/*PROC CORR < options > ;*/
/*BY variables ;*/
/*FREQ variable ;*/
/*ID variables ;*/
/*PARTIAL variables ;*/
/*VAR variables ;*/
/*WEIGHT variable ;*/
/*WITH variables ;*/

proc corr;
  var x1 x2;
  with y1 y2 y3;
run;

*---Computing Four Measures of Association---*;
ods graphics on;
title 'Measures of Association for a Physical Fitness Study';
proc corr data=Fitness pearson spearman kendall hoeffding
  plots=matrix(histogram);
  var Weight Oxygen RunTime;
run;

*---Computing Correlations between Two Sets of Variables---*;
*------------------- Data on Iris Setosa --------------------*
| The data set contains 50 iris specimens from the species |
| Iris Setosa with the following four measurements: |
| SepalLength (sepal length) |
| SepalWidth (sepal width) |
| PetalLength (petal length) |
| PetalWidth (petal width) |
| Certain values were changed to missing for the analysis. |
*------------------------------------------------------------*;
data Setosa;
input SepalLength SepalWidth PetalLength PetalWidth @@;
label sepallength='Sepal Length in mm.'
sepalwidth='Sepal Width in mm.'
petallength='Petal Length in mm.'
petalwidth='Petal Width in mm.';
datalines;
50 33 14 02 46 34 14 03 46 36 . 02
51 33 17 05 55 35 13 02 48 31 16 02
52 34 14 02 49 36 14 01 44 32 13 02
50 35 16 06 44 30 13 02 47 32 16 02
48 30 14 03 51 38 16 02 48 34 19 02
50 30 16 02 50 32 12 02 43 30 11 .
58 40 12 02 51 38 19 04 49 30 14 02
51 35 14 02 50 34 16 04 46 32 14 02
57 44 15 04 50 36 14 02 54 34 15 04
52 41 15 . 55 42 14 02 49 31 15 02
54 39 17 04 50 34 15 02 44 29 14 02
47 32 13 02 46 31 15 02 51 34 15 02
50 35 13 03 49 31 15 01 54 37 15 02
54 39 13 04 51 35 14 03 48 34 16 02
48 30 14 01 45 23 13 03 57 38 17 03
51 38 15 03 54 34 17 02 51 37 15 04
52 35 15 02 53 37 15 02
;


ods graphics on;
title 'Fisher (1936) Iris Setosa Data';
proc corr data=Setosa sscp cov plots=matrix;
var sepallength sepalwidth;
with petallength petalwidth;
run;


*---Analysis Using Fisher°Øs z Transformation---*;
proc corr data=Fitness nosimple fisher;
  var weight oxygen runtime;
run;

proc corr data=Fitness nosimple nocorr fisher (type=lower);
  var weight oxygen runtime;
run;

*---Applications of Fisher°Øs z Transformation---*;
data Sim (drop=i);
do i=1 to 400;
  X = rannor(135791);
  Batch = 1 + (i>150) + (i>300);
    if Batch = 1 then Y = 0.3*X + 0.9*rannor(246791);
    if Batch = 2 then Y = 0.25*X + sqrt(.8375)*rannor(246791);
    if Batch = 3 then Y = 0.3*X + 0.9*rannor(246791);
       output;
end;
run;



*---Testing Whether a Population Correlation Is Equal to a Given Value 0---*;
title 'Analysis for Batch 1';
proc corr data=Sim (where=(Batch=1)) fisher(rho0=.5);
  var X Y;
run;

*---Testing for Equality of Two Population Correlations---*;
ods output FisherPearsonCorr=SimCorr;
title 'Testing Equality of Population Correlations';
proc corr data=Sim (where=(Batch=1 or Batch=2)) fisher;
  var X Y;
  by Batch;
run;

proc print data=SimCorr;
run;

data SimTest (drop=Batch);
merge SimCorr (where=(Batch=1) keep=Nobs ZVal Batch
  rename=(Nobs=n1 ZVal=z1))
  SimCorr (where=(Batch=2) keep=Nobs ZVal Batch
  rename=(Nobs=n2 ZVal=z2));
  variance = 1/(n1-3) + 1/(n2-3);
  z = (z1 - z2) / sqrt( variance );
  pval = probnorm(z);
  if (pval > 0.5) then pval = 1 - pval;
  pval = 2*pval;
run;
proc print data=SimTest noobs;
run;

*---Combining Correlation Estimates from Different Samples---*;
ods output FisherPearsonCorr=SimCorr2;
proc corr data=Sim (where=(Batch=1 or Batch=3)) fisher;
var X Y;
by Batch;
run;
data SimComb (drop=Batch);
merge SimCorr2 (where=(Batch=1) keep=Nobs ZVal Batch
rename=(Nobs=n1 ZVal=z1))
SimCorr2 (where=(Batch=3) keep=Nobs ZVal Batch
rename=(Nobs=n2 ZVal=z2));
z = ((n1-3)*z1 + (n2-3)*z2) / (n1+n2-6);
corr = tanh(z);
var = 1/(n1+n2-6);
zlcl = z - probit(0.975)*sqrt(var);
zucl = z + probit(0.975)*sqrt(var);
lcl= tanh(zlcl);
ucl= tanh(zucl);
pval= probnorm( z/sqrt(var));
if (pval > .5) then pval= 1 - pval;
pval= 2*pval;
run;

proc print data=SimComb noobs;
var n1 z1 n2 z2 corr lcl ucl pval;
run;

*---Computing Polyserial Correlations---*;
*----------------- Data on Physical Fitness -----------------*
| These measurements were made on men involved in a physical |
| fitness course at N.C. State University. |
| The variables are Age (years), Weight (kg), |
| Runtime (time to run 1.5 miles in minutes), and |
| Oxygen (an ordinal variable based on oxygen intake, |
| ml per kg body weight per minute) |
| Certain values were changed to missing for the analysis. |
*------------------------------------------------------------*;
data Fitness1;
input Age Weight RunTime Oxygen @@;
datalines;
44 89.47 11.37 8 40 75.07 10.07 9
44 85.84 8.65 10 42 68.15 8.17 11
38 89.02 . 9 47 77.45 11.63 8
40 75.98 11.95 9 43 81.19 10.85 9
44 81.42 13.08 7 38 81.87 8.63 12
44 73.03 10.13 10 45 87.66 14.03 7
45 66.45 11.12 8 47 79.15 10.60 9
54 83.12 10.33 10 49 81.42 8.95 9
51 69.63 10.95 8 51 77.91 10.00 9
48 91.63 10.25 9 49 73.37 10.08 .
57 73.37 12.63 7 54 79.38 11.17 9
52 76.32 9.63 9 50 70.87 8.92 10
51 67.25 11.08 9 54 91.63 12.88 7
51 73.71 10.47 9 57 59.08 9.93 10
49 76.32 . . 48 61.24 11.50 9
52 82.78 10.50 9
;

proc corr data=Fitness1 pearson polyserial;
with Oxygen;
var Age Weight RunTime;
run;

*---Computing Cronbach°Øs Coefficient Alpha---*;
*------------------- Fish Measurement Data ----------------------*
| The data set contains 35 fish from the species Bream caught in |
| Finland's lake Laengelmavesi with the following measurements: |
| Weight (in grams) |
| Length3 (length from the nose to the end of its tail, in cm) |
| HtPct (max height, as percentage of Length3) |
| WidthPct (max width, as percentage of Length3) |
*----------------------------------------------------------------*;
data Fish1 (drop=HtPct WidthPct);
title 'Fish Measurement Data';
input Weight Length3 HtPct WidthPct @@;
Weight3= Weight**(1/3);
Height=HtPct*Length3/100;
Width=WidthPct*Length3/100;
datalines;
242.0 30.0 38.4 13.4 290.0 31.2 40.0 13.8
340.0 31.1 39.8 15.1 363.0 33.5 38.0 13.3
430.0 34.0 36.6 15.1 450.0 34.7 39.2 14.2
500.0 34.5 41.1 15.3 390.0 35.0 36.2 13.4
450.0 35.1 39.9 13.8 500.0 36.2 39.3 13.7
475.0 36.2 39.4 14.1 500.0 36.2 39.7 13.3
500.0 36.4 37.8 12.0 . 37.3 37.3 13.6
600.0 37.2 40.2 13.9 600.0 37.2 41.5 15.0
700.0 38.3 38.8 13.8 700.0 38.5 38.8 13.5
610.0 38.6 40.5 13.3 650.0 38.7 37.4 14.8
575.0 39.5 38.3 14.1 685.0 39.2 40.8 13.7
620.0 39.7 39.1 13.3 680.0 40.6 38.1 15.1
700.0 40.5 40.1 13.8 725.0 40.9 40.0 14.8
720.0 40.6 40.3 15.0 714.0 41.5 39.8 14.1
850.0 41.6 40.6 14.9 1000.0 42.6 44.5 15.5
920.0 44.1 40.9 14.3 955.0 44.0 41.1 14.3
925.0 45.3 41.4 14.9 975.0 45.9 40.6 14.7
950.0 46.5 37.9 13.7
;

ods graphics on;
title 'Fish Measurement Data';
proc corr data=fish1 nomiss alpha plots=matrix;
var Weight3 Length3 Height Width;
run;

*---Saving Correlations in an Output Data Set---*;
title 'Correlations for a Fitness and Exercise Study';
proc corr data=Fitness nomiss outp=CorrOutp;
var weight oxygen runtime;
run;

title 'Output Data Set from PROC CORR';
proc print data=CorrOutp noobs;
run;

title 'Input Type CORR Data Set from PROC REG';
proc reg data=CorrOutp;
model runtime= weight oxygen;
run;

proc reg data=Fitness;
model runtime= weight oxygen;
run;

*---Creating Scatter Plots---*;
ods graphics on;
title 'Fish Measurement Data';
proc corr data=fish1 nomiss plots=matrix(histogram);
var Height Width Length3 Weight3;
run;

ods graphics on;
proc corr data=fish1 nomiss
plots=scatter(nvar=2 alpha=.20 .30);
var Height Width Length3 Weight3;
run;

ods graphics on;
proc corr data=fish1
plots=scatter(alpha=.20 .30);
var Height Width;
run;

ods graphics on;
title 'Fish Measurement Data';
proc corr data=fish1 nomiss
plots=scatter(ellipse=confidence nvar=2 alpha=.05 .01);
var Height Width Length3 Weight3;
run;

*---2.9Computing Partial Correlations---*;
ods graphics on;
title 'Fish Measurement Data';
proc corr data=fish1 plots=scatter(alpha=.20 .30);
var Height Width;
partial Length3 Weight3;
run;


