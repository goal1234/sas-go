/* SAMPLE SAS PROGRAM "CIMPORT.SAS" */
/* PROGRAM TO READ A SAS TRANSPORT FILE CREATED BY 
   USING "PROC CPORT", see Note below */


/* CPORT FILE IN GENERAL HAVE EXTENSION "cpt", ".trn" or ".dat"  */
/* CPORT FILE READ IN THIS SAMPLE PROGRAM IS CALLED "ahbhh.cpt",
   AND IS LOCATED IN FOLDER 'U:\econ166\'   */
/* SAS DATASETS CREATED IN THE PROGRAM ARE ALSO SAVED IN FOLDER 
    'U:\econ166\PROJ1\'    */
/* SUBSTITUTE YOUR OWN TRANSPORT FILE NAME AND,
    FOLDER NAME IN libname AND filename STATEMENTS    */



libname ssd 'U:\econ166\PROJ1\';

filename datfile 'U:\econ166\ahbhh.cpt';

proc cimport library=ssd infile=datfile;
run ;



/* NOTE: HERE IS A SAMPLE SAS PROGRAM TO CREATE A TRANSPORT FILE
   BY USING "PRCO CPORT" (CPORT FILE IN GENERAL HAVE EXTENSION OF
   "CPT", ".dat" OR ".trn"). THE TRANSPORT FILE IS CALLED "ahbhh.cpt",
   AND IT IS SAVED IN folder "U:\econ166\". SAS DATASETS 
   mydata1 AND mydata2 ARE LOCATED IN FOLDER "U:\econ166\PROJ1/".  ---


libname ssd 'U:\econ166\PROJ1\';

filename datfile 'U:\econ166\ahbhh.cpt';
  
proc cport library=ssd  file=datfile ;
  select mydata1 mydata2 ;
run ;

*/
