options ls=76;
libname dx 'V:\crsp\dx\';
libname nx 'V:\crsp\dx\';

/*pulling returns for a single CRSP firm between January 1, 1989 and 
December 31, 1991*/
data single;                                                           
  set dx.tsdata;
  where (permno=10516) and                                  
   (caldt between '01JAN89'D and '31DEC91'D);
 
/*list the max and min one day return*/     
proc summary data=single;       
 class permno;  
 var ret;         
 output out=summret max=maxret min=minret;
proc print data=summret;
run;

/*                                                                      
Pull multiple records from nx(daily NASDAQ COMBINED) 
*/                                                                      
        
data nas;                           
 set nx.tsdata; 
 where permno in (35423,  59790, 79937, 80431);                  
 run;
 
/*
Pull  returns of multiple records from dx (daily combined nyse & amex)
in year 1995
*/        
data nyse;
 set dx.tsdata;
 where permno in (10225, 10233, 56119) and
 (caldt between '01JAN95'D and '31DEC95'D); 
run;



