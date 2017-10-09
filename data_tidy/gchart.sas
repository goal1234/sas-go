/* Creating Graphs with SAS on Gaea */
/* SAMPLE SAS PROGRAM "GCHART.SAS" */

/* SAMPLE PROGRAM TO CREATE A PIE CHART ;
 Using GOPTIONS statement to override default graphics setup */

libname ssd '.' ;
goptions gunit=pct
       display
        rotate=landscape
      cback=white
      ctext=blue
      colors=(red blue green)
    ;

data temp;
input num1 @@;
cards;
  1 1 1 2 2 2 2 3 3 3 3 3
;
 * proc freq ;
run;

proc gchart data=temp;
 pie num1 /discrete fill=solid;
run;
