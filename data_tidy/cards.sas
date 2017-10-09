* Sample SAS Program  "enter.sas" ;

/* Entering your own data     */
/* Using list input format    */
/* Numeric and character data */
/* Print data                 */

options ls=80 ;

data temp;
  input name $ age sex $ height;
     cards;
       Aubrey 41 M 74
       Ron 42 M 68
       Carl 32 M 70
       Antonio 39 M 72
       Debbby 30 F 66
       Thomas 31 M 71
       Carol 46 F 64
       Jean 48 F 66
       ;
run;

proc print data=temp;
 title;
run;
