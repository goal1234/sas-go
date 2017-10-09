/* Sample SAS program name "dbf2sas.sas" */

/*  This program will convert a dBase III file into a SAS dataset. */

/* Substitute appropriate folder names and file names */

libname ssd 'U:\';
filename dbfile 'U:\dbfile.dbf'; 

proc dbf db3=dbfile out=ssd.sasfile; 
run; 

