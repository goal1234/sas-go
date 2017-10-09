
*-----ͨ���ָ����Ķ��뷽ʽ��file����import---*;
data _null_;

file 'c:\temp\pipefile.txt';

put"X1!X2!X3!X4";

put "11!22!.! ";

put "111!.!333!apple";

run ;

proc import

datafile='c:\temp\pipefile.txt'

out=work.test

dbms=dlm

replace;

delimiter='!';

GUESSINGROWS=2000;

DATAROW=2;

getnames=yes;

run ;




data _null_;

file 'c:\temp\csvfile.csv';

put "Fruit1,Fruit2,Fruit3,Fruit4"; put "apple,banana,coconut,date";

put "apricot,berry,crabapple,dewberry"; run ;

proc import

datafile='c:\temp\csvfile.csv'

out=work.fruit

dbms=csv

replace;

run ;

*1.3 ��tab �ָ����ݵĵ���;

data _null_;

file 'c:\temp\tabfile.txt';

put "cereal" "09"x "eggs" "09"x "bacon"; put "muffin" "09"x "berries" "09"x "toast"; run ;

proc import

datafile='c:\temp\tabfile.txt'

out=work.breakfast

dbms=tab
replace;

getnames=no;

run ;

1.4 ��dbf ���ݿ����ݽ��е��룺

proc import datafile="/myfiles/mydata.dbf"

out=sasuser.mydata

dbms=dbf

replace;

run ;

1.5��excel ���ݽ��е��룺

PROC IMPORT OUT= hospital1

DATAFILE= " C:\My Documents\Excel Files\Hospital1.xls " DBMS=EXCEL REPLACE;

SHEET="Sheet1$";

GETNAMES=YES;

MIXED=NO;

SCANTEXT=YES;

USEDATE=YES;

SCANTIME=YES;

RUN ;

1.6��access ���ݽ��е��룺

PROC IMPORT DBMS=ACCESS TABLE="customers" OUT=sasuser.cust;
DATABASE="c:\demo\customers.mdb"; UID="bob";

PWD="cat";

WGDB="c:\winnt\system32\system.mdb";

RUN ;

proc print data=sasuser.cust; run ;


/*2 ����һ���ļ����µ������ļ������ݡ�*/
/**/
/*2.1����Ĵ��뵼��һ���ļ����µ������ļ������ݣ�Ҫʹ�ñ�������ע�⼸�㣺���ȣ�����ļ����µ������ļ�������ͬһ���ͷָ������ݣ�*/
/*���������ж���tab �ָ���txt �ļ�����ȻҲ���ԶԱ�������иĽ��������м��proc import��dbms ��Ϊexcel ���Ϳ��Ե���excel �ļ��ˡ�*/
/*��Σ�������ֱ�ӽ��ļ�����ΪSAS ���ݼ������֣�����ļ���������Ӣ�ģ�������SAS �������� */
%macro directory(dir=);

%let rs=%sysfunc(filename(filref,&dir)); 
%let did=%sysfunc(dopen(&filref)); 
%let nobs=%sysfunc(dnum(&did)); 
%do i=1 %to &nobs.;

%let name=%qscan(%qsysfunc(dread(&did,&i)),1,.); %let ext=%qscan(%qsysfunc(dread(&did,&i)),-1,.);

proc import out=&name. datafile="&dir.\&name..&ext" dbms=tab replace; getnames=no;
datarow=1;

run;

%end;

%let rc=%sysfunc(dclose(&did));

%mend;

%directory (dir=C:\PRIVATE);


*---2.2 ��������pipe ��ȡ���ļ����ƣ��ٶ�ȡ���ݡ����Ƚ����������ݼ���---*;
data _null_;

file 'c:\junk\extfile1.txt';

put "05JAN2001 6 W12301 1.59 9.54";

put "12JAN2001 3 P01219 2.99 8.97";

run ;

data _null_;

file 'c:\junk\extfile2.txt';

put "02FEB2001 1 P01219 2.99 2.99";

put "05FEB2001 3 A00901 1.99 5.97";

put "07FEB2001 2 C21135 3.00 6.00";

run ;

data _null_;

file 'c:\junk\extfile3.txt';


put "06MAR2001 4 A00101 3.59 14.36";

put "12MAR2001 2 P01219 2.99 5.98";

run ;

filename blah pipe 'dir C:\Junk /b';

data _null_;

infile blah truncover end=last;

length fname $20;

input fname;

i+1;

call symput('fname'||trim(left(put(i,8. ))),scan(trim(fname),1,'.')); call symput('pext'||trim(left(put(i,8. ))),trim(fname));

if last then call symput('total',trim(left(put(i,8. ))));

run ;

%macro test ;

%do i=1 %to &total;

proc import datafile="c:\Junk\&&pext&i"

out=work.&&fname&i

dbms=dlm replace;

delimiter=' ';

getnames=no ;

run;

proc print data=work.&&fname&i;;

title &&fname&i;

run;

%end;

%mend;

%test ;

/**---������filename blah pipe 'dir C:\Junk.*.txt /b'*/
/*�õ�ָ�����͵��ļ��������ǻ�����%sysexec dir *.x ls /b/o:n > flist.txt;����xls �ļ������ָ�����ļ���*/
%let dir=C:\ExcelFiles;

%macro ReadXls (inf);

libname excellib excel "&dir.\&inf";

proc sql noprint;

create table sheetname as

select tranwrd(memname, "''", "'") as sheetname

from sashelp.vstabvw

where libname="EXCELLIB";

select count(DISTINCT sheetname) into :cnt_sht

from sheetname;
select DISTINCT sheetname into :sheet1 - :sheet%left (&cnt_sht)

from sheetname;

quit;

libname excellib clear;

%do i=1 %to &cnt_sht;

proc import datafile="&dir.\&inf"

out=sheet&i replace;

sheet="&&sheet&i";

getnames=yes;

mixed=yes;

run;

proc append base=master data=sheet&i force;

run;

%end;

%mend ReadXls;

%ReadXls (all1.xls);

*---��ȡ����ļ��еĶ���������ٽ���һ���µĶ�ȡ����ļ��ķ�����---*;
options noxwait;

%macro ReadXls (dir=);

%sysexec cd &dir; %sysexec dir *.x ls /b/o:n > flist.txt;


data _indexfile;

length filen $200;

infile "&dir./flist.txt";

input filen $;

run;

proc sql noprint;

select count(filen) into :cntfile from _indexfile; %if &cntfile>=1 %then %do;

select filen into :filen1-:filen%left (&cntfile) from _indexfile;

%end;

quit;

%do i=1 %to &cntfile;

libname excellib excel "&dir.\&&filen&i";

proc sql noprint;

create table sheetname as

select tranwrd(memname, "''", "'") as sheetname from sashelp.vstabvw

where libname="EXCELLIB";

select count(DISTINCT sheetname) into :cnt_sht from sheetname;

select DISTINCT sheetname into :sheet1 - :sheet%left (&cnt_sht)



from sheetname;

quit;

%do j=1 %to &cnt_sht;

proc import datafile="&dir.\&&filen&i" out=sheet&j replace;

sheet="&&sheet&j";

getnames=yes;

mixed=yes;

run;

data sheet&j;

length _excelfilename $100 _sheetname $32; set sheet&j;

_excelfilename="&&filen&z";

_sheetname="&&sheet&j";

run;

proc append base=master data=sheet&j force; run;

%end;

libname excellib clear;

%end;

%mend ReadXls;

%readxls (dir=C:\ExcelFiles);


*---4 �Ӷ���ļ����¶�ȡ������ݡ�---*;
%macro etl(ds, ds2,path);

data &ds &ds2;

LENGTH DateTime 8

UserName $ 20

Submit $ 10

SentNumber $ 11

IP $ 15

MessageID $ 15

SendingMode $ 6

Contents $ 160 ;

%let filrf=mydir;

%let rc=%sysfunc(filename(filrf,"&path")); %let did=%sysfunc(dopen(&filrf)); %let memcount=%sysfunc(dnum(&did)); %do i=1 %to &memcount;

AccountNum+1;

%let counter = AccountNum;

%let username&i=%sysfunc(dread(&did,&i)); %let filref=mydir2;

%let file=%sysfunc(filename(filref,"&path\&&username&i"));


%let op=%sysfunc(dopen(&filref));

%let flcount=%sysfunc(dnum(&op));

filename FT77F001 "D:\SMSGatewayData2\USERS\&&username&i\*.log";

%do j=1 %to &flcount;

%let trans&j=%sysfunc(dread(&op,&j));

%put '&&username&i = ' &&username&i '&&trans&j= ' &&trans&j '&flcount = ' &flcount '&filref = ' &filref '&filrf = ' &filrf;

infile FT77F001 filename=filename eov=eov end = done length=L DSD;

INPUT DateTime : ANYDTDTM19.

UserName $

Submit $

SentNumber $

IP $

MessageID $

SendingMode $

Contents $;

output;

%end;

%end;

run;

%mend;

%etl (sms2, sms,D:\SMSGatewayData2\USERS);



*---������---*;


***** ��ȡһ���ļ����������޹���Ķ��excel �ĵ� *********;

%MACRO GetFileName(DSNAME=,ROUTE=,TYP=) ;/*������������·�����ļ����ͺ�׺

*/

%PUT %STR(----------->DIRNAME=&ROUTE) ;

%PUT %STR(----------->TYP=&TYP) ;

DATA WORK. &DSNAME ;

RC=FILENAME("DIR" , "&ROUTE") ;/*��&DIRNAMEֵ�����ļ����÷�

��DIR"*/

OPENFILE=DOPEN("DIR" ) ;/*�õ�·����ʾ��OPENFILE ��DOPEN �Ǵ�directory ��sas ���ú���*/

IF OPENFILE>0 THEN DO ;/*���OPENFILE>0��ʾ��ȷ��·��*/ NUMMEM=DNUM(OPENFILE) ;/*�õ�·����ʾ��OPENFILE ��member

�ĸ���nummem*/

DO II=1 TO NUMMEM ;

NAME=DREAD(OPENFILE,II) ;/*��DREAD ���ζ�ȡÿ���ļ������ֵ�

NAME*/

OUTPUT ;/*�������*/

END ;

END ;

KEEP NAME ;/*ֻ����NAME ��*/

RUN ;

PROC SORT data=WORK. &DSNAME; ;/*����NAME ����*/

BY DESCENDING NAME ;

%IF &TYP^=ALL %THEN %DO ;/*�Ƿ�����ض����ļ�����&TYP*/ WHERE INDEX(UPCASE(NAME),UPCASE(".&TYP")); /*Y,��ͨ������NAME �Ƿ����

&TYP�ķ�ʽ�����ļ�����*/

%END ;

RUN ;

%MEND GetFileName;

%GetFileName (DSNAME=FILE,ROUTE=F:\������\�����ھ�\������-�����ھ������ݼ�

\Data\behavior\2012-05-07,TYP=TXT);

************ ��ȡͬһ��excel �ĵ����������޹���Ķ�������� ****************;

/*ȥ�ٶ�ԭ�ı��⡰SAS ��������EXCEL ������ �������£����Կ����������*/

%let dir=F:\SAS\shumo_miss\;

%macro ReadXls (name);

libname excellib excel "&dir.&name";

proc sql noprint; /*������ sheetname*/

create table sheetname as

select tranwrd(memname, "''" , "'" ) as sheetname

from sashelp.vstabvw

where libname= "EXCELLIB" ;

select count(DISTINCT sheetname) into :number/*��ȡexcel �ļ��е�sheet �������*/

from sheetname;

select DISTINCT sheetname into :sheet1 - :sheet%left (&number)/*��ÿ����

ָ������Ӧ�ĺ���*/

from sheetname;

quit;
%put &number;

libname excellib clear;

%do i=1 %to &number. ;

proc import datafile= "&dir.&name"

out=sheet&i replace; sheet= "&&sheet&i";

getnames=yes;

mixed=yes;

run;

/*����ܣ�����б��ʽ��ͳһ�Ļ������Բ����ܣ�Ҫ��Ȼ���ݻ������*/

proc append base=master data=sheet&i. force;

run;

%end ;

%mend ReadXls;

%ReadXls (no_hege.xls);

********* ��������ݼ��еı����������� ***********************;

/*proc contents �������˽�һ�����ݼ������ԣ�����������ݼ���ϵͳ��Ϣ���������Եȡ�*/ options mprint mlogic ;

proc contents data =sashelp.class

noprint out =class_variable;

run ;

data class_variable;

set class_variable;

where type=1; /*1������ֵ�ͱ�����0�����ַ��ͱ���*/

keep NAME;

run ;

%macro DsVar ;

%let dsid=%sysfunc(open(class_variable));

%if &dsid gt 0 %then %do;

%let nobs=%sysfunc(attrn(&dsid,nobs));/*�������ݼ������������Ҫ�����������nobs ��Ϊnvars*/

%do i=1 %to &nobs;

%let rc=%sysfunc(fetchobs(&dsid,&i));/*��ȡָ���ĵ�i ����¼��PDV �У����ɹ��򷵻�0������-1��ʾ�Ѷ�ȡ�����Լ�¼*/

%let varnume=%sysfunc(varnum(&dsid,name));/*varnum�Ƿ��ر���name ��λ�ã��������name �ǵ�һ�У�����varnume ��ֵΪ1*/

%let variable=%sysfunc(getvarc(&dsid,&varnume));/*getvarc�ǽ���i ����¼�ĵ�1����Ϊvarnume ��ֵΪ1����������ֵ����variable ��

����getvarc ����Զ�ȡ�ַ��͵ı�����getvarn ����Զ�ȡ��ֵ�͵ı���*/ %put &rc;

%put &varnume;

%put &variable;

proc means data=sashelp.class;/*����*/

var &variable;

run;

%end;

%let dsid=%sysfunc(close(&dsid));/*�ر����ݼ�*/

%end;

%mend DsVar;

%DsVar ;


