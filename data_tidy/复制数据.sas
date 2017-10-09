/* CISER COMPUTING CONSULTING */
/* SAMPLE SAS PROGRAM "CAT_MERG.SAS" */

/* PROGRAM TO COPY CATALOGS AND TO MERGE TWO CATALOGS */ 
/* FOR MORE DETAILS SEE "SAS/AF Software, Usage and Reference,
     Version 6, First Edition, Chapter 10 */


libname ssd 'U:\proj\';  /* CONTAINS FORMATS catalog */
libname ssd1 'U:\proj_one\';  /* CONTAINS ANOTHER FORMATS catalog */
libname ssd2 'U:\';  /* COPY AND MERGE FORMATS catalogs here */


           /* TO COPY FORMATS CATALOG FROM subfolder .\proj\ TO 
                the main folder */
proc copy in=ssd out=ssd2 memtype=(catalog);
          select formats;
run;

          /* MERGE FORMATS CATALOG IN subfolder ./proj_one WITH 
              FORMATS IN THE MAIN FOLDER; MERGED CATALOG SAVED IN 
                  THE MAIN FOLDER "U:\Users\pc17\" */
proc build catalog=ssd2.formats batch ;
 merge catalog=ssd1.formats   ; 
*  merge catalog=ssd1.formats  replace ; /* TO REPLACE LIKE-
      NAMED ENTRIES IN MERGED CATALOG WITH THE ENTRIES FROM
  THE CATALOG SPECIFIED IN THE MERGE STATEMENT, subfolder ./proj_one */
run;

