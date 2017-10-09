* Sample SAS Program   "selecvar.sas"   ;


/* Reading SAS data set and creating new SAS data 
 sets that contain selected variables */


libname sas2 'U:\';
options ls=80;


/* using the KEEP data set option */

data perform;
   set sas2.nasa (keep=year ptotal pflight pscience pairtran);
run;
proc print data=perform;
   title 'NASA Performance-Related Expenditures';
run;


/* using the DROP data set option */

data perform2;
   set sas2.nasa (drop=total ftotal fflight fscience fairtran);
run;
proc print data=perform2;
   title 'NASA Performance-Related Expenditures';
run;
