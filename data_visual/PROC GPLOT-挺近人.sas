*===============================================storms plots=============================================*;
%let name=isabel1;
filename odsout '.';

/* Imitation of ... http://www.erh.noaa.gov/mhx/Images/IsabelDuck.gif */

data my_data;
format timestamp datetime14.;
label obs_feet='Observation';
label pred_feet='Prediction';
informat timestamp datetime14.;
input timestamp obs_feet   pred_feet    knots    direction;
datalines;
 16SEP03:12:00       3.6       3.3       15         25   
 16SEP03:12:30       3.6        .        17         25   
 16SEP03:13:00       3.4        .        15         25   
 16SEP03:13:30       3.2        .        14         25   
 16SEP03:14:00       3.0        .        17         25   
 16SEP03:14:30       2.6        .        15         25   
 16SEP03:15:30       2.4        .        18         25   
 16SEP03:16:00       2.0        .        12         25   
 16SEP03:16:30       1.7        .        16         25   
 16SEP03:17:00       1.6        .        15         25   
 16SEP03:17:30       1.5        .        16         25   
 16SEP03:18:00       1.5       0.8       17         25   
 16SEP03:18:30       1.5        .        14         25   
 16SEP03:19:00       1.8        .        15         25   
 16SEP03:19:30       2.0        .        16         27   
 16SEP03:20:00       2.2        .        15         25   
 16SEP03:20:30       2.4        .        13         25   
 16SEP03:21:00       2.6        .        15         25   
 16SEP03:21:30       2.8        .        18         26   
 16SEP03:22:00       3.0        .        16         25   
 16SEP03:22:30       3.2        .        17         25   
 16SEP03:23:00       3.3        .        12         26   
 16SEP03:23:30       3.5        .        16         25   
 17SEP03:00:00       3.6       3.0       18         25   
 17SEP03:00:30       3.6        .        17         25   
 17SEP03:01:00       3.5        .        15         24   
 17SEP03:01:30       3.6        .        18         25   
 17SEP03:02:00       3.5        .        16         25   
 17SEP03:02:30       3.2        .        19         26   
 17SEP03:03:00       3.0        .        18         27   
 17SEP03:03:30       2.8        .        15         26   
 17SEP03:04:00       2.5        .        16         25   
 17SEP03:04:30       2.2        .        15         25   
 17SEP03:05:00       2.0        .        19         28   
 17SEP03:05:30       1.6        .        18         25   
 17SEP03:06:00       1.6       0.7       17         25   
 17SEP03:06:30       1.7        .        17         25   
 17SEP03:07:00       2.0        .        18         25   
 17SEP03:07:30       2.2        .        16         25   
 17SEP03:08:00       2.6        .        19         25   
 17SEP03:08:30       2.8        .        18         26   
 17SEP03:09:00       3.0        .        18         25   
 17SEP03:09:30       3.2        .        17         25   
 17SEP03:10:00       3.4        .        19         25   
 17SEP03:10:30       3.6        .        18         27   
 17SEP03:11:00       3.9        .        18         25   
 17SEP03:11:30       4.2        .        17         25   
 17SEP03:12:00       4.2       3.4       18         25   
 17SEP03:12:30       4.1        .        17         25   
 17SEP03:13:00       4.2        .        19         25   
 17SEP03:13:30       3.9        .        18         25   
 17SEP03:14:00       3.7        .        18         24   
 17SEP03:14:30       3.6        .        20         24   
 17SEP03:15:00       3.4        .        19         25   
 17SEP03:15:30       3.2        .        21         25   
 17SEP03:16:00       3.0        .        20         25   
 17SEP03:16:30       2.7        .        18         26   
 17SEP03:17:00       2.3        .        20         26   
 17SEP03:17:30       2.0        .        22         25   
 17SEP03:18:00       2.0       0.8       22         25   
 17SEP03:18:30       2.0        .        26         25   
 17SEP03:19:00       2.1        .        21         25   
 17SEP03:19:30       2.2        .        25         25   
 17SEP03:20:00       2.6        .        29         25   
 17SEP03:20:30       2.9        .        27         25   
 17SEP03:21:00       3.1        .        22         26   
 17SEP03:21:30       3.3        .        23         26   
 17SEP03:22:00       3.6        .        29         25   
 17SEP03:22:30       4.2        .        27         25   
 17SEP03:23:00       4.5        .        20         26   
 17SEP03:23:30       4.9        .        23         25   
 18SEP03:00:00       5.0       2.2       25         25   
 18SEP03:00:30       5.0        .        24         25   
 18SEP03:01:00       4.9        .        28         25   
 18SEP03:01:30       4.8        .        29         25   
 18SEP03:02:00       4.9        .        27         26   
 18SEP03:02:30       4.6        .        29         25   
 18SEP03:03:00       4.5        .        30         25   
 18SEP03:03:30       4.4        .        32         25   
 18SEP03:04:00       4.2        .        28         26   
 18SEP03:04:30       4.3        .        31         26   
 18SEP03:05:00       4.1        .        34         26   
 18SEP03:05:30       4.0        .        47         25   
 18SEP03:06:00       4.0       0.7       35         25   
 18SEP03:06:30       4.1        .        38         25   
 18SEP03:07:00       4.6        .        40         25   
 18SEP03:07:30       5.0        .        37         25   
 18SEP03:08:00       5.2        .        41         25   
 18SEP03:08:30       5.5        .        44         35   
 18SEP03:09:00       5.8        .        42         53   
 18SEP03:09:30       6.0        .        43         55   
 18SEP03:10:00       6.3        .        48         52   
 18SEP03:10:30       6.7        .        51         55   
 18SEP03:10:42       7.15       .        56         69   
 18SEP03:11:00        .         .         .          .   
 18SEP03:11:30        .         .         .          .   
 18SEP03:12:00        .        3.0        .          .   
 18SEP03:12:30        .         .         .          .   
 18SEP03:13:00        .         .         .          .   
 18SEP03:13:30        .         .         .          .   
 18SEP03:14:00        .         .         .          .   
 18SEP03:14:30        .         .         .          .   
 18SEP03:15:00        .         .         .          .   
 18SEP03:15:30        .         .         .          .   
 18SEP03:16:00        .         .         .          .   
 18SEP03:16:30        .         .         .          .   
 18SEP03:17:00        .         .         .          .   
 18SEP03:17:30        .         .         .          .   
 18SEP03:18:00        .         .         .          .   
 18SEP03:18:30        .        0.7        .          .   
 18SEP03:19:00        .         .         .          .   
 18SEP03:19:30        .         .         .          .   
 18SEP03:20:00        .         .         .          .   
 18SEP03:20:30        .         .         .          .   
 18SEP03:21:00        .         .         .          .   
 18SEP03:21:30        .         .         .          .   
 18SEP03:22:00        .         .         .          .   
 18SEP03:22:30        .         .         .          .   
 18SEP03:23:00        .         .         .          .   
 18SEP03:23:30        .         .         .          .   
 19SEP03:00:00        .         .         .          .   
 19SEP03:00:30        .        2.0        .          .   
 19SEP03:01:00        .         .         .          .   
 19SEP03:01:30        .         .         .          .   
 19SEP03:02:00        .         .         .          .   
 19SEP03:02:30        .         .         .          .   
 19SEP03:03:00        .         .         .          .   
 19SEP03:03:30        .         .         .          .   
 19SEP03:04:00        .         .         .          .   
 19SEP03:04:30        .         .         .          .   
 19SEP03:05:00        .         .         .          .   
 19SEP03:05:30        .         .         .          .   
 19SEP03:06:00        .         .         .          .   
 19SEP03:06:30        .        0.6        .          .   
 19SEP03:07:00        .         .         .          .   
 19SEP03:07:30        .         .         .          .   
 19SEP03:08:00        .         .         .          .   
 19SEP03:08:30        .         .         .          .   
 19SEP03:09:00        .         .         .          .   
 19SEP03:09:30        .         .         .          .   
 19SEP03:10:00        .         .         .          .   
 19SEP03:10:30        .         .         .          .   
 19SEP03:11:00        .         .         .          .   
 19SEP03:11:30        .         .         .          .   
 19SEP03:12:00        .        1.9        .          .   
;
run;

data my_data; set my_data;
length my_html $500;
my_html=
 'title='||quote(
  'Timestamp: '||put(timestamp,datetime14.)||'0D'x||
  'Observed Tide Height: '||trim(left(obs_feet))||' ft ')||
 ' href="isabel1_info.htm"';
run;

goptions device=png;
goptions noborder;

ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" (title="Hurricane Isabel water level") style=sasweb;

goptions gunit=pct ftitle="albany amt" htitle=3.0 ftext="albany amt" htext=2.25;

symbol1 i=spline c=blue v=none width=2;
symbol2 i=none c=red v=x height=2;

axis1 order=(0 to 10 by 2) minor=none label=(a=90 'Feet Above MLLW') offset=(0,0);

axis2 value=(a=90) label=none order=('16sep03:12:00:00'dt to '19sep03:12:00:00'dt by 21600) 
 minor=(number=5 color=grayaa);

legend1 position=(top right inside) mode=protect across=1 label=none;

title1 ls=1.5 "Hurricane Isabel measurements at Duck, NC";
title2 h=3.0 font="albany amt" "Water Level";

proc gplot data=my_data;  
 note move=(9,83.0) "Water Level Observed Time: 1042 (EDT) 18SEP03";
 note move=(9,79.0) "Observed height:   7.12 ft.";
 note move=(9,75.0) "Predicted Height:  2.27 ft.";
plot pred_feet*timestamp=1 obs_feet*timestamp=2 / overlay 
 vaxis=axis1 haxis=axis2
 href='18SEP03:10:42'dt  lhref=2
 legend=legend1
 html=my_html
 des='' name="&name"; 
run;

quit;
ODS HTML CLOSE;
ODS LISTING;


*============================================  Multiple Plots Per Page ·ÖÒ³============================================*;
%let name=multi;
filename odsout '.';


/* 
Created this demo for Lynneth Lohse and Michael Kilhullen,
to show to a Pharmaceutical company, to show that we can
do plots like GRAMS/AI.
*/

data mydata1;
format x comma7.0;
input x y;
datalines;
 500    85.00
 510    86.00
 520    87.00
 530    88.00
 535    87.50
 540    89.00
 550    90.00
 560    93.00
 570    95.00
 575    94.80
 580    94.00
 590    97.00
 600    96.50
 603    20
 660    78.00
 690    86.00
 728    10
 730    96.00
 740    96.30
 750    96.10
 760    96.80
 770    96.70
 780    96.00
 790    96.30
 800    96.00
 810    96.00
 820    96.70
 830    96.30
 840    96.00
 850    96.80
 860    96.00
 870    96.10
 880    96.00
 890    96.00
 900    96.00
 910    96.30
 920    96.80
 930    96.00
 940    96.80
 950    96.70
 960    96.00
 970    96.10
 980    96.70
 990    96.00
1000    96.10
1010    96.80
1020    96.00
1030    55   
1040    96.00
1050    96.00
1060    96.00
1070    96.00
1080    96.00
1081    55
1090    96.00
1100    96.20
1110    96.00
1120    96.70
1130    96.00
1140    96.90
1150    96.20
1160    96.00
1170    96.00
1180    96.00
1190    96.00
1200    96.00
1210    96.70
1220    96.00
1230    96.00
1240    96.20
1250    96.90
1260    96.20
1270    96.00
1280    96.00
1290    96.00
1300    96.00
1310    96.00
1320    96.00
1330    96.70
1340    96.00
1350    96.20
1360    96.00
1370    96.00
1380    65    
1390    96.00
1400    96.30
1410    96.00
1420    96.80
1430    96.20
1440    96.60
1450    96.00
1460    45   
1470    76.00
1480    86.00
1490    66.00
1495    20
1500    96.00
1510    96.80
1520    96.20
1530    96.00
1540    96.00
1550    96.00
1560    96.20
1570    96.00
1580    96.80
1590    96.00
1600    96.80
1604    40
1610    66.00
1620    76.00
1630    86.00
1640    96.00
1650    96.00
1660    96.00
1670    96.00
1680    96.00
1690    96.00
1700    85.00
1710    94.00
1720    96.00
1730    93.00
1740    95.00
1750    84.00
1760    94.00
1770    92.00
1780    96.00
1790    95.00
1800    83.00
1820    90.00
1830    93.00
1840    96.00
1850    96.00
1860    96.80
1870    96.00
1880    96.30
1890    96.00
1900    96.70
1910    92.00
1920    90.00
1942    80
1950    96.00
1960    96.90
1970    96.00
1980    96.30
1990    96.00
2000    96.00
2010    96.60
2020    96.00
2030    96.00
2040    96.30
2050    96.00
2060    96.00
2070    96.00
2080    96.00
2090    96.60
2100    96.00
2110    96.00
2120    96.00
2130    96.00
2140    96.30
2150    96.00
2160    96.00
2170    96.90
2180    96.00
2190    96.00
2200    96.60
2210    96.00
2220    96.00
2230    96.00
2240    96.00
2250    96.00
2260    96.00
2270    96.00
2280    96.00
2290    96.00
2300    96.30
2310    96.00
2320    96.00
2330    96.60
2340    96.00
2350    95.00
2360    96.00
2370    96.00
2380    96.90
2390    96.00
2400    95.60
2410    95.00
2420    96.00
2430    96.00
2440    96.00
2450    96.00
2460    96.00
2470    95.00
2480    96.00
2490    96.00
2500    96.00
2510    96.90
2520    96.00
2530    96.60
2540    95.30
2550    96.00
2560    96.00
2570    96.00
2580    96.00
2590    96.00
2600    96.00
2610    96.30
2620    96.00
2630    96.00
2640    96.00
2650    95.90
2660    96.00
2670    96.00
2680    96.00
2690    96.00
2700    96.00
2710    96.90
2720    90.30
2730    96.30
2740    95.00
2750    96.00
2760    96.30
2770    96.30
2780    96.60
2790    96.00
2800    96.00
2810    96.00
2820    96.00
2830    95.60
2840    94.00
2850    90.00
2860    86.00
2870    60   
2880    70.00
2921    40
2925    50
2970    65.00
3020    40.00
3028    25
3050    40.00
3070    65.00
3086    50
3090    80.00
3100    96.80
3110    96.20
3120    96.20
3130    96.30
3140    96.30
3150    96.90
3160    96.20
3170    96.80
3180    96.20
3190    96.60
3200    96.70
3210    96.30
3220    96.60
3230    96.60
3240    96.00
3250    96.30
3260    96.00
3270    96.30
3280    96.00
3290    96.00
3300    96.20
3310    96.10
3320    96.30
3330    96.30
3340    96.10
3350    96.20
3360    96.20
3370    96.10
3380    96.20
3390    96.20
3400    96.99
3410    96.20
3420    96.30
3430    96.20
3440    96.60
3450    96.80
3460    96.20
3470    96.30
3480    96.60
3490    96.90
3500    96.30
;
run;


/* Annotate the labels on certain x/y's
   (These could be queried out of the data, based on
   some criteria, but I'm just hard-coding them for
   this demo.)
*/
data myanno1;
input x y;
datalines;
603 20
728 10
1030 55
1081 55
1380 65
1460 45
1495 20
1604 40
1942 80
2870 60
2921 40
3028 25
3086 50
;
run;
/* Get a little fancy, and plot blue dots on the points
   that I'm labeling. */
proc sql; 
create table dots1 as
select x, y as ydot
from myanno1;
quit; run;
/* Here are the annotate labels */
data myanno1; set myanno1;
xsys='2'; ysys='2'; when='A';
length text $30 html $1000;
function='label'; angle=90; position='a'; style='';
text=trim(left(put(x,comma10.0)));
html=
 'title='||quote(
  'X Value: '||trim(left(put(x,comma10.0)))||'0D'x||
  'Y Value: '||trim(left(y)))||
 ' href="multi_info.htm"';
y=y-1.5; /* slightly reposition the label */
run;

data mydata1; set mydata1 dots1;
run;



data mydata2; 
input x y;
datalines;
350 70
370 73
452 44
546 66
640 43
645 42.5
652 41
675 43
680 42
700 42
775 49
850 45
;
run;

%let seed=8937;

data mydata3; 
input x y;
/* Make my fake data look a little more random */
y=y*(1+(ranuni(&seed)/8)); output;
/* generate some additional random data */
x=x+.01; y=-1*y*(1+(ranuni(&seed)/29)); output;
x=x+.01; y=-1*y*(1+(ranuni(&seed)/29)); output;
x=x+.01; y=-1*y*(1+(ranuni(&seed)/29)); output;
x=x+.01; y=-1*y*(1+(ranuni(&seed)/29)); output;
datalines;
0.00   12000
0.05  -12000
0.10   12000
0.15  -12000
0.20   12000
0.25    9000
0.30   -8000
0.35    8000
0.40   -7000
0.45   -7000
0.50    5000
0.55   -8000.0
0.60    9000.0
0.65    7000.0
0.70   -7000.0
0.75    4800.0
0.80    5500.0
0.85   -3220.0
0.90    1380.0
0.95    2490.0
1.00   -1260.0
1.05    1170.0
1.10    1150.0
1.15   -1140.0
1.20    -950.0
1.25    -940.0
1.30     840.0
1.35     240.0
1.40    -440.0
1.45     640.0
1.50     420.0
1.55    -320.0
1.60     120.0
1.65    -220.0
1.70     120.0
1.75     -89.4
1.80      88.0
1.85      19.0
1.90     -78.4
1.95      77.6
2.00      19.8
2.05      15.0
2.10      15.0
2.15      16.8
2.20     -16.0
2.25      13.0
2.30      13.0
2.35      1.6
2.40     -1.3
2.45      0.0
2.50      0.0
2.55      0.3
2.60      0.6
2.65      0.0
2.70      0.0
2.75      0.3
2.80      0.0
2.85      0.0
2.90     -0.4
2.95      0.0
3.00      0.6
;
run;


data mydata4;
input x y;
datalines;
 20             0
 22             0
 24             0
 26             0
 28             0
 30             0
 32             0
 34             8000
 36             1100
 38             1000
 40             50000
 41             49000
 42             100000
 44             0
 46             0
 48             1800
 50             2800
 52             38000
 54             49000
 55             370000
 56             53000
 58             1000
 60             9000
 62             2000
 64             9000
 66             50000
 67             380000
 68             1000
 70             30000
 72             0
 74             0
 76             8000
 78             0
 80             2000
 81             80000
 82             320000
 84             20000
 86             5000
 88             6000
 90             2000
 92             3000
 94             2000
 96             0
 98             0
100             0
102             0
104             500
106             8000
108             60000
109             550000
110             100000
112             3000
114             1000
116             0
118             0
120             2000
122             5000
124             3000
126             3000
128             0
130             0
132             0
134             8000
136             90000
137             100000
138             20000
140             5000
142             0
144             0
146             0
148             10000
150             8000
152             9000
154             0
156             0
158             0
160             0
162             5000
164             90000
165             120000
166             20000
168             0
170             0
172             0
174             0
176             0
178             0
180             0
182             5000
184             0
186             3000
188             0
190             0
192             0
193             310000
194             550000
195             280000
196             10000
198             0
200             0
;
run;

/* Here are the annotate labels */
data myanno4;
input x y;
datalines;
 40             50000
 41             49000
 42             100000
 54             49000
 55             370000
 56             53000
 66             50000
 67             380000
 81             80000
 82             320000
108             60000
109             550000
110             100000
136             90000
137             100000
165             120000
193             310000
194             550000
195             280000
;
run;
data myanno4; set myanno4;
length text $30 style $35;
length html $1000;
xsys='2';
ysys='2';
color='black';
when='A';
function='label';
angle=90;
position='6';
style="albany amt";
text=' '||trim(left(x));
/* slightly reposition the label */
x=x-1;
html=
 'title='||quote(
  'X Value: '||trim(left(x))||'0D'x||
  'Y Value: '||trim(left(put(y,comma10.0))))||
 ' href="multi_info.htm"';
run;

goptions nodisplay;


 symbol1 i=join v=none c=purple;
 symbol2 i=none v=dot c=blue h=.5;

 goptions ftext="albany amt" gunit=pct htext=3.5;

 axis1 order=(3500 to 500 by -500) minor=none label=none offset=(0,0);
 axis2 order=(0 to 100 by 20) minor=none label=none
  value=(t=1 '') offset=(0,5);
 
 proc gplot data=mydata1 anno=myanno1;           
 plot y*x=1 ydot*x=2 / overlay
  haxis=axis1 vaxis=axis2
  autovref cvref=graydd
  cframe=white
  name="plot1"; 
 run;

 title;
 symbol3 color=stb interpol=spline v=none;
 axis3 order=(350 to 850 by 50) label=none minor=none offset=(0,0);
 axis4 order=(35 to 80 by 5) label=none minor=none offset=(0,0);
 proc gplot data=mydata2;          
 plot y*x=3 /
  cframe=white
  haxis=axis3 autohref lhref=1 chref=graycc
  vaxis=axis4 autovref lvref=1 cvref=graycc
  autovref cvref=graydd
  name="plot2";
 run;

 title;
 axis5 order=(0 to 3 by .5) label=none minor=none offset=(0,0);
 axis6 order=(-15000 to 15000 by 5000) label=none minor=none offset=(0,0);
 symbol4 color=green interpol=join v=none;
 proc gplot data=mydata3;          
 format y comma10.0;
  plot y*x=4 /
  cframe=white
  haxis=axis5
  vaxis=axis6
  autovref cvref=graydd
  name="plot3";
 run;

 title;
 axis7 order=(20 to 200 by 20) label=none minor=none offset=(0,0);
 axis8 order=(0 to 600000 by 100000) label=none minor=none offset=(0,0);
 symbol5 color=red interpol=needle v=none;
 proc gplot data=mydata4 anno=myanno4;          
 format y comma10.0;
  plot y*x=5 /
  cframe=white
  haxis=axis7
  vaxis=axis8
  autovref cvref=graydd
  name="plot4";
 run;



goptions device=png;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" 
 (title="SAS/Braph version of GRAMS/AI plots") 
 nogtitle style=sasweb;

goptions display;

title1 color=black
 link="http://www.adeptscience.co.uk/products/lab/grams32/screens/assistant.gif" 
 "Imitation of 'GRAMS/AI' plot";

title2 color=gray55 "Mouse over labels to see data values";

proc greplay nofs igout=work.gseg tc=tempcat;
   tdef L2R2S des="2 BOXES LEFT, 2 BOXES RIGHT (WITH SPACE)"
        1/llx=0   lly=52
          ulx=0   uly=100
          urx=48  ury=100
          lrx=48  lry=52
        2/llx=0   lly=0
          ulx=0   uly=48
          urx=48  ury=48
          lrx=48  lry=00
        3/llx=52  lly=52
          ulx=52  uly=100
          urx=100 ury=100
          lrx=100 lry=52
        4/llx=52  lly=0
          ulx=52  uly=48
          urx=100 ury=48
          lrx=100 lry=0
          ;
template L2R2S;
treplay 
 1:plot1  3:plot3
 2:plot2  4:plot4
 des='' name="&name";
run;

/* 
clean up, so you can re-run the same code in the same sas session,
and still use the same grseg names (otherwise they get auto-incremented).
*/
proc greplay nofs igout=gseg;
delete _all_;
run; quit;

quit;
ODS HTML CLOSE;
ODS LISTING;

*============================================================ Winds=====================================================*;
%let name=isabel2;
filename odsout '.';

/* Imitation of ... http://www.erh.noaa.gov/mhx/Images/IsabelDuck.gif */

data my_data;
format timestamp datetime14.;
label obs_feet='Observation';
label pred_feet='Prediction';
informat timestamp datetime14.;
input timestamp obs_feet   pred_feet    knots    direction;
datalines;
 16SEP03:12:00      3.6       3.3       15         25   
 16SEP03:12:30       3.6        .        17         25   
 16SEP03:13:00       3.4        .        15         25   
 16SEP03:13:30       3.2        .        14         25   
 16SEP03:14:00       3.0        .        17         25   
 16SEP03:14:30       2.6        .        15         25   
 16SEP03:15:30       2.4        .        18         25   
 16SEP03:16:00       2.0        .        12         25   
 16SEP03:16:30       1.7        .        16         25   
 16SEP03:17:00       1.6        .        15         25   
 16SEP03:17:30       1.5        .        16         25   
 16SEP03:18:00      1.5       0.8       17         25   
 16SEP03:18:30       1.5        .        14         25   
 16SEP03:19:00       1.8        .        15         25   
 16SEP03:19:30       2.0        .        16         27   
 16SEP03:20:00       2.2        .        15         25   
 16SEP03:20:30       2.4        .        13         25   
 16SEP03:21:00       2.6        .        15         25   
 16SEP03:21:30       2.8        .        18         26   
 16SEP03:22:00       3.0        .        16         25   
 16SEP03:22:30       3.2        .        17         25   
 16SEP03:23:00       3.3        .        12         26   
 16SEP03:23:30       3.5        .        16         25   
 17SEP03:00:00      3.6       3.0       18         25   
 17SEP03:00:30       3.6        .        17         25   
 17SEP03:01:00       3.5        .        15         24   
 17SEP03:01:30       3.6        .        18         25   
 17SEP03:02:00       3.5        .        16         25   
 17SEP03:02:30       3.2        .        19         26   
 17SEP03:03:00       3.0        .        18         27   
 17SEP03:03:30       2.8        .        15         26   
 17SEP03:04:00       2.5        .        16         25   
 17SEP03:04:30       2.2        .        15         25   
 17SEP03:05:00       2.0        .        19         28   
 17SEP03:05:30       1.6        .        18         25   
 17SEP03:06:00      1.6       0.7       17         25   
 17SEP03:06:30       1.7        .        17         25   
 17SEP03:07:00       2.0        .        18         25   
 17SEP03:07:30       2.2        .        16         25   
 17SEP03:08:00       2.6        .        19         25   
 17SEP03:08:30       2.8        .        18         26   
 17SEP03:09:00       3.0        .        18         25   
 17SEP03:09:30       3.2        .        17         25   
 17SEP03:10:00       3.4        .        19         25   
 17SEP03:10:30       3.6        .        18         27   
 17SEP03:11:00       3.9        .        18         25   
 17SEP03:11:30       4.2        .        17         25   
 17SEP03:12:00      4.2       3.4       18         25   
 17SEP03:12:30       4.1        .        17         25   
 17SEP03:13:00       4.2        .        19         25   
 17SEP03:13:30       3.9        .        18         25   
 17SEP03:14:00       3.7        .        18         24   
 17SEP03:14:30       3.6        .        20         24   
 17SEP03:15:00       3.4        .        19         25   
 17SEP03:15:30       3.2        .        21         25   
 17SEP03:16:00       3.0        .        20         25   
 17SEP03:16:30       2.7        .        18         26   
 17SEP03:17:00       2.3        .        20         26   
 17SEP03:17:30       2.0        .        22         25   
 17SEP03:18:00      2.0       0.8       22         25   
 17SEP03:18:30       2.0        .        26         25   
 17SEP03:19:00       2.1        .        21         25   
 17SEP03:19:30       2.2        .        25         25   
 17SEP03:20:00       2.6        .        29         25   
 17SEP03:20:30       2.9        .        27         25   
 17SEP03:21:00       3.1        .        22         26   
 17SEP03:21:30       3.3        .        23         26   
 17SEP03:22:00       3.6        .        29         25   
 17SEP03:22:30       4.2        .        27         25   
 17SEP03:23:00       4.5        .        20         26   
 17SEP03:23:30       4.9        .        23         25   
 18SEP03:00:00      5.0       2.2       25         25   
 18SEP03:00:30       5.0        .        24         25   
 18SEP03:01:00       4.9        .        28         25   
 18SEP03:01:30       4.8        .        29         25   
 18SEP03:02:00       4.9        .        27         26   
 18SEP03:02:30       4.6        .        29         25   
 18SEP03:03:00       4.5        .        30         25   
 18SEP03:03:30       4.4        .        32         25   
 18SEP03:04:00       4.2        .        28         26   
 18SEP03:04:30       4.3        .        31         26   
 18SEP03:05:00       4.1        .        34         26   
 18SEP03:05:30       4.0        .        47         25   
 18SEP03:06:00      4.0       0.7       35         25   
 18SEP03:06:30       4.1        .        38         25   
 18SEP03:07:00       4.6        .        40         25   
 18SEP03:07:30       5.0        .        37         25   
 18SEP03:08:00       5.2        .        41         25   
 18SEP03:08:30       5.5        .        44         35   
 18SEP03:09:00       5.8        .        42         53   
 18SEP03:09:30       6.0        .        43         55   
 18SEP03:10:00       6.3        .        48         52   
 18SEP03:10:30       6.7        .        51         55   
 18SEP03:10:42      7.15        .       56         69   
 18SEP03:11:00        .         .         .          .   
 18SEP03:11:30        .         .         .          .   
 18SEP03:12:00       .        3.0        .          .   
 18SEP03:12:30        .         .         .          .   
 18SEP03:13:00        .         .         .          .   
 18SEP03:13:30        .         .         .          .   
 18SEP03:14:00        .         .         .          .   
 18SEP03:14:30        .         .         .          .   
 18SEP03:15:00        .         .         .          .   
 18SEP03:15:30        .         .         .          .   
 18SEP03:16:00        .         .         .          .   
 18SEP03:16:30        .         .         .          .   
 18SEP03:17:00        .         .         .          .   
 18SEP03:17:30        .         .         .          .   
 18SEP03:18:00        .         .         .          .   
 18SEP03:18:30       .        0.7        .          .   
 18SEP03:19:00        .         .         .          .   
 18SEP03:19:30        .         .         .          .   
 18SEP03:20:00        .         .         .          .   
 18SEP03:20:30        .         .         .          .   
 18SEP03:21:00        .         .         .          .   
 18SEP03:21:30        .         .         .          .   
 18SEP03:22:00        .         .         .          .   
 18SEP03:22:30        .         .         .          .   
 18SEP03:23:00        .         .         .          .   
 18SEP03:23:30        .         .         .          .   
 19SEP03:00:00        .         .         .          .   
 19SEP03:00:30       .        2.0        .          .   
 19SEP03:01:00        .         .         .          .   
 19SEP03:01:30        .         .         .          .   
 19SEP03:02:00        .         .         .          .   
 19SEP03:02:30        .         .         .          .   
 19SEP03:03:00        .         .         .          .   
 19SEP03:03:30        .         .         .          .   
 19SEP03:04:00        .         .         .          .   
 19SEP03:04:30        .         .         .          .   
 19SEP03:05:00        .         .         .          .   
 19SEP03:05:30        .         .         .          .   
 19SEP03:06:00        .         .         .          .   
 19SEP03:06:30       .        0.6        .          .   
 19SEP03:07:00        .         .         .          .   
 19SEP03:07:30        .         .         .          .   
 19SEP03:08:00        .         .         .          .   
 19SEP03:08:30        .         .         .          .   
 19SEP03:09:00        .         .         .          .   
 19SEP03:09:30        .         .         .          .   
 19SEP03:10:00        .         .         .          .   
 19SEP03:10:30        .         .         .          .   
 19SEP03:11:00        .         .         .          .   
 19SEP03:11:30        .         .         .          .   
 19SEP03:12:00       .        1.9        .          .   
;
run;

data my_data; set my_data;
length my_html $500;
my_html=
 'title='||quote(
  'Timestamp: '||put(timestamp,datetime14.)||'0D'x||
  'Wind Speed: '||trim(left(knots))||' knots '||'0D'x||
  'Wind Direction: '||trim(left(direction))||' degrees')||
 ' href="isabel2_info.htm"';
run;

data my_anno; set my_data;
if knots ne . then do;
 xsys='2'; ysys='2';
 when='b';  /* draw the blue tails before the red dots, so they look better */
 color='blue';
 function='move';
 x=timestamp;
 y=knots;
 output;
 function='draw';
 /* convert compass direction into annotate coordinate system */
 /* with a compass 0 is north, and degrees go clockwise */
 /* with annotate, 0 is at 3pm, and degrees go counterclockwise */
 annoangl=(360-direction)+90;
 /* convert degrees to radians, since sas sin() and cos() operate on radians */
 anglerad=( (2*3.14)/360 )*(annoangl);  
 /* Make wind vane tails length approx 5% of total area */
 x=timestamp + .05*('19SEP03:12:00'dt - '16SEP03:12:00'dt)  * cos(anglerad) * -1;
 y=knots     + .05*(60-10) * sin(anglerad) * -1;
 output;
end;
run;


goptions device=png;
goptions noborder;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm"
 (title=" SAS/Graph gplot of Hurricane Isabel winds") style=sasweb;

goptions gunit=pct ftitle="albany amt" htitle=3.0 ftext="albany amt" htext=2.5;

legend1 position=(top right inside) mode=protect across=1 label=none repeat=1;
/* legend repeat= is a new v9.2 feature */

symbol1 c=red v=dot i=none height=2.2;

axis1 order=(0 to 60 by 10) label=(a=90 'Knots') minor=none offset=(0,0);

axis2 value=(a=90) label=none 
  order=('16sep03:12:00:00'dt to '19sep03:12:00:00'dt by 21600) 
  minor=(number=5 color=grayaa);

title1 ls=1.5 "Hurricane Isabel measurements at Duck, NC";
title2 h=3.0pct "Wind Speed and Direction";

proc gplot data=my_data anno=my_anno;  
 note move=(9,83) "Wind Observed Time: 1042 (EDT) 18SEP03";
 note move=(9,79) "Wind Direction: 69 degrees T";
 note move=(9,75) "Wind Speed: 56 Knots";
 note move=(9,71) "Gusting To: 71 Knots";
plot knots*timestamp=1 / 
  vaxis=axis1 haxis=axis2
  href='18SEP03:10:42'dt  lhref=2
  legend=legend1   
  html=my_html
  des='' name="&name"; 
run;

quit;
ODS HTML CLOSE;
ODS LISTING;


*=================================================Used Corvette Prices  =====================================================*;
%let name=corvette;
filename odsout '.';

data my_data;
length style $15;
input year style trade private retail;
datalines;
1989 Base         5250 7075 9625
1989 Convert      6300 8275 11050
1990 Base         5775 7675 10400
1990 Convert      6900 8975 11950
1990 ZR1          13050 16050 20400
1991 Base         6400 8325 11050
1991 Convert      7675 9800 12800
1991 ZR1          14600 17650 22100
1992 Base         7075 9075 11950
1992 Convert      8500 10650 13800
1992 ZR1          16200 19300 24000
1993 Base         7875 9900 12850 
1993 Convert      9425 11650 14900
1993 ZR1          17900 21100 26000
1994 Base         8750 10850 13900
1994 Convert      10425 12750 16150
1994 ZR1          19700 23000 28000
1995 Base         9800 11950 15150
1995 Convert      11650 13950 17450
1995 ZR1          23275 26900 32300
1996 Base         10950 13200 16550
1996 Convert      12950 15350 19000
1997 Base         14400 17150 21300
1998 Base         16400 19250 23600
1998 Convert      19800 22900 27700
1999 Base_HT      16300 19150 23500
1999 Base         18525 21500 26100
1999 Convert      22400 25600 30700
2000 Base_HT      18875 22000 26800
2000 Base         21350 24500 29600
2000 Convert      25600 29000 34500
2001 Base         23675 26900 32000
2001 Z06          28425 31800 37400
2001 Convert      28325 31600 37200
;
run;

/* Re-structure the data for hi/lo/close plot */
data my_data; set my_data;
length combined $30;
length type $10;
format price dollar10.0;
combined=trim(left(year))||'_'||trim(left(style));
price=retail; type='retail'; output; 
price=trade;  type='trade'; output; 
price=private; type='private'; output;
run;

proc sql;
create table my_data as
select year, price, type, style, combined
from my_data
order by combined;
quit; run;

data my_data; set my_data;
stylechar='B';
if style='Convert' then stylechar='C';
if style='Z06' then stylechar='Z';
if style='ZR1' then stylechar='Z';
run;

data my_data; set my_data;
length myhtml $200;
myhtml=
 'title='||quote(
  'Year/Style: '||trim(left(combined))||'0D'x||
  trim(left(type))||' used price: '||trim(left(put(price,dollar10.0))))||
 ' href="corvette_info.htm"';
run;

/* Annotate years along haxis */
proc sql noprint;
create table my_anno as 
select unique combined, year
from my_data
where style='Base';
quit; run;

data my_anno; set my_anno;
xsys='2'; ysys='1'; hsys='3'; when='a';
xc=combined;
y=-1;
text=trim(left(year));
function='label'; position='4'; angle=90;
run;


goptions device=png;
goptions noborder;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" 
 (title="SAS/Graph of Used Corvette Price info (Kelley Blue Book, 2003)") 
 style=sasweb;

goptions ftitle="albany amt/bold" ftext="albany amt" gunit=pct htitle=3 htext=2.25;

axis1 label=none offset=(2,2) major=none minor=none value=none;
axis2 label=none offset=(0,0) order=(0 to 40000 by 5000) minor=none;

title1 ls=1.5 'Used Corvette Prices';
title2 'Based on Kelley Blue Book, July-December 2003 edition'; 
title3 a=-90 h=2pct "  ";

footnote1 height=5 " ";
footnote2 'Legend: ' c=red 'B=Base Model  ' c=blue 'C=Convertible  ' c=magenta 'Z=ZR1 or Z06';
footnote3 ls=1.5 '3 Prices per Line Segment: trade-in, private-party, and retail';
                    
symbol1 interpol=hiloc font="albany amt/bold" v='B' cv=cxff0000 ci=black width=1 height=2.5; 
symbol2 interpol=hiloc font="albany amt/bold" v='C' cv=cx0000ff ci=black width=1 height=2.5; 
symbol3 interpol=hiloc font="albany amt/bold" v='Z' cv=magenta  ci=black width=1 height=2.5; 

proc gplot data=my_data anno=my_anno; 
plot price*combined=stylechar / nolegend
 vaxis=axis2 vzero 
 haxis=axis1
 autovref cvref=graydd
 href=
   '1989_Base' 
   '1990_Base' 
   '1991_Base' 
   '1992_Base' 
   '1993_Base' 
   '1994_Base' 
   '1995_Base' 
   '1996_Base' 
   '1997_Base' 
   '1998_Base' 
   '1999_Base' 
   '2000_Base' 
   '2001_Base' 
 chref=graydd
 html=myhtml
 des='' name="&name"; 
run; 

quit;
ODS HTML CLOSE;
ODS LISTING;


*============================================================== Genome Analytics ================================================*;
%let name=genome;
filename odsout '.';

/* Based on p. 270 of "discovering Genomics, Proteomics, and Bioinformatics"
  library book#  QH 447.C36 2003  */ 


/* radius range= 0 to .5  (with .5, the circles touch) */
%let radius=.43;

%let max_across=20;
%let max_updown=25;

proc format;
value ylabel 
1='16(41)'
2='15(92)'
3='14(102)'
4='13(128)'
5='12(35)'
6='11(33)'
7='10(52)'
8='9(26)'
9='8(32)'
10='7(32)'
11='6(62)'
12='5(44)'
13='4(69)'
14='3(180)'
15='2(24)'
16='1(45)'
17='Gal80'
18='Gal10'
19='Gal7'
20='Gal6'
21='Gal5'
22='Gal4'
23='Gal3'
24='Gal2'
25='Gal1'
;
proc format;
value y2label 
1='Gluconeogenesis'
2='Sugar Transport; HXT family'
3='Vesicular transport'
4='Fatty acid oxidation; amino-acid uptake'
5='Downreg. in gal4(delta)'
6='Downreg. in gal4(delta)'
7='Respiration / mitochondrial machinery'
8='Unknown'
9='Protein degradation; upreg in gal5(delta)'
10='Chromatin'
11='Glycogen metabolism'
12='Hsp70 family; mating'
13='RPP family'
14='RPl, RPS family; mating'
15='Similar in expression profiles to Gal enzyme'
16='Similar in expression profiles to Gal enzyme'
17='Inhibitor of Gal4 activation'
18='UDP-galactose epimerase'
19='Galactotransferase'
20='(Lap3) involved in negative regulation of Gal genes'
21='(Pgm2) Phosphoglucomutase'
22='Transcriptional activator of Gal genes'
23='Inducer; releases Gal80 inhibition'
24='Galactose permease'
25='Galactokinase'
;
value xlabel
1='119'
2='99'
3='117'
4='120'
5='126'
6='141'
7='248'
8='87'
9='273'
10='>300'
11='100'
12='116'
13='133'
14='133'
15='129'
16='133'
17='125'
18='129'
19='128'
20='205'
;
run;

/* Fake axis labels for the top axis */
data top_anno;
length text $30;
xsys='2';
ysys='2';
color='black';
when='a';
function='label';
angle=90;
position='C';
style='';
y=%eval(&max_updown+1);
x=1; text='wt-gal'; output;
x=2; text='wt+gal'; output;
x=3; text='gal1(delta)'; output;
x=4; text='gal2(delta)'; output;
x=5; text='gal3(delta)'; output;
x=6; text='gal4(delta)'; output;
x=7; text='gal5(delta)'; output;
x=8; text='gal6(delta)'; output;
x=9; text='gal7(delta)'; output;
x=10; text='gal10(delta)'; output;
x=11; text='gal80(delta)'; output;
x=12; text='gal1(delta)'; output;
x=13; text='gal2(delta)'; output;
x=14; text='gal3(delta)'; output;
x=15; text='gal4(delta)'; output;
x=16; text='gal5(delta)'; output;
x=17; text='gal6(delta)'; output;
x=18; text='gal7(delta)'; output;
x=19; text='gal10(delta)'; output;
x=20; text='gal80(delta)'; output;
run;
data top_anno; set top_anno;
text='    '||trim(left(text));
x+.15;
run;

/* Fake axis labels for the top axis */
data top_anno2;
length text $30;
xsys='2';
ysys='3';
color='black';
when='a';
function='label';
position='5';
style='';
y=90;
x=1.5; text='wt vs. +gal'; output;
x=7;   text='+gal; (delta) vs. wt'; output;
x=17;  text='-gal; (delta) vs. wt'; output;
run;

%let unitsize=2.5;
/* This is the 'key' in the top/right corner */
data key_anno;
length function color style $8;
length text $30;
xsys='3';
ysys='3';
when='a';

 /* Coordinates of bottom left of the color key, in screen % */
 x=73; y=82; 

 /* outline around color legend */
 function='move'; output;
 function='draw'; color='black';
 x=x+7*&unitsize; output;
 y=y+&unitsize; output;
 x=x-7*&unitsize; output;
 y=y-&unitsize; output;
 

 function='poly';  style='solid'; color='grayff'; /* fill color */
 output;
 function='polycont';  /* color='black'; */  /* outline color */
 x=x+&unitsize; output;
 y=y+&unitsize; output;
 x=x-&unitsize; output;
 y=y-&unitsize; output;

 x+&unitsize;
 function='poly';  style='solid'; color='graydd'; output;
 function='polycont';    
 x=x+&unitsize; output;
 y=y+&unitsize; output;
 x=x-&unitsize; output;
 y=y-&unitsize; output;

 x+&unitsize;
 function='poly';  style='solid'; color='graycc'; output;
 function='polycont';    
 x=x+&unitsize; output;
 y=y+&unitsize; output;
 x=x-&unitsize; output;
 y=y-&unitsize; output;

 x+&unitsize;
 function='poly';  style='solid'; color='grayaa'; output;
 function='polycont';    
 x=x+&unitsize; output;
 y=y+&unitsize; output;
 x=x-&unitsize; output;
 y=y-&unitsize; output;

 x+&unitsize;
 function='poly';  style='solid'; color='gray99'; output;
 function='polycont';    
 x=x+&unitsize; output;
 y=y+&unitsize; output;
 x=x-&unitsize; output;
 y=y-&unitsize; output;

 x+&unitsize;
 function='poly';  style='solid'; color='gray77'; output;
 function='polycont';    
 x=x+&unitsize; output;
 y=y+&unitsize; output;
 x=x-&unitsize; output;
 y=y-&unitsize; output;

 x+&unitsize;
 function='poly';  style='solid'; color='gray55'; output;
 function='polycont';    
 x=x+&unitsize; output;
 y=y+&unitsize; output;
 x=x-&unitsize; output;
 y=y-&unitsize; output;


 /* Now, do the upper of the 2 color keys */
 x=73; y=86; 

 /* outline around upper color legend */
 function='move'; output;
 function='draw'; color='black';
 x=x+7*&unitsize; output;
 y=y+&unitsize; output;
 x=x-7*&unitsize; output;
 y=y-&unitsize; output;

 function='poly';  style='solid'; color='grayff'; /* fill color */
 output;
 function='polycont';    
 x=x+&unitsize; output;
 y=y+&unitsize; output;
 x=x-&unitsize; output;
 y=y-&unitsize; output;

 x+&unitsize;
 function='poly';  style='solid'; color='graydd'; output;
 function='polycont';    
 x=x+&unitsize; output;
 y=y+&unitsize; output;
 x=x-&unitsize; output;
 y=y-&unitsize; output;

 x+&unitsize;
 function='poly';  style='solid'; color='graycc'; output;
 function='polycont';    
 x=x+&unitsize; output;
 y=y+&unitsize; output;
 x=x-&unitsize; output;
 y=y-&unitsize; output;

 x+&unitsize;
 function='poly';  style='solid'; color='grayaa'; output;
 function='polycont';    
 x=x+&unitsize; output;
 y=y+&unitsize; output;
 x=x-&unitsize; output;
 y=y-&unitsize; output;

 x+&unitsize;
 function='poly';  style='solid'; color='gray99'; output;
 function='polycont';    
 x=x+&unitsize; output;
 y=y+&unitsize; output;
 x=x-&unitsize; output;
 y=y-&unitsize; output;

 x+&unitsize;
 function='poly';  style='solid'; color='gray77'; output;
 function='polycont';    
 x=x+&unitsize; output;
 y=y+&unitsize; output;
 x=x-&unitsize; output;
 y=y-&unitsize; output;

 x+&unitsize;
 function='poly';  style='solid'; color='gray55'; output;
 function='polycont';    
 x=x+&unitsize; output;
 y=y+&unitsize; output;
 x=x-&unitsize; output;
 y=y-&unitsize; output;

 /* Now, the text labels on the color key */
 x=73; y=82+(&unitsize/2); 
 function='label'; style='';
 size=.7;
 position='5';
 color='black';
 x=x+(&unitsize/2); text='-1.5'; output;
 x=x+&unitsize; text='-1'; output;
 x=x+&unitsize; text='-.5'; output;
 x=x+&unitsize; text='0'; output;
 color='white';
 x=x+&unitsize; text='.5'; output;
 x=x+&unitsize; text='1'; output;
 x=x+&unitsize; text='1.5'; output;
 color='black';
 size=.9;
 x=x+(&unitsize*.6); position='6'; text='Gene clusters'; output;

 /* Now, the text labels on the upper color key */
 x=73; y=86+(&unitsize/2); 
 function='label';
 size=.7;
 position='5';
 color='black';
 x=x+(&unitsize/2); text='-3'; output;
 x=x+&unitsize; text='-2'; output;
 x=x+&unitsize; text='-1'; output;
 x=x+&unitsize; text='0'; output;
 color='white';
 x=x+&unitsize; text='1'; output;
 x=x+&unitsize; text='2'; output;
 x=x+&unitsize; text='3'; output;
 color='black';
 size=.9;
 x=x+(&unitsize*.6); position='6'; text='Gal genes'; output;

 x=73+3.5*&unitsize;
 y=89.5;
 position='2';
 text='log(10) expression ratio';
 output;

run;

data other_anno; 
 set key_anno top_anno top_anno2 ;
run;

%let seed=63452764;

data microarray;
format updown ylabel.;
format updown2 y2label.;
format across xlabel.;
do across=1 to &max_across;
 do updown=1 to &max_updown;
  grid_id=trim(left(across))||'_'||trim(left(updown));
  updown2=updown;
  value=int((ranuni(&seed)*7)+.9999);
  magnitude=ranuni(&seed);
  output;
 end;
end;
run;


/* Annotate balls, rather than letting gplot plot dots -- this
   way you have much more control */
data anno_balls; set microarray;
length color $8 style $20 html $800;
xsys='2'; ysys='2'; hsys='3'; when='a';
x=across;
y=updown;
function='pie'; rotate=360; size=.9+(.2*magnitude);
     if (value eq 1) then color='grayff';  /* white */
else if (value eq 2) then color='graydd';
else if (value eq 3) then color='graycc';
else if (value eq 4) then color='grayaa';  /* same as cframe */
else if (value eq 5) then color='gray99';
else if (value eq 6) then color='gray77';
else if (value eq 7) then color='gray55';  /* dark gray */
style='psolid'; output;

html=
 'title='||quote(
  put(updown,ylabel.)||'0D'x||
  put(updown,y2label.)||'0D'x||
  'Growth Rate (doubling time in minutes): '||put(across,xlabel.)||'0D'x||
  '-------------------------------------------'||'0D'x||
  'Value: '||trim(left(value))||'0D'x||
  'Size: '||trim(left(size))||'0D'x||
  'Color: '||trim(left(color))||'0D'x||
  '-------------------------------------------'||'0D'x||
  'Galactose induction of yeast genes.  '||'0D'x||
  'Medium-gray spots (same color as background)  '||'0D'x||
  'represent no change, darker spots represent   '||'0D'x||
  'increased mRNA production, and lighter spots  '||'0D'x||
  'indicate reduced mRNA production.')||
 ' href="genome_info.htm"';

style='pempty'; output;

run;



/*

Grid numbering layout.
Number your data accordingly.

  &max_updown
   .
   .
   .
   7
u  6
p  5
d  4
o  3
w  2 
n  1

     1 2 3 4 5 6 7 8 .....&max_across
       a c r o s s
*/


goptions device=png;
goptions border;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm"
 (title="SAS/Graph Proc Gplot version of Microarray") style=htmlblue;

goptions gunit=pct htext=1.8 ftext="albany amt";
 
axis1 order=(0 to %eval(&max_updown+1) by 1) 
   label=(a=90 c=white '.' c=black '                      Gene cluster (size)                             Galactose utilization gene')
   value=(j=r tick=1 '' tick=%eval(&max_updown+2) '')
   major=none minor=none
   ;
 
axis2 order=(0 to %eval(&max_updown+1) by 1) 
   label=('')
   value=(j=l tick=1 '' tick=%eval(&max_updown+2) '')
   major=none minor=none
   ;

axis3 order=(0 to %eval(&max_across+1) by 1) 
   label=('Growth rate (doubling time in min.)')
   value=( a=90 tick=1 '' tick=%eval(&max_across+2) '')
   major=none minor=none
   ;

/* I don't really want the 'symbol' dots to show up, so I make them
   the same color as the cframe.  The 'dots' you will actually see on
   the graph are annotated pies. */
symbol v=dot c=grayaa r=2;  

title1 h=5pct "Microarray";
title2 h=3pct "(genome chip)";
title3 h=10pct " ";  /* make some blank space, so annotated labels have room */

proc gplot data=microarray anno=anno_balls;
 plot  updown*across / cframe=grayaa 
   haxis=axis3 href=2.5 11.5 
   vaxis=axis1 vref= 16.5 
   anno=other_anno
   des='' name="&name";  
 plot2 updown2*across / 
   vaxis=axis2;
run;

quit;
ODS HTML CLOSE;
ODS LISTING;


*====================================================================forecast=================================================*;
%let name=savings;
filename odsout '.';

data savings; 
input line date date7. value; 
format date year.; 
format value percent5.0; 
datalines; 
1 01jan90 .095
1 24dec00 .01
2 01jan90 .075
2 01feb90 .079
2 01mar90 .078
2 01apr90 .081
2 01may90 .079
2 01jun90 .082
2 01jul90 .080
2 01aug90 .081
2 01sep90 .079
2 01oct90 .080
2 01nov90 .078
2 01dec90 .081
2 01jan91 .080
2 01feb91 .081
2 01mar91 .083
2 01apr91 .086
2 01may91 .085
2 01jun91 .087
2 01jul91 .083
2 01aug91 .079
2 01sep91 .081
2 01oct91 .082
2 01nov91 .080
2 01dec91 .081
2 01jan92 .080
2 01feb92 .082
2 01mar92 .081
2 01apr92 .082
2 01may92 .083
2 01jun92 .084
2 01jul92 .083
2 01aug92 .083
2 01sep92 .081
2 01oct92 .082
2 01nov92 .105
2 01dec92 .081
2 01jan93 .07
2 01feb93 .07
2 01mar93 .07
2 01apr93 .075
2 01may93 .075
2 01jun93 .080
2 01jul93 .072
2 01aug93 .074
2 01sep93 .071
2 01oct93 .073
2 01nov93 .071
2 01dec93 .073
2 01jan94 .06
2 01feb94 .08
2 01mar94 .05
2 01apr94 .055
2 01may94 .065
2 01jun94 .050
2 01jul94 .062
2 01aug94 .064
2 01sep94 .061
2 01oct94 .063
2 01nov94 .061
2 01dec94 .050
2 01jan95 .051
2 01feb95 .052
2 01mar95 .053
2 01apr95 .051
2 01may95 .053
2 01jun95 .050
2 01jul95 .051
2 01aug95 .041
2 01sep95 .042
2 01oct95 .043
2 01nov95 .041
2 01dec95 .040
2 01feb96 .048
2 01mar96 .047
2 01apr96 .048
2 01may96 .046
2 01jun96 .046
2 01jul96 .045
2 01aug96 .046
2 01sep96 .043
2 01oct96 .044
2 01nov96 .042
2 01dec96 .039
2 01jan97 .041
2 01feb97 .040
2 01mar97 .041
2 01apr97 .042
2 01may97 .041
2 01jun97 .042
2 01jul97 .041
2 01aug97 .042
2 01sep97 .041
2 01oct97 .040
2 01nov97 .039
2 01dec97 .038
2 01jan98 .040
2 01feb98 .040
2 01mar98 .040
2 01apr98 .042
2 01may98 .042
2 01jun98 .043
2 01jul98 .043
2 01aug98 .044
2 01sep98 .044
2 01oct98 .043
2 01nov98 .042
2 01dec98 .043
2 01jan99 .040
2 01feb99 .042
2 01mar99 .041
2 01apr99 .040
2 01may99 .038
2 01jun99 .034
2 01jul99 .037
2 01aug99 .033
2 01sep99 .028
2 01oct99 .023
2 01nov99 .021
2 01dec99 .018
2 01jan00 .017
2 01feb00 -.003
2 01mar00 .001
2 01apr00 .002
2 01may00 -.003
2 01jun00 -.002
2 01jul00 -.003
2 01aug00 -.006
2 01sep00 -.003
2 01oct00 -.007
2 01nov00 -.010
2 01dec00 -.013
2 24dec00 -.015
; 
run; 


data myanno;
length function style $12;
xsys='2'; ysys='2'; hsys='3'; when='a';

   /* Add a text label to look like a title */
   function='label'; x='01may95'd; style=''; color='white'; position='B';
   y=.11; size=5.5; text='U.S. Personal Savings Rate'; output;
   y=.098; size=4.5; text='1990 - 2001'; output;
   

   /* identify 2 diagonal corners, and image will go between them */
   function='move'; x='01mar90'd; y=-.017; output;
   function='image'; x=x+1100; y=y+.01; imgpath='zealllc_logo.jpg'; style='fit'; 
   html='title="ZealLLC" href="http://www.ZealLLC.com"';
   output;

   function='move'; x='01nov90'd; y=.011; output;
   function='image'; x=x+900; y=y+.03; imgpath='break_bank.jpg'; style='fit'; 
   html='title="ZealLLC" href="http://www.ZealLLC.com"';
   output;

   function='move'; x='01jan98'd; y=.06; output;
   function='image'; x=x+500; y=y+.03; imgpath='rob_bank.jpg'; style='fit'; 
   html='title="ZealLLC" href="http://www.ZealLLC.com"';
   output;

run;


goptions device=png;
goptions border cback=white;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm"
 (title="SAS/Graph GPLOT with annotated images") 
 gtitle nogfootnote style=d3d;

goptions gunit=pct htext=3.5 ctext=gray33 ftext="albany amt/bold";

symbol1 interpol=join color=black width=3 l=2;
symbol2 interpol=join color=red width=3;

axis1 label=none order=(-.02 to .12 by .02) minor=none;

axis2 label=none order=('01jan90'd to '01jan01'd by year) minor=none value=(angle=40);

title h=1 " ";  /* I annotate the title in this graph */

footnote color=black height=12pt 
 "Imitation of plot in "
 link="http://www.gold-eagle.com/gold_digest_01/hamilton040901.html" 
 "http://www.gold-eagle.com/gold_digest_01/hamilton040901.html";

proc gplot data=savings anno=myanno; 
plot value*date=line / 
 cframe=grayc1 nolegend 
 vaxis=axis1 vref=0 
 haxis=axis2 
 des='' name="&name"; 
run; 

quit;
ODS HTML CLOSE;
ODS LISTING;

*====================================================================risk loss ===========================================*;
%let name=heat;
filename odsout '.';

/* To 'generalize' this code, I've tried to separate out all the
   parts that might change from data-to-data, and make them 
   macro variables here at the top of the program */

/* All of these macro variables might be passed-in, rather than hard-coded */
%let rowname=risk_name; 
%let lossname=expected_annual_loss;
%let riskname=expected_risk_frequency;
%let color1=CX00ff00;   /* Color for 'green' area */
%let color2=CXffcc33;   /* Color for 'amber' area */
%let color3=CXff0000;   /* Color for 'red' area */
%let colordot=cyan;     /* Color for markers/dots in plot */


/* For this demo, using a pre-summarized data set */
libname here '.';
data ds1; set here.ds1; 
run;

proc sql;
 select min(risk)*.9 into :minrisk from ds1;
 select max(risk)*1.1 into :maxrisk from ds1;
 select -1*(((max(risk)*1.1)-(min(risk)*.9))/6) into :byrisk from ds1;
quit; run;

%let y_variable=loss;   /* Coordinate to use on y-axis */
%let x_variable=risk;   /* Coordinate to use on x-axis */

data ds1; set ds1;
format loss dollar20.0;
format risk comma10.0;
label loss='Expected Annual Loss';
label risk='Average Risk Frequency';
length myhtml $500;
 myhtml='title='||quote(
  'ID:   '||trim(left(id))||'0D'x||
  'Risk Frequency: '||trim(left(put(&x_variable,comma10.1)))||'0D'x||
  'Expected Loss: '||trim(left(put(&y_variable,dollar20.0))))||
 ' href="heat_info.htm"';
run;

/*
Annotating the pointlabels, since the automatic symbol statement
pointlabels have a lenght limit of 16 or 17
*/
data anno_pointlabels; set ds1;
length color function $8 style $20 text $50;
xsys='2'; ysys='2'; hsys='3';
x=&x_variable; 
y=&y_variable;
function='label'; position='2'; size=2;
cbox='white';
text=trim(left(id));
run;


data anno_color_ranges; 
length color function $8 style $20 text $50;
xsys='1'; ysys='1'; when='b';  

/* Bottom color background area */
function='move';
 x=0; y=0;  /* bottom/left corner of bottom color area */
output;
function='bar';
 x=100; y=(3/9)*100;  /* top/right corner of bottom color area */
 color="&color1";
 style='solid';
output;

/* Middle color background area (done in 2 pieces) */
/* first, the horizontal piece */
function='move';
 x=0; y=(3/9)*100;
output;
function='bar';
 x=100; y=(5/9)*100;
 color="&color2";
 style='solid';
output;
function='move';
 x=0; y=(5/9)*100;
output;
function='bar';
 x=(1/3)*100; y=100;
 color="&color2";
 style='solid';
output;

/* Top color background area */
function='move';
 x=(1/3)*100; y=(5/9)*100;
output;
function='bar';
 x=100;   y=100; 
 color="&color3";
 style='solid';
output;


/* Fake legend color bars (using annotate) */

function='move';
 xsys='1'; ysys='1';
 x=100; y=0;
output;
 function='move';
 xsys='A'; ysys='A';
 x=+4; y=+0;
output;
 function='bar';
 xsys='A'; ysys='A';
 x=+5.5; y=+1;
 color="&color1";
 style='solid';
 line=0;
output;
 function='move';
 xsys='A'; ysys='A';
 x=-5.5; y=+.5;
output;
 function='bar';
 xsys='A'; ysys='A';
 x=+5.5; y=+1;
 color="&color2";
 style='solid';
 line=0;
output;
 function='move';
 xsys='A'; ysys='A';
 x=-5.5; y=+.5;
output;
 function='bar';
 xsys='A'; ysys='A';
 x=+5.5; y=+1;
 color="&color3";
 style='solid';
 line=0;
output;

/* 'Fake' legend text (red, amber, green) (using annotate) */

function='move';
 xsys='1'; ysys='1';
 x=100; y=0;
output;
function='cntl2txt';
output;
 function='label';
 xsys='A'; ysys='A';
 x=+11; y=+.75;
 text='Green'; style=''; color='black'; position='6';
output;

function='move';
 xsys='1'; ysys='1';
 x=100; y=0;
output;
function='cntl2txt';
output;
 function='label';
 xsys='A'; ysys='A';
 x=+11; y=+2.25;
 text='Amber'; style=''; color='black'; position='6';
output;

function='move';
 xsys='1'; ysys='1';
 x=100; y=0;
output;
function='cntl2txt';
output;
 function='label';
 xsys='A'; ysys='A';
 x=+11; y=+3.75;
 text='Red'; style=''; color='black'; position='6';
output;

run;


goptions device=png;
goptions xpixels=900 ypixels=600 noborder;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm"
 (title="SAS/Graph risk heat map (proof-of-concept using contrived data)")
 style=htmlblue;

goptions gunit=pct htitle=4.5 ftitle="albany amt/bold" htext=2.5 ftext="albany amt/bold";
 
title1 j=c ls=1.5 'Control Heat-map For Current Period (2003 Q2)';

title2 a=-90 h=17 ' ';  /* right side */
title3 a=90 h=1 ' ';   /* left side */

/*
Would like to use pointlabel rather than annotate, but pointlabel only 
supports 16 or 17 characters...
symbol1 h=4 v=dot c=&colordot pointlabel=("#id") i=none;
*/
symbol1 h=4 v=dot c=&colordot i=none;
symbol2 h=4 v=circle c=black i=none;

axis1 label=(c=blue)
 order=(&maxrisk to &minrisk by &byrisk)
 major=(number=7) minor=none   
 value=(
   tick=2 c=blue 'High' 
   tick=4 c=blue 'Med' 
   tick=6 c=blue 'Low')
 offset=(0,0);

axis2 label=(c=blue) major=(number=10) minor=none offset=(0,0);

proc gplot data=ds1 anno=anno_color_ranges;
plot &y_variable*&x_variable &y_variable*&x_variable / overlay 
 haxis=axis1 vaxis=axis2
 autovref cvref=grayaa lvref=1    
 autohref chref=grayaa lhref=1
 anno=anno_pointlabels
 html=myhtml 
 des='' name="&name";
run;

quit;
ODS HTML CLOSE;
ODS LISTING;

*==================================================================== Commute Comparison    ==========================================*;
%let name=travel;
filename odsout '.';


data state_data; 
input state $ 1-21 average lower upper;
datalines;
United States             24.3      24.1      24.5 
Alabama                   22.8      22.3      23.3 
Alaska                    18.7      17.4      20.0 
Arizona                   23.2      22.4      24.0 
Arkansas                  19.8      19.3      20.3 
California                26.5      26.2      26.8 
Colorado                  23.1      22.6      23.6 
Connecticut               24.0      23.5      24.5 
Delaware                  23.1      22.4      23.8 
District of Columbia      28.5      27.8      29.2 
Florida                   24.5      24.2      24.8 
Georgia                   26.3      25.1      27.5 
Hawaii                    25.2      24.0      26.4 
Idaho                     19.5      18.8      20.2 
Illinois                  27.2      26.7      27.7 
Indiana                   21.3      20.6      22.0 
Iowa                      17.8      17.0      18.6 
Kansas                    17.8      16.6      19.0 
Kentucky                  22.5      21.5      23.5 
Louisiana                 22.9      22.2      23.6 
Maine                     22.4      21.6      23.2 
Maryland                  29.7      29.2      30.2 
Massachusetts             26.1      25.8      26.4 
Michigan                  23.1      22.6      23.6 
Minnesota                 21.6      20.6      22.6 
Mississippi               22.0      20.8      23.2 
Missouri                  23.2      22.4      24.0 
Montana                   15.8      15.1      16.5 
Nebraska                  16.5      16.0      17.0 
Nevada                    21.6      21.1      22.1 
New Hampshire             24.0      23.3      24.7 
New Jersey                29.1      28.8      29.4 
New Mexico                19.6      18.9      20.3 
New York                  30.5      30.2      30.8 
North Carolina            22.9      22.2      23.6 
North Dakota              15.2      14.7      15.7 
Ohio                      21.7      21.4      22.0 
Oklahoma                  19.5      18.5      20.5 
Oregon                    21.3      20.6      22.0 
Pennsylvania              23.8      23.5      24.1 
Rhode Island              21.9      21.4      22.4 
South Carolina            22.5      21.7      23.3 
South Dakota              15.1      14.4      15.8 
Tennessee                 23.2      21.9      24.5 
Texas                     23.9      23.6      24.2 
Utah                      20.3      19.3      21.3 
Vermont                   20.8      20.1      21.5 
Virginia                  25.6      25.3      25.9 
Washington                25.1      24.3      25.9 
West Virginia             26.2      24.9      27.5 
Wisconsin                 20.3      20.0      20.6 
Wyoming                   18.0      16.2      19.8 
;
run;

proc sort data=state_data out=state_data;
by descending average;
run;

data state_data; set state_data;
length html $400 function $8 color $8;
label plot_rank = 'Rank';
label state = 'State';
label average = 'Average';
label lower = 'Lower Bound';
label upper = 'Upper Bound';
plot_rank+1;
html=
 'title='||quote(
  trim(left(state))||' '||'0D'x||
  'average: '||trim(left(average))||' '||'0D'x||
  'lower: '||trim(left(lower))||' '||'0D'x||
  'upper: '||trim(left(upper)))||
 ' href="travel_info.htm"';
run;


proc sql;
create table foo as
select unique plot_rank as start, state as label
from state_data;
quit; run;
data control; set foo;
fmtname = 'pltfmt';
type = 'N';
end = START;
run;
proc format lib=work cntlin=control;
run;


/*
I annotate the markers, rather than using the symbol statement, so I can have
easier control over the colors, etc 
*/
data anno_markers; set state_data;
length function color $8 style $12;
xsys='2'; ysys='2'; hsys='4'; when='a'; 

if state='United States' then color='red';
else color='blue'; 

/* Annotate the dot in the middle */
x=average;
y=plot_rank; 
function='pie'; style='psolid'; rotate=360; size=.3; output;
style='pempty'; size=size*1.1; output;

/* Annotate a horizontal line over each dot */
line=1; size=1.8; 
function='move'; x=lower; y=plot_rank; output;
function='draw'; x=upper; y=plot_rank; output;

/* Annotate the vertical tail on left side of each dot */
function='move'; x=lower; y=plot_rank-.3; output;
function='draw'; x=lower; y=plot_rank+.3; output;

/* Annotate the vertical tail on right side of each dot */
function='move'; x=upper; y=plot_rank-.3; output;
function='draw'; x=upper; y=plot_rank+.3; output;

run;

goptions device=png;
goptions xpixels=600 ypixels=1000;
goptions noborder;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" 
 (title="Average Travel Time to Work") style=htmlblue;

goptions ftitle="albany amt/bold" ftext="albany amt" gunit=pct htitle=18pt htext=10pt;

/* Blank out the numeric tickmark labels along y-axis, so you'll
   have a clean slate to annotate the state names */
axis1 order=(52 to 1 by -1) major=none label=none;

axis2 order=(0 to 50 by 5) label=('Average Travel Time to Work (In Minutes)') 
  major=(height=.15) minor=none offset=(0,0);

title1 ls=0.8 "Average Travel Time to Work (In Minutes)";
title2 h=12pt "Workers 16 Years and Over";
title3 h=12pt "(Mouse over dots to see detailed data)";
title4 a=90 h=1 " ";
title5 a=-90 h=1 " ";

footnote 
 link="http://www.census.gov/acs/www/Products/Ranking/SS01/R04G040.htm" 
 "Source: U.S. Census Bureau, 2001 Supplementary Survey";

symbol i=none v=point c=white;

/* Plot numeric rank, rather than state name, so states are sorted that way */
proc gplot data=state_data anno=anno_markers;
format plot_rank pltfmt.;
plot plot_rank*average / 
 vaxis=axis1 haxis=axis2 
 href=5 10 15 20 25 30 35 40 45
 chref=graydd
 autovref cvref=graydd
 des='' name="&name";
run;

title;
footnote;
proc print data=state_data label noobs; 
var plot_rank state average lower upper;
run;

quit;
ODS HTML CLOSE;
ODS LISTING;

*======================================================================Poverty Rate Analysis==========================================================*;
%let name=poorplt;
filename odsout '.';

data poverty;
input year millions percent;
datalines;
1959 39 22.5
1960 40 22
1961 39 21.5
1962 38 21
1963 37 19
1964 37 18.5
1965 33 17
1966 28 14
1967 27 13.5
1968 25 13
1969 24 12
1970 25.5 13
1971 25.2 13
1972 24.5 12
1973 23 11
1974 24 11
1975 26 12
1976 25 11
1977 25 11
1978 24.5 11
1979 26 11
1980 29 13
1981 32 14
1982 34 15
1983 35 15
1984 33 14
1985 33 14
1986 32 13.5
1987 32 13.5
1988 31 13
1989 32 13
1990 33 13
1991 34 14
1992 38 15 
1993 39 15
1994 37 14.5
1995 36 14
1996 36 14
1997 35.5 13.5
1998 34 13
1999 32.3 11.8
;
run;

data poverty; set poverty;
length myhtmlvar $200;
myhtmlvar=
 'title='||quote( 
  'Year: '||trim(left(year))||'0D'x||
  'Number in poverty: '||trim(left(millions))||' million'||'0D'x||
  'Poverty rate: '||trim(left(percent))||'% ')||
 ' href="poorplt_info.htm"';
run;


data anno_poverty;
length function color $8 style $20 position $1 text $200;
xsys='2'; ysys='2'; hsys='4'; when='a'; 
function='label'; position='5'; size=1.25; 
input x y position $ 9 text $ 11-30;
datalines;
1983 12 6 Poverty rate                        
1983 38 6 Number in poverty             
1999 13 6 . 11.8 percent                      
1999 34 6 . 32.3 million                       
;
run;

data anno_labels;
length function style color $8 text $200;
xsys='3'; ysys='3'; hsys='3'; when='a';

/* gray box above top/right of graph */
color='graydd'; style='solid';
function='poly'; 
 x=79; y=83; output;
function='polycont';
 x=x+2; output;
 y=y+3; output;
 x=x-2; output;
 y=y-3; output;

/* Various text labels */
function='label'; position='6';
size=.; style=''; color='';
 x=82; y=84.5; text='Recession'; output;
 x=5; y=84.5; text='Numbers in millions, rates in percent'; output;
 x=2; y=10; text='Note:  The data points represent the midpoints of the respective years.  The longest recession began in July 1 19?? and ended in March 1 19??'; output;
 x=2; y=6; text='Source:  _not_ U.S. Census Bureau, Current Populaton Survey, March 1960-2000.'; output;

run;

data anno_recessions;
input start_date end_date;
datalines;
1959.70 1960.75
1969.40 1970.45  
1973.30 1974.75  
1978.30 1978.95 
1980.00 1981.45  
1990.00 1990.55
;
run;

data anno_recessions; set anno_recessions;
length function color $8;
xsys='2'; ysys='1'; when='b'; color='graydd'; style='solid';
function='move'; x=start_date; y=0; output;
function='bar'; x=end_date; y=100; output;
run;

data anno_all;
 set anno_recessions anno_poverty anno_labels; 
run;


goptions device=png;
goptions xpixels=850 ypixels=420;
goptions noborder;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" 
 (title="SAS/Graph - Poor and Poverty Rate plot") style=htmlblue;

goptions gunit=pct ftitle="albany amt/bold" ftext="albany amt" htitle=5 htext=2.8 cback=white ;

title1 j=l move=(+2,+0) "Figure 1.";
title2 j=l move=(+2,+0) h=5 font="albany amt/bold" "Number of Poor and Poverty Rate: 1959 to 1999";
title3 " ";
title4 a=-90 h=3 " ";

footnote1 h=7 " ";
footnote2 "Imitation of "
  c=blue link="http://www.census.gov/hhes/poverty/poverty99/pov99.html" 
  "http://www.census.gov/hhes/poverty/poverty99/pov99.html";

symbol1 v=dot h=2.5 cv=graydd i=spline w=3 ci=black;
symbol2 v=dot h=2.5 cv=graydd i=spline w=3 ci=black;

axis1 order=(0 to 45 by 5) minor=none label=none offset=(0,0);
axis2 order=(1959 to 1999 by 5) minor=(number=4) label=none;
/* Tricky axis for right-hand side.  This blanks out the label & the tickmarks. */
axis3 order=(0 to 45 by 45) minor=none major=none label=('                ') value=(' ' ' ');

proc gplot data=poverty annotate=anno_all; 
 plot millions*year=1 / 
  vaxis=axis1 autovref cvref=graydd
  haxis=axis2  
  html=myhtmlvar 
  des='' name="&name"; 
 plot2 percent*year=2 / 
  html=myhtmlvar 
  vaxis=axis3; 
run;

quit;
ODS HTML CLOSE;
ODS LISTING;
 
