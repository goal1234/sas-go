*===How to convert all character variables to numeric and use the same variable names in the output data se===*;
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

*===Use a Microsoft Excel file to create a user-defined format===*;
/* Create an Excel spreadsheet for the example. */                                                                                       
proc export data=sashelp.class outfile=test                                                                                             
     dbms=xlsx outfile='c:\temp\exceltest.xlsx' replace;                                                                                   
run;                                                                                                                                    
                                                                                                                                        
/* Read the Excel spreadsheet and create a SAS data set. */                                                                             
proc import datafile='c:\temp\exceltest.xlsx' out=work.testfmt dbms=xlsx replace;                                                       
run;                                                                                                                                    
 
/* Remove duplicate values */
proc sort data=testfmt nodupkey;                                                                                                        
   by age;                                                                                                                                
run;                                                                                                                                    
                                                                                                                                        
/* Build control data set */                                                                                                            
data new(rename=(age=start) keep=age fmtname label);                                                                                    
   retain fmtname 'testfmt';                                                                                                 
   length label $8.;                                                                                                                    
   set testfmt;                                                                                                                         
   if age <= 12 then label='Pre-teen';                                                                                                  
   else if age ge 13 and age < 20 then label='Teen';
   else label='Adult'; 
run;                                                                                                                                    
                                                                                                              
/* Create the format using the control data set. */                                                                                     
proc format cntlin=new;                                                                                                                 
run;                                                                                                                                    
                                                                                                                                        
/* Display average height by formatted values */                                                                                
title;                                                                                                                                  
ods listing close;                                                                                                                      
ods html file="c:\avgheight.htm" style=styles.sasweb;                                                                                         
                                                                                                                                        
proc report data=sashelp.class nowd split='/';                                                                                                    
   title 'Using Control Data Set to generate a format with Excel file';                                                                 
   col age height n;  
   define n / 'Count'; 
   define age / group;                                                                                                       
   define height / mean 'Average Height /in Inches' f=6.2;   
format age testfmt.; 
run;                                                                                                                                    
                                                                                                                                        
ods html close;                                                                                                                         
ods listing; 

*===Merge multiple data sets and output matches only===*;
/* Create three sample data sets */

data file1;
  input var name $;
datalines;
100 Anja
200 Bob
400 Chandra
600 Darrin
;

data file2;
  infile datalines dsd truncover;
  input var address $ 13.;
datalines;
100,34 Smith Road
200,67 Burt Ave
300,12 You St
400,45 Younge St
500,79 Wellington
600,23 Done Road
;

data file3;
  input var zip;
datalines;
100 28092
200 27502
300 27539
600 27526
;

/* The IN= variable is a boolean flag that resets when a BY-Group */
/* changes. To output only matches from the MERGE, test for the   */
/* condition that the current BY-Group is found in all data sets. */
/*                                                                */
/* Sample data is already in sorted order by VAR, so no sorting   */
/* is needed.                                                     */

data three;
  merge file1 (in=a) file2 (in=b) file3 (in=c);
  by var;
  if a and b and c;
run;

proc print data=three;
run;

*== Count for certain number of consecutive weekdays===*;
/* sample data */
data one;
input acct reportdate:date9. ;
format reportdate date9.;
datalines;
11111 08Oct2008 
11111 09Oct2008 
11111 10Oct2008 
11111 13Oct2008 
11111 16Oct2008 
22222 08Oct2008 
22222 10Oct2008 
22222 14Oct2008 
22222 01Oct2008 
22222 05Oct2008 
;
run;

proc sort;
  by acct reportdate;
run;

/* put weekends into a data set and weekdays in another using */
/* WEEKDAY function                                           */
data weekends weekdays;
  set one;
  if weekday(reportdate) in(1,7) then output weekends;
  else output weekdays;
run;

/* Compute the lag of REPORTDATE. Increment COUNT by 1 if the     */
/* current observation is a Monday and the previous is a Friday.  */
/* Also increment COUNT by 1 if the previous observation and      */
/* current are just 1 day apart. I                                */
data other;
  set weekdays;
  by acct;
  lg=lag(reportdate);
  day=weekday(reportdate);
  if first.acct then count=1;
  if day=2 and weekday(lg)=6 then count+1;
  else if lg=reportdate-1 then count+1;
  else count=1;
proc print;run;

/* put data sets back together */
data final;
  set other weekends;
  by acct reportdate;
proc print;run;

