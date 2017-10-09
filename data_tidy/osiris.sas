/* Sample SAS program "osiris.sas" */
/* Program to access OSIRIS files */


        /* IN LIBNAME STATEMENT SPECIFY "OSIRIS" ENGINE
          AND OSIRIS FILE NAME AS FOLLOWS:
        LIBNAME libref OSIRIS 'physical-filename' DICT='dictionary-file-name'; */

libname ochk osiris 'U:\da9298dd' dict='odict.s8298pp'; 
options ls=79 obs=10;
proc print data=ochk._first_; /* Use the member name _FIRST_ */
run; 

