* SAS Sample Program  "sind_dat.sas" ;

/* Data Extraction from World Tables of Economic
   and Social Indicators 1950-1992  */
/* Data includes a header record    */


libname ssd  'U:\' ;
filename in 'V:\sind\059\da6159' lrecl=937 ;

data ssd.sind ;
  infile in firstobs=2 missover;

input country $ 1-3
      ind $ 5-34   @ ;

if country in
   ('AFG', 'BGD',
    'KHM' )
and ind in
   ('CP.L.RESBAL' ,
    'CP.L.EXP.GNFS' )
then do ;
input @ 35 (year50-year92) (21.);
end;

else delete;

proc means data=ssd.sind;
proc freq data=ssd.sind; tables country ind ;
run;

proc print data=ssd.sind(obs=10) ;
var country ind year90 year91 year92 ;
run;
