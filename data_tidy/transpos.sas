/* CISER COMPUTING CONSULTING */
/* SAMPLE SAS PROGRAM "TRANSPOS.SAS" */

/* PROGRAM TRNSPOSES A DATSET */

options ls=65 nodate;
data temp;
input var1 var2 var3 var4 var5 $ ;
cards;
1 2 3 4 newvar1
1 3 4 5 newvar2
1 4 5 6 newvar3
2 5 6 7 newvar4
2 6 7 8 newvar5
2 7 8 9 newvar6
;
run;
proc print;
title "Original dataset";
run;
proc sort data=temp; by var1;

proc transpose data=temp out=trn_temp ; /* OUTPUT FILE TRN_TEMP
                             CONTAINS THE TRANSPOSED DATASET */
by var1 ;    /* TRANSPOSES DATA BY VARIABLE VAR1 */
var var2 var3 var4 ;  /* TRANSPOSES VARIABLES VAR2-VAR4 */
id var5;  /* VAR5 CONTAINS THE NAMES OF THE VARIABLES 
               CREATED IN THE OUTPUT DATASET TRN_TEMP.
          (IF THERE IS NO ID VARIABLE DEFAULT OUTPUT VARIABLES
            NAMES ARE COL1, COL2, COL3 */

proc print data=trn_temp;
title "OUTPUT DATASET: Transposed ";
run;


/***  BELOW IS THE SAS OUTPUT GENERATED IN THIS PROGRAM 

                PRINT ORIGINAL DATASET TEMP.SSD01               1

         OBS    VAR1    VAR2    VAR3    VAR4     VAR5

          1       1       2       3       4     newvar1
          2       1       3       4       5     newvar2
          3       1       4       5       6     newvar3
          4       2       5       6       7     newvar4
          5       2       6       7       8     newvar5
          6       2       7       8       9     newvar6
 

              OUTPUT DATASET TRN_TEMP.SSD01                  2

 OBS VAR1 _NAME_ NEWVAR1 NEWVAR2 NEWVAR3 NEWVAR4 NEWVAR5 NEWVAR6

  1    1   VAR2     2       3       4       .       .       .   
  2    1   VAR3     3       4       5       .       .       .   
  3    1   VAR4     4       5       6       .       .       .   
  4    2   VAR2     .       .       .       5       6       7   
  5    2   VAR3     .       .       .       6       7       8   
  6    2   VAR4     .       .       .       7       8       9   

****/
