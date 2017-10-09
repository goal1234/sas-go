* Sample SAS Program   "dupl_obs.sas" ;


/* Removing the DUPLICATE observations from 
   SAS data set with PROC SORT  */


libname sas2 'U:\';
options ls=80;

/* Program to create a SAS Dataset from the dataset "dupobs.dat" */

data dupobs;
   infile 'U:\dupobs.dat';
   input country $ 1-11 tourtype $ 13-24 nights
         landcost vendor $;
run;

proc print data=dupobs;
   title 'Data Set DUPOBS';
run;

/* Removing the duplicate observations from SAS 
  dataset dupobs with PROC SORT */

proc sort data=dupobs out=sas2.nodupobs  noduplicates;
   by country;
run;

proc print data=sas2.nodupobs;
   title 'Removing a Duplicate Observation with PROC SORT';
run;
