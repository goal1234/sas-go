* Sample SAS program  "mixfmt.sas" ;

/* Using Mixed Input Formats */
/* Column and Formatted LIST INPUT */
/* Reading (and writing) Dates */

options ls=80 nodate;

data temp;
  infile 'U:\data3.txt';
  input name $ 1-10
        sex $
        age
        height
        weight
        startdat:MMDDYY8.
        points:COMMA5.
        balance
        ;

* format startdat MMDDYY8.;

run;

proc print data=temp;
 title;
run;
