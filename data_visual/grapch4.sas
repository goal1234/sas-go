*--------------------------------------折线图---------------------------*;
%let name=fbi;
filename odsout '.';

/* Imitation of graph in April 2000 "American Demographics" magazine, p. 20 */

data my_data;
input year locality $ 6-13 crime;
datalines;
1995 Rural     3.0
1996 Rural     3.5
1997 Rural     1.8
1998 Rural    -2.2
1995 Suburban  2.0
1996 Suburban  8.0
1997 Suburban -2.0
1998 Suburban  0.0
1995 Urban     0.5
1996 Urban     2.0
1997 Urban    -1.0
1998 Urban    -4.9
;
run;

/* 
Add chart tip variable.  In a gplot, the charttips show up when 
you hover your mouse over the vertex/markers of the line, but 
not the line itself. 
*/
data my_data; set my_data;
length htmlvar $500;
htmlvar=
 'title='||quote(
  'Year: '|| trim(left(year)) ||'0D'x||
  'Locatality: '|| trim(left(locality)) ||'0D'x||
  'Crime: '|| trim(left(crime))) ||
 ' href='||quote('fbi_info.htm');
run;


/* Annotated background colors - black at top, and gradient in lower sections */
data anno_gradient;
length function style color $8;
xsys='3'; ysys='3'; when='b'; style='solid';
function='move'; x=0; y=89; output;
function='bar'; x=100;  y=100;  color='black'; output;

orig_red=  input('ad',hex2.);
orig_green=input('dd',hex2.);
orig_blue= input('8e',hex2.);

do i=0 to 89 by 1;
 count+1;
 function='move'; x=0; y=i; output;
 function='bar'; x=100;  y=i-1;
 percent=(count-1)/(90);
 red=orig_red     + ( (256-orig_red)   * percent );
 green=orig_green + ( (256-orig_green) * percent );
 blue=orig_blue   + ( (256-orig_blue)  * percent );
 rgb=put(red,hex2.)||put(green,hex2.)||put(blue,hex2.);
 color="cx"||rgb;
 output;
 end;
run;


goptions device=png;
goptions hsize=7in vsize=5in;
goptions cback=graycc;
goptions border
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" 
 (title="SAS/Graph plot of Suburban & Rural Crime") style=sasweb;

goptions gunit=pct ftitle="albany amt/bold" htitle=4.25 ctitle=white htext=3.5 ftext="albany amt/bold";
 
title1 c=white ls=1.0 "SUBURBAN AND RURAL AREAS SAW SHARPER INCREASES IN";
title2 h=4.25 "JUVENILE CRIME THAN URBAN CENTERS DURING THE MID-'90S.";
title3 h=2 " ";
title4 h=3.1 color=CXc22817 "Percentage change in total crime arrests for persons under 18 by locality, 1995-1998.";

title6 a=90 h=5 " ";
title7 a=-90 h=5 " ";

footnote1 j=r move=(-6,+0) h=4 f="albany amt/italic" c=black "Source: Federal Bureau of Investigation, Uniform Crime Reports";
footnote2 j=r move=(-6,+0) f="albany amt" c=grayf8 "(data in this example not exact - estimated from graph in magazine)";

symbol1 i=join v=dot h=1 w=5 color=CX2554c7;  
symbol2 i=join v=dot h=1 w=5 color=CXc22817;  
symbol3 i=join v=dot h=1 w=5 color=CXfbb917;  

axis1 order=(-6 to 10 by 2) label=none minor=none major=(height=.2) offset=(0,0);

axis2 order=(1995 to 1998 by 1) label=none minor=(number=1 height=-1) 
  major=none offset=(2,2);

legend1 label=none across=1 position=(middle right inside) mode=protect 
 cframe=white cborder=black offset=(0,12);

proc gplot data=my_data anno=anno_gradient; 
 plot crime*year=locality / 
 vaxis=axis1 haxis=axis2
 legend=legend1 noframe
 /* To get a white refline at zero, and black at all the other tickmarks,
    I'm hardcoding reflines and refline colors, rather than using autovref */
 vref=(-6 -4 -2 0 2 4 6 8 10)
 cvref=(black black black white black black black black black)
 html=htmlvar
 des='' name="&name"; 
run;

quit;
ODS HTML CLOSE;
ODS LISTING;


*---------------------------------------------------一排三个条形图，炸翻---------------------------------------------*;
%let name=gtable;
filename odsout '.';
goptions reset=global;

/* Mike Zdeb was curious if I could do one like the following:
http://www.washingtonpost.com/wp-srv/politics/daily/graphics/campaignstates_031504.html
*/

%let d_blue=cx0570b0; /* democratic blue */
%let r_red=cxb00026;  /* republican red */

/* Here's the data for the states-of-interest */
data my_data;
input st $ 1-2 winner $ 3-13 electoral_votes demo_votes repub_votes;
/* Am I calculating margin correctly?? -- If I am, then the washington
   post must have calculated it incorrectly for New Mexico in the 
   list that's on their website. */
margin=100*((repub_votes-demo_votes)/(repub_votes+demo_votes));
state=stfips(st);
abs_margin=abs(margin);
datalines;
FL Republican 27 2912253 2912790
NM Democratic 5 289783 286418
WI Democratic 10 1242987 1237279
IA Democratic 7 638517 634373
OR Democratic 7 720342 713577
NH Republican 4 266348 273559
MN Democratic 10 1168266 1109659
MO Republican 11 1111138 1189924
NV Republican 5 279978 301575
OH Republican 20 2183628 2350363
TN Republican 11 981720 1061949
PA Democratic 21 2485967 2281127
ME Democratic 4 319951 286616
MI Democratic 17 2170418 1953139
AR Republican 6 422768 472940
WA Democratic 11 1247652 1108864
AZ Republican 10 685341 781652
WV Republican 5 295497 336475
;
run;

/* Since this is such a small dataset, I'm going to manipulate 
   it in a somewhat resource-wasteful (easy-to-follow) manner ... 
   since it's so small, efficiency doesn't matter. */

proc sort data=my_data out=my_data;
by abs_margin;
run;

data my_data; set my_data;
rankorder+1;
run;

data my_data; set my_data;
rankorder=rankorder+100;
statename=fipnamel(stfips(st));
run;

data my_data; set my_data;
length html $1000;
html=
 'title='|| quote(
  'State: '||trim(left(statename))||'0D'x||
  'Electoral Votes: '||trim(left(electoral_votes))||'0D'x||
  'Democratic = '||put(demo_votes,comma12.0)||'0D'x||
  'Republican = '||put(repub_votes,comma12.0)||'0D'x||
  'Margin: '||trim(left(put(abs_margin,3.1)))||'%  ')||
 ' href='||quote('gtable_info.htm');
run;

/* For each bar, annotate some text values to the left, forming what
   will look like a table. */
data bar_anno1;
set my_data;
length function color cbox $8 style $20 text $30;
xsys='2'; ysys='2'; hsys='3'; when='a';
function='label';
color='gray55';
style="albany amt/bold";
midpoint=rankorder;
position='6';
x=-8; text=trim(left(put(abs_margin,3.1))); output;
if (rankorder eq 101) then do;
 text=trim(left(text))||'%'; output;
end;
position='4';
/* Get a little tricky with the winning vote-getter, and make a 
   colored box behind that text (red=republican, blue=democrat).
   The original graph/table used a slightly lighter shade of red
   and blue behind the text, but I prefer using the same (strong)
   color so that I can make the text white.  This seems to tie it
   in better with the democratic/republican colors used in the 
   map and bar chart. */
if (winner eq 'Republican') then do; 
 cbox="&r_red"; color='white'; 
 end;
x=-9; text=trim(left(put(repub_votes,comma12.0))); output;
cbox='white'; color='gray55';
if (winner eq 'Democratic') then do; 
 cbox="&d_blue"; color='white'; 
 end;
x=-16; text=trim(left(put(demo_votes,comma12.0))); output;
cbox='white'; color='gray55';
position='6';
x=-31; text=trim(left(statename)); output;
run;

/* Annotate the headers at the top of the columns in your annotated table.
   I tried combining the two annotate datasets, but somehow it was getting
   my coordinate systems mixed up - maybe something about having 'midpoints'
   for some, and a y-value for other annotations? ... I finally opted for
   just using 2 annotate datasets, since gchart will allow me to do that. */
data bar_anno2;
length function color cbox $8 style $20 text $30;
xsys='2'; ysys='3'; hsys='3'; when='a';
y=92;
function='label';
color='black';
style="albany amt/bold";
position='4';
x=-9; text='Republican'; output;
x=-16; text='Democratic'; output;
position='6';
x=-31; text='Closest States'; output;
position='4'; x=-.2; color="&d_blue"; text='Democrat'; output;
position='6'; x=.2; color="&r_red"; text='Republican'; output;
y=95;
position='5'; x=0; color='black'; text='Margin of victory'; output;
run;


goptions device=png hsize=6in;
goptions noborder;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" 
 (title="Democrat / Republican graph proof-of-concept") style=minimal;

goptions gunit=pct ftitle="albany amt/bold" ftext="albany amt" htitle=4.25 htext=2.5;

title1 link="http://www.washingtonpost.com/wp-srv/politics/daily/graphics/campaignstates_031504.html"
   h=3.5 c=gray77 "Gchart Hbar, with annotated table of values to the left";

title2 h=3.5 " ";

pattern1 v=s c=&d_blue;  
pattern2 v=s c=&r_red;  

axis1 c=black label=none value=none offset=(3,1);
/* give the horizontal axis a lot of extra room on the left-side, so you have room
   to annotate all the text that will look like a table. */
axis2 c=black label=none value=none major=none minor=none order=(-32 to 8 by 8);

proc gchart data=my_data anno=bar_anno2;
 hbar rankorder / discrete type=sum sumvar=margin
 subgroup=winner
 anno=bar_anno1
 nostats noframe nolegend
 maxis=axis1 raxis=axis2
 coutline=same
 html=html
 des='' name="&name"; 
run;

quit;
ODS HTML CLOSE;
ODS LISTING;

*-----------------------------------------------------好看的分析图-----------------------------------*;
%let name=multiwaf;
filename odsout '.';

/* This is a modification of my wafer map example.
   Renato Luppi wanted a version that had the wafermap, 
   in addition to several others, all on the same page.

   This example looks at the same data in 4 different ways.
   I try to keep the color-mapping the same in each chart,
   but it's difficult to get that exact, therefore there 
   might be slight differences (with some extra work, they
   could be made exact, if that's important).
*/

data rawdata;
input failures @@;
datalines;
 .    .    .    .    .    .    .    .    .    .    .    .    .    .    .    .    .    .    .    .   
 .    .    .    .    .    .    .    .    .    .    .    .    .    .    .    .    .    .    .    .   
 .    .    .    .    .    .    .    .    .    .    .    .    .    .    .    .    .    .    .    .   
 .    .    .    .    .    .    .    .    .   0.00 0.00  .    .    .    .    .    .    .    .    .   
 .    .    .    .    .    .    .   0.00 1.20 2.60 4.70 4.70 0.00  .    .    .    .    .    .    .   
 .    .    .    .    .    .   0.00 2.20 3.50 4.00 4.00 4.00 4.70 0.00  .    .    .    .    .    . 
 .    .    .    .    .    .   1.20 3.50 3.50 4.00 4.00 4.00 4.00 4.00  .    .    .    .    .    .
 .    .    .    .    .   1.20 3.50 3.50 3.50 4.00 4.00 4.00 4.00 4.00 4.00  .    .    .    .    . 
 .    .    .    .   0.00 3.50 3.50 3.50 3.50 4.00 4.00 4.00 4.00 4.00 4.00 0.00  .    .    .    . 
 .    .    .    .   2.20 3.50 3.50 4.00 4.00 4.00 4.00 4.00 4.00 4.00 4.00 1.20  .    .    .    . 
 .    .    .    .   3.00 3.00 3.50 3.50 4.00 4.00 4.00 4.00 4.00 4.00 4.00 4.00  .    .    .    .  
 .    .    .   0.00 3.00 3.00 3.50 4.00 4.00 4.50 4.50 4.50 4.50 4.00 4.00 4.00 2.70  .    .    .  
 .    .    .   3.50 3.00 3.50 4.00 4.00 4.50 4.50 4.50 4.50 4.50 4.50 4.00 4.00 4.00  .    .    .  
 .    .    .   3.50 3.00 3.50 4.00 4.50 4.50 4.50 4.50 4.50 4.50 4.50 4.00 4.00 4.00  .    .    .  
 .    .   0.00 3.00 3.50 4.00 4.00 4.50 4.50 4.50 4.70 4.70 4.50 4.50 4.50 4.00 4.00 0.00  .    .  
 .    .   2.00 3.00 3.50 3.50 4.00 4.50 4.50 4.50 4.50 4.50 4.50 4.50 4.50 4.00 3.50 1.20  .    .  
 .    .   2.70 3.00 3.50 4.00 4.50 4.50 4.50 4.70 4.50 4.70 4.50 4.50 4.50 4.00 4.00 3.00  .    .  
 .    .   3.00 3.50 3.50 4.00 4.50 4.50 4.50 4.70 4.50 4.70 4.70 4.70 4.50 4.50 4.00 3.50  .    .  
 .    .   3.00 3.50 3.50 4.00 4.50 4.50 3.50 4.50 4.50 4.70 4.70 4.70 4.50 4.50 4.00 3.50  .    .  
 .   1.20 3.00 3.50 4.00 4.50 4.50 4.50 4.50 4.70 4.50 4.70 4.70 4.70 4.50 4.50 4.00 3.50 0.00  .  
 .   1.50 2.70 3.00 4.00 4.50 4.50 4.50 4.50 4.50 4.50 4.50 4.70 4.70 4.50 4.50 3.50 3.50 1.20  .  
 .   1.20 3.00 3.50 4.00 4.00 4.50 4.50 4.50 4.50 4.50 4.50 4.70 4.70 4.50 4.50 4.00 3.50 3.00  .  
 .   1.20 3.00 3.50 4.00 4.50 4.50 4.50 4.50 4.50 4.50 4.70 4.70 4.70 4.70 4.50 4.00 3.50 3.50  .  
 .   1.20 3.00 3.50 4.00 4.50 4.50 4.50 4.50 4.50 4.50 4.70 4.50 4.70 4.70 4.50 4.00 3.50 2.20  .  
 .   1.20 3.00 3.50 4.00 4.50 4.00 4.50 4.50 4.50 4.50 4.50 4.50 4.70 4.70 4.50 4.00 3.50 1.20  .  
 .   1.50 2.70 3.50 3.50 4.00 4.00 4.50 4.00 4.00 4.00 4.50 4.50 4.70 4.50 4.50 3.50 3.00 1.20  .  
 .   1.50 2.70 3.50 4.00 4.00 4.50 4.50 3.50 4.00 4.00 4.50 4.50 4.70 4.50 4.50 4.00 3.00 2.20  .  
 .   1.50 2.70 3.00 4.00 4.50 4.50 4.50 4.00 4.50 4.50 4.50 4.50 4.70 4.50 4.50 4.00 3.00 3.00  . 
 .   1.50 2.70 3.00 4.00 4.50 4.00 4.50 4.00 4.00 4.50 4.50 4.50 4.70 4.50 4.50 4.00 3.00 1.20  .  
 .   1.50 2.70 3.00 4.00 4.00 4.50 4.50 4.00 4.00 4.50 4.50 4.50 4.70 4.50 4.50 3.50 3.00 1.20  .  
 .   1.20 2.20 2.70 3.50 4.00 4.00 4.00 4.50 4.00 4.50 4.50 4.50 4.50 4.50 4.00 3.50 3.00 1.20  .  
 .   1.20 2.20 3.00 3.50 4.00 4.00 4.50 4.50 4.50 4.50 4.50 4.50 4.50 4.50 4.00 3.50 3.00 1.20  .  
 .   1.20 2.20 2.70 3.50 4.00 4.00 4.50 4.50 4.50 4.50 4.50 4.50 4.50 4.50 4.00 3.50 3.00 2.20  .  
 .   1.20 2.20 2.70 3.00 4.00 4.00 4.50 4.50 4.50 4.50 4.50 4.50 4.50 4.50 4.00 3.50 3.00 3.50  .  
 .   1.20 2.20 2.70 3.00 3.50 4.00 4.50 4.50 4.50 4.50 4.50 4.50 4.50 4.50 4.00 3.00 2.70 3.50  .  
 .   0.00 2.00 2.20 2.70 3.50 3.50 4.00 4.00 4.00 4.00 4.50 4.50 4.00 4.00 3.50 3.00 2.70 0.00  .  
 .    .   2.00 2.20 2.70 3.50 3.50 4.00 4.00 4.50 4.00 4.50 4.50 4.00 4.00 3.50 3.00 2.70  .    .  
 .    .   2.00 2.20 2.70 3.00 3.50 4.00 4.00 4.50 4.00 4.50 4.00 4.00 3.50 3.00 2.70 2.70  .    .  
 .    .   2.20 1.90 2.20 3.00 3.50 4.00 4.00 4.00 4.00 4.00 4.00 4.00 3.50 3.00 2.70 2.70  .    .  
 .    .   1.20 1.90 2.70 2.70 3.00 3.50 4.00 4.00 4.00 4.00 4.00 4.00 3.50 3.00 2.70 2.20  .    .  
 .    .   0.00 1.20 1.20 1.90 2.70 3.00 3.00 3.50 3.50 3.50 3.50 3.50 3.00 2.70 2.20 0.00  .    .  
 .    .    .   1.20 1.20 1.90 2.20 3.00 3.00 3.50 3.50 3.50 3.50 3.00 2.70 2.70 2.70  .    .    .  
 .    .    .   2.00 1.20 1.90 2.20 2.70 3.00 3.00 3.00 3.00 3.00 3.00 2.70 2.20 2.70  .    .    .  
 .    .    .   2.00 1.20 1.90 2.20 2.70 2.70 3.00 3.00 3.00 3.00 2.70 2.20 2.20 1.90  .    .    .  
 .    .    .    .   1.20 1.90 1.50 2.20 2.70 2.70 2.70 2.70 2.70 2.20 2.20 2.70  .    .    .    .  
 .    .    .    .   1.20 1.50 1.50 1.90 1.90 2.20 2.20 2.20 2.20 1.90 1.90 2.70  .    .    .    .  
 .    .    .    .   0.00 1.20 1.20 1.90 1.50 1.90 2.20 2.20 1.90 1.90 1.90 0.00  .    .    .    .  
 .    .    .    .    .   1.90 1.20 1.90 1.20 1.90 1.90 2.20 1.90 1.90 1.90  .    .    .    .    .  
 .    .    .    .    .    .   1.90 1.20 1.20 1.90 1.90 2.20 1.90 2.20  .    .    .    .    .    .  
 .    .    .    .    .    .   0.00 1.20 1.90 1.90 1.90 2.20 0.00 0.00  .    .    .    .    .    .  
 .    .    .    .    .    .    .   0.00 1.20 1.20 1.20 1.90 0.00  .    .    .    .    .    .    .  
 .    .    .    .    .    .    .    .    .   0.00 0.00  .    .    .    .    .    .    .    .    .   
 .    .    .    .    .    .    .    .    .    .    .    .    .    .    .    .    .    .    .    .   
 .    .    .    .    .    .    .    .    .    .    .    .    .    .    .    .    .    .    .    .   
 .    .    .    .    .    .    .    .    .    .    .    .    .    .    .    .    .    .    .    .   
;
run;

data rawdata; set rawdata;
 n=_n_;
 x=mod(_n_-1,20)*5;
 y= 108 - int((_n_-1)/20)*2 ;
run;



proc greplay nofs igout=gseg;
delete _all_;
run;
quit;

goptions device=png;
goptions cback=cxfafbfe;
goptions nodisplay;
goptions xpixels=550 ypixels=450;
goptions gunit=pct htitle=3 htext=2.5 ftitle="albany amt/bold" ftext="albany amt";


title1 h=15pct " ";
title2 h=15pct font="albany amt/bold" "Wafer Analysis";
title3 ls=5 h=10pct "With Summary Views";
title4 ls=5 h=10pct "From Two Sides";
proc gslide des='' name="plot3";
run;


/*
Summary data for the bar charts 
*/

proc sql;
create table sum1 as
 select unique x, 118 as y, mean(failures) as failures
 from rawdata
 group by x;
create table sum2 as
 select unique y, 105 as x, mean(failures) as failures
 from rawdata
 group by y;
quit; run;

/* Some 'fake' data to guarantee all colorchips are in the legend */
data foo;
input x y failcolor;
datalines;
. . 0
. . 1
. . 2
. . 3
. . 4
. . 5
. . 6
. . 7
. . 8
. . 9
. . 10
;
run;

data sum1; set sum1 foo;
length barhtml $1000;
barhtml=
 'title='||quote(
  'x: '||x||'0D'x||
  'average failures: '||trim(left(put(failures,comma5.1))))||
 ' href='||quote('multiwaf_info.htm');

if failures=. then failcolor=0;
else if failures = 0 then failcolor=0;   /* hash-mark */
else if failures < 1.32 then failcolor=1;  /* red */
else if failures < 1.72 then failcolor=2;
else if failures < 2.13 then failcolor=3;
else if failures < 2.63 then failcolor=4;
else if failures < 2.94 then failcolor=5;
else if failures < 3.34 then failcolor=6;
else if failures < 3.74 then failcolor=7;
else if failures < 4.15 then failcolor=8;
else if failures < 4.66 then failcolor=9;
else                         failcolor=10;  /* green */


data sum2; set sum2 foo;
length barhtml $1000;
barhtml=
 'title='||quote(
  'y: '||y||'0D'x||
  'average failures: '||trim(left(put(failures,comma5.1))))||
 ' href='||quote('multiwaf_info.htm');

 if failures=. then failcolor=0;
 else if failures = 0 then failcolor=0;   /* hash-mark */
 else if failures < 1.32 then failcolor=1;  /* red */
 else if failures < 1.72 then failcolor=2;
 else if failures < 2.13 then failcolor=3;
 else if failures < 2.63 then failcolor=4;
 else if failures < 2.94 then failcolor=5;
 else if failures < 3.34 then failcolor=6;
 else if failures < 3.74 then failcolor=7;
 else if failures < 4.15 then failcolor=8;
 else if failures < 4.66 then failcolor=9;
 else                         failcolor=10;  /* green */
run;


/* Colors red->green */
pattern1 v=m3x45 c=black;
pattern2 v=s c=CXd90000; 
pattern3 v=s c=CXe90401;
pattern4 v=s c=CXff4500;
pattern5 v=s c=CXfe8d00;
pattern6 v=s c=CXffbe00;
pattern7 v=s c=CXffff0b;
pattern8 v=s c=CXcdff00;
pattern9 v=s c=CX6eff00;
pattern10 v=s c=CX00be05;
pattern11 v=s c=CX008b05; 

axis1 label=none value=(h=2.5) minor=none offset=(0,5);
axis2 label=none value=none offset=(2,2);
/* if I don't hard-code the descending order, it will be alphabetic ascending order */
axis3 label=none value=none order=(100 to 8 by -2) offset=(2,2); 



title1 h=1pct " ";
title2 a=-90 h=30pct " ";  /* white-space on the right */
title3 a=90 h=5pct " ";  /* white-space on the left */
footnote;

proc gchart data=sum1;
format failures comma5.1;
vbar x / discrete type=sum sumvar=failures
 subgroup=failcolor coutline=black
 width=3.4 space=0 outside=sum
 raxis=axis1 maxis=axis2
 autoref clipref 
 nolegend noframe 
 html=barhtml
 des='' name="plot1";
run;



title1 h=11pct " ";
title2 a=90 h=2pct " ";
title3 a=-90 h=7pct " ";
footnote;

proc gchart data=sum2;
format failures comma5.1;
goptions htext=1.8;  /* make the stats to right of bar smaller */
hbar y / discrete type=sum sumvar=failures sumlabel=' '
 subgroup=failcolor coutline=black
 width=0.7 space=0
 raxis=axis1 maxis=axis3 
 autoref clipref
 nolegend noframe       
 html=barhtml
 des='' name="plot4";
run;
goptions htext=2.5; 




/* 
Now prepare the "wafer map" (bottom/left) graph.
This involves creating a custom SAS/Graph gmap 'map'
*/

/* Create the 'geographical map' (grid of rectangles) */
data wafermap;
 length id $20;
 do super_y=1 to (11+1);
  do super_x=1 to (10+1);
   do sub_y=1 to 5;
    do sub_x=1 to 2;
     x=((super_x*10)-10)+(sub_x*5)-5; y=((super_y*10)-10)+(sub_y*2)-2;
     id=trim(left(x))||'_'||trim(left(y));
     output;
     x=x+5; output;
     y=y+2; output;
     x=x-5; output;
    end;
   end;
  end;
 end;

/* Create some areas for the fake-legend */
 do legend_y=10 to 55 by 5;
   x=120; y=legend_y;
   id=trim(left(x))||'_'||trim(left(y));
   output;
   x=x+5; output;
   y=y+5; output;
   x=x-5; output;
 end;

run;  

/* Annotate grid 'reference' outlines */
data outlines;
 length function color $8 text $30 style $20;
 xsys='2';
 ysys='2';
 hsys='3';
 when='a';
 size=2; /* thickness of annotated grid lines */
 color='black';
 do super_y=1 to 11;
  do super_x=1 to 10;
   function='poly'; 
   x=(super_x*10)-10; y=(super_y*10)-10; output;
   function='polycont'; 
   x=x+10; output;
   y=y+10; output;
   x=x-10; output;
   y=y-10; output;
  end;
 end;

  
/* calculate the points to draw a circular polygon */
  radius=(10*10)/2;    /* circle radius is 1/2 of the x grid direction */
  x_circle_origin=0+(10*10)/2;
  y_circle_origin=0+(11*10)/2;
  size=1; /* use a more narrow line than the heavy grid */
  do degrees=0 to 360 by 2;  
    if degrees eq 0 then function='poly';
    else function='polycont';
    radians=degrees/57.3; 
    x=(radius * cos(radians)) + x_circle_origin;
    y=(radius * sin(radians)) + y_circle_origin;
    output;
  end;

/* Annotate some labels.  Ideally the locations would be 
   relative/calculated, but I'm hard-coding them ... */
  function='label';
  x=5; y=117; size=2.5; style="albany amt/bold"; position='6'; text='MEAN'; output;
  x=5; y=123; size=2.0; style="albany amt"; position='6'; text='ISB2A: Bit Count Failures'; output;

  x=121; y=68; size=2.5; style="albany amt/bold"; position='F'; text='Color Key'; output;

  size=2.0; style="albany amt"; position='F';
  x=126; y=60; text='4.66-'; output;
  x=126; y=55; text='4.15-4.66'; output;
  x=126; y=50; text='3.74-4.15'; output;
  x=126; y=45; text='3.34-3.74'; output;
  x=126; y=40; text='2.94-3.34'; output;
  x=126; y=35; text='2.63-2.94'; output;
  x=126; y=30; text='2.13-2.63'; output;
  x=126; y=25; text='1.72-2.13'; output;
  x=126; y=20; text='1.32-1.72'; output;
  x=126; y=15; text='0-1.32'; output;

run;

data griddata; set rawdata sum1 sum2;
 length id $20 map_html $1000;
 id=trim(left(x))||'_'||trim(left(y));

 if failures=. then failcolor=0;
 else if failures = 0 then failcolor=0;   /* hash-mark */
 else if failures < 1.32 then failcolor=1;  /* red */
 else if failures < 1.72 then failcolor=2;
 else if failures < 2.13 then failcolor=3;
 else if failures < 2.63 then failcolor=4;
 else if failures < 2.94 then failcolor=5;
 else if failures < 3.34 then failcolor=6;
 else if failures < 3.74 then failcolor=7;
 else if failures < 4.15 then failcolor=8;
 else if failures < 4.66 then failcolor=9;  
 else                           failcolor=10;  /* green */

map_html=
 'title='||quote(
  'x: '||x||'0D'x||
  'y: '||y||'0D'x||
  'failures: '||trim(left(put(failures,comma8.1))))||
 ' href='||quote('multiwaf_info.htm');

 if failures^=. then output;
run;

/* Add some values to go with the 'fake-legend' -- a side-benefit
   of using a fake legend, and using map areas & data for it, is
   that now the map is guaranteed to have at least 1 data value in
   each color range, therefore guaranteeing that each color is
   used & assigned correctly -- otherwise, if you are missing 
   data in certain color ranges, gmap would skip that color, and
   assign the colors in-order, without making the colors not
   assign in the desired order. */
data fakelegend; 
id='120_10'; failcolor=1;  output;
id='120_15'; failcolor=2;  output;
id='120_20'; failcolor=3;  output;
id='120_25'; failcolor=4;  output;
id='120_30'; failcolor=5;  output;
id='120_35'; failcolor=6;  output;
id='120_40'; failcolor=7;  output;
id='120_45'; failcolor=8;  output;
id='120_50'; failcolor=9;  output;
id='120_55'; failcolor=10;  output;
run;

data griddata;
 set griddata fakelegend;
run;
 

title1 ls=1.5 "Failure Analysis";
title2 " ";
footnote1 h=5 " ";

pattern1 v=m3x45 c=black;
pattern2 v=s c=CXd90000; /* red */
pattern3 v=s c=CXe90401;
pattern4 v=s c=CXff4500;
pattern5 v=s c=CXfe8d00;
pattern6 v=s c=CXffbe00;
pattern7 v=s c=CXffff0b;
pattern8 v=s c=CXcdff00;
pattern9 v=s c=CX6eff00;
pattern10 v=s c=CX00be05;
pattern11 v=s c=CX008b05;  /* green */
pattern12 v=s c=white;

proc gmap data=griddata map=wafermap anno=outlines; 
id id; 
choro failcolor / discrete 
 nolegend coutline=black 
 html=map_html 
 des='' name="plot2"; 
run;




/* 
Earlier, you sent the sas/graph output to name= names.
Now, you're going to "replay" those graphs into a greplay template,
such that all 4 graphs will appear on 1 page. 
(I'm using a pre-defined SAS greplay template - l2r2s)
*/
goptions xpixels=1100 ypixels=900;
goptions display;
goptions noborder;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm"
 (title="SAS/GRAPH Wafer Example with multiple graphs on a page") style=htmlblue;

title;
proc greplay igout=gseg tc=sashelp.templt template=l2r2s nofs;
treplay 
 1:plot1 3:plot3 
 2:plot2 4:plot4
 des='' name="&name";
run;

quit;
ODS HTML CLOSE;
ODS LISTING;

*------------------------------------折线图----------------------------------*;
%let name=winner;
filename odsout '.';

/*
Imitation of a graph from March 1, 2004 "Information Week" magazine, p. 86
*/

data my_data;
format date date7.;
input date date7. software computer;
datalines;
15oct03 1 6
22oct03 -1 2
29oct03 3 3
05nov03 2 -2
12nov03 -2.5 8.5
19nov03 -7 -11
25nov03 4.5 -8
03dec03 1 -2
10dec03 -4 -.5
17dec03 2 22
24dec03 2 9
30dec03 .5 8.5
07jan04 -4 2
14jan04 -3.5 -.5
21jan04 2 0
28jan04 -4.5 -8
04feb04 3 -7
11feb04 4 9
18feb04 0 8.5 
25feb04 -9 4.5
;
run;

data my_data; set my_data;
length myhtml $500;
myhtml=
 'title='||quote(
  put(date,date7.)||'0D'x||
  'Personal-productivity software:   '||trim(left(software))||'0D'x||
  'Computer systems (other):         '||trim(left(computer)))||
 ' href='||quote('winner_info.htm');
run;


goptions device=png;
goptions noborder;

ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" 
 (title="Computer Systems & Personal Productivity Software (SAS/Graph chart)") style=sasweb;

goptions ftitle="albany amt/bold" ftext="albany amt" gunit=pct htitle=5 htext=3.1;

axis1 order=(-15 to 25 by 5) minor=none label=(a=90 '% Change') offset=(0,0);

axis2 order=('15oct2003'd to '25feb2004'd by week) minor=none offset=(3,3) 
 label=none value=(a=90 h=2.25);

symbol1 i=join c=tan v=none w=7;
symbol2 i=join c=brown v=none w=2;
symbol3 i=none c=orange v=dot h=1.5;
symbol4 i=join c=cx82caff v=none w=7;
symbol5 i=join c=cx151b7e v=none w=2;
symbol6 i=none c=orange v=dot h=1.5;

title1 ls=1.3 "WINNERS & LOSERS";
title2 c=cx151b7e "The non-desktop and non-enterprise computer-systems sector";
title3 c=cx151b7e "rose the most last week, while the personal-productivity";
title4 c=cx151b7e "software sector showed the biggest decline.";
title5 h=.5 " ";
title6 f=marker h=2pct c=tan 'U'      f="albany amt" h=3.5pct c=black " Computer systems (other)      "
       f=marker h=2pct c=cx82caff 'U' f="albany amt" h=3.5pct c=black " Personal-productivity software";
title7 a=-90 h=1 " ";

proc gplot data=my_data;
plot 
  software*date=4 software*date=5 software*date=6 
  computer*date=1 computer*date=2 computer*date=3 
  / overlay
 noframe nolegend
 vaxis=axis1 haxis=axis2
 vref=(-10 -5 0 5 10 15 20 25) cvref=graycc lvref=(2 2 1 2 2 2 2 2)
 autohref chref=grayf3
 html=myhtml
 des='' name="&name"; 
run;

quit;
ODS HTML CLOSE;
ODS LISTING;

*---------------------------------------------------------有面积填充的折线图--------------------------------------------*；
%let name=crime;
filename odsout '.';

/* Imitation of graph in April 2000 "American Demographics" magazine, p. 20 */

data my_data;
input year crime;
datalines;
1981 310
1982 305
1983 296
1984 298
1985 300
1986 312
1987 307
1988 311
1989 380
1990 420
1991 460
1992 480
1993 507
1994 528.1
1995 507
1996 450
1997 401
1998 370
;
run;


data anno_label; set my_data (where=(year in (1983, 1994, 1998)));
length function color cbox  $8 text $30;
xsys='2'; ysys='2'; when='a';
function='label'; cbox='black'; color='white'; size=1.75;
x=year; y=crime;
text=trim(left(crime));
if year eq 1983 then position='e';
if year eq 1994 then position='b';
if year eq 1998 then position='e';
run;


/* Annotated background colors - black at top, and gradient in lower sections */
data anno_colors;
length function style color $10;
xsys='3'; ysys='3'; when='b'; style='solid';
function='move'; x=0; y=89; output;
function='bar'; x=100;  y=100;  color='black'; output;
orig_red=  input('fe',hex2.);
orig_green=input('c4',hex2.);
orig_blue= input('4f',hex2.);
do i=0 to 89 by 1;
 count+1;
 function='move'; x=0; y=i; output;
 function='bar'; x=100;  y=i-1;
 percent=(count-1)/(90);
 red=orig_red     + ( (256-orig_red)   * percent );
 green=orig_green + ( (256-orig_green) * percent );
 blue=orig_blue   + ( (256-orig_blue)  * percent );
 rgb=put(red,hex2.)||put(green,hex2.)||put(blue,hex2.);
 color='cx'||rgb;
 output;
 end;
run;


goptions device=png;
goptions hsize=7in vsize=5in;
goptions cback=graycc;
goptions border;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" 
 (title="Violent Juvenile Crime Rates - SAS/Graph plot") style=minimal;

goptions gunit=pct htitle=4 ftitle="albany amt/bold" htext=3.0 ftext="albany amt/bold";
 
title1 c=white ls=1.5 "VIOLENT JUVENILE CRIME RATES, WHILE";
title2 h=4 c=white "STILL HIGH, HAVE BEEN STEADILY DECLINING";
title3 h=2 " ";
title4 h=2.5 "Youth crime peaked in 1994, and is now at its lowest level in nearly a decade.";
title5 h=2.5 c=cxc22817 "Violent crime arrests (for murder, rape, robbery, and aggravated assault) per 100,000 juveniles, 1981-1998";
title6 a=90 h=4 " ";
title7 a=-90 h=4 " ";

footnote1 j=r move=(-4,+0) h=3.7 f="albany amt/italic" "Source: Office of Juvenile Justice and Delinquency Prevention, 1999";
footnote2 j=r move=(-4,+0) c=gray "(data in this example not exact - estimated from graph in magazine)";

symbol1 i=join v=none;  
pattern1 color=cxc22817 value=solid; /* colored area below line */

axis1 order=(0 to 600 by 100) label=none minor=none major=(height=.2) offset=(0,0);

axis2 order=(1981 to 1998 by 1) label=none minor=none value=(a=90) major=(height=.1) offset=(2,2);

proc gplot data=my_data anno=anno_colors; 
 plot crime*year / areas=1
 vaxis=axis1 haxis=axis2
 href=(1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997)
 anno=anno_label autovref
 des='' name="&name"; 
run;

quit;
ODS HTML CLOSE;
ODS LISTING;

*-----------------------------------------------仿造的雷达图-----------------------------------------*;
%let name=lead;
filename odsout '.';


/* Radius = 1 mile */
%let radius=40;   /* 40 = 40% of the screen */
%let halfradius=20;


/* 
Wind direction - Using compass degrees (0-degrees is at the
top/north of the compass, 90-degrees is right/east, etc 
*/
data winds;
input direction percent_val;
datalines;
0      1
22.5   3
45     3
67.5   3
90     2
112.5  1
135    1
157.5  2
180    1
202.5  2
225    3
247.5  3
270    3
292.5  3
315    2
337.5  1
;
run;

data winds; set winds;
length function color $8 style $12 text $30;
xsys='3'; ysys='3'; hsys='3';
x=50; y=50; /* Center */
function='PIE';
size=&radius;  /* Radius */
if percent_val eq 1 then color='cxfbbbb9';
else if percent_val eq 2 then color='cxfeeccf';
else if percent_val eq 3 then color='cxbcfeff';
/* convert compass direction into annotate coordinate system */
/* with a compass 0 is north, and degrees go clockwise */
/* with annotate, 0 is at 3pm, and degrees go counterclockwise */
anno_dir=(360-direction)+90;   /* This is the center of this wind-slice */
angle=anno_dir-((360/16)/2);   /* Back up 1/2 a slice */
rotate=(360/16);               /* Then rotate this pie slice through 1/16-th of circle */
style='psolid';
output;
/* Do an outline around each pie slice */
style='pempty'; color='black'; output;
/* Only do this once */
if direction eq 337.5 then do;
 /* Do a 1/2-mile circle */
 size=(&radius/2); rotate=360; output;
 /* Put some labels on the 1/2-mile and 1-mile locations */
 function='LABEL'; style="albany amt/bold"; position='5'; size=2.0;
 color='black'; cbox='white';
 angle=.; rotate=.; 
 y=50;
 x=50-&halfradius; text='1/2 mile'; output;
 x=50-&radius; text='1 mile'; output;
 end;
run;


data lead;
input direction miles mcg_dl;
datalines;
0 .51 3
13 .95 18
12 .7  7
158 .98 23
150 .8 1
152 .73 3
149 .33 1
158 .21 5
150 .4 6
162 .82 3
165 .8 5
168 .73 2
144 .995 8
352 .6 0
350 .71 3
344 .43 1
349 .31 5
88  .7  11
86  .65 10
355 .1  4
0   .65 2
12 .3 3
15 .7 1
22 .63 5
14 .4 6
31 .8 2
47 .32 1
;
run;

data lead; set lead;
length html $1000;
html=
 'title='||quote(
  'Direction: (compass degrees): '||trim(left(direction))||'0D'x||
  'Distance (miles): '||trim(left(miles))||'0D'x||
  'Blood Lead Level (mcg/dL): '||trim(left(mcg_dl)))||
 ' href='||quote('lead_info.htm');
run;

data lead; set lead;
length style function color $8 text $30;
xsys='3'; ysys='3'; hsys='3';
radius=miles*&radius;
/* convert compass direction into annotate coordinate system */
/* with a compass 0 is north, and degrees go clockwise */
/* with annotate, 0 is at 3pm, and degrees go counterclockwise */
anno_dir=(360-direction)+90;
/* convert to radians */
anglerad=( (2*3.14)/360 )*(anno_dir);
y=50+radius*sin(anglerad);
x=50+radius*cos(anglerad);
/* The marker font doesn't center exactly on the coordinate, therefore
   if you want the markers to be in the exact right location then you'll
   need to adjust the y-coordinate, or you could draw an annotate 'polygon'
   which you could center exactly as you like.  Since this is just a
   proof-of-concept example, I'm taking the easy way, and just using
   the plain old marker font characters. */
function='label'; style='marker';
if (mcg_dl ge 0) and (mcg_dl <= 5) then do;
  color='graycc';
  text='W';
  size=1.75;
  end;
else if (mcg_dl gt 5) and (mcg_dl <= 10) then do;
  color='cx00ff00';
  text='C';
  size=2;
  end;
else if (mcg_dl gt 10) and (mcg_dl <= 20) then do;
  color='magenta';
  text='U';
  size=2.5;
  end;
else if (mcg_dl gt 20) then do;
  color='cxff0000';
  text='V';
  size=3;
  end;
output;
style='markere'; color='black'; output; /* black outline around each marker */
run;


/*
Unfortunately, when you create a custom graph with annotate,
you also have to create a custom legend with annotate...
*/
data legend;
length function color $8 style $12 text $30;
xsys='3'; ysys='3'; hsys='3';
size=2.0;
function='label'; position='5';
x=2; 
y=15; style='marker'; color='cxff0000'; text='V'; output;
style='markere'; color='black'; output; 
y=12; style='marker'; color='magenta'; text='U'; output;
style='markere'; color='black'; output; 
y=9; style='marker'; color='cx00ff00'; text='C'; output;
style='markere'; color='black'; output; 
y=6; style='marker'; color='graycc'; text='W'; output;
style='markere'; color='black'; output; 
x=4; style="albany amt"; color='black';
position='6';
y=15; text='20 to 30'; output;
y=12; text='10 to 20'; output;
y=9; text='5 to 10'; output;
y=6; text='0 to 5'; output;
position='6';
style="albany amt/bold";
x=1; y=2;
text='Blood Lead Levels (mcg/dL)';
output;

position='5';
x=98; 
y=12; style='marker'; color='cxfbbbb9'; text='U'; output;
style='markere'; color='black'; output; 
y=9; style='marker'; color='cxfeeccf'; text='U'; output;
style='markere'; color='black'; output; 
y=6; style='marker'; color='cxbcfeff'; text='U'; output;
style='markere'; color='black'; output; 
x=96; style="albany amt"; color='black';
position='4';
y=12; text='8.65 to 12.04'; output;
y=9; text='3.93 to 8.65'; output;
y=6; text='0.91 to 3.93'; output;
position='4';
style="albany amt/bold";
x=98; y=2;
text='Wind Direction (%)';
output;

run;

/* Combine all the annotate data sets */
data all_anno;
 set winds lead legend;
run;


goptions device=png border;
goptions xpixels=600 ypixels=600;
goptions cback=white;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" 
 (title="Lead Exposure (Custom SAS/Graph Windrose/Polar type graph)") 
 style=htmlblue;

goptions gunit=pct htitle=6 htext=2 ftitle="albany amt/bold" ftext="albany amt";

title1 ls=1.3 "Lead Exposure";
proc gslide annotate=all_anno 
 des='' name="&name";                                               
run;                                                                            

quit;
ODS HTML CLOSE;
ODS LISTING;
