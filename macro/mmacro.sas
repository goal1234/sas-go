/*SAS �꣺9���� SAS ����Ҫ���������֣�������ͺ꺯��*/
/**/
/*ͨ��ʹ��SAS �꣬���Ը�������ά��SAS ���룬�ǳ����������ִ̬�С� һ����˵��ͨ��д�꺯��ִ�д�����Ҫ9������*/
/**/
/*��1����*/
/**/
/*д�ó��򣬲���ȷ�������ܹ���ȷ����*/

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

/*�깦��ʹ����ÿ���ܹ��Զ��������ݼ��ı仯���иı�*/
/**/
/*��2 ����*/
/**/
/*ʹ�ú���������ı��滻*/
/**/
/*������ṩ�ı��滻����������ʹ�ü򵥵ĵ��ʻ��ߴ��飬����Ҫ��εĴ��롣������������Զ���������û��Զ�������%let�������ݲ�����sql ���̲�ʹ�õ��û��Զ�������call symput ����������δ�����������ڳ��������ú����ͨ��&��*/

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

/*SYMBOLGEN ����־�����м�¼���������ν����ġ�*/

/*%let ���������*/
/**/
/*&���ú����*/
/**/
/*SYSDATE9�����*/
/**/
/*�����ʹ�ô�������ά��*/
/**/
/*��3����*/
/**/
/*ʹ�ú꺯�������ݼ������Ʊ�ɴ�д*/

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

/*�꺯���ܹ���ߺ�����Ĺ���*/
/**/
/*��4����*/
/**/
/*��SAS ���ݼ��д��������*/
/**/
/*�ں�����д洢���ݼ��������ǲ���ʹ��%let����Ӧ��ʹ��call symput������ֻ�������ݲ�ʹ�á�*/

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

/*������ܹ������ݼ��л�ȡֵ ��5����*/
/**/
/*����������ں궨����*/

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

/*�궨��ʹ�ô��������Ը���*/
/**/
/*��6����*/
/**/
/*�ں꺯����ʹ�ò���*/

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

%vacation (expenses,ResortName RoomRate) �궨�����ʹ�ò��������ĺʹ��� ��7����

/*�ı�궨�壬Ϊ������ṩĬ��ֵ*/

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
/*�궨�壬������Ҫ��������������Ĭ��ֵ ��8����*/
/**/
/*ʹ��proc sql���������*/

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
/*Sql ���̿��Լ���ͳ�����ʹ���������Щͳ�����ĺ���� ��9����*/
/**/
/*�ں궨����ʹ��%if��%then%else���ִ��������� */

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

/*�궨�����ִ�����������߲��ִ���*/


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

/*����ODS ����excel �ļ�*/
/**/
/*ʹ�� ods html*/

ODS HMTL FILE=��C:\TEMP.XLS��;

PROC PRINT DATA=SASHELP.CLASS; RUN;

ODS HTML CLOSE;

/*ʹ��ods csv*/

ODS CSV FILE=��C:\TEMP.CSV��;

PROC PRINT DATA=SASHELP.CLASS; RUN;

ODS CSV CLOSE;

/*�����ļ���С*/
Ods html

ODS HTML FILE=��TEMP.XLS�� STYLESHEET ;

PROC PRINT DATA=SASHELP.CLASS;

RUN;

ODS HTML CLOSE;

/*ʹ��ods phtml �����ļ���С ODS PHTML FILE=��TEMP.XLS�� STYLESHEET=��TEMP.CSS��;*/

PROC PRINT DATA=SASHELP.CLASS;

RUN;

ODS PHTML CLOSE;

/*�������*/

ODS HTML FILE=��C:\TEMP.XLS��;

PROC PRINT DATA=SASHELP.CLASS;

RUN;

ODS HTML CLOSE;

ODS HTMLCSS FILE=��C:\TEMP.XLS�� STYLESHEET=��TEMP.CSS��; PROC PRINT DATA=SASHELP.CLASS;

RUN;

ODS HTMLCSS CLOSE;

/*Sas ���ݵ�excel*/

libname myxls ��c:\demoA1.xls��;

data myxls.houses;

set sasuser.houses

data myxls.build;

/*SAS ����ת�� proc transpose*/

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

/*���ݷ����ĳ�������*/
/*Logistic �ع����ͨ��outest ������ݼ������ղ���Ԥ��ֵ��*/

proc logistic data=develop des outest=betas1;

model ins=dda ddabal dep depamt cashbk checks;

run;

proc print data=betas1


run;

/*����Ԥ������*/

proc score data=read.new out=scored score=betas1

type=parms;

var dda ddabal dep depamt cashbk checks;

run;

/*����Ԥ��������*/

data scored;

set scored;

P=1/(1+exp(-ins));

run;

/*���Ԥ����*/

proc print data=scored(obs=20);

var p ins dda ddabal dep depamt cashbk checks;

run;

/*����ȱʧֵ��ʶ*/

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

/*��STDIZE �����м���reponly ѡ������滻ȱʧֵ��Method ѡ���������ò�ͬ�Ķ���������Ʃ���ֵ����ֵ�ȵȡ�ע�⣬stdize ֻ����ֵ�ͱ�����*/

proc stdize data=develop1 reponly method=median out=imputed;

var &inputs;

run;
proc print data=imputed(obs=20);

var ccbal miccbal ccpurc miccpurc income miincome hmown mihmown;

run;
