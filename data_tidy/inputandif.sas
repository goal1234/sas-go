* Sample SAS program  "select.sas" ;

/* Using the line pointer and                                   */
/* multiple input statements to select observations,            */
/* based on the value of a particular variable.                 */
/* The trailing @ line-hold specifier holds the input           */
/* record for the execution of the next INPUT statement,        */
/* and it must appear at the end of the INPUT statement.        */
/* For a description of Line-Hold Specifiers see                */
/* SAS Language: Reference, Version 6, First Edition, Chapter 6 */


  options ls=79;

  data temp;
    infile 'U:\income.dat';
      input state $14-15 @;
         if state = 'NY';
            input year 1-4 income 6-11;
  run;

  proc print data=temp;
    title;
  run;
