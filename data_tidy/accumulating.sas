* Sample SAS Program   "totaldat.sas" ;
 
/* Accumulating a total for an entire data set */
/* Selecting the last obs of the accumulating 
   variable to get a total */
/* Accumulating a total for each BY Group  */
/* Selecting the last obs of the accumulating 
   variable for a BY Group to get totals for each group */



libname sas2 'U:\';
options ls=80;

/* Accumulating a total for an entire data set */

data total;
   set sas2.tourrev;
   totbook+bookings;
run;   /* SAS creates a variable "totbook" in dataset TOURREV.
        This variable contains the sum of observations in var
        "bookings". For e.g. 2nd obs in "totbook" is the sum  
        of 1st and 2nd obs in "bookings", 3rd obs in "totbook"  
        is the sum of 1st, 2nd and 3rd obs in "bookings".  */ 


/* Selecting the last obs in "totbook" only to get a total */

data total2(keep=totbook);
   set sas2.tourrev end=lastobs;
   totbook+bookings;
   if lastobs;  /* Keep a record only if lastobs is not 0 and "." */

run;      /* In statement "set sas2.tourrev end=lastobs" SAS
         creates a variable "lastobs" whose value is 1 when the
         data set is processing the last obs and it is 0 
         otherswise. Note: SAS does not add the END=VAR to the 
         data set being created. */

proc print data=total2;
   title 'Last Observation Shows Total Tours Booked';
run;


/* Accumulating a total for each BY group */
       /* First we have to sort the data in groups */

proc sort data=sas2.tourrev out=sorttour;
   by vendor;
run;

data totalby;
   set sorttour;
   by vendor;
   if first.vendor then vendorbk=0;
   vendorbk+bookings;
run;  /* Variable "vendorbk" accumulates the totals for the obs
       in variable "bookings". When the Data step processes the
      first obs in a group the value of "vendorbk" is initially 
      set to 0 and then the statement "vendorbk+bookings" puts 
      the value of first obs in that group in "vendorbk". */


proc print data=totalby;
   title 'Setting the Sum Variable to 0 for BY Groups';
run;


/*  Selecting the last observation for a BY Group to
    get totals by BY group */

proc sort data=sas2.tourrev out=sorttour;
   by vendor;
run;

data totalby(drop=country landcost bookings);
   set sorttour;
   by vendor;
   if first.vendor then vendorbk=0;
   vendorbk+bookings;
   if last.vendor;     /* Keep a record if it is the last
                       observation in a group */
run;

proc print data=totalby;
   title 'Last Observation in BY Group Contains Group Total';
run;


/* Writing totals and detail records */
/* Using a DO GROUP */

proc sort data=sas2.tourrev out=sorttour;
   by vendor;
run;

data details(drop=grpbook grpmoney)
     vendgrps(keep=vendor grpbook grpmoney);
   set sorttour;
   by vendor;
   money=landcost*bookings;
   output details;
   if first.vendor then
      do;
         grpbook=0;
         grpmoney=0;
      end;
   grpbook+bookings;
   grpmoney+money;
   if last.vendor then output vendgrps;
run;

proc print data=details;
   title 'Detail Records: Dollars Spent on Individual Tours';
run;

proc print data=vendgrps;
   title 'Group Totals: Dollars Spent and Bookings by Vendor';
run;
