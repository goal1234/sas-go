
PROC CONTENTS statement options
DATA=
OUT=


options pagesize=40 linesize=80 nodate pageno=1;
LIBNAME health 'SAS-library';
proc datasets library=health nolist;
run;
proc contents data=health.group (read=green) out=health.grpout;
title 'The Contents of the GROUP Data Set';
run;
proc contents data=health.grpout;
title 'The Contents of the GRPOUT Data Set';
run;

*---------------------------------------Example 2: Using the DIRECTORY Option----------------------------------*;
/*PROC CONTENTS statement options*/
/*DATA=*/
/*DIRECTORY*/
/*OUT=*/
options pagesize=40 linesize=80 nodate pageno=1;
LIBNAME health 'SAS-library';
proc datasets library=health nolist;
run;
proc contents data=health.group (read=green) directory;
title 'Contents Using the DIRECTORY Option';
run;

*---------------------------------Example 3: Using the DIRECTORY and DETAILS Options---------------------------*;
options pagesize=40 linesize=80 nodate pageno=1;
LIBNAME health 'SAS-library';
proc datasets library=health nolist;
run;
proc contents data=health.groupdirectory details;
title 'Contents Using the DIRECTORY and DETAILS Options';
run;


*------------------------------Example 4: Using the ORDER= Option--------------------------------------------*;
options pagesize=40 linesize=80 nodate pageno=1;
LIBNAME health 'SAS-library';
proc contents data=health.grpout order=collate;
  title 'Contents Using the ORDER= Option';
run;
proc contents data=health.grpout order=varnum;
  title 'Contents Using the ORDER= Option';
run;

*==================================================================================================================================================*
*===                                                        COPY ProcedureOverview                                                              ===*;
*==================================================================================================================================================*;
PROC COPY OUT=libref-1
<CLONE | NOCLONE><CONSTRAINT=YES | NO>
<DATECOPY><ENCRYPTKEY=key-value>
<FORCE>IN=libref-2<INDEX=YES | NO>
<MEMTYPE=(member-type(s))>
<MOVE <ALTER=alter-password>>
<OVERRIDE=(ds-option-1=value-1 <ds-option-2=value-2 …> ) >;
SELECT SAS-file(s)
</ <ENCRYPTKEY=key-value> <ALTER=alter-password> 
<MEMTYPE=member-type>>;

proc copy in=work out=mylib memtype=(data catalog);

*处理过程需要压缩，不过这个步并不支持，用noclone;
options compress=yes;
proc copy in=work out=new noclone;
select x;
run;

*---------------------------------------------Example 1: Copying SAS Data Sets between Hosts--------------------------------*;
PROC COPY statement options
IN=
MEMTYPE=
OUT=
SELECT statement;

libname source 'SAS-library-on-sending-host';
libname xptout xport 'filename-on-sending-host';
proc copy in=source out=xptout memtype=data;
select bonus budget salary;
run;
libname insource xport 'filename-on-receiving-host';
proc copy in=insource out=work;
run;

*--------------------------------------------Example 2: Converting SAS Data Sets Encodings-------------------------------------*;
/*PROC COPY statement options*/
/*IN=*/
/*NOCLONE*/
/*OUT=*/
/*SELECT statement*/
LIBNAME inlib cvp 'SAS-library';
LIBNAME outlib 'SAS-library' outencoding=”encoding value for output”;
proc copy noclone in=inlib out=outlib;
select car;
run;

*-----------------------------------------Example 3: Using PROC COPY to Migrate from a 32-bit to a 64-bit Machine--------------*;
/*PROC COPY statement options*/
/*IN=*/
/*OUT=*/
/*NOCLONE*/
/*SELECTstatement*/

libname source 'SAS-library';
libname target 'SAS-library'
outrep=windows_64;
proc copy in=source out=target NOCLONE;
select data-set-name;
run;

*==============================================================================================================================*;
*===                                                   CPORT Procedure                                                      ===*;
