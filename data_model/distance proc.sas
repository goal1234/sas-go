

/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: distangs                                            */
/*   TITLE: Getting Started Example for PROC DISTANCE           */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Distance Matrix, Cluster Analysis                   */
/*   PROCS: DISTANCE, CLUSTER, PRINT                            */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: saswfk                UPDATE: July 25, 2010         */
/*     REF: PROC DISTANCE, Getting Started Example              */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

data Protein;
   length Country $ 14;
   input Country &$ RedMeat WhiteMeat Eggs Milk
                      Fish Cereal Starch Nuts FruitVeg;
   datalines;
Albania            10.1  1.4  0.5   8.9  0.2  42.3  0.6  5.5  1.7
Austria             8.9 14.0  4.3  19.9  2.1  28.0  3.6  1.3  4.3
Belgium            13.5  9.3  4.1  17.5  4.5  26.6  5.7  2.1  4.0
Bulgaria            7.8  6.0  1.6   8.3  1.2  56.7  1.1  3.7  4.2
Czechoslovakia      9.7 11.4  2.8  12.5  2.0  34.3  5.0  1.1  4.0
Denmark            10.6 10.8  3.7  25.0  9.9  21.9  4.8  0.7  2.4
E Germany           8.4 11.6  3.7  11.1  5.4  24.6  6.5  0.8  3.6
Finland             9.5  4.9  2.7  33.7  5.8  26.3  5.1  1.0  1.4
France             18.0  9.9  3.3  19.5  5.7  28.1  4.8  2.4  6.5
Greece             10.2  3.0  2.8  17.6  5.9  41.7  2.2  7.8  6.5
Hungary             5.3 12.4  2.9   9.7  0.3  40.1  4.0  5.4  4.2
Ireland            13.9 10.0  4.7  25.8  2.2  24.0  6.2  1.6  2.9
Italy               9.0  5.1  2.9  13.7  3.4  36.8  2.1  4.3  6.7
Netherlands         9.5 13.6  3.6  23.4  2.5  22.4  4.2  1.8  3.7
Norway              9.4  4.7  2.7  23.3  9.7  23.0  4.6  1.6  2.7
Poland              6.9 10.2  2.7  19.3  3.0  36.1  5.9  2.0  6.6
Portugal            6.2  3.7  1.1   4.9 14.2  27.0  5.9  4.7  7.9
Romania             6.2  6.3  1.5  11.1  1.0  49.6  3.1  5.3  2.8
Spain               7.1  3.4  3.1   8.6  7.0  29.2  5.7  5.9  7.2
Sweden              9.9  7.8  3.5   4.7  7.5  19.5  3.7  1.4  2.0
Switzerland        13.1 10.1  3.1  23.8  2.3  25.6  2.8  2.4  4.9
UK                 17.4  5.7  4.7  20.6  4.3  24.3  4.7  3.4  3.3
USSR                9.3  4.6  2.1  16.6  3.0  43.6  6.4  3.4  2.9
W Germany          11.4 12.5  4.1  18.8  3.4  18.6  5.2  1.5  3.8
Yugoslavia          4.4  5.0  1.2   9.5  0.6  55.9  3.0  5.7  3.2
;

title 'Protein Consumption in Europe';
proc distance data=Protein out=Dist method=Euclid;
   var interval(RedMeat--FruitVeg / std=Std);
   id Country;
run;

proc print data=Dist(obs=10);
   title2 'First 10 Observations in Output Data Set from PROC DISTANCE';
run;
title2;

ods graphics on;

proc cluster data=Dist method=Ward plots=dendrogram(height=rsq);
   id Country;
run;

*---Divorce Grounds ¨C the Jaccard Coefficient---*;


/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: distanx1                                            */
/*   TITLE: Documentation Example 1 for PROC DISTANCE           */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Distance Matrix, Cluster Analysis                   */
/*   PROCS: DISTANCE, CLUSTER, TREE, PRINT, SORT                */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: saswfk                UPDATE: July 25, 2010         */
/*     REF: PROC DISTANCE, Example 1                            */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

data divorce;
   length State $ 15;
   input State &$
         Incompatibility Cruelty Desertion Non_Support Alcohol
         Felony Impotence Insanity Separation @@;
   datalines;
Alabama          1 1 1 1 1 1 1 1 1    Alaska           1 1 1 0 1 1 1 1 0
Arizona          1 0 0 0 0 0 0 0 0    Arkansas         0 1 1 1 1 1 1 1 1
California       1 0 0 0 0 0 0 1 0    Colorado         1 0 0 0 0 0 0 0 0
Connecticut      1 1 1 1 1 1 0 1 1    Delaware         1 0 0 0 0 0 0 0 1
Florida          1 0 0 0 0 0 0 1 0    Georgia          1 1 1 0 1 1 1 1 0
Hawaii           1 0 0 0 0 0 0 0 1    Idaho            1 1 1 1 1 1 0 1 1
Illinois         0 1 1 0 1 1 1 0 0    Indiana          1 0 0 0 0 1 1 1 0
Iowa             1 0 0 0 0 0 0 0 0    Kansas           1 1 1 0 1 1 1 1 0
Kentucky         1 0 0 0 0 0 0 0 0    Louisiana        0 0 0 0 0 1 0 0 1
Maine            1 1 1 1 1 0 1 1 0    Maryland         0 1 1 0 0 1 1 1 1
Massachusetts    1 1 1 1 1 1 1 0 1    Michigan         1 0 0 0 0 0 0 0 0
Minnesota        1 0 0 0 0 0 0 0 0    Mississippi      1 1 1 0 1 1 1 1 0
Missouri         1 0 0 0 0 0 0 0 0    Montana          1 0 0 0 0 0 0 0 0
Nebraska         1 0 0 0 0 0 0 0 0    Nevada           1 0 0 0 0 0 0 1 1
New Hampshire    1 1 1 1 1 1 1 0 0    New Jersey       0 1 1 0 1 1 0 1 1
New Mexico       1 1 1 0 0 0 0 0 0    New York         0 1 1 0 0 1 0 0 1
North Carolina   0 0 0 0 0 0 1 1 1    North Dakota     1 1 1 1 1 1 1 1 0
Ohio             1 1 1 0 1 1 1 0 1    Oklahoma         1 1 1 1 1 1 1 1 0
Oregon           1 0 0 0 0 0 0 0 0    Pennsylvania     0 1 1 0 0 1 1 1 0
Rhode Island     1 1 1 1 1 1 1 0 1    South Carolina   0 1 1 0 1 0 0 0 1
South Dakota     0 1 1 1 1 1 0 0 0    Tennessee        1 1 1 1 1 1 1 0 0
Texas            1 1 1 0 0 1 0 1 1    Utah             0 1 1 1 1 1 1 1 0
Vermont          0 1 1 1 0 1 0 1 1    Virginia         0 1 0 0 0 1 0 0 1
Washington       1 0 0 0 0 0 0 0 1    West Virginia    1 1 1 0 1 1 0 1 1
Wisconsin        1 0 0 0 0 0 0 0 1    Wyoming          1 0 0 0 0 0 0 1 1
;

title 'Grounds for Divorce';
proc distance data=divorce method=djaccard absent=0 out=distjacc;
   var anominal(Incompatibility--Separation);
   id state;
run;

proc print data=distjacc(obs=10);
   id state; var alabama--georgia;
   title2 'First 10 States';
run;
title2;

proc cluster data=distjacc method=centroid
             pseudo outtree=tree;
   id state;
   var alabama--wyoming;
run;

proc tree data=tree noprint n=9 out=out;
   id state;
run;

proc sort;
   by state;
run;

data clus;
   merge divorce out;
   by state;
run;

proc sort;
   by cluster;
run;

proc print;
   id state;
   var Incompatibility--Separation;
   by cluster;
run;


*---Financial Data ¨C Stock Dividends---*;


/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: distanx2                                            */
/*   TITLE: Documentation Example 2 for PROC DISTANCE           */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Distance Matrix, Cluster Analysis                   */
/*   PROCS: DISTANCE, CLUSTER, PRINT                            */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: saswfk                UPDATE: July 25, 2010         */
/*     REF: PROC DISTANCE, Example 2                            */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

title 'Stock Dividends';

data stock;
   length Company $ 27;
   input Company &$  Div_1986 Div_1987 Div_1988 Div_1989 Div_1990;
   datalines;
Cincinnati G&E               8.4    8.2    8.4    8.1    8.0
Texas Utilities              7.9    8.9   10.4    8.9    8.3
Detroit Edison               9.7   10.7   11.4    7.8    6.5
Orange & Rockland Utilities  6.5    7.2    7.3    7.7    7.9
Kentucky Utilities           6.5    6.9    7.0    7.2    7.5
Kansas Power & Light         5.9    6.4    6.9    7.4    8.0
Union Electric               7.1    7.5    8.4    7.8    7.7
Dominion Resources           6.7    6.9    7.0    7.0    7.4
Allegheny Power              6.7    7.3    7.8    7.9    8.3
Minnesota Power & Light      5.6    6.1    7.2    7.0    7.5
Iowa-Ill Gas & Electric      7.1    7.5    8.5    7.8    8.0
Pennsylvania Power & Light   7.2    7.6    7.7    7.4    7.1
Oklahoma Gas & Electric      6.1    6.7    7.4    6.7    6.8
Wisconsin Energy             5.1    5.7    6.0    5.7    5.9
Green Mountain Power         7.1    7.4    7.8    7.8    8.3
;

proc distance data=stock method=dcorr out=distdcorr;
   var interval(div_1986 div_1987 div_1988 div_1989 div_1990);
   id company;
run;

proc print data=distdcorr;
   id company;
   title2 'Distance Matrix for 15 Utility Stocks';
run;
title2;

ods graphics on;

/* compute pseudo statistic versus number of clusters and create plot */
proc cluster data=distdcorr method=ward pseudo plots(only)=(psf dendrogram);
   id company;
run;

/* compute pseudo statistic versus number of clusters and create plot */
proc cluster data=distdcorr method=average pseudo plots(only)=(psf dendrogram);
   id company;
run;

ods graphics off;

