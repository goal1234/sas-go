* Sample SAS Program   "arith_fc.sas" ;


/* Reading a SAS data set and creating new data sets   */
/* using arithmetic operators and SAS functions.        */


libname sas2 'U:\';
options ls=80;

/* Using arithmetic operators */

data newtour;
   set sas2.tours;
   totcost=aircost+landcost;
   peakair=(aircost*1.10)+8;
   nitecost=landcost/nights;
run;

proc print data=newtour;
   var country nights aircost landcost totcost peakair nitecost;
   title 'New Variables Containing Calculated Values';
run;


/* Using SAS Functions */

data moretour;
   set sas2.tours;
   roundair=round(aircost,50);
   totcostr=round(aircost+landcost,100);
   sumcost=sum(aircost,landcost);
   roundsum=round(sum(aircost,landcost),100);
run;

proc print data=moretour;
   var country aircost landcost roundair totcostr sumcost roundsum;
   title 'Rounding and Summing Values';
run;
