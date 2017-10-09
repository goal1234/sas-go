data sasuser.houses;
input style $ 1-9 sqfeet 10-13 bedrooms 15 baths 17-19 street $ 21-36 price 38-44;
datalines;
RANCH 1250 2 1.0 Sheppart Avenue 64000
SPLIT 1190 1 1.0 Rand Street 65850
CONDO 1400 2 1.5 Market Street 80050
TWOSTORY 1810 4 3.0 Garris Street 107250
RANCH 1500 3 3.0 Kemble Avenue 86650
SPLIT 1615 4 3.0 West Drive 94450
SPLIT 1305 3 1.5 Graham Avenue 73650
CONDO 1390 3 2.5 Hampshire Avenue 79650
TWOSTORY 1040 2 1.0 Sanders Road 55850
CONDO 2105 4 2.5 Jeans Avenue 127150
RANCH 1535 3 3.0 State Highway 89100
TWOSTORY 1240 2 1.0 Fairbanks Circle 69250
RANCH 720 1 1.0 Nicholson Drive 34550
TWOSTORY 1745 4 2.5 Highland Road 102950
CONDO 1860 2 2.0 Arcata Avenue 110700
run;

*---修改了字段的属性---*;
proc datasets lib=sasuser memtype=data;
modify houses;
attrib price format=dollar8.;
run;
proc print data=sasuser.houses;
run;

*---通过申明的方式排序---*;
proc sort data = sasuser.houses out = houses;  *覆盖了原来的数据;
    by style;
run;
proc freq data = houses;
  by style;
  tables bedrooms/nopercent;
run;

*---放在前面进行降---*;
proc sort data=sasuser.houses out=houses;
  by descending style;    *降序在前，函数式的声明;
run;
proc freq data=houses;
  by descending style;
  tables bedrooms /nopercent;
run;

*---一个分类均值的过程---*;
proc means data = sasuser.houses nawy mean;  *是means而非mean;
  class style;
  var sqfeet;
run;

*---0.1透视表---*;
proc tabulate data=sasuser.houses format=3. noseps;  *多个分类;
  class style bedrooms;
  table style*bedrooms, n / rts=23;
run;

*---0.2透视表加入order按钮---*;
proc tabulate data=sasuser.houses format=3. noseps order=freq;
  class style bedrooms;
  table style*bedrooms, n / rts=23;
run;

*---用format进行分组---*;
proc format;
  value numf 0,3,4='GROUP A'
             1,2='GROUP B';
proc report data=sasuser.houses;
  column bedrooms;
  define bedrooms / group format=numf. order=internal;
run;

*---一个更长的format---*;
data sample;
  length dept $ 5;
  input dept id;
  datalines;
  PET 100
  PET 110
  PET 120
  PET 199 
  PLANT 200
  PLANT 210
  PLANT 220
  PLANT 299
;
proc format;
  value idfmt
    100='CAT'
    110='DOG'
    120='FISH'
    199='OTHER'
    200='CACTUS'
    210='IVY'
    220='FERN'
    299='OTHER';
proc tabulate data=sample noseps;
  class dept id;
  table dept*id, n;
  format id idfmt.;  *--通过透视表中的一个开关;
run;

*---对于空值的格式---*;
proc format;
  value bedfmt 1='ONE' 2='TWO' other='OTHER';
data houses;
  set sasuser.houses end=last;
  output;
  if last then do;
    bedrooms=.;
    output;
  end;
    format bedrooms bedfmt.;
run;
proc print data=houses;
  title "PROC PRINT";
  title2 "WORK.HOUSES";
  var bedrooms;
  format bedrooms;
run;
proc freq data=houses;
  title1 "PROC FREQ";
  title2 "Without MISSING Specified";
  tables bedrooms / nocum nopercent;
run;
proc report data=houses;
  title1 "PROC REPORT";
  title2 "Without MISSING Specified";
  column beddrooms n;
  define bedrooms /group width=8;
run;

*---freq 和report用了两种不同的格式---*;
proc freq data=houses;
  title1 "PROC FREQ";
  title2 "With MISSING Specified";
  tables bedrooms / nocum nopercent missing ;
run;
proc report data=houses missing;
  title1 "PROC REPORT";
  title2 "With MISSING Specified";
  column bedrooms n;
  define bedrooms / group width=8;
run;

*---order作为开关---*;
*---可以用来计数用---*;
proc tabulate data=sasuser.houses order=data format=3. noseps;
  class style;
  table style, n;
run;

proc tabulate data=sasuser.houses order=data format=3. noseps;
  class style bedrooms;
  table style*bedrooms, n;
run;

*---1.0准备数据---*;
data groc;
  input Region $9. Manager $ Department $ Sales;
  datalines;
  Southeast Hayes Paper 250
Southeast Hayes Produce 100
Southeast Hayes Canned 120
Southeast Hayes Meat 80
Northeast Fuller Paper 200
Northeast Fuller Produce 300
Northeast Fuller Canned 420
Northeast Fuller Meat 125
;

*---1.1排序相关数据---*;
proc sort data=groc;
  by region department; *这个by不开心，没有高亮;
run;

*---1.2图形开关---*;
options nobyline nodate pageno=1
linesize=64 pagesize=20;
proc chart data=groc;
  by region department;
  vbar manager / type=sum sumvar=sales;
  title1 'This chart shows #byval2 sales';
  title2 'in the #byval(region)..';
run;
options byline;

*---print中两个title2---*;
proc print data=proclib.payroll(obs=10)
  noobs;
  title 'PROCLIB.PAYROLL';
  title2 'First 10 Observations Only';
run;


*------------------------------------------------------------APPEND PROCEDURE-----------------------*;
*-------------开关语句:base中可以有（drop,keep,rename)像指针一样的方式;
/*PROC APPEND BASE=<libref.>SAS-data-set*/
/*<APPENDVER=V6>*/
/*<DATA=<libref.>SAS-data-set>*/
/*<ENCRYPTKEY=key-value>*/
/*<FORCE>*/
/*<GETSORT>*/
/*<NOWARN>;*/

*-----一个列子-----*;
proc append base=dataset1 data=dataset2(obs=0);
run;
proc contents data=dataset1;
run;
quit;

*---exp1---*;
options pagesize=40 linesize=64 nodate pageno=1;    *nodate将在输出中不显示日期,pageno从第几页开始;
LIBNAME exp 'SAS-library';
proc append base=exp.results data=exp.sur force;    *force将搬运即使没有的数据;
run;
proc print data=exp.results noobs;                  *noobs将不显示变量;
title 'The Concatenated RESULTS Data Set';
run;
quit;

option user = work;
*----exp2---*;
data mtea;
  length var1 8.;
  stop;
run;
data phull;
  length var1 8.;
  do var1=1 to 100000;                            *输出了一个序列感觉;
  output;
  end;
run;

proc sort data=phull;
  by DESCENDING var1;
run;

proc append base=mtea data=phull getsort;    *原来数据就会被覆盖了;
run;

ods select sortedby;                          *打印内容到了屏幕上;
proc contents data=mtea;
run;
data mysort(sortedby=var1);                  *然而这个可以直接调节;
length var1 8.;
do var1=1 to 10;
output;
end;
run;

*---打印在屏幕上---*;
ods select sortedby;
proc contents data=mysort;
run;
quit;

data mysort;
  length var1 8.;
  do var1=1 to 10;
  output;
  end;
run;
proc sort data=mysort;
  by var1;
run;

ods select sortedby;
proc contents data=mysort;
run;
quit;


*------------------------------------------------------AUTHLIB Procedure-------------------------------------------*;
*Metadata-Bound LibrariesPROC元数据管理;
*暂时未添加;
*-----------------------------------------------------CALENDAR Procedure-------------------------------------------*;
*形成一个日历数据，;
*---或者说是自己画了一个日历---*;
proc calendar data=allacty;
  start date;
  dur long;
run;

data cale;
input _sun_ $ _mon_ $ _tue_ $ _wed_ $ _thu_ $ /
_fri_ $ _sat_ $ _cal_ $ d_length time6.;
datalines;
holiday workday workday workday workday
workday holiday calone 8:00
holiday shift1 shift1 shift1 shift1
shift2 holiday caltwo 9:00
;


options formchar="|----|+|---+=|-/\<>*";      *在执行之前是重要的;

*输入一个数据---*;

data allacty;
input date : date7. event $ 9-36 who $ 37-48 long;
datalines;
01JUL02 Dist. Mtg. All 1
17JUL02 Bank Meeting 1st Natl 1
02JUL02 Mgrs. Meeting District 6 2
11JUL02 Mgrs. Meeting District 7 2
03JUL02 Interview JW 1
08JUL02 Sales Drive District 6 5
15JUL02 Sales Drive District 7 5
08JUL02 Trade Show Knox 3
22JUL02 Inventors Show Melvin 3
11JUL02 Planning Council Group II 1
18JUL02 Planning Council Group III 1
25JUL02 Planning Council Group IV 1
12JUL02 Seminar White 1
19JUL02 Seminar White 1
18JUL02 NewsLetter Deadline All 1
05JUL02 VIP Banquet JW 1
19JUL02 Co. Picnic All 1
16JUL02 Dentist JW 1
24JUL02 Birthday Mary 1
25JUL02 Close Sale WYGIX Co. 2
;
*----创建一个时间的数据集---*;
data hol;
input date : date7. holiday $ 11-25 holilong @27;
datalines;
05jul02 Vacation 3
04jul02 Independence 1
;
proc sort data=allacty;
by date;
run;
options formchar="|----|+|---+=|-/\<>*";
proc calendar data=allacty holidata=hol weekdays;
start date;
dur long;
holistart date;
holivar holiday;
holidur holilong;
title1 'Summer Planning Calendar: Julia Cho';
title2 'President, Community Bank';
run;


*************************************************CATALOG Procedure**********************************;
*建立目录册文件;
/*PROC CATALOG CATALOG=<libref.>catalog*/
/*<ENTRYTYPE=entry-type><FORCE> <KILL>;*/
/*CONTENTS <OUT=SAS-data-set> <FILE=fileref>;*/
/*COPY OUT=<libref.>catalog <option(s)>;*/
/*SELECT entry-1 <entry-2 …> </ ENTRYTYPE=entry-type >;*/
/*EXCLUDE entry-1 <entry-2 …> </ ENTRYTYPE=entry-type>;*/
/*CHANGE old-name-1=new-name-1<old-name-2=new-name-2 …></ ENTRYTYPE=entry-type>;*/
/*EXCHANGE name-1=other-name-1<name-2=other-name-2 …></ ENTRYTYPE=entry-type>;*/
/*DELETE entry-1 <entry-2 …> </ ENTRYTYPE=entry-type>;*/
/*MODIFY entry (DESCRIPTION=<<'>entry-description<'>>)</ ENTRYTYPE=entry-type>;*/
/*SAVE entry-1 <entry-2 …> </ ENTRYTYPE=entry-type >;*/
