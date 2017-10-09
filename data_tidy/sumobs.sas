/* Sample SAS Program "sumbyobs.sas" */

/* Uses PROC MEANS with BY and OUTPUT statements to
  produce a summary data set */
/* Substitute appropriate file names and folder names */


filename in1 'U:\mytest.dat'; 
libname ssd 'U:\';
option ls=70 ;

data temp;
INFILE in1;
input primary sex age inmig outmig nonmig netmig pop;
run;

proc sort data=temp;
by primary sex;
run;

proc means data=temp noprint;
var in_mig out_mig non_mig net_mig pop;
by primary sex ;
output out=warren sum=s_inmig s_outmig s_nonmig s_netmig s_pop;
run;

data ssd.warren;
set warren(drop=_TYPE_ _FREQ_);
run;

proc print data=ssd.warren;
run;

