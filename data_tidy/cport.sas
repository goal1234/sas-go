/* SAMPLE SAS PROGRAM "CPORT.SAS" */
/* PROGRAM TO CREATE A SAS TRANSPORT FILE 
   BY USING "PROC CPORT"   */


/* CPORT FILE IN GENERAL HAVE EXTENSION ".cpt", ".dat" OR ".trn" */
/* CPORT FILE CREATED IN THIS SAMPLE PROGRAM IS CALLED 
   "ahbhh.cpt", AND IS SAVED IN DIR "U:\econ166\"  */
/* SAS DATASETS (mydata1 AND mydata2) READ IN THE 
   TRANSPORT FILE ARE LOCATED IN "U:\econ166\proj1\" */
/* SUBSTITUTE YOUR OWN TRANSPORT FILE NAME AND,
    FOLDER NAME IN libname AND filename STATEMENTS    */



libname ssd "U:\econ166\proj1\" ;

filename datfile "U:\econ166\ahbhh.cpt";

proc cport library=ssd file=datfile ;
select mydata1 mydata2 ;
run ;



