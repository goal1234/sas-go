/* An example of summing across observations, and
creating a new record based on the sums. */


options ls=75;

data temp;
 input fips county $ pop var2 var3;
cards;
 12435 nyc1 2000 343 543
 43235 nyc2 3002 573 657
 64927 nyc3 3044 99 3588
 68257 Other1 4782 2896 67803
 56738 Other2 568 678 234
;
run;

proc print data=temp;
 title 'Original Data';
run;

data temp2;
 set temp;
 if fips in (12435,43235,64927) then nyc=1;
 else nyc=0;
 run;

proc sort data=temp2;
by nyc;
run;

proc means data=temp2 sum noprint;
 by nyc;
 output out=newrec sum=;
run;

data realnew (drop= _type_ _freq_);
 set newrec;
 if nyc=1;
 fips=12345;
 county='NYCity';
run;

data final (drop=nyc);
  set temp2 (where=(nyc=0)) realnew;
run;

proc print data=final;
title 'Final Data Set';
run;
