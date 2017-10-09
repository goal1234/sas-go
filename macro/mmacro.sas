/*SAS 宏：9步法 SAS 宏主要包括两部分：宏变量和宏函数*/
/**/
/*通过使用SAS 宏，可以更加容易维护SAS 代码，是程序更加灵活，动态执行。 一般来说，通过写宏函数执行代码需要9个步骤*/
/**/
/*第1步：*/
/**/
/*写好程序，并且确保程序能够正确运行*/

proc means data=expenses mean;

var RoomRate;

run;

proc print data=expenses;

title 'Lowest Priced Hotels in the

EXPENSES Data Set';

footnote 'On June 1, 2003';

var ResortName RoomRate Food;

where RoomRate<=221.109;

run;

/*宏功能使程序每次能够自动根据数据集的变化进行改变*/
/**/
/*第2 步：*/
/**/
/*使用宏变量帮助文本替换*/
/**/
/*宏变量提供文本替换，这样可以使用简单的单词或者词组，不需要大段的代码。宏变量包括：自动宏变量，用户自定义宏变量%let，在数据步或者sql 过程步使用的用户自定义宏变量call symput 。不管是如何创建宏变量，在程序中引用宏变量通过&。*/

options symbolgen;

%let dsn=expenses;

%let varlist=ResortName RoomRate Food;

proc means data=&dsn mean;

var RoomRate;

run;

%let average=221.109;

proc print data=&dsn;

title "Lowest Priced Hotels in the &dsn

Data Set";

footnote "On &sysdate9";

var &varlist;


where RoomRate<=&average;

run;

/*SYMBOLGEN 在日志窗口中记录宏变量是如何解析的。*/

/*%let 创建宏变量*/
/**/
/*&引用宏变量*/
/**/
/*SYSDATE9宏变量*/
/**/
/*宏变量使得代码易于维护*/
/**/
/*第3步：*/
/**/
/*使用宏函数将数据集的名称变成大写*/

options symbolgen;

%let dsn=expenses;

%let varlist=ResortName RoomRate Food;

proc means data=&dsn mean;

var RoomRate;

run;

%let average=221.109;

proc print data=&dsn;

title "Lowest Priced Hotels in the

%upcase(&dsn) Data Set";

footnote "On &sysdate9";

var &varlist;

where RoomRate<=&average;

run;

/*宏函数能够提高宏变量的功能*/
/**/
/*第4步：*/
/**/
/*从SAS 数据集中创建宏变量*/
/**/
/*在宏变量中存储数据集变量，是不能使用%let。而应该使用call symput程序，它只能在数据步使用。*/

options symbolgen;

%let dsn=expenses;

%let varlist=ResortName RoomRate Food;

proc means data=&dsn noprint;

output out=stats mean=avg;

var RoomRate;

run;

data _null_;


set stats;

dt=put(today(),mmddyy10.);

call symput('date',dt);

call symput('average',put(avg,7.2)); run;

proc print data=&dsn;

title "Lowest Priced Hotels in the %upcase(&dsn) Data Set";

footnote "On &date";

var &varlist;

where RoomRate<=&average; run;

/*宏变量能够从数据集中获取值 第5步：*/
/**/
/*将程序放在在宏定义中*/

%let dsn=expenses;

%let varlist=ResortName RoomRate Food; %macro vacation ;

proc means data=&dsn noprint; output out=stats mean=avg;

var RoomRate;

run;

data _null_;

set stats;

dt= put(today(),mmddyy10.);

call symput('date',dt);

call symput('average',put(avg,7.2)); run;

proc print data=&dsn;

title "Lowest Priced Hotels in the %upcase(&dsn) Data Set";

footnote "On &date";

var &varlist;

where RoomRate<=&average; run;


%mend vacation;

options symbolgen mprint;

%vacation

/*宏定义使得代码重用性更好*/
/**/
/*第6步：*/
/**/
/*在宏函数中使用参数*/

%macro vacation(dsn,varlist );

proc means data=&dsn noprint;

output out=stats mean=avg;

var RoomRate;

run;

data _null_;

set stats;

dt=put(today(),mmddyy10.);

call symput('date',dt);

call symput('average',put(avg,7.2)); run;

proc print data=&dsn;

title "Lowest Priced Hotels in the

%upcase(&dsn) Data Set";

footnote "On &date";

var &varlist;

where RoomRate<=&average;

run;

%mend;

options symbolgen mprint;

%vacation (expenses,ResortName RoomRate) 宏定义可以使用参数来更改和代码 第7步：

/*改变宏定义，为宏变量提供默认值*/

%macro vacation(dsn=expenses,varlist=_all_); proc means data=&dsn noprint;

output out=stats mean=avg;

var RoomRate;

run;


data _null_;

set stats;

dt=put(today(),mmddyy10.);

call symput('date',dt);

call symput('average',put(avg,7.2));

run;

proc print data=&dsn;

title "Lowest Priced Hotels in the

%upcase(&dsn) Data Set";

footnote "On &sysdate9";

var &varlist;

where RoomRate<=&average;

run;

%mend;

options symbolgen mprint;

/*%vacation (dsn=hexpenses,varlist=ResortName) %vacation (varlist=ResortName RoundOfGolf) %vacation()*/
/**/
/*宏定义，对于主要参数，可以设置默认值 第8步：*/
/**/
/*使用proc sql创建宏变量*/

%macro vacation(dsn=expenses,varlist=_all_); proc sql noprint;

select mean(RoomRate),

put(today(),mmddyy10.)

into :average, :date

from &dsn;

quit;

proc print data=&dsn;

title "Lowest Priced Hotels in the

%upcase(&dsn) Data Set";

footnote "On &date";

var &varlist;

where RoomRate<=&average;

run;


%mend;

options symbolgen mprint;

/*%vacation (dsn=newexpenses)*/
/**/
/*%vacation (varlist=ResortName)*/
/**/
/*Sql 过程可以计算统计量和创建包含这些统计量的宏变量 第9步：*/
/**/
/*在宏定义中使用%if…%then%else语句执行条件语句 */

%macro vacation(dsn=expenses,varlist=_all_);

proc sql noprint;

select mean(RoomRate),

put(today(),mmddyy10.),

month(today())

into :average,:date,:mon

from &dsn;

%if &mon=6 or &mon =7 or &mon =8 %then %do; proc print data=&dsn;

title "Lowest Priced Hotels in the

%upcase(&dsn) Data Set";

footnote "On &date";

var &varlist;

where RoomRate<=&average;

run;

%end;

%else %do;

proc print data=&dsn;

title "All Room Information in the

%upcase(&dsn) Data Set";

footnote "On &date";

var &varlist;

run;

%end;

%mend;

options symbolgen mprint mlogic;

%vacation( )

/*宏定义可以执行条件语句或者部分代码*/


%macro vacation(dsn=expenses,varlist=_all_); proc sql noprint; select mean(RoomRate),

put(today(),mmddyy10.),

month(today())

into :average,:date,:mon

from &dsn;

proc print data=&dsn;

footnote "On &date";

var &varlist;

%if &mon=6 or &mon=7 or &mon=8 %then %do; title "Lowest Priced Hotels in the

%upcase(&dsn) Data Set";

where RoomRate<=&average;

%end;

%else %do;

title "All Room Information in the

%upcase(&dsn) Data Set";

%end;

run;

%mend;

/*利用ODS 产生excel 文件*/
/**/
/*使用 ods html*/

ODS HMTL FILE=”C:\TEMP.XLS”;

PROC PRINT DATA=SASHELP.CLASS; RUN;

ODS HTML CLOSE;

/*使用ods csv*/

ODS CSV FILE=”C:\TEMP.CSV”;

PROC PRINT DATA=SASHELP.CLASS; RUN;

ODS CSV CLOSE;

/*减少文件大小*/
Ods html

ODS HTML FILE=’TEMP.XLS’ STYLESHEET ;

PROC PRINT DATA=SASHELP.CLASS;

RUN;

ODS HTML CLOSE;

/*使用ods phtml 减少文件大小 ODS PHTML FILE=’TEMP.XLS’ STYLESHEET=”TEMP.CSS”;*/

PROC PRINT DATA=SASHELP.CLASS;

RUN;

ODS PHTML CLOSE;

/*定义界面*/

ODS HTML FILE=’C:\TEMP.XLS’;

PROC PRINT DATA=SASHELP.CLASS;

RUN;

ODS HTML CLOSE;

ODS HTMLCSS FILE=’C:\TEMP.XLS’ STYLESHEET=”TEMP.CSS”; PROC PRINT DATA=SASHELP.CLASS;

RUN;

ODS HTMLCSS CLOSE;

/*Sas 数据到excel*/

libname myxls “c:\demoA1.xls”;

data myxls.houses;

set sasuser.houses

data myxls.build;

/*SAS 数据转置 proc transpose*/

data score;

input Student $9. +1 StudentID $ Section $ Test1 Test2 Final; datalines;


Capalleti 0545 1 94 91 87

Dubose 1252 2 51 65 91

Engles 1167 1 95 97 97

Grant 1230 2 63 75 80

Krupski 2527 2 80 76 71

Lundsford 4860 1 92 40 86

Mcbane 0674 1 75 78 72

;

run ;

proc transpose data = score out = score_transposed;

run ;

proc print data = score_transposed;

run ;

proc transpose data = score out = idnumber name = Test prefix = sn; run ;

proc print data = idnumber noobs;

run ;

proc transpose data = score out = idlabel name = Test prefix = sn; id studentid;

idlabel student;

run ;

proc print data = idlabel label noobs;

run ;

data fishdata;

infile datalines missover;

input Location & $10. Date date7.

Length1 Weight1 Length2 Weight2 Length3 Weight3

Length4 Weight4;

format date date7.;

datalines;

Cole Pond 2JUN95 31 .25 32 .3 32 .25 33 .3

Cole Pond 3JUL95 33 .32 34 .41 37 .48 32 .28

Cole Pond 4AUG95 29 .23 30 .25 34 .47 32 .3

Eagle Lake 2JUN95 32 .35 32 .25 33 .30

Eagle Lake 3JUL95 30 .20 36 .45



Eagle Lake 4AUG95 33 .30 33 .28 34 .42

;

proc transpose data = fishdata out = fishlength(rename = (col1 = Measurement)); var length1-length4;

by location date;

run ;

proc print data = fishlength noobs;

run ;

data stocks;

input Company $14. Date $ Time $ Price;

datalines;

Horizon Kites jun11 opening 29

Horizon Kites jun11 noon 27

Horizon Kites jun11 closing 27

Horizon Kites jun12 opening 27

Horizon Kites jun12 noon 28

Horizon Kites jun12 closing 30

SkyHi Kites jun11 opening 43

SkyHi Kites jun11 noon 43

SkyHi Kites jun11 closing 44

SkyHi Kites jun12 opening 44

SkyHi Kites jun12 noon 45

SkyHi Kites jun12 closing 45

;

proc transpose data = stocks out = close let;

by company;

id date;

run ;

proc print data = close noobs;

run ;

data weights;

input Program $ s1-s7;

datalines;

CONT 85 85 86 85 87 86 87

CONT 80 79 79 78 78 79 78



CONT 78 77 77 77 76 76 77

CONT 84 84 85 84 83 84 85 CONT 80 81 80 80 79 79 80

RI 79 79 79 80 80 78 80

RI 83 83 85 85 86 87 87

RI 81 83 82 82 83 83 82

RI 81 81 81 82 82 83 81

RI 80 81 82 82 82 84 86

WI 84 85 84 83 83 83 84

WI 74 75 75 76 75 76 76

WI 83 84 82 81 83 83 82

WI 86 87 87 87 87 87 86

WI 82 83 84 85 84 85 86

;

data split;

set weights;

array s{7} s1-s7;

Subject + 1;

do Time = 1 to 7;

Strength = s{time};

output;

end;

drop s1-s7;

run ;

proc print data=split noobs;

run ;

proc transpose data = split out = totsplit prefix = Str; by program subject;

copy time strength;

var strength;

run ;

proc print data = totsplit;

run ;

/*数据分析的常见误区*/
/*Logistic 回归过程通过outest 输出数据集的最终参数预测值。*/

proc logistic data=develop des outest=betas1;

model ins=dda ddabal dep depamt cashbk checks;

run;

proc print data=betas1


run;

/*评估预测数据*/

proc score data=read.new out=scored score=betas1

type=parms;

var dda ddabal dep depamt cashbk checks;

run;

/*计算预测后验概率*/

data scored;

set scored;

P=1/(1+exp(-ins));

run;

/*输出预测结果*/

proc print data=scored(obs=20);

var p ins dda ddabal dep depamt cashbk checks;

run;

/*创建缺失值标识*/

proc print data=develop(obs=30);

var ccbal ccpurc income hmown;

run;

data develop1;

set develop;

array mi{*} miacctag miphone mipos miposamt miinv

miinvbal micc miccbal miccpurc miincome mihmown

milores mihmval miage micrscor;

array x{*} acctage phone pos posamt inv invbal cc

ccbal ccpurc income hmown lores hmval age

crscore;

do i=1 to dim(mi);

mi{i}=(x{i}=.);

end;

run;

/*在STDIZE 过程中加入reponly 选项可以替换缺失值。Method 选项用来设置不同的度量方法，譬如均值、中值等等。注意，stdize 只对数值型变量有*/

proc stdize data=develop1 reponly method=median out=imputed;

var &inputs;

run;
proc print data=imputed(obs=20);

var ccbal miccbal ccpurc miccpurc income miincome hmown mihmown;

run;
