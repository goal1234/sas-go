/* 7/30/01 Edited by Pinky Chandra */


/* This program uses data from the Census of Population and 
Housing, 1990 [United States]: Public Use Microdata Sample:
1/10,000 Sample */

/* This program restructures the data into a flat ascii file */

/* There will be 25105 records in the "cen90.txt" file created 
by this program (one record for each person), and the logical 
record length will be 462.  Person level data will be in 
columns 1-231, and household level data in columns 232-462 of 
each record. */ 




options ls=76 ps=100;

filename in 'V:\cen1990\008B.0001\da6150'
    lrecl=231;

data temp (drop=rectype);
  infile in;
  retain hrec1 hrec2;

  input rectype $1 @;
    if rectype='H' then do;
      input @1 hrec1 $200. @201 hrec2 $31.;
    end;

    else if rectype='P' then do;
       input @1 prec1 $200. @201 prec2 $31.;
    output;
    end;
run;


data _null_;
   set temp;
   file 'U:\cen90.txt' lrecl=462;
    put @1 prec1 @201 prec2 @232 hrec1 @432 hrec2;
run; 
