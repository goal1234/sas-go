/* SAMPLE SAS PROGRAM "CONCATEN.SAS" */
/* PROGRAM USES A MACRO TO CONCATENATE A NUMBER OF 
  SAS DATA SETS */
/* USEFULL WHEN CONCATENATING A LARGE NUMBER OF 
  SAS DATA SETS */


Options ls=75 nodate ;

   /* CREATE THREE DATASETS TEMP1-TEMP3 */
data temp1;
input var1 @@;
cards;
1 2 3 4
;
run;

data temp2;
input var1 @@;
cards;
5 6 7 8
;
run;

data temp3;
input var1 @@;
cards;
9 10
;
run;


   /* MACRO CONCATENATES THREE DATASETS TEMP1-TEMP3,
    AND CREATES A NEW DATASET TEMP1. NEW DATASET TEMP1 
    CONTAINS 1 VARIABLE "VAR1" AND 10 OBSERVATIONS */

%macro combine;
 %do n= 2 %to 3 ;

data temp1;
 set temp1 temp&n;
run;

%end;
%mend;
%combine;

proc print data=temp1;
run;

