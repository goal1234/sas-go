* Sample SAS Program  "linkrec1.sas" ;

/* Sample program to read data with multiple
record types. Links data from two record
types to create a single observation   */

/* The data file "da6497" contains 
 The Census of Populationand Housing, 1990, Public Use Microsample: 1/1000 */

/* The data contains HOUSEHOLD Records and PERSON Records */

/* The records in data file "da6497" look something like this

     H . . . . . . . .
     P . . . . . . . .
     P . . . . . . . .
     H . . . . . . . .
     P . . . . . . . .
     H . . . . . . . .
                                    */

/* Goal is to link HOUSEHOLD information with individual information
  for each PERSON in the household  */
 


filename pums  'V:\cen1990\008A.001\da6497' ;

data temp;

  infile pums lrecl=231;

     input RECTYPE $ 1 @;

      if RECTYPE='H' then do;
       retain SERIALNO PERSONS ROOMS BEDROOMS;

       input
         SERIALNO 2-8
         PERSONS 33-34
         ROOMS 43
         BEDROOMS $ 57;

      end;

      else if RECTYPE='P' then do;

        input
         SEX $ 11
         AGE 15-16
         MARITAL $ 17
         PWGT1 18-21
         YEARSCH $ 51-52;

       /* Missing values recode */
       if ROOMS=0 then ROOMS=.;
       if BEDROOMS='0' then BEDROOMS=' ';
       if YEARSCH='00' then YEARSCH=' ';
       output;
     end;

   label
       PERSONS='Number of person records this household'
       ROOMS='Rooms'
       BEDROOMS='Bedrooms'
       SEX='Sex'
       AGE='Age'
       MARITAL='Marital status'
       PWGT1='Person weight'
       YEARSCH='Educational attainment';
run;

proc means data=temp ; run;

proc print data=temp (obs=25);
run;
