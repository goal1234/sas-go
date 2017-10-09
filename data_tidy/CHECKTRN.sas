/* CISER COMPUTING CONSULTING */
/* SAMPLE SAS PROGRAM "CHECKTRN.SAS" */

/* Program to check contents of a SAS transport file */
/* Transport file "broome.trn" is saved in subfolder ''U:\' */


libname trn xport 'U:\broome.trn';
options ls=80 nodate;                                                           
proc contents data=trn.broome; 
  title 'Contents of Broome SAS Transport File';
run;
