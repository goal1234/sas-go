

option user = work;

*-带格式的输出-*;


* - 定义style- *;
ods  tagsets.excelxp  file="d:\test.xls" options(sheet_name="print") style=analysis;
proc print data=sashelp.class;
 title1 'what is it?';
run;
ods  tagsets.excelxp  options(sheet_name="freq");
proc freq data=sashelp.class;
     tables sex;
run;
ods tagsets.excelxp close;

*---定义一个style---*;
proc template;
define style Styles.Custom;
parent = Styles.RTF;
replace fonts /
	'TitleFont' = ("Times Roman",13pt,Bold) /* Titles from TITLE statements */
	'TitleFont2' = ("Times Roman",12pt,Bold Italic) /* Procedure titles ("The _____
	Procedure")*/
	'StrongFont' = ("Times Roman",10pt,Bold)
	'EmphasisFont' = ("Times Roman",10pt,Italic)
	'headingEmphasisFont' = ("Times Roman",11pt,Bold Italic)
	'headingFont' = ("Times Roman",10pt) /* Table column and row headings */
	'docFont' = ("Times Roman",10pt) /* Data in table cells */
	'footFont' = ("Times Roman",10pt) /* Footnotes from FOOTNOTE statements */
	'FixedEmphasisFont' = ("Courier",9pt,Italic)
	'FixedStrongFont' = ("Courier",9pt,Bold)
	'FixedHeadingFont' = ("Courier",9pt,Bold)
	'BatchFixedFont' = ("Courier",6.7pt)
	'FixedFont' = ("Courier",9pt);
	replace color_list /
	'link' = blue /* links */
	'bgH' = white /* row and column header background */
	'fg' = black /* text color */
	'bg' = white; /* page background color */;
	replace Body from Document /
	bottommargin = 0.25in
	topmargin = 0.25in
	rightmargin = 0.25in
	leftmargin = 0.25in;
	replace Table from Output /
	frame = hsides /* outside borders: void, box, above/below, vsides/hsides, lhs/rhs */
	rules = groups /* internal borders: none, all, cols, rows, groups */
	cellpadding = 5pt /* the space between table cell contents and the cell border */
	cellspacing = 0pt /* the space between table cells, allows background to show */
	borderwidth = 0.5pt /* the width of the borders and rules */;
	* Leave code below this line alone ;
	style SystemFooter from SystemFooter /
	font = fonts("footFont");
	end;
run; 


*-examples2;
ods excel file="c:\projects\output\example.xlsx" 
 /* will apply an appearance style */
 style=pearl
 options(
  /* for multiple procs/sheet */
  sheet_interval="none" 
  /* name the sheet tab */
  sheet_name="CARS summary"
 );
 
/* add some formatted text */
ods escapechar='~';
ods text="~S={font_size=14pt font_weight=bold}~Cars Summary and Histogram";
 
/* tabular output */
proc means data=sashelp.cars;
var msrp invoice;
run;
 
/* and a graph */
ods graphics / height=400 width=800 noborder;
proc sgplot data=sashelp.cars;
histogram msrp;
run;
 
ods excel close;


* -example3- *;
/* Create a new FB summary and report workbook for this snapshot 
   of Facebook data                                             */
filename fbout "c:\temp\FBReport_&SYSDATE..xlsx";
 
/* A little ODS style trick to make headings in my sheet */
ods escapechar='~';
%let bold_style=~S={font_size=12pt font_weight=bold}~;
 
/* CREATES a new XLSX file */
ods excel (id=fb) file=fbout
  /* choose a style you like */
  style=pearl
  /* SHEET_INTERVAL of NONE means that each PROC won't generate a 
     new sheet automatically                                     */
  options (sheet_interval="none" sheet_name="Summary")
  ;
 
ods noproctitle;
ods text="&SYSDATE. Friend Report for &myFacebookName";
proc sql;
     select count(distinct(UserId)) as 
         Number_Of_Friends into: NumberOfFriends
	 from friends;
quit;
 
ods text="&bold_style.Count of friends by gender";
proc freq data=frienddetails
	order=internal;
	tables gender / 
	nocum   
	scores=table;
run;
 
ods text="&bold_style.Calculated Ages based on Graduation years";
proc means data=ages
	min max mean median p99;
	var age;
	class how;
run;
 
ods graphics on / width=800 height=300;
ods text="&bold_style.Count of friends by Relationship Status";
proc freq data=frienddetails
	order=internal;
	tables relationshipstatus / 
	nocum   
	scores=table plots(only)=freqplot;
run;
 
ods excel (id=fb) close;
 
/* ADDS new SHEETS to the existing XLSX file */
proc export data=frienddetails
  dbms=xlsx
  outfile=fbout replace;
  sheet="Friend Details";
run;
 
proc export data=schoolfriends
  dbms=xlsx
  outfile=fbout replace;
  sheet="Schools";
run;
 
proc export data=statusprep(keep=name date message)
  dbms=xlsx
  outfile=fbout replace;
  sheet="Latest Status";
run;
