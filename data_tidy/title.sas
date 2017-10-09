* Sample SAS Program   "titles.sas" ;

/*  ENHANCING OUTPUT WITH THE PROC STEP:    */
/*  TITLES, FOOTNOTES, LABELS, AND FORMATS  */
/* Adding a TITLE to output  */
/* Adding multiple TITLEs   */
/* Removing TITLEs  */
/* Adding FOOTNOTEs */
/* Using the LABEL Statement with PROC PRINT */
/* Using the FORMAT Statement with PROC PRINT */


  
              /* GLOBAL STATEMENTS */
  libname sas3 'U:\';
  options ls=75 nodate pagesize=30;


            /* ADDING A TITLE TO YOUR OUTPUT */
proc print data=sas3.tourrev2;
  title 'Total Tours Booked';
run;


          /* ADDING MULTIPLE TITLES */
          /* (See note 1 below.)    */
proc print data=temp;
  title 'Total Tours Booked';
  title2 '1996';
  title4 'By Vendor';
run;


          /* REMOVING TITLES */
proc print data=sas3.tourrev2;
   title2;
   title4;
run;


        /* ADDING FOOTNOTES AND TITLES */
proc print data=sas3.tourrev2;
  where vendor = 'World';
  title 'Total Bookings';
  footnote '1996';
  footnote2 'World Vendor';
run;


       /* REMOVING TITLES AND FOOTNOTES */
proc print data=sas3.tourrev2;
  title;
  footnote;
  footnote2;
run;


       /* USING THE LABEL STATEMENT  */
       /* WITH PROC PRINT            */
       /* (See notes 2 and 3 below.) */
proc sort data=sas3.sales out=sorted;
  by region;
run;
proc print data=sorted label;
  label region='Sales Region'
        product='Product'
        saletype='Sales Type'
        totsales='Total Sales';
  var region product saletype totsales;
run;


         /* USING THE FORMAT STATEMENT */
         /* WITH PROC PRINT            */

proc print data=sas3.sales(drop=citysize);
  format pop COMMA8.;
run;


         /* USING PROC FORMAT TO */
         /* RE-ASSIGN MISSING VALUES FOR PRINTING */
proc format;
   value xtot .='Pending';
run;
proc print data=sas3.sales (obs=25);
  format totsales xtot10.;
        /* note the 10 in the format "xtot10." above */
        /* otherwise SAS will use 8 bytes for totsales */
  var region product saletype totsales;
run;


/*------------------------------------------------*/
/* NOTES:                                         */
/* 1. SAS will accept up to 10 titles and 10      */
/*      footnotes.                                */
/* 2. The Label statement will remain in effect   */
/*      for the duration of the Proc Step only.   */
/* 3. Other SAS Procedures do not require the     */
/*      "label" option in the Proc Statement.     */
/*------------------------------------------------*/
