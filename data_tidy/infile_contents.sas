* Sample SAS Program name "dataset.sas";

* Reading an external data file;
* Using column input;
* Creating a permanent SAS data set;
* Using FILENAME, INFILE, and LIBNAME statements;
* Checking the CONTENTS of the SAS data set;
* External file used in this sample program is 
  called "data1.txt" located in dir
  "V:\sind\084\"  ;
* SAS dataset created in this program is
  called "htwt" and is saved in folder 'U:\';
* Note - In LIBNAME statement substitute appropriate folder name ;


  filename in 'V:\sind\084\data1.txt';
  libname ssd 'U:\';

  options ls=79 nodate;

  data ssd.htwt;
    infile in;
       input name $ 1-10
             sex $ 12
             age 14-15
             height 17-18
             weight 20-22
             ;
       wtkilo=weight*.45;    
  run;

  proc contents data=ssd.htwt;
     title "Contents of SAS Dataset 'htwt'";
     title2 "Height and Weight Data Base";
  run;

 
