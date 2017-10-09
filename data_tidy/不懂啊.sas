/* Sample SAS Program "update.sas" */

/********************************************/
/* Sample program to convert all            */
/* ".sd2" files in a directory              */
/* to ".sas7bdat" files which               */
/* can be moved across operating systems    */
/********************************************/

options ls=75;
         /* Folder where .sd2 files are located */
libname ssd6 v6 'U:\oldfiles\' ; 

        /* Folder where you wish to create the 
            updated SAS data files */
libname ssd7 v7 'U:\NEWfiles\' ; 

       /*Use DATECOPY option to preserve the data creation date 
         (the date that shows up in the results of PROC CONTENTS) */
proc copy in=ssd6 out=ssd7 datecopy;  
run; 

/* optional checks */

proc datasets library=ssd6;run;
proc datasets library=ssd7;run;

proc contents data=ssd7._all_;
run;

