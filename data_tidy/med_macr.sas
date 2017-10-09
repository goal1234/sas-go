/* CISER COMPUTING CONSULTING */
/* SAMPLE SAS PROGRAM "MED_MACR.SAS" */

/* PROGRAM USES "PROC UNIVARIATE" TO COMPUTE MEDIAN AND SAVES
   IT AS AN OBSERVATION IN AN OUTFILE */
/* IT USES A MACRO TO READ IN THIS MEDIAN FROM THE OUTFILE AND ATTACH IT TO
   EVERY OBSERVATION IN THE ORIGINAL FILE FOR COMPARISONS, ETC. */

   /* CREATS A MACRO THAT TAKES IN A VALUE AND CREATES A NEW VARIABLE
      IN THE ORIGINAL DATASET */
   /* EXECUTES THE MACRO WITH OBSERVATIONS FORM THE MEDIAN OUTFILE AS 
      INPUT TO THE MACRO */
 

libname sp 'U:\';
options ls=70 ;
data sp.new ;
input num1 $ num2 num3 num4 ;
cards ;
1 1 3.3 1
1 1 2.2  1
1 1 1.1  1
1 2 1.1  1
1 2 2.2  1
2 1 1.1  1
2 1 2.2  1
2 2 1.1  1
2 2 2.2  1
;

run;

proc sort ; by num4;
         
          /* COMPUTE MEDIAN OF A VARIABLE AND SAVE IN
             AN OUTPUT DATA SET */
proc univariate ; by num4 ;
var num3;
output out=outuni median=md_num3;

proc print data=outuni ; run;

       /* CREATE A MACRO THAT TAKES IN MEDIAN AND CREATES 
          A VARIABLE WITH THAT VALUE IN THE NEW DATASET NEW&N */
%macro uni (median, n) ;

data new&n ; set sp.new ;
  md_num = &median ;
  z=0 ; if num3 ge md_num  then z=1 ;
run;
proc print data=new&n; run ;
proc contents data=new&n ; run;

%mend;

         /* EXECUTE THE MACRO WITH ITS INPUT FROM THE OBSERVATIONS
            OF A DATASET */
data _null_ ; set outuni ;

call execute ('%uni ('||md_num3||', '||_n_||')');
run;


