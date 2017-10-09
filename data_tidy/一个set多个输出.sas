* Sample SAS Program  "multidat.sas" ;


/* Reading SAS data set and creating         */
/* multiple SAS data sets in one data step.  */


libname sas2 'U:\';
options ls=80;

/* creating multiple datasets in one data step */

data perform(keep=ptotal pflight pscience pairtran)
     facil  (keep=ftotal fflight fscience fairtran);
   set sas2.nasa;
run;

proc print data=perform;
   title 'NASA Expenditures: Performance';
run;

proc print data=facil;
   title 'NASA Expenditures: Facilities';
run;
