option user = work;
options threads=yes cpucount=2 compress=yes;  *进行了多核运算;

libname proclib "F:\sas-go\doc\data";
*================COMPARE ProcedureOverview======================*;
data proclib.one(label='First Data Set');
input student year $ state $ gr1 gr2;
label year='Year of Birth';
format gr1 4.1;
datalines;
1000 1990 NC 85 87
1042 1991 MS 90 92
1095 1989 TN 78 92
1187 1990 MA 87 94
;
data proclib.two(label='Second Data Set');
input student $ year $ state $ gr1
gr2 major $;
label state='Home State';
format gr1 5.2;
datalines;
1000 1990 NC 85 87 Math
1042 1991 MS 90 92 History
1095 1989 TN 78 92 Physics
1187 1990 MA 87 94 Music
1204 1991 NC 82 96 English
;

data inone intwo inboth;
merge a (in=ina) b(in=inb);
by byvar;
if ina and not inb then output inone;
if inb and not ina then output intwo;
if ina and inb then output inboth;
run;

*option里有参数METHOD= option<exact,ABSOLUTE,RELATIVE,PERCENT>对于后面的三个参数用CRITERION= Option来确认后面的运算数;
PROC COMPARE <option(s)>;
  BY <DESCENDING> variable-1
     <<DESCENDING> variable-2 …>
     <NOTSORTED>;ID <DESCENDING> variable-1
     <<DESCENDING> variable-2 …>
     <NOTSORTED>;
VAR variable(s);
WITH variable(s);

*Summary of Optional Arguments;
*细节控制：ALLOBS ALLSTATS ALLVARS BRIEFSUMMARY FUZZ=number MAXPRINT=total | (per-variable, total) NODATE .NOPRINT .NOSUMMARY NOVALUES PRINTALL STATS TRANSPOSE;
*list控制:LISTALL LISTBASE LISTBASEOBS LISTOBS...;
*输出控制:OUT=SAS-data-set OUTALL OUTBASE OUTPERCENT OUTCOMP。。。;

proc compare base=SAS-data-set
compare=SAS-data-set;
run;
%if &sysinfo >= 64 %then
%do;
handle error;
%end;

/*diff label -- RC is 32*/
data class1;
set sashelp.class;
label sex='Gender';
run;
data class2;
set sashelp.class;
run;
proc compare base=class1 comp=class2;
run;
%let rc=&sysinfo;
%put 'RC' &rc;
/*diff label and value -- RC is 4128*/
data class1;
set sashelp.class;
label sex='Gender';
run;
data class2;
set sashelp.class;
if name="Jeffrey" then name="Jeff";
run;
proc compare base=class1 comp=class2;
run;
%let rc=&sysinfo;
%put 'RC' &rc;


proc compare base=SAS-data-set
compare=SAS-data-set;
run;
%let rc=&sysinfo;
data _null_;
/* Test for data set label */
if &rc = '1'b then
put '<<<< Data sets have different labels';
/* Test for data set types */
if &rc = '1.'b then
put '<<<< Data set types differ';
/* Test for label */
if &rc = '1.....'b then
put '<<<< Variable has different label';
/* Test for base observation */
if &rc = '1......'b then
put '<<<< Base data set has observation not in comparison data set';
/* Test for length */
if &rc = '1....'b then
put '<<<< Variable has different lengths between the base data set
and the comparison data set';
/* Variable in base data set not in compare data set */
if &rc ='1..........'b then
put '<<<< Variable in base data set not found in comparison data set';
/* Comparison data set has variable not in base data set */
if &rc = '1...........'b then
put '<<<< Comparison data set has variable not contained in the
base data set';
/* Test for values */
if &rc = '1............'b then
put '<<<< A value comparison was unequal';
/* Conflicting variable types */
if &rc ='1.............'b then
put '<<<< Conflicting variable types between the two data sets
being compared';
run;


options nodate pageno=1 linesize=80 pagesize=60;
proc compare base=proclib.one compare=proclib.two;
run;

options nodate pageno=1
linesize=80 pagesize=60;
proc compare base=proclib.one
compare=proclib.two allstats;
title 'Comparing Two Data Sets: Default Report';
run;

options nodate pageno=1
linesize=80 pagesize=60;
proc compare base=proclib.one
compare=proclib.two transpose;
title 'Comparing Two Data Sets: Default Report';
run;


*----------------------------Example 1: Producing a Complete Report of the Differences--------------------------*;
libname proclib 'SAS-library';
options nodate pageno=1 linesize=80 pagesize=40;
proc compare base=proclib.one compare=proclib.two printall;
  title 'Comparing Two Data Sets: Full Report';
run;

*--------------------------Example 2: Comparing Variables in Different Data Sets---------------------------------*;
libname proclib 'SAS-library';
options nodate pageno=1 linesize=80 pagesize=40;
proc compare base=proclib.one compare=proclib.two nosummary;
  var gr1;
  with gr2;
  title 'Comparison of Variables in Different Data Sets';
run;

*------------------------Example 3: Comparing a Variable Multiple Times-------------------------------------------*;
libname proclib 'SAS-library';
options nodate pageno=1 linesize=80 pagesize=40;
proc compare base=proclib.one compare=proclib.two nosummary;
  var gr1 gr1;
  with gr1 gr2;
  title 'Comparison of One Variable with Two Variables';
run;

*------------------------Example 4: Comparing Variables That Are in the Same Data Set------------------------------*;
libname proclib 'SAS-library';
options nodate pageno=1 linesize=80 pagesize=40;
proc compare base=proclib.one allstats briefsummary;
  var gr1;
  with gr2;
  title 'Comparison of Variables in the Same Data Set';
run;

*-----------------------Example 5: Comparing Observations with an ID Variable-------------------------------------*;
libname proclib 'SAS-library';
options nodate pageno=1 linesize=80 pagesize=40;
data proclib.emp95;
input #1 idnum $4. @6 name $15.
      #2 address $42.
     #3 salary 6.;
datalines;
2388 James Schmidt
100 Apt. C Blount St. SW Raleigh NC 27693
92100
2457 Fred Williams
99 West Lane Garner NC 27509
33190
... more data lines...
3888 Kim Siu
5662 Magnolia Blvd Southeast Cary NC 27513
77558
;

data proclib.emp96;
input #1 idnum $4. @6 name $15.
#2 address $42.
#3 salary 6.;
datalines;
2388 James Schmidt
100 Apt. C Blount St. SW Raleigh NC 27693
92100
2457 Fred Williams
99 West Lane Garner NC 27509
33190
...more data lines...
6544 Roger Monday
3004 Crepe Myrtle Court Raleigh NC 27604
47007
;

proc sort data=proclib.emp95 out=emp95_byidnum;
by idnum;
run;
proc sort data=proclib.emp96 out=emp96_byidnum;
by idnum;
run;
proc compare base=emp95_byidnum compare=emp96_byidnum;
id idnum;
title 'Comparing Observations that Have Matching IDNUMs';
run;


*-----Example 6: Comparing Values of Observations Using an Output Data Set (OUT=)----------------------*;
libname proclib 'SAS-library';
options nodate pageno=1 linesize=120 pagesize=40;
proc sort data=proclib.emp95 out=emp95_byidnum;
by idnum;
run;
proc sort data=proclib.emp96 out=emp96_byidnum;
by idnum;
run;
proc compare base=emp95_byidnum compare=emp96_byidnum
out=result outnoequal outbase outcomp outdif
noprint;
id idnum;
run;
proc print data=result noobs;
by idnum;
id idnum;
title 'The Output Data Set RESULT';
run;

*---------------------------------------Example 7: Creating an Output Data Set of Statistics (OUTSTATS=)--------------------------------*;
libname proclib 'SAS-library';
options nodate pageno=1 linesize=80 pagesize=40;
proc sort data=proclib.emp95 out=emp95_byidnum;
    by idnum;
run;
proc sort data=proclib.emp96 out=emp96_byidnum;
    by idnum;
run;
proc compare base=emp95_byidnum compare=emp96_byidnum
    outstats=diffstat noprint;
    id idnum;
run;
proc print data=diffstat noobs;
    title 'The DIFFSTAT Data Set';
run;



