
*-----通过分隔符的读入方式有file还有import---*;
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

*1.3 对tab 分隔数据的导入;

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

1.4 对dbf 数据库数据进行导入：

proc import datafile="/myfiles/mydata.dbf"

out=sasuser.mydata

dbms=dbf

replace;

run ;

1.5对excel 数据进行导入：

PROC IMPORT OUT= hospital1

DATAFILE= " C:\My Documents\Excel Files\Hospital1.xls " DBMS=EXCEL REPLACE;

SHEET="Sheet1$";

GETNAMES=YES;

MIXED=NO;

SCANTEXT=YES;

USEDATE=YES;

SCANTIME=YES;

RUN ;

1.6对access 数据进行导入：

PROC IMPORT DBMS=ACCESS TABLE="customers" OUT=sasuser.cust;
DATABASE="c:\demo\customers.mdb"; UID="bob";

PWD="cat";

WGDB="c:\winnt\system32\system.mdb";

RUN ;

proc print data=sasuser.cust; run ;


/*2 导入一个文件夹下的所有文件的数据。*/
/**/
/*2.1下面的代码导入一个文件夹下的所有文件的数据，要使用本代码需注意几点：首先，这个文件夹下的数据文件必须是同一类型分隔的数据，*/
/*比如例子中都是tab 分隔的txt 文件，当然也可以对本代码进行改进，例如中间的proc import的dbms 改为excel ，就可以导入excel 文件了。*/
/*其次，本代码直接将文件名作为SAS 数据集的名字，因此文件名必须是英文，且满足SAS 命名规则。 */
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


*---2.2 这里运用pipe 读取到文件名称，再读取数据。首先建立三个数据集：---*;
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

/**---除了用filename blah pipe 'dir C:\Junk.*.txt /b'*/
/*得到指定类型的文件名，我们还可以%sysexec dir *.x ls /b/o:n > flist.txt;来将xls 文件输出到指定的文件中*/
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

*---读取多个文件中的多个表。这里再介绍一种新的读取多个文件的方法：---*;
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


*---4 从多个文件夹下读取多个数据。---*;
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



*---批量大法---*;


***** 读取一个文件夹下命名无规则的多个excel 文档 *********;

%MACRO GetFileName(DSNAME=,ROUTE=,TYP=) ;/*参数有两个：路径，文件类型后缀

*/

%PUT %STR(----------->DIRNAME=&ROUTE) ;

%PUT %STR(----------->TYP=&TYP) ;

DATA WORK. &DSNAME ;

RC=FILENAME("DIR" , "&ROUTE") ;/*把&DIRNAME值传给文件引用符

“DIR"*/

OPENFILE=DOPEN("DIR" ) ;/*得到路径标示符OPENFILE ，DOPEN 是打开directory 的sas 内置函数*/

IF OPENFILE>0 THEN DO ;/*如果OPENFILE>0表示正确打开路径*/ NUMMEM=DNUM(OPENFILE) ;/*得到路径标示符OPENFILE 中member

的个数nummem*/

DO II=1 TO NUMMEM ;

NAME=DREAD(OPENFILE,II) ;/*用DREAD 依次读取每个文件的名字到

NAME*/

OUTPUT ;/*依次输出*/

END ;

END ;

KEEP NAME ;/*只保留NAME 列*/

RUN ;

PROC SORT data=WORK. &DSNAME; ;/*按照NAME 排序*/

BY DESCENDING NAME ;

%IF &TYP^=ALL %THEN %DO ;/*是否过滤特定的文件类型&TYP*/ WHERE INDEX(UPCASE(NAME),UPCASE(".&TYP")); /*Y,则通过检索NAME 是否包含

&TYP的方式过滤文件类型*/

%END ;

RUN ;

%MEND GetFileName;

%GetFileName (DSNAME=FILE,ROUTE=F:\服务器\数据挖掘\数据堂-数据挖掘竞赛数据集

\Data\behavior\2012-05-07,TYP=TXT);

************ 读取同一个excel 文档里面命名无规则的多个工作表 ****************;

/*去百度原文标题“SAS 批量导入EXCEL 中数据 ”的文章，可以看到程序解释*/

%let dir=F:\SAS\shumo_miss\;

%macro ReadXls (name);

libname excellib excel "&dir.&name";

proc sql noprint; /*创建表 sheetname*/

create table sheetname as

select tranwrd(memname, "''" , "'" ) as sheetname

from sashelp.vstabvw

where libname= "EXCELLIB" ;

select count(DISTINCT sheetname) into :number/*提取excel 文件中的sheet 表的数量*/

from sheetname;

select DISTINCT sheetname into :sheet1 - :sheet%left (&number)/*把每个表都

指定到相应的宏中*/

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

/*表汇总，如果有表格式不统一的话，可以不汇总，要不然数据会出问题*/

proc append base=master data=sheet&i. force;

run;

%end ;

%mend ReadXls;

%ReadXls (no_hege.xls);

********* 逐个对数据集中的变量进行运算 ***********************;

/*proc contents 过程是了解一个数据集的属性，包括这个数据集的系统信息，变量属性等。*/ options mprint mlogic ;

proc contents data =sashelp.class

noprint out =class_variable;

run ;

data class_variable;

set class_variable;

where type=1; /*1代表数值型变量，0代表字符型变量*/

keep NAME;

run ;

%macro DsVar ;

%let dsid=%sysfunc(open(class_variable));

%if &dsid gt 0 %then %do;

%let nobs=%sysfunc(attrn(&dsid,nobs));/*计算数据集行数，如果需要计算列数则把nobs 换为nvars*/

%do i=1 %to &nobs;

%let rc=%sysfunc(fetchobs(&dsid,&i));/*读取指定的第i 条记录到PDV 中，若成功则返回0，返回-1表示已读取完所以记录*/

%let varnume=%sysfunc(varnum(&dsid,name));/*varnum是返回变量name 的位置，在这变量name 是第一列，所以varnume 的值为1*/

%let variable=%sysfunc(getvarc(&dsid,&varnume));/*getvarc是将第i 条记录的第1（因为varnume 的值为1）个变量的值赋给variable ，

此外getvarc 是针对读取字符型的变量，getvarn 是针对读取数值型的变量*/ %put &rc;

%put &varnume;

%put &variable;

proc means data=sashelp.class;/*例子*/

var &variable;

run;

%end;

%let dsid=%sysfunc(close(&dsid));/*关闭数据集*/

%end;

%mend DsVar;

%DsVar ;


