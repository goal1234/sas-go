*---path model---*;
proc calis nobs=932 data=Wheaton;
   path
      Anomie67     <=== Alien67   = 1.0,
      Powerless67  <=== Alien67   = 0.833,
      Anomie71     <=== Alien71   = 1.0,
      Powerless71  <=== Alien71   = 0.833,
      Education    <=== SES       = 1.0,
      SEI          <=== SES       = lambda,
      Alien67      <=== SES       = gamma1,
      Alien71      <=== SES       = gamma2,
      Alien71      <=== Alien67   = beta;
   pvar
      Anomie67     = theta1,
      Powerless67  = theta2,
      Anomie71     = theta1,
      Powerless71  = theta2,
      Education    = theta3,
      SEI          = theta4,
      Alien67      = psi1,
      Alien71      = psi2,
      SES          = phi;
   pcov
      Anomie67    Anomie71    = theta5,
      Powerless67 Powerless71 = theta5;
run;



/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CALEX101                                            */
/*   TITLE: Documentation Example 1 for PROC CALIS              */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: MSTRUCT, covariance estimation                      */
/*   PROCS: CALIS                                               */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: yiyung                UPDATE: October 12, 2009      */
/*     REF: PROC CALIS, Example 1                               */
/*    MISC:                                                     */
/****************************************************************/

data sales;
   input q1 q2 q3 q4;
   datalines;
1.03   1.54   1.11   2.22
1.23   1.43   1.65   2.12
3.24   2.21   2.31   5.15
1.23   2.35   2.21   7.17
 .98   2.13   1.76   2.38
1.02   2.05   3.15   4.28
1.54   1.99   1.77   2.00
1.76   1.79   2.28   3.18
1.11   3.41   2.20   3.21
1.32   2.32   4.32   4.78
1.22   1.81   1.51   3.15
1.11   2.15   2.45   6.17
1.01   2.12   1.96   2.08
1.34   1.74   2.16   3.28
;

proc calis data=sales pcorr;
   mstruct var=q1-q4;
run;

proc calis data=sales nose;
   mstruct var=q1-q4;
run;



/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CALEX102                                            */
/*   TITLE: Documentation Example 2 for PROC CALIS              */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: MSTRUCT, covariance and mean estimation             */
/*   PROCS: CALIS                                               */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: yiyung                UPDATE: October 12, 2009      */
/*     REF: PROC CALIS, Example 2                               */
/*    MISC:                                                     */
/****************************************************************/

data sales;
   input q1 q2 q3 q4;
   datalines;
1.03   1.54   1.11   2.22
1.23   1.43   1.65   2.12
3.24   2.21   2.31   5.15
1.23   2.35   2.21   7.17
 .98   2.13   1.76   2.38
1.02   2.05   3.15   4.28
1.54   1.99   1.77   2.00
1.76   1.79   2.28   3.18
1.11   3.41   2.20   3.21
1.32   2.32   4.32   4.78
1.22   1.81   1.51   3.15
1.11   2.15   2.45   6.17
1.01   2.12   1.96   2.08
1.34   1.74   2.16   3.28
;

proc calis data=sales meanstr nostand;
   mstruct var=q1-q4;
run;



/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CALEX104                                            */
/*   TITLE: Documentation Example 3 for PROC CALIS              */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: MSTRUCT, Uncorrelatedness model                     */
/*   PROCS: CALIS                                               */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: yiyung                UPDATE: October 12, 2009      */
/*     REF: PROC CALIS, Example 3                               */
/*    MISC:                                                     */
/****************************************************************/

data sales;
   input q1 q2 q3 q4;
   datalines;
1.03   1.54   1.11   2.22
1.23   1.43   1.65   2.12
3.24   2.21   2.31   5.15
1.23   2.35   2.21   7.17
 .98   2.13   1.76   2.38
1.02   2.05   3.15   4.28
1.54   1.99   1.77   2.00
1.76   1.79   2.28   3.18
1.11   3.41   2.20   3.21
1.32   2.32   4.32   4.78
1.22   1.81   1.51   3.15
1.11   2.15   2.45   6.17
1.01   2.12   1.96   2.08
1.34   1.74   2.16   3.28
;

proc calis data=sales;
   mstruct var=q1-q4;
   matrix _cov_ [1,1], [2,2], [3,3], [4,4];
run;



/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CALEX105                                            */
/*   TITLE: Documentation Example 4 for PROC CALIS              */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: MSTRUCT, testing covariance patterns                */
/*   PROCS: CALIS                                               */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: yiyung                UPDATE: October 13, 2009      */
/*     REF: PROC CALIS, Example 4                               */
/*    MISC:                                                     */
/****************************************************************/

data sales;
   input q1 q2 q3 q4;
   datalines;
1.03   1.54   1.11   2.22
1.23   1.43   1.65   2.12
3.24   2.21   2.31   5.15
1.23   2.35   2.21   7.17
 .98   2.13   1.76   2.38
1.02   2.05   3.15   4.28
1.54   1.99   1.77   2.00
1.76   1.79   2.28   3.18
1.11   3.41   2.20   3.21
1.32   2.32   4.32   4.78
1.22   1.81   1.51   3.15
1.11   2.15   2.45   6.17
1.01   2.12   1.96   2.08
1.34   1.74   2.16   3.28
;

proc calis data=sales;
   mstruct var=q1-q4;
   matrix _cov_ [1,1] = 4*sigma_sq;
run;

title "Sphericity Test for the Sales Data Using MSTRUCT: "
      "Equivalent Specification";
proc calis data=sales;
   mstruct var=q1-q4;
   matrix _cov_ [1,1] = sigma_sq,
                [2,2] = sigma_sq,
                [3,3] = sigma_sq,
                [4,4] = sigma_sq;
   fitindex on(only)=[chisq df probchi];
run;

data frets(type=cov);
   input _type_ $ _name_ $ x1 x2;
   datalines;
cov   x1    91.481   66.875
cov   x2    66.875   96.775
n      .      25      25
;
title "Sphericity Test verification: Mardia, Kent, and Bibby - "
      "Multivariate Analysis p.134";
proc calis data=frets vardef=n;
   mstruct var=x1-x2;
   matrix _cov_ [1,1] = 2*sigma_sq;
   fitindex on(only)=[chisq df probchi];
run;



/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CALEX106                                            */
/*   TITLE: Documentation Example 5 for PROC CALIS              */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: COVPATTERN=                                         */
/*   PROCS: CALIS                                               */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: yiyung                UPDATE: October 15, 2010      */
/*     REF: PROC CALIS, Example 5                               */
/*    MISC:                                                     */
/****************************************************************/

data sales;
   input q1 q2 q3 q4;
   datalines;
1.03   1.54   1.11   2.22
1.23   1.43   1.65   2.12
3.24   2.21   2.31   5.15
1.23   2.35   2.21   7.17
 .98   2.13   1.76   2.38
1.02   2.05   3.15   4.28
1.54   1.99   1.77   2.00
1.76   1.79   2.28   3.18
1.11   3.41   2.20   3.21
1.32   2.32   4.32   4.78
1.22   1.81   1.51   3.15
1.11   2.15   2.45   6.17
1.01   2.12   1.96   2.08
1.34   1.74   2.16   3.28
;

proc calis data=sales covpattern=diag;
run;

proc calis data=sales covpattern=diag chicorrect=0;
run;

proc calis data=sales covpattern=sigsqi;
run;

proc calis data=sales covpattern=sigsqi chicorrect=0;
run;



/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CALEX111                                            */
/*   TITLE: Documentation Example 6 for PROC CALIS              */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: LINEQS, PATH, regression                            */
/*   PROCS: CALIS                                               */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: yiyung                UPDATE: October 13, 2009      */
/*     REF: PROC CALIS, Example 6                               */
/*    MISC:                                                     */
/****************************************************************/

data sales;
   input q1 q2 q3 q4;
   datalines;
1.03   1.54   1.11   2.22
1.23   1.43   1.65   2.12
3.24   2.21   2.31   5.15
1.23   2.35   2.21   7.17
 .98   2.13   1.76   2.38
1.02   2.05   3.15   4.28
1.54   1.99   1.77   2.00
1.76   1.79   2.28   3.18
1.11   3.41   2.20   3.21
1.32   2.32   4.32   4.78
1.22   1.81   1.51   3.15
1.11   2.15   2.45   6.17
1.01   2.12   1.96   2.08
1.34   1.74   2.16   3.28
;

proc calis data=sales;
   path   q1  ===>  q4;
run;

proc reg data=sales;
   model q4 = q1;
run;

proc calis data=sales meanstr;
   path   q1  ===>  q4;
run;



/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CALEX202                                            */
/*   TITLE: Documentation Example 8 for PROC CALIS              */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: PATH, measurement error models                      */
/*   PROCS: CALIS                                               */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: yiyung                UPDATE: November 4, 2009      */
/*     REF: PROC CALIS, Example 8                               */
/*    MISC:                                                     */
/****************************************************************/

data measures;
   input x y @@;
   datalines;
 7.91736    13.8673    6.10807    11.7966    6.94139    12.2174
 7.61290    12.9761    6.77190    11.6356    6.33328    11.7732
 7.60608    12.8040    6.65642    12.8866    6.26643    11.9382
 7.32266    13.2590    5.76977    10.7654    5.62881    11.5041
 7.57418    13.2502    7.17305    13.3416    8.23123    13.9876
 7.17199    13.1750    8.04604    14.5968    5.77692    11.5077
 5.72741    11.3299    6.66033    12.5159    7.14944    12.4988
 7.51832    12.3588    5.48877    11.2211    7.50323    13.3735
 7.15814    13.1556    7.35485    13.8457    8.91648    14.4929
 5.37445     9.6366    6.00419    11.7654    6.89546    13.1493
;

proc calis data=measures;
   path
      x ===> y;
run;

proc reg data=measures;
   model y = x;
run;

proc calis data=measures meanstr;
   path
      x ===> y;
   pvar
      x y;
run;

proc calis data=measures;
   path
      x  <=== Fx   = 1.,
      Fx ===> y;
   pvar
      x  = 0.019,
      Fx, y;
run;

proc calis data=measures;
   path
      x  <=== Fx  = 1.,
      Fx ===> Fy   ,
      Fy ===> y   = 1.;
   pvar
      x  = 0.019,
      y  = 0.022,
      Fx Fy;
run;

proc calis data=measures;
   path
      x  <=== Fx  = 1.,
      Fx ===> Fy   ,
      Fy ===> y   = 1.;
   pvar
      x  = 0.,
      y  = 0.,
      Fx Fy;
run;



/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CALEX203                                            */
/*   TITLE: Documentation Example 9 for PROC CALIS              */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: PATH, testing measurement models                    */
/*   PROCS: CALIS                                               */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: yiyung                UPDATE: November 5, 2009      */
/*     REF: PROC CALIS, Example 9                               */
/*    MISC:                                                     */
/****************************************************************/

data measures;
   input x y;
   datalines;
 7.91736    13.8673
 7.61290    12.9761
 7.60608    12.8040
 7.32266    13.2590
 7.57418    13.2502
 7.17199    13.1750
 5.72741    11.3299
 7.51832    12.3588
 7.15814    13.1556
 5.37445     9.6366
 6.10807    11.7966
 6.77190    11.6356
 6.65642    12.8866
 5.76977    10.7654
 7.17305    13.3416
 8.04604    14.5968
 6.66033    12.5159
 5.48877    11.2211
 7.35485    13.8457
 6.00419    11.7654
 6.94139    12.2174
 6.33328    11.7732
 6.26643    11.9382
 5.62881    11.5041
 8.23123    13.9876
 5.77692    11.5077
 7.14944    12.4988
 7.50323    13.3735
 8.91648    14.4929
 6.89546    13.1493
;

proc calis data=measures;
   path
      x  <=== Fx  = 1.,
      Fx ===> Fy   ,
      Fy ===> y   = 1.;
   pvar
      x  = evar,
      y  = evar,
      Fy = 0.,
      Fx;
run;

proc calis data=measures;
   path
      x  <=== Fx  = 1.,
      Fx ===> Fy  = 1.,  /* Testing a fixed constant effect */
      Fy ===> y   = 1.;
   pvar
      x  = evar,
      y  = evar,
      Fy = 0.,
      Fx;
run;

proc calis data=measures;
   path
      x  <=== Fx  = 1.,
      Fx ===> Fy  ,       /* regression effect is freely estimated */
      Fy ===> y   = 1.;
   pvar
      x  = evar,
      y  = evar,
      Fy = 0.,
      Fx;
   mean
      x y = 0. 0., /* Intercepts are zero in the measurement error model */
      Fy  = 0.,    /* Fixed to zero under the hypothesis */
      Fx;          /* Mean of Fx is freely estimated */
run;

proc calis data=measures;
   path
      x  <=== Fx  = 1.,
      Fx ===> Fy  ,
      Fy ===> y   = 1.;
   pvar
      x  = evar,
      y  = evar,
      Fy = 0.,
      Fx;
   mean
      x y = 0. 0.,
      Fy Fx;
run;



/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CALEX204                                            */
/*   TITLE: Documentation Example 10 for PROC CALIS             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: PATH, measurement error models, multiple predictors */
/*   PROCS: CALIS                                               */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: yiyung                UPDATE: November 5, 2009      */
/*     REF: PROC CALIS, Example 10                              */
/*    MISC:                                                     */
/****************************************************************/

data pg214(type=cov);
   input _type_ $ 1-4  _name_ $ 6-8 @10 y x1 x2 x3;
   datalines;
mean     1.1349 1.5070 1.9214 3.5020
cov  y   1.2129 1.2059 0.2465 4.3714
cov  x1  1.2059 1.2706 0.1633 4.4813
cov  x2  0.2465 0.1633 1.1227 0.6250
cov  x3  4.3714 4.4813 0.6250 16.6909
;

/* Path Model */
title2 'Wayne Fuller''s Original Measurement Error Model: Page 214-215';
proc calis data=pg214 method=ml nobs=43;
   path
      Fy  <===   F1 F2 F3,
      F1  ===>   x1   = 1.,
      F2  ===>   x2   = 1.,
      F3  ===>   x3   = 1.,
      Fy  ===>   y    = 1.;
   pvar
      x1-x3 y = .01 .01 .1403 .01;
   pcov
      x1 x3 = 0.0301;
   mean
      x1-x3 y = 4 * 0.,
      F1-F3 Fy;
run;

/* Lineqs Model */
proc calis data=pg214 method=ml nobs=43;
   lineqs
      Fy = alpha * Intercept + b1 * F1 + b2 * F2 + b3 * F3 + DFy,
      x1 = 0. * Intercept + 1 * F1 + e1,
      x2 = 0. * Intercept + 1 * F2 + e2,
      x3 = 0. * Intercept + 1 * F3 + e3,
       y = 0. * Intercept + 1 * Fy + ey;
    variance
       e1-e3 ey = .01 .01 .1403 .01;
    cov
       e1 e3 = 0.0301;
    mean
       F1-F3;
run;

data multiple(type=cov);
   input _type_ $ 1-4  _name_ $ 6-8 @10 y x1 x2 x3;
   datalines;
mean     0.93   1.33   1.34   4.11
cov  y   1.31    .      .      .
cov  x1  1.24   1.42    .      .
cov  x2  0.21   0.18   1.15    .
cov  x3  3.91   4.21   0.58  14.11
;

proc calis data=multiple nobs=37;
   path
      Fy  <===   F1 F2 F3,
      F1  ===>   x1   = 1.,
      F2  ===>   x2   = 1.,
      F3  ===>   x3   = 1.,
      Fy  ===>   y    = 1.;
   pvar
      x1 x2 x3 y = .02 .03 .15 .02,
      Fy;
run;

proc calis data=multiple nobs=37;
   path
      Fy  <===   F1 F2 F3,
      F1  ===>   x1   = 1.,
      F2  ===>   x2   = 1.,
      F3  ===>   x3   = 1.,
      Fy  ===>   y    = 1.;
   pvar
      x1 x2 x3 y = .02 .03 .15 .02,
      Fy;
   pcov
      x1 x2 = 0.01;
run;

	

/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CALEX112                                            */
/*   TITLE: Documentation Example 12 for PROC CALIS             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: FACTOR, confirmatory factor models                  */
/*   PROCS: CALIS                                               */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: yiyung                UPDATE: October 29, 2009      */
/*     REF: PROC CALIS, Example 12                              */
/*    MISC:                                                     */
/****************************************************************/

data scores;
   input x1 x2 x3 y1 y2 y3;
   datalines;
 23  17  16  15  14  16
 29  26  23  22  18  19
 14  21  17  15  16  18
 20  18  17  18  21  19
 25  26  22  26  21  26
 26  19  15  16  17  17
 14  17  19   4   6   7
 12  17  18  14  16  13
 25  19  22  22  20  20
  7  12  15  10  11   8
 29  24  30  14  13  16
 28  24  29  19  19  21
 12   9  10  18  19  18
 11   8  12  15  16  16
 20  14  15  24  23  16
 26  25  21  24  23  24
 20  16  19  22  21  20
 14  19  15  17  19  23
 14  20  13  24  26  25
 29  24  24  21  20  18
 26  28  26  28  26  23
 20  23  24  22  23  22
 23  24  20  23  22  18
 14  18  17  13  16  14
 28  34  27  25  21  21
 17  12  10  14  12  16
  8   1  13  14  15  14
 22  19  19  13  11  14
 18  21  18  15  18  19
 12  12  10  13  13  16
 22  14  20  20  18  19
 29  21  22  13  17  12
;

proc calis data=scores;
   factor
      verbal ===> x1-x3,
      math   ===> y1-y3;
   pvar
      verbal = 1.,
      math   = 1.;
run;

title "Basic Confirmatory Factor Model: Separate Path Entries";
title2 "FACTOR Model Specification";
proc calis data=scores;
   factor
      verbal ===> x1,
      verbal ===> x2,
      verbal ===> x3,
      math   ===> y1,
      math   ===> y2,
      math   ===> y3;
   pvar
      verbal = 1.,
      math   = 1.;
   fitindex  noindextype on(only)=[chisq df probchi rmsea  srmr bentlercfi];
run;

ods graphics on;
proc calis data=scores plots=pathdiagram;
   factor
      verbal ===> x1-x3   = 1. ,
      math   ===> y1-y3   = 1. ;
run;
ods graphics off;



/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CALEX115                                            */
/*   TITLE: Documentation Example 13 for PROC CALIS             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: FACTOR, confirmatory factor models                  */
/*   PROCS: CALIS                                               */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: yiyung                UPDATE: November 8, 2009      */
/*     REF: PROC CALIS, Example 13                              */
/*    MISC:                                                     */
/****************************************************************/

data scores;
   input x1 x2 x3 y1 y2 y3;
   datalines;
 23  17  16  15  14  16
 29  26  23  22  18  19
 14  21  17  15  16  18
 20  18  17  18  21  19
 25  26  22  26  21  26
 26  19  15  16  17  17
 14  17  19   4   6   7
 12  17  18  14  16  13
 25  19  22  22  20  20
  7  12  15  10  11   8
 29  24  30  14  13  16
 28  24  29  19  19  21
 12   9  10  18  19  18
 11   8  12  15  16  16
 20  14  15  24  23  16
 26  25  21  24  23  24
 20  16  19  22  21  20
 14  19  15  17  19  23
 14  20  13  24  26  25
 29  24  24  21  20  18
 26  28  26  28  26  23
 20  23  24  22  23  22
 23  24  20  23  22  18
 14  18  17  13  16  14
 28  34  27  25  21  21
 17  12  10  14  12  16
  8   1  13  14  15  14
 22  19  19  13  11  14
 18  21  18  15  18  19
 12  12  10  13  13  16
 22  14  20  20  18  19
 29  21  22  13  17  12
;

proc calis data=scores;
   factor
      verbal ===> x1-x3   = load1 load1 load1,
      math   ===> y1-y3   = load2 load2 load2;
   pvar
      verbal = 1.,
      math   = 1.,
      x1-x3  = 3*evar1,
      y1-y3  = 3*evar2;
run;

proc calis data=scores;
   factor
      verbal ===> x1-x3   = load1 load1 load1,
      math   ===> y1-y3   = load2 load2 load2;
   pvar
      verbal = 1.,
      math   = 1.;
run;

proc calis data=scores;
   factor
      verbal ===> x1-x3   = load1 load1 alpha,
      math   ===> y1-y3   = beta  load2 load2;
   pvar
      verbal = 1.,
      math   = 1.,
      x1-x3  = evar1  evar1  phi,
      y1-y3  = theta  evar2  evar2;
run;



/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CALEX206                                            */
/*   TITLE: Documentation Example 14 for PROC CALIS             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: PATH, robust estimation                             */
/*   PROCS: CALIS                                               */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: yiyung                UPDATE: May 8, 2012           */
/*     REF: PROC CALIS, Example 14                              */
/*    MISC:                                                     */
/****************************************************************/

data mardia;
   input mechanics vector algebra analysis statistics;
   datalines;
     77.000     82.000     67.000     67.000     81.000
     63.000     78.000     80.000     70.000     81.000
     75.000     73.000     71.000     66.000     81.000
     55.000     72.000     63.000     70.000     68.000
     63.000     63.000     65.000     70.000     63.000
     53.000     61.000     72.000     64.000     73.000
     51.000     67.000     65.000     65.000     68.000
     59.000     70.000     68.000     62.000     56.000
     62.000     60.000     58.000     62.000     70.000
     64.000     72.000     60.000     62.000     45.000
     52.000     64.000     60.000     63.000     54.000
     55.000     67.000     59.000     62.000     44.000
     50.000     50.000     64.000     55.000     63.000
     65.000     63.000     58.000     56.000     37.000
     31.000     55.000     60.000     57.000     73.000
     60.000     64.000     56.000     54.000     40.000
     44.000     69.000     53.000     53.000     53.000
     42.000     69.000     61.000     55.000     45.000
     62.000     46.000     61.000     57.000     45.000
     31.000     49.000     62.000     63.000     62.000
     44.000     61.000     52.000     62.000     46.000
     49.000     41.000     61.000     49.000     64.000
     12.000     58.000     61.000     63.000     67.000
     49.000     53.000     49.000     62.000     47.000
     54.000     49.000     56.000     47.000     53.000
     54.000     53.000     46.000     59.000     44.000
     44.000     56.000     55.000     61.000     36.000
     18.000     44.000     50.000     57.000     81.000
     46.000     52.000     65.000     50.000     35.000
     32.000     45.000     49.000     57.000     64.000
     30.000     69.000     50.000     52.000     45.000
     46.000     49.000     53.000     59.000     37.000
     40.000     27.000     54.000     61.000     61.000
     31.000     42.000     48.000     54.000     68.000
     36.000     59.000     51.000     45.000     51.000
     56.000     40.000     56.000     54.000     35.000
     46.000     56.000     57.000     49.000     32.000
     45.000     42.000     55.000     56.000     40.000
     42.000     60.000     54.000     49.000     33.000
     40.000     63.000     53.000     54.000     25.000
     23.000     55.000     59.000     53.000     44.000
     48.000     48.000     49.000     51.000     37.000
     41.000     63.000     49.000     46.000     34.000
     46.000     52.000     53.000     41.000     40.000
     46.000     61.000     46.000     38.000     41.000
     40.000     57.000     51.000     52.000     31.000
     49.000     49.000     45.000     48.000     39.000
     22.000     58.000     53.000     56.000     41.000
     35.000     60.000     47.000     54.000     33.000
     48.000     56.000     49.000     42.000     32.000
     31.000     57.000     50.000     54.000     34.000
     17.000     53.000     57.000     43.000     51.000
     49.000     57.000     47.000     39.000     26.000
     59.000     50.000     47.000     15.000     46.000
     37.000     56.000     49.000     28.000     45.000
     40.000     43.000     48.000     21.000     61.000
     35.000     35.000     41.000     51.000     50.000
     38.000     44.000     54.000     47.000     24.000
     43.000     43.000     38.000     34.000     49.000
     39.000     46.000     46.000     32.000     43.000
     62.000     44.000     36.000     22.000     42.000
     48.000     38.000     41.000     44.000     33.000
     34.000     42.000     50.000     47.000     29.000
     18.000     51.000     40.000     56.000     30.000
     35.000     36.000     46.000     48.000     29.000
     59.000     53.000     37.000     22.000     19.000
     41.000     41.000     43.000     30.000     33.000
     31.000     52.000     37.000     27.000     40.000
     17.000     51.000     52.000     35.000     31.000
     34.000     30.000     50.000     47.000     36.000
     46.000     40.000     47.000     29.000     17.000
     10.000     46.000     36.000     47.000     39.000
     46.000     37.000     45.000     15.000     30.000
     30.000     34.000     43.000     46.000     18.000
     13.000     51.000     50.000     25.000     31.000
     49.000     50.000     38.000     23.000      9.000
     18.000     32.000     31.000     45.000     40.000
      8.000     42.000     48.000     26.000     40.000
     23.000     38.000     36.000     48.000     15.000
     30.000     24.000     43.000     33.000     25.000
      3.000      9.000     51.000     47.000     40.000
      7.000     51.000     43.000     17.000     22.000
     15.000     40.000     43.000     23.000     18.000
     15.000     38.000     39.000     28.000     17.000
      5.000     30.000     44.000     36.000     18.000
     12.000     30.000     32.000     35.000     21.000
      5.000     26.000     15.000     20.000     20.000
      0.000     40.000     21.000      9.000     14.000
;

ods graphics on;

proc calis data=mardia residual plots=caseresid;
   path
      fact1 ===>  mechanics vector algebra analysis statistics = 1. ;
run;



proc calis data=mardia residual robust plots=caseresid pcorr;
   path
      fact1 ===>  mechanics vector algebra analysis statistics = 1. ;
run;

ods graphics off;


proc calis data=mardia robust=sat pcorr;
   path
      fact1 ===>  mechanics vector algebra analysis statistics = 1. ;
run;



/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CALEX113                                            */
/*   TITLE: Documentation Example 15 for PROC CALIS             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: FACTOR, missing data, full information ML           */
/*   PROCS: CALIS                                               */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: yiyung                UPDATE: October 29, 2009      */
/*     REF: PROC CALIS, Example 15                              */
/*    MISC:                                                     */
/****************************************************************/

data missing;
   input x1 x2 x3 y1 y2 y3;
   datalines;
 23   .  16  15  14  16
 29  26  23  22  18  19
 14  21   .  15  16  18
 20  18  17  18  21  19
 25  26  22   .  21  26
 26  19  15  16  17  17
  .  17  19   4   6   7
 12  17  18  14  16   .
 25  19  22  22  20  20
  7  12  15  10  11   8
 29  24   .  14  13  16
 28  24  29  19  19  21
 12   9  10  18  19   .
 11   .  12  15  16  16
 20  14  15  24  23  16
 26  25   .  24  23  24
 20  16  19  22  21  20
 14   .  15  17  19  23
 14  20  13  24   .   .
 29  24  24  21  20  18
 26   .  26  28  26  23
 20  23  24  22  23  22
 23  24  20  23  22  18
 14   .  17   .  16  14
 28  34  27  25  21  21
 17  12  10  14  12  16
  .   1  13  14  15  14
 22  19  19  13  11  14
 18  21   .  15  18  19
 12  12  10  13  13  16
 22  14  20  20  18  19
 29  21  22  13  17   .
;

proc calis data=missing;
   factor
      verbal ===> x1-x3,
      math   ===> y1-y3;
   pvar
      verbal = 1.,
      math   = 1.;
run;

proc calis method=fiml data=missing;
   factor
      verbal ===> x1-x3,
      math   ===> y1-y3;
   pvar
      verbal = 1.,
      math   = 1.;
run;



/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CALEX114                                            */
/*   TITLE: Documentation Example 16 for PROC CALIS             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: FACTOR, missing data, ML and FIML                   */
/*   PROCS: CALIS                                               */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: yiyung                UPDATE: October 29, 2009      */
/*     REF: PROC CALIS, Example 16                              */
/*    MISC:                                                     */
/****************************************************************/

data scores;
   input x1 x2 x3 y1 y2 y3;
   datalines;
 23  17  16  15  14  16
 29  26  23  22  18  19
 14  21  17  15  16  18
 20  18  17  18  21  19
 25  26  22  26  21  26
 26  19  15  16  17  17
 14  17  19   4   6   7
 12  17  18  14  16  13
 25  19  22  22  20  20
  7  12  15  10  11   8
 29  24  30  14  13  16
 28  24  29  19  19  21
 12   9  10  18  19  18
 11   8  12  15  16  16
 20  14  15  24  23  16
 26  25  21  24  23  24
 20  16  19  22  21  20
 14  19  15  17  19  23
 14  20  13  24  26  25
 29  24  24  21  20  18
 26  28  26  28  26  23
 20  23  24  22  23  22
 23  24  20  23  22  18
 14  18  17  13  16  14
 28  34  27  25  21  21
 17  12  10  14  12  16
  8   1  13  14  15  14
 22  19  19  13  11  14
 18  21  18  15  18  19
 12  12  10  13  13  16
 22  14  20  20  18  19
 29  21  22  13  17  12
;

proc calis method=fiml data=scores;
   factor
      verbal ===> x1-x3,
      math   ===> y1-y3;
   pvar
      verbal = 1.,
      math   = 1.;
run;

proc calis method=ml meanstr vardef=n data=scores;
   factor
      verbal ===> x1-x3,
      math   ===> y1-y3;
   pvar
      verbal = 1.,
      math   = 1.;
run;



/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CALEX01                                             */
/*   TITLE: Documentation Example 17 for PROC CALIS             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: path model, stability of alienation                 */
/*   PROCS: CALIS                                               */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: yiyung                UPDATE: August 27, 2007       */
/*     REF: PROC CALIS, Example 17                              */
/*    MISC:                                                     */
/****************************************************************/

title "Stability of Alienation";
title2 "Data Matrix of WHEATON, MUTHEN, ALWIN & SUMMERS (1977)";
data Wheaton(TYPE=COV);
   _type_ = 'cov';
   input _name_ $ 1-11 Anomie67 Powerless67 Anomie71 Powerless71
                       Education SEI;
   label Anomie67='Anomie (1967)' Powerless67='Powerlessness (1967)'
         Anomie71='Anomie (1971)' Powerless71='Powerlessness (1971)'
         Education='Education'    SEI='Occupational Status Index';
   datalines;
Anomie67       11.834     .        .        .       .        .
Powerless67     6.947    9.364     .        .       .        .
Anomie71        6.819    5.091   12.532     .       .        .
Powerless71     4.783    5.028    7.495    9.986    .        .
Education      -3.839   -3.889   -3.841   -3.625   9.610     .
SEI           -21.899  -18.831  -21.748  -18.775  35.522  450.288
;

ods graphics on;

proc calis nobs=932 data=Wheaton plots=residuals;
   path
      Anomie67   Powerless67  <===  Alien67   = 1.0  0.833,
      Anomie71   Powerless71  <===  Alien71   = 1.0  0.833,
      Education  SEI          <===  SES       = 1.0  lambda,
      Alien67    Alien71      <===  SES       = gamma1 gamma2,
      Alien71                 <===  Alien67   = beta;
   pvar
      Anomie67     = theta1,
      Powerless67  = theta2,
      Anomie71     = theta1,
      Powerless71  = theta2,
      Education    = theta3,
      SEI          = theta4,
      Alien67      = psi1,
      Alien71      = psi2,
      SES          = phi;
   pcov
      Anomie67    Anomie71    = theta5,
      Powerless67 Powerless71 = theta5;
   pathdiagram title='Stability of Alienation';
run;

ods graphics off;



/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CALEX02                                             */
/*   TITLE: Documentation Example 18 for PROC CALIS             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: structural equations, reciprocal effects            */
/*   PROCS: CALIS                                               */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: yiyung                UPDATE: August 27, 2007       */
/*     REF: PROC CALIS, Example 18                              */
/*    MISC:                                                     */
/****************************************************************/

title 'Food example of KMENTA(1971, p.565 & 582)';
data food;
   input Q P D F Y;
   label  Q='Food Consumption per Head'
          P='Ratio of Food Prices to General Price'
          D='Disposable Income in Constant Prices'
          F='Ratio of Preceding Years Prices'
          Y='Time in Years 1922-1941';
   datalines;
  98.485  100.323   87.4   98.0   1
  99.187  104.264   97.6   99.1   2
 102.163  103.435   96.7   99.1   3
 101.504  104.506   98.2   98.1   4
 104.240   98.001   99.8  110.8   5
 103.243   99.456  100.5  108.2   6
 103.993  101.066  103.2  105.6   7
  99.900  104.763  107.8  109.8   8
 100.350   96.446   96.6  108.7   9
 102.820   91.228   88.9  100.6  10
  95.435   93.085   75.1   81.0  11
  92.424   98.801   76.9   68.6  12
  94.535  102.908   84.6   70.9  13
  98.757   98.756   90.6   81.4  14
 105.797   95.119  103.1  102.3  15
 100.225   98.451  105.1  105.0  16
 103.522   86.498   96.4  110.5  17
  99.929  104.016  104.4   92.5  18
 105.223  105.769  110.7   89.3  19
 106.232  113.490  127.1   93.0  20
;

proc calis data=food pshort nostand;
   lineqs
      Q = alpha1 * Intercept + beta1  * P  + gamma1 * D + E1,
      P = theta1 * Intercept + theta2 * Q  + theta3 * F + theta4 * Y + E2;
   variance
      E1-E2 = eps1-eps2;
   cov
      E1-E2 = eps3;
   bounds
      eps1-eps2 >= 0. ;
run;

proc calis data=Food pshort nostand;
   lineqs
      Q = alpha1 * Intercept + beta1  * P  + gamma1 * D + E1,
      P = theta1 * Intercept + theta2 * Q  + theta3 * F + theta4 * Y + E2;
   variance
      E1-E2 = eps1-eps2;
   cov
      E1-E2 = eps3;
   bounds
      eps1-eps2 >= 0. ;
   parameters alpha2 (50.) beta2 gamma2 gamma3 (3*.25);
      theta1  = -alpha2 / beta2;
      theta2  = 1 / beta2;
      theta3  = -gamma2 / beta2;
      theta4  = -gamma3 / beta2;
run;

proc calis data=food pshort nostand;
   lineqs
      Q =  * Intercept +  *  P  +  * D        + E1,
      P =  * Intercept +  *  Q  +  * F +  * Y + E2;
   variance
      E1-E2 = eps1-eps2;
   cov
      E1 E2;
   bounds
      eps1-eps2 >= 0. ;
run;



/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CALEX03                                             */
/*   TITLE: Documentation Example 19 for PROC CALIS             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: MSTRUCT, direct covariance structure analysis       */
/*   PROCS: CALIS                                               */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: yiyung                UPDATE: August 27, 2007       */
/*     REF: PROC CALIS, Example 19                              */
/*    MISC:                                                     */
/****************************************************************/

data Wheaton(TYPE=COV);
   _type_ = 'cov';
   input _name_ $ 1-11 Anomie67 Powerless67 Anomie71 Powerless71
                       Education SEI;
   label Anomie67='Anomie (1967)' Powerless67='Powerlessness (1967)'
         Anomie71='Anomie (1971)' Powerless71='Powerlessness (1971)'
         Education='Education'    SEI='Occupational Status Index';
   datalines;
Anomie67       11.834     .        .        .       .        .
Powerless67     6.947    9.364     .        .       .        .
Anomie71        6.819    5.091   12.532     .       .        .
Powerless71     4.783    5.028    7.495    9.986    .        .
Education      -3.839   -3.889   -3.841   -3.625   9.610     .
SEI           -21.899  -18.831  -21.748  -18.775  35.522  450.288
;

proc calis nobs=932 data=Wheaton psummary;
   fitindex on(only)=[chisq df probchi] outfit=savefit;
   mstruct
      var = Anomie67 Powerless67 Anomie71 Powerless71;
   matrix _COV_ [1,1] = phi1,
                [2,2] = phi2,
                [3,3] = phi1,
                [4,4] = phi2,
                [2,1] = theta1,
                [3,1] = theta2,
                [3,2] = theta1,
                [4,1] = theta1,
                [4,2] = theta3,
                [4,3] = theta1;
run;

proc print data=savefit;
run;

proc calis nobs=932 data=Wheaton psummary;
   mstruct
      var = Anomie67 Powerless67 Anomie71 Powerless71;
   matrix _COV_ [1,1] = phi1 phi2 phi1 phi2,
                [2, ] = theta1,
                [3, ] = theta2 theta1,
                [4, ] = theta1 theta3 theta1;
   fitindex on(only)=[chisq df probchi];
run;



/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CALEX04                                             */
/*   TITLE: Documentation Example 20 for PROC CALIS             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: confirmatory factor model, cognitive abilities      */
/*   PROCS: CALIS                                               */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: yiyung                UPDATE: August 27, 2007       */
/*     REF: PROC CALIS, Example 20                              */
/*    MISC:                                                     */
/****************************************************************/

title "Confirmatory Factor Analysis Using the FACTOR Modeling Language";
title2 "Cognitive Data";
data cognitive1(type=cov);
   _type_='cov';
   input _name_ $ reading1 reading2 reading3 math1 math2 math3
         writing1 writing2 writing3;
   datalines;
reading1 83.024    .      .      .      .      .      .      .      .
reading2 50.924 108.243   .      .      .      .      .      .      .
reading3 62.205  72.050 99.341   .      .      .      .      .      .
math1    22.522  22.474 25.731 82.214   .      .      .      .      .
math2    14.157  22.487 18.334 64.423 96.125   .      .      .      .
math3    22.252  20.645 23.214 49.287 58.177 88.625   .      .      .
writing1 33.433  42.474 41.731 25.318 14.254 27.370 90.734   .      .
writing2 24.147  20.487 18.034 22.106 26.105 22.346 53.891 96.543   .
writing3 13.340  20.645 23.314 19.387 28.177 38.635 55.347 52.999 98.445
;

proc calis data=cognitive1 nobs=64 modification;
   factor
      Read_Factor   ===> reading1-reading3 ,
      Math_Factor   ===> math1-math3       ,
      Write_Factor  ===> writing1-writing3 ;
   pvar
      Read_Factor Math_Factor Write_Factor = 3 * 1.;
   cov
      Read_Factor Math_Factor Write_Factor = 3 * 0.;
run;

proc calis data=cognitive1 nobs=64 modification;
   factor
      Read_Factor   ===> reading1-reading3 ,
      Math_Factor   ===> math1-math3       ,
      Write_Factor  ===> writing1-writing3 ;
   pvar
      Read_Factor Math_Factor Write_Factor = 3 * 1.;
   cov
      Read_Factor Math_Factor Write_Factor /* = 3 * 0. */;
run;



/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CALEX05                                             */
/*   TITLE: Documentation Example 21 for PROC CALIS             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: equality of covariance matrices                     */
/*   PROCS: CALIS                                               */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: yiyung                UPDATE: August 27, 2007       */
/*     REF: PROC CALIS, Example 21                              */
/*    MISC:                                                     */
/****************************************************************/

data expert(type=cov);
   input _type_ $ _name_ $ high medium low;
   datalines;
COV   high    5.88     .      .
COV   medium  2.88    7.16    .
COV   low     3.12    4.44   8.14
;

data novice(type=cov);
   input _type_ $ _name_ $ high medium low;
   datalines;
COV   high    6.42     .      .
COV   medium  1.24    8.25    .
COV   low     4.26    2.75   7.99
;

proc calis;
   group 1 / data=expert nobs=20 label="Expert";
   group 2 / data=novice nobs=18 label="Novice";
   model 1 / groups=1,2;
      mstruct
         var=high medium low;
   fitindex NoIndexType On(only)=[chisq df probchi]
            chicorrect=eqcovmat;
   ods select ModelingInfo MSTRUCTVariables MSTRUCTCovInit Fit;
run;

proc calis covpattern=eqcovmat;
   var high medium low;
   group 1 / data=expert nobs=20 label="Expert";
   group 2 / data=novice nobs=18 label="Novice";
   fitindex NoIndexType On(only)=[chisq df probchi];
run;



/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CALEX13                                             */
/*   TITLE: Documentation Example 22 for PROC CALIS             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: equality of covariance and mean matrices            */
/*   PROCS: CALIS                                               */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: yiyung                UPDATE: October 11, 2010      */
/*     REF: PROC CALIS, Example 22                              */
/*    MISC:                                                     */
/****************************************************************/

data g1(type=corr);
   Input _type_ $ 1-8 _name_ $ 9-11 x1-x9;
   datalines;
corr    x1  1.     .       .      .      .      .      .      .       .
corr    x2 .721    1.      .      .      .      .      .      .       .
corr    x3 .676   .379     1.     .      .      .      .      .       .
corr    x4 .149   .403    .450    1.     .      .      .      .       .
corr    x5 .422   .384    .445   .411    1.     .      .      .       .
corr    x6 .343   .456    .243   .308   .531    1.     .      .       .
corr    x7 .115   .225    .201   .481   .373   .198   1.      .       .
corr    x8 .213   .237    .434   .503   .267   .333   .355   1.       .
corr    x9 .236   .257    .159   .246   .126   .235   .601   .512    1.
mean     . 21.3   22.3    17.2   23.4   22.1   15.6   18.7   20.1  19.7
std      .  1.2    1.4    .87    1.33    2.2    1.4    2.3    2.1   1.8
n        .   21     21      21     21     21     21     21     21    21
;

data g2(type=corr);
   Input _type_ $ 1-8 _name_ $ 9-11 x1-x9;
   datalines;
corr    x1  1.     .       .      .      .      .      .      .       .
corr    x2 .733    1.      .      .      .      .      .      .       .
corr    x3 .576   .388     1.     .      .      .      .      .       .
corr    x4 .209   .414    .425    1.     .      .      .      .       .
corr    x5 .412   .286    .461   .398    1.     .      .      .       .
corr    x6 .323   .399    .212   .302   .522    1.     .      .       .
corr    x7 .215   .295    .188   .467   .334   .232   1.      .       .
corr    x8 .204   .257    .462   .522   .298   .355  .372    1.       .
corr    x9 .245   .272    .177   .301   .156   .246  .578   .422     1.
mean     . 22.1   19.8    16.9   23.3   21.9   17.3   17.9   19.1  19.8
std      .  1.3    1.3    .99    1.25    2.1    1.3    2.2    2.0   1.5
n        .   22     22      22     22     22     22     22     22    22
;

data g3(type=corr);
   Input _type_ $ 1-8 _name_ $ 9-11 x1-x9;
   datalines;
corr    x1  1.     .       .      .      .      .      .      .       .
corr    x2 .699    1.      .      .      .      .      .      .       .
corr    x3 .488   .328     1.     .      .      .      .      .       .
corr    x4 .235   .398    .413    1.     .      .      .      .       .
corr    x5 .377   .265    .471   .376    1.     .      .      .       .
corr    x6 .335   .412    .265   .314   .503    1.     .      .       .
corr    x7 .243   .216    .192   .423   .369   .212   1.      .       .
corr    x8 .217   .292    .423   .525   .219   .317  .376    1.       .
corr    x9 .211   .283    .152   .285   .147   .135  .633   .579     1.
mean     . 22.2   20.9    15.4   25.1   22.6   16.3   19.3   20.2  19.5
std      .  1.5    1.0    1.04    1.5    1.9    1.6    2.4    2.2   1.6
n        .   20     20      20     20     20     20     20     20    20
;

proc calis covpattern=eqcovmat meanpattern=eqmeanvec modification;
   var x1-x9;
   group 1 / data=g1;
   group 2 / data=g2;
   group 3 / data=g3;
   fitindex NoIndexType On(only)=[chisq df probchi rmsea aic caic sbc];
run;

proc calis covpattern=eqcovmat meanpattern=saturated;
   var x1-x9;
   group 1 / data=g1;
   group 2 / data=g2;
   group 3 / data=g3;
   fitindex NoIndexType On(only)=[chisq df probchi rmsea aic caic sbc];
run;

proc template;
   define table LagrangeEquality;
      notes "Lagrange Tests for Releasing Equality Constraints For CALIS DOC";
      col_space_min=1 contents_label="Equality Constraints";
      header h1 h2 h3;

      define header h1;
         text "Lagrange Multiplier Statistics "
              "for Releasing Equality Constraints";
         space=1 spill_margin;
         end;

      column Parameter ModelNum RelParmType Var1 Var2 LMStat PVal
             ParmChange RelParmChange;

      define Parameter;
         header="Parm" id width=9 style=RowHeader blank_dups=on;
         translate _val_ = ._ into '.';
         end;

      define ModelNum;
         header=";;Model" id format=best5. style=RowHeader;
         translate _val_ = ._ into '';
         end;

      define RelParmType;
         header="Type" id width=4 style=RowHeader;
         translate _val_ = ._ into '.';
         end;

      define Var1;
         id width=4 style=RowHeader;
         translate _val_ = ._ into '.';
         end;

      define Var2;
         id width=4 style=RowHeader;
         translate _val_ = ._ into '.';
         end;

      define header h2;
         text "Released Parameter";
         start=ModelNum end=Var2 expand='-';
         end;

      define LMStat;
         parent=Stat.Calis.ChiSq;
         header="LM Stat";
         translate _val_ = ._ into '';
         end;

      define PVal;
         parent=Stat.Calis.ProbChiSq;
         translate _val_ = ._ into '';
         end;

      define ParmChange;
         header=";Original;Parm" format=D8.;
         translate _val_ = ._ into '';
         end;

      define RelParmChange;
         header=";Released;Parm" format=D8.;
         translate _val_ = ._ into '';
         end;

      define header h3;
         text "Changes";
         start=ParmChange end=RelParmChange expand='-';
         end;
      end;

proc calis modification;
   var x1-x9;
   group 1 / data=g1;
   group 2 / data=g2;
   group 3 / data=g3;
   model 1 / group = 1;
      mstruct;
      matrix _cov_  = cov01-cov45;
      matrix _mean_ = mean1-mean9;
   model 2 / group = 2;
      refmodel 1;
   model 3 / group = 3;
      refmodel 1;
      renameparm mean3=mean3_mdl3;
   fitindex NoIndexType On(only)=[chisq df probchi rmsea aic caic sbc];
run;

proc calis modification;
   var x1-x9;
   group 1 / data=g1;
   group 2 / data=g2;
   group 3 / data=g3;
   model 1 / group = 1;
      mstruct;
      matrix _cov_  = cov01-cov45;
      matrix _mean_ = mean1-mean9;
   model 2 / group = 2;
      refmodel 1;
      renameparm mean2=mean2_new;    /* constraint a */
   model 3 / group = 3;
      refmodel 1;
      renameparm mean2=mean2_new,    /* constraint a */
                 mean3=mean3_mdl3;
   fitindex NoIndexType On(only)=[chisq df probchi rmsea aic caic sbc];
run;

proc calis modification;
   var x1-x9;
   group 1 / data=g1;
   group 2 / data=g2;
   group 3 / data=g3;
   model 1 / group = 1;
      mstruct;
      matrix _cov_  = cov01-cov45;
      matrix _mean_ = mean1-mean9;
   model 2 / group = 2;
      refmodel 1;
      renameparm mean2=mean2_new,     /* constraint a */
                 mean6=mean6_mdl2;
   model 3 / group = 3;
      refmodel 1;
      renameparm mean2=mean2_new,     /* constraint a */
                 mean3=mean3_mdl3;
   fitindex NoIndexType On(only)=[chisq df probchi rmsea aic caic sbc];
run;

proc calis modification;
   var x1-x9;
   group 1 / data=g1;
   group 2 / data=g2;
   group 3 / data=g3;
   model 1 / group = 1;
      mstruct;
      matrix _cov_  = cov01-cov45;
      matrix _mean_ = mean1-mean9;
   model 2 / group = 2;
      refmodel 1;
      renameparm mean2=mean2_new,     /* constraint a */
                 mean4=mean4_new,     /* constraint b */
                 mean6=mean6_mdl2;
   model 3 / group = 3;
      refmodel 1;
      renameparm mean2=mean2_new,     /* constraint a */
                 mean3=mean3_mdl3,
                 mean4=mean4_new;     /* constraint b */
   fitindex NoIndexType On(only)=[chisq df probchi rmsea aic caic sbc];
run;

proc calis modification;
   var x1-x9;
   group 1 / data=g1;
   group 2 / data=g2;
   group 3 / data=g3;
   model 1 / group = 1;
      mstruct;
      matrix _cov_  = cov01-cov45;
      matrix _mean_ = mean1-mean9;
   model 2 / group = 2;
      refmodel 1;
      renameparm mean1=mean1_new,     /* constraint c */
                 mean2=mean2_new,     /* constraint a */
                 mean4=mean4_new,     /* constraint b */
                 mean6=mean6_mdl2;
   model 3 / group = 3;
      refmodel 1;
      renameparm mean1=mean1_new,    /* constraint c */
                 mean2=mean2_new,    /* constraint a */
                 mean3=mean3_mdl3,
                 mean4=mean4_new;    /* constraint b */
   fitindex NoIndexType On(only)=[chisq df probchi rmsea aic caic sbc];
run;



/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CALEX13                                             */
/*   TITLE: Documentation Example 22 for PROC CALIS             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: equality of covariance and mean matrices            */
/*   PROCS: CALIS                                               */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: yiyung                UPDATE: October 11, 2010      */
/*     REF: PROC CALIS, Example 22                              */
/*    MISC:                                                     */
/****************************************************************/

data g1(type=corr);
   Input _type_ $ 1-8 _name_ $ 9-11 x1-x9;
   datalines;
corr    x1  1.     .       .      .      .      .      .      .       .
corr    x2 .721    1.      .      .      .      .      .      .       .
corr    x3 .676   .379     1.     .      .      .      .      .       .
corr    x4 .149   .403    .450    1.     .      .      .      .       .
corr    x5 .422   .384    .445   .411    1.     .      .      .       .
corr    x6 .343   .456    .243   .308   .531    1.     .      .       .
corr    x7 .115   .225    .201   .481   .373   .198   1.      .       .
corr    x8 .213   .237    .434   .503   .267   .333   .355   1.       .
corr    x9 .236   .257    .159   .246   .126   .235   .601   .512    1.
mean     . 21.3   22.3    17.2   23.4   22.1   15.6   18.7   20.1  19.7
std      .  1.2    1.4    .87    1.33    2.2    1.4    2.3    2.1   1.8
n        .   21     21      21     21     21     21     21     21    21
;

data g2(type=corr);
   Input _type_ $ 1-8 _name_ $ 9-11 x1-x9;
   datalines;
corr    x1  1.     .       .      .      .      .      .      .       .
corr    x2 .733    1.      .      .      .      .      .      .       .
corr    x3 .576   .388     1.     .      .      .      .      .       .
corr    x4 .209   .414    .425    1.     .      .      .      .       .
corr    x5 .412   .286    .461   .398    1.     .      .      .       .
corr    x6 .323   .399    .212   .302   .522    1.     .      .       .
corr    x7 .215   .295    .188   .467   .334   .232   1.      .       .
corr    x8 .204   .257    .462   .522   .298   .355  .372    1.       .
corr    x9 .245   .272    .177   .301   .156   .246  .578   .422     1.
mean     . 22.1   19.8    16.9   23.3   21.9   17.3   17.9   19.1  19.8
std      .  1.3    1.3    .99    1.25    2.1    1.3    2.2    2.0   1.5
n        .   22     22      22     22     22     22     22     22    22
;

data g3(type=corr);
   Input _type_ $ 1-8 _name_ $ 9-11 x1-x9;
   datalines;
corr    x1  1.     .       .      .      .      .      .      .       .
corr    x2 .699    1.      .      .      .      .      .      .       .
corr    x3 .488   .328     1.     .      .      .      .      .       .
corr    x4 .235   .398    .413    1.     .      .      .      .       .
corr    x5 .377   .265    .471   .376    1.     .      .      .       .
corr    x6 .335   .412    .265   .314   .503    1.     .      .       .
corr    x7 .243   .216    .192   .423   .369   .212   1.      .       .
corr    x8 .217   .292    .423   .525   .219   .317  .376    1.       .
corr    x9 .211   .283    .152   .285   .147   .135  .633   .579     1.
mean     . 22.2   20.9    15.4   25.1   22.6   16.3   19.3   20.2  19.5
std      .  1.5    1.0    1.04    1.5    1.9    1.6    2.4    2.2   1.6
n        .   20     20      20     20     20     20     20     20    20
;

proc calis covpattern=eqcovmat meanpattern=eqmeanvec modification;
   var x1-x9;
   group 1 / data=g1;
   group 2 / data=g2;
   group 3 / data=g3;
   fitindex NoIndexType On(only)=[chisq df probchi rmsea aic caic sbc];
run;

proc calis covpattern=eqcovmat meanpattern=saturated;
   var x1-x9;
   group 1 / data=g1;
   group 2 / data=g2;
   group 3 / data=g3;
   fitindex NoIndexType On(only)=[chisq df probchi rmsea aic caic sbc];
run;

proc template;
   define table LagrangeEquality;
      notes "Lagrange Tests for Releasing Equality Constraints For CALIS DOC";
      col_space_min=1 contents_label="Equality Constraints";
      header h1 h2 h3;

      define header h1;
         text "Lagrange Multiplier Statistics "
              "for Releasing Equality Constraints";
         space=1 spill_margin;
         end;

      column Parameter ModelNum RelParmType Var1 Var2 LMStat PVal
             ParmChange RelParmChange;

      define Parameter;
         header="Parm" id width=9 style=RowHeader blank_dups=on;
         translate _val_ = ._ into '.';
         end;

      define ModelNum;
         header=";;Model" id format=best5. style=RowHeader;
         translate _val_ = ._ into '';
         end;

      define RelParmType;
         header="Type" id width=4 style=RowHeader;
         translate _val_ = ._ into '.';
         end;

      define Var1;
         id width=4 style=RowHeader;
         translate _val_ = ._ into '.';
         end;

      define Var2;
         id width=4 style=RowHeader;
         translate _val_ = ._ into '.';
         end;

      define header h2;
         text "Released Parameter";
         start=ModelNum end=Var2 expand='-';
         end;

      define LMStat;
         parent=Stat.Calis.ChiSq;
         header="LM Stat";
         translate _val_ = ._ into '';
         end;

      define PVal;
         parent=Stat.Calis.ProbChiSq;
         translate _val_ = ._ into '';
         end;

      define ParmChange;
         header=";Original;Parm" format=D8.;
         translate _val_ = ._ into '';
         end;

      define RelParmChange;
         header=";Released;Parm" format=D8.;
         translate _val_ = ._ into '';
         end;

      define header h3;
         text "Changes";
         start=ParmChange end=RelParmChange expand='-';
         end;
      end;

proc calis modification;
   var x1-x9;
   group 1 / data=g1;
   group 2 / data=g2;
   group 3 / data=g3;
   model 1 / group = 1;
      mstruct;
      matrix _cov_  = cov01-cov45;
      matrix _mean_ = mean1-mean9;
   model 2 / group = 2;
      refmodel 1;
   model 3 / group = 3;
      refmodel 1;
      renameparm mean3=mean3_mdl3;
   fitindex NoIndexType On(only)=[chisq df probchi rmsea aic caic sbc];
run;

proc calis modification;
   var x1-x9;
   group 1 / data=g1;
   group 2 / data=g2;
   group 3 / data=g3;
   model 1 / group = 1;
      mstruct;
      matrix _cov_  = cov01-cov45;
      matrix _mean_ = mean1-mean9;
   model 2 / group = 2;
      refmodel 1;
      renameparm mean2=mean2_new;    /* constraint a */
   model 3 / group = 3;
      refmodel 1;
      renameparm mean2=mean2_new,    /* constraint a */
                 mean3=mean3_mdl3;
   fitindex NoIndexType On(only)=[chisq df probchi rmsea aic caic sbc];
run;

proc calis modification;
   var x1-x9;
   group 1 / data=g1;
   group 2 / data=g2;
   group 3 / data=g3;
   model 1 / group = 1;
      mstruct;
      matrix _cov_  = cov01-cov45;
      matrix _mean_ = mean1-mean9;
   model 2 / group = 2;
      refmodel 1;
      renameparm mean2=mean2_new,     /* constraint a */
                 mean6=mean6_mdl2;
   model 3 / group = 3;
      refmodel 1;
      renameparm mean2=mean2_new,     /* constraint a */
                 mean3=mean3_mdl3;
   fitindex NoIndexType On(only)=[chisq df probchi rmsea aic caic sbc];
run;

proc calis modification;
   var x1-x9;
   group 1 / data=g1;
   group 2 / data=g2;
   group 3 / data=g3;
   model 1 / group = 1;
      mstruct;
      matrix _cov_  = cov01-cov45;
      matrix _mean_ = mean1-mean9;
   model 2 / group = 2;
      refmodel 1;
      renameparm mean2=mean2_new,     /* constraint a */
                 mean4=mean4_new,     /* constraint b */
                 mean6=mean6_mdl2;
   model 3 / group = 3;
      refmodel 1;
      renameparm mean2=mean2_new,     /* constraint a */
                 mean3=mean3_mdl3,
                 mean4=mean4_new;     /* constraint b */
   fitindex NoIndexType On(only)=[chisq df probchi rmsea aic caic sbc];
run;

proc calis modification;
   var x1-x9;
   group 1 / data=g1;
   group 2 / data=g2;
   group 3 / data=g3;
   model 1 / group = 1;
      mstruct;
      matrix _cov_  = cov01-cov45;
      matrix _mean_ = mean1-mean9;
   model 2 / group = 2;
      refmodel 1;
      renameparm mean1=mean1_new,     /* constraint c */
                 mean2=mean2_new,     /* constraint a */
                 mean4=mean4_new,     /* constraint b */
                 mean6=mean6_mdl2;
   model 3 / group = 3;
      refmodel 1;
      renameparm mean1=mean1_new,    /* constraint c */
                 mean2=mean2_new,    /* constraint a */
                 mean3=mean3_mdl3,
                 mean4=mean4_new;    /* constraint b */
   fitindex NoIndexType On(only)=[chisq df probchi rmsea aic caic sbc];
run;



/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CALEX06                                             */
/*   TITLE: Documentation Example 23 for PROC CALIS             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: RAM, LINEQS, and LISMOD modeling languages          */
/*   PROCS: CALIS                                               */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: yiyung                UPDATE: August 27, 2007       */
/*     REF: PROC CALIS, Example 23                              */
/*    MISC:                                                     */
/****************************************************************/

title "Stability of Alienation";
title2 "Data Matrix of WHEATON, MUTHEN, ALWIN & SUMMERS (1977)";
data Wheaton(type=cov);
   _type_ = 'cov';
   input _name_ $ 1-11 Anomie67 Powerless67 Anomie71 Powerless71
                       Education SEI;
   label Anomie67='Anomie (1967)' Powerless67='Powerlessness (1967)'
         Anomie71='Anomie (1971)' Powerless71='Powerlessness (1971)'
         Education='Education'    SEI='Occupational Status Index';
   datalines;
Anomie67       11.834     .        .        .       .        .
Powerless67     6.947    9.364     .        .       .        .
Anomie71        6.819    5.091   12.532     .       .        .
Powerless71     4.783    5.028    7.495    9.986    .        .
Education      -3.839   -3.889   -3.841   -3.625   9.610     .
SEI           -21.899  -18.831  -21.748  -18.775  35.522  450.288
;

proc calis nobs=932 data=Wheaton;
   ram
      var =  Anomie67     /* 1 */
             Powerless67  /* 2 */
             Anomie71     /* 3 */
             Powerless71  /* 4 */
             Education    /* 5 */
             SEI          /* 6 */
             Alien67      /* 7 */
             Alien71      /* 8 */
             SES,         /* 9 */
      _A_    1   7   1.0,
      _A_    2   7   0.833,
      _A_    3   8   1.0,
      _A_    4   8   0.833,
      _A_    5   9   1.0,
      _A_    6   9   lambda,
      _A_    7   9   gamma1,
      _A_    8   9   gamma2,
      _A_    8   7   beta,
      _P_    1   1   theta1,
      _P_    2   2   theta2,
      _P_    3   3   theta1,
      _P_    4   4   theta2,
      _P_    5   5   theta3,
      _P_    6   6   theta4,
      _P_    7   7   psi1,
      _P_    8   8   psi2,
      _P_    9   9   phi,
      _P_    1   3   theta5,
      _P_    2   4   theta5;
run;

proc calis nobs=932 data=Wheaton;
   lineqs
      Anomie67     = 1.0    * f_Alien67 + e1,
      Powerless67  = 0.833  * f_Alien67 + e2,
      Anomie71     = 1.0    * f_Alien71 + e3,
      Powerless71  = 0.833  * f_Alien71 + e4,
      Education    = 1.0    * f_SES     + e5,
      SEI          = lambda * f_SES     + e6,
      f_Alien67    = gamma1 * f_SES     + d1,
      f_Alien71    = gamma2 * f_SES     + beta * f_Alien67 + d2;
   variance
      E1           = theta1,
      E2           = theta2,
      E3           = theta1,
      E4           = theta2,
      E5           = theta3,
      E6           = theta4,
      D1           = psi1,
      D2           = psi2,
      f_SES        = phi;
   cov
      E1  E3       = theta5,
      E2  E4       = theta5;
run;

proc calis nobs=932 data=Wheaton;
   lismod
      yvar   = Anomie67 Powerless67 Anomie71 Powerless71,
      xvar   = Education SEI,
      etavar = Alien67  Alien71,
      xivar  = SES;
   matrix _LAMBDAY_
      [1,1]  = 1,
      [2,1]  = 0.833,
      [3,2]  = 1,
      [4,2]  = 0.833;
   matrix _LAMBDAX_
      [1,1]  = 1,
      [2,1]  = lambda;
   matrix _GAMMA_
      [1,1]  = gamma1,
      [2,1]  = gamma2;
   matrix _BETA_
      [2,1]  = beta;
   matrix _THETAY_
      [1,1]  = theta1-theta2 theta1-theta2,
      [3,1]  = theta5,
      [4,2]  = theta5;
   matrix _THETAX_
      [1,1]  = theta3-theta4;
   matrix _PSI_
      [1,1]  = psi1-psi2;
   matrix _PHI_
      [1,1]  = phi;
run;



/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CALEX12                                             */
/*   TITLE: Documentation Example 24 for PROC CALIS             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: path analysis, career aspiration data               */
/*   PROCS: CALIS                                               */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: yiyung                UPDATE: November 13, 2009     */
/*     REF: PROC CALIS, Example 24                              */
/*    MISC:                                                     */
/****************************************************************/

title 'Peer Influences on Aspiration: Haller & Butterworth (1960)';
data aspire(type=corr);
   _type_='corr';
   input _name_ $ riq rpa rses roa rea fiq fpa fses foa fea;
   label riq='Respondent: Intelligence'
         rpa='Respondent: Parental Aspiration'
         rses='Respondent: Family SES'
         roa='Respondent: Occupational Aspiration'
         rea='Respondent: Educational Aspiration'
         fiq='Friend: Intelligence'
         fpa='Friend: Parental Aspiration'
         fses='Friend: Family SES'
         foa='Friend: Occupational Aspiration'
         fea='Friend: Educational Aspiration';
   datalines;
riq   1.      .      .      .      .      .       .      .      .      .
rpa   .1839  1.      .      .      .      .       .      .      .      .
rses  .2220  .0489  1.      .      .      .       .      .      .      .
roa   .4105  .2137  .3240  1.      .      .       .      .      .      .
rea   .4043  .2742  .4047  .6247  1.      .       .      .      .      .
fiq   .3355  .0782  .2302  .2995  .2863  1.       .      .      .      .
fpa   .1021  .1147  .0931  .0760  .0702  .2087   1.      .      .      .
fses  .1861  .0186  .2707  .2930  .2407  .2950  -.0438  1.      .      .
foa   .2598  .0839  .2786  .4216  .3275  .5007   .1988  .3607  1.      .
fea   .2903  .1124  .3054  .3269  .3669  .5191   .2784  .4105  .6404  1.
;

proc calis data=aspire nobs=329;
   path
      /* measurement model for intelligence and environment */
      rpa     <===  f_rpa    = 0.837,
      riq     <===  f_riq    = 0.894,
      rses    <===  f_rses   = 0.949,
      fses    <===  f_fses   = 0.949,
      fiq     <===  f_fiq    = 0.894,
      fpa     <===  f_fpa    = 0.837,

      /* structural model of influences: 5 equality constraints */
      f_rpa   ===>  R_Amb ,
      f_riq   ===>  R_Amb ,
      f_rses  ===>  R_Amb ,
      f_fses  ===>  R_Amb ,
      f_rses  ===>  F_Amb ,
      f_fses  ===>  F_Amb ,
      f_fiq   ===>  F_Amb ,
      f_fpa   ===>  F_Amb ,
      F_Amb   ===>  R_Amb ,
      R_Amb   ===>  F_Amb ,

      /* measurement model for aspiration: 1 equality constraint */
      R_Amb   ===>  rea  ,
      R_Amb   ===>  roa      = 1.,
      F_Amb   ===>  foa      = 1.,
      F_Amb   ===>  fea  ;
   pvar
      f_rpa f_riq f_rses f_fpa f_fiq f_fses = 6 * 1.0;
   pcov
      R_Amb F_Amb            ,
      rea  fea               ,
      roa  foa               ;
run;

proc calis data=aspire nobs=329 outmodel=model2;
   path
      /* measurement model for intelligence and environment */
      rpa     <===  f_rpa    = 0.837,
      riq     <===  f_riq    = 0.894,
      rses    <===  f_rses   = 0.949,
      fses    <===  f_fses   = 0.949,
      fiq     <===  f_fiq    = 0.894,
      fpa     <===  f_fpa    = 0.837,

      /* structural model of influences: 5 equality constraints */
      f_rpa   ===>  R_Amb    = gam1,
      f_riq   ===>  R_Amb    = gam2,
      f_rses  ===>  R_Amb    = gam3,
      f_fses  ===>  R_Amb    = gam4,
      f_rses  ===>  F_Amb    = gam4,
      f_fses  ===>  F_Amb    = gam3,
      f_fiq   ===>  F_Amb    = gam2,
      f_fpa   ===>  F_Amb    = gam1,
      F_Amb   ===>  R_Amb    = beta,
      R_Amb   ===>  F_Amb    = beta,

      /* measurement model for aspiration: 1 equality constraint */
      R_Amb   ===>  rea      = lambda,
      R_Amb   ===>  roa      = 1.,
      F_Amb   ===>  foa      = 1.,
      F_Amb   ===>  fea      = lambda;
   pvar
      f_rpa f_riq f_rses f_fpa f_fiq f_fses = 6 * 1.0,
      R_Amb F_Amb             = 2 * psi,        /* 1 ec */
      rea fea                 = 2 * theta1,     /* 1 ec */
      roa foa                 = 2 * theta2;     /* 1 ec */
   pcov
      R_Amb F_Amb             = psi12,
      rea  fea                = covea,
      roa  foa                = covoa,
      f_rpa f_riq f_rses      = cov1-cov3,       /* 3 ec */
      f_fpa f_fiq f_fses      = cov1-cov3,
      f_rpa f_riq f_rses * f_fpa f_fiq f_fses =  /* 3 ec */
          cov4 cov5 cov6  cov5 cov7 cov8  cov6 cov8 cov9;
run;

data model3(type=calismdl);
   set model2;
   if _name_='gam4' then
      do;
         _name_=' ';
         _estim_=0;
      end;
run;

proc calis data=aspire nobs=329 inmodel=model3;
run;

data model4(type=calismdl);
   set model2;
   if _name_='beta' then
      do;
         _name_=' ';
         _estim_=0;
      end;
run;

proc calis data=aspire nobs=329 inmodel=model4;
run;

data model5(type=calismdl);
   set model2;
   if _name_='psi12' then
      do;
         _name_=' ';
         _estim_=0;
      end;
run;

proc calis data=aspire nobs=329 inmodel=model5;
run;

data model7(type=calismdl);
   set model2;
   if _name_='psi12'|_name_='beta' then
      do;
         _name_=' ';
         _estim_=0;
      end;
run;

proc calis data=aspire nobs=329 inmodel=model7;
run;

data model6(type=calismdl);
   set model2;
   if _name_='covea'|_name_='covoa' then
      do;
         _name_=' ';
         _estim_=0;
      end;
run;

proc calis data=aspire nobs=329 inmodel=model6;
run;

data _null_;
   array achisq[7] _temporary_
      (12.0132 19.0697 23.0365 20.9981 19.0745 33.4475 25.3466);
   array adf[7] _temporary_
      (13 28 29 29 29 30 30);
   retain indent 16;
   file print;
   input ho ha @@;
   chisq = achisq[ho] - achisq[ha];
   df = adf[ho] - adf[ha];
   p = 1 - probchi( chisq, df);
   if _n_ = 1 then put
      / +indent 'model comparison   chi**2   df  p-value'
      / +indent '---------------------------------------';
   put +indent +3 ho ' versus ' ha @18 +indent chisq 8.4 df 5. p 9.4;
   datalines;
2 1    3 2    4 2    5 2    7 2    7 4    7 5    6 2
;



/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CALEX07                                             */
/*   TITLE: Documentation Example 25 for PROC CALIS             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: latent growth curve model                           */
/*   PROCS: CALIS                                               */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: yiyung                UPDATE: August 27, 2007       */
/*     REF: PROC CALIS, Example 25                              */
/*    MISC:                                                     */
/****************************************************************/

data growth;
   input y1 y2 y3 y4 y5;
   datalines;
17.6  21.4  25.6  32.1  37.7
13.2  14.3  18.9  20.3  25.4
11.6  13.5  17.4  22.1  39.6
10.7  11.1  13.2  18.2  21.4
18.7  23.7  28.6  31.5  34.0
18.3  19.2  20.5  23.2  25.9
 9.2  13.5  17.8  19.2  21.1
18.3  23.5  27.9  30.2  34.6
11.2  15.6  20.8  22.7  30.4
17.0  22.9  26.9  31.9  35.6
10.4  13.6  18.0  25.6  29.3
17.7  19.0  22.5  28.5  30.7
14.5  19.4  21.1  28.8  31.5
20.0  21.4  28.9  30.2  35.6
14.6  19.3  21.7  28.5  32.0
11.7  15.2  19.1  23.7  28.7
;

proc calis method=ml data=growth nostand noparmname;
   lineqs
      y1 = 0. * Intercept + f_alpha                + e1,
      y2 = 0. * Intercept + f_alpha  +  1 * f_beta + e2,
      y3 = 0. * Intercept + f_alpha  +  2 * f_beta + e3,
      y4 = 0. * Intercept + f_alpha  +  3 * f_beta + e4,
      y5 = 0. * Intercept + f_alpha  +  4 * f_beta + e5;
   variance
      f_alpha f_beta,
      e1-e5 = 5 * evar;
   mean
      f_alpha f_beta;
   cov
      f_alpha f_beta;
   fitindex on(only)=[chisq df probchi];
run;

proc calis method=ml data=growth nostand noparmname;
   lineqs
      y1 = 0. * Intercept + f_alpha                + e1,
      y2 = 0. * Intercept + f_alpha  +  1 * f_beta + e2,
      y3 = 0. * Intercept + f_alpha  +  2 * f_beta + e3,
      y4 = 0. * Intercept + f_alpha  +  3 * f_beta + e4,
      y5 = 0. * Intercept + f_alpha  +  4 * f_beta + e5;
   variance
      f_alpha f_beta,
      e1-e5;
   mean
      f_alpha f_beta;
   cov
      f_alpha f_beta;
   fitindex on(only)=[chisq df probchi];
run;



/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CALEX08                                             */
/*   TITLE: Documentation Example 26 for PROC CALIS             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: higher-order and hierarchical factor models         */
/*   PROCS: CALIS                                               */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: yiyung                UPDATE: August 27, 2007       */
/*     REF: PROC CALIS, Example 26                              */
/*    MISC:                                                     */
/****************************************************************/

data Thurst(type=corr);
title "Example of THURSTONE resp. McDONALD (1985, p.57, p.105)";
   _type_ = 'corr'; input _name_ $ V1-V9;
   label V1='Sentences' V2='Vocabulary' V3='Sentence Completion'
         V4='First Letters' V5='Four-letter Words' V6='Suffices'
         V7='Letter series' V8='Pedigrees' V9='Letter Grouping';
   datalines;
V1  1.       .      .      .      .      .      .      .      .
V2   .828   1.      .      .      .      .      .      .      .
V3   .776   .779   1.      .      .      .      .      .      .
V4   .439   .493    .460  1.      .      .      .      .      .
V5   .432   .464    .425   .674  1.      .      .      .      .
V6   .447   .489    .443   .590   .541  1.      .      .      .
V7   .447   .432    .401   .381   .402   .288  1.      .      .
V8   .541   .537    .534   .350   .367   .320   .555  1.      .
V9   .380   .358    .359   .424   .446   .325   .598   .452  1.
;

proc calis corr data=Thurst method=max nobs=213 nose nostand;
   lineqs
      V1      = X11 * Factor1                                    + E1,
      V2      = X21 * Factor1                                    + E2,
      V3      = X31 * Factor1                                    + E3,
      V4      =             X42 * Factor2                        + E4,
      V5      =             X52 * Factor2                        + E5,
      V6      =             X62 * Factor2                        + E6,
      V7      =                         X73 * Factor3            + E7,
      V8      =                         X83 * Factor3            + E8,
      V9      =                         X93 * Factor3            + E9,
      Factor1 =                                    L1g * FactorG + E10,
      Factor2 =                                    L2g * FactorG + E11,
      Factor3 =                                    L3g * FactorG + E12;
   variance
      FactorG   = 1. ,
      E1-E12    = U1-U9 W1-W3;
   bounds
      0. <= U1-U9;
   fitindex ON(ONLY)=[chisq df probchi];
   /* SAS Programming Statements: Dependent parameter definitions */
      W1  = 1. - L1g * L1g;
      W2  = 1. - L2g * L2g;
      W3  = 1. - L3g * L3g;
run;

proc calis corr data=Thurst method=max nobs=213 nose nostand;
   lineqs
      V1 = X11 * Factor1                       + X1g * FactorG + E1,
      V2 = X21 * Factor1                       + X2g * FactorG + E2,
      V3 = X31 * Factor1                       + X3g * FactorG + E3,
      V4 =            X42 * Factor2            + X4g * FactorG + E4,
      V5 =            X52 * Factor2            + X5g * FactorG + E5,
      V6 =            X62 * Factor2            + X6g * FactorG + E6,
      V7 =                       X73 * Factor3 + X7g * FactorG + E7,
      V8 =                       X83 * Factor3 + X8g * FactorG + E8,
      V9 =                       X93 * Factor3 + X9g * FactorG + E9;
   variance
      Factor1-Factor3 = 3 * 1.,
      FactorG         = 1. ,
      E1-E9           = U1-U9;
   cov
      Factor1-Factor3 FactorG = 6 * 0.;
   bounds
      0. <= U1-U9;
   fitindex ON(ONLY)=[chisq df probchi];
run;

data _null_;
   df0 = 24; chi0 = 38.1963;
   df1 = 18; chi1 = 24.2163;
   diff = chi0-chi1;
   p = 1.-probchi(chi0-chi1,df0-df1);
   put 'Chi-square difference = ' diff;
   put 'p-value = ' p;
run;

proc calis corr data=Thurst method=max nobs=213 nose nostand;
   lineqs
      V1 = X11 * Factor1                          + X1g * FactorG + E1,
      V2 = X21 * Factor1                          + X2g * FactorG + E2,
      V3 = X31 * Factor1                          + X3g * FactorG + E3,
      V4 =              X42 * Factor2             + X4g * FactorG + E4,
      V5 =              X52 * Factor2             + X5g * FactorG + E5,
      V6 =              X62 * Factor2             + X6g * FactorG + E6,
      V7 =                          X73 * Factor3 + X7g * FactorG + E7,
      V8 =                          X83 * Factor3 + X8g * FactorG + E8,
      V9 =                          X93 * Factor3 + X9g * FactorG + E9;
   variance
      Factor1-Factor3 = 3 * 1.,
      FactorG         = 1. ,
      E1-E9           = U1-U9;
   cov
      Factor1-Factor3 FactorG = 6 * 0.;
   bounds
      0. <= U1-U9;
   fitindex ON(ONLY)=[chisq df probchi];
   parameters p1 (.5) p2 (.5) p3 (.5);
   /* Proportionality constraints */
   X1g = p1 * X11;
   X2g = p1 * X21;
   X3g = p1 * X31;
   X4g = p2 * X42;
   X5g = p2 * X52;
   X6g = p2 * X62;
   X7g = p3 * X73;
   X8g = p3 * X83;
   X9g = p3 * X93;
run;



/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CALEX09                                             */
/*   TITLE: Documentation Example 27 for PROC CALIS             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: confirmatory factor model, dependent parameters     */
/*   PROCS: CALIS                                               */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: yiyung                UPDATE: August 27, 2007       */
/*     REF: PROC CALIS, Example 27                              */
/*    MISC:                                                     */
/****************************************************************/

data kinzer(type=corr);
title "Data Matrix of Kinzer & Kinzer, see GUTTMAN (1957)";
   _type_ = 'corr';
   input _name_ $ var1-var6;
   datalines;
var1  1.00   .     .     .     .     .
var2   .51  1.00   .     .     .     .
var3   .46   .51  1.00   .     .     .
var4   .46   .47   .54  1.00   .     .
var5   .40   .39   .49   .57  1.00   .
var6   .33   .39   .47   .45   .56  1.00
;

proc calis data=kinzer nobs=326 nose;
   factor
      factor1 ===> var1-var6   = b11 b21 b31 b41 b51 b61 (6 *.6),
      factor2 ===> var1-var6   = b12 b22 b32 b42 b52 b62;
   pvar
      factor1-factor2 = 2 * 1.,
      var1-var6       = psi1-psi6 (6 *.3);
   cov
      factor1 factor2 = 0.;
   parameters alpha (1.);
   /* SAS Programming Statements to define dependent parameters */
   b12 = alpha - b11;
   b22 = alpha - b21;
   b32 = alpha - b31;
   b42 = alpha - b41;
   b52 = alpha - b51;
   b62 = alpha - b61;
   fitindex on(only)=[chisq df probchi];
run;

proc calis data=Kinzer nobs=326 nose;
   factor
      factor1 ===> var1-var6   = t11 t21 t31 t41 t51 t61,
      factor2 ===> var1-var6   = t12 t22 t32 t42 t52 t62;
   pvar
      factor1-factor2 = 2 * 1.,
      var1-var6       = k1-k6;
   cov
      factor1 factor2 = 0.;
   parameters alpha (1.) d1-d6 (6 * 1.)
              b11 b21 b31 b41 b51 b61 (6 *.6),
              b12 b22 b32 b42 b52 b62
              psi1-psi6;
   /* SAS Programming Statements */
   /* 12 Constraints on Correlation structures */
   b12  = alpha - b11;
   b22  = alpha - b21;
   b32  = alpha - b31;
   b42  = alpha - b41;
   b52  = alpha - b51;
   b62  = alpha - b61;
   psi1 = 1. - b11 * b11 - b12 * b12;
   psi2 = 1. - b21 * b21 - b22 * b22;
   psi3 = 1. - b31 * b31 - b32 * b32;
   psi4 = 1. - b41 * b41 - b42 * b42;
   psi5 = 1. - b51 * b51 - b52 * b52;
   psi6 = 1. - b61 * b61 - b62 * b62;
   /* Defining Covariance Structure Parameters */
   t11  = d1 * b11;
   t21  = d2 * b21;
   t31  = d3 * b31;
   t41  = d4 * b41;
   t51  = d5 * b51;
   t61  = d6 * b61;
   t12  = d1 * b12;
   t22  = d2 * b22;
   t32  = d3 * b32;
   t42  = d4 * b42;
   t52  = d5 * b52;
   t62  = d6 * b62;
   k1   = d1 * d1 * psi1;
   k2   = d2 * d2 * psi2;
   k3   = d3 * d3 * psi3;
   k4   = d4 * d4 * psi4;
   k5   = d5 * d5 * psi5;
   k6   = d6 * d6 * psi6;
   fitindex on(only)=[chisq df probchi];
run;



/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CALEX10                                             */
/*   TITLE: Documentation Example 28 for PROC CALIS             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: multiple-group model, purchase behavior             */
/*   PROCS: CALIS                                               */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: yiyung                UPDATE: August 27, 2007       */
/*     REF: PROC CALIS, Example 28                              */
/*    MISC:                                                     */
/****************************************************************/

data region1(type=cov);
   input _type_ $6. _name_ $12. Spend02 Spend03 Courtesy Responsive
         Helpful Delivery Pricing Availability Quality;
   datalines;
COV   Spend02      14.428  2.206  0.439 0.520 0.459 0.498 0.635 0.642 0.769
COV   Spend03       2.206 14.178  0.540 0.665 0.560 0.622 0.535 0.588 0.715
COV   Courtesy      0.439  0.540  1.642 0.541 0.473 0.506 0.109 0.120 0.126
COV   Responsive    0.520  0.665  0.541 2.977 0.582 0.629 0.119 0.253 0.184
COV   Helpful       0.459  0.560  0.473 0.582 2.801 0.546 0.113 0.121 0.139
COV   Delivery      0.498  0.622  0.506 0.629 0.546 3.830 0.120 0.132 0.145
COV   Pricing       0.635  0.535  0.109 0.119 0.113 0.120 2.152 0.491 0.538
COV   Availability  0.642  0.588  0.120 0.253 0.121 0.132 0.491 2.372 0.589
COV   Quality       0.769  0.715  0.126 0.184 0.139 0.145 0.538 0.589 2.753
MEAN     .        183.500 301.921 4.312 4.724 3.921 4.357 6.144 4.994 5.971
;

data region2(type=cov);
   input _type_ $6. _name_ $12. Spend02 Spend03 Courtesy Responsive
         Helpful Delivery Pricing Availability Quality;
   datalines;
COV   Spend02       14.489   2.193 0.442 0.541 0.469 0.508 0.637 0.675 0.769
COV   Spend03        2.193  14.168 0.542 0.663 0.574 0.623 0.607 0.642 0.732
COV   Courtesy       0.442   0.542 3.282 0.883 0.477 0.120 0.248 0.283 0.387
COV   Responsive     0.541   0.663 0.883 2.717 0.477 0.601 0.421 0.104 0.105
COV   Helpful        0.469   0.574 0.477 0.477 2.018 0.507 0.187 0.162 0.205
COV   Delivery       0.508   0.623 0.120 0.601 0.507 2.999 0.179 0.334 0.099
COV   Pricing        0.637   0.607 0.248 0.421 0.187 0.179 2.512 0.477 0.423
COV   Availability   0.675   0.642 0.283 0.104 0.162 0.334 0.477 2.085 0.675
COV   Quality        0.769   0.732 0.387 0.105 0.205 0.099 0.423 0.675 2.698
MEAN     .         156.250 313.670 2.412 2.727 5.224 6.376 7.147 3.233 5.119
;

proc calis meanstr;
   group 1 / data=region1 label="Region 1" nobs=378;
   group 2 / data=region2 label="Region 2" nobs=423;
   model 1 / group=1,2;
      path
         Service ===> Spend02  Spend03      ,
         Product ===> Spend02  Spend03      ,
         Spend02 ===> Spend03               ,
         Service ===> Courtesy Responsive
                      Helpful Delivery      ,
         Product ===> Pricing  Availability
                      Quality               ;
      pvar
         Courtesy Responsive Helpful Delivery Pricing
         Availability Quality Spend02 Spend03,
         Service Product = 2 * 1.;
      pcov
         Service Product;
run;

proc calis meanstr;
   group 1 / data=region1 label="Region 1" nobs=378;
   group 2 / data=region2 label="Region 2" nobs=423;
   model 1 / group=1;
      path
         Service ===> Spend02  Spend03      ,
         Product ===> Spend02  Spend03      ,
         Spend02 ===> Spend03               ,
         Service ===> Courtesy Responsive Helpful Delivery  ,
         Product ===> Pricing  Availability Quality ;
      pvar
         Courtesy Responsive Helpful Delivery Pricing
         Availability Quality Spend02 Spend03,
         Service Product = 2 * 1.;
      pcov
         Service Product;
   model 2 / group=2;
      refmodel 1/ allnewparms;
run;

proc calis meanstr modification;
   group 1 / data=region1 label="Region 1" nobs=378;
   group 2 / data=region2 label="Region 2" nobs=423;
   model 3 / label="Model for References Only";
      path
         Service ===> Spend02  Spend03      ,
         Product ===> Spend02  Spend03      ,
         Spend02 ===> Spend03               ,
         Service ===> Courtesy Responsive
                      Helpful Delivery      ,
         Product ===> Pricing  Availability
                      Quality               ;
      pvar
         Courtesy Responsive Helpful Delivery Pricing
         Availability Quality Spend02 Spend03,
         Service Product = 2 * 1.;
      pcov
         Service Product;
   model 1 / groups=1;
      refmodel 3;
      mean
         Spend02 Spend03 = G1_InterSpend02 G1_InterSpend03,
         Courtesy Responsive Helpful
         Delivery Pricing Availability
         Quality = G1_intercept01-G1_intercept07;
   model 2 / groups=2;
      refmodel 3;
      mean
         Spend02 Spend03 = G2_InterSpend02 G2_InterSpend03,
         Courtesy Responsive Helpful
         Delivery Pricing Availability
         Quality = G2_intercept01-G2_intercept07;
      simtests
         SpendDiff       = (Spend02Diff Spend03Diff)
         MeasurementDiff = (CourtesyDiff ResponsiveDiff
                            HelpfulDiff DeliveryDiff
                            PricingDiff AvailabilityDiff
                            QualityDiff);
      Spend02Diff      = G2_InterSpend02 - G1_InterSpend02;
      Spend03Diff      = G2_InterSpend03 - G1_InterSpend03;
      CourtesyDiff     = G2_intercept01  - G1_intercept01;
      ResponsiveDiff   = G2_intercept02  - G1_intercept02;
      HelpfulDiff      = G2_intercept03  - G1_intercept03;
      DeliveryDiff     = G2_intercept04  - G1_intercept04;
      PricingDiff      = G2_intercept05  - G1_intercept05;
      AvailabilityDiff = G2_intercept06  - G1_intercept06;
      QualityDiff      = G2_intercept07  - G1_intercept07;
run;



/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CALEX401                                            */
/*   TITLE: Documentation Example 29 for PROC CALIS             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: COSAN model, Wheaton data                           */
/*   PROCS: CALIS                                               */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: yiyung                UPDATE: November 11, 2009     */
/*     REF: PROC CALIS, Example 29                              */
/*    MISC:                                                     */
/****************************************************************/

title "Stability of Alienation";
title2 "Data Matrix of WHEATON, MUTHEN, ALWIN & SUMMERS (1977)";
data Wheaton(TYPE=COV);
   _type_ = 'cov';
   input _name_ $ 1-11 Anomie67 Powerless67 Anomie71 Powerless71
                       Education SEI;
   label Anomie67='Anomie (1967)' Powerless67='Powerlessness (1967)'
         Anomie71='Anomie (1971)' Powerless71='Powerlessness (1971)'
         Education='Education'    SEI='Occupational Status Index';
   datalines;
Anomie67       11.834     .        .        .       .        .
Powerless67     6.947    9.364     .        .       .        .
Anomie71        6.819    5.091   12.532     .       .        .
Powerless71     4.783    5.028    7.495    9.986    .        .
Education      -3.839   -3.889   -3.841   -3.625   9.610     .
SEI           -21.899  -18.831  -21.748  -18.775  35.522  450.288
;

proc calis nobs=932 data=Wheaton primat nose;
   ram
      var =  Anomie67     /* 1 */
             Powerless67  /* 2 */
             Anomie71     /* 3 */
             Powerless71  /* 4 */
             Education    /* 5 */
             SEI          /* 6 */
             Alien67      /* 7 */
             Alien71      /* 8 */
             SES,         /* 9 */
      _A_    1   7   1.0,
      _A_    2   7   0.833,
      _A_    3   8   1.0,
      _A_    4   8   0.833,
      _A_    5   9   1.0,
      _A_    6   9   lambda,
      _A_    7   9   gamma1,
      _A_    8   9   gamma2,
      _A_    8   7   beta,
      _P_    1   1   theta1,
      _P_    2   2   theta2,
      _P_    3   3   theta1,
      _P_    4   4   theta2,
      _P_    5   5   theta3,
      _P_    6   6   theta4,
      _P_    7   7   psi1,
      _P_    8   8   psi2,
      _P_    9   9   phi,
      _P_    1   3   theta5,
      _P_    2   4   theta5;
run;

proc calis data=Wheaton nobs=932 nose;
   cosan
      var= Anomie67 Powerless67 Anomie71 Powerless71 Education SEI,
      J(9, IDE) * A(9, GEN, IMI) * P(9, SYM);
   matrix  A
      [1 2 8   , 7] = 1.0  0.833  beta,
      [3 4     , 8] = 1.0  0.833 ,
      [5 6 7 8 , 9] = 1.   lambda  gamma1  gamma2;
   matrix P
      [1,1] = theta1-theta2 theta1-theta4 ,
      [7,7] = psi1 psi2 phi,
      [3,1] = theta5 ,
      [4,2] = theta5 ;
   vnames
      J = [Anomie67 Powerless67 Anomie71 Powerless71
           Education SEI Alien67 Alien71 SES],
      A = J,
      P = A;
run;

proc calis nobs=932 data=Wheaton primat nose;
   lineqs
      Anomie67     = 1.0    * f_Alien67 + e1,
      Powerless67  = 0.833  * f_Alien67 + e2,
      Anomie71     = 1.0    * f_Alien71 + e3,
      Powerless71  = 0.833  * f_Alien71 + e4,
      Education    = 1.0    * f_SES     + e5,
      SEI          = lambda * f_SES     + e6,
      f_Alien67    = gamma1 * f_SES     + d1,
      f_Alien71    = gamma2 * f_SES     + beta * f_Alien67 + d2;
   variance
      E1           = theta1,
      E2           = theta2,
      E3           = theta1,
      E4           = theta2,
      E5           = theta3,
      E6           = theta4,
      D1           = psi1,
      D2           = psi2,
      f_SES        = phi;
   cov
      E1  E3       = theta5,
      E2  E4       = theta5;
run;

proc calis cov data=Wheaton nobs=932 nose;
   cosan
      var = Anomie67 Anomie71 Education Powerless67 Powerless71 SEI,
      J(8, IDE) * Beta(8, GEN, IMI) * Gamma(9, GEN) * Phi(9, SYM);
   matrix Beta
           [1 4 8   , 7] = 1.0  0.833  beta,
           [2 5     , 8] = 1.0  0.833 ;
   matrix Gamma
           [3 6 7 8 , 1] = 1.0  lambda gamma1 gamma2,
           [1,2]         = 8 *  1.0;
   matrix Phi
           [1,1] = phi 2*theta1 theta3 2*theta2 theta4 psi1 psi2,
           [3,2] = theta5 ,
           [6,5] = theta5 ;
   vnames J     = [Anomie67 Anomie71 Education Powerless67 Powerless71 SEI
                   f_Alien67 f_Alien71],
          Beta  = J,
          Gamma = [f_SES e1 e3 e5 e2 e4 e6 d1 d2],
          Phi   = Gamma;
run;




/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CALEX402                                            */
/*   TITLE: Documentation Example 30 for PROC CALIS             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: higher-order confirmatory factor analysis, COSAN    */
/*   PROCS: CALIS                                               */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: yiyung                UPDATE: November 11, 2009     */
/*     REF: PROC CALIS, Example 30                              */
/*    MISC:                                                     */
/****************************************************************/

data Thurst(TYPE=CORR);
title "Example of THURSTONE resp. McDONALD (1985, p.57, p.105)";
   _TYPE_ = 'CORR'; Input _NAME_ $ Obs1-Obs9;
   label obs1='Sentences' obs2='Vocabulary' obs3='Sentence Completion'
         obs4='First Letters' obs5='Four-letter Words' obs6='Suffices'
         obs7='Letter series' obs8='Pedigrees' obs9='Letter Grouping';
   datalines;
obs1  1.       .      .      .      .      .      .      .      .
obs2   .828   1.      .      .      .      .      .      .      .
obs3   .776   .779   1.      .      .      .      .      .      .
obs4   .439   .493    .460  1.      .      .      .      .      .
obs5   .432   .464    .425   .674  1.      .      .      .      .
obs6   .447   .489    .443   .590   .541  1.      .      .      .
obs7   .447   .432    .401   .381   .402   .288  1.      .      .
obs8   .541   .537    .534   .350   .367   .320   .555  1.      .
obs9   .380   .358    .359   .424   .446   .325   .598   .452  1.
;

proc calis data=Thurst nobs=213 corr nose;
lineqs
   obs1 =  x1 * f1 + e1,
   obs2 =  x2 * f1 + e2,
   obs3 =  x3 * f1 + e3,
   obs4 =  x4 * f2 + e4,
   obs5 =  x5 * f2 + e5,
   obs6 =  x6 * f2 + e6,
   obs7 =  x7 * f3 + e7,
   obs8 =  x8 * f3 + e8,
   obs9 =  x9 * f3 + e9,
   f1   = x10 * f4 + e10,
   f2   = x11 * f4 + e11,
   f3   = x12 * f4 + e12;
variance
   f4      = 1.,
   e1-e9   = u1-u9,
   e10-e12 = 3 * 1.;
bounds
   0. <= u1-u9;
run;

proc calis data=Thurst nobs=213 corr nose;
   cosan
      var = obs1-obs9,
      F1(3) * F2(1) * P(1,IDE) + F1(3) * U2(3,IDE) + U1(9,DIA);
   matrix F1
      [1 , @1] = x1-x3,
      [4 , @2] = x4-X6,
      [7 , @3] = x7-x9;
   matrix F2
      [ ,1]    = x10-x12;
   matrix U1
      [1,1]    = u1-u9;
   bounds
      0. <= u1-u9;
   vnames
      F1 = [f1 f2 f3],
      F2 = [f4],
      U1 = [e1-e9];
run;



/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CALEX403                                            */
/*   TITLE: Documentation Example 31 for PROC CALIS             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: factor analysis, constraints, COSAN                 */
/*   PROCS: CALIS                                               */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: yiyung                UPDATE: November 11, 2009     */
/*     REF: PROC CALIS, Example 31                              */
/*    MISC:                                                     */
/****************************************************************/

data kinzer(type=corr);
title "Data Matrix of Kinzer & Kinzer, see GUTTMAN (1957)";
   _type_ = 'corr';
   input _name_ $ var1-var6;
   datalines;
var1  1.00   .     .     .     .     .
var2   .51  1.00   .     .     .     .
var3   .46   .51  1.00   .     .     .
var4   .46   .47   .54  1.00   .     .
var5   .40   .39   .49   .57  1.00   .
var6   .33   .39   .47   .45   .56  1.00
;

proc calis data=Kinzer nobs=326 nose;
   cosan
      var= var1-var6,
      D(6,DIA) * B(2,GEN) + D(6,DIA) * Psi(6,DIA);
   matrix B
      [ ,1] = b11 b21 b31 b41 b51 b61,
      [ ,2] = b12 b22 b32 b42 b52 b62;
   matrix Psi
      [1,1] = psi1-psi6;
   matrix D
      [1,1] = d1-d6;
   parameters alpha (1.);

   /* SAS Programming Statements to Define Dependent Parameters*/
   /* 6 constraints on the factor loadings */
   b12  = alpha - b11;
   b22  = alpha - b21;
   b32  = alpha - b31;
   b42  = alpha - b41;
   b52  = alpha - b51;
   b62  = alpha - b61;

   /* 6 Constraints on Correlation structures */
   psi1 = 1. - b11 * b11 - b12 * b12;
   psi2 = 1. - b21 * b21 - b22 * b22;
   psi3 = 1. - b31 * b31 - b32 * b32;
   psi4 = 1. - b41 * b41 - b42 * b42;
   psi5 = 1. - b51 * b51 - b52 * b52;
   psi6 = 1. - b61 * b61 - b62 * b62;
   vnames
      D   = [var1-var6],
      B   = [factor1 factor2],
      Psi = D;
run;



/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CALEX405                                            */
/*   TITLE: Documentation Example 32 for PROC CALIS             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: factor analysis, ordinal constraints, COSAN         */
/*   PROCS: CALIS                                               */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: yiyung                UPDATE: August 23, 2007       */
/*     REF: PROC CALIS, Example 32                              */
/*    MISC:                                                     */
/****************************************************************/

Data Kinzer(TYPE=CORR);
Title "Data Matrix of Kinzer & Kinzer, see GUTTMAN (1957)";
   _TYPE_ = 'CORR'; INPUT _NAME_ $ var1-var6;
   Datalines;
var1  1.00   .     .     .     .     .
var2   .51  1.00   .     .     .     .
var3   .46   .51  1.00   .     .     .
var4   .46   .47   .54  1.00   .     .
var5   .40   .39   .49   .57  1.00   .
var6   .33   .39   .47   .45   .56  1.00
;

proc calis data=Kinzer nobs=326 nose;
   cosan
      var= var1-var6,
      D(6,DIA) * B(2,GEN) + D(6,DIA) * Psi(6,DIA);
   matrix B
      [ ,1]= b11 b21 b31 b41 b51 b61,
      [ ,2]= 0.  b22 b32 b42 b52 b62;
   matrix Psi
      [1,1]= psi1-psi6;
   matrix D
      [1,1]= d1-d6 ;
   lincon
      b61  <= b51,
      b51  <= b41,
      b41  <= b31,
      b31  <= b21,
      b21  <= b11,
       0.  <= b22,
      b22  <= b32,
      b32  <= b42,
      b42  <= b52,
      b52  <= b62;

   /* SAS Programming Statements */
   /* 6 Constraints on Correlation structures */
   psi1 = 1. - b11 * b11;
   psi2 = 1. - b21 * b21 - b22 * b22;
   psi3 = 1. - b31 * b31 - b32 * b32;
   psi4 = 1. - b41 * b41 - b42 * b42;
   psi5 = 1. - b51 * b51 - b52 * b52;
   psi6 = 1. - b61 * b61 - b62 * b62;
   vnames
       B   = [factor1 factor2],
       Psi = [var1-var6],
       D   = Psi;
run;



/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CALEX406                                            */
/*   TITLE: Documentation Example 33 for PROC CALIS             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: factor analysis, longitudinal data, COSAN           */
/*   PROCS: CALIS                                               */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: yiyung                UPDATE: November 11, 2009     */
/*     REF: PROC CALIS, Example 33                              */
/*    MISC:                                                     */
/****************************************************************/

Title "Swaminathan's Longitudinal Factor Model, Data: McDONALD(1980)";
Title2 "Constructed Singular Correlation Matrix, GLS & ML not possible";
data Mcdon(TYPE=CORR);
   _TYPE_ = 'CORR'; INPUT _NAME_ $ obs1-obs9;
   datalines;
obs1  1.000    .      .      .      .      .      .      .      .
obs2   .100  1.000    .      .      .      .      .      .      .
obs3   .250   .400  1.000    .      .      .      .      .      .
obs4   .720   .108   .270  1.000    .      .      .      .      .
obs5   .135   .740   .380   .180  1.000    .      .      .      .
obs6   .270   .318   .800   .360   .530  1.000    .      .      .
obs7   .650   .054   .135   .730   .090   .180  1.000    .      .
obs8   .108   .690   .196   .144   .700   .269   .200  1.000    .
obs9   .189   .202   .710   .252   .336   .760   .350   .580  1.000
;

proc calis data=Mcdon method=ls nobs=100 corr;
   cosan
      var = obs1-obs9,
      F1(6,GEN) * F2(6,DIA) * F3(6,DIA) * L(6,LOW) * F3(6,DIA,INV)
                * F2(6,DIA,INV) * P(6,DIA) + U(9,SYM);
   matrix F1
            [1 , @1] = x1-x3,
            [2 , @2] = x4-x5,
            [4 , @3] = x6-x8,
            [5 , @4] = x9-x10,
            [7 , @5] = x11-x13,
            [8 , @6] = x14-x15;
   matrix F2
            [1,1]= 2 * 1. x16 x17 x16 x17;
   matrix F3
            [1,1]= 4 * 1. x18 x19;
   matrix L
            [1,1]= 6 * 1.,
            [3,1]= 4 * 1.,
            [5,1]= 2 * 1.;
   matrix P
            [1,1]= 2 * 1. x20-x23;
   matrix U
            [1,1]= x24-x32,
            [4,1]= x33-x38,
            [7,1]= x39-x41;
   bounds 0. <= x24-x32,
         -1. <= x16-x19 <= 1.;
   /* SAS programming statements for dependent parameters */
   x20 = 1. - x16 * x16;
   x21 = 1. - x17 * x17;
   x22 = 1. - x18 * x18;
   x23 = 1. - x19 * x19;
run;

