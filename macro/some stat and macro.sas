option user = work;
proc print data = sashelp.cars;
where make = 'Audi' and type = 'Sports' ;
 TITLE "Sales as of &SYSDAY &SYSDATE";
run;


*syntax;
%LET make_name = 'Audi';
%LET type_name = 'Sports';
proc print data = sashelp.cars;
where make = &make_name and type = &type_name ;
 TITLE "Sales as of &SYSDAY &SYSDATE";
run;


*一个标准的语法*;
/*# Creating a Macro program.*/
/*%MACRO (Param1, Param2,….Paramn);*/
/**/
/*Macro Statements;*/
/**/
/*%MEND;*/
/**/
/*# Calling a Macro program.*/
/*%MacroName (Value1, Value2,…..Valuen);*/

%MACRO show_result(make_ , type_);
proc print data = sashelp.cars;
where make = "&make_" and type = "&type_" ;
TITLE "Sales as of &SYSDAY &SYSDATE";
run;
%MEND;

%show_result(BMW,SUV);


*输出值;
data _null_;
CALL SYMPUT ('today',
TRIM(PUT("&sysdate"d,worddate22.)));
run;
%put &today;

*Macro %RETURN;;

%macro check_condition(val);
  %if &val = 10 %then %return;

  data p;
      x = 34.2;
  run;
%mend check_condition;

%check_conditon(11);

*macro %end;

%macro test(finish);
	%let i = 1;
	%do %while (&i <&finish);
		%put the value of i is &i;
		%let i = %eval(&i +1);
	%end;
%mend test;
%test(5);

DATA TEMP;
INPUT ID NAME $ SALARY DEPT $ DOJ DATE9. ;
FORMAT DOJ DATE9. ;
DATALINES;
1 Rick 623.3 IT 02APR2001
2 Dan 515.2 OPS 11JUL2012
3 Michelle 611 IT 21OCT2000
4 Ryan 729 HR 30JUL2012
5 Gary 843.25 FIN 06AUG2000
6 Tusar 578 IT 01MAR2009
7 Pranab 632.8 OPS 16AUG1998
8 Rasmi 722.5 FIN 13SEP2014
;
PROC PRINT DATA=TEMP;
RUN;

*string;

data string_examples;
   LENGTH string1 $ 6 String2 $ 5;
   /*String variables of length 6 and 5 */
   String1 = 'Hello';
   String2 = 'World';
   Joined_strings =  String1 ||String2 ;
 run;
proc print data = string_examples noobs;
run;

*提取字符串;
data string_examples;
   LENGTH string1 $ 6 ;
   String1 = 'Hello';
   sub_string1 = substrn(String1,2,4) ;
   /*Extract from position 2 to 4 */
   sub_string2 = substrn(String1,3) ;  *从最后的到前面的3个;
   /*Extract from position 3 onwards */
run;
proc print data = string_examples noobs;
run;


*trim()去除空格;
TRIMN('stringval');
data string_examples;
	length string1 $ 7;
	String1 = 'Hello';
	length_string1 = lengthc(String1);
	length_trimmed_string = lengthc(trimn(String1);
run;
proc print data = string_examples noobs;
run;


DATA array_example;
INPUT a1 $ a2 $ a3 $ a4 $ a5 $;
ARRAY colours(5) $ a1-a5;
mix = a1||'+'||a2;
DATALINES;
yello pink orange green blue
;
RUN;
PROC PRINT DATA=array_example;
RUN;

DATA array_example_OF;
	INPUT A1 A2 A3 A4;
	ARRAY A(4) A1-A4;
	A_SUM=SUM(OF A(*));
	A_MEAN=MEAN(OF A(*));
	A_MIN=MIN(OF A(*));
	DATALINES;
	21 4 52 11
	96 25 42 6
	;
	RUN;
	PROC PRINT DATA=array_example_OF;
	RUN;

DATA array_in_example;
	INPUT A1 $ A2 $ A3 $ A4 $;
	ARRAY COLOURS(4) A1-A4;
	IF 'yellow' IN COLOURS THEN available='Yes';ELSE available='No';
	DATALINES;
	Orange pink violet yellow
	;
	RUN;
	PROC PRINT DATA=array_in_example;
	RUN;


	data date_functions;
INPUT @1 date1 date9. @11 date2 date9.;
format date1 date9.  date2 date9.;

/* Get the interval between the dates in years*/
Years_ = INTCK('YEAR',date1,date2);

/* Get the interval between the dates in months*/
months_ = INTCK('MONTH',date1,date2);

/* Get the week day from the date*/
weekday_ =  WEEKDAY(date1);

/* Get Today's date in SAS date format */
today_ = TODAY();

/* Get current time in SAS time format */
time_ = time();
DATALINES;
21OCT2000 16AUG1998
01MAR2009 11JUL2012
;
proc print data = date_functions noobs;
run;


data character_functions;

/* Convert the string into lower case */
lowcse_ = LOWCASE('HELLO');
  
/* Convert the string into upper case */
upcase_ = UPCASE('hello');
  
/* Reverse the string */
reverse_ = REVERSE('Hello');
  
/* Return the nth word */
nth_letter_ = SCAN('Learn SAS Now',2);
run;

proc print data = character_functions noobs;
run;

data trunc_functions;

/* Nearest greatest integer */
ceil_ = CEIL(11.85);
  
/* Nearest greatest integer */
floor_ = FLOOR(11.85);
  
/* Integer portion of a number */
int_ = INT(32.41);
  
/* Round off to nearest value */
round_ = ROUND(5621.78);
run;

proc print data = trunc_functions noobs;
run;

data misc_functions;

/* Nearest greatest integer */
state2=zipstate('01040');
 
/* Amortization calculation */
payment=mort(50000, . , .10/12,30*12);

proc print data = misc_functions noobs;
run;


*--------------------------------histogram-------------------------------*;
PROC UNIVARAITE DATA = DATASET;
HISTOGRAM variables;
RUN;

proc univariate data = sashelp.cars;
	histogram horsepower
	/midpoints = 176 to 350 by 50;
run;

*拟合一个曲线;
proc univariate data = sashelp.cars noprint;
	histogram horsepowe
	/
	normal (
	mu = est
	sigma = est
	colot = blue
	w = 2.5
	)

	barlabel = percent
	  midpoints = 70 to 550 by 50;
	run;


	*----SAS - Bar Charts---*;
	PROC SGPLOT DATA = DATASET;
VBAR variables;
RUN;

PROC SQL;
create table CARS1 as
SELECT make,model,type,invoice,horsepower,length,weight
 FROM 
SASHELP.CARS
WHERE make in ('Audi','BMW')
;
RUN;

proc SGPLOT data=work.cars1;
vbar length ;
title 'Lengths of cars';
run;
quit;

*stack bar chart;
proc SGPLOT data=work.cars1;
vbar length /group = type ;
title 'Lengths of Cars by Types';
run;
quit;

*---Clustered Bar chart---*;
proc SGPLOT data=work.cars1;
vbar length /group = type GROUPDISPLAY = CLUSTER;
title 'Cluster of Cars by Types';
run;
quit;


*---SAS - Pie Charts---*;
PROC TEMPLATE;
  DEFINE STATGRAPH pie;
    BEGINGRAPH;
      LAYOUT REGION;
        PIECHART CATEGORY = variable /
          DATALABELLOCATION = OUTSIDE
          CATEGORYDIRECTION = CLOCKWISE
          START = 180 NAME = 'pie';
        DISCRETELEGEND 'pie' /
          TITLE = ' ';
      ENDLAYOUT;
    ENDGRAPH;
  END;
RUN;

*---Simple Pie Chart---*;
PROC SQL;
create table CARS1 as
SELECT make,model,type,invoice,horsepower,length,weight
 FROM 
SASHELP.CARS
WHERE make in ('Audi','BMW')
;
RUN;

PROC TEMPLATE;
  DEFINE STATGRAPH pie;
    BEGINGRAPH;
      LAYOUT REGION;
        PIECHART CATEGORY = type /
          DATALABELLOCATION = OUTSIDE
          CATEGORYDIRECTION = CLOCKWISE
          START = 180 NAME = 'pie';
        DISCRETELEGEND 'pie' /
          TITLE = 'Car Types';
      ENDLAYOUT;
    ENDGRAPH;
  END;
RUN;
PROC SGRENDER DATA = cars1
          TEMPLATE = pie;
RUN;

PROC TEMPLATE;
  DEFINE STATGRAPH pie;
    BEGINGRAPH;
      LAYOUT REGION;
        PIECHART CATEGORY = type /
          DATALABELLOCATION = INSIDE
          DATALABELCONTENT=ALL
          CATEGORYDIRECTION = CLOCKWISE
          DATASKIN= SHEEN 
          START = 180 NAME = 'pie';
        DISCRETELEGEND 'pie' /
          TITLE = 'Car Types';
      ENDLAYOUT;
    ENDGRAPH;
  END;
RUN;
PROC SGRENDER DATA = cars1
          TEMPLATE = pie;
RUN;

PROC TEMPLATE;
  DEFINE STATGRAPH pie;
    BEGINGRAPH;
      LAYOUT REGION;
        PIECHART CATEGORY = type / Group = make
          DATALABELLOCATION = INSIDE
          DATALABELCONTENT=ALL
          CATEGORYDIRECTION = CLOCKWISE
          DATASKIN= SHEEN 
          START = 180 NAME = 'pie';
        DISCRETELEGEND 'pie' /
          TITLE = 'Car Types';
      ENDLAYOUT;
    ENDGRAPH;
  END;
RUN;
PROC SGRENDER DATA = cars1
          TEMPLATE = pie;
RUN;


*----------------点图-----------------*;
PROC sgscatter  DATA=DATASET;
   PLOT VARIABLE_1 * VARIABLE_2
   / datalabel = VARIABLE group = VARIABLE;
RUN;

PROC SQL;
create table CARS1 as
SELECT make,model,type,invoice,horsepower,length,weight
 FROM 
SASHELP.CARS
WHERE make in ('Audi','BMW')
;
RUN;

TITLE 'Scatterplot - Two Variables';
PROC sgscatter  DATA=CARS1;
   PLOT horsepower*Invoice 
   / datalabel = make group = type grid;
   title 'Horsepower vs. Invoice for car makers by types';
RUN; 

proc sgscatter data =cars1; 
compare y = Invoice  x =(horsepower length)  
           / group=type  ellipse =(alpha =0.05 type=predicted); 
title
'Average Invoice vs. horsepower for cars by length'; 
title2
'-- with 95% prediction ellipse --'
; 
format
Invoice dollar6.0;
run;

PROC sgscatter  DATA=CARS1;
  matrix horsepower invoice length
  / group = type;

   title 'Horsepower vs. Invoice vs. Length for car makers by types';
RUN; 


*---boxplot---*;
PROC SGPLOT  DATA=DATASET;
  VBOX VARIABLE / category = VARIABLE;
RUN; 

PROC SGPANEL  DATA=DATASET;;
PANELBY VARIABLE;
  VBOX VARIABLE> / category = VARIABLE;
RUN; 

PROC SQL;
create table CARS1 as
SELECT make,model,type,invoice,horsepower,length,weight
 FROM 
SASHELP.CARS
WHERE make in ('Audi','BMW')
;
RUN;

PROC SGPLOT  DATA=CARS1;
  VBOX horsepower 
  / category = type;

   title 'Horsepower of cars by types';
RUN; 

PROC SGPANEL  DATA=CARS1;
PANELBY MAKE;
  VBOX horsepower   / category = type;

   title 'Horsepower of cars by types';
RUN;

PROC SGPANEL  DATA=CARS1;
PANELBY MAKE / columns = 1 novarname;

  VBOX horsepower   / category = type;

   title 'Horsepower of cars by types';
RUN;


**************************************************************************************************************************************;
**************************************************************************************************************************************;

PROC MEANS DATA = DATASET;
CLASS Variables ;
VAR Variables;
run;

PROC MEANS DATA = sashelp.CARS Mean SUM MAXDEC=2;
RUN;

PROC MEANS DATA = sashelp.CARS mean SUM MAXDEC=2 ;
var horsepower invoice EngineSize;
RUN;

PROC MEANS DATA = sashelp.CARS mean SUM MAXDEC=2;
class make type;
var horsepower;
RUN;
PROC means DATA = dataset STD;
PROC SQL;
create table CARS1 as
SELECT make,type,invoice,horsepower,length,weight
 FROM 
SASHELP.CARS
WHERE make in ('Audi','BMW')
;
RUN;

proc means data=CARS1 STD;
run;

PROC SURVEYMEANS options statistic-keywords ;
BY variables ;
CLASS variables ;
VAR variables ;

proc surveymeans data=CARS1 STD;
class type;
var type horsepower;
ods output statistics=rectangle;
run;
proc print data=rectangle;
run;

proc surveymeans data=CARS1 STD;
var horsepower;
BY make;
ods output statistics=rectangle;
run;
proc print data=rectangle;
run;

PROC FREQ DATA = Dataset ;
TABLES Variable_1 ;
BY Variable_2 ;

PROC SQL;
create table CARS1 as
SELECT make,model,type,invoice,horsepower,length,weight
 FROM 
SASHELP.CARS
WHERE make in ('Audi','BMW')
;
RUN;

proc FREQ data=CARS1 ;
tables horsepower; 
by make;
run;

proc FREQ data=CARS1 ;
tables make type; 
run;

proc FREQ data=CARS1 ;
tables make type; 
weight horsepower;
run;

PROC FREQ DATA = dataset;
TABLES variable_1*Variable_2;

PROC SQL;
create table CARS1 as
SELECT make,type,invoice,horsepower,length,weight
 FROM 
SASHELP.CARS
WHERE make in ('Audi','BMW')
;
RUN;

proc FREQ data=CARS1 ;
tables make*type; 
run;

proc FREQ data=CARS2 ;
tables make * (type model)  / nocol norow nopercent;   
run;


*Cross tabulation of 4 Variables;
proc FREQ data=CARS2 ;
tables (make model) * (length  horsepower)  / nocol norow nopercent;   
run;

PROC TTEST DATA = dataset;
VAR variable;
CLASS Variable;
PAIRED Variable_1 * Variable_2;

PROC SQL;
create table CARS1 as
SELECT make,type,invoice,horsepower,length,weight
 FROM 
SASHELP.CARS
WHERE make in ('Audi','BMW')
;
RUN;

proc ttest data=cars1 alpha=0.05 h0=0;
 	var horsepower;
   run;

   proc ttest data=cars1 ;
    paired weight*length;
   run;

proc ttest data=cars1 sides=2 alpha=0.05 h0=0;
 	title "Two sample t-test example";
 	class make; 
	var horsepower;
   run;

*---SAS - Correlation Analysis---*;
   PROC CORR DATA = dataset options;
VAR variable;

PROC SQL;
create table CARS1 as
SELECT invoice,horsepower,length,weight
 FROM 
SASHELP.CARS
WHERE make in ('Audi','BMW')
;
RUN;

proc corr data=cars1 ;
VAR horsepower weight ;
BY make;
run;

proc corr data=cars1 ;
run;

proc corr data=cars1 plots=matrix ;
VAR horsepower weight ;
run;


PROC REG DATA = dataset;
MODEL variable_1 = variable_2;

PROC SQL;
create table CARS1 as
SELECT invoice,horsepower,length,weight
 FROM 
SASHELP.CARS
WHERE make in ('Audi','BMW')
;
RUN;
proc reg data=cars1;
model horsepower= weight ;
run;

PROC SGPLOT DATA = dataset;
SCATTER X=variable Y=Variable;
REFLINE value;

data mydata;
input new old;
datalines;
31 45
27 12
11 37
36 25
14 8
27 15
3 11
62 42
38 35
20 9
35 54
62 67
48 25
77 64
45 53
32 42
16 19
15 27
22 9
8 38
24 16
59 25
;

data diffs ;
set mydata ;
/* calculate the difference */
diff=new-old ;
/* calculate the average */
mean=(new+old)/2 ;
run ;
proc print data=diffs;
run;

proc sql noprint ;
select mean(diff)-2*std(diff),  mean(diff)+2*std(diff)
into   :lower,  :upper 
from diffs ;
quit;

proc sgplot data=diffs ;
scatter x=mean y=diff;
refline 0 &upper &lower / LABEL =  ("zero bias line" "95% upper limit" "95%
lower limit") ;
TITLE 'Bland-Altman Plot';
footnote 'Accurate prediction with 10% homogeneous error'; 
run ;
quit ;

proc sgplot data=diffs ;
reg x = new y = diff/clm clmtransparency= .5;
needle x= new y=diff/baseline=0;
refline 0 / LABEL =  ('No diff line');
TITLE 'Enhanced Bland-Altman Plot';
footnote 'Accurate prediction with 10% homogeneous error'; 
run ;
quit ;

PROC FREQ DATA = dataset;
TABLES variables 
/CHISQ TESTP=(percentage values);

proc freq data = sashelp.cars;
tables type 
/chisq 
testp=(0.20 0.12 0.18 0.10 0.25 0.15);
run;

proc freq data = sashelp.cars;
tables type*origin 
/chisq 
;
run;

PROC FREQ DATA = dataset ;
TABLES Variable_1*Variable_2 / fisher;
data temp;
input  Test1 Test2 Result @@;
datalines;
1 1 3 1 2 1 2 1 1 2 2 3
;
proc freq; 
tables Test1*Test2 / fisher;
run;

PROC ANOVA dataset ;
CLASS Variable;
MODEL Variable1=variable2 ;
MEANS ;

PROC ANOVA DATA = SASHELPS.CARS;
CLASS type;
MODEL horsepower = type;
RUN;

PROC ANOVA DATA = SASHELPS.CARS;
CLASS type;
MODEL horsepower = type;
MEANS type / tukey lines;
RUN;


 PROC GLM DATA=dataset;
  CLASS variable;
  MODEL variables = group / NOUNI ;
  REPEATED TRIAL n;

DATA temp;
  INPUT person group $ r1 r2 r3 r4;
CARDS;
1 A  2  1  6  5
2 A  5  4 11  9
3 A  6 14 12 10
4 A  2  4  5  8
5 A  0  5 10  9
6 B  9 11 16 13
7 B  12 4 13 14
8 B  15 9 13  8
9 B  6  8 12  5
10 B 5  7 11  9
;
RUN;

PROC PRINT DATA=temp ;
RUN;

 PROC GLM DATA=temp;
  CLASS group;
  MODEL r1-r4 = group / NOUNI ;
  REPEATED trial 5;
RUN;


