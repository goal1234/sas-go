
***---------------------The UNIVARIATE Procedure----------------***;

*---Summarizing a Data Distribution---*;
ods select BasicMeasures ExtremeObs;
proc univariate data=HomeLoans;
  var LoanToValueRatio;
run;

*-Exploring a Data Distribution-*;
title 'Home Loan Analysis';
ods graphics on;
proc univariate data=HomeLoans noprint;
  histogram LoanToValueRatio / odstitle = title;
  inset n = 'Number of Homes' / position=ne;
run;

title 'Comparison of Loan Types';
ods select Histogram Quantiles;
proc univariate data=HomeLoans;
  var LoanToValueRatio;
  class LoanType;
  histogram LoanToValueRatio / kernel
  odstitle = title;
  inset n='Number of Homes' median='Median Ratio' (5.3) / position=ne;
  label LoanType = 'Type of Loan';
run;
options gstyle;

*--Modeling a Data Distribution--*;

data Aircraft;
input Deviation @@;
label Deviation = 'Position Deviation';
datalines;
-.00653 0.00141 -.00702 -.00734 -.00649 -.00601
-.00631 -.00148 -.00731 -.00764 -.00275 -.00497
-.00741 -.00673 -.00573 -.00629 -.00671 -.00246
-.00222 -.00807 -.00621 -.00785 -.00544 -.00511
-.00138 -.00609 0.00038 -.00758 -.00731 -.00455
;

title 'Position Deviation Analysis';
ods graphics on;
ods select Moments TestsForNormality ProbPlot;
proc univariate data=Aircraft normaltest;
  var Deviation;
  probplot Deviation / normal(mu=est sigma=est)
                       square
                       odstitle = title;
  label Deviation = 'Position Deviation';
  inset mean std / format=6.4;
run;

*---syntax---*;
/*PROC UNIVARIATE < options > ;*/
/*BY variables ;*/
/*CDFPLOT < variables > < / options > ;*/
/*CLASS variable-1 < (v-options) > < variable-2 < (v-options) > >*/
/*< / KEYLEVEL= value1 | (value1 value2 ) > ;*/
/*FREQ variable ;*/
/*HISTOGRAM < variables > < / options > ;*/
/*ID variables ;*/
/*INSET keyword-list < / options > ;*/
/*OUTPUT <OUT=SAS-data-set > < keyword1=names . . . keywordk=names > < percentile-options >*/
/*;*/
/*PPPLOT < variables > < / options > ;*/
/*PROBPLOT < variables > < / options > ;*/
/*QQPLOT < variables > < / options > ;*/
/*VAR variables ;*/
/*WEIGHT variable ;*/

proc univariate round=1 0.5;
var Yieldstrength tenstren;
run;

*---CDFPLOT Statement---*;
proc univariate data=Steel;
  cdfplot;
run;

proc univariate data=Steel;
  var Length Width;
  cdfplot;
run;

proc univariate data=Steel;
  var Length Width;
  cdfplot Width;
run;

proc univariate;
  cdfplot / beta(theta=50 sigma=25);
run;

proc univariate;
  cdfplot / exponential(theta=10 l=2 color=green);
run;

proc univariate;
  cdfplot / gamma(theta=4);
run;

proc univariate;
  cdfplot / lognormal(theta = 10);
run;

*---HISTOGRAM Statement---*;
proc univariate data=Steel;
  histogram;
run;

proc univariate data=Steel;
  var Length Width;
  histogram;
run;

proc univariate data=Steel;
  var Length Width;
  histogram Length;
run;

proc univariate data=Steel;
  histogram Length / normal
  midpoints = 5.6 5.8 6.0 6.2 6.4
  ctext = blue;
run;

proc univariate;
  histogram / normal(color=red mu=10 sigma=0.5);
run;

proc univariate;
  histogram / normal(color=(red blue) mu=10 est sigma=0.5 est);
run;

*---Primary and Secondary Keywords---*;
proc univariate data=score;
histogram final / normal(sigma=1 2 3);
inset normal[2](ad adpval);
run;

proc univariate noprint;
var Width;
output pctlpts=20 33.33 66.67 80 pctlpre=pwid;
run;

proc univariate data=Score;
var PreTest PostTest;
output out=Pctls pctlpts=20 40 pctlpre=PreTest_ PostTest_
pctlname=P20 P40;
run;

*---PPPLOT Statement---*;
proc univariate data=measures;
  var length width;
  ppplot;
run;

proc univariate data=measures;
  ppplot length width;
run;

proc univariate data=measures;
ppplot length width / normal(mu=10 sigma=0.3)
square
ctext=blue;
run;

proc univariate data=measures;
ppplot length / normal(mu=10 sigma=0.3 color=red);
run;

proc univariate data=measures;
ppplot width / beta(theta=1 sigma=2 alpha=3 beta=4);
run;

proc univariate data=measures;
ppplot width / exponential(theta=1 sigma=2);
run;

proc univariate data=measures;
ppplot width / gamma(alpha=1 sigma=2 theta=3);
run;


proc univariate data=measures;
ppplot width / lognormal(theta=1 zeta=2);
run;

proc univariate data=measures;
ppplot width / normal(mu=1 sigma=2);
run;

*---PROBPLOT Statement---*;
proc univariate data=Measures;
  var Length Width;
  probplot;
proc univariate data=Measures;
  probplot Length Width;
run;

proc univariate data=Measures;
  probplot Length1 Length2 / normal(mu=10 sigma=0.3)
  square ctext=blue;
run;

proc univariate;
probplot Length / normal(mu=10 sigma=0.3 color=red);
run;

proc univariate data=Measures;
probplot Width / lognormal(sigma=2 theta=0 zeta=0);
probplot Width / lognormal(sigma=2 theta=0 slope=1);
probplot Width / weibull2(sigma=2 theta=0 c=.25);
probplot Width / weibull2(sigma=2 theta=0 slope=4);
run;

*---QQPLOT Statement---*;
proc univariate data=Measures;
var Length Width;
qqplot;
proc univariate data=Measures;
qqplot Length Width;
run;

proc univariate data=measures;
qqplot length1 length2 / normal(mu=10 sigma=0.3)
square ctext=blue;
run;

proc univariate;
qqplot Length / normal(mu=10 sigma=0.3 color=red);
run;

proc univariate data=Measures;
qqplot Width / lognormal(sigma=2 theta=0 zeta=0);
qqplot Width / lognormal(sigma=2 theta=0 slope=1);
qqplot Width / weibull2(sigma=2 theta=0 c=.25);
qqplot Width / weibull2(sigma=2 theta=0 slope=4);
RUN;


options nogstyle;
ods graphics off;
proc univariate data=HomeLoans noprint;
histogram LoanToValueRatio / lognormal;
inset lognormal(theta sigma zeta) / position=ne;
run;

*---Positioning Insets---*;
data Score;
input Student $ PreTest PostTest @@;
label ScoreChange = 'Change in Test Scores';
ScoreChange = PostTest - PreTest;
datalines;
Capalleti 94 91 Dubose 51 65
Engles 95 97 Grant 63 75
Krupski 80 75 Lundsford 92 55
Mcbane 75 78 Mullen 89 82
Nguyen 79 76 Patel 71 77
Si 75 70 Tanaka 87 73
;
title 'Test Scores for a College Course';
ods graphics off;
proc univariate data=Score noprint;
histogram PreTest / midpoints = 45 to 95 by 10;
inset n / cfill=blank
header='Position = NW' pos=nw;
inset mean / cfill=blank
header='Position = N ' pos=n ;
inset sum / cfill=blank
header='Position = NE' pos=ne;
inset max / cfill=blank
header='Position = E ' pos=e ;
inset min / cfill=blankheader='Position = SE' pos=se;
inset nobs / cfill=blank
header='Position = S ' pos=s ;
inset range / cfill=blank
header='Position = SW' pos=sw;
inset mode / cfill=blank
header='Position = W ' pos=w ;
label PreTest = 'Pretest Score';
run;


*---Positioning an Inset Using Coordinates--*;
title 'Test Scores for a College Course';
proc univariate data=Score noprint;
histogram PreTest / midpoints = 45 to 95 by 10;
inset n / header = 'Position=(45,10)'
position = (45,10) data;
run;

data Analysis;
input A1-A10;
datalines;
72 223 332 138 110 145 23 293 353 458
97 54 61 196 275 171 117 72 81 141
56 170 140 400 371 72 60 20 484 138
124 6 332 493 214 43 125 55 372 30
152 236 222 76 187 126 192 334 109 546
5 260 194 277 176 96 109 184 240 261
161 253 153 300 37 156 282 293 451 299
128 121 254 297 363 132 209 257 429 295
116 152 331 27 442 103 80 393 383 94
43 178 278 159 25 180 253 333 51 225
34 128 182 415 524 112 13 186 145 131
142 236 234 255 211 80 281 135 179 11
108 215 335 66 254 196 190 363 226 379
62 232 219 474 31 139 15 56 429 298
177 218 275 171 457 146 163 18 155 129
0 235 83 239 398 99 226 389 498 18
147 199 324 258 504 2 218 295 422 287
39 161 156 198 214 58 238 19 231 548
120 42 372 420 232 112 157 79 197 166
178 83 238 492 463 68 46 386 45 81
161 267 372 296 501 96 11 288 330 74
14 2 52 81 169 63 194 161 173 54
22 181 92 272 417 94 188 180 367 342
55 248 214 422 133 193 144 318 271 479
56 83 169 30 379 5 296 320 396 597
;

proc univariate data=Analysis outtable=Table noprint;
var A1-A10;
run;

proc print data=Table label noobs;
var _VAR_ _MIN_ _MEAN_ _MAX_ _STD_;
label _VAR_='Analysis';
run;

*---UNIVARIATE Procedure---*;
data BPressure;
length PatientID $2;
input PatientID $ Systolic Diastolic @@;
datalines;
CK 120 50 SS 96 60 FR 100 70
CP 120 75 BL 140 90 ES 120 70
CP 165 110 JI 110 40 MC 119 66
FC 125 76 RW 133 60 KD 108 54
DS 110 50 JW 130 80 BH 120 65
JW 134 80 SB 118 76 NS 122 78
GS 122 70 AB 122 78 EC 112 62
HH 122 82
;

title 'Systolic and Diastolic Blood Pressure';
ods select BasicMeasures Quantiles;
proc univariate data=BPressure;
var Systolic Diastolic;
run;

*---Calculating Modes---*;
data Exam;
label Score = 'Exam Score';
input Score @@;
datalines;
81 97 78 99 77 81 84 86 86 97
85 86 94 76 75 42 91 90 88 86
97 97 89 69 72 82 83 81 80 81
;

title 'Table of Modes for Exam Scores';
ods select Modes;
proc univariate data=Exam modes;
var Score;
run;

title 'Default Output';
ods select BasicMeasures;
proc univariate data=Exam;
var Score;
run;

*---Identifying Extreme Observations and Extreme Values---*;
title 'Extreme Blood Pressure Observations';
ods select ExtremeObs;
proc univariate data=BPressure;
var Systolic Diastolic;
id PatientID;
run;

title 'Extreme Blood Pressure Values';
ods select ExtremeValues;
proc univariate data=BPressure nextrval=5;
var Systolic Diastolic;
run;

*---Creating a Frequency Table---*;
data Score;
input Student $ PreTest PostTest @@;
label ScoreChange = 'Change in Test Scores';
ScoreChange = PostTest - PreTest;
datalines;
Capalleti 94 91 Dubose 51 65
Engles 95 97 Grant 63 75
Krupski 80 75 Lundsford 92 55
Mcbane 75 78 Mullen 89 82
Nguyen 79 76 Patel 71 77
Si 75 70 Tanaka 87 73
;

title 'Analysis of Score Changes';
ods select Frequencies;
proc univariate data=Score freq;
var ScoreChange;
run;

*---Creating Basic Summary Plots---*;
data AirPoll (keep = Site Ozone);
label Site = 'Site Number'
Ozone = 'Ozone level (in ppb)';
do i = 1 to 3;
input Site @@;
do j = 1 to 15;
input Ozone @@;
output;
end;
end;
datalines;
102 4 6 3 4 7 8 2 3 4 1 3 8 9 5 6
134 5 3 6 2 1 2 4 3 2 4 6 4 6 3 1
137 8 9 7 8 6 7 6 7 9 8 9 8 7 8 5
;

ods graphics off;
ods select Plots SSPlots;
proc univariate data=AirPoll plot;
by Site;
var Ozone;
run;

ods select Plots SSPlots;
proc univariate data=AirPoll plot;
by Site;
var Ozone;
run;

*---Analyzing a Data Set With a FREQ Variable---*;
data Speeding;
label Speed = 'Speed (in miles per hour)';
do Speed = 66 to 85;
input Number @@;
output;
end;
datalines;
2 3 2 1 3 6 8 9 10 13
12 14 6 2 0 0 1 1 0 1
;

title 'Analysis of Speeding Data';
ods select Moments;
proc univariate data=Speeding;
freq Number;
var Speed;
run;

*---Saving Summary Statistics in an OUT= Output Data Set---*;
data Belts;
label Strength = 'Breaking Strength (lb/in)'
Width = 'Width in Inches';
input Strength Width @@;
datalines;
1243.51 3.036 1221.95 2.995 1131.67 2.983 1129.70 3.019
1198.08 3.106 1273.31 2.947 1250.24 3.018 1225.47 2.980
1126.78 2.965 1174.62 3.033 1250.79 2.941 1216.75 3.037
1285.30 2.893 1214.14 3.035 1270.24 2.957 1249.55 2.958
1166.02 3.067 1278.85 3.037 1280.74 2.984 1201.96 3.002
1101.73 2.961 1165.79 3.075 1186.19 3.058 1124.46 2.929
1213.62 2.984 1213.93 3.029 1289.59 2.956 1208.27 3.029
1247.48 3.027 1284.34 3.073 1209.09 3.004 1146.78 3.061
1224.03 2.915 1200.43 2.974 1183.42 3.033 1195.66 2.995
1258.31 2.958 1136.05 3.022 1177.44 3.090 1246.13 3.022
1183.67 3.045 1206.50 3.024 1195.69 3.005 1223.49 2.971
1147.47 2.944 1171.76 3.005 1207.28 3.065 1131.33 2.984
1215.92 3.003 1202.17 3.058
;

proc univariate data=Belts noprint;
var Strength Width;
output out=Means mean=StrengthMean WidthMean;
output out=StrengthStats mean=StrengthMean std=StrengthSD
min=StrengthMin max=StrengthMax;
run;

*---Saving Percentiles in an Output Data Set---*;
proc univariate data=Belts noprint;
var Strength Width;
output out=PctlStrength p5=p5str p95=p95str;
run;

proc univariate data=Belts noprint;
var Strength Width;
output out=Pctls pctlpts = 20 40
pctlpre = Strength Width
pctlname = pct20 pct40;
run;

*---Computing Confidence Limits for the Mean, Standard Deviation,and Variance---*;
data Heights;
label Height = 'Height (in)';
input Height @@;
datalines;
64.1 60.9 64.1 64.7 66.7 65.0 63.7 67.4 64.9 63.7
64.0 67.5 62.8 63.9 65.9 62.3 64.1 60.6 68.6 68.6
63.7 63.0 64.7 68.2 66.7 62.8 64.0 64.1 62.1 62.9
62.7 60.9 61.6 64.6 65.7 66.6 66.7 66.0 68.5 64.4
60.5 63.0 60.0 61.6 64.3 60.2 63.5 64.7 66.0 65.1
63.6 62.0 63.6 65.8 66.0 65.4 63.5 66.3 66.2 67.5
65.8 63.1 65.8 64.4 64.0 64.9 65.7 61.0 64.1 65.5
68.6 66.6 65.7 65.1 70.0
;

title 'Analysis of Female Heights';
ods select BasicIntervals;
proc univariate data=Heights cibasic;
var Height;
run;

title 'Analysis of Female Heights';
ods select BasicIntervals;
proc univariate data=Heights cibasic(alpha=.1);
var Height;
run;

*---Computing Confidence Limits for Quantiles and Percentiles---*;
title 'Analysis of Female Heights';
ods select Quantiles;
proc univariate data=Heights ciquantnormal(alpha=.1);
var Height;
run;

title 'Analysis of Female Heights';
ods select Quantiles;
proc univariate data=Heights ciquantdf(alpha=.1);
var Height;
run;

*---Computing Robust Estimates---*;
title 'Robust Estimates for Blood Pressure Data';
ods select TrimmedMeans WinsorizedMeans RobustScale;
proc univariate data=BPressure trimmed=1 .1
winsorized=.1 robustscale;
var Systolic;
run;

*---Testing for Location---*;
title 'Analysis of Female Height Data';
ods select TestsForLocation LocationCounts;
proc univariate data=Heights mu0=66 loccount;
var Height;
run;

*---Performing a Sign Test Using Paired Data---*;
title 'Test Scores for a College Course';
ods select BasicMeasures TestsForLocation;
proc univariate data=Score;
var ScoreChange;
run;

*---Creating a Histogram---*;
data Trans;
input Thick @@;
label Thick = 'Plating Thickness (mils)';
datalines;
3.468 3.428 3.509 3.516 3.461 3.492 3.478 3.556 3.482 3.512
3.490 3.467 3.498 3.519 3.504 3.469 3.497 3.495 3.518 3.523
3.458 3.478 3.443 3.500 3.449 3.525 3.461 3.489 3.514 3.470
3.561 3.506 3.444 3.479 3.524 3.531 3.501 3.495 3.443 3.458
3.481 3.497 3.461 3.513 3.528 3.496 3.533 3.450 3.516 3.476
3.512 3.550 3.441 3.541 3.569 3.531 3.468 3.564 3.522 3.520
3.505 3.523 3.475 3.470 3.457 3.536 3.528 3.477 3.536 3.491
3.510 3.461 3.431 3.502 3.491 3.506 3.439 3.513 3.496 3.539
3.469 3.481 3.515 3.535 3.460 3.575 3.488 3.515 3.484 3.482
3.517 3.483 3.467 3.467 3.502 3.471 3.516 3.474 3.500 3.466
;

title 'Analysis of Plating Thickness';
ods graphics on;
proc univariate data=Trans noprint;
histogram Thick / odstitle = title;
run;
title 'Enhancing a Histogram';
proc univariate data=Trans noprint;
histogram Thick / midpoints = 3.4375 to 3.5875 by .025
rtinclude
outhistogram = OutMdpts
odstitle = title;
run;
proc print data=OutMdpts;
run;

*---Creating a One-Way Comparative Histogram---*;
title 'Histogram of Length Ignoring Lot Source';
ods graphics on;
proc univariate data=Channel noprint;
histogram Length / odstitle = title;
run;

title 'Comparative Analysis of Lot Source';
proc univariate data=Channel noprint;
class Lot;
histogram Length / nrows = 3
odstitle = title;
run;

*---Creating a Two-Way Comparative Histogram---*;
proc format ;
value mytime 1 = '2002' 2 = '2003';
data Disk;
input @1 Supplier $10. Year Width;
label Width = 'Opening Width (inches)';
format Year mytime.;
datalines;
Supplier A 1 1.8932
. . .
Supplier B 1 1.8986
Supplier A 2 1.8978
. . .
Supplier B 2 1.8997
;

title 'Results of Supplier Training Program';
ods graphics on;
proc univariate data=Disk noprint;
class Supplier Year / keylevel = ('Supplier A' '2003');
histogram Width / vaxis = 0 10 20 30
ncols = 2
nrows = 2
odstitle = title;
run;

*---Adding Insets with Descriptive Statistics---*;
data Machines;
input Position @@;
label Position = 'Position in Millimeters';
if (_n_ <= 100) then Machine = 'Machine 1';
else if (_n_ <= 200) then Machine = 'Machine 2';
else Machine = 'Machine 3';
datalines;
-0.17 -0.19 -0.24 -0.24 -0.12 0.07 -0.61 0.22 1.91 -0.08
-0.59 0.05 -0.38 0.82 -0.14 0.32 0.12 -0.02 0.26 0.19
-0.07 0.13 -0.49 0.07 0.65 0.94 -0.51 -0.61 -0.57 -0.51
... more lines ...
0.48 0.41 0.78 0.58 0.43 0.07 0.27 0.49 0.79 0.92
0.79 0.66 0.22 0.71 0.53 0.57 0.90 0.48 1.17 1.03
;

title 'Machine Comparison Study';
ods graphics on;
proc univariate data=Machines noprint;
class Machine;
histogram Position / nrows = 3
midpoints = -1.2 to 2.2 by 0.1
vaxis = 0 to 16 by 4
odstitle = title;
inset mean std="Std Dev" / pos = ne format = 6.3;
run;

*---Binning a Histogram---*;
title 'Enhancing a Histogram';
ods select Histogram HistogramBins;
proc univariate data=Trans;
histogram Thick / midpercents
endpoints = 3.425 to 3.6 by .025
odstitle = title;
run;

title 'Enhancing a Histogram';
proc univariate data=Trans noprint;
histogram Thick / midpoints = 3.4375 to 3.5875 by .025
rtinclude
outhistogram = OutMdpts
odstitle = title;
run;

*---Adding a Normal Curve to a Histogram---*;
title 'Analysis of Plating Thickness';
ods select Histogram ParameterEstimates GoodnessOfFit FitQuantiles Bins;
proc univariate data=Trans;
histogram Thick / normal(percents=20 40 60 80 midpercents)
odstitle = title;
inset n normal(ksdpval) / pos = ne format = 6.3;
run;

*---Adding Fitted Normal Curves to a Comparative Histogram---*;
title 'Comparative Analysis of Lot Source';
proc univariate data=Channel noprint;
class Lot;
histogram Length / nrows = 3
intertile = 1
odstitle = title
cprop
normal(noprint);
inset n = "N" / pos = nw;
run;

*---Fitting a Beta Curve---*;
data Robots;
input Length @@;
label Length = 'Attachment Point Offset (in mm)';
datalines;
10.147 10.070 10.032 10.042 10.102
10.034 10.143 10.278 10.114 10.127
10.122 10.018 10.271 10.293 10.136
10.240 10.205 10.186 10.186 10.080
10.158 10.114 10.018 10.201 10.065
10.061 10.133 10.153 10.201 10.109
10.122 10.139 10.090 10.136 10.066
10.074 10.175 10.052 10.059 10.077
10.211 10.122 10.031 10.322 10.187
10.094 10.067 10.094 10.051 10.174
;

ods select ParameterEstimates FitQuantiles Histogram;
proc univariate data=Robots;
histogram Length /
beta(theta=10 scale=0.5 fill)
href = 10
hreflabel = 'Lower Bound'
odstitle = 'Fitted Beta Distribution of Offsets';
inset n = 'Sample Size' /
pos=ne cfill=blank;
run;

*---Fitting Lognormal, Weibull, and Gamma Curves---*;
data Plates;
label Gap = 'Plate Gap in cm';
input Gap @@;
datalines;
0.746 0.357 0.376 0.327 0.485 1.741 0.241 0.777 0.768 0.409
0.252 0.512 0.534 1.656 0.742 0.378 0.714 1.121 0.597 0.231
0.541 0.805 0.682 0.418 0.506 0.501 0.247 0.922 0.880 0.344
0.519 1.302 0.275 0.601 0.388 0.450 0.845 0.319 0.486 0.529
1.547 0.690 0.676 0.314 0.736 0.643 0.483 0.352 0.636 1.080
;

title 'Distribution of Plate Gaps';
ods graphics on;
ods select Histogram ParameterEstimates GoodnessOfFit FitQuantiles;
proc univariate data=Plates;
var Gap;
histogram / midpoints=0.2 to 1.8 by 0.2
lognormal
weibull
gamma
odstitle = title;
inset n mean(5.3) std='Std Dev'(5.3) skewness(5.3)
/ pos = ne header = 'Summary Statistics';
run;

*----Computing Kernel Density Estimates---*;
title 'FET Channel Length Analysis';
proc univariate data=Channel noprint;
histogram Length / kernel(c = 0.25 0.50 0.75 1.00
l = 1 20 2 34
noprint)
odstitle = title;
run;

*---Fitting a Three-Parameter Lognormal Curve---*;
data Plastic;
label Strength = 'Strength in psi';
input Strength @@;
datalines;
30.26 31.23 71.96 47.39 33.93 76.15 42.21
81.37 78.48 72.65 61.63 34.90 24.83 68.93
43.27 41.76 57.24 23.80 34.03 33.38 21.87
31.29 32.48 51.54 44.06 42.66 47.98 33.73
25.80 29.95 60.89 55.33 39.44 34.50 73.51
43.41 54.67 99.43 50.76 48.81 31.86 33.88
35.57 60.41 54.92 35.66 59.30 41.96 45.32
;

title 'Three-Parameter Lognormal Fit';
ods graphics on;
proc univariate data=Plastic noprint;
histogram Strength / lognormal(fill theta = est noprint)
odstitle = title;
inset lognormal / format=6.2 pos=ne;
run;

*---Annotating a Folded Normal Curve---*;
data Assembly;
label Offset = 'Offset (in mm)';
input Offset @@;
datalines;
11.11 13.07 11.42 3.92 11.08 5.40 11.22 14.69 6.27 9.76
9.18 5.07 3.51 16.65 14.10 9.69 16.61 5.67 2.89 8.13
9.97 3.28 13.03 13.78 3.13 9.53 4.58 7.94 13.51 11.43
11.98 3.90 7.67 4.32 12.69 6.17 11.48 2.82 20.42 1.01
3.18 6.02 6.63 1.72 2.42 11.32 16.49 1.22 9.13 3.34
1.29 1.70 0.65 2.62 2.04 11.08 18.85 11.94 8.34 2.07
0.31 8.91 13.62 14.94 4.83 16.84 7.09 3.37 0.49 15.19
5.16 4.14 1.92 12.70 1.97 2.10 9.38 3.18 4.18 7.22
15.84 10.85 2.35 1.93 9.19 1.39 11.40 12.20 16.07 9.23
0.05 2.15 1.95 4.39 0.48 10.16 4.81 8.28 5.68 22.81
0.23 0.38 12.71 0.06 10.11 18.38 5.53 9.36 9.32 3.63
12.93 10.39 2.05 15.49 8.12 9.52 7.77 10.70 6.37 1.91
8.60 22.22 1.74 5.84 12.90 13.06 5.08 2.09 6.41 1.40
15.60 2.36 3.97 6.17 0.62 8.56 9.36 10.19 7.16 2.37
12.91 0.95 0.89 3.82 7.86 5.33 12.92 2.64 7.92 14.06
;

proc means data = Assembly noprint;
var Offset;
output out=stat mean=m1 var=var n=n min = min;
run;
* Compute constant A from equation (19) of Elandt (1961);
data stat;
keep m2 a min;
set stat;
a = (m1*m1);
m2 = ((n-1)/n)*var + a;
a = a/m2;
run;

proc iml;
use stat;
read all var {m2} into m2;
read all var {a} into a;
read all var {min} into min;
* f(t) is the function in equation (19) of Elandt (1961);
start f(t) global(a);
y = .39894*exp(-0.5*t*t);
y = (2*y-(t*(1-2*probnorm(t))))**2/(1+t*t);
y = (y-a)**2;
return(y);
finish;
* Minimize (f(t)-A)**2 and estimate mu and sigma;
if ( min < 0 ) then do;
print "Warning: Observations are not all nonnegative.";
print " The folded normal is inappropriate.";
stop;
end;
if ( a < 0.637 ) then do;
print "Warning: the folded normal may be inappropriate";
end;
opt = { 0 0 };
con = { 1e-6 };
x0 = { 2.0 };
tc = { . . . . . 1e-8 . . . . . . .};
call nlpdd(rc,etheta0,"f",x0,opt,con,tc);
esig0 = sqrt(m2/(1+etheta0*etheta0));
emu0 = etheta0*esig0;
create prelim var {emu0 esig0 etheta0};
append;
close prelim;
* Define the log likelihood of the folded normal;
start g(p) global(x);
y = 0.0;
do i = 1 to nrow(x);
z = exp( (-0.5/p[2])*(x[i]-p[1])*(x[i]-p[1]) );
z = z + exp( (-0.5/p[2])*(x[i]+p[1])*(x[i]+p[1]) );
y = y + log(z);
end;
y = y - nrow(x)*log( sqrt( p[2] ) );
return(y);
finish;
* Maximize the log likelihood with subroutine NLPDD;
use assembly;
read all var {offset} into x;
esig0sq = esig0*esig0;
x0 = emu0||esig0sq;
opt = { 1 0 };
con = { . 0.0, . . };
call nlpdd(rc,xr,"g",x0,opt,con);
emu = xr[1];
esig = sqrt(xr[2]);
etheta = emu/esig;
create parmest var{emu esig etheta};
append;
close parmest;
quit;
* Define the log likelihood of the folded normal;
start g(p) global(x);
y = 0.0;
do i = 1 to nrow(x);
z = exp( (-0.5/p[2])*(x[i]-p[1])*(x[i]-p[1]) );
z = z + exp( (-0.5/p[2])*(x[i]+p[1])*(x[i]+p[1]) );
y = y + log(z);
end;
y = y - nrow(x)*log( sqrt( p[2] ) );
return(y);
finish;
* Maximize the log likelihood with subroutine NLPDD;
use assembly;
read all var {offset} into x;
esig0sq = esig0*esig0;
x0 = emu0||esig0sq;
opt = { 1 0 };
con = { . 0.0, . . };
call nlpdd(rc,xr,"g",x0,opt,con);
emu = xr[1];
esig = sqrt(xr[2]);
etheta = emu/esig;
create parmest var{emu esig etheta};
append;
close parmest;
quit;

proc univariate data = Assembly noprint;
histogram Offset / outhistogram = out normal(noprint) noplot;
run;
data OutCalc (drop = _MIDPT_);
set out (keep = _MIDPT_) end = eof;
retain _MIDPT1_ _WIDTH_;
if _N_ = 1 then _MIDPT1_ = _MIDPT_;
if eof then do;
_MIDPTN_ = _MIDPT_;
_WIDTH_ = (_MIDPTN_ - _MIDPT1_) / (_N_ - 1);
output;
end;
run;

data Anno;
merge ParmEst OutCalc;
length function color $ 8;
function = 'point';
color = 'black';
size = 2;
xsys = '2';
ysys = '2';
when = 'a';
constant = 39.894*_width_;;
left = _midpt1_ - .5*_width_;
right = _midptn_ + .5*_width_;
inc = (right-left)/100;
do x = left to right by inc;
z1 = (x-emu)/esig;
z2 = (x+emu)/esig;
y = (constant/esig)*(exp(-0.5*z1*z1)+exp(-0.5*z2*z2));
output;
function = 'draw';
end;
run;

title 'Folded Normal Distribution';
ods graphics off;
proc univariate data=assembly noprint;
histogram Offset / annotate = anno;
run;

*---Creating Lognormal Probability Plots---*;
title 'Lognormal Probability Plot for Position Deviations';
ods graphics on;
proc univariate data=Aircraft noprint;
probplot Deviation /
lognormal(theta=est zeta=est sigma=0.7 0.9 1.1)
odstitle = title
href = 95
square;
run;

title 'Lognormal Probability Plot for Position Deviations';
proc univariate data=Aircraft noprint;
probplot Deviation / lognormal(theta=est zeta=est sigma=est)
href = 95
odstitle = title
square;
run;

*----Creating a Histogram to Display Lognormal Fit---*;
title 'Distribution of Position Deviations';
ods select Histogram Lognormal.ParameterEstimates Lognormal.GoodnessOfFit;
proc univariate data=Aircraft;
var Deviation;
histogram / lognormal(w=3 theta=est)
odstitle = title;
inset n mean (5.3) std='Std Dev' (5.3) skewness (5.3) /
pos = ne
header = 'Summary Statistics';
run;

*---Creating a Normal Quantile Plot---*;
data Sheets;
input Distance @@;
label Distance = 'Hole Distance (cm)';
datalines;
9.80 10.20 10.27 9.70 9.76
10.11 10.24 10.20 10.24 9.63
9.99 9.78 10.10 10.21 10.00
9.96 9.79 10.08 9.79 10.06
10.10 9.95 9.84 10.11 9.93
10.56 10.47 9.42 10.44 10.16
10.11 10.36 9.94 9.77 9.36
9.89 9.62 10.05 9.72 9.82
9.99 10.16 10.58 10.70 9.54
10.31 10.07 10.33 9.98 10.15
;

title 'Normal Quantile-Quantile Plot for Hole Distance';
ods graphics on;
proc univariate data=Sheets noprint;
qqplot Distance / odstitle = title;
run;

*---Adding a Distribution Reference Line---*;
title 'Normal Quantile-Quantile Plot for Hole Distance';
proc univariate data=Sheets noprint;
qqplot Distance / normal(mu=est sigma=est)
odstitle = title
square;
run;

*---Interpreting a Normal Quantile Plot---*;
data Measures;
input Diameter @@;
label Diameter = 'Diameter (mm)';
datalines;
5.501 5.251 5.404 5.366 5.445 5.576 5.607
5.200 5.977 5.177 5.332 5.399 5.661 5.512
5.252 5.404 5.739 5.525 5.160 5.410 5.823
5.376 5.202 5.470 5.410 5.394 5.146 5.244
5.309 5.480 5.388 5.399 5.360 5.368 5.394
5.248 5.409 5.304 6.239 5.781 5.247 5.907
5.208 5.143 5.304 5.603 5.164 5.209 5.475
5.223
;

title 'Normal Q-Q Plot for Diameters';
ods graphics on;
proc univariate data=Measures noprint;
qqplot Diameter / normal
square
odstitle = title;
run;

*---Estimating Three Parameters from Lognormal Quantile Plots---*;
title 'Lognormal Q-Q Plot for Diameters';
proc univariate data=Measures noprint;
qqplot Diameter / lognormal(sigma=0.2 0.5 0.8)
square
odstitle = title;
run;

title 'Lognormal Q-Q Plot for Diameters';
proc univariate data=Measures noprint;
qqplot Diameter / lognormal(theta=5 zeta=est sigma=est)
square
odstitle = title;
run;

*---Estimating Percentiles from Lognormal Quantile Plots---*;
title 'Lognormal Q-Q Plot for Diameters';
proc univariate data=Measures noprint;
qqplot Diameter / lognormal(sigma=0.5 theta=5 slope=0.39)
pctlaxis(grid)
vref = 5.8 5.9 6.0
odstitle = title
square;
run;

*---Estimating Parameters from Lognormal Quantile Plots---*;
data ModifiedMeasures;
set Measures;
LogDiameter = log(Diameter-5);
label LogDiameter = 'log(Diameter-5)';
run;
title 'Two-Parameter Lognormal Q-Q Plot for Diameters';
proc univariate data=ModifiedMeasures noprint;
qqplot LogDiameter / normal(mu=est sigma=est)
square
odstitle = title;
inset n mean (5.3) std (5.3) /
pos = nw header = 'Summary Statistics';
run;

*---Comparing Weibull Quantile Plots---*;
data Failures;
input Time @@;
label Time = 'Time in Months';
datalines;
29.42 32.14 30.58 27.50 26.08 29.06 25.10 31.34
29.14 33.96 30.64 27.32 29.86 26.28 29.68 33.76
29.32 30.82 27.26 27.92 30.92 24.64 32.90 35.46
30.28 28.36 25.86 31.36 25.26 36.32 28.58 28.88
26.72 27.42 29.02 27.54 31.60 33.46 26.78 27.82
29.18 27.94 27.66 26.42 31.00 26.64 31.44 32.52
;

title 'Three-Parameter Weibull Q-Q Plot for Failure Times';
ods graphics on;
proc univariate data=Failures noprint;
qqplot Time / weibull(c=est theta=est sigma=est)
square
href = 0.5 1 1.5 2
vref = 25 27.5 30 32.5 35
odstitle = title;
run;

title 'Two-Parameter Weibull Q-Q Plot for Failure Times';
proc univariate data=Failures noprint;
qqplot Time / weibull(theta=24 c=est sigma=est)
square
vref = 25 to 35 by 2.5
href = 0.5 to 2.0 by 0.5
odstitle = title;
run;

*----Creating a Cumulative Distribution Plot---*;
data Cord;
label Strength="Breaking Strength (psi)";
input Strength @@;
datalines;
6.94 6.97 7.11 6.95 7.12 6.70 7.13 7.34 6.90 6.83
7.06 6.89 7.28 6.93 7.05 7.00 7.04 7.21 7.08 7.01
7.05 7.11 7.03 6.98 7.04 7.08 6.87 6.81 7.11 6.74
6.95 7.05 6.98 6.94 7.06 7.12 7.19 7.12 7.01 6.84
6.91 6.89 7.23 6.98 6.93 6.83 6.99 7.00 6.97 7.01
;

title 'Cumulative Distribution Function of Breaking Strength';
ods graphics on;
proc univariate data=Cord noprint;
cdf Strength / normal odstitle = title;
inset normal(mu sigma);
run;

*--Creating a P-P Plot---*;
data Sheets;
input Distance @@;
label Distance='Hole Distance in cm';
datalines;
9.80 10.20 10.27 9.70 9.76
10.11 10.24 10.20 10.24 9.63
9.99 9.78 10.10 10.21 10.00
9.96 9.79 10.08 9.79 10.06
10.10 9.95 9.84 10.11 9.93
10.56 10.47 9.42 10.44 10.16
10.11 10.36 9.94 9.77 9.36
9.89 9.62 10.05 9.72 9.82
9.99 10.16 10.58 10.70 9.54
10.31 10.07 10.33 9.98 10.15
;

title 'Normal Probability-Probability Plot for Hole Distance';
ods graphics on;
proc univariate data=Sheets noprint;
ppplot Distance / normal(mu=10 sigma=0.3)
square
odstitle = title;
run;






