* Sample SAS program  "form_inp.sas" ;


/* Creating a SAS Data Set using Formatted Input  */


data nasa;
   infile 'U:\nasa.dat';
   input YEAR 4. @7 TOTAL comma6.
         @13 PTOTAL comma6. @20 PFLIGHT comma6.
         @28 PSCIENCE comma6. @35 PAIRTRAN comma6.
         @43 FTOTAL 3. @49 FFLIGHT 3.
         @58 FSCIENCE 3. @64 FAIRTRAN 3.0;
    label     total='Total Outlays'
             ptotal='Performance: Total'
            pflight='Performance: Space Flight'
           pscience='Performance: Space Science Applications'
           pairtran='Performance: Air Transport and Other'
             ftotal='Facilities: Total'
            fflight='Facilities: Space Flight'
           fscience='Facilities: Space Science Applications'
           fairtran='Facilities: Air Transport and Other' ;
   run;



proc print data=nasa;
run;
