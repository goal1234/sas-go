

/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CLUSGS                                              */
/*   TITLE: Getting Started Example for PROC CLUSTER            */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: CLUSTER ANALYSIS POVERTY DATA                       */
/*   PROCS: ACECLUS, CLUSTER, TREE, SGPLOT                      */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: sasrbk                                              */
/*     REF: PROC CLUSTER, GETTING STARTED.                      */
/*    MISC:                                                     */
/****************************************************************/

data Poverty;
   input Birth Death InfantDeath Country $20. @@;
   datalines;
24.7  5.7  30.8 Albania               12.5 11.9  14.4 Bulgaria
13.4 11.7  11.3 Czechoslovakia        12   12.4   7.6 Former E. Germany
11.6 13.4  14.8 Hungary               14.3 10.2    16 Poland
13.6 10.7  26.9 Romania                 14    9  20.2 Yugoslavia
17.7   10    23 USSR                  15.2  9.5  13.1 Byelorussia SSR
13.4 11.6    13 Ukrainian SSR         20.7  8.4  25.7 Argentina
46.6   18   111 Bolivia               28.6  7.9    63 Brazil
23.4  5.8  17.1 Chile                 27.4  6.1    40 Columbia
32.9  7.4    63 Ecuador               28.3  7.3    56 Guyana
34.8  6.6    42 Paraguay              32.9  8.3 109.9 Peru
  18  9.6  21.9 Uruguay               27.5  4.4  23.3 Venezuela
  29 23.2    43 Mexico                  12 10.6   7.9 Belgium
13.2 10.1   5.8 Finland               12.4 11.9   7.5 Denmark
13.6  9.4   7.4 France                11.4 11.2   7.4 Germany
10.1  9.2    11 Greece                15.1  9.1   7.5 Ireland
 9.7  9.1   8.8 Italy                 13.2  8.6   7.1 Netherlands
14.3 10.7   7.8 Norway                11.9  9.5  13.1 Portugal
10.7  8.2   8.1 Spain                 14.5 11.1   5.6 Sweden
12.5  9.5   7.1 Switzerland           13.6 11.5   8.4 U.K.
14.9  7.4     8 Austria                9.9  6.7   4.5 Japan
14.5  7.3   7.2 Canada                16.7  8.1   9.1 U.S.A.
40.4 18.7 181.6 Afghanistan           28.4  3.8    16 Bahrain
42.5 11.5 108.1 Iran                  42.6  7.8    69 Iraq
22.3  6.3   9.7 Israel                38.9  6.4    44 Jordan
26.8  2.2  15.6 Kuwait                31.7  8.7    48 Lebanon
45.6  7.8    40 Oman                  42.1  7.6    71 Saudi Arabia
29.2  8.4    76 Turkey                22.8  3.8    26 United Arab Emirates
42.2 15.5   119 Bangladesh            41.4 16.6   130 Cambodia
21.2  6.7    32 China                 11.7  4.9   6.1 Hong Kong
30.5 10.2    91 India                 28.6  9.4    75 Indonesia
23.5 18.1    25 Korea                 31.6  5.6    24 Malaysia
36.1  8.8    68 Mongolia              39.6 14.8   128 Nepal
30.3  8.1 107.7 Pakistan              33.2  7.7    45 Philippines
17.8  5.2   7.5 Singapore             21.3  6.2  19.4 Sri Lanka
22.3  7.7    28 Thailand              31.8  9.5    64 Vietnam
35.5  8.3    74 Algeria               47.2 20.2   137 Angola
48.5 11.6    67 Botswana              46.1 14.6    73 Congo
38.8  9.5  49.4 Egypt                 48.6 20.7   137 Ethiopia
39.4 16.8   103 Gabon                 47.4 21.4   143 Gambia
44.4 13.1    90 Ghana                   47 11.3    72 Kenya
  44  9.4    82 Libya                 48.3   25   130 Malawi
35.5  9.8    82 Morocco                 45 18.5   141 Mozambique
  44 12.1   135 Namibia               48.5 15.6   105 Nigeria
48.2 23.4   154 Sierra Leone          50.1 20.2   132 Somalia
32.1  9.9    72 South Africa          44.6 15.8   108 Sudan
46.8 12.5   118 Swaziland             31.1  7.3    52 Tunisia
52.2 15.6   103 Uganda                50.5   14   106 Tanzania
45.6 14.2    83 Zaire                 51.1 13.7    80 Zambia
41.7 10.3    66 Zimbabwe
;


proc aceclus data=Poverty out=Ace p=.03 noprint;
   var Birth Death InfantDeath;
run;

ods graphics on;

proc cluster data=Ace method=ward ccc pseudo print=15 out=tree
   plots=den(height=rsq);
   var can1-can3;
   id country;
run;

ods graphics off;

proc tree data=Tree out=New nclusters=3 noprint;
   height _rsq_;
   copy can1 can2;
   id country;
run;

proc sgplot data=New;
   scatter y=can2 x=can1 / group=cluster;
run;


*---Cluster Analysis of Flying Mileages between 10 American Cities---*;


/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CLUSEX1                                             */
/*   TITLE: Documentation Example 1 for PROC CLUSTER            */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: CLUSTER ANALYSIS MILEAGE                            */
/*   PROCS: CLUSTER                                             */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: sasrbk                                              */
/*     REF: PROC CLUSTER, Example 1.                            */
/*    MISC:                                                     */
/****************************************************************/

proc print noobs data=sashelp.mileages;
run;

title 'Cluster Analysis of Flying Mileages Between 10 American Cities';
ods graphics on;

title2 'Using METHOD=AVERAGE';
proc cluster data=sashelp.mileages(type=distance) method=average pseudo;
  id City;
run;

title2 'Using METHOD=CENTROID';
proc cluster data=sashelp.mileages(type=distance) method=centroid pseudo;
   id City;
run;

title2 'Using METHOD=DENSITY K=3';
proc cluster data=sashelp.mileages(type=distance) method=density k=3;
   id City;
run;

title2 'Using METHOD=SINGLE';
proc cluster data=sashelp.mileages(type=distance) method=single;
   id City;
run;

title2 'Using METHOD=TWOSTAGE K=3';
proc cluster data=sashelp.mileages(type=distance) method=twostage k=3;
   id City;
run;

title2 'Using METHOD=WARD';
proc cluster data=sashelp.mileages(type=distance) method=ward pseudo;
   id City;
run;



/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CLUSEX2                                             */
/*   TITLE: Documentation Example 2 for PROC CLUSTER            */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: CLUSTER ANALYSIS POVERTY DATA                       */
/*   PROCS: CLUSTER, TREE                                       */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: sasrbk                                              */
/*     REF: PROC CLUSTER, Example 1.                            */
/*    MISC:                                                     */
/****************************************************************/

data Poverty;
   input Birth Death InfantDeath Country $20. @@;
   datalines;
24.7  5.7  30.8 Albania               12.5 11.9  14.4 Bulgaria
13.4 11.7  11.3 Czechoslovakia        12   12.4   7.6 Former E. Germany
11.6 13.4  14.8 Hungary               14.3 10.2    16 Poland
13.6 10.7  26.9 Romania                 14    9  20.2 Yugoslavia
17.7   10    23 USSR                  15.2  9.5  13.1 Byelorussia SSR
13.4 11.6    13 Ukrainian SSR         20.7  8.4  25.7 Argentina
46.6   18   111 Bolivia               28.6  7.9    63 Brazil
23.4  5.8  17.1 Chile                 27.4  6.1    40 Columbia
32.9  7.4    63 Ecuador               28.3  7.3    56 Guyana
34.8  6.6    42 Paraguay              32.9  8.3 109.9 Peru
  18  9.6  21.9 Uruguay               27.5  4.4  23.3 Venezuela
  29 23.2    43 Mexico                  12 10.6   7.9 Belgium
13.2 10.1   5.8 Finland               12.4 11.9   7.5 Denmark
13.6  9.4   7.4 France                11.4 11.2   7.4 Germany
10.1  9.2    11 Greece                15.1  9.1   7.5 Ireland
 9.7  9.1   8.8 Italy                 13.2  8.6   7.1 Netherlands
14.3 10.7   7.8 Norway                11.9  9.5  13.1 Portugal
10.7  8.2   8.1 Spain                 14.5 11.1   5.6 Sweden
12.5  9.5   7.1 Switzerland           13.6 11.5   8.4 U.K.
14.9  7.4     8 Austria                9.9  6.7   4.5 Japan
14.5  7.3   7.2 Canada                16.7  8.1   9.1 U.S.A.
40.4 18.7 181.6 Afghanistan           28.4  3.8    16 Bahrain
42.5 11.5 108.1 Iran                  42.6  7.8    69 Iraq
22.3  6.3   9.7 Israel                38.9  6.4    44 Jordan
26.8  2.2  15.6 Kuwait                31.7  8.7    48 Lebanon
45.6  7.8    40 Oman                  42.1  7.6    71 Saudi Arabia
29.2  8.4    76 Turkey                22.8  3.8    26 United Arab Emirates
42.2 15.5   119 Bangladesh            41.4 16.6   130 Cambodia
21.2  6.7    32 China                 11.7  4.9   6.1 Hong Kong
30.5 10.2    91 India                 28.6  9.4    75 Indonesia
23.5 18.1    25 Korea                 31.6  5.6    24 Malaysia
36.1  8.8    68 Mongolia              39.6 14.8   128 Nepal
30.3  8.1 107.7 Pakistan              33.2  7.7    45 Philippines
17.8  5.2   7.5 Singapore             21.3  6.2  19.4 Sri Lanka
22.3  7.7    28 Thailand              31.8  9.5    64 Vietnam
35.5  8.3    74 Algeria               47.2 20.2   137 Angola
48.5 11.6    67 Botswana              46.1 14.6    73 Congo
38.8  9.5  49.4 Egypt                 48.6 20.7   137 Ethiopia
39.4 16.8   103 Gabon                 47.4 21.4   143 Gambia
44.4 13.1    90 Ghana                   47 11.3    72 Kenya
  44  9.4    82 Libya                 48.3   25   130 Malawi
35.5  9.8    82 Morocco                 45 18.5   141 Mozambique
  44 12.1   135 Namibia               48.5 15.6   105 Nigeria
48.2 23.4   154 Sierra Leone          50.1 20.2   132 Somalia
32.1  9.9    72 South Africa          44.6 15.8   108 Sudan
46.8 12.5   118 Swaziland             31.1  7.3    52 Tunisia
52.2 15.6   103 Uganda                50.5   14   106 Tanzania
45.6 14.2    83 Zaire                 51.1 13.7    80 Zambia
41.7 10.3    66 Zimbabwe
;

title 'Cluster Analysis of Birth and Death Rates';
ods graphics on;

%macro analyze(method,ncl);
   proc cluster data=poverty outtree=tree method=&method print=15 ccc pseudo;
      var birth death;
      title2;
   run;

   %let k=1;
   %let n=%scan(&ncl,&k);
   %do %while(&n NE);

      proc tree data=tree noprint out=out ncl=&n;
         copy birth death;
      run;

      proc sgplot;
         scatter y=death x=birth / group=cluster;
         title2 "Plot of &n Clusters from METHOD=&METHOD";
      run;

      %let k=%eval(&k+1);
      %let n=%scan(&ncl,&k);
   %end;
%mend;

%analyze(average, 3 8)

%analyze(complete, 3)

%analyze(single, 7 10)

%analyze(two k=10, 3)

%analyze(two k=18, 2)



/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CLUSEX3                                             */
/*   TITLE: Documentation Example 3 for PROC CLUSTER            */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: CLUSTER ANALYSIS IRIS DATA                          */
/*   PROCS: FREQ, CANDISC, SGPLOT, CLUSTER, TREE, FASTCLUS      */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: sasrbk                                              */
/*     REF: PROC CLUSTER, Example 3.                            */
/*    MISC:                                                     */
/****************************************************************/

proc format;
   value specname
      1='Setosa    '
      2='Versicolor'
      3='Virginica ';
run;

data iris;
   title 'Fisher (1936) Iris Data';
   input SepalLength SepalWidth PetalLength PetalWidth Species @@;
   format Species specname.;
   label SepalLength='Sepal Length in mm.'
         SepalWidth ='Sepal Width in mm.'
         PetalLength='Petal Length in mm.'
         PetalWidth ='Petal Width in mm.';
   datalines;
50 33 14 02 1 64 28 56 22 3 65 28 46 15 2 67 31 56 24 3
63 28 51 15 3 46 34 14 03 1 69 31 51 23 3 62 22 45 15 2
59 32 48 18 2 46 36 10 02 1 61 30 46 14 2 60 27 51 16 2
65 30 52 20 3 56 25 39 11 2 65 30 55 18 3 58 27 51 19 3
68 32 59 23 3 51 33 17 05 1 57 28 45 13 2 62 34 54 23 3
77 38 67 22 3 63 33 47 16 2 67 33 57 25 3 76 30 66 21 3
49 25 45 17 3 55 35 13 02 1 67 30 52 23 3 70 32 47 14 2
64 32 45 15 2 61 28 40 13 2 48 31 16 02 1 59 30 51 18 3
55 24 38 11 2 63 25 50 19 3 64 32 53 23 3 52 34 14 02 1
49 36 14 01 1 54 30 45 15 2 79 38 64 20 3 44 32 13 02 1
67 33 57 21 3 50 35 16 06 1 58 26 40 12 2 44 30 13 02 1
77 28 67 20 3 63 27 49 18 3 47 32 16 02 1 55 26 44 12 2
50 23 33 10 2 72 32 60 18 3 48 30 14 03 1 51 38 16 02 1
61 30 49 18 3 48 34 19 02 1 50 30 16 02 1 50 32 12 02 1
61 26 56 14 3 64 28 56 21 3 43 30 11 01 1 58 40 12 02 1
51 38 19 04 1 67 31 44 14 2 62 28 48 18 3 49 30 14 02 1
51 35 14 02 1 56 30 45 15 2 58 27 41 10 2 50 34 16 04 1
46 32 14 02 1 60 29 45 15 2 57 26 35 10 2 57 44 15 04 1
50 36 14 02 1 77 30 61 23 3 63 34 56 24 3 58 27 51 19 3
57 29 42 13 2 72 30 58 16 3 54 34 15 04 1 52 41 15 01 1
71 30 59 21 3 64 31 55 18 3 60 30 48 18 3 63 29 56 18 3
49 24 33 10 2 56 27 42 13 2 57 30 42 12 2 55 42 14 02 1
49 31 15 02 1 77 26 69 23 3 60 22 50 15 3 54 39 17 04 1
66 29 46 13 2 52 27 39 14 2 60 34 45 16 2 50 34 15 02 1
44 29 14 02 1 50 20 35 10 2 55 24 37 10 2 58 27 39 12 2
47 32 13 02 1 46 31 15 02 1 69 32 57 23 3 62 29 43 13 2
74 28 61 19 3 59 30 42 15 2 51 34 15 02 1 50 35 13 03 1
56 28 49 20 3 60 22 40 10 2 73 29 63 18 3 67 25 58 18 3
49 31 15 01 1 67 31 47 15 2 63 23 44 13 2 54 37 15 02 1
56 30 41 13 2 63 25 49 15 2 61 28 47 12 2 64 29 43 13 2
51 25 30 11 2 57 28 41 13 2 65 30 58 22 3 69 31 54 21 3
54 39 13 04 1 51 35 14 03 1 72 36 61 25 3 65 32 51 20 3
61 29 47 14 2 56 29 36 13 2 69 31 49 15 2 64 27 53 19 3
68 30 55 21 3 55 25 40 13 2 48 34 16 02 1 48 30 14 01 1
45 23 13 03 1 57 25 50 20 3 57 38 17 03 1 51 38 15 03 1
55 23 40 13 2 66 30 44 14 2 68 28 48 14 2 54 34 17 02 1
51 37 15 04 1 52 35 15 02 1 58 28 51 24 3 67 30 50 17 2
63 33 60 25 3 53 37 15 02 1
;

/*--- Define macro show ---*/
%macro show;
   proc freq;
      tables cluster*species / nopercent norow nocol plot=none;
   run;

   proc candisc noprint out=can;
      class cluster;
      var petal: sepal:;
   run;

   proc sgplot data=can;
      scatter y=can2 x=can1 / group=cluster;
   run;
%mend;

title2 'By Ward''s Method';
ods graphics on;

proc cluster data=iris method=ward print=15 ccc pseudo;
   var petal: sepal:;
   copy species;
run;

proc tree noprint ncl=3 out=out;
   copy petal: sepal: species;
run;

%show;

title2 'By Two-Stage Density Linkage';

proc cluster data=iris method=twostage k=8 print=15 ccc pseudo;
   var petal: sepal:;
   copy species;
run;

proc tree noprint ncl=3 out=out;
   copy petal: sepal: species;
run;

%show;

title2 'Preliminary Analysis by FASTCLUS';
proc fastclus data=iris summary maxc=10 maxiter=99 converge=0
              mean=mean out=prelim cluster=preclus;
   var petal: sepal:;
run;

proc freq;
   tables preclus*species / nopercent norow nocol plot=none;
run;

proc sort data=prelim;
   by preclus;
run;

/*--- Define macro clus ---*/
%macro clus(method);
   proc cluster data=mean method=&method ccc pseudo;
      var petal: sepal:;
      copy preclus;
   run;

   proc tree noprint ncl=3 out=out;
      copy petal: sepal: preclus;
   run;

   proc sort data=out;
      by preclus;
   run;

   data clus;
      merge out prelim;
      by preclus;
   run;

   %show;
%mend;

title2 'Clustering Clusters by Ward''s Method';
%clus(ward);

title2 "Clustering Clusters by Wong's Hybrid Method";
%clus(twostage hybrid);



/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CLUSEX4                                             */
/*   TITLE: Documentation Example 4 for PROC CLUSTER            */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: HIERARCHICAL CLUSTER ANALYSIS TIES                  */
/*   PROCS: FREQ, SGSCATTER, CLUSTER, TREE, TABULATE            */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: sasrbk                                              */
/*     REF: PROC CLUSTER, Example 4.                            */
/*    MISC:                                                     */
/****************************************************************/

title 'Hierarchical Cluster Analysis of Mammals'' Teeth Data';
title2 'Evaluating the Effects of Ties';
data teeth;
   input Mammal & $16. v1-v8 @@;
   label v1='Top incisors'
         v2='Bottom incisors'
         v3='Top canines'
         v4='Bottom canines'
         v5='Top premolars'
         v6='Bottom premolars'
         v7='Top molars'
         v8='Bottom molars';
   datalines;
Brown Bat         2 3 1 1 3 3 3 3   Mole              3 2 1 0 3 3 3 3
Silver Hair Bat   2 3 1 1 2 3 3 3   Pigmy Bat         2 3 1 1 2 2 3 3
House Bat         2 3 1 1 1 2 3 3   Red Bat           1 3 1 1 2 2 3 3
Pika              2 1 0 0 2 2 3 3   Rabbit            2 1 0 0 3 2 3 3
Beaver            1 1 0 0 2 1 3 3   Groundhog         1 1 0 0 2 1 3 3
Gray Squirrel     1 1 0 0 1 1 3 3   House Mouse       1 1 0 0 0 0 3 3
Porcupine         1 1 0 0 1 1 3 3   Wolf              3 3 1 1 4 4 2 3
Bear              3 3 1 1 4 4 2 3   Raccoon           3 3 1 1 4 4 3 2
Marten            3 3 1 1 4 4 1 2   Weasel            3 3 1 1 3 3 1 2
Wolverine         3 3 1 1 4 4 1 2   Badger            3 3 1 1 3 3 1 2
River Otter       3 3 1 1 4 3 1 2   Sea Otter         3 2 1 1 3 3 1 2
Jaguar            3 3 1 1 3 2 1 1   Cougar            3 3 1 1 3 2 1 1
Fur Seal          3 2 1 1 4 4 1 1   Sea Lion          3 2 1 1 4 4 1 1
Grey Seal         3 2 1 1 3 3 2 2   Elephant Seal     2 1 1 1 4 4 1 1
Reindeer          0 4 1 0 3 3 3 3   Elk               0 4 1 0 3 3 3 3
Deer              0 4 0 0 3 3 3 3   Moose             0 4 0 0 3 3 3 3
;

title3 'Raw Data';
proc cluster data=teeth method=average nonorm noeigen;
   var v1-v8;
   id mammal;
run;

title3 'Standardized Data';
proc cluster data=teeth std method=average nonorm noeigen;
   var v1-v8;
   id mammal;
run;

/* --------------------------------------------------------- */
/*                                                           */
/* The macro CLUSPERM randomly permutes observations and     */
/* does a cluster analysis for each permutation.             */
/* The arguments are as follows:                             */
/*                                                           */
/*    data    data set name                                  */
/*    var     list of variables to cluster                   */
/*    id      id variable for proc cluster                   */
/*    method  clustering method (and possibly other options) */
/*    nperm   number of random permutations.                 */
/*                                                           */
/* --------------------------------------------------------- */
%macro CLUSPERM(data,var,id,method,nperm);

   /* ------CREATE TEMPORARY DATA SET WITH RANDOM NUMBERS------ */
   data _temp_(drop=i);
      set &data;
      array _random_ _ran_1-_ran_&nperm;
      do i = 1 to dim(_random_);
         _random_[i]=ranuni(835297461);
      end;
   run;

   /* ------PERMUTE AND CLUSTER THE DATA----------------------- */
   %do n=1 %to &nperm;
      proc sort data=_temp_(keep=_ran_&n &var &id) out=_perm_;
         by _ran_&n;
      run;

      proc cluster method=&method noprint outtree=_tree_&n;
         var &var;
         id &id;
      run;
   %end;
%mend;

/* --------------------------------------------------------- */
/*                                                           */
/* The macro PLOTPERM plots various cluster statistics       */
/* against the number of clusters for each permutation.      */
/* The arguments are as follows:                             */
/*                                                           */
/*    nclus   maximum number of clusters to be plotted       */
/*    nperm   number of random permutations.                 */
/*                                                           */
/* --------------------------------------------------------- */
%macro PLOTPERM(nclus,nperm);

   /* ---CONCATENATE TREE DATA SETS FOR 20 OR FEWER CLUSTERS--- */
   data _plot_;
      set %do n=1 %to &nperm; _tree_&n(in=_in_&n) %end;;
      if _ncl_<=&nclus;
      %do n=1 %to &nperm;
         if _in_&n then _perm_=&n;
      %end;
      label _perm_='permutation number';
      keep _ncl_ _psf_ _pst2_ _ccc_ _perm_;
   run;

   /* ---PLOT THE REQUESTED STATISTICS BY NUMBER OF CLUSTERS--- */
   proc sgscatter;
      compare y=(_ccc_ _psf_ _pst2_) x=_ncl_ /group=_perm_;
      label _ccc_ = 'CCC' _psf_ = 'Pseudo F' _pst2_ = 'Pseudo T-Squared';
   run;
%mend;

/* --------------------------------------------------------- */
/*                                                           */
/* The macro TABPERM generates cluster-membership variables  */
/* for a specified number of clusters for each permutation.  */
/* PROC TABULATE gives the frequencies and means.            */
/* The arguments are as follows:                             */
/*                                                           */
/*    var     list of variables to cluster                   */
/*            (no "-" or ":" allowed)                        */
/*    id      id variable for proc cluster                   */
/*    meanfmt format for printing means in PROC TABULATE     */
/*    nclus   number of clusters desired                     */
/*    nperm   number of random permutations.                 */
/*                                                           */
/* --------------------------------------------------------- */
%macro TABPERM(var,id,meanfmt,nclus,nperm);

   /* ------CREATE DATA SETS GIVING CLUSTER MEMBERSHIP--------- */
   %do n=1 %to &nperm;
      proc tree data=_tree_&n noprint n=&nclus
                out=_out_&n(drop=clusname
                              rename=(cluster=_clus_&n));
         copy &var;
         id &id;
      run;

      proc sort;
         by &id &var;
      run;
   %end;

   /* ------MERGE THE CLUSTER VARIABLES------------------------ */
   data _merge_;
      merge
         %do n=1 %to &nperm;
            _out_&n
         %end;;
      by &id &var;
      length all_clus $ %eval(3*&nperm);
      %do n=1 %to &nperm;
         substr( all_clus, %eval(1+(&n-1)*3), 3) =
            put( _clus_&n, 3.);
      %end;
   run;

   /* ------ TABULATE CLUSTER COMBINATIONS------------ */
   proc sort;
      by _clus_:;
   run;
   proc tabulate order=data formchar='           ';
      class all_clus;
      var &var;
      table all_clus, n='FREQ'*f=5. mean*f=&meanfmt*(&var) /
         rts=%eval(&nperm*3+1);
   run;
%mend;

/* -TABULATE does not accept hyphens or colons in VAR lists- */
%let vlist=v1 v2 v3 v4 v5 v6 v7 v8;

title3 'Raw Data';

/* ------CLUSTER RAW DATA WITH AVERAGE LINKAGE-------------- */
%clusperm( teeth, &vlist, mammal, average, 10);

/* -----PLOT STATISTICS FOR THE LAST 20 LEVELS-------------- */
%plotperm(20, 10);

/* ------ANALYZE THE 4-CLUSTER LEVEL------------------------ */
%tabperm( &vlist, mammal, 9.1, 4, 10);

title3 'Standardized Data';

/*------CLUSTER STANDARDIZED DATA WITH AVERAGE LINKAGE------*/
%clusperm( teeth, &vlist, mammal, average std, 10);

/* -----PLOT STATISTICS FOR THE LAST 20 LEVELS-------------- */
%plotperm(20, 10);

/* ------ANALYZE THE 4-CLUSTER LEVEL------------------------ */
%tabperm( &vlist, mammal, 9.1, 4, 10);

