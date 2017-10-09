* Sample SAS Program  "matmerg.sas" ;

/* TO MATCH-MERGE DATA SETS        */
/* USE "In" OPTION WITH AN "If" STATEMENT 
  TO SELECT OBSERVATIONS IN THE MERGED DATA SET 
   CORRESPONDING TO ONE OF THE DATA SETS */

                /* GLOBAL STATEMENTS */
options ls=75 pagesize=30 nodate nonumber;


              /* PROGRAM TO CREATE DATA 
                SETS FOR THIS EXAMPLE */
data dat1;
  input name $ age sex $;
cards;
  Tina 46 F
  Rudy 40 M
  Cara 47 F
  Justin  48 M
  Phil  48 M
  Ed    49 M
  ;
run;

data dat2;
  input name $ occup;
cards;
  Tina 603
  Rudy 406
  Cara 296
  Justin  273
  Phil  279
  ;
run;


           /* MATCH-MERGING DATA SETS */
           /* USING PROC SORT AND A   */
           /* "BY" VARIABLE           */
     
proc sort data=dat1;
  by name;
run;
proc sort data=dat2;
  by name;
run;
data new;
  merge dat1 dat2;
  by name;
run;
proc print data=new;
run;


          /* TO KEEP ONLY THOSE OBSERVATIONS IN THE MERGED DATA SET "NEW2"
		     FOR WHICH THERE IS AN ENTRY IN THE DATA SET "DAT2" */
data new2;
  merge dat1 dat2(in=NEWVAR); /* Note: "NEWVAR" should not exist in either of the input 
                                         data sets "dat1" and "dat2" */
  by name;
  if NEWVAR ;
run;
proc print data=new2;
run;

/*-----------------------------------*/
/* Notes:                            */
/* 1. There are a number of ways     */
/*    to join data sets, including   */
/*    concatenation, interleaving,   */
/*    one-to-one merging, as well as */
/*    the match-merging discussed    */
/*    above.                         */
/*    To get more information on     */
/*    each refer to SAS Language and */
/*    Procedures, Usage, Version 6   */
/*-----------------------------------*/
