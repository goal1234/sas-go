* Sample SAS Program  "do_array.sas" ;

/* Using DO group in IF/THEN Statement.    */
/* Using ARRAYS and iterative DO loops to perform 
  the same action for a series of variables.  */


libname sas2 'U:\';
options ls=80;

/* Using a DO Group as an efficient method of performing
more than one action in a single IF/THEN Statement */

data fixit2;
   set sas2.arts3;
   if city='Madrid' then
      do;
         museum=3;
         other=2;
      end;
   else if city='Amsterdam' then
      do;
         guide='Vandever';
         yrs_exp=4;
      end;
run;

proc print data=fixit2;
   title 'Using DO Groups';
run;


/* Performing the Same Action for a Series of Variables.
   Using ARRAYS and iterative DO Loops. */

data changes;
   set sas2.arts3;
   array chglist{3} museum gallery other;
   do count=1 to 3;
      if chglist{count}=. then chglist{count}=0;
   end;
run;

proc print data=changes;
   title 'Data Set Produced with Array Processing';
run;


/* Same as above, but getting rid of the COUNT variable  */
/* By using "(drop=count)" in Data step    */
 
data chgdrop(drop=count);
   set sas2.arts3;
   array chglist{3} museum gallery other;
   do count=1 to 3;
      if chglist{count}=. then chglist{count}=0;
   end;
run;

proc print data=chgdrop;
   title 'Data Set After Dropping Index Variable';
run;
