title 'Examining the Growth Rate of Pigs';

data Pigs;
   input Group Block Treatment Weight @@;
   datalines;
1 1 1 2.20  1 1 2 1.84  1 1 3 2.18  1 2 4 2.05  1 2 5 0.85
1 2 6 1.86  1 3 7 0.73  1 3 8 1.60  1 3 9 1.76
2 1 1 1.19  2 1 4 1.20  2 1 7 1.15  2 2 2 2.26  2 2 5 1.07
2 2 8 1.45  2 3 3 2.12  2 3 6 2.03  2 3 9 1.63
3 1 1 1.81  3 1 5 1.16  3 1 9 1.11  3 2 2 1.76  3 2 6 2.16
3 2 7 1.80  3 3 3 1.71  3 3 4 1.57  3 3 8 1.13
4 1 1 1.77  4 1 6 1.57  4 1 8 1.43  4 2 2 1.50  4 2 4 1.60
4 2 9 1.42  4 3 3 2.04  4 3 5 0.93  4 3 7 1.78
;

proc lattice data=Pigs;
   var Weight;
run;

/*The LATTICE procedure computes the analysis of variance and analysis of simple covariance for data from an experiment with a lattice design. */
/*PROC LATTICE analyzes balanced square lattices, partially balanced square lattices, and some rectangular lattices. */

/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: LATEX1                                              */
/*   TITLE: Documentation Example 1 for PROC LATTICE            */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: LATTICE                                             */
/*   PROCS: LATTICE                                             */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: RAB          UPDATE:                                */
/*     REF: COCHRAN, W.G. & COX, G.M.(1957), "EXPERIMENTAL      */
/*          DESIGNS", 2ND EDITION, NEW YORK: JOHN WILEY & SONS. */
/*    MISC:                                                     */
/****************************************************************/

data Soy(drop=plot);
   do Group = 1 to 2;
      do Block = 1 to 5;
         do Plot = 1 to 5;
            input Treatment Yield @@;
            output;
         end;
      end;
   end;
   datalines;
 1  6  2  7  3  5  4  8  5  6  6 16  7 12  8 12  9 13 10  8
11 17 12  7 13  7 14  9 15 14 16 18 17 16 18 13 19 13 20 14
21 14 22 15 23 11 24 14 25 14  1 24  6 13 11 24 16 11 21  8
 2 21  7 11 12 14 17 11 22 23  3 16  8  4 13 12 18 12 23 12
 4 17  9 10 14 30 19  9 24 23  5 15 10 15 15 22 20 16 25 19
;

proc lattice data=Soy;
run;

