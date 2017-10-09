

/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: gamgs                                               */
/*   TITLE: Getting Started Example for PROC GAM                */
/*    DESC: Patterns of Diabetes                                */
/*     REF: Sockett et al. 1987                                 */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Additive Model                                      */
/*   PROCS: GAM                                                 */
/*                                                              */
/* SUPPORT: Weijie Cai                                          */
/****************************************************************/

title 'Patterns of Diabetes';
data diabetes;
   input Age BaseDeficit CPeptide @@;
   logCP = log(CPeptide);
   datalines;
5.2    -8.1  4.8   8.8  -16.1  4.1  10.5   -0.9  5.2
10.6   -7.8  5.5  10.4  -29.0  5.0   1.8  -19.2  3.4
12.7  -18.9  3.4  15.6  -10.6  4.9   5.8   -2.8  5.6
1.9   -25.0  3.7   2.2   -3.1  3.9   4.8   -7.8  4.5
7.9   -13.9  4.8   5.2   -4.5  4.9   0.9  -11.6  3.0
11.8   -2.1  4.6   7.9   -2.0  4.8  11.5   -9.0  5.5
10.6  -11.2  4.5   8.5   -0.2  5.3  11.1   -6.1  4.7
12.8   -1.0  6.6  11.3   -3.6  5.1   1.0   -8.2  3.9
14.5   -0.5  5.7  11.9   -2.0  5.1   8.1   -1.6  5.2
13.8  -11.9  3.7  15.5   -0.7  4.9   9.8   -1.2  4.8
11.0  -14.3  4.4  12.4   -0.8  5.2  11.1  -16.8  5.1
5.1    -5.1  4.6   4.8   -9.5  3.9   4.2  -17.0  5.1
6.9    -3.3  5.1  13.2   -0.7  6.0   9.9   -3.3  4.9
12.5  -13.6  4.1  13.2   -1.9  4.6   8.9  -10.0  4.9
10.8  -13.5  5.1
;

ods graphics on;
proc gam data=diabetes;
   model logCP = spline(Age) spline(BaseDeficit);
run;

*---Generalized Additive Model with Binary Data---*;


/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: gamex1                                              */
/*   TITLE: Example 1 for PROC GAM                              */
/*    DESC: Kyphosis data                                       */
/*     REF: Bell et al. 1994                                    */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Generalized Additive Model                          */
/*   PROCS: GAM, GENMOD                                         */
/*                                                              */
/* SUPPORT: Weijie Cai                                          */
/****************************************************************/

title 'Comparing PROC GAM with PROC GENMOD';
data kyphosis;
   input Age StartVert NumVert Kyphosis @@;
   datalines;
71  5  3  0     158 14 3 0    128 5   4 1
2   1  5  0     1   15 4 0    1   16  2 0
61  17 2  0     37  16 3 0    113 16  2 0
59  12 6  1     82  14 5 1    148 16  3 0
18  2  5  0     1   12 4 0    243 8   8 0
168 18 3  0     1   16 3 0    78  15  6 0
175 13 5  0     80  16 5 0    27  9   4 0
22  16 2  0     105 5  6 1    96  12  3 1
131 3  2  0     15  2  7 1    9   13  5 0
12  2 14  1     8   6  3 0    100 14  3 0
4   16 3  0     151 16 2 0    31  16  3 0
125 11 2  0     130 13 5 0    112 16  3 0
140 11 5  0     93  16 3 0    1   9   3 0
52  6  5  1     20  9  6 0    91  12  5 1
73  1  5  1     35  13 3 0    143 3   9 0
61  1  4  0     97  16 3 0    139 10  3 1
136 15 4  0     131 13 5 0    121 3   3 1
177 14 2  0     68  10 5 0    9   17  2 0
139 6  10 1     2   17 2 0    140 15  4 0
72  15 5  0     2   13 3 0    120 8   5 1
51  9  7  0     102 13 3 0    130 1   4 1
114 8  7  1     81  1  4 0    118 16  3 0
118 16 4  0     17  10 4 0    195 17  2 0
159 13 4  0     18  11 4 0    15  16  5 0
158 15 4  0     127 12 4 0    87  16  4 0
206 10 4  0     11  15 3 0    178 15  4 0
157 13 3  1     26  13 7 0    120 13  2 0
42  6  7  1     36  13 4 0
;

proc genmod data=kyphosis descending;
   model Kyphosis = Age StartVert NumVert/link=logit dist=binomial;
run;

title 'Comparing PROC GAM with PROC GENMOD';
proc gam data=kyphosis;
   model Kyphosis (event='1') = spline(Age      ,df=3)
                                spline(StartVert,df=3)
                                spline(NumVert  ,df=3) / dist=binomial;
run;

title 'PROC GAM with Approximate Analysis of Deviance';
proc gam data=kyphosis;
   model Kyphosis (event='1') = spline(Age      ,df=3)
                                spline(StartVert,df=3)
                                spline(NumVert  ,df=3) /
                                    dist=binomial anodev=norefit;
run;
ods graphics on;

proc gam data=kyphosis plots=components(clm commonaxes);
   model Kyphosis (event='1') = spline(Age      ,df=3)
                                spline(StartVert,df=3)
                                spline(NumVert  ,df=3) / dist=binomial;
run;

ods graphics off;
title 'Comparing PROC GAM with PROC GENMOD';
proc genmod data=kyphosis descending;
   model kyphosis = Age       Age      *Age
                    StartVert StartVert*StartVert
                    NumVert   NumVert  *NumVert /
                        link=logit  dist=binomial;
run;

*---Poisson Regression Analysis of Component Reliability---*;


/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: gamex2                                              */
/*   TITLE: Example 2 for PROC GAM                              */
/*    DESC: Reliability data                                    */
/*     REF:                                                     */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Generalized Additive Model: Poisson Link            */
/*   PROCS: GAM                                                 */
/*                                                              */
/* SUPPORT: Weijie Cai                                          */
/****************************************************************/

title 'Analysis of Component Reliability';
data equip;
   input year month removals @@;
   datalines;
1987   1  2 1987   2  4 1987   3  3
1987   4  3 1987   5  3 1987   6  8
1987   7  2 1987   8  6 1987   9  3
1987  10  9 1987  11  4 1987  12 10
1988   1  4 1988   2  6 1988   3  4
1988   4  4 1988   5  3 1988   6  5
1988   7  3 1988   8  4 1988   9  5
1988  10  3 1988  11  6 1988  12  3
1989   1  2 1989   2  6 1989   3  1
1989   4  5 1989   5  5 1989   6  4
1989   7  2 1989   8  2 1989   9  2
1989  10  5 1989  11  1 1989  12 10
1990   1  3 1990   2  8 1990   3 12
1990   4  7 1990   5  3 1990   6  2
1990   7  4 1990   8  3 1990   9  0
1990  10  6 1990  11  6 1990  12  6
;

title2 'Two-way model';
proc genmod data=equip;
   class year month;
   model removals=year month / dist=Poisson link=log type3;
run;

title2 'One-way model';
proc gam data=equip;
   class month;
   model removals=param(month) / dist=Poisson;
   output out=est p;
run;

proc sort data=est;by month;run;

proc sgplot data=est;
   title "Predicted Seasonal Trend";
   yaxis label="Number of Removals";
   xaxis integer values=(1 to 12);
   scatter x=Month y=Removals / name="points"
                                legendLabel="Removals";
   series  x=Month y=p_Removals / name="line"
                                  legendLabel="Predicted Removals"
                                  lineattrs = GRAPHFIT;
   discretelegend "points" "line";
run;

title 'Analysis of Component Reliability';
title2 'Spline model';
proc gam data=equip;
   model removals=spline(month) / dist=Poisson method=gcv;
run;
ods graphics on;

proc gam data=equip plots=components(clm);
   model removals=spline(month) / dist=Poisson method=gcv;
run;

ods graphics off;

*---Comparing PROC GAM with PROC LOESS---*;


/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: gamex3                                              */
/*   TITLE: Example 3 for PROC GAM                              */
/*    DESC: simulated data                                      */
/*     REF:                                                     */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Additive Model                                      */
/*   PROCS: GAM, LOESS                                          */
/*                                                              */
/* SUPPORT: Weijie Cai                                          */
/****************************************************************/

data ExperimentA;
   format Temperature f4.0 Catalyst f6.3 Yield f8.3;
   input Temperature Catalyst Yield @@;
   datalines;
80  0.005 6.039  80 0.010 4.719  80 0.015 6.301
80  0.020 4.558  80 0.025 5.917  80 0.030 4.365
80  0.035 6.540  80 0.040 5.063  80 0.045 4.668
80  0.050 7.641  80 0.055 6.736  80 0.060 7.255
80  0.065 5.515  80 0.070 5.260  80 0.075 4.813
80  0.080 4.465  90 0.005 4.540  90 0.010 3.553
90  0.015 5.611  90 0.020 4.586  90 0.025 6.503
90  0.030 4.671  90 0.035 4.919  90 0.040 6.536
90  0.045 4.799  90 0.050 6.002  90 0.055 6.988
90  0.060 6.206  90 0.065 5.193  90 0.070 5.783
90  0.075 6.482  90 0.080 5.222 100 0.005 5.042
100 0.010 5.551 100 0.015 4.804 100 0.020 5.313
100 0.025 4.957 100 0.030 6.177 100 0.035 5.433
100 0.040 6.139 100 0.045 6.217 100 0.050 6.498
100 0.055 7.037 100 0.060 5.589 100 0.065 5.593
100 0.070 7.438 100 0.075 4.794 100 0.080 3.692
110 0.005 6.005 110 0.010 5.493 110 0.015 5.107
110 0.020 5.511 110 0.025 5.692 110 0.030 5.969
110 0.035 6.244 110 0.040 7.364 110 0.045 6.412
110 0.050 6.928 110 0.055 6.814 110 0.060 8.071
110 0.065 6.038 110 0.070 6.295 110 0.075 4.308
110 0.080 7.020 120 0.005 5.409 120 0.010 7.009
120 0.015 6.160 120 0.020 7.408 120 0.025 7.123
120 0.030 7.009 120 0.035 7.708 120 0.040 5.278
120 0.045 8.111 120 0.050 8.547 120 0.055 8.279
120 0.060 8.736 120 0.065 6.988 120 0.070 6.283
120 0.075 7.367 120 0.080 6.579 130 0.005 7.629
130 0.010 7.171 130 0.015 5.997 130 0.020 6.587
130 0.025 7.335 130 0.030 7.209 130 0.035 8.259
130 0.040 6.530 130 0.045 8.400 130 0.050 7.218
130 0.055 9.167 130 0.060 9.082 130 0.065 7.680
130 0.070 7.139 130 0.075 7.275 130 0.080 7.544
140 0.005 4.860 140 0.010 5.932 140 0.015 3.685
140 0.020 5.581 140 0.025 4.935 140 0.030 5.197
140 0.035 5.559 140 0.040 4.836 140 0.045 5.795
140 0.050 5.524 140 0.055 7.736 140 0.060 5.628
140 0.065 6.644 140 0.070 3.785 140 0.075 4.853
140 0.080 6.006
;

proc sort data=ExperimentA;
   by Temperature Catalyst;
run;

proc template;
   define statgraph surface;
      dynamic _X _Y _Z _T;
      begingraph;
         entrytitle _T;
         layout overlay3d/
            xaxisopts=(linearopts=(tickvaluesequence=
                       (start=85 end=135 increment=25)))
            yaxisopts=(linearopts=(tickvaluesequence=
                       (start=0 end=0.08 increment=0.04)))
            rotate=30 cube=false;
         surfaceplotparm x=_X y=_Y z=_Z;
         endlayout;
      endgraph;
   end;
run;

proc sgrender data=ExperimentA template=surface;
   dynamic _X='Temperature' _Y='Catalyst' _Z='Yield' _T='Raw Data';
run;

ods output ScoreResults=PredLOESS;
proc loess data=ExperimentA;
   model Yield = Temperature Catalyst
                 / scale=sd select=gcv degree=2;
   score;
run;

proc gam data=PredLoess;
   model Yield = loess(Temperature) loess(Catalyst) / method=gcv;
   output out=PredGAM p=Gam_p_;
run;

proc template;
   define statgraph surface1;
      begingraph;
         entrytitle "Fitted Surface";
         layout lattice/columns=2;
            layout
            overlay3d/xaxisopts=(linearopts=(tickvaluesequence=
                                (start=85 end=135 increment=25)))
                     yaxisopts=(linearopts=(tickvaluesequence=
                                (start=0 end=0.08 increment=0.04)))
                     zaxisopts=(label="P_Yield")
                     rotate=30 cube=0;
               entry "PROC LOESS"/location=outside valign=top
                                  textattrs=graphlabeltext;
               surfaceplotparm x=Temperature y=Catalyst z=p_Yield;
            endlayout;
            layout
            overlay3d/xaxisopts=(linearopts=(tickvaluesequence=
                                (start=85 end=135 increment=25)))
                     yaxisopts=(linearopts=(tickvaluesequence=
                                (start=0 end=0.08 increment=0.04)))
                     rotate=30 cube=0
                     zaxisopts=(label="P_Yield")
                     rotate=30 cube=0;
               entry "PROC GAM"/location=outside valign=top
                                textattrs=graphlabeltext;
               surfaceplotparm x=Temperature y=Catalyst z=Gam_p_Yield;
            endlayout;
         endlayout;
      endgraph;
   end;
run;

proc sgrender data=PredGAM template=surface1;
run;

proc template;
   define statgraph projection;
      begingraph;
         entrytitle "Cross Sections of Fitted Surfaces";
         layout lattice/rows=2 columndatarange=unionall
                       columngutter=10;
            columnAxes;
               columnAxis / display=all griddisplay=auto_on;
            endColumnAxes;

            layout overlay/
               xaxisopts=(display=none)
               yaxisopts=(label="LOESS Prediction"
               linearopts=(viewmin=2 viewmax=10));
               seriesplot x=Catalyst y=p_Yield /
                  group=temperature
                  name="Temperature";
            endlayout;

            layout overlay/
               xaxisopts=(display=none)
               yaxisopts=(label="GAM Prediction"
               linearopts=(viewmin=2 viewmax=10));
               seriesplot x=Catalyst y=Gam_p_Yield /
                  group=temperature
                  name="Temperature";
            endlayout;

            columnheaders;
               discreteLegend "Temperature" / title = "Temperature";
            endcolumnheaders;

         endlayout;
      endgraph;
   end;
run;

proc sgrender data=PredGAM template=projection;
run;

data ExperimentB;
   format Temperature f4.0 Catalyst f6.3 Yield f8.3;
   input Temperature Catalyst Yield @@;
   datalines;
80  0.005  9.115  80 0.010  9.275  80 0.015  9.160
80  0.020  7.065  80 0.025  6.054  80 0.030  4.899
80  0.035  4.504  80 0.040  4.238  80 0.045  3.232
80  0.050  3.135  80 0.055  5.100  80 0.060  4.802
80  0.065  8.218  80 0.070  7.679  80 0.075  9.669
80  0.080  9.071  90 0.005  7.085  90 0.010  6.814
90  0.015  4.009  90 0.020  4.199  90 0.025  3.377
90  0.030  2.141  90 0.035  3.500  90 0.040  5.967
90  0.045  5.268  90 0.050  6.238  90 0.055  7.847
90  0.060  7.992  90 0.065  7.904  90 0.070 10.184
90  0.075  7.914  90 0.080  6.842 100 0.005  4.497
100 0.010  2.565 100 0.015  2.637 100 0.020  2.436
100 0.025  2.525 100 0.030  4.474 100 0.035  6.238
100 0.040  7.029 100 0.045  8.183 100 0.050  8.939
100 0.055  9.283 100 0.060  8.246 100 0.065  6.927
100 0.070  7.062 100 0.075  5.615 100 0.080  4.687
110 0.005  3.706 110 0.010  3.154 110 0.015  3.726
110 0.020  4.634 110 0.025  5.970 110 0.030  8.219
110 0.035  8.590 110 0.040  9.097 110 0.045  7.887
110 0.050  8.480 110 0.055  6.818 110 0.060  7.666
110 0.065  4.375 110 0.070  3.994 110 0.075  3.630
110 0.080  2.685 120 0.005  4.697 120 0.010  4.268
120 0.015  6.507 120 0.020  7.747 120 0.025  9.412
120 0.030  8.761 120 0.035  8.997 120 0.040  7.538
120 0.045  7.003 120 0.050  6.010 120 0.055  3.886
120 0.060  4.897 120 0.065  2.562 120 0.070  2.714
120 0.075  3.141 120 0.080  5.081 130 0.005  8.729
130 0.010  7.460 130 0.015  9.549 130 0.020 10.049
130 0.025  8.131 130 0.030  7.553 130 0.035  6.191
130 0.040  6.272 130 0.045  4.649 130 0.050  3.884
130 0.055  2.522 130 0.060  4.366 130 0.065  3.272
130 0.070  4.906 130 0.075  6.538 130 0.080  7.380
140 0.005  8.991 140 0.010  8.029 140 0.015  8.417
140 0.020  8.049 140 0.025  4.608 140 0.030  5.025
140 0.035  2.795 140 0.040  3.123 140 0.045  3.407
140 0.050  4.183 140 0.055  3.750 140 0.060  6.316
140 0.065  5.799 140 0.070  7.992 140 0.075  7.835
140 0.080  8.985
;

proc sort data=ExperimentB;
   by Temperature Catalyst;
run;

proc sgrender data=ExperimentB template=surface;
   dynamic _X='Temperature' _Y='Catalyst' _Z='Yield' _T='Raw Data';
run;

ods output ScoreResults=PredLOESSb;
proc loess data=ExperimentB;
   model Yield = Temperature Catalyst
                 / scale=sd degree=2 select=gcv;
   score;
run;
ods output close;

proc gam data=PredLOESSb;
   model Yield = loess(Temperature) loess(Catalyst)
                 / method=gcv;
   output out=PredGAMb p=Gam_p_;
run;

proc sgrender data=PredGAMb template=surface1;
run;

data PredGAM;
   set PredGAM;
   rename Yield=Yield_a;
run;

data PredGAMb;
   set PredGAMb;
   set PredGAM(keep=Yield_a);
run;

proc template;
   define statgraph scatter2;
      dynamic _X _Y1 _Y2;
      begingraph;
         entrytitle "Scatter Plots of Yield by Catalyst";
         layout lattice/rows=2 columndatarange=unionall
                        rowdatarange=unionall
                        columngutter=15;
            columnAxes;
               columnAxis / display=all griddisplay=auto_on;
            endColumnAxes;

            layout overlay/
               xaxisopts=(display=none)
               yaxisopts=(label="Yield of Experiment A"
               linearopts=(viewmin=2 viewmax=10));
               scatterplot x=_X y=_Y1;
            endlayout;

            layout overlay/
               xaxisopts=(display=none)
               yaxisopts=(label="Yield of Experiment B"
               linearopts=(viewmin=2 viewmax=10));
               scatterplot x=_X y=_Y2;
            endlayout;

         endlayout;
      endgraph;
   end;
run;

proc sgrender data=PredGAMb template=scatter2;
   dynamic _X='Catalyst' _Y1='Yield_a' _Y2='Yield';
run;

ods graphics off;

