* Sample SAS Program  "firs_las.sas" ;

/* Finding the FIRST and the LAST observation in
  a grouped data set */


data new ;
input char1 $  num2 num3 ;
cards ;
   A  1  3.3
   A  1  2.2
   A  1  1.1
   A  2  5.1
   A  2  2.2
   B  1  1.1
   B  1  2.2
   B  1  0.0
   B  2  1.1
   B  2  2.2
;
run;


              /* FIRST SORT THE DATA BY
              ALL THE GROUPING VARIABLES */

proc sort data = new ; by char1 num2 num3 ; run;

            /* FIND FIRST AND LAST OBSERVATION
                  IN A GROUP */
data new2 ; set new;
by  char1 num2 ;
fstnum2 = first.num2;
lstnum2 = last.num2;  /* VARIABLES FSTNUM2 AND LSTNUM2
                  CONTAIN 1 AND 0'S. FSTNUM2=1 IF IT IS THE
                  FIRST OBS IN A GROUP AND IT IS 0 OTHERWISE.
                 LSTNUM2=1 IF IT IS THE LAST OBS IN A GROUP
                 AND IT IS 0 OTHERWISE */
run;

proc print data=new2 ; run;

                /* THIS IS THE OUTPUT FROM PROC PRINT 
              OBS    CHAR1    NUM2    NUM3    FSTNUM2    LSTNUM2

                1      A        1      1.1       1          0
                2      A        1      2.2       0          0
                3      A        1      3.3       0          1
                4      A        2      2.2       1          0
                5      A        2      5.1       0          1
                6      B        1      0.0       1          0
                7      B        1      1.1       0          0
                8      B        1      2.2       0          1
                9      B        2      1.1       1          0
               10      B        2      2.2       0          1
              */
