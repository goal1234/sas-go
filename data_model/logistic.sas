

/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: LOGIINTR                                            */
/*   TITLE: Getting Started Example for PROC LOGISTIC           */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: logistic regression analysis,                       */
/*          binomial response data                              */
/*   PROCS: LOGISTIC                                            */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: Bob Derr                                            */
/*     REF: SAS/STAT User's Guide, PROC LOGISTIC chapter        */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

/*****************************************************************
Introductory Example.
*****************************************************************/

/*
The data, taken from Cox and Snell (1989, pp 10-11), consists of the number,
r, of ingots not ready for rolling, out of n tested, for a number of
combinations of heating time and soaking time.  PROC LOGISTIC is invoked to
fit the binary logit model to the grouped data.

The ODDSRATIO statement computes odds ratios even though the main effects are
involved in an interaction.  Because Heat interacts with Soak, the odds
ratio for Heat depend on the value of Soak.  ODS Graphics is used to
display a plot of these odds ratios.
*/

title 'Introductory Example';

data ingots;
   input Heat Soak r n @@;
   datalines;
7 1.0 0 10  14 1.0 0 31  27 1.0 1 56  51 1.0 3 13
7 1.7 0 17  14 1.7 0 43  27 1.7 4 44  51 1.7 0  1
7 2.2 0  7  14 2.2 2 33  27 2.2 0 21  51 2.2 0  1
7 2.8 0 12  14 2.8 0 31  27 2.8 1 22  51 4.0 0  1
7 4.0 0  9  14 4.0 0 19  27 4.0 1 16
;

ods graphics on;
proc logistic data=ingots;
   model r/n = Heat | Soak;
   oddsratio Heat / at(Soak=1 2 3 4);
run;


/*
Since the Heat*Soak interaction is nonsignificant, the following statements
fit a main-effects model:
*/

proc logistic data=ingots;
   model r/n = Heat Soak;
run;


/*
To illustrate the use of an alternative form of input data, the following
DATA step creates the INGOTS data set with new variables NotReady and Freq
instead of n and r.  The variable NotReady represents the response of an
individual unit; it has a value of 1 for units not ready for rolling (event)
and a value of 0 for units ready for rolling (nonevent).  The variable Freq
represents the frequency of occurrence of each combination of Heat, Soak, and
NotReady.  Note that, compared to the previous data set, NotReady=1 implies
Freq=r, and NotReady=0 implies Freq=n-r.
*/

data ingots;
   input Heat Soak NotReady Freq @@;
   datalines;
7 1.0 0 10  14 1.0 0 31  14 4.0 0 19  27 2.2 0 21  51 1.0 1  3
7 1.7 0 17  14 1.7 0 43  27 1.0 1  1  27 2.8 1  1  51 1.0 0 10
7 2.2 0  7  14 2.2 1  2  27 1.0 0 55  27 2.8 0 21  51 1.7 0  1
7 2.8 0 12  14 2.2 0 31  27 1.7 1  4  27 4.0 1  1  51 2.2 0  1
7 4.0 0  9  14 2.8 0 31  27 1.7 0 40  27 4.0 0 15  51 4.0 0  1
;

proc logistic data=ingots;
   model NotReady(event='1') = Heat Soak;
   freq Freq;
run;




/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: LOGIEX1                                             */
/*   TITLE: Example 1 for PROC LOGISTIC                         */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: logistic regression analysis,                       */
/*          binomial response data,                             */
/*   PROCS: LOGISTIC                                            */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: Bob Derr                                            */
/*     REF: SAS/STAT User's Guide, PROC LOGISTIC chapter        */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

/*****************************************************************
Example 1. Stepwise Logistic Regression and Predicted Values
*****************************************************************/

/*
The data, taken from Lee (1974), consist of patient characteristics and
whether or not cancer remission occurred, and are saved in the data set
Remission. The variable remiss is the cancer remission indicator variable
with a value of 1 for remission and a value of 0 for nonremission.  The other
six variables are the risk factors thought to be related to cancer remission.

The first call to the LOGISTIC procedure illustrates the use of stepwise
selection to identify the prognostic factors for cancer remission.  Two
output data sets are printed: one contains the parameter estimates and the
estimated covariance matrix; the other contains the predicted values and
confidence limits for the probabilities of cancer remission.

The second call to the LOGISTIC procedure illustrates the FAST option for
backward elimination.
*/

title 'Example 1. Stepwise Regression';

data Remission;
   input remiss cell smear infil li blast temp;
   label remiss='Complete Remission';
   datalines;
1   .8   .83  .66  1.9  1.1     .996
1   .9   .36  .32  1.4   .74    .992
0   .8   .88  .7    .8   .176   .982
0  1     .87  .87   .7  1.053   .986
1   .9   .75  .68  1.3   .519   .98
0  1     .65  .65   .6   .519   .982
1   .95  .97  .92  1    1.23    .992
0   .95  .87  .83  1.9  1.354  1.02
0  1     .45  .45   .8   .322   .999
0   .95  .36  .34   .5  0      1.038
0   .85  .39  .33   .7   .279   .988
0   .7   .76  .53  1.2   .146   .982
0   .8   .46  .37   .4   .38   1.006
0   .2   .39  .08   .8   .114   .99
0  1     .9   .9   1.1  1.037   .99
1  1     .84  .84  1.9  2.064  1.02
0   .65  .42  .27   .5   .114  1.014
0  1     .75  .75  1    1.322  1.004
0   .5   .44  .22   .6   .114   .99
1  1     .63  .63  1.1  1.072   .986
0  1     .33  .33   .4   .176  1.01
0   .9   .93  .84   .6  1.591  1.02
1  1     .58  .58  1     .531  1.002
0   .95  .32  .3   1.6   .886   .988
1  1     .6   .6   1.7   .964   .99
1  1     .69  .69   .9   .398   .986
0  1     .73  .73   .7   .398   .986
;

title 'Stepwise Regression on Cancer Remission Data';
proc logistic data=Remission outest=betas covout;
   model remiss(event='1')=cell smear infil li blast temp
                / selection=stepwise
                  slentry=0.3
                  slstay=0.35
                  details
                  lackfit;
   output out=pred p=phat lower=lcl upper=ucl
          predprob=(individual crossvalidate);
   ods output Association=Association;
run;

proc print data=betas;
   title2 'Parameter Estimates and Covariance Matrix';
run;

proc print data=pred;
   title2 'Predicted Probabilities and 95% Confidence Limits';
run;


/*
The following statements order the selected models by the area
under the ROC curve (AUC):
*/

data Association(rename=(Label2=Statistic nValue2=Value));
   set Association;
   if (Label2='c');
   keep Step Label2 nValue2;
proc sort data=Association;
   by Value;
title;
proc print data=Association;
run;

title 'Backward Elimination on Cancer Remission Data';
proc logistic data=Remission;
   model remiss(event='1')=temp cell li smear blast
         / selection=backward fast slstay=0.2 ctable;
run;



/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: LOGIEX2                                             */
/*   TITLE: Example 2 for PROC LOGISTIC                         */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: logistic regression analysis,                       */
/*          binomial response data,                             */
/*   PROCS: LOGISTIC                                            */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: Bob Derr                                            */
/*     REF: SAS/STAT User's Guide, PROC LOGISTIC chapter        */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

/*****************************************************************
Example 2. Logistic Modeling With Categorical Predictors
*****************************************************************/

/*
In a study of the analgesic effects of treatments on elderly
patients with neuralgia, two test treatments and a placebo are
compared. The response variable, Pain, is whether the patient
reported pain or not. Researchers record Age and Sex of the
patients and the Duration of complaint before the treatment began.

The first call to the LOGISTIC procedure fits the logit model with
Treatment, Sex, Treatment by Sex interaction, Age, and Duration as
effects.  The categorical variables Treatment and Sex are declared
in the CLASS statement.

The next PROC LOGISTIC call illustrates the use of forward
selection on the data set Neuralgia to identify the effects that
differentiate the two Pain responses.  The option SELECTION=FORWARD
is specified to carry out the forward selection. The term
Treatment|Sex@2 illustrates another way to specify main effects and
two-way interaction.

The final PROC LOGISTIC call refits the previously selected model
using the REFERENCE-coding for the CLASS variables.  ODDSRATIO
statements are specified to compute odds ratios of the main
effects, graphical displays are produced when ODS Graphics is
enabled. Four CONTRAST statements are specified.  The ones labeled
'Pairwise' test the pairwise comparisons between the three levels
of Treatment. The one labeled 'Female vs Male' compares female to
male patients. The option ESTIMATE=EXP is specified in the CONTRAST
statements to exponentiate the estimates of the contrast.  With the
given specification of contrast coefficients, the first of the
'Pairwise' CONTRAST statements corresponds to the odds ratio of A
versus P, the second corresponds to B versus P, and the third
corresponds to A versus B.  The 'Female vs Male' CONTRAST statement
corresponds to the odds ratio that compares female to male
patients.  The EFFECTPLOT statement displays a plot of the
model-predicted probabilities classified by Treatment and Age.
*/

title 'Example 2. Modeling with Categorical Predictors';

data Neuralgia;
   input Treatment $ Sex $ Age Duration Pain $ @@;
   datalines;
P  F  68   1  No   B  M  74  16  No  P  F  67  30  No
P  M  66  26  Yes  B  F  67  28  No  B  F  77  16  No
A  F  71  12  No   B  F  72  50  No  B  F  76   9  Yes
A  M  71  17  Yes  A  F  63  27  No  A  F  69  18  Yes
B  F  66  12  No   A  M  62  42  No  P  F  64   1  Yes
A  F  64  17  No   P  M  74   4  No  A  F  72  25  No
P  M  70   1  Yes  B  M  66  19  No  B  M  59  29  No
A  F  64  30  No   A  M  70  28  No  A  M  69   1  No
B  F  78   1  No   P  M  83   1  Yes B  F  69  42  No
B  M  75  30  Yes  P  M  77  29  Yes P  F  79  20  Yes
A  M  70  12  No   A  F  69  12  No  B  F  65  14  No
B  M  70   1  No   B  M  67  23  No  A  M  76  25  Yes
P  M  78  12  Yes  B  M  77   1  Yes B  F  69  24  No
P  M  66   4  Yes  P  F  65  29  No  P  M  60  26  Yes
A  M  78  15  Yes  B  M  75  21  Yes A  F  67  11  No
P  F  72  27  No   P  F  70  13  Yes A  M  75   6  Yes
B  F  65   7  No   P  F  68  27  Yes P  M  68  11  Yes
P  M  67  17  Yes  B  M  70  22  No  A  M  65  15  No
P  F  67   1  Yes  A  M  67  10  No  P  F  72  11  Yes
A  F  74   1  No   B  M  80  21  Yes A  F  69   3  No
;

proc logistic data=Neuralgia;
   class Treatment Sex;
   model Pain= Treatment Sex Treatment*Sex Age Duration / expb;
run;

proc logistic data=Neuralgia;
   class Treatment Sex;
   model Pain=Treatment|Sex@2 Age Duration
         /selection=forward expb;
run;

ods graphics on;
proc logistic data=Neuralgia plots(only)=(oddsratio(range=clip));
   class Treatment Sex /param=ref;
   model Pain= Treatment Sex Age / noor;
   oddsratio Treatment;
   oddsratio Sex;
   oddsratio Age;
   contrast 'Pairwise A vs P' Treatment 1  0 / estimate=exp;
   contrast 'Pairwise B vs P' Treatment 0  1 / estimate=exp;
   contrast 'Pairwise A vs B' Treatment 1 -1 / estimate=exp;
   contrast 'Female vs Male' Sex 1 / estimate=exp;
   effectplot / at(Sex=all) noobs;
   effectplot slicefit(sliceby=Sex plotby=Treatment) / noobs;
run;



/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: LOGIEX3                                             */
/*   TITLE: Example 3 for PROC LOGISTIC                         */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: logistic regression analysis,                       */
/*          polytomous response data                            */
/*   PROCS: LOGISTIC                                            */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: Bob Derr                                            */
/*     REF: SAS/STAT User's Guide, PROC LOGISTIC chapter        */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

/*****************************************************************
Example 3. Ordinal Logistic Regression
*****************************************************************/

/*
The data, taken from McCullagh and Nelder (1989, p.175), were derived from an
experiment concerned with the effect on taste of four cheese additives.  The
nine response categories range from strong dislike (1) to excellent taste
(9).  Let y be the response variable.  The variable Additive specifies the
cheese additive (1, 2, 3, or 4).  The data after the DATALINES statement are
arranged like a 2-way table of additive by rating; i.e., the rows are the
four additives and the columns are the nine levels of the rating scale.

The ODDSRATIO statement produces a plot of the odds ratios when ODS
Graphics is enabled, while the EFFECTPLOT statement displays the
model-predicted probabilities
*/

title 'Example 3. Ordinal Logistic Regression';

data Cheese;
   do Additive = 1 to 4;
      do y = 1 to 9;
         input freq @@;
         output;
      end;
   end;
   label y='Taste Rating';
   datalines;
0  0  1  7  8  8 19  8  1
6  9 12 11  7  6  1  0  0
1  1  6  8 23  7  5  1  0
0  0  0  1  3  7 14 16 11
;

ods graphics on;
proc logistic data=Cheese plots(only)=oddsratio(range=clip);
   freq freq;
   class Additive (param=ref ref='4');
   model y=Additive / covb nooddsratio;
   oddsratio Additive;
   effectplot / polybar;
   title 'Multiple Response Cheese Tasting Experiment';
run;

proc logistic data=Cheese
   plots(only)=effect(x=y sliceby=additive connect yrange=(0,0.4));
   freq freq;
   class Additive (param=ref ref='4');
   model y=Additive / nooddsratio link=alogit;
   oddsratio Additive;
   title 'Multiple Response Cheese Tasting Experiment';
run;



/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: LOGIEX4                                             */
/*   TITLE: Example 4 for PROC LOGISTIC                         */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: logistic regression analysis,                       */
/*          polytomous response data                            */
/*   PROCS: LOGISTIC                                            */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: Bob Derr                                            */
/*     REF: SAS/STAT User's Guide, PROC LOGISTIC chapter        */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

/*****************************************************************
Example 4. Nominal Response Data: Generalized Logits Model
*****************************************************************/

/*
Stokes, Davis, and Koch (2000). Over the course of one school year, third
graders from three different schools are exposed to three different styles of
mathematics instruction: a self-paced computer-learning style, a team
approach, and a traditional class approach.  The students are asked which
style they prefer and their responses are classified by the type of program
they are in (a regular school day versus a regular day supplemented with an
afternoon school program).  The levels (self, team, and class) of the
response variable Style have no essential ordering, so a logistic regression
is performed on the generalized logits.  An interaction model then a main
effects model are fit.
*/

title 'Example 4. Nominal Response Data: Generalized Logits Model';

data school;
   length Program $ 9;
   input School Program $ Style $ Count @@;
   datalines;
1 regular   self 10  1 regular   team 17  1 regular   class 26
1 afternoon self  5  1 afternoon team 12  1 afternoon class 50
2 regular   self 21  2 regular   team 17  2 regular   class 26
2 afternoon self 16  2 afternoon team 12  2 afternoon class 36
3 regular   self 15  3 regular   team 15  3 regular   class 16
3 afternoon self 12  3 afternoon team 12  3 afternoon class 20
;

ods graphics on;
proc logistic data=school;
   freq Count;
   class School Program(ref=first);
   model Style(order=data)=School Program School*Program / link=glogit;
   oddsratio program;
run;

proc logistic data=school;
   freq Count;
   class School Program(ref=first);
   model Style(order=data)=School Program / link=glogit;
   effectplot interaction(plotby=Program) / clm noobs;
run;




/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: LOGIEX6                                             */
/*   TITLE: Example 6 for PROC LOGISTIC                         */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: logistic regression analysis,                       */
/*          binomial response data,                             */
/*   PROCS: LOGISTIC                                            */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: Bob Derr                                            */
/*     REF: SAS/STAT User's Guide, PROC LOGISTIC chapter        */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

/*****************************************************************
Example 6. Logistic Regression Diagnostics
*****************************************************************/

/*
Finney( 1947) lists data on a controlled experiment to study the effect of
the rate and volume of air on a transient reflex vasoconstriction in the
skin of the digits. 39 tests under various combinations of rate and volume of
air inspired were obtained.  The end point of each test is whether or not
vasoconstriction occurred.  Pregibon (1981) uses this set of data to
illustrate the diagnostic measures he proposes for detecting influential
observations and in quantifying their effects on various aspects of the
maximum likelihood fit.

The variable Response represents the outcome of the test.  PROC LOGISTIC is
invoked to fit a logistic regression model to the vasoconstriction data.
The INFLUENCE option is specified to display the regression diagnostics.
*/

title 'Example 6. Logistic Regression Diagnostics';

data vaso;
   length Response $12;
   input Volume Rate Response @@;
   LogVolume=log(Volume);
   LogRate=log(Rate);
   datalines;
3.70  0.825  constrict       3.50  1.09   constrict
1.25  2.50   constrict       0.75  1.50   constrict
0.80  3.20   constrict       0.70  3.50   constrict
0.60  0.75   no_constrict    1.10  1.70   no_constrict
0.90  0.75   no_constrict    0.90  0.45   no_constrict
0.80  0.57   no_constrict    0.55  2.75   no_constrict
0.60  3.00   no_constrict    1.40  2.33   constrict
0.75  3.75   constrict       2.30  1.64   constrict
3.20  1.60   constrict       0.85  1.415  constrict
1.70  1.06   no_constrict    1.80  1.80   constrict
0.40  2.00   no_constrict    0.95  1.36   no_constrict
1.35  1.35   no_constrict    1.50  1.36   no_constrict
1.60  1.78   constrict       0.60  1.50   no_constrict
1.80  1.50   constrict       0.95  1.90   no_constrict
1.90  0.95   constrict       1.60  0.40   no_constrict
2.70  0.75   constrict       2.35  0.03   no_constrict
1.10  1.83   no_constrict    1.10  2.20   constrict
1.20  2.00   constrict       0.80  3.33   constrict
0.95  1.90   no_constrict    0.75  1.90   no_constrict
1.30  1.625  constrict
;

ods graphics on;
title 'Occurrence of Vasoconstriction';
proc logistic data=vaso;
   model Response=LogRate LogVolume/influence;
run;

proc logistic data=vaso plots(only label)=(phat leverage dpc);
   model Response=LogRate LogVolume;
run;




/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: LOGIEX4                                             */
/*   TITLE: Example 4 for PROC LOGISTIC                         */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: logistic regression analysis,                       */
/*          polytomous response data                            */
/*   PROCS: LOGISTIC                                            */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: Bob Derr                                            */
/*     REF: SAS/STAT User's Guide, PROC LOGISTIC chapter        */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

/*****************************************************************
Example 4. Nominal Response Data: Generalized Logits Model
*****************************************************************/

/*
Stokes, Davis, and Koch (2000). Over the course of one school year, third
graders from three different schools are exposed to three different styles of
mathematics instruction: a self-paced computer-learning style, a team
approach, and a traditional class approach.  The students are asked which
style they prefer and their responses are classified by the type of program
they are in (a regular school day versus a regular day supplemented with an
afternoon school program).  The levels (self, team, and class) of the
response variable Style have no essential ordering, so a logistic regression
is performed on the generalized logits.  An interaction model then a main
effects model are fit.
*/

title 'Example 4. Nominal Response Data: Generalized Logits Model';

data school;
   length Program $ 9;
   input School Program $ Style $ Count @@;
   datalines;
1 regular   self 10  1 regular   team 17  1 regular   class 26
1 afternoon self  5  1 afternoon team 12  1 afternoon class 50
2 regular   self 21  2 regular   team 17  2 regular   class 26
2 afternoon self 16  2 afternoon team 12  2 afternoon class 36
3 regular   self 15  3 regular   team 15  3 regular   class 16
3 afternoon self 12  3 afternoon team 12  3 afternoon class 20
;

ods graphics on;
proc logistic data=school;
   freq Count;
   class School Program(ref=first);
   model Style(order=data)=School Program School*Program / link=glogit;
   oddsratio program;
run;

proc logistic data=school;
   freq Count;
   class School Program(ref=first);
   model Style(order=data)=School Program / link=glogit;
   effectplot interaction(plotby=Program) / clm noobs;
run;




/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: LOGIEX5                                             */
/*   TITLE: Example 5 for PROC LOGISTIC                         */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: logistic regression analysis,                       */
/*          binomial response data,                             */
/*   PROCS: LOGISTIC                                            */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: Bob Derr                                            */
/*     REF: SAS/STAT User's Guide, PROC LOGISTIC chapter        */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

/*****************************************************************
Example 5. Stratified Sampling
*****************************************************************/

/*
Consider the hypothetical example in Fleiss (1981, pp. 6-7) in which a test
is applied to a sample of 1000 people known to have a disease and to another
sample of 1000 people known not to have the same disease. In the diseased
sample, 950 were tested positively; in the nondiseased sample, only 10 were
tested positively. If the true disease rate in the population is 1 in 100,
you should specify PEVENT= .01 in order to obtain the correct false positive
and negative rates for the stratified sampling scheme. Omitting the PEVENT=
option is equivalent to using the overall sample disease rate (1000/2000 =
.5) as the value of the PEVENT= option and thereby ignoring the stratified
sampling.
*/

title 'Example 5. Stratified Sampling';

data Screen;
   do Disease='Present','Absent';
      do Test=1,0;
         input Count @@;
         output;
      end;
   end;
   datalines;
950  50
 10 990
;


proc logistic data=Screen;
   freq Count;
   model Disease(event='Present')=Test
         / pevent=.5 .01 ctable pprob=.5;
run;



/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: LOGIEX7                                             */
/*   TITLE: Example 7 for PROC LOGISTIC                         */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: logistic regression analysis,                       */
/*          binomial response data,                             */
/*   PROCS: LOGISTIC                                            */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: Bob Derr                                            */
/*     REF: SAS/STAT User's Guide, PROC LOGISTIC chapter        */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

/*****************************************************************
Example 7. ROC Curve, Customized Odds Ratios, Goodness-of-Fit
Statistics, R-Square and Confidence Limits
*****************************************************************/

/*
This example plots an ROC curve, estimates a customized odds ratio, produces
the traditional goodness-of-fit analysis, prints the generalized R^2 measures
for the fitted model, and calculates the normal confidence intervals for the
regression parameters.

The data consist of three variables: N (number of subjects in a sample),
DISEASE (number of diseased subjects in the sample), and AGE (age for the
sample).  A linear logistic regression model is fit to study the effect of
age on the probability of contracting the disease.

Finally, ODS Graphics and the PLOTS= option are used
to plot the ROC curve, and the EFFECTPLOT statement displays the
model-predicted probabilities.*/

title 'Example 7: ROC Curve, R-Square, ...';

data Data1;
   input disease n age;
   datalines;
 0 14 25
 0 20 35
 0 19 45
 7 18 55
 6 12 65
17 17 75
;

ods graphics on;
%let _ROC_XAXISOPTS_LABEL=False Positive Fraction;
%let _ROC_YAXISOPTS_LABEL=True Positive Fraction;
proc logistic data=Data1 plots(only)=roc(id=obs);
   model disease/n=age / scale=none
                         clparm=wald
                         clodds=pl
                         rsquare;
   units age=10;
   effectplot;
run;



/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: LOGIEX8                                             */
/*   TITLE: Example 8 for PROC LOGISTIC                         */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: logistic regression analysis,                       */
/*          binomial response data,                             */
/*   PROCS: LOGISTIC                                            */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: Bob Derr                                            */
/*     REF: SAS/STAT User's Guide, PROC LOGISTIC chapter        */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

/*****************************************************************
Example 8. Comparing Receiver Operating Characteristic Curves
*****************************************************************/

/*
Delong, Delong, and Clarke-Pearson (1988) report on 49 patients with ovarian
cancer who also suffer from an intestinal obstruction.  Three (correlated)
screening tests are measured to determine whether a patient will benefit from
surgery.  The three tests are the K-G score and two measures of nutritional
status: total protein and albumin.

This example illustrates how to use PROC LOGISTIC to compute and display the
ROC curves for the three tests, and how to compare the tests.
*/

title 'Example 8: Comparing ROC Curves';

data roc;
   input alb tp totscore popind @@;
   totscore = 10 - totscore;
   datalines;
3.0 5.8 10 0   3.2 6.3  5 1   3.9 6.8  3 1   2.8 4.8  6 0
3.2 5.8  3 1   0.9 4.0  5 0   2.5 5.7  8 0   1.6 5.6  5 1
3.8 5.7  5 1   3.7 6.7  6 1   3.2 5.4  4 1   3.8 6.6  6 1
4.1 6.6  5 1   3.6 5.7  5 1   4.3 7.0  4 1   3.6 6.7  4 0
2.3 4.4  6 1   4.2 7.6  4 0   4.0 6.6  6 0   3.5 5.8  6 1
3.8 6.8  7 1   3.0 4.7  8 0   4.5 7.4  5 1   3.7 7.4  5 1
3.1 6.6  6 1   4.1 8.2  6 1   4.3 7.0  5 1   4.3 6.5  4 1
3.2 5.1  5 1   2.6 4.7  6 1   3.3 6.8  6 0   1.7 4.0  7 0
3.7 6.1  5 1   3.3 6.3  7 1   4.2 7.7  6 1   3.5 6.2  5 1
2.9 5.7  9 0   2.1 4.8  7 1   2.8 6.2  8 0   4.0 7.0  7 1
3.3 5.7  6 1   3.7 6.9  5 1   3.6 6.6  5 1
;

ods graphics on;
proc logistic data=roc plots=roc(id=prob);
   model popind(event='0') = alb tp totscore / nofit;
   roc 'Albumin' alb;
   roc 'K-G Score' totscore;
   roc 'Total Protein' tp;
   roccontrast reference('K-G Score') / estimate e;
run;



/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: LOGIEX9                                             */
/*   TITLE: Example 9 for PROC LOGISTIC                         */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: logistic regression analysis,                       */
/*          binomial response data,                             */
/*   PROCS: LOGISTIC                                            */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: Bob Derr                                            */
/*     REF: SAS/STAT User's Guide, PROC LOGISTIC chapter        */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

/*****************************************************************
Example 9. Goodness-of-Fit Tests and Subpopulations
*****************************************************************/

/*
A study is done to investigate the effects of two binary factors, A and B, on
a binary response, Y.  Subjects are randomly selected from subpopulations
defined by the four possible combinations of levels of A and B.  The number
of subjects responding with each level of Y is recorded and entered into data
set A.

First, a full model is fit to examine the main effects of A and B as well as
the interaction effect of A and B. Note that Pearson and Deviance
goodness-of-fit tests cannot be obtained for this model since a full model
containing four parameters is fit, leaving no residual degrees of freedom.
For a binary response model, the goodness-of-fit tests have m-q degrees of
freedom, where m is the number of subpopulations and q is the number of model
parameters. In the preceding model, m=q=4, resulting in zero degrees of
freedom for the tests.
*/

title 'Example 9: Goodness-of-Fit Tests and Subpopulations';

data One;
   do A=0,1;
      do B=0,1;
         do Y=1,2;
            input F @@;
            output;
         end;
      end;
   end;
   datalines;
23 63 31 70 67 100 70 104
;


proc logistic data=One;
   freq F;
   model Y=A B A*B;
run;


/*
Results of the model fit above show that neither the A*B interaction nor the
B main effect is significant. If a reduced model containing only the A effect
is fit, two degrees of freedom become available for testing goodness of fit.
Specifying the SCALE=NONE option requests the Pearson and deviance
statistics.  With single-trial syntax, the AGGREGATE= option is needed to
define the subpopulations in the study.

Specifying AGGREGATE=(A B) creates subpopulations of the four combinations of
levels of A and B. Although the B effect is being dropped from the model, it
is still needed to define the original subpopulations in the study. If
AGGREGATE=(A) were specified, only two subpopulations would be created from
the levels of A, resulting in m=q=2 and zero degrees of freedom for the
tests.
*/

proc logistic data=One;
   freq F;
   model Y=A / scale=none aggregate=(A B);
run;




/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: LOGIEX10                                            */
/*   TITLE: Example 10 for PROC LOGISTIC                        */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: logistic regression analysis,                       */
/*          binomial response data,                             */
/*   PROCS: LOGISTIC                                            */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: Bob Derr                                            */
/*     REF: SAS/STAT User's Guide, PROC LOGISTIC chapter        */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

/*****************************************************************
Example 10. Overdispersion
*****************************************************************/

/*
In a seed germination test, seeds of two cultivars were planted in pots of
two soil conditions. The following SAS statements create the data set SEEDS,
which contains the observed proportion of seeds that germinated for various
combinations of cultivar and soil condition. Variable N represents the number
of seeds planted in a pot, and R represents the number germinated. CULT and
SOIL are indicator variables, representing the cultivar and soil condition,
respectively.

PROC LOGISTIC is first used to fit a logit model to the data, with CULT, SOIL
and CULT*SOIL (the CULT x SOIL interaction) as explanatory variables. The
option SCALE=NONE is specified to display the goodness-of-fit statistics.

The results from the first LOGISTIC run suggest that without adjusting for
the overdispersion, the standard errors are likely to be underestimated,
causing the Wald tests to be oversensitive.  In PROC LOGISTIC, there are
three SCALE= options to accommodate overdispersion. With unequal sample sizes
for the observations, SCALE=WILLIAMS is preferred.  In the second LOGISTIC
call, the option SCALE=WILLIAMS is included. The Williams model estimates a
scale parameter by equating the value of Pearson's chi-square for full model
to its approximate expected value. The full model considered here is the
factorial model with cultivar and soil condition as factors.

The estimate of the Williams scale parameter is 0.075941 and is given in the
formula for the WEIGHT variable at the beginning of the printed output. Since
both CULT and CULT*SOIL are not statistically significant (p=.5289 and
p=.9275, respectively), a reduced model containing only the soil condition
factor is then fitted in the final LOGISTIC run.  Here, the observations are
weighted by 1/(1+0.075941(N-1)) by including the scale estimate in the
SCALE=WILLIAMS option as shown.
*/

title 'Example 10. Overdispersion';

data seeds;
   input pot n r cult soil;
   datalines;
 1 16     8      0       0
 2 51    26      0       0
 3 45    23      0       0
 4 39    10      0       0
 5 36     9      0       0
 6 81    23      1       0
 7 30    10      1       0
 8 39    17      1       0
 9 28     8      1       0
10 62    23      1       0
11 51    32      0       1
12 72    55      0       1
13 41    22      0       1
14 12     3      0       1
15 13    10      0       1
16 79    46      1       1
17 30    15      1       1
18 51    32      1       1
19 74    53      1       1
20 56    12      1       1
;


proc logistic data=seeds;
   model r/n=cult soil cult*soil/scale=none;
   title 'Full Model With SCALE=NONE';
run;

proc logistic data=seeds;
   model r/n=cult soil cult*soil / scale=williams;
   title 'Full Model With SCALE=WILLIAMS';
run;

proc logistic data=seeds;
   model r/n=soil / scale=williams(0.075941);
   title 'Reduced Model With SCALE=WILLIAMS(0.075941)';
run;




/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: LOGIEX11                                            */
/*   TITLE: Example 11 for PROC LOGISTIC                        */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: logistic regression analysis,                       */
/*          conditional logistic regression analysis,           */
/*          exact conditional logistic regression analysis,     */
/*          binomial response data,                             */
/*   PROCS: LOGISTIC                                            */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: Bob Derr                                            */
/*     REF: SAS/STAT User's Guide, PROC LOGISTIC chapter        */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

/*****************************************************************
Example 11. Conditional Logistic Regression for Matched Pairs Data
****************************************************************/

/*
The data are a subset of data from the Los Angeles Study of the Endometrial
Cancer Data described in Breslow and Day (1980).  There are 63 matched pairs,
each consisting of a case of endometrial cancer (Outcome=1) and a control
(Outcome=0).  The case and the corresponding control have the same ID.  The
explanatory variables include Gall (an indicator for gall bladder disease)
and Hyper (an indicator for hypertension).  The goal of the analysis is to
determine the relative risk for gall bladder disease controlling for the
effect of hypertension.
*/

title 'Example 11. Conditional Logistic Regression for Matched Pairs';

data Data1;
   do ID=1 to 63;
      do Outcome = 1 to 0 by -1;
         input Gall Hyper @@;
         output;
      end;
   end;
   datalines;
0 0  0 0    0 0  0 0    0 1  0 1    0 0  1 0    1 0  0 1
0 1  0 0    1 0  0 0    1 1  0 1    0 0  0 0    0 0  0 0
1 0  0 0    0 0  0 1    1 0  0 1    1 0  1 0    1 0  0 1
0 1  0 0    0 0  1 1    0 0  1 1    0 0  0 1    0 1  0 0
0 0  1 1    0 1  0 1    0 1  0 0    0 0  0 0    0 0  0 0
0 0  0 1    1 0  0 1    0 0  0 1    1 0  0 0    0 1  0 0
0 1  0 0    0 1  0 0    0 1  0 0    0 0  0 0    1 1  1 1
0 0  0 1    0 1  0 0    0 1  0 1    0 1  0 1    0 1  0 0
0 0  0 0    0 1  1 0    0 0  0 1    0 0  0 0    1 0  0 0
0 0  0 0    1 1  0 0    0 1  0 0    0 0  0 0    0 1  0 1
0 0  0 0    0 1  0 1    0 1  0 0    0 1  0 0    1 0  0 0
0 0  0 0    1 1  1 0    0 0  0 0    0 0  0 0    1 1  0 0
1 0  1 0    0 1  0 0    1 0  0 0
;


/*
In the following SAS statements, PROC LOGISTIC is invoked with the ID
variable declared in the STRATA statement to obtain the conditional logistic
model estimates. The model contains Gall as the only predictor variable.
*/

proc logistic data=Data1;
   strata ID;
   model outcome(event='1')=Gall;
run;


/*
When you believe there is not enough data or that the data are too sparse,
you can perform a stratified exact conditional logistic regression.  The
following SAS statements perform exact conditional logistic regressions on
the original data set by specifying both the STRATA and EXACT statements.
*/

proc logistic data=Data1 exactonly;
   strata ID;
   model outcome(event='1')=Gall;
   exact Gall / estimate=both;
run;



/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: LOGIEX12                                            */
/*   TITLE: Example 12 for PROC LOGISTIC                        */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: logistic regression analysis,                       */
/*          exact conditional logistic regression analysis,     */
/*   PROCS: LOGISTIC                                            */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: Bob Derr                                            */
/*     REF: SAS/STAT User's Guide, PROC LOGISTIC chapter        */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

/*****************************************************************
Example 12. Exact Conditional Logistic Regression
****************************************************************/

/* Exact conditional logistic regression is a method that
addresses issues of separability and small sample sizes.

This example from Hand (1994) uses exact conditional logistic
regression to analyze a data set that has quasi-complete
separation.  The resulting exact parameter estimates are used to
predict the success probabilities of the subjects.*/

title 'Example 12. Exact Conditional Logistic Regression';

data one;
   length Diagnosis $ 9;
   input Diagnosis $ Friendships $ Recovered Total @@;
   datalines;
Anxious   Poor 0 0    Anxious   Good 13 21
Depressed Poor 0 8    Depressed Good 15 20
;

proc logistic data=one;
   class Diagnosis Friendships / param=ref;
   model Recovered/Total = Diagnosis Friendships;
run;

proc logistic data=one exactonly;
   class Diagnosis Friendships / param=ref;
   model Recovered/Total = Diagnosis Friendships;
   exact Diagnosis Friendships
       / outdist=dist joint estimate;
run;

proc print data=dist(obs=10);
run;

proc print data=dist(firstobs=162 obs=175);
run;

proc print data=dist(firstobs=176 obs=184);
run;

proc logistic data=one exactonly outest=est;
   class Diagnosis Friendships / param=ref;
   model Recovered/Total = Diagnosis Friendships;
   exact Intercept Diagnosis Friendships / estimate;
run;
proc means data=est noprint;
   output out=out;
run;
data out; set out; if _STAT_='MEAN'; drop _TYPE_; run;
data est(type=est); set out; _TYPE_='PARMS'; run;

proc logistic data=one inest=est;
   class Diagnosis Friendships / param=ref;
   model Recovered/Total = Diagnosis Friendships / maxiter=0;
   score out=score;
run;

proc print data=score;
   var Diagnosis Friendships P_Event;
run;



/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: LOGIEX14                                            */
/*   TITLE: Example 14 for PROC LOGISTIC                        */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: logistic regression analysis,                       */
/*          binomial response data,                             */
/*          CLOGLOG link                                        */
/*   PROCS: LOGISTIC                                            */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: Bob Derr                                            */
/*     REF: SAS/STAT User's Guide, PROC LOGISTIC chapter        */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

/*****************************************************************
Example 14. Complementary log-log Model for Infection Rates
*****************************************************************/

/*
Antibodies produced in response to an infectious disease like malaria remain
in the body after the individual has recovered from the disease. A
serological test detects the presence or absence of antibodies. An individual
with such antibodies is termed seropositive. In areas where the disease is
endemic, the inhabitants are at fairly constant risk of infection. The
probability of an individual never having been infected in Y years is
exp(-uY) where u is the mean number of infections per year (see the
appendix of Draper, C.C., Voller, A., and Carpenter, R.G. 1972, "The
epidemiologic interpretation of serologic data in malaria," American Journal
of Tropical Medicine and Hygiene, 21, 696-703). Rather than estimating the
unknown u, it is of interest to epidemiologists to estimate the probability
of a person living in the area being infected in one year. This infection
rate is 1-exp(-u).

The SAS statements below create the data set SERO, which contains the results
of a serological survey of malaria infection. Individuals of nine age groups
were tested. Variable A represents the midpoint of the age range for each age
group, N represents the number of individuals tested in each age group and R
represents the number of individuals that are sero- positive.
*/

title 'Example 14. CLOGLOG Model for Infection Rates';

data sero;
   input Group A N R;
   X=log(A);
   label X='Log of Midpoint of Age Range';
   datalines;
1  1.5  123  8
2  4.0  132  6
3  7.5  182 18
4 12.5  140 14
5 17.5  138 20
6 25.0  161 39
7 35.0  133 19
8 47.0   92 25
9 60.0   74 44
;


/*
For the ith group with age midpoint A_i, the probability of being
seropositive is p_i=1-exp(-uA_i). It follows that

log(log(1-p_i)) = log(u) + log(A_i)

By fitting a binomial model with a complementary log-log link function and by
using X=log(A) as an offset term, b0=log(u) is estimated as an intercept
parameter. The following SAS statements invoke PROC LOGISTIC to compute the
maximum likelihood estimate of b0. The LINK=CLOGLOG option is specified to
request the complementary log-log link function. Also specified is the
CLPARM=PL option, which produces the profile-likelihood confidence limits for
the b0.
*/

proc logistic data=sero;
   model R/N= / offset=X
                link=cloglog
                clparm=pl
                scale=none;
   title 'Constant Risk of Infection';
run;


/*
The maximum likelihood estimate of b0 is -4.6605. This translates into an
infection rate of 1-exp(-exp(-4.6605))=.00942.  The 95\% confidence interval
for the infection rate, obtained by back-transforming the 95\% confidence
interval for b0, is (.0082, .0011); that is, there is a 95\% chance that the
interval of 8 to 11 infections per thousand individuals contains the true
infection rate.

The goodness-of-fit statistics for the constant risk model are statistically
significant (p<.0001), indicating that the assumption of constant risk of
infection is not correct. One can fit a more extensive model by allowing a
separate risk of infection for each age group. Let u_i be the mean number of
infections per year for the ith age group. The probability of seropositive
for the ith group with age midpoint A_i is p_i=1-exp(-u_iA_i), so that

log(-log(1-p_i)=log(u_i) + log(A_i)

In the following SAS statements, the GLM parameterization creates dummy
variables for the age groups.  PROC LOGISTIC is invoked to fit a
complementary log-log model that contains the dummy variables as the only
explanatory variables with no intercept term and with X=log(A) as an offset
term.  Note that log(u_i) is the regression parameter associated with
GROUP=i.  The DATA statement transforms the estimates and confidence limits
saved in the CLPARMPL data set to estimate the infection rates in one year's
time.
*/

proc logistic data=sero;
   ods output ClparmPL=ClparmPL;
   class Group / param=glm;
   model R/N=Group / noint
                     offset=X
                     link=cloglog
                     clparm=pl;
   title 'Infectious Rates and 95% Confidence Intervals';
run;

data ClparmPL;
   set ClparmPL;
   Estimate=round( 1000*( 1-exp(-exp(Estimate)) ) );
   LowerCL =round( 1000*( 1-exp(-exp(LowerCL )) ) );
   UpperCL =round( 1000*( 1-exp(-exp(UpperCL )) ) );
run;



/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: LOGIEX15                                            */
/*   TITLE: Example 15 for PROC LOGISTIC                        */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: logistic regression analysis,                       */
/*          binomial response data,                             */
/*          CLOGLOG link                                        */
/*   PROCS: LOGISTIC                                            */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: Bob Derr                                            */
/*     REF: SAS/STAT User's Guide, PROC LOGISTIC chapter        */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

/*****************************************************************
Example 15. Complementary Log-Log Model for Interval-Censored Survival Times
*****************************************************************/

/*
Often survival times are not observed more precisely than the interval (for
instance, a day) within which the event occurred.  Survival data of this form
are known as grouped or interval- censored data.  A discrete analogue of the
continuous proportional hazards model (Prentice and Gloeckler 1978; Allison
1982) is used to investigate the relationship between these survival times
and a set of explanatory variables.

As a example of this method. consider a study of the effect of insecticide on
flour beetles.  Four different concentrations of an insecticide were sprayed
on separate groups of flour beetles and the numbers of male and female
flour beetles dying in successive intervals are recorded.  The data are saved
in data set BEETLES below.  This data set contains four variables: TIME, SEX,
CONC, and FREQ.  TIME represents the interval death time; for example, TIME=2
is the interval between day 1 and day 2.  Insects surviving the duration (13
days) of the experiment are given a TIME value of 14.  The variable SEX
represents the sex of the insect (1=male, 2=female), CONC represents the
concentration of the insecticide (mg/cm^2), and FREQ represents the frequency
of the observations.

To use PROC LOGISTIC with the grouped survival data, you must expand the data
so that each beetle has a separate record for each day of survival. A beetle
that died in the third day (time=3) would contribute three observations to
the analysis, one for each day it was alive at the beginning of the day. A
beetle that survives the 13-day duration of the experiment (time=14) would
contribute 13 observations.

A new data set DAYS that contains the beetle-day observations is created from
the data set BEETLES. In addition to the variables SEX, CONC and FREQ, the
data set contains an outcome variable Y and the variable DAY taking the
values 1,...,13.  Y has a value of 1 if the observation corresponds to the
day that the beetle died and has a value of 0 otherwise.

PROC LOGISTIC is invoked to fit a complementary log-log model for binary data
with response variable Y and explanatory variables DAY, SEX, and CONC. Since
the values of Y are coded 0 and 1, specifying the DESCENDING option ensures
that the event (y=1) probability is modeled. The DAY variable is specified
with the GLM coding, which adds a parameter to the model for each of
DAY=1,...,13.  The coefficients of these 13 DAY parameters can be used to
estimate the baseline survival function. The NOINT option is specified to
prevent any redundancy in estimating the coefficients of the DAY effects. The
Newton-Raphson algorithm is used for the maximum likelihood estimation of the
parameters.

Finally, DATA step code is used to compute the survivor curves for
male and female flour beetles exposed to the insecticide of
concentrations .20 mg/cm2 and .80 mg/cm2. The SGPLOT procedure is
used to plot the survival curves. Instead of plotting them as step
functions, the PBSPLINE statement is used to smooth the curves.
*/

title 'Example 15: CLOGLOG Model for Interval-Censored Survival Times';

data Beetles(keep=time sex conc freq);
   input time m20 f20 m32 f32 m50 f50 m80 f80;
   conc=.20; freq= m20; sex=1; output;
             freq= f20; sex=2; output;
   conc=.32; freq= m32; sex=1; output;
             freq= f32; sex=2; output;
   conc=.50; freq= m50; sex=1; output;
             freq= f50; sex=2; output;
   conc=.80; freq= m80; sex=1; output;
             freq= f80; sex=2; output;
   datalines;
 1   3   0  7  1  5  0  4  2
 2  11   2 10  5  8  4 10  7
 3  10   4 11 11 11  6  8 15
 4   7   8 16 10 15  6 14  9
 5   4   9  3  5  4  3  8  3
 6   3   3  2  1  2  1  2  4
 7   2   0  1  0  1  1  1  1
 8   1   0  0  1  1  4  0  1
 9   0   0  1  1  0  0  0  0
10   0   0  0  0  0  0  1  1
11   0   0  0  0  1  1  0  0
12   1   0  0  0  0  1  0  0
13   1   0  0  0  0  1  0  0
14 101 126 19 47  7 17  2  4
;

data Days;
   set Beetles;
   do day=1 to time;
      if (day < 14) then do;
         y= (day=time);
         output;
      end;
   end;
run;

proc logistic data=Days outest=est1;
   class day / param=glm;
   model y(event='1')= day sex conc
         / noint link=cloglog technique=newton;
   freq freq;
run;

data one (keep=day survival element s_m20 s_f20 s_m80 s_f80);
   array dd[13] day1-day13;
   array sc[4] m20 f20 m80 f80;
   array s_sc[4] s_m20 s_f20 s_m80 s_f80 (1 1 1 1);
   set est1;
   m20= exp(sex + .20 * conc);
   f20= exp(2 * sex + .20 * conc);
   m80= exp(sex + .80 * conc);
   f80= exp(2 * sex + .80 * conc);
   survival=1;
   day=0;
   output;
   do day=1 to 13;
      element= exp(-exp(dd[day]));
      survival= survival * element;
      do i=1 to 4;
         s_sc[i] = survival ** sc[i];
      end;
      output;
   end;
run;

%modstyle(name=LogiStyle,parent=htmlblue,markers=circlefilled);
ods listing style=LogiStyle;
proc sgplot data=one;
   title 'Flour Beetles Sprayed with Insecticide';
   xaxis grid integer;
   yaxis grid label='Survival Function';
   pbspline y=s_m20 x=day /
      legendlabel = "Male at 0.20 conc." name="pred1";
   pbspline y=s_m80 x=day /
      legendlabel = "Male at 0.80 conc." name="pred2";
   pbspline y=s_f20 x=day /
      legendlabel = "Female at 0.20 conc." name="pred3";
   pbspline y=s_f80 x=day /
      legendlabel = "Female at 0.80 conc." name="pred4";
   discretelegend "pred1" "pred2" "pred3" "pred4" / across=2;
run;

ods listing close;
ods listing;



/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: LOGIEX16                                            */
/*   TITLE: Example 16 for PROC LOGISTIC                        */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: logistic regression analysis,                       */
/*          binomial response data,                             */
/*   PROCS: LOGISTIC                                            */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: Bob Derr                                            */
/*     REF: SAS/STAT User's Guide, PROC LOGISTIC chapter        */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

/*****************************************************************
Example 16. Scoring Data Sets with the SCORE Statement
*****************************************************************/

/*
The remote-sensing data set contains a response variable, CROP, and
prognostic factors X1 through X4.

Specify a SCORE statement to score the CROPS data using the fitted model. The
data together with the predicted values are saved into the data set SCORE1.
With ODS Graphics enabled, the EFFECTPLOT statement produces a
plot of the model-predicted probabilities for each of the response levels.
This plot shows how the value of X3 affects the probabilities of the various
crops when the other prognostic factors are fixed at their means.

The model is again fit, the data and the predicted values are saved into the
data set SCORE2, and the model information is saved in the permanent SAS data
set SASUSER.CROPMODEL.  The model is also stored in the CROPMODEL2 data set
for later use by the PLM procedure.

The model is then read from the SASUSER.CROPMODEL data set, and the data and
the predicted values are saved into the data set SCORE3.

The CROPMODEL2 model and the data set is input to the PLM procedure, and the
predicted values are saved into the data set SCORE4.

The PRIOR data set contains the values of the response variable (because this
example uses single-trial MODEL statement syntax) and a _PRIOR_ variable
(containing values proportional to the default priors) in order to set prior
probabilities on the responses.  The model is fit, then the data and the
predicted values are saved into the data set SCORE5.

SCORE1, SCORE2, SCORE3, SCORE4, and SCORE5 are identical.

The previously fit data set SASUSER.CROPMODEL is used to score the
new observations in the TEST data set, and the results of scoring
the test data are saved in the SCOREDTEST data set.
*/

title 'Example 16: Scoring Data Sets';

data Crops;
   length Crop $ 10;
   infile datalines truncover;
   input Crop $ @@;
   do i=1 to 3;
      input x1-x4 @@;
      if (x1 ^= .) then output;
   end;
   input;
   datalines;
Corn       16 27 31 33  15 23 30 30  16 27 27 26
Corn       18 20 25 23  15 15 31 32  15 32 32 15
Corn       12 15 16 73
Soybeans   20 23 23 25  24 24 25 32  21 25 23 24
Soybeans   27 45 24 12  12 13 15 42  22 32 31 43
Cotton     31 32 33 34  29 24 26 28  34 32 28 45
Cotton     26 25 23 24  53 48 75 26  34 35 25 78
Sugarbeets 22 23 25 42  25 25 24 26  34 25 16 52
Sugarbeets 54 23 21 54  25 43 32 15  26 54  2 54
Clover     12 45 32 54  24 58 25 34  87 54 61 21
Clover     51 31 31 16  96 48 54 62  31 31 11 11
Clover     56 13 13 71  32 13 27 32  36 26 54 32
Clover     53 08 06 54  32 32 62 16
;

ods graphics on;
proc logistic data=Crops;
   model Crop=x1-x4 / link=glogit;
   score out=Score1;
   effectplot slicefit(x=x3);
run;

proc logistic data=Crops outmodel=sasuser.CropModel;
   model Crop=x1-x4 / link=glogit;
   score data=Crops out=Score2;
   store CropModel2;
run;

proc logistic inmodel=sasuser.CropModel;
   score data=Crops out=Score3;
run;

proc plm source=CropModel2;
   score data=Crops out=ScorePLM predicted=p / ilink;
run;

proc transpose data=ScorePLM out=Score4 prefix=P_ let;
   id _LEVEL_;
   var p;
   by x1-x4  notsorted;
run;
data Score4(drop=_NAME_ _LABEL_);
   merge Score4 Crops(keep=Crop x1-x4);
   F_Crop=Crop;
run;
proc summary data=ScorePLM nway;
   by x1-x4 notsorted;
   var p;
   output out=into maxid(p(_LEVEL_))=I_Crop;
run;
data Score4;
   merge Score4 into(keep=I_Crop);
run;

data Prior;
   length Crop $10.;
   input Crop _PRIOR_;
   datalines;
Clover     11
Corn        7
Cotton      6
Soybeans    6
Sugarbeets  6
;

proc logistic inmodel=sasuser.CropModel;
   score data=Crops prior=prior out=Score5 fitstat;
run;

proc freq data=Score1;
   table F_Crop*I_Crop / nocol nocum nopercent;
run;

data Test;
   input Crop $ 1-10 x1-x4;
   datalines;
Corn       16 27 31 33
Soybeans   21 25 23 24
Cotton     29 24 26 28
Sugarbeets 54 23 21 54
Clover     32 32 62 16
;

proc logistic noprint inmodel=sasuser.CropModel;
   score data=Test out=ScoredTest;
run;

proc print data=ScoredTest label noobs;
   var F_Crop I_Crop P_Clover P_Corn P_Cotton P_Soybeans P_Sugarbeets;
run;



/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: LOGIEX17                                            */
/*   TITLE: Example 17 for PROC LOGISTIC                        */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: logistic regression analysis,                       */
/*          binomial response data,                             */
/*   PROCS: LOGISTIC                                            */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: Bob Derr                                            */
/*     REF: SAS/STAT User's Guide, PROC LOGISTIC chapter        */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

/*****************************************************************
Example 17. Using the LSMEANS Statement
*****************************************************************/

/*
The NEURALGIA data set is used to demonstrate the LSMEANS statement.

A model including an interaction between TREATMENT and SEX is fit.

The ODDSRATIO statement produces odds ratios contrasting pairs of
levels of TREATMENT at each level of SEX, and a brief discussion of
the odds ratio computation is provided.

The LSMEANS statement first displays the LS-means.  The DIFF option
takes differences of the TREATMENT LS-means, the ODDSRATIO option
computes odds ratios of these differences, and the CL option produces
confidence limits for the LS-means and the odds ratios.  In contrast
to the results from the ODDSRATIO statement, there is only one LS-means
odds ratio computed for comparing each pair of TREATMENT levels.
The ADJUST=BON option is specified to adjust the p-values and
confidence intervals for multiplicity.
*/

title 'Example 17. Using the LSMEANS Statement';

Data Neuralgia;
   input Treatment $ Sex $ Age Duration Pain $ @@;
   datalines;
P  F  68   1  No   B  M  74  16  No  P  F  67  30  No
P  M  66  26  Yes  B  F  67  28  No  B  F  77  16  No
A  F  71  12  No   B  F  72  50  No  B  F  76   9  Yes
A  M  71  17  Yes  A  F  63  27  No  A  F  69  18  Yes
B  F  66  12  No   A  M  62  42  No  P  F  64   1  Yes
A  F  64  17  No   P  M  74   4  No  A  F  72  25  No
P  M  70   1  Yes  B  M  66  19  No  B  M  59  29  No
A  F  64  30  No   A  M  70  28  No  A  M  69   1  No
B  F  78   1  No   P  M  83   1  Yes B  F  69  42  No
B  M  75  30  Yes  P  M  77  29  Yes P  F  79  20  Yes
A  M  70  12  No   A  F  69  12  No  B  F  65  14  No
B  M  70   1  No   B  M  67  23  No  A  M  76  25  Yes
P  M  78  12  Yes  B  M  77   1  Yes B  F  69  24  No
P  M  66   4  Yes  P  F  65  29  No  P  M  60  26  Yes
A  M  78  15  Yes  B  M  75  21  Yes A  F  67  11  No
P  F  72  27  No   P  F  70  13  Yes A  M  75   6  Yes
B  F  65   7  No   P  F  68  27  Yes P  M  68  11  Yes
P  M  67  17  Yes  B  M  70  22  No  A  M  65  15  No
P  F  67   1  Yes  A  M  67  10  No  P  F  72  11  Yes
A  F  74   1  No   B  M  80  21  Yes A  F  69   3  No
;

proc logistic data=Neuralgia;
   class Treatment Sex / param=glm;
   model Pain= Treatment|Sex Age;
   oddsratio Treatment;
   lsmeans Treatment / e diff oddsratio cl adjust=bon;
run;

proc logistic data=Neuralgia;
   class Treatment Sex / param=glm;
   model Pain= Treatment|Sex Age;
   lsmestimate treatment 1 0 -1, 0 1 -1 / joint;
run;

proc logistic data=Neuralgia;
   class Treatment Sex / param=glm;
   model Pain= Treatment|Sex Age;
   slice Treatment*Sex / sliceby=Sex diff oddsratio cl adjust=bon;
run;



/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: LOGIEX18                                            */
/*   TITLE: Example 18 for PROC LOGISTIC                        */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: logistic regression analysis,                       */
/*          polytomous response data,                           */
/*          partial proportional odds model                     */
/*   PROCS: LOGISTIC                                            */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: Bob Derr                                            */
/*     REF: SAS/STAT User's Guide, PROC LOGISTIC chapter        */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

/*****************************************************************
Example 18. Partial Proportional Odds Model
*****************************************************************/

/*
title 'Example 18. Partial Proportional Odds Model';

Cameron and Trivedi (1998) studied the number of doctor visits from
the Australian Health Survey 1977-78.  In the following data set,
the dependent variable, DVISITS, contains the number of doctor
visits in the past 2 weeks (0, 1, or more than 2).  The explanatory
variables are: SEX indicates if the patient is female; AGE is the
age in years divided by 100; INCOME is the annual income
(\$10,000); LEVYPLUS indicates if the patient has private health
insurance; FREEPOOR indicates free government health insurance due
to low income; FREEREPA indicates free government health insurance
for other reasons; ILLNESS is the number of illnesses in the past 2
weeks; ACTDAYS is the number of days the illness caused reduced
activity; HSCORE is a questionnaire score; CHCOND1 indicates a
chronic condition that does not limit activity; and CHCOND2
indicates a chronic condition that limits activity.

A proportional odds model is fit to the data.  The test of the
proportional odds assumption rejects the model, so the
UNEQUALSLOPES option is specified to fit a nonproportional odds
model, along with TEST statements to test the proportional odds
assumption for each covariate.  Finally the UNEQUALSLOPES=(ACTDAYS
AGESQ INCOME) option is specified to fit a partial proportional
odds model.*/

data docvisit;
   input sex age agesq income levyplus freepoor freerepa
         illness actdays hscore chcond1 chcond2 dvisits;
   if ( dvisits > 2) then dvisits = 2;
   datalines;
1 0.19 0.0361 0.55  1  0  0  1  4  1  0  0  1
1 0.19 0.0361 0.45  1  0  0  1  2  1  0  0  1
0 0.19 0.0361 0.90  0  0  0  3  0  0  0  0  1
0 0.19 0.0361 0.15  0  0  0  1  0  0  0  0  1
0 0.19 0.0361 0.45  0  0  0  2  5  1  1  0  1
1 0.19 0.0361 0.35  0  0  0  5  1  9  1  0  1
1 0.19 0.0361 0.55  0  0  0  4  0  2  0  0  1
1 0.19 0.0361 0.15  0  0  0  3  0  6  0  0  1
1 0.19 0.0361 0.65  1  0  0  2  0  5  0  0  1
0 0.19 0.0361 0.15  1  0  0  1  0  0  0  0  1
0 0.19 0.0361 0.45  0  0  0  1  0  0  0  0  1
0 0.19 0.0361 0.25  0  0  1  2  0  2  0  0  1
0 0.19 0.0361 0.55  0  0  0  3 13  1  1  0  2
0 0.19 0.0361 0.45  0  0  0  4  7  6  1  0  1
0 0.19 0.0361 0.25  1  0  0  3  1  0  1  0  1
0 0.19 0.0361 0.55  0  0  0  2  0  7  0  0  1
0 0.19 0.0361 0.45  1  0  0  1  0  5  0  0  2
1 0.19 0.0361 0.45  0  0  0  1  1  0  1  0  1
1 0.19 0.0361 0.45  1  0  0  1  0  0  0  0  2
1 0.19 0.0361 0.35  1  0  0  1  0  0  0  0  1
1 0.19 0.0361 0.45  1  0  0  1  3  0  0  0  1
1 0.19 0.0361 0.35  1  0  0  1  0  1  0  0  1
0 0.19 0.0361 0.45  1  0  0  2  2  0  0  0  1
0 0.19 0.0361 0.55  0  0  0  2 14  2  0  0  1
1 0.19 0.0361 0.25  0  0  1  2 14 11  0  1  1
1 0.19 0.0361 0.15  0  1  0  1  2  6  1  0  1
1 0.19 0.0361 0.55  0  0  0  2  5  6  0  0  1
0 0.19 0.0361 0.00  0  1  0  1  0  0  1  0  1
1 0.19 0.0361 0.45  0  0  0  1  0  1  0  1  1
0 0.19 0.0361 0.25  1  0  0  1  0  0  0  1  1
0 0.19 0.0361 0.35  0  0  0  1  2  0  0  0  2
1 0.19 0.0361 0.65  1  0  0  1  1  1  0  0  1
0 0.19 0.0361 0.45  0  0  0  1 14  2  0  0  1
1 0.19 0.0361 0.06  0  1  0  1  0  0  0  0  1
1 0.19 0.0361 0.45  1  0  0  4  0  0  1  0  1
0 0.19 0.0361 0.00  0  0  0  1  4  0  0  0  3
1 0.19 0.0361 1.10  1  0  0  2  0  1  0  0  1
1 0.19 0.0361 0.35  1  0  0  1  0  0  1  0  1
1 0.19 0.0361 0.65  1  0  0  2  0  0  1  0  1
0 0.19 0.0361 0.75  0  0  0  1  0  1  1  0  2
0 0.19 0.0361 0.35  1  0  0  1  2  0  1  0  1
0 0.19 0.0361 0.55  0  0  0  4  5  2  0  0  4
0 0.19 0.0361 0.25  0  0  0  1  0  0  0  0  1
0 0.19 0.0361 0.55  0  0  0  2  0  1  0  0  1
1 0.19 0.0361 0.55  0  0  1  2  3  0  0  1  1
1 0.19 0.0361 0.25  0  1  0  1  0  1  1  0  1
1 0.19 0.0361 0.15  0  0  0  1  4  2  0  0  3
1 0.19 0.0361 0.25  0  0  0  2  7  0  0  1  8
0 0.19 0.0361 0.65  0  0  0  3  0  0  0  1  1
0 0.19 0.0361 0.15  0  1  0  1  0  4  0  0  1
1 0.19 0.0361 0.55  1  0  0  1  0  1  0  0  1
1 0.19 0.0361 0.55  1  0  0  1  0  0  0  0  1
1 0.19 0.0361 0.55  0  0  0  2  0  0  0  1  1
1 0.19 0.0361 0.35  1  0  0  3  0  0  1  0  1
1 0.19 0.0361 0.55  0  0  0  4  0  1  0  0  1
1 0.19 0.0361 0.15  0  0  0  3  1  0  1  0  4
1 0.19 0.0361 0.15  0  0  0  3  0  0  0  0  1
1 0.19 0.0361 0.45  1  0  0  2  2  0  1  0  2
0 0.19 0.0361 0.25  0  1  0  1  0  0  0  0  2
1 0.19 0.0361 0.15  0  1  0  2  0  0  1  0  2
1 0.19 0.0361 0.55  1  0  0  2  0  5  0  0  2
1 0.19 0.0361 0.45  0  0  0  5  2  5  0  1  2
1 0.19 0.0361 0.45  0  0  0  2  1  1  0  0  1
1 0.19 0.0361 0.65  0  0  0  2  1  0  0  0  1
1 0.19 0.0361 0.45  0  0  0  2  0  0  1  0  1
1 0.19 0.0361 0.01  0  0  0  4  0  0  1  0  1
0 0.19 0.0361 0.55  1  0  0  1  0  0  0  0  1
1 0.19 0.0361 0.45  1  0  0  3  0  0  0  0  1
0 0.19 0.0361 0.55  0  0  0  2  0  2  0  0  2
1 0.19 0.0361 0.35  0  0  0  1  0  2  1  0  1
0 0.19 0.0361 0.15  0  0  0  1  0  2  0  0  1
0 0.19 0.0361 0.55  1  0  0  3  6  1  0  0  1
1 0.19 0.0361 0.25  0  0  0  4  0  1  0  0  1
1 0.19 0.0361 0.35  1  0  0  3  0  0  1  0  1
0 0.19 0.0361 0.06  0  0  0  2  0 12  0  0  1
1 0.19 0.0361 0.45  0  0  0  3  3  4  0  0  2
1 0.19 0.0361 0.55  1  0  0  2  2  0  0  0  1
0 0.19 0.0361 0.35  0  0  0  1 14  1  0  0  4
0 0.19 0.0361 0.75  0  0  0  1  8  1  0  0  2
1 0.19 0.0361 0.15  0  0  0  1  3  0  1  0  4
1 0.19 0.0361 0.45  1  0  0  2 14  6  0  1  4
1 0.19 0.0361 0.15  0  1  0  2  0  1  1  0  1
1 0.19 0.0361 0.25  0  0  1  1  0  9  0  0  1
1 0.19 0.0361 0.35  0  0  0  5 14  3  0  0  1
1 0.19 0.0361 0.35  0  1  0  2  1  0  0  0  1
1 0.19 0.0361 0.55  0  0  0  1  6  0  0  0  5
1 0.19 0.0361 0.35  0  0  0  1  0  0  0  0  1
1 0.19 0.0361 0.65  1  0  0  2  3  2  0  0  1
0 0.19 0.0361 0.25  0  0  0  3  2  3  0  0  2
1 0.19 0.0361 0.55  1  0  0  3  1  2  1  0  1
1 0.19 0.0361 0.35  1  0  0  2  0  2  0  0  1
0 0.19 0.0361 0.45  0  0  0  2  2  2  0  0  1
0 0.19 0.0361 0.45  0  0  0  1 14  0  0  0  1
1 0.19 0.0361 0.65  0  0  0  3  0  0  0  1  1
0 0.19 0.0361 0.65  1  0  0  2  0  0  0  0  2
0 0.19 0.0361 0.45  0  0  0  1 14  3  0  0  1
1 0.19 0.0361 0.45  1  0  0  2  0  0  0  0  1
1 0.19 0.0361 0.45  1  0  0  1  0  2  0  0  1
1 0.19 0.0361 0.55  1  0  0  3  0  2  0  0  1
1 0.19 0.0361 0.55  1  0  0  3  0  2  0  0  1
0 0.19 0.0361 1.10  0  0  0  2  7  0  0  0  1
0 0.19 0.0361 0.65  0  0  0  2  0  0  1  0  1
0 0.19 0.0361 0.55  1  0  0  2  5  0  1  0  2
1 0.19 0.0361 0.45  1  0  0  0  0  0  0  0  1
0 0.19 0.0361 0.25  1  0  0  0  0  1  0  0  1
1 0.19 0.0361 0.35  1  0  0  0  0  6  1  0  1
1 0.19 0.0361 0.45  0  0  0  0  0  0  0  0  1
1 0.19 0.0361 0.65  1  0  0  0  0  0  0  0  1
1 0.19 0.0361 0.45  1  0  0  0  0  1  0  0  1
1 0.19 0.0361 0.65  0  0  0  0  0  0  0  0  1
0 0.19 0.0361 0.55  0  0  0  0  1  0  0  0  1
0 0.19 0.0361 0.55  0  1  0  0  0  0  1  0  1
0 0.19 0.0361 0.65  1  0  0  0  0  0  0  0  1
1 0.19 0.0361 0.45  0  0  0  0  0  0  0  0  1
0 0.22 0.0484 0.00  0  1  0  1 14  1  1  0  7
1 0.22 0.0484 0.65  0  0  0  4  0  1  1  0  1
1 0.22 0.0484 0.45  0  0  0  2  0  0  1  0  1
1 0.22 0.0484 0.45  0  0  0  1  0  5  1  0  2
0 0.22 0.0484 1.10  1  0  0  2  7  1  1  0  1
1 0.22 0.0484 0.65  1  0  0  1  0  2  0  0  2
0 0.22 0.0484 0.35  0  0  0  4  0  3  1  0  2
0 0.22 0.0484 0.75  0  0  0  5  0  6  1  0  1
0 0.22 0.0484 0.15  1  0  0  2  5  2  1  0  2
0 0.22 0.0484 0.75  0  0  0  4  0  3  1  0  1
0 0.22 0.0484 0.65  0  0  0  3  0  2  0  0  1
0 0.22 0.0484 0.75  1  0  0  3  6  3  1  0  1
1 0.22 0.0484 0.65  1  0  0  1  0  5  0  0  1
0 0.22 0.0484 0.65  1  0  0  3  0  0  0  0  2
1 0.22 0.0484 0.55  1  0  0  1  0  1  1  0  1
1 0.22 0.0484 0.25  1  0  0  1  0 10  1  0  1
1 0.22 0.0484 0.55  0  0  0  2  0  6  0  0  1
0 0.22 0.0484 0.90  1  0  0  1  0  5  1  0  1
1 0.22 0.0484 0.45  0  0  0  4  4  5  0  1  1
1 0.22 0.0484 0.55  0  0  0  1  0  0  0  0  1
1 0.22 0.0484 0.65  1  0  0  2  4  3  0  0  1
1 0.22 0.0484 0.25  1  0  0  4  0  1  0  0  1
0 0.22 0.0484 0.45  0  0  0  2  0  1  0  0  1
1 0.22 0.0484 0.75  1  0  0  1  0  1  1  0  1
1 0.22 0.0484 0.45  0  0  0  2  1  2  0  1  1
0 0.22 0.0484 0.25  0  0  1  2  0 12  0  1  1
1 0.22 0.0484 0.90  1  0  0  2  0  0  1  0  1
1 0.22 0.0484 0.90  1  0  0  4  1  0  1  0  1
1 0.22 0.0484 0.75  0  0  0  1  0  0  0  0  1
1 0.22 0.0484 0.25  0  0  1  1  0  0  0  1  1
1 0.22 0.0484 0.35  0  0  0  3  7  3  0  0  1
1 0.22 0.0484 0.75  1  0  0  2  0  3  0  0  1
0 0.22 0.0484 1.30  1  0  0  4  0  1  0  0  1
0 0.22 0.0484 1.10  1  0  0  3  0  0  0  1  1
0 0.22 0.0484 0.75  0  0  0  2  0  3  1  0  1
0 0.22 0.0484 0.55  0  0  0  1  3  0  0  0  5
0 0.22 0.0484 0.65  0  0  0  1  0  0  0  0  1
0 0.22 0.0484 0.15  1  0  0  2  9  1  1  0  1
1 0.22 0.0484 0.55  0  0  1  5  2  3  0  1  2
1 0.22 0.0484 0.15  0  1  0  3  0  0  0  1  1
1 0.22 0.0484 0.25  0  1  0  2  0  0  1  0  1
0 0.22 0.0484 0.75  1  0  0  5  0  5  1  0  1
1 0.22 0.0484 0.55  1  0  0  1  0  0  0  0  1
1 0.22 0.0484 0.15  1  0  0  5  0  1  0  0  1
1 0.22 0.0484 0.90  0  0  0  2  0  0  1  0  1
1 0.22 0.0484 0.55  1  0  0  4  3  1  1  0  1
1 0.22 0.0484 0.75  1  0  0  2  0  2  1  0  2
1 0.22 0.0484 0.90  0  0  0  1  4  0  0  0  1
1 0.22 0.0484 0.90  0  0  0  1 14  0  0  0  1
1 0.22 0.0484 0.55  1  0  0  1  0  0  0  0  2
1 0.22 0.0484 0.90  1  0  0  1  0  1  1  0  1
1 0.22 0.0484 1.10  1  0  0  1  0  0  1  0  1
0 0.22 0.0484 0.75  1  0  0  1  0  1  0  0  1
1 0.22 0.0484 0.45  1  0  0  2  0  0  0  1  2
0 0.22 0.0484 0.90  1  0  0  1  2  2  0  0  1
1 0.22 0.0484 0.90  1  0  0  1  2  0  1  0  1
1 0.22 0.0484 0.90  1  0  0  2  0  6  1  0  1
0 0.22 0.0484 0.25  0  0  0  1  6  3  0  1  1
1 0.22 0.0484 0.65  1  0  0  2  7  0  0  0  1
0 0.22 0.0484 0.90  1  0  0  1  0  0  0  0  1
0 0.22 0.0484 0.75  0  0  0  1  0  2  0  0  1
0 0.22 0.0484 0.90  0  0  0  3  4  0  0  0  1
0 0.22 0.0484 0.75  0  0  0  1  0  0  0  0  1
1 0.22 0.0484 0.25  0  0  0  2  6  0  0  0  2
1 0.22 0.0484 0.65  1  0  0  2  2  0  0  0  1
1 0.22 0.0484 0.90  0  0  0  1  6  0  0  0  1
0 0.22 0.0484 0.55  0  0  0  1  0  0  1  0  1
0 0.22 0.0484 1.10  1  0  0  4  1  3  1  0  1
1 0.22 0.0484 0.55  1  0  0  1  7  0  0  0  1
1 0.22 0.0484 0.75  1  0  0  2 14  2  1  0  2
0 0.22 0.0484 1.10  1  0  0  1  1  0  0  0  1
0 0.22 0.0484 0.90  1  0  0  1  3  1  1  0  1
1 0.22 0.0484 0.65  1  0  0  1  3  0  1  0  1
1 0.22 0.0484 0.06  1  0  0  3  0  7  0  1  2
0 0.22 0.0484 0.35  0  0  0  2  2  4  1  0  1
1 0.22 0.0484 0.75  1  0  0  2  3  0  1  0  1
0 0.22 0.0484 0.90  0  0  0  1  0  1  0  0  1
0 0.22 0.0484 1.50  1  0  0  2 14  5  0  0  1
0 0.22 0.0484 0.65  0  0  0  4  0  8  1  0  1
0 0.22 0.0484 1.10  1  0  0  3  0  0  1  0  1
0 0.22 0.0484 0.65  1  0  0  3 14  1  0  0  1
0 0.22 0.0484 0.65  0  0  0  1  0  1  0  0  1
1 0.22 0.0484 0.65  1  0  0  1  0  1  0  0  1
1 0.22 0.0484 0.45  0  1  0  3  5 10  1  0  5
1 0.22 0.0484 0.55  0  0  0  2  0  0  1  0  1
0 0.22 0.0484 0.15  1  0  0  1  0  0  0  0  1
0 0.22 0.0484 0.65  0  0  0  2  8  0  0  0  1
1 0.22 0.0484 0.15  1  0  0  3  4  1  0  1  1
0 0.22 0.0484 0.65  0  0  0  2  0  7  0  0  2
1 0.22 0.0484 0.00  0  1  0  3  3  9  0  1  4
0 0.22 0.0484 0.65  1  0  0  1  1 11  1  0  1
1 0.22 0.0484 0.55  1  0  0  3 10  2  0  1  2
0 0.22 0.0484 0.65  1  0  0  1  0  0  0  0  1
1 0.22 0.0484 0.25  0  0  0  1  0  0  0  0  1
1 0.22 0.0484 0.35  0  0  1  2  0  5  0  0  1
1 0.22 0.0484 1.10  1  0  0  1  0  1  0  0  1
1 0.22 0.0484 0.90  0  0  0  2  0  0  0  0  1
1 0.22 0.0484 0.65  1  0  0  1  0  2  0  0  1
1 0.22 0.0484 0.75  1  0  0  1  0  0  0  0  1
1 0.22 0.0484 0.75  0  0  0  3  1  0  1  0  1
0 0.22 0.0484 1.50  1  0  0  1  0  3  0  1  4
0 0.22 0.0484 0.75  1  0  0  2  0  0  0  0  1
1 0.22 0.0484 0.35  0  0  0  2  0  0  0  0  1
0 0.22 0.0484 0.65  0  0  0  4  4  2  0  0  2
0 0.22 0.0484 1.10  0  0  0  1  0  0  0  0  1
1 0.22 0.0484 0.25  0  0  0  1  0  1  0  0  1
0 0.22 0.0484 1.10  0  0  0  2  0  0  1  0  3
0 0.22 0.0484 0.35  1  0  0  2  0  0  1  0  1
1 0.22 0.0484 0.00  0  1  0  2  2  6  1  0  1
1 0.22 0.0484 1.10  1  0  0  5  0  1  1  0  1
0 0.22 0.0484 0.90  0  0  0  2  1  3  0  0  1
1 0.22 0.0484 0.75  0  0  0  2  0  0  1  0  1
0 0.22 0.0484 0.55  0  0  0  2 14  1  0  1  1
0 0.22 0.0484 0.55  0  0  0  3  0  0  0  0  2
1 0.22 0.0484 0.65  0  0  0  4  7  7  0  0  1
0 0.22 0.0484 0.75  1  0  0  2  0  1  1  0  1
0 0.22 0.0484 0.45  0  1  0  2 14  9  0  0  1
0 0.22 0.0484 1.50  1  0  0  3  8  1  0  0  1
0 0.22 0.0484 0.45  0  0  0  1  0  0  0  0  2
0 0.22 0.0484 0.90  0  0  0  2  5  5  0  0  1
0 0.22 0.0484 0.65  1  0  0  1 14  1  0  0  4
0 0.22 0.0484 1.50  1  0  0  5  0  0  1  0  1
1 0.22 0.0484 0.25  0  0  0  2 10  1  0  0  2
1 0.22 0.0484 0.75  1  0  0  1  0  4  0  0  2
1 0.22 0.0484 0.15  1  0  0  1  0  0  0  0  1
1 0.22 0.0484 0.45  1  0  0  3  1  1  1  0  2
0 0.22 0.0484 0.06  1  0  0  1  0  6  0  0  1
0 0.22 0.0484 0.45  0  0  0  1 12  1  0  0  4
1 0.22 0.0484 0.65  1  0  0  1  1  0  0  0  1
1 0.22 0.0484 0.75  0  0  0  3 14  2  1  0  2
1 0.22 0.0484 0.65  1  0  0  3  0  7  0  1  1
0 0.22 0.0484 0.65  0  0  0  1  0  1  0  0  1
0 0.22 0.0484 0.90  0  0  0  1 11  1  0  0  4
1 0.22 0.0484 0.35  0  0  0  4  0  0  0  0  1
1 0.22 0.0484 0.15  0  0  1  1 14  0  1  0  1
1 0.22 0.0484 0.75  0  0  0  1  0  0  0  0  1
0 0.22 0.0484 0.65  0  0  0  1  1  0  0  0  1
0 0.22 0.0484 1.10  0  0  0  1  0  0  0  0  1
0 0.22 0.0484 0.75  1  0  0  2  0  0  0  1  2
0 0.22 0.0484 0.45  0  0  0  1  0  1  0  0  1
0 0.22 0.0484 0.55  0  0  0  2  0  0  0  0  1
0 0.22 0.0484 0.06  0  0  0  2  0  1  0  0  2
0 0.22 0.0484 0.90  1  0  0  2  0  2  0  0  1
1 0.22 0.0484 0.65  1  0  0  3  2  0  0  1  2
0 0.22 0.0484 0.45  0  0  0  1  0  1  0  0  1
1 0.22 0.0484 0.55  0  0  0  2  0  0  0  0  1
0 0.22 0.0484 0.65  0  0  0  1  1  0  0  0  2
0 0.22 0.0484 0.35  0  0  0  2  0  0  1  0  2
0 0.22 0.0484 0.90  0  0  0  1 10  6  1  0  3
0 0.22 0.0484 0.75  0  0  0  3  2  1  1  0  2
0 0.22 0.0484 0.65  0  0  0  1 10  2  0  0  4
1 0.22 0.0484 0.55  0  0  0  2  7  0  0  0  3
0 0.22 0.0484 0.25  1  0  0  0  0  0  1  0  2
0 0.22 0.0484 0.75  1  0  0  0  0  0  1  0  1
0 0.22 0.0484 0.90  0  0  0  0 14  1  1  0  2
1 0.22 0.0484 0.35  1  0  0  0  0  2  0  0  1
0 0.22 0.0484 0.65  1  0  0  0  0  2  0  1  1
0 0.22 0.0484 0.90  1  0  0  0  0  0  0  0  1
0 0.22 0.0484 0.75  1  0  0  0  0  1  0  0  1
1 0.22 0.0484 0.90  1  0  0  0  0  0  0  0  1
1 0.22 0.0484 0.90  1  0  0  0  0  0  0  0  1
1 0.22 0.0484 0.65  0  0  0  0  0  0  1  0  1
1 0.22 0.0484 0.15  0  0  0  0  0  0  0  0  1
0 0.22 0.0484 0.90  0  0  0  0  0  0  0  0  1
1 0.22 0.0484 0.90  1  0  0  0  0  0  0  0  1
1 0.22 0.0484 0.55  0  0  0  0  0  0  0  0  1
0 0.22 0.0484 0.65  1  0  0  0  0  1  0  0  1
0 0.22 0.0484 0.06  1  0  0  0  0  0  0  1  1
0 0.22 0.0484 0.90  0  0  0  0  0  0  0  0  3
0 0.22 0.0484 0.75  0  0  0  0  0  0  0  0  1
0 0.22 0.0484 0.06  0  0  0  0  1  0  0  0  2
1 0.22 0.0484 0.15  0  0  0  0  0  0  0  0  1
1 0.22 0.0484 1.10  0  0  0  0  0  0  0  0  1
1 0.22 0.0484 0.90  1  0  0  0  0  2  0  0  1
1 0.27 0.0729 0.90  0  0  0  3  0  4  1  0  1
1 0.27 0.0729 0.90  1  0  0  1  0  3  0  0  2
1 0.27 0.0729 1.10  0  0  0  2  0  1  0  0  1
1 0.27 0.0729 0.90  1  0  0  4  0  0  1  0  2
1 0.27 0.0729 0.00  1  0  0  2  0  5  0  0  2
1 0.27 0.0729 0.90  1  0  0  1  0  4  0  1  2
1 0.27 0.0729 1.30  1  0  0  1  7  4  1  0  2
1 0.27 0.0729 0.25  0  0  1  2  0  0  0  1  1
1 0.27 0.0729 0.90  0  0  0  3 14  4  0  1  2
1 0.27 0.0729 1.10  1  0  0  2  3  8  1  0  1
0 0.27 0.0729 0.75  1  0  0  4  2  1  1  0  1
1 0.27 0.0729 0.15  0  0  0  3  3  6  0  0  1
1 0.27 0.0729 0.90  1  0  0  5  1  5  1  0  1
1 0.27 0.0729 1.50  1  0  0  1  0  6  0  0  1
0 0.27 0.0729 0.55  0  0  0  3  2  1  0  0  1
0 0.27 0.0729 0.25  0  0  1  3  0  3  0  1  1
1 0.27 0.0729 0.90  1  0  0  2  0  2  0  0  1
1 0.27 0.0729 0.55  0  0  0  1  0  3  0  0  1
0 0.27 0.0729 0.90  0  0  0  1  0  0  1  0  1
0 0.27 0.0729 0.90  0  0  0  2  1 11  1  0  1
0 0.27 0.0729 1.10  0  0  0  2  0  1  0  0  1
0 0.27 0.0729 0.55  0  0  0  4  8  8  0  0  2
1 0.27 0.0729 0.90  1  0  0  1  0  0  1  0  1
1 0.27 0.0729 1.30  0  0  0  2  5  0  1  0  1
1 0.27 0.0729 1.30  1  0  0  2  1  0  0  1  1
0 0.27 0.0729 1.50  1  0  0  1  0  0  1  0  1
0 0.27 0.0729 0.90  1  0  0  2  1  0  0  0  1
1 0.27 0.0729 0.55  0  0  0  2  8 10  1  0  2
0 0.27 0.0729 0.35  1  0  0  1  3  0  0  0  1
0 0.27 0.0729 1.10  1  0  0  2  3  3  0  0  1
0 0.27 0.0729 1.30  1  0  0  1  2  3  0  1  1
0 0.27 0.0729 0.90  0  0  0  1  0  0  1  0  1
1 0.27 0.0729 0.65  1  0  0  2  3  0  0  0  1
1 0.27 0.0729 0.90  1  0  0  5  1 11  1  0  2
1 0.27 0.0729 0.65  1  0  0  1  4  1  1  0  1
1 0.27 0.0729 0.35  1  0  0  1 14  1  1  0  5
1 0.27 0.0729 1.30  1  0  0  1  7  2  0  0  2
0 0.27 0.0729 0.90  1  0  0  1  5  2  0  0  2
0 0.27 0.0729 0.65  1  0  0  1  3  1  0  0  1
0 0.27 0.0729 0.90  1  0  0  1  3  0  0  0  1
1 0.27 0.0729 0.65  0  0  0  2  5  1  1  0  1
1 0.27 0.0729 0.25  1  0  0  1  4  0  0  1  1
0 0.27 0.0729 0.90  0  0  0  3  5  1  0  1  3
1 0.27 0.0729 0.75  1  0  0  2  2  2  0  1  2
1 0.27 0.0729 0.06  0  1  0  5  3 12  1  0  1
1 0.27 0.0729 0.90  1  0  0  1  3  0  0  0  7
0 0.27 0.0729 1.50  0  0  0  5  0  0  1  0  1
1 0.27 0.0729 1.10  0  0  0  3  3  0  0  0  1
1 0.27 0.0729 0.00  0  0  1  1  0  5  0  0  3
0 0.27 0.0729 0.75  0  0  0  3  0  7  1  0  1
0 0.27 0.0729 1.30  0  0  0  2  0  0  0  0  3
1 0.27 0.0729 0.55  1  0  0  3  3  1  1  0  1
0 0.27 0.0729 1.50  1  0  0  1  4  1  0  1  2
0 0.27 0.0729 1.10  1  0  0  1  1  0  0  1  1
1 0.27 0.0729 0.75  1  0  0  2  3  1  1  0  1
0 0.27 0.0729 0.90  1  0  0  1  4  1  0  1  1
0 0.27 0.0729 1.30  0  0  0  1 14  7  1  0  5
0 0.27 0.0729 0.90  1  0  0  2  5  1  0  1  1
1 0.27 0.0729 1.10  1  0  0  1  0  0  0  0  1
1 0.27 0.0729 0.15  0  0  1  1  1  3  0  0  2
1 0.27 0.0729 0.35  0  0  1  1  0  4  0  0  1
1 0.27 0.0729 0.45  0  0  0  2  0  2  0  1  1
0 0.27 0.0729 1.30  1  0  0  2  7  0  0  0  2
0 0.27 0.0729 0.90  1  0  0  2  4  1  0  0  1
1 0.27 0.0729 0.65  0  0  0  4  0  2  0  0  1
0 0.27 0.0729 1.30  1  0  0  5  0  0  1  0  1
1 0.27 0.0729 0.75  0  0  0  2  8  0  0  0  7
0 0.27 0.0729 1.10  1  0  0  3  2  5  0  0  1
1 0.27 0.0729 1.10  1  0  0  1  2  2  1  0  1
1 0.27 0.0729 0.75  1  0  0  1  1  0  0  0  2
0 0.27 0.0729 0.90  1  0  0  1  1  0  0  0  1
1 0.27 0.0729 0.65  0  0  0  3 14 10  1  0  1
0 0.27 0.0729 1.50  1  0  0  2  0  1  0  1  1
1 0.27 0.0729 1.10  1  0  0  1  0  0  0  0  2
0 0.27 0.0729 1.10  1  0  0  1  0  3  0  0  2
0 0.27 0.0729 0.55  1  0  0  2  0  0  1  0  2
0 0.27 0.0729 0.25  1  0  0  2  0  0  1  0  2
0 0.27 0.0729 0.65  0  0  0  5  3  3  1  0  3
1 0.27 0.0729 0.75  1  0  0  1 14  0  1  0  1
0 0.27 0.0729 1.50  0  0  0  1 14  5  0  0  1
1 0.27 0.0729 0.75  1  0  0  0  0  2  0  0  1
1 0.27 0.0729 1.50  1  0  0  0  0  0  0  0  1
0 0.27 0.0729 0.65  1  0  0  0  0  0  0  0  1
0 0.27 0.0729 1.30  0  0  0  0  0  1  0  0  1
1 0.27 0.0729 0.75  0  0  0  0  0  0  0  0  1
0 0.27 0.0729 0.35  0  0  0  0  0  0  0  0  1
1 0.27 0.0729 0.90  1  0  0  0  0  0  0  0  1
0 0.32 0.1024 0.90  1  0  0  2  3  2  0  0  1
1 0.32 0.1024 0.90  1  0  0  4  5  1  1  0  2
1 0.32 0.1024 1.10  1  0  0  5  1  4  1  0  2
0 0.32 0.1024 0.25  0  0  1  2  0  2  0  1  1
0 0.32 0.1024 1.50  1  0  0  2  0  1  0  0  1
1 0.32 0.1024 1.10  1  0  0  2  2  0  1  0  1
1 0.32 0.1024 0.90  1  0  0  1  0  0  0  0  1
0 0.32 0.1024 0.65  0  0  0  4  0 12  1  0  1
0 0.32 0.1024 1.50  1  0  0  2  0  4  1  0  1
1 0.32 0.1024 0.15  0  0  0  4  0  6  0  0  1
0 0.32 0.1024 0.75  0  0  0  2  0  7  0  0  1
0 0.32 0.1024 0.45  1  0  0  4  0  8  0  0  1
0 0.32 0.1024 0.25  0  0  1  3  0  4  0  1  1
0 0.32 0.1024 0.90  1  0  0  2  0  1  0  0  2
0 0.32 0.1024 0.75  0  0  0  4  0  3  0  1  1
1 0.32 0.1024 0.25  0  0  1  2  0  0  0  1  1
1 0.32 0.1024 0.55  0  0  1  1 14  8  0  1  4
1 0.32 0.1024 0.75  1  0  0  1  0  0  0  1  1
0 0.32 0.1024 0.90  1  0  0  2 12  3  1  0  3
1 0.32 0.1024 1.10  1  0  0  4  2  6  1  0  1
0 0.32 0.1024 0.75  0  0  0  2  1  1  0  0  1
0 0.32 0.1024 1.10  0  0  0  3  0  3  1  0  1
1 0.32 0.1024 1.50  1  0  0  1  5  2  1  0  1
0 0.32 0.1024 0.45  0  0  0  2  0  0  1  0  2
1 0.32 0.1024 1.30  1  0  0  1  0  0  0  0  1
0 0.32 0.1024 1.50  0  0  0  1  4  6  0  0  1
0 0.32 0.1024 1.30  0  0  0  1  7  3  1  0  1
0 0.32 0.1024 0.55  1  0  0  1  5  0  0  0  1
1 0.32 0.1024 1.30  1  0  0  1  6  4  0  1  4
1 0.32 0.1024 0.65  0  0  0  1  8  0  0  0  1
1 0.32 0.1024 1.30  1  0  0  2  0  0  0  1  1
0 0.32 0.1024 0.90  0  0  0  5  9  3  0  1  2
1 0.32 0.1024 0.75  1  0  0  1  0  1  0  0  1
0 0.32 0.1024 0.25  0  0  0  1  0  0  0  0  1
0 0.32 0.1024 1.50  1  0  0  1  0  0  1  0  1
0 0.32 0.1024 0.25  1  0  0  2 14  1  0  1  1
0 0.32 0.1024 1.50  1  0  0  2  0  0  0  0  1
0 0.32 0.1024 1.30  1  0  0  5 14  9  0  1  2
0 0.32 0.1024 0.75  0  0  0  1  0  1  1  0  1
1 0.32 0.1024 0.90  1  0  0  3  0  3  1  0  3
1 0.32 0.1024 0.15  1  0  0  4 14  0  0  1  7
1 0.32 0.1024 0.45  1  0  0  1  5  7  0  1  1
0 0.32 0.1024 0.25  0  0  1  2  0  4  1  0  1
0 0.32 0.1024 0.65  1  0  0  2  0  0  0  0  1
0 0.32 0.1024 0.35  1  0  0  0  0  3  1  0  1
1 0.32 0.1024 0.90  1  0  0  0  0  0  0  0  1
1 0.32 0.1024 0.15  1  0  0  0  0  1  0  0  2
0 0.32 0.1024 1.30  0  0  0  0  0 12  0  0  1
0 0.32 0.1024 1.50  1  0  0  0  0  0  1  0  1
0 0.32 0.1024 1.50  1  0  0  0  0  0  0  0  1
1 0.37 0.1369 1.10  1  0  0  1  0  0  0  0  1
0 0.37 0.1369 0.90  1  0  0  4  2  2  0  0  1
0 0.37 0.1369 1.10  1  0  0  2  0  7  0  1  1
1 0.37 0.1369 1.10  1  0  0  2  0  7  0  0  1
1 0.37 0.1369 0.45  1  0  0  2 14  4  0  0  1
1 0.37 0.1369 0.25  1  0  0  3  1  1  0  1  1
1 0.37 0.1369 0.25  0  0  0  3  0  0  1  0  1
1 0.37 0.1369 0.90  1  0  0  1  1  0  1  0  1
1 0.37 0.1369 0.90  1  0  0  1  0  0  1  0  1
0 0.37 0.1369 1.30  1  0  0  2  0  3  1  0  1
1 0.37 0.1369 0.06  0  1  0  2  0  0  0  0  1
0 0.37 0.1369 0.75  1  0  0  1  0  0  0  1  1
1 0.37 0.1369 1.50  1  0  0  2 14  7  0  1  1
1 0.37 0.1369 0.65  1  0  0  2  1  5  1  0  2
1 0.37 0.1369 0.55  1  0  0  1  3  0  0  0  1
0 0.37 0.1369 1.50  0  0  0  1  3  2  1  0  1
1 0.37 0.1369 1.50  1  0  0  1  0  0  1  0  1
0 0.37 0.1369 0.65  1  0  0  2  5  0  1  0  2
1 0.37 0.1369 0.45  0  0  0  1  7  2  1  0  3
1 0.37 0.1369 1.50  1  0  0  1  0  0  0  1  2
0 0.37 0.1369 0.65  0  0  0  1  0  0  0  0  1
1 0.37 0.1369 0.90  1  0  0  3  3  0  0  1  2
0 0.37 0.1369 0.55  1  0  0  3  7 12  0  1  3
1 0.37 0.1369 0.35  1  0  0  1 14  7  0  1  3
0 0.37 0.1369 0.75  0  0  0  1  0  0  0  0  1
0 0.37 0.1369 1.50  1  0  0  0  0  1  0  0  1
0 0.42 0.1764 1.50  0  0  0  4  0  4  1  0  1
0 0.42 0.1764 0.65  1  0  0  4 14  5  0  1  6
0 0.42 0.1764 0.65  1  0  0  2  2  0  0  0  1
0 0.42 0.1764 1.10  1  0  0  1  0  4  1  0  1
1 0.42 0.1764 1.30  1  0  0  3  1  3  0  1  1
0 0.42 0.1764 0.25  0  0  1  5 14  7  0  1  2
1 0.42 0.1764 0.75  0  0  0  1  0  0  0  0  1
1 0.42 0.1764 0.90  0  0  0  1  0  0  1  0  3
1 0.42 0.1764 0.15  1  0  0  3  7  1  0  1  1
0 0.42 0.1764 0.65  0  0  0  3  6  0  0  1  1
1 0.42 0.1764 0.25  1  0  0  1  0  0  0  0  1
0 0.42 0.1764 1.30  0  0  0  3  0  1  0  1  1
0 0.42 0.1764 1.10  1  0  0  2 11  0  0  1  6
0 0.42 0.1764 0.65  0  0  1  2 14 12  0  1  1
1 0.42 0.1764 0.06  1  0  0  2  7  1  0  0  2
0 0.42 0.1764 1.10  1  0  0  3  0  0  1  0  1
0 0.42 0.1764 1.50  0  0  0  1  0  1  1  0  1
0 0.42 0.1764 0.15  0  0  0  1 14  6  0  0  1
1 0.42 0.1764 0.65  1  0  0  1 14  6  0  1  5
0 0.42 0.1764 1.30  1  0  0  1  0  1  0  0  1
1 0.42 0.1764 1.50  1  0  0  0  0  0  1  0  1
0 0.42 0.1764 1.50  1  0  0  0  0  0  0  0  1
1 0.47 0.2209 0.65  1  0  0  2  2  1  1  0  1
1 0.47 0.2209 0.55  1  0  0  2  0  3  0  1  1
1 0.47 0.2209 0.90  1  0  0  2  0  6  1  0  1
1 0.47 0.2209 0.90  1  0  0  1  0  1  1  0  1
1 0.47 0.2209 0.15  1  0  0  5  0 11  0  1  2
1 0.47 0.2209 0.75  1  0  0  5  0  2  0  1  2
1 0.47 0.2209 0.25  0  0  0  2  0  0  0  0  1
0 0.47 0.2209 0.75  1  0  0  1  0  3  0  0  1
0 0.47 0.2209 0.25  0  0  1  1  0  4  1  0  1
0 0.47 0.2209 1.50  0  0  0  2  0  0  1  0  1
1 0.47 0.2209 1.50  1  0  0  1  0  0  1  0  1
1 0.47 0.2209 0.25  0  0  1  2  0  2  0  1  1
1 0.47 0.2209 0.75  0  0  0  5  3  2  0  0  7
1 0.47 0.2209 0.45  0  0  1  2 14  4  1  0  6
0 0.47 0.2209 0.55  0  0  1  1  0  0  0  1  1
0 0.47 0.2209 1.10  1  0  0  1  1  0  1  0  1
1 0.47 0.2209 0.25  1  0  0  2  0  0  1  0  2
0 0.47 0.2209 1.50  1  0  0  2  2  0  0  0  2
1 0.47 0.2209 0.01  0  0  0  1  0  0  1  0  3
0 0.47 0.2209 0.90  1  0  0  1  0  0  1  0  1
1 0.47 0.2209 0.65  1  0  0  1  3  1  1  0  1
0 0.47 0.2209 0.75  1  0  0  5 14  7  0  1  2
1 0.47 0.2209 0.90  1  0  0  2  0 11  0  0  1
0 0.47 0.2209 0.90  1  0  0  3  3  0  0  1  1
0 0.47 0.2209 0.75  1  0  0  1 14  6  1  0  2
0 0.47 0.2209 0.65  1  0  0  1  0  0  0  0  1
0 0.47 0.2209 1.50  1  0  0  2  1  1  0  0  1
0 0.47 0.2209 0.65  1  0  0  0  0  0  0  0  1
0 0.47 0.2209 0.75  1  0  0  0  0  0  1  0  1
0 0.47 0.2209 1.50  1  0  0  0  0  0  0  0  1
0 0.52 0.2704 0.35  0  1  0  1 14  6  0  1  1
1 0.52 0.2704 0.25  0  0  1  1  0  0  0  1  1
0 0.52 0.2704 0.25  0  0  1  4  2  7  0  0  1
0 0.52 0.2704 0.55  0  0  1  5  0  4  1  0  4
1 0.52 0.2704 0.65  1  0  0  2  0  3  1  0  1
1 0.52 0.2704 0.25  0  0  1  4 14  4  0  1  6
1 0.52 0.2704 0.25  0  0  1  3  3  2  0  1  3
0 0.52 0.2704 0.65  1  0  0  2  5  6  0  0  1
1 0.52 0.2704 0.35  0  0  1  3  0 12  0  1  1
0 0.52 0.2704 1.10  1  0  0  2  0  0  1  0  2
1 0.52 0.2704 0.00  1  0  0  2  0  0  1  0  1
1 0.52 0.2704 0.25  0  0  1  2  0  6  1  0  1
0 0.52 0.2704 0.90  0  0  0  5  0 11  0  1  1
1 0.52 0.2704 0.75  1  0  0  1  0  0  1  0  1
1 0.52 0.2704 0.25  0  0  1  1  0  0  0  0  2
1 0.52 0.2704 0.25  0  0  1  3  0  2  1  0  1
1 0.52 0.2704 0.25  0  0  1  2  0  0  1  0  1
1 0.52 0.2704 0.25  0  0  1  5  0  0  1  0  1
1 0.52 0.2704 0.75  0  0  1  1  0  1  1  0  1
0 0.52 0.2704 0.25  0  0  1  3  0  3  0  1  1
1 0.52 0.2704 0.35  0  0  1  1 14 10  0  1  2
0 0.52 0.2704 0.25  0  0  1  5 14  7  0  1  8
1 0.52 0.2704 1.30  1  0  0  1  0  0  0  0  1
1 0.52 0.2704 0.45  0  0  1  4  0  1  0  1  2
1 0.52 0.2704 0.25  0  0  1  5 14  1  1  0  1
1 0.52 0.2704 0.55  0  0  1  2 14  1  0  1  2
0 0.52 0.2704 0.75  1  0  0  1  1  1  0  1  3
0 0.52 0.2704 0.25  0  0  1  4  0  0  0  1  1
1 0.52 0.2704 1.30  1  0  0  2  3  0  1  0  5
0 0.52 0.2704 0.35  0  0  1  5  5 11  0  1  2
1 0.52 0.2704 0.65  0  0  0  1 14  1  0  1  1
1 0.52 0.2704 0.25  0  0  1  4  3  2  1  0  2
1 0.52 0.2704 0.75  1  0  0  3  3  0  0  0  1
1 0.52 0.2704 1.30  1  0  0  2  0  0  1  0  1
1 0.52 0.2704 0.25  0  0  1  1  0  1  1  0  1
1 0.52 0.2704 0.35  1  0  0  3  0  0  1  0  1
1 0.52 0.2704 0.25  0  0  1  5  0  7  0  1  1
1 0.52 0.2704 0.25  0  0  1  1  0  0  1  0  1
1 0.52 0.2704 0.45  0  0  0  1  0  1  1  0  1
1 0.52 0.2704 0.45  0  0  0  5  0  0  1  0  1
1 0.52 0.2704 0.90  1  0  0  2 14  3  1  0  2
0 0.52 0.2704 0.25  1  0  0  1  0  0  0  0  2
1 0.52 0.2704 0.45  1  0  0  4  3  0  0  1  1
1 0.52 0.2704 0.75  1  0  0  2  2  1  0  0  2
1 0.52 0.2704 0.45  1  0  0  3  0  2  1  0  1
0 0.52 0.2704 1.50  1  0  0  3  0  0  1  0  1
1 0.52 0.2704 0.65  0  0  1  1  0  0  1  0  1
0 0.52 0.2704 0.75  1  0  0  3 14  6  0  1  1
1 0.52 0.2704 0.25  0  0  1  4 14  4  1  0  2
0 0.52 0.2704 1.30  1  0  0  2  0  2  1  0  1
1 0.52 0.2704 0.45  0  0  1  1 14  8  0  1  1
0 0.52 0.2704 1.10  0  0  0  1  3  0  0  0  5
1 0.52 0.2704 0.75  1  0  0  0  0  0  1  0  1
0 0.52 0.2704 1.50  1  0  0  0  0  0  0  0  1
1 0.57 0.3249 0.35  1  0  0  2  0  0  0  0  1
1 0.57 0.3249 0.25  0  0  1  4  0  1  0  0  1
1 0.57 0.3249 0.00  1  0  0  1  0  1  1  0  2
1 0.57 0.3249 0.35  0  0  1  4  0 11  1  0  1
0 0.57 0.3249 0.90  1  0  0  1  0  0  0  0  1
1 0.57 0.3249 0.35  1  0  0  1 10  2  1  0  6
0 0.57 0.3249 0.55  1  0  0  1  4  1  0  1  1
1 0.57 0.3249 0.65  1  0  0  2  0  7  0  0  2
1 0.57 0.3249 0.35  0  0  1  2  0  0  1  0  1
1 0.57 0.3249 0.90  1  0  0  2  0  4  1  0  1
1 0.57 0.3249 0.25  0  0  1  4  0  0  1  0  1
1 0.57 0.3249 0.25  0  0  1  5  0  2  0  1  1
1 0.57 0.3249 0.15  1  0  0  3  7  9  1  0  3
1 0.57 0.3249 0.25  1  0  0  3  0  0  1  0  1
1 0.57 0.3249 0.15  1  0  0  5  1  2  0  1  1
1 0.57 0.3249 0.25  0  0  1  2  0  4  1  0  1
1 0.57 0.3249 0.01  1  0  0  1  0  1  1  0  1
0 0.57 0.3249 0.75  1  0  0  4  0  0  1  0  1
1 0.57 0.3249 0.25  0  0  1  2  0  0  0  1  1
1 0.57 0.3249 0.06  1  0  0  2  0  4  1  0  1
1 0.57 0.3249 0.55  1  0  0  1  8 10  0  1  1
1 0.57 0.3249 0.25  0  0  1  2  0  2  0  1  1
1 0.57 0.3249 0.75  1  0  0  3  0  0  1  0  1
0 0.57 0.3249 0.25  0  0  0  3  0  0  0  1  1
0 0.57 0.3249 0.90  0  0  0  3  0  0  1  0  1
0 0.57 0.3249 0.25  0  0  0  5  1 10  0  1  1
1 0.57 0.3249 0.35  0  0  1  3  0  0  1  0  1
0 0.57 0.3249 0.75  0  0  0  1  4  0  0  0  1
1 0.57 0.3249 0.35  0  0  1  1  0  0  0  0  1
1 0.57 0.3249 1.30  1  0  0  2  9  1  1  0  1
1 0.57 0.3249 0.65  1  0  0  3 14  1  1  0  1
0 0.57 0.3249 0.65  1  0  0  1  0  3  1  0  1
1 0.57 0.3249 1.10  1  0  0  1  5  1  0  0  2
0 0.57 0.3249 0.65  0  0  1  5  0  0  0  1  1
1 0.57 0.3249 0.90  1  0  0  1  4  0  1  0  1
0 0.57 0.3249 1.10  0  0  1  3  8  1  1  0  2
1 0.57 0.3249 0.45  0  0  1  1  0  6  0  1  1
1 0.57 0.3249 0.45  0  0  1  3  1  0  0  1  1
0 0.57 0.3249 0.90  0  0  0  5 10  4  1  0  2
1 0.57 0.3249 0.15  0  0  1  4  3  0  1  0  1
0 0.57 0.3249 0.25  0  0  1  5  0  6  0  0  1
0 0.57 0.3249 0.01  0  0  0  1  9  4  0  0  8
0 0.57 0.3249 0.75  1  0  0  4 14  1  1  0  4
1 0.57 0.3249 0.55  1  0  0  2  0  1  0  0  2
1 0.57 0.3249 0.35  0  0  0  2  2  2  1  0  4
1 0.57 0.3249 0.25  0  0  1  5  0  0  0  1  1
1 0.57 0.3249 0.55  0  0  0  4  2  0  1  0  1
0 0.57 0.3249 0.75  0  0  0  1  2  1  1  0  1
1 0.57 0.3249 0.25  1  0  0  5  0  6  0  1  1
1 0.57 0.3249 0.25  0  0  1  5 14  7  1  0  2
1 0.57 0.3249 0.25  0  0  1  4  0  3  0  1  1
1 0.57 0.3249 0.35  0  0  1  3  4  5  0  1  3
1 0.57 0.3249 0.25  0  0  1  4 14  7  0  1  2
1 0.57 0.3249 0.55  1  0  0  1  0  0  0  0  1
1 0.57 0.3249 0.35  1  0  0  2 14  6  1  0  4
1 0.57 0.3249 0.25  1  0  0  1  8  0  1  0  1
1 0.57 0.3249 0.35  0  0  1  5 14  2  0  1  1
0 0.57 0.3249 0.90  1  0  0  2  0  0  0  1  2
1 0.57 0.3249 0.45  1  0  0  4  4  5  0  0  2
1 0.57 0.3249 0.25  0  0  1  3  0  0  0  1  2
0 0.57 0.3249 1.50  1  0  0  4  0  0  0  1  1
1 0.57 0.3249 0.25  1  0  0  1 14  7  1  0  1
0 0.57 0.3249 0.65  1  0  0  3 14  4  0  1  1
0 0.57 0.3249 0.65  0  0  0  1 12  0  0  0  1
1 0.57 0.3249 0.25  0  0  1  0  0  0  0  0  1
1 0.57 0.3249 0.25  0  0  1  0  0  1  0  0  2
0 0.57 0.3249 1.10  1  0  0  0  0  0  1  0  1
1 0.57 0.3249 0.25  1  0  0  0  0  0  1  0  1
0 0.57 0.3249 1.50  0  0  1  0  0  0  1  0  1
1 0.57 0.3249 0.65  1  0  0  0  0  0  0  0  1
1 0.57 0.3249 0.55  1  0  0  0  0  0  0  1  1
1 0.57 0.3249 0.35  0  0  1  0  0  0  1  0  1
1 0.62 0.3844 1.50  1  0  0  1 14  1  0  0  8
1 0.62 0.3844 1.30  1  0  0  1  4  1  0  0  1
1 0.62 0.3844 0.25  0  0  1  3  0  8  0  1  1
1 0.62 0.3844 0.25  1  0  0  1  0  0  1  0  2
1 0.62 0.3844 0.25  1  0  0  1  0  3  1  0  1
1 0.62 0.3844 0.25  0  0  1  5  0  7  1  0  1
1 0.62 0.3844 0.35  0  0  1  4  0  2  1  0  1
1 0.62 0.3844 0.15  0  0  1  1  0  4  0  0  1
1 0.62 0.3844 0.25  0  0  1  1  0 10  0  0  1
1 0.62 0.3844 0.35  0  0  1  2  0  8  0  1  2
1 0.62 0.3844 0.35  1  0  0  2  0  0  1  0  1
1 0.62 0.3844 0.25  1  0  0  3  0  0  0  1  1
1 0.62 0.3844 0.25  0  0  1  5  3  1  0  1  1
0 0.62 0.3844 0.25  0  0  1  3  0  0  0  1  1
1 0.62 0.3844 0.00  0  0  0  3  0  6  1  0  1
0 0.62 0.3844 0.45  1  0  0  5  0  4  0  1  3
1 0.62 0.3844 0.15  1  0  0  5  3  5  0  1  1
0 0.62 0.3844 0.90  1  0  0  1  0  0  0  0  1
0 0.62 0.3844 0.75  0  0  1  2  0  2  0  1  1
1 0.62 0.3844 0.25  0  0  1  2  0  0  1  0  1
1 0.62 0.3844 0.75  1  0  0  3  0  0  1  0  1
0 0.62 0.3844 0.65  1  0  0  5  2  1  1  0  1
1 0.62 0.3844 0.25  0  0  1  1  0  0  1  0  1
1 0.62 0.3844 0.25  0  0  1  2  0  0  1  0  1
1 0.62 0.3844 0.25  0  0  1  1  0  0  1  0  2
1 0.62 0.3844 0.25  0  0  0  3  5  1  1  0  1
1 0.62 0.3844 0.25  0  0  1  5  0  7  0  1  1
1 0.62 0.3844 0.15  1  0  0  3  0  2  1  0  2
0 0.62 0.3844 0.35  0  0  1  5  0 11  0  1  1
1 0.62 0.3844 0.25  0  0  1  1 14 12  0  1  2
1 0.62 0.3844 0.35  1  0  0  1  0  0  1  0  1
0 0.62 0.3844 1.10  1  0  0  1  2  4  1  0  1
0 0.62 0.3844 0.25  0  0  1  4 13  0  1  0  3
0 0.62 0.3844 0.25  0  0  1  5 14 10  0  1  9
1 0.62 0.3844 0.45  0  0  1  5  0  0  0  1  1
0 0.62 0.3844 0.35  0  0  1  1  0  0  0  1  1
1 0.62 0.3844 0.00  0  0  1  1  0  4  0  0  1
0 0.62 0.3844 0.25  1  0  0  2  0  0  0  1  2
1 0.62 0.3844 0.90  1  0  0  2  0  0  1  0  1
1 0.62 0.3844 0.01  0  0  1  1  2  0  1  0  4
1 0.62 0.3844 0.25  0  0  1  4  0  1  1  0  2
0 0.62 0.3844 1.50  1  0  0  4 14  8  0  0  1
1 0.62 0.3844 0.25  0  0  1  5  6  4  0  1  1
1 0.62 0.3844 0.45  1  0  0  2  0  0  1  0  1
0 0.62 0.3844 0.90  0  0  0  3  2  0  1  0  1
1 0.62 0.3844 0.45  1  0  0  1  0  1  1  0  1
1 0.62 0.3844 0.25  0  0  1  1  0  7  0  1  1
1 0.62 0.3844 0.35  1  0  0  2  5  0  0  1  1
1 0.62 0.3844 0.25  0  0  1  3  0  0  1  0  1
1 0.62 0.3844 0.25  0  0  1  3  0  0  1  0  1
0 0.62 0.3844 0.25  0  0  1  1  0  0  0  1  1
0 0.62 0.3844 0.45  1  0  0  5  1  8  0  1  2
1 0.62 0.3844 0.25  1  0  0  1  0  0  1  0  1
1 0.62 0.3844 0.25  1  0  0  3  0  9  0  1  1
1 0.62 0.3844 0.25  0  0  1  5 14  5  0  1  1
1 0.62 0.3844 0.45  0  0  1  2  0  0  1  0  3
1 0.62 0.3844 1.10  1  0  0  1  4  0  0  0  1
0 0.62 0.3844 0.25  0  0  1  2  0  0  0  1  1
1 0.62 0.3844 0.25  1  0  0  1  0  0  0  0  1
0 0.62 0.3844 0.35  1  0  0  3  0  0  1  0  2
1 0.62 0.3844 0.25  1  0  0  5  2  2  1  0  1
1 0.62 0.3844 0.25  1  0  0  4  0  2  0  1  1
1 0.62 0.3844 0.25  0  0  1  2  0  1  1  0  1
1 0.62 0.3844 0.90  1  0  0  3  0  0  1  0  1
1 0.62 0.3844 0.25  0  0  1  1 14  2  1  0  1
0 0.62 0.3844 0.75  1  0  0  1 14  2  0  0  1
0 0.62 0.3844 0.55  0  0  0  2  0  0  1  0  1
1 0.62 0.3844 0.25  0  0  1  1 14  5  1  0  1
1 0.62 0.3844 1.50  1  0  0  5  0  1  1  0  1
0 0.62 0.3844 1.50  1  0  0  0  0  4  1  0  1
1 0.62 0.3844 0.25  0  0  1  0  0  0  1  0  1
1 0.62 0.3844 0.55  0  0  1  0  0  0  1  0  1
1 0.62 0.3844 0.25  0  0  0  0  0  4  0  0  1
1 0.62 0.3844 0.00  0  0  1  0 14  2  1  0  2
1 0.62 0.3844 0.00  1  0  0  0  0  0  1  0  1
1 0.62 0.3844 0.25  1  0  0  0  0  0  1  0  1
0 0.62 0.3844 1.50  1  0  0  0  0  1  1  0  2
1 0.67 0.4489 0.25  0  0  1  3  0  4  1  0  1
1 0.67 0.4489 0.45  0  0  1  5  0  6  1  0  1
1 0.67 0.4489 0.35  1  0  0  3 14  2  1  0  1
1 0.67 0.4489 0.25  0  0  1  3  0  4  0  0  1
1 0.67 0.4489 0.15  0  0  1  2  0  4  0  1  7
0 0.67 0.4489 0.25  0  0  1  3  0  7  1  0  1
1 0.67 0.4489 0.15  1  0  0  2  0  1  1  0  2
1 0.67 0.4489 0.25  0  0  1  3  0  1  1  0  2
1 0.67 0.4489 0.25  0  0  1  2  0  0  1  0  1
1 0.67 0.4489 0.25  0  0  1  2  0  6  0  0  2
1 0.67 0.4489 0.45  0  0  1  3  0  3  1  0  1
0 0.67 0.4489 0.25  0  0  1  2  0  0  1  0  1
1 0.67 0.4489 0.25  0  0  1  1  0  0  1  0  1
1 0.67 0.4489 0.25  0  0  1  1  0  4  0  0  1
0 0.67 0.4489 0.45  1  0  0  3  0  1  1  0  1
1 0.67 0.4489 0.25  0  0  1  2  0  0  1  0  2
1 0.67 0.4489 0.25  1  0  0  1  0  1  0  0  1
1 0.67 0.4489 0.75  1  0  0  4  0  0  0  1  1
1 0.67 0.4489 0.35  0  0  1  1 14 12  0  1  6
0 0.67 0.4489 0.25  0  0  1  2  0  2  1  0  1
1 0.67 0.4489 0.45  0  0  1  1  1  0  1  0  1
1 0.67 0.4489 0.25  0  0  1  2  0  1  1  0  1
1 0.67 0.4489 0.45  0  0  1  1  0  0  1  0  1
1 0.67 0.4489 0.25  0  0  1  3  0  9  1  0  2
1 0.67 0.4489 0.15  0  0  1  4  0  2  0  1  2
1 0.67 0.4489 0.25  1  0  0  1  0  0  0  0  1
0 0.67 0.4489 0.75  0  0  1  3  0  0  1  0  1
0 0.67 0.4489 0.75  0  0  1  2 14 11  0  1  3
1 0.67 0.4489 0.25  0  0  1  5 14  7  1  0  1
1 0.67 0.4489 0.25  1  0  0  5  0  9  1  0  2
1 0.67 0.4489 0.25  1  0  0  2  0  1  1  0  1
1 0.67 0.4489 0.25  0  0  1  1  0  0  0  1  1
1 0.67 0.4489 0.35  1  0  0  5 14 10  1  0  7
1 0.67 0.4489 0.35  0  0  1  5 14  9  0  1  2
0 0.67 0.4489 0.35  0  0  0  3  0  2  1  0  1
1 0.67 0.4489 0.25  0  0  1  2  0  2  1  0  2
0 0.67 0.4489 0.25  0  0  1  2 14  5  1  0  8
1 0.67 0.4489 0.15  0  0  1  2  0  1  1  0  1
1 0.67 0.4489 0.25  1  0  0  2  0  2  1  0  2
1 0.67 0.4489 0.25  0  0  1  4 14  0  1  0  2
1 0.67 0.4489 0.15  1  0  0  1  0  0  1  0  2
0 0.67 0.4489 0.55  0  0  0  1  0  0  1  0  1
1 0.67 0.4489 0.25  0  0  1  4  0 11  1  0  1
1 0.67 0.4489 0.35  1  0  0  2  0  4  1  0  1
1 0.67 0.4489 0.45  0  0  1  5  0  0  1  0  1
0 0.67 0.4489 0.35  1  0  0  2  0  1  1  0  1
1 0.67 0.4489 0.25  0  0  1  1  0  0  1  0  1
1 0.67 0.4489 0.25  1  0  0  2  0  1  1  0  1
0 0.67 0.4489 0.25  0  0  1  1  0  0  1  0  1
1 0.67 0.4489 0.25  0  0  1  2  0  1  0  1  1
0 0.67 0.4489 1.10  0  0  1  2  0  0  1  0  1
1 0.67 0.4489 0.25  0  0  1  3 14  3  1  0  2
1 0.67 0.4489 0.25  0  0  1  2  0  0  1  0  1
0 0.67 0.4489 0.25  1  0  0  1  0  3  1  0  1
0 0.67 0.4489 0.25  0  0  1  3 14  2  1  0  1
1 0.67 0.4489 0.25  0  0  1  2  0  2  0  1  1
1 0.67 0.4489 0.35  0  0  1  2  0  1  1  0  1
1 0.67 0.4489 0.55  1  0  0  5  3  2  1  0  1
0 0.67 0.4489 0.15  0  0  1  2  0  0  1  0  1
1 0.67 0.4489 0.35  1  0  0  1 14  3  0  0  7
1 0.67 0.4489 0.35  0  0  1  2  0  0  1  0  1
1 0.67 0.4489 0.25  0  0  1  3  0  1  0  1  1
0 0.67 0.4489 0.25  0  0  1  3  0  0  1  0  1
1 0.67 0.4489 0.35  0  0  1  1  6  0  1  0  1
0 0.67 0.4489 0.25  1  0  0  5 14  3  1  0  6
1 0.67 0.4489 0.25  0  0  1  0  0  0  1  0  1
1 0.67 0.4489 0.35  0  0  1  0  0  1  0  0  1
1 0.67 0.4489 0.25  0  0  1  0  0  0  1  0  1
1 0.67 0.4489 0.25  0  0  1  0  0  0  1  0  1
1 0.72 0.5184 0.25  0  0  1  5 14  7  1  0  6
1 0.72 0.5184 0.25  0  0  1  2 10  1  1  0  1
1 0.72 0.5184 0.65  0  0  1  4 14  5  1  0  1
1 0.72 0.5184 0.25  0  0  1  1 14  3  0  1  1
1 0.72 0.5184 0.25  0  0  1  3  0  3  1  0  1
1 0.72 0.5184 0.25  0  0  1  1  0  0  0  0  1
1 0.72 0.5184 0.25  1  0  0  3  0  3  1  0  1
1 0.72 0.5184 0.25  0  0  1  3  0  3  1  0  1
1 0.72 0.5184 0.55  1  0  0  1  0  4  0  0  1
1 0.72 0.5184 0.25  0  0  1  3  4  6  1  0  2
1 0.72 0.5184 0.25  1  0  0  1  0  8  1  0  2
1 0.72 0.5184 0.55  0  0  1  1  0  4  1  0  1
0 0.72 0.5184 0.25  0  0  1  4  0  3  1  0  4
1 0.72 0.5184 0.25  1  0  0  3  0  0  0  0  1
1 0.72 0.5184 0.25  0  0  1  5  0  6  1  0  1
1 0.72 0.5184 0.25  0  0  1  2  0  0  1  0  1
1 0.72 0.5184 0.15  0  0  1  3  0  2  1  0  1
1 0.72 0.5184 0.25  0  0  1  3  3  1  1  0  1
1 0.72 0.5184 0.25  0  0  1  3  0  1  1  0  1
1 0.72 0.5184 0.35  0  0  1  2  0  1  0  0  1
1 0.72 0.5184 0.25  0  0  1  3  0  0  1  0  1
1 0.72 0.5184 0.25  0  0  1  2  0 11  0  1  2
1 0.72 0.5184 0.15  0  0  1  1  0  8  0  1  1
0 0.72 0.5184 0.45  0  0  1  1  0  4  0  0  1
1 0.72 0.5184 0.35  0  0  1  3  0  9  0  1  1
1 0.72 0.5184 0.55  0  0  1  4  0  1  1  0  1
0 0.72 0.5184 0.25  0  0  1  2  0  1  1  0  1
1 0.72 0.5184 0.35  1  0  0  2  0  1  1  0  1
1 0.72 0.5184 0.35  0  0  1  5  0  4  1  0  1
1 0.72 0.5184 0.25  0  0  1  1  0  0  0  0  1
1 0.72 0.5184 0.25  0  0  1  1 14  2  0  1  1
1 0.72 0.5184 0.25  0  0  1  2  0  5  1  0  1
1 0.72 0.5184 0.25  0  0  1  2  0  5  0  0  1
1 0.72 0.5184 0.25  0  0  1  3 14  1  1  0  1
0 0.72 0.5184 1.10  1  0  0  5  0  0  1  0  3
1 0.72 0.5184 0.45  1  0  0  5  7  2  1  0  3
1 0.72 0.5184 0.25  1  0  0  2  0  0  0  0  1
1 0.72 0.5184 0.25  0  0  1  1  0  2  1  0  1
0 0.72 0.5184 0.45  0  0  1  3  0  0  1  0  1
1 0.72 0.5184 0.25  0  0  1  4  7  3  1  0  1
0 0.72 0.5184 0.25  0  0  1  2  0  0  1  0  1
1 0.72 0.5184 0.25  0  0  1  4  0  1  0  1  1
1 0.72 0.5184 0.25  0  0  1  4  0  3  0  1  1
1 0.72 0.5184 0.25  0  0  1  4  1  3  1  0  2
0 0.72 0.5184 0.25  0  0  1  3  0  0  1  0  1
1 0.72 0.5184 0.15  0  0  1  3  0  0  0  1  1
0 0.72 0.5184 0.06  1  0  0  4  0  2  1  0  1
0 0.72 0.5184 0.35  1  0  0  1 14  1  0  0  5
1 0.72 0.5184 0.25  1  0  0  2 12  6  1  0  4
0 0.72 0.5184 0.75  1  0  0  1  0  0  0  0  1
1 0.72 0.5184 0.65  1  0  0  3  0  0  1  0  1
1 0.72 0.5184 0.45  1  0  0  3  0  0  1  0  1
1 0.72 0.5184 0.25  0  0  1  4  0  2  1  0  1
1 0.72 0.5184 0.25  0  0  1  2  0  3  1  0  1
1 0.72 0.5184 0.25  0  0  1  3  0  0  1  0  1
1 0.72 0.5184 0.25  0  0  1  5  0  1  0  1  2
1 0.72 0.5184 0.25  0  0  1  1  0  0  1  0  1
1 0.72 0.5184 0.25  0  0  1  2  0  3  1  0  1
1 0.72 0.5184 0.25  0  0  1  2  0  0  1  0  1
1 0.72 0.5184 0.25  0  0  1  3  7  3  1  0  1
1 0.72 0.5184 0.25  0  0  1  2  0  0  1  0  2
0 0.72 0.5184 0.15  0  0  1  4  0  1  1  0  2
1 0.72 0.5184 0.65  0  0  0  1 14  0  0  0  1
0 0.72 0.5184 0.35  1  0  0  3  0  4  1  0  1
0 0.72 0.5184 0.25  0  0  1  1  0  0  1  0  1
1 0.72 0.5184 0.25  1  0  0  5 13  3  0  1  2
1 0.72 0.5184 0.45  1  0  0  4 14  2  0  1  1
1 0.72 0.5184 0.25  0  0  1  5  0  2  0  1  2
0 0.72 0.5184 0.15  0  0  1  1  0  2  1  0  1
1 0.72 0.5184 0.25  0  0  1  4  0  1  1  0  2
1 0.72 0.5184 0.55  1  0  0  4  0  2  0  1  1
0 0.72 0.5184 0.45  1  0  0  1  0  0  1  0  1
1 0.72 0.5184 0.25  0  0  1  1  0  1  1  0  1
1 0.72 0.5184 0.45  1  0  0  3  0  1  1  0  1
1 0.72 0.5184 0.25  0  0  1  5  0  2  1  0  2
0 0.72 0.5184 0.25  1  0  0  3 13  6  1  0  7
1 0.72 0.5184 0.15  0  0  1  4  0  3  1  0  1
1 0.72 0.5184 0.25  0  0  1  1  4  0  1  0  1
1 0.72 0.5184 0.25  0  0  0  1  0  0  1  0  1
1 0.72 0.5184 0.25  1  0  0  3  0  0  1  0  2
1 0.72 0.5184 0.25  0  0  1  1 14 11  0  1  1
0 0.72 0.5184 1.30  0  0  1  1  0  0  1  0  1
1 0.72 0.5184 0.25  0  0  1  1  0  1  1  0  1
1 0.72 0.5184 0.25  0  0  1  4  5  0  1  0  4
1 0.72 0.5184 0.90  1  0  0  3  0  0  1  0  1
1 0.72 0.5184 0.25  0  0  1  2  0  0  0  0  1
1 0.72 0.5184 0.25  1  0  0  2  0  2  1  0  1
1 0.72 0.5184 0.25  1  0  0  3  0  2  1  0  1
1 0.72 0.5184 0.25  0  0  1  1  3  2  1  0  1
1 0.72 0.5184 0.25  1  0  0  3  0  1  0  1  2
1 0.72 0.5184 0.25  1  0  0  5 14  5  1  0  7
0 0.72 0.5184 0.25  1  0  0  2 14  4  0  1  2
1 0.72 0.5184 0.25  0  0  1  3 14  2  1  0  6
0 0.72 0.5184 0.35  0  0  1  1  0  0  0  1  1
1 0.72 0.5184 0.25  0  0  1  1  2  0  1  0  2
1 0.72 0.5184 0.25  0  0  1  3  0  4  1  0  1
0 0.72 0.5184 0.25  0  0  1  2  0  1  1  0  1
1 0.72 0.5184 0.25  1  0  0  5 14  3  0  1  6
1 0.72 0.5184 0.25  0  0  1  4  0  5  0  1  1
1 0.72 0.5184 0.25  1  0  0  3  0  0  1  0  1
0 0.72 0.5184 0.35  1  0  0  3 14  6  0  1  1
0 0.72 0.5184 0.25  0  0  1  2  0  5  0  1  3
1 0.72 0.5184 0.35  0  0  1  3  0  1  1  0  1
1 0.72 0.5184 0.25  0  0  1  2 14  1  0  1  7
1 0.72 0.5184 0.25  0  0  1  3  0  1  1  0  1
0 0.72 0.5184 0.55  0  0  1  5 14  3  1  0  1
1 0.72 0.5184 0.25  0  0  1  5 14  0  1  0  7
1 0.72 0.5184 0.45  1  0  0  1  0  0  1  0  1
0 0.72 0.5184 0.25  1  0  0  2 14  6  0  1  1
0 0.72 0.5184 0.25  1  0  0  1  0  0  1  0  1
0 0.72 0.5184 0.25  0  0  1  1  1  1  0  0  1
1 0.72 0.5184 0.25  0  0  1  1  0  0  0  0  1
0 0.72 0.5184 0.45  1  0  0  2  0  0  1  0  1
0 0.72 0.5184 0.25  0  0  1  1  0  0  1  0  1
0 0.72 0.5184 0.25  0  0  1  2  0  0  1  0  1
1 0.72 0.5184 0.25  1  0  0  4  0  3  0  0  1
1 0.72 0.5184 0.25  0  0  1  1  0  2  0  0  2
1 0.72 0.5184 0.25  0  0  1  2  0  0  0  0  1
0 0.72 0.5184 0.25  0  0  1  1  0  0  0  0  1
1 0.72 0.5184 0.25  1  0  0  4  3  0  1  0  1
1 0.72 0.5184 0.25  1  0  0  1  0  0  1  0  1
1 0.72 0.5184 0.25  0  0  1  1  0  0  1  0  2
0 0.72 0.5184 0.35  0  0  1  1  0  0  0  0  1
0 0.72 0.5184 0.55  0  0  0  2  2  0  0  0  1
0 0.72 0.5184 0.25  0  0  1  2  0  0  1  0  1
0 0.72 0.5184 0.25  0  0  1  4 14  7  1  0  1
0 0.72 0.5184 0.55  0  0  0  5 14  3  0  1  3
1 0.72 0.5184 0.45  0  0  1  5  6  1  1  0  1
0 0.72 0.5184 0.35  0  0  1  4  0  5  0  1  1
0 0.72 0.5184 0.35  0  0  1  5  0  1  1  0  1
0 0.72 0.5184 0.25  0  0  1  5  0  0  1  0  1
1 0.72 0.5184 0.25  0  0  1  4  0  0  1  0  1
0 0.72 0.5184 0.45  0  0  0  1  6  0  1  0  1
0 0.72 0.5184 0.25  0  0  1  3 14  0  1  0  2
1 0.72 0.5184 0.25  0  0  1  5 14  0  1  0  2
1 0.72 0.5184 0.25  0  0  1  2  0  1  1  0  2
0 0.72 0.5184 0.25  0  0  1  3  0  0  1  0  1
0 0.72 0.5184 0.25  0  0  1  2  0  5  1  0  2
0 0.72 0.5184 0.35  1  0  0  2  5  3  0  0  3
0 0.72 0.5184 0.25  0  0  1  1  0  0  0  0  1
0 0.72 0.5184 0.25  0  0  1  3 14  1  0  1  1
0 0.72 0.5184 0.15  0  0  1  3  0  1  1  0  1
1 0.72 0.5184 0.25  0  0  1  3  0  0  1  0  1
1 0.72 0.5184 0.35  0  0  1  4  0  1  1  0  1
1 0.72 0.5184 0.25  0  0  1  2  0  1  1  0  1
1 0.72 0.5184 0.25  0  0  1  3  0  0  1  0  4
1 0.72 0.5184 0.25  1  0  0  3  2  1  1  0  1
1 0.72 0.5184 0.35  0  0  1  5  0  0  1  0  1
1 0.72 0.5184 0.35  1  0  0  5  7  1  1  0  2
1 0.72 0.5184 0.25  1  0  0  1  0  1  1  0  1
1 0.72 0.5184 0.25  1  0  0  1  1  0  1  0  1
1 0.72 0.5184 0.25  0  0  1  5  0  0  1  0  1
1 0.72 0.5184 0.25  0  0  1  3  0  0  1  0  1
0 0.72 0.5184 0.35  0  0  1  5  0  5  1  0  2
0 0.72 0.5184 0.25  0  0  1  4 14  6  0  1  1
0 0.72 0.5184 0.45  1  0  0  5  0  1  1  0  1
1 0.72 0.5184 0.25  0  0  1  3  0  1  0  0  1
0 0.72 0.5184 0.25  0  0  1  4  0  0  1  0  1
1 0.72 0.5184 0.65  0  0  1  5  0  3  0  1  1
1 0.72 0.5184 0.35  0  0  1  5  0  2  1  0  2
0 0.72 0.5184 0.15  0  0  1  2  0  1  0  1  1
1 0.72 0.5184 0.25  0  0  1  1  0  1  0  1  1
1 0.72 0.5184 0.25  0  0  1  4 10  0  1  0  2
1 0.72 0.5184 0.25  1  0  0  1  0  0  1  0  1
0 0.72 0.5184 0.45  1  0  0  2  0  0  1  0  1
1 0.72 0.5184 0.25  0  0  1  3  0  0  0  1  1
0 0.72 0.5184 0.65  0  0  0  1  0  1  1  0  1
1 0.72 0.5184 0.25  0  0  1  1  0  0  1  0  1
1 0.72 0.5184 0.35  1  0  0  4  0  0  1  0  4
1 0.72 0.5184 0.25  0  0  1  5  0  0  0  1  1
1 0.72 0.5184 0.25  1  0  0  3  2  0  1  0  1
1 0.72 0.5184 0.25  0  0  1  1 14  0  0  1  1
1 0.72 0.5184 0.35  1  0  0  4 14  6  0  1  1
1 0.72 0.5184 0.25  0  0  1  2 14  0  0  1  2
1 0.72 0.5184 0.25  0  0  1  4  0 10  1  0  1
1 0.72 0.5184 0.25  0  0  1  5  0  1  1  0  1
1 0.72 0.5184 0.25  0  0  1  2  0  0  1  0  1
0 0.72 0.5184 0.25  1  0  0  3  0  1  1  0  2
1 0.72 0.5184 0.90  1  0  0  2 14  4  0  1  1
0 0.72 0.5184 0.45  0  0  0  2  0  0  0  1  1
1 0.72 0.5184 0.55  0  0  1  3  0  0  1  0  1
1 0.72 0.5184 0.25  0  0  1  3  0  3  1  0  2
0 0.72 0.5184 0.15  0  0  0  2  0  3  0  1  1
1 0.72 0.5184 0.25  0  0  1  4  0  2  0  1  1
1 0.72 0.5184 0.25  0  0  1  1 14  1  0  1  1
1 0.72 0.5184 0.45  0  0  1  2  0  0  1  0  1
1 0.72 0.5184 0.25  0  0  1  4  0  0  1  0  1
1 0.72 0.5184 0.55  0  0  1  5 10  7  0  1  2
1 0.72 0.5184 0.65  0  0  1  3  0 10  1  0  1
1 0.72 0.5184 0.55  0  0  1  1  0  1  0  1  2
1 0.72 0.5184 0.55  1  0  0  4  0  0  1  0  1
1 0.72 0.5184 0.25  1  0  0  1 14  2  1  0  1
1 0.72 0.5184 0.25  0  0  1  5  7  1  0  1  1
0 0.72 0.5184 0.45  0  0  1  1  0  0  1  0  1
1 0.72 0.5184 0.35  1  0  0  5  0  2  0  1  1
1 0.72 0.5184 0.35  1  0  0  4 13  4  0  1  6
1 0.72 0.5184 0.25  1  0  0  1  0  0  1  0  1
1 0.72 0.5184 0.25  0  0  1  3  0  0  1  0  1
1 0.72 0.5184 0.25  1  0  0  1  0  0  1  0  1
1 0.72 0.5184 0.25  1  0  0  2  0  0  1  0  1
1 0.72 0.5184 0.25  0  0  1  4 14 12  0  1  1
1 0.72 0.5184 0.75  1  0  0  1  0  1  1  0  1
1 0.72 0.5184 0.35  0  0  1  3  0  4  1  0  1
1 0.72 0.5184 0.25  0  0  1  3  0  2  1  0  1
1 0.72 0.5184 0.25  0  0  1  5  0  5  1  0  1
1 0.72 0.5184 0.25  1  0  0  1  0  2  1  0  1
1 0.72 0.5184 0.25  1  0  0  1  0  2  1  0  1
1 0.72 0.5184 0.25  0  0  1  1  0  1  0  1  2
1 0.72 0.5184 0.25  0  0  1  1  5  2  1  0  6
1 0.72 0.5184 0.25  0  0  1  3  0  0  1  0  1
0 0.72 0.5184 0.75  0  0  1  5  0  2  0  1  1
1 0.72 0.5184 0.25  0  0  1  2  0  1  1  0  1
1 0.72 0.5184 0.25  0  0  1  1  0  0  1  0  1
1 0.72 0.5184 0.90  1  0  0  5  0  0  1  0  1
1 0.72 0.5184 0.25  0  0  1  2  0  0  1  0  1
0 0.72 0.5184 0.25  0  0  1  2  0  1  0  1  1
1 0.72 0.5184 0.25  0  0  1  3  0  0  1  0  1
1 0.72 0.5184 0.35  1  0  0  3  0  3  1  0  1
0 0.72 0.5184 0.35  0  0  1  2 14  2  1  0  1
0 0.72 0.5184 0.90  1  0  0  4  0  1  1  0  2
1 0.72 0.5184 0.25  1  0  0  4  0  1  1  0  1
1 0.72 0.5184 0.35  1  0  0  2  0  0  1  0  1
1 0.72 0.5184 0.25  1  0  0  2  4  0  0  1  2
1 0.72 0.5184 0.25  0  0  1  5  0  8  1  0  1
1 0.72 0.5184 0.25  0  0  1  4  2  0  1  0  1
1 0.72 0.5184 0.25  0  0  1  1  0  0  1  0  2
0 0.72 0.5184 0.25  0  0  1  2  0  0  1  0  1
1 0.72 0.5184 0.25  1  0  0  2  0  0  1  0  1
1 0.72 0.5184 0.35  0  0  1  2  0  0  1  0  1
1 0.72 0.5184 0.25  0  0  1  3 14  6  1  0  1
0 0.72 0.5184 0.25  0  0  1  4  0  1  1  0  2
0 0.72 0.5184 0.55  1  0  0  3  0  0  1  0  1
1 0.72 0.5184 0.25  1  0  0  4  0  2  1  0  2
0 0.72 0.5184 0.35  1  0  0  1  0  0  1  0  1
1 0.72 0.5184 0.25  1  0  0  3  0  5  1  0  1
1 0.72 0.5184 0.25  0  0  1  4 14  9  0  1  1
1 0.72 0.5184 0.25  1  0  0  5  0  0  1  0  2
1 0.72 0.5184 0.25  0  0  1  5  0  3  1  0  1
1 0.72 0.5184 0.45  0  0  1  1 14  1  0  0  1
0 0.72 0.5184 1.50  1  0  0  1 14  4  1  0  1
1 0.72 0.5184 0.25  0  0  1  1  0  1  1  0  1
1 0.72 0.5184 0.35  0  0  1  2  0  2  0  0  1
1 0.72 0.5184 0.25  0  0  1  1 14  2  0  1  1
1 0.72 0.5184 0.35  0  0  1  0  0  1  0  0  2
1 0.72 0.5184 0.25  0  0  1  0  0  0  0  0  1
1 0.72 0.5184 0.35  0  0  1  0  0  0  1  0  1
1 0.72 0.5184 0.35  0  0  1  0  0  5  1  0  1
0 0.72 0.5184 0.25  0  0  1  0  0  4  1  0  4
0 0.72 0.5184 0.25  1  0  0  0  0  0  0  0  2
1 0.72 0.5184 0.55  1  0  0  0  0  0  1  0  1
1 0.72 0.5184 0.25  1  0  0  0  0  0  1  0  1
1 0.72 0.5184 0.35  1  0  0  0  0  0  1  0  1
1 0.72 0.5184 0.25  1  0  0  0  0  1  1  0  1
1 0.72 0.5184 0.25  0  0  1  0  0  0  1  0  1
0 0.72 0.5184 0.35  1  0  0  0  0  0  0  0  1
1 0.72 0.5184 0.75  1  0  0  0  0  0  0  0  1
1 0.72 0.5184 0.25  1  0  0  0  0  0  1  0  1
1 0.72 0.5184 0.25  1  0  0  0  0  0  0  1  1
1 0.72 0.5184 0.25  0  0  1  0  0  0  0  0  1
0 0.72 0.5184 0.35  0  0  1  0  0  0  0  0  1
1 0.72 0.5184 0.25  0  0  1  0  0  0  0  1  2
1 0.72 0.5184 0.15  0  0  1  0  0  0  1  0  2
1 0.72 0.5184 0.25  1  0  0  0  0  0  1  0  1
1 0.72 0.5184 0.25  1  0  0  0  0  0  0  0  1
0 0.72 0.5184 0.15  0  0  1  0  0  3  0  0  1
1 0.72 0.5184 0.25  0  0  1  0  0  3  1  0  1
1 0.72 0.5184 0.15  1  0  0  0  0  0  0  0  1
1 0.72 0.5184 0.25  0  0  1  0  0  0  0  0  1
1 0.72 0.5184 0.25  0  0  1  0  0  0  0  0  1
1 0.72 0.5184 0.25  0  0  1  0  0  0  0  0  2
1 0.72 0.5184 0.25  0  0  1  0  0  0  0  1  1
0 0.72 0.5184 0.25  0  0  1  0  0  1  0  0  1
0 0.72 0.5184 0.25  0  0  1  0  0  2  1  0  1
1 0.72 0.5184 0.25  0  0  1  0  0  2  0  0  1
1 0.19 0.0361 0.35  1  0  0  5  0  2  1  0  0
0 0.19 0.0361 0.65  0  0  0  1  0  0  0  0  0
1 0.19 0.0361 0.45  1  0  0  3  0  0  1  0  0
0 0.19 0.0361 0.75  0  0  0  2  0  0  0  0  0
1 0.19 0.0361 0.35  0  0  0  1  0  2  1  0  0
0 0.19 0.0361 0.01  1  0  0  2  0  1  1  0  0
1 0.19 0.0361 0.25  0  0  0  3  0 12  1  0  0
0 0.19 0.0361 0.90  1  0  0  1  0  0  0  0  0
1 0.19 0.0361 0.55  0  0  0  3  0  3  1  0  0
1 0.19 0.0361 0.90  0  0  0  1  0  4  1  0  0
1 0.19 0.0361 0.15  1  0  0  2  0  4  0  0  0
0 0.19 0.0361 0.65  0  0  0  3  0  4  0  1  0
1 0.19 0.0361 0.25  1  0  0  4 14  9  1  0  0
0 0.19 0.0361 0.25  0  0  0  1  1  1  0  0  0
1 0.19 0.0361 0.55  0  0  0  4  0  2  0  0  0
0 0.19 0.0361 0.55  1  0  0  2  0  3  0  0  0
0 0.19 0.0361 0.75  1  0  0  1  0  1  1  0  0
1 0.19 0.0361 0.35  1  0  0  2  0  2  0  0  0
1 0.19 0.0361 0.55  0  0  0  1  0  0  0  0  0
0 0.19 0.0361 0.45  0  0  0  4  0  5  1  0  0
0 0.19 0.0361 0.45  1  0  0  5  0  0  1  0  0
1 0.19 0.0361 0.15  1  0  0  3  0  4  1  0  0
0 0.19 0.0361 0.35  1  0  0  1  0  3  1  0  0
1 0.19 0.0361 0.35  1  0  0  2  0  0  0  0  0
0 0.19 0.0361 0.00  1  0  0  4  4  2  1  0  0
1 0.19 0.0361 0.35  1  0  0  5  0  3  1  0  0
1 0.19 0.0361 0.15  1  0  0  2  1  0  1  0  0
1 0.19 0.0361 0.15  1  0  0  2  0 10  0  0  0
1 0.19 0.0361 0.45  0  0  0  3  0  5  0  0  0
1 0.19 0.0361 0.65  0  0  0  3  0  0  0  0  0
0 0.19 0.0361 0.15  0  0  0  1  0  1  1  0  0
1 0.19 0.0361 0.75  1  0  0  1  0  0  0  0  0
1 0.19 0.0361 0.45  1  0  0  4  0  3  0  0  0
1 0.19 0.0361 0.35  1  0  0  1  0  1  0  0  0
1 0.19 0.0361 0.55  0  0  0  2  0  4  0  1  0
1 0.19 0.0361 0.65  0  0  0  1  0  1  0  0  0
0 0.19 0.0361 0.65  1  0  0  1  0  4  0  0  0
1 0.19 0.0361 0.15  1  0  0  1  0  6  0  0  0
1 0.19 0.0361 0.45  1  0  0  5  0  4  1  0  0
0 0.19 0.0361 0.01  0  0  0  3  0  6  0  0  0
1 0.19 0.0361 0.06  1  0  0  3  3  1  0  0  0
1 0.19 0.0361 0.55  1  0  0  3  0  5  0  0  0
1 0.19 0.0361 0.25  0  1  0  2  0  0  0  0  0
1 0.19 0.0361 0.25  0  1  0  1  0  0  1  0  0
1 0.19 0.0361 0.55  1  0  0  2  0  3  0  0  0
0 0.19 0.0361 0.55  1  0  0  2  0  2  0  0  0
1 0.19 0.0361 0.55  0  0  0  5  2  6  1  0  0
1 0.19 0.0361 0.65  1  0  0  2  0  2  0  0  0
0 0.19 0.0361 0.45  1  0  0  5  0  2  0  1  0
1 0.19 0.0361 0.01  0  0  0  1  0  5  1  0  0
1 0.19 0.0361 0.06  1  0  0  3  0  3  1  0  0
1 0.19 0.0361 0.15  0  0  0  2  0  0  1  0  0
0 0.19 0.0361 0.55  0  0  0  1  0  2  1  0  0
1 0.19 0.0361 0.45  1  0  0  1  0  0  0  1  0
1 0.19 0.0361 0.35  1  0  0  2  0  6  0  0  0
0 0.19 0.0361 0.15  0  0  0  1  0  2  0  0  0
1 0.19 0.0361 0.75  1  0  0  2  0  0  1  0  0
1 0.19 0.0361 0.45  0  0  0  2  1  2  1  0  0
0 0.19 0.0361 0.45  0  0  0  2  0  2  0  0  0
0 0.19 0.0361 0.25  0  1  0  3  0  1  0  0  0
0 0.19 0.0361 0.45  1  0  0  3  0  1  1  0  0
1 0.19 0.0361 0.55  1  0  0  1  1  1  0  0  0
1 0.19 0.0361 0.35  0  0  0  1  0  6  0  0  0
0 0.19 0.0361 0.55  0  0  0  1  3  2  0  1  0
1 0.19 0.0361 0.45  0  0  0  1  0  0  1  0  0
0 0.19 0.0361 0.25  0  0  0  1  0  3  1  0  0
0 0.19 0.0361 0.90  0  0  0  1  0  0  0  0  0
0 0.19 0.0361 0.25  0  0  0  1  0  0  0  0  0
0 0.19 0.0361 0.35  0  0  0  1  0  0  0  1  0
1 0.19 0.0361 0.55  1  0  0  1  0  3  1  0  0
0 0.19 0.0361 0.00  0  1  0  1  1  3  0  0  0
0 0.19 0.0361 0.25  0  0  0  2  0  0  0  0  0
0 0.19 0.0361 0.45  0  0  0  1  0  0  1  0  0
1 0.19 0.0361 0.55  1  0  0  1  2  0  0  0  0
1 0.19 0.0361 0.55  0  0  0  1  0  0  0  0  0
1 0.19 0.0361 0.45  1  0  0  2  1  0  1  0  0
1 0.19 0.0361 0.00  0  0  0  2  0  0  0  0  0
0 0.19 0.0361 0.45  0  0  0  1  0  3  1  0  0
0 0.19 0.0361 0.75  1  0  0  2  0  2  1  0  0
1 0.19 0.0361 0.55  0  0  0  1  0  0  0  0  0
0 0.19 0.0361 0.25  0  0  0  1  0  0  1  0  0
1 0.19 0.0361 0.45  0  0  0  4  0  3  0  1  0
0 0.19 0.0361 0.55  1  0  0  3  0  0  1  0  0
1 0.19 0.0361 0.35  0  1  0  1  0  0  0  0  0
1 0.19 0.0361 0.45  0  0  0  1  0  0  0  0  0
1 0.19 0.0361 0.55  1  0  0  1  0  0  0  1  0
1 0.19 0.0361 0.55  0  0  0  1  0  0  0  0  0
1 0.19 0.0361 0.35  0  1  0  4  0  5  0  1  0
0 0.19 0.0361 0.55  0  0  0  2  0  1  0  0  0
1 0.19 0.0361 0.06  1  0  0  1  0  0  0  0  0
0 0.19 0.0361 0.15  0  1  0  2  0  2  0  0  0
0 0.19 0.0361 0.01  0  0  0  4  0  2  0  0  0
0 0.19 0.0361 0.90  0  0  0  1  0  0  1  0  0
1 0.19 0.0361 0.55  0  0  0  1  0  0  0  0  0
1 0.19 0.0361 0.15  0  1  0  1  0  2  0  0  0
1 0.19 0.0361 0.35  0  0  0  1  1  1  1  0  0
0 0.19 0.0361 0.35  0  0  0  4  2  0  0  0  0
1 0.19 0.0361 0.01  0  0  0  1  0  0  1  0  0
0 0.19 0.0361 0.15  0  0  0  2  1  0  0  0  0
1 0.19 0.0361 0.55  0  0  0  4  4  7  0  0  0
1 0.19 0.0361 0.25  0  0  0  3  0  1  1  0  0
1 0.19 0.0361 0.75  1  0  0  3  0  3  0  0  0
1 0.19 0.0361 0.65  0  0  0  2  1  0  1  0  0
1 0.19 0.0361 0.25  1  0  0  4  2  9  0  1  0
0 0.19 0.0361 0.25  0  0  0  1  0  2  0  0  0
1 0.19 0.0361 0.25  0  0  0  1  0  1  0  0  0
1 0.19 0.0361 0.45  0  0  0  1  0  0  0  0  0
1 0.19 0.0361 0.15  0  0  0  2  0  0  1  0  0
1 0.19 0.0361 0.35  0  0  0  1  0  1  0  0  0
1 0.19 0.0361 0.65  0  0  0  2  0  1  0  0  0
0 0.19 0.0361 0.45  0  0  0  1  3  1  0  0  0
0 0.19 0.0361 1.30  1  0  0  1  0  0  0  0  0
0 0.19 0.0361 0.00  1  0  0  1  0  0  0  0  0
1 0.19 0.0361 0.00  1  0  0  1  0  0  1  0  0
0 0.19 0.0361 1.10  1  0  0  1  0  0  1  0  0
0 0.19 0.0361 0.00  0  0  0  3  0  0  0  0  0
0 0.19 0.0361 0.65  0  1  0  1  0  1  0  0  0
1 0.19 0.0361 0.45  1  0  0  2  0  0  0  0  0
0 0.19 0.0361 0.65  1  0  0  5  0  6  0  1  0
1 0.19 0.0361 0.15  1  0  0  3  0  0  0  0  0
0 0.19 0.0361 0.55  0  0  0  2  0  1  0  0  0
0 0.19 0.0361 0.25  0  1  0  1  0  0  0  0  0
0 0.19 0.0361 0.65  0  0  0  1  0  0  1  0  0
0 0.19 0.0361 0.35  0  1  0  1  0  0  0  0  0
1 0.19 0.0361 0.35  0  0  0  2  0  0  0  0  0
0 0.19 0.0361 0.55  1  0  0  1  0  0  1  0  0
0 0.19 0.0361 0.35  0  0  0  2  3  0  0  0  0
0 0.19 0.0361 0.45  0  0  0  1  4  0  0  0  0
0 0.19 0.0361 0.75  0  0  0  2  0  2  0  0  0
0 0.19 0.0361 0.55  0  0  0  2  0  1  0  0  0
0 0.19 0.0361 0.25  1  0  0  2 14  2  0  1  0
1 0.19 0.0361 0.15  0  1  0  3  0  1  1  0  0
1 0.19 0.0361 0.00  0  1  0  3  0  3  0  0  0
0 0.19 0.0361 0.06  0  0  0  1  0  1  0  0  0
1 0.19 0.0361 0.55  0  0  0  2  0  0  0  0  0
0 0.19 0.0361 0.55  0  0  0  2  0  0  1  0  0
1 0.19 0.0361 0.90  0  0  0  1  0  2  1  0  0
1 0.19 0.0361 0.35  0  0  0  2  4  4  0  0  0
0 0.19 0.0361 0.55  0  0  0  1 14  0  1  0  0
1 0.19 0.0361 0.55  0  0  0  1  0  5  0  0  0
0 0.19 0.0361 0.25  0  0  0  1  0  2  0  0  0
0 0.19 0.0361 0.35  0  0  0  1  0  0  0  0  0
1 0.19 0.0361 0.45  0  0  0  1  0  0  0  0  0
0 0.19 0.0361 0.35  1  0  0  2  0  1  0  0  0
1 0.19 0.0361 0.55  0  0  0  1  0  0  0  0  0
1 0.19 0.0361 0.35  0  0  0  3  2  1  0  0  0
0 0.19 0.0361 0.55  1  0  0  1  0  0  0  0  0
0 0.19 0.0361 0.45  0  0  0  1  0  0  0  0  0
0 0.19 0.0361 0.65  0  1  0  2  0  1  0  0  0
0 0.19 0.0361 0.45  0  0  0  3  0  0  0  0  0
0 0.19 0.0361 0.65  1  0  0  2  0  0  0  0  0
0 0.19 0.0361 0.45  0  0  0  1  0  0  0  0  0
1 0.19 0.0361 0.25  0  0  0  3  0  5  0  0  0
0 0.19 0.0361 0.55  0  0  0  1  0  1  0  0  0
1 0.19 0.0361 0.35  0  0  0  3  0  0  0  1  0
0 0.19 0.0361 0.00  1  0  0  0  0  1  0  0  0
1 0.19 0.0361 0.65  0  1  0  0  0  0  0  0  0
1 0.19 0.0361 0.55  1  0  0  0  0  0  1  0  0
1 0.19 0.0361 0.45  0  0  0  0  0  0  0  0  0
1 0.19 0.0361 0.45  0  0  0  0  0  0  1  0  0
1 0.19 0.0361 0.35  0  0  0  0  0  0  0  0  0
1 0.19 0.0361 0.15  0  0  0  0  0  0  1  0  0
0 0.19 0.0361 0.00  1  0  0  0  0  0  0  0  0
1 0.19 0.0361 0.45  1  0  0  0  0  3  1  0  0
0 0.19 0.0361 0.75  0  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.45  0  0  0  0  0  0  0  0  0
1 0.19 0.0361 0.25  1  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.35  0  0  0  0  0  0  0  0  0
1 0.19 0.0361 0.65  1  0  0  0  0  0  1  0  0
0 0.19 0.0361 0.15  0  1  0  0  0  3  0  0  0
1 0.19 0.0361 0.00  0  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.45  0  0  0  0  0  0  0  0  0
1 0.19 0.0361 0.55  0  0  0  0  0  1  0  0  0
0 0.19 0.0361 0.45  1  0  0  0  0  0  0  0  0
1 0.19 0.0361 0.55  1  0  0  0  0  2  0  0  0
0 0.19 0.0361 0.90  1  0  0  0  0  0  1  0  0
0 0.19 0.0361 0.45  1  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.45  0  0  0  0  0  0  1  0  0
1 0.19 0.0361 0.90  1  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.65  0  0  0  0  0  1  0  0  0
0 0.19 0.0361 0.35  0  0  0  0  0  5  0  0  0
0 0.19 0.0361 0.35  0  1  0  0  0  2  0  1  0
1 0.19 0.0361 0.25  0  0  0  0  0  1  0  0  0
0 0.19 0.0361 0.65  1  0  0  0  0  0  0  0  0
1 0.19 0.0361 0.55  0  0  0  0  0  0  0  0  0
1 0.19 0.0361 0.00  0  0  0  0  0  0  1  0  0
0 0.19 0.0361 0.45  0  0  0  0  0  0  0  0  0
1 0.19 0.0361 0.25  0  1  0  0  0  0  0  0  0
0 0.19 0.0361 0.65  1  0  0  0  0  0  1  0  0
1 0.19 0.0361 0.01  0  1  0  0  0  0  0  1  0
1 0.19 0.0361 0.00  0  1  0  0  0  0  0  0  0
0 0.19 0.0361 0.55  0  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.25  0  1  0  0  0  0  0  0  0
0 0.19 0.0361 0.25  0  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.00  0  0  0  0  0  0  0  0  0
1 0.19 0.0361 0.45  1  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.65  1  0  0  0  0  4  0  0  0
0 0.19 0.0361 0.45  1  0  0  0  0  0  1  0  0
0 0.19 0.0361 0.15  1  0  0  0  0  1  1  0  0
0 0.19 0.0361 0.90  0  0  0  0  0  0  0  0  0
1 0.19 0.0361 0.55  0  0  0  0  0  6  0  0  0
0 0.19 0.0361 0.35  0  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.55  0  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.75  0  0  0  0  0  1  0  0  0
1 0.19 0.0361 0.45  0  0  0  0  0  0  0  0  0
1 0.19 0.0361 0.25  1  0  0  0  0  0  0  1  0
1 0.19 0.0361 0.45  0  0  0  0  0  0  0  0  0
1 0.22 0.0484 1.10  1  0  0  1  0  0  0  0  0
1 0.22 0.0484 1.10  0  0  0  1  5  2  1  0  0
1 0.22 0.0484 0.45  1  0  0  3  0  3  0  0  0
0 0.22 0.0484 1.30  0  0  0  2  0  0  0  0  0
1 0.22 0.0484 0.65  0  0  0  1  2  1  0  0  0
0 0.22 0.0484 0.90  1  0  0  2  0  0  0  0  0
1 0.22 0.0484 0.06  1  0  0  4  5  9  0  0  0
1 0.22 0.0484 1.10  1  0  0  2  0  0  0  0  0
0 0.22 0.0484 0.55  0  0  0  1  0  0  0  0  0
1 0.22 0.0484 0.35  0  0  0  1  0  0  1  0  0
0 0.22 0.0484 0.55  1  0  0  2  0  1  0  0  0
0 0.22 0.0484 0.25  0  0  0  4  0  0  1  0  0
0 0.22 0.0484 0.25  0  1  0  3  9  2  1  0  0
1 0.22 0.0484 0.35  0  1  0  3  0  1  1  0  0
1 0.22 0.0484 0.90  0  0  0  3  0  2  0  0  0
1 0.22 0.0484 0.01  1  0  0  3  0 12  0  0  0
1 0.22 0.0484 0.25  0  1  0  2  1  1  0  0  0
1 0.22 0.0484 0.65  0  0  0  1  1  2  0  0  0
1 0.22 0.0484 0.55  1  0  0  1  0  6  0  0  0
1 0.22 0.0484 0.35  0  1  0  2  0  4  0  1  0
1 0.22 0.0484 0.65  0  0  0  3  0  0  1  0  0
0 0.22 0.0484 0.25  1  0  0  1  0  0  1  0  0
0 0.22 0.0484 0.15  1  0  0  1  0  1  1  0  0
0 0.22 0.0484 0.15  0  0  0  2  0  2  0  0  0
1 0.22 0.0484 0.75  0  0  0  3  0  2  1  0  0
0 0.22 0.0484 0.75  0  0  0  1  0  0  0  0  0
1 0.22 0.0484 0.65  1  0  0  4  0  6  1  0  0
0 0.22 0.0484 0.75  0  0  0  1  0  1  0  0  0
0 0.22 0.0484 0.45  0  0  0  3  0  2  1  0  0
1 0.22 0.0484 0.15  1  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.45  1  0  0  1  0  0  0  0  0
1 0.22 0.0484 0.75  1  0  0  5  0  5  1  0  0
0 0.22 0.0484 1.10  1  0  0  3  0  2  0  0  0
1 0.22 0.0484 0.45  1  0  0  4  0  0  1  0  0
0 0.22 0.0484 0.75  0  0  0  2  0  4  1  0  0
1 0.22 0.0484 0.45  1  0  0  2  0  0  0  0  0
0 0.22 0.0484 0.90  1  0  0  3  0  1  1  0  0
0 0.22 0.0484 0.90  1  0  0  3  1  0  0  1  0
1 0.22 0.0484 0.90  1  0  0  2  0  3  0  1  0
1 0.22 0.0484 0.90  0  0  0  1  0  1  0  0  0
0 0.22 0.0484 0.00  0  0  0  2  0  2  1  0  0
1 0.22 0.0484 1.10  1  0  0  2  0  6  1  0  0
1 0.22 0.0484 0.65  0  0  0  1  0  6  1  0  0
0 0.22 0.0484 1.10  0  0  0  2  0  2  0  0  0
1 0.22 0.0484 0.45  0  0  0  2  0  1  1  0  0
1 0.22 0.0484 0.00  0  1  0  2  0  4  0  0  0
1 0.22 0.0484 0.65  1  0  0  2  0  0  0  0  0
1 0.22 0.0484 0.90  1  0  0  2  0  0  0  0  0
1 0.22 0.0484 0.65  0  0  0  1  0  2  0  0  0
0 0.22 0.0484 0.75  0  0  0  1  0  1  0  0  0
1 0.22 0.0484 0.65  1  0  0  2  0  2  0  0  0
1 0.22 0.0484 0.55  1  0  0  1  0  0  1  0  0
0 0.22 0.0484 0.75  0  0  0  2  0  0  0  0  0
0 0.22 0.0484 0.06  0  1  0  1  0  2  1  0  0
0 0.22 0.0484 0.45  1  0  0  2  0  4  1  0  0
0 0.22 0.0484 0.45  1  0  0  1  0  0  0  0  0
1 0.22 0.0484 0.55  1  0  0  1  0  5  1  0  0
0 0.22 0.0484 0.15  1  0  0  1  0  3  1  0  0
0 0.22 0.0484 0.00  1  0  0  1  0  6  0  0  0
1 0.22 0.0484 1.30  0  0  0  2  0  2  1  0  0
1 0.22 0.0484 0.75  1  0  0  1  0  4  0  1  0
0 0.22 0.0484 0.65  1  0  0  1  0  1  1  0  0
1 0.22 0.0484 0.65  0  0  0  3  2  1  0  0  0
1 0.22 0.0484 0.45  1  0  0  1  0  4  1  0  0
1 0.22 0.0484 0.65  1  0  0  4  0  7  0  0  0
1 0.22 0.0484 0.45  1  0  0  2  1  3  1  0  0
0 0.22 0.0484 0.90  1  0  0  4  0  3  0  0  0
1 0.22 0.0484 0.75  0  0  0  4  0  0  1  0  0
1 0.22 0.0484 0.65  1  0  0  1  0  8  0  1  0
1 0.22 0.0484 0.25  1  0  0  2  0  1  0  0  0
0 0.22 0.0484 0.45  1  0  0  3  0  9  1  0  0
0 0.22 0.0484 0.90  0  0  0  3  0  2  0  0  0
1 0.22 0.0484 1.10  1  0  0  2  0  3  0  0  0
1 0.22 0.0484 0.90  0  0  0  1  0  2  0  0  0
0 0.22 0.0484 0.90  0  0  0  1  0  1  0  0  0
0 0.22 0.0484 1.10  1  0  0  3  0  1  0  0  0
0 0.22 0.0484 0.90  0  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.65  0  0  0  1  0  0  0  0  0
0 0.22 0.0484 1.30  1  0  0  3  0  0  1  0  0
0 0.22 0.0484 0.75  0  0  0  1  0  0  0  0  0
1 0.22 0.0484 0.15  1  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.90  1  0  0  2  0  0  0  1  0
0 0.22 0.0484 0.25  0  0  0  1  1  0  1  0  0
1 0.22 0.0484 0.45  1  0  0  4  1  4  1  0  0
0 0.22 0.0484 0.65  0  0  0  1  0  0  1  0  0
1 0.22 0.0484 1.10  1  0  0  2  0  3  0  1  0
1 0.22 0.0484 0.75  0  0  0  1  0  0  1  0  0
0 0.22 0.0484 0.55  1  0  0  2  0  1  0  0  0
0 0.22 0.0484 0.65  0  0  0  1  0  0  1  0  0
0 0.22 0.0484 0.75  0  0  0  2  0  0  0  0  0
0 0.22 0.0484 0.01  0  0  0  2  0  4  0  0  0
1 0.22 0.0484 0.55  1  0  0  1  0  0  0  0  0
1 0.22 0.0484 0.65  1  0  0  2  0  0  0  0  0
1 0.22 0.0484 0.65  1  0  0  3  2  1  0  1  0
0 0.22 0.0484 1.10  0  0  0  1  0  1  1  0  0
0 0.22 0.0484 0.25  0  1  0  3  0  2  1  0  0
0 0.22 0.0484 0.75  0  0  0  1  0  0  0  0  0
1 0.22 0.0484 0.75  0  0  0  3  0  0  0  1  0
0 0.22 0.0484 1.10  0  0  0  1  0  0  1  0  0
0 0.22 0.0484 0.90  1  0  0  1  0  0  0  0  0
1 0.22 0.0484 0.75  0  0  0  1  1  2  1  0  0
1 0.22 0.0484 0.55  0  0  0  2  1  0  1  0  0
1 0.22 0.0484 1.10  1  0  0  1  0  0  0  0  0
1 0.22 0.0484 1.10  1  0  0  2  0  0  1  0  0
1 0.22 0.0484 0.65  1  0  0  1  0  0  0  0  0
1 0.22 0.0484 0.35  0  0  0  1  0  0  1  0  0
0 0.22 0.0484 1.10  0  0  0  1  0  0  0  0  0
1 0.22 0.0484 0.25  1  0  0  1  0  0  1  0  0
1 0.22 0.0484 0.45  1  0  0  2  1  0  0  0  0
1 0.22 0.0484 0.55  1  0  0  1  0  1  0  0  0
1 0.22 0.0484 0.35  0  0  0  2  0  0  1  0  0
0 0.22 0.0484 0.90  1  0  0  1  0  1  0  0  0
1 0.22 0.0484 0.90  1  0  0  2  0  3  1  0  0
1 0.22 0.0484 0.55  1  0  0  1  2  2  0  0  0
1 0.22 0.0484 0.65  1  0  0  1  2  0  1  0  0
1 0.22 0.0484 0.25  0  0  0  1  0  1  0  0  0
0 0.22 0.0484 0.65  0  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.55  0  0  0  1  0  1  0  0  0
0 0.22 0.0484 0.65  1  0  0  1  0  1  0  0  0
0 0.22 0.0484 1.50  1  0  0  1  1  1  1  0  0
1 0.22 0.0484 1.10  1  0  0  1  0  0  0  0  0
1 0.22 0.0484 0.90  1  0  0  2  0  2  0  0  0
0 0.22 0.0484 0.75  1  0  0  2  0  0  1  0  0
1 0.22 0.0484 0.55  0  0  0  1  0  0  0  0  0
1 0.22 0.0484 0.90  0  0  0  2  0  6  0  0  0
1 0.22 0.0484 0.90  1  0  0  1  0  0  1  0  0
0 0.22 0.0484 0.90  1  0  0  2  0  2  0  0  0
0 0.22 0.0484 0.75  0  0  0  1  0  2  1  0  0
1 0.22 0.0484 0.06  1  0  0  1  0  3  0  0  0
0 0.22 0.0484 0.55  0  0  0  3  0  4  1  0  0
1 0.22 0.0484 0.00  1  0  0  1  0  0  0  0  0
1 0.22 0.0484 0.65  0  0  0  1  1  1  1  0  0
1 0.22 0.0484 0.35  1  0  0  2  0  3  0  0  0
1 0.22 0.0484 0.90  0  0  0  4  0  2  1  0  0
0 0.22 0.0484 0.35  0  0  0  1  0  2  1  0  0
1 0.22 0.0484 0.55  0  0  0  1  0  1  0  0  0
1 0.22 0.0484 0.06  0  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.55  0  0  0  1  0  2  0  1  0
0 0.22 0.0484 0.90  1  0  0  3  0  0  1  0  0
0 0.22 0.0484 0.25  0  0  0  1  0  3  1  0  0
1 0.22 0.0484 0.55  1  0  0  2  0  0  1  0  0
0 0.22 0.0484 0.35  0  1  0  2  0  0  0  0  0
0 0.22 0.0484 0.45  0  0  0  1  0  2  0  0  0
1 0.22 0.0484 0.25  0  1  0  1  0  2  0  0  0
1 0.22 0.0484 0.06  1  0  0  1  0  0  1  0  0
1 0.22 0.0484 0.55  1  0  0  3  0  6  0  0  0
0 0.22 0.0484 0.35  1  0  0  2  0  1  0  0  0
0 0.22 0.0484 0.55  0  1  0  2  5  1  0  0  0
0 0.22 0.0484 0.75  0  0  0  3  0  0  1  0  0
0 0.22 0.0484 1.10  1  0  0  2  0  0  0  0  0
1 0.22 0.0484 0.65  1  0  0  1  0  0  1  0  0
0 0.22 0.0484 0.06  0  1  0  1  0  0  0  0  0
0 0.22 0.0484 1.10  0  0  0  3  0  4  0  0  0
1 0.22 0.0484 0.65  0  0  0  3  0  2  0  0  0
1 0.22 0.0484 0.65  0  0  0  1  0  0  0  0  0
1 0.22 0.0484 0.35  0  0  0  1  0  0  1  0  0
1 0.22 0.0484 0.90  1  0  0  2  0  1  0  0  0
1 0.22 0.0484 0.65  1  0  0  2  0  0  0  0  0
0 0.22 0.0484 0.65  0  0  0  2  0  0  1  0  0
1 0.22 0.0484 0.75  0  0  0  1  0  0  1  0  0
1 0.22 0.0484 0.65  0  0  0  1  0  0  1  0  0
1 0.22 0.0484 0.75  1  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.90  1  0  0  2  1  1  1  0  0
1 0.22 0.0484 0.25  1  0  0  3  7  2  1  0  0
1 0.22 0.0484 0.55  0  0  0  3  0  1  1  0  0
0 0.22 0.0484 0.75  1  0  0  1  0  2  0  0  0
0 0.22 0.0484 1.10  1  0  0  1  0  0  1  0  0
1 0.22 0.0484 0.75  1  0  0  1  0  0  1  0  0
0 0.22 0.0484 0.90  1  0  0  1  0  0  0  0  0
1 0.22 0.0484 0.90  0  0  0  3  0  3  0  1  0
1 0.22 0.0484 0.90  1  0  0  2  0  0  0  1  0
1 0.22 0.0484 0.65  0  0  0  1  0  1  1  0  0
1 0.22 0.0484 0.75  1  0  0  4  0  3  0  0  0
1 0.22 0.0484 0.65  1  0  0  1  0  1  1  0  0
1 0.22 0.0484 0.25  0  0  0  5  0  1  1  0  0
1 0.22 0.0484 0.55  1  0  0  3  0  1  1  0  0
0 0.22 0.0484 0.90  0  0  0  3  0  5  0  1  0
1 0.22 0.0484 0.15  1  0  0  2  0  0  1  0  0
0 0.22 0.0484 0.90  1  0  0  1  0  0  0  1  0
0 0.22 0.0484 0.65  0  0  0  1  0  0  1  0  0
1 0.22 0.0484 0.55  1  0  0  1  0  0  0  1  0
1 0.22 0.0484 0.75  1  0  0  2  0  3  0  0  0
1 0.22 0.0484 0.75  0  0  0  1  0  0  0  0  0
1 0.22 0.0484 0.65  1  0  0  3  0  0  0  0  0
1 0.22 0.0484 0.90  0  0  0  1  0  0  1  0  0
0 0.22 0.0484 0.35  0  1  0  1  0  2  1  0  0
1 0.22 0.0484 0.75  1  0  0  3  0  0  1  0  0
0 0.22 0.0484 1.10  1  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.75  1  0  0  2  0  2  0  0  0
1 0.22 0.0484 1.10  1  0  0  1  0  0  0  1  0
0 0.22 0.0484 1.10  1  0  0  1  0  0  0  1  0
0 0.22 0.0484 0.55  0  0  0  2  0  1  1  0  0
0 0.22 0.0484 1.50  0  0  0  2  0  1  0  0  0
0 0.22 0.0484 1.30  0  0  0  4  0  3  1  0  0
0 0.22 0.0484 1.10  1  0  0  1  0  0  0  1  0
0 0.22 0.0484 0.90  1  0  0  3  0  1  0  0  0
1 0.22 0.0484 0.90  1  0  0  4  3  2  0  1  0
0 0.22 0.0484 0.15  1  0  0  2  1  0  1  0  0
0 0.22 0.0484 0.75  0  0  0  1 14  3  0  1  0
1 0.22 0.0484 0.45  1  0  0  2  0  0  1  0  0
0 0.22 0.0484 0.90  0  0  0  1  0  0  0  0  0
1 0.22 0.0484 0.55  0  0  0  1  0  0  1  0  0
0 0.22 0.0484 0.15  0  0  0  1  0  0  0  0  0
1 0.22 0.0484 0.65  1  0  0  2  3  3  0  1  0
0 0.22 0.0484 0.75  0  0  0  3  0  0  0  0  0
1 0.22 0.0484 0.65  1  0  0  1  0  0  1  0  0
0 0.22 0.0484 0.75  1  0  0  3  0  0  1  0  0
1 0.22 0.0484 0.55  1  0  0  2 14  6  0  1  0
0 0.22 0.0484 0.55  0  1  0  2 14  1  0  1  0
0 0.22 0.0484 0.06  0  0  0  1  0  0  0  0  0
1 0.22 0.0484 0.35  0  0  0  1  0  5  0  0  0
1 0.22 0.0484 0.15  1  0  0  1  0  3  0  0  0
0 0.22 0.0484 0.75  0  1  0  4  0  4  0  1  0
1 0.22 0.0484 0.90  1  0  0  1  0  0  0  0  0
1 0.22 0.0484 0.55  0  0  0  2  0  3  1  0  0
1 0.22 0.0484 0.90  1  0  0  2  0  0  1  0  0
1 0.22 0.0484 0.00  0  0  1  1  0  4  0  1  0
0 0.22 0.0484 0.55  0  0  0  4  1  1  1  0  0
1 0.22 0.0484 0.65  0  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.55  0  0  0  4  0  2  1  0  0
0 0.22 0.0484 0.90  1  0  0  1  0  0  1  0  0
0 0.22 0.0484 0.45  1  0  0  1  1  0  0  0  0
0 0.22 0.0484 0.65  0  0  0  1 14  0  0  1  0
0 0.22 0.0484 1.10  1  0  0  5  0  1  0  0  0
0 0.22 0.0484 1.50  1  0  0  2  0  0  0  0  0
0 0.22 0.0484 1.10  1  0  0  1  0  0  0  0  0
0 0.22 0.0484 1.10  1  0  0  1  0  0  0  0  0
1 0.22 0.0484 0.75  0  0  0  2 14  0  0  0  0
0 0.22 0.0484 0.90  0  0  0  2  0  0  1  0  0
0 0.22 0.0484 0.65  0  0  0  3  0  2  0  0  0
0 0.22 0.0484 0.65  0  0  0  3  0  0  1  0  0
0 0.22 0.0484 0.55  0  0  0  2  0  1  0  0  0
0 0.22 0.0484 0.90  0  0  0  5  4  3  0  0  0
0 0.22 0.0484 0.45  0  0  0  5  2  0  0  1  0
0 0.22 0.0484 0.90  1  0  0  2  0  0  0  0  0
1 0.22 0.0484 0.45  1  0  0  3  0  2  0  0  0
1 0.22 0.0484 0.55  0  1  0  3 14  1  1  0  0
1 0.22 0.0484 0.65  0  0  0  3  1  0  1  0  0
0 0.22 0.0484 0.90  0  0  0  4  7  4  0  0  0
0 0.22 0.0484 1.10  0  0  0  1  0  0  0  0  0
1 0.22 0.0484 0.65  1  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.25  0  0  0  0  0  0  0  0  0
1 0.22 0.0484 1.10  0  0  0  0  0  3  0  0  0
1 0.22 0.0484 0.90  1  0  0  0  0  1  0  0  0
0 0.22 0.0484 1.30  1  0  0  0  0  0  1  0  0
1 0.22 0.0484 0.75  1  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.90  0  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.75  1  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.65  1  0  0  0  0  4  0  0  0
0 0.22 0.0484 0.45  1  0  0  0  0  0  1  0  0
0 0.22 0.0484 0.45  1  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.65  1  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.65  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.75  1  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.55  0  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.75  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.55  1  0  0  0  0  1  0  0  0
0 0.22 0.0484 0.75  1  0  0  0  0  2  0  0  0
0 0.22 0.0484 0.45  0  0  0  0  0  0  1  0  0
1 0.22 0.0484 0.90  1  0  0  0  0  0  0  1  0
0 0.22 0.0484 0.90  0  0  0  0  0  1  0  0  0
0 0.22 0.0484 1.10  1  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.75  1  0  0  0  0  0  1  0  0
1 0.22 0.0484 0.15  1  0  0  0  0  1  0  0  0
0 0.22 0.0484 0.90  1  0  0  0  0  0  0  1  0
1 0.22 0.0484 0.65  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.65  0  0  1  0  0  0  0  0  0
1 0.22 0.0484 0.55  0  0  1  0  0  0  0  0  0
1 0.22 0.0484 0.90  1  0  0  0  0  0  1  0  0
0 0.22 0.0484 0.06  1  0  0  0  0  1  0  0  0
0 0.22 0.0484 0.75  0  0  1  0  0  0  0  0  0
1 0.22 0.0484 0.35  0  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.90  0  0  0  0  0  5  0  0  0
1 0.22 0.0484 0.45  0  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.45  0  0  0  0  0  0  1  0  0
1 0.22 0.0484 0.75  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.65  1  0  0  0  0  2  0  0  0
0 0.22 0.0484 0.15  0  0  0  0  0  1  0  0  0
1 0.22 0.0484 0.55  1  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.55  0  1  0  0  0  0  0  0  0
0 0.22 0.0484 1.10  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.90  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 1.30  0  0  0  0  0  0  1  0  0
1 0.22 0.0484 0.75  0  0  0  0  0  2  1  0  0
0 0.22 0.0484 0.45  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.55  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 1.10  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.75  1  0  0  0  0  0  1  0  0
0 0.22 0.0484 0.65  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.90  0  0  0  0  0  1  0  0  0
0 0.22 0.0484 0.90  1  0  0  0  0  0  0  1  0
0 0.22 0.0484 0.35  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.35  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.45  0  0  0  0  0  2  0  0  0
1 0.22 0.0484 0.35  1  0  0  0  0  1  0  0  0
0 0.22 0.0484 0.90  1  0  0  0  0  1  0  0  0
0 0.22 0.0484 0.15  0  1  0  0  0  4  0  0  0
1 0.22 0.0484 0.65  1  0  0  0  0  1  0  0  0
0 0.22 0.0484 0.55  0  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.25  0  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.65  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.75  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.75  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 1.10  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.90  1  0  0  0  0  1  0  0  0
0 0.22 0.0484 0.90  1  0  0  0  0  1  0  0  0
1 0.22 0.0484 1.10  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.65  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.90  1  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.75  0  0  0  0  0  0  1  0  0
0 0.22 0.0484 0.75  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.90  0  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.45  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.90  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.55  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.65  1  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.55  0  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.65  1  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.45  0  0  0  0  0  3  0  0  0
0 0.22 0.0484 0.75  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.55  1  0  0  0  0  1  1  0  0
0 0.22 0.0484 0.55  0  0  0  0  0  0  1  0  0
1 0.22 0.0484 0.65  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.35  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.55  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.65  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.55  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.25  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.90  1  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.90  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.75  0  0  0  0  0  0  1  0  0
0 0.22 0.0484 0.55  0  0  0  0  0  0  1  0  0
1 0.22 0.0484 0.75  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.55  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.90  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.75  0  1  0  0  0  0  0  0  0
0 0.22 0.0484 0.75  1  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.35  0  0  0  0  0  0  1  0  0
0 0.22 0.0484 0.75  1  0  0  0  0  0  1  0  0
1 0.22 0.0484 0.90  1  0  0  0  0  0  0  1  0
0 0.22 0.0484 1.10  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.90  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.75  0  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.15  1  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.35  0  0  0  0  0  1  0  0  0
0 0.27 0.0729 0.65  0  0  0  1  0  0  1  0  0
0 0.27 0.0729 1.50  0  0  0  2  0  0  0  0  0
0 0.27 0.0729 1.10  0  0  0  1  0  0  0  0  0
0 0.27 0.0729 1.50  0  0  0  1  0  0  0  1  0
0 0.27 0.0729 1.10  0  0  0  2  0  1  1  0  0
0 0.27 0.0729 1.10  1  0  0  2  0  0  0  0  0
1 0.27 0.0729 0.90  0  0  0  2  0  8  0  1  0
0 0.27 0.0729 0.75  0  0  0  4  0  1  1  0  0
0 0.27 0.0729 0.90  1  0  0  1  0  0  0  0  0
1 0.27 0.0729 1.10  1  0  0  1  0  2  0  0  0
1 0.27 0.0729 0.01  0  0  0  1  0  0  0  0  0
0 0.27 0.0729 1.50  1  0  0  1  0  2  0  0  0
0 0.27 0.0729 0.90  0  0  0  1  0  1  0  0  0
0 0.27 0.0729 1.10  1  0  0  2  0  4  1  0  0
0 0.27 0.0729 0.45  0  1  0  4  3 12  0  0  0
1 0.27 0.0729 0.25  0  0  0  2 14  1  1  0  0
1 0.27 0.0729 1.10  0  0  0  1  0  5  1  0  0
1 0.27 0.0729 0.90  1  0  0  3  0  5  1  0  0
1 0.27 0.0729 0.75  1  0  0  2  0  0  0  0  0
1 0.27 0.0729 1.50  1  0  0  2  0 11  0  0  0
1 0.27 0.0729 0.55  1  0  0  3  0  0  1  0  0
1 0.27 0.0729 0.06  0  0  0  1  0  1  0  1  0
1 0.27 0.0729 1.10  1  0  0  2  0  2  1  0  0
1 0.27 0.0729 0.75  1  0  0  1  0  0  0  0  0
1 0.27 0.0729 0.75  1  0  0  1  0  0  1  0  0
0 0.27 0.0729 0.45  0  0  0  1  0  5  0  0  0
0 0.27 0.0729 0.90  1  0  0  4  0  2  1  0  0
0 0.27 0.0729 1.10  0  0  0  2  0  3  0  0  0
1 0.27 0.0729 1.10  1  0  0  1  0  4  0  1  0
1 0.27 0.0729 0.90  0  0  0  5 14  8  0  0  0
0 0.27 0.0729 1.10  0  0  0  2  0  0  1  0  0
0 0.27 0.0729 0.90  0  0  0  4  6  5  1  0  0
1 0.27 0.0729 0.75  1  0  0  1  0  0  0  0  0
1 0.27 0.0729 1.10  1  0  0  1  0  0  1  0  0
1 0.27 0.0729 0.90  1  0  0  1  0  1  1  0  0
1 0.27 0.0729 0.90  0  0  0  1  0  5  1  0  0
1 0.27 0.0729 1.10  1  0  0  2  1  1  1  0  0
1 0.27 0.0729 0.90  0  0  0  1  0  0  1  0  0
1 0.27 0.0729 1.30  1  0  0  2  0  0  0  0  0
0 0.27 0.0729 0.06  1  0  0  1  0  0  0  1  0
1 0.27 0.0729 0.01  1  0  0  1  0  0  1  0  0
0 0.27 0.0729 1.10  0  0  0  4  0  1  0  0  0
1 0.27 0.0729 1.10  0  0  0  1  0  6  0  0  0
0 0.27 0.0729 0.65  0  0  0  3  0  3  0  1  0
0 0.27 0.0729 0.25  0  0  1  1  0  0  0  1  0
1 0.27 0.0729 0.65  1  0  0  1  0  0  0  0  0
1 0.27 0.0729 0.90  1  0  0  1  7  0  0  0  0
0 0.27 0.0729 0.75  1  0  0  1  0  0  0  0  0
0 0.27 0.0729 1.30  1  0  0  1  2  1  0  1  0
0 0.27 0.0729 1.50  1  0  0  1  0  1  0  0  0
0 0.27 0.0729 1.10  0  0  0  2  0  0  1  0  0
1 0.27 0.0729 0.75  0  0  0  1  1  0  0  0  0
1 0.27 0.0729 0.90  1  0  0  5  0  1  1  0  0
1 0.27 0.0729 0.75  1  0  0  1  0  0  1  0  0
0 0.27 0.0729 0.01  0  0  0  5  2  4  0  1  0
0 0.27 0.0729 0.90  0  0  0  1  0  1  0  1  0
1 0.27 0.0729 0.65  1  0  0  1  1  0  1  0  0
0 0.27 0.0729 0.75  1  0  0  1  1  0  1  0  0
1 0.27 0.0729 0.75  0  0  0  4  0  0  1  0  0
1 0.27 0.0729 0.90  1  0  0  3  0  0  0  0  0
0 0.27 0.0729 1.50  0  0  0  2  0  2  0  0  0
1 0.27 0.0729 0.15  0  0  0  1  0  0  0  0  0
0 0.27 0.0729 0.90  1  0  0  1  0  0  0  0  0
0 0.27 0.0729 0.75  0  0  0  1  0  0  0  1  0
0 0.27 0.0729 0.55  0  1  0  2  0  2  1  0  0
0 0.27 0.0729 0.90  0  0  0  2  0  0  0  0  0
0 0.27 0.0729 0.45  0  1  0  4  0  2  1  0  0
1 0.27 0.0729 0.65  1  0  0  1  0  0  0  0  0
1 0.27 0.0729 0.75  1  0  0  2  0  2  0  0  0
0 0.27 0.0729 0.65  1  0  0  1  0  0  0  0  0
0 0.27 0.0729 0.45  0  0  0  1  0  1  0  0  0
1 0.27 0.0729 0.55  1  0  0  1  0  0  1  0  0
1 0.27 0.0729 1.10  1  0  0  1  0  0  1  0  0
0 0.27 0.0729 0.45  1  0  0  5  0  0  1  0  0
0 0.27 0.0729 1.10  0  0  0  1  0  0  0  0  0
0 0.27 0.0729 0.25  1  0  0  1 14  2  1  0  0
0 0.27 0.0729 1.10  1  0  0  2  0  1  0  0  0
0 0.27 0.0729 1.10  1  0  0  4  2  3  0  0  0
0 0.27 0.0729 0.65  0  0  0  1  0  0  1  0  0
0 0.27 0.0729 1.30  0  0  0  1  0  0  0  1  0
1 0.27 0.0729 0.90  1  0  0  2  0  1  0  0  0
0 0.27 0.0729 0.75  0  0  0  2  2  0  0  1  0
1 0.27 0.0729 0.75  1  0  0  1  0  1  1  0  0
0 0.27 0.0729 0.90  1  0  0  2  0  3  1  0  0
0 0.27 0.0729 1.50  1  0  0  1 14  2  0  0  0
1 0.27 0.0729 0.15  1  0  0  3  1  1  1  0  0
1 0.27 0.0729 0.45  0  0  0  1  0  0  0  0  0
1 0.27 0.0729 0.25  1  0  0  2  7  6  0  1  0
1 0.27 0.0729 0.35  0  1  0  2  0  0  1  0  0
0 0.27 0.0729 1.30  0  0  0  1  0  0  0  0  0
1 0.27 0.0729 1.30  1  0  0  2  0  0  0  0  0
1 0.27 0.0729 1.10  0  1  0  0  0  1  0  0  0
1 0.27 0.0729 0.06  0  0  1  0  0  0  0  0  0
0 0.27 0.0729 0.65  0  0  0  0  0  0  0  0  0
1 0.27 0.0729 0.75  1  0  0  0  0  0  1  0  0
1 0.27 0.0729 0.25  0  1  0  0  0  3  0  0  0
0 0.27 0.0729 0.90  0  0  0  0  0  0  0  0  0
0 0.27 0.0729 1.10  0  0  0  0  0  2  0  0  0
0 0.27 0.0729 0.55  0  0  0  0  0  0  1  0  0
0 0.27 0.0729 0.90  0  0  1  0  0  0  0  0  0
0 0.27 0.0729 1.10  1  0  0  0  0  0  0  0  0
0 0.27 0.0729 0.75  1  0  0  0  0  0  0  0  0
1 0.27 0.0729 0.65  0  1  0  0  0  1  0  0  0
0 0.27 0.0729 0.45  0  0  0  0  0  0  0  0  0
0 0.27 0.0729 0.90  1  0  0  0  0  0  0  0  0
0 0.27 0.0729 0.25  0  0  1  0  0  0  0  1  0
1 0.27 0.0729 0.90  0  0  0  0  0  1  1  0  0
0 0.27 0.0729 1.10  1  0  0  0  0  0  0  0  0
1 0.27 0.0729 1.30  1  0  0  0  0  3  1  0  0
0 0.27 0.0729 1.30  0  0  0  0  0  0  1  0  0
1 0.27 0.0729 1.30  1  0  0  0  0  0  0  0  0
0 0.27 0.0729 1.30  1  0  0  0  0  0  0  0  0
0 0.27 0.0729 1.10  1  0  0  0  0  0  0  0  0
1 0.27 0.0729 1.30  0  0  0  0  0  0  0  0  0
1 0.27 0.0729 1.10  0  0  0  0  0  1  1  0  0
0 0.27 0.0729 1.10  1  0  0  0  0  0  1  0  0
0 0.27 0.0729 1.30  0  0  0  0  0  2  0  0  0
0 0.27 0.0729 0.45  1  0  0  0  0  0  0  0  0
0 0.27 0.0729 1.10  1  0  0  0  0  0  0  0  0
0 0.27 0.0729 1.10  1  0  0  0  0  0  0  0  0
1 0.27 0.0729 0.90  1  0  0  0  0  0  1  0  0
1 0.27 0.0729 1.10  1  0  0  0  0  0  0  0  0
0 0.27 0.0729 1.10  1  0  0  0  0  0  0  0  0
1 0.27 0.0729 0.15  0  0  0  0  0  0  0  0  0
0 0.27 0.0729 1.30  1  0  0  0  0  0  1  0  0
0 0.27 0.0729 0.75  0  0  0  0  0  1  0  0  0
1 0.27 0.0729 0.90  1  0  0  0  0  0  0  0  0
1 0.27 0.0729 0.65  1  0  0  0  0  0  0  0  0
0 0.27 0.0729 0.75  1  0  0  0  0  0  1  0  0
0 0.27 0.0729 0.75  1  0  0  0  0  7  0  0  0
0 0.27 0.0729 1.10  0  0  0  0  0  0  0  0  0
1 0.27 0.0729 0.75  1  0  0  0  0  0  1  0  0
0 0.27 0.0729 0.65  1  0  0  0  0  0  1  0  0
1 0.27 0.0729 0.55  0  0  0  0  0  0  1  0  0
0 0.27 0.0729 0.06  1  0  0  0  0  1  0  0  0
1 0.27 0.0729 0.90  1  0  0  0  0  0  1  0  0
0 0.27 0.0729 0.15  0  0  0  0  0  0  0  0  0
1 0.27 0.0729 0.75  1  0  0  0  0  0  0  0  0
0 0.27 0.0729 0.35  0  0  0  0  0  0  0  0  0
0 0.27 0.0729 0.90  1  0  0  0  0  0  0  0  0
0 0.27 0.0729 0.90  0  0  0  0  0  1  0  0  0
0 0.27 0.0729 1.10  0  0  0  0  0  0  0  0  0
0 0.27 0.0729 0.90  1  0  0  0  0  0  1  0  0
0 0.27 0.0729 0.90  1  0  0  0  0  1  0  1  0
0 0.27 0.0729 0.75  1  0  0  0  4  0  1  0  0
1 0.27 0.0729 0.65  0  0  0  0  0  0  0  0  0
0 0.32 0.1024 1.50  1  0  0  1  0  2  0  0  0
0 0.32 0.1024 1.30  1  0  0  4  0  1  1  0  0
0 0.32 0.1024 1.10  1  0  0  1  0  0  1  0  0
1 0.32 0.1024 0.90  1  0  0  1  0  0  1  0  0
1 0.32 0.1024 0.35  0  0  0  1  0  8  0  0  0
0 0.32 0.1024 1.10  1  0  0  1  0  0  1  0  0
0 0.32 0.1024 0.65  0  0  0  1  0  0  1  0  0
1 0.32 0.1024 1.10  1  0  0  2  0  0  1  0  0
1 0.32 0.1024 0.75  1  0  0  5  0  5  1  0  0
0 0.32 0.1024 0.25  0  1  0  1  0  5  0  0  0
0 0.32 0.1024 1.10  1  0  0  1  0  5  0  0  0
1 0.32 0.1024 0.45  1  0  0  1  0  0  0  0  0
1 0.32 0.1024 1.10  1  0  0  5  0  0  1  0  0
1 0.32 0.1024 0.65  0  0  0  1  0  1  0  0  0
0 0.32 0.1024 0.55  0  0  0  2  0  7  1  0  0
1 0.32 0.1024 1.10  1  0  0  3  0  2  1  0  0
1 0.32 0.1024 0.90  1  0  0  4  0  3  1  0  0
0 0.32 0.1024 1.30  1  0  0  2  4 12  1  0  0
1 0.32 0.1024 0.35  1  0  0  5  0  0  0  1  0
1 0.32 0.1024 1.50  1  0  0  2  0  0  1  0  0
1 0.32 0.1024 1.30  0  0  0  2  0  0  0  0  0
0 0.32 0.1024 1.10  1  0  0  2  0  1  0  0  0
1 0.32 0.1024 0.65  1  0  0  1  0  0  1  0  0
1 0.32 0.1024 1.30  0  0  0  3  6  1  1  0  0
0 0.32 0.1024 1.50  1  0  0  1  0  0  0  0  0
1 0.32 0.1024 1.10  1  0  0  1  0  0  0  1  0
0 0.32 0.1024 1.50  1  0  0  2  2  2  1  0  0
1 0.32 0.1024 1.10  1  0  0  2  0  1  1  0  0
0 0.32 0.1024 0.90  1  0  0  2  0  0  1  0  0
1 0.32 0.1024 0.25  1  0  0  1  0  0  1  0  0
1 0.32 0.1024 1.50  1  0  0  2  0  0  1  0  0
1 0.32 0.1024 0.75  1  0  0  3  0  2  1  0  0
0 0.32 0.1024 1.30  1  0  0  1  0  3  1  0  0
1 0.32 0.1024 0.06  1  0  0  1  0  6  1  0  0
1 0.32 0.1024 1.50  1  0  0  2  0  0  0  0  0
0 0.32 0.1024 1.10  1  0  0  2  1  0  1  0  0
0 0.32 0.1024 0.75  1  0  0  3  0  0  0  0  0
0 0.32 0.1024 0.90  1  0  0  1  0  0  0  0  0
0 0.32 0.1024 0.75  0  0  0  1  0  0  1  0  0
1 0.32 0.1024 0.75  0  0  0  2  0  2  0  0  0
1 0.32 0.1024 0.90  1  0  0  1  0  0  0  0  0
1 0.32 0.1024 1.50  1  0  0  1  0  0  0  0  0
1 0.32 0.1024 0.25  1  0  0  1  0  0  0  0  0
0 0.32 0.1024 1.30  1  0  0  2  0  0  1  0  0
1 0.32 0.1024 0.75  1  0  0  2  0  0  1  0  0
0 0.32 0.1024 1.50  1  0  0  4  0  2  0  1  0
0 0.32 0.1024 1.10  0  0  0  3  0  0  1  0  0
1 0.32 0.1024 1.10  1  0  0  3  0  3  1  0  0
0 0.32 0.1024 0.00  0  0  0  3  2  7  1  0  0
1 0.32 0.1024 0.90  1  0  0  1  0  7  0  0  0
1 0.32 0.1024 1.10  1  0  0  3  0  2  1  0  0
1 0.32 0.1024 1.10  1  0  0  2  0  1  0  0  0
0 0.32 0.1024 1.10  1  0  0  2  3  0  0  0  0
0 0.32 0.1024 1.10  1  0  0  1  5  2  1  0  0
0 0.32 0.1024 1.10  0  0  0  0  0  3  0  0  0
0 0.32 0.1024 0.75  0  0  0  0  0  0  1  0  0
1 0.32 0.1024 0.75  1  0  0  0  0  0  0  0  0
0 0.32 0.1024 1.10  0  0  0  0  0  1  0  0  0
0 0.32 0.1024 1.10  1  0  0  0  0  0  1  0  0
0 0.32 0.1024 1.50  1  0  0  0  0  0  0  0  0
0 0.32 0.1024 1.50  0  0  0  0  0  0  0  0  0
0 0.32 0.1024 1.10  1  0  0  0  0  0  1  0  0
0 0.32 0.1024 0.75  1  0  0  0  0  0  1  0  0
0 0.32 0.1024 1.10  0  0  0  0  0  0  1  0  0
0 0.32 0.1024 0.90  0  0  0  0  0  0  0  0  0
0 0.32 0.1024 1.30  1  0  0  0  0  0  0  0  0
0 0.32 0.1024 0.75  0  0  0  0  0  0  0  0  0
0 0.32 0.1024 0.75  0  0  1  0  0  0  0  0  0
1 0.32 0.1024 0.55  1  0  0  0  0  0  0  0  0
0 0.32 0.1024 0.15  0  0  0  0  0  8  0  1  0
1 0.32 0.1024 0.55  0  0  0  0  0  2  0  1  0
1 0.32 0.1024 0.90  1  0  0  0  0  3  1  0  0
0 0.32 0.1024 0.75  1  0  0  0  0  0  0  0  0
1 0.32 0.1024 0.55  0  0  0  0  0  2  0  0  0
0 0.32 0.1024 1.30  0  0  0  0  0  0  1  0  0
0 0.32 0.1024 1.50  1  0  0  0  0  1  0  0  0
0 0.32 0.1024 1.10  1  0  0  0  0  0  0  0  0
1 0.32 0.1024 1.10  1  0  0  0  0  1  0  0  0
0 0.32 0.1024 0.90  0  0  0  0  0  4  0  0  0
1 0.32 0.1024 0.65  0  0  0  0  0  0  0  0  0
0 0.32 0.1024 0.55  1  0  0  0  0  1  1  0  0
0 0.32 0.1024 0.90  1  0  0  0  0  5  1  0  0
0 0.32 0.1024 0.90  0  1  0  0 14  2  0  1  0
1 0.32 0.1024 1.30  0  0  0  0  0  2  0  0  0
1 0.32 0.1024 1.50  1  0  0  0  0  0  0  1  0
0 0.32 0.1024 1.50  0  0  0  0  0  0  0  1  0
1 0.32 0.1024 0.90  1  0  0  0  0  0  0  0  0
1 0.32 0.1024 0.75  0  0  0  0  0  0  0  0  0
1 0.37 0.1369 1.10  1  0  0  2  0  6  0  0  0
0 0.37 0.1369 0.55  1  0  0  2  0  8  0  0  0
0 0.37 0.1369 0.65  1  0  0  2  0  1  0  0  0
0 0.37 0.1369 0.75  1  0  0  4  0  5  0  0  0
1 0.37 0.1369 0.90  1  0  0  5  0  5  0  0  0
1 0.37 0.1369 0.90  1  0  0  1  0  1  0  0  0
1 0.37 0.1369 0.90  1  0  0  1  0  2  0  0  0
1 0.37 0.1369 1.50  1  0  0  1  0  2  0  0  0
0 0.37 0.1369 1.10  1  0  0  3  1  1  1  0  0
1 0.37 0.1369 0.75  1  0  0  2  0  5  1  0  0
0 0.37 0.1369 1.30  0  0  0  1  0  0  0  0  0
1 0.37 0.1369 0.25  0  0  1  2 14 10  0  1  0
0 0.37 0.1369 1.10  1  0  0  1  0  0  0  0  0
1 0.37 0.1369 1.30  1  0  0  2  2  0  0  1  0
0 0.37 0.1369 0.75  1  0  0  1  3  2  1  0  0
1 0.37 0.1369 1.30  1  0  0  2  0  1  1  0  0
1 0.37 0.1369 1.50  1  0  0  3 14  0  0  0  0
1 0.37 0.1369 0.15  1  0  0  2  0  1  1  0  0
1 0.37 0.1369 1.50  1  0  0  1  1  0  0  1  0
0 0.37 0.1369 1.10  1  0  0  3  0  2  0  0  0
0 0.37 0.1369 0.90  1  0  0  1  0  0  0  0  0
1 0.37 0.1369 0.65  1  0  0  1  0  0  1  0  0
0 0.37 0.1369 1.30  1  0  0  3  1  1  0  1  0
1 0.37 0.1369 1.10  1  0  0  1  0  2  0  0  0
1 0.37 0.1369 0.25  0  0  1  1  0  0  0  1  0
0 0.37 0.1369 0.90  0  0  0  2  0  3  0  0  0
1 0.37 0.1369 1.30  1  0  0  2  2  1  1  0  0
0 0.37 0.1369 0.90  0  0  0  5  0  4  0  0  0
1 0.37 0.1369 0.75  1  0  0  2  1  0  0  1  0
0 0.37 0.1369 1.30  1  0  0  2  0  1  1  0  0
1 0.37 0.1369 0.90  1  0  0  2  0  0  1  0  0
0 0.37 0.1369 1.30  1  0  0  2  0  0  1  0  0
0 0.37 0.1369 1.50  1  0  0  1  0  0  0  0  0
0 0.37 0.1369 0.06  0  0  0  2 12  0  0  0  0
0 0.37 0.1369 0.45  0  0  0  0  0  0  0  0  0
0 0.37 0.1369 1.50  1  0  0  0  0  0  0  0  0
0 0.37 0.1369 0.65  1  0  0  0  0  0  0  0  0
0 0.37 0.1369 0.90  1  0  0  0  0  0  0  0  0
1 0.37 0.1369 0.75  1  0  0  0  0  0  1  0  0
0 0.37 0.1369 1.10  0  0  0  0  0  1  0  0  0
0 0.37 0.1369 0.55  1  0  0  0  0  0  0  0  0
0 0.37 0.1369 0.55  1  0  0  0  0  0  0  0  0
0 0.37 0.1369 0.15  0  0  1  0  0  0  0  1  0
0 0.37 0.1369 1.10  1  0  0  0  0  0  1  0  0
1 0.37 0.1369 0.90  0  0  0  0  0  0  1  0  0
1 0.42 0.1764 0.65  1  0  0  1  0  1  1  0  0
0 0.42 0.1764 1.10  1  0  0  2  0  0  0  0  0
0 0.42 0.1764 1.50  1  0  0  1  0  0  0  0  0
0 0.42 0.1764 1.30  0  0  0  2  0  0  1  0  0
0 0.42 0.1764 0.90  1  0  0  2  2  3  0  1  0
1 0.42 0.1764 0.25  0  0  1  3  0  8  1  0  0
0 0.42 0.1764 0.25  0  0  1  1  0  6  0  1  0
0 0.42 0.1764 0.75  1  0  0  2  0  0  1  0  0
1 0.42 0.1764 0.25  0  0  1  1  0  2  1  0  0
1 0.42 0.1764 0.15  0  0  1  4  0  0  1  0  0
1 0.42 0.1764 1.10  1  0  0  1  4  1  1  0  0
0 0.42 0.1764 0.90  0  0  0  1  0  0  0  0  0
0 0.42 0.1764 0.25  0  0  1  4  5  4  0  1  0
0 0.42 0.1764 0.25  0  1  0  1  0  1  1  0  0
0 0.42 0.1764 0.75  1  0  0  1  0  1  0  0  0
1 0.42 0.1764 0.25  0  0  1  3  0  0  0  1  0
1 0.42 0.1764 1.50  0  0  0  1  2  0  0  1  0
1 0.42 0.1764 0.55  0  0  0  1  0  0  1  0  0
1 0.42 0.1764 0.75  1  0  0  2  0  3  0  0  0
0 0.42 0.1764 0.45  0  0  0  2  0  0  0  1  0
1 0.42 0.1764 0.25  0  1  0  1  0  0  0  0  0
1 0.42 0.1764 0.65  1  0  0  0  0  0  0  0  0
0 0.42 0.1764 1.10  1  0  0  0  0  0  0  0  0
0 0.42 0.1764 1.50  1  0  0  0  0  0  0  0  0
0 0.42 0.1764 0.35  0  1  0  0  0  0  0  0  0
0 0.42 0.1764 1.50  0  0  0  0  0  0  0  1  0
0 0.42 0.1764 1.50  0  0  0  0  0  0  1  0  0
0 0.42 0.1764 1.50  0  0  0  0  0  0  1  0  0
1 0.42 0.1764 1.30  0  0  0  0  0  1  1  0  0
1 0.42 0.1764 0.90  0  0  0  0  0  1  1  0  0
0 0.42 0.1764 0.45  0  1  0  0  0  1  0  1  0
0 0.42 0.1764 0.90  0  0  0  0  0  1  0  0  0
1 0.47 0.2209 0.65  1  0  0  1  0  1  1  0  0
1 0.47 0.2209 0.55  1  0  0  1  0  0  1  0  0
1 0.47 0.2209 0.25  0  0  1  3  0  0  0  1  0
1 0.47 0.2209 0.65  1  0  0  4  0  0  1  0  0
0 0.47 0.2209 0.90  1  0  0  1  0  0  1  0  0
0 0.47 0.2209 0.90  0  0  0  1  0  0  1  0  0
1 0.47 0.2209 0.75  1  0  0  3  0  0  1  0  0
1 0.47 0.2209 0.45  1  0  0  2  0  8  0  0  0
0 0.47 0.2209 0.35  1  0  0  5  0  5  0  1  0
1 0.47 0.2209 0.35  1  0  0  1  0  0  1  0  0
1 0.47 0.2209 0.65  1  0  0  2  0  4  1  0  0
0 0.47 0.2209 0.90  0  0  0  1  0  6  0  0  0
0 0.47 0.2209 1.10  0  0  0  5  0  6  0  1  0
0 0.47 0.2209 0.75  0  0  0  4  0  6  1  0  0
1 0.47 0.2209 0.45  0  0  0  1  0  2  1  0  0
1 0.47 0.2209 0.75  1  0  0  2  0  0  1  0  0
1 0.47 0.2209 0.55  0  0  0  3 14  9  1  0  0
1 0.47 0.2209 0.55  1  0  0  2  0  1  1  0  0
1 0.47 0.2209 0.55  0  0  1  5  0  4  0  1  0
1 0.47 0.2209 0.55  1  0  0  4  0  0  1  0  0
0 0.47 0.2209 0.25  0  0  0  4  1  6  1  0  0
1 0.47 0.2209 0.90  1  0  0  4  0  1  0  0  0
0 0.47 0.2209 0.35  0  0  1  1  0  0  0  1  0
1 0.47 0.2209 0.06  1  0  0  1  1  3  1  0  0
0 0.47 0.2209 0.25  0  0  1  2  0  0  0  1  0
1 0.47 0.2209 0.65  0  0  0  2  0  0  0  1  0
0 0.47 0.2209 0.90  1  0  0  1  0  1  1  0  0
1 0.47 0.2209 0.25  0  0  1  2  0  1  0  1  0
1 0.47 0.2209 0.35  0  0  1  5 14  0  0  1  0
1 0.47 0.2209 0.00  1  0  0  1  0  0  1  0  0
1 0.47 0.2209 0.90  1  0  0  1  0  0  0  0  0
1 0.47 0.2209 0.45  0  0  0  2  0  0  1  0  0
1 0.47 0.2209 0.90  1  0  0  5  3  0  1  0  0
1 0.47 0.2209 0.25  1  0  0  1  0  0  0  0  0
1 0.47 0.2209 1.10  1  0  0  1  0  3  0  1  0
0 0.47 0.2209 1.50  1  0  0  2  0  0  1  0  0
1 0.47 0.2209 0.65  1  0  0  1  5  2  0  1  0
0 0.47 0.2209 1.50  1  0  0  1  0  2  0  1  0
1 0.47 0.2209 0.25  0  0  1  1  0  0  0  1  0
1 0.47 0.2209 0.65  1  0  0  3  0  0  1  0  0
1 0.47 0.2209 0.25  0  0  1  3  0  3  0  0  0
1 0.47 0.2209 0.65  1  0  0  4  1  1  0  1  0
1 0.47 0.2209 0.65  1  0  0  3  0  2  1  0  0
0 0.47 0.2209 0.75  1  0  0  0  0  0  1  0  0
1 0.47 0.2209 0.55  1  0  0  0  0  0  0  0  0
1 0.47 0.2209 0.15  0  0  1  0  0  0  0  1  0
1 0.47 0.2209 0.65  1  0  0  0  0  0  0  0  0
0 0.47 0.2209 0.75  0  0  0  0  0  1  0  0  0
1 0.47 0.2209 0.55  1  0  0  0  0  0  1  0  0
1 0.47 0.2209 0.90  1  0  0  0  0  0  0  0  0
1 0.47 0.2209 0.90  1  0  0  0  0  0  1  0  0
0 0.47 0.2209 0.90  0  0  0  0  0  0  1  0  0
0 0.47 0.2209 1.50  1  0  0  0  0  0  0  0  0
0 0.47 0.2209 1.30  0  0  0  0  0  0  1  0  0
0 0.47 0.2209 0.15  1  0  0  0  0  0  1  0  0
0 0.47 0.2209 0.75  1  0  0  0  0  2  0  0  0
1 0.47 0.2209 0.55  1  0  0  0  0  0  1  0  0
1 0.47 0.2209 0.25  0  0  0  0  0  0  1  0  0
1 0.47 0.2209 0.65  0  0  0  0  0  0  1  0  0
1 0.47 0.2209 1.30  0  0  0  0  0  0  0  0  0
1 0.47 0.2209 1.50  0  0  0  0  0  0  1  0  0
0 0.52 0.2704 1.50  1  0  0  3  0  0  1  0  0
1 0.52 0.2704 0.25  0  0  1  1 14  5  0  0  0
0 0.52 0.2704 1.30  1  0  0  4  0  6  0  1  0
1 0.52 0.2704 1.50  1  0  0  2  0  1  1  0  0
1 0.52 0.2704 0.25  1  0  0  3  0  0  1  0  0
1 0.52 0.2704 0.75  1  0  0  1  0  0  1  0  0
1 0.52 0.2704 1.30  1  0  0  2  0  7  1  0  0
1 0.52 0.2704 0.65  1  0  0  3  0  5  0  0  0
1 0.52 0.2704 1.30  1  0  0  3  0  9  0  1  0
1 0.52 0.2704 0.90  1  0  0  3  0  5  0  0  0
1 0.52 0.2704 0.06  1  0  0  1  0  1  1  0  0
1 0.52 0.2704 0.25  0  0  1  2  0  1  1  0  0
1 0.52 0.2704 0.90  1  0  0  1  0  0  1  0  0
1 0.52 0.2704 0.75  0  0  1  1  0  0  1  0  0
1 0.52 0.2704 0.15  1  0  0  1  0  1  0  1  0
1 0.52 0.2704 0.25  1  0  0  2  0  0  1  0  0
1 0.52 0.2704 1.10  0  0  1  2  0  1  1  0  0
1 0.52 0.2704 0.06  1  0  0  1  1  4  1  0  0
1 0.52 0.2704 0.25  0  0  1  1  0  0  0  0  0
1 0.52 0.2704 0.00  0  0  0  3  0  2  0  1  0
1 0.52 0.2704 0.75  0  0  0  2  0  0  1  0  0
1 0.52 0.2704 0.65  0  0  0  4  0  3  1  0  0
0 0.52 0.2704 0.65  0  0  0  3  2  0  1  0  0
1 0.52 0.2704 0.25  0  0  1  2  0  0  1  0  0
1 0.52 0.2704 0.15  0  0  1  2  0  0  0  1  0
1 0.52 0.2704 0.45  1  0  0  1  0  0  1  0  0
1 0.52 0.2704 0.75  1  0  0  5  0  1  1  0  0
0 0.52 0.2704 0.90  0  0  0  1  0  0  1  0  0
1 0.52 0.2704 0.35  0  0  1  1  3  1  0  1  0
1 0.52 0.2704 0.25  0  0  1  1  0  0  1  0  0
1 0.52 0.2704 0.25  0  0  1  2  7  1  0  1  0
1 0.52 0.2704 0.35  0  0  1  2  0  1  1  0  0
1 0.52 0.2704 0.90  0  0  0  1  0  0  0  0  0
1 0.52 0.2704 0.25  0  0  1  5  0  2  1  0  0
0 0.52 0.2704 1.30  0  0  0  1  0  0  1  0  0
1 0.52 0.2704 0.25  1  0  0  3  0  2  0  1  0
1 0.52 0.2704 1.10  1  0  0  1  0  0  1  0  0
0 0.52 0.2704 1.10  1  0  0  3  0  0  1  0  0
1 0.52 0.2704 0.45  0  0  1  4  0  1  1  0  0
1 0.52 0.2704 0.45  1  0  0  2  0  1  1  0  0
0 0.52 0.2704 0.75  1  0  0  1  0  0  1  0  0
1 0.52 0.2704 0.35  0  0  0  1  0  0  0  0  0
1 0.52 0.2704 1.10  1  0  0  1  0  0  1  0  0
1 0.52 0.2704 0.25  0  0  1  5  0  7  0  1  0
0 0.52 0.2704 0.25  0  0  1  1  0  0  0  1  0
0 0.52 0.2704 1.50  1  0  0  1  0  1  0  1  0
1 0.52 0.2704 0.55  1  0  0  3  0  0  1  0  0
0 0.52 0.2704 0.90  1  0  0  2  0  1  0  1  0
1 0.52 0.2704 0.75  1  0  0  2  0  2  0  1  0
1 0.52 0.2704 1.10  1  0  0  4  0  0  1  0  0
1 0.52 0.2704 0.35  0  0  1  3  0  1  1  0  0
0 0.52 0.2704 1.10  0  0  0  2  5  0  0  0  0
0 0.52 0.2704 1.50  1  0  0  2  0  0  0  0  0
1 0.52 0.2704 0.25  0  0  1  2  0  6  0  1  0
1 0.52 0.2704 0.25  1  0  0  5  0  1  1  0  0
1 0.52 0.2704 0.90  0  0  1  2  7  3  1  0  0
0 0.52 0.2704 0.06  0  0  0  0  0  0  1  0  0
1 0.52 0.2704 1.50  1  0  0  0  0  0  0  0  0
1 0.52 0.2704 1.50  1  0  0  0  0  0  0  0  0
0 0.52 0.2704 0.90  0  0  0  0  0  0  0  0  0
0 0.52 0.2704 0.25  0  0  1  0  0  0  0  0  0
0 0.52 0.2704 1.10  1  0  0  0  0  0  0  0  0
0 0.52 0.2704 1.10  1  0  0  0  0  1  1  0  0
1 0.52 0.2704 0.25  1  0  0  0  0  0  1  0  0
1 0.52 0.2704 0.65  0  0  0  0  0  0  1  0  0
0 0.52 0.2704 1.50  1  0  0  0  0  1  0  1  0
1 0.52 0.2704 0.25  0  0  1  0  0  0  1  0  0
1 0.52 0.2704 0.55  0  0  0  0  0  0  0  0  0
1 0.52 0.2704 0.35  1  0  0  0  0  0  1  0  0
1 0.52 0.2704 0.25  0  0  1  0  0  0  1  0  0
1 0.52 0.2704 1.10  1  0  0  0  0  0  0  1  0
0 0.52 0.2704 1.50  0  0  0  0  0  0  0  1  0
1 0.52 0.2704 0.25  1  0  0  0  0  0  1  0  0
0 0.52 0.2704 1.50  1  0  0  0  0  0  0  0  0
1 0.52 0.2704 0.90  0  0  0  0  0  2  1  0  0
1 0.57 0.3249 0.15  1  0  0  3  0  3  1  0  0
0 0.57 0.3249 0.35  0  0  1  4  0  1  0  1  0
1 0.57 0.3249 0.25  1  0  0  3  7  3  0  1  0
1 0.57 0.3249 1.50  1  0  0  2  0  1  1  0  0
0 0.57 0.3249 1.10  1  0  0  1  0  1  1  0  0
1 0.57 0.3249 0.00  1  0  0  1  0  2  0  0  0
1 0.57 0.3249 0.45  0  0  0  3  0  0  1  0  0
0 0.57 0.3249 0.25  0  1  0  2  0  5  0  1  0
1 0.57 0.3249 0.25  1  0  0  2  0  0  1  0  0
1 0.57 0.3249 0.35  0  0  1  2  0  3  0  1  0
1 0.57 0.3249 0.25  0  0  1  5  0  4  0  0  0
0 0.57 0.3249 0.25  0  0  1  2  0  1  0  1  0
1 0.57 0.3249 0.65  0  0  0  2  0  6  1  0  0
0 0.57 0.3249 0.90  1  0  0  1  0  3  0  0  0
1 0.57 0.3249 0.55  1  0  0  1  0  4  1  0  0
1 0.57 0.3249 0.35  1  0  0  1  0  0  1  0  0
1 0.57 0.3249 0.25  0  0  1  1  0  1  1  0  0
1 0.57 0.3249 0.55  1  0  0  1  0  0  0  0  0
1 0.57 0.3249 1.30  1  0  0  3  0  5  0  1  0
1 0.57 0.3249 0.00  0  0  1  2  0  1  1  0  0
1 0.57 0.3249 0.25  0  0  1  2  0  0  1  0  0
1 0.57 0.3249 0.45  1  0  0  2  0  0  1  0  0
0 0.57 0.3249 0.25  0  0  1  2  0  6  0  1  0
1 0.57 0.3249 0.25  0  0  1  5  0  0  1  0  0
1 0.57 0.3249 0.25  0  0  1  5  0  4  0  1  0
1 0.57 0.3249 0.25  1  0  0  2  0  0  1  0  0
1 0.57 0.3249 0.25  1  0  0  2  0  0  1  0  0
1 0.57 0.3249 0.15  0  0  1  5  0  0  1  0  0
1 0.57 0.3249 0.35  0  0  1  3  0  8  1  0  0
0 0.57 0.3249 0.35  0  0  0  1  0  0  1  0  0
0 0.57 0.3249 0.25  0  0  1  3  0  2  0  1  0
1 0.57 0.3249 0.90  1  0  0  1  1  3  1  0  0
1 0.57 0.3249 0.25  1  0  0  3  4  0  0  1  0
1 0.57 0.3249 0.25  0  0  1  5  0  1  0  1  0
1 0.57 0.3249 0.25  0  0  1  2  0  1  1  0  0
1 0.57 0.3249 0.25  0  0  1  2  0  0  1  0  0
1 0.57 0.3249 0.55  1  0  0  1  0  0  1  0  0
0 0.57 0.3249 0.15  1  0  0  3  0  1  1  0  0
1 0.57 0.3249 0.35  0  0  1  2  6  4  0  1  0
1 0.57 0.3249 0.00  1  0  0  5  2 10  1  0  0
0 0.57 0.3249 0.65  1  0  0  3  0  0  0  1  0
1 0.57 0.3249 1.30  0  0  1  1  0  0  0  0  0
1 0.57 0.3249 1.10  1  0  0  1  0  0  1  0  0
1 0.57 0.3249 0.65  1  0  0  2  0  1  1  0  0
1 0.57 0.3249 0.75  1  0  0  1  2  1  1  0  0
1 0.57 0.3249 0.25  0  0  1  3  0  0  1  0  0
0 0.57 0.3249 0.65  1  0  0  2  0  0  1  0  0
0 0.57 0.3249 1.30  1  0  0  1  0  0  0  1  0
0 0.57 0.3249 0.25  0  0  0  2  0  2  0  1  0
0 0.57 0.3249 0.55  0  0  0  1  0  1  1  0  0
1 0.57 0.3249 0.25  0  0  1  5  0  1  0  0  0
1 0.57 0.3249 0.45  0  0  1  2  0  0  0  1  0
1 0.57 0.3249 0.55  0  0  0  3  0  0  1  0  0
1 0.57 0.3249 0.35  0  0  1  3 14 11  0  1  0
1 0.57 0.3249 0.75  1  0  0  1  0  0  0  1  0
1 0.57 0.3249 0.25  0  0  1  3  0 11  1  0  0
1 0.57 0.3249 0.25  0  1  0  5  0  1  0  1  0
1 0.57 0.3249 0.25  0  0  1  3  0  1  0  1  0
0 0.57 0.3249 0.25  0  0  1  4  0  2  1  0  0
1 0.57 0.3249 0.65  1  0  0  1  0  2  1  0  0
1 0.57 0.3249 0.35  1  0  0  2  0  3  1  0  0
1 0.57 0.3249 0.35  0  0  1  1  0  0  1  0  0
1 0.57 0.3249 0.35  0  0  1  4  9  1  1  0  0
1 0.57 0.3249 0.15  1  0  0  3  0  3  0  1  0
1 0.57 0.3249 0.25  0  0  1  2  0  0  1  0  0
1 0.57 0.3249 0.65  1  0  0  1  0  0  1  0  0
1 0.57 0.3249 0.75  1  0  0  2  0  0  0  1  0
1 0.57 0.3249 0.25  0  0  1  3  0  0  0  1  0
0 0.57 0.3249 0.15  1  0  0  5  2  0  0  1  0
0 0.57 0.3249 0.90  0  0  0  0  0  0  0  0  0
0 0.57 0.3249 0.75  0  0  0  0  0  0  1  0  0
1 0.57 0.3249 0.55  0  1  0  0  0  6  0  0  0
1 0.57 0.3249 0.45  1  0  0  0  0  0  0  0  0
1 0.57 0.3249 0.45  0  0  1  0  0  0  0  1  0
1 0.57 0.3249 1.10  1  0  0  0  0  0  1  0  0
1 0.57 0.3249 0.25  0  0  1  0  0  0  1  0  0
1 0.57 0.3249 0.25  0  0  1  0  0  6  1  0  0
1 0.57 0.3249 0.25  0  0  1  0  0  0  1  0  0
1 0.57 0.3249 0.75  1  0  0  0  0  0  1  0  0
0 0.57 0.3249 0.90  1  0  0  0  0  1  0  0  0
0 0.57 0.3249 0.25  0  0  1  0  0  0  0  1  0
1 0.57 0.3249 0.25  1  0  0  0  0  0  0  0  0
1 0.57 0.3249 0.25  0  0  1  0  0  0  0  0  0
0 0.57 0.3249 0.90  1  0  0  0  0  0  1  0  0
1 0.57 0.3249 0.25  1  0  0  0  0  0  0  0  0
1 0.57 0.3249 0.65  0  0  0  0  0  0  1  0  0
1 0.57 0.3249 0.06  0  0  0  0  0  0  0  0  0
0 0.57 0.3249 1.30  1  0  0  0  0  0  0  0  0
1 0.57 0.3249 0.25  0  0  1  0  0  0  1  0  0
0 0.57 0.3249 1.50  1  0  0  0  0  0  1  0  0
1 0.57 0.3249 0.25  0  0  1  0  0  0  0  0  0
0 0.57 0.3249 0.65  0  0  0  0  0  0  1  0  0
0 0.57 0.3249 1.10  0  0  0  0  0  0  0  0  0
1 0.57 0.3249 1.10  0  0  1  0  0  0  1  0  0
1 0.57 0.3249 1.30  1  0  0  0  0 12  1  0  0
1 0.57 0.3249 0.65  0  0  1  0  0  0  0  0  0
1 0.62 0.3844 0.35  1  0  0  1  1  1  1  0  0
0 0.62 0.3844 0.90  1  0  0  1  0  0  1  0  0
0 0.62 0.3844 1.30  1  0  0  1  0  0  1  0  0
0 0.62 0.3844 1.50  1  0  0  1  0  0  1  0  0
1 0.62 0.3844 0.25  1  0  0  1  0  0  1  0  0
0 0.62 0.3844 0.55  1  0  0  3  0  3  0  1  0
0 0.62 0.3844 0.90  1  0  0  1  0  1  1  0  0
1 0.62 0.3844 0.25  0  0  1  4  0  2  1  0  0
1 0.62 0.3844 0.15  0  0  1  5  0  1  1  0  0
1 0.62 0.3844 0.25  1  0  0  2  0  1  0  0  0
1 0.62 0.3844 0.25  0  0  1  1  0  0  1  0  0
1 0.62 0.3844 0.15  0  0  1  1  0  0  1  0  0
1 0.62 0.3844 0.25  0  0  1  5  0  1  0  1  0
1 0.62 0.3844 0.25  1  0  0  1 14  8  1  0  0
1 0.62 0.3844 0.25  0  0  1  2  0  1  1  0  0
0 0.62 0.3844 0.90  1  0  0  2  0  0  1  0  0
0 0.62 0.3844 0.25  0  0  1  2  0  1  0  1  0
0 0.62 0.3844 0.25  0  0  1  2  0  1  0  1  0
0 0.62 0.3844 0.25  0  0  1  3  0  0  1  0  0
1 0.62 0.3844 0.55  1  0  0  2  0  0  1  0  0
1 0.62 0.3844 0.00  1  0  0  1  0  1  1  0  0
1 0.62 0.3844 0.35  0  0  1  5  0  1  1  0  0
1 0.62 0.3844 0.35  0  0  1  2  0  0  1  0  0
1 0.62 0.3844 0.65  1  0  0  4  0  5  1  0  0
0 0.62 0.3844 1.10  1  0  0  4  0  3  1  0  0
1 0.62 0.3844 0.55  1  0  0  3  0  6  1  0  0
1 0.62 0.3844 0.25  0  0  1  1  0  0  0  1  0
1 0.62 0.3844 0.25  0  0  0  1  0  0  1  0  0
1 0.62 0.3844 0.15  0  0  1  1  0  0  1  0  0
1 0.62 0.3844 0.90  0  0  1  3  0  0  1  0  0
1 0.62 0.3844 0.25  0  0  1  2  0  2  1  0  0
1 0.62 0.3844 0.25  0  0  1  1  0  0  1  0  0
1 0.62 0.3844 0.25  1  0  0  3  0  0  1  0  0
1 0.62 0.3844 0.15  0  0  1  3  0  1  0  1  0
1 0.62 0.3844 0.55  1  0  0  3  0  0  1  0  0
0 0.62 0.3844 0.25  0  0  1  4  0  1  0  1  0
1 0.62 0.3844 0.25  1  0  0  3  0  3  1  0  0
1 0.62 0.3844 0.25  0  0  1  5  0  0  1  0  0
0 0.62 0.3844 0.25  0  0  1  2  0  3  0  1  0
0 0.62 0.3844 0.75  1  0  0  3 14  3  0  1  0
0 0.62 0.3844 0.25  1  0  0  5 14  8  0  1  0
1 0.62 0.3844 0.25  0  0  1  1  0  0  1  0  0
1 0.62 0.3844 0.35  1  0  0  2  0  0  1  0  0
1 0.62 0.3844 0.25  0  0  1  1  0  0  1  0  0
0 0.62 0.3844 0.25  0  0  1  1  0  0  0  1  0
0 0.62 0.3844 1.30  0  0  0  1  0  0  1  0  0
1 0.62 0.3844 0.25  0  0  1  1  0  5  1  0  0
0 0.62 0.3844 0.35  0  0  1  1  0  0  0  1  0
1 0.62 0.3844 0.25  0  0  1  2  0  0  1  0  0
0 0.62 0.3844 0.25  0  0  1  3  0  2  0  1  0
0 0.62 0.3844 0.45  1  0  0  2  0  0  0  1  0
0 0.62 0.3844 0.35  0  0  1  4  0  5  0  1  0
1 0.62 0.3844 1.30  1  0  0  2  0  0  1  0  0
1 0.62 0.3844 0.45  0  0  0  1  0  2  1  0  0
1 0.62 0.3844 0.25  0  0  1  2  0  0  1  0  0
0 0.62 0.3844 0.55  1  0  0  5  2  0  1  0  0
1 0.62 0.3844 1.10  1  0  0  2  0  0  1  0  0
1 0.62 0.3844 0.25  0  0  1  2  0  3  0  1  0
1 0.62 0.3844 0.25  1  0  0  1  0  0  1  0  0
1 0.62 0.3844 0.45  1  0  0  2  0  0  1  0  0
1 0.62 0.3844 0.25  0  0  1  1  0  2  1  0  0
1 0.62 0.3844 0.25  0  0  1  2  0  0  1  0  0
0 0.62 0.3844 0.15  0  0  1  1  0  0  0  1  0
0 0.62 0.3844 0.25  0  0  1  3  0  0  0  1  0
1 0.62 0.3844 0.35  1  0  0  1  0  4  1  0  0
0 0.62 0.3844 0.55  0  0  0  1  0  0  0  1  0
1 0.62 0.3844 0.25  0  0  1  1  0  0  0  0  0
0 0.62 0.3844 0.35  0  0  1  1 14  0  0  1  0
0 0.62 0.3844 0.65  1  0  0  4  0  0  1  0  0
1 0.62 0.3844 0.35  0  0  1  1  0  0  0  1  0
1 0.62 0.3844 1.10  1  0  0  1  0  0  0  1  0
0 0.62 0.3844 0.15  0  0  1  3  0  0  0  1  0
1 0.62 0.3844 1.10  0  0  1  4  0  2  1  0  0
1 0.62 0.3844 0.55  1  0  0  2  0  2  1  0  0
1 0.62 0.3844 0.15  0  0  1  2  0  0  1  0  0
1 0.62 0.3844 0.65  1  0  0  2  0  0  1  0  0
1 0.62 0.3844 0.25  0  0  1  1  0  0  0  1  0
1 0.62 0.3844 0.90  0  0  0  3  0  3  0  1  0
0 0.62 0.3844 0.55  1  0  0  3  0  0  0  0  0
1 0.62 0.3844 0.75  1  0  0  1  0  0  0  0  0
1 0.62 0.3844 0.25  1  0  0  5  0  3  1  0  0
1 0.62 0.3844 0.25  0  0  1  2  0  1  0  1  0
1 0.62 0.3844 0.35  0  0  1  1  0  0  0  0  0
1 0.62 0.3844 0.35  1  0  0  1  0  1  1  0  0
1 0.62 0.3844 0.35  0  0  1  2 14  9  1  0  0
1 0.62 0.3844 0.00  0  0  0  1 14  2  0  1  0
1 0.62 0.3844 0.90  0  0  0  2  1  1  0  1  0
0 0.62 0.3844 0.00  1  0  0  4  0  0  0  1  0
1 0.62 0.3844 1.10  1  0  0  3  0  0  1  0  0
1 0.62 0.3844 0.35  0  0  0  2  0  0  0  1  0
0 0.62 0.3844 0.25  0  0  1  1  0  0  1  0  0
0 0.62 0.3844 0.65  0  0  0  1  0  0  0  0  0
1 0.62 0.3844 0.35  1  0  0  1  0  0  0  0  0
1 0.62 0.3844 0.65  0  0  1  1  0  0  1  0  0
0 0.62 0.3844 0.65  0  0  1  1  0  0  1  0  0
1 0.62 0.3844 0.25  0  0  1  1  0  0  0  1  0
1 0.62 0.3844 0.35  0  0  1  1  0  3  0  1  0
1 0.62 0.3844 0.75  1  0  0  0  0  0  0  1  0
0 0.62 0.3844 0.90  1  0  0  0 14  2  1  0  0
1 0.62 0.3844 0.35  1  0  0  0  0  0  0  1  0
0 0.62 0.3844 1.10  1  0  0  0  0  0  0  1  0
1 0.62 0.3844 1.10  1  0  0  0  0  0  0  0  0
1 0.62 0.3844 0.00  1  0  0  0  0  5  1  0  0
0 0.62 0.3844 0.90  1  0  0  0  0  1  1  0  0
1 0.62 0.3844 1.50  1  0  0  0  0  0  1  0  0
1 0.62 0.3844 0.65  1  0  0  0  0  0  0  0  0
1 0.62 0.3844 0.25  0  0  1  0  0  0  1  0  0
1 0.62 0.3844 0.25  0  0  1  0  0  0  1  0  0
1 0.62 0.3844 0.75  0  0  0  0  0  1  1  0  0
1 0.62 0.3844 0.35  1  0  0  0  0  0  0  0  0
0 0.62 0.3844 0.65  1  0  0  0  0  0  1  0  0
1 0.62 0.3844 0.25  0  0  1  0  0  0  1  0  0
0 0.62 0.3844 0.35  1  0  0  0  0  0  1  0  0
0 0.62 0.3844 1.50  1  0  0  0  0  0  1  0  0
1 0.62 0.3844 0.25  1  0  0  0  0  0  1  0  0
1 0.62 0.3844 0.25  0  0  1  0  0  0  0  0  0
1 0.62 0.3844 0.25  0  0  1  0  0  0  1  0  0
1 0.62 0.3844 0.25  0  0  1  0  0  0  0  0  0
1 0.62 0.3844 0.25  0  0  1  0  0  1  1  0  0
0 0.62 0.3844 1.10  1  0  0  0  0  0  0  1  0
0 0.62 0.3844 0.35  1  0  0  0  0  1  0  0  0
0 0.62 0.3844 0.25  0  0  1  0  0  0  1  0  0
1 0.62 0.3844 0.25  1  0  0  0  0  0  0  1  0
1 0.62 0.3844 0.25  0  0  1  0  0  0  1  0  0
0 0.62 0.3844 0.25  1  0  0  0  0  0  0  1  0
0 0.62 0.3844 0.90  1  0  0  0  0  0  1  0  0
0 0.67 0.4489 0.25  1  0  0  1 14  1  1  0  0
1 0.67 0.4489 0.25  1  0  0  1  4  1  0  0  0
1 0.67 0.4489 0.25  1  0  0  1  0  1  1  0  0
1 0.67 0.4489 0.55  1  0  0  1  0  1  1  0  0
1 0.67 0.4489 0.25  0  0  1  1  0  0  0  0  0
1 0.67 0.4489 0.25  0  0  1  3  0  2  1  0  0
1 0.67 0.4489 0.65  1  0  0  1  0  2  0  0  0
1 0.67 0.4489 0.45  0  0  1  2  0  0  1  0  0
1 0.67 0.4489 0.25  0  0  1  2  0  1  1  0  0
1 0.67 0.4489 0.25  0  0  1  1  0  3  0  0  0
1 0.67 0.4489 0.25  0  0  1  3  0  1  1  0  0
1 0.67 0.4489 0.25  0  0  1  2  0  0  1  0  0
0 0.67 0.4489 0.25  0  0  1  2  0  5  1  0  0
1 0.67 0.4489 0.35  1  0  0  3  0  5  0  0  0
1 0.67 0.4489 0.25  0  0  1  2  0  0  1  0  0
0 0.67 0.4489 0.01  0  0  1  2  0  1  1  0  0
1 0.67 0.4489 0.25  0  0  1  1  0  0  1  0  0
1 0.67 0.4489 0.35  1  0  0  3  0  1  1  0  0
0 0.67 0.4489 0.35  0  0  1  1  0  0  1  0  0
1 0.67 0.4489 0.25  0  0  1  1  0  0  1  0  0
1 0.67 0.4489 0.25  0  0  1  1  0  0  1  0  0
1 0.67 0.4489 0.35  1  0  0  3  0  0  1  0  0
1 0.67 0.4489 0.15  1  0  0  2  0  4  1  0  0
1 0.67 0.4489 0.35  0  0  1  3  0  1  1  0  0
1 0.67 0.4489 0.25  0  0  1  5  0 10  1  0  0
1 0.67 0.4489 0.25  1  0  0  2  0  0  1  0  0
0 0.67 0.4489 0.25  0  0  1  2  0  0  1  0  0
1 0.67 0.4489 0.25  1  0  0  5  7  2  0  1  0
0 0.67 0.4489 0.15  0  0  1  1  0  0  1  0  0
1 0.67 0.4489 0.15  1  0  0  1  0  0  1  0  0
1 0.67 0.4489 0.25  1  0  0  2  0  0  1  0  0
1 0.67 0.4489 0.25  0  0  1  3  2  0  1  0  0
1 0.67 0.4489 0.35  0  0  1  4  0  0  1  0  0
0 0.67 0.4489 0.06  0  0  1  2  1  0  1  0  0
1 0.67 0.4489 0.25  0  0  1  1  0  0  0  0  0
1 0.67 0.4489 0.35  1  0  0  1  3  0  0  0  0
1 0.67 0.4489 0.35  1  0  0  1  0  1  1  0  0
1 0.67 0.4489 0.35  1  0  0  1  0  0  1  0  0
0 0.67 0.4489 0.25  0  0  1  1  0  0  1  0  0
0 0.67 0.4489 0.45  0  0  1  2  0  0  1  0  0
0 0.67 0.4489 0.25  0  0  1  3  0  0  1  0  0
1 0.67 0.4489 0.35  0  0  1  3  0  4  1  0  0
0 0.67 0.4489 0.35  0  0  1  4 14  7  0  1  0
1 0.67 0.4489 0.55  1  0  0  1  0  0  0  0  0
0 0.67 0.4489 0.75  1  0  0  1  0  0  1  0  0
0 0.67 0.4489 0.25  0  0  1  2  0  0  1  0  0
1 0.67 0.4489 0.35  1  0  0  1  0  0  0  1  0
0 0.67 0.4489 1.50  1  0  0  1  0  0  1  0  0
1 0.67 0.4489 0.25  1  0  0  2  0  1  1  0  0
0 0.67 0.4489 0.35  0  0  1  3 14  4  0  0  0
1 0.67 0.4489 0.25  0  0  1  1  0  1  1  0  0
1 0.67 0.4489 0.25  0  0  1  2  0  1  0  0  0
0 0.67 0.4489 0.25  0  0  1  3  7  8  0  1  0
1 0.67 0.4489 0.25  0  0  1  1  0  1  1  0  0
1 0.67 0.4489 0.25  0  0  1  1  0  0  0  0  0
1 0.67 0.4489 0.25  0  0  1  2  0  2  1  0  0
0 0.67 0.4489 0.25  0  0  1  2  0  0  1  0  0
1 0.67 0.4489 0.25  0  0  1  1  0  0  1  0  0
1 0.67 0.4489 0.15  0  0  1  2  0  0  1  0  0
1 0.67 0.4489 0.25  0  0  1  1  0  0  1  0  0
1 0.67 0.4489 0.65  1  0  0  2  0  0  1  0  0
0 0.67 0.4489 0.35  0  0  1  2  0  0  1  0  0
1 0.67 0.4489 0.15  1  0  0  2  0  2  1  0  0
1 0.67 0.4489 0.35  0  0  1  4  0  0  1  0  0
1 0.67 0.4489 0.35  1  0  0  3  0  0  1  0  0
1 0.67 0.4489 0.25  0  0  1  5  0  0  1  0  0
1 0.67 0.4489 0.35  1  0  0  1  0  0  1  0  0
1 0.67 0.4489 0.25  0  0  1  3  1  2  1  0  0
1 0.67 0.4489 0.25  0  0  1  1  0  2  1  0  0
1 0.67 0.4489 0.25  0  0  1  1  0  0  1  0  0
1 0.67 0.4489 0.25  0  0  1  1  0  2  1  0  0
0 0.67 0.4489 0.35  0  0  1  1  0  0  1  0  0
1 0.67 0.4489 0.25  0  0  1  3  0  0  1  0  0
1 0.67 0.4489 0.25  0  0  1  3  0  0  1  0  0
1 0.67 0.4489 0.35  1  0  0  1  0  0  1  0  0
0 0.67 0.4489 0.25  0  0  1  4  0  3  0  1  0
1 0.67 0.4489 0.25  0  0  0  1  0  0  0  0  0
1 0.67 0.4489 0.25  0  0  1  2  0  0  1  0  0
1 0.67 0.4489 0.25  0  0  1  2  0  1  0  0  0
1 0.67 0.4489 0.25  0  0  1  1  0  0  1  0  0
1 0.67 0.4489 0.65  0  0  1  3  0  2  0  1  0
1 0.67 0.4489 0.25  1  0  0  3  1  0  1  0  0
0 0.67 0.4489 0.90  0  0  1  1 14  1  1  0  0
1 0.67 0.4489 0.45  0  0  1  5  8  2  1  0  0
1 0.67 0.4489 0.25  0  0  1  1  0  0  1  0  0
0 0.67 0.4489 0.25  0  0  1  3 14  3  0  1  0
0 0.67 0.4489 0.25  0  0  1  1  0  0  1  0  0
1 0.67 0.4489 0.35  0  0  1  1  0  0  1  0  0
0 0.67 0.4489 0.35  0  0  1  1  0  0  1  0  0
0 0.67 0.4489 1.50  1  0  0  3  4  3  1  0  0
1 0.67 0.4489 0.25  0  0  1  2  0  0  1  0  0
1 0.67 0.4489 0.25  0  0  1  0  0  0  0  0  0
1 0.67 0.4489 0.25  0  0  1  0  0  0  0  0  0
1 0.67 0.4489 0.45  0  0  0  0  0  0  0  0  0
1 0.67 0.4489 0.25  0  0  1  0  0  0  1  0  0
0 0.67 0.4489 0.15  0  0  1  0  0  0  0  0  0
1 0.67 0.4489 0.25  0  0  1  0  0  0  0  0  0
1 0.67 0.4489 0.25  1  0  0  0  0  0  1  0  0
1 0.67 0.4489 0.15  0  0  1  0  0  0  0  0  0
1 0.67 0.4489 0.25  0  0  1  0  0  0  0  0  0
1 0.67 0.4489 0.55  1  0  0  0  0  0  1  0  0
1 0.67 0.4489 0.35  0  0  1  0  0  0  1  0  0
1 0.67 0.4489 0.25  0  0  1  0  0  0  0  0  0
1 0.67 0.4489 0.25  0  0  1  0  0  0  1  0  0
0 0.67 0.4489 0.45  0  0  1  0  0  4  0  0  0
1 0.67 0.4489 0.25  1  0  0  0  0  1  0  0  0
1 0.67 0.4489 0.35  0  0  1  0  0  0  1  0  0
1 0.67 0.4489 0.25  0  0  1  0  0  2  0  0  0
1 0.67 0.4489 0.25  0  0  1  0  0  0  0  0  0
1 0.67 0.4489 0.25  0  0  1  0  0  0  0  0  0
1 0.67 0.4489 0.25  0  0  1  0  0  2  0  1  0
0 0.67 0.4489 0.75  0  0  0  0  0  0  0  0  0
0 0.67 0.4489 0.75  0  0  0  0  0  0  0  0  0
0 0.67 0.4489 0.75  1  0  0  0  0  0  1  0  0
1 0.67 0.4489 0.25  1  0  0  0  0  0  1  0  0
0 0.67 0.4489 0.15  0  0  1  0  0  2  1  0  0
1 0.67 0.4489 0.15  0  0  1  0  0  0  0  0  0
1 0.67 0.4489 0.35  0  0  1  0  0  2  1  0  0
1 0.67 0.4489 0.25  0  0  1  0  0  0  1  0  0
1 0.67 0.4489 0.25  1  0  0  0  0  0  1  0  0
1 0.67 0.4489 0.25  0  0  1  0  0  1  1  0  0
1 0.67 0.4489 0.15  0  0  1  0  0  5  1  0  0
0 0.67 0.4489 0.25  0  0  1  0  0  0  1  0  0
0 0.67 0.4489 0.65  1  0  0  0  0  1  1  0  0
1 0.67 0.4489 0.15  1  0  0  0  0  0  0  1  0
0 0.67 0.4489 1.30  1  0  0  0  0  0  0  0  0
1 0.72 0.5184 0.25  0  0  1  1  3  0  0  0  0
1 0.72 0.5184 0.25  0  0  1  1  4  2  0  0  0
1 0.72 0.5184 0.25  1  0  0  5  0  0  1  0  0
0 0.72 0.5184 0.25  0  0  1  1  0  2  1  0  0
1 0.72 0.5184 0.35  1  0  0  3  0  0  1  0  0
0 0.72 0.5184 0.25  0  0  0  3  0  5  1  0  0
1 0.72 0.5184 0.25  0  0  1  3  0  1  1  0  0
1 0.72 0.5184 0.25  1  0  0  5 14  9  0  1  0
1 0.72 0.5184 0.25  0  0  1  3  0  2  1  0  0
1 0.72 0.5184 0.45  1  0  0  1  0  0  0  0  0
1 0.72 0.5184 0.25  0  0  1  3  0  1  0  0  0
1 0.72 0.5184 0.55  0  0  1  1  0  2  0  0  0
1 0.72 0.5184 0.25  0  0  1  2  0  4  1  0  0
0 0.72 0.5184 0.75  1  0  0  2  0  2  1  0  0
1 0.72 0.5184 0.25  0  0  1  1  0  3  1  0  0
1 0.72 0.5184 0.25  0  0  1  3  0  1  1  0  0
1 0.72 0.5184 0.25  1  0  0  2  0  3  1  0  0
1 0.72 0.5184 0.25  1  0  0  4  0 11  0  1  0
1 0.72 0.5184 0.25  0  0  1  3  0  0  0  1  0
1 0.72 0.5184 0.65  1  0  0  4  0  9  1  0  0
1 0.72 0.5184 0.35  0  0  1  4  0  2  1  0  0
1 0.72 0.5184 0.25  1  0  0  4  0  0  1  0  0
1 0.72 0.5184 0.25  1  0  0  5  0  0  1  0  0
1 0.72 0.5184 0.25  1  0  0  1  0  2  1  0  0
1 0.72 0.5184 0.25  0  0  1  3  0  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  2  0  8  1  0  0
0 0.72 0.5184 0.35  1  0  0  2  0  5  1  0  0
1 0.72 0.5184 0.35  0  0  1  3  0  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  5  0  2  1  0  0
1 0.72 0.5184 0.25  0  0  1  5  0  2  1  0  0
1 0.72 0.5184 0.25  1  0  0  4  0  2  1  0  0
1 0.72 0.5184 0.25  1  0  0  3  0  2  1  0  0
1 0.72 0.5184 0.25  1  0  0  1  0  0  1  0  0
0 0.72 0.5184 0.25  0  0  1  5  0  7  0  0  0
1 0.72 0.5184 0.25  0  0  1  2  0  1  0  1  0
1 0.72 0.5184 0.15  1  0  0  3  0  2  1  0  0
1 0.72 0.5184 0.25  0  0  1  3  0  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  3  0  4  1  0  0
1 0.72 0.5184 0.15  0  0  1  1  0  0  0  0  0
1 0.72 0.5184 0.25  1  0  0  2  0  0  1  0  0
1 0.72 0.5184 0.35  0  0  1  3  4  2  1  0  0
1 0.72 0.5184 0.65  1  0  0  2  0  3  0  0  0
1 0.72 0.5184 0.25  0  1  0  3  0  0  1  0  0
1 0.72 0.5184 0.55  0  0  1  2  0  0  1  0  0
0 0.72 0.5184 0.25  1  0  0  2  0  2  1  0  0
0 0.72 0.5184 0.45  1  0  0  3  0  4  1  0  0
1 0.72 0.5184 0.45  0  0  1  4  0  2  1  0  0
0 0.72 0.5184 0.25  0  0  1  5 10  5  1  0  0
1 0.72 0.5184 0.25  0  0  1  5  0  3  1  0  0
1 0.72 0.5184 0.25  1  0  0  1  0  0  0  0  0
1 0.72 0.5184 0.25  0  0  1  3  0  3  0  1  0
1 0.72 0.5184 0.45  1  0  0  1  0  0  0  1  0
1 0.72 0.5184 0.25  1  0  0  3  0  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  3  0  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  2  0  1  0  0  0
0 0.72 0.5184 0.45  0  0  0  3  0  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  1  0  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  5  3  2  1  0  0
1 0.72 0.5184 0.25  1  0  0  2  0  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  1  0  0  1  0  0
1 0.72 0.5184 0.25  1  0  0  3  0  2  0  1  0
1 0.72 0.5184 0.25  1  0  0  1  0  0  1  0  0
1 0.72 0.5184 0.35  0  0  1  3  0  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  2  0  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  3  0  1  1  0  0
1 0.72 0.5184 0.25  0  0  1  4  0  0  1  0  0
0 0.72 0.5184 0.35  0  0  1  2  0  0  1  0  0
0 0.72 0.5184 0.25  0  0  1  3  0  4  1  0  0
1 0.72 0.5184 0.25  1  0  0  2  0  1  0  0  0
0 0.72 0.5184 0.25  0  0  1  1  0  1  1  0  0
1 0.72 0.5184 0.25  0  0  1  1  0  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  5  0  0  1  0  0
0 0.72 0.5184 0.75  0  0  1  5  0  1  0  1  0
1 0.72 0.5184 0.25  0  0  1  2  0  6  0  1  0
0 0.72 0.5184 1.50  1  0  0  5  3  2  1  0  0
0 0.72 0.5184 0.25  1  0  0  5  0  1  1  0  0
0 0.72 0.5184 0.45  1  0  0  2  0  0  1  0  0
1 0.72 0.5184 0.45  1  0  0  2  0  0  0  1  0
1 0.72 0.5184 0.25  0  0  1  2  0  0  1  0  0
0 0.72 0.5184 0.25  0  0  1  2  0  0  1  0  0
0 0.72 0.5184 0.25  1  0  0  2  0  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  3 14  7  0  1  0
1 0.72 0.5184 0.35  0  0  1  2  0  2  0  1  0
1 0.72 0.5184 0.35  0  0  1  4  0  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  3  0  2  1  0  0
1 0.72 0.5184 0.25  0  0  1  5  0  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  2  0  2  1  0  0
1 0.72 0.5184 0.25  0  0  1  2  0  1  1  0  0
1 0.72 0.5184 0.35  0  0  1  2  0  1  0  1  0
0 0.72 0.5184 1.10  0  0  0  2  0  1  1  0  0
0 0.72 0.5184 0.90  0  0  1  1  0  0  1  0  0
1 0.72 0.5184 0.25  0  0  0  5  0  7  1  0  0
1 0.72 0.5184 0.25  1  0  0  4  0  1  1  0  0
0 0.72 0.5184 0.25  0  0  1  4  0  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  4  0  5  1  0  0
1 0.72 0.5184 0.25  0  0  1  2  0  2  1  0  0
1 0.72 0.5184 0.25  0  0  1  1  0  1  1  0  0
1 0.72 0.5184 0.25  0  0  1  5 14  6  1  0  0
1 0.72 0.5184 0.25  0  0  1  4  0  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  5  1  5  1  0  0
1 0.72 0.5184 0.25  1  0  0  2  0  1  1  0  0
1 0.72 0.5184 0.25  1  0  0  5 12  5  0  1  0
1 0.72 0.5184 0.25  0  0  1  1  0  0  1  0  0
1 0.72 0.5184 0.35  1  0  0  1 14  4  1  0  0
1 0.72 0.5184 0.55  1  0  0  3  0  3  1  0  0
0 0.72 0.5184 0.45  1  0  0  1  0  1  1  0  0
1 0.72 0.5184 0.25  0  0  1  5  0  3  0  1  0
1 0.72 0.5184 0.25  0  0  1  4  0  3  0  1  0
1 0.72 0.5184 0.25  0  0  1  5  0  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  3  0  0  0  1  0
1 0.72 0.5184 0.35  0  0  1  1  0  0  0  1  0
1 0.72 0.5184 0.25  0  0  1  1  0  0  1  0  0
1 0.72 0.5184 0.35  0  0  1  1  0  0  1  0  0
1 0.72 0.5184 0.35  0  0  1  1  0  0  1  0  0
0 0.72 0.5184 0.25  0  0  1  1  0  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  2  0  2  0  1  0
1 0.72 0.5184 0.25  0  0  1  1  0  0  1  0  0
0 0.72 0.5184 0.25  0  0  1  5  0  0  1  0  0
0 0.72 0.5184 0.25  1  0  0  2  0  1  1  0  0
1 0.72 0.5184 0.15  0  0  1  2  0  0  1  0  0
1 0.72 0.5184 0.45  0  0  0  1  0  3  1  0  0
0 0.72 0.5184 0.35  0  0  1  5  0  2  1  0  0
1 0.72 0.5184 0.25  0  0  1  5  1  0  0  1  0
1 0.72 0.5184 0.25  0  0  1  3  0  0  0  0  0
1 0.72 0.5184 0.25  0  0  1  3  0  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  1  0  1  1  0  0
0 0.72 0.5184 0.35  1  0  0  1  0  0  0  0  0
1 0.72 0.5184 0.25  1  0  0  1  0  0  1  0  0
0 0.72 0.5184 0.65  1  0  0  1  0  0  0  0  0
1 0.72 0.5184 0.25  0  0  1  2  0  4  0  1  0
1 0.72 0.5184 0.15  1  0  0  2  0  0  1  0  0
1 0.72 0.5184 0.55  0  0  1  3  7  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  1  0  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  1  0  2  0  0  0
1 0.72 0.5184 0.35  1  0  0  3  0  0  1  0  0
1 0.72 0.5184 0.75  0  0  1  1  0  1  1  0  0
0 0.72 0.5184 0.25  0  0  1  2  0  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  4  0  0  1  0  0
1 0.72 0.5184 0.55  1  0  0  3 14  2  1  0  0
0 0.72 0.5184 0.25  0  0  1  3  0  0  1  0  0
0 0.72 0.5184 0.25  0  0  1  4  0  2  1  0  0
0 0.72 0.5184 0.45  0  0  1  3  0  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  1  0  1  1  0  0
1 0.72 0.5184 0.25  1  0  0  5  0  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  1  0  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  2  0  2  1  0  0
1 0.72 0.5184 0.45  1  0  0  3 14  4  1  0  0
0 0.72 0.5184 0.15  0  0  1  1  0  2  1  0  0
0 0.72 0.5184 0.90  1  0  0  2  0  0  1  0  0
0 0.72 0.5184 0.25  0  0  1  1  0  0  0  0  0
0 0.72 0.5184 0.25  0  0  1  2  0  5  0  0  0
0 0.72 0.5184 0.25  0  0  1  3  0  0  0  0  0
1 0.72 0.5184 0.25  0  0  1  3  0  0  0  0  0
1 0.72 0.5184 0.55  1  0  0  2  0  6  1  0  0
0 0.72 0.5184 0.25  0  0  1  2  0  1  0  0  0
0 0.72 0.5184 0.25  0  0  1  2  0  0  0  1  0
1 0.72 0.5184 0.25  0  0  1  2  1  1  1  0  0
1 0.72 0.5184 0.25  1  0  0  5  1  0  0  1  0
1 0.72 0.5184 0.25  0  0  1  4  0  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  1  0  0  0  0  0
1 0.72 0.5184 0.25  0  0  1  3  0  0  1  0  0
0 0.72 0.5184 0.25  0  0  1  3  0  0  0  0  0
1 0.72 0.5184 0.45  1  0  0  5  0  2  1  0  0
1 0.72 0.5184 0.75  1  0  0  4  0  1  1  0  0
1 0.72 0.5184 0.25  0  0  1  2  8  0  0  1  0
0 0.72 0.5184 0.45  0  0  1  1  0  1  0  0  0
1 0.72 0.5184 0.15  0  0  1  4  0  7  1  0  0
1 0.72 0.5184 0.25  0  0  1  4  0  2  1  0  0
0 0.72 0.5184 0.55  1  0  0  1  0  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  2  0  0  0  0  0
1 0.72 0.5184 0.25  0  0  1  2  0  2  1  0  0
1 0.72 0.5184 0.25  0  0  1  2  0  0  1  0  0
0 0.72 0.5184 0.35  1  0  0  1  0  0  1  0  0
1 0.72 0.5184 0.15  0  0  1  1  0  0  0  0  0
0 0.72 0.5184 0.35  0  0  1  2  0  0  1  0  0
1 0.72 0.5184 0.25  1  0  0  5  0  2  1  0  0
1 0.72 0.5184 0.90  1  0  0  3  0  0  0  0  0
1 0.72 0.5184 0.25  0  0  1  1  1  1  1  0  0
1 0.72 0.5184 0.45  1  0  0  3  2  1  1  0  0
1 0.72 0.5184 0.15  0  0  1  2  0  0  1  0  0
1 0.72 0.5184 0.55  0  0  1  3  0  1  0  1  0
1 0.72 0.5184 0.25  1  0  0  4  0  3  0  1  0
1 0.72 0.5184 0.35  0  0  1  2  0  0  0  0  0
1 0.72 0.5184 0.25  1  0  0  1  0  1  1  0  0
1 0.72 0.5184 0.25  0  0  1  2  0  2  1  0  0
1 0.72 0.5184 0.25  0  0  1  5  0  1  1  0  0
1 0.72 0.5184 0.35  1  0  0  1  0  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  5  0  0  1  0  0
0 0.72 0.5184 0.25  0  0  1  2  0  1  0  0  0
1 0.72 0.5184 0.25  0  0  0  2  0  0  1  0  0
1 0.72 0.5184 0.25  1  0  0  2  0  0  1  0  0
1 0.72 0.5184 0.25  1  0  0  5 14  2  0  1  0
1 0.72 0.5184 0.25  0  0  1  4  0  3  0  1  0
0 0.72 0.5184 0.35  0  0  1  3  0  1  1  0  0
1 0.72 0.5184 0.25  1  0  0  3  0  6  1  0  0
0 0.72 0.5184 1.10  1  0  0  2 14  0  1  0  0
0 0.72 0.5184 0.25  1  0  0  1  0  0  1  0  0
1 0.72 0.5184 0.55  1  0  0  2  0  0  1  0  0
1 0.72 0.5184 0.45  1  0  0  5  0  3  1  0  0
1 0.72 0.5184 0.25  1  0  0  2  0  4  0  1  0
1 0.72 0.5184 0.25  0  0  1  1  0  1  1  0  0
1 0.72 0.5184 0.65  1  0  0  1  2  0  1  0  0
1 0.72 0.5184 0.25  1  0  0  4 14  0  0  1  0
1 0.72 0.5184 0.25  0  0  1  5  2  7  0  1  0
1 0.72 0.5184 0.25  1  0  0  2  0  0  1  0  0
1 0.72 0.5184 0.25  1  0  0  2  0  0  1  0  0
1 0.72 0.5184 0.45  1  0  0  1  0  2  1  0  0
1 0.72 0.5184 0.35  0  0  1  2  0  5  1  0  0
1 0.72 0.5184 0.25  1  0  0  1  0  2  0  1  0
1 0.72 0.5184 0.35  1  0  0  4  0  1  1  0  0
1 0.72 0.5184 0.25  0  0  1  1  0  0  0  0  0
0 0.72 0.5184 0.25  0  0  1  3  3  1  1  0  0
1 0.72 0.5184 0.75  1  0  0  1  0  0  1  0  0
1 0.72 0.5184 0.55  1  0  0  1  0  2  1  0  0
1 0.72 0.5184 0.55  0  0  1  2  0  3  0  1  0
1 0.72 0.5184 0.25  0  0  1  3  0  0  0  1  0
1 0.72 0.5184 0.25  0  0  1  5  0  6  1  0  0
1 0.72 0.5184 0.15  1  0  0  1  0  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  2  0  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  4  5  1  1  0  0
1 0.72 0.5184 0.25  1  0  0  1  0  0  1  0  0
1 0.72 0.5184 0.25  1  0  0  5  0  5  1  0  0
1 0.72 0.5184 0.25  0  0  1  4  0  0  0  1  0
1 0.72 0.5184 0.25  0  0  1  2 14  1  1  0  0
1 0.72 0.5184 0.35  0  0  1  3  8  2  0  1  0
1 0.72 0.5184 0.25  1  0  0  1  0  0  1  0  0
1 0.72 0.5184 0.25  1  0  0  2  0  1  0  1  0
1 0.72 0.5184 0.55  0  0  1  4  0  1  1  0  0
1 0.72 0.5184 0.25  0  0  1  3  0  0  1  0  0
0 0.72 0.5184 0.25  0  0  1  3  0  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  3  0  0  0  1  0
1 0.72 0.5184 0.25  0  0  1  5 14  1  1  0  0
1 0.72 0.5184 0.35  1  0  0  4  0  7  1  0  0
1 0.72 0.5184 0.06  1  0  0  1  0  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  1  0  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  1  0  0  0  1  0
0 0.72 0.5184 0.25  0  0  1  1  0  4  0  1  0
1 0.72 0.5184 0.25  0  0  1  2  0  1  1  0  0
1 0.72 0.5184 0.25  0  0  1  5  0  6  0  1  0
1 0.72 0.5184 0.35  0  0  1  1  0  0  1  0  0
1 0.72 0.5184 0.35  0  0  1  1  0  0  1  0  0
1 0.72 0.5184 0.55  0  0  1  5  0  2  1  0  0
1 0.72 0.5184 0.75  1  0  0  1  0  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  3  0  0  1  0  0
0 0.72 0.5184 0.25  0  0  1  2  0  1  1  0  0
1 0.72 0.5184 0.25  0  0  1  1  0  0  1  0  0
0 0.72 0.5184 0.35  0  0  1  2  0  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  3  0  0  1  0  0
0 0.72 0.5184 0.25  0  0  1  2  0  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  3  0  0  1  0  0
0 0.72 0.5184 1.50  1  0  0  4 14  2  1  0  0
1 0.72 0.5184 0.25  1  0  0  2  0  2  1  0  0
1 0.72 0.5184 0.25  0  0  1  2  0  1  1  0  0
1 0.72 0.5184 0.25  0  0  1  5  0  1  1  0  0
1 0.72 0.5184 0.25  0  0  1  1 14  0  0  1  0
1 0.72 0.5184 0.35  0  0  1  3  0  1  1  0  0
1 0.72 0.5184 0.25  0  0  1  4  0  2  0  0  0
0 0.72 0.5184 0.25  0  0  1  1  0  0  0  0  0
1 0.72 0.5184 0.65  1  0  0  1 14  0  1  0  0
1 0.72 0.5184 0.45  1  0  0  1 14  4  0  1  0
1 0.72 0.5184 0.25  0  0  1  4  0  2  1  0  0
1 0.72 0.5184 0.25  1  0  0  1  0  0  1  0  0
1 0.72 0.5184 0.90  1  0  0  1  0  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  2 14  5  0  1  0
1 0.72 0.5184 0.25  0  0  1  2  0  2  1  0  0
1 0.72 0.5184 0.25  0  0  1  5  0  3  1  0  0
1 0.72 0.5184 0.25  0  0  1  1  0  0  1  0  0
1 0.72 0.5184 0.55  1  0  0  1  0  0  0  0  0
0 0.72 0.5184 0.25  0  0  1  2  0  0  0  1  0
0 0.72 0.5184 0.35  0  0  1  2  0  1  1  0  0
1 0.72 0.5184 0.25  0  0  1  1  0  0  0  0  0
1 0.72 0.5184 0.55  1  0  0  1  0  1  1  0  0
0 0.72 0.5184 0.45  1  0  0  3  8  1  1  0  0
1 0.72 0.5184 0.25  1  0  0  5  4  3  1  0  0
1 0.72 0.5184 0.25  1  0  0  1  0  0  0  0  0
0 0.72 0.5184 0.25  1  0  0  4  0  3  1  0  0
1 0.72 0.5184 0.25  0  0  1  2  0  0  1  0  0
0 0.72 0.5184 0.25  0  0  1  4  0  4  0  0  0
1 0.72 0.5184 0.25  0  0  1  2  2  5  1  0  0
1 0.72 0.5184 0.25  0  0  1  1 14  7  0  1  0
1 0.72 0.5184 0.25  0  0  1  2  0  0  1  0  0
1 0.72 0.5184 1.50  1  0  0  2  0  0  1  0  0
1 0.72 0.5184 0.55  0  0  1  3 14 10  1  0  0
0 0.72 0.5184 0.25  0  0  1  1  0  0  1  0  0
1 0.72 0.5184 0.55  0  0  1  1 14  1  1  0  0
1 0.72 0.5184 0.25  0  0  1  1  0  1  1  0  0
1 0.72 0.5184 0.25  0  0  1  4  0  1  1  0  0
1 0.72 0.5184 0.25  0  0  1  5 14  9  1  0  0
1 0.72 0.5184 0.25  0  0  1  1  0  2  0  0  0
1 0.72 0.5184 0.25  0  0  1  4  0  1  1  0  0
0 0.72 0.5184 0.35  0  0  1  0  0  0  0  0  0
1 0.72 0.5184 0.35  0  0  1  0  0  0  0  0  0
1 0.72 0.5184 0.25  0  0  1  0  0  0  1  0  0
1 0.72 0.5184 0.35  0  0  1  0  0  2  1  0  0
1 0.72 0.5184 0.35  0  0  1  0  0  0  0  0  0
1 0.72 0.5184 0.45  0  0  1  0  0  0  1  0  0
1 0.72 0.5184 0.25  1  0  0  0  0  0  1  0  0
0 0.72 0.5184 0.25  1  0  0  0  0  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  0  0  0  1  0  0
1 0.72 0.5184 0.25  1  0  0  0  0  0  0  0  0
1 0.72 0.5184 0.25  1  0  0  0  0  0  0  0  0
0 0.72 0.5184 0.25  0  0  1  0  0  1  0  0  0
1 0.72 0.5184 0.25  0  0  1  0  0  0  0  0  0
1 0.72 0.5184 1.30  1  0  0  0  0  0  0  0  0
1 0.72 0.5184 0.35  1  0  0  0  0  1  0  0  0
1 0.72 0.5184 0.35  0  0  1  0  0  0  0  0  0
0 0.72 0.5184 0.25  0  0  1  0  0  0  0  0  0
0 0.72 0.5184 0.25  0  0  1  0  0  0  0  0  0
0 0.72 0.5184 1.10  0  0  1  0  0  0  1  0  0
1 0.72 0.5184 1.10  1  0  0  0  0  0  1  0  0
1 0.72 0.5184 0.45  1  0  0  0  0  0  1  0  0
1 0.72 0.5184 0.35  0  0  0  0  0  0  0  0  0
1 0.72 0.5184 0.55  0  0  0  0 14  3  0  1  0
0 0.72 0.5184 0.15  0  0  1  0  0  1  0  0  0
1 0.72 0.5184 0.25  0  0  1  0  0  0  0  0  0
1 0.72 0.5184 0.35  0  0  1  0  0  0  0  1  0
1 0.72 0.5184 0.25  0  0  1  0  0  0  1  0  0
1 0.72 0.5184 0.75  1  0  0  0  0  0  1  0  0
1 0.72 0.5184 0.25  1  0  0  0  0  0  1  0  0
1 0.72 0.5184 0.90  1  0  0  0  0  1  0  0  0
1 0.72 0.5184 0.25  1  0  0  0  0  0  0  0  0
1 0.72 0.5184 0.45  0  0  1  0  0  0  1  0  0
1 0.72 0.5184 0.25  1  0  0  0  0  0  0  0  0
1 0.72 0.5184 0.25  0  0  1  0  0  0  0  0  0
1 0.72 0.5184 0.15  0  0  1  0  0  0  0  0  0
1 0.72 0.5184 0.45  1  0  0  0  0  0  0  0  0
1 0.72 0.5184 0.35  0  0  1  0  0  0  0  0  0
1 0.72 0.5184 0.25  1  0  0  0  0  3  0  0  0
1 0.72 0.5184 0.25  1  0  0  0  0  0  1  0  0
0 0.72 0.5184 0.25  0  0  1  0  0  0  0  0  0
0 0.72 0.5184 0.25  0  0  1  0  0  1  1  0  0
1 0.72 0.5184 0.25  0  0  1  0  0  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  0  0  0  0  0  0
0 0.72 0.5184 0.35  0  0  1  0  0  0  0  0  0
1 0.72 0.5184 0.25  1  0  0  0  0  0  0  0  0
1 0.72 0.5184 0.25  1  0  0  0  0  0  0  0  0
1 0.72 0.5184 0.75  1  0  0  0  0  0  0  0  0
1 0.72 0.5184 0.35  1  0  0  0  0  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  0  0  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  0  0  0  0  0  0
0 0.72 0.5184 0.25  0  0  1  0  0  0  1  0  0
0 0.72 0.5184 0.15  1  0  0  0  0  0  0  0  0
1 0.72 0.5184 0.45  1  0  0  0  0  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  0  0  4  0  1  0
1 0.72 0.5184 0.15  0  0  1  0  0  0  1  0  0
0 0.72 0.5184 0.35  0  0  1  0  0  1  1  0  0
1 0.72 0.5184 0.35  1  0  0  0  0  0  0  0  0
1 0.72 0.5184 0.35  0  0  1  0  0  0  1  0  0
0 0.72 0.5184 1.50  1  0  0  0  0  0  1  0  0
1 0.72 0.5184 0.15  0  0  1  0  0  0  1  0  0
1 0.72 0.5184 0.45  0  0  1  0  0  0  1  0  0
0 0.72 0.5184 0.25  0  0  1  0  0  0  0  0  0
1 0.72 0.5184 0.25  0  0  1  0  0  2  1  0  0
1 0.72 0.5184 0.25  1  0  0  0  0  0  0  0  0
1 0.72 0.5184 0.25  0  0  1  0  0  0  1  0  0
0 0.72 0.5184 0.45  0  0  1  0  0  1  0  1  0
1 0.72 0.5184 0.25  0  0  1  0  0  0  0  1  0
1 0.72 0.5184 0.35  0  0  1  0  0  0  1  0  0
1 0.19 0.0361 0.45  1  0  0  1  0  0  0  0  0
1 0.19 0.0361 0.45  0  1  0  1  0  0  0  0  0
1 0.19 0.0361 0.55  1  0  0  2  0  0  0  0  0
1 0.19 0.0361 0.45  1  0  0  3  1  5  0  0  0
1 0.19 0.0361 0.00  0  0  0  3  0  0  0  0  0
1 0.19 0.0361 0.65  0  0  0  5  0  1  0  0  0
1 0.19 0.0361 0.35  0  0  0  1  0  3  0  0  0
0 0.19 0.0361 0.55  0  0  0  1  0  6  0  1  0
1 0.19 0.0361 0.45  1  0  0  4  0  6  0  0  0
1 0.19 0.0361 0.45  0  0  0  1  0  4  0  0  0
1 0.19 0.0361 0.06  0  0  0  1  0  6  0  0  0
1 0.19 0.0361 0.55  1  0  0  1  0  1  0  0  0
0 0.19 0.0361 0.65  0  0  0  3  0  0  1  0  0
1 0.19 0.0361 0.45  1  0  0  1  0  3  0  1  0
0 0.19 0.0361 0.90  1  0  0  2  0  2  0  0  0
0 0.19 0.0361 0.55  0  0  0  1  0  0  0  0  0
1 0.19 0.0361 0.15  0  0  0  3  0  1  0  1  0
1 0.19 0.0361 0.65  0  0  0  2  0  6  1  0  0
1 0.19 0.0361 0.25  1  0  0  5  4  6  1  0  0
0 0.19 0.0361 0.01  0  0  1  1  0  0  0  0  0
1 0.19 0.0361 0.55  0  0  0  2  0  2  0  0  0
1 0.19 0.0361 0.25  0  1  0  1  0  6  1  0  0
1 0.19 0.0361 0.90  1  0  0  2  0  3  0  0  0
0 0.19 0.0361 0.45  0  0  0  1  0  0  0  0  0
1 0.19 0.0361 0.45  0  1  0  3  0  4  0  0  0
0 0.19 0.0361 0.15  0  0  0  2  0  5  0  0  0
1 0.19 0.0361 0.45  1  0  0  3  0  2  1  0  0
0 0.19 0.0361 1.10  0  0  0  4  0  9  0  1  0
1 0.19 0.0361 0.45  1  0  0  1  0  2  1  0  0
1 0.19 0.0361 0.45  1  0  0  3  0  4  1  0  0
0 0.19 0.0361 0.25  0  0  0  3  0  1  1  0  0
0 0.19 0.0361 0.65  0  0  0  5  1  1  0  0  0
0 0.19 0.0361 0.75  0  0  0  1  0  0  0  0  0
0 0.19 0.0361 0.35  0  0  0  1  0  0  0  0  0
0 0.19 0.0361 0.06  0  1  0  1  0  2  1  0  0
1 0.19 0.0361 0.25  1  0  0  3  1  1  1  0  0
1 0.19 0.0361 0.55  0  0  0  1  0  0  0  0  0
1 0.19 0.0361 0.45  0  0  0  1  0  2  0  0  0
0 0.19 0.0361 0.45  0  0  0  1  0  0  1  0  0
0 0.19 0.0361 0.90  1  0  0  1  0  2  1  0  0
1 0.19 0.0361 0.25  0  0  0  1  0  2  1  0  0
0 0.19 0.0361 0.55  1  0  0  1  0  0  0  0  0
0 0.19 0.0361 0.25  1  0  0  2  0  3  1  0  0
1 0.19 0.0361 0.15  0  1  0  2  1  9  1  0  0
0 0.19 0.0361 0.25  0  0  0  1  0  0  1  0  0
1 0.19 0.0361 0.55  0  0  0  1  0  0  0  0  0
0 0.19 0.0361 0.35  0  0  0  1  0  1  0  0  0
1 0.19 0.0361 0.55  0  0  0  1  0  0  0  0  0
1 0.19 0.0361 0.65  1  0  0  1  0  0  0  0  0
1 0.19 0.0361 0.65  1  0  0  1  0  0  0  0  0
1 0.19 0.0361 0.45  0  0  0  1  0  0  0  0  0
1 0.19 0.0361 0.75  0  0  0  1  0  2  0  0  0
1 0.19 0.0361 0.45  0  0  0  1  0  0  0  0  0
0 0.19 0.0361 0.55  0  0  0  1  0  0  0  0  0
0 0.19 0.0361 0.55  0  0  0  1  2  0  0  0  0
1 0.19 0.0361 0.45  1  0  0  1  0  0  0  0  0
0 0.19 0.0361 0.35  0  0  0  3  7  4  0  1  0
0 0.19 0.0361 0.45  1  0  0  1  0  0  0  0  0
1 0.19 0.0361 0.25  1  0  0  1  0  0  1  0  0
0 0.19 0.0361 0.45  1  0  0  1  0  1  1  0  0
0 0.19 0.0361 0.75  0  0  0  1  0  0  0  0  0
1 0.19 0.0361 0.55  1  0  0  2  0  0  0  0  0
0 0.19 0.0361 0.25  0  1  0  1  0  0  0  0  0
1 0.19 0.0361 0.45  0  0  0  1  0  0  0  0  0
1 0.19 0.0361 0.55  0  0  0  1  0  0  1  0  0
1 0.19 0.0361 0.55  0  0  0  1  0  0  0  0  0
1 0.19 0.0361 0.25  0  1  0  2  0  0  0  0  0
0 0.19 0.0361 0.65  1  0  0  1  0  0  0  0  0
1 0.19 0.0361 0.45  0  0  0  3  0  0  1  0  0
1 0.19 0.0361 0.55  0  0  0  2  0  3  0  1  0
0 0.19 0.0361 0.25  0  0  0  3  0  3  0  0  0
1 0.19 0.0361 0.06  0  0  0  4  0  5  1  0  0
0 0.19 0.0361 0.55  0  0  0  2  0  0  0  0  0
0 0.19 0.0361 0.45  1  0  0  3  0  1  0  1  0
0 0.19 0.0361 0.35  0  0  0  3  0  2  0  0  0
1 0.19 0.0361 0.55  0  0  0  1  0  0  0  0  0
1 0.19 0.0361 0.45  1  0  0  1  0  0  0  0  0
0 0.19 0.0361 0.25  0  0  0  1  0  2  0  0  0
0 0.19 0.0361 0.45  0  0  0  2  0  0  0  0  0
1 0.19 0.0361 0.15  0  0  0  5  0  3  1  0  0
1 0.19 0.0361 0.55  1  0  0  1  0  0  0  0  0
0 0.19 0.0361 0.55  0  0  0  1  0  0  0  0  0
1 0.19 0.0361 0.35  0  0  0  1  0  2  0  0  0
1 0.19 0.0361 0.55  1  0  0  1  0  0  1  0  0
1 0.19 0.0361 0.65  0  0  0  1  0  0  1  0  0
1 0.19 0.0361 0.45  0  0  0  1  0  0  0  0  0
1 0.19 0.0361 0.65  0  0  0  1  0  1  0  0  0
0 0.19 0.0361 0.35  1  0  0  1  1  0  0  0  0
1 0.19 0.0361 0.55  1  0  0  1  0  0  1  0  0
0 0.19 0.0361 0.35  0  0  0  1  0  1  1  0  0
1 0.19 0.0361 0.35  0  0  0  2  0  1  0  0  0
0 0.19 0.0361 0.15  1  0  0  2  0  1  0  0  0
0 0.19 0.0361 0.45  0  0  0  1  0  3  0  0  0
0 0.19 0.0361 0.25  0  1  0  2  0  0  0  0  0
1 0.19 0.0361 0.90  1  0  0  1  0  1  0  0  0
1 0.19 0.0361 0.55  0  0  0  2  0  1  1  0  0
1 0.19 0.0361 0.55  0  0  0  2  0  1  0  0  0
0 0.19 0.0361 0.15  0  1  0  1  0  0  0  1  0
0 0.19 0.0361 0.55  1  0  0  3  0  0  1  0  0
1 0.19 0.0361 0.35  1  0  0  2  0  0  0  0  0
0 0.19 0.0361 1.50  1  0  0  1  0  0  0  0  0
1 0.19 0.0361 0.06  0  1  0  1  0  2  0  1  0
0 0.19 0.0361 0.45  0  0  0  3  1  1  0  0  0
1 0.19 0.0361 0.45  0  0  0  4  0  3  1  0  0
0 0.19 0.0361 0.45  0  0  0  1  0  5  1  0  0
0 0.19 0.0361 0.90  1  0  0  2  0  0  1  0  0
1 0.19 0.0361 0.45  1  0  0  1  0  0  1  0  0
1 0.19 0.0361 0.75  1  0  0  0  0  0  0  0  0
1 0.19 0.0361 0.45  1  0  0  0  0  0  1  0  0
0 0.19 0.0361 0.00  1  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.75  1  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.90  0  0  0  0  0  1  1  0  0
0 0.19 0.0361 0.65  0  0  0  0  0  0  0  0  0
1 0.19 0.0361 0.35  1  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.06  0  1  0  0  0  3  0  0  0
0 0.19 0.0361 0.65  0  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.25  0  1  0  0  0  1  0  0  0
0 0.19 0.0361 0.55  1  0  0  0  0  1  0  0  0
0 0.19 0.0361 0.35  0  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.55  0  0  0  0  0  1  0  0  0
1 0.19 0.0361 0.45  1  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.06  0  1  0  0  0  1  0  0  0
0 0.19 0.0361 0.65  0  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.45  0  0  0  0  0  0  0  0  0
1 0.19 0.0361 0.00  1  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.90  0  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.45  0  0  0  0  0  1  0  0  0
1 0.19 0.0361 0.00  1  0  0  0  0  1  0  0  0
0 0.19 0.0361 0.55  1  0  0  0  0  1  0  0  0
0 0.19 0.0361 0.25  1  0  0  0  0  0  0  0  0
1 0.19 0.0361 0.55  1  0  0  0  0  0  0  0  0
1 0.19 0.0361 0.45  0  0  0  0  0  1  0  0  0
0 0.19 0.0361 1.10  0  0  0  0  0  2  0  0  0
0 0.19 0.0361 0.25  0  0  0  0  0  0  0  0  0
1 0.19 0.0361 0.01  0  0  0  0  0  0  0  1  0
1 0.19 0.0361 0.45  0  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.55  0  0  0  0  0  0  0  0  0
1 0.19 0.0361 0.55  0  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.35  0  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.45  1  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.06  0  1  0  0  0  1  0  0  0
1 0.19 0.0361 0.15  1  0  0  0  0  0  0  0  0
1 0.19 0.0361 0.55  0  0  0  0  0  0  0  0  0
1 0.19 0.0361 1.10  0  0  0  0  0  5  0  0  0
1 0.19 0.0361 0.65  0  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.90  0  0  1  0  0  1  0  0  0
1 0.19 0.0361 0.35  0  0  0  0  0  0  0  0  0
1 0.19 0.0361 0.15  1  0  0  0  0  0  0  0  0
1 0.19 0.0361 0.55  1  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.25  1  0  0  0  0  0  1  0  0
0 0.19 0.0361 0.55  1  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.75  0  1  0  0  0  1  0  0  0
1 0.19 0.0361 0.15  1  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.65  1  0  0  0  0  0  1  0  0
0 0.19 0.0361 0.25  0  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.15  0  0  0  0  0  0  1  0  0
1 0.19 0.0361 0.45  0  0  0  0  0  0  1  0  0
1 0.19 0.0361 0.25  0  0  0  0  0  1  0  0  0
0 0.19 0.0361 0.75  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.75  1  0  0  1  1  1  0  0  0
1 0.22 0.0484 0.90  1  0  0  2  1  2  0  0  0
0 0.22 0.0484 0.90  1  0  0  3  1  0  0  0  0
0 0.22 0.0484 0.75  0  0  0  1  0  0  1  0  0
0 0.22 0.0484 0.55  0  0  0  1  2  0  0  0  0
1 0.22 0.0484 0.35  0  0  0  1  2  2  0  0  0
0 0.22 0.0484 0.25  0  1  0  3  0  1  1  0  0
0 0.22 0.0484 0.90  1  0  0  1  0  1  0  0  0
1 0.22 0.0484 1.10  1  0  0  1  0  2  1  0  0
0 0.22 0.0484 0.65  1  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.55  1  0  0  1  0  0  1  0  0
1 0.22 0.0484 0.25  0  0  0  3  1  0  1  0  0
0 0.22 0.0484 0.55  1  0  0  2  0  2  1  0  0
1 0.22 0.0484 0.15  1  0  0  2  0  1  0  0  0
1 0.22 0.0484 0.75  1  0  0  1  0  0  1  0  0
1 0.22 0.0484 0.00  1  0  0  2  0  7  0  0  0
1 0.22 0.0484 0.75  1  0  0  1  1  4  0  1  0
1 0.22 0.0484 0.75  1  0  0  3  0  0  1  0  0
0 0.22 0.0484 1.10  1  0  0  1  0  1  0  0  0
0 0.22 0.0484 0.25  0  0  0  1  0  3  0  0  0
0 0.22 0.0484 0.65  1  0  0  1  0  0  0  0  0
1 0.22 0.0484 0.90  0  0  0  4  1 12  1  0  0
1 0.22 0.0484 0.55  0  0  0  2  0  2  1  0  0
0 0.22 0.0484 0.45  1  0  0  3  0  8  0  0  0
0 0.22 0.0484 0.45  1  0  0  3  0  8  0  0  0
1 0.22 0.0484 0.75  0  0  0  1 14  8  1  0  0
1 0.22 0.0484 0.55  0  0  0  4  0  4  1  0  0
0 0.22 0.0484 0.45  0  0  0  3  0  3  0  0  0
1 0.22 0.0484 0.65  1  0  0  3  0  3  1  0  0
0 0.22 0.0484 0.45  0  1  0  4  0  4  0  1  0
0 0.22 0.0484 0.55  0  1  0  1  0  2  0  0  0
0 0.22 0.0484 0.75  1  0  0  2  0  6  1  0  0
1 0.22 0.0484 0.75  1  0  0  3  0  2  0  0  0
0 0.22 0.0484 1.30  0  0  0  2  0  1  0  0  0
1 0.22 0.0484 0.55  1  0  0  3  1  5  0  1  0
1 0.22 0.0484 0.55  0  0  0  5  0  8  1  0  0
1 0.22 0.0484 0.75  1  0  0  1  0  1  1  0  0
1 0.22 0.0484 0.55  0  0  0  2  0  0  0  0  0
1 0.22 0.0484 0.65  0  0  0  4  1 10  0  1  0
0 0.22 0.0484 0.90  1  0  0  2  0  9  1  0  0
0 0.22 0.0484 1.10  1  0  0  1  0  7  0  0  0
1 0.22 0.0484 0.75  0  0  0  5  0  3  0  0  0
0 0.22 0.0484 0.65  0  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.45  0  0  0  1  0  3  0  0  0
0 0.22 0.0484 0.90  0  0  0  1  0  1  0  0  0
0 0.22 0.0484 0.25  0  1  0  4  0  3  0  1  0
0 0.22 0.0484 0.25  1  0  0  1  0  2  1  0  0
0 0.22 0.0484 0.90  0  0  0  3  0  2  0  0  0
1 0.22 0.0484 0.55  1  0  0  2  0  0  1  0  0
0 0.22 0.0484 0.35  1  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.45  0  0  0  2  0 12  0  0  0
0 0.22 0.0484 0.75  0  0  0  1  1  0  1  0  0
0 0.22 0.0484 0.90  0  0  0  4  0  1  0  1  0
1 0.22 0.0484 0.65  1  0  0  2  0  0  1  0  0
0 0.22 0.0484 0.25  0  1  0  2  0  5  0  0  0
0 0.22 0.0484 0.15  0  0  0  3  0  0  1  0  0
1 0.22 0.0484 0.75  1  0  0  4  0  3  1  0  0
0 0.22 0.0484 0.75  1  0  0  3  0  3  1  0  0
1 0.22 0.0484 0.90  1  0  0  2  0  0  1  0  0
1 0.22 0.0484 0.65  0  0  0  1  0  0  1  0  0
0 0.22 0.0484 0.90  0  1  0  2  1  1  0  0  0
0 0.22 0.0484 0.55  0  1  0  2  0  1  0  0  0
1 0.22 0.0484 0.65  1  0  0  2  0  1  0  0  0
0 0.22 0.0484 0.45  0  0  0  1  0  2  0  0  0
1 0.22 0.0484 0.65  1  0  0  1  0  0  0  0  0
1 0.22 0.0484 0.15  0  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.90  0  0  0  1  0  0  0  0  0
1 0.22 0.0484 0.65  0  0  0  2  0  0  0  0  0
0 0.22 0.0484 0.65  0  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.90  1  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.01  0  1  0  2  0  2  0  0  0
0 0.22 0.0484 0.90  1  0  0  1  0  0  1  0  0
1 0.22 0.0484 0.75  1  0  0  1  1  0  0  0  0
1 0.22 0.0484 1.10  1  0  0  1  0  0  1  0  0
0 0.22 0.0484 0.35  0  1  0  1  0  0  0  0  0
0 0.22 0.0484 0.55  1  0  0  1  0  0  1  0  0
0 0.22 0.0484 0.75  0  0  0  1  0  1  1  0  0
0 0.22 0.0484 0.90  0  0  0  1  0  1  0  0  0
0 0.22 0.0484 0.75  1  0  0  4  0  3  1  0  0
0 0.22 0.0484 0.65  1  0  0  1  0  0  1  0  0
0 0.22 0.0484 0.45  0  1  0  3  3  2  0  1  0
1 0.22 0.0484 0.25  0  0  0  2  0  0  1  0  0
0 0.22 0.0484 0.00  0  0  0  1  0  1  1  0  0
0 0.22 0.0484 0.55  0  0  0  1  0  3  0  0  0
0 0.22 0.0484 0.65  0  1  0  1  2  1  0  1  0
0 0.22 0.0484 0.25  0  1  0  1  3  5  1  0  0
1 0.22 0.0484 0.25  1  0  0  2  0  0  1  0  0
0 0.22 0.0484 0.45  1  0  0  2  0  0  1  0  0
1 0.22 0.0484 0.90  1  0  0  2  0  0  1  0  0
0 0.22 0.0484 0.55  1  0  0  2  0  0  1  0  0
0 0.22 0.0484 0.65  0  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.75  1  0  0  1  1  0  0  1  0
0 0.22 0.0484 0.45  0  0  0  3  0  5  1  0  0
0 0.22 0.0484 0.55  1  0  0  2  0  2  0  1  0
0 0.22 0.0484 0.15  0  0  0  1  0  0  0  0  0
1 0.22 0.0484 0.35  0  1  0  1  0  0  0  0  0
1 0.22 0.0484 0.65  1  0  0  1  0  1  0  0  0
0 0.22 0.0484 0.90  1  0  0  2  0  1  1  0  0
1 0.22 0.0484 0.00  0  1  0  1  0  0  1  0  0
1 0.22 0.0484 0.65  0  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.35  1  0  0  1  1  0  0  0  0
1 0.22 0.0484 0.15  0  0  0  2  1  2  1  0  0
1 0.22 0.0484 0.75  1  0  0  1  0  1  1  0  0
1 0.22 0.0484 1.10  1  0  0  2  0  0  0  0  0
1 0.22 0.0484 0.75  1  0  0  2  0  0  1  0  0
0 0.22 0.0484 0.90  0  0  0  3  2  6  1  0  0
1 0.22 0.0484 0.35  0  0  0  2  1  1  0  0  0
1 0.22 0.0484 0.25  1  0  0  3  0  4  1  0  0
0 0.22 0.0484 0.90  0  0  0  1  0  1  1  0  0
1 0.22 0.0484 0.45  0  0  0  2  0  0  0  1  0
1 0.22 0.0484 0.65  1  0  0  1  0  0  1  0  0
1 0.22 0.0484 0.25  0  0  0  3  0  1  1  0  0
0 0.22 0.0484 0.25  1  0  0  3  0  2  0  0  0
1 0.22 0.0484 0.90  0  0  0  2  0  6  0  0  0
0 0.22 0.0484 0.90  1  0  0  3  0  1  1  0  0
0 0.22 0.0484 1.50  0  0  0  1  0  0  0  0  0
1 0.22 0.0484 1.10  0  0  0  1  0  0  0  0  0
1 0.22 0.0484 0.65  0  0  0  3  0  1  1  0  0
0 0.22 0.0484 1.10  1  0  0  1  0  3  0  0  0
0 0.22 0.0484 0.75  0  0  0  1  0  1  1  0  0
1 0.22 0.0484 0.90  1  0  0  1  0  4  0  0  0
0 0.22 0.0484 1.10  1  0  0  3  0  0  0  0  0
0 0.22 0.0484 1.10  1  0  0  2  0  0  1  0  0
1 0.22 0.0484 0.75  0  0  0  2  0  3  0  0  0
1 0.22 0.0484 0.90  1  0  0  2  0  0  0  1  0
1 0.22 0.0484 0.75  1  0  0  1  2  0  1  0  0
0 0.22 0.0484 1.30  0  0  0  2  0  3  0  1  0
1 0.22 0.0484 0.00  1  0  0  1 14  0  1  0  0
0 0.22 0.0484 0.90  1  0  0  3  0  1  1  0  0
0 0.22 0.0484 0.90  1  0  0  1  0  1  0  0  0
0 0.22 0.0484 0.55  1  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.55  0  0  0  3  0  0  0  0  0
1 0.22 0.0484 1.10  1  0  0  3  0  4  0  0  0
1 0.22 0.0484 0.65  1  0  0  3  0  1  0  1  0
1 0.22 0.0484 0.55  0  0  0  4  0  1  1  0  0
0 0.22 0.0484 0.15  0  1  0  3  0  4  1  0  0
0 0.22 0.0484 1.10  0  0  0  3  0  0  0  1  0
0 0.22 0.0484 0.65  0  0  0  2  0  2  0  0  0
1 0.22 0.0484 1.10  0  0  0  1 14  1  0  0  0
0 0.22 0.0484 0.90  1  0  0  2  0  1  1  0  0
0 0.22 0.0484 0.55  0  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.15  0  0  0  1  1  1  1  0  0
0 0.22 0.0484 1.10  1  0  0  2  0  0  0  0  0
0 0.22 0.0484 0.90  0  0  0  1  0  1  0  0  0
1 0.22 0.0484 0.45  0  0  0  0  0  4  0  0  0
1 0.22 0.0484 0.65  0  0  0  0  0  1  0  0  0
1 0.22 0.0484 0.55  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.35  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 1.30  1  0  0  0  0  0  1  0  0
0 0.22 0.0484 0.90  1  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.90  1  0  0  0  0  2  0  0  0
0 0.22 0.0484 0.90  1  0  0  0  0  0  1  0  0
1 0.22 0.0484 0.15  1  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.55  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.65  1  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.75  1  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.15  0  1  0  0  0  4  0  0  0
0 0.22 0.0484 0.90  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.25  0  0  0  0  0  4  1  0  0
1 0.22 0.0484 1.10  1  0  0  0  0  1  0  0  0
0 0.22 0.0484 0.65  1  0  0  0  0  1  0  0  0
0 0.22 0.0484 0.75  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.55  1  0  0  0  0  2  1  0  0
0 0.22 0.0484 0.65  1  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.75  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 1.10  1  0  0  0  0  2  0  0  0
1 0.22 0.0484 0.65  1  0  0  0  0  0  1  0  0
0 0.22 0.0484 0.90  1  0  0  0  0  1  0  0  0
0 0.22 0.0484 0.55  0  0  0  0  0  2  0  0  0
1 0.22 0.0484 0.65  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.90  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.90  1  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.35  0  0  0  0  0  2  0  0  0
1 0.22 0.0484 0.65  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.55  1  0  0  0  0  0  0  1  0
0 0.22 0.0484 0.90  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.35  0  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.65  1  0  0  0  0  3  0  0  0
0 0.22 0.0484 0.90  0  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.55  1  0  0  0  0  3  0  0  0
1 0.22 0.0484 1.10  1  0  0  0  0  0  0  1  0
0 0.22 0.0484 0.90  0  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.55  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 1.10  1  0  0  0  0  0  1  0  0
0 0.22 0.0484 0.90  0  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.65  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.25  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.65  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.35  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.55  0  0  0  0  0  0  1  0  0
1 0.22 0.0484 0.25  0  1  0  0  0  0  0  0  0
0 0.22 0.0484 0.55  1  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.55  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.75  1  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.65  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.90  1  0  0  0  0  0  1  0  0
0 0.22 0.0484 0.75  1  0  0  0  0  0  1  0  0
0 0.22 0.0484 0.75  0  0  0  0  0  1  0  0  0
1 0.22 0.0484 0.65  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.65  1  0  0  0  0  0  1  0  0
0 0.22 0.0484 0.75  0  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.75  1  0  0  0  0  0  1  0  0
0 0.22 0.0484 0.75  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.55  0  0  0  0  0  1  0  0  0
0 0.22 0.0484 1.30  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.55  0  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.75  1  0  0  0  0  0  1  0  0
1 0.22 0.0484 0.65  1  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.55  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 1.10  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.75  0  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.65  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.75  0  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.01  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.75  0  0  0  0  0  2  0  1  0
0 0.22 0.0484 0.90  0  0  0  0  0  0  1  0  0
1 0.22 0.0484 0.75  1  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.90  1  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.65  0  0  0  0  0  5  0  0  0
1 0.22 0.0484 0.90  1  0  0  0  0  0  0  0  0
0 0.27 0.0729 0.90  1  0  0  1  0  0  0  0  0
1 0.27 0.0729 0.55  0  0  0  1  2  0  0  0  0
0 0.27 0.0729 0.90  0  0  0  1  0  0  0  0  0
0 0.27 0.0729 1.50  1  0  0  2  0  0  1  0  0
0 0.27 0.0729 1.50  0  0  0  3  1  0  1  0  0
0 0.27 0.0729 0.90  0  0  0  1  0  1  0  0  0
0 0.27 0.0729 0.45  0  0  0  1  0  1  0  0  0
1 0.27 0.0729 0.90  0  0  0  1  0  6  1  0  0
1 0.27 0.0729 0.75  0  0  0  3  0  0  1  0  0
0 0.27 0.0729 0.90  0  0  0  2  0  0  1  0  0
0 0.27 0.0729 0.90  0  0  0  2  0  3  0  1  0
1 0.27 0.0729 0.90  1  0  0  3  0  4  1  0  0
0 0.27 0.0729 0.90  1  0  0  2  2  2  0  0  0
1 0.27 0.0729 1.10  1  0  0  3  0  4  0  0  0
1 0.27 0.0729 0.90  0  0  0  1  0  0  0  0  0
1 0.27 0.0729 0.35  1  0  0  3  0  0  1  0  0
1 0.27 0.0729 0.35  1  0  0  1  0  0  0  0  0
0 0.27 0.0729 0.35  0  0  0  1  0  8  1  0  0
0 0.27 0.0729 0.75  0  0  0  3  0  5  0  0  0
0 0.27 0.0729 0.25  0  1  0  3  0  1  1  0  0
0 0.27 0.0729 0.65  0  0  0  1  0  0  1  0  0
1 0.27 0.0729 0.75  0  0  0  2  0  0  1  0  0
0 0.27 0.0729 0.75  0  0  0  1  0  0  0  1  0
0 0.27 0.0729 1.10  0  0  0  2  0  3  0  0  0
1 0.27 0.0729 0.90  0  0  0  1  0  0  0  0  0
0 0.27 0.0729 0.55  0  0  0  1  0  0  0  0  0
0 0.27 0.0729 0.45  0  1  0  2  0  1  1  0  0
1 0.27 0.0729 1.30  0  0  0  1  0  0  1  0  0
1 0.27 0.0729 0.75  1  0  0  1  0  0  0  0  0
0 0.27 0.0729 0.75  1  0  0  1  0  1  0  0  0
0 0.27 0.0729 0.75  1  0  0  2  0  4  0  0  0
0 0.27 0.0729 0.65  1  0  0  2  0  0  1  0  0
0 0.27 0.0729 1.50  1  0  0  1  0  1  1  0  0
0 0.27 0.0729 0.35  0  0  0  4  0  1  1  0  0
1 0.27 0.0729 1.10  1  0  0  1  0  0  1  0  0
0 0.27 0.0729 0.90  0  0  0  3  0  1  1  0  0
0 0.27 0.0729 0.65  0  0  0  1  0  1  0  0  0
0 0.27 0.0729 0.90  0  0  0  1  0  0  0  1  0
0 0.27 0.0729 1.10  1  0  0  2  0 11  0  0  0
0 0.27 0.0729 0.65  1  0  0  1  0  0  0  0  0
0 0.27 0.0729 0.01  0  1  0  2  1  8  1  0  0
0 0.27 0.0729 0.90  0  0  0  3  0  1  1  0  0
0 0.27 0.0729 0.75  0  0  0  1  0  0  1  0  0
0 0.27 0.0729 1.10  1  0  0  1  0  4  0  1  0
1 0.27 0.0729 0.90  1  0  0  1  0  0  0  0  0
0 0.27 0.0729 1.10  1  0  0  2  0  0  1  0  0
0 0.27 0.0729 1.50  1  0  0  3  0  2  0  1  0
0 0.27 0.0729 0.15  1  0  0  1  0  1  0  0  0
0 0.27 0.0729 1.50  1  0  0  1  0  1  0  1  0
1 0.27 0.0729 0.90  1  0  0  2  6  0  1  0  0
1 0.27 0.0729 1.10  1  0  0  2  1  0  1  0  0
0 0.27 0.0729 1.30  0  0  0  1  0  0  0  1  0
1 0.27 0.0729 0.90  0  0  0  1  0  0  0  0  0
1 0.27 0.0729 1.50  1  0  0  5  0  2  0  1  0
0 0.27 0.0729 1.10  1  0  0  1  0  0  0  0  0
0 0.27 0.0729 0.35  0  0  0  1  1  4  0  0  0
1 0.27 0.0729 0.01  0  1  0  5  1  2  0  1  0
1 0.27 0.0729 0.25  0  0  1  2  0  1  1  0  0
0 0.27 0.0729 1.10  1  0  0  1  0  0  0  0  0
0 0.27 0.0729 1.50  1  0  0  1  0  0  0  0  0
0 0.27 0.0729 0.90  0  0  0  2  0  0  0  1  0
0 0.27 0.0729 0.90  0  0  0  1  0  0  1  0  0
0 0.27 0.0729 1.10  0  0  0  3  0  3  1  0  0
0 0.27 0.0729 1.10  0  0  0  0  0  0  0  0  0
1 0.27 0.0729 1.30  1  0  0  0  0  0  0  0  0
1 0.27 0.0729 0.45  0  0  0  0  0  0  0  0  0
0 0.27 0.0729 1.50  0  0  0  0  0  0  0  0  0
0 0.27 0.0729 0.90  1  0  0  0  0  0  0  0  0
0 0.27 0.0729 0.55  0  0  0  0  0  0  0  0  0
0 0.27 0.0729 0.65  1  0  0  0  0  1  0  1  0
1 0.27 0.0729 0.15  0  1  0  0  0  0  0  0  0
1 0.27 0.0729 0.75  1  0  0  0  0  0  1  0  0
0 0.27 0.0729 0.90  0  0  0  0  0  0  0  0  0
0 0.27 0.0729 0.90  0  0  0  0  0  0  0  0  0
0 0.27 0.0729 1.30  1  0  0  0  0  0  0  0  0
1 0.27 0.0729 0.75  1  0  0  0  0  0  0  0  0
0 0.27 0.0729 1.50  1  0  0  0  0  0  0  0  0
1 0.27 0.0729 0.25  1  0  0  0  0  0  0  1  0
0 0.27 0.0729 0.90  0  0  0  0  0  4  0  0  0
0 0.27 0.0729 1.30  1  0  0  0  0  0  0  0  0
0 0.27 0.0729 0.55  0  0  0  0  0  0  0  0  0
1 0.27 0.0729 0.65  1  0  0  0  0  0  0  0  0
0 0.27 0.0729 1.30  1  0  0  0  0  3  0  0  0
0 0.27 0.0729 1.10  0  0  0  0  0  1  0  0  0
1 0.27 0.0729 0.90  1  0  0  0  0  1  1  0  0
1 0.27 0.0729 0.90  1  0  0  0  0  0  1  0  0
1 0.27 0.0729 0.65  0  0  0  0  0  0  0  0  0
0 0.27 0.0729 0.65  1  0  0  0  0  0  1  0  0
1 0.27 0.0729 0.90  1  0  0  0  0  0  0  0  0
1 0.27 0.0729 0.90  1  0  0  0  0  0  0  0  0
0 0.27 0.0729 1.50  1  0  0  0  0  1  0  0  0
0 0.27 0.0729 1.10  0  0  0  0  0  0  0  0  0
1 0.32 0.1024 0.90  1  0  0  1  0  0  0  0  0
0 0.32 0.1024 0.90  0  0  0  1  0  5  1  0  0
0 0.32 0.1024 0.65  0  0  0  2  0  3  1  0  0
0 0.32 0.1024 0.90  0  0  0  2  0  4  0  0  0
0 0.32 0.1024 1.50  0  0  0  4  0  3  1  0  0
0 0.32 0.1024 1.50  1  0  0  2  0  0  0  0  0
0 0.32 0.1024 1.10  0  0  0  2  0  9  0  0  0
0 0.32 0.1024 1.10  1  0  0  4  0  8  0  1  0
0 0.32 0.1024 0.55  0  0  0  2  0  5  0  1  0
0 0.32 0.1024 1.30  1  0  0  1  0  1  0  0  0
0 0.32 0.1024 1.10  0  1  0  2  0  9  1  0  0
1 0.32 0.1024 1.50  1  0  0  1  0  0  0  0  0
1 0.32 0.1024 0.90  1  0  0  1  0  0  1  0  0
0 0.32 0.1024 0.65  0  0  0  1  0  0  0  0  0
0 0.32 0.1024 1.10  1  0  0  1  0  0  0  0  0
0 0.32 0.1024 1.50  1  0  0  1  1  3  1  0  0
0 0.32 0.1024 0.65  1  0  0  5  0  5  1  0  0
1 0.32 0.1024 0.25  0  1  0  4  0  8  1  0  0
0 0.32 0.1024 0.90  1  0  0  2  0  0  1  0  0
1 0.32 0.1024 0.75  1  0  0  1  0  0  0  0  0
0 0.32 0.1024 1.10  0  0  0  1  0  0  0  0  0
0 0.32 0.1024 1.30  1  0  0  1  0  0  0  0  0
1 0.32 0.1024 1.50  1  0  0  1  0  0  0  0  0
1 0.32 0.1024 1.10  1  0  0  2  0  2  0  0  0
1 0.32 0.1024 0.55  0  0  0  1  0  0  1  0  0
0 0.32 0.1024 1.30  1  0  0  1  0  2  1  0  0
0 0.32 0.1024 0.45  1  0  0  4  0  0  1  0  0
0 0.32 0.1024 0.55  1  0  0  3  0  0  0  0  0
1 0.32 0.1024 1.50  1  0  0  1  0  2  0  0  0
0 0.32 0.1024 0.65  1  0  0  1  0  1  1  0  0
0 0.32 0.1024 1.50  1  0  0  2  0  0  1  0  0
0 0.32 0.1024 1.10  0  0  0  0  0  0  0  0  0
1 0.32 0.1024 0.90  0  0  0  0  0  0  0  0  0
0 0.32 0.1024 0.90  0  0  0  0  0  0  0  0  0
0 0.32 0.1024 1.10  1  0  0  0  0  0  0  0  0
0 0.32 0.1024 0.90  0  0  0  0  0  0  0  0  0
0 0.32 0.1024 0.90  0  0  0  0  0  0  0  0  0
0 0.32 0.1024 1.10  1  0  0  0  0  0  0  0  0
0 0.32 0.1024 0.90  0  0  0  0  0  0  1  0  0
0 0.32 0.1024 1.50  0  0  0  0  0  0  1  0  0
0 0.32 0.1024 0.35  0  0  0  0  0  3  1  0  0
0 0.32 0.1024 1.50  0  0  0  0  0  4  0  0  0
0 0.32 0.1024 1.10  1  0  0  0  0  0  1  0  0
0 0.32 0.1024 0.25  0  0  0  0  0  0  0  0  0
0 0.32 0.1024 0.65  1  0  0  0  0  0  0  1  0
1 0.32 0.1024 1.30  0  0  0  0  0  1  0  0  0
1 0.32 0.1024 0.75  0  0  0  0  0  0  0  0  0
0 0.32 0.1024 1.10  0  0  0  0  0  0  1  0  0
0 0.37 0.1369 1.50  1  0  0  1  0  8  0  0  0
0 0.37 0.1369 0.25  0  0  0  1  0  1  0  0  0
1 0.37 0.1369 0.25  0  0  1  1 14  4  0  1  0
0 0.37 0.1369 0.65  1  0  0  1  0  0  0  0  0
1 0.37 0.1369 0.65  1  0  0  1  0  0  0  0  0
0 0.37 0.1369 0.90  1  0  0  3  2  4  0  1  0
0 0.37 0.1369 0.15  0  0  0  5 14  2  0  1  0
1 0.37 0.1369 0.90  1  0  0  1  0  0  0  1  0
1 0.37 0.1369 0.75  0  0  0  1  7  2  1  0  0
1 0.37 0.1369 0.90  0  0  0  1  0  0  1  0  0
0 0.37 0.1369 1.50  1  0  0  1  0  0  1  0  0
0 0.37 0.1369 1.50  1  0  0  1  0  0  1  0  0
0 0.37 0.1369 0.90  0  0  0  1  3  1  1  0  0
0 0.37 0.1369 1.50  0  0  0  1  0  1  1  0  0
0 0.37 0.1369 0.45  1  0  0  1  0  4  0  1  0
1 0.37 0.1369 0.90  0  0  0  1  0  0  0  0  0
0 0.37 0.1369 0.75  1  0  0  1  0  0  0  0  0
0 0.37 0.1369 0.35  1  0  0  0  0  0  0  0  0
1 0.37 0.1369 0.55  1  0  0  0  0  0  0  1  0
0 0.37 0.1369 1.10  1  0  0  0  0  0  1  0  0
1 0.37 0.1369 0.55  0  0  0  0  0  0  0  0  0
0 0.37 0.1369 1.50  1  0  0  0  0  0  0  0  0
0 0.37 0.1369 0.90  1  0  0  0  0  0  0  0  0
1 0.42 0.1764 1.50  1  0  0  3  0  0  1  0  0
0 0.42 0.1764 0.90  1  0  0  2  0  9  1  0  0
0 0.42 0.1764 0.75  0  1  0  2  0  0  1  0  0
0 0.42 0.1764 1.50  1  0  0  1  0  0  1  0  0
0 0.42 0.1764 0.35  1  0  0  2  0  0  0  0  0
0 0.42 0.1764 1.50  1  0  0  2  0  0  0  1  0
0 0.42 0.1764 1.30  1  0  0  1  0  0  1  0  0
0 0.42 0.1764 0.75  0  0  0  1  1  0  0  0  0
0 0.42 0.1764 1.10  1  0  0  1  0  2  0  1  0
0 0.42 0.1764 1.50  1  0  0  4  0  3  1  0  0
1 0.42 0.1764 0.65  1  0  0  1  0  0  0  0  0
1 0.42 0.1764 0.35  0  0  1  1  0  4  0  1  0
0 0.42 0.1764 1.10  0  0  0  3  0  0  0  1  0
0 0.42 0.1764 0.75  1  0  0  0  0  1  0  0  0
1 0.42 0.1764 0.45  1  0  0  0  0  0  0  1  0
1 0.42 0.1764 0.90  1  0  0  0  0  0  0  0  0
0 0.42 0.1764 1.50  1  0  0  0  0  0  0  0  0
0 0.42 0.1764 0.90  0  0  0  0  0  1  0  0  0
0 0.42 0.1764 1.10  0  0  0  0  0  0  1  0  0
1 0.42 0.1764 0.65  1  0  0  0  0  0  1  0  0
0 0.42 0.1764 0.15  1  0  0  0  0  0  0  0  0
0 0.42 0.1764 0.90  0  1  0  0  0  0  0  0  0
0 0.42 0.1764 0.90  0  0  0  0  0  0  1  0  0
1 0.47 0.2209 0.55  0  0  1  5  0  2  1  0  0
0 0.47 0.2209 0.65  1  0  0  3  0  0  0  0  0
0 0.47 0.2209 1.30  1  0  0  1  0  0  0  0  0
1 0.47 0.2209 0.55  1  0  0  4  0  2  1  0  0
1 0.47 0.2209 0.25  1  0  0  1  0  4  1  0  0
0 0.47 0.2209 0.35  0  1  0  1  0  0  1  0  0
1 0.47 0.2209 0.35  1  0  0  1  0  0  0  0  0
1 0.47 0.2209 0.45  1  0  0  2  0  0  0  0  0
0 0.47 0.2209 0.25  0  0  1  3  3  1  0  1  0
1 0.47 0.2209 0.25  0  0  1  1  0  1  0  1  0
0 0.47 0.2209 0.90  1  0  0  1  0  0  1  0  0
1 0.47 0.2209 0.45  1  0  0  1  0  0  1  0  0
0 0.47 0.2209 0.55  0  0  0  1  0  0  1  0  0
1 0.47 0.2209 0.90  0  0  0  0  0  0  0  0  0
0 0.47 0.2209 0.65  1  0  0  0  0  0  1  0  0
0 0.47 0.2209 1.50  1  0  0  0  0  0  0  0  0
0 0.47 0.2209 0.35  0  0  1  0  0  1  0  0  0
1 0.47 0.2209 0.90  1  0  0  0  0  0  0  0  0
0 0.47 0.2209 0.35  1  0  0  0  0  0  0  0  0
1 0.47 0.2209 0.45  0  0  0  0  0  0  0  0  0
0 0.47 0.2209 1.50  1  0  0  0  0  1  0  0  0
1 0.47 0.2209 0.06  1  0  0  0  0  7  0  0  0
1 0.47 0.2209 1.10  1  0  0  0  0  0  1  0  0
1 0.52 0.2704 0.35  1  0  0  1  0  2  0  0  0
1 0.52 0.2704 0.25  0  0  1  4  0  0  0  1  0
0 0.52 0.2704 0.45  1  0  0  3  0  0  1  0  0
0 0.52 0.2704 0.65  1  0  0  2  0  0  0  1  0
1 0.52 0.2704 0.35  0  0  1  1  0  0  1  0  0
1 0.52 0.2704 0.75  1  0  0  1  0  3  1  0  0
1 0.52 0.2704 0.25  0  0  1  1  8  7  0  1  0
1 0.52 0.2704 0.06  1  0  0  1  0  0  1  0  0
1 0.52 0.2704 0.35  0  0  1  3  0  6  1  0  0
0 0.52 0.2704 0.00  1  0  0  2  5  5  1  0  0
0 0.52 0.2704 0.65  1  0  0  1  0  0  1  0  0
1 0.52 0.2704 0.00  1  0  0  1  0  0  1  0  0
1 0.52 0.2704 0.55  0  0  0  3  0  0  1  0  0
0 0.52 0.2704 0.90  0  0  0  1  0  0  1  0  0
0 0.52 0.2704 0.75  0  0  0  1  0  0  1  0  0
0 0.52 0.2704 0.75  0  0  0  4  0  4  1  0  0
1 0.52 0.2704 0.25  0  1  0  4  0  2  1  0  0
1 0.52 0.2704 0.15  1  0  0  1  0  4  1  0  0
1 0.52 0.2704 0.90  1  0  0  2  0  0  0  1  0
0 0.52 0.2704 0.75  0  1  0  2 14  6  0  1  0
1 0.52 0.2704 0.25  0  0  1  2  0  0  1  0  0
1 0.52 0.2704 0.55  1  0  0  0  0  0  0  0  0
1 0.52 0.2704 1.50  1  0  0  0  0  0  0  0  0
1 0.52 0.2704 0.90  1  0  0  0  0  0  0  0  0
0 0.52 0.2704 0.90  1  0  0  0  0  0  0  0  0
1 0.52 0.2704 0.35  1  0  0  0  0  2  0  0  0
1 0.52 0.2704 0.35  1  0  0  0  0  0  1  0  0
0 0.52 0.2704 1.50  1  0  0  0  0  0  1  0  0
0 0.52 0.2704 1.10  0  0  0  0  0  0  0  1  0
0 0.52 0.2704 1.10  0  0  0  0  0  0  1  0  0
0 0.52 0.2704 0.55  0  0  0  0  0  0  0  0  0
0 0.52 0.2704 0.75  0  0  0  0  0  0  0  0  0
1 0.52 0.2704 0.45  1  0  0  0  0  0  0  0  0
1 0.57 0.3249 1.30  1  0  0  1  0  2  1  0  0
1 0.57 0.3249 0.45  1  0  0  1  0  7  0  0  0
1 0.57 0.3249 0.25  0  0  1  4  0  1  1  0  0
1 0.57 0.3249 0.45  1  0  0  2  0  2  1  0  0
1 0.57 0.3249 0.90  1  0  0  2  0  3  1  0  0
0 0.57 0.3249 0.25  1  0  0  3  0  0  0  0  0
1 0.57 0.3249 0.25  1  0  0  2  0  2  1  0  0
1 0.57 0.3249 0.45  0  0  0  1  0  0  0  0  0
1 0.57 0.3249 0.35  1  0  0  4  0  3  1  0  0
0 0.57 0.3249 0.65  0  0  0  3  0  0  0  0  0
1 0.57 0.3249 0.15  1  0  0  5  0  0  1  0  0
1 0.57 0.3249 0.25  0  0  1  3  0  2  1  0  0
1 0.57 0.3249 1.50  1  0  0  2  0  0  1  0  0
0 0.57 0.3249 0.90  1  0  0  1  2  1  0  1  0
1 0.57 0.3249 0.25  0  0  1  2  0  0  1  0  0
1 0.57 0.3249 0.65  0  0  0  5  0  6  1  0  0
1 0.57 0.3249 0.01  0  1  0  4  0  1  0  0  0
0 0.57 0.3249 0.90  1  0  0  3  0  0  1  0  0
0 0.57 0.3249 0.25  0  0  1  1  0  0  1  0  0
0 0.57 0.3249 0.90  0  0  0  1  0  3  1  0  0
0 0.57 0.3249 0.65  1  0  0  1  0  0  0  0  0
0 0.57 0.3249 0.35  1  0  0  4  2  3  1  0  0
1 0.57 0.3249 1.10  0  0  1  2  0  0  1  0  0
1 0.57 0.3249 0.45  1  0  0  3  0  3  1  0  0
1 0.57 0.3249 1.10  1  0  0  1  0  0  0  0  0
1 0.57 0.3249 0.90  1  0  0  4  0  0  0  1  0
1 0.57 0.3249 0.75  1  0  0  1  0  0  1  0  0
0 0.57 0.3249 0.90  0  0  0  0  0  0  0  0  0
1 0.57 0.3249 0.90  1  0  0  0  0  1  1  0  0
1 0.57 0.3249 0.25  0  0  1  0  0  0  0  0  0
1 0.57 0.3249 0.90  1  0  0  0  0  0  1  0  0
1 0.57 0.3249 0.90  1  0  0  0  0  4  0  0  0
0 0.57 0.3249 0.90  1  0  0  0  0  1  0  1  0
0 0.57 0.3249 0.01  1  0  0  0  0  0  0  0  0
1 0.57 0.3249 0.00  1  0  0  0  0  0  0  0  0
1 0.57 0.3249 0.45  1  0  0  0  0  0  1  0  0
0 0.62 0.3844 0.75  1  0  0  2  0  1  0  1  0
1 0.62 0.3844 1.30  1  0  0  1  0  0  1  0  0
1 0.62 0.3844 0.25  0  0  1  3  0  3  1  0  0
1 0.62 0.3844 0.25  0  0  1  3  0  1  1  0  0
1 0.62 0.3844 0.25  0  0  1  3  0  5  1  0  0
0 0.62 0.3844 1.10  1  0  0  3  0  3  0  0  0
0 0.62 0.3844 0.75  1  0  0  1  0  0  0  0  0
1 0.62 0.3844 0.25  0  0  1  2  0  0  1  0  0
1 0.62 0.3844 0.45  1  0  0  1  0  2  1  0  0
1 0.62 0.3844 0.25  0  0  1  3  0  0  1  0  0
0 0.62 0.3844 1.10  1  0  0  3  0  5  1  0  0
1 0.62 0.3844 0.45  1  0  0  2  0  3  0  0  0
0 0.62 0.3844 0.25  0  0  1  2  0  0  0  1  0
1 0.62 0.3844 0.25  0  0  1  1  0  0  1  0  0
1 0.62 0.3844 0.25  0  0  1  1  0  1  1  0  0
1 0.62 0.3844 0.25  0  0  1  1  0  0  1  0  0
0 0.62 0.3844 0.25  0  0  1  3  0  3  0  1  0
1 0.62 0.3844 0.75  0  0  0  2  0  0  1  0  0
1 0.62 0.3844 0.65  1  0  0  2  0  0  1  0  0
1 0.62 0.3844 0.25  0  0  1  2  0  0  0  0  0
1 0.62 0.3844 0.55  1  0  0  2  0  0  0  1  0
0 0.62 0.3844 1.50  1  0  0  1  0  0  1  0  0
1 0.62 0.3844 0.25  1  0  0  2  0  0  1  0  0
1 0.62 0.3844 0.25  1  0  0  3  0  0  1  0  0
0 0.62 0.3844 0.25  0  1  0  1  0  2  0  0  0
1 0.62 0.3844 0.25  0  0  1  0  0  0  1  0  0
1 0.62 0.3844 0.25  1  0  0  0  0  0  0  0  0
0 0.62 0.3844 0.90  0  0  0  0  0  0  0  0  0
0 0.62 0.3844 0.15  1  0  0  0  0  0  0  0  0
1 0.62 0.3844 0.25  0  0  1  0  0  0  0  0  0
0 0.62 0.3844 0.25  0  0  1  0  0  0  0  0  0
1 0.62 0.3844 0.25  0  0  1  0  0  0  0  0  0
1 0.62 0.3844 0.35  1  0  0  0  0  0  1  0  0
1 0.62 0.3844 0.25  1  0  0  0  0  0  1  0  0
0 0.62 0.3844 1.50  1  0  0  0  0  0  1  0  0
0 0.62 0.3844 0.45  0  0  1  0  0  0  0  0  0
1 0.67 0.4489 0.25  1  0  0  3  0  0  1  0  0
1 0.67 0.4489 0.55  1  0  0  1  0  0  0  0  0
1 0.67 0.4489 0.35  1  0  0  2  0  0  1  0  0
1 0.67 0.4489 0.25  0  0  1  1  0  0  1  0  0
1 0.67 0.4489 0.25  0  0  1  4  4  0  1  0  0
1 0.67 0.4489 0.35  1  0  0  1  0  0  1  0  0
0 0.67 0.4489 1.30  1  0  0  5  0  1  1  0  0
1 0.67 0.4489 0.15  1  0  0  1  0  0  1  0  0
1 0.67 0.4489 0.25  0  0  1  2  0  1  0  0  0
1 0.67 0.4489 0.45  0  0  1  1  0  0  0  0  0
1 0.67 0.4489 0.25  0  0  1  2  0  0  0  0  0
1 0.67 0.4489 0.45  0  0  1  1  2  1  0  0  0
1 0.67 0.4489 0.25  0  0  1  1  0  0  0  0  0
0 0.67 0.4489 0.35  0  0  1  5  0  0  1  0  0
1 0.67 0.4489 0.15  1  0  0  1  0  0  1  0  0
0 0.67 0.4489 1.10  1  0  0  2  0  0  1  0  0
1 0.67 0.4489 0.35  0  0  1  3  0  1  1  0  0
1 0.67 0.4489 0.15  1  0  0  1  0  0  1  0  0
1 0.67 0.4489 0.25  0  0  1  1  0  0  1  0  0
1 0.67 0.4489 0.35  1  0  0  3  0  1  1  0  0
1 0.67 0.4489 0.25  0  0  1  3  0  0  1  0  0
1 0.67 0.4489 0.25  1  0  0  1  0  0  1  0  0
1 0.67 0.4489 0.25  1  0  0  1  0  0  0  0  0
1 0.67 0.4489 0.25  0  0  1  1  0  0  1  0  0
1 0.67 0.4489 0.25  0  0  1  2  0  0  0  0  0
0 0.67 0.4489 0.75  1  0  0  2  0  1  1  0  0
0 0.67 0.4489 0.25  0  0  1  1  0  0  1  0  0
0 0.67 0.4489 0.06  1  0  0  5  0  8  1  0  0
1 0.67 0.4489 0.75  1  0  0  0  0  0  0  0  0
1 0.67 0.4489 0.25  1  0  0  0  0  0  1  0  0
0 0.67 0.4489 0.25  0  1  0  0  0  0  1  0  0
1 0.67 0.4489 0.06  1  0  0  0  0  3  1  0  0
0 0.67 0.4489 0.25  1  0  0  0  0  0  0  0  0
1 0.67 0.4489 0.25  1  0  0  0  0  1  0  0  0
0 0.67 0.4489 0.35  1  0  0  0  0  0  1  0  0
1 0.67 0.4489 0.35  0  0  0  0  0  0  1  0  0
0 0.67 0.4489 0.25  0  0  0  0  0  0  0  0  0
0 0.67 0.4489 1.50  1  0  0  0  0  0  0  0  0
1 0.67 0.4489 0.25  0  0  1  0  0  0  1  0  0
1 0.67 0.4489 0.45  1  0  0  0  0  0  0  0  0
1 0.67 0.4489 0.35  0  0  1  0  0  0  0  0  0
1 0.67 0.4489 0.35  1  0  0  0  0  0  0  0  0
0 0.67 0.4489 0.25  0  0  1  0  0  1  1  0  0
1 0.67 0.4489 0.35  0  0  1  0  0  0  1  0  0
0 0.72 0.5184 0.25  0  0  1  1  0  4  1  0  0
1 0.72 0.5184 0.90  1  0  0  2  0  1  0  1  0
1 0.72 0.5184 0.75  1  0  0  1  0  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  4  0  2  1  0  0
1 0.72 0.5184 0.25  0  0  1  1  0  0  0  0  0
0 0.72 0.5184 0.25  0  0  1  1  1  0  0  0  0
1 0.72 0.5184 0.55  1  0  0  4  0  0  1  0  0
1 0.72 0.5184 1.10  1  0  0  2  0  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  5  0  6  0  1  0
1 0.72 0.5184 0.35  0  0  1  2  0  0  1  0  0
1 0.72 0.5184 0.55  0  0  1  4  0  0  1  0  0
1 0.72 0.5184 0.35  0  0  1  1  0  1  1  0  0
1 0.72 0.5184 0.25  0  0  1  2  0  0  1  0  0
0 0.72 0.5184 0.25  0  0  1  2  0  0  0  1  0
1 0.72 0.5184 0.25  1  0  0  3  0  0  1  0  0
0 0.72 0.5184 0.25  0  0  1  3  0  3  1  0  0
0 0.72 0.5184 0.25  0  0  1  5  0  2  1  0  0
0 0.72 0.5184 0.35  1  0  0  2  0  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  1  0  0  0  0  0
1 0.72 0.5184 0.25  0  0  1  2  0  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  1  0  0  0  0  0
0 0.72 0.5184 0.25  1  0  0  1 14  1  0  0  0
0 0.72 0.5184 0.25  0  0  1  4  0  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  3  0  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  2  0  0  1  0  0
1 0.72 0.5184 0.15  0  0  1  1  0  0  0  0  0
0 0.72 0.5184 0.35  0  0  0  2  0  0  1  0  0
0 0.72 0.5184 0.25  0  0  1  3  0  3  0  0  0
0 0.72 0.5184 0.25  0  0  1  1  0  4  0  1  0
1 0.72 0.5184 0.15  0  0  1  4  0  0  0  1  0
1 0.72 0.5184 0.35  1  0  0  1  0  0  1  0  0
1 0.72 0.5184 0.25  1  0  0  1  0  0  1  0  0
1 0.72 0.5184 0.35  0  0  1  1 14  0  0  1  0
1 0.72 0.5184 0.25  0  0  1  2  0  5  0  1  0
1 0.72 0.5184 0.35  0  0  1  1  0  0  1  0  0
0 0.72 0.5184 0.25  1  0  0  4  0  0  0  0  0
1 0.72 0.5184 0.75  1  0  0  1  0  0  1  0  0
0 0.72 0.5184 0.25  1  0  0  2  0  0  1  0  0
1 0.72 0.5184 0.25  1  0  0  2  0  1  0  1  0
1 0.72 0.5184 0.25  0  0  1  1  0  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  1 14  0  0  0  0
1 0.72 0.5184 0.25  0  0  1  1  0  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  1  0  0  1  0  0
0 0.72 0.5184 0.65  0  0  0  1  0  0  1  0  0
1 0.72 0.5184 0.06  0  0  1  1  0  0  1  0  0
1 0.72 0.5184 0.25  1  0  0  2  0  0  0  1  0
0 0.72 0.5184 0.35  1  0  0  1  0  0  1  0  0
1 0.72 0.5184 0.55  0  0  1  0  0  0  1  0  0
1 0.72 0.5184 0.55  1  0  0  0  0  0  1  0  0
0 0.72 0.5184 0.90  1  0  0  0  0  1  1  0  0
1 0.72 0.5184 0.15  1  0  0  0  0  1  0  0  0
1 0.72 0.5184 0.35  1  0  0  0  0  0  1  0  0
0 0.72 0.5184 0.25  1  0  0  0  0  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  0  0  1  0  0  0
1 0.72 0.5184 1.10  1  0  0  0  0  0  1  0  0
1 0.72 0.5184 0.55  1  0  0  0  0  0  0  0  0
1 0.72 0.5184 0.25  0  0  1  0  0  0  0  0  0
1 0.72 0.5184 0.25  0  0  1  0  0  0  0  0  0
1 0.72 0.5184 0.35  1  0  0  0  0  0  0  0  0
1 0.72 0.5184 0.35  0  0  1  0  0  0  0  0  0
1 0.72 0.5184 0.25  0  0  1  0  0  0  1  0  0
1 0.72 0.5184 0.35  1  0  0  0  0  0  0  0  0
1 0.72 0.5184 0.25  0  0  1  0  0  0  1  0  0
1 0.72 0.5184 0.45  0  0  1  0  0  0  0  0  0
1 0.72 0.5184 1.30  0  0  0  0  0  0  0  0  0
1 0.72 0.5184 0.35  1  0  0  0  0  0  1  0  0
0 0.19 0.0361 0.35  0  0  0  2  0  2  0  0  0
0 0.19 0.0361 0.65  0  0  0  1  0  3  0  0  0
0 0.19 0.0361 0.55  1  0  0  1  0  3  1  0  0
1 0.19 0.0361 0.00  1  0  0  1  0  0  0  0  0
1 0.19 0.0361 0.55  1  0  0  1  0  4  0  0  0
0 0.19 0.0361 0.45  1  0  0  1  0  1  0  0  0
1 0.19 0.0361 0.55  1  0  0  4  1  0  1  0  0
0 0.19 0.0361 0.00  1  0  0  1  0  0  0  0  0
1 0.19 0.0361 0.55  0  0  0  1  0  1  0  0  0
1 0.19 0.0361 0.15  0  0  0  2  8  4  1  0  0
1 0.19 0.0361 0.45  1  0  0  1  0  1  0  0  0
0 0.19 0.0361 0.45  0  0  0  3  0  4  0  0  0
0 0.19 0.0361 0.35  1  0  0  1  0  2  1  0  0
1 0.19 0.0361 0.65  0  0  0  1  0  0  1  0  0
0 0.19 0.0361 0.45  0  0  0  1  0  0  0  0  0
0 0.19 0.0361 0.06  1  0  0  2  7  9  0  0  0
0 0.19 0.0361 0.25  0  1  0  5  0  1  0  0  0
0 0.19 0.0361 0.15  1  0  0  1  0  0  0  0  0
0 0.19 0.0361 0.35  0  0  0  2  0  1  1  0  0
1 0.19 0.0361 0.35  0  1  0  1  0  1  1  0  0
1 0.19 0.0361 0.55  1  0  0  1  0  4  1  0  0
0 0.19 0.0361 0.35  0  0  0  2  0  1  0  0  0
0 0.19 0.0361 0.01  0  0  0  1  1  0  1  0  0
0 0.19 0.0361 0.65  1  0  0  1  0  0  0  0  0
0 0.19 0.0361 0.55  1  0  0  1  0  0  0  0  0
0 0.19 0.0361 0.25  1  0  0  1  0  1  0  0  0
0 0.19 0.0361 0.06  1  0  0  2  1  2  0  0  0
0 0.19 0.0361 0.45  0  0  0  1  0  0  0  0  0
0 0.19 0.0361 0.55  0  0  0  1  0  1  0  0  0
0 0.19 0.0361 0.65  0  0  0  1  0  2  1  0  0
1 0.19 0.0361 0.35  0  0  0  1  0  0  0  0  0
0 0.19 0.0361 0.45  0  0  0  1  0  0  0  0  0
0 0.19 0.0361 0.35  0  0  0  1  0  0  0  0  0
0 0.19 0.0361 0.55  1  0  0  1  0  2  1  0  0
0 0.19 0.0361 0.25  0  0  0  3  0  0  1  0  0
1 0.19 0.0361 0.00  0  0  0  1  0  0  0  0  0
0 0.19 0.0361 0.55  0  0  0  4  0  1  1  0  0
0 0.19 0.0361 0.90  1  0  0  2  1  1  0  0  0
0 0.19 0.0361 0.55  1  0  0  2  1  1  0  0  0
1 0.19 0.0361 0.15  0  1  0  1  3  2  0  0  0
0 0.19 0.0361 0.25  1  0  0  1  0  0  0  0  0
0 0.19 0.0361 0.90  0  0  0  1  0  3  0  0  0
0 0.19 0.0361 0.65  0  0  0  3  0  1  1  0  0
0 0.19 0.0361 0.55  0  0  0  1  0  0  0  0  0
1 0.19 0.0361 0.55  1  0  0  3  0  0  0  0  0
0 0.19 0.0361 0.01  0  1  0  3  0  1  0  1  0
0 0.19 0.0361 0.15  1  0  0  1  0  0  0  0  0
1 0.19 0.0361 0.55  1  0  0  1  0  0  0  0  0
1 0.19 0.0361 0.55  1  0  0  1  0  0  0  0  0
1 0.19 0.0361 0.35  0  0  0  3  0  5  1  0  0
0 0.19 0.0361 0.45  0  0  0  4  0  4  0  0  0
1 0.19 0.0361 0.45  0  0  0  3  0  5  1  0  0
0 0.19 0.0361 0.55  0  0  0  2  2  3  0  0  0
0 0.19 0.0361 0.00  0  0  0  1  0  1  0  0  0
0 0.19 0.0361 0.35  0  0  0  2  0  1  0  0  0
1 0.19 0.0361 0.35  0  1  0  1  0  0  0  0  0
1 0.19 0.0361 0.00  1  0  0  1  0  0  0  0  0
0 0.19 0.0361 0.55  1  0  0  1  0  0  0  0  0
1 0.19 0.0361 0.45  1  0  0  5  0  3  1  0  0
0 0.19 0.0361 0.00  0  0  1  3  0  3  1  0  0
0 0.19 0.0361 0.35  0  0  0  2  0  4  0  0  0
0 0.19 0.0361 0.15  0  0  0  2  0  0  1  0  0
0 0.19 0.0361 0.06  0  0  0  1  0  5  0  0  0
0 0.19 0.0361 0.55  1  0  0  1  1  0  1  0  0
0 0.19 0.0361 0.35  1  0  0  3  0  1  0  0  0
1 0.19 0.0361 0.00  0  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.55  0  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.35  0  0  0  0  0  0  0  0  0
1 0.19 0.0361 0.75  0  0  0  0  0  1  0  0  0
1 0.19 0.0361 0.65  1  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.55  0  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.65  0  0  0  0  0  0  0  0  0
1 0.19 0.0361 0.25  1  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.45  0  1  0  0  0  1  0  0  0
0 0.19 0.0361 0.25  0  0  0  0  0  1  0  0  0
0 0.19 0.0361 0.15  0  1  0  0  0  0  0  0  0
0 0.19 0.0361 0.35  1  0  0  0  0  0  0  0  0
1 0.19 0.0361 0.25  1  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.35  0  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.55  0  0  0  0  0  0  0  0  0
1 0.19 0.0361 0.55  0  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.65  0  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.45  0  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.65  0  0  0  0  0  0  0  0  0
1 0.19 0.0361 0.25  1  0  0  0  0  0  0  0  0
1 0.19 0.0361 0.75  0  0  0  0  0  1  0  0  0
0 0.19 0.0361 0.25  0  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.25  0  1  0  0  0  1  0  0  0
0 0.19 0.0361 0.35  1  0  0  0  0  0  0  0  0
1 0.19 0.0361 0.55  0  0  0  0  0  0  1  0  0
0 0.19 0.0361 0.55  0  0  0  0  0  0  1  0  0
0 0.19 0.0361 0.25  0  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.00  1  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.45  1  0  0  0  0  4  0  0  0
0 0.19 0.0361 0.55  1  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.55  0  0  0  0  0  0  0  0  0
1 0.19 0.0361 0.25  0  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.55  0  0  0  0  0  0  0  0  0
1 0.19 0.0361 0.45  0  0  0  0  0  0  0  0  0
1 0.19 0.0361 0.45  1  0  0  0  0  0  0  0  0
1 0.19 0.0361 0.55  0  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.15  0  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.25  0  0  0  0  0  0  0  0  0
1 0.19 0.0361 0.35  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.75  0  0  0  1  1  0  1  0  0
1 0.22 0.0484 0.55  0  1  0  1  1  0  1  0  0
0 0.22 0.0484 0.75  1  0  0  2  1  1  1  0  0
1 0.22 0.0484 0.15  1  0  0  1  2  1  0  0  0
1 0.22 0.0484 0.65  1  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.55  0  0  0  1  0  0  1  0  0
0 0.22 0.0484 0.90  0  0  0  1  0  0  0  0  0
1 0.22 0.0484 0.25  0  0  0  1  0  0  0  0  0
1 0.22 0.0484 0.90  0  0  0  2  2  0  0  0  0
1 0.22 0.0484 0.35  0  1  0  3  5  0  0  0  0
0 0.22 0.0484 0.75  0  0  0  1  0  0  0  0  0
1 0.22 0.0484 0.45  0  0  0  2  0  0  1  0  0
1 0.22 0.0484 0.55  1  0  0  1  0  2  1  0  0
0 0.22 0.0484 0.15  0  1  0  2  0  1  1  0  0
0 0.22 0.0484 0.90  0  0  0  1  0  8  0  0  0
1 0.22 0.0484 0.45  0  0  0  4  0 11  1  0  0
0 0.22 0.0484 0.35  0  0  0  1  0  4  0  0  0
1 0.22 0.0484 0.25  1  0  0  4  0  5  1  0  0
0 0.22 0.0484 1.10  1  0  0  3  0  0  1  0  0
1 0.22 0.0484 0.65  1  0  0  1  0  1  0  0  0
0 0.22 0.0484 0.55  0  0  0  2  5  2  0  0  0
1 0.22 0.0484 0.45  0  0  0  1  0  0  1  0  0
1 0.22 0.0484 0.90  1  0  0  1  0  2  1  0  0
0 0.22 0.0484 0.25  0  0  0  1  0  0  0  0  0
1 0.22 0.0484 0.65  1  0  0  1  0  1  0  0  0
0 0.22 0.0484 0.35  0  0  0  5  0 11  0  0  0
0 0.22 0.0484 0.35  0  1  0  2  0  4  0  0  0
1 0.22 0.0484 0.01  0  0  0  1  0  7  0  1  0
0 0.22 0.0484 0.45  1  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.06  1  0  0  2  0  1  0  0  0
0 0.22 0.0484 0.65  0  0  0  2  0  1  0  0  0
0 0.22 0.0484 0.35  0  0  0  3  0  2  1  0  0
1 0.22 0.0484 0.90  0  0  0  3  0  0  0  0  0
0 0.22 0.0484 0.01  0  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.75  1  0  0  2  0  2  0  0  0
1 0.22 0.0484 1.10  1  0  0  1  0  3  1  0  0
0 0.22 0.0484 0.55  0  0  0  4  0  6  0  0  0
1 0.22 0.0484 0.45  0  0  0  1  0  0  1  0  0
0 0.22 0.0484 0.65  1  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.55  0  1  0  3  0  1  1  0  0
0 0.22 0.0484 0.65  0  0  0  1  0  2  1  0  0
0 0.22 0.0484 0.25  0  0  0  3  0  2  0  0  0
0 0.22 0.0484 0.75  0  0  0  2  0  1  0  0  0
0 0.22 0.0484 0.90  0  0  0  1  0  4  0  0  0
0 0.22 0.0484 0.75  1  0  0  1  0  1  0  0  0
0 0.22 0.0484 1.10  0  0  0  5 14  1  0  1  0
0 0.22 0.0484 0.55  1  0  0  5  0  1  1  0  0
0 0.22 0.0484 0.65  1  0  0  3  5  1  1  0  0
1 0.22 0.0484 1.10  0  0  0  1 14  0  1  0  0
0 0.22 0.0484 1.30  0  0  0  3  0  0  1  0  0
0 0.22 0.0484 0.35  1  0  0  2  0  0  1  0  0
0 0.22 0.0484 0.90  0  0  1  1  0  0  0  0  0
0 0.22 0.0484 0.65  1  0  0  2  1  1  0  0  0
0 0.22 0.0484 0.65  0  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.55  1  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.75  1  0  0  2  0  0  1  0  0
0 0.22 0.0484 0.90  0  0  0  2  1  0  0  0  0
1 0.22 0.0484 0.75  1  0  0  4  0  0  0  0  0
0 0.22 0.0484 0.55  0  0  0  3  0  5  1  0  0
0 0.22 0.0484 0.75  1  0  0  3  0  0  0  0  0
1 0.22 0.0484 0.55  1  0  0  1  0  0  0  0  0
1 0.22 0.0484 0.15  0  0  1  1  1  0  0  0  0
0 0.22 0.0484 0.25  0  0  0  1  0  0  0  0  0
1 0.22 0.0484 0.90  1  0  0  1  0  5  0  0  0
1 0.22 0.0484 0.65  1  0  0  2  0  1  0  0  0
1 0.22 0.0484 0.90  1  0  0  1  1  0  1  0  0
0 0.22 0.0484 0.90  0  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.55  0  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.75  1  0  0  1  0  0  1  0  0
1 0.22 0.0484 0.55  0  1  0  1  0  0  0  0  0
1 0.22 0.0484 0.45  0  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.35  1  0  0  1  0  1  1  0  0
1 0.22 0.0484 0.65  1  0  0  1  1  0  1  0  0
1 0.22 0.0484 0.65  1  0  0  1  0  0  1  0  0
0 0.22 0.0484 0.90  0  0  0  2  0  1  1  0  0
1 0.22 0.0484 0.55  0  0  0  2  1  3  1  0  0
0 0.22 0.0484 0.90  0  0  0  1  0  1  1  0  0
1 0.22 0.0484 0.25  1  0  0  1  0  2  1  0  0
0 0.22 0.0484 0.25  1  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.35  1  0  0  1  2  1  0  0  0
1 0.22 0.0484 0.35  0  0  0  1  2  0  0  0  0
1 0.22 0.0484 0.65  1  0  0  3  0  0  1  0  0
0 0.22 0.0484 0.55  0  0  0  2  0  0  0  0  0
1 0.22 0.0484 0.75  1  0  0  1  0  1  0  0  0
0 0.22 0.0484 0.55  1  0  0  1  0  0  1  0  0
0 0.22 0.0484 1.10  1  0  0  2  0  3  0  0  0
1 0.22 0.0484 0.75  1  0  0  1  0  0  0  0  0
1 0.22 0.0484 0.90  1  0  0  3  0  0  0  0  0
0 0.22 0.0484 0.45  0  0  0  5  0  9  0  0  0
0 0.22 0.0484 0.55  0  0  0  1  1  0  0  1  0
0 0.22 0.0484 0.35  1  0  0  2  0  2  1  0  0
0 0.22 0.0484 0.90  1  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.25  0  0  0  1  0  1  1  0  0
0 0.22 0.0484 0.15  1  0  0  1  0  1  1  0  0
0 0.22 0.0484 0.75  0  0  0  1  0  0  0  0  0
1 0.22 0.0484 0.65  0  0  0  2  0  2  0  0  0
1 0.22 0.0484 0.90  1  0  0  3  1  2  0  0  0
0 0.22 0.0484 0.75  0  0  0  4  1  0  0  0  0
0 0.22 0.0484 0.90  0  0  0  1  1  0  0  0  0
1 0.22 0.0484 0.00  0  0  0  2  0  0  1  0  0
0 0.22 0.0484 0.55  0  1  0  2  0  3  0  0  0
1 0.22 0.0484 0.65  0  0  0  2  0  0  1  0  0
1 0.22 0.0484 0.01  0  0  0  1  0  0  1  0  0
0 0.22 0.0484 1.10  1  0  0  1  0  0  1  0  0
1 0.22 0.0484 0.15  0  1  0  2  0  0  0  0  0
1 0.22 0.0484 0.25  0  0  0  1  0  2  1  0  0
0 0.22 0.0484 0.90  0  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.45  0  0  0  2  0  0  1  0  0
0 0.22 0.0484 0.90  0  0  0  2  4  0  0  0  0
1 0.22 0.0484 0.55  0  0  0  1  0  1  0  0  0
0 0.22 0.0484 0.65  1  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.65  0  0  0  1  0  0  1  0  0
0 0.22 0.0484 0.75  0  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.90  1  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.90  0  0  0  1  0  0  0  0  0
1 0.22 0.0484 0.25  0  0  0  1  0  0  1  0  0
1 0.22 0.0484 0.45  1  0  0  1  0  2  1  0  0
1 0.22 0.0484 0.90  1  0  0  1  0  0  0  0  0
0 0.22 0.0484 1.10  0  0  0  1  0  0  0  0  0
0 0.22 0.0484 1.50  1  0  0  1  0  0  1  0  0
0 0.22 0.0484 0.55  0  0  0  1  0  0  0  0  0
1 0.22 0.0484 0.65  0  0  0  1  0  0  0  0  0
1 0.22 0.0484 0.75  1  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.90  1  0  0  2  0  1  0  0  0
0 0.22 0.0484 0.65  0  0  0  3  0  0  0  0  0
0 0.22 0.0484 1.10  0  0  0  3  1  0  1  0  0
1 0.22 0.0484 0.45  1  0  0  2  3  0  0  0  0
0 0.22 0.0484 1.10  0  0  0  1 14  0  0  0  0
1 0.22 0.0484 0.65  1  0  0  2  0  2  1  0  0
0 0.22 0.0484 0.15  1  0  0  1  0  0  1  0  0
0 0.22 0.0484 1.10  0  0  0  1  3  0  0  0  0
1 0.22 0.0484 0.90  0  0  0  0  0  1  1  0  0
1 0.22 0.0484 0.90  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.75  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.55  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.75  0  0  0  0  0  1  0  0  0
0 0.22 0.0484 1.30  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 1.10  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 1.10  1  0  0  0  0  0  1  0  0
1 0.22 0.0484 0.25  1  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.55  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.55  1  0  0  0  0  3  0  0  0
1 0.22 0.0484 0.35  0  1  0  0  0  2  0  0  0
0 0.22 0.0484 0.90  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.75  0  0  0  0  0  1  0  0  0
0 0.22 0.0484 0.65  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.90  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.25  0  1  0  0  0  0  0  0  0
1 0.22 0.0484 1.10  1  0  0  0  0  1  0  0  0
0 0.22 0.0484 0.45  1  0  0  0  0  1  1  0  0
0 0.22 0.0484 1.10  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.25  0  1  0  0  0  0  0  0  0
0 0.22 0.0484 0.90  1  0  0  0  0  0  1  0  0
0 0.22 0.0484 0.35  0  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.25  0  1  0  0  0  0  0  0  0
0 0.22 0.0484 1.10  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.65  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.35  0  1  0  0  0  1  0  0  0
0 0.22 0.0484 0.15  0  1  0  0  0  0  0  0  0
0 0.22 0.0484 0.45  0  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.90  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.75  1  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.90  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.90  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.90  1  0  0  0  0  1  1  0  0
0 0.22 0.0484 1.10  1  0  0  0  0  0  1  0  0
0 0.22 0.0484 0.90  1  0  0  0  0  0  1  0  0
0 0.22 0.0484 0.25  0  0  0  0  0  1  0  0  0
0 0.22 0.0484 0.65  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.75  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.25  0  1  0  0  0  0  0  0  0
0 0.22 0.0484 0.65  0  0  0  0  0  1  0  0  0
0 0.22 0.0484 0.65  0  0  0  0  0  3  0  0  0
1 0.22 0.0484 0.90  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.55  0  0  0  0  0  0  1  0  0
0 0.22 0.0484 0.65  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.55  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.25  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.65  1  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.25  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 1.10  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.75  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.45  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.45  0  1  0  0  0  7  0  0  0
0 0.22 0.0484 0.55  0  0  0  0  0  1  0  0  0
1 0.22 0.0484 0.55  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 1.50  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.90  1  0  0  0  0  1  1  0  0
1 0.22 0.0484 0.65  1  0  0  0  0  2  0  0  0
0 0.22 0.0484 0.75  1  0  0  0  0  2  0  1  0
1 0.22 0.0484 0.55  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.45  0  0  0  0  0  2  1  0  0
0 0.22 0.0484 0.65  1  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.55  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.65  1  0  0  0  0  0  1  0  0
1 0.22 0.0484 0.35  0  0  0  0  0  1  1  0  0
0 0.22 0.0484 1.10  1  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.55  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.55  0  0  0  0  0  2  0  0  0
0 0.22 0.0484 1.30  1  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.65  0  0  0  0  0  0  0  0  0
1 0.22 0.0484 1.10  0  0  0  0  0  0  1  0  0
0 0.22 0.0484 0.35  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.75  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.75  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 1.30  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.65  0  0  0  0  0  1  0  0  0
0 0.22 0.0484 0.90  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.75  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.45  0  0  0  0  0  2  1  0  0
0 0.22 0.0484 1.30  0  0  0  0  0  0  0  0  0
0 0.27 0.0729 0.25  0  0  0  1  3  0  0  0  0
0 0.27 0.0729 0.90  1  0  0  1  0  4  0  0  0
0 0.27 0.0729 0.75  0  1  0  1  0  1  0  0  0
1 0.27 0.0729 0.90  1  0  0  3  0  0  0  0  0
0 0.27 0.0729 0.45  1  0  0  1  0  0  0  0  0
0 0.27 0.0729 0.90  0  0  0  1  0  3  1  0  0
1 0.27 0.0729 0.90  1  0  0  1  0 11  1  0  0
0 0.27 0.0729 1.30  1  0  0  1  0  0  0  0  0
0 0.27 0.0729 0.75  0  0  0  2  0  0  0  0  0
0 0.27 0.0729 1.30  1  0  0  1  0  0  0  0  0
1 0.27 0.0729 0.75  1  0  0  1  0  2  1  0  0
0 0.27 0.0729 0.55  0  0  0  1  0  0  1  0  0
0 0.27 0.0729 1.30  1  0  0  1  0  0  0  0  0
1 0.27 0.0729 0.90  0  0  0  2  0  1  0  0  0
0 0.27 0.0729 1.50  0  0  0  1  0  1  0  0  0
0 0.27 0.0729 0.55  1  0  0  2  0  0  0  0  0
0 0.27 0.0729 0.75  0  0  0  1  0  0  0  0  0
1 0.27 0.0729 1.10  1  0  0  1  2  1  1  0  0
0 0.27 0.0729 0.90  0  0  0  1  0  0  0  1  0
0 0.27 0.0729 0.25  0  1  0  1  7  2  0  0  0
1 0.27 0.0729 1.10  1  0  0  1  0  0  0  0  0
0 0.27 0.0729 0.55  0  0  0  3  0  0  0  0  0
0 0.27 0.0729 0.90  1  0  0  1  0  0  1  0  0
1 0.27 0.0729 0.90  1  0  0  2  0  0  1  0  0
0 0.27 0.0729 1.50  0  0  0  2  0  3  1  0  0
0 0.27 0.0729 0.90  0  0  0  1  0  0  1  0  0
0 0.27 0.0729 0.75  1  0  0  1  2  2  0  1  0
0 0.27 0.0729 0.90  0  0  0  2  0  0  1  0  0
0 0.27 0.0729 0.25  0  1  0  1  0  0  0  0  0
0 0.27 0.0729 0.90  0  0  0  1  0  4  1  0  0
0 0.27 0.0729 0.25  0  1  0  3  0  0  1  0  0
0 0.27 0.0729 0.25  1  0  0  1  0  0  0  0  0
1 0.27 0.0729 0.90  1  0  0  1  0  0  1  0  0
0 0.27 0.0729 0.75  1  0  0  2  0  0  0  0  0
0 0.27 0.0729 0.90  0  0  0  2  0  5  1  0  0
0 0.27 0.0729 1.50  1  0  0  1  0  0  1  0  0
1 0.27 0.0729 0.65  0  0  0  1  0  0  0  0  0
1 0.27 0.0729 1.10  0  0  0  0  0  3  0  0  0
1 0.27 0.0729 0.90  1  0  0  0  0  0  0  0  0
0 0.27 0.0729 0.25  1  0  0  0  0  5  0  0  0
1 0.27 0.0729 0.45  0  1  0  0  0  0  0  1  0
1 0.27 0.0729 0.75  1  0  0  0  0  0  0  0  0
0 0.27 0.0729 0.90  1  0  0  0  0  0  0  0  0
0 0.27 0.0729 1.10  0  0  0  0  0  0  0  0  0
1 0.27 0.0729 0.90  1  0  0  0  0  0  0  0  0
0 0.27 0.0729 0.65  0  0  0  0  0  0  0  0  0
0 0.27 0.0729 1.10  1  0  0  0  0  0  0  0  0
0 0.27 0.0729 1.50  1  0  0  0  1  1  0  0  0
0 0.27 0.0729 1.10  1  0  0  0  0  0  0  0  0
1 0.27 0.0729 0.90  1  0  0  0  0  0  1  0  0
0 0.27 0.0729 0.90  1  0  0  0  0  0  0  0  0
0 0.27 0.0729 0.65  0  0  0  0  0  1  0  0  0
0 0.27 0.0729 0.15  0  0  0  0  0  0  1  0  0
0 0.27 0.0729 1.50  1  0  0  0  0  0  0  0  0
0 0.27 0.0729 1.10  1  0  0  0  0  0  0  0  0
0 0.27 0.0729 1.10  0  0  0  0  0  0  0  0  0
0 0.27 0.0729 0.75  0  0  0  0  0  0  0  1  0
0 0.27 0.0729 0.55  0  0  0  0  0  0  0  0  0
0 0.27 0.0729 1.10  1  0  0  0  0  0  0  0  0
0 0.27 0.0729 0.65  1  0  0  0  0  0  0  0  0
0 0.27 0.0729 0.90  0  0  0  0  0  0  0  0  0
0 0.27 0.0729 0.90  0  0  0  0  0  0  0  0  0
0 0.27 0.0729 0.90  1  0  0  0  0  0  0  0  0
1 0.27 0.0729 0.90  1  0  0  0  0  0  0  0  0
1 0.27 0.0729 0.75  1  0  0  0  0  1  0  0  0
1 0.27 0.0729 0.90  1  0  0  0  0  1  0  0  0
0 0.27 0.0729 0.90  1  0  0  0  0  1  0  0  0
1 0.27 0.0729 1.10  0  0  0  0  0  2  0  0  0
0 0.27 0.0729 0.65  0  0  0  0  0  0  0  1  0
0 0.27 0.0729 0.35  0  0  0  0  0  0  0  0  0
0 0.27 0.0729 0.55  0  1  0  0  0  8  0  0  0
0 0.27 0.0729 0.75  0  0  0  0  0  0  0  0  0
0 0.27 0.0729 0.75  0  0  0  0  0  0  0  0  0
1 0.27 0.0729 0.90  1  0  0  0  0  0  0  0  0
0 0.27 0.0729 1.30  1  0  0  0  0  0  0  0  0
0 0.32 0.1024 1.30  0  0  0  1  0  0  0  0  0
1 0.32 0.1024 0.55  0  0  0  4 14  1  0  0  0
0 0.32 0.1024 0.75  0  0  0  2  0  0  0  0  0
0 0.32 0.1024 0.55  0  0  0  4  0  4  1  0  0
0 0.32 0.1024 0.75  1  0  0  2  0  4  0  0  0
0 0.32 0.1024 0.90  1  0  0  1  0  0  0  0  0
0 0.32 0.1024 0.65  0  0  0  1  0  0  0  1  0
0 0.32 0.1024 1.30  0  0  0  3  0  0  0  0  0
1 0.32 0.1024 0.65  0  0  0  3  0  1  0  1  0
0 0.32 0.1024 0.90  0  0  0  1  0  0  0  1  0
0 0.32 0.1024 0.90  0  0  0  1  0  1  0  0  0
0 0.32 0.1024 0.45  0  0  0  1  0  0  0  0  0
0 0.32 0.1024 1.30  1  0  0  1  0  0  0  0  0
0 0.32 0.1024 1.50  0  0  0  1  0  0  1  0  0
1 0.32 0.1024 1.50  1  0  0  1  0  1  0  0  0
1 0.32 0.1024 1.50  1  0  0  1  1  0  1  0  0
0 0.32 0.1024 0.65  0  0  0  1  0  0  0  0  0
0 0.32 0.1024 1.30  1  0  0  1  0  1  1  0  0
1 0.32 0.1024 0.75  1  0  0  1  0  0  0  0  0
1 0.32 0.1024 1.50  1  0  0  1  0  0  1  0  0
0 0.32 0.1024 1.30  1  0  0  1  0  1  0  0  0
1 0.32 0.1024 0.90  1  0  0  2  0  0  0  0  0
1 0.32 0.1024 1.50  1  0  0  3  0  0  1  0  0
1 0.32 0.1024 1.50  0  0  0  4 14  4  1  0  0
0 0.32 0.1024 0.90  1  0  0  1  0  0  1  0  0
1 0.32 0.1024 0.90  1  0  0  1  0  4  0  0  0
0 0.32 0.1024 1.30  1  0  0  0  0  0  0  0  0
1 0.32 0.1024 1.10  1  0  0  0  0  0  0  0  0
0 0.32 0.1024 0.75  1  0  0  0  0  0  0  0  0
1 0.32 0.1024 0.90  1  0  0  0  0  0  1  0  0
0 0.32 0.1024 0.90  0  0  0  0  0  0  0  0  0
0 0.32 0.1024 0.55  1  0  0  0  0  0  0  0  0
0 0.32 0.1024 0.75  1  0  0  0  0  0  0  1  0
0 0.32 0.1024 0.90  0  0  0  0  0  1  1  0  0
1 0.32 0.1024 0.55  0  0  0  0  0  0  0  1  0
1 0.32 0.1024 1.10  1  0  0  0  0  0  0  0  0
0 0.32 0.1024 0.55  0  0  0  0  0  0  0  0  0
0 0.32 0.1024 1.10  0  0  0  0  0  0  0  0  0
0 0.32 0.1024 1.50  0  0  0  0  0  2  1  0  0
0 0.32 0.1024 1.10  1  0  0  0  0  0  1  0  0
0 0.32 0.1024 0.90  0  0  0  0  0  0  1  0  0
0 0.32 0.1024 0.75  1  0  0  0  0  0  0  0  0
1 0.37 0.1369 1.10  1  0  0  1  0  0  0  1  0
0 0.37 0.1369 1.10  0  0  0  4  0  4  0  0  0
1 0.37 0.1369 0.90  1  0  0  2  0  1  0  0  0
1 0.37 0.1369 0.90  0  0  0  1  0  3  1  0  0
0 0.37 0.1369 0.90  0  0  0  1  0  0  0  0  0
1 0.37 0.1369 0.25  0  0  1  4  8  9  0  1  0
0 0.37 0.1369 1.50  1  0  0  2  0  0  1  0  0
0 0.37 0.1369 0.65  0  0  0  4  0  5  0  0  0
0 0.37 0.1369 1.30  0  0  0  1  0  0  0  0  0
0 0.37 0.1369 0.45  1  0  0  1  0  1  1  0  0
1 0.37 0.1369 0.65  1  0  0  4  0  0  0  0  0
1 0.37 0.1369 0.35  1  0  0  2  0  2  0  1  0
0 0.37 0.1369 1.50  1  0  0  0  0  0  1  0  0
1 0.37 0.1369 0.65  1  0  0  0  0  0  0  0  0
1 0.37 0.1369 0.75  1  0  0  0  0  0  0  0  0
0 0.37 0.1369 0.35  0  0  0  0  0  0  0  0  0
1 0.42 0.1764 0.15  0  0  1  1  4  0  0  0  0
1 0.42 0.1764 0.45  1  0  0  1  0  7  1  0  0
1 0.42 0.1764 0.90  1  0  0  1  0  0  0  1  0
0 0.42 0.1764 0.90  1  0  0  2  3  0  1  0  0
1 0.42 0.1764 0.25  0  0  1  2  2  4  0  1  0
0 0.42 0.1764 1.50  1  0  0  1  0  0  1  0  0
1 0.42 0.1764 0.75  1  0  0  1 10  1  0  0  0
1 0.42 0.1764 0.01  1  0  0  1  0  0  1  0  0
0 0.42 0.1764 1.10  0  0  0  1  0  0  0  0  0
0 0.42 0.1764 1.50  0  0  0  4  0  5  0  1  0
1 0.42 0.1764 0.90  1  0  0  5  0  0  1  0  0
0 0.42 0.1764 1.10  1  0  0  0  0  0  0  0  0
0 0.42 0.1764 1.10  1  0  0  0  0  0  0  0  0
0 0.42 0.1764 0.90  1  0  0  0  0  0  0  0  0
0 0.42 0.1764 1.30  1  0  0  0  0  0  0  0  0
0 0.42 0.1764 0.90  1  0  0  0  0  0  0  0  0
0 0.42 0.1764 0.75  0  0  0  0  0  0  1  0  0
0 0.42 0.1764 1.50  1  0  0  0  0  0  0  0  0
0 0.47 0.2209 0.90  1  0  0  1  0  0  0  0  0
0 0.47 0.2209 0.65  1  0  0  5  0  0  1  0  0
0 0.47 0.2209 0.45  1  0  0  5  0  3  1  0  0
1 0.47 0.2209 0.65  0  0  0  1  0  0  0  0  0
1 0.47 0.2209 0.90  1  0  0  1  0  1  0  0  0
0 0.47 0.2209 1.30  1  0  0  1  0  7  1  0  0
0 0.47 0.2209 0.00  0  0  0  3  0  1  1  0  0
1 0.47 0.2209 0.65  1  0  0  1  0  0  1  0  0
0 0.47 0.2209 1.10  0  0  0  1  0  0  0  0  0
0 0.47 0.2209 0.90  1  0  0  3  0  0  0  1  0
1 0.47 0.2209 0.65  1  0  0  3  0  2  1  0  0
0 0.47 0.2209 0.75  1  0  0  1  0  0  0  0  0
0 0.47 0.2209 1.50  0  0  0  1  1  1  1  0  0
0 0.47 0.2209 1.30  1  0  0  2  0  1  0  1  0
1 0.47 0.2209 1.50  1  0  0  1  0  4  1  0  0
0 0.47 0.2209 1.30  1  0  0  2  0  0  1  0  0
1 0.47 0.2209 0.25  0  0  1  1  0  0  1  0  0
0 0.47 0.2209 0.25  0  1  0  0  0  4  0  0  0
1 0.47 0.2209 0.06  1  0  0  0  0  1  1  0  0
0 0.47 0.2209 0.75  1  0  0  0  0  0  0  0  0
1 0.47 0.2209 0.90  1  0  0  0  0  0  0  0  0
0 0.47 0.2209 0.65  1  0  0  0  0  0  0  0  0
0 0.47 0.2209 1.50  0  0  0  0  0  0  1  0  0
0 0.47 0.2209 0.00  0  1  0  0  0  0  1  0  0
0 0.47 0.2209 1.50  1  0  0  0  0  0  0  0  0
1 0.52 0.2704 0.25  1  0  0  2 14  4  1  0  0
0 0.52 0.2704 1.10  0  0  0  1  0  1  0  0  0
0 0.52 0.2704 1.10  1  0  0  1  0  0  0  0  0
1 0.52 0.2704 0.25  0  0  1  1  0  0  1  0  0
0 0.52 0.2704 0.55  1  0  0  2  0  7  0  1  0
1 0.52 0.2704 0.65  1  0  0  1  0  0  0  0  0
1 0.52 0.2704 0.55  1  0  0  5  0  0  1  0  0
0 0.52 0.2704 0.35  0  0  1  1  0  2  1  0  0
1 0.52 0.2704 0.35  1  0  0  2  0  0  1  0  0
0 0.52 0.2704 1.30  0  0  0  1  0  0  0  0  0
0 0.52 0.2704 0.75  0  0  0  5  3  4  1  0  0
0 0.52 0.2704 1.30  0  0  0  1  0  0  0  0  0
1 0.52 0.2704 0.55  1  0  0  4  0  4  1  0  0
0 0.52 0.2704 0.65  1  0  0  1  0  0  1  0  0
0 0.52 0.2704 0.90  1  0  0  1  0  0  0  0  0
0 0.52 0.2704 1.30  1  0  0  1  0  0  1  0  0
0 0.52 0.2704 0.00  0  0  0  1  0  0  1  0  0
0 0.52 0.2704 0.90  1  0  0  1  0  0  0  0  0
0 0.52 0.2704 1.10  0  0  0  0  0  0  0  0  0
0 0.52 0.2704 1.30  1  0  0  0  0  0  0  0  0
0 0.52 0.2704 1.50  1  0  0  0  0  0  0  0  0
0 0.52 0.2704 0.65  0  0  0  0  0  0  1  0  0
1 0.52 0.2704 0.65  1  0  0  0  0  0  1  0  0
0 0.52 0.2704 0.25  0  0  1  0  0  1  0  1  0
0 0.52 0.2704 0.75  0  0  0  0  0  0  0  1  0
1 0.57 0.3249 0.75  1  0  0  1  0  1  1  0  0
0 0.57 0.3249 0.75  0  0  0  2  0  1  0  1  0
0 0.57 0.3249 0.90  1  0  0  1  0  0  1  0  0
1 0.57 0.3249 0.75  0  0  0  1  0  0  0  0  0
1 0.57 0.3249 0.65  0  0  0  1  0  0  0  0  0
0 0.57 0.3249 0.01  0  0  1  1  0  0  1  0  0
1 0.57 0.3249 0.35  0  0  1  2  0  1  1  0  0
0 0.57 0.3249 1.10  1  0  0  2  0  1  1  0  0
1 0.57 0.3249 0.35  0  0  1  2  0  0  1  0  0
1 0.57 0.3249 0.25  0  0  1  1  0  3  1  0  0
0 0.57 0.3249 0.25  0  0  1  3  0  0  1  0  0
0 0.57 0.3249 0.65  0  0  0  5  0  0  0  0  0
1 0.57 0.3249 0.90  1  0  0  3  0  0  1  0  0
1 0.57 0.3249 0.35  0  0  1  1  0  1  1  0  0
0 0.57 0.3249 0.00  0  1  0  2  0  0  0  1  0
1 0.57 0.3249 0.45  1  0  0  2  0  0  1  0  0
0 0.57 0.3249 0.25  0  0  1  1  0  0  0  1  0
1 0.57 0.3249 0.25  1  0  0  0  0  0  0  0  0
0 0.57 0.3249 0.90  0  0  0  0  0  0  0  0  0
0 0.57 0.3249 0.65  0  0  0  0  0  0  0  0  0
1 0.57 0.3249 1.10  1  0  0  0  0  0  0  1  0
0 0.57 0.3249 0.90  1  0  0  0  0  0  0  0  0
1 0.57 0.3249 0.65  0  0  0  0  0  0  1  0  0
1 0.62 0.3844 0.25  0  0  1  5  0  3  1  0  0
1 0.62 0.3844 0.45  0  0  1  2  2  3  1  0  0
1 0.62 0.3844 1.10  1  0  0  2  0  0  1  0  0
0 0.62 0.3844 0.65  1  0  0  4  0  5  1  0  0
1 0.62 0.3844 0.35  0  0  1  2  0  1  1  0  0
1 0.62 0.3844 0.00  1  0  0  2  0  0  0  0  0
1 0.62 0.3844 0.01  0  0  0  3  0  0  0  1  0
1 0.62 0.3844 0.35  1  0  0  3  0  0  1  0  0
0 0.62 0.3844 0.06  1  0  0  5  0  2  1  0  0
0 0.62 0.3844 0.25  0  0  1  4  0  0  0  0  0
1 0.62 0.3844 0.35  0  0  1  1  0  0  1  0  0
1 0.62 0.3844 0.25  0  0  1  5 14  6  0  1  0
1 0.62 0.3844 0.90  1  0  0  2  0  1  1  0  0
1 0.62 0.3844 0.25  0  0  1  1  0  2  1  0  0
1 0.62 0.3844 0.25  0  0  1  1  0  0  0  0  0
0 0.62 0.3844 0.90  1  0  0  2  0  0  1  0  0
0 0.62 0.3844 0.25  0  0  1  1  0  0  1  0  0
0 0.62 0.3844 0.75  1  0  0  1  0  0  1  0  0
1 0.62 0.3844 0.25  1  0  0  2  0  0  0  0  0
1 0.62 0.3844 0.25  0  0  1  2  0  0  1  0  0
1 0.62 0.3844 0.35  1  0  0  2  0  1  1  0  0
1 0.62 0.3844 0.25  0  0  1  1  0  0  1  0  0
1 0.62 0.3844 0.35  1  0  0  0  0  0  0  0  0
0 0.62 0.3844 0.90  1  0  0  0  0  0  0  0  0
1 0.62 0.3844 0.25  0  0  1  0  0  0  0  0  0
1 0.62 0.3844 0.06  1  0  0  0  0  0  1  0  0
0 0.62 0.3844 1.10  0  0  0  0  0  0  0  0  0
0 0.62 0.3844 0.65  0  0  0  0  0  0  0  0  0
0 0.62 0.3844 0.15  1  0  0  0  0  0  1  0  0
1 0.62 0.3844 0.65  0  0  1  0  0  0  1  0  0
1 0.62 0.3844 0.35  0  0  1  0  0  0  0  0  0
1 0.62 0.3844 0.25  0  0  1  0  0  0  1  0  0
1 0.62 0.3844 0.25  0  0  1  0  0  0  0  1  0
0 0.62 0.3844 0.15  0  0  1  0  0  0  0  1  0
1 0.67 0.4489 0.35  1  0  0  2  0  1  1  0  0
1 0.67 0.4489 0.25  0  0  1  5  0  1  1  0  0
1 0.67 0.4489 0.25  0  0  1  2  1  0  1  0  0
1 0.67 0.4489 0.25  0  0  1  3  0  1  1  0  0
1 0.67 0.4489 0.25  0  0  1  4  0  0  1  0  0
0 0.67 0.4489 0.15  0  0  1  1  0  0  0  0  0
1 0.67 0.4489 0.55  0  0  0  1  0  0  0  0  0
1 0.67 0.4489 0.15  1  0  0  3  0  0  1  0  0
1 0.67 0.4489 0.25  0  0  1  1  0  0  1  0  0
0 0.67 0.4489 0.35  0  0  1  2  0  4  1  0  0
1 0.67 0.4489 0.25  0  0  1  2  0  0  1  0  0
1 0.67 0.4489 0.45  0  0  1  1  0  0  1  0  0
0 0.67 0.4489 0.35  1  0  0  1  0  0  1  0  0
1 0.67 0.4489 0.25  0  0  1  1  0  0  0  0  0
0 0.67 0.4489 0.25  0  0  1  5  0  6  1  0  0
0 0.67 0.4489 0.55  1  0  0  2  1  0  1  0  0
1 0.67 0.4489 0.45  0  0  1  2  0  1  1  0  0
0 0.67 0.4489 0.25  0  0  1  1 10  6  1  0  0
0 0.67 0.4489 0.75  0  0  1  3 14  1  1  0  0
1 0.67 0.4489 0.35  0  0  0  0  0  0  1  0  0
1 0.67 0.4489 0.45  0  0  1  0  0  0  0  0  0
1 0.67 0.4489 0.35  1  0  0  0  0  0  0  0  0
1 0.67 0.4489 0.25  0  0  1  0  0  0  0  0  0
0 0.67 0.4489 0.35  1  0  0  0  0  0  0  0  0
1 0.72 0.5184 0.25  0  0  1  1  0  0  0  0  0
1 0.72 0.5184 0.55  1  0  0  2  0  4  1  0  0
1 0.72 0.5184 0.35  1  0  0  1  0  0  1  0  0
0 0.72 0.5184 0.35  0  0  1  1  0  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  4  3  5  1  0  0
0 0.72 0.5184 1.10  1  0  0  3  0  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  5  0  0  1  0  0
1 0.72 0.5184 0.65  1  0  0  5  0  3  1  0  0
1 0.72 0.5184 0.45  1  0  0  2  0  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  1  0  0  0  0  0
1 0.72 0.5184 0.25  0  0  1  2  0  0  1  0  0
0 0.72 0.5184 0.25  0  0  1  1  0  0  0  0  0
0 0.72 0.5184 0.25  0  0  1  5  0  1  1  0  0
0 0.72 0.5184 0.25  0  0  1  2  0  0  0  0  0
1 0.72 0.5184 0.25  0  0  1  2  0  0  1  0  0
1 0.72 0.5184 0.06  0  0  1  1  0  0  0  0  0
1 0.72 0.5184 0.25  0  0  1  4  0  0  1  0  0
1 0.72 0.5184 0.35  0  0  1  2  0  2  1  0  0
1 0.72 0.5184 0.25  0  0  1  1  0  0  1  0  0
1 0.72 0.5184 0.35  1  0  0  1  0  2  1  0  0
1 0.72 0.5184 0.45  1  0  0  2  0  0  0  0  0
1 0.72 0.5184 0.25  0  0  1  4  0  1  1  0  0
1 0.72 0.5184 0.25  0  0  1  1  0  0  0  0  0
0 0.72 0.5184 0.25  0  0  1  1  0  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  2  0  0  1  0  0
0 0.72 0.5184 0.35  0  0  1  1  0  1  1  0  0
1 0.72 0.5184 0.25  0  0  1  3  0  0  1  0  0
0 0.72 0.5184 1.10  1  0  0  1  0  0  1  0  0
1 0.72 0.5184 0.15  0  0  1  2  0  1  1  0  0
1 0.72 0.5184 0.35  1  0  0  4  0 10  1  0  0
0 0.72 0.5184 0.25  0  0  1  1  0  0  0  0  0
0 0.72 0.5184 0.25  0  0  1  1  0  0  0  0  0
1 0.72 0.5184 0.55  1  0  0  2  0  0  1  0  0
0 0.72 0.5184 0.45  1  0  0  1  0  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  1  0  0  0  1  0
0 0.72 0.5184 0.25  0  0  1  0  0  0  0  0  0
1 0.72 0.5184 0.35  0  0  1  0  0  1  0  0  0
1 0.72 0.5184 0.90  1  0  0  0  0  0  0  0  0
1 0.72 0.5184 0.25  0  0  1  0  0  1  1  0  0
1 0.72 0.5184 0.35  0  0  1  0  0  0  1  0  0
1 0.72 0.5184 0.15  0  0  1  0  0  0  0  0  0
1 0.72 0.5184 0.25  1  0  0  0  0  0  0  1  0
0 0.72 0.5184 1.10  1  0  0  0  0  0  1  0  0
0 0.72 0.5184 0.35  1  0  0  0  0  0  0  0  0
1 0.72 0.5184 0.65  0  0  0  0  0  0  0  0  0
1 0.72 0.5184 0.35  1  0  0  0  0  0  1  0  0
1 0.72 0.5184 0.25  1  0  0  0  0  1  0  0  0
1 0.72 0.5184 0.25  0  0  1  0  0  1  0  0  0
1 0.72 0.5184 0.25  0  0  1  0  0  0  0  0  0
1 0.72 0.5184 0.15  1  0  0  0  0  0  0  0  0
1 0.72 0.5184 0.25  0  0  1  0  0  0  0  0  0
1 0.72 0.5184 0.35  0  0  0  0  0  0  0  0  0
1 0.72 0.5184 0.25  0  0  1  0  0  0  0  0  0
1 0.72 0.5184 0.15  0  0  1  0  0  0  0  0  0
1 0.72 0.5184 0.25  0  0  1  0  0  1  0  0  0
1 0.72 0.5184 0.25  1  0  0  0  0  1  0  0  0
1 0.72 0.5184 0.25  0  0  1  0  0  2  0  0  0
0 0.19 0.0361 0.65  1  0  0  1  1  0  1  0  0
0 0.19 0.0361 0.25  1  0  0  1  1  0  0  0  0
0 0.19 0.0361 0.55  1  0  0  1  0  3  0  0  0
1 0.19 0.0361 0.45  0  0  0  1  0  0  0  0  0
1 0.19 0.0361 0.15  0  0  0  4  0  3  0  0  0
0 0.19 0.0361 0.15  0  1  0  3  0  0  0  0  0
0 0.19 0.0361 0.00  1  0  0  2  0  1  0  0  0
0 0.19 0.0361 0.35  0  0  0  1  0  3  1  0  0
1 0.19 0.0361 0.06  0  0  0  3  0  0  0  0  0
0 0.19 0.0361 0.35  0  1  0  3  0  0  0  0  0
1 0.19 0.0361 0.45  0  0  0  2  1  0  0  0  0
0 0.19 0.0361 0.65  1  0  0  1  0  0  1  0  0
0 0.19 0.0361 0.25  0  0  0  1  0  5  0  0  0
0 0.19 0.0361 0.65  0  0  0  1  0 11  0  0  0
1 0.19 0.0361 0.35  0  1  0  2  0  7  1  0  0
0 0.19 0.0361 0.65  0  0  0  1  0  1  0  0  0
1 0.19 0.0361 0.15  0  0  0  1  0  1  0  0  0
1 0.19 0.0361 0.06  0  0  0  1  0  3  0  0  0
1 0.19 0.0361 0.45  0  0  0  1  0  2  0  0  0
1 0.19 0.0361 0.75  0  0  0  2  0  6  0  0  0
0 0.19 0.0361 0.35  0  0  0  2  0  6  0  0  0
1 0.19 0.0361 0.65  0  0  0  2  0  0  1  0  0
1 0.19 0.0361 0.45  0  0  0  3  0  2  0  0  0
0 0.19 0.0361 0.45  0  0  0  2  0  2  0  1  0
0 0.19 0.0361 0.45  0  0  0  1  0  0  0  0  0
0 0.19 0.0361 0.35  0  0  0  2  0  0  0  0  0
0 0.19 0.0361 0.25  0  1  0  1  0  3  0  0  0
1 0.19 0.0361 0.65  1  0  0  2  0  0  1  0  0
0 0.19 0.0361 0.00  0  0  0  2  0  3  0  0  0
1 0.19 0.0361 0.25  1  0  0  1  0  2  1  0  0
0 0.19 0.0361 0.25  0  1  0  1  0  3  0  0  0
1 0.19 0.0361 0.45  0  0  0  3  0  0  1  0  0
1 0.19 0.0361 0.06  0  0  0  2  0  2  0  0  0
0 0.19 0.0361 0.65  0  0  0  3  0  1  1  0  0
0 0.19 0.0361 0.15  0  0  0  2  1  0  0  0  0
1 0.19 0.0361 0.55  1  0  0  1  0  0  0  0  0
1 0.19 0.0361 0.25  0  0  0  1  0  3  0  0  0
0 0.19 0.0361 0.35  0  0  0  1  0  0  0  0  0
1 0.19 0.0361 0.00  1  0  0  1  0  0  1  0  0
0 0.19 0.0361 0.45  0  0  0  1  0  1  0  0  0
1 0.19 0.0361 0.90  0  0  0  1  1  0  1  0  0
0 0.19 0.0361 0.15  0  0  0  2  0  1  0  0  0
0 0.19 0.0361 0.55  0  0  0  1  0  1  0  0  0
1 0.19 0.0361 0.06  1  0  0  1  1  0  0  0  0
1 0.19 0.0361 0.55  1  0  0  1  0  0  0  0  0
1 0.19 0.0361 0.45  0  1  0  1  0  0  0  0  0
0 0.19 0.0361 0.55  0  0  0  1  0  0  0  0  0
0 0.19 0.0361 0.55  0  0  0  1  1  0  1  0  0
0 0.19 0.0361 0.55  0  0  0  2  1  0  0  0  0
1 0.19 0.0361 0.75  1  0  0  1  0  0  0  0  0
1 0.19 0.0361 0.65  1  0  0  2  0  0  0  0  0
0 0.19 0.0361 0.25  0  0  0  1  0  0  0  0  0
0 0.19 0.0361 0.15  1  0  0  1  0  1  0  0  0
0 0.19 0.0361 0.55  1  0  0  1  0  0  0  0  0
0 0.19 0.0361 0.06  0  0  0  1  0  0  0  0  0
0 0.19 0.0361 0.25  0  0  0  2  0  1  0  0  0
0 0.19 0.0361 0.15  0  0  0  4  0  4  0  1  0
0 0.19 0.0361 0.06  1  0  0  1  1  0  0  0  0
0 0.19 0.0361 0.25  0  0  0  1  0  0  0  0  0
0 0.19 0.0361 0.55  0  0  0  2  2  0  0  0  0
0 0.19 0.0361 0.15  0  0  0  1  0  0  1  0  0
0 0.19 0.0361 0.75  0  0  0  1  0  0  1  0  0
1 0.19 0.0361 0.45  0  0  0  3  0  0  0  0  0
0 0.19 0.0361 0.15  1  0  0  1  0  0  0  0  0
1 0.19 0.0361 0.25  0  1  0  2  0  9  0  0  0
0 0.19 0.0361 0.06  0  0  0  1  0  1  0  0  0
0 0.19 0.0361 0.75  0  0  0  1  0  0  0  0  0
1 0.19 0.0361 0.15  1  0  0  1  0  2  0  0  0
0 0.19 0.0361 0.55  0  0  0  1  0  1  0  0  0
0 0.19 0.0361 0.45  1  0  0  3  0  0  0  0  0
0 0.19 0.0361 0.65  0  0  0  2  0  0  1  0  0
1 0.19 0.0361 0.25  0  0  0  2  0  0  1  0  0
0 0.19 0.0361 0.65  0  0  0  1  0  0  0  0  0
0 0.19 0.0361 0.55  0  0  0  1  0  3  0  0  0
1 0.19 0.0361 0.45  0  0  0  1  0  0  0  0  0
0 0.19 0.0361 0.90  0  0  0  1  0  0  1  0  0
0 0.19 0.0361 0.55  0  0  0  1  0  0  0  0  0
0 0.19 0.0361 0.35  1  0  0  2  0  2  0  0  0
0 0.19 0.0361 0.15  1  0  0  1  0  0  0  0  0
0 0.19 0.0361 0.25  0  1  0  1  2  1  0  0  0
0 0.19 0.0361 0.55  1  0  0  2  0  0  0  0  0
0 0.19 0.0361 0.45  1  0  0  1  0  0  1  0  0
1 0.19 0.0361 0.45  0  0  0  1  1  0  0  0  0
0 0.19 0.0361 0.55  1  0  0  1  0  0  0  0  0
0 0.19 0.0361 0.45  0  0  0  0  0  0  0  0  0
1 0.19 0.0361 0.45  0  1  0  0  0  2  0  0  0
0 0.19 0.0361 0.75  1  0  0  0  0  1  0  0  0
0 0.19 0.0361 0.06  0  1  0  0  0  0  1  0  0
0 0.19 0.0361 0.15  0  0  0  0  0  5  0  0  0
0 0.19 0.0361 0.75  0  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.45  0  0  0  0  0  0  0  0  0
1 0.19 0.0361 0.25  0  1  0  0  0  0  0  0  0
1 0.19 0.0361 0.75  0  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.35  0  1  0  0  0  0  0  0  0
0 0.19 0.0361 0.25  0  1  0  0  0  0  0  0  0
1 0.19 0.0361 0.15  0  0  0  0  0  0  0  0  0
1 0.19 0.0361 0.55  0  0  0  0  0  0  0  0  0
1 0.19 0.0361 0.06  0  1  0  0  0  0  0  0  0
0 0.19 0.0361 0.45  1  0  0  0  0  0  0  0  0
1 0.19 0.0361 0.55  1  0  0  0  0  1  0  0  0
0 0.19 0.0361 0.35  0  0  0  0  0  0  0  0  0
1 0.19 0.0361 0.25  0  1  0  0  0  0  0  0  0
0 0.19 0.0361 0.15  0  0  0  0  0  1  0  0  0
0 0.19 0.0361 0.25  0  0  0  0  0  0  0  0  0
1 0.19 0.0361 0.55  0  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.45  0  0  0  0  0  0  1  0  0
0 0.19 0.0361 0.75  1  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.75  1  0  0  0  0  2  0  0  0
0 0.19 0.0361 0.15  0  0  0  0  0  2  0  0  0
1 0.19 0.0361 0.15  0  1  0  0  0  0  0  0  0
0 0.19 0.0361 0.25  0  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.45  0  0  0  0  0  0  1  0  0
0 0.19 0.0361 0.15  0  1  0  0  0  0  0  1  0
0 0.19 0.0361 0.45  0  0  0  0  0  4  0  0  0
0 0.19 0.0361 0.45  0  0  0  0  0  0  1  0  0
1 0.19 0.0361 0.45  0  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.65  0  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.15  0  1  0  0  0  7  0  0  0
0 0.19 0.0361 0.06  1  0  0  0  0  1  0  0  0
0 0.19 0.0361 0.15  0  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.45  0  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.55  0  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.15  1  0  0  0  0  0  1  0  0
1 0.19 0.0361 0.45  1  0  0  0  0  2  0  0  0
0 0.19 0.0361 0.35  0  0  0  0  0  0  0  0  0
1 0.19 0.0361 0.45  0  0  0  0  0  0  0  0  0
1 0.19 0.0361 0.25  1  0  0  0  0  2  0  0  0
0 0.19 0.0361 0.35  1  0  0  0  0  0  0  0  0
1 0.19 0.0361 1.10  0  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.65  1  0  0  0  0  0  0  0  0
1 0.19 0.0361 0.15  0  1  0  0  0  0  0  0  0
1 0.19 0.0361 0.75  0  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.35  0  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.45  0  0  0  0  0  0  0  0  0
1 0.19 0.0361 0.45  0  0  0  0  0  0  1  0  0
1 0.19 0.0361 0.00  0  1  0  0  0  0  0  0  0
0 0.19 0.0361 0.45  0  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.25  0  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.75  0  0  0  0  0  0  0  0  0
1 0.19 0.0361 0.65  1  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.25  1  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.55  0  0  0  0  0  0  0  0  0
1 0.19 0.0361 0.45  1  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.65  0  0  0  0  0  0  1  0  0
0 0.19 0.0361 0.00  0  1  0  0  0  0  0  0  0
0 0.19 0.0361 0.35  1  0  0  0  0  0  1  0  0
0 0.19 0.0361 0.55  0  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.55  1  0  0  0  0  1  0  0  0
0 0.19 0.0361 0.55  0  0  0  0  0  0  0  0  0
1 0.19 0.0361 0.15  0  1  0  0  0  0  0  0  0
1 0.19 0.0361 0.65  0  0  0  0  0  0  0  0  0
1 0.19 0.0361 0.35  0  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.90  0  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.15  1  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.55  0  1  0  0  0  3  0  0  0
0 0.19 0.0361 0.35  0  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.25  0  1  0  0  0  0  0  0  0
0 0.19 0.0361 0.15  0  1  0  0  0  1  0  0  0
1 0.19 0.0361 0.35  0  0  0  0  0  0  0  0  0
1 0.19 0.0361 0.35  1  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.06  0  0  0  0  0  1  0  0  0
0 0.19 0.0361 0.35  0  1  0  0  0  0  0  0  0
0 0.19 0.0361 0.25  0  1  0  0  0  0  0  0  0
0 0.19 0.0361 0.75  1  0  0  0  0  0  0  0  0
0 0.19 0.0361 0.06  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.06  0  0  0  1  0  2  1  0  0
0 0.22 0.0484 0.90  0  0  0  1  0  0  0  0  0
1 0.22 0.0484 0.75  1  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.90  1  0  0  3  0  0  0  0  0
0 0.22 0.0484 0.25  0  1  0  1  0  0  0  0  0
0 0.22 0.0484 0.75  0  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.90  0  0  0  2  0  0  0  0  0
1 0.22 0.0484 0.06  1  0  0  1  0  2  0  0  0
1 0.22 0.0484 0.15  0  0  0  1  0  5  1  0  0
0 0.22 0.0484 0.45  1  0  0  4  0  1  0  0  0
0 0.22 0.0484 0.55  1  0  0  1  0  3  1  0  0
1 0.22 0.0484 0.90  1  0  0  2  0  1  1  0  0
1 0.22 0.0484 0.55  1  0  0  3  0  4  0  1  0
1 0.22 0.0484 0.90  1  0  0  1  0  0  0  0  0
1 0.22 0.0484 0.15  0  1  0  1  0  2  0  0  0
0 0.22 0.0484 0.35  1  0  0  2  0  1  0  0  0
0 0.22 0.0484 0.75  0  0  0  1  0  0  0  0  0
0 0.22 0.0484 1.10  0  0  0  2  4  1  0  0  0
0 0.22 0.0484 0.65  1  0  0  2  0  2  0  0  0
0 0.22 0.0484 1.10  0  0  0  1  0  0  0  0  0
1 0.22 0.0484 0.90  1  0  0  1  0  4  1  0  0
0 0.22 0.0484 0.65  0  1  0  1  0  3  0  0  0
0 0.22 0.0484 0.55  0  0  0  1  0  3  0  0  0
0 0.22 0.0484 0.25  1  0  0  3  0  1  0  0  0
0 0.22 0.0484 1.10  0  0  0  1  0  2  1  0  0
1 0.22 0.0484 0.75  0  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.75  0  0  0  1  0  1  0  0  0
1 0.22 0.0484 0.25  0  1  0  2  0 11  1  0  0
0 0.22 0.0484 0.90  1  0  0  1  0  2  0  0  0
1 0.22 0.0484 0.55  1  0  0  2  0  0  0  0  0
1 0.22 0.0484 0.15  0  1  0  2  0  0  0  0  0
1 0.22 0.0484 0.55  0  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.25  1  0  0  2  0  5  1  0  0
1 0.22 0.0484 0.90  1  0  0  1  0  2  0  0  0
1 0.22 0.0484 0.65  1  0  0  1  0  2  0  0  0
0 0.22 0.0484 0.75  0  0  0  1  0  0  0  0  0
1 0.22 0.0484 0.55  1  0  0  3  0  0  1  0  0
0 0.22 0.0484 0.45  1  0  0  1  0  0  0  0  0
1 0.22 0.0484 0.75  1  0  0  1  0  1  0  0  0
1 0.22 0.0484 0.65  1  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.75  0  0  0  3  0  1  0  0  0
0 0.22 0.0484 0.90  0  0  0  1  0  0  0  0  0
1 0.22 0.0484 0.35  0  0  0  1  0  0  1  0  0
1 0.22 0.0484 0.35  0  0  0  2  1  0  1  0  0
0 0.22 0.0484 0.75  0  0  0  1  2  1  0  1  0
0 0.22 0.0484 0.15  0  1  0  1  0  2  0  0  0
0 0.22 0.0484 1.10  1  0  0  3  0  2  1  0  0
0 0.22 0.0484 0.55  0  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.90  1  0  0  2  0  2  1  0  0
0 0.22 0.0484 0.65  0  0  0  1  0  0  1  0  0
0 0.22 0.0484 1.50  0  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.55  1  0  0  4  0  0  0  0  0
0 0.22 0.0484 0.65  0  0  0  2  0  0  1  0  0
0 0.22 0.0484 0.90  0  0  0  2  0  0  0  0  0
0 0.22 0.0484 0.55  0  0  0  2  0  0  0  0  0
0 0.22 0.0484 0.75  0  0  0  1  0  1  1  0  0
0 0.22 0.0484 0.25  0  1  0  1  0  1  0  0  0
0 0.22 0.0484 0.35  0  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.75  1  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.15  0  0  0  1  0  0  0  0  0
0 0.22 0.0484 1.50  0  0  0  1  0  0  1  0  0
0 0.22 0.0484 0.15  1  0  0  1  0  0  0  0  0
0 0.22 0.0484 1.10  1  0  0  2  0  5  0  0  0
1 0.22 0.0484 0.15  1  0  0  1  0  1  0  0  0
0 0.22 0.0484 0.55  0  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.55  0  0  0  2  1  4  0  0  0
0 0.22 0.0484 0.90  1  0  0  1  0  1  1  0  0
1 0.22 0.0484 0.90  1  0  0  1  0  0  0  0  0
1 0.22 0.0484 0.00  1  0  0  1  0  0  0  0  0
0 0.22 0.0484 1.10  0  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.55  0  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.75  0  0  0  2  0  3  1  0  0
0 0.22 0.0484 0.15  0  1  0  1  0  0  0  0  0
0 0.22 0.0484 0.65  1  0  0  1  9  0  0  0  0
0 0.22 0.0484 0.25  1  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.55  0  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.55  0  1  0  1  0  1  1  0  0
0 0.22 0.0484 1.10  1  0  0  1  0  4  1  0  0
0 0.22 0.0484 0.65  0  0  0  1  0  0  0  0  0
0 0.22 0.0484 1.10  0  0  0  1  0  0  0  0  0
1 0.22 0.0484 0.45  1  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.90  0  0  0  3  2  0  0  1  0
0 0.22 0.0484 1.30  0  0  0  1  0  0  0  0  0
1 0.22 0.0484 0.65  1  0  0  3  0  1  0  0  0
0 0.22 0.0484 0.15  1  0  0  4  0  0  0  1  0
0 0.22 0.0484 0.90  0  0  0  1  0  1  1  0  0
1 0.22 0.0484 0.65  1  0  0  1  5  0  0  0  0
0 0.22 0.0484 0.65  0  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.55  1  0  0  4  0  0  0  0  0
0 0.22 0.0484 0.90  1  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.65  0  1  0  1  0  0  0  0  0
0 0.22 0.0484 0.90  0  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.90  0  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.55  0  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.90  0  0  1  2  0  0  0  0  0
0 0.22 0.0484 0.65  0  0  0  1  0  0  0  0  0
1 0.22 0.0484 0.25  0  0  0  3  0  0  0  1  0
1 0.22 0.0484 0.55  0  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.75  0  0  0  2  0  2  0  0  0
1 0.22 0.0484 0.35  1  0  0  1  0  1  1  0  0
0 0.22 0.0484 0.15  1  0  0  4  0  8  1  0  0
1 0.22 0.0484 0.75  0  0  0  3  1  0  1  0  0
0 0.22 0.0484 0.45  1  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.45  0  1  0  3  2  0  1  0  0
0 0.22 0.0484 0.75  1  0  0  2  0  0  0  0  0
0 0.22 0.0484 0.45  0  0  0  2  0  3  1  0  0
0 0.22 0.0484 0.90  0  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.75  0  0  0  1  0  0  0  1  0
0 0.22 0.0484 0.75  1  0  0  2  0  0  0  0  0
0 0.22 0.0484 0.55  0  1  0  2  0  0  0  0  0
0 0.22 0.0484 0.90  0  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.75  1  0  0  1  0  0  0  0  0
1 0.22 0.0484 0.75  0  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.15  1  0  0  1  0  2  0  0  0
0 0.22 0.0484 0.35  1  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.65  0  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.15  1  0  0  1  0  0  0  0  0
1 0.22 0.0484 0.45  1  0  0  1  0  0  1  0  0
0 0.22 0.0484 0.45  1  0  0  1  0  0  1  0  0
1 0.22 0.0484 0.90  0  0  0  2  0  0  0  0  0
0 0.22 0.0484 0.65  0  0  0  2  0  0  0  0  0
0 0.22 0.0484 0.90  1  0  0  1  0  1  1  0  0
0 0.22 0.0484 0.65  0  0  0  1  0  1  0  0  0
0 0.22 0.0484 0.65  0  0  0  2  0  4  1  0  0
1 0.22 0.0484 0.65  1  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.75  0  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.75  1  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.75  0  0  0  1  0  0  0  1  0
0 0.22 0.0484 0.25  0  1  0  1  0  0  1  0  0
0 0.22 0.0484 1.10  1  0  0  1  0  0  1  0  0
0 0.22 0.0484 0.90  1  0  0  1  0  0  0  0  0
0 0.22 0.0484 0.25  0  1  0  0  0  0  0  0  0
0 0.22 0.0484 0.25  0  1  0  0  0  8  0  0  0
0 0.22 0.0484 0.55  0  1  0  0  0  0  0  0  0
0 0.22 0.0484 0.35  0  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.35  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 1.10  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.65  1  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.65  1  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.25  0  0  1  0  0  5  0  0  0
0 0.22 0.0484 0.06  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.75  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 1.10  0  0  0  0  0  0  1  0  0
0 0.22 0.0484 0.25  0  0  0  0  0  1  0  0  0
0 0.22 0.0484 0.35  0  1  0  0  0  0  0  0  0
0 0.22 0.0484 0.75  1  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.75  0  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.35  0  1  0  0  0  0  0  0  0
0 0.22 0.0484 0.15  1  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.25  0  1  0  0  0  0  0  0  0
0 0.22 0.0484 0.75  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.06  1  0  0  0  0  1  0  0  0
0 0.22 0.0484 0.90  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.55  1  0  0  0  0  2  0  0  0
1 0.22 0.0484 0.90  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.15  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.65  1  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.00  1  0  0  0  0  0  1  0  0
0 0.22 0.0484 1.10  1  0  0  0  0  3  0  0  0
0 0.22 0.0484 0.45  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.90  0  0  0  0  0  4  0  0  0
0 0.22 0.0484 0.25  0  0  0  0  0  2  1  0  0
0 0.22 0.0484 1.10  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.55  0  1  0  0  0  0  0  0  0
0 0.22 0.0484 0.90  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.75  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.25  0  1  0  0  0  0  0  0  0
0 0.22 0.0484 0.25  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.65  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.75  1  0  0  0  0  6  0  0  0
1 0.22 0.0484 0.55  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.90  0  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.25  0  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.65  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 1.10  1  0  0  0  0  1  0  0  0
0 0.22 0.0484 0.35  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.45  0  1  0  0  0  0  0  0  0
0 0.22 0.0484 0.15  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.35  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.35  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.35  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.75  1  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.55  1  0  0  0  0  1  0  0  0
0 0.22 0.0484 0.45  0  0  0  0  0  5  0  0  0
0 0.22 0.0484 1.10  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 1.10  1  0  0  0  0  2  0  0  0
1 0.22 0.0484 0.35  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.55  0  0  0  0  0  3  0  0  0
0 0.22 0.0484 1.10  0  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.65  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.75  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.90  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.75  0  0  0  0  0  1  1  0  0
0 0.22 0.0484 0.55  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 1.10  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.55  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.35  0  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.01  0  1  0  0  0  2  0  1  0
0 0.22 0.0484 0.75  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.45  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.65  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.90  0  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.00  1  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.75  1  0  0  0  0  5  0  0  0
1 0.22 0.0484 0.45  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 1.10  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.65  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.55  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 1.10  0  0  1  0  0  0  0  0  0
0 0.22 0.0484 0.35  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.75  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.90  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.90  0  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.65  0  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.06  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.55  1  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.75  0  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.55  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.15  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.06  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.25  0  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.15  1  0  0  0  0  1  0  0  0
0 0.22 0.0484 0.55  0  1  0  0  0  0  0  0  0
0 0.22 0.0484 0.90  0  0  0  0  0  2  1  0  0
0 0.22 0.0484 0.25  0  1  0  0  0  2  0  0  0
0 0.22 0.0484 0.55  0  1  0  0  0  0  0  0  0
1 0.22 0.0484 1.10  1  0  0  0  0  0  1  0  0
0 0.22 0.0484 0.75  0  0  0  0  0  0  1  0  0
1 0.22 0.0484 0.65  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 1.30  1  0  0  0  0  1  0  0  0
0 0.22 0.0484 0.90  1  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.55  1  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.90  1  0  0  0  0  1  0  0  0
0 0.22 0.0484 0.55  0  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.75  1  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.25  0  0  0  0  0  6  0  0  0
0 0.22 0.0484 0.65  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.65  0  0  0  0  0  1  0  0  0
0 0.22 0.0484 0.25  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 1.30  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.75  0  0  0  0  0  1  0  0  0
0 0.22 0.0484 0.65  0  0  0  0  0  0  1  0  0
0 0.22 0.0484 0.45  1  0  0  0  0  0  1  0  0
0 0.22 0.0484 0.55  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.35  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.90  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.35  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 1.10  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 1.50  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 1.50  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.65  1  0  0  0  0  0  1  0  0
0 0.22 0.0484 1.10  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.90  1  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.75  0  1  0  0  0  0  0  0  0
0 0.22 0.0484 1.10  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.25  0  1  0  0  0  0  0  0  0
1 0.22 0.0484 0.90  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.90  0  0  0  0  0  0  1  0  0
0 0.22 0.0484 0.90  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 0.55  0  0  0  0  0  0  0  0  0
0 0.27 0.0729 1.30  0  0  0  1  0  0  1  0  0
0 0.27 0.0729 0.90  1  0  0  3  0  0  0  1  0
0 0.27 0.0729 0.55  0  0  0  1  0  0  0  0  0
1 0.27 0.0729 0.15  0  0  0  1  0  2  0  0  0
0 0.27 0.0729 0.15  0  1  0  2  0  6  0  0  0
1 0.27 0.0729 0.90  1  0  0  2  0  0  1  0  0
0 0.27 0.0729 0.90  1  0  0  2  0  0  0  1  0
1 0.27 0.0729 1.30  1  0  0  1  0  0  0  0  0
1 0.27 0.0729 1.30  1  0  0  1  0  1  0  0  0
0 0.27 0.0729 1.30  0  0  0  2  0  3  0  0  0
0 0.27 0.0729 1.30  1  0  0  2  0  4  1  0  0
0 0.27 0.0729 1.10  1  0  0  1  0  1  1  0  0
0 0.27 0.0729 1.10  0  0  0  1  0  0  1  0  0
0 0.27 0.0729 1.10  0  0  0  1  0  0  0  0  0
1 0.27 0.0729 1.30  0  0  0  3  0  6  1  0  0
0 0.27 0.0729 1.50  1  0  0  1  0  3  0  0  0
1 0.27 0.0729 0.90  1  0  0  1  0  5  0  0  0
1 0.27 0.0729 0.45  0  0  0  2  0  2  0  0  0
0 0.27 0.0729 1.10  0  0  0  1  0  2  0  0  0
0 0.27 0.0729 0.35  0  0  0  2  5 10  0  0  0
0 0.27 0.0729 0.75  1  0  0  2  0  1  1  0  0
0 0.27 0.0729 1.10  1  0  0  1  0  1  0  0  0
0 0.27 0.0729 0.90  1  0  0  1  0  0  0  0  0
0 0.27 0.0729 0.35  0  0  1  2  0  4  1  0  0
0 0.27 0.0729 1.30  1  0  0  1  0  0  0  0  0
0 0.27 0.0729 1.50  1  0  0  4  0  0  1  0  0
0 0.27 0.0729 0.25  0  0  1  1 14  0  0  1  0
0 0.27 0.0729 0.25  1  0  0  1  0  8  0  0  0
0 0.27 0.0729 1.50  0  0  0  5  0  3  1  0  0
0 0.27 0.0729 1.10  0  0  0  1  0  1  0  0  0
0 0.27 0.0729 0.90  0  0  0  2  0  0  0  0  0
0 0.27 0.0729 0.90  1  0  0  1  0  0  0  0  0
0 0.27 0.0729 1.50  0  0  0  1  0  3  0  0  0
1 0.27 0.0729 0.75  1  0  0  1  0  2  0  0  0
1 0.27 0.0729 0.90  0  0  0  1  1  0  0  0  0
1 0.27 0.0729 0.35  0  0  0  1  0  0  0  0  0
0 0.27 0.0729 0.75  1  0  0  1  0  0  0  0  0
0 0.27 0.0729 0.45  0  0  0  1  0  0  1  0  0
0 0.27 0.0729 0.65  1  0  0  1  0  0  0  0  0
0 0.27 0.0729 1.30  1  0  0  1  0  0  0  0  0
1 0.27 0.0729 0.45  1  0  0  2  0  1  1  0  0
0 0.27 0.0729 0.90  1  0  0  1  0  0  0  0  0
1 0.27 0.0729 0.25  0  0  1  1  0  0  0  0  0
0 0.27 0.0729 1.30  0  0  0  1  0  0  0  0  0
0 0.27 0.0729 0.55  0  0  0  1  0  3  0  0  0
0 0.27 0.0729 1.30  1  0  0  2  3  1  1  0  0
0 0.27 0.0729 0.35  0  0  0  1  2  0  0  0  0
1 0.27 0.0729 0.25  1  0  0  1  0  0  1  0  0
0 0.27 0.0729 0.15  0  1  0  5  0  2  1  0  0
0 0.27 0.0729 0.45  0  0  0  5  3  3  0  0  0
0 0.27 0.0729 0.90  1  0  0  1  1  2  1  0  0
0 0.27 0.0729 1.50  0  0  0  3  0  0  0  0  0
0 0.27 0.0729 0.75  0  0  0  1  0  0  0  0  0
0 0.27 0.0729 1.10  1  0  0  2  0  0  1  0  0
0 0.27 0.0729 0.75  0  0  0  2  0  4  1  0  0
0 0.27 0.0729 1.10  1  0  0  1  1  0  0  0  0
0 0.27 0.0729 0.75  0  0  0  1  0  0  1  0  0
0 0.27 0.0729 0.90  0  0  0  1  0  0  0  0  0
0 0.27 0.0729 1.50  0  0  0  1  0  0  0  0  0
0 0.27 0.0729 0.25  0  0  1  1  0  0  0  1  0
0 0.27 0.0729 0.90  1  0  0  1  0  0  0  1  0
0 0.27 0.0729 1.50  0  0  0  1  0  0  0  0  0
0 0.27 0.0729 0.90  0  0  0  1  0  1  0  0  0
0 0.27 0.0729 0.75  1  0  0  1  0  0  0  0  0
0 0.27 0.0729 0.65  0  0  0  1  0  0  0  0  0
0 0.27 0.0729 0.25  0  0  0  1  0  3  0  1  0
0 0.27 0.0729 1.10  0  0  0  1  0  0  0  1  0
0 0.27 0.0729 1.10  0  0  0  1  0  0  1  0  0
0 0.27 0.0729 0.90  0  0  0  0  0  0  0  0  0
0 0.27 0.0729 0.75  0  0  0  0  0  0  0  0  0
0 0.27 0.0729 0.90  0  0  0  0  0  5  0  0  0
0 0.27 0.0729 0.55  0  0  0  0  0  0  1  0  0
0 0.27 0.0729 0.06  0  0  0  0  0  0  0  0  0
0 0.27 0.0729 1.10  0  0  0  0  0  0  0  0  0
0 0.27 0.0729 1.30  0  0  0  0  0  1  0  0  0
0 0.27 0.0729 0.45  1  0  0  0  0  0  0  0  0
1 0.27 0.0729 0.90  1  0  0  0  0  0  0  0  0
0 0.27 0.0729 1.10  1  0  0  0  0  0  1  0  0
0 0.27 0.0729 0.75  0  0  0  0  0  0  0  0  0
0 0.27 0.0729 0.45  0  0  0  0  0  0  0  0  0
0 0.27 0.0729 1.30  1  0  0  0  0  0  1  0  0
1 0.27 0.0729 0.65  1  0  0  0  0  0  0  0  0
0 0.27 0.0729 0.75  1  0  0  0  0  0  0  0  0
0 0.27 0.0729 0.90  0  0  0  0  0  0  0  0  0
0 0.27 0.0729 0.75  0  0  0  0  0  1  0  0  0
0 0.27 0.0729 1.10  0  0  0  0  0  0  0  0  0
0 0.27 0.0729 1.10  0  0  0  0  0  0  0  0  0
1 0.27 0.0729 0.45  0  0  0  0  0  0  0  0  0
0 0.27 0.0729 0.75  0  0  0  0  0  0  0  0  0
0 0.27 0.0729 0.90  1  0  0  0  0  1  1  0  0
0 0.27 0.0729 0.90  0  0  0  0  0  0  0  0  0
1 0.27 0.0729 0.45  1  0  0  0  0  0  0  0  0
0 0.27 0.0729 0.90  1  0  0  0  0  0  1  0  0
0 0.27 0.0729 0.15  0  1  0  0  0  0  0  0  0
0 0.27 0.0729 0.35  0  0  0  0  0  0  0  0  0
0 0.27 0.0729 1.50  1  0  0  0  0  0  0  0  0
1 0.27 0.0729 0.90  0  0  0  0  0  0  0  0  0
0 0.27 0.0729 0.90  1  0  0  0  0  0  0  0  0
0 0.27 0.0729 0.45  0  0  0  0  0  1  0  0  0
1 0.27 0.0729 0.65  1  0  0  0  0  0  0  0  0
1 0.27 0.0729 0.55  1  0  0  0  0  0  0  0  0
1 0.27 0.0729 0.65  0  0  0  0  0  0  1  0  0
0 0.27 0.0729 0.90  1  0  0  0  0  0  0  0  0
0 0.27 0.0729 0.90  0  0  0  0  0  0  0  0  0
0 0.27 0.0729 1.10  0  0  0  0  0  0  0  0  0
0 0.27 0.0729 1.50  0  0  0  0  0  0  0  0  0
0 0.27 0.0729 1.50  1  0  0  0  0  0  0  0  0
0 0.27 0.0729 0.65  0  0  0  0  0  0  0  0  0
0 0.27 0.0729 0.65  0  0  0  0  0  0  1  0  0
0 0.27 0.0729 0.65  0  0  0  0  0  0  0  0  0
1 0.27 0.0729 0.55  1  0  0  0  0  2  0  0  0
0 0.27 0.0729 0.75  0  0  0  0  0  0  0  0  0
0 0.27 0.0729 0.65  1  0  0  0  0  0  0  0  0
0 0.27 0.0729 1.50  1  0  0  0  0  0  1  0  0
0 0.27 0.0729 0.90  0  0  0  0  0  0  0  0  0
0 0.27 0.0729 0.75  0  0  0  0  0  0  0  0  0
0 0.27 0.0729 0.90  0  0  0  0  0  0  0  0  0
0 0.27 0.0729 1.10  0  0  0  0  0  0  0  0  0
0 0.27 0.0729 0.35  0  0  0  0  0  0  0  0  0
0 0.27 0.0729 1.10  0  0  0  0  0  0  0  0  0
0 0.27 0.0729 1.10  1  0  0  0  0  1  1  0  0
0 0.27 0.0729 1.10  0  0  0  0  0  0  1  0  0
0 0.32 0.1024 1.50  1  0  0  3  0  5  0  1  0
0 0.32 0.1024 0.25  0  0  0  2  0  0  0  0  0
0 0.32 0.1024 1.30  0  0  0  1  0  0  1  0  0
0 0.32 0.1024 0.65  0  0  0  1  0  2  0  0  0
0 0.32 0.1024 1.50  1  0  0  1  0  0  0  0  0
0 0.32 0.1024 1.50  1  0  0  1  0  2  0  0  0
0 0.32 0.1024 1.10  0  0  0  2  0  0  0  0  0
0 0.32 0.1024 0.90  0  0  0  1  0  4  0  1  0
0 0.32 0.1024 0.90  1  0  0  1  0 10  1  0  0
0 0.32 0.1024 0.25  0  0  1  2  0  1  1  0  0
1 0.32 0.1024 0.00  0  1  0  3  0  8  1  0  0
1 0.32 0.1024 0.65  1  0  0  3  0  0  1  0  0
0 0.32 0.1024 0.55  1  0  0  2  1  0  0  0  0
1 0.32 0.1024 0.90  1  0  0  2  0  0  0  0  0
0 0.32 0.1024 1.10  0  0  0  2  0  0  1  0  0
0 0.32 0.1024 0.75  0  0  0  1  0  0  0  0  0
1 0.32 0.1024 0.55  1  0  0  1  0  0  1  0  0
1 0.32 0.1024 0.25  1  0  0  1  0  0  1  0  0
0 0.32 0.1024 0.25  1  0  0  2  1  0  0  0  0
0 0.32 0.1024 0.75  0  0  0  1  0 12  0  0  0
1 0.32 0.1024 1.30  1  0  0  1  2  2  0  0  0
0 0.32 0.1024 1.10  1  0  0  1  0  1  1  0  0
0 0.32 0.1024 1.10  1  0  0  1  0  1  0  0  0
0 0.32 0.1024 0.90  1  0  0  1  0  1  1  0  0
0 0.32 0.1024 1.50  1  0  0  1  1  0  1  0  0
0 0.32 0.1024 0.15  0  1  0  2  5  3  0  0  0
0 0.32 0.1024 0.75  0  0  0  2  0  1  1  0  0
0 0.32 0.1024 0.35  0  0  0  5  0  2  0  1  0
0 0.32 0.1024 1.50  0  0  0  1  0  0  0  0  0
0 0.32 0.1024 0.90  1  0  0  2  1  4  0  0  0
0 0.32 0.1024 0.90  0  0  0  1  0  6  0  0  0
0 0.32 0.1024 1.50  1  0  0  1  0  0  0  0  0
0 0.32 0.1024 1.30  0  0  0  1  0  0  0  0  0
0 0.32 0.1024 1.50  1  0  0  1  0  1  1  0  0
1 0.32 0.1024 0.65  1  0  0  2  0  0  0  0  0
0 0.32 0.1024 0.75  0  0  0  1  0  0  0  0  0
0 0.32 0.1024 0.75  0  0  0  2  0  0  0  0  0
0 0.32 0.1024 1.10  0  0  0  0  0  0  0  0  0
1 0.32 0.1024 1.10  1  0  0  0  0  2  0  0  0
0 0.32 0.1024 1.30  1  0  0  0  0  0  1  0  0
0 0.32 0.1024 0.75  1  0  0  0  0  0  0  0  0
0 0.32 0.1024 0.65  1  0  0  0  0  1  0  0  0
0 0.32 0.1024 1.50  1  0  0  0  0  0  0  0  0
1 0.32 0.1024 1.50  0  0  0  0  0  3  0  0  0
0 0.32 0.1024 0.75  0  0  0  0  0  0  1  0  0
0 0.32 0.1024 1.30  1  0  0  0  0  0  0  0  0
0 0.32 0.1024 1.30  1  0  0  0  0  0  0  0  0
0 0.32 0.1024 0.90  1  0  0  0  0  0  0  0  0
0 0.32 0.1024 0.45  1  0  0  0  0  0  0  0  0
0 0.32 0.1024 0.65  0  0  0  0  0  1  0  0  0
0 0.32 0.1024 1.10  1  0  0  0  0  0  0  0  0
0 0.32 0.1024 1.10  0  0  0  0  0  0  1  0  0
0 0.32 0.1024 0.55  1  0  0  0  0  0  0  0  0
1 0.32 0.1024 0.90  1  0  0  0  0  0  0  0  0
0 0.32 0.1024 1.10  0  0  0  0  0  1  0  0  0
1 0.32 0.1024 0.75  1  0  0  0  0  1  0  0  0
1 0.32 0.1024 0.65  0  0  0  0  0  0  0  0  0
0 0.32 0.1024 0.90  1  0  0  0  0  0  1  0  0
1 0.32 0.1024 0.65  1  0  0  0  0  0  1  0  0
0 0.32 0.1024 0.90  0  0  0  0  0  2  0  0  0
1 0.32 0.1024 0.65  1  0  0  0  0  0  0  0  0
0 0.32 0.1024 1.10  1  0  0  0  0  0  0  0  0
1 0.32 0.1024 0.90  1  0  0  0  0  0  0  0  0
0 0.32 0.1024 0.90  1  0  0  0  0  3  0  0  0
0 0.32 0.1024 0.55  1  0  0  0  0  0  0  0  0
0 0.32 0.1024 0.55  1  0  0  0  0  0  1  0  0
1 0.32 0.1024 1.30  1  0  0  0  0  0  0  0  0
0 0.32 0.1024 1.10  1  0  0  0  0  0  1  0  0
0 0.32 0.1024 0.75  1  0  0  0  0  0  0  0  0
0 0.32 0.1024 0.01  0  0  0  0  0  0  0  0  0
0 0.32 0.1024 0.90  0  0  0  0  0  0  0  0  0
0 0.32 0.1024 1.50  1  0  0  0  0  1  0  0  0
1 0.32 0.1024 0.35  0  0  0  0  0  0  0  0  0
1 0.37 0.1369 0.55  0  0  0  1  0  0  1  0  0
1 0.37 0.1369 0.90  0  0  0  1  0  0  0  0  0
0 0.37 0.1369 1.50  0  0  0  2  0  1  0  0  0
0 0.37 0.1369 0.25  1  0  0  1  0  1  0  0  0
1 0.37 0.1369 0.25  0  0  1  1  0  5  0  0  0
0 0.37 0.1369 1.50  1  0  0  1  0  5  1  0  0
0 0.37 0.1369 1.10  1  0  0  1  0  4  0  0  0
0 0.37 0.1369 0.90  0  0  0  1  0  0  1  0  0
0 0.37 0.1369 1.10  1  0  0  3  4  3  0  0  0
1 0.37 0.1369 0.55  0  0  0  1  0  2  0  0  0
0 0.37 0.1369 1.30  1  0  0  1  0  1  0  0  0
0 0.37 0.1369 0.90  0  0  0  1  0  0  0  0  0
0 0.37 0.1369 0.90  0  0  0  1  0  0  0  0  0
1 0.37 0.1369 1.50  1  0  0  1  3  0  0  0  0
0 0.37 0.1369 0.90  0  0  0  1  0  0  0  0  0
0 0.37 0.1369 1.50  1  0  0  2  0  1  0  0  0
0 0.37 0.1369 0.45  0  0  0  1  0  1  0  0  0
0 0.37 0.1369 0.15  1  0  0  3  0  0  1  0  0
0 0.37 0.1369 1.50  1  0  0  1  0  0  0  0  0
0 0.37 0.1369 0.75  0  0  0  0  0  1  0  0  0
0 0.37 0.1369 0.45  0  0  0  0  0  0  0  0  0
0 0.37 0.1369 0.75  1  0  0  0  0  0  0  0  0
0 0.37 0.1369 0.65  1  0  0  0  0  0  0  0  0
0 0.37 0.1369 1.30  0  0  0  0  0  0  1  0  0
0 0.37 0.1369 1.30  1  0  0  0  0  0  0  0  0
1 0.37 0.1369 0.65  1  0  0  0  0  0  1  0  0
0 0.37 0.1369 1.30  1  0  0  0  0  0  0  0  0
0 0.37 0.1369 0.65  0  0  0  0  0  0  0  0  0
1 0.37 0.1369 0.90  1  0  0  0  0  0  0  0  0
0 0.37 0.1369 1.50  0  0  0  0  0  0  0  0  0
0 0.37 0.1369 1.30  0  0  0  0  0  0  0  0  0
0 0.37 0.1369 1.30  0  0  0  0  0  0  1  0  0
1 0.37 0.1369 0.65  0  0  0  0  0  1  0  0  0
0 0.37 0.1369 1.10  0  0  0  0  0  0  1  0  0
0 0.37 0.1369 1.30  1  0  0  0  0  1  1  0  0
1 0.42 0.1764 0.65  0  0  0  1  0  7  0  0  0
0 0.42 0.1764 0.90  0  0  0  1  0  2  0  0  0
0 0.42 0.1764 0.25  0  0  0  1  2  0  0  0  0
0 0.42 0.1764 0.90  1  0  0  1  0  0  0  0  0
1 0.42 0.1764 0.90  1  0  0  3  0  0  1  0  0
1 0.42 0.1764 0.55  1  0  0  2  0  1  0  0  0
0 0.42 0.1764 0.90  0  0  0  1  0  1  0  0  0
1 0.42 0.1764 1.30  1  0  0  1  0  0  1  0  0
0 0.42 0.1764 1.50  1  0  0  1  0  1  0  0  0
0 0.42 0.1764 0.75  0  0  0  1  0  0  0  0  0
0 0.42 0.1764 0.90  0  0  0  1  0  0  1  0  0
0 0.42 0.1764 0.65  0  0  0  1  0  0  1  0  0
0 0.42 0.1764 1.30  0  0  0  3  0  1  1  0  0
1 0.42 0.1764 0.75  1  0  0  1  0  1  1  0  0
0 0.42 0.1764 0.45  1  0  0  2  0  1  0  1  0
0 0.42 0.1764 0.65  0  1  0  1  0  2  0  0  0
0 0.42 0.1764 1.10  0  0  0  1  0  0  0  0  0
0 0.42 0.1764 0.06  0  1  0  2  0  0  0  0  0
0 0.42 0.1764 0.45  0  0  0  1  0  0  0  0  0
1 0.42 0.1764 0.90  0  0  0  1  0  2  1  0  0
1 0.42 0.1764 0.90  0  0  0  0  0  0  0  0  0
0 0.42 0.1764 0.90  0  0  0  0  0  0  0  0  0
1 0.42 0.1764 0.06  0  1  0  0  1  1  0  0  0
0 0.42 0.1764 0.90  0  0  0  0  0  0  1  0  0
0 0.42 0.1764 1.10  0  0  0  0  0  0  1  0  0
0 0.42 0.1764 1.10  1  0  0  0  0  0  0  0  0
1 0.42 0.1764 0.75  1  0  0  0  0  0  0  0  0
0 0.42 0.1764 0.75  0  0  0  0  0  0  0  0  0
1 0.42 0.1764 0.25  0  0  0  0  0  0  1  0  0
0 0.42 0.1764 0.15  0  0  0  0  0  3  0  0  0
1 0.42 0.1764 1.30  0  0  0  0  0  0  0  0  0
0 0.47 0.2209 0.15  0  0  1  2  0  1  1  0  0
1 0.47 0.2209 0.55  1  0  0  2  0  0  1  0  0
1 0.47 0.2209 0.90  1  0  0  2  0  0  0  0  0
0 0.47 0.2209 1.30  0  0  0  2  0  4  1  0  0
0 0.47 0.2209 1.50  1  0  0  1  0  4  0  0  0
1 0.47 0.2209 0.90  1  0  0  1  0  0  1  0  0
1 0.47 0.2209 0.90  1  0  0  1  0  0  0  0  0
0 0.47 0.2209 0.90  1  0  0  1  0  0  0  0  0
0 0.47 0.2209 1.30  1  0  0  1  0  1  0  0  0
1 0.47 0.2209 0.75  0  0  0  1  0  0  0  0  0
1 0.47 0.2209 0.75  0  0  0  1  0  0  1  0  0
0 0.47 0.2209 0.55  0  0  0  1  0  0  0  0  0
0 0.47 0.2209 0.00  1  0  0  1  0  3  0  0  0
0 0.47 0.2209 1.10  0  0  0  1  0  0  0  0  0
0 0.47 0.2209 1.50  1  0  0  1  0  1  0  1  0
1 0.47 0.2209 0.75  0  0  0  1  0  0  0  0  0
0 0.47 0.2209 0.90  1  0  0  2  0  0  1  0  0
0 0.47 0.2209 1.10  1  0  0  0  0  0  0  0  0
1 0.47 0.2209 0.00  0  0  0  0  0  0  0  0  0
0 0.47 0.2209 0.90  0  0  0  0  0  0  0  0  0
1 0.47 0.2209 0.75  1  0  0  0  0  0  0  0  0
0 0.47 0.2209 0.90  0  0  0  0  0  0  0  0  0
0 0.47 0.2209 0.15  0  0  0  0  0  0  0  0  0
0 0.47 0.2209 0.75  0  0  0  0  0  0  0  0  0
0 0.47 0.2209 1.10  1  0  0  0  0  0  1  0  0
0 0.47 0.2209 0.90  0  0  0  0  0  0  0  0  0
0 0.47 0.2209 1.10  1  0  0  0  0  0  0  0  0
0 0.47 0.2209 0.45  1  0  0  0  0  0  1  0  0
1 0.47 0.2209 1.10  1  0  0  0  0  0  1  0  0
0 0.47 0.2209 0.90  0  0  0  0  0  0  0  0  0
1 0.47 0.2209 0.35  1  0  0  0  0  0  1  0  0
0 0.47 0.2209 1.10  0  0  0  0  0  0  0  0  0
0 0.47 0.2209 0.65  0  0  0  0  0  1  0  0  0
0 0.47 0.2209 0.65  1  0  0  0  0  0  0  0  0
1 0.47 0.2209 1.50  1  0  0  0  0  0  0  0  0
1 0.47 0.2209 1.10  1  0  0  0  0  0  0  0  0
0 0.47 0.2209 0.90  0  0  0  0  0  0  1  0  0
0 0.47 0.2209 0.75  0  0  0  0  0  0  0  0  0
0 0.47 0.2209 1.50  1  0  0  0  0  0  0  0  0
0 0.47 0.2209 1.50  1  0  0  0  0  1  0  0  0
1 0.47 0.2209 1.50  1  0  0  0  0  0  0  0  0
0 0.47 0.2209 0.90  1  0  0  0  0  0  0  0  0
0 0.52 0.2704 0.55  0  0  0  4  0  3  1  0  0
0 0.52 0.2704 0.65  0  0  0  2  0  2  0  0  0
0 0.52 0.2704 0.35  0  0  0  1  0  1  1  0  0
0 0.52 0.2704 0.25  0  0  1  2  0  0  0  1  0
0 0.52 0.2704 0.90  0  0  0  1  0  1  0  0  0
1 0.52 0.2704 0.90  0  0  0  1  0  0  0  0  0
1 0.52 0.2704 0.75  1  0  0  1  0  0  0  0  0
1 0.52 0.2704 0.25  0  0  1  2  0  0  1  0  0
0 0.52 0.2704 1.10  0  0  0  2  0  0  0  0  0
0 0.52 0.2704 0.75  0  0  0  2  0  0  1  0  0
1 0.52 0.2704 0.25  0  0  1  1  0  0  1  0  0
0 0.52 0.2704 1.10  1  0  0  1  0  0  1  0  0
1 0.52 0.2704 1.10  1  0  0  1  0  0  0  0  0
1 0.52 0.2704 1.50  1  0  0  3  0  0  0  0  0
0 0.52 0.2704 1.10  1  0  0  1  0  0  1  0  0
0 0.52 0.2704 1.10  1  0  0  1  0  0  0  0  0
1 0.52 0.2704 1.50  1  0  0  0  0  0  0  0  0
1 0.52 0.2704 0.45  0  0  0  0  0  2  1  0  0
0 0.52 0.2704 0.90  1  0  0  0  0  0  0  0  0
1 0.52 0.2704 0.45  1  0  0  0  0  0  0  0  0
0 0.52 0.2704 1.10  1  0  0  0  0  0  0  0  0
1 0.52 0.2704 0.25  1  0  0  0  0  0  0  0  0
0 0.52 0.2704 0.75  1  0  0  0  0  0  1  0  0
0 0.52 0.2704 1.10  1  0  0  0  0  1  1  0  0
1 0.52 0.2704 0.65  1  0  0  0  0  0  0  0  0
0 0.52 0.2704 0.75  0  0  0  0  1  0  0  0  0
0 0.52 0.2704 0.35  1  0  0  0  0  0  0  0  0
0 0.52 0.2704 0.25  0  1  0  0  0  0  0  0  0
1 0.52 0.2704 1.10  0  0  0  0  0  1  0  0  0
0 0.52 0.2704 1.50  1  0  0  0  0  0  0  0  0
1 0.52 0.2704 0.25  0  0  1  0  0  0  0  0  0
1 0.52 0.2704 1.50  1  0  0  0  0  0  0  0  0
0 0.52 0.2704 0.65  0  0  0  0  0  0  0  0  0
0 0.52 0.2704 0.90  0  0  0  0  0  0  0  0  0
1 0.57 0.3249 0.25  0  0  1  3  6  1  0  0  0
1 0.57 0.3249 0.00  1  0  0  2  0  4  0  0  0
1 0.57 0.3249 0.90  1  0  0  1  0  0  1  0  0
0 0.57 0.3249 0.90  1  0  0  1  0  2  0  0  0
1 0.57 0.3249 0.15  0  0  1  2  0  4  0  0  0
1 0.57 0.3249 0.35  0  0  1  1  0  0  0  0  0
1 0.57 0.3249 0.25  0  0  1  1  0  0  0  0  0
1 0.57 0.3249 0.90  1  0  0  1  0  0  1  0  0
1 0.57 0.3249 0.25  0  0  1  2  1  0  0  0  0
1 0.57 0.3249 0.25  0  0  1  1  0  0  0  0  0
0 0.57 0.3249 0.65  1  0  0  2  0  0  1  0  0
0 0.57 0.3249 0.35  0  0  0  2  0  6  1  0  0
0 0.57 0.3249 0.65  0  0  0  3  0  2  0  0  0
0 0.57 0.3249 0.65  0  0  0  1  0  4  0  0  0
1 0.57 0.3249 0.75  1  0  0  2  0  0  1  0  0
1 0.57 0.3249 0.25  0  0  1  1  0  1  0  0  0
0 0.57 0.3249 0.90  0  0  0  1  2  0  0  0  0
0 0.57 0.3249 0.90  0  0  0  2  0  0  1  0  0
1 0.57 0.3249 0.15  0  0  1  2  0  0  1  0  0
1 0.57 0.3249 0.75  1  0  0  2  0  1  1  0  0
1 0.57 0.3249 1.30  1  0  0  3  0  0  1  0  0
1 0.57 0.3249 0.06  1  0  0  2  0  1  1  0  0
0 0.57 0.3249 0.90  0  0  0  1  0  0  0  0  0
1 0.57 0.3249 0.25  1  0  0  0  0  0  0  0  0
1 0.57 0.3249 0.45  1  0  0  0  0  1  0  0  0
1 0.57 0.3249 0.45  0  0  0  0  0  0  0  0  0
0 0.57 0.3249 0.90  1  0  0  0  0  0  0  0  0
1 0.57 0.3249 0.15  0  0  1  0  0  0  0  0  0
0 0.57 0.3249 1.50  1  0  0  0  0  0  0  0  0
0 0.57 0.3249 1.50  0  0  0  0  0  0  0  0  0
1 0.57 0.3249 0.15  0  0  1  0  0  0  0  0  0
0 0.57 0.3249 0.65  1  0  0  0  0  0  0  0  0
1 0.57 0.3249 0.35  1  0  0  0  0  0  0  0  0
1 0.57 0.3249 0.45  1  0  0  0  0  0  1  0  0
1 0.57 0.3249 0.35  0  0  1  0  0  1  0  0  0
0 0.57 0.3249 0.45  0  0  0  0  0  0  0  0  0
1 0.57 0.3249 0.90  0  0  0  0  0  0  0  0  0
1 0.57 0.3249 0.15  1  0  0  0  0  0  0  0  0
0 0.57 0.3249 0.90  1  0  0  0  0  0  1  0  0
1 0.57 0.3249 0.25  0  0  1  0  0  0  0  1  0
1 0.57 0.3249 0.25  1  0  0  0  0  0  1  0  0
1 0.57 0.3249 0.65  0  0  0  0  0  0  1  0  0
1 0.57 0.3249 0.25  0  0  1  0  0  0  1  0  0
1 0.57 0.3249 0.25  0  0  1  0  0  1  1  0  0
0 0.57 0.3249 0.25  0  0  0  0  0  0  0  0  0
0 0.57 0.3249 0.90  1  0  0  0  0  0  0  0  0
0 0.62 0.3844 0.90  1  0  0  4  0  1  0  0  0
1 0.62 0.3844 0.25  1  0  0  1  0  0  0  0  0
1 0.62 0.3844 0.35  0  0  0  1  0  0  0  0  0
1 0.62 0.3844 0.25  0  0  1  2  0  0  1  0  0
1 0.62 0.3844 0.15  0  0  1  3  0  2  0  1  0
0 0.62 0.3844 0.45  0  0  1  2  0  3  1  0  0
1 0.62 0.3844 0.25  0  0  1  2  0  0  1  0  0
0 0.62 0.3844 1.10  0  0  0  1  0  5  0  0  0
0 0.62 0.3844 0.25  0  0  1  4  0  1  0  1  0
1 0.62 0.3844 0.00  0  0  0  1  0  0  0  0  0
1 0.62 0.3844 0.45  1  0  0  1  0  0  1  0  0
0 0.62 0.3844 0.35  0  0  0  2  0  0  0  0  0
1 0.62 0.3844 0.25  1  0  0  1  0  0  1  0  0
1 0.62 0.3844 0.25  1  0  0  3  0  7  1  0  0
1 0.62 0.3844 0.25  0  0  1  1  0  1  1  0  0
0 0.62 0.3844 0.35  0  0  0  4  0  2  0  1  0
0 0.62 0.3844 0.65  0  0  0  1  0  0  1  0  0
0 0.62 0.3844 0.25  0  0  1  1  0  0  0  1  0
0 0.62 0.3844 0.65  1  0  0  1  0  0  0  0  0
1 0.62 0.3844 0.25  1  0  0  1  0  0  1  0  0
1 0.62 0.3844 0.35  1  0  0  1  0  2  0  0  0
1 0.62 0.3844 0.25  0  0  1  1  0  0  0  0  0
0 0.62 0.3844 0.25  0  0  1  5  0  1  0  1  0
1 0.62 0.3844 0.25  1  0  0  0  0  0  1  0  0
1 0.62 0.3844 1.10  1  0  0  0  0  0  1  0  0
1 0.62 0.3844 0.25  1  0  0  0  0  0  0  0  0
1 0.62 0.3844 0.15  1  0  0  0  0  0  0  0  0
1 0.62 0.3844 0.25  0  0  1  0  0  0  0  0  0
0 0.62 0.3844 0.90  0  0  0  0  0  0  0  1  0
1 0.62 0.3844 0.25  0  0  1  0  0  0  0  0  0
0 0.62 0.3844 0.90  0  0  0  0  0  0  0  0  0
1 0.62 0.3844 0.25  0  1  0  0  0  0  1  0  0
0 0.62 0.3844 0.90  1  0  0  0  0  0  0  0  0
1 0.62 0.3844 0.25  0  0  1  0  0  0  0  0  0
0 0.62 0.3844 0.75  0  0  0  0  0  2  1  0  0
0 0.62 0.3844 1.50  1  0  0  0  0  0  0  1  0
0 0.62 0.3844 1.50  1  0  0  0  0  0  0  0  0
1 0.62 0.3844 0.25  0  0  1  0  0  0  0  0  0
0 0.62 0.3844 0.45  0  0  0  0  0  0  0  0  0
1 0.62 0.3844 0.65  1  0  0  0  0  0  0  0  0
0 0.62 0.3844 0.25  0  0  1  0  0  0  1  0  0
1 0.62 0.3844 0.75  1  0  0  0  0  1  0  0  0
1 0.62 0.3844 0.75  0  0  0  0  0  0  0  0  0
1 0.67 0.4489 0.55  1  0  0  1  1  0  0  0  0
1 0.67 0.4489 0.25  0  0  1  2  2  0  1  0  0
1 0.67 0.4489 0.90  1  0  0  1  0  3  0  0  0
1 0.67 0.4489 0.25  1  0  0  2  0  2  0  0  0
1 0.67 0.4489 0.25  1  0  0  2  0  0  1  0  0
1 0.67 0.4489 0.25  0  0  1  1  0  1  0  0  0
1 0.67 0.4489 1.50  1  0  0  2  0  0  0  0  0
1 0.67 0.4489 0.35  0  0  1  1  0  4  0  0  0
1 0.67 0.4489 0.25  0  0  1  1  0  0  1  0  0
0 0.67 0.4489 0.25  1  0  0  4  7  3  1  0  0
1 0.67 0.4489 0.25  1  0  0  2  0  0  1  0  0
0 0.67 0.4489 0.35  0  0  1  2  0  1  1  0  0
0 0.67 0.4489 0.25  0  0  1  2  0  0  0  0  0
0 0.67 0.4489 0.25  0  0  1  2  0  1  0  0  0
1 0.67 0.4489 0.25  0  0  1  5  0  4  1  0  0
1 0.67 0.4489 0.25  0  0  1  1  0  0  0  0  0
1 0.67 0.4489 0.25  0  0  1  2  0  0  1  0  0
1 0.67 0.4489 0.25  0  0  1  3  0  3  1  0  0
0 0.67 0.4489 0.45  1  0  0  2  0  0  0  0  0
1 0.67 0.4489 0.25  0  0  1  2  0  3  1  0  0
0 0.67 0.4489 0.45  1  0  0  1  0  0  1  0  0
1 0.67 0.4489 0.25  0  0  1  2  0  0  0  0  0
1 0.67 0.4489 0.25  0  0  1  0  0  0  0  0  0
0 0.67 0.4489 0.45  1  0  0  0  0  0  1  0  0
1 0.67 0.4489 0.35  0  0  1  0  0  7  0  0  0
0 0.67 0.4489 0.35  0  0  0  0  0  0  0  0  0
0 0.67 0.4489 0.25  0  0  1  0  0  0  0  0  0
0 0.67 0.4489 0.25  0  0  1  0  0  0  0  0  0
0 0.67 0.4489 0.25  0  0  1  0  0  0  0  0  0
1 0.67 0.4489 0.55  1  0  0  0  0  0  0  0  0
1 0.67 0.4489 0.15  0  0  1  0  0  5  0  0  0
0 0.67 0.4489 1.10  1  0  0  0  0  0  1  0  0
0 0.67 0.4489 0.65  1  0  0  0  0  0  0  0  0
0 0.67 0.4489 0.90  1  0  0  0  0  0  0  0  0
1 0.67 0.4489 0.25  0  0  1  0  0  4  0  0  0
0 0.67 0.4489 0.25  0  0  1  0  0  1  0  0  0
0 0.67 0.4489 0.35  0  0  0  0  0  0  0  0  0
1 0.67 0.4489 0.25  0  0  1  0  0  0  0  0  0
1 0.67 0.4489 0.35  1  0  0  0  0  0  0  0  0
1 0.67 0.4489 0.25  0  0  1  0  0  0  0  0  0
1 0.67 0.4489 0.06  1  0  0  0  0  1  0  0  0
1 0.67 0.4489 0.25  1  0  0  0  0  0  0  0  0
1 0.67 0.4489 0.65  1  0  0  0  0  0  0  0  0
1 0.67 0.4489 0.25  0  0  1  0  0  0  0  0  0
0 0.67 0.4489 0.25  0  0  1  0  0  0  1  0  0
1 0.67 0.4489 0.45  1  0  0  0  0  0  0  0  0
1 0.67 0.4489 0.90  1  0  0  0  0  0  0  0  0
1 0.67 0.4489 1.50  1  0  0  0  0  0  0  0  0
0 0.67 0.4489 0.35  0  0  1  0  0  0  0  0  0
1 0.67 0.4489 0.35  0  0  1  0  0  0  1  0  0
1 0.67 0.4489 0.35  0  0  1  0  0  0  0  0  0
0 0.67 0.4489 0.65  0  0  0  0  0  0  1  0  0
1 0.72 0.5184 0.45  0  0  1  1  0  0  0  0  0
1 0.72 0.5184 0.25  0  0  1  5  0  3  1  0  0
1 0.72 0.5184 0.25  1  0  0  1  0  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  2  0  4  1  0  0
1 0.72 0.5184 0.25  0  0  1  3  0  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  2  0  1  1  0  0
1 0.72 0.5184 0.25  0  0  1  4  0  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  1  0  0  0  1  0
0 0.72 0.5184 0.25  0  0  1  1  0  0  1  0  0
0 0.72 0.5184 0.35  0  0  1  1  2  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  3  0  3  0  1  0
1 0.72 0.5184 0.25  0  0  1  1  0  2  1  0  0
0 0.72 0.5184 0.25  0  0  1  3  0  0  1  0  0
1 0.72 0.5184 0.15  0  0  1  1  0  0  1  0  0
0 0.72 0.5184 1.50  1  0  0  1  0  0  1  0  0
1 0.72 0.5184 0.45  1  0  0  1  0  0  1  0  0
0 0.72 0.5184 0.75  0  0  1  5  0  5  0  0  0
1 0.72 0.5184 0.25  0  0  1  2  0  3  0  0  0
0 0.72 0.5184 0.45  1  0  0  3  0  0  1  0  0
0 0.72 0.5184 0.55  0  0  1  1  0  1  1  0  0
0 0.72 0.5184 0.25  0  0  1  1  0  0  0  0  0
1 0.72 0.5184 0.25  0  0  1  3  0  0  1  0  0
1 0.72 0.5184 0.55  1  0  0  1  0  0  0  0  0
1 0.72 0.5184 0.65  1  0  0  1  0  0  1  0  0
1 0.72 0.5184 0.25  1  0  0  1  0  0  1  0  0
1 0.72 0.5184 0.15  0  0  1  1  0  0  1  0  0
1 0.72 0.5184 0.75  1  0  0  1  0  1  1  0  0
1 0.72 0.5184 0.65  1  0  0  2  0  2  0  0  0
1 0.72 0.5184 0.45  1  0  0  1  0  0  0  0  0
1 0.72 0.5184 0.25  0  0  1  2  0  0  1  0  0
0 0.72 0.5184 0.55  0  0  0  1  0  1  1  0  0
0 0.72 0.5184 0.25  0  0  1  1  0  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  1  0  0  0  0  0
0 0.72 0.5184 0.25  0  0  1  1  0  0  0  0  0
1 0.72 0.5184 1.30  0  0  1  2  0  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  2  0  0  0  1  0
1 0.72 0.5184 0.25  0  0  1  1  0  0  1  0  0
0 0.72 0.5184 0.90  1  0  0  1  0  0  1  0  0
1 0.72 0.5184 0.25  1  0  0  4  0  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  1  0  0  1  0  0
1 0.72 0.5184 0.25  0  0  1  1  0  0  0  1  0
1 0.72 0.5184 0.25  1  0  0  3  0  0  0  1  0
1 0.72 0.5184 0.25  0  0  1  0  0  1  1  0  0
1 0.72 0.5184 0.25  0  0  0  0  0  0  1  0  0
1 0.72 0.5184 0.35  0  0  1  0  0  0  0  0  0
1 0.72 0.5184 0.35  0  0  1  0  0  4  0  0  0
1 0.72 0.5184 0.25  0  0  1  0  0  0  0  0  0
1 0.72 0.5184 0.25  1  0  0  0  0  0  0  0  0
1 0.72 0.5184 1.10  1  0  0  0  0  0  0  0  0
0 0.72 0.5184 1.50  1  0  0  0  0  3  0  0  0
1 0.72 0.5184 0.25  0  0  1  0  0  0  0  0  0
0 0.72 0.5184 0.25  0  0  1  0  0  0  0  0  0
1 0.72 0.5184 0.25  1  0  0  0  0  0  0  0  0
1 0.72 0.5184 0.55  1  0  0  0  0  0  0  0  0
1 0.72 0.5184 0.25  1  0  0  0  0  0  0  0  0
1 0.72 0.5184 0.25  1  0  0  0  0  0  0  0  0
1 0.72 0.5184 0.25  1  0  0  0  0  0  0  0  0
1 0.72 0.5184 0.25  1  0  0  0  0  0  0  0  0
1 0.72 0.5184 0.55  1  0  0  0  0  0  1  0  0
1 0.72 0.5184 0.35  1  0  0  0  0  0  0  0  0
1 0.72 0.5184 0.25  0  0  1  0  0  0  0  0  0
1 0.72 0.5184 0.25  0  0  1  0  0  1  0  0  0
1 0.72 0.5184 0.25  0  0  1  0  0  0  0  0  0
0 0.72 0.5184 0.55  0  0  1  0  0  0  0  0  0
0 0.72 0.5184 0.25  0  0  1  0  0  0  0  0  0
1 0.72 0.5184 0.35  0  0  1  0  0  0  0  0  0
0 0.19 0.0361 0.25  0  1  0  1  0  1  0  0  0
0 0.19 0.0361 0.75  0  0  0  1  0  0  0  0  0
1 0.19 0.0361 0.45  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 1.10  0  0  0  0  0  0  0  0  0
0 0.22 0.0484 1.50  0  0  0  0  0  0  0  0  0
1 0.22 0.0484 0.55  0  0  0  0  0  0  0  0  0
0 0.27 0.0729 1.30  0  0  0  0  0  1  0  0  0
1 0.37 0.1369 0.25  0  0  1  1  0  1  0  0  0
1 0.52 0.2704 0.65  0  0  0  0  0  0  0  0  0
0 0.72 0.5184 0.25  0  0  1  0  0  0  0  0  0
;

proc logistic data=docvisit;
   model dvisits = sex age agesq income levyplus
                   freepoor freerepa illness actdays hscore
                   chcond1 chcond2;
run;

proc logistic data=docvisit;
   model dvisits = sex age agesq income levyplus
                   freepoor freerepa illness actdays hscore
                   chcond1 chcond2 / unequalslopes;
   sex:      test sex_0     =sex_1;
   age:      test age_0     =age_1;
   agesq:    test agesq_0   =agesq_1;
   income:   test income_0  =income_1;
   levyplus: test levyplus_0=levyplus_1;
   freepoor: test freepoor_0=freepoor_1;
   freerepa: test freerepa_0=freerepa_1;
   illness:  test illness_0 =illness_1;
   actdays:  test actdays_0 =actdays_1;
   hscore:   test hscore_0  =hscore_1;
   chcond1:  test chcond1_0 =chcond1_1;
   chcond2:  test chcond2_0 =chcond2_1;
run;

proc logistic data=docvisit;
   model dvisits= sex age agesq income levyplus freepoor
         freerepa illness actdays hscore chcond1 chcond2
   / unequalslopes=(actdays agesq income);
run;

proc logistic data=docvisit;
   model dvisits= sex age agesq income levyplus freepoor
         freerepa illness actdays hscore chcond1 chcond2
   / equalslopes unequalslopes selection=stepwise details;
run;

data a;
   label p='Pr>ChiSq';
   format p 8.6;
   input Test $10. ChiSq1 DF1 ChiSq2 DF2;
   ChiSq= ChiSq1-ChiSq2;
   DF= DF1-DF2;
   p=1-probchi(ChiSq,DF);
   keep Test Chisq DF p;
   datalines;
Gen vs PO     761.4797 24    734.2971 12
PPO vs PO     752.5512 15    734.2971 12
Gen vs PPO    761.4797 24    752.5512 15
;

proc print data=a label noobs;
   var Test ChiSq DF p;
run;



/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: LOGIEX13                                            */
/*   TITLE: Example 13 for PROC LOGISTIC                        */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: logistic regression analysis,                       */
/*          conditional logistic regression analysis,           */
/*          exact conditional logistic regression analysis,     */
/*          binomial response data,                             */
/*   PROCS: LOGISTIC                                            */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: Bob Derr                                            */
/*     REF: SAS/STAT User's Guide, PROC LOGISTIC chapter        */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

/*****************************************************************
Example 13. Firth's Penalized Likelihood Compared to Other Approaches
*****************************************************************/

/*
Firth's penalized likelihood approach is a method for addressing issues of
separability, small sample sizes, and bias of the parameter estimates.

This example compares results obtained from a 2x2 table where one cell has
zero frequencies.  This is an example of a quasi-completely separated data
set.
*/

title 'Example 13. Firth''s Penalized Likelihood Compared to Other Approaches';

%let beta0=-15;
%let beta1=16;
data one;
   keep sample X y pry;
   do sample=1 to 10/*1000*/;
      do i=1 to 100;
         X=rantbl(987987,.4,.6)-1;
         xb= &beta0 + X*&beta1;
         exb=exp(xb);
         pry= exb/(1+exb);
         cut= ranuni(393993);
         if (pry < cut) then y=1; else y=0;
         output;
      end;
   end;
run;

ods exclude all;
proc logistic data=one;
   by sample;
   class X(param=ref);
   model y(event='1')=X / firth clodds=pl;
   ods output cloddspl=firth;
run;
proc logistic data=one exactonly;
   by sample;
   class X(param=ref);
   model y(event='1')=X;
   exact X / estimate=odds;
   ods output exactoddsratio=exact;
run;
ods select all;
proc means data=firth;
   var LowerCL OddsRatioEst UpperCL;
run;
proc means data=exact;
   var LowerCL Estimate UpperCL;
run;


/*
This example compares results on case-control data.

Due to the exact analyses, this program takes a long time and a lot of
resources to run.  You may want to reduce the number of samples generated.
*/

%let beta0=1;
%let beta1=2;
data one;
   do sample=1 to 3/*1000*/;
      do pair=1 to 20;
         ran=ranuni(939393);
         a=3*ranuni(9384984)-1;
         pdf0= pdf('NORMAL',a,.4,1);
         pdf1= pdf('NORMAL',a,1,1);
         pry0= pdf0/(pdf0+pdf1);
         pry1= 1-pry0;
         xb= log(pry0/pry1);
         x= (xb-&beta0*pair/100) / &beta1;
         y=0;
         output;
         x= (-xb-&beta0*pair/100) / &beta1;
         y=1;
         output;
      end;
   end;
run;

ods exclude all;
proc logistic data=one;
   by sample;
   class pair / param=ref;
   model y=x pair / clodds=pl;
   ods output cloddspl=oru;
run;
data oru;
   set oru;
   if Effect='x';
   rename lowercl=lclu uppercl=uclu oddsratioest=orestu;
run;
proc logistic data=one;
   by sample;
   strata pair;
   model y=x / clodds=wald;
   ods output cloddswald=orc;
run;
data orc;
   set orc;
   if Effect='x';
   rename lowercl=lclc uppercl=uclc oddsratioest=orestc;
run;
proc logistic data=one exactonly;
   by sample;
   strata pair;
   model y=x;
   exact x / estimate=both;
   ods output ExactOddsRatio=ore;
run;
proc logistic data=one;
   by sample;
   class pair / param=ref;
   model y=x pair / firth clodds=pl;
   ods output cloddspl=orf;
run;
data orf;
   set orf;
   if Effect='x';
   rename lowercl=lclf uppercl=uclf oddsratioest=orestf;
run;
data all;
   merge oru orc ore orf;
run;
ods select all;
proc means data=all;
run;

