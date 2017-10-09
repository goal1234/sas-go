* Sample SAS program  "chkdat.sas" ;

/* Print out a few records from an       */
/*  external (raw) data file.            */
/* Use an arbitrary LRECL to find out    */
/*   what the actual lrecl is.           */
/* Output will be printed to the log.    */


options ls=79;

data _null_;

       /* Example of Printing out a few records from an   
                 external (raw) data file.  */ 
  infile 'V:\sind\084\data1.txt' obs=5;


      /* Example of using an arbitrary LRECL to find out 
           the actual lrecl (pick a fairly high value)  */
* infile 'V:\sind\084\arfsamp.dat' lrecl=50000 obs=2;

     input;
  list;
run;
