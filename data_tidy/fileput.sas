/* Sample SAS program "fileput.sas" */

/* This program creates a plain ascii file called "sceen1.txt" 
      from a SAS data set "screen1.sas7bdat" */

/*
About the file statement:  The default maximum line size on the output
file is 256, unless you specify a larger line size with the "ls" or
"lrecl" options.  See SAS Language, Reference Version 6, 1st Edition, pages
342-349 to get information about file statement options.
*/ 

libname ssd01 'U:\';
data temp;
  set ssd01.screen1;
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
