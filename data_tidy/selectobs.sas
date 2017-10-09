* Sample SAS Program  "selecobs.sas" ;


/* Reading a SAS data set */
/* Creating SAS data sets that contain selected observations */


libname sas2  'U:\';
options ls=80;


/* To check the contents of the SAS Data Set "sas2.nasa": */

proc contents data=sas2.nasa;
run;

/* Read a SAS Data Set and create an extract beginning with observation #12 */

data nasa2;
  set sas2.nasa (firstobs=12);
run;

proc print data=nasa2;
run;

/* To select the first 10 observations: */

data nasa2;
  set sas2.nasa (obs=10);
run;

proc print data=nasa2;
run;

/* To select observations 11-21: */

data nasa2;
  set sas2.nasa (firstobs=11 obs=21);
run;

proc print data=nasa2;
run;
