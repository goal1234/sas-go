

**---Example: Define Classes---**;
proc groovy classpath=cp;
submit;
class Speaker {
def say( word ) {
println "----> \"${word}\""
}
}
endsubmit;
quit;


**=========================================================================================================================**;
**===                                    HADOOP Procedure                                                               ===**;
**=========================================================================================================================**;


options set=SAS_HADOOP_CONFIG_PATH="\\sashq\root\u\abcdef\cdh45p1";
options set=SAS_HADOOP_JAR_PATH="\\sashq\root\u\abcdef\cdh45";
proc hadoop username='sasabc' password='sasabc' verbose;
hdfs mkdir='/user/sasabc/new_directory';
hdfs delete='/user/sasabc/temp2_directory';
hdfs copytolocal='/user/sasabc/testdata.txt'
out='C:\Users\sasabc\Hadoop\testdata.txt' overwrite;
run;

*--Submitting HDFS Commands with Wildcard Characters--*;
options set=SAS_HADOOP_CONFIG_PATH="\\sashq\root\u\abcdef\cdh45p1";
options set=SAS_HADOOP_JAR_PATH="\\sashq\root\u\abcdef\cdh45";
proc hadoop username='sasabc' password='sasabc' verbose;
hdfs cat='/user/sasabc/*';
hdfs chmod='/user/sasabc/' permission=rwxr-xr-x;
hdfs ls='/user/sasabc/*';
run;


**--Example 3: Submitting a MapReduce Program---**;
filename cfg 'C:\Users\sasabc\Hadoop\sample_config.xml';
proc hadoop cfg=cfg username='sasabc' password='sasabc' verbose;
mapreduce input='/user/sasabc/architectdoc.txt'
output='/user/sasabc/outputtest'
jar='C:\Users\sasabc\Hadoop\jars\WordCount.jar'
outputkey='org.apache.hadoop.io.Text'
outputvalue='org.apache.hadoop.io.IntWritable'
reduce='org.apache.hadoop.examples.WordCount$IntSumReducer'
combine='org.apache.hadoop.examples.WordCount$IntSumReducer'
map='org.apache.hadoop.examples.WordCount$TokenizerMapper';
run;

**---Example 4: Submitting Pig Language Code---*;
filename cfg 'C:\Users\sasabc\hadoop\sample_config.xml';
filename code 'C:\Users\sasabc\hadoop\sample_pig.txt';
proc hadoop cfg=cfg username='sasabc' password='sasabc' verbose;
pig code=code registerjar='C:\Users\sasabc\Hadoop\jars\myudf.jar';
run;

**---Example 5: Submitting Configuration Properties---**;
proc hadoop username='sasabc' password='sasabc' verbose;
prop 'mapred.job.tracker'='xxx.us.company.com:8021'
'fs.default.name'='hdfs://xxx.us.company.com:8020';
mapreduce jar="&mapreducejar."
input="&inputfile."
output="&outdatadir."
deleteresults;
run;


*===================================================================================================*;
*===                                         PROC MEANS                                          ===*;
*===================================================================================================*;
proc template;
edit base.summary;
use_format_defaults=off;
end;
run;

proc means;
class a b c d e;
ways 2 3;
run;
*is equivalent to;
proc means;
class a b c d e;
types a*b a*c a*d a*e b*c b*d b*e c*d c*e d*e
a*b*c a*b*d a*b*e a*c*d a*c*e a*d*e
b*c*d b*c*e c*d*e;
run;


*---Example 1: Computing Specific Descriptive Statistics---*;
options nodate pageno=1 linesize=80 pagesize=60;
data cake;
input LastName $ 1-12 Age 13-14 PresentScore 16-17
TasteScore 19-20 Flavor $ 23-32 Layers 34 ;
datalines;
Orlando 27 93 80 Vanilla 1
Ramey 32 84 72 Rum 2
Goldston 46 68 75 Vanilla 1
Roe 38 79 73 Vanilla 2
Larsen 23 77 84 Chocolate .
Davis 51 86 91 Spice 3
Strickland 19 82 79 Chocolate 1
Nguyen 57 77 84 Vanilla .
Hildenbrand 33 81 83 Chocolate 1
Byron 62 72 87 Vanilla 2
Sanders 26 56 79 Chocolate 1
Jaeger 43 66 74 1
Davis 28 69 75 Chocolate 2
Conrad 69 85 94 Vanilla 1
Walters 55 67 72 Chocolate 2
Rossburger 28 78 81 Spice 2
Matthew 42 81 92 Chocolate 2
Becker 36 62 83 Spice 2
Anderson 27 87 85 Chocolate 1
Merritt 62 73 84 Chocolate 1
;
proc means data=cake n mean max min range std fw=8;
var PresentScore TasteScore;
title 'Summary of Presentation and Taste Scores';
run;

**---Example 2: Computing Descriptive Statistics with Class Variables---**;
options nodate pageno=1 linesize=80 pagesize=60;
data grade;
input Name $ 1-8 Gender $ 11 Status $13 Year $ 15-16
Section $ 18 Score 20-21 FinalGrade 23-24;
datalines;
Abbott F 2 97 A 90 87
Branford M 1 98 A 92 97
Crandell M 2 98 B 81 71
Dennison M 1 97 A 85 72
Edgar F 1 98 B 89 80
Faust M 1 97 B 78 73
Greeley F 2 97 A 82 91
Hart F 1 98 B 84 80
Isley M 2 97 A 88 86
Jasper M 1 97 B 91 93
;
proc means data=grade maxdec=3;
var Score;
class Status Year;
types () status*year;
title 'Final Exam Grades for Student Status and Year of Graduation';
run;

**---Example 3: Using the BY Statement with Class Variables---**;
options nodate pageno=1 linesize=80 pagesize=60;
proc sort data=Grade out=GradeBySection;
by section;
run;
proc means data=GradeBySection min max median;
by Section;
var Score;
class Status Year;
title1 'Final Exam Scores for Student Status and Year of Graduation';
title2 ' Within Each Section';
run;

**---Example 4: Using a CLASSDATA= Data Set with Class Variables---**;
options nodate pageno=1 linesize=80 pagesize=60;
data caketype;
input Flavor $ 1-10 Layers 12;
datalines;
Vanilla 1
Vanilla 2
Vanilla 3
Chocolate 1
Chocolate 2
Chocolate 3
;
proc means data=cake range median min max fw=7 maxdec=0
classdata=caketype exclusive printalltypes;
var TasteScore;
class flavor layers;
title 'Taste Score For Number of Layers and Cake Flavor';
run;

**----Example 5: Using Multilabel Value Formats with Class Variables---**;
options nodate pageno=1 linesize=80 pagesize=64;
proc format;
value $flvrfmt
'Chocolate'='Chocolate'
'Vanilla'='Vanilla'
'Rum','Spice'='Other Flavor';
value agefmt (multilabel)
15 - 29='below 30 years'
30 - 50='between 30 and 50'
51 - high='over 50 years'
15 - 19='15 to 19'
20 - 25='20 to 25'
25 - 39='25 to 39'
40 - 55='40 to 55'
56 - high='56 and above';
run;
proc means data=cake fw=6 n min max median nonobs;
class flavor/order=data;
class age /mlf order=fmt;
types flavor flavor*age;
var TasteScore;
format age agefmt. flavor $flvrfmt.;
title 'Taste Score for Cake Flavors and Participant''s Age';
run;

**---Example 6: Using Preloaded Formats with Class Variables---**;
options nodate pageno=1 linesize=80 pagesize=64;
proc format;
value layerfmt 1='single layer'
2-3='multi-layer'
.='unknown';
value $flvrfmt (notsorted)
'Vanilla'='Vanilla'
'Orange','Lemon'='Citrus'
'Spice'='Spice'
'Rum','Mint','Almond'='Other Flavor';
run;
proc means data=cake fw=7 completetypes missing nonobs;
class flavor layers/preloadfmt exclusive order=data;
ways 1 2;
var TasteScore;
format layers layerfmt. flavor $flvrfmt.;
title 'Taste Score For Number of Layers and Cake Flavors';
run;


**---Example 7: Computing a Confidence Limit for the Mean---**;
data charity;
input School $ 1-7 Year 9-12 Name $ 14-20 MoneyRaised 22-26
HoursVolunteered 28-29;
datalines;
Monroe 2007 Allison 31.65 19
Monroe 2007 Barry 23.76 16
Monroe 2007 Candace 21.11 5
. . . more data lines . . .
Kennedy 2009 Sid 27.45 25
Kennedy 2009 Will 28.88 21
Kennedy 2009 Morty 34.44 25
;
proc means data=charity fw=8 maxdec=2 alpha=0.1 clm mean std;
class Year;
var MoneyRaised HoursVolunteered;
title 'Confidence Limits for Fund Raising Statistics';
title2 '2007-09';
run;

**---Example 8: Computing Output Statistics---**;
options nodate pageno=1 linesize=80 pagesize=60;
proc means data=Grade noprint;
class Status Year;
var FinalGrade;
output out=sumstat mean=AverageGrade
idgroup (max(score) obs out (name)=BestScore)
/ ways levels;
run;
proc print data=sumstat noobs;
title1 'Average Undergraduate and Graduate Course Grades';
title2 'For Two Years';
run;

**--Example 9: Computing Different Output Statistics for Several Variables--**;
options nodate pageno=1 linesize=80 pagesize=60;
proc means data=Grade noprint descend;
class Status Year;
var Score FinalGrade;
output out=Sumdata (where=(status='1' or _type_=0))
mean= median(finalgrade)=MedianGrade;
run;
proc print data=Sumdata;
title 'Exam and Course Grades for Undergraduates Only';
title2 'and for All Students';
run;

**---Example 10: Computing Output Statistics with Missing Class Variable Values---**;
options nodate pageno=1 linesize=80 pagesize=60;
proc means data=cake chartype nway noprint;
class flavor /order=freq ascending;
class layers /missing;
var TasteScore;
output out=cakestat max=HighScore;
run;
proc print data=cakestat;
title 'Maximum Taste Score for Flavor and Cake Layers';
run;

**---Example 11: Identifying an Extreme Value with the Output Statistics---**;
proc means data=Charity n mean range chartype;
class School Year;
var MoneyRaised HoursVolunteered;
output out=Prize maxid(MoneyRaised(name)
HoursVolunteered(name))= MostCash MostTime
max= ;
title 'Summary of Volunteer Work by School and Year';
run;
proc print data=Prize;
title 'Best Results: Most Money Raised and Most Hours Worked';
run;

**---Example 12: Identifying the Top Three Extreme Values with the Output Statistics---**;
proc format;
value yrFmt . = " All";
value $schFmt ' ' = "All ";
run;
proc means data=Charity noprint;
class School Year;
types () school year;
var MoneyRaised;
output out=top3list(rename=(_freq_=NumberStudents))sum= mean=
idgroup( max(moneyraised) out[3] (moneyraised name
school year)=)/autolabel autoname;
label MoneyRaised='Amount Raised';
format year yrfmt. school $schfmt.
moneyraised dollar8.2;
run;
proc print data=top3list;
title1 'School Fund Raising Report';
title2 'Top Three Students';
run;
proc datasets library=work nolist;
contents data=top3list;
title1 'Contents of the PROC MEANS Output Data Set';
run;

**---Example 13: Using the STACKODSOUTPUT Option to Control Data---**;
proc means data=sashelp.class;
class sex;
var weight height;
ods output summary=default;
run;
proc print data=default; run;
proc contents data=default; run;


*================================================================================================*;
*===                                   MIGRATE                                                ===*;
*================================================================================================*;

*---Example 1: Migrating across Computers---*;
signon serv-ID sascmd='my-sas-invocation-command';
rsubmit;
libname Source <engine> 'source-library-pathname';
endrsubmit;
libname Source <engine> server=serv-ID;
libname Target <engine> 'target-library-pathname';
proc migrate in=Source out=Target <options>;
run;

*---Example 2: Migrating with Incompatible Catalogs across Computers---*;
signon v8srv sascmd='my-v8¨Csas-invocation-command';
rsubmit;
libname Srclib <engine> 'source-library-pathname';
endrsubmit;
libname Source <engine> '/nfs/v8machine-name/source-library-pathname';
libname Srclib <engine> server=v8srv;
libname Target <engine> 'target-library-pathname';
proc migrate in=Source out=Target slibref=Srclib <options>;
run;
proc migrate out=Target slibref=Srclib <options>;
run;

*---Example 3: Migrating on the Same Computer---*;
libname Source <engine> 'source-library-pathname';
libname Target base 'target-library-pathname';
proc migrate in=Source out=Target;
run;


*---Example 4: Migrating with Incompatible Catalogs on the Same Computer---*;
signon v8srv sascmd='my-v8¨Csas-invocation-command';
rsubmit;
libname Srclib <engine> 'source-library-pathname';
endrsubmit;
libname Srclib <engine> server=v8srv;
libname Source <engine> 'source-library-pathname';
libname Target <engine> 'target-library-pathname';
proc migrate in=Source out=Target slibref=Srclib <options>;
run;
proc migrate out=Target slibref=Srclib <options>;
run;

*---Example 5: Migrating from a SAS?9 Release with Incompatible Catalogs---*;
signon serv-ID sascmd='my-sas-invocation-command';
rsubmit;
libname Source <engine> 'source-library-pathname';
endrsubmit;
libname Source <engine> server=serv-ID;
libname Target <engine> 'target-library-pathname';
proc migrate in=Source out=Target <options>;
run;

