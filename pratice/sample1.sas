/*If you are running in batch mode, set options at the start of each script so that output will be formatted to fit on a letter size page.*/

options linesize=64 pagesize=55;

/*Do a simple probability calculation and display the result*/

data race;
pr = probnorm(-15/sqrt(325));
run;
 
proc print data=race;
var pr;
run;

/*Do a simple probability calculation and display the result with PROC IML*/

proc iml;
FF = FINV(0.05/32,2,29);
print FF;
quit;
 

/*Compute, display and plot the ratio of confidence limits for a normal variance*/
/**/
/*(Try writing a simpler version of this using PROC IML.)*/

data chisq;
input df;
chirat = cinv(.995,df)/cinv(.005,df);
datalines;
20
21
22
23
24
25
26
27
28
29
30
;
run;
 
proc print data=chisq;
var df chirat;
run;
 
proc plot data=chisq;
plot chirat*df;
run;

/*Do a 2-Factor ANOVA, data entered in the script*/

data copper;
input id warp temp pct;
datalines;
1    17   50  40
2    20   50  40
3    16   50  60
4    21   50  60
5    24   50  80
6    22   50  80
9    12   75  40
10    9   75  40
11   18   75  60
12   13   75  60
13   17   75  80
14   12   75  80
25   21  125  40
26   17  125  40
27   23  125  60
28   21  125  60
29   23  125  80
30   22  125  80
;
 
proc anova data=copper;
  class temp pct;
  model warp= temp | pct;
run;

/*Do a Simple Linear Regression and plot the result from PROC REG*/
/**/
/*(Plotting from PROC REG does not work in batch mode)*/

data crack;
  input id age load;
  datalines;
  1  20 11.45
  2  20 10.42
  3  20 11.14
  4  25 10.84
  5  25 11.17
  6  25 10.54
  7  31  9.47
  8  31  9.19
  9  31  9.54
  ;
 
proc reg data=crack;
  model load = age;
  plot predicted. * age = 'P' load * age = '*' / overlay;
run;

/*Scatter plot in batch mode*/

data crack;
  input id age load;
  datalines;
  1  20 11.45
  2  20 10.42
  3  20 11.14
  4  25 10.84
  5  25 11.17
  6  25 10.54
  7  31  9.47
  8  31  9.19
  9  31  9.54
  ;
 
proc plot data=crack;
  plot load * age = "*";
run;

/*Simple Linear Regression and scatter plot with overlay in batch mode*/

data crack;
  input id age load;
  datalines;
  1  20 11.45
  2  20 10.42
  3  20 11.14
  4  25 10.84
  5  25 11.17
  6  25 10.54
  7  31  9.47
  8  31  9.19
  9  31  9.54
  ;
 
proc reg data=crack;
  model load = age / p;
  output out=crackreg p=pred r=resid;
run;
 
proc plot data=crackreg;
  plot load*age="*" pred*age="+"/ overlay;
run;

/*Simple Linear Regression ANOVA with non-linearity test, scatter plot with overlay in batch mode*/

data crack;
  input id age load agef;
  datalines;
  1  20 11.45 20
  2  20 10.42 20
  3  20 11.14 20
  4  25 10.84 25
  5  25 11.17 25
  6  25 10.54 25
  7  31  9.47 31
  8  31  9.19 31
  9  31  9.54 31
  ;
 
proc glm data=crack;
  class agef;
  model load = age agef / p;
  output out=crackreg p=pred r=resid;
run;
 
proc plot data=crackreg;
  plot load*age="*" pred*age="+"/ overlay;
run;

/*Two-Factor ANOVA, data entered in the script*/

data toxic;
input life  poison $ treatment $;
datalines;
0.31 I   A
0.45 I   A
0.46 I   A
0.43 I   A
0.36 II  A
0.29 II  A
0.40 II  A
0.23 II  A
0.22 III A
0.21 III A
0.18 III A
0.23 III A
0.82 I   B
1.10 I   B
0.88 I   B
0.72 I   B
0.92 II  B
0.61 II  B
0.49 II  B
1.24 II  B
0.30 III B
0.37 III B
0.38 III B
0.29 III B
0.43 I   C
0.45 I   C
0.63 I   C
0.76 I   C
0.44 II  C
0.35 II  C
0.31 II  C
0.40 II  C
0.23 III C
0.25 III C
0.24 III C
0.22 III C
0.45 I   D
0.71 I   D
0.66 I   D
0.62 I   D
0.56 II  D
1.02 II  D
0.71 II  D
0.38 II  D
0.30 III D
0.36 III D
0.31 III D
0.33 III D
;
run;
 
proc anova data=toxic;
class poison treatment;
model life = poison treatment poison*treatment;
run;

/*Two-Factor ANOVA, data from a comma-delimited text file*/

data toxic;
infile "toxic.dat" dlm=",";
input life  poison $ treatment $;
run;
 
proc anova data=toxic;
class poison treatment;
model life = poison treatment poison*treatment;
run;
