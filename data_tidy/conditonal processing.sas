DATA test;                                   
x=1;
*setting COND to 4 via SYSCC automatic macro variable;                        

IF x=1 THEN CALL SYMPUT('SYSCC','4');        
run;
*display value of automatic macro variable;                                   
%PUT &SYSCC;                                 

DATA test2;                                  
y=1;                                         
RUN; 
*display value of automatic macro variable SYSCC to;
*see if it has changed even after a successful Data step;
                                 
%PUT &SYSCC;   

*Using the ABORT RETURN Statement;
//STEP1  EXEC yourSASproc
//SYSIN DD *
 DATA _NULL_;
   ABORT RETURN 1111;
 RUN;
//STEP2 IF (RC = 1111) THEN
//TRUE  EXEC yourSASproc
//SYSIN DD *
 DATA _NULL_;
   PUT 'TRUE';
 RUN;
//      ELSE
//FALSE EXEC yourSASproc
//SYSIN DD *
 DATA _NULL_;
   PUT 'FALSE';
 RUN;
//ENDTEST ENDIF;

*===How to stop a program from executing without ending the SAS? session===*;
 /** sets a macro variable called error to a value of 0 **/
   %let error=0;
    
    /** macro runjobs defines all the DATA steps that need to be run **/
    %macro runjobs ;
      data a; 
       x=7; 
       /** CALL SYMPUT is used to change the macro variable error to 1 based on a condition **/
       if x=7 then call symput('error',1);
      run;
      /** %IF is used to see if the macro variable error is set to 1 and if so leave the macro **/
      %if &error ne 0 %then %goto finish;
      data b;
       x=8;  
       if x=7 then call symput('error',1);
      run;                                                                                                 
      %finish:
   %mend runjobs ;  
   %runjobs 

    proc print data=a; 
    run;   
    /** Just to show that data set b does not exist **/
    proc print data=b; 
    run;

  
  /** Starting in SAS 9.0, %RETURN can be used instead of %GOTO **/
 
   %let error=0; 
   %macro runjobs ; 
      data a; 
       x=7; 
       if x=7 then call symput('error',1); 
      run;  
      %if &error ne 0 %then %return;  
      data b;  
       x=8;   
       if x=7 then call symput('error',1);  
      run; 
    %mend runjobs ; 
    %runjobs 
 
    proc print data=a; 
    run;   
    /** Just to show that data set b does not exist **/
    proc print data=b;  
    run; 


	*===All expressions are evaluated in compound expressions===*;
	/* create test data */

data test;
  infile datalines truncover;
  input ID :$3. chgdate ??mmddyy10.;
  format chgdate date9.;
datalines;
aaa .
bbb 1/1/2009
ccc 1/1/2008
ddd 1/1/2007
eee 1/1/2006
fff .
ggg 9/1/2009
hhh 8/1/2009
iii 7/1/2009
jjj 6/1/2009
kkk 5/1/2009
mmm .
nnn 4/1/2009
ppp 3/1/2009
qqq 2/1/2009
;

/* generates warning message */
%let dt = '02Oct2009'd;
data result1 ;
  set test;
IF not (CHGDATE = .  OR  &dt - CHGDATE > 370) THEN                 
  output;   
run; 

/* does not generate warning message */
data result2 ;
  set test;
if chgdate ne .;
IF not( &dt - CHGDATE > 370) THEN                 
  output;   
run;


*=== Understanding automatically retained variables when performing a merge: results of doing a merge and conditional processing in the same DATA step===*;
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


*/

/*
Try it all in one step. Here, the value of variable C is
changed in the second observation from 100 to 50. Then, because
you are using BY-group processing in the merge, the
value is retained for the remainder of the BY-group. Note that 
four observations have a value of 50 for C in this example. */

data match3 ;
   merge one two;
   by a;
   if b = 20 then c = 50;
run;

/* RESULTS *

  Obs     a     b     c

   1     10    10    100
   2     10    20     50
   3     10    30     50
   4     10    40     50
   5     10    50     50
*/


*===Take caution when assigning hexadecimal values to macro variables===*;
data _null_;
     var='00093230'x;
     call symput('macvar',var);
   run;

   data _null_;
     newvar="&macvar";
     put newvar= $hex8.;
   run;

   data _null_;
     var='00093230'x;
     call symput('macvar',put(var,$hex8.));
   run;

   data _null_;
     newvar="&macvar"x;
     put newvar= $hex8.;
   run;

*===When do I use a WHERE statement instead of an IF statement to subset a data set?==*;
data exam;
   input name $ class $ score ;
   cards;
 Tim math 9
 Tim history 8
 Tim science 7
 Sally math 10
 Sally science 7
 Sally history 10
 John math 8
 John history 8
 John science 9
 ;
 run;

data student1;
    set exam;

    * Can use WHERE condition because NAME variable is a data set variable;
    * WHERE condition requires all data set variables;
    where name = 'Tim' or name = 'Sally';

    * Create CLASSNUM variable;
    if class = 'math' then classnum = 1;
    else if class = 'science' then classnum = 2;
    else if class = 'history' then classnum = 3;

    * Use IF condition because CLASSNUM variable was created within the DATA step;
    if classnum = 2;
  run;

  proc print data = student1;
  run;

  proc sort data = exam out=student2;
    by name;
   run;

   data student2;
     set student2;
     by name;

     * Use IF condition because NAME is the BY variable;
     if first.name;

   run;

   proc print data = student2;
   run;
*==Table lookup using MERGE with data modification==*;

   /*  Create starting data */

data On_hand Inventory;
  input part qty;
datalines;
111     10
222     12
333     15
444      7
555     22
;

/* Create updating data set */

data Sales;
  input part sold;
datalines;
333      4
555      3
;

data on_hand;
  merge on_hand(in=in1) sales(in=in2);
  by part;
  if in1 and in2 then qty=qty-sold;
  drop sold;
run;

proc print;
run;

*===KINDEX function incorrectly returns a 1 when second argument is null===*;
 data _null_;                                    
     value='abcd';                                 
     wrongvalue=index(value,trimn(" "));           
     put wrongvalue=;                              
   run;                                            
                                                   
   %let val=%str(xyz);                             
   %put wrongresult=%sysfunc(kindex(&val,%str()));





