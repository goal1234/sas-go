
data sample;
  input x y;
  cards;
1 1
1 1
1 1
2 2
2 2
2 3
2 3
3 4
3 4
3 4
;

proc freq;
  tables x*y / all;


data grades;
  options linesize=78;
  infile 'grades.dat';
  input id $ hwk1 hwk2 hwk3 hwk4 mt1 mt2 final;
  hwk = (hwk1+hwk2+hwk3+hwk4)*1.25;
  mt = mt1+mt2;
  grade=.2*hwk+.4*mt+.4*final;
  drop hwk1 hwk2 hwk3 hwk4 mt1 mt2;
proc print;
  var id hwk mt final grade;
  format id $char2. hwk 3. mt 3. final 3. grade 3.;

*----regression---*;
  /* Stat 306 Assignment #6, March 13, 1985 */
data oxygen;
  infile 'oxygen.dat' firstobs=2;
  input day x1 x2 x3 x4 x5 o2up;
  y=log(o2up);
proc reg simple;
  model y=x3 x5 / ss1 ss2 seqb dw r;
  output out=d1 r=resid p=predy student=stdres;
proc rank data=d1 normal=blom out=d2;
  var stdres;
  ranks nscore;
data oxy2;
  set d2;
  resid1=lag1(resid);
  resid2=lag2(resid);
proc plot data=oxy2;
  plot nscore*stdres;
  plot stdres*predy;
  plot resid*resid1 / href=0 vref=0;
  plot resid*resid2 / href=0 vref=0;


*--corraltion---*;
  /* partial correlations Stat 306 Assignment #6, Mar 13, 1985 */
data oxygen;
  infile 'oxygen.dat' firstobs=2;
  input day x1 x2 x3 x4 x5 o2up;
  drop day;
  y=log(o2up);

proc iml;
  use oxygen ;
  read all into x ;
  n= nrow(x);
  xsum= x[+,];
  xpx=x`*x-xsum`*xsum/n;
  tem= diag(1/xpx);
  s=sqrt(tem);
  print s;
  corrm=s*xpx*s;
  /* correlation matrix */
  print corrm;
  tem=1-corrm[,{3}]##2;
   print tem;
  denom= (1- corrm[,{3}]##2)*({1}- corrm[{3},]##2);
  print denom;
  /*denom= sqrt((1- corrm[,{3}]##2)*({1}- corrm[{3},]##2));*/
  denom[{3},{3}]=1;
  print denom;
  partial3=(corrm- corrm[,{3}]* corrm[{3},])/denom;
  /* partial corr with var x3 partialled out */
  print partial3;
 
 

  *---anova---*;
  DATA thiamn;
  OPTIONS linesize=78;
  INFILE 'thiamn.dat' firstobs=2;
  INPUT grain $ contnt;
  LIST;
PROC MEANS;
PROC MEANS;
  BY grain NOTSORTED;
PROC PLOT;
  PLOT contnt*grain;
PROC GLM;
  CLASSES grain;
  MODEL contnt=grain;
  OUTPUT OUT=data1 P=pred R=resid;
PROC RANK DATA=data1 NORMAL=BLOM OUT=data2;
  VAR resid;
  RANKS resrnk;
PROC PLOT DATA=data2;
  PLOT resrnk*resid /VREF=0;
  PLOT resid*pred/ VREF=0;



  data survival;
  infile 'surv.dat' firstobs=2;
  input poison 1 trt $ 3 surv 5-8; 
  survtr=1./surv;
  list;
proc means;
  var surv survtr;
  by poison trt;
proc glm;
  classes poison trt;
  model surv=poison trt poison*trt;
  output out=d1 p=predsur r=resid;
proc rank data=d1 normal=blom out=d2;
  var resid;
  ranks nscore;
proc plot data=d2;
  plot nscore*resid;
  plot resid*predsur / vref=0;
  plot resid*poison;
  plot resid*trt;
  plot predsur*poison=trt;
proc glm;
  classes poison trt;
  model survtr=poison trt poison*trt;
  output out=d3 p=predtrs r=resid;
proc rank data=d3 normal=blom out=d4;
  var resid;
  ranks nscore;
proc plot data=d4;
  plot nscore*resid;
  plot resid*predtrs / vref=0;
  plot resid*poison;
  plot resid*trt;
  plot predtrs*poison=trt;


  *---logistic---*;
   /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: LOGISTIC                                            */
 /*   TITLE: Documentation Examples from PROC LOGISTIC           */
 /* PRODUCT: STAT                                                */
 /*  SYSTEM: ALL                                                 */
 /*    KEYS: REGR                                                */
 /*   PROCS: LOGISTIC                                            */
 /****************************************************************/


 /*-------------------- Example 0: Ingot Data --------------------
 | The data, taken from Cox and Snell (1989, pp 10-11), consists|
 | of the number, R, of ingots not ready for rolling, out of N  |
 | tested, for a number of combinations of heating time and     |
 | soaking time.
 ---------------------------------------------------------------*/
    data ingots;
       input heat soak r n;
    cards;
     7 1.0 0 10
     7 1.7 0 17
     7 2.2 0  7
     7 2.8 0 12
     7 4.0 0  9
    14 1.0 0 31
    14 1.7 0 43
    14 2.2 2 33
    14 2.8 0 31
    14 4.0 0 19
    27 1.0 1 56
    27 1.7 4 44
    27 2.2 0 21
    27 2.8 1 22
    27 4.0 1 16
    51 1.0 3 13
    51 1.7 0  1
    51 2.2 0  1
    51 4.0 0  1
    ;
    proc logistic data = ingots;
      model r/n = heat soak;



*---random variable---*;
	  data rng;
  options linesize=78 nodate nonumber pagesize=60 nocenter;
  retain seed 12345;
  nsim=1000;
  do isim=1 to nsim;
     j1=int(6*uniform(seed));
     j2=int(6*uniform(seed));
     j3=int(6*uniform(seed));
     output;
  end;
  drop seed nsim ;
/*proc print noobs;*/
proc univariate;
  var j1 j2 j3;
proc corr;
proc plot;
  plot j1*j2;
  plot j1*j3;
  plot j2*j3;
  plot isim*j1;

