/* CISER COMPUTING CONSULTING */
/* SAMPLE SAS PROGRAM "TRANSPRT.SAS" */

/* Program to create a SAS transport file (XPORT file) from
   SAS datasets */


/* Example 2: with PC SAS :
This program creates a SAS transport file (XPORT file) called "prices.trn"
from SAS datasets "price1.sd2", "price2.sd2" and "price3.sd2". SAS
datasets are located in directory "u:\sas\myproj\" and transport file
"prices.trn" is saved in directory "u:\".  Substitute your own
libnames, transport filename and the file location */

libname ssd 'u:\sas\myproj\' ;
libname trndata xport 'u:\prices.trn' ;
proc copy in=ssd out=trndata ;
 select price1-price3 ;
run;

