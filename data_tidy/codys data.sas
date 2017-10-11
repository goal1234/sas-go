*----------------------------------------------------------*
|PROGRAM NAME: PATIENTS.SAS in C:\BOOKS\CLEAN |
|PURPOSE: To create a SAS data set called PATIENTS |
*----------------------------------------------------------*;
libname clean "c:\books\clean";
data clean.patients;
  infile "c:\books\clean\patients.txt" truncover /* take care of problems
                                                    with short records */;
  input @1 Patno $3.
        @4 Gender $1.
        @5 Visit mmddyy10.
        @15 Hr 3.
        @18 SBP 3.
        @21 DBP 3.
        @24 Dx $3.
        @27 AE $1.;
  LABEL Patno = "Patient Number"
        Gender = "Gender"
        Visit = "Visit Date"
        HR = "Heart Rate"
        SBP = "Systolic Blood Pressure"
        DBP = "Diastolic Blood Pressure"
        Dx = "Diagnosis Code"
        AE = "Adverse Event?";
  format visit mmddyy10.;
run;

/*Using PROC FREQ to List All the Unique Values for Character Variables*/
title ' Frequency Counts for Selected Character Variables';
proc freq data = clean.patients;
  table Gender Dx AE / nocum nopercent;
run;

/* Using the Keyword _CHARACTER_ in the TABLES Statement*/
title "Frequency Counts for Selected Character Variables";
proc freq data=clean.patients(drop=Patno);
tables _character_ / nocum nopercent;
run;

/*Using a DATA _NULL_ Step to Detect Invalid Character Data*/
title "Listing of invalid patient numbers and data values";
data _null_;
set clean.patients;
file print; ***send output to the output window;
***check Gender;
if Gender not in ('F' 'M' ' ') then put Patno= Gender=;
***check Dx;
if verify(trim(Dx),'0123456789') and not missing(Dx)
then put Patno= Dx=;
/***********************************************
SAS 9 alternative:
if notdigit(trim(Dx)) and not missing(Dx)
then put Patno= Dx=;
************************************************/
***check AE;
if AE not in ('0' '1' ' ') then put Patno= AE=;
run;

/*Using PROC PRINT with a WHERE Statement to List Invalid Values*/
title "Listing of invalid gender values";
proc print data=clean.patients;
  where Gender not in ('M' 'F' ' ');
  id Patno;
  var Gender;
run;

/*Using Formats to Check for Invalid Values*/
proc format;
	value $gender 'F','M' = 'Valid'
	                 ' ' = 'Missing'
                   other = 'Miscoded';
	value $ae '0','1' = 'Valid'
' ' = 'Missing'
other = 'Miscoded';
run;
title "Using formats to identify invalid values";
proc freq data=clean.patients;
format Gender $gender.
AE $ae.;
tables Gender AE/ nocum nopercent missing;
run;

*----------------------------------------------------------------*
| Purpose: To create a SAS data set called PATIENTS2 |
| and set any invalid values for Gender and AE to |
| missing, using a user-defined informat |
*---------------------------------------------------------------*;
libname clean "c:\books\clean";
proc format;
  invalue $gen 'F','M' = _same_
                 other = ' ';
  invalue $ae '0','1' = _same_
                other = ' ';
run;
data clean.patients_filtered;
  infile "c:\books\clean\patients.txt" pad;
  input @1 Patno $3.
        @4 Gender $gen1.
        @27 AE $ae1.;
  label Patno = "Patient Number"
       Gender = "Gender"
           AE = "adverse event?";
run;
title "Listing of data set PATIENTS_FILTERED";

proc print data=clean.patients_filtered;
var Patno Gender AE;
run;

proc format;
  invalue $gen (upcase) 'F' = 'F'
                        'M' = 'M'
                      other = ' ';
  invalue $ae '0','1' = _same_
                other = ' ';
run;


/*Using a User-Defined Informat with the INPUT Function*/
proc format;
  invalue $gender 'F','M' = _same_
                    other = 'Error';
  invalue $ae '0','1' = _same_
                other = 'Error';
run;

data _null_;
  file print;
  set clean.patients;
  if input (Gender,$gender.) = 'Error' then
  put @1 "Error for Gender for patient:" Patno" value is " Gender;
  if input (AE,$ae.) = 'Error' then
  put @1 "Error for AE for patient:" Patno" value is " AE;
run;

/*Using PROC MEANS, PROC TABULATE, and*/
/*PROC UNIVARIATE to Look for Outliers*/

libname clean "c:\books\clean";

title "Checking numeric variables in the patients data set";
proc means data=clean.patients n nmiss min max maxdec=3;  *这一步面向过程的调用;
	var HR SBP DBP;
run;

/*Using PROC TABULATE to Display Descriptive Data*/
title "Statistics for numeric variables";
proc tabulate data=clean.patients format=7.3;    *format 定义了输出的格式;
  var HR SBP DBP;
  tables HR SBP DBP,
  n*f=7.0 nmiss*f=7.0 mean min max / rtspace=18;    *rtspace 定义了18个标签来放东西;
  keylabel n = 'Number'
  nmiss = 'Missing'
   mean = 'Mean'
    min = 'Lowest'
    max = 'Highest';
run;

title "Using PROC UNIVARIATE to Look for Outliers";
proc univariate data=clean.patients plot;    *画出图形来找到一些异常的点 输出了一系列的统计量在结果中;
  id Patno;
  var HR SBP DBP;
run;

/*Using PROC UNIVARIATE to Print the Top and Bottom "n" Percent of*/
/*Data Values*/

libname clean "c:\books\clean";
proc univariate data=clean.patients noprint;
	var HR;
	id Patno;
	output out=tmp pctlpts=10 90 pctlpre = L_;  *输出了数据集名为tmp; 
run;

data hilo;
	set clean.patients(keep=Patno HR); 
	***Bring in upper and lower cutoffs for variable;
	if _n_ = 1 then set tmp;                   *这样的表述;
	if HR le L_10 and not missing(HR) then do;
	  Range = 'Low ';
	output;
	end;

	else if HR ge L_90 then do;
	Range = 'High';
	output;
	end;
run;

proc sort data=hilo;
by HR; 
run;

title "Top and Bottom 10% for Variable HR";
proc print data=hilo;
	id Patno;
	var Range HR;
run;

/*Creating a Macro to List the Highest and Lowest "n" Percent of the Data*/
/*Using PROC UNIVARIATE*/
*---------------------------------------------------------------*
| Program Name: HILOWPER.SAS in c:\books\clean |
| Purpose: To list the n percent highest and lowest values for |
| a selected variable. |
| Arguments: Dsn - Data set name |
| Var - Numeric variable to test |
| Percent - Upper and Lower percentile cutoff |
| Idvar - ID variable to print in the report |
| Example: %hilowper(Dsn=clean.patients, |
| Var=SBP, |
| Perecent=10, |
| Idvar=Patno) |
*---------------------------------------------------------------*;
%macro hilowper(Dsn=, /* Data set name */
                 Var=, /* Variable to test */
                 Percent=, /* Upper and lower percentile cutoff */
                 Idvar= /* ID variable */);

***Compute upper percentile cutoff;
%let Up_per = %eval(100 - &Percent);

proc univariate data=&Dsn noprint;
        var &Var;
        id &Idvar;
        output out=tmp pctlpts=&Percent &Up_per pctlpre = L_;
run;

data hilo;
  set &Dsn(keep=&Idvar &Var);
  if _n_ = 1 then set tmp;
  if &Var le L_&percent and not missing(&Var) then do;
  range = 'Low';
  output;
  end;
  else if &Var ge L_&Up_per then do;
  range = 'High';
  output;
  end;
run;

proc sort data=hilo;
by &Var;
run;

title "Low and High Values for Variables";
proc print data=hilo;
           id &Idvar;
       var Range &Var;
run;

proc datasets library=work nolist;
  delete tmp hilo;
run;
quit;

%mend hilowper;

/*调用编写的宏代码*/
%hilowper(Dsn=clean.patients,
           Var=SBP,
           Perecent=10,
           Idvar=Patno)

/*对一组数据进行排序*/
proc rank data=input out=new;
  var X Y Z;
  ranks RX RY RZ;
run;

/*Creating a Program to List the Highest and Lowest 10 Values*/
proc sort data=clean.patients(keep=Patno HR
where=(HR is not missing)) out=tmp;
by HR;
run;
data _null_;
set tmp nobs=Num_obs;
call symputx('Num',Num_obs);
stop;
run;
%let High = %eval(&Num - 9);
title "Ten Highest and Ten Lowest Values for HR";
data _null_;
set tmp(obs=10) /* lowest values */
tmp(firstobs=&High) /* highest values */;
file print;
if _n_ le 10 then do;
if _n_ = 1 then put / "Ten Lowest Values" ;
put "Patno = " Patno @15 "Value = " HR;
end;
else if _n_ ge 11 then do;
if _n_ = 11 then put / "Ten Highest Values" ;
put "Patno = " Patno @15 "Value = " HR;
end;
run;



/*Creating a Macro for Range Checking*/
*---------------------------------------------------------------*
| Program Name: RANGE.SAS in C:\books\clean |
| Purpose: Macro that takes lower and upper limits for a |
| numeric variable and an ID variable to print out |
| an exception report to the Output window. |
| Arguments: Dsn - Data set name |
| Var - Numeric variable to test |
| Low - Lowest valid value |
| High - Highest valid value |
| Idvar - ID variable to print in the exception |
| report |
| Example: %range(Dsn=CLEAN.PATIENTS, |
| Var=HR, |
| Low=40, |
| High=100, |
| Idvar=Patno) |
*---------------------------------------------------------------*;
%macro range(Dsn= /* Data set name */,
Var= /* Variable you want to check */,
Low= /* Low value */,
High= /* High value */,
Idvar= /* ID variable */);
title "Listing of Out of range Data Values";
data _null_;
set &Dsn(keep=&Idvar &Var);
file print;
if (&Var lt &Low and not missing(&Var)) or &Var gt &High then
put "&Idvar:" &Idvar @18 "Variable:&VAR"
@38 "Value:" &Var
@50 "out-of-range";
run;
%mend range;

/*Checking Ranges for Several Variables*/

%macro errors(Var=, /* Variable to test */
Low=, /* Low value */
High=, /* High value */
Missing=ignore
/* How to treat missing values */
/* Ignore is the default. To flag */
/* missing values as errors set */
/* Missing=error */);
data tmp;
set &dsn(keep=&Idvar &Var);
length Reason $ 10 Variable $ 32;
Variable = "&Var";
Value = &Var;
if &Var lt &Low and not missing(&Var) then do;
Reason='Low';
output;
end;
%if %upcase(&Missing) ne IGNORE %then %do;
else if missing(&Var) then do;
Reason='Missing';
output;
end;
%end;
else if &Var gt &High then do;
Reason='High';
output;
end;
drop &Var;
run;
proc append base=errors data=tmp;
run;
%mend errors;
***Error Reporting Macro - to be run after ERRORS has been called
as many times as desired for each numeric variable to be tested;
%macro report;
proc sort data=errors;
by &Idvar;
run;
proc print data=errors;
title "Error Report for Data Set &Dsn";
id &Idvar;
var Variable Value Reason;
run;
proc datasets library=work nolist;
delete errors;
delete tmp;
run;
quit;
%mend report;
***Calling the ERRORS macro;
***Set two macro variables;
%let dsn=clean.patients;
%let Idvar = Patno;
%errors(Var=HR, Low=40, High=100, Missing=error)
%errors(Var=SBP, Low=80, High=200, Missing=ignore)
%errors(Var=DBP, Low=60, High=120)
***Generate the report;
%report



proc format;
value hr_ck 40-100, . = 'OK';
value sbp_ck 80-200, . = 'OK';
value dbp_ck 60-120, . = 'OK';
run;
title "Listing of patient numbers and invalid data values";
data _null_;
set clean.patients(keep=Patno HR SBP DBP);
file print; ***send output to the output window;
if put(HR,hr_ck.) ne 'OK' then put Patno= HR=;
if put(SBP,sbp_ck.) ne 'OK' then put Patno= SBP=;
if put(DBP,dbp_ck.) ne 'OK' then put Patno= DBP=;
run;

proc format;
invalue hr_ck 40-100 = _same_
other = .;
invalue sbp_ck 80-200 = _same_
other = .;
invalue dbp_ck 60-120 = _same_
other = .;
run;
title "Using User-Defined Informats to Filter Invalid Values";
data valid_numerics;
infile "c:\books\clean\patients.txt" pad;
file print; ***send output to the output window;
***Note: we will only input those variables of interest;
input @1 Patno $3.
@15 HR hr_ck3.
@18 SBP sbp_ck3.
@21 DBP dbp_ck3.;
run;


libname clean "c:\books\clean";
***Output means and standard deviations to a data set;
proc means data=clean.patients noprint;
var HR;
output out=means(drop=_type_ _freq_)
mean=M_HR
std=S_HR;
run;
title "Outliers for HR Based on 2 Standard Deviations";
data _null_;
file print;
set clean.patients(keep=Patno HR);
***bring in the means and standard deviations;
if _n_ = 1 then set means;
if HR lt M_HR – 2*S_HR and not missing(HR) or
HR gt M_HR + 2*S_HR then put Patno= HR=;
run;

/*Computing Trimmed Statistics*/
proc rank data=clean.patients(keep=Patno HR) out=tmp groups=5;
var HR;
ranks R_HR;
run;

proc means data=tmp noprint;
where R_HR not in (0,4);
*Trimming the top and bottom 20%;
var HR;
output out=means(drop=_type_ _freq_)
mean=M_HR
std=S_HR;
run;


proc rank data=clean.patients(keep=Patno HR) out=tmp groups=5;
var HR;
ranks R_HR;
run;

proc means data=tmp noprint;
where R_HR not in (0,4); ***the middle 60%;
var HR;
output out=means(drop=_type_ _freq_)
mean=M_HR
std=S_HR;
run;

%let N_sd = 2;
%let Mult = 2.12;
title "Outliers Based on Trimmed Statistics";
data _null_;
file print;
set clean.patients;
if _n_ = 1 then set means;
if HR lt M_HR – &N_sd*S_HR*&Mult and not missing(HR) or
HR gt M_HR + &N_sd*S_HR*&Mult then put Patno= HR=;
run;


/*Creating a Macro to Detect Outliers Based on Trimmed Statistics*/
%macro trimmed
(/* the data set name (DSN) and ID variable (IDVAR)
need to be assigned with %let statements
prior to calling this macro */
Var=, /* Variable to test for outliers */
N_sd=2, /* Number of standard deviations */
Trim=10 /* Percent top and bottom trim */
/* Valid values of Trim are */
/* 5, 10, 20, and 25 */);
/*************************************************************
Example:
%let dsn=clean.patients;
%let idvar=Patno;
%trimmed(Var=HR,
N_sd=2,
Trim=20)
**************************************************************/
title "Outliers for &Var based on &N_sd Standard Deviations";
title2 "Trimming &Trim% from the Top and Bottom of the Values";
%if &Trim eq 5 or
&Trim eq 10 or
&Trim eq 20 or
&Trim eq 25 %then %do;
%let NGroups = %eval(100/&Trim);
%if &Trim = 5 %then %let Mult = 1.24;
%else %if &trim = 10 %then %let Mult = 1.49;
%else %if &trim = 20 %then %let Mult = 2.12;
%else %if &trim = 25 %then %let Mult = 2.59;
proc rank data=&dsn(keep=&Idvar &Var)
out=tmp groups=&NGroups;
var &var;
ranks rank;
run;
proc means data=tmp noprint;
where rank not in (0,%eval(&Ngroups - 1));
var &Var;
output out=means(drop=_type_ _freq_)
mean=Mean
std=Sd;
run;
data _null_;
file print;
set &dsn;
if _n_ = 1 then set means;
if &Var lt Mean - &N_sd*&Mult*Sd and
not missing(&Var) or
&Var gt Mean + &N_sd*&Mult*Sd
then put &Idvar= &Var=;
run;
proc datasets library=work;
delete means;
run;
quit;
%end;
%else %do;
data _null_;
file print;
put "You entered a value of &trim for the Trim Value."/
"It must be 5, 10, 20, or 25";
run;
%end;
%mend trimmed;

%let Dsn=clean.patients;
%let Idvar=Patno;
%trimmed(Var=HR, N_sd=2, Trim=10)
%trimmed(Var=HR, N_sd=2, Trim=25)
%trimmed(Var=SBP, N_sd=2, Trim=20)
%trimmed(Var=DBP, N_sd=2, Trim=20)

title "Trimmed statistics for HR with TRIM=5";
proc Univariate data=clean.patients trim=5;
var HR;
run;

/*Presenting a Macro to List Outliers of Several Variables Based on Trimmed*/
/*Statistics (Using PROC UNIVARIATE)*/

%macro auto_outliers(
Dsn=, /* Data set name */
ID=, /* Name of ID variable */
Var_list=, /* List of variables to check */
/* separate names with spaces */
Trim=.1, /* Integer 0 to n = number to trim */
/* from each tail; if between 0 and .5, */
/* proportion to trim in each tail */
N_sd=2 /* Number of standard deviations */);
ods listing close;
ods output TrimmedMeans=trimmed(keep=VarName Mean Stdmean DF);
proc univariate data=&Dsn trim=&Trim;
var &Var_list;
run;
ods output close;
data restructure;
set &Dsn;
length Varname $ 32;
array vars[*] &Var_list;
do i = 1 to dim(vars);
Varname = vname(vars[i]);
Value = vars[i];
output;
end;
keep &ID Varname Value;
run;
proc sort data=trimmed;
by Varname;
run;
proc sort data=restructure;
by Varname;
run;
data outliers;
merge restructure trimmed;
by Varname;
Std = StdMean*sqrt(DF + 1);
if Value lt Mean - &N_sd*Std and not missing(Value)
then do;
Reason = 'Low ';
output;
end;
else if Value gt Mean + &N_sd*Std
then do;
Reason = 'High';
output;
end;
run;
proc sort data=outliers;
by &ID;
run;
ods listing;
title "Outliers based on trimmed Statistics";
proc print data=outliers;
id &ID;
var Varname Value Reason;
run;
proc datasets nolist library=work;
delete trimmed;
delete restructure;
*Note: work data set outliers not deleted;
run;
quit;
%mend auto_outliers;

/*调用这个模型*/
%auto_outliers(Dsn=clean.patients,
ID=Patno,
Var_list=HR SBP DBP,
Trim=.2,
N_sd=2)

%macro interquartile
(/* the data set name (Dsn) and ID variable (Idvar)
need to be assigned with %let statements
prior to calling this macro */
var=, /* Variable to test for outliers */
n_iqr=2 /* Number of interquartile ranges */);
/****************************************************************
This macro will list outliers based on the interquartile range.
Example: To list all values beyond 1.5 interquartile ranges
from a data set called clean.patients for a variable
called hr, use the following:
%let Dsn=clean.patients;
%let Idvar=Patno;
%interquartile(var=HR,
n_iqr=1.5)
****************************************************************/
title "Outliers Based on &N_iqr Interquartile Ranges";
proc means data=&dsn noprint; ??
var &var;
output out=tmp
q1=Lower
q3=Upper
qrange=Iqr;
run;

data _null_; ??
set &dsn(keep=&Idvar &Var);
file print;
if _n_ = 1 then set tmp;
if &Var le Lower - &N_iqr*Iqr and not missing(&Var) or
&Var ge Upper + &N_iqr*Iqr then
put &Idvar= &Var=;
run;
proc datasets library=work;
delete tmp;
run;
quit;
%mend interquartile;

%interquartile(Var=HR, N_iqr=1.5)

/*Checking for Missing Values*/

/*Using PROC MEANS and PROC FREQ to Count*/
/*Missing Values*/
libname clean "c:\books\clean";
title "Missing value check for the patients data set";

proc means data=clean.patients n nmiss;
run;

proc format;
value $misscnt ' ' = 'Missing'
other = 'Nonmissing';
run;

proc freq data=clean.patients;
tables _character_ / nocum missing;
format _character_ $misscnt.;
run;

/*Using DATA Step Approaches to Identify and Count*/
/*Missing Values*/
title "Listing of missing values";
data _null_;
file print; ***send output to the output window;
set clean.patients(keep=Patno Visit HR AE);
if missing(Visit) then
put "Missing or invalid visit date for ID " Patno;
if missing(HR) then put "Missing or invalid HR for ID " Patno;
if missing(AE) then put "Missing value for ID " Patno;
run;

/*Attempting to Locate a Missing or Invalid Patient ID by Listing the Two*/
/*Previous ID's*/
title "Listing of missing patient numbers";
data _null_;
set clean.patients;
***Be sure to run this on the unsorted data set;
file print;
Prev_id = lag(Patno);
Prev2_id = lag2(Patno);
if missing(Patno) then put "Missing patient ID. Two previous ID's are:"
Prev2_id "and " Prev_id / @5 "Missing record is number " _n_;
else if notdigit(trim(Patno)) then
put "Invalid patient ID:" patno +(-1)". Two previous ID's are:"
Prev2_id "and " Prev_id / @5 "Missing record is number " _n_;
run;

/*Using PROC PRINT to List Data for Missing or Invalid Patient ID's*/title "Data listing for patients with missing or invalid ID's";
proc print data=clean.patients;
where missing(Patno) or notdigit(trim(Patno));
run;

title "Listing of missing values";
data _null_;
set clean.patients(keep=Patno Visit HR AE) end=last;
file print; ***Send output to the output window;
if missing(Visit) then do;
put "Missing or invalid visit date for ID " Patno;
N_visit + 1;
end;
if missing(HR) then do;
put "Missing or invalid HR for ID " Patno;
N_HR + 1;
end;
if missing(AE) then do;
put "Missing AE for ID " Patno;
N_AE + 1;
end;
if last then
put // "Summary of missing values" /
25*'-' /
"Number of missing dates = " N_visit /
"Number of missing HR's = " N_HR /
"Number of missing adverse events = " N_AE;
run;

/*Identifying All Numeric Variables Equal to a Fixed Value (Such as 999)*/
***Create test data set;
data test;
input X Y A $ X1-X3 Z $;
datalines;
1 2 X 3 4 5 Y
2 999 Y 999 1 999 J
999 999 R 999 999 999 X
1 2 3 4 5 6 7
;
***Program to detect the specified values;
data _null_;
set test;
file print;
array nums[*] _numeric_;
length Varname $ 32;
do __i = 1 to dim(nums);
if nums[__i] = 999 then do;
Varname = vname(nums[__i]);
put "Value of 999 found for variable " Varname
"in observation " _n_;
end;
end;
drop __i;
run;

/*Creating a Macro to Search for Specific Numeric Values*/

*-----------------------------------------------------------------*
| Macro name: find_value.sas in c:\books\clean |
| purpose: Identifies any specified value for all numeric vars |
| Calling arguments: dsn= sas data set name |
| value= numeric value to search for |
| example: to find variable values of 9999 in data set test, use |
| |
| %find_value(dsn=test, value=9999) |
*-----------------------------------------------------------------*;
%macro find_value(dsn=, /* The data set name */
value=999 /* Value to look for, default is 999 */ );
title "Variables with &value as missing values";
data temp;
set &dsn;
file print;
length Varname $ 32;
array nums[*] _numeric_;
do __i = 1 to dim(nums);
if nums[__i] = &value then do;
Varname = vname(nums[__i]);
output;
end;
end;
keep Varname;
run;
proc freq data=temp;
tables Varname / out=summary(keep=Varname Count)
nocum;
run;
proc datasets library=work;
delete temp;
run;
quit;
%mend find_value;
%find_value(dsn=test, value=999)

/*Working with Dates*/
/*Checking That a Date Is within a Specified Interval (DATA Step Approach)*/
libname clean "c:\books\clean";
title "Dates before June 1, 1998 or after October 15, 1999";
data _null_;
file print;
set clean.patients(keep=Visit Patno);
if Visit lt '01jun1998'd and not missing(Visit) or
Visit gt '15oct1999'd then put Patno= Visit= mmddyy10.;
run;

/*Checking That a Date Is within a Specified Interval (Using PROC PRINT*/
/*and a WHERE Statement)*/
title "Dates before June 1, 1998 or after October 15, 1999";
proc print data=clean.patients;
where Visit not between '01jun1998'd and '15oct1999'd and
not missing(Visit);
id Patno;
var Visit;
format Visit date9.;
run;

/*Checking for Invalid Dates*/
/*Reading Dates with the MMDDYY10. Informat*/
data dates;
infile "c:\cleaning\patients.txt" truncover;
input @5 Visit mmddyy10.;
format Visit mmddyy10.;
run;

/*Listing Missing and Invalid Dates by Reading the Date Twice, Once with a*/
/*Date Informat and the Second as Character Data*/
title "Listing of missing and invalid dates";
data _null_;
file print;
infile "c:\books\clean\patients.txt" truncover;
input @1 Patno $3.
@5 Visit mmddyy10.
@5 V_date $char10.;
format Visit mmddyy10.;
if missing(Visit) then put Patno= V_date=;
run;

/*Listing Missing and Invalid Dates by Reading the Date as a Character*/
/*Variable and Converting to a SAS Date with the INPUT Function*/
title "Listing of missing and invalid dates";
data _null_;
file print;
infile "c:\books\clean\patients.txt" truncover;
input @1 Patno $3.
@5 V_date $char10.;
Visit = input(V_date,mmddyy10.);
format Visit mmddyy10.;
if missing(Visit) then put Patno= V_date=;
run;

/*Removing the Missing Values from the Invalid Date Listing*/
title "Listing only invalid dates";
data _null_;
file print;
infile "c:\books\clean\patients.txt" truncover;
input @1 Patno $3.
@5 V_date $char10.;
Visit = input(V_date,mmddyy10.);
format Visit mmddyy10.;
if missing(Visit) and not missing(V_date) then put Patno= V_date=;
run;

/*Working with Dates in Nonstandard Form*/
data nonstandard;
input Patno $ 1-3 Month 6-7 Day 13-14 Year 20-23;
Date = mdy(Month,Day,Year);
format date mmddyy10.;
datalines;
001 05 23 1998
006 11 01 1998
123 14 03 1998
137 10 1946
;
title "Listing of data set NONSTANDARD";
proc print data=nonstandard;
id Patno;
run;

/*Creating a SAS Date When the Day of the Month Is Missing*/
data no_day;
input @1 Date1 monyy7. @8 Month 2. @10 Year 4.;
Date2 = mdy(Month,15,Year);
format Date1 Date2 mmddyy10.;
datalines;
JAN98 011998
OCT1998101998
;
title "Listing of data set NO_DAY";
proc print data=NO_DAY;
run;

/*Suspending Error Checking for Known Invalid Dates by Using the ??*/
/*Informat Modifier*/

data dates;
infile "c:\books\clean\patients.txt" truncover;
input @5 visit ?? mmddyy10.;
format visit mmddyy10.;
run;

/*Demonstrating the ?? Informat Modifier with the INPUT Function*/
title "Listing of missing and invalid dates";
data _null_;
file print;
infile "c:\books\clean\patients.txt" truncover;
input @1 Patno $3.
@5 V_date $char10.;
Visit = input(V_date,?? mmddyy10.);
format Visit mmddyy10.;
if missing(Visit) then put Patno= V_date=;
run;

/*Looking for Duplicates and “n” Observations*/
/*per Subject*/
/*Demonstrating the NODUPKEY Option of PROC SORT*/
proc sort data=clean.patients out=single nodupkey;
by Patno;
run;

title "Data Set SINGLE - Duplicated ID's Removed from PATIENTS";

proc print data=single;
id Patno;
run;

proc sort data=clean.patients out=single noduprecs;
by Patno;
run;


/*Demonstrating a Problem with the NODUPRECS (NODUP) Option*/
data multiple;
input Patno $ x y;
datalines;
001 1 2
006 1 2
009 1 2
001 3 4
001 1 2
009 1 2
001 1 2
;
proc sort data=multiple out=single noduprecs;
by Patno;
run;

/*Detecting Duplicates by Using DATA Step Approaches*/
/*Identifying Duplicate ID's*/

proc sort data=clean.patients out=tmp;
by Patno;
run;
data dup;
set tmp;
by Patno;
if first.Patno and last.Patno then delete;
run;
title "Listing of duplicates from data set CLEAN.PATIENTS";
proc print data=dup;
id Patno;
run;

/*Creating the SAS Data Set PATIENTS2 (a Data Set Containing Multiple*/
/*Visits for Each Patient)*/

data clean.patients2;
infile "c:\books\clean\patients2.txt" truncover;
input @1 Patno $3.
@4 Visit mmddyy10.
@14 HR 3.
@17 SBP 3.
@20 DBP 3.;
format Visit mmddyy10.;
run;

/*Identifying Patient ID's with Duplicate Visit Dates*/
proc sort data=clean.patients2 out=tmp;
by Patno Visit;
run;
data dup;
set tmp;
by Patno Visit;
if first.Visit and last.Visit then delete;
run;
title "Listing of Duplicates from Data Set CLEAN.PATIENTS2";
proc print data=dup;
id Patno;
run;

/*Using PROC FREQ to Detect Duplicate ID's*/
/*Using PROC FREQ and an Output Data Set to Identify Duplicate ID's*/
proc freq data=clean.patients noprint;
tables Patno / out=dup_no(keep=Patno Count
where=(Count gt 1));
run;
proc sort data=clean.patients out=tmp;
by Patno;
run;
proc sort data=dup_no;
by Patno;
run;
data dup;
merge tmp dup_no(in=Yes_dup drop=Count);
by Patno;
if Yes_dup;
run;
title "Listing of data set dup";
proc print data=dup;
run;

/*Producing a List of Duplicate Patient Numbers by Using PROC FREQ*/
proc freq data=clean.patients noprint;
tables Patno / out=dup_no(keep=Patno Count
where=(Count gt 1));
run;
title "Patients with duplicate observations";
proc print data=dup_no noobs;
run;

/*Using PROC SQL to Create a List of Duplicates*/

proc sql noprint;
select quote(Patno)
into :Dup_list separated by " "
from dup_no;
quit;
title "Duplicates selected using SQL and a macro variable";
proc print data=clean.patients;
where Patno in (&Dup_list);
run;

/*Identifying Subjects with "n" Observations Each (DATA Step*/
/*Approach)*/

/*Using a DATA Step to List All ID's for Patients Who Do Not Have Exactly*/
/*Two Observations*/
proc sort data=clean.patients2(keep=Patno) out=tmp;
by Patno;
run;
title "Patient ID's for patients with other than two observations";
data _null_;
file print;
set tmp;
by Patno; ??
if first.Patno then n = 0; ??
n + 1; ??
if last.Patno and n ne 2 then put
"Patient number " Patno "has " n "observation(s)."; ??
run;

/*Identifying Subjects with "n" Observations Each (Using*/
/*PROC FREQ)*/
/*Using PROC FREQ to List All ID's for Patients Who Do Not Have Exactly*/
/*Two Observations*/

proc freq data=clean.patients2 noprint;
tables Patno / out=dup_no(keep=Patno Count
where=(Count ne 2));
run;
title "Patient ID's for patients with other than two observations";
proc print data=dup_no noobs;
run;

                                                       /*Working with Multiple Files*/
/*Creating Two Test Data Sets for Chapter 6 Examples*/

data one;
input Patno x y;
datalines;
1 69 79
2 56 .
3 66 99
5 98 87
12 13 14
;
data two;
input Patno z;
datalines;
1 56
3 67
4 88
5 98
13 99
;

/*Identifying ID's Not in Each of Two Data Sets*/
proc sort data=one;
by Patno;
run;
proc sort data=two;
by Patno;
run;
title "Listing of missing ID's";
data _null_;
file print;
merge one(in=Inone)
two(in=Intwo) end=Last; ??
by Patno; ??
if not Inone then do;
put "ID " Patno "is not in data set one";
n + 1;
end;
else if not Intwo then do; ??
put "ID " Patno "is not in data set two";
n + 1;
end;
if Last and n eq 0 then
put "All ID's match in both files"; ??
run;

/*Checking for an ID in Each of "n" Files*/
??data three;
input Patno Gender $;
datalines;
1 M
2 F
3 M
5 F
6 M
12 M
13 M
;

/*Checking for an ID in Each of Three Data Sets (Long Way)*/
proc sort data=one(keep=Patno) out=tmp1;
by Patno;
run;
proc sort data=two(keep=Patno) out=tmp2;
by Patno;
run;
proc sort data=three(keep=Patno) out=tmp3;
by Patno;
run;
title "Listing of missing ID's and data set names";
data _null_;
file print;
merge tmp1(in=In1)
tmp2(in=In2)
tmp3(in=In3) end=Last;
by Patno;
if not In1 then do;
put "ID " Patno "missing from data set one";
n + 1;
end;
if not In2 then do;
put "ID " Patno "missing from data set two";
n + 1;
end;
if not In3 then do;
put "ID " Patno "missing from data set three";
n + 1;
end;
if Last and n eq 0 then
put "All id's match in all files";
run;

/*A Macro for ID Checking*/
/*Presenting a Macro to Check for ID's Across Multiple Data Sets*/
*----------------------------------------------------------------*
| Program Name: check_id.sas in c:\books\clean |
| Purpose: Macro which checks if an ID exists in each of n files |
| Arguments: The name of the ID variable, followed by as many |
| data sets names as desired, separated by BLANKS |
| Example: %check_id(ID = Patno, |
| Dsn_list=one two three) |
| Date: Sept 17, 2007 |
*----------------------------------------------------------------*;
%macro check_id(ID=, /* ID variable */
Dsn_list= /* List of data set names, */
/* separated by spaces */);
%do i = 1 %to 99;
/* break up list into data set names */
%let Dsn = %scan(&Dsn_list,&i);
%if &Dsn ne %then %do; /* If non null data set name */
%let n = &i; /* When you leave the loop, n will */
/* be the number of data sets */
proc sort data=&Dsn(keep=&ID) out=tmp&i;
by &ID;
run;
%end;
%end;
title "Report of data sets with missing ID's";
title2 "-------------------------------------";
data _null_;
file print;
merge
%do i = 1 %to &n;
tmp&i(in=In&i)
%end;
end=Last;
by &ID;
if Last and nn eq 0 then do;
put "All ID's Match in All Files";
stop;
end;
%do i = 1 %to &n;
%let Dsn = %scan(&Dsn_list,&i);
if not In&i then do;
put "ID " &ID "missing from data set &dsn";
nn + 1;
end;
%end;
run;
%mend check_id;

%check_id(Patno,one two three)

/*More Complicated Multi-File Rules*/

/*Creating Data Set AE (Adverse Events)*/
libname clean "c:\books\clean";
data clean.ae;
input @1 Patno $3.
@4 Date_ae mmddyy10.
@14 A_event $1.;
label Patno = 'Patient ID'
Date_ae = 'Date of AE'
A_event = 'Adverse event';
format Date_ae mmddyy10.;
datalines;
00111/21/1998W
00112/13/1998Y
00311/18/1998X
00409/18/1998O
00409/19/1998P
01110/10/1998X
01309/25/1998W
00912/25/1998X
02210/01/1998W
02502/09/1999X
;

/*Creating Data Set LAB_TEST*/
libname clean "c:\books\clean";
data clean.lab_test;
input @1 Patno $3.
@4 Lab_date date9.
@13 WBC 5.
@18 RBC 4.;
label Patno = 'Patient ID'
Lab_date = 'Date of lab test'
WBC = 'White blood cell count'
RBC = 'Red blood cell count';
format Lab_date mmddyy10.;
datalines;
00115NOV1998 90005.45
00319NOV1998 95005.44
00721OCT1998 82005.23
00422DEC1998110005.55
02501JAN1999 82345.02
02210OCT1998 80005.00
;

/*Verifying That Patients with an Adverse Event of "X" in Data Set AE Have*/
/*an Entry in Data Set LAB_TEST*/

libname clean "c:\books\clean";
proc sort data=clean.ae(where=(A_event = 'X')) out=ae_x;
by Patno;
run;
proc sort data=clean.lab_test(keep=Patno Lab_date) out=lab;
by Patno;
run;
data missing;
merge ae_x
lab(in=In_lab);
by Patno;
if not In_lab;
run;
title "Patients with AE of X who are missing a lab test entry";
proc print data=missing label;
id Patno;
var Date_ae A_event;
run;

/*Checking That the Dates Are in the Proper Order*/
/*Adding the Condition That the Lab Test Must Follow the Adverse Event*/
title "Patients with AE of X Who Are Missing Lab Test Entry";
title2 "or the Date of the Lab Test Is Earlier Than the AE Date";
title3 "-------------------------------------------------------";
data _null_;
file print;
merge ae_x(in=In_ae)
lab(in=In_lab);
by Patno;
if not In_lab then put
"No lab test for patient " Patno "with adverse event X";
else if In_ae and missing(Lab_date) then put
"Date of lab test is missing for patient "
Patno /
"Date of AE is " Date_ae /;
else if In_ae and Lab_date lt Date_ae then put
"Date of lab test is earlier than date of AE for patient "
Patno /
" date of AE is " Date_ae " date of lab test is " Lab_date /;
run;

/*Double Entry and Verification*/
data one;
infile "c:\books\clean\file_1.txt" truncover;
input @1 Patno 3.
@4 Gender $1.
@5 DOB mmddyy8.
@13 SBP 3.
@16 DBP 3.;
format DOB mmddyy10.;
run;

data two;
infile "c:\books\clean\file_2.txt" truncover;
input @1 Patno 3.
@4 Gender $1.
@5 DOB mmddyy8.
@13 SBP 3.
@16 DBP 3.;
format dob mmddyy10.;
run;

/*Running PROC COMPARE*/
title "Using PROC COMPARE to compare two data sets";
proc compare base=one compare=two;
id Patno;
run;

/*Demonstrating the TRANSPOSE Option of PROC COMPARE*/
title "Demonstrating the TRANSPOSE Option";
proc compare base=one compare=two brief transpose;
id Patno;
run;

/*Using PROC COMPARE to Compare Two Data Records*/
data one;
infile "c:\books\clean\file_1.txt"
pad;
input @1 Patno $char3.
@4 Gender $char1.
@5 DOB $char8.
@13 SBP $char3.
@16 DBP $char3.;
run;
data two;
infile "c:\books\clean\file_2.txt"
pad;
input @1 Patno $char3.
@4 Gender $char1.
@5 DOB $char8.
@13 SBP $char3.
@16 DBP $char3.;
run;
title "Using PROC COMPARE to compare two data sets";
proc compare base=one compare=two brief;
id Patno;
run;

/*Creating Two Test Data Sets, DEMOG and OLDDEMOG*/

***Program to create data sets DEMOG and OLDDEMOG;
data demog;
input @1 Patno 3.
@4 Gender $1.
@5 DOB mmddyy10.
@15 Height 2.;
format DOB mmddyy10.;
datalines;
001M10/21/194668
003F11/11/105062
004M04/05/193072
006F05/13/196863
;
data olddemog;
input @1 Patno 3.
@4 DOB mmddyy8.
@12 Gender $1.
@13 Weight 3.;
format DOB mmddyy10.;
datalines;
00110211946M155
00201011950F102
00404051930F101
00511111945M200
00605131966F133
;

/*Comparing Two Data Sets That Contain Different Variables*/
title "Comparing demographic information between two data sets";
proc compare base=olddemog compare=demog brief;
id Patno;
run;

/*Adding a VAR Statement to PROC COMPARE*/
title "Comparing demographic information between two data sets";
proc compare base=olddemog compare=demog brief;
id Patno;
var Gender;
run;

/*Some PROC SQL Solutions to Data Cleaning*/
proc sql;
select X
from one
where X gt 100;
quit;

/*Using PROC SQL to Look for Invalid Character Values*/

libname clean "c:\books\clean";
***Checking for invalid character data;
title "Checking for Invalid Character Data";
proc sql;
select Patno,
Gender,
DX,
AE
from clean.patients
where Gender not in ('M','F',' ') or
notdigit(trim(DX))and not missing(DX) or
AE not in ('0','1',' ');
quit;

/*Checking for Outliers*/
title "Checking for out-of-range numeric values";
proc sql;
select Patno,
HR,
SBP,
DBP
from clean.patients
where HR not between 40 and 100 and HR is not missing or
SBP not between 80 and 200 and SBP is not missing or
DBP not between 60 and 120 and DBP is not missing;
quit;

/*Checking a Range Using an Algorithm Based on the*/
/*Standard Deviation*/
title "Data values beyond two standard deviations";
proc sql;
select Patno,
SBP
from clean.patients
having SBP not between mean(SBP) - 2 * std(SBP) and
mean(SBP) + 2 * std(SBP) and
SBP is not missing;
quit;

/*Using SQL to List Missing Values*/
title "Observations with missing values";
proc sql;
select *
from clean.patients
where Patno is missing or
Gender is missing or
Visit is missing or
HR is missing or
SBP is missing or
DBP is missing or
DX is missing or
AE is missing;
quit;

/*Using SQL to Perform Range Checks on Dates*/

title "Dates before June 1, 1998 or after October 15, 1999";
proc sql;
select Patno,
Visit
from clean.patients
where Visit not between '01jun1998'd and '15oct1999'd and
Visit is not missing;
quit;

/*Using SQL to List Duplicate Patient Numbers*/
title "Duplicate Patient Numbers";
proc sql;
select Patno,
Visit
from clean.patients
group by Patno
having count(Patno) gt 1;
quit;

/*Using SQL to List Patients Who Do Not Have Two Visits*/
title "Listing of patients who do not have two visits";
proc sql;
select Patno,
Visit
from clean.patients2
group by Patno
having count(Patno) ne 2;
quit;

/*Checking for an ID in Each of Two Files*/

/*Creating Two Data Sets for Testing Purposes*/

data one;
input Patno X Y;
datalines;
1 69 79
2 56 .
3 66 99
5 98 87
12 13 14
;
data two;
input Patno Z;
datalines;
1 56
3 67
4 88
5 98
13 99
;

/*Using SQL to Look for ID's That Are Not in Each of Two Files*/
title "Patient numbers not in both files";
proc sql;
select One.patno as ID_one,
Two.patno as ID_two
from one full join two
on One.patno eq Two.patno
where One.patno is missing or Two.patno is missing;
quit;

/*More Complicated Multi-File Rules*/
/*Using SQL to Demonstrate More Complicated Multi-File Rules*/
title1 "Patients with an AE of X who did not have a";
title2 "labtest or where the date of the test is prior";
title3 "to the date of the visit";
proc sql;
select AE.Patno as AE_Patno label="AE patient number",
A_event,
Date_ae,
Lab_test.Patno as Labpatno label="Lab patient number",
Lab_date
from clean.ae left join clean.lab_test
on AE.Patno=Lab_test.Patno
where A_event = 'X' and
Lab_date lt Date_ae;
quit;

/*Example of LEFT, RIGHT, and FULL Joins*/
proc sql;
title "Left join";
select one.Patno as One_id,
two.patno as Two_id
from one left join two
on one.Patno eq two.Patno;
title "Right join";
select one.Patno as One_id,
two.Patno as Two_id
from one right join two
on one.Patno eq two.Patno;
title "Full join";
select one.Patno as One_id,
two.Patno as Two_id
from one full join two
on one.Patno eq two.Patno;
quit;


/*Correcting Errors*/
/*Hardcoding Corrections Using a DATA Step*/
libname clean 'c:\books\clean';
data clean.patients_24Sept2007;
set clean.patients;
if Patno = '002' then DX = '3';
else if Patno = '003' then do;
Gender = 'F';
SBP = 160;
end;
else if Patno = '004' then do;
SBP = 188;
DBP = 110;
HR = 90;
end;
***and so forth;
run;

/*Describing Named Input*/
/*Describing Named Input*/
data named;
length Char $ 3;
input x=
y=
char=;
datalines;
x=3 y=4 char=abc
y=7
char=xyz z=9
;

/*Using Named Input to Make Corrections*/
data correct_24Sept2007;
length Patno DX $ 3
Gender Drug $ 1;
input Patno=
DX=
Gender=
Drug=
HR=
SBP=
DBP=;
datalines;
Patno=002 DX=3
Patno=003 Gender=F SBP=160
Patno=004 SBP=188 DBP=110 HR=90
;

/*Demonstrating How UPDATE Works*/
data inventory;
length PartNo $ 3;
input PartNo $ Quantity Price;
datalines;
133 200 10.99
198 105 30.00
933 45 59.95
;
data transaction;
length PartNo $ 3;
input Partno=
Quantity=
Price=;
datalines;
PartNo=133 Quantity=195
PartNo=933 Quantity=40 Price=69.95
;
proc sort data=inventory;
by Partno;
run;
proc sort data=transaction;
by PartNo;
run;
data inventory_24Sept2007;
update inventory transaction;
by Partno;
run;

/*Creating Integrity Constraints and Audit Trails*/
/*Creating Data Set HEALTH to Demonstrate Integrity Constraints*/
data health;
input Patno : $3. Gender : $1. HR SBP DBP;
datalines;
001 M 88 140 80
002 F 84 120 78
003 M 58 112 74
004 F . 200 120
007 M 88 148 102
015 F 82 148 88
;

proc datasets library=work nolist;
modify health;
ic create gender_chk = check
(where=(gender in('F','M')));
ic create hr_chk = check
(where=( HR between 40 and 100 or HR is missing));
ic create sbp_chk = check
(where=(SBP between 80 and 200 or SBP is missing));
ic create dbp_chk = check
(where=(DBP between 60 and 140));
ic create id_chk = unique(Patno);
run;
quit;

/*Creating Data Set NEW Containing Valid and Invalid Data*/
data new;
input Patno : $3. Gender : $1. HR SBP DBP;
datalines;
456 M 66 98 72
567 F 150 130 80
003 M 70 134 86
123 F 66 10 80
013 X 68 120 .
;

/*Attempting to Append Data Set NEW to the HEALTH Data Set*/
proc append base=health data=new;
run;

/*Deleting an Integrity Constraint Using PROC DATASETS*/
proc datasets library=work nolist;
modify health;
ic delete gender_chk;
run;
quit;

/*Adding User Messages to the Integrity Constraints*/

proc datasets library=work nolist;
modify health;
ic create gender_chk = check
(where=(gender in('F','M')))
message="Gender must be F or M"
msgtype=user;
ic create hr_chk = check
(where=( HR between 40 and 100 or HR is missing))
message="HR must be between 40 and 100 or missing"
msgtype=user;
ic create sbp_chk = check
(where=(SBP between 80 and 200 or SBP is missing))
message="SBP must be between 80 and 200 or missing"
msgtype=user;
ic create dbp_chk = check
(where=(DBP between 60 and 140))
message="DBP must be between 60 and 140"
msgtype=user;
ic create id_chk = unique(Patno)
message="Patient number must be unique"
msgtype=user;
run;
quit;

/*Creating an Audit Trail Data Set*/
proc datasets library=work nolist;
audit health;
initiate;
run;
quit;

/*Using PROC PRINT to List the Contents of the Audit Trail Data Set*/
title "Listing of audit trail data set";
proc print data=health(type=audit) noobs;
run;

/*Reporting the Integrity Constraint Violations Using the Audit Trail Data Set*/

title "Integrity Constraint Violations";
proc report data=health(type=audit) nowd;
where _ATOPCODE_ in ('EA' 'ED' 'EU');
columns Patno Gender HR SBP DBP _ATMESSAGE_;
define Patno / order "Patient Number" width=7;
define Gender / display width=6;
define HR / display "Heart Rate" width=5;
define SBP / display width=3;
define DBP / display width=3;
define _atmessage_ / display "_IC Violation_"
width=30 flow;
run;

/*Correcting Errors Based on the Observations in the Audit Trail Data Set*/
data correct_audit;
set health(type=audit
where=(_ATOPCODE_ in ('EA' 'ED' 'EU')));
if Patno = '003' then Patno = '103';
else if Patno = '013' then do;
Gender = 'F';
DBP = 88;
end;
else if Patno = '123' then SBP = 100;
else if Patno = '567' then HR = 87;
drop _AT: ;
run;
proc append base=health data=correct_audit;
run;

/*Demonstrating an Integrity Constraint Involving More than One Variable*/
data survey;
length ID $ 3;
retain ID ' ' TimeTV TimeSleep TimeWork TimeOther .;
stop;
run;
proc datasets library=work;
modify survey;
ic create ID_check = primary key(ID)
message = "ID must be unique and nonmissing"
msgtype = user;
ic create TimeTV_max = check(where=(TimeTV le 100))
message = "TimeTV must not be over 100"
msgtype = user;
ic create TimeSleep_max = check(where=(TimeSleep le 100))
message = "TimeSleep must not be over 100"
msgtype = user;
ic create TimeWork_max = check(where=(TimeWork le 100))
message = "TimeWork must not be over 100"
msgtype = user;
ic create TimeOther_max = check(where=(TimeOther le 100))
message = "TimeOther must not be over 100"
msgtype = user;
ic create Time_total =
check(where=(sum(TimeTV,TimeSleep,TimeWork,TimeOther) le 100))
message = "Total percentage cannot exceed 100%"
msgtype = user;
run;
audit survey;
initiate;
run;
quit;

/*Added the Survey Data*/
data add;
input ID $ TimeTV TimeSleep TimeWork TimeOther;
datalines;
001 10 40 40 10
002 20 50 40 5
003 10 . . .
004 0 40 60 0
005 120 10 10 10
;

proc append base=survey data=add;
run;

title "Integrity Constraint Violations";
proc report data=survey(type=audit) nowd;
where _ATOPCODE_ in ('EA' 'ED' 'EU');
columns ID TimeTV TimeSleep TimeWork TimeOther _ATMESSAGE_;
define ID / order "ID Number" width=7;
define TimeTV / display "Time spent watching TV" width=8;
define TimeSleep / display "Time spent sleeping" width=8;
define TimeWork / display "Time spent working" width=8;
define TimeOther / display "Time spent in other activities"
width=10;
define _atmessage_ / display "_Error Report_"
width=30 flow;
run;

/*Creating Two Data Sets and a Referential Constraint*/
data master_list;
input FirstName : $12. LastName : $12. DOB : mmddyy10. Gender : $1.;
format DOB mmddyy10.;
datalines;
Julie Chen 7/7/1988 F
Nicholas Schneider 4/15/1966 M
Joanne DiMonte 6/15/1983 F
Roger Clement 9/11/1988 M
;
data salary;
input FirstName : $12. LastName : $12. Salary : comma10.;
datalines;
Julie Chen $54,123
Nicholas Schneider $56,877
Joanne DiMonte $67,800
Roger Clement $42,000
;
title "Listing of MASTER LIST";
proc print data=master_list;
run;
title "Listing of SALARY";
proc print data=salary;
run;

proc datasets library=work nolist;
modify master_list;
ic create prime_key = primary key (FirstName LastName);
ic create gender_chk = check(where=(Gender in ('F','M')));
run;
modify salary;
ic create foreign_key = foreign key (FirstName LastName)
references master_list
on delete restrict on update restrict;
ic create salary_chk = check(where=(Salary le 90000));
run;
quit;

/*Attempting to Delete a Primary Key When a Foreign Key Still Exists*/
/*Attempting to Delete a Primary Key When a Foreign Key Still Exists*/
*Attempt to delete an observation in the master_list;
data master_list;
modify master_list;
if FirstName = 'Joanne' and LastName = 'DiMonte' then remove;
run;
title "Listing of MASTER_LIST";
proc print data=master_list;
run;

/*Attempting to Add a Name to the Child Data Set*/
data add_name;
input FirstName : $12. LastName : $12. Salary : comma10.;
format Salary dollar9.;
datalines;
David York 77,777
;
proc append base=salary data=add_name;
run;

/*Demonstrate the CASCADE Feature of a Referential Integrity Constraint*/
proc datasets library=work nolist;
modify master_list;
ic create prime_key = primary key (FirstName LastName);
run;
modify salary;
ic create foreign_key = foreign key (FirstName LastName)
references master_list
on delete RESTRICT on update CASCADE;
run;
quit;
data master_list;
modify master_list;
if FirstName = 'Roger' and LastName = 'Clement' then
LastName = 'Cody';
run;
title "master list";
proc print data=master_list;
run;
title "salary";
proc print data=salary;
run;

/*Demonstrating the SET NULL Feature of a Referential Constraint*/
proc datasets library=work nolist;
modify master_list;
ic create primary key (FirstName LastName);
run;
modify salary;
ic create foreign key (FirstName LastName) references master_list
on delete SET NULL on update CASCADE;
run;
quit;
data master_list;
modify master_list;
if FirstName = 'Roger' and LastName = 'Clement' then
remove;
run;
title "master list";
proc print data=master_list;
run;
title "salary";
proc print data=salary;
run;

/*Demonstrating How to Delete a Referential Constraint*/
/*Demonstrating How to Delete a Referential Constraint*/
*delete prior referential integrity constraint;
*Note: Foreign key must be deleted before the primary key can be deleted;
proc datasets library=work nolist;
modify salary;
ic delete foreign_key;
run;
modify master_list;
ic delete prime_key;
run;
quit;


/*Program to Create the SAS Data Set PATIENTS*/
*----------------------------------------------------------*
|PROGRAM NAME: PATIENTS.SAS in C:\BOOKS\CLEAN |
|PURPOSE: To create a SAS data set called PATIENTS |
*----------------------------------------------------------*;
libname clean "c:\books\clean";
data clean.patients;
infile "c:\books\clean\patients.txt"
lrecl=30 truncover; /* take care of problems
with short records */
input @1 Patno $3. @4 gender $1.
@5 Visit mmddyy10.
@15 HR 3.
@18 SBP 3.
@21 DBP 3.
@24 Dx $3.
@27 AE $1.;
LABEL Patno = "Patient Number"
Gender = "Gender"
Visit = "Visit Date"
HR = "Heart Rate"
SBP = "Systolic Blood Pressure"
DBP = "Diastolic Blood Pressure"
Dx = "Diagnosis Code"
AE = "Adverse Event?";
format visit mmddyy10.;
run;

/*Program to Create the SAS Data Set AE*/
/*(Adverse Events)*/
libname clean "c:\books\clean";
data clean.ae;
input @1 Patno $3.
@4 Date_ae mmddyy10.
@14 A_event $1.;
label Patno = 'Patient ID'
Date_ae = 'Date of AE'
A_event = 'Adverse event';
format Date_ae mmddyy10.;
datalines;
00111/21/1998W
00112/13/1998Y
00311/18/1998X
00409/18/1998O
00409/19/1998P
01110/10/1998X
01309/25/1998W
00912/25/1998X
02210/01/1998W
02502/09/1999X
;


