

/* Program from Mancang Dong, JGSM */

options nocenter ;

libname  dx 'V:\CRSP\dx\';
libname mcd 'U:\';

/* This program is to obtain the pre and post 30 day's of
   return from daily time series data. I calculated the max-
   obs within a permno which is 8939 for the 1997 data. Therefore,
   I defined array size to be 10000. Although this is for 30
   day's range, you can change to any range as long as 
   2*range + maxobs/within permno <= array size. Actually,  
   array size can also be changed according to your need.

   The array hld is defined as two dimenstions(10000,2). 10000 rows 
   should be >= 2*range + maxobs/within permno and 2 columns is for 
   variables caldt and ret. To make the programming easier, I store
   the i obs within permno to the array hld(range+i,*) and set the
   array hld(1:range,*) and hld(totobs+1:totobs+range,*) to missing 
   values so it is easy to output the all variables by starting with
   hld(range+1,*) without figuring out which should be missing & which
   shouldn't. totobs is total obs within permno. I use the
   count to count the number of obs within permno.
  
   This program is superior to get_ts.sas because the range is
   not limitted and it only read data once. Consequently, it  
   not only runs fast but also saves work disk space. 

   If your data is already sorted ascendingly, you may skip 
   the sort.
 
   Mancang            3/9/1999                   */

data two;             /* if data is sorted this is not necessary */
     set mcd.samp;    /* data mcd.samp is a subset from dx.tsdata */

proc sort data=two;  /* if data is sorted this is not necessary */
   by permno caldt;  /* permno= company number, caldt=date      */

proc print data=two (obs=100); /*not necessary if the data is sorted */

data mcd.ret2 (keep=permno caldt ret pre1-pre30 pst1-pst30);
 
 array hld {10000,2};
 retain hld ;
 retain count 0 ;
 retain old_perm;
 array  prets{30} pre1-pre30;
 array  pstts{30} pst1-pst30;

 set two (rename =(permno=perm caldt=caldate ret=return)) end=last;

 if _n_ =1 then 

    do;
 
      do i=1 to 30;
         hld(i,2) = . ;
      end;

      old_perm = perm;
      count=30;
 
    end;

 if  (perm ne old_perm) then

    do; 
       
     do i=1 to 30; 

        hld(count+i,2) = . ;

     end;
         
     do j=31 to count;

        do k=1 to 30;
           prets(k) = hld(j-k,2);
           pstts(k) = hld(j+k,2); 
        end;
 
        caldt  = hld(j,1);
        ret    = hld(j,2);
        permno = old_perm;
        output mcd.ret2;

     end;

       count = 31;
       hld(count,2) = return;
       hld(count,1) = caldate;
       old_perm = perm;

     end;

  else
       do;
       count=count+1;
       hld(count,1)=caldate;
       hld(count,2)=return;
       end;
             
       
  if last then
     do;
 
      do i=1 to 30; 

        hld(count+i,2) = . ;

      end;
         
        do j=31 to count;

           do k=1 to 30;
              prets(k) = hld(j-k,2);
              pstts(k) = hld(j+k,2); 
           end;
 
           caldate = hld(j,1);
           return  = hld(j,2);
           permnum = old_perm;
           output mcd.ret2;

        end;
     end;

 proc contents data=mcd.ret2;
 
 proc print data=mcd.ret2 (obs=50);
