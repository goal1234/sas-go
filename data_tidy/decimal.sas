* Sample SAS program  "decimal.sas" ;

/* Reading data with implied decimals.                             */
/* Using COLUMN POINTER and simple INFORMAT.                       */
/* Column pointer control @ n in INPUT statement indicate that an  */
/* input value starts at column n (n must be a positive integer).  */
/* In input statement " @ 6 income 6.2 " moves the pointer to      */
/* column 6 and informat 6.2 reads 6 digits col 6-11 in            */
/* variable income with 2 implied decimals.                        */
/* For a complete description of COLUMN POINTER and Informats see  */
/* SAS Language: Reference, Version 6, First Edition, Chapter 9.   */


  options ls=79;

  data temp;
    infile 'V:\sind\084\income.dat';

       input year 1-4
             @ 6 income 6.2
             state $ 14-15;

  run;

  proc print data=temp;
    title;
  run;
