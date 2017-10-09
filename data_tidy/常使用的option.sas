* Sample SAS Program  "options.sas" ;


/* CHANGING SYSTEM OPTIONS TO ENHANCE YOUR OUTPUT   */
/* (See note 1 below.)      */

/* Checking your System Defaults   */
/* Altering PAGESIZE  */
/* CENTERing output */
/* NUMBERing Pages  */
/* Printing DATE and time values */
/* Customizing output of MISSING values */
/* Using multiple options */


         /* CHECKING YOUR SYSTEM DEFAULTS */
         /* (See note 2 below.)           */
proc options;
run;

        /* SAMPLE OUTPUT USING OPTION DEFAULTS */
libname sas3 'U:\';
proc print data=sas3.sales;
run;

        /* ALTERING LINE SIZE */
options ls=80;
proc print data=sas3.sales;
run;

          /* ALTERING PAGE SIZE */
options pagesize=30;
proc print data=sas3.sales;
run;

          /* CENTERING OUTPUT   */
          /* (Default is "center") */
options nocenter;
* options center; /* TO RETURN TO DEFAULT */
proc print data=sas3.sales;
  var region product saletype quantity;
run;

          /* NUMBERING PAGES */
          /* (Default is to number)  */
options nonumber;
* options number; /* TO RETURN TO DEFAULT*/
proc print data=sas3.sales;
  var region product saletype quantity;
run;

          /* PRINTING DATE AND TIME VALUES  */
          /* (Default is to print date and time) */
options nodate;
proc print data=sas3.sales;
  var region product saletype quantity;
run;

          /* CUSTOMIZING OUTPUT OF MISSING VALUES */
options missing ='M';
* options missing ='.';/* TO RETURN TO DEFAULT */
proc print data=sas3.sales;
  var region product saletype quantity;
run;

          /* USING MULTIPLE OPTIONS */
options ls=80 ps=29 center nonumber nodate;
proc print data=sas3.sales;
run;


/*------------------------------------------------*/
/* NOTES:                                         */
/* 1. When a global option is set, it remains in  */
/*    effect for the duration of the interactive  */
/*    session (or batch job), or until it is      */
/*    re-set.                                     */
/* 2. With SAS for Windows95, options may also be */
/*    checked by selecting "options" under the    */
/*    "Globals" menu.                             */
/*------------------------------------------------*/

