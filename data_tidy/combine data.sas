*===Using the equivalent of CONTAINS and LIKE in an IF statement===*;
data test;
   input name $;
   datalines; 
John
Diana
Diane
Sally
Doug
David
DIANNA
;
run;

data test;
   set test;
   if name =: 'D';
   /* the syntax to select observations that /*
   /*  do not match the pattern is below */
   *if name not =: 'D';
   /* equivalent WHERE clause */
   *where name like 'D%';
run;

proc print;
run;

*===Generate every combination of observations between data sets===*;
/* Create two test data sets */

data one;                  
  input id $ fruit $;      
datalines;                 
a apple                    
a apple                    
b banana                   
c coconut                  
c coconut                  
c coconut                  
;                          
                           
data two;                  
  input id $ color $;      
datalines;                 
a amber                    
b brown                    
b black                    
c cocoa                    
c cream                    
;               
 
data every_combination;

  /* Set one of your data sets, usually the larger data set */
  set one;
  do i=1 to n;

    /* For every observation in the first data set,    */
    /* read in each observation in the second data set */ 
    set two point=i nobs=n;
    output;
  end;
run;

proc print data=every_combination;
run;

*===Collapse observations in BY-Group so values from duplicate observations have new names===*;
data visits;
input dovisit date9. person_id sex :$1. nvisit :$1. fvisit :$1. avisit :$1.;
datalines;
18dec2007 444 M T F F
18dec2007 444 M T F F
10jan2007 365 M T F F
10jan2007 365 M T F F
01feb2007 212 F T T T
01feb2007 212 F T F T
;
run;


/*create a data set of the duplicates using DUPOUT= option  */

proc sort data=visits dupout=visits_dup nodupkey;
  by person_id;
run;

/* Create a macro variable with the variable names that are to     */
/* be merged.  The variables considered BY variables are excluded  */
/* from going into the macro variable using the NOT IN operator.   */
/* The resulting macro variable is in the format varname=varname_2 */                                             
proc sql noprint;                                                                                                                       
  select trim(name) || '=' || trim(name) || '_2'                                                                                        
  into :varlist separated by ' '                                                                                                        
  from DICTIONARY.COLUMNS                                                                                                               
  WHERE LIBNAME EQ "WORK" and MEMNAME EQ "VISITS"
  and upcase(name) not in ('PERSON_ID' 'DOVISIT' 'SEX');                                                                                                                                                                                          
quit;

/*Merge the two data sets using the macro variable to rename the  */
/*common variables in the second (duplicates) data set.           */
data merged;
  merge visits visits_dup (rename=(&varlist));
  by person_id;
run;

proc print;
run;

*===A one-to-many merge with common variables that are not the BY variables will have values from the many data set after the first observation===*;
/* Create the "many" data set, SCORES, that has multiple observations per ID.        */
/* It has some incorrect names.                                                      */

data scores;
   input id name :$8. score;
   datalines;
1 Jo 100
1 Jo 90
1 Jo 95
2 John 89
2 John 92
;
run;

/* Create the "one" data set, NAMES, that has one observation per ID.  It has        */
/* corrected values for names.                                                       */

data names;
   input id name :$8.;
   datalines;
1 Joanna
2 Jon
;
run;

/* First merge with the common variable and note how the values from the second and */
/* subsequent observations of the "many" data set are not overwritten.              */

data results_common_variable;
   merge scores names;
   by id;
run;
title "Results from Common Variable";
proc print; 
run;

/* Rename the variable from the "many" data set so that the value from the "one" data */
/* set is carried down the by-group.                                                  */

data results_renamed_variable;
   merge scores(rename=(name=old_name)) names;
   by id;
run;
title "Results from Renamed Variable";
proc print; 
run;

*=== Perform a fuzzy merge by comparing strings for similarities===*;
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

*=== Using KEY= to update a data set containing duplicates ===*;
/*****************************************************************************/
/* An index is created for data set STORE (master) using the INDEX= data set */
/* option for the key variable ITEM.                                         */
/*                                                                           */
/* An observation is read from the GROCERY_LIST (transaction) data set and   */
/* and a matching observation in STORE is located using the index. The       */
/* automatic variable _IORC_ is tested using the mnemonics defined in the    */
/* SAS-supplied %SYSRC autocall macro.  The value _SOK means a match was     */
/* found, and the value _DSENOM means a match was not found.                 */
/*****************************************************************************/

/* Example 1: Only first matching observation updated */
/*            due to duplicates in master             */

data Dairy(index=(Item));
  input Item $ Inventory Price ;
datalines;
Milk 15 1.99
Milk 3 1.99
Soymilk 8 1.79
Eggs 24 1.29
Cheese 14 2.19
;

data Dairy_current_price;
  input Item $ price_increase;
datalines;
Milk .05
Butter .10
;

data Dairy;
  set Dairy_current_price;
  modify Dairy key=Item;
  select (_iorc_);
    when (%sysrc(_sok)) do;
      /* calculate new price for match, and replace observation */
      Price=Price + Price_increase;
      replace;
    end;
    when (%sysrc(_dsenom)) do;

      /* When item is not in master, reset _ERROR_ flag */
      /* and output note to log.                        */
      _ERROR_=0;
      put "Item not in stock --- " Item;
    end;
    otherwise do;      /* Unplanned condition, stop the data step */
      put 'Unexpected ERROR: _iorc_= ' _iorc_;
      stop;
    end;
  end;
run;

proc print data=dairy;
run;

/* Example 2: Forcing updates to occur on all duplicates in master */

/* Use DO loop to apply single transaction to multiple consecutive */
/* duplicates in master data set.                                  */

data Dairy(index=(Item));
  input Item $ Inventory Price ;
datalines;
Milk 15 1.99
Milk 3 1.99
Soymilk 8 1.79
Eggs 24 1.29
Cheese 14 2.19
;

data Dairy_current_price;
  input Item $ price_increase;
datalines;
Milk .05
Butter .10
;


data Dairy;
  set Dairy_current_price;
  master_count = 0;
  do until (_IORC_=%SYSRC(_DSENOM));
  modify Dairy key=Item;
   select (_iorc_);
    when (%sysrc(_sok)) do;
      Price=Price + Price_increase;
      master_count + 1;
      replace;
    end;
    when (%sysrc(_dsenom)) do;
      _ERROR_=0;
      if master_count = 0 then put "Item not in stock --- " Item;
    end;
    otherwise do;
      put 'Unexpected ERROR: _iorc_= ' _iorc_;
      stop;
    end;
   end;
  end;
run;

proc print data=dairy;
run;

proc datasets library = work;
  work.list;
run;

*===Understanding automatically retained variables when performing a merge: results of doing a merge and conditional processing in the same DATA step===*;
data one;
   input a b;
   datalines;
10 10 
10 20 
10 30
10 40
10 50
;
run;

data two;
   input a c;
   datalines;
10 100
;
run;

/*
   Do the merge and subset in two DATA steps

   The data set MATCH1 is created via a many-to-one merge.
   The value of variable C carries down the BY-Group, as is
   the nature of merge.
*/

data match1;
   merge one two;
   by a; 
run;

/*
  Subsetting with a second step

  Since you are doing a separate SET to the data set, 
  any changes that are made to a variable's
  value apply only to that observation. Note that only 
  one observation has a value of 50 for C in this example.
*/

data match2 ;
   set match1;
   if b = 20 then c = 50;
run;

/* RESULTS *

  Obs     a     b     c

   1     10    10    100
   2     10    20     50
   3     10    30    100
   4     10    40    100
   5     10    50    100

*===How to combine SAS generation data sets into one SAS data set===*;
/* Use PROC CONTENTS to obtain the information on how many  */
/* generations exist and the maximum number of generations  */
/* that can exist.                                          */


proc contents data=dsn out=dsncont(keep=genmax gennext) noprint;
run;

/* SET the SAS data set that is a result of PROC CONTENTS.   */
/* Based on the values of GENMAX and GENNEXT, determine how  */
/* many generations exist for the SAS data set and put that  */
/* value into a macro variable.                              */


data _null_;
  set dsncont;
  if (gennext > genmax) then count=genmax-1;
  else count=gennext-1;
  call symput('count',left(put(count,8.)));
run;


/* Use macro DO loop with macro variable created in the above */
/* DATA step to determine how many times the PROC APPEND      */
/* iterates to create a new SAS data set with all generations */
/* of the SAS data set.                                       */


%macro combgens;
  %do i=0 %to &count;
    proc append base=newdsn data=dsn(gennum=-&i);
    run;
  %end;
%mend combgens;
%combgens

*===Linguistic collation with PROC SORT===*;
data a;
  input name $ weight;
datalines;
ted 155
thea 134
;
run;

data b;
  input name $ height;
datalines;
TED 32
ThEa 24
;
run;

proc sort data=a sortseq=linguistic(strength=2); by name; run;
proc sort data=b sortseq=linguistic(strength=2); by name; run;

data c;
  merge a b;
  by name;
run;

proc print data=c; run;

*===Adding variables from a transaction data set to a master data set based upon a common variable===*;
/* Create sample data for a master and transaction data set */

data master;                               
  input fruit $ Y;                         
datalines;                              
apple 11                                  
apple 22                                 
apple 33                                  
pear  11                                  
;                                          
                                           
data trans;                                
  input fruit $ Z;                         
datalines;                              
apple 89                                    
apple 94                                    
apple 83                                    
pear 77                                    
pear 88                                    
pear 99                                    
;                   

data combined;                                
  inmast=0;                                  
  merge master(in=inmast) trans;             
  by fruit;                                   
  if inmast;                                 
run;                                          
                                              
proc print data=combined;                                             
run;

*===Appending a single observation data set to all observations in another data set===*;
data dept;                                                              
  infile datalines truncover;                                             
  input dept $20.;                                                        
datalines;                                                              
Technical Support                                                       
;
                                                                       
data empl;                                                              
  infile datalines truncover;                                             
  input empl name $20.;                                                   
datalines;                                                              
112 Simons, Alex                                                        
115 Wang, Stephen                                                       
143 Preston, Julie                                                      
178 Patrick, Douglas                                                    
196 Hollingsworth, Karen                                                
;                                                                       
                                                                        
                                                                        
/*  Variable values being read with the SET statement are retained across    */
/*  iterations of the DATA step.  For efficiency, SET WORK.DEPT on the first */
/*  iteration of the step.  Variables unique to WORK.DEPT will carry down    */
/*  all the observations from WORK.EMPL.                                     */
                                                                      
data techdept;                                                          
  if _n_=1 then set dept;                                                 
  set empl;                                                               
run;
 
proc print data=techdept;                                               
run;

*===Create a new data set from multiple data sets based upon sorted order===*;
data animal;                 
  input common $ animal $;
datalines;
a     Ant 
a     Ape           
b     Bird           
c     Cat            
d     Dog            
;

data plant;
  input common $ plant $;
datalines; 
a     Apple
b     Banana
c     Coconut
d     Dewberry
e     Eggplant
f     Fig
;


data interleaving;
  set animal plant;
  by common;
run;

proc print data=interleaving;
run;

*===Use formatted value to combine data sets===*;
data one;
  input date :mmddyy6. x $;
  format date date9.;
datalines;
010104 a
011504 b
012804 c
020204 a
022904 b
031304 a
031504 b
;

data two;
  input date :mmddyy6. y;
datalines;
011204 111
021504 222
031704 333
;

data three;
  format date monyy7.;
  merge one two;
  by groupformat date;
run;

proc print data=three;
run;

*===Merge observations from multiple data sets based upon a common variable===*;
/*******************************************************************************/
/* The objective is to create a new data set that matches each individual with */
/* the correct sale and bonus based on corresponding ID values.  This program  */
/* match-merges the data sets ONE, TWO, and THREE to create a single data set  */
/* that contains variables ID, NAME, SALE, and BONUS.                          */
/*                                                                             */
/* Data set TWO contains multiple occurrences of some values of ID, while ONE  */
/* and THREE contain only one occurrence.  Because values of NAME and BONUS    */
/* (which are read from ONE and THREE) are automatically retained across the   */
/* BY-group, multiple observations with the same value for ID contain the      */
/* correct NAME and BONUS values.                                              */
/*******************************************************************************/

/* Create sample data */ 
 
data one; 
  input id name& $20.; 
datalines;                                                                   
1 Nay Rong                                                                      
2 Kelly Windsor                                                                 
3 Julio Meraz                                                                   
4 Richard Krabill                                                               
5 Rita Giuliano                                                                 
; 
                                                                                
data two;                                                                       
  input id sale;                                                               
  format sale dollar10.;                                                       
datalines;                                                                   
1 28000                                                                         
2 30000 
2 40000 
3 15000
3 20000                                                                       
3 25000                                                                        
4 35000                                                                         
5 40000                                                                         
;                                                                               
                                                                              
data three;                                                                     
  input id bonus;                                                              
  format bonus dollar10.;                                                      
datalines;                                                                   
1 2000                                                                          
2 4000                                                                          
3 3000                                                                          
4 2500                                                                          
5 2800                                                                          
; 

data final; 
  merge one two three;                                                         
  by id;                                                                       
run;                                                                            
                                                                                
proc print data=final;                                                                                                                     
run;

*===Combining multiple data sets with differing attributes for the BY variable===*;
/*********************************************************************************/
/* Note the type and lengths of the BY variables is not consistent for all       */
/* three data sets.                                                              */
/*                                                                               */
/* In the first data set the Zw.d format is associated with SALE.  In the second */
/* data set SALE used the DOLLARw.d format.  Use and ATTRIB statement to         */
/* associate the DOLLAR7.2 format with SALE in the final data set.               */
/*********************************************************************************/

data sample1;
  input id $5. team $ sale;
  format sale z5.2;
datalines;
00345 red 9.15
01234 blue 4.75
55555 green 10.38
;

data sample2;
  input id :$7. team $ sale flag :$3.;
  format sale dollar7.2;
datalines;
00345 red 8.15 -1
01234 blue 5.75 +1
10000 yellow 5.00 +0
55555 green 11.38 +1
;

data sample3;
  input id num;
datalines;
00345 1
01234 3
55555 2
;

/* SAMPLE3 has the wrong type for ID.  Change the type from numeric to character */
/* prior to the MERGE.  Use the RENAME= option to allow the original variable    */
/* name to be used as the new variable name in the type conversion.  DROP=       */
/* keeps the old numeric version of ID from being added to NEW_SAMPLE3.          */

data new_sample3 (drop=numid);
  set sample3 (rename=(id=numid));
  id=put(numid,z5.-l);
run;

data final;
  attrib id length=$5
  sale format=dollar7.2;
  merge sample1 sample2 new_sample3;
  by id;
run;

proc print data=final;
run;

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

*===Performing a table lookup on an indexed data set===*;
/*****************************************************************************/
/* An index is created for data set STORE (master) using the INDEX= data set */
/* option for the key variable ITEM.                                         */
/*                                                                           */
/* An observation is read from the GROCERY_LIST (transaction) data set and   */
/* a matching observation in STORE is located using the index.  The          */
/* automatic variable _IORC_ is tested using the mnemonics defined in the    */
/* SAS-supplied %SYSRC autocall macro.                                       */
/*                                                                           */
/* The value _SOK means there was a match found in the master data set,      */
/* and the value _DSENOM means a match was not found.                        */      
/*****************************************************************************/
                    
data store(index=(Item));
  input Item $ Inventory Aisle $;
datalines;
Milk 15 A
Soymilk 8 A
Eggs 24 A
Cheese 14 A
Bread 12 D
Muffins 8 D
;

data Grocery_List;
  input Item $ Quantity;
datalines;
Bread 2
Milk 1
Butter 1
;

data shop;

  /* Value of KEY variable comes from transaction data set */
  set Grocery_List;

  /* Index used to find matches for KEY= value */
  set store key=Item;

  /* Check return code from search */
  select (_iorc_); 

    /* Match found */                                  
    when (%sysrc(_sok)) do;
      output;
    end;
 
    /* Match not found in master */  
    when (%sysrc(_dsenom)) do;
      _ERROR_=0;
      /* Reset values in PDV from last matched condition */
      inventory=.;
      Aisle='N/A';
      output;
    end;

    otherwise do;                                          
      put 'Unexpected ERROR: _iorc_= ' _iorc_;  
      stop;                                    
    end; 
  end; 
run;

proc print data=shop;
run;

/* Alternative Technique  -- Same output results, but the observation order */
/*                           may be different                               */

/* This is a left outer join, which returns rows that satisfy the condition */
/* in the ON clause.  In addition, a left outer join returns all the rows   */
/* from the left table (first table listed in the FROM clause) that do not  */
/* match with a row from the right table (second table listed in the FROM   */
/* clause).                                                                 */

proc sql;                                                                         
  create table shop2 as                                                          
    select Grocery_List.Item, Quantity, Inventory, 
      coalesce(Aisle,"N/A") as Aisle 
        from Grocery_List left join store                                         
          on Grocery_List.Item=store.Item;                                        
quit;


*===Using the SET statement to concatenate data sets===*;
data one;
  input name $ age;
datalines;
Chris 36
Jane 21
Jerry 30
Joe 49
;

data two;
  input name $ age group;
datalines;
Daniel 33 1
Terry 40 2
Michael 60 3
Tyrone 26 4
;

data both;
  set one two;
run;

proc print data=both;
run;

*===Combine data sets based upon similar values===*;
data a;
  input fname $20.;
  var1=soundex(scan(fname,1,' '));
  var2=soundex(scan(fname,-1,' '));
datalines;
john smith
jon smithe
jonn smythe
john paul
;

proc sort data=a;
  by var1 var2;
run;

data b;
  input name $20.;
  var1=soundex(scan(name,1,' '));
  var2=soundex(scan(name,2,' '));
datalines;
John Smith
;

data c;
  merge a b;
  by var1 var2;
run;

proc print;
run;

*===Overwriting a master data set with duplicate transactions===*;
/* Create sample data sets */

data veggies(index=(item));
  input Item $ Inventory ;
datalines;
Corn 12 
Lettuce 6 
Potato 15 
Onion 7 
;


data new_inventory;
  input Item $ Quantity;
datalines;
Lettuce 2
Onion 7
Lettuce 3
;

/* There is no automatic update of like named variables with KEY=.   */
/*                                                                   */
/* To overwrite the values of INVENTORY in the master data set with  */
/* all matches in the look-up data set, use an assignment statement. */ 

data veggies;
  set new_inventory;
  modify veggies key=Item/unique;
  select (_iorc_);                                   
    when (%sysrc(_sok)) do;
      inventory=quantity;
      replace;
      end;
    when (%sysrc(_dsenom)) do;                                          
      _ERROR_=0;
      inventory=.;
      put "Item not in stock --- " Item; 
      end;
    otherwise do;                                          
      put 'Unexpected ERROR: _iorc_= ' _iorc_;  
      stop;                                    
      end; 
  end; 
run;

proc print data=veggies;
run;

*===Using the MODIFY statement to update all observations in a data set===*;
/* Create sample data set */

data sample;
  input x y z;
datalines;
1 2 3
. 22 .
. . .
;

data sample;
  modify sample;
  array num(3) x y z;
  do i=1 to 3;
    if num(i)=. then num(i)=0;
  end;
run;

proc print;
run;

*===Missing values in common variables in a one-to-many merge can overwrite nonmissing values===*;
/*Data set one has missing values for age after the first value for each ID*/
data one;
input id age score;
datalines;
1 11 90
1 . 100
1 . 95
2 9 80
2 . 100
;
data two;
input id name $ age;
datalines;
1 Sarah 8
2 John 10
;
run;

/*A regular merge will result in the missing values be written to the output.*/
data merge1;
merge one two;
by id;
run;

proc print;
run;

/*In this merge, we check for missing values and use the previous age for the ID if the*/
/*age is missing.*/

data merge2 (drop=tempage);
merge one  two;
by id;
retain tempage;
if first.id then tempage = .;
if age = . then age = tempage;
else tempage = age;
run;
proc print;
run;

*===Calculate the percentage that one observation contributes to the total of a BY-group===*;
data sales;                                                      
  input @1 region $char8.  @10 repid 4.  @15 amount 10. ;     
  format amount dollar12.;                                    
  datalines;                                                      
NORTH    1001 1000000                                            
NORTH    1002 1100000                                            
NORTH    1003 1550000                                            
NORTH    1008 1250000                                            
NORTH    1005  900000                                            
SOUTH    1007 2105000                                            
SOUTH    1010  875000                                            
SOUTH    1012 1655000                                            
EAST     1051 2508000                                            
EAST     1055 1805000                                            
;
run;    
 
proc sort data=sales;                                            
  by region;                                                    
run;                                                             

/* Create REGTOT, a data set that contains one observation for each REGION. */ 
/* Create a new variable REGTOTAL, that contains the total AMOUNT for each  */
/* REGION.                                                                  */
                                                                 
proc means data=sales noprint nway;                              
  var amount;                                                   
  by region;                                                    
  output out=regtot(keep=regtotal region) sum=regtotal;         
run;         


/* Create PERCENT1 by merging REGTOT with SALES, based on the value of      */
/* the BY variable REGION.                                                  */

data percent1;                                    
  merge sales regtot;                            
  by region; 
  /* Calculate the percentage each observation contributed 
     to the total for the appropriate region.               */                                                                                
  regpct = (amount / regtotal ) * 100;           
  format regpct 6.2 amount regtotal dollar10.;   
run;                                              
                                                  
proc print data=percent1;                         
  title1 'PERCENT1';                             
run;




/* Method 2 : Related Technique using PROC SQL */                           
                                                                                            
proc sql;                                                       
  create table percent2 as                                     
    select *, sum(amount) as regtotal format=dollar10.,       
          100*(amount/sum(amount)) as regpct format=6.2      
      from sales                                             
        group by region;                                       
quit;


*===Combining observations when variable values do not match exactly===*;
/* Create sample data sets */

data one;
  input time time5.  sample;
  format time datetime13.;
  time=dhms('23nov94'd,0,0,time);
datalines;
09:01   100
10:03   101
10:58   102
11:59   103
13:00   104
14:02   105
16:00   106
;

data two;
  input time time5.  sample;
  format time datetime13.;
  time=dhms('23nov94'd,0,0,time);
datalines;
09:00   200
09:59   201
11:04   202
12:02   203
14:01   204
14:59   205
15:59   206
16:59   207
18:00   208
;

/* Create MATCH1.  Route execution to a group of statements that read an */
/* observation from ONE and then to another group that reads from TWO.   */

data match1 (keep = time1 time2 sample1 sample2);
  link getone;
  link gettwo;
  
  /* Format the datetime variables.  Set to 0 the two variables that will be */
  /* used to indicate that the last observation from data set ONE or TWO has */
  /* been both read and processed.                                           */
  format time1 time2 datetime13.;
  onedone=0;  twodone=0;

  /* Check the value of TEMPT1 against TEMPT2.  If there is less than a 5-   */
  /* minute (300 second) difference between them, assign the values of these */
  /* "temp" variables to the variables that you want to write to the output  */
  /* data set, and then write an observation.  Execute the LINK statements   */
  /* to read a new observation from ONE and from TWO.                        */
  do while (1=1);
    if abs(tempt1-tempt2) < 300 then
    do;
       time1=tempt1;
       time2=tempt2;
       sample1=temps1;
       sample2=temps2;
       output;
       link getone;
       link gettwo;
    end;

    /* If the difference between TEMPT1 and TEMPT2 is five minutes or more, */
    /* test for further conditions.  If the conditions are met, write an    */
    /* observation that contains the actual values from TWO but missing     */
    /* values from ONE.                                                     */
    else if (tempt1 > tempt2 and twodone=0) or onedone then
    do;
      time1=.;
      time2=tempt2;
      sample1=.;
      sample2=temps2;
      output;
      link gettwo;
    end;

    /* If conditions have not been met in the previous IF-THEN or ELSE-IF/THEN */
    /* statements, test for further conditions.  If the conditions are met,    */
    /* write an observation that contains the actual values from ONE but       */
    /* missing values from TWO.                                                */
    else if (tempt1 < tempt2 and onedone=0) or twodone then
    do;
      time1=tempt1;
      time2=.;
      sample1=temps1;
      sample2=.;
      output;
      link getone;
    end;

    /* When you have processed all observations from both ONE and TWO, */
    /* stop the DATA step.                                             */
    if onedone and twodone then stop;

  /* end the DO WHILE loop */
  end;      
  return;

  /* If there are more observations in ONE, read another observation.    */
  /* If the last observation has already been read, set ONEDONE to 1 to  */
  /* indicate that the last observation was both read and processed, and */
  /* then prevent the SET statement from executing and attempting to     */
  /* read past the end of data set ONE.                                  */
  getone: 
  if last1 then 
  do;
    onedone=1;
    return;
  end;
  
  set one (rename=(time=tempt1 sample=temps1)) end=last1;
  return;

  /* If there are more observations in TWO, read another observation.    */
  /* If the last observation has already been read, set TWODONE to 1 to  */
  /* indicate that the last observation was both read and processed, and */
  /* then prevent the SET statement from executing and attempting to     */
  /* read past the end of data TWO.                                      */
  gettwo: 
  if last2 then 
  do;
    twodone=1;
    return;
  end;

  set two (rename=(time=tempt2 sample=temps2)) end=last2;
  return;

run;


proc print data=match1;
  title 'MATCH1';
run;


/***********************************************************************/
/* Example 2: Related Technique                                        */
/*                                                                     */
/* The following PROC SQL step uses considerably less code to produce  */
/* the same output as the DATA step, although the rows and columns are */
/* in a different order in the resulting data set.                     */
/***********************************************************************/

data one;
  input time time5.  sample;
  format time datetime13.;
  time=dhms('23nov94'd,0,0,time);
datalines;
09:01   100
10:03   101
10:58   102
11:59   103
13:00   104
14:02   105
16:00   106
;

data two;
  input time time5.  sample;
  format time datetime13.;
  time=dhms('23nov94'd,0,0,time);
datalines;
09:00   200
09:59   201
11:04   202
12:02   203
14:01   204
14:59   205
15:59   206
16:59   207
18:00   208
;

proc sql;
  create table match2 as
    select *
      from one(rename=(time=time1 sample=sample1)) full join
           two(rename=(time=time2 sample=sample2))
              on abs(time1-time2)<=5*60;
quit;

proc print data=match2;
   title 'MATCH2';
run;

