* Sample SAS Program  "if_then.sas" ;

/* Using IF/THEN/ELSE Statements */
/* Using Comparison Operators  */
/* Writing mutually exclusive conditions */
/* Using the Logical Operators "AND" and "OR" */
/* Using Numeric comparisons  */
/* Dealing with MIXED case character values */



libname sas2 'U:\';
options ls=80;

/* Using the IF/THEN Statement */

data revise;
   set sas2.arttour;
   if city='Rome' then landcost=landcost+30;
   if events>nights then calendar='Check schedule';
   if guide='Lucas' and nights>7 then guide='Torres';
run;

proc print data=revise;
   var city nights landcost events guide calendar;
   title 'Examples of IF-THEN Statements';
run;

/* Using IF/THEN/ELSE */

data revise2;
   set sas2.arttour;
   if city='Rome' then landcost=landcost+30;
   if events>nights then calendar='Check schedule';
   else calendar='No problems';
   if guide='Lucas' and nights>7 then guide='Torres';
run;

proc print data=revise2;
   var city nights landcost events guide calendar;
   title 'Alternative Value Assigned by ELSE';
run;


/* Writing mutually exclusing conditions */

data prices;
   set sas2.arttour;
   if landcost>=1500 then price='High  ';
   else if landcost>=700 then price='Medium';
   else price='Low';
run;

proc print data=prices;
   var city landcost price;
   title 'Mutually Exclusive Values';
run;


/* Using comparison operators */

data changes;
   set sas2.arttour;
   if nights>=6 then stay='Week+';
   else stay='days';
   if landcost ne . then remarks='OK  ';
   else remarks='Redo';
   if landcost lt 600 then budget='Low   ';
   else budget='Medium';
   if events/nights>2 then pace='Too fast';
   else pace='OK';
run;

proc print data=changes;
   var city nights landcost events stay remarks budget pace;
   title 'Using Various Conditions';
run;


/* Using the logical operator "AND" to use more than one
   comparison in a condition */

data showand;
   set sas2.arttour;
   if city='Paris' and guide='Lucas' then remarks='Bilingual';
   if 1000<=landcost<=1500 then price='1000-1500';
run;

proc print data=showand;
   var city landcost guide remarks price;
   title 'Making Multiple Comparisons with AND';
run;


/* Using the logical operator "OR" to use more than one
   comparison in a condition */


data showor;
   set sas2.arttour;
   if landcost gt 1500 or landcost/nights gt 200 then level='Deluxe';
run;

proc print data=showor;
   var city landcost nights level;
   title 'Making Multiple Comparisons with OR';
run;

/* Choosing between "AND" and "OR" */

data test;
   set sas2.arttour;
   if guide ne backup or guide ne ' ' then use_or='OK';
   else use_or='No';
   if guide ne backup and guide ne ' ' then use_and='OK';
   else use_and='No';
run;

proc print data=test;
   var city guide backup use_or use_and;
   title 'Negative Operators with OR';
run;


/* Using both "AND" and "OR" in the same condition */

data combine;
   set sas2.arttour;
   if (city='Paris' or city='Rome') and (guide='Lucas' or
      guide="D'Amico") then topic='Art history';
run;

proc print data=combine;
   var city guide topic;
   title 'Grouping Comparisons with Parentheses';
run;


/* Using NUMERIC comparisons */

data morecomp;
   set sas2.arttour;
   if landcost then remarks='Ready to budget'; 
   else remarks='Need land cost';

/* ABOVE STATEMENT COULD ALSO BE WRITTEN AS: 
   if landcost ne . and landcost ne 0 then remarks='Ready to budget' ; 
   else remarks='Need land cost';
 */

   if nights=6 or nights=8 then stay='Medium';
   else stay='Short';
run;

proc print data=morecomp;
   var city nights landcost remarks stay;
   title 'More About Numeric Comparisons';
run;


/* Dealing with MIXED case CHARACTER values */

data newguide;
   set sas2.arttour;
   if upcase(city)='MADRID' then guide='Duncan';
run;

proc print data=newguide;
   var city guide;
   title 'Using the UPCASE Function to Make a Comparison';
run;
