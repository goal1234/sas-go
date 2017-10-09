* Sample SAS Program   "pmeans.sas" ;

/* DESCRIPTIVE STATISTICS FOR NUMERIC VARIABLES     */
/* USING "PROC MEANS"             */
/* PROC MEANS with selected VARiables  */
/* PROC MEANS with selected keywords  */
/* PROC MEANS for groups 
   with the BY Statement     */
/* PROC MEANS for groups
   with the CLASS Statement  */

      
         /* GLOBAL STATEMENTS */
libname sas3 'U:\';
  options ls=75 pagesize=25;
  title;
  footnote;


        /* DESCRIPTIVE STATISTICS FOR
          NUMERIC VARIABLES */
        /* (See notes 1 and 2 below.) */
proc means data=sas3.tourrev2;
 title 'Proc Means for sas3.tourrev2';
run;
proc means data=sas3.htwt2;
 title 'Proc Means for sas3.htwt2';
run;


        /* SELECTING VARIABLES WITH PROC MEANS */
proc means data=sas3.htwt2;
  var height weight;
title 'Proc Means for sas3.htwt2';
title2 'Selected Variables';
run;


   /* USING SELECTED KEYWORDS WITH PROC MEANS */
   /* (See Notes 3 and 4 below.)      */
proc means data=sas3.htwt2 n min max sum;
title 'Proc Means for sas3.htwt2';
title2 'Using Selected Keywords';
title3 'Example 1';
run;
proc means data=sas3.htwt2 n min max nmiss;
title 'Proc Means for sas3.htwt2';
title2 'Using Selected Keywords';
title3 'Example 2';
run;


        /* PRODUCING STATISTICS BY GROUP */
         /* WITH THE BY STATEMENT     */
         /* (See Note 5 below.)     */
options pagesize=55;
proc sort data=sas3.tourrev2 out=sorttour;
 by vendor;
run;
 proc means data=sorttour;
  by vendor;
  var bookings landcost;
title 'Using Proc Means with the BY Statement';
title2;
title3;
run;


         /* PRODUCING STATISTICS BY GROUP  */
         /* USING THE CLASS STATEMENT      */
           /* (See Note 5 below.)       */
proc means data=sas3.tourrev2;
 class vendor;
 var bookings landcost;
title 'Using Proc Means with the CLASS Statement';
run;


/*------------------------------------------*/
/* NOTES:                                   */
/* 1.Note that Proc Means automatically     */
/*   produces printed output, unlike        */
/*   some other SAS procedures.  No         */
/*   Proc Print Statement is necessary.     */
/* 2.Proc Means produces statistics for     */
/*   for numeric variables only.            */
/* 3.If no keywords are specified Proc      */
/*   Means automatically produces these     */
/*   Statistics:                            */
/*     N - # of observations                */
/*     MEAN - mean or average               */
/*     STD - standard deviation             */
/*     MIN - minimum                        */
/*     MAX - maximum                        */
/* 4.You can request other statistics by    */
/*   including their keywords in the Proc   */
/*   Means statement:                       */
/*     RANGE - difference between smallest  */
/*             and largest values           */
/*     SUM - the sum of nonmissing values   */
/*           of the variable                */
/*     NMISS - # missing observations       */
/*     SUMWGT = sum of the WEIGHT variables */
/*     CSS - corrected sum of squares       */
/*     USS - uncorrected sum of squares     */
/*     VAR - variance                       */
/*     STDERR - standard error of the mean  */
/*     CV - coefficient of variation        */
/*     SKEWNESS - skewness                  */
/*     KURTOSIS - kurtosis                  */
/*     T - student's t test                 */
/*     PRT - probability of a greater       */
/*           absolute value for the t-test  */
/*    (source: SAS Procedures Guide)        */
/* 5.The BY Statement is similar to the     */
/*   CLASS Statement.  The main difference  */
/*   is that the BY Statement requires that */
/*   the data be sorted prior to use. The   */
/*   CLASS Statement does not. You can use  */
/*   the BY Statement with larger data sets */
/*   since Proc Means is not required to    */
/*   hold all the groups in memory as is    */
/*   case when the CLASS Statement is used. */
/*------------------------------------------*/
