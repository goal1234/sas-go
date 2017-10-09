/* Sample SAS program name 'dif2sas.sas' */

/*  This program will convert a DIF file into a SAS dataset. */
/* Substitute appropriate folder names and file names */

libname ssd 'U:\';
filename diffile 'U:\filename.dif'; 
proc dif dif=diffile out=ssd.filename;
run; 

