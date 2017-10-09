/* CISER COMPUTING CONSULTING */
/* SAMPLE SAS PROGRAM "ASCII.SAS" */

/* Program creates an ascii datafile from the SAS dataset */
/* SAS dataset "screen1.sas7bdat" is read from folder 'U:\' */
/* ASCII file created in the program is called "screen1.txt" and is
   saved in the current directory */

/* Output file "screen1.txt" would contain ascii data in a fixed 
   column format. For example, data from variable SSNUM in "screen1.ssd01" 
   is saved in ascii file "screen1.txt" in column 1-6. Similarly, data 
   from var RESPONSE is saved in column 8 of the ascii file */  
  

libname myssd 'U:\';
data _null_;
  set myssd.screen1;
  file 'U:\screen1.txt';                                                         
  put @  1   SSNUM
      @  7   FTYPE
      @  8   RESPONSE
      @  9   FCODE
      @  15  RSNUM
      @  21  SCODE
      @  27  UNITID
      @  33  RCOVER
      @  34  RCDESC
      @  54  INAME
      @  79  ISTREET
      @ 104  ICITY
      @ 129  ICOUNTY
      @ 154  ISTATE
      @ 156  IZIP
      @ 161  FC1
      @ 162  FC2
      @ 163  FC3
      @ 164  CDS1
      @ 165  CDS2
      @ 166  CDS3
      @ 167  CDS4
      @ 168  DESC4
      @ 188  CDS5
      @ 189  RUNIT;
run;
