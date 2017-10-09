/* Sample SAS program "datadump.sas"

/* This program uses raw data from the CISER archive and prints   */
/* out the data for the first 10 observations.  Note that lrecl can be in    */
/* either place (filename or infile statement) and doesn't have to be in both*/ 


filename in 'V:\cph\020\1990-99\da6188.baltim' lrecl=1940;

data temp;
infile in lrecl=1940 obs=10;
INPUT;                                                                          
LIST;                                                                           
run;
