* Sample SAS Program   "if_outpu.sas" ;

/* Deleting observation based on a condition. */
/* Using the implicit action of  subsetting IF. */
/* Comparing the DELETE and Subsetting IF Statement. */
/* Writing observations to Multiple SAS Data Sets 
   using OUTPUT statement.   */
/* Combining Assignment and OUTPUT Statements. */
/* Assigning observations to more than one Data Set. */

   

libname sas2 'U:\';
options ls=80;


/* DELETE observations based on a condition */

data remove;
   set sas2.arts;
   if landcost=. then delete;
run;

proc print data=remove;
   title 'Deleting Observations That Lack a Land Cost';
run;


/*  Using the implicit action of a subsetting IF */
/*  Create a Data set that contains ONLY those records 
    that have nights=6 */
 
data subset6;
   set sas2.arts;
   if nights=6;
run;

proc print data=subset6;
   title 'Producing a Subset with the Subsetting IF Statement';
run;



/* Comparing the DELETE and Subsetting IF Statements */
/* first attempt */

data lowmed;
   set sas2.arts;
   if upcase(budget)='HIGH' then delete;
run;

proc print data=lowmed;
   title 'Deleting High-Priced Tours';
run;


/* Comparing the DELETE and Subsetting IF Statements */
/* a safer method */

data lowmed2;
   set sas2.arts;
   if upcase(budget)='MEDIUM' or upcase(budget)='LOW';
run;

proc print data=lowmed2;
   title 'Using Subsetting IF for an Exact Selection';
run;


/* Writing observations to Multiple SAS Data Sets */
/* Using the OUTPUT Statement */

data ltour othrtour;
   set sas2.arts;
   if guide='Lucas' then output ltour;
   else output othrtour;  /* If you omit this ELSE statement
                          data set othrtour will have 0 obs */
run;

proc print data=ltour;
   title "Data Set with Guide='Lucas'";
run;

proc print data=othrtour;
   title "Data Set with Other Guides";
run;


/* Combining Assignment and OUTPUT Statements  */

data lday2 othrday2;
   set sas2.arts;
   days=nights+1;  /* correct location */
   if guide='Lucas' then output lday2;
   else output othrday2;
*  days=nights+1;  /* If you put this statement here after 
                      all the OUTPUT statements instead of 
                    above then the variable "days" in the data 
 		     sets will only have MISSING values (.) */
run;

proc print data=lday2;
   title "Number of Days in Lucas's Tours";
run;

proc print data=othrday2;
   title "Number of Days in Other Guides' Tours";
run;


/* Assigning observations to more than one data set */


data ltour othrtour weektour daytour;
   set sas2.arts;
   if guide='Lucas' then output ltour;
   else output othrtour;
   if nights>=6 then output weektour;
   else output daytour;
run;

proc print data=ltour;
   title "Lucas's Tours";
run;

proc print data=othrtour;
   title "Other Guides' Tours";
run;

proc print data=weektour;
   title 'Tours Lasting a Week or More';
run;

proc print data=daytour;
   title 'Tours Lasting Less Than a Week';
run;
