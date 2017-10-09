/* CISER Computing Consulting */
/* Sample SAS Program "macr_ex1.sas" */

/* Program creates a PROC IML module and
  uses a MACRO to run the module a number of times.
  At each run of the module
  1. a row vector is extracted from a matrix,
  2. a col vector of normal numbers is generated,
  3. the row vector and the col vector are multiplied
      to get a scalar,
  4.  the scalar is saved in a vector.
 */


 options nonotes;

 proc iml ;   /* Start PROC IML */

       /* Create a 4X2 matrix A */
 A={3 4,
    5 6,
    7 8,
    9 1} ;

         /* Create a module "CALC" */
 start calc(row_n, A, firstv, finalv) ;

   X = A[row_n,] ; /* Create a row vector X from matrix A */
   print X ;

                  /* Generate a col vector [2,1] of random numbers
                      from standard normal distribution */
   U = RANNOR(REPEAT(0,2,1)) ;
   print U ;

   XU = X*U ;    /* Create a scalar matrix by
                    multiplying X and U */
   print XU ;

                /* At the Ist iteration the scalar
                  is saved in vector "firstv" */
   if row_n = 1 then do;
    firstv = XU ;
    finalv = firstv;
    end;

   else if row_n > 1 then do;
    finalv=firstv||XU ;  /* Create vector "finalv" by adding
                         the scalar XU to the vector "firstv" */
    firstv=finalv;  /* Initialize "firstv" for the next iteration */
   end;

   print finalv;
   print firstv ;

 finish calc ;  /* Completing the module "calc" */


 %macro compute ;   /* Create a macro "compute" */
  %do p= 1 %to 4 ;  /* Do 4 iterations of module "calc" */
   run calc(&p, A, firstv, finalv);
  %end ;
 %mend compute ;    /* Macro "compute" completed */

 %compute ;      /* Execute the macro "compute" */


 quit;   /* End PROC IML */
