

/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: PRINCGS                                             */
/*   TITLE: Getting Started Example for PROC PRINCOMP           */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: multivariate analysis                               */
/*   PROCS: PRINCOMP                                            */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: saswfk                UPDATE: July 25, 2010         */
/*     REF: PROC PRINCOMP, Getting Started Example              */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

title 'Crime Rates per 100,000 Population by State';

data Crime;
   input State $1-15 Murder Rape Robbery Assault
         Burglary Larceny Auto_Theft;
   datalines;
Alabama        14.2 25.2  96.8 278.3 1135.5 1881.9 280.7
Alaska         10.8 51.6  96.8 284.0 1331.7 3369.8 753.3
Arizona         9.5 34.2 138.2 312.3 2346.1 4467.4 439.5
Arkansas        8.8 27.6  83.2 203.4  972.6 1862.1 183.4
California     11.5 49.4 287.0 358.0 2139.4 3499.8 663.5
Colorado        6.3 42.0 170.7 292.9 1935.2 3903.2 477.1
Connecticut     4.2 16.8 129.5 131.8 1346.0 2620.7 593.2
Delaware        6.0 24.9 157.0 194.2 1682.6 3678.4 467.0
Florida        10.2 39.6 187.9 449.1 1859.9 3840.5 351.4
Georgia        11.7 31.1 140.5 256.5 1351.1 2170.2 297.9
Hawaii          7.2 25.5 128.0  64.1 1911.5 3920.4 489.4
Idaho           5.5 19.4  39.6 172.5 1050.8 2599.6 237.6
Illinois        9.9 21.8 211.3 209.0 1085.0 2828.5 528.6
Indiana         7.4 26.5 123.2 153.5 1086.2 2498.7 377.4
Iowa            2.3 10.6  41.2  89.8  812.5 2685.1 219.9
Kansas          6.6 22.0 100.7 180.5 1270.4 2739.3 244.3
Kentucky       10.1 19.1  81.1 123.3  872.2 1662.1 245.4
Louisiana      15.5 30.9 142.9 335.5 1165.5 2469.9 337.7
Maine           2.4 13.5  38.7 170.0 1253.1 2350.7 246.9
Maryland        8.0 34.8 292.1 358.9 1400.0 3177.7 428.5
Massachusetts   3.1 20.8 169.1 231.6 1532.2 2311.3 1140.1
Michigan        9.3 38.9 261.9 274.6 1522.7 3159.0 545.5
Minnesota       2.7 19.5  85.9  85.8 1134.7 2559.3 343.1
Mississippi    14.3 19.6  65.7 189.1  915.6 1239.9 144.4
Missouri        9.6 28.3 189.0 233.5 1318.3 2424.2 378.4
Montana         5.4 16.7  39.2 156.8  804.9 2773.2 309.2
Nebraska        3.9 18.1  64.7 112.7  760.0 2316.1 249.1
Nevada         15.8 49.1 323.1 355.0 2453.1 4212.6 559.2
New Hampshire   3.2 10.7  23.2  76.0 1041.7 2343.9 293.4
New Jersey      5.6 21.0 180.4 185.1 1435.8 2774.5 511.5
New Mexico      8.8 39.1 109.6 343.4 1418.7 3008.6 259.5
New York       10.7 29.4 472.6 319.1 1728.0 2782.0 745.8
North Carolina 10.6 17.0  61.3 318.3 1154.1 2037.8 192.1
North Dakota    0.9  9.0  13.3  43.8  446.1 1843.0 144.7
Ohio            7.8 27.3 190.5 181.1 1216.0 2696.8 400.4
Oklahoma        8.6 29.2  73.8 205.0 1288.2 2228.1 326.8
Oregon          4.9 39.9 124.1 286.9 1636.4 3506.1 388.9
Pennsylvania    5.6 19.0 130.3 128.0  877.5 1624.1 333.2
Rhode Island    3.6 10.5  86.5 201.0 1489.5 2844.1 791.4
South Carolina 11.9 33.0 105.9 485.3 1613.6 2342.4 245.1
South Dakota    2.0 13.5  17.9 155.7  570.5 1704.4 147.5
Tennessee      10.1 29.7 145.8 203.9 1259.7 1776.5 314.0
Texas          13.3 33.8 152.4 208.2 1603.1 2988.7 397.6
Utah            3.5 20.3  68.8 147.3 1171.6 3004.6 334.5
Vermont         1.4 15.9  30.8 101.2 1348.2 2201.0 265.2
Virginia        9.0 23.3  92.1 165.7  986.2 2521.2 226.7
Washington      4.3 39.6 106.2 224.8 1605.6 3386.9 360.3
West Virginia   6.0 13.2  42.2  90.9  597.4 1341.7 163.3
Wisconsin       2.8 12.9  52.2  63.7  846.9 2614.2 220.7
Wyoming         5.4 21.9  39.7 173.9  811.6 2772.2 282.0
;


ods graphics on;

proc princomp out=Crime_Components plots= score(ellipse ncomp=3);
   id State;
run;

*--- Analyzing Mean Temperatures of US Cities---*;


/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: PRINCEX1                                            */
/*   TITLE: Documentation Example 1 for PROC PRINCOMP           */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: multivariate analysis                               */
/*   PROCS: PRINCOMP                                            */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: saswfk                UPDATE: July 25, 2010         */
/*     REF: PROC PRINCOMP, Example 1                            */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

data Temperature;
   length CityId $ 2;
   title 'Mean Temperature in January and July for Selected Cities';
   input City $ 1-15 January July;
   CityId = substr(City,1,2);
   datalines;
Mobile          51.2 81.6
Phoenix         51.2 91.2
Little Rock     39.5 81.4
Sacramento      45.1 75.2
Denver          29.9 73.0
Hartford        24.8 72.7
Wilmington      32.0 75.8
Washington DC   35.6 78.7
Jacksonville    54.6 81.0
Miami           67.2 82.3
Atlanta         42.4 78.0
Boise           29.0 74.5
Chicago         22.9 71.9
Peoria          23.8 75.1
Indianapolis    27.9 75.0
Des Moines      19.4 75.1
Wichita         31.3 80.7
Louisville      33.3 76.9
New Orleans     52.9 81.9
Portland, ME    21.5 68.0
Baltimore       33.4 76.6
Boston          29.2 73.3
Detroit         25.5 73.3
Sault Ste Marie 14.2 63.8
Duluth           8.5 65.6
Minneapolis     12.2 71.9
Jackson         47.1 81.7
Kansas City     27.8 78.8
St Louis        31.3 78.6
Great Falls     20.5 69.3
Omaha           22.6 77.2
Reno            31.9 69.3
Concord         20.6 69.7
Atlantic City   32.7 75.1
Albuquerque     35.2 78.7
Albany          21.5 72.0
Buffalo         23.7 70.1
New York        32.2 76.6
Charlotte       42.1 78.5
Raleigh         40.5 77.5
Bismarck         8.2 70.8
Cincinnati      31.1 75.6
Cleveland       26.9 71.4
Columbus        28.4 73.6
Oklahoma City   36.8 81.5
Portland, OR    38.1 67.1
Philadelphia    32.3 76.8
Pittsburgh      28.1 71.9
Providence      28.4 72.1
Columbia        45.4 81.2
Sioux Falls     14.2 73.3
Memphis         40.5 79.6
Nashville       38.3 79.6
Dallas          44.8 84.8
El Paso         43.6 82.3
Houston         52.1 83.3
Salt Lake City  28.0 76.7
Burlington      16.8 69.8
Norfolk         40.5 78.3
Richmond        37.5 77.9
Spokane         25.4 69.7
Charleston, WV  34.5 75.0
Milwaukee       19.4 69.9
Cheyenne        26.6 69.1
;

title 'Mean Temperature in January and July for Selected Cities';
proc sgplot data=Temperature;
   scatter x=July y=January / datalabel=CityId;
run;

ods graphics on;

title 'Mean Temperature in January and July for Selected Cities';
proc princomp data=Temperature cov plots=score(ellipse);
   var July January;
   id CityId;
run;

*--- Analyzing Rankings of US College Basketball Teams---*;


/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: PRINCEX2                                            */
/*   TITLE: Documentation Example 2 for PROC PRINCOMP           */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: multivariate analysis                               */
/*   PROCS: PRINCOMP                                            */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: saswfk                UPDATE: July 25, 2010         */
/*     REF: PROC PRINCOMP, Example 2                            */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

/*-----------------------------------------------------------*/
/*                                                           */
/* Pre-season 1985 College Basketball Rankings               */
/* (rankings of 35 teams by 10 news services)                */
/*                                                           */
/* Note: (a) news services rank varying numbers of teams;    */
/*       (b) not all teams are ranked by all news services;  */
/*       (c) each team is ranked by at least one service;    */
/*       (d) rank 20 is missing for UPI.                     */
/*                                                           */
/*-----------------------------------------------------------*/

data HoopsRanks;
   input School $13. CSN DurSun DurHer WashPost USAToday
         Sport InSports UPI AP SI;
   label CSN      = 'Community Sports News (Chapel Hill, NC)'
         DurSun   = 'Durham Sun'
         DurHer   = 'Durham Morning Herald'
         WashPost = 'Washington Post'
         USAToday = 'USA Today'
         Sport    = 'Sport Magazine'
         InSports = 'Inside Sports'
         UPI      = 'United Press International'
         AP       = 'Associated Press'
         SI       = 'Sports Illustrated'
         ;
   format CSN--SI 5.1;
   datalines;
Louisville     1  8  1  9  8  9  6 10  9  9
Georgia Tech   2  2  4  3  1  1  1  2  1  1
Kansas         3  4  5  1  5 11  8  4  5  7
Michigan       4  5  9  4  2  5  3  1  3  2
Duke           5  6  7  5  4 10  4  5  6  5
UNC            6  1  2  2  3  4  2  3  2  3
Syracuse       7 10  6 11  6  6  5  6  4 10
Notre Dame     8 14 15 13 11 20 18 13 12  .
Kentucky       9 15 16 14 14 19 11 12 11 13
LSU           10  9 13  . 13 15 16  9 14  8
DePaul        11  . 21 15 20  . 19  .  . 19
Georgetown    12  7  8  6  9  2  9  8  8  4
Navy          13 20 23 10 18 13 15  . 20  .
Illinois      14  3  3  7  7  3 10  7  7  6
Iowa          15 16  .  . 23  .  . 14  . 20
Arkansas      16  .  .  . 25  .  .  .  . 16
Memphis State 17  . 11  . 16  8 20  . 15 12
Washington    18  .  .  .  .  .  . 17  .  .
UAB           19 13 10  . 12 17  . 16 16 15
UNLV          20 18 18 19 22  . 14 18 18  .
NC State      21 17 14 16 15  . 12 15 17 18
Maryland      22  .  .  . 19  .  .  . 19 14
Pittsburgh    23  .  .  .  .  .  .  .  .  .
Oklahoma      24 19 17 17 17 12 17  . 13 17
Indiana       25 12 20 18 21  .  .  .  .  .
Virginia      26  . 22  .  . 18  .  .  .  .
Old Dominion  27  .  .  .  .  .  .  .  .  .
Auburn        28 11 12  8 10  7  7 11 10 11
St. Johns     29  .  .  .  . 14  .  .  .  .
UCLA          30  .  .  .  .  .  . 19  .  .
St. Joseph's   .  . 19  .  .  .  .  .  .  .
Tennessee      .  . 24  .  . 16  .  .  .  .
Montana        .  .  . 20  .  .  .  .  .  .
Houston        .  .  .  . 24  .  .  .  .  .
Virginia Tech  .  .  .  .  .  . 13  .  .  .
;


/* PROC MEANS is used to output a data set containing the      */
/* maximum value of each of the newspaper and magazine         */
/* rankings.  The output data set, maxrank, is then used       */
/* to set the missing values to the next highest rank plus     */
/* thirty-six, divided by two (that is, the mean of the        */
/* missing ranks).  This ad hoc method of replacing missing    */
/* values is based more on intuition than on rigorous          */
/* statistical theory.  Observations are weighted by the       */
/* number of nonmissing values.                                */
/*                                                             */

title 'Pre-Season 1985 College Basketball Rankings';
proc means data=HoopsRanks;
   output out=MaxRank
          max=CSNMax DurSunMax DurHerMax
              WashPostMax USATodayMax SportMax
              InSportsMax UPIMax APMax SIMax;
run;

data Basketball;
   set HoopsRanks;
   if _n_=1 then set MaxRank;
   array Services{10} CSN--SI;
   array MaxRanks{10} CSNMax--SIMax;
   keep School CSN--SI Weight;
   Weight=0;
   do i=1 to 10;
      if Services{i}=. then Services{i}=(MaxRanks{i}+36)/2;
      else Weight=Weight+1;
   end;
run;


ods graphics on;

proc princomp data=Basketball n=1 out=PCBasketball standard
              plots=patternprofile;
   var CSN--SI;
   weight Weight;
run;

proc sort data=PCBasketball;
   by Prin1;
run;

proc print;
   var School Prin1;
   title 'Pre-Season 1985 College Basketball Rankings';
   title2 'College Teams as Ordered by PROC PRINCOMP';
run;

*--- Analyzing Job Ratings of Police Officers---*;


/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: PRINCEX3                                            */
/*   TITLE: Documentation Example 3 for PROC PRINCOMP           */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: multivariate analysis                               */
/*   PROCS: PRINCOMP                                            */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: saswfk                UPDATE: July 25, 2010         */
/*     REF: PROC PRINCOMP, Example 3                            */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

options validvarname=any;
data Jobratings;
   input 'Communication Skills'n         'Problem Solving'n
         'Learning Ability'n             'Judgment Under Pressure'n
         'Observational Skills'n         'Willingness to Confront Problems'n
         'Interest in People'n           'Interpersonal Sensitivity'n
         'Desire for Self-Improvement'n  'Appearance'n
         'Dependability'n                'Physical Ability'n
         'Integrity'n                    'Overall Rating'n;
   datalines;
2 6 8 3 8 8 5 3 8 7 9 8 6 7 7 4 7 5 8 8 7 6 8 5 7 6 6 7 5 6 7 5 7 8 6 3 7 7 5
8 7 5 6 7 8 6 9 7 7 7 9 8 8 9 9 7 9 9 9 9 7 7 9 8 8 7 8 8 8 8 8 9 8 9 7 8 9 9
8 8 8 7 9 9 8 9 9 9 9 8 8 9 8 9 9 7 9 8 8 7 7 9 4 7 9 8 4 6 8 8 8 6 3 5 6 5 2
3 3 5 1 4 3 1 1 3 8 9 8 8 8 8 7 9 5 7 6 8 6 7 7 6 5 5 7 8 9 9 4 4 6 3 9 7 9 7
8 8 9 9 9 8 8 9 8 9 8 9 7 6 7 6 6 6 7 7 5 9 8 8 8 8 7 7 6 6 7 6 7 6 7 7 9 6 7
7 6 3 8 3 9 9 3 2 5 8 8 8 5 6 2 5 7 3 8 8 1 1 2 8 4 9 1 5 8 8 8 7 9 9 6 6 7 9
7 9 8 8 8 7 9 7 9 8 7 7 9 5 9 6 7 9 8 7 9 8 9 9 7 5 8 7 8 7 9 8 9 9 8 8 9 9 8
8 8 9 8 8 8 8 7 8 8 7 6 7 6 5 6 8 7 6 7 7 8 8 8 8 9 8 8 8 8 9 9 8 9 9 8 8 8 8
9 9 8 8 8 7 8 9 8 8 6 7 6 4 6 5 7 7 3 8 4 7 7 6 7 8 7 7 8 7 8 8 7 9 9 9 9 7 7
6 8 8 8 8 6 6 7 6 8 6 6 7 6 7 6 7 8 6 6 5 7 4 6 7 7 6 3 3 4 2 4 4 7 6 6 6 4 8
5 5 6 5 6 5 6 7 6 5 7 8 5 7 6 6 5 4 5 6 6 6 7 6 5 6 5 8 6 6 5 6 6 5 5 5 6 6 6
5 6 7 7 5 8 8 8 8 9 9 8 8 8 6 8 8 8 7 8 9 8 9 9 9 9 9 8 9 8 7 9 9 9 8 8 8 9 9
9 9 8 9 9 8 9 9 5 7 5 5 4 7 7 6 4 6 8 8 7 8 5 3 6 8 7 7 7 7 7 9 7 8 8 7 6 8 6
6 6 7 1 6 4 7 5 7 6 7 7 8 7 7 8 8 8 9 7 9 8 9 9 7 6 7 3 6 4 7 6 7 5 6 5 8 4 6
7 7 6 7 8 8 6 5 8 8 6 7 6 7 6 8 6 9 8 9 5 5 6 6 9 9 9 8 5 5 5 4 6 8 6 6 6 6 3
8 8 6 6 8 8 8 8 9 9 9 9 9 8 9 8 9 9 7 7 8 7 8 8 8 7 9 8 9 9 9 7 6 6 7 7 8 9 9
7 9 9 9 9 7 4 4 7 5 4 6 8 7 8 7 7 7 8 7 7 7 8 7 6 6 7 8 7 9 8 8 8 8 7 6 6 6 8
7 7 8 7 9 9 7 9 7 5 7 6 5 3 6 3 4 3 6 1 5 4 3 7 6 7 7 7 7 4 5 6 5 3 6 5 6 7 6
7 6 6 6 6 5 6 5 6 6 7 6 8 8 8 8 8 8 8 8 8 7 8 7 8 9 8 8 9 7 7 8 8 8 8 6 9 7 7
8 5 8 8 9 4 8 8 8 7 4 7 8 8 6 5 8 6 7 4 5 6 5 4 7 3 6 7 6 7 6 7 7 7 7 6 7 7 7
7 7 7 7 7 7 7 8 8 8 7 8 7 8 9 7 9 8 9 8 9 8 9 9 8 7 9 9 9 8 6 8 6 6 7 2 9 9 1
1 4 7 4 7 1 3 9 8 8 8 9 9 7 6 9 9 9 9 8 8 8 8 7 8 6 8 5 6 6 6 7 7 4 8 7 7 8 6
8 8 8 7 8 9 7 8 8 9 9 9 9 9 9 9 8 6 9 9 9 9 9 9 4 6 6 8 8 5 8 7 6 1 6 8 8 6 6
6 7 5 5 7 7 8 4 8 6 7 7 6 8 7 7 7 7 7 8 8 8 8 9 7 9 7 6 5 6 6 6 6 5 6 5 4 5 9
7 6 7 3 5 7 4 4 8 8 8 8 7 6 8 7 7 4 7 5 5 5 5 6 5 8 6 5 9 6 7 6 6 7 7 7 7 8 7
8 9 7 9 7 8 7 8 7 8 7 4 6 7 7 7 6 6 7 8 6 7 7 6 9 5 5 8 7 4 8 7 7 7 7 8 8 8 7
6 7 7 7 8 6 7 8 6 5 7 7 8 7 8 7 7 7 8 9 9 7 5 8 7 8 6 8 8 7 7 8 7 9 8 7 6 5 7
8 7 7 6 6 6 7 6 7 7 8 8 6 7 7 7 8 7 5 4 6 8 7 7 7 6 7 7 8 8 8 7 7 7 5 7 7 7 7
7 7 7 7 8 9 6 7 8 5 5 8 6 7 6 7 8 8 7 8 7 6 7 6 7 7 7 7 2 4 7 8 6 5 8 5 5 3 5
8 6 6 4 6 5 3 2 3 4 3 5 4 2 5 3 3 3 5 5 6 6 7 6 6 6 7 6 7 8 4 1 1 2 3 1 2 1 4
2 1 1 2 1 1 7 6 8 8 6 5 8 8 5 3 6 8 8 7 5 7 7 8 4 7 8 8 6 8 8 5 8 9 5 6 6 6 7
7 6 6 4 6 5 6 6 6 6 6 7 8 7 7 7 8 7 7 8 8 9 8 7 7 6 8 7 9 9 8 8 7 7 9 9 7 7 6
6 6 8 8 8 8 5 4 6 6 7 6 6 6 4 7 7 9 8 7 5 8 9 9 9 8 8 6 7 8 8 9 7 6 8 8 4 5 9
7 7 7 8 6 8 7 6 5 7 8 5 4 7 7 9 9 9 8 8 8 8 8 9 8 7 8 8 8 6 5 9 4 8 9 3 3 8 8
6 4 5 7 9 9 9 9 9 8 7 7 9 8 8 8 9 8 9 6 6 3 6 7 3 6 8 7 6 5 8 7 9 8 6 7 6 8 8
7 7 9 8 9 6 8 8 7 8 7 8 8 7 7 8 9 8 9 7 9 8 8 8 9 7 8 8 8 8 8 8 7 8 8 9 9 9 9
7 8 9 9 7 9 9 7 9 9 9 9 8 9 9 8 9 9 8 9 9 8 9 9 7 6 6 5 6 3 9 9 5 6 7 4 8 6
;

ods graphics on;

proc princomp data=Jobratings(drop='Overall Rating'n);
run;

proc princomp data=Jobratings(drop='Overall Rating'n)
              n=5 plots(ncomp=3)=all;
run;

