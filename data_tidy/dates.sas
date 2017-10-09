* Sample SAS Program   "dates.sas" ;

/* Program to create a data set that includes dates */
/* Using a FORMAT Statement in PROC Step */
/* Using a FORMAT Statement in the DATA Step */
/* Changing formats temporarily for Printing */
/* Sorting Dates */
/* Creating new DATE variables */
/* Using DATES as constants  */
/* Using SAS Date Functions  */
/* Calculating a duration in days */
/* Calculating a duration in years */


libname sas2 'U:\';
options ls=80;  


/* Program to create "sas2.dates" */

data sas2.dates;
   input country $ 1-11 @13 depart date7. nights;
   cards;
Japan       13may89  8
Greece      17oct89 12
New Zealand 03feb90 16
Brazil      28feb90  8
Venezuela   10nov89  9
Italy       25apr89  8
USSR        03jun89 14
Switzerland 14jan90  9
Australia   24oct89 12
Ireland     27may89  7
;
run;

proc print data=sas2.dates;
   title 'Departure Dates with SAS Date Values';
run;



/* Using a FORMAT Statement in the Proc Step */

proc print data=sas2.dates;
   title 'Departure Dates in Calendar Form';
   format depart mmddyy8.;
run;

/* Using a FORMAT Statement in the Data Step */

data tourdate;
   set sas2.dates;
   format depart date7.;
run;

proc contents data=tourdate;
title;
run;


/* Changing Formats Temporarily */

proc print data=tourdate;
   title 'Report with Departure Date Spelled Out';
   format depart worddate18.;
run;


/* Sorting Dates */

proc sort data=tourdate out=sortdate;
   by depart;
run;

proc print data=sortdate;
   var depart country nights;
   title 'Departure Dates Listed in Chronological Order';
run;


/* Creating new date variables */

data home;
   set tourdate;
   return=depart+nights;
   format return date7.;
run;

proc print data=home;
   title 'Dates of Departure and Return';
run;


/* Using dates as constants */

data corrdate;
   set tourdate;
   if country='Switzerland' then depart='21jan90'd;
run;

proc print data=corrdate;
   title 'Corrected Value for Switzerland';
run;


/* Using SAS Date Functions */

data pay;
   set tourdate;
   duedate=depart-30;
   if weekday(duedate)=1 then duedate=duedate-1;
   format duedate weekdate29.;
run;

proc print data=pay;
   var country duedate;
   title 'Date and Day of Week Payment Is Due';
run;


   /* Calculating a duration in days */

data temp;
   start='08feb82'd;
   rightnow=today();
   age=rightnow-start;
   format start rightnow date7.;
run;

proc print data=temp;
   title 'Age of Tradewinds Travel';
run;

   /* Calculating a duration in years */

data temp2;
   start='08feb82'd;
   rightnow=today();
   agedays=rightnow-start;
   ageyrs=agedays/365.25;
   format ageyrs 4.1 start rightnow date7.;
run;

proc print data=temp2;
   title 'Age in Years of Tradewinds Travel';
run;
