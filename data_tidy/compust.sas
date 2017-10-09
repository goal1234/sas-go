/** SAMPLE SAS PROGRAM "compust.sas" **/
/** PROGRAM READS COMPUSTAT SAS DATASETS **/

/* COMPUSTAT documentation is available at
   http://research.gsm.cornell.edu/research/documentation/documentation.html
   and on the CISER file server in directory 
   V:\compustat\user_guide  .
   A printed copy of the COMPUSTAT User's Guide is shelved
   in the Data Archive, Codebook ECON-028" */

/* COMPUSTAT SAS datasets are located on the file server
   in the V:\compustat directory.
   - Industrial datasets are saved in subdirectories
       ica, icar, icq, icqr
   - Business information datasets (segment) are saved in subdir
       segment
   - Bank datasets are saved in subdir
       banka and bankq
   - Canadian data are located in subdir
       canann canpde canqtr
   - Expansion data are located in subdir
       expann expqtr
   - Global data are located in subdir
       global
   - Price-Dividends-Earnings datasets are saved in subdir
       pde pdr     
   - Utlities data are located in subdir
       utila utilq                       */

/*V:\compustat also contains several reference and 
crosswalk datasets.*/

/* A description of Compustat and lists of variables are
available at the JGSM research computing documentation web site,
cited above. */



  
           /* READ INDUSTRIAL ACTIVE SAS DATASETS 
              SAVED IN DIR "V:\compustat\ica\"   */
options ls=70 ;
libname ssd 'V:\compustat\ica\' ;

          /* READ THE SAS DATASET master.sas7bdat,
             CREATE A NEW DATASET WITH SELECTED COMPANIES,
             USE STOCK TICKER SYMBOL (smbl) FOR SELECTION,
             SELECT A FEW VARIABLES
               CUSIP ISSUER CODE(cnum),... */
data temp (keep=smbl cic cnum coname);
set ssd.master (where=(smbl="CPQ" or smbl="DELL" 
                      or smbl="MSFT" or smbl="INTC")) ;
run;
proc print data=temp;
run;

/** OUTPUT FROM PROC PRINT 

         OBS     CNUM     CIC    CONAME                  SMBL

          1     204493    100    COMPAQ COMPUTER CORP    CPQ
          2     247025    109    DELL COMPUTER CORP      DELL
          3     458140    100    INTEL CORP              INTC
          4     594918    104    MICROSOFT CORP          MSFT
**/


       
        /* READ THE SAS DATASET data.sas7bdat,
           CREATE A NEW DATASET WITH SELECTED COMPANIES,
           USE CUSIP ISSUER CODE(cnum) FOR THE SELECTION,
           SELECT A FEW VARIABLES cnum cic d1 d12   */

data temp2 (keep=cnum cic d1 d12) ; 
 set ssd.data;
where cnum="204493" ;
run;

        /* OBTAIN A TIMEPLOT FOR VARIABLES d1 and d12 */
proc timeplot data=temp2;
 plot d1 d12;
run;
