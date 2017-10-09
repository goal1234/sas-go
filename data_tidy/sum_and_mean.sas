* Sample SAS Program   "comprocs.sas" ;

/* COMPARING PROC MEANS WITH PROC SUMMARY  */
/* (See Notes below.)         */

        
             /* GLOBAL STATEMENTS */
  libname sas3 'U:\';
  options ls=75;
  title;

            /* PROC MEANS   */
            /* NO VARIABLES SELECTED */
proc means data=sas3.sales;
   title 'Output of Proc Means';
   title2 'No Variables Selected';
run;

           /* PROC SUMMARY */
           /* NO VARIABLES SELECTED */
proc summary data=sas3.sales print;
   title 'Output of Proc Summary';
   title2 'No Variables Selected';
run;

          /* PROC MEANS */
          /* SELECTED VARIABLES */
proc means data=sas3.sales;
  var pop quantity amount totsales;
   title 'Output of Proc Means';
   title2 'Selected Variables';
run;

         /* PROC SUMMARY */
         /* SELECTED VARIABLES */
proc summary data=sas3.sales print;
   var pop quantity amount totsales;
   title 'Output of Proc Summary';
   title2 'Selected Variables';
  run;


/*----------------------------------------------*/
/*NOTES:                                        */
/* Proc Means and Proc Summary are very         */
/* similar.  The primary differences are:       */
/*  1) Proc Summary does not automatically      */
/*      produce printed output, but Proc        */
/*      Means does.                             */
/*  2) Proc Summary requires a "print" option   */
/*      in the Proc Statement in order to       */
/*      produce printed output.                 */
/*  3) Proc Summary will produce only a total   */
/*      number of observations if no Var        */
/*      Statement is used.  Proc Means will   */
/*      produce a list of basic summary         */
/*      statistics.                             */
/*  4) If a Var statement is used to select     */
/*     variables Proc Means and Proc Summary    */
/*     are identical.                           */
/*  5) Both can be used to output datasets.     */
/*----------------------------------------------*/
