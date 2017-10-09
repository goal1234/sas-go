/* SAMPLE PROGRAM TO LIST CONTENTS OF ALL 
   SAS DATA SETS IN A DIRECTORY   */

options ls=76;
libname ssd 'V:\crsp\dx';
proc contents data=ssd._all_;
run;

