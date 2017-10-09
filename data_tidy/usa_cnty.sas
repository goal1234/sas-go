* Sample SAS Program "usa_cnty.sas" ;

/* USA Counties 1996, CISER Codebook CPH-202 (1996) */
/* PROGRAM TO READ CENSUS DATA AND CREATE A SAS DATASET
THAT CONTAINS PER CAPITA PERSONAL INCOME AND THE FLAGS */

 
libname here 'U:\' ;
filename in 'V:\cph\202\master.costat.padded'
     RECFM=V lrecl=717;
data here.temp;
infile in ;

input
#43 stcou1 1-2 stcou2 3-5 stcou 1-5
ip02089f 388 ip02089d 389-398
ip02090f 399 ip02090d 400-409
ip02091f 410 ip02091d 411-420
ip02092f 421 ip02092d 422-431

#63;

label
 stcou = "FIPS"
 stcou1 = "COUNTY CODES- STATE"
 stcou2 = "COUNTY CODES - COUNTY"
 ip02089f = "FLAG - 1989 PER CAPITA PERS INC"
 ip02089d = "1989 PER CAPITA PERSONAL INCOME"
 ip02090f = "FLAG - 1990 PER CAPITA PERS INC"
 ip02090d = "1990 PER CAPITA PERSONAL INCOME"
 ip02091f = "FLAG - 1991 PER CAPITA PERS INC"
 ip02091d = "1991 PER CAPITA PERSONAL INCOME"
 ip02092f = "FLAG - 1992 PER CAPITA PERS INC"
 ip02092d = "1992 PER CAPITA PERSONAL INCOME"
 ;

proc means data=here.temp;
proc freq data=here.temp;
tables ip02089f ip02090f ip02091f ip02092f;


      /* PRINTS FREQUENCIES FOR FIPS IF STATE CODE OR 
		COUNTY CODE IS ZERO */
proc freq data=here.temp(where=(stcou2=00 or stcou1=00));
tables stcou ;

run;

       /* CONVERT THE SAS DATA SET temp.ssd01 INTO SAS
          TRANSPORT FORMAT temp.trn */ 
libname trn xport 'U:\\temp.trn' ;
proc copy in=here out=trn;
select temp ;
run;
