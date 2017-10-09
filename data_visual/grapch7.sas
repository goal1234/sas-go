*---------------------------------------bar and lines -------------------------------------*;
%let name=calls;
filename odsout '.';

/*
As of SAS v9.1.3, the GBARLINE only allows 1 line to be used with the bar.
This example shows one way you might 'imitate' a barline plot, using 
regular GPLOT (with wide 'needles' that look like bars).
This technique should work with just about any version of sas that
is currently in the field.
*/

data my_data;
format date monyy5.;  
format Product1 Product2 Product3 Product4 Product5 percent6.0;
format calls comma8.;
input date date7. calls Product1 Product2 Product3 Product4 Product5;
datalines;
15apr03 27600 .93 .65 .16 .15 .22
15may03 26000 .91 .67 .13 .12 .20
15jun03 29000 .81 .77 .12 .15 .18
15jul03 31000 .83 .77 .17 .13 .17
15aug03 34000 .92 .77 .12 .15 .16
15sep03 39600 .96 .67 .22 .14 .16
15oct03 44300 .98 .67 .44 .15 .18
15nov03 48200 .98 .66 .59 .15 .16
15dec03 38000 .91 .78 .69 .19 .16
15jan04 22500 .98 .67 .16 .29 .12
15feb04 25000 .97 .67 .11 .30 .12
15mar04 28000 .96 .66 .19 .33 .13
15apr04 32000 .96 .66 .10 .34 .16
15may04 27000 .85 .76 .17 .32 .17
15jun04 28300 .86 .75 .14 .33 .15
;
run;

data my_data; set my_data;
length myhtml $500;
myhtml=
 'title='||quote(
  'Date:         '||trim(left(put(date,monyy5.)))||'0D'x||
  'Total Calls:  '||trim(left(put(calls,comma8.)))||'0D'x||
  '------------------------- '||'0D'x||
  'Product1:     '||trim(left(put(Product1,percent6.0)))||'0D'x||
  'Product2:     '||trim(left(put(Product2,percent6.0)))||'0D'x||
  'Product3:     '||trim(left(put(Product3,percent6.0)))||'0D'x||
  'Product4:     '||trim(left(put(Product4,percent6.0)))||'0D'x||
  'Product5:     '||trim(left(put(Product5,percent6.0)))
  )|| 
 ' href="calls_info.htm"';
run;

data anno_img;
length function $8;
xsys='3'; ysys='3'; hsys='3'; when='A';

 /* phone image from http://www.telephoneart.com */
 function='move'; x=0; y=42; output;
 function='image'; x=x+8; y=y+11; imgpath='phone.gif'; style='fit'; output;

 /* checkmark image from http://www.aperfectworld.org/academic.htm */
 function='move'; x=91; y=42; output;
 function='image'; x=x+8; y=y+11; imgpath='check.gif'; style='fit'; output;

run;


goptions device=png;
goptions xpixels=1100 ypixels=450;
goptions noborder;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm"
  (title="SAS/Graph gplot - lines and simulated bars") style=minimal;

goptions ftitle="albany amt" ftext="albany amt" htitle=4.5pct htext=2.5pct;

axis1 label=(a=-90 'Product Completion Rates') 
 minor=none offset=(0,0) order=(0 to 1.00 by .2);

axis2 label=(a=90 f="albany amt" c=black 'Selling Team Sales Calls   ' f=marker c=cxffd45d 'U') 
 minor=none offset=(0,0) order=(0 to 50000 by 10000);

axis3 minor=none label=none offset=(3,3) order=('15apr03'd to '15jun04'd by month); 

legend1 position=(right bottom) across=1 label=none frame repeat=1;

/* Instead of using the regular line plot symbol markers, I'm using characters
   from the sas/graph 'marker' software font for some of the symbols, which look better.
   I'm also using a 'spline' interpolation to look 'pretty' -- you could change it
   to 'join' which would probably be more technically correct.  */
symbol1 w=1 font=marker value='P' i=spline c=cx0000ff;
symbol2 w=1 font=marker value='U' i=spline c=green;
symbol3 w=1 font=marker value='C' i=spline c=red;
symbol4 w=1 value=dot h=1.5 i=spline c=purple;
symbol5 w=1 font=marker value='V' i=spline c=magenta h=1.2;

/* This is how I make the things that "look" like bars in the plot (they're 
   actually very wide 'needles' rather than bars.  But hey - if it looks like
   a duck, walks like a duck, and sounds like a duck ... ;)   */
symbol6 i=needle w=25 c=cxffd45d;

title1 
 j=l " Number of Calls (bars)" 
 j=r "Completion Rates (lines) ";

title2 a=90 h=18pct " ";

footnote c=gray "Mouse over markers to see detailed data";

proc gplot data=my_data anno=anno_img; 
/* do the needle/bars first, so they'll be 'behind' the lines */
plot calls*date=6 /
 vaxis=axis2 haxis=axis3
 href='15dec03'd lhref=2 chref=gray
 des='' name="&name";
/* Now, do all the lines last, so they'll be 'on top of' the bars */
plot2 Product1*date=1 Product2*date=2 Product3*date=3 Product4*date=4 Product5*date=5 / overlay
 vaxis=axis1 cframe=grayfb
 autovref lvref=2 cvref=graycc
 legend=legend1
 html=myhtml;
run; 

quit;
ODS HTML CLOSE;
ODS LISTING;

*-------------------------------------------------------------------------------------------------*;
%let name=calls;
filename odsout '.';

/*
As of SAS v9.1.3, the GBARLINE only allows 1 line to be used with the bar.
This example shows one way you might 'imitate' a barline plot, using 
regular GPLOT (with wide 'needles' that look like bars).
This technique should work with just about any version of sas that
is currently in the field.
*/

data my_data;
format date monyy5.;  
format Product1 Product2 Product3 Product4 Product5 percent6.0;
format calls comma8.;
input date date7. calls Product1 Product2 Product3 Product4 Product5;
datalines;
15apr03 27600 .93 .65 .16 .15 .22
15may03 26000 .91 .67 .13 .12 .20
15jun03 29000 .81 .77 .12 .15 .18
15jul03 31000 .83 .77 .17 .13 .17
15aug03 34000 .92 .77 .12 .15 .16
15sep03 39600 .96 .67 .22 .14 .16
15oct03 44300 .98 .67 .44 .15 .18
15nov03 48200 .98 .66 .59 .15 .16
15dec03 38000 .91 .78 .69 .19 .16
15jan04 22500 .98 .67 .16 .29 .12
15feb04 25000 .97 .67 .11 .30 .12
15mar04 28000 .96 .66 .19 .33 .13
15apr04 32000 .96 .66 .10 .34 .16
15may04 27000 .85 .76 .17 .32 .17
15jun04 28300 .86 .75 .14 .33 .15
;
run;

data my_data; set my_data;
length myhtml $500;
myhtml=
 'title='||quote(
  'Date:         '||trim(left(put(date,monyy5.)))||'0D'x||
  'Total Calls:  '||trim(left(put(calls,comma8.)))||'0D'x||
  '------------------------- '||'0D'x||
  'Product1:     '||trim(left(put(Product1,percent6.0)))||'0D'x||
  'Product2:     '||trim(left(put(Product2,percent6.0)))||'0D'x||
  'Product3:     '||trim(left(put(Product3,percent6.0)))||'0D'x||
  'Product4:     '||trim(left(put(Product4,percent6.0)))||'0D'x||
  'Product5:     '||trim(left(put(Product5,percent6.0)))
  )|| 
 ' href="calls_info.htm"';
run;

data anno_img;
length function $8;
xsys='3'; ysys='3'; hsys='3'; when='A';

 /* phone image from http://www.telephoneart.com */
 function='move'; x=0; y=42; output;
 function='image'; x=x+8; y=y+11; imgpath='phone.gif'; style='fit'; output;

 /* checkmark image from http://www.aperfectworld.org/academic.htm */
 function='move'; x=91; y=42; output;
 function='image'; x=x+8; y=y+11; imgpath='check.gif'; style='fit'; output;

run;


goptions device=png;
goptions xpixels=1100 ypixels=450;
goptions noborder;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm"
  (title="SAS/Graph gplot - lines and simulated bars") style=minimal;

goptions ftitle="albany amt" ftext="albany amt" htitle=4.5pct htext=2.5pct;

axis1 label=(a=-90 'Product Completion Rates') 
 minor=none offset=(0,0) order=(0 to 1.00 by .2);

axis2 label=(a=90 f="albany amt" c=black 'Selling Team Sales Calls   ' f=marker c=cxffd45d 'U') 
 minor=none offset=(0,0) order=(0 to 50000 by 10000);

axis3 minor=none label=none offset=(3,3) order=('15apr03'd to '15jun04'd by month); 

legend1 position=(right bottom) across=1 label=none frame repeat=1;

/* Instead of using the regular line plot symbol markers, I'm using characters
   from the sas/graph 'marker' software font for some of the symbols, which look better.
   I'm also using a 'spline' interpolation to look 'pretty' -- you could change it
   to 'join' which would probably be more technically correct.  */
symbol1 w=1 font=marker value='P' i=spline c=cx0000ff;
symbol2 w=1 font=marker value='U' i=spline c=green;
symbol3 w=1 font=marker value='C' i=spline c=red;
symbol4 w=1 value=dot h=1.5 i=spline c=purple;
symbol5 w=1 font=marker value='V' i=spline c=magenta h=1.2;

/* This is how I make the things that "look" like bars in the plot (they're 
   actually very wide 'needles' rather than bars.  But hey - if it looks like
   a duck, walks like a duck, and sounds like a duck ... ;)   */
symbol6 i=needle w=25 c=cxffd45d;

title1 
 j=l " Number of Calls (bars)" 
 j=r "Completion Rates (lines) ";

title2 a=90 h=18pct " ";

footnote c=gray "Mouse over markers to see detailed data";

proc gplot data=my_data anno=anno_img; 
/* do the needle/bars first, so they'll be 'behind' the lines */
plot calls*date=6 /
 vaxis=axis2 haxis=axis3
 href='15dec03'd lhref=2 chref=gray
 des='' name="&name";
/* Now, do all the lines last, so they'll be 'on top of' the bars */
plot2 Product1*date=1 Product2*date=2 Product3*date=3 Product4*date=4 Product5*date=5 / overlay
 vaxis=axis1 cframe=grayfb
 autovref lvref=2 cvref=graycc
 legend=legend1
 html=myhtml;
run; 

quit;
ODS HTML CLOSE;
ODS LISTING;


*------------------------------------------------多指标对比-------------------------------------------*;
%let name=dealer;
filename odsout '.';

data mydata;
input dealer $ 1-20 measure $ 22-43 value;
datalines;
Hendrick Dodge       Loan to Value           80
Hendrick Dodge       Loan Amount             25000
Hendrick Dodge       Chargeoff Pct           4
Hendrick Dodge       Chargeoff Amt           1000
Performance Chevy    Loan to Value           70
Performance Chevy    Loan Amount             15000
Performance Chevy    Chargeoff Pct           5
Performance Chevy    Chargeoff Amt           500 
CrossRoads Ford      Loan to Value           60
CrossRoads Ford      Loan Amount             20000
CrossRoads Ford      Chargeoff Pct           6
CrossRoads Ford      Chargeoff Amt           750 
;
run;

/* Set up the mouseover charttip info */
data mydata; set mydata;
length htmlvar $200;
htmlvar=
 'title='||quote(
  'Dealer:  '||trim(left(dealer))||'0D'x||
  'Measure: '||trim(left(measure))||'0D'x||
  'Value:   '||trim(left(value))
  )||
 ' href="dealer_info.htm"';
run;


/* Here are some macro variables that will be used for 'normalizing'
   the data values, so they can be plotted in the same 0->1 axis.
*/
%let maxltv=100;     /* Loan to Value */
%let maxloan=50000;  /* Loan Amount */
%let maxcopct=10;    /* Chargeoff Pct */
%let maxcoamt=2000;  /* Chargeoff Amt */

/* Calculated the 'normalized' values */
data mydata; set mydata;
if measure eq 'Loan to Value' then nvalue=(value/&maxltv);
if measure eq 'Loan Amount'   then nvalue=(value/&maxloan);
if measure eq 'Chargeoff Pct' then nvalue=(value/&maxcopct);
if measure eq 'Chargeoff Amt' then nvalue=(value/&maxcoamt);
run;


/* Create custom annotated text labels for each axis */
data anno_label; 
length function color cbox  $8 text $10;
xsys='2'; ysys='2'; when='a';
function='label'; size=1.5; color='black';
xc='Loan to Value'; y=0; text='0%'; position='a'; output;
xc='Loan Amount';   y=0; text='$0'; position='c'; output;
xc='Chargeoff Pct'; y=0; text='0%'; position='c'; output;
xc='Chargeoff Amt'; y=0; text='$0'; position='c'; output;
xc='Loan to Value'; y=1; text=trim(left(&maxltv))||'%'; position='d'; output;
xc='Loan Amount';   y=1; text='$'||trim(left(&maxloan)); position='f'; output;
xc='Chargeoff Pct'; y=1; text=trim(left(&maxcopct))||'%'; position='f'; output;
xc='Chargeoff Amt'; y=1; text='$'||trim(left(&maxcoamt)); position='f'; output;
run;


data anno_colors;
length function style color $10;
xsys='3'; ysys='3'; when='b'; style='solid';
orig_red=  input('ad',hex2.);
orig_green=input('dd',hex2.);
orig_blue= input('8e',hex2.);
do i=0 to 100 by 2;
 count+1;
 function='move'; x=0; y=i; output;
 function='bar'; x=100;  y=i-2;
 percent=(count-1)/(60);
 red=orig_red     + ( (256-orig_red)   * percent );
 if red > 255 then red=255;
 green=orig_green + ( (256-orig_green) * percent );
 if green > 255 then green=255;
 blue=orig_blue   + ( (256-orig_blue)  * percent );
 if blue > 255 then blue=255;
 rgb=put(red,hex2.)||put(green,hex2.)||put(blue,hex2.);
 color="cx"||rgb;
 output;
 end;
run;


goptions device=png;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm"
 (title="SAS/GRAPH Overlay Plot") style=htmlblue;

goptions gunit=pct htitle=5 htext=3;
goptions ftitle="albany amt" ftext="albany amt";

symbol i=join v=dot w=2 h=3;

axis1 order=(0 to 1 by .2) value=none label=none minor=none offset=(0,0);
axis2 offset=(5,5) label=none;

/* link=" http://www.vrvis.at/vis/research/ang-brush/" */                                 
title1 ls=1.5 "Car Dealership Comparison";
title2 "(mouse over markers to see detailed info)";

footnote j=r c=gray move=(-1,+0) "This example uses contrived data";

legend1 cborder=black cblock=gray cframe=cornsilk;

proc gplot data=mydata anno=anno_colors;
plot nvalue*measure=dealer / anno=anno_label
 vaxis=axis1 haxis=axis2
 legend=legend1 cframe=cornsilk
 autohref chref=graycc
 autovref cvref=graycc
 html=htmlvar
des='' name="&name"; 
run;

quit;
ODS HTML CLOSE;
ODS LISTING;

*-----------------------------------------------------------雷达图分析------------------------------------*;
%let name=radar;
filename odsout '.';

data mydata;
input Dealership $ 1-20 measure $ 22-43 value;
datalines;
Hendrick Dodge       Loan to Value           80
Hendrick Dodge       Loan Amount             25000
Hendrick Dodge       Chargeoff Pct           4
Hendrick Dodge       Chargeoff Amt           1000
Performance Chevy    Loan to Value           70
Performance Chevy    Loan Amount             15000
Performance Chevy    Chargeoff Pct           5
Performance Chevy    Chargeoff Amt           500 
CrossRoads Ford      Loan to Value           60
CrossRoads Ford      Loan Amount             20000
CrossRoads Ford      Chargeoff Pct           6
CrossRoads Ford      Chargeoff Amt           750 
;
run;



/* Or, if you want the lightest color in the center */
data anno_colors;
length function style color $10;
xsys='3'; ysys='3'; when='b';
style='solid';
orig_red=  input('ad',hex2.);
orig_green=input('dd',hex2.);
orig_blue= input('8e',hex2.);
function='move'; x=50; y=50; output;
do i=0 to 100 by 2;
 count+1;
 function='pie';
 rotate=360;
 size=50-(i/2);
 percent=(count-1)/(43);
 red=orig_red     + ( (256-orig_red)   * percent );
 if red > 255 then red=255;
 green=orig_green + ( (256-orig_green) * percent );
 if green > 255 then green=255;
 blue=orig_blue   + ( (256-orig_blue)  * percent );
 if blue > 255 then blue=255;
 rgb=put(red,hex2.)||put(green,hex2.)||put(blue,hex2.);
 color="cx"||rgb;
 output;
 end;
run;



goptions device=png;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" (title="SAS/Graph Radar Chart") style=sasweb;

goptions gunit=pct htitle=5 htext=3;
goptions ftitle="albany amt" ftext="albany amt";

symbol interpol=join v=dot;

/*
The advantage here, over a normal gplot, is that each spoke can be 
an independently-scaled axis, and you don't have to 'normalize' the
values to plot them together (like you did in gplot).
*/
axis1 label=('Chargeoff Amt') major=(number=4) order=(0 to 2000 by 400);
axis2 label=('Chargeoff Pct') major=(number=4) order=(0 to 10 by 2);
axis3 label=('Loan Amount')   major=(number=4) order=(0 to 50000 by 10000);
axis4 label=('Loan to Value') major=(number=4) order=(0 to 100 by 20);

title1 ls=1.5 "Car Dealership Comparison";
title2 c=gray "This example uses contrived data";

legend1 cborder=black cblock=gray cframe=cornsilk;

proc gradar data=mydata anno=anno_colors;
chart measure / overlay=Dealership sumvar=value noframe
  cstars=(black red green)
  wstars=2 2 2
  lstars=1 1 1
  staroutradius=100 /* 100% of screen size for outer radius */
  starinradius=5  /* 5% of screen size for inner radius */
  spokescale=vertex /* aha! - this is an undocumented option that allows
     each of the axes to be scaled independently! */
  starcircles=(1.0)
  staraxis=(axis1, axis2, axis3, axis4) 
 des='' name="&name"; 
run;

quit;
ODS HTML CLOSE;
ODS LISTING;

*------------------------------------------------------start chart------------------------------------------------------*;
%let name=star;
filename odsout '.';

data mydata;
label dealer='00'x;  /* to suppress the dealer= in the titles */
input dealer $ 1-20 measure $ 22-43 value;
datalines;
Hendrick Dodge       Loan to Value           80
Hendrick Dodge       Loan Amount             25000
Hendrick Dodge       Chargeoff Pct           4
Hendrick Dodge       Chargeoff Amt           1000
Performance Chevy    Loan to Value           70
Performance Chevy    Loan Amount             15000
Performance Chevy    Chargeoff Pct           5
Performance Chevy    Chargeoff Amt           500 
CrossRoads Ford      Loan to Value           60
CrossRoads Ford      Loan Amount             20000
CrossRoads Ford      Chargeoff Pct           6
CrossRoads Ford      Chargeoff Amt           750 
;
run;

/*
Note that I can't specify the ranges for each of the axes 
(like I can in gradar), therefore I have to 'normalize' the
values to get them to plot to the same scale.
*/

/* 
Here are some macro variables that will be used for 'normalizing'
the data values, so they can be plotted in the same 0->1 axis.
*/
%let maxltv=100;     /* Loan to Value */
%let maxloan=50000;  /* Loan Amount */
%let maxcopct=10;    /* Chargeoff Pct */
%let maxcoamt=2000;  /* Chargeoff Amt */

/* Calculate the 'normalized' values (nvalue), so they'll all plot to the same scale */
data mydata; set mydata;
if measure eq 'Loan to Value' then nvalue=(value/&maxltv);
if measure eq 'Loan Amount'   then nvalue=(value/&maxloan);
if measure eq 'Chargeoff Pct' then nvalue=(value/&maxcopct);
if measure eq 'Chargeoff Amt' then nvalue=(value/&maxcoamt);
run;

/* Set up the mouseover charttip info */
data mydata; set mydata;
length htmlvar $200;
htmlvar=
 'title='|| quote(
  "Dealer: "||trim(left(dealer))||'0D'x||
  "Measure:   "||trim(left(measure))||'0D'x||
  "Value:   "||trim(left(value))
  )||
 ' href="star_info.htm"';
run;


goptions device=png border;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" (title="SAS/Graph Star Chart") style=sasweb;

goptions gunit=pct htitle=5 htext=2.6 ftitle="albany amt" ftext="albany amt";

title1 ls=1.5 "Car Dealership Comparison";
title2 "(mouse over star slices to see detailed info)";

footnote j=r c=gray "This example uses contrived data ";

legend1 cborder=black cblock=gray cframe=cornsilk;

pattern c=green v=empty repeat=4;

proc gchart data=mydata;
 star measure / type=sum sumvar=nvalue noheading 
 group=dealer
 across=2 down=2
 starmin=0 starmax=1
 slice=arrow value=none
 html=htmlvar
 des='' name="&name"; 
run;

quit;
ODS HTML CLOSE;
ODS LISTING;

*-----------------------------------------------------------frequency density----------------------------*;
%let name=margin;
filename odsout '.';

/* Just using some random data for this plot ... */
data mydata;
do i=1 to 100;
 y=round(ranuni(9)*100)/10;
 x=round(ranuni(8)*100)/10;
 /* for more 'interesting' data, bring x values in towards the center */
 if x < 5 then x=x*2;
 else if x > 5 then x=x/1.5;
 output;
 end;
run;

data mydata; set mydata;
length myhtml $500;
myhtml=
 'title='||quote(
  'X: '||trim(left(put(X,comma5.1)))||'0D'x||
  'Y: '||trim(left(put(Y,comma5.1)))
  )||
 ' href="margin_info.htm"';
run;


proc sql;

 create table x_anno as 
 select unique y from mydata;

 create table y_anno as 
 select unique x from mydata;

quit; run;


/* Annotate some green line segments along the axis/border of the plot */
data x_anno; set x_anno;
 xsys='1';  /* % of data area */
 ysys='2';  /* data-based */
 when='a';  
 color='red';
 function='move'; x=92; output;
 function='draw'; x=99; output;
run;

/* Do the 'flipside' along the other axis */
data y_anno; set y_anno;
 ysys='1';  /* % of data area */
 xsys='2';  /* data-based */
 when='a';  
 color='red';
 function='move'; y=92; output;
 function='draw'; y=99; output;
run;

data myanno; set y_anno x_anno; run;


/* annotate gradient color background */
data anno_colors;
length function style color $10;
xsys='3'; ysys='3'; when='b';
style='solid';
orig_red=  input('96',hex2.);
orig_green=input('96',hex2.);
orig_blue= input('96',hex2.);
function='move'; x=50; y=50; output;
do i=0 to 100 by 2;
 count+1;
 function='pie'; 
 rotate=360;
 size=50-(i/2);
 percent=(count-1)/(23);
 red=orig_red     + ( (256-orig_red)   * percent );
 if red > 255 then red=255;
 green=orig_green + ( (256-orig_green) * percent );
 if green > 255 then green=255;
 blue=orig_blue   + ( (256-orig_blue)  * percent );
 if blue > 255 then blue=255;
 rgb=put(red,hex2.)||put(green,hex2.)||put(blue,hex2.);
 color="cx"||rgb;
 output;
 end;
run;



goptions device=png;
goptions noborder;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" (title="Custom SAS/Graph border plot") style=minimal;

goptions gunit=pct ftitle="albany amt/bold" ftext="albany amt" htitle=6 htext=3.25;

/* Make your axis go out 1 unit farther than it normally would,
   and make the final tickmark value be 'blank' so it doesn't
   show a number - this is the border/line-segment area. */
axis1 order=(0 to 11 by 1) minor=none value=(t=12 ' ') offset=(0,0);

symbol interpol=none color=red value=triangle h=1.5;

title1 ls=1.5 "Border Plot";
title2 h=25pct a=90 " ";
title3 h=25pct a=-90 " ";

footnote "Margin Frequency-Distribution Graph";

proc gplot data=mydata anno=myanno; 
plot y*x / 
 haxis=axis1 vaxis=axis1
 /* Put a reference line at next to last tickmark, to look like axis line */
 href=10 vref=10
 anno=anno_colors
 html=myhtml
 des='' name="&name"; 
run; 

quit;
ODS HTML CLOSE;
ODS LISTING;

*-----------------------------------------------树图----------------------------------------*;
%let name=tree;
filename odsout '.';

data my_org;
input
name     $  1-32 /* employee's name */
empno    $ 34-37 /* employee's id number */
mgrno    $ 43-46 /* manager's employee id number */
deptname $ 52-80 /* Department name */
;
datalines;
Jim Goodson                      0001     0000     Executive
Stew Nisselsen                   0300     0001     Research and Development
Sanj Sharmanese                  2234     0300     Graphics
Eric Carmesuka                   2235     2234     Graphics - Charts
Ed Bunting                       2236     2234     Graphics - Maps
Basil Hit                        2436     2234     Graphics - Fonts   
Bill Guttenberg                  2736     2234     Graphics - Printing
Millie Zuniga                    2237     2234     Graphics - Documentation
Doug Cockerson                   2138     0300     Technology
Bill Lawson                      4138     2138     Patents    
Sally Corona                     9438     4138     Legal Secretary
Melissa Smith                    8331     4138     Legal Secretary
Jyoti Jones                      2345     0300     Web Products
Phillip Phillips                 2346     2345     Web Browsers
Jaclyn Turner                    2347     2345     Web Log Analyzers
John Doe                         2348     2345     Web Servers
John Latchsmith                  2349     2345     Web Surfing
Linda Southerson                 2350     2345     Search Engines
Bob Floatsom                     1001     0001     Testing
Jim Badson                       0222     1001     Tricky Testing
Annie Gunner                     5666     1001     Development Testing
Stue Dent                        5888     5666     Development Testing
Susan Dent                       5887     5666     Development Testing
Biff Barnes                      5556     1001     Traditional QA
Ziggy Starhem                    1556     5556     Cross-Platform
Indison Little                   1786     5556     Cross-Platform
Linda Lakemont                   0043     0001     Marketing
Koka Boots                       0819     0043     Brochures
Val Kilmore                      0018     0043     International Marketing
Krishna Smith                    6088     0018     Asian Marketing
Kyle Peterson                    6089     0018     Asian Marketing
Mary Contrarey                   6090     0018     Asian Marketing
Lawrence Arabia                  1810     0043     US Marketing
Joey Colorado                    1811     0043     US Marketing
Wright Man                       1819     1811     Conventions 
Gill Finn                        1839     1811     User Events 
Jennifer Scorcey                 1812     0043     US Marketing
;
run;

data my_org; set my_org;
length tiptext $ 50;
tiptext='Empno: '||trim(left(empno))||',    Unit: '||trim(left(deptname));
run;


goptions device=java;
 
title1 'Company Org Chart';
footnote1 'Click & Drag to reposition the tree';
footnote2 'Alt+Drag to rotate tree';

%ds2tree(ndata=my_org,
         htmlfile=&name..htm, xmltype=inline,
         nid=empno, nparent=mgrno, ntip=tiptext, nlabel=name,
/*
         codebase=http://sww.sas.com/dvt/codebase/v9.1/,
*/
         codebase=./,
         ARCHIVE=treeview.jar,
         height=500, width=600, cutoff=.5,
         septype=none, center=y, brtitle=SAS TreeView Sample,
         ttag=header 2, tcolor=black,
         tface=%str(Arial,Helvetica,sans-serif),
         ftag=header 4, fcolor=black,
         fface=%str(Arial,Helvetica,sans-serif)
         );
run;

*----------------------------------------------------------------------- Proc GAreaBar Chart---------------------------------------------*;
%let name=area;
filename odsout '.';

/* Since this example uses dev=actximg, it will only run on a pc */

data my_data; 
input Item $ 1-11 Cost;
datalines; 
Gas         150 
Electricity 112.5
Water       90
Food        225 
Travel      52.5 
Other       120 
;
run;

proc sql;
 create table my_data as 
 select *, (cost/sum(cost))*100 as share
 from my_data;
quit; run;

data my_data; set my_data;
label share="% Share";
label cost="Cost (" "a3"x ")";
run;

goptions device=actximg;
goptions xpixels=600 ypixels=300;
goptions noborder;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" (title="SAS/GRAPH GAREABAR Example") 
 gtitle nogfootnote style=sasweb;

goptions ftext="albany amt";
 
title1 h=18pt c=black "Budgeting Considerations";

/*
gareabar does not support 'axis' statements yet, so I can't
take out the minor tickmarks, and turn the axis label up/down.
Also, the discrete option doesn't seem to work.
*/

pattern1 v=solid c=cxffff99;
pattern2 v=solid c=cxccffcc;
pattern3 v=solid c=cxccffff;
pattern4 v=solid c=cxff99cc;
pattern5 v=solid c=cxccccff;
pattern6 v=solid c=cx00ccff;

proc gareabar data=my_data;
vbar item*share / sumvar=cost discrete
 cframe=white wstat=PERCENT 
 des='' name="&name";
run;

goptions reset=pattern;
pattern1 v=solid c=white repeat=6;

footnote c=gray h=12pt "Imitation of this graph... " 
 link="http://www.andypope.info/charts/colwidth.htm"
  "(click here)";

proc gareabar data=my_data;
vbar item*share / sumvar=cost discrete
 cframe=white wstat=PERCENT 
 des='' name="&name";
run;

quit;
ODS HTML CLOSE;
ODS LISTING;

*-------------------------------------------------------钟型图------------------------------------------------------*;
%let name=clock;
filename odsout '.';


data my_data;

/*
Remember, datetime() is the time the sas job started - when run via intrnet,
this assumes that a new sas job is started each time this is re-run 
*/
format datetime datetime.;
format justtime time.;
datetime=datetime();
justtime=timepart(datetime());

/* 
Find the number of seconds past midnight (ie, divide by number of seconds
per day, and then take the remainder - ie, take the modulus) 
*/
secpastmid=mod(datetime,86400);

/* Seconds past '12', for the pie-chart clock */
category='1st slice';
if secpastmid le 43200 then seconds=secpastmid;
else seconds=(secpastmid-43200);
length my_html $100;
my_html=
 'title='||quote('Time = '||trim(left(put(justtime,time.))))||
 ' href="clock_info.htm"';
output;

category='2nd slice';
seconds=43200-seconds;
my_html='';
output;

run;


proc sql noprint;
select unique justtime into :justtime separated by ' ' from my_data;
quit; run;


goptions device=png;
goptions xpixels=475 ypixels=400;
goptions cback=yellow;
goptions border;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm"
  (title="SAS/Graph Pie Chart representing clock time") style=htmlblue;

goptions gunit=pct ftitle="albany amt/bold" ftext="albany amt" htitle=8 htext=5;

title1 ls=1.5 c=purple "Time  &justtime";
title2 c=purple "pie represents hour hand";

pattern1 v=s c=purple;
pattern2 v=s c=yellow;

proc gchart data=my_data;
pie category / type=sum sumvar=seconds clockwise
 noheading slice=none
 coutline=purple
 html=my_html
 des='' name="&name"; 
run; 

quit;
ODS HTML CLOSE;
ODS LISTING;

*---------------------------------------------------Greplay 'Cube' Trick---------------------------------------*;
%let name=cube3d;
filename odsout '.';

options mprint;

/* Reduce the size of the world map, and get rid of some of the islands and Antarctica */
data world; set maps.world (
 where=((density<=1) and (segment<=3) and (country^=143))
 rename=(cont=continent id=country)
 );
run;

options fmtsearch=(sashelp.mapfmts);
data world; set world;
   length  countryname $20;
   countryname=put(country,glcnsm.);
run;

data mydata;
label Lost_Activity_Days='Activity Days Lost Due to Hospitalization';
label ADRs='Serious Adverse Drug Events';
format Lost_Activity_Days comma15.0;
format ADRs comma15.0;
input countryname $ 1-20 Lost_Activity_Days ADRs;
datalines;
United States        1218000  700000
Germany               358440  206000
United Kingdom        257520  148000
Australia              83520   48000
Sweden                 38280   22000
;
run;

data mydata; set mydata;
length  my_htmlvar $400;
my_htmlvar=
 'title='||quote( 
  trim(left(countryname))||'0D'x||
  'Lost Activity Days: '||trim(left(put(Lost_Activity_Days,comma15.0)))||'0D'x||
  'Serious Adverse Drug Events: '||trim(left(put(ADRs,comma15.0))) )||
 ' href="cube3d_info.htm"';
run;


goptions device=png;
goptions border;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" 
 (title="World Health Organization data plotted by SAS/Graph") 
 style=minimal;

goptions ftitle="albany amt/bold" ftext="albany amt" gunit=pct htitle=5 htext=2.75;

proc greplay nofs; igout=work.gseg;  delete _all_; run;
goptions nodisplay; 

 /* 1st map & bar chart */

 title1 "Serious Adverse Drug Events";
 title2 font="albany amt/bold" height=3.5pct "(based on World Health Organization data)";
 pattern1 v=s c=red;
 proc gmap data=mydata map=world all; 
  id countryname; 
  choro ADRs / levels=1
   coutline=black nolegend 
   html=my_htmlvar 
   des='' name='map';
  run;

/* create 'reflected image' of this map */
 data world3d; set world;
 x=x*-1;
 run;
 pattern1 v=s c=red;
 title1 " ";
 title2 height=3.5pct " ";
 footnote h=4pct " ";
 proc gmap data=mydata map=world3d all; 
  id countryname; 
  choro ADRs / levels=1
   coutline=black nolegend 
   html=my_htmlvar 
   des='' name='map3d';
  run;

 pattern1 v=s c=graydd;
 axis1 label=none major=(number=5) minor=none;
 axis2 label=none;
 title1 " ";
 title2 height=3.5pct " ";
 footnote h=4pct " ";
 proc gchart data=mydata;
  vbar countryname / type=sum sumvar=ADRs descending outside=sum
   noframe coutline=same caxis=graydd
   raxis=axis1 maxis=axis2
   des='' name='bar';
 run;

 data mydata; set mydata;
  nADRs=-1*ADRs;
 run;
 pattern1 v=s c=graydd;
 axis1 label=("              ") major=none minor=none value=none;
 axis2 label=none value=none;
 title1 h=10pct " ";  /* just to add some space at top of bar chart */
 footnote h=4pct " ";
 proc gchart data=mydata;
  vbar countryname / type=sum sumvar=nADRs ascending
   noframe coutline=same caxis=white
   raxis=axis1 maxis=axis2
   des='' name='bar3d';
 run;

goptions display;
goptions noborder;

/* Borrowing this custom 3d 'cube' greplay template from Dr. Dickey's
   example at NCSU ...
   http://www.stat.ncsu.edu/~dickey/SAScode/St610A/CoolCube.sas
*/
proc greplay tc=tempcat nofs igout=work.gseg;
  tdef cube des='Cube' 

/* bottom */
  1/ llx =  0   lly = 0
     ulx = 30   uly = 20
     urx = 100  ury = 20
     lrx = 90   lry = 0
     color=black

/* main */
   2/llx = 30   lly =  20
     ulx = 30   uly = 100
     urx =100   ury = 100
     lrx =100   lry = 20
     color=black

/* left */
   3/llx = 0   lly =  0
     ulx = 0   uly = 88
     urx =30   ury = 100
     lrx =30   lry = 20
     color=black

;
template = cube;
treplay 
 1:bar3d 
 2:bar 
 2:map 
 3:map3d 
 des='' name="&name";
run;

title;
proc print data=mydata label noobs;
 var countryname Lost_Activity_Days ADRs;
 sum Lost_Activity_Days ADRs;
run;

quit;
ODS HTML CLOSE;
ODS LISTING;
