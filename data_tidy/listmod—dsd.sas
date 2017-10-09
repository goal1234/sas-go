/* Sample SAS Program "listmod.sas" */

/* Example of a modified list input */

options ls=75;
           /* Use DSD option to read a comma delimited data */
data test;
 infile cards dsd ;
 input name:$20. date:mmddyy8. v1 v2 v3 v4 v5;
 cards;
 Tina Mohammed,07/29/51,34236,45745,12613,3623,42
Sophie Batten,02/18/49, 653,73475,88732,745475,37686
Joseph Miles,02/11/57,527,64789,579,3497,4679
Duane Smith,09/12/63,7898,678903,678903,7807,67946
;
run;

proc print data=test;
format date mmddyy8.;
run;
