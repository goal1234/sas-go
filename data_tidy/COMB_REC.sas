/* SAMPLE SAS PROGRAM "COMB_REC.SAS" */

/* COMBINES INFORMATION FROM SEVERAL RECORDS IN INPUT RAW DATA SET 
   TO CREATE A SINGLE OBSERVATION IN THE OUTPUT SAS DATASET */
/* INPUT DATASET CONTAINS CONSECUTIVE MULTIPLE BIRTH/ADOPTION RECORDS
   ASSOCIATED WITH A MOTHER */
/* OUTPUT SAS DATASET INCLUDES ONE OBSERVATION FOR EACH MOTHER */

 
options ps=55 ls=70 ;

data temp (drop=i) ;
infile 'U:\85_93cah.dat' lrecl=57 missover ;

input int_par 2-5  per_par 6-8 sex_par 9
      mon_par 10-11 yr_par 12-15 mar_mom 16
      num_ch 55-56 @ ; /* OBTAIN MOM'S INFO AND TOTAL NUMBER OF CHILDREN,  
                          HOLD THE POINTER AT THE SAME RECORD */

                   /* NUMBER OF BIRTH OR ADOPTION
                     RECORDS RANGES FROM 1 THRU 18 */
array per_ch{18} per_ch1-per_ch18 ;
array sex_ch{18} sex_ch1-sex_ch18 ;
array mon_ch{18} mon_ch1-mon_ch18 ;
array yr_ch{18} yr_ch1-yr_ch18 ;
do i = 1 to num_ch ;
  input per_ch{i} 23-25 sex_ch{i} 26 mon_ch{i} 27-28
        yr_ch{i} 29-32 ;
end ;

output ; /* CREATE AN OBS WHEN INFO ABOUT ALL CHILDREN IS OBTAINED */
run;

proc print data=temp(obs=20) ;
run;
