/* CISER COMPUTING CONSULTING */
/* SAMPLE SAS PROGRAM "RAND_SAM.SAS" */

/* TO GENERATE A RANDOM SAMPLE FROM A SAS DATA SET */
/*      GENERATE A RANDOM VECTOR
        SORT THE DATA BY THE RANDOM VECTOR
        SELECT THE FIRST K OBSERVATIONS       */


data populatn;
input var1 @@ ;
 cards;
  2.1  3.1 4 6  2.2  4.9 4 5 3  3.3  4 5 3 4.3
  2.3 4 5 7 3 3 9 11 2
;

run;
proc print;
run;


%let k=10; /* DEFINE SAMPLE SIZE */

DATA dummy;
  SET populatn;
  random=RANUNI(-1); /* GENERATE A RANDOM VECTOR */

PROC SORT DATA=dummy;
  BY random;       /* SORT OBSERVATIONS BY THE RANDOM VECTOR */

DATA sample;
  SET dummy(drop=random);
  IF _N_ le &k;   /* SELECT THE FIRST K OBSERVATIONS */
  run;

proc print;
run;
