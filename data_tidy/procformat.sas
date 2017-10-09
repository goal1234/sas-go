
*==================================================================================================================*;
*===                                    FORMAT Procedure                                                        ===*;
*==================================================================================================================*;

PROC FORMAT <option(s)>;
EXCLUDE entry(s);
INVALUE <$>name <(informat-option(s))> <value-range-set(s)>;
PICTURE name <(format-option(s))><value-range-set-1 <(picture-1-option(s))><value-range-set-2 <(picture-2-option(s))>> ¡­>;
SELECT entry(s);
VALUE <$>name <(format-option(s))> <value-range-set(s)>;

*Example 1: Create a Character Informat for Raw Data Values;
invalue $gender 'F'='1'
'M'='2';

*Example 2: Create Character and Numeric Values or a Range of Values;
invalue trial 'A'-'M'=1
'N'-'Z'=2
1-3000=3;

*Example 3: Create an Informat Using _ERROR_ and _SAME_;
invalue check 1-4=_same_
99=.
other=_error_;

*---Building a Picture Format: Step by Step---*;
data sample;
input Amount;
datalines;
-2.051
-.05
-.017
0
.093
.54
.556
6.6
14.63
0.996
-0.999
-45.00
;
run;
proc sort data=sample;
by amount;
run;
proc print data=sample;
title 'Default Printing of the Variable Amount';
run;

libname library 'SAS-library';
proc format;
picture nozerosR (round fuzz=0)
low - -1 = '000.00' (prefix='-')
-1 < - < -.99 = '0.99' (prefix='-' mult=100)
-0.99 <-< 0 = '99' (prefix='-.' mult=100)
0 = '9.99'
0 < -< .99 = '99' (prefix='.' mult=100)
0.99 - < 1 = '0.99' (mult=100)
1 - high = '09.99';
picture nozeros (fuzz=0)
low - -1 = '000.00' (prefix='-')
-1 < - < -.99 = '0.99' (prefix='-.' mult=100)
-0.99 <-< 0 = '99' (prefix='-.' mult=100)
0 = '9.99'
0 < -< .99 = '99' (prefix='.' mult=100)
0.99 - < 1 = '0.99' (prefix='.' mult=100)
1 - high = '09.99';
run;

proc print data=sample;
format amount nozerosr.;
title 'Formatting the Variable Amount';
title2 'with the NOZEROSR. Format Using Rounding';
run;
proc print data=sample;
format amount nozeros.;
title 'Formatting the Variable Amount';
title2 'with the NOZEROS. Format, No Rounding';
run;

*Using a Function to Format Values;
/* Create a function that creates the value Qx from a formatted value. */
proc fcmp outlib=work.functions.smd;
function qfmt(date) $;
length qnum $4;
qnum=put(date,yyq4.);
if substr(qnum,3,1)='Q'
then return(substr(qnum,3,2));
else return(qnum);
endsub;
run;
/* Make the function available to SAS. */
options cmplib=(work.functions);
/* Create a format using the function created by the FCMP procedure. */
proc format;
value qfmt
other=[qfmt()]; run;
/* Use the format in a SAS program. */
data djia2013;
input closeDate date7. close;
datalines;
01jan13 800.86
02feb13 7062.93
02mar13 7608.92
01apr13 8168.12
01may13 8500.33
01jun13 8447.00
01jul13 9171.61
03aug13 9496.28
01sep13 9712.28
01oct13 9712.73
02nov13 10344.84
02dec13 10428.05
run;
proc print data=djia2013;
format closedate qfmt. close dollar9.;
run;

***----Example 1: Create the Example Data Set---***;
libname proclib 'SAS-library';
data proclib.staff;
infile datalines dlm='#';
input Name & $16. IdNumber $ Salary
Site $ HireDate date8.;
format hiredate date8.;
datalines;
Capalleti, Jimmy# 2355# 21163# BR1# 30JAN13
Chen, Len# 5889# 20976# BR1# 18JUN06
Davis, Brad# 3878# 19571# BR2# 20MAR04
Leung, Brenda# 4409# 34321# BR2# 18SEP94
Martinez, Maria# 3985# 49056# US2# 10JAN93
Orfali, Philip# 0740# 50092# US2# 16FEB03
Patel, Mary# 2398# 35182# BR3# 02FEB90
Smith, Robert# 5162# 40100# BR5# 15APR06
Sorrell, Joseph# 4421# 38760# US1# 19JUN11
Zook, Carla# 7385# 22988# BR3# 18DEC10
;

*---Example 2: Creating a Picture Format---*;
libname proclib 'SAS-library-1';
libname library 'SAS-library-2';
options nodate pageno=1 linesize=80 pagesize=40;
proc format library=library;
picture uscurrency low-high='000,000' (mult=1.61 prefix='$');
run;
proc print data=proclib.staff noobs label;
label salary='Salary in U.S. Dollars';
format salary uscurrency.;
title 'PROCLIB.STAFF with a Format for the Variable Salary';
run;

*---Example 3: Creating a Picture Format for Large Dollar Amounts---*;
proc format;
picture bigmoney (fuzz=0)
1E06-<1000000000='0000 M' (prefix='$' mult=.000001)
1E09-<1000000000000='0000 B' (prefix='$' mult=1E-09)
1E12-<1000000000000000='0000 T' (prefix='$' mult=1E-012);
run;
data mult;
do i=5 to 12;
x=16**i;
put x=comma20. x= bigmoney.;
end;
run;

proc format;
picture bigmoney (fuzz=0)
1E06-<1000000000='0000 M' (prefix='$' mult=.000001)
1E09-<1000000000000='0000 B' (prefix='$' mult=1E-09)
1E12-<1000000000000000='0000 T' (prefix='$' mult=1E-012);
run;

data mult;
do i=5 to 12;
x=16**i;
put x=comma20. x= bigmoney.;
end;
run;

proc format;
picture bigmoney (fuzz=0)
1E06-<1000000000='0000.99 M' (prefix='$' mult=.0001)
1E09-<1000000000000='0000.99 B' (prefix='$' mult=1E-07)
1E12-<1000000000000000='0000.99 T' (prefix='$' mult=1E-010);
run;
data mult;
do i=5 to 12;
x=16**i;
put x=comma20. x= bigmoney.;
end;
run;

**---Example 4: Filling a Picture Format---**;
data pay;
input Name $ MonthlySalary;
datalines;
Liu 1259.45
Lars 1289.33
Kim 1439.02
Wendy 1675.21
Alex 1623.73
;
proc format;
picture salary low-high='00,000,000.00' (fill='*' prefix='$');
run;
proc print data=pay noobs;
format monthlysalary salary.;
title 'Printing Salaries for a Check';
run;

**---------------------------------Example 5: Change the 24¨CHour Clock to 00:00:01¨C24:00:00-------------------**;
proc format;
picture hour (default=19)
other='%Y-%0m-%0d %0H:%0M:%0S' (datatype=datetime_util);
run;
data _null_;
x = '01jul2015:00:00:01'dt; put x=hour.;
x = '01jul2015:00:00:00'dt; put x=hour.;
run;

**----------------------------Example 6: Creating a Format for Character Values------------------------------**;
libname proclib 'SAS-library-1';
libname library 'SAS-library-2';
proc format library=library;
value $city 'BR1'='Birmingham UK'
'BR2'='Plymouth UK'
'BR3'='York UK'
'US1'='Denver USA'
'US2'='Miami USA'
other='INCORRECT CODE';
run;
proc print data=proclib.staff noobs label;
label salary='Salary in U.S. Dollars';
format salary uscurrency. site $city.;
title 'PROCLIB.STAFF with a Format for the Variables';
title2 'Salary and Site';
run;


**---Example 7: Creating a Format for Missing and Nonmissing Variable Values---*;
options obs=20;
proc format;
value myfmt .='n/a' other=[5.1];
run;
proc sort data=education;
by region;
run;
proc print data=education;
by region;
var state dropOutRate mathScore;
format mathScore myfmt.;
run;

**---Example 8: Creating a Format Using Perl Regular Expressions---*;
proc format;
invalue isnum (default=5) '/[0-9]/' (regexp) = _same_ other=_error_;
invalue x1to2x(default=5) 's/1/2/' (regexpe) = _same_ other=_same_;
run;
data _null_;
input x:isnum. y:x1to2x.;
put x= y=;
datalines;
1 121
2 145
a 232
run;

**---Example 9: Writing a Format for Dates Using a Standard SAS Format and a Color Background---*;
libname proclib 'SAS-library-1';
libname library 'SAS-library-2';
proc format library=library;
value benefit
low-'31DEC2008'd=[worddate20.]
'01JAN2008'd-high=' ** Not Eligible **';
value color;
low-'31DEC2008'd='light green'
'01JAN2009'd-high='light red';
run;
proc print data=proclib.staff noobs label;
var name idnumber salary site;
var hiredate /style=[background=color.];
label salary='Salary in U.S. Dollars';
format salary uscurrency. site $city. hiredate benefit.;
title 'PROCLIB.STAFF with a Format for the Variables';
title2 'Salary, Site, and HireDate';
run;

**----------------------Example 10: Converting Raw Character Data to Numeric Values--------------**;
libname proclib 'SAS-library-1';
libname library 'SAS-library-2';
proc format library=library;
invalue evaluation 'O'=4
'S'=3
'E'=2
'C'=1
'N'=0;
run;
data proclib.points;
input EmployeeId $ (Q1-Q4) (evaluation.,+1);
TotalPoints=sum(of q1-q4);
datalines;
2355 S O O S
5889 2 2 2 2
3878 C E E E
4409 0 1 1 1
3985 3 3 3 2
0740 S E E S
2398 E E C C
5162 C C C E
4421 3 2 2 2
7385 C C C N
;
proc print data=proclib.points noobs;
title 'The PROCLIB.POINTS Data Set';
run;

data proclib.points;
input EmployeeId $ (Q1-Q4) (evaluation.,+1);
TotalPoints=sum(of q1-q4);
datalines;
2355 S O O S
5889 2 2 2 2
3878 C E E E
4409 0 1 1 1
3985 3 3 3 2
0740 S E E S
2398 E E C C
5162 C C C E
4421 3 2 2 2
7385 C C C N
;

**------------------------------------------Example 11: Creating a Format from a CNTLIN= Data Set--------------------------**;
data scale;
input begin: $char2. end: $char2. amount: $char2.;
datalines;
0 3 0%
4 6 3%
7 8 6%
9 10 8%
11 16 10%
;
data ctrl;
length label $ 11;
set scale(rename=(begin=start amount=label)) end=last;
retain fmtname 'PercentageFormat' type 'n';
output;
if last then do;
hlo='O';
label='***ERROR***';
output;
end;
run;
proc print data=ctrl noobs;
title 'The CTRL Data Set';
run;

**------------------------------------------Example 12: Creating an Informat from a CNTLIN= Data Set---------------------------------------**;
proc format;
invalue mytest
'abc'=1
'xyz'=2
other=3;
invalue $chrtest
'abc'='xyz'
other='else';
run;

data _null_;
input value:mytest. @@;
put value=;
datalines;
abc xyz ghi 4
run;

data _null_;
input value:$chrtest. @@;
put value=;
datalines;
abc xyz ghi 4
run;

data temp;
length start $8 type $1 hlo $1;
fmtname='newtest'; type='i';
start='abc'; label=1; hlo=' '; output;
start='xyz'; label=2; hlo=' '; output;
start=' '; label=3; hlo='O'; output;
run;

data temp;
length start label $8 type $1 hlo $1;
fmtname='$newchr'; type='j';
start='abc'; label='xyz'; hlo=' '; output;
start=' '; label='else'; hlo='O'; output;
run;

proc format cntlin=temp; run;
data _null_;
input value:newtest. @@;
put value=;
datalines;
abc xyz ghi 4
run;
data _null_;
input value:$newchr. @@;
put value=;
datalines;
abc xyz ghi 4
run;

data temp;
length start label $8 hlo $1;
fmtname='@new2test';
start='abc'; label='1'; hlo=' '; output;
start='xyz'; label='2'; hlo=' '; output;
start=' '; label='3'; hlo='O'; output;
fmtname='@$new2chr';
start='abc'; label='xyz'; hlo=' '; output;
start=' '; label='else'; hlo='O'; output;
run;
proc format cntlin=temp; run;
data _null_;
input value:new2test. @@;
put value=;
datalines;
abc xyz ghi 4
run;
data _null_;
input value:$new2chr. @@;
put value=;
datalines;
abc xyz ghi 4
run;

proc print data=temp noobs;
title 'The CTRL Data Set';
run;

**------------------Example 13: Printing the Description of Informats and Formats-----------------**;
libname library 'SAS-library';
proc format library=library fmtlib;
select @evaluation benefit;
title 'FMTLIB Output for the BENEFIT. Format and the';
title2 'EVALUATION. Informat';
run;


**-------------Example 14: Retrieving a Permanent Format----------------------------**;
libname proclib 'SAS-library';
proc format library=proclib;
picture nozeros (fuzz=0)
low - -1 = '000.00'(prefix='-')
-1 < - < -.99 = '0.99' (prefix='-.' mult=100)
-0.99 < - < 0 = '99' (prefix='-.' mult=100)
0 = '0.99'
0 < - < .99 = '99' (prefix='.' mult=100)
0.99 - <1 = '0.99' (prefix='.' mult=100)
1 - high = '00.99';
run;
options fmtsearch=(proclib);
data sample;
input Amount;
datalines;
-2.051
-.05
-.017
0
.093
.54
.556
6.6
14.63
0.996
-0.999
-45.00
;
run;
proc print data=sample;
format amount nozeros.;
title1 'Retrieving the NOZEROS. Format from PROCLIB.FORMATS';
title2 'The SAMPLE Data Set';
run;

**---Example 15: Writing Ranges for Character Strings---**;
libname proclib'SAS-library';
data train;
set proclib.staff(keep=name idnumber);
run;
proc print data=train noobs;
title 'The TRAIN Data Set without a Format';
run;

**---Example 16: Creating a Format in a non-English Language---**;
proc format;
picture mdy(default=8) other='%0d%0m%Y' (datatype=date);
picture langtsda (default=50) other='%A, %d %B, %Y' (datatype=date);
picture langtsdt (default=50) other='%A, %d,%B, %Y %H %M %S'
(datatype=datetime);
picture langtsfr (default=50) other='%A, %d %B, %Y %H %M %S'
(datatype=datetime language=french);
picture alltest (default=100)
other='%a %A %b %B %d %H %I %j %m %M %p %S %w %U %y %%'
(datatype=datetime);
run;option locale = de_DE;
data _null_ ;
a= 18903;
b = 1633239000;
put a= mdy.;
put a= langtsda.;
put b= langtsdt.;
put b= langtsfr.;
put b= alltest.;
run ;

**--------------------------Example 17: Creating a Locale-Specific Format Catalog-------------------**;
/*no locale information*/
proc format lib=work.formats;
value age low - 5 = 'baby'
6 - 12 = 'child'
13 - 15 = 'teen'
16 - 30 = 'youth'
31 - 50 = 'midlife'
51 - high = 'older';
run;
options locale=ro_RO;
proc format lib = work.formats locale;
value age low - 5 = 'Copil'
6 - 12 = 'Copil'
13 - 15 = 'Adolescent'
16 - 30 = 'Tineretului'
31 - 50 = 'Asta vrei'
51 - high = 'Mai vechi';
run;
options fmtsearch=(work/locale);
/* Set the locale back to English(US) */
options locale=en_US;
data datatst;
input age sex $;
attrib age format= age.;
cards;
5 M
6 F
12 M
13 F
15 M
16 F
30 M
35 F
51 M
100 F
;
run;
/* Use the English format catalog*/
title "Locale is English, Use the Original Format Catalog";
proc print data=datatst; run;
/* Use the Romanian format catalog*/
options locale=ro_RO;
title 'Locale is ro_RO, Use the Romanian Format Catalog';
proc print data=datatst;run;


**----Example 18: Creating a Function to Use as a Format---**;
proc fcmp outlib=library.functions.smd;
function ctof(c) $;
return(cats(((9*c)/5)+32,'F'));
endsub;
function ftoc(f) $;
return(cats((f-32)*5/9,'C'));
endsub;
run;
options cmplib=(library.functions);
data _null_;
f=ctof(100);
put f=;
run;
proc format;
value ctof (default=10) other=[ctof()];
value ftoc (default=10) other=[ftoc()];
run;
data _null_;
c=100;
put c=ctof.;
f=212;
put f=ftoc.;
run;


**---Example 19: Using a Format to Create a Drill-down Table---**;
data mydata;
format population comma12.0;
label st='State';
label population='Population';
input st $ 1-2 population;
year=2000;
datalines;
VA 7078515
NC 8049313
SC 4012012
GA 8186453
FL 15982378
;
run;
proc format;
value $COMPND
'VA'='<a href=http://www.va.gov>VA</a>'
'NC'='<a href=http://www.nc.gov>NC</a>'
'SC'='<a href=http://www.sc.gov>SC</a>'
'GA'='<a href=http://www.ga.gov>GA</a>'
'FL'='<a href=http://www.fl.gov>FL</a>';
run;
ods html file="c:\mySAS\html\Drilldown.htm"
(title="An ODS HTML Drill-down Table Using a User-defined Format in the PRINT
Procedure");
title h=.25in "Year 2000 U.S. Census Population";
title2 color=gray "An ODS HTML Drill-down Table Using a User-defined Format in
the PRINT Procedure";
footnote color=gray "(Click the underlined text to drill down.)";
options nodate;
proc print data=mydata label noobs;
var st population;
format st $compnd. ;
run;
ods html close;
ods html;




