*===A one-to-many merge with common variables that are not the BY variables will have values from the many data set after the first observation===*;
/* Create the "many" data set, SCORES, that has multiple observations per ID.        */
/* It has some incorrect names.                                                      */

data scores;
   input id name :$8. score;
   datalines;
1 Jo 100
1 Jo 90
1 Jo 95
2 John 89
2 John 92
;
run;

/* Create the "one" data set, NAMES, that has one observation per ID.  It has        */
/* corrected values for names.                                                       */

data names;
   input id name :$8.;
   datalines;
1 Joanna
2 Jon
;
run;

/* First merge with the common variable and note how the values from the second and */
/* subsequent observations of the "many" data set are not overwritten.              */

data results_common_variable;
   merge scores names;
   by id;
run;
title "Results from Common Variable";
proc print; 
run;

/* Rename the variable from the "many" data set so that the value from the "one" data */
/* set is carried down the by-group.                                                  */

data results_renamed_variable;
   merge scores(rename=(name=old_name)) names;
   by id;
run;
title "Results from Renamed Variable";
proc print; 
run;

*===Counting the number of observations in a BY-Group===*;
/* Create sample data */

data old;
  input state $ accttot;
datalines;
ca     7000
ca     6500
ca     5800
nc     4800
nc     3640
sc     3520
va     4490
va     8700
va     2850
va     1111
;

proc sort data=old;
  by state;
run;

/* To get the number of observations in each group of states, start */
/* a counter on the first observation of each BY-Group. The last    */
/* observation in the BY-Group contains the total number of  	    */ 
/* observations and is output to the data set.                      */

data new;
  set old (drop= accttot);
  by state;
  if first.state then count=0;
  count+1;
  if last.state then output;
run;

proc print; 
run;

/* Alternative approach using PROC FREQ to generate the same output */

proc freq;                                                                                                                              
 tables state / out=new(drop=percent);                                                                                                  
run;

*===Perturbation of risk factors in a covariance simulation analysis in SAS? Risk Dimension===*;
/*
   This simple example compares a covariance-based Monte Carlo simulation across multiple
   simulation horizons with the same calculation performed in SAS/IML.

   See also the "Static Covariance Simulation" section in the SAS Risk Dimensions
   Procedures Guide at http://support.sas.com/documentation/onlinedoc/riskdimen/index.html.
*/



* Specify time horizons in a macro variable;
%let horizons=1 2 3 12 30;

* Specify covariance data;
data cv;
  format _type_ $3. _name_ $3. rf1 8.6 rf2 8.6 rf3 8.6;
  input _type_ $ _name_ $ rf1 rf2 rf3;
  datalines;
COV rf1 0.01631 0.00760 0.00901
COV rf2 0.00760 0.00613 0.00732
COV rf3 0.00901 0.00732 0.01370
STD   . 0.12770 0.07831 0.11705
;
run;

* Specify current market data (that is, base-case values for the risk factors);
data curr;
  rf1=50;
  rf2=49;
  rf3=51;
run;

* Specify portfolio positions;
data inst;
  format instid $12. insttype $6.;
  input instid $ insttype $;
  datalines;
position01 asset
;
run;



* Create risk environment and register risk factor variables;
proc risk;
  env new=env;
  declare riskfactors=(rf1 num var label="Risk Factor 1",
                       rf2 num var label="Risk Factor 2",
                       rf3 num var label="Risk Factor 3");
  env save;
run;

* Define a pricing method to value the portfolio instrument;
proc compile env=env outlib=env;
  method asset_price kind=price;
    _value_=max(rf1,rf2,rf3);
  endmethod;
quit;



* Define and run a covariance simulation analysis project;
proc risk;
  env open=env;
  instrument asset methods=(price asset_price);
  marketdata cv file=cv type=covariance;
  marketdata curr file=curr type=current;
  instdata inst file=inst format=simple;
  sources inst inst;
  read sources=inst out=inst;
  simulation simcv
    data=cv
    method=cov
    horizon=(&horizons)
    ndraw=50;
  project simcv
    analysis=simcv
    data=(curr cv)
    portfolio=inst
    options=(shocks simstate)
    outlib=work;
  runproject simcv
    endproject=states;
run;
proc print data=simstate noobs;
  title1 "Perturbed Risk Factor Values from SAS Risk Dimensions";
  title2 "Work.SimState";
  var simulationtime simulationreplication rf1 rf2 rf3;
  where simulationreplication le 3 or simulationreplication eq 50;
run;


* Store the random shocks output data into a vector that is used to create a 
  perturbation matrix; 
data d;
  set shocks (keep=_z_);
run;

* Extract the numbers of horizons and simulation replications, and assign them macro
  variables to use later in calculations;
data _null_;
  set simstate end=last;
  if last then do;
    call symput('nhorizon',simulationtime);
    call symput('nsimrep',simulationreplication);
  end;
run;

* Extract the number of risk factors from the SAS Risk Dimensions output and assign
  it to a macro variable to use in later calculations;
proc contents data=states_v(drop=statenumber analysisnumber analysispart
  simulationtime simulationreplication _date_) out=rflist(keep=name) noprint;
run;
proc sql noprint;
  select count(name) into: nrf from rflist;
quit;

* Remove the labels from the covariance matrix so that only the covariance values remain;
data cv_vals;
  set cv;
  where upcase(_type_) eq 'COV';
  drop _type_ _name_;
run;

proc iml;

  * Perform a Cholesky decomposition on the covariance matrix;
  use cv_vals var _all_;
  read all var _all_ into cv_vals;
  U=root(cv_vals);
  L=U`;

  * Store the lower Cholesky root into a block diagonal matrix that is based on the 
    numbers of simulation horizons and simulation replications. This block diagonal 
    matrix is needed to create the perturbation vector;
  do i=1 to &nhorizon;
    do j=1 to &nsimrep;
      if i=1 & j=1 then blockL=L;
      else blockL=block(L,blockL);
    end;
  end;

  * Read in the shocks vector, which is organized by horizon by simulation replication;
  use d var _all_;
  read all var _all_ into d;

  * Compute the perturbation vector;
  p=blockL*d;

  * Output the perturbation vector to a data set;
  create p from p [colname='p'];
  append from p;
quit;
run;

* Restructure the perturbation vector to have a row for each risk factor and a column
  for each simulation horizon and for each simulation replication;

* Set up indexes for the perturbation vector;
data indx;
  label rfnum="Risk Factor Number"
        simulationtime="Simulation Time"
        simulationreplication="Simulation Replication";
  do simulationreplication=1 to &nsimrep;
    do simulationtime=1 to &nhorizon;
      do rfnum=1 to &nrf;
        output;
      end;
    end;
  end;
run;

* Merge the indexes with the perturbation vector; 
data indxp;
  merge indx p;
  label p="Perturbation";
  underscore="_";   * Underscore is used to label columns in a transpose later;
run;

* Re-sort the peturbation vector by the risk-factor index;
proc sort data=indxp out=indxprf;
  by rfnum;
run;
proc print data=indxprf noobs label;
  title1 "Perturbation Vector";
  title2 "Indexed for Risk Factors, Simulation Replications, and Horizons";
  title3 "Work.SMS";
  var rfnum simulationreplication simulationtime p;
run;

* Transpose the perturbation vector into a perturbation matrix that is structured as follows
  for later calculations: Row=[risk-factor-index] by Column=[horizon * simrep];
proc transpose data=indxprf out=indxprft prefix=time_rep_;
  var p;
  by rfnum;
  id simulationtime underscore simulationreplication;
run;

* Remove the labels and indexes from the perturbation matrix so that only the
  perturbation values remain;
data pmat;
  set indxprft (drop=rfnum _name_ _label_);
run;
proc print data=pmat noobs;
  title1 "Perturbation Matrix that is Used by SAS/IML";
  title2 "Work.PMat";
run;

proc iml;

  * Read in the perturbation matrix;
  use pmat var _all_;
  read all var _all_ into pmat;
  pmat=pmat`;

  * Get base-case values from current market data;
  use curr var _all_;
  read all var _all_ into b;

  * The horizon vector is based on the simulation horizon macro variable;
  h={&horizons};

  * Initialize output matrices;
  ind={0 0};    * the ind matrix holds the simrep and horizon numbers;
  rf=b*0;       * the rf matrix holds the simulated risk factor values;
  do i=1 to &nsimrep*&nhorizon-1;
    ind=ind//{0 0};
    rf=rf//b*0;
  end;

  * Perturb risk factors for each horizon and simulation replication;
  cntr=0;                   * row number for risk factor and perturbation matrices;
  do i=1 to &nsimrep;       * loop through simulation replications;
    do j=1 to &nhorizon;    * loop through horizon numbers;
      cntr=cntr+1;          * increment to next row;
      ind[cntr,1]=j;        * horizon number;
      ind[cntr,2]=i;        * simulation replication number;
      if j=1 then do;       * if first horizon, perturb the base-case risk factor value;
        rf[cntr,]=b#exp(sqrt(h[j]-0)*pmat[cntr,]);
      end;
      else do;              * otherwise perturb the previous horizon's rf value;
        rf[cntr,]=rf[cntr-1,]#exp(sqrt(h[j]-h[j-1])*pmat[cntr,]); * perturb risk factors;
      end;
    end;                    * end horizon loop;
  end;                      * end sim rep loop;
  
  * Create an output data set that uses the same data structure as the SimState table;
  rfout=ind||rf;
  varnames={'simulationtime' 'simulationreplication' 'rf1' 'rf2' 'rf3'};
  create ss from rfout [colname=varnames];
  append from rfout;
quit;
run;
proc print data=ss noobs label;
  title1 "Perturbed Risk Factor Values from SAS/IML";
  title2 "Work.SS";
  label simulationtime="Simulation Time"
        simulationreplication="Simulation Replication";
  var simulationtime simulationreplication rf1 rf2 rf3;
  where simulationreplication le 3 or simulationreplication eq 50;
run;


* Compare IML results to the SimState table;
proc compare data=simstate compare=ss criterion=1e-12;
  var simulationtime simulationreplication rf1 rf2 rf3;
run;

*===Missing values in common variables in a one-to-many merge can overwrite nonmissing values===;
/*Data set one has missing values for age after the first value for each ID*/
data one;
input id age score;
datalines;
1 11 90
1 . 100
1 . 95
2 9 80
2 . 100
;
data two;
input id name $ age;
datalines;
1 Sarah 8
2 John 10
;
run;

/*A regular merge will result in the missing values be written to the output.*/
data merge1;
merge one two;
by id;
run;

proc print;
run;

/*In this merge, we check for missing values and use the previous age for the ID if the*/
/*age is missing.*/

data merge2 (drop=tempage);
merge one  two;
by id;
retain tempage;
if first.id then tempage = .;
if age = . then age = tempage;
else tempage = age;
run;
proc print;
run;

*===PROC X12 stops processing when the number of missing values exceeds 80===*;

*===BY-group processing in PROC IML===*;
data pottery;
        input Site X Fe Mg Ca Na;
        datalines;
      1 14.4 7.00 4.30 0.15 0.51
      1 13.8 7.08 3.43 0.12 0.17
      1 14.6 7.09 3.88 0.13 0.20
      1 11.5 6.37 5.64 0.16 0.14
      1 13.8 7.06 5.34 0.20 0.20
      1 10.9 6.26 3.47 0.17 0.22
      1 10.1 4.26 4.26 0.20 0.18
      1 11.6 5.78 5.91 0.18 0.16
      1 11.1 5.49 4.52 0.29 0.30
      1 13.4 6.92 7.23 0.28 0.20
      1 12.4 6.13 5.69 0.22 0.54
      1 13.1 6.64 5.51 0.31 0.24
      1 12.7 6.69 4.45 0.20 0.22
      1 12.5 6.44 3.94 0.22 0.23
      2 11.8 5.44 3.94 0.30 0.04
      2 11.6 5.39 3.77 0.29 0.06
      3 18.3 1.28 0.67 0.03 0.03
      3 15.8 2.39 0.63 0.01 0.04
      3 18.0 1.50 0.67 0.01 0.06
      3 18.0 1.88 0.68 0.01 0.04
      3 20.8 1.51 0.72 0.07 0.10
      4 17.7 1.12 0.56 0.06 0.06
      4 18.3 1.14 0.67 0.06 0.05
      4 16.7 0.92 0.53 0.01 0.05
      4 14.8 2.74 0.67 0.03 0.05
      4 19.1 1.64 0.60 0.10 0.03
      ;

proc means sum;
        by site;
        var x fe;
        run;

proc iml;
        use pottery;
        read all var{site x fe} into a;

unique_rows=uniqueby(a,1,1:nrow(a)); 
      
        do i=1 to nrow(unique_rows);
          /* Next line is for the last BY group */
          if i=nrow(unique_rows) then index=unique_rows[i]:nrow(a);
          else index=unique_rows[i]:unique_rows[i+1]-1; 
          submat=a[index,];

  sum=sum//submat[+,2:3];
      
end;
print sum;
quit;

*===Collapse observations within a BY group into a single observation===*;
/* Create sample data */

data students;
   input name:$ score;
   datalines;
Deborah      89
Deborah      90
Deborah      95
Martin       90
Stefan       89
Stefan       76
;
run;

data scores(keep=name score1-score3);

   /* RETAIN prevents these variables from being set to missing at the top of */
   /* the DATA step with each iteration                                       */
   retain name score1-score3;

   /* An ARRAY statement is used to name the new variables */
   array scores(*) score1-score3;
   set students;
   by name;
   if first.name then do;
      i=1;

      /* Clear the array so that values from the last BY group are not carried forward */
      call missing (of scores(*));
   end;

   /* Assign the values to the array elements */
   scores(i)=score;
   if last.name then output;
   i+1;
run;

proc print;
run;


/* Alternate method using PROC TRANSPOSE to yield the same result */

proc transpose data=students out=new(drop=_name_) prefix=score;                                                                                       
   by name;                                                                                                                               
   var score; 
run;

*===Assign values evenly throughout a BY-Group===*;
data test;
  infile datalines truncover;
  input branch num_b num_c custid $  b1  b2 b3;
datalines;
1111 2 8 A       12817   6886
1111 2 8 B       12817   6886
1111 2 8 C       12817   6886
1111 2 8 D       12817   6886
1111 2 8 E       12817   6886
1111 2 8 F       12817   6886
1111 2 8 G       12817   6886
1111 2 8 H       12817   6886
2222 3 11 N       12309   2209    6054
2222 3 11 O       12309   2209    6054
2222 3 11 P       12309   2209    6054
2222 3 11 Q       12309   2209    6054
2222 3 11 R       12309   2209    6054
2222 3 11 S       12309   2209    6054
2222 3 11 T       12309   2209    6054
2222 3 11 U       12309   2209    6054
2222 3 11 V       12309   2209    6054
2222 3 11 W       12309   2209    6054
2222 3 11 X       12309   2209    6054
;

proc sort data=test;
  by branch;
run;

/* Assign B1-B3 to an array for ease of grouping and reference. Since NUM_B      */
/* represents the number of variables in the array that are populated and        */
/* NUM_C is the total number of observations in the BY-Group, CT is computed     */
/* to know how many values from B1-B3 can be assigned per BY-Group. LEFTOVER     */
/* is computed to know how many extra values exist after the values are assigned */
/* equally within the BY-Group.                                                  */

data test;
  set test;
  by branch;
  retain leftover ct i custleft;
  array banker(*) b1-b3;
  if first.branch then do;
    ct=int(num_c/num_b);
    i=1;
    custleft=num_c;
    leftover=mod(num_c,num_b);
  end;

  /* ASSIGN is the variable that is created holding one of the array values. */ 
  /* CT is the number of observations left to assign that value to.          */
  assign=banker(i);
  ct=ct-1;
  custleft=custleft-1;

  /* If CT=0 then determine which category CUSTLEFT falls into and compute */  
  /* variables accordingly.                                                */
  if ct=0 then do;
    if custleft gt leftover then do;
      i=i+1;
      ct=int(num_c/num_b);
    end;
    if custleft lt leftover then do;
      i=i+1;
      ct=1;
    end;
    if custleft eq leftover then do;
      ct=1;
      I=1;
    end;
  end;

  /* Comment out to see these variables in the PROC PRINT as well */
  drop leftover ct i custleft; 
run;

proc print;
run;

*===Compute the number of observations and the average value of a variable within a BY-Group===*;
data test;
  input i j x;
datalines;
1 1 123
1 1 3245
1 2 23
1 2 543
1 2 87
1 3 90
2 1 88
2 1 86
;


/* When the first observation in each BY-Group is read, the variables JSUB and  */
/* FREQ are initialized to zero and with each subsequent observation in the     */
/* BY-Group, FREQ is incremented by one and JSUB is incremented by the value of */
/* X. When the last observation in the BY-Group is read, AVER is created by     */
/* dividing JSUB by FREQ to determine the average value for the group.          */

data jsubtot (keep=i j freq aver);
  set test;
  by i j;
  retain jsub freq;
  if first.j then do;
    jsub=0;
    freq=0;
  end;
  jsub + x;
  freq + 1;
  if last.j then do;
    aver=jsub/freq;
    output;
  end;
run;

proc print;
run;

/* Alternate approach using PROC MEANS to generate the same output */

proc means data=test noprint;
  by i j;
  output out=i_j(drop=_FREQ_ _TYPE_) n=freq mean=aver;
run;


*===Calculate the percentage that one observation contributes to the total of a BY-group===*;
data sales;                                                      
  input @1 region $char8.  @10 repid 4.  @15 amount 10. ;     
  format amount dollar12.;                                    
  datalines;                                                      
NORTH    1001 1000000                                            
NORTH    1002 1100000                                            
NORTH    1003 1550000                                            
NORTH    1008 1250000                                            
NORTH    1005  900000                                            
SOUTH    1007 2105000                                            
SOUTH    1010  875000                                            
SOUTH    1012 1655000                                            
EAST     1051 2508000                                            
EAST     1055 1805000                                            
;
run;    
 
proc sort data=sales;                                            
  by region;                                                    
run;                                                             

/* Create REGTOT, a data set that contains one observation for each REGION. */ 
/* Create a new variable REGTOTAL, that contains the total AMOUNT for each  */
/* REGION.                                                                  */
                                                                 
proc means data=sales noprint nway;                              
  var amount;                                                   
  by region;                                                    
  output out=regtot(keep=regtotal region) sum=regtotal;         
run;         


/* Create PERCENT1 by merging REGTOT with SALES, based on the value of      */
/* the BY variable REGION.                                                  */

data percent1;                                    
  merge sales regtot;                            
  by region; 
  /* Calculate the percentage each observation contributed 
     to the total for the appropriate region.               */                                                                                
  regpct = (amount / regtotal ) * 100;           
  format regpct 6.2 amount regtotal dollar10.;   
run;                                              
                                                  
proc print data=percent1;                         
  title1 'PERCENT1';                             
run;




/* Method 2 : Related Technique using PROC SQL */                           
                                                                                            
proc sql;                                                       
  create table percent2 as                                     
    select *, sum(amount) as regtotal format=dollar10.,       
          100*(amount/sum(amount)) as regpct format=6.2      
      from sales                                             
        group by region;                                       
quit;

*===Collapsing observations within a BY-Group into a single observation (when data set has 3 or more variables===*;
data in;
  infile datalines truncover;
  input x y s $;
datalines;
1 2
1 5 a
1 9 b
1 10 c
2 1 x
2 2 y
2 1  
;

proc sort;
  by x;
run;


/* Create new variables needed to hold all values in the BY-Group with an ARRAY */
/* statement and then retain them so they can be output on the last observation */
/* in the BY-Group. At the beginning of the BY-Group, set all variables to      */
/* missing so that when there are uneven numbers of observations, there aren't  */
/* 'bleed over' values from the previous BY-Group.  Assign the current          */
/* observation's values to the appropriate array elements.                      */

data out (keep=x y1-y5 s1-s5);
  retain y1-y5 s1-s5;
  array ay (5) y1-y5;
  array as (5) $ s1-s5;
  set in;
  by x;
  if first.x then do;
    i=1;
    do j=1 to 5;
      as(j)=' ';
      ay(j)=. ;
    end;
  end;
  as(i)=s;
  ay(i)=y;
  if last.x then output;
  i+1;
run;

proc print;
run;


*===Force a new page in a report when a BY-Group changes===*;
/* Create sample data set  */

data test;
  input fruit $ ;
datalines;
apple
coconut
apple
coconut
coconut
banana
;

/* Sort the data */

proc sort data=test;
  by fruit;
run;

/* Using PRINT as the fileref causes the PUT statement to write to the output window. The first.logic */
/* forces a new page for each new value of FRUIT.                                                     */

data test2;
  file print notitle;
  set test;
  by fruit;
  if first.fruit then put _page_;
  put fruit;
run;

*===Generate a cumulative total per BY-group using DATA step code===*;
/* Create sample data */

data one;
   input x y;
   datalines;
1 3
1 6
2 7
2 8
2 9
2 5
3 3
3 5
4 10
4 4
4 9
4 15
4 3
;
run;

/* Initialize the TOTAL variable back to zero at the beginning of each  */
/* BY-Group. Sum the variable while the BY-Group remains the same       */
/* and produce a total for the BY-Group on the last observation of the  */
/* BY-Group. Output the last observation for each BY-Group.             */

data two;
   set one; 
   by x;
   if first.x then total=0;
   total + y;
   if last.x then output;
   drop y;
run;

proc print;
run;

*===Collapsing observations within a BY-Group into a single observation (when data set has 3 or more variables)===*;
data in;
  infile datalines truncover;
  input x y s $;
datalines;
1 2
1 5 a
1 9 b
1 10 c
2 1 x
2 2 y
2 1  
;

proc sort;
  by x;
run;


/* Create new variables needed to hold all values in the BY-Group with an ARRAY */
/* statement and then retain them so they can be output on the last observation */
/* in the BY-Group. At the beginning of the BY-Group, set all variables to      */
/* missing so that when there are uneven numbers of observations, there aren't  */
/* 'bleed over' values from the previous BY-Group.  Assign the current          */
/* observation's values to the appropriate array elements.                      */

data out (keep=x y1-y5 s1-s5);
  retain y1-y5 s1-s5;
  array ay (5) y1-y5;
  array as (5) $ s1-s5;
  set in;
  by x;
  if first.x then do;
    i=1;
    do j=1 to 5;
      as(j)=' ';
      ay(j)=. ;
    end;
  end;
  as(i)=s;
  ay(i)=y;
  if last.x then output;
  i+1;
run;

proc print;
run;

*===Grouped or Sorted Observations, Chapter 10===*;
 /**************************************************************/
  /*          S A S   S A M P L E   L I B R A R Y               */
  /*                                                            */
  /*    NAME: BUG10U01                                          */
  /*   TITLE: Grouped or Sorted Observations, Chapter 10        */
  /* PRODUCT: BASE                                              */
  /*  SYSTEM: ALL                                               */
  /*    KEYS: DOC DATASTEP PRINT SORT VAR SET BY FIRST. LAST.   */
  /*          NODUP                                             */
  /*   PROCS: PRINT SORT                                        */
  /*    DATA:                                                   */
  /*                                                            */
  /* SUPPORT:                             UPDATE:               */
  /*     REF: SAS Language and Procedures:  Usage               */
  /*    MISC:                                                   */
  /*                                                            */
  /**************************************************************/

  /* For simplicity the infile statement has been removed and */
  /* the raw data is being read into this step via a cards    */
  /* statement.                                               */

options ls=72;
title;
data type;
   input country $ 1-11 tourtype $ 13-24 nights
         landcost vendor $;
cards;
Spain       architecture  10  510 World
Japan       architecture   8  720 Express
Switzerland scenery        9  734 World
France      architecture   8  575 World
Ireland     scenery        7  558 Express
New Zealand scenery       16 1489 Southsea
Italy       architecture   8  468 Express
Greece      scenery       12  698 Express
;
run;
proc print data=type;
   title 'Data Set TYPE';
run;

proc sort data=type out=type2;
   by tourtype;
run;

proc print data=type2;
   var tourtype country nights landcost vendor;
   title 'The Simplest Sort--One Variable, Default Order of Groups';
run;

proc sort data=type out=type3;
   by tourtype vendor landcost;
run;

proc print data=type3;
   var tourtype vendor landcost country nights;
   title 'Observations Grouped by Type of Tour, Vendor, and Price';
run;

proc sort data=type out=type4;
   by descending tourtype vendor landcost;
run;

proc print data=type4;
   var tourtype vendor landcost country nights;
   title 'Descending and Ascending Orders';
run;

proc sort data=type out=type5;
   by tourtype landcost;
run;

proc print data=type5;
   var tourtype landcost country nights vendor;
   title 'Tours Arranged by TOURTYPE and LANDCOST';
run;

data temp;
   set type5;
   by tourtype;
   frsttour=first.tourtype;
   lasttour=last.tourtype;
run;

proc print data=temp;
   var country tourtype frsttour lasttour;
   title 'Representing FIRST.TOURTYPE and LAST.TOURTYPE';
run;

proc sort data=type out=type5;
   by tourtype landcost;
run;

data lowcost;
   set type5;
   by tourtype;
   if first.tourtype;
run;

proc print data=lowcost;
   title 'Least Expensive Tour for Each Type of Tour';
run;

proc sort data=type out=type6;
   by country;
run;

proc print data=type6;
   title 'Alphabetical Order by Country';
run;

data dupobs;
   input country $ 1-11 tourtype $ 13-24 nights
         landcost vendor $;
   cards;
Spain       architecture  10  510 World
Japan       architecture   8  720 Express
Switzerland scenery        9  734 World
Switzerland scenery        9  734 World
France      architecture   8  575 World
Ireland     scenery        7  558 Express
New Zealand scenery       16 1489 Southsea
Italy       architecture   8  468 Express
Greece      scenery       12  698 Express
;
run;
proc print data=dupobs;
   title 'Data Set DUPOBS';
run;

proc sort data=dupobs out=fixed noduplicates;
   by country;
run;

proc print data=fixed;
   title 'Removing a Duplicate Observation with PROC SORT';
run;

*===Using More than One Observation in a Calculation, Chapter 11
/**************************************************************/
  /*          S A S   S A M P L E   L I B R A R Y               */
  /*                                                            */
  /*    NAME: BUG11U01                                          */
  /*   TITLE: More than One Obs. in a Calculation, Chapter 11   */
  /* PRODUCT: BASE                                              */
  /*  SYSTEM: ALL                                               */
  /*    KEYS: DOC DATASTEP PRINT SUM SET END= DSOPTION DROP=    */
  /*          KEEP= SORT SET FIRST. BY                          */
  /*   PROCS: PRINT SORT                                        */
  /*    DATA:                                                   */
  /*                                                            */
  /* SUPPORT:                             UPDATE:               */
  /*     REF: SAS Language and Procedures:  Usage               */
  /*    MISC:                                                   */
  /*                                                            */
  /**************************************************************/

  /* For simplicity, the infile statement has been removed  */
  /* and the raw data is being read via the cards statement */

options ls=72;
title;
data tourrev;
   input country $ 1-11 landcost vendor $ bookings;
   cards;
France       575 Express  10
Spain        510 World    12
Brazil       540 World     6
India        489 Express   .
Japan        720 Express  10
Greece       698 Express  20
New Zealand 1489 Southsea  6
Venezuela    425 World     8
Italy        468 Express   9
USSR         924 World     6
Switzerland  734 World    20
Australia   1079 Southsea 10
Ireland      558 Express   9
;
run;

proc print data=tourrev;
   title 'SAS Data Set TOURREV';
run;

data total;
   set tourrev;
   totbook+bookings;
run;

proc print data=total;
   var country bookings totbook;
   title 'Total Tours Booked';
run;

data total2(keep=totbook);
   set tourrev end=lastobs;
   totbook+bookings;
   if lastobs;
run;

proc print data=total2;
   title 'Last Observation Shows Total Tours Booked';
run;

proc sort data=tourrev out=sorttour;
   by vendor;
run;

data totalby;
   set sorttour;
   by vendor;
   if first.vendor then vendorbk=0;
   vendorbk+bookings;
run;

proc print data=totalby;
   title 'Setting the Sum Variable to 0 for BY Groups';
run;

proc sort data=tourrev out=sorttour;
   by vendor;
run;

data totalby(drop=country landcost bookings);
   set sorttour;
   by vendor;
   if first.vendor then vendorbk=0;
   vendorbk+bookings;
   if last.vendor;
run;

proc print data=totalby;
   title 'Last Observation in BY Group Contains Group Total';
run;

proc sort data=tourrev out=sorttour;
   by vendor;
run;

data details(drop=grpbook grpmoney)
     vendgrps(keep=vendor grpbook grpmoney);
   set sorttour;
   by vendor;
   money=landcost*bookings;
   output details;
   if first.vendor then
      do;
         grpbook=0;
         grpmoney=0;
      end;
   grpbook+bookings;
   grpmoney+money;
   if last.vendor then output vendgrps;
run;

proc print data=details;
   title 'Detail Records: Dollars Spent on Individual Tours';
run;

proc print data=vendgrps;
   title 'Group Totals: Dollars Spent and Bookings by Vendor';
run;

data temp;
   set tourrev;
   retain holdrev;
   revenue=landcost*bookings;
   output;
   holdrev=revenue;
run;

proc print data=temp;
   var country landcost bookings revenue holdrev;
   title 'HOLDREV Shows REVENUE from Previous Observation';
run;

data mostrev;
   set tourrev;
   retain holdrev;
   revenue=landcost*bookings;
   if revenue>holdrev then holdrev=revenue;
run;

proc print data=mostrev;
   var country landcost bookings revenue holdrev;
   title 'Collecting the Largest Value of REVENUE in HOLDREV';
run;

data mostrev(keep=holdctry holdrev);
   set tourrev end=lastone;
   retain holdrev holdctry;
   revenue=landcost*bookings;
   if revenue>holdrev then
      do;
         holdrev=revenue;
         holdctry=country;
      end;
   if lastone;
run;

proc print data=mostrev;
   title 'Country with the Largest Value of REVENUE';
run;

*===Assign values evenly throughout a BY-Group===*;
data test;
  infile datalines truncover;
  input branch num_b num_c custid $  b1  b2 b3;
datalines;
1111 2 8 A       12817   6886
1111 2 8 B       12817   6886
1111 2 8 C       12817   6886
1111 2 8 D       12817   6886
1111 2 8 E       12817   6886
1111 2 8 F       12817   6886
1111 2 8 G       12817   6886
1111 2 8 H       12817   6886
2222 3 11 N       12309   2209    6054
2222 3 11 O       12309   2209    6054
2222 3 11 P       12309   2209    6054
2222 3 11 Q       12309   2209    6054
2222 3 11 R       12309   2209    6054
2222 3 11 S       12309   2209    6054
2222 3 11 T       12309   2209    6054
2222 3 11 U       12309   2209    6054
2222 3 11 V       12309   2209    6054
2222 3 11 W       12309   2209    6054
2222 3 11 X       12309   2209    6054
;

proc sort data=test;
  by branch;
run;

/* Assign B1-B3 to an array for ease of grouping and reference. Since NUM_B      */
/* represents the number of variables in the array that are populated and        */
/* NUM_C is the total number of observations in the BY-Group, CT is computed     */
/* to know how many values from B1-B3 can be assigned per BY-Group. LEFTOVER     */
/* is computed to know how many extra values exist after the values are assigned */
/* equally within the BY-Group.                                                  */

data test;
  set test;
  by branch;
  retain leftover ct i custleft;
  array banker(*) b1-b3;
  if first.branch then do;
    ct=int(num_c/num_b);
    i=1;
    custleft=num_c;
    leftover=mod(num_c,num_b);
  end;

  /* ASSIGN is the variable that is created holding one of the array values. */ 
  /* CT is the number of observations left to assign that value to.          */
  assign=banker(i);
  ct=ct-1;
  custleft=custleft-1;

  /* If CT=0 then determine which category CUSTLEFT falls into and compute */  
  /* variables accordingly.                                                */
  if ct=0 then do;
    if custleft gt leftover then do;
      i=i+1;
      ct=int(num_c/num_b);
    end;
    if custleft lt leftover then do;
      i=i+1;
      ct=1;
    end;
    if custleft eq leftover then do;
      ct=1;
      I=1;
    end;
  end;

  /* Comment out to see these variables in the PROC PRINT as well */
  drop leftover ct i custleft; 
run;

proc print;
run;

*===Add observations to a SAS? data set so the values of a variable are consecutive throughout the BY group===*;
/* Create starting data */

data missing;
   input date mmddyy8. x1 x2; 
   format date mmddyy8.;
   datalines;
01/15/99 1 11
01/15/99 2 22
01/15/99 4 44
01/15/99 5 55
02/14/99 3 33
08/29/99 1 88
08/29/99 3 99
08/29/99 5 101
11/11/99 1 111
11/11/99 4 141
;

proc sort;
   by date x1;
run;

data fill(drop=temp1 temp2 end);

  /* Rename X1 and X2 so we can use those variable names */
  /* in our calculations below                           */
   set missing (rename=(x1=temp1 x2=temp2));
   by date;
   retain x1;

  /* X1 is the observation counter  */  
   if first.date then x1=1; 

  /* Every date needs 5 observations */
   if last.date then end=5; 
   else end=temp1; 
      
  /* This loop creates the observations that are missing in the sequence and */    
  /* assigns X2 a missing value for the new observation.                     */
   do x1=x1 to end;
      if x1 ne temp1 then x2=. ;
      else x2=temp2;            
      output;
   end;
run;

proc print;
run;

*===The warning "Multiple lengths were specified for the BY variable xxxx by input data sets" might be issued when merging data sets===*;
*===Select a specified number of observations from the top of each BY-Group===*;
/*********************************************************************************/
/* The following data set contains contribution amounts for each value of GROUP. */
/* In order to subset the top three observations within each BY-Group with the   */
/* three largest contribution amounts, sort the data set by the GROUP            */
/* variable and descending AMOUNT.  In the DATA step use the BY statement        */
/* following the SET statement to create the automatic FIRST. and LAST.          */
/* BY-Group variables.  Create a new COUNT variable and set its value to zero    */
/* on the first observation of each group. Increment the COUNT variable by       */
/* adding the value of one for each observation by using the SUM statement.      */
/* Output the observations where the COUNT value equals a 1, 2, or 3.            */
/*********************************************************************************/

data groups;
  input group $ amount date date9.;
  format date date9. amount dollar6.;
datalines;
A 1000 06Mar2000
A 550 01Mar2000
A 375 15Mar2000
A 1500 01Jun2000
A 900 15Jul2000
A 800 30Jun2000
B 500 01Mar2000
B 400 15Mar2000
B 1050 01Jun2000
B 330 15Jul2000
B 575 30Jun2000
;

proc sort;
  by group descending amount;
run;

data top3(drop=count);
  set groups;
  by group descending amount;
  if first.group then count=0;
  count+1;
  if count le 3 then output;
run;

proc print;
run;

