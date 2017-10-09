/* Sample SAS Program "include.sas" */

/* Example of using %INCLUDE statement */
/* %INLUDE statement brings SAS programming statements, data lines, or both, 
  into a current SAS program. For example, if you use a set of global statements
  very frequently, you can create a text file with those SAS statements and
  use a %INCLUDE statement to call them in your program. 
  Below is an example. */


data electric;
 format date monyy5.;
 input date:monyy5. elec @@;
 month=date;
 cards;
jan83 195579 
feb83 172479
mar83 182488
apr83 170372
may83 174932 
jun83 191048
jul83 220165
aug83 229957
;
run;

%include "U:\myglobal.txt" ;

proc gplot data=electric;
 plot elec*date / vaxis=170000 to 240000 by 10000;
 symbol1 i=joint;
 run;

/**** THE TEXT FILE "U:\myglobal.txt"
 INCLUDES THE FOLLOWING STATEMENTS:

libname ssd 'U:\';
options ls=75 nodate ;
title "This output was produced on &sysdate at &systime";

****/
