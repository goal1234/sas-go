/* CISER COMPUTING CONSULTING */
/* SAMPLE SAS PROGRAM "SELE_CON.SAS" */

/* USES MACROS TO 
  - CREATE NEW DATASETS FROM A SAS DATA SET WITH ALL SUBSETS OF N=fixed 
     CONSECUTIVE OBSERVATIONS STARTING FROM THE FIRST OBSERVATION  
  - DOES REGRESSION WITH EACH DATASET AND 
  - SAVES AN OUTPUT REGRESSION DATASET
*/ 



options ls=65 nodate;
libname in 'U:\' ;
data temp;
input var1 y x  ;
cards;

1 2 4
2 3 6
3 1 2
4 4 8
5 3 6.1
6 5 9.9
7 2 4.1
;

run;

proc sort data=temp  out=in.temp;  by var1; run;


/* CREATE A MACRO THAT USES A DATASET, N AND TOT TO 
   CREATE NEW DATASETS WITH N OBSERVATIONS, 
   DOES REGRESSION WITH THOSE SELECTED OBSERVATIONS AND 
   EACHTIME CREATES A NEW OUTPUT REGRESSION DATASET */
/* SELECT OBSERVARIONS N AT A TIME STARTING FROM FIRST OBS */
/* IN OUT EXAMPLE SELECT N=5 at a time, TOT=3 possibilities */


%macro compute (mydata, tot, n) ;

%do k=1 %to &tot ;
 data outdata ;
 set &mydata ;
   if _n_ < &k   or   _n_ > (&n+ &k -1) then delete;
   proc reg data=outdata outest=out_reg&k ;
    model y=x;
    title "REGRESSION_&K" ;
   proc print data=outdata;
    title "DATA&k" ;
   proc print data=out_reg&k;
    title "OUT_REG&k" ;
 run;
%end ;

%mend compute;

%compute (in.temp, 3, 5);
