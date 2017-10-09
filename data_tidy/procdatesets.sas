*-------------------------DATASETS Procedure----------------------------*;
LIBNAME dest 'SAS-library';
/* RUN group */
proc datasets;
/* RUN group */
  change nutr=fatg;
  delete bldtest;
  exchange xray=chest;
/* RUN group */
  copy out=dest;
  select report;
/* RUN group */
  modify bp;
  label dias='Taken at Noon';
  rename weight=bodyfat;
/* RUN group */
  append base=tissue data=newtiss;
quit;

proc datasets lib=mylib details;
  contents data=table-name;
  run;
quit;

/*PROC DATASETS <option(s)>;*/
/*AGE current-name related-SAS-file(s)*/
/*</ <ALTER=alter-password> <MEMTYPE=member-type>>;*/
/*APPEND BASE=<libref.>SAS-data-set*/
/*  <APPENDVER=V6>*/
/*  <DATA=<libref.>SAS-data-set><ENCRYPTKEY=key-value>*/
/*  <FORCE><GETSORT><NOWARN>;*/
/*AUDIT SAS-file <(SAS-password <ENCRYPTKEY=key-value>*/
/*  <GENNUM=integer>)>;*/
/*INITIATE <AUDIT_ALL=NO | YES>;*/
/*LOG <ADMIN_IMAGE=YES | NO>*/
/*  <BEFORE_IMAGE=YES | NO>*/
/*  <DATA_IMAGE=YES | NO>*/
/*  <ERROR_IMAGE=YES | NO>;*/
/*  <SUSPEND | RESUME | TERMINATE; >*/
/*  <USER_VAR> variable-name-1 <$> <length> <LABEL='variable-label' ><variable-name-2 <$> <length> <LABEL='variable-label' > бн>;*/
/*CHANGE old-name-1=new-name-1<old-name-2=new-name-2 бн>*/
/*  </ <ENCRYPTKEY=key-value>*/
/*  <ALTER=alter-password> */
/*  <GENNUM=ALL | integer> */
/*  <MEMTYPE=member-type>>;*/
/*CONTENTS <option(s)>;*/
/*COPY OUT=libref-1<CLONE | NOCLONE>*/
/*  <CONSTRAINT=YES | NO>*/
/*  <DATECOPY><ENCRYPTKEY=key-value>*/
/*  <FORCE>IN=libref-2<INDEX=YES | NO>*/
/*  <MEMTYPE=(member-type(s))>*/
/*  <MOVE <ALTER=alter-password>>*/
/*  <OVERRIDE=(ds-option-1=value-1 <ds-option-2=value-2 бн> ) >;*/
/*SELECT SAS-file(s)</ <ENCRYPTKEY=key-value> */
/*  <ALTER=alter-password> */
/*  <MEMTYPE=member-type>>;*/
/*DELETE SAS-file(s)*/
/*  </ <ALTER=alter-password>*/
/*  <ENCRYPTKEY=key-value>*/
/*  <GENNUM=ALL | HIST | REVERT | integer>*/
/*  <MEMTYPE=member-type>>;*/
/*EXCHANGE name-1=other-name-1 <name-2=other-name-2 бн>*/
/*  </ <ALTER=alter-password> */
/*  <MEMTYPE=member-type>>;*/
/*  MODIFY SAS-file <(option(s))>*/
/*  </ <CORRECTENCODING=encoding-value>*/
/*  <DTC=SAS-date-time><GENNUM=integer> */
/*  <MEMTYPE=member-type>>;FORMAT variable-1 <format-1><variable-2 <format-2> бн>;*/
/*  IC CREATE <constraint-name=> constraint <MESSAGE='message-string'*/
/*  <MSGTYPE=USER>>;*/
/*  IC DELETE constraint-name(s) | _ALL_;*/
/*  IC REACTIVATE foreign-key-name REFERENCES libref;*/
/*  INDEX CENTILES index(s)</ <REFRESH> <UPDATECENTILES=ALWAYS | NEVER | integer>>;*/
/* run;*/

proc datasets;
  append base=a data=b appendver=v6;
run;

data format1;
input Date date9.;
format Date date9.;
datalines;
24sep1975
22may1952
;
data format2;
input Date datetime20.;
format Date datetime20.;
datalines;
25aug1952:11:23:07.4
;
proc append base=format1 data=format2;
run;

Proc contents data=original out2=icsidx;
run;
proc sql noprint;
select recreate into :recreate from icsidx;
quit;
proc datasets lib=to_lib nolist;
modify model;
recreatm;
quit;
proc contents data=to_lib.model;
run;

*---Creating an Audit File---*;
proc datasets library=mylib;
  audit myfile (alter=password);
  initiate;
run;

proc datasets library=mylib;
  audit myfile (alter=password);
  initiate;
  log data_image=no
  before_image=no
  data_image=no;
run;

proc datasets lib=mylib; /* all audit image types will be logged
  and the file cannot be suspended */
  audit myfile (alter=password);
  initiate audit_all=yes;
quit;

proc datasets lib=mylib;
  audit myfile (alter=password);
  terminate;
quit;

proc datasets memtype=data;
contents data=_all_;
run;

data a;
length aa 7 bb 6 cc $10 dd 8 ee 3;
aa = 1;
bb = 2;
cc = 'abc';
dd = 3;
ee = 4;
ff = 5;
output;
run;
proc contents data=a out=a1;
run;
proc print data=a1(keep=name length varnum npos);
run;


options obs=0 msglevel=i;
proc copy in=old out=lib;
select a;
run;

data lib.new;
  if 0 then set old.a;
  stop;
run;

proc datasets library=source;
  copy out=dest;
run;

proc datasets memtype=(data program);
  copy out=dest;
  select apples / memtype=catalog;
run;

proc datasets library=work memtype=catalog;
  copy in=source out=dest;
  select bodyfat / memtype=data;
run;

proc datasets lib=work;
  copy out=mylib memtype=(data catalog);
  select mydata x1-x10 data2;
run;

options validvarname=any;
data test;
longvar10='aLongVariableName';
retain longvar1-longvar5 0;
run;
options validvarname=v6;
proc copy in=work out=sasuser;
select test;
run;

proc datasets library=mylib;
modify myown;
ic reactivate fkey references mainlib;
run;

proc datasets library=mylib;
audit myfile (alter=password);
initiate;
run;

LIBNAME control 'SAS-library-1';
LIBNAME health 'SAS-library-2';
proc datasets memtype=data;
copy in=control out=health;
run;
proc datasets library=health memtype=data details;
delete syndrome;
change prenat=infant;
run;
quit;


*--------------------------------------Example 1: Removing All Labels and Formats in a Data Set----------------------------------------*;
options ls=79 nodate center;
title ;
libname mylib 'c:\mylib';
proc format;
value clsfmt 1='Freshman' 2='Sophomore' 3='Junior' 4='Senior';
run;
data mylib.class;
format z clsfmt.;
label x='ID NUMBER'
y='AGE'
z='CLASS STATUS';
input x y z;
datalines;
1 20 4
2 18 1
;
proc contents data=mylib.class;
run;
proc datasets lib=mylib memtype=data;
modify class;
attrib _all_ label=' ';
attrib _all_ format=;
contents data=mylib.class;
run;
quit;

*------------------------------------------Example 2: Manipulating SAS Files-------------------------------------------*;
options pagesize=60 linesize=80 nodate pageno=1 source;
LIBNAME dest1 'SAS-library-1';
LIBNAME dest2 'SAS-library-2';
LIBNAME health 'SAS-library-3';
proc datasets library=health details;
delete tension a2(mt=catalog);
change a1=postdrug;
exchange weight=bodyfat;
copy out=dest1 move memtype=view;
select spdata;
select etest1-etest5 / memtype=catalog;
copy out=dest2;
exclude d: mlscl oxygen test2 vision weight;
quit;

*-------------------------------------Example 3: Saving SAS Files from Deletion----------------------------------------*;
options pagesize=40 linesize=80 nodate pageno=1 source;
LIBNAME elder 'SAS-library';
proc datasets lib=elder;
save chronic aging clinics / memtype=data;
run;

*----------------------------------------Example 4: Modifying SAS Data Sets---------------------------------------------*;
LIBNAME health 'SAS-library';
proc datasets library=health nolist;
  modify group (label='Test Subjects' read=green sortedby=lname);
  index create vital=(birth salary) / nomiss unique;
  informat birth date7.;
  format birth date7.;
  label salary='current salary excluding bonus';
  modify oxygen;
  rename oxygen=intake;
  label intake='Intake Measurement';
quit;

*----------------------------------------Example 5: Describing a SAS Data Set------------------------------------------*;
options pagesize=40 linesize=80 nodate pageno=1;
LIBNAME health 'SAS-library';
proc datasets library=health nolist;
contents data=group (read=green) out=grpout;
title 'The Contents of the GROUP Data Set';
run;
quit;

*------------------------------------Example 6: Concatenating Two SAS Data Sets-------------------------------------------*;
options pagesize=40 linesize=64 nodate pageno=1;
LIBNAME exp 'SAS-library';
proc datasets library=exp nolist;
append base=exp.results data=exp.sur force;
run;
proc print data=exp.results noobs;
title 'The RESULTS Data Set';
run;

*-------------------------------Example 7: Aging SAS Data Sets------------------------------------------------------------*;
options pagesize=40 linesize=80 nodate pageno=1 source;
LIBNAME daily 'SAS-library';
proc datasets library=daily nolist;
age today day1-day7;
run;

*----------------------------------------------Example 8: Initiating an Audit File---------------------------------------*;
libname mylib "SAS-library";
data mylib.inventory;
input vendor $10. +1 item $4. +1 description $11. +1 units 4.;
datalines;
SmithFarms F001 Apples 10
Tropicana B002 OrangeJuice 45
UpperCrust C215 WheatBread 25
;
run;
proc datasets lib=mylib;
audit inventory;
initiate;
user_var reason $ 30;
quit;
proc sql;
Insert into mylib.inventory values ('Bordens','B132', 'Milk', 100,
'increase on hand');
Update mylib.inventory set units=10, reason='recounted inventory'
where item='B002';
quit;
proc datasets lib=mylib;
audit inventory;
log admin_image=no;
suspend;
quit;

proc sql;
select * from mylib.inventory(type=audit);
quit;
proc datasets lib=mylib;
audit inventory;
resume;
quit;

proc datasets lib=mylib;
audit inventory;
terminate;
quit;

*--------------------------------------------Example 9: Extended Attributes-------------------------------*;
libname mylib 'C:\mylib';
data mylib.sales;
  purchase="car";
  age=10;
  income=200000;
  kids=3;
  cars=4;
run;

proc datasets lib=mylib nolist;
modify sales;
  xattr add ds role="train" attrib="table";
  xattr add var purchase (role="target" level="nominal")
  age (role="reject")
  income (role="input" level="interval");
  contents data=sales;
  title 'The Contents of the Sales Data Set That Contains Extended Attributes';
run;
quit;

*=======================================================================================================================================*;
*===                                                      DATEKEYS ProcedureOverview                                                 ===*;
*=======================================================================================================================================*;
*A SAS datekey describes a date or time interval that is associated with special events such as holidays and sale periods and time computations.;
proc datekeys;
datekeydef SuperBowl=
'15JAN1967'd '14JAN1968'd '12JAN1969'd '11JAN1970'd
'17JAN1971'd '16JAN1972'd '14JAN1973'd '13JAN1974'd '12JAN1975'd
'18JAN1976'd '09JAN1977'd '15JAN1978'd '21JAN1979'd '20JAN1980'd
'25JAN1981'd '24JAN1982'd '30JAN1983'd '22JAN1984'd '20JAN1985'd
'26JAN1986'd '25JAN1987'd '31JAN1988'd '22JAN1989'd '28JAN1990'd
'27JAN1991'd '26JAN1992'd '31JAN1993'd '30JAN1994'd '29JAN1995'd
'28JAN1996'd '26JAN1997'd '25JAN1998'd '31JAN1999'd '30JAN2000'd
'28JAN2001'd '03FEB2002'd '26JAN2003'd '01FEB2004'd '06FEB2005'd
'05FEB2006'd '04FEB2007'd '03FEB2008'd '01FEB2009'd '07FEB2010'd
'06FEB2011'd '05FEB2012'd '03FEB2013'd '02FEB2014'd '01FEB2015'd
...'07FEB2016'd '05FEB2017'd '04FEB2018'd '03FEB2019'd '02FEB2020'd
/ PULSE=DAY ;

datekeydef GoodFriday=Easter / shift=-2 pulse=day;
datekeykey EasterMonday=Easter / shift=1 pulse=day;
datekeydata out=MyHolidays condense;
run;
options eventds=(MyHolidays);
proc hpfevents data=sashelp.citiday;
id date interval=day start='27JAN1991'd end='01APR1991'd;
eventkey SuperBowl;
eventkey GoodFriday;
eventkey EasterMonday;
eventdata out=MyHolidayEvents condense;
eventdummy out=MyHolidayDates;
run;

*--------------Example 1: Methods for Constructing a Datekeys Definition Data Set----------------------*;
options eventds=(nodefaults);
data TimeSeriesDates(keep=date);
set sashelp.citiday;
format date date.;
run;
data WhiteSaleDates(keep=_name_ _startdate_);
  set TimeSeriesDates;
  _name_='WhiteSale';
  if (month(date)=1) then do;
    if (year(date)=1991 or year(date)=1992) then do;
      if (weekday(date)=6) then do;
          _startdate_=date;
      end;
      else delete;
      end;
    else delete;
    end;
  else delete;
  format _startdate_ date.;
run;
proc print data=WhiteSaleDates;
run;

*-----------------Example 2: Using User-Defined SAS Datekey Keywords Directly in Other-------------------*;
proc datekeys;
  datekeydef Years1991_1992='01JAN1991'd / pulse=year after=(duration=1);
  datekeykey JANUARY / pulse=month;
  datekeydef WhiteSale=JANUARY FRIDAY Years1991_1992 / rule=and;
  datekeydata out=WhiteSaleDefinitions condense;
run;
options eventds=(WhiteSaleDefinitions);
proc hpfdiagnose data=sashelp.citiday
  print=all; 
  id date interval=day;
  forecast snysecm;
  event WhiteSale / required=yes;
  arimax;
run;

*-----------------Example 3: Obtaining a Calendar Variable By Using the DATEKEYS Procedure-----------------*;
options eventds=(nodefaults);
data Year2010;
do date='01JAN2010'd to '31DEC2010'd;
output;
end;
format date date.;
run;
proc datekeys;
datekeydef SuperBowl=
'15JAN1967'd '14JAN1968'd '12JAN1969'd '11JAN1970'd
'17JAN1971'd '16JAN1972'd '14JAN1973'd '13JAN1974'd '12JAN1975'd
'18JAN1976'd '09JAN1977'd '15JAN1978'd '21JAN1979'd '20JAN1980'd
'25JAN1981'd '24JAN1982'd '30JAN1983'd '22JAN1984'd '20JAN1985'd
'26JAN1986'd '25JAN1987'd '31JAN1988'd '22JAN1989'd '28JAN1990'd
'27JAN1991'd '26JAN1992'd '31JAN1993'd '30JAN1994'd '29JAN1995'd
'28JAN1996'd '26JAN1997'd '25JAN1998'd '31JAN1999'd '30JAN2000'd
'28JAN2001'd '03FEB2002'd '26JAN2003'd '01FEB2004'd '06FEB2005'd
'05FEB2006'd '04FEB2007'd '03FEB2008'd '01FEB2009'd '07FEB2010'd
'06FEB2011'd '05FEB2012'd '03FEB2013'd '02FEB2014'd
/ pulse=day;
datekeydef GoodFriday=Easter / shift=-2 pulse=day;
datekeykey EasterMonday=Easter / shift=1 pulse=day;
datekeydata out=MyHolidays condense;
run;
options eventds=(MyHolidays);
proc datekeys data=Year2010;
id date interval=day;
datekeycalendar out=MyHolidaysIn2010;
run;
proc print data=MyHolidaysIn2010(where=(month(date)=2));
run;
proc print data=MyHolidaysIn2010(where=(month(date)=4));
run;


*---------------------------Example 4: Filtering Data Sets By Using the DATEKEYDSOPT Statement-------------------------------*;

