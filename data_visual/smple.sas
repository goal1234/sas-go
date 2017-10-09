/*  SAS/GRAPH chapter 23, sample 20: GR23N20 */

   /* set the graphics environment */
goptions reset=global gunit=pct border
         ftext=swissb htitle=6 htext=3;

   /* set the default graphics device */
goptions device=ps300 rotate=landscape ;

   /* create data set REGIONS */
data regions;
   length region state $ 8;
   format sales dollar8.;
   input region state sales;
   cards;
West    CA  13636
West    OR  18988
West    WA  14523
Central IL  18038
Central IN  13611
Central OH  11084
Central MI  19660
South   FL  14541
South   GA  19022
;
run;

   /* define title and footnote for chart */
title 'US Sales Goal:  $15,000';
footnote j=r 'GR23N20  ';

   /* define axis characteristics */
axis width=3;

   /* define pattern characteristics */
pattern1 value=l1 color=black;
pattern2 value=x1 color=black;
pattern3 value=r1 color=black;

   /* generate vertical bar chart */
proc gchart data=regions  ;
   vbar state
        / frame
          sumvar=sales
          group=region
          nozeros
          ref=15000
          patternid=group
          width=6
          space=0
          gspace=0
          clipref
          gaxis=axis
          raxis=axis;
   label sales='Sales';
run;


/* SAS/GRAPH chapter 31, sample7: GR31N07 */

   /* set the graphics environment */
goptions reset=global gunit=pct border
         ftext=swissb htitle=6 htext=3;

   /* set the graphics device */
goptions device=ps300 rotate=landscape ;

   /* create the data set STOCKS */
data stocks;
   input year @15 high;
   cards;
1954  31DEC54  404.39  11JAN54  279.87
1955  30DEC55  488.40  17JAN55  388.20
1956  06APR56  521.05  23JAN56  462.35
more data lines
1985  16DEC85 1553.10  04JAN85 1184.96
1986  02DEC86 1955.57  22JAN86 1502.29
1987  25AUG87 2722.42  19OCT87 1738.74
;
run;

   /* define titles and footnote */
title1 'Dow Jones Industrial Average Highs';
title2 h=4 '1954 to 1987';

footnote j=l ' Source: 1988 World Almanac'
         j=r 'GR31N07  ';

   /* define symbol characteristics */
symbol1 color=black interpol=join value=dot height=2;

   /* generate plot of two variables */
proc gplot data=stocks  ;
   plot high*year / haxis=1952 to 1988 by 4
                    vaxis=200 to 2800 by 200
                    hminor=3
                    vminor=1
                    vref=1000
                    lvref=2;
run;

/* SAS/GRAPH chapter 31, sample 8: GR31N08 */

   /* set the graphics environment */
goptions reset=global gunit=pct border
         ftext=swissb htitle=6 htext=3;

   /* set the graphics device */
goptions device=ps300 rotate=landscape ;

   /* create the data set STOCKS */
data stocks;
   input year @15 high @32 low;
   cards;
1954  31DEC54  404.39  11JAN54  279.87
1955  30DEC55  488.40  17JAN55  388.20
1956  06APR56  521.05  23JAN56  462.35
more data lines
1985  16DEC85 1553.10  04JAN85 1184.96
1986  02DEC86 1955.57  22JAN86 1502.29
1987  25AUG87 2722.42  19OCT87 1738.74
;
run;

   /* define titles and footnotes */
title1 'Dow Jones Industrial Average';
title2 height=4 'Highs and Lows From 1954 to 1987';
footnote1 f=special h=6 'J J J'
          f=swissb h=3 '   High'
          f=special h=4 '   D D D'
          f=swissb h=3 '   Low';
footnote2 j=l ' Source: 1988 World Almanac'
          j=r 'GR31N08  ';

   /* define symbol characteristics */
symbol1 color=black interpol=join value=dot height=2;
symbol2 color=black interpol=join value=diamond height=3;

   /* define axis characteristics */
axis1 order=(1952 to 1988 by 4)
      label=none
      major=(height=2)
      minor=(number=3 height=1)
      offset=(2)
      width=3;
axis2 order=(200 to 2800 by 200)
      label=none
      major=(height=2)
      minor=(number=1 height=1)
      width=3;

   /* generate two plots */
proc gplot data=stocks  ;
   plot high*year low*year / overlay
                             haxis=axis1
                             vaxis=axis2;
run;


/* SAS/GRAPH chapter 31, sample 5: GR39N05 */

   /* set the graphics environment */
goptions reset=global gunit=pct border
         ftext=swissb htitle=6 htext=3;

   /* set the graphics device */
goptions device=ps300 rotate=landscape ;

   /* create the data set CITYTEMP */
data citytemp;
   input  date  date7.
          month
          season
          f1     /* Raleigh, North Carolina */
          f2     /* Minneapolis, Minnesota  */
          f3;    /* Phoenix, Arizona        */

      /* restructure data so that there is */
      /* one observation for each city     */
   drop date season f1-f3;
   faren=f1; city='Raleigh'; output;
   faren=f2; city='Minn'; output;
   faren=f3; city='Phoenix'; output;
   cards;
01JAN83  1    1   40.5  12.2  52.1
01FEB83  2    1   42.2  16.5  55.1
01MAR83  3    2   49.2  28.3  59.7
01APR83  4    2   59.5  45.1  67.7
01MAY83  5    2   67.4  57.1  76.3
01JUN83  6    3   74.4  66.9  84.6
01JUL83  7    3   77.5  71.9  91.2
01AUG83  8    3   76.5  70.2  89.1
01SEP83  9    4   70.6  60.0  83.8
01OCT83  10   4   60.2  50.0  72.2
01NOV83  11   4   50.0  32.4  59.8
01DEC83  12   1   41.2  18.6  52.5
;
run;

   /* define titles and footnotes */
title1 'Average Monthly Temperature';
title2 h=4  'Minneapolis, Phoenix, and Raleigh';
footnote1 j=l ' Source: 1984 American Express';
footnote2 j=l '            Appointment Book'
          j=r 'GR31N10  ';

   /* define symbol characteristics */
symbol1 color=black interpol=spline width=2 value=triangle
        height=3;
symbol2 color=black interpol=spline width=2 value=circle
        height=3;
symbol3 color=black interpol=spline width=2 value=square
        height=3;

   /* define axis characteristics */
axis1 label=none
      value=('JAN' 'FEB' 'MAR' 'APR' 'MAY' 'JUN'
             'JUL' 'AUG' 'SEP' 'OCT' 'NOV' 'DEC')
      offset=(2)
      width=3;
axis2 label=('Degrees' justify=right 'Fahrenheit')
      order=(0 to 100 by 10)
      width=3;

   /* generate a plot of three variables */
   /* that produces a legend             */
proc gplot data=citytemp  ;
   plot faren*month=city / haxis=axis1
                           vaxis=axis2
                           hminor=0
                           vminor=1
                           frame;
run;

/* SAS/GRAPH chapter 39, sample 3: GR39N03 */

   /* set the graphics environment */
goptions reset=global gunit=pct border
         ftext=swissb htitle=6 htext=3;

   /* set the graphics device */
goptions device=ps300 rotate=landscape ;

   /* create the data set HAT */
data hat;
   do x=-5 to 5 by .25;
      do y=-5 to 5 by .25;
         z=sin(sqrt(x*x+y*y));
         output;
      end;
   end;
run;

   /* define title and footnote for plot */
title 'Surface Plot of HAT Data Set';
footnote j=r 'GR39N03  ';

   /* show the plot */
proc g3d  ;
   plot y*x=z
        / grid
          rotate=45
          yticknum=5
          zticknum=5
          zmin=-3
          zmax=1
          caxis=black cbottom=black ctop=black ;
run;

/* SAS/GRAPH chapter 39, sample 5: GR39N05 */

   /* set the graphics environment */
goptions reset=global gunit=pct border
         ftext=swissb htitle=6 htext=3;

   /* set the graphics device */
goptions device=ps300 rotate=landscape ;

   /* create data set IRIS */
data iris;
   length species $12. colorval $8. shapeval $8.;
   input sepallen sepalwid petallen petalwid spec_no;
   if spec_no=1 then do;
      species='setosa';
      shapeval='club';
      colorval='black';
   end;
   if spec_no=2 then do;
      species='versicolor';
      shapeval='diamond';
      colorval='black';
   end;
   if spec_no=3 then do;
      species='virginica';
      shapeval='spade';
      colorval='black'  ;
   end;
   sizeval=sepalwid/30;
   cards;
50 33 14 02 1
64 28 56 22 3
65 28 46 15 2
more data lines 
67 30 50 17 2
63 33 60 25 3
53 37 15 02 1
;
run;

   /* define titles and footnotes for graph */
title1 'Iris Species Classification';
title2 'Physical Measurement';
title3 'Source: Fisher (1936) Iris Data';
footnote1 j=l '  Petallen: Petal Length in mm.'
          j=r 'Petalwid: Petal Width in mm.  ';
footnote2 j=l '  Sepallen: Sepal Length in mm.'
          j=r 'Sepal Width not shown         ';
footnote3 j=r 'GR39N05(a)  ';

   /* show the graph using NOTE statement for legend */
proc g3d data=iris  ;
   scatter petallen*petalwid=sepallen
           / color=colorval
             shape=shapeval
             caxis=black ;

      /* create a legend using NOTE statements */
   note;
   note j=r f=special h=2 'B' f=swissb ' Species: Virginica      '
        j=r f=special h=2 'D' f=swissb '          Versicolor     '
        j=r f=special h=2 'E' f=swissb '          Setosa        ';
run;


/* SAS/GRAPH chapter 29, sample 9: GR29N09 */

   /* set the graphics environment */
goptions reset=global gunit=pct border
         ftext=swissb htitle=6 htext=3;

   /* set the graphics device */
goptions device=ps300 rotate=landscape ;

   /* create response data set SITES */
data sites;
   length state 3;
   input state sites;
   cards;
 1        80
 2        31
 4        92
more data lines 
54        44
55       197
56        59
;
run;

   /* create format SITESFMT */
proc format;
   value sitesfmt low-100='0-100'
                  101-400='101-400'
                  401-700='401-700'
                 701-1000='701-1000'
                1001-high='over 1000';
run;

   /* define titles and footnotes for map */
title1 'Products Installed in the USA';
title2 h=4 'XXX Corp.';
footnote1 j=l '  US map data set supplied'
          ' with SAS/GRAPH' '02'x ' Software';
footnote2 j=r 'GR29N09  ';

   /* define pattern characteristics */
pattern1 value=mempty color=black;
pattern2 value=m1n45  color=black;
pattern3 value=m1x45  color=black;
pattern4 value=m1n135 color=black;
pattern5 value=msolid color=black;

   /* define legend characteristics */
legend value=(j=l) frame;

   /* display the choropleth map */
proc gmap map=maps.us data=sites ;
   format sites sitesfmt.;
   id state;
   choro sites / discrete legend=legend ;
run;


/* SAS/GRAPH chapter 29, sample 13: GR29N13 */

   /* set the graphics environment */
goptions reset=global gunit=pct border
         ftext=swissb htitle=6 htext=3;

   /* set the default graphics device */
goptions device=ps300 rotate=landscape ;

   /* create response data set SITES */
data sites;
   length state 3;
   input state sites;
   cards;
 1        80
 2        31
 4        92
more data lines
54        44
55       197
56        59
;
run;

   /* define titles and footnotes for map */
title1 'Products Installed in the USA';
title2 h=4 'XXX Corp.';
footnote1 j=l '  US map data set supplied'
          ' with SAS/GRAPH' '02'x ' Software';
footnote2 j=r 'GR29N13  ';

   /* display the surface map */
proc gmap map=maps.us data=sites  ;
   id state;
   surface sites / nlines=100
                   rotate=40
                   tilt=60;
run;

data poisson;
  do lambda=.1 to 10 by .3;
  eml=exp(-lambda);
  do x=0 to 20;
    if x=0 then xfact=1;
     else xfact=xfact*x;
    fx=lambda**x*eml/xfact;
    output;
  end;
  end;
  label fx='f(x)'
         x='x'
        lambda='lambda';

/* define appearance of plot */
goptions border
         cback=white
         ctext=green
         ftext=titalic
         htext=3
         htitle=6
         gunit=pct;

/* define output device and characteristics of output file */
goptions device=gif ;

*goptions device=pscolor
         rotate=landscape
         gsfmode=none;
*goptions device=hpljgl
         rotate=landscape
         gsfmode=none;

 title1 ;
  title2 c=blue f=triplex h=6 'Poisson Density Function';

  footnote1 h=4 c=red j=r f=titalic 'f(x) = '
        f=greek 'l' 
        move=(+0,+4) f=titalic h=3 ' x' h=4 move=(+0,-4) ' e '
        move=(+0,+4) f=greek h=3 '-l' h=4 move=(+0,-4) 
        f=titalic '/x! ';

   footnote2 j=r ;
run; 

/* create graph and output to temporary graphics catalog called
   poisson_graph  */
proc g3d ;
  plot lambda*x=fx /
       caxis=green yticknum=5 xticknum=5 zticknum=5
       zmax=1.0 ;
run;
