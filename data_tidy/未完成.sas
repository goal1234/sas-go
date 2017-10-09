*----------------------------------------------DELETE Procedure------------------------------------------*;
*---删除一串数据集;
proc delete data=x1-x3;
run;

*---Example 1: Deleting Several SAS Data Sets---*;
proc delete data=MyLib.A MyLib.B MyLib.C (gennum=all);
run;

*---Example 2: Deleting the Base Version and All Historical Versions---*;
proc delete data=MyLib.A (gennum=all);
run;

*---Example 3: Deleting the Base Version and Renaming the Youngest Historical Version to the Base Version---*;
proc delete data=MyLib.A(gennum=revert1);
run;

*---Example 5: Deleting All Historical Versions and Leaving the Base Version---*;
proc delete data=MyLib.A(gennum=hist);
run;


*---Example 6: Using the MEMTYPE= Option---*;
proc delete lib=MyLib data=MyFile (memtype=catalog);
run;

*---Example 7: Using the ENCRYPTKEY= Option---*;
proc delete lib=MyLib data=MyFile (memtype=catalog);
run;

*---Example 7: Using the ENCRYPTKEY= Option---*;
proc delete data=MyLib.A (gennum=ALL encryptkey=key-value);
run;

*---Example 8: Using the ALTER= Option---*;
proc delete data=MyLib.A (alter=alter-password);
run;

*---Example 9: Using the DATA= List Feature---*;
proc delete data=X1-X5;
run;

*---Example 11: Using the LIBRARY= Option and List Feature---*;
proc delete lib=MyLib data=X1-X5;
run;

*===================================================================================================================*;
*===                                            EXPORT ProcedureOverview                                         ===*;
*===================================================================================================================*;

proc export data=sashelp.class
outfile="c:\myfiles\class"
dbms=dlm replace;
delimiter='&';
run;

*---Example 2: Exporting a Subset of Observations to a CSV File---*;
proc export data=sashelp.class (where=(sex='F'))
outfile="c:\myfiles\Femalelist.csv"
dbms=csv
replace;
run;

*---Example 3: Exporting to a Tab Delimited File with the PUTNAMES= Statement---*;
PROC PRINT DATA=WORK.INVOICE;
RUN;
PROC EXPORT DATA=WORK.INVOICE
OUTFILE="c:\temp\invoice_names.txt"
DBMS=TAB REPLACE;
PUTNAMES=YES;
RUN;
PROC PRINT;
RUN;
PROC EXPORT DATA=WORK.INVOICE
OUTFILE="c:\temp\invoice_data_1st.txt"
DBMS=TAB REPLACE;
PUTNAMES=NO;
RUN;
PROC PRINT;
RUN;


*==================================================================================================================================*;
*===                                             FCMP Procedure                                                                 ===*;
*==================================================================================================================================*;
*The SAS Function Compiler (FCMP) procedure enables you to create, test, and store SAS functions;
option user = work;
proc fcmp outlib=sasuser.MySubs.MathFncs;
function day_date(indate, type $);
if type="DAYS" then wkday=weekday(indate);
if type="YEARS" then wkday=weekday(indate*365);
return(wkday);
endsub;
subroutine inverse(in, inv);
outargs inv;
if in=0 then inv=.;
else inv=1/in;
endsub;
run;

*The function or CALL routine makes a program easier to read, write, and modify.;
proc fcmp outlib=sasuser.funcs.trial;
function study_day(intervention_date, event_date);
n=event_date-intervention_date;
if n <= 0 then
n=n+1;
return(n);
endsub;
options cmplib=sasuser.funcs;
data _null_;
start='15Feb2006'd;
today='27Mar2006'd;
sd=study_day(start, today);
put sd=;
run;

proc fcmp outlib=work.funcs.trial TRACE;
function study_day(intervention_date, event_date);
n=event_date - intervention_date;
if n >= 0 then n=n + 1;
return(n);
endsub;
start='15Feb2010'd;
today='27Mar2010'd;
sd=study_day(start, today);
run;


**---Example 1---**;
proc fcmp;
function fdef1(in);
static x1 1;
if x1 = 1 then do;
x1 = 2;
return(in);
end;
return (in*2);
endfunc;
ans = fdef1( 1);
put "Answer should be 1" ans=;
ans = fdef1( 1);
put "Answer should be 2" ans=;
run;

proc fcmp;
function char_func( in $) $;
length c1 $ 32;
static c1 "Elephant";
if c1 = "Elephant" then
do;
c1 = in || c1;
return (c1);
end;
return( in);
endfunc;
length ans $ 32;
ans = char_func( "Big ");
put "Answer should be >>Big Elephant<<" ans=;
ans = char_func( "Big ");
put "Answer should be >>Big<<" ans=;
run;
quit;

proc fcmp ;
function array_func( in ) ;
array a[5] ;
array foo[5];
static a first 1;
put a[1]= foo[1]=;
If first then do;
do i=1 to dim(a);
a[i]=i;
foo[i]=i;
end;
first =0;
end;
else do;
do i=1 to dim(a);
a[i]=a[i]+1;
end;
end;
put a[5];
return( in);
endfunc;
ans = array_func( 4);
/* should increase by 1 */
ans = array_func( 4);
run;

**Identifying the Location of Compiled Functions**;

*---Example 1: Setting the CMPLIB= System Option;
options cmplib=sasuser.funcs;
options cmplib=(sasuser.funcs work.functions mycat.funcs);
options cmplib=(sasuser.func1 - sasuser.func10);

*--Example 2: Compiling and Using Functions;
proc fcmp outlib=sasuser.models.yval;
function simple(a, b, x);
y=a+b*x;
return(y);
endsub;
run;
options cmplib=sasuser.models nodate ls=80;
data a;
input y @@;
x=_n_;
datalines;
08 06 08 10 08 10
;
proc model data=a;
y=simple(a, b, x);
fit y / outest=est1 out=out1;
quit;

**---Example 3: Identifying the Data Set Name from Where SAS Loaded a Function---*;
proc fcmp outlib=work.myfuncs1.pkg;
function myfunc();
return(1);
endsub;
run;
proc fcmp outlib=work.myfuncs2.pkg;
function myfunc();
return(2);
endsub;
run;
proc fcmp outlib=work.myfuncs3.pkg;
function myfunc();
return(3);
endsub;
run;

option CMPLIB=(myfuncs1-myfuncs3 _DISPLAYLOC_);
proc fcmp;
a = myfunc();
put a=;
run;
/*- turning _DISPLAYLOC_ off -*/
option CMPLIB=(myfuncs1-myfuncs3);
proc fcmp;
a = myfunc();
put a=;
run;
option CMPLIB=(myfuncs1 myfuncs2 _DISPLAYLOC_);
proc fcmp;
a = myfunc();
put a=;
run;
option CMPLIB=_DISPLAYLOC_;
proc fcmp inlib=work.myfuncs1;
a = myfunc();
put a=;
run;
option CMPLIB=_NO_DISPLAYLOC_;
proc fcmp inlib=work.myfuncs1;
a = myfunc();
put a=;
run;

**-------------------------------------------------Examples: FCMP Procedure--------------------------*;
proc fcmp outlib=sasuser.funcs.trial;
function study_day(intervention_date, event_date);
n=event_date - intervention_date;
if n >= 0 then
n=n + 1;
return(n);
endsub;
options cmplib=sasuser.funcs;
data _null_;
start='15Feb2010'd;
today='27Mar2010'd;
sd=study_day(start, today);
put sd=;
run;


**---Example 2: Creating and Saving Functions with PROC FCMP---*;
proc fcmp outlib=sasuser.exsubs.pkt1;
subroutine calc_years(maturity, current_date, years);
outargs years;
years=(maturity - current_date) / 365.25;
endsub;
function garkhprc (type$, buysell$, amount,
E, t, S, rd, rf, sig);
if buysell="Buy" then sign=1.;
else do;
if buysell="Sell" then sign=-1.;
else sign=.;
end;
if type="Call" then
garkhprc=sign * amount
* garkhptprc (E, t, S, rd, rf, sig);
else do;
if type="Put" then
garkhprc=sign * amount
* garkhptprc (E, t, S, rd, rf, sig);
else garkhprc=.;
end;
return(garkhprc);
endsub;
run;

**---Example 3: Using Numeric Data in the FUNCTION Statement---*;
proc fcmp;
function inverse(in);
if n=0 then inv=.;
else inv=1/in;
return(inv);
endsub;
run;

**---Example 4: Using Character Data with the FUNCTION Statement---*;
options cmplib=work.funcs;
proc fcmp outlib=work.funcs.math;
function test(x $) $ 12;
if x='yes' then
return('si si si');
else
return('no');
endsub;
run;
data _null_;
spanish=test('yes');
put spanish=;
run;

**---Example 5: Using Variable Arguments with an Array---*;
options cmplib=sasuser.funcs;
proc fcmp outlib=sasuser.funcs.temp;
function summation (b[*]) varargs;
total=0;
do i=1 to dim(b);
total=total + b[i];
end;
return(total);
endsub;
sum=summation(1, 2, 3, 4, 5);
put sum=;
run;

**---Example 6: Using the SUBROUTINE Statement with a CALL Statement---*;
proc fcmp outlib=sasuser.funcs.temp;
subroutine inverse(in,inv) group="generic";
outargs inv;
if in=0 then inv=.;
else inv=1/in;
endsub;
options cmplib=sasuser.funcs;
data _null_;
x=5;
call inverse(x, y);
put x= y=;
run;

*---Example 7: Using Graph Template Language (GTL) with User-Defined Functions---*;
proc fcmp outlib=sasuser.funcs.curves;
function oscillate(x,amplitude,frequency);
if amplitude le 0 then amp=1; else amp=amplitude;
if frequency le 0 then freq=1; else freq=frequency;
y=sin(freq*x)*constant("e")**(-amp*x);
return (y);
endsub;
function oscillateBound(x,amplitude);
if amplitude le 0 then amp=1; else amp=amplitude;
y=constant("e")**(-amp*x);
return(y);
endsub;
run;
options cmplib=sasuser.funcs;
data range;
do time=0 to 2 by .01;
output;
end;
run;
proc template ;
define statgraph damping;
dynamic X AMP FREQ;
begingraph;
entrytitle "Damped Harmonic Oscillation";
layout overlay / yaxisopts=(label="Displacement");
if (exists(X) and exists(AMP) and exists(FREQ))
bandplot x=X limitlower=eval(-oscillateBound(X,AMP))
limitupper=eval(oscillateBound(X,AMP));
seriesplot x=X y=eval(oscillate(X,AMP,FREQ));
endif;
endlayout;
endgraph;
end;
run;
proc sgrender data=range template=damping;
dynamic x="Time" amp=10 freq=50 ;
run;

**---Example 8: Standardizing Each Row of a Data Set---*;
data numbers;
drop i j;
array a[5];
do j=1 to 5;
do i=1 to 5;
a[i] = ranuni(12345) * (i+123.234);
end;
output;
end;
run;
%macro standardize;
%let dsname=%sysfunc(dequote(&dsname));
%let colname=%sysfunc(dequote(&colname));
proc standard data=&dsname mean=&MEAN std=&STD out=_out;
var &colname;
run;
data &dsname;
set_out;
run;
%mend standardize;
proc fcmp outlib=sasuser.ds.functions;
subroutine standardize(x[*], mean, std);
outargs x;
rc=write_array('work._TMP_', x, 'x1');
dsname='work._TMP_';
colname='x1';
rc=run_macro('standardize', dsname, colname, mean, std);
array x2[1]_temporary_;
rc=read_array('work._TMP_', x2);
if dim(x2)=dim(x) then do;
do i=1 to dim(x);
x[i]=x2[i];
end;
end;
endsub;
run;
options cmplib=(sasuser.ds);
data numbers2;
set numbers;
array a[5];
array t[5]_temporary_;
do i=1 to 5;
t[i]=a[i];
end;
call standardize(t, 0, 1);
do i=1 to 5;
a[i]=t[i];
end;
output;
run;
proc print data=work.numbers2;
run;

*=====================================================================================================================*;
*===                                   FCMP Special Functions and Call Routines                                    ===*;
*=====================================================================================================================*;

*ADDMATRIX CALL;
options pageno=1 nodate;
proc fcmp;
array mat1[3,2] (0.3, -0.78, -0.82, 0.54, 1.74, 1.2);
array mat2[3,2] (0.2, 0.38, -0.12, 0.98, 2, 5.2);
array result[3,2];
call addmatrix(mat1, mat2, result);
call addmatrix(2, mat1, result);
put result=;
quit;

*CHOL CALL routine;
options pageno=1 nodate;
proc fcmp;
array xx[3,3] 2 2 3 2 4 2 3 2 6;
array yy[3,3];
call chol(xx, yy, 0);
do i=1 to 3;
put yy[i, 1] yy[i, 2] yy[i, 3];
end;
run;

*DET CALL routine:;
options pageno=1 nodate;
proc fcmp;
array mat1[3,3] (.03, -0.78, -0.82, 0.54, 1.74,
1.2, -1.3, 0.25, 1.49);
call det(mat1, result);
put result=;
quit;

*Example;
proc fcmp;
function avedev_wacky(data[*]);
length=dim(data);
array temp[1] /nosymbols;
call dynamic_array(temp, length);
mean=0;
do i=1 to length;
mean += data[i];
if i>1 then temp[i]=data[i-1];
else temp[i]=0;
end;
mean=mean/length;
avedev=0;
do i=1 to length;
avedev += abs((data[i])-temp[i] /2-mean);
end;
avedev=avedev/length;
return(avedev);
endsub;
array data[10];
do i = 1 to 10;
data[i] = i;
end;
avedev = avedev_wacky(data);
run;

*CALL ELEMMULT Routine;
options pageno=1 nodate;
proc fcmp;
array mat1[3,2] (0.3, -0.78, -0.82, 0.54, 1.74, 1.2);
array mat2[3,2] (0.2, 0.38, -0.12, 0.98, 2, 5.2);
array result[3,2];
call elemmult(mat1, mat2, result);
call elemmult(2.5, mat1, result);
put result=;
quit;

*CALL EXPMATRIX Routine;
options pageno=1 nodate;
proc fcmp;
array mat1[3,3] (0.3, -0.78, -0.82, 0.54, 1.74,
1.2, -1.3, 0.25, 1.49);
array result[3,3];
call expmatrix(mat1, 3, result);
put result=;
quit;

*CALL FILLMATRIX Routine;
proc fcmp;
array mat1[3, 2] (0.3, -0.78, -0.82, 0.54, 1.74, 1.2);
call fillmatrix(mat1, 99);
put mat1=;
quit;
*CALL IDENTITY Routine;
proc fcmp;
array mat1[3,3] (0.3, -0.78, -0.82, 0.54, 1.74, 1.2,
-1.3, 0.25, 1.49);
call identity(mat1);
put mat1=;
quit;

*CALL INV Routine;
options pageno=1 nodate;
proc fcmp;
array mat1[3,3] (0.3, -0.78, -0.82, 0.54, 1.74,
1.2, -1.3, 0.25, 1.49);
array result[3,3];
call inv(mat1, result);
put result=;
quit;

*CALL MULT Routine;
options pageno=1 nodate;
proc fcmp;
array mat1[2,3] (0.3, -0.78, -0.82, 0.54, 1.74, 1.2);
array mat2[3,2] (1, 0, 0, 1, 1, 0);
array result[2,2];
call mult(mat1, mat2, result);
put result=;
quit;

*CALL POWER Routine;
options pageno=1 nodate;
proc fcmp;
array mat1[3,3] (0.3, -0.78, -0.82, 0.54, 1.74,
1.2, -1.3, 0.25, 1.49);
array result[3,3];
call power(mat1, 3, result);
put result=;
quit;

*CALL STRUCTINDEX Routine;
proc proto package=sasuser.mylib.str2;
struct point{
short s;
int i;
long l;
double d;
};
struct point_array {
int length;
struct point p[2];
char name[32];
};
run;

options pageno=1 nodate ls=80 ps=64;
proc fcmp libname=sasuser.mylib;
struct point_array pntarray;
struct point pnt;
pntarray.length=2;
pntarray.name="My funny structure";
/* Get each element using the STRUCTINDEX CALL routine and set values. */
do i=1 to 2;
call structindex(pntarray.p, i, pnt);
put "Before setting the" i "element: " pnt=;
pnt.s=1;
pnt.i=2;
pnt.l=3;
pnt.d=4.5;
put "After setting the" i "element: " pnt=;
end;
run;

*CALL SUBTRACTMATRIX Routine;
options pageno=1 nodate;
proc fcmp;
array mat1[3,2] (0.3, -0.78, -0.82, 0.54, 1.74, 1.2);
array mat2[3,2] (0.2, 0.38, -0.12, 0.98, 2, 5.2);
array result[3,2];
call subtractmatrix(mat1, mat2, result);
call subtractmatrix(2, mat1, result);
put result=;
quit;

*CALL TRANSPOSE Routine;
options pageno=1 nodate;
proc fcmp;
array mat1[3,2] (0.3, -0.78, -0.82, 0.54, 1.74, 1.2);
array result[2,3];
call transpose(mat1, result);
put result=;
quit;

*CALL ZEROMATRIX Routine;
options pageno=1 nodate;
proc fcmp;
array mat1[3,2] (0.3, -0.78, -0.82, 0.54, 1.74, 1.2);
call zeromatrix(mat1);
put mat1=;
quit;

*INVCDF Function;

*---Example: Generating a Random Sample from an Exponential Distribution---*;
proc fcmp library=work.mycdf outlib=work.myquantile.functions;
function exp_quantile(cdf, theta, rc);
outargs rc;
array opts[4] / nosym(0.1 1.0e-8 .);
q=invcdf("exp_cdf", opts, cdf, theta);
rc=opts[4]; /* return code */
return(q);
endsub;
quit;

proc fcmp outlib=work.mycdf.functions;
function exp_cdf(x, theta);
return(1.0 - exp(-x/Theta));
endsub;
quit;

options cmplib=(work.mycdf work.myquantile);

data exp_sample(keep=q);
n=0;k=0;
do k=1 to 500;
if (n=100) then leave;
rcode=.;
q=exp_quantile(rand('UNIFORM'), 50, rcode);
if (rcode <= 0) then do;
n=n+1;
output;
end;
end;
run;

**---ISNULL Function---**;
*Example 1: Generating a Linked List;
struct linklist{
double value;
struct linklist * next;
};
struct linklist * get_list(int);

proc proto package=sasuser.mylib.str2;
struct linklist{
double value;
struct linklist * next;
};

struct linklist * get_list(int);
externc get_list;
struct linklist * get_list(int len){
int i;
struct linklist * list=0;
list=(struct linklist*)
malloc(len*sizeof(struct linklist));
for (i=0;i<len-1;i++){
list[i].value=i;
list[i].next=&list[i+1];
}
list[i].value=i;
list[i].next=0;
return list;
}
externcend;
run;
options pageno=1 nodate ls=80 ps=64;
proc fcmp libname=sasuser.mylib;
struct linklist list;
list=get_list(3);
put list.value=;
do while (^isnull(list.next));
list=list.next;
put list.value=;
end;
run;

**---LIMMOMENT Function---**;
options cmplib=(work.mycdf work.mylimmom);
data _null_;
do order=1 to 3;
rcode=.;
m=logn_limmoment(order, 100, 5, 0.5, rcode);
if (rcode > 0) then
put "ERROR: Limited moment could not be computed.";
else
put 'Moment of order ' order ' with limit 100 = ' m;
end;
run;

*READ_ARRAY Function;
options nodate pageno=1;
data account;
input acct price cost;
datalines;
1 2 3
4 5 6
;
run;

proc fcmp;
array x[2,3] / nosymbols;
rc=read_array('account',x);
put x=;
run;
proc fcmp;
array x[2,2] / nosymbols;
rc=read_array('account', x, 'price', 'acct');
put x=;
run;

*--RUN_MACRO Function--*;
*Example 1: Executing a Predefined Macro with PROC FCMP;
/* Create a macro called %TESTMACRO. */
%macro testmacro;
%let p=%sysevalf(&a - &b);
%mend testmacro;
/* Use %TESTMACRO within a function in PROC FCMP to subtract two numbers. */
proc fcmp outlib=sasuser.ds.functions;
function subtract_macro(a, b);
rc=run_macro('testmacro', a, b, p);
if rc eq 0 then return(p);
else return(.);
endsub;
run;
/* Make a call from the DATA step. */
option cmplib=(sasuser.ds);
data _null_;
a=5.3;
b=0.7;
p=.;
p=subtract_macro(a, b);
put p=;
run;

**--Example 2: Comparing Results from the RUN_MACRO and the DOSUBL Functions---*;
/* Create a macro called %TESTMACRO. */
%macro testmacro;
%let p=%sysevalf(&a - &b);
%mend testmacro;
/* Use %TESTMACRO within a function in PROC FCMP to subtract two numbers. */
proc fcmp outlib=sasuser.ds.functions;
function subtract_macro(a, b);
rc=run_macro('testmacro', a, b, p);
if rc eq 0 then return(p);
else return(.);
endsub;
run;
/* Make a call from the DATA step. */
option cmplib=(sasuser.ds);
data _null_;
a=5.3;
b=0.7;
p=.;
p=subtract_macro(a, b);
put p= '(RUN_MACRO function and a DATA step)';
run;
%global a b p;
%put p=&p;
/* The value should not yet be known. */
%let a=5.3;
%let b=0.7;
data _null_;
rc=dosubl('%testmacro');
run;
%put p=&p (DOSUBL function);

**---Example 3: Executing a DATA Step within a DATA Step---**;
/* Create a macro called APPEND_DS. */
%macro append_ds;
/* Character values that are passed to RUN_MACRO are put */
/* into their corresponding macro variables inside of quotation */
/* marks. The quotation marks are part of the macro variable value. */
/* The DEQUOTE function is called to remove the quotation marks. */
%let dsname=%sysfunc(dequote(&dsname));
data &dsname
%if %sysfunc(exist(&dsname)) %then %do;
modify &dsname;
%end;
Name=&Name;
WageCategory=&WageCategory;
WageRate=&WageRate;
output;
stop;
run;
%mend append_ds;
/* Call the APPEND_DS macro from function writeDataset in PROC FCMP. */
proc fcmp outlib=sasuser.ds.functions;
function writeDataset (DsName $, Name $, WageCategory $, WageRate);
rc=run_macro('append_ds', dsname, DsName, Name, WageCategory, WageRate);
return(rc);
endsub;
run;
/* Use the DATA step to separate the salaries data set into four separate */
/* departmental data sets (NAD, DDG, PPD, and STD). */
data salaries;
input Department $ Name $ WageCategory $ WageRate;
datalines;
BAD Carol Salaried 20000
BAD Beth Salaried 5000
BAD Linda Salaried 7000
BAD Thomas Salaried 9000
BAD Lynne Hourly 230
DDG Jason Hourly 200
DDG Paul Salaried 4000
PPD Kevin Salaried 5500
PPD Amber Hourly 150
PPD Tina Salaried 13000
STD Helen Hourly 200
STD Jim Salaried 8000
;
run;

options cmplib=(sasuser.ds) pageno=1 nodate;
data _null_;
set salaries;
by Department;
length dsName $ 64;
retain dsName;
if first.Department then do;
dsName='work.' || trim(left(Department));
end;
rc=writeDataset(dsName, Name, WageCategory, wageRate);
run;

proc print data=work.BAD; run;
proc print data=work.DDG; run;
proc print data=work.PPD; run;
proc print data=work.STD; run;

*RUN_SASFILE Function;
/* test.sas(a,b,c) */
data _null_;
call symput('p', &a * &b);
run;
/* Set a SAS fileref to point to the data set. */
filename myfileref "test.sas";
/* Set up a function in PROC FCMP and call it from the DATA step. */
proc fcmp outlib=sasuser.ds.functions;
function subtract_sasfile(a, b);
rc=run_sasfile('myfileref', a, b,
p);
if rc=0 then return(p);
else return(.);
endsub;
run;

options cmplib=(sasuser.ds);
data _null_;
a=5.3;
b=0.7;
p=.;
p=subtract_sasfile(a, b);
put p=;
run;

**---SOLVE Function---**;
*Example 1: Computing a Square Root Value;
options pageno=1 nodate ls=80 ps=64;
proc fcmp;
/* define the function */
function inversesqrt(x);
return(1/sqrt(x));
endsub;
y=20;
x=solve("inversesqrt", {.}, y, .);
put x;
run;

*Example 2: Calculating the Garman-Kohlhagen Implied Volatility;
proc fcmp;
function garkhprc(type$, buysell$, amount, E, t, S, rd, rf, sig)
kind=pricing label='FX option pricing';
if buysell='Buy' then sign=1.;
else do;
if buysell='Sell' then sign=-1.;
else sign=.;
end;
if type='Call' then
garkhprc=sign*amount*(E+t+S+rd+rf+sig);
else do;
if type='Put' then
garkhprc=sign*amount*(E+t+S+rd+rf+sig);
else garkhprc=.;
end;
return(garkhprc);
endsub;
subroutine gkimpvol(n, premium[*], typeflag[*], amt_lc[*],
strike[*], matdate[*], valudate, xrate,
rd, rf, sigma);
outargs sigma;
array solvopts[1] initial (0.20);
sigma=0;
do i=1 to n;
maturity=(matdate[i] - valudate) / 365.25;
stk_opt=1./strike[i];
amt_opt=amt_lc[i] * strike[i];
price=premium[i] * amt_lc[i];
if typeflag[i] eq 0 then type="Call";
if typeflag[i] eq 1 then type="Put";
/* solve for volatility */
sigma=sigma + solve("GARKHPRC", solvopts, price,
type, "Buy", amt_opt, stk_opt,
maturity, xrate, rd, rf, .);
end;
sigma=sigma / n;
endsub;
run;

**---Example 3: Calculating the Black-Scholes Implied Volatility---**;
options pageno=1 nodate ls=80 ps=64;
proc fcmp;
opt_price=5;
strike=50;
today='20jul2010'd;
exp='21oct2010'd;
eq_price=50;
intrate=.05;
time=exp - today;
array opts[5] initial abconv relconv maxiter status
(.5 .001 1.0e-6 100 -1);
function blksch(strike, time, eq_price, intrate, volty);
return(blkshclprc(strike, time/365.25,
eq_price, intrate, volty));
endsub;
bsvolty=solve("blksch", opts, opt_price, strike,
time, eq_price, intrate, .);
put 'Option Implied Volatility:' bsvolty
'Initial value: ' opts[1]
'Solve status: ' opts[5];
run;

*WRITE_ARRAY;
options nodate pageno=1 ls=80 ps=64;
proc fcmp;
array x[4,5] (11 12 13 14 15 21 22 23 24 25 31 32 33 34 35 41 42 43 44 45);
rc=write_array('work.numbers', x);
run;

*Example 2: Using the WRITE_ARRAY Function to Specify Column Names;
options pageno=1 nodate ps=64 ls=80;
proc fcmp;
array x[2,3] (1 2 3 4 5 6);
rc=write_array('numbers2', x, 'col1', 'col2', 'col3');
run;
proc print data=numbers2;
run;

*=======================================================================================================================*;
*===                                     FCmp Function EditorIntroduction                                           ====*;
*=======================================================================================================================*;







