*================================================================================================================*;
*===                                           PLOT Procedure                                                 ===*;
*================================================================================================================*;
options nodate pageno=1 linesize=64
pagesize=25;
proc plot data=djia;
  plot high*year;
  title 'High Values of the Dow Jones';
  title2 'Industrial Average';
  title3 'from 1968 to 2008';
run;

*---Example 1: Specifying a Plotting Symbol---*;
options formchar="|----|+|---+=|-/\<>*";
data djia;
input Year HighDate date7. High LowDate date7. Low;
format highdate lowdate date7.;
datalines;
1968 03DEC68 985.21 21MAR68 825.13
1969 14MAY69 968.85 17DEC69 769.93...more data lines...
2006 27DEC06 12510.57 20JAN06 10667.39
2007 09OCT07 14164.53 05MAR07 12050.41
2008 02MAY08 13058.20 10OCT08 8451.19
;
proc plot data=djia;
plot high*year='*'
/ vspace=5 vaxis=by 1000;
title 'High Values of the Dow Jones Industrial Average';
title2 'from 1968 to 2008';
run;

*---Example 2: Controlling the Horizontal Axis and Adding a Reference Line---*;
options formchar="|----|+|---+=|-/\<>*";
data djia;
input Year HighDate date7. High LowDate date7. Low;
format highdate lowdate date7.;
datalines;
1968 03DEC68 985.21 21MAR68 825.13
1969 14MAY69 968.85 17DEC69 769.93...more data lines...
2006 27DEC06 12510.57 20JAN06 10667.39
2007 09OCT07 14164.53 05MAR07 12050.41
2008 02MAY08 13058.20 10OCT08 8451.19
;
proc plot data=djia;
plot high*year='*'
/ haxis=1965 to 2020 by 10 vref=3000;
title 'High Values of Dow Jones Industrial Average';
title2 'from 1968 to 2008';
run;


**---Example 3: Overlaying Two Plots---**;
options formchar="|";
data djia;
input Year HighDate date7. High LowDate date7. Low;
format highdate lowdate date7.;
datalines;
1968 03DEC68 985.21 21MAR68 825.13
1969 14MAY69 968.85 17DEC69 769.93...more data lines...
2006 27DEC06 12510.57 20JAN06 10667.39
2007 09OCT07 14164.53 05MAR07 12050.41
2008 02MAY08 13058.20 10OCT08 8451.19
;
proc plot data=djia formchar="|----|+|---+=|-/\<>*";
plot high*year='*'
low*year='o' / overlay box
haxis=by 10
vaxis=by 5000;
title 'Plot of Highs and Lows';
title2 'for the Dow Jones Industrial Average';
run;

*---Example 4: Producing Multiple Plots per Page---**;
options formchar="|----|+|---+=|-/\<>*" pagesize=40 linesize=120;
data djia;
input Year HighDate date7. High LowDate date7. Low;
format highdate lowdate date7.;
datalines;
1968 03DEC68 985.21 21MAR68 825.13
1969 14MAY69 968.85 17DEC69 769.93...more data lines...
2006 27DEC06 12510.57 20JAN06 10667.39
2007 09OCT07 14164.53 05MAR07 12050.41
2008 02MAY08 13058.20 10OCT08 8451.19
;
proc plot data=djia vpercent=50 hpercent=50;
plot high*year='*';
plot low*year='o';
plot high*year='*' low*year='o' / overlay box;
title 'Plots of the Dow Jones Industrial Average';
title2 'from 1968 to 2008';
run;

**---Example 5: Plotting Data on a Logarithmic Scale---*;
data equa;
do Y=1 to 3 by .1;
X=10**y;
output;
end;
run;
proc plot data=equa hpercent=50;
plot y*x / vspace=1;
plot y*x / haxis=10 100 1000 vspace=1;
title 'Two Plots with Different';
title2 'Horizontal Axis Specifications';
run;

**---Example 6: Plotting Date Values on an Axis--**;
options formchar="|----|+|---+=|-/\<>*";
data emergency_calls;
input Date : date7. Calls @@;
label calls='Number of Calls';
datalines;
1APR94 134 11APR94 384 13FEB94 488
2MAR94 289 21MAR94 201 14MAR94 460
3JUN94 184 13JUN94 152 30APR94 356
4JAN94 179 14JAN94 128 16JUN94 480
5APR94 360 15APR94 350 24JUL94 388
6MAY94 245 15DEC94 150 17NOV94 328
7JUL94 280 16MAY94 240 25AUG94 280
8AUG94 494 17JUL94 499 26SEP94 394
9SEP94 309 18AUG94 248 23NOV94 590
19SEP94 356 24FEB94 201 29JUL94 330
10OCT94 222 25MAR94 183 30AUG94 321
11NOV94 294 26APR94 412 2DEC94 511
27MAY94 294 22DEC94 413 28JUN94 309
;
proc plot data=emergency_calls;
plot calls*date / haxis='1JAN94'd to '1JAN95'd by month vaxis=by 100 vspace=5;
format date mmyyd5.;
title 'Calls to City Emergency Services Number';
title2 'Sample of Days for 1994';
run;

**---Example 7: Producing a Contour Plot---**;
options formchar="|----|+|---+=|-/\<>*";
data contours;
format Z 5.1;
do X=0 to 400 by 5;
do Y=0 to 350 by 10;
z=46.2+.09*x-.0005*x**2+.1*y-.0005*y**2+.0004*x*y;
output;
end;
end;
run;
proc print data=contours(obs=5) noobs;
title 'CONTOURS Data Set';
title2 'First 5 Observations Only';
run;
proc plot data=contours;
plot y*x=z / contour=10;
title 'A Contour Plot';
run;

**---Example 8: Plotting BY Groups---*;
options formchar=|----|+|---+=|-/\<>*;
data education;
input State $14. +1 Code $ DropoutRate Expenditures MathScore
Region $;
label dropout='Dropout Percentage - 1989'
expend='Expenditure Per Pupil - 1989'
math='8th Grade Math Exam - 1990';
datalines;
Alabama AL 22.3 3197 252 SE
Alaska AK 35.8 7716 . W
...more data lines...
New York NY 35.0 . 261 NE
North Carolina NC 31.2 3874 250 SE
North Dakota ND 12.1 3952 281 MW
Ohio OH 24.4 4649 264 MW
;
proc sort data=education;
by region;
run;
proc plot data=education;
by region;
plot expenditures*dropoutrate='*' / href=28.6
vaxis=by 500 vspace=5
haxis=by 5 hspace=12;
title 'Plot of Dropout Rate and Expenditure Per Pupil';
run;

**---Example 9: Adding Labels to a Plot---**;
options formchar="|----|+|---+=|-/\<>*";
proc sort data=education;
by region;
run;
proc plot data=education;
by region;
plot expenditures*dropoutrate='*' $ state / href=28.6
vaxis=by 500 vspace=5
haxis=by 5 hspace=12;
title 'Plot of Dropout Rate and Expenditure Per Pupil';
run;

**---Example 10: Excluding Observations That Have Missing Values---**;
options formchar="|----|+|---+=|-/\<>*";
proc sort data=education;
by region;
run;
proc plot data=education nomiss;
by region;
plot expenditures*dropoutrate='*' $ state / href=28.6
vaxis=by 500 vspace=5
haxis=by 5 hspace=12;
title 'Plot of Dropout Rate and Expenditure Per Pupil';
run;

**---Example 11: Adjusting Labels on a Plot with the PLACEMENT= Option---**;
options formchar="|----|+|---+=|-/\<>*";
data census;
input Density CrimeRate State $ 14-27 PostalCode $ 29-30;
datalines;
263.3 4575.3 Ohio OH
62.1 7017.1 Washington WA
...more data lines...
111.6 4665.6 Tennessee TN
120.4 4649.9 North Carolina NC
;
proc plot data=census;
plot density*crimerate=state $ state /
box
list=1
haxis=by 1000
vaxis=by 250
vspace=10
hspace=10;
plot density*crimerate=state $ state /
box
list=1
haxis=by 1000
vaxis=by 250
vspace=10
placement=((v=2 1 : l=2 1)
((l=2 2 1 : v=0 1 0) * (s=right left : h=2 -2))
(s=center right left * l=2 1 * v=0 1 -1 2 *
h=0 1 to 5 by alt));
title 'A Plot of Population Density and Crime Rates';
run;

**---Example 12: Adjusting Labeling on a Plot with a Macro---**;
options formchar="|----|+|---+=|-/\<>*";
%macro place(n);
%if &n > 13 %then %let n = 13;
placement=(
%if &n <= 0 %then (s=center); %else (h=2 -2 : s=right left);
%if &n = 1 %then (v=1 * h=0 -1 to -2 by alt);
%else %if &n = 2 %then (v=1 -1 * h=0 -1 to -5 by alt);
%else %if &n > 2 %then (v=1 to 2 by alt * h=0 -1 to -10 by alt);
%if &n > 3 %then
(s=center right left * v=0 1 to %eval(&n - 2) by alt *
h=0 -1 to %eval(-3 * (&n - 2)) by alt *
l=1 to %eval(2 + (10 * &n - 35) / 30)); )
%if &n > 4 %then penalty(7)=%eval((3 * &n) / 2);
%mend;
proc plot data=census;
plot density*crimerate=state $ state /
box
list=1
haxis=by 1000
vaxis=by 250
vspace=12
%place(4);
title 'A Plot of Population Density and Crime Rates';
run;

**---Example 13: Changing a Default Penalty---**;
options formchar="|----|+|---+=|-/\<>*";
proc plot data=census;
plot density*crimerate=state $ state /
placement=(h=100 to 10 by alt * s=left right)
penalties(4)=500 list=0
haxis=0 to 13000 by 1000
vaxis=by 100
vspace=5;
title 'A Plot of Population Density and Crime Rates';
run;




