*===Convert variable values from character to numeric or from numeric to character===*;
/* Example 1: The simplest case character to numeric */
/* The resulting data set has both the original character variable and a new */
/* numeric variable.  If you want the result to have just one variable with  */
/* the original name, uncomment the DROP and RENAME statements. */

data new1;
   orig_var = '80000';
   new_var = input(orig_var,8.);
/* drop orig_var; */
/* rename new_var = orig_var; */
run;
proc print; 
run;

/* Example 2a and 2b: Character to numeric with additional characters in original string */
/* You can comment out the FORMAT statements to see what the unformatted value looks like. */

data new2a;
   orig_var = "12%";
   new_var = input(orig_var, percent8.);
   format new_var percent8.;
run;
proc print;
run;

data new2b;
   orig_var = "43,000.24";
   new_var = input(orig_var, comma9.2);
   format new_var comma9.2;
run;
proc print; 
run;

/* Example 3: Multiple input values with a blank character value for one of the values. */
/* The result has a standard numeric missing value of . for the converted value.  */

data old3;
   infile datalines truncover;
   input orig_var :$12.;
   datalines;
1234
0
99999

56
;
run;

data new3;
   set old3;
   new_var = input(orig_var,8.);
run;
proc print; 
run;

/* Example 4: Convert a character date to a SAS date.  By looking through the informat */
/* documentation, I see that the structure mm-dd-yyyy is read by the MMDDYY10. informat. */
/* I have chosen to format the resulting SAS date with the DATE9. format. */

data new4;
   orig_var = '04-23-2013';
   new_var = input(orig_var,mmddyy10.);
   format new_var date9.;
run;
proc print; 
run;

/* Example 5a: Convert a character time value to a SAS time */
/* variable and format it to look the same as the original value. */

data new5a;
   orig_var = '10:12:34';
   new_var = input(orig_var,time8.);
   format new_var time8.;
run;
proc print; 
run;

/* Example 5b: Same as 5a but ends up with the same name for the resulting variable.*/
/* Format it to look the same as the original.  */

/* The RENAME statement affects the name in the output data set, not during the current */
/* DATA step.  During the current DATA step, you use the old variable name in programming */
/* statements.  That is why you see the FORMAT on New_var (the initial variable name for */
/* the created variable), but the resulting output has the format inherited by the new */
/* name from the RENAME which is Orig_var. */

/* For more information, see the Statements Reference documentation.*/

data new5b;
   orig_var = '10:12:34';
   new_var = input(orig_var, time8.);
   drop orig_var;
   rename new_var = orig_var;
   format new_var time8.;
run;
proc print;
run;

/* Example 6: Convert a character datetime to a SAS datetime */

data new6;
   orig_var = '12MAY2014:01:13:55';
   new_var = input(orig_var,datetime20.);
   format new_var datetime20.;
run;
proc print;
run;

/* Example 7: Numeric to character and end up with the original variable name */

data new7;
   orig_var = 189;
   new_var = put(orig_var,8.);
   drop orig_var;
   rename new_var = orig_var;
run;
proc print;
run;

/* Example 8: Numeric to character with left alignment using DATALINES to read in */
/* multiple numeric values.  You can remove the -L to see the different result in the */
/* output without it. */

data new8;
   input orig_var 8.;
   new_var = put(orig_var, 12. -L);
   datalines;
123
8345521
.
99
;
run;
proc print;
run;

/* Example 9: Putting it all together: Convert a numeric value that looks like */
/* MMDDYYYY, but is a true numeric value with no format applied, to a SAS date. */

data new9;
   orig_var = 10122012;
   char_var = put(orig_var,8.);
   sas_date = input (char_var,mmddyy8.);
   format sas_date mmddyy8.;
run;
proc print;
run;

*===Perform a fuzzy merge by comparing strings for similarities===*;
/*Create data set of valid magazine names.*/
data mags;
input title $char30.;
datalines;
Science 
Discover
Nature Today
Journal of Medicine
Outside
;
run;

/*Create data set of articles with magazine name.  Some of the magazine names are not quite correct.*/
data articles;
infile datalines dlm=',';
input magtitle :$30. article :$30.;
datalines;
Science, Bears
Sciene, Cats
Sciences, Dogs
Discovery, Stars
Discover, Planets
Outdoors, Hiking
;

/*Generate two output data sets: MATCH if the magazine names are an exact match and */
/*CLOSE if the distance between the magazine names is within the value we have set.*/

/*First, we read in all the correct magazine titles from the MAGS data set into an array.*/
/*Then we read through each observation in the data set ARTICLES.  If the magazine names*/
/*are an exact match, we output to MATCH and stop checking for a magazine.  If COMPLEV returns*/
/*a distance of less than or equal to 5 (chosen arbitrarily to get matches we consider*/
/*"close enough"), then the observation is written to the CLOSE data set.*/

data match (keep = magtitle article) 
close (keep=distance magtitle possible_mag article);
array mags[5] $20 _temporary_;
do until (done);
	set mags end=done;
	count+1;
	mags[count] = title;
end;

do until (checkdone);
	set articles end=checkdone;
	do i = 1 to dim(mags);
		distance = complev(magtitle, mags[i],'iln');
		if distance=0 then do;
			output match;
			leave;
		end;
		else if distance <= 5 then do;
			possible_mag = mags[i];
			output close;
		end;
	end;
end;
stop;
run;

*===How to find a specific value in any variable in any SAS? data set in a library===*;
options nomprint nomlogic nosymbolgen nonotes;
/* Create test data sets */

libname test 'c:\';
data test.one;
  x=1;
  y='hi';
  z='***find me***';
run;

data test.two;
  x=5;
  a='***find me***';
run;

data test.three;
  x=5;
run;

/* Find data sets names and store in a macro variable */

%macro grep(librf,string);  /* parameters are unquoted, libref name, search string */
%let librf = %upcase(&librf);
  proc sql noprint;
    select left(put(count(*),8.)) into :numds
    from dictionary.tables
    where libname="&librf";

    select memname into :ds1 - :ds&numds
    from dictionary.tables
    where libname="&librf";

  %do i=1 %to &numds;
    proc sql noprint;
    select left(put(count(*),8.)) into :numvars
    from dictionary.columns
    where libname="&librf" and memname="&&ds&i" and type='char';

    /* Create list of variable names and store in a macro variable */

    %if &numvars > 0 %then %do;
      select name into :var1 - :var&numvars 
      from dictionary.columns
      where libname="&librf" and memname="&&ds&i" and type='char';
      quit;

      data _null_;
        set &librf..&&ds&i;
          %do j=1 %to &numvars;
            if &&var&j = "&string" then
            put "String &string found in dataset &librf..&&ds&i for variable &&var&j";
          %end;
        run;
    %end;
  %end; 
%mend;

%grep(test,***find me***);

*===How to search a variable for any character that may be an unprintable character or not a standard ASCII character===*;
ebcdic_string=put(ascii_string,$ebcdic96.);

data test;                                        
length ascii_string $ 96;                         
do x = 32 to 127;                                 
  ascii_string=trim(left(ascii_string))||byte(x); 
end;                                                   
test_var="534153205396667477617265"x;                       
not_ascii=verify(test_var,ascii_string);        
run;                                             
    
*===How to convert all character variables to numeric and use the same variable names in the output data set===*;
/*The sample data set TEST contains both character and numeric variables*/

data test;                                                
input id $ b c $ d e $ f;                                 
datalines;                                                
AAA 50 11 1 222 22                                        
BBB 35 12 2 250 25                                        
CCC 75 13 3 990 99                                        
;                                                         
/*PROC CONTENTS is used to create an output data set called VARS to list all */
/*variable names and their type from the TEST data set.                      */                                                          

proc contents data=test out=vars(keep=name type) noprint; 
 
/*A DATA step is used to subset the VARS data set to keep only the character */
/*variables and exclude the one ID character variable.  A new list of numeric*/ 
/*variable names is created from the character variable name with a "_n"     */
/*appended to the end of each name.                                          */                                                        

data vars;                                                
set vars;                                                 
if type=2 and name ne 'id';                               
newname=trim(left(name))||"_n";                                                                               

/*The macro system option SYMBOLGEN is set to be able to see what the macro*/
/*variables resolved to in the SAS log.                                    */                                                       

options symbolgen;                                        

/*PROC SQL is used to create three macro variables with the INTO clause.  One  */
/*macro variable named c_list will contain a list of each character variable   */
/*separated by a blank space.  The next macro variable named n_list will       */
/*contain a list of each new numeric variable separated by a blank space.  The */
/*last macro variable named renam_list will contain a list of each new numeric */
/*variable and each character variable separated by an equal sign to be used on*/ 
/*the RENAME statement.                                                        */                                                        

proc sql noprint;                                         
select trim(left(name)), trim(left(newname)),             
       trim(left(newname))||'='||trim(left(name))         
into :c_list separated by ' ', :n_list separated by ' ',  
     :renam_list separated by ' '                         
from vars;                                                
quit;                                                                                                               
 
/*The DATA step is used to convert the numeric values to character.  An ARRAY  */
/*statement is used for the list of character variables and another ARRAY for  */
/*the list of numeric variables.  A DO loop is used to process each variable   */
/*to convert the value from character to numeric with the INPUT function.  The */
/*DROP statement is used to prevent the character variables from being written */
/*to the output data set, and the RENAME statement is used to rename the new   */
/*numeric variable names back to the original character variable names.        */                                                        

data test2;                                               
set test;                                                 
array ch(*) $ &c_list;                                    
array nu(*) &n_list;                                      
do i = 1 to dim(ch);                                      
  nu(i)=input(ch(i),8.);                                  
end;                                                      
drop i &c_list;                                           
rename &renam_list;                                                                                      
run;  

*=== Create multiple formats from one data set===*;
options formdlim=' ';

data format;
   input OccCode $ OccCode_formatted $23. name $ region $;
   cards;
0  None                    John    NE 
27 Laborer                 Mary    NW
3  Service                 Sue     SE
4  Service Administration  Peter   SW
15 Engineer                Paul    CENTRAL
;
run;

data cntlone;
   set format; 
   fmtname="$OccCode";
   start=OccCode;
   label=OccCode_formatted;
   type='C';
   output ;

   fmtname="$Region";
   start=region;
   type='C';
   if region in('NE' 'NW') then label='North';
   else if region in('SE' 'SW') then label='South';
   else label=region;
   output ;
run;

/* Sort the CNTLIN data set to group format rows together */
proc sort data=cntlone;
   by fmtname start;
run;

proc format cntlin=cntlone; 
run;

/* For debugging purposes, verify that formats are on the library */
options linesize=120;

proc format library=work fmtlib; 
   select $OccCode $Region;
run;

 
	
