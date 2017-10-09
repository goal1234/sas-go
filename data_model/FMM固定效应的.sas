

/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: fmmgs2                                              */
/*   TITLE: Second Getting Started Example for PROC FMM         */
/*          Zero-inflated Poisson regression                    */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Excess zeros                                        */
/*          Count data                                          */
/*          Bayesian analysis                                   */
/*   PROCS: FMM                                                 */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: Dave Kessler                                        */
/*     REF:                                                     */
/*    MISC:                                                     */
/****************************************************************/

data catch;
   input gender $ age count @@;
   datalines;
  F   54  18   M   37   0   F   48  12   M   27   0
  M   55   0   M   32   0   F   49  12   F   45  11
  M   39   0   F   34   1   F   50   0   M   52   4
  M   33   0   M   32   0   F   23   1   F   17   0
  F   44   5   M   44   0   F   26   0   F   30   0
  F   38   0   F   38   0   F   52  18   M   23   1
  F   23   0   M   32   0   F   33   3   M   26   0
  F   46   8   M   45   5   M   51  10   F   48   5
  F   31   2   F   25   1   M   22   0   M   41   0
  M   19   0   M   23   0   M   31   1   M   17   0
  F   21   0   F   44   7   M   28   0   M   47   3
  M   23   0   F   29   3   F   24   0   M   34   1
  F   19   0   F   35   2   M   39   0   M   43   6
;

proc fmm data=catch;
   class gender;
   model count = gender*age / dist=Poisson;
run;

proc fmm data=catch;
   class gender;
   model count = gender*age / dist=Poisson ;
   model       +            / dist=Constant;
run;

proc fmm data=catch seed=12345;
   class gender;
   model count = gender*age / dist=Poisson;
   model       +            / dist=constant;
   performance cpucount=2;
   bayes;
run;

ods graphics on;
ods select TADPanel;
proc fmm data=catch seed=12345;
   class gender;
   model count = gender*age / dist=Poisson;
   model       +            / dist=constant;
   performance cpucount=2;
   bayes;
run;
ods graphics off;

*---Mixture Modeling for Binomial Overdispersion: "Student," Pearson, Beer, and Yeast---*;


/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: fmmgs1                                              */
/*   TITLE: First Getting Started Example for PROC FMM          */
/*          Mixtures of binomial distributions                  */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Student's yeast cell counts                         */
/*          Maximum likelihood and Bayesian analysis            */
/*   PROCS: FMM                                                 */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: Dave Kessler                                        */
/*     REF: Pearson, K. (1915), On certain types of compound    */
/*          frequency distributions in which the components     */
/*          can be individually described by binomial series.   */
/*          Biometrika, 11, 139--144.                           */
/*    MISC:                                                     */
/****************************************************************/

data yeast;
   input count f;
   n = 5;
   datalines;
   0     213
   1     128
   2      37
   3      18
   4       3
   5       1
;

proc fmm data=yeast;
   model count/n =  / k=2;
   freq f;
run;

proc fmm data=yeast;
   model count/n =  / k=2;
   freq f;
   output out=fmmout pred(components) posterior;
run;
data fmmout;
   set fmmout;
   PredCount_1 = post_1 * f;
   PredCount_2 = post_2 * f;
run;
proc print data=fmmout;
run;

ods graphics on;
proc fmm data=yeast seed=12345;
   model count/n = / k=2;
   freq f;
   performance cpucount=2;
   bayes;
run;
ods graphics off;

*---Looking for Multiple Modes: Are Galaxies Clustered?---*;


/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: fmmgs3                                              */
/*   TITLE: Third Getting Started Example for PROC FMM          */
/*          Mixtures of normal distributions                    */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Galaxy data                                         */
/*          Count data                                          */
/*          Bayesian analysis                                   */
/*   PROCS: FMM                                                 */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: Dave Kessler                                        */
/*     REF: Roeder, K. (1990), Density Estimation With          */
/*          Confidence Sets Exemplified by Superclusters and    */
/*          Voids in the Galaxies, Journal of the American      */
/*          Statistical Association, 85, 617--624.              */
/*    MISC:                                                     */
/****************************************************************/

title "FMM Analysis of Galaxies Data";
data galaxies;
   input velocity @@;
   v = velocity / 1000;
   datalines;
9172  9350  9483  9558  9775  10227 10406 16084 16170 18419
18552 18600 18927 19052 19070 19330 19343 19349 19440 19473
19529 19541 19547 19663 19846 19856 19863 19914 19918 19973
19989 20166 20175 20179 20196 20215 20221 20415 20629 20795
20821 20846 20875 20986 21137 21492 21701 21814 21921 21960
22185 22209 22242 22249 22314 22374 22495 22746 22747 22888
22914 23206 23241 23263 23484 23538 23542 23666 23706 23711
24129 24285 24289 24366 24717 24990 25633 26960 26995 32065
32789 34279
;

title2 "Three to Seven Components, Unequal Variances";
ods graphics on;
proc fmm data=galaxies criterion=AIC;
   model v = / kmin=3 kmax=7;
run;

title2 "Three to Seven Components, Equal Variances";
proc fmm data=galaxies criterion=AIC gconv=0;
   model v = / kmin=3 kmax=7  equate=scale;
run;

title2 "Five Components, Equal Variances = 0.9025";
proc fmm data=galaxies;
   model v = / K=5 equate=scale;
   restrict int 0 (scale 1) = 0.9025;
run;

*--- Modeling Mixing Probabilities: All Mice Are Equal, but Some Mice Are More Equal Than Others---*;


/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: fmmex01                                             */
/*   TITLE: Documentation Example 1 for PROC FMM                */
/*          Binomial cluster model                              */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Correlated binomial data                            */
/*          Beta-binomial distribution                          */
/*   PROCS: FMM                                                 */
/*    DATA: Ossification data, Morel and Neerchal (1997)        */
/*                                                              */
/* SUPPORT: Dave Kessler                                        */
/*     REF: Morel, J.G. and Neerchal, N.K. (1997),              */
/*          Clustered Binary Logistic Regression in Teratology  */
/*          Data Using a Finite Mixture Distribution,           */
/*          Statistics in Medicine, 16, 2843--2853              */
/*    MISC:                                                     */
/****************************************************************/

data ossi;
   length tx $8;
   input tx$ n @@;
   do i=1 to n;
      input y m @@;
      output;
   end;
   drop i;
   datalines;
Control  18 8 8 9  9  7  9 0  5 3  3 5 8 9 10 5 8 5 8 1 6 0 5
            8 8 9 10  5  5 4  7 9 10 6 6 3  5
Control  17 8 9 7 10 10 10 1  6 6  6 1 9 8  9 6 7 5 5 7 9
            2 5 5  6  2  8 1  8 0  2 7 8 5  7
PHT      19 1 9 4  9  3  7 4  7 0  7 0 4 1  8 1 7 2 7 2 8 1 7
            0 2 3 10  3  7 2  7 0  8 0 8 1 10 1 1
TCPO     16 0 5 7 10  4  4 8 11 6 10 6 9 3  4 2 8 0 6 0 9
            3 6 2  9  7  9 1 10 8  8 6 9
PHT+TCPO 11 2 2 0  7  1  8 7  8 0 10 0 4 0  6 0 7 6 6 1 6 1 7
;

data ossi;
   set ossi;
   array xx{3} x1-x3;
   do i=1 to 3; xx{i}=0; end;
   pht  = 0;
   tcpo = 0;
   if (tx='TCPO') then do;
      xx{1} = 1;
      tcpo  = 100;
   end; else if (tx='PHT') then do;
      xx{2} = 1;
      pht   = 60;
   end; else if (tx='PHT+TCPO') then do;
      pht  = 60;
      tcpo = 100;
      xx{1} = 1; xx{2} = 1; xx{3}=1;
   end;
run;

proc fmm data=ossi;
   class pht tcpo;
   model y/m = / dist=binomcluster;
   probmodel pht tcpo pht*tcpo;
run;

proc fmm data=ossi;
   class pht tcpo;
   model y/m = pht tcpo pht*tcpo / dist=binomcluster;
   probmodel   pht tcpo pht*tcpo;
run;

proc fmm data=ossi;
   model y/m = x1-x3 / dist=binomcluster;
   probmodel   x1-x3;
run;

proc fmm data=ossi;
   model y/m = x1-x3 / dist=binomial;
run;

proc fmm data=ossi;
   model y/m = x1-x3 / dist=betabinomial;
run;

*---The Usefulness of Custom Starting Values: When Do Cows Eat?---*;


/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: fmmex02                                             */
/*   TITLE: Documentation Example 2 for PROC FMM                */
/*          Three-component mixture, normal-normal-Weibull      */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Three-component mixture                             */
/*          Weibull distribution                                */
/*          Starting values                                     */
/*   PROCS: FMM, KDE                                            */
/*    DATA: Cattle feeding interval data                        */
/*                                                              */
/* SUPPORT: Dave Kessler                                        */
/*    MISC:                                                     */
/****************************************************************/

data cattle;
   input LogInt Count @@;
   datalines;
 0.70   195  1.10   233  1.40   355  1.60   563
 1.80   822  1.95   926  2.10  1018  2.20  1712
 2.30  3190  2.40  2212  2.50  1692  2.55  1558
 2.65  1622  2.70  1637  2.75  1568  2.85  1599
 2.90  1575  2.95  1526  3.00  1537  3.05  1561
 3.10  1555  3.15  1427  3.20  2852  3.25  1396
 3.30  1343  3.35  2473  3.40  1310  3.45  2453
 3.50  1168  3.55  2300  3.60  2174  3.65  2050
 3.70  1926  3.75  1849  3.80  1687  3.85  2416
 3.90  1449  3.95  2095  4.00  1278  4.05  1864
 4.10  1672  4.15  2104  4.20  1443  4.25  1341
 4.30  1685  4.35  1445  4.40  1369  4.45  1284
 4.50  1523  4.55  1367  4.60  1027  4.65  1491
 4.70  1057  4.75  1155  4.80  1095  4.85  1019
 4.90  1158  4.95  1088  5.00  1075  5.05   912
 5.10  1073  5.15   803  5.20   924  5.25   916
 5.30   784  5.35   751  5.40   766  5.45   833
 5.50   748  5.55   725  5.60   674  5.65   690
 5.70   659  5.75   695  5.80   529  5.85   639
 5.90   580  5.95   557  6.00   524  6.05   473
 6.10   538  6.15   444  6.20   456  6.25   453
 6.30   374  6.35   406  6.40   409  6.45   371
 6.50   320  6.55   334  6.60   353  6.65   305
 6.70   302  6.75   301  6.80   263  6.85   218
 6.90   255  6.95   240  7.00   219  7.05   202
 7.10   192  7.15   180  7.20   162  7.25   126
 7.30   148  7.35   173  7.40   142  7.45   163
 7.50   152  7.55   149  7.60   139  7.65   161
 7.70   174  7.75   179  7.80   188  7.85   239
 7.90   225  7.95   213  8.00   235  8.05   256
 8.10   272  8.15   290  8.20   320  8.25   355
 8.30   307  8.35   311  8.40   317  8.45   335
 8.50   369  8.55   365  8.60   365  8.65   396
 8.70   419  8.75   467  8.80   468  8.85   515
 8.90   558  8.95   623  9.00   712  9.05   716
 9.10   829  9.15   803  9.20   834  9.25   856
 9.30   838  9.35   842  9.40   826  9.45   834
 9.50   798  9.55   801  9.60   780  9.65   849
 9.70   779  9.75   737  9.80   683  9.85   686
 9.90   626  9.95   582 10.00   522 10.05   450
10.10   443 10.15   375 10.20   342 10.25   285
10.30   254 10.35   231 10.40   195 10.45   186
10.50   143 10.55   100 10.60    73 10.65    49
10.70    28 10.75    36 10.80    16 10.85     9
10.90     5 10.95     6 11.00     4 11.05     1
11.15     1 11.25     4 11.30     2 11.35     5
11.40     4 11.45     3 11.50     1
;

ods graphics on;
proc kde data=cattle;
   univar LogInt / bwm=4;
   freq count;
run;

proc fmm data=cattle gconv=0;
   model LogInt = / dist=normal k=2 parms(3 1, 5 1);
   model        + / dist=weibull;
   freq count;
run;

ods select DensityPlot;
proc fmm data=cattle gconv=0;
   model LogInt = / dist=normal k=2 parms(3 1, 5 1);
   model        + / dist=weibull;
   freq count;
run;

ods select DensityPlot;
proc fmm data=cattle plot=density(cumulative) gconv=0;
   model LogInt = / dist=normal k=2 parms(3 1, 5 1);
   model        + / dist=weibull;
   freq count;
run;

proc fmm data=cattle gconv=0;
   model LogInt = / dist=normal k=2;
   model        + / dist=weibull;
   freq count;
run;
ods graphics off;

*---Enforcing Homogeneity Constraints: Count and Dispersion¡ªIt Is All Over!---*;


/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: fmmex03                                             */
/*   TITLE: Documentation Example 3 for PROC FMM                */
/*          Mixed Poisson Regression                            */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Partially varying mean functions                    */
/*          Likelihood ratio test                               */
/*          Outlier induces overdispersion                      */
/*                                                              */
/*   PROCS: FMM                                                 */
/*    DATA: Ames salmonella assay data, Margolin et al. (1981)  */
/*                                                              */
/* SUPPORT: Dave Kessler                                        */
/*     REF: Wang, P., Puterman, M. L., Cockburn, I., and Le, N.,*/
/*          (1996), Mixed Poisson Regression Models With        */
/*          Covariate Dependent Rates, Biometrics, 52, 381--400.*/
/*    MISC:                                                     */
/****************************************************************/

data assay;
   label dose = 'Dose of quinoline (microg/plate)'
         num  = 'Observed number of colonies';
   input dose @;
   logd = log(dose+10);
   do i=1 to 3; input num@; output; end;
   datalines;
   0  15 21 29
  10  16 18 21
  33  16 26 33
 100  27 41 60
 333  33 38 41
1000  20 27 42
;

proc fmm data=assay;
   model num = dose logd / dist=Poisson;
run;

proc fmm data=assay;
   model num = dose logd / dist=Poisson k=2
                           equate=effects(dose logd);
run;

proc fmm data=assay;
   model num = dose logd / dist=Poisson k=2;
   restrict 'common dose' dose 1, dose -1;
   restrict 'common logd' logd 1, logd -1;
run;

proc fmm data=assay(where=(num ne 60));
   model num = dose logd / dist=Poisson k=2
                           equate=effects(dose logd);
run;

proc fmm data=assay(where=(num ne 60));
   model num = dose logd / dist=Poisson;
run;

*--- Modeling Multinomial Overdispersion: Town and Country---*;


/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: fmmex04                                             */
/*   TITLE: Documentation Example 4 for PROC FMM                */
/*          Multinomial Cluster Model                           */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Multinomial overdispersion                          */
/*          Information Criteria                                */
/*                                                              */
/*   PROCS: FMM                                                 */
/*    DATA: Housing satisfaction data, Wilson (1989).           */
/*                                                              */
/* SUPPORT: Dave Kessler                                        */
/*     REF: Brier, S.S. (1980), Analysis of contingency tables  */
/*          under cluster sampling, Biometrika, 67, 591-596     */
/*                                                              */
/*     REF: Wilson J.R., (1989), Chi-square tests for           */
/*          overdispersion with multiparameter estimates,       */
/*          Journal of the Royal Statistical Society Series C   */
/*          (Applied Statistics), 38, 3, 441-453                */
/*                                                              */
/*     REF: Morel, J.G. and Nagaraj, N.K. [sic] (1993),         */
/*          A Finite Mixture Distribution for Modeling          */
/*          Multinomial Extra Variation, Biometrika, 80,        */
/*          363-371                                             */
/*                                                              */
/*    MISC:                                                     */
/****************************************************************/

data housing;
   label us    = 'Unsatisfied'
         s     = 'Satisfied'
         vs    = 'Very Satisfied';
   input type $ us s vs @@;
   datalines;
rural 3 2 0  rural 3 2 0  rural 0 5 0  rural 3 2 0  rural 0 5 0
rural 4 1 0  rural 3 2 0  rural 2 3 0  rural 4 0 1  rural 0 4 1
rural 2 3 0  rural 4 1 0  rural 4 1 0  rural 1 2 2  rural 4 1 0
rural 1 3 1  rural 4 1 0  rural 5 0 0
urban 0 4 1  urban 0 5 0  urban 0 3 2  urban 3 2 0  urban 2 3 0
urban 1 3 1  urban 4 1 0  urban 4 0 1  urban 0 3 2  urban 1 2 2
urban 0 5 0  urban 3 2 0  urban 2 3 0  urban 2 2 1  urban 4 0 1
urban 0 4 1  urban 4 1 0
;

data toscore;
   type='rural'; output;
   type='urban'; output;
run;

data housing;
   set housing toscore;
run;

proc fmm data=housing;
   class type;
   model us s vs = Type  / dist=multinomial;
   output out=Pred pred;
run;

proc print data=pred(where=(us=.)) noobs;
   var type pred:;
run;

proc fmm data=housing;
   class type;
   model us s vs = Type / dist=multinomcluster;
   output out=Pred pred;
   probmodel Type;
run;

