* Sample SAS Program  "output.sas" ;

/* CREATING NEW DATA SETS WITH THE OUTPUT
   FROM A SAS PROCEDURE.    */
/* Using PROC MEANS to output a data set
   with no var statement    */
/* Using PROC MEANS to output a data set
   using a CLASS statement  */
/* Using PROC MEANS to output a data set
   using the SORT statement 
   and BY statement         */
/* Using PROC SUMMARY to output a data set
   with VARiable statement  */



              /* GLOBAL STATEMENTS */
libname sas3 'U:\';
options ls=75;

           /* USING PROC MEANS TO OUTPUT A DATA
            SET: NO VAR STATEMENT. THIS OUTPUT 
             FILE CONTAINS ALL VARIABLES WITH
             THEIR SUM AS THE ONLY OBSERVATION */
proc means data=sas3.sales  noprint ;
output out=sumobs0 sum= ;
run;
proc print data=sumobs0;
title 'sumobs0';
run;
proc contents data=sumobs0;
title ;
run;

         /* USING PROC MEANS TO OUTPUT A DATA  */
          /* SET; USING THE CLASS STATEMENT   */
proc means data=sas3.sales noprint;
 var amount totsales ;
  class region;
  output out=sumobs1 sum=s_amount s_totsal ;
run;
proc print data=sumobs1;
title 'sumobs1';
run;
proc contents data=sumobs1;
title;
run;


/* USING PROC MEANS TO OUTPUT A SAS   */
/* DATA SET: USING THE SORT STATEMENT */
/* AND THE BY STATEMENT               */

proc sort data=sas3.sales;
  by region;
run;
proc means data=sas3.sales noprint;
 var amount totsales ;
  by region;
  output out=sumobs2 sum=s_amount s_totsal ;
run;
proc print data=sumobs2;
title 'sumobs2';
run;
proc contents data=sumobs2;
title;
run;



/* USING PROC SUMMARY TO OUTPUT A    */
/* DATA SET: USING THE VAR STATEMENT */

proc sort data=sas3.sales;
 by region;
run;

proc summary data=sas3.sales ;
 var amount totsales;
  by region;
  output out=sumobs4 sum=m_amount m_totsal;
run;
proc print data=sumobs4;
title 'sumobs4';
run;
proc contents data=sumobs4;
title;
run;
