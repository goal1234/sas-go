*============================================== California Earthquakes    ====================================*;
%let name=calpie;
filename odsout '.';

/*
Trying to duplicate 
http://tsdsrv04.unx.sas.com:7777/sirius/sirts/fetch_attachment.pl/dataclockchart.ppt?trknum=us5742988&page_id=20020903_112156_693827
from customer call
http://pockets.pc.sas.com/sirius/gsts/us/5742/us5742988.html
*/

data my_data;
input year month $ value;
datalines;
1997 Jan 6
1997 Feb 9
1997 Mar 2
1997 Apr 3
1997 May 3
1997 Jun 6
1997 Jul 0
1997 Aug 0
1997 Sep 0
1997 Oct 0
1997 Nov 0
1997 Dec 0
1996 Jan 8
1996 Feb 5
1996 Mar 5
1996 Apr 2
1996 May 3
1996 Jun 5
1996 Jul 5
1996 Aug 9
1996 Sep 5
1996 Oct 5
1996 Nov 3
1996 Dec 3
1995 Jan 3
1995 Feb 5
1995 Mar 5
1995 Apr 5
1995 May 5
1995 Jun 5
1995 Jul 4
1995 Aug 5
1995 Sep 2
1995 Oct 1
1995 Nov 5
1995 Dec 2
1994 Jan 270
1994 Feb 5
1994 Mar 5
1994 Apr 5
1994 May 8
1994 Jun 3
1994 Jul 3
1994 Aug 5
1994 Sep 5
1994 Oct 5
1994 Nov 4
1994 Dec 5
1993 Jan 5
1993 Feb 8
1993 Mar 5
1993 Apr 5
1993 May 5
1993 Jun 9
1993 Jul 5
1993 Aug 5
1993 Sep 2
1993 Oct 2
1993 Nov 5
1993 Dec 7
1992 Jan 5
1992 Feb 5
1992 Mar 4
1992 Apr 150
1992 May 75
1992 Jun 275
1992 Jul 285
1992 Aug 80
1992 Sep 5
1992 Oct 5
1992 Nov 5
1992 Dec 5
1991 Jan 5
1991 Feb 5
1991 Mar 3
1991 Apr 5
1991 May 7
1991 Jun 5
1991 Jul 9
1991 Aug 9
1991 Sep 5
1991 Oct 2
1991 Nov 3
1991 Dec 5
1990 Jan 8
1990 Feb 2
1990 Mar 3
1990 Apr 4
1990 May 3
1990 Jun 1
1990 Jul 2
1990 Aug 2
1990 Sep 5
1990 Oct 8
1990 Nov 5
1990 Dec 5
;
run;

proc sql;
 select max(year) into :max_year from my_data;
 select min(year) into :min_year from my_data;
quit; run;

/* Radius of maximum pie ring is this % of the screen */
%let radius=25;
%let offset=5;  /* offset for center of pie, to make room for title at top */

data pies; set my_data;
length style function color $12 html $200;
xsys='3'; ysys='3'; hsys='3';
x=50; 
y=50-&offset; /* slightly down from center, to give room for 'title' above the chart */
function='PIE'; style='PSOLID';
angle+((1/12)*360);  /* start angle for this slice */
if month='Jan' then angle=0;  
rotate=((1/12)*360);  /* each pie slice is 1/12th of a year */
/* the +3 gives extra room in the middle, for the hole */
size=(&radius*((year-&min_year+3)/(&max_year-&min_year)));  /* maximum radius is &radius% of page */
color='gray';
if value >= 1 and value <= 62 then color='cxFF3333';
if value >= 63 and value <= 124 then color='yellow';
if value >= 125 and value <= 186 then color='cx00ff00';
if value >= 187 and value <= 248 then color='cyan';
if value >= 249 then color='cx0147FA'; /* blue */
html=
 'title='||quote(
  'Date: '||trim(left(month))||' '||trim(left(year))||'0d'x||
  'earthquake count: '||trim(left(value)))||
 ' href="calpie_info.htm"';
run;

/* Black outlines around the pie slices */
data outlines; set pies;
style='EMPTY'; color='black'; line=1;
run;

/* Make a white hole in the middle */
data hole; 
/*set my_data;*/
length style function color $12;
xsys='3'; ysys='3'; hsys='3';
x=50; 
y=50-&offset;
function='PIE'; angle=0; line=0; rotate=360;  
size=(&radius*((2)/(&max_year-&min_year)));  
html='';
style='PSOLID'; color='white'; output;
style='PEMPTY'; color='black'; output;
run;

/* annotate year labels */
/* subset data - only need 1 obsn per each year ... */
proc sql; 
 create table years as 
 select * 
 from my_data 
 where month='Mar'; 
quit; run;

data years; set years;
length style function color $12 text $20;
xsys='3'; ysys='3'; hsys='3'; when='a';
x=50; 
y=50-&offset; 
/* Need a better equation - I just did something simple, and then 
 tweaked the offset (2.6) until it looked ok */
y=50-&offset+(&radius*((year-&min_year+2.6)/(&max_year-&min_year)));   
function='LABEL'; color='black'; position='6';  style=''; size=2.5;
text=trim(left(year));
run;

/* annotate month labels */
proc sql;
 create table months as 
 select * 
 from pies 
 where year=&max_year; 
quit; run;

/* Place the 3-char month abbreviations around the pie */
data months; set months;
length text $20;
/* find a point that is half of the arc (rotate*.5) */
function='piexy'; angle=angle+rotate*.5; 
/* 5.6 times the radius/size of previous pie slice (previous slice was pie center) */
size=5.6; output;
/* (XLAST, YLAST) cannot be used directly by text functions. 
   Use CNTL2TXT to copy the coordinates in (XLAST, YLAST) to the 
   XLSTT and YLSTT variables, which text functions can use. */
function='cntl2txt'; output;
/* write the text label centered on the point stored in XLSTT and YLSTT */
function='label'; text=month; angle=0; rotate=0; color='';
style=''; size=3; x=.; y=.; position='5';
output;
run;

/* 
When you annotate colors, there is no automatic legend.
Therefore you have to annotate a legend also...
*/
data legend;
length style function color $12 text $20;
xsys='3'; ysys='3'; hsys='3';
/* first, the text in the legend */
function='LABEL'; color=''; style=''; position='6'; size=2.5;
x=90;
y=91; text='0'; output;
y=y-5; text='1-62'; output;
y=y-5; text='63-124'; output;
y=y-5; text='125-186'; output;
y=y-5; text='187-248'; output;
y=y-5; text='249+'; output;
/* 'marker' character 'U' is a box - these are my color chips in legend */
style='marker'; text='U'; position='5'; size=2.5;
x=88; 
y=90.5; color='gray'; output;
y=y-5; color='cxFF3333'; output; /* red */
y=y-5; color='yellow'; output;
y=y-5; color='cx00ff00'; output; /* green */
y=y-5; color='cyan'; output;
y=y-5; color='cx0147FA'; output; /* blue */
/* And, draw an outline around them ... */
style='markere'; color='black';
x=88; 
y=90.5; output;
y=y-5; output;
y=y-5; output;
y=y-5; output;
y=y-5; output;
y=y-5; output;
run;


data anno; set pies outlines hole years months legend; 
run;

goptions device=png;
goptions cback=white;
goptions border;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" 
 (title="SAS/Graph custom plot - Southern California Earthquakes") 
 gtitle nogfootnote style=d3d;

goptions gunit=pct htitle=5 ftitle="albany amt/bold";

title1 ls=2.5 "Southern California Earthquakes";

footnote "Based on a screen-capture sent in by a customer";

proc gslide annotate=anno 
 des='' name="&name";                                               
run;                                                                            

quit;
ODS HTML CLOSE;
ODS LISTING;

*================================================================»·ÐÎÍ¼==========================================*£º
%let name=rings;
filename odsout '.';

%let scale=.5;

data graphics1; 
length style function color side $12;
xsys='3'; ysys='3'; hsys='3'; when='a';

side='left';
function='move'; x=50-(25*&scale); y=50-(25*&scale); output;
function='bar'; style='solid'; color='cx6c616e'; 
 x=x+(25*&scale); y=y+(25*&scale)+(25*&scale); output;

side='right';
function='move'; x=50; y=50-(25*&scale); output;
function='bar'; style='solid'; color='cxd4c9d6'; 
 x=x+(25*&scale); y=y+(25*&scale)+(25*&scale); output;

function='PIE'; style='PSOLID'; x=50; y=50; 

side='left';
angle=90; rotate=180; size=15*&scale; color='cxa095a2'; output;
angle=90; rotate=180; size=5*&scale; color='cx6c616e'; output;

side='right';
angle=270; rotate=180; size=15*&scale; color='cxa095a2'; output;
angle=270; rotate=180; size=5*&scale; color='cxd4c9d6'; output;

run;

/* spread them apart */
data graphics2; set graphics1;
if side eq 'left' then x=x-(2.5*&scale);
if side eq 'right' then x=x+(2.5*&scale);
run;

/* slide the 2 halfs up/down */
data graphics3; set graphics1;
if side eq 'left' then y=y+(5*&scale);
if side eq 'right' then y=y-(5*&scale);
run;

data graphics1; set graphics1; 
 x=x+30; y=y+30;
run;

data graphics2; set graphics2;
 x=x+30;
run;

data graphics3; set graphics3;
 x=x+30; y=y-30;
run;

%let textspace=4;
data titles;
length style function color $ 12;
length text $80;
xsys='3'; ysys='3'; hsys='3';
function='LABEL'; position='6'; color='';
style='Albany amt/bold'; size=5;
x=8; 
y=85; text='The "Koffka Rings" Illusion'; output;
style='Albany amt'; size=3.5;
y=70; text='Koffka was a Gestalt psychologist who studied'; output;
y=y-&textspace; text='the importance of grouping in perceptual'; output;
y=y-&textspace; text='phenomena.  In the case of lightness, he'; output;
y=y-&textspace; text='showed that a gray ring on a light/dark'; output;
y=y-&textspace; text='background looks uniform, but when the two'; output;
y=y-&textspace; text='halves are split, as in the middle image, they'; output;
y=y-&textspace; text='look quite different.  A new variant is shown at'; output;
y=y-&textspace; text='the bottom, where the halves are slid vertically,'; output;
y=y-&textspace; text='giving an impression of transparency.  Even'; output;
y=y-&textspace; text='though the half-rings are set against the same'; output;
y=y-&textspace; text='backgrounds in each case, their appearance'; output;
y=y-&textspace; text='depends on the overall spatial configuration.'; output;
y=y-15; x=x+5; text='[mouse over rings to see color value]'; output;
run;

data anno; set graphics1 graphics2 graphics3 titles; 
length html $100;
if (function ne 'LABEL') then 
  html='title='||quote('Hex Color Value: '||trim(left(color)))||' href="rings_info.htm"';
else 
  html='title='||quote('Click here to find out more info')||' href="rings_info.htm"';
run;


goptions device=png;
goptions border;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" (title="Koffka Rings illusion") style=sasweb;

proc gslide annotate=anno 
 des='' name="&name";                                               
run;                                                                            

quit;
ODS HTML CLOSE;
ODS LISTING;


*===========================================================  Licensed Physicians  ==============================================*;
%let name=docbar;
filename odsout '.';

data mydata;
input year physicians physicians_per_person;
datalines;
1985 5933 222
1986 6160 231
1987 6497 242
1988 6491 237
1989 6729 241
1990 6941 244
1991 7108 243
1992 7299 244
1993 7508 246
1994 7607 244
1995 7884 249
1996 8153 252
1997 8405 256
1998 8617 260
1999 8990 265
2000 9173 266
2001 9584 .
;
run;

data mydata; set mydata;
format physicians comma6.0;
label physicians='Active Licensed Physicians';
label physicians_per_person='Physicians per 100,000 Population';
length my_html $200;
my_html=
 'title='||quote(
  'Year: '||trim(left(year))||'0d'x||
  'Physicians: '||trim(left(put(physicians,comma6.0)))||'0d'x||
  'per person: '||trim(left(physicians_per_person)))||
 ' href="docbar_info.htm"';
run;

goptions device=png;
goptions noborder;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" 
 (title="SAS/Graph bar & line plot - Licensed Physicians") style=sasweb;

/* for the bars */
pattern v=s c=gray55;
 
/* for the line */
symbol ci=black w=1 v=dot cv=black h=1.5;

goptions gunit=pct htitle=3 htext=2 ftitle="albany amt" ftext="albany amt";

axis1 c=olive order=(0 to 12000 by 2000) minor=none 
 label=(c=black angle=90 h=.15in) value=(c=black) offset=(0,0);

axis2 c=olive order=(0 to 300 by 50) minor=none 
 label=(c=black angle=90 h=.15in) value=(c=black) offset=(0,0);

axis3 label=none value=('1985' '' '1987' '' '1989' '' '1991' '' '1993' '' '1995' ''
  '1997' '' '1999' '' '2001') offset=(4,4);

title1 ls=1.5 "Active Licensed Physicians and Physicians";
title2 h=3 "per 100,000 Population, Oregon 1985-2001";

footnote "Sources: Oregon Board of Medical Examiners; Bureau of the Census - est.";

proc gbarline data=mydata;
bar year / type=sum sumvar=physicians 
 discrete outside=sum
 raxis=axis1 maxis=axis3 
 html=my_html
 des='' name="&name";
plot / type=sum sumvar=physicians_per_person
 axis=axis2
 html=my_html;
run;

quit;
ODS HTML CLOSE;
ODS LISTING;


*================================================= Bioremediation ================================================*;
%let name=biorem;
filename odsout '.';

data my_data;
label temperature="Temperature (degrees C)";
label concentration="TCE Concentration (PPM)";
label day="Day";
input day temperature concentration;
datalines;
0 29 26
5 23 21
10 27 19
15 25 12.5
20 20 7
25 23 6
30 23 3
35 27 1
;
run;

data my_data; set my_data;
length my_html $200;
my_html=
 'title='||quote(
  'Day: '||trim(left(day))||'0d'x||
  'Temp: '||trim(left(temperature))||' degrees C'||'0d'x||
  'Conc: '||trim(left(concentration))||' PPM')||
 ' href="biorem_info.htm"';
run;

/* Annotate the text on the line */
data my_anno;
length function color $8 style $20 text $100;
xsys='2'; ysys='2'; when='a';
x=15; y=16;
function='label'; position='5'; size=1.7;
angle=-52;
/* using spaces to do a little subtle position control */
text='      Concentration';
run;


goptions device=png;
goptions xpixels=576 ypixels=384;
goptions border;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm"
 (title="Bioremediation Plot") style=sasweb gtitle nogfootnote;

goptions ftitle="albany amt" ftext="albany amt" gunit=pct htitle=5.0 htext=3.2;
 
title1 ls=1.5 "Bioremediation";

footnote 
 link="http://www.mathworks.de/access/helpdesk/help/techdoc/creating_plots/chspeci6.shtml#1061"
  c=magenta "Imitation of this 'mathworks' plot (click here to see)";

axis1 order=(0 to 30 by 5) minor=none label=(angle=90) offset=(0,0);
 
/* Bar color */
pattern v=s c=turquoise;

/* Line */
symbol i=join ci=black w=3 v=dot cv=black h=.5; 

proc gbarline data=my_data;
bar day / type=sum sumvar=temperature discrete 
 axis=axis1 coutline=black cframe=white 
 autoref lref=2 cref=gray width=7
 noframe anno=my_anno
 html=my_html
 des='' name="&name";
plot / type=sum sumvar=concentration
 axis=axis1
 ;
run;

quit;
ODS HTML CLOSE;
ODS LISTING;


*================================================ Oil Field Production ====================================================*;
%let name=purbar;
filename odsout '.';


data my_data;
label barrels="Annual Production (Millions of Barrels oil, gas, and water)";
length type $10;
input year barrels type;
datalines;
1980 2.1 Oil
1981 2.8 Oil
1982 3.2 Oil
1983 2.8 Oil
1984 2.5 Oil
1985 2.2 Oil
1986 2.0 Oil
1987 0.9 Oil
1988 .87 Oil
1989 0.4 Oil
1980 2.2 Gas
1981 3.8 Gas
1982 3.5 Gas
1983 2.8 Gas
1984 3.1 Gas
1985 2.31 Gas
1986 2.15 Gas
1987 1.85 Gas
1988 1.2 Gas
1989 .98 Gas
1980 2.4 Water
1981 2.2 Water
1982 2.8 Water
1983 3.01 Water
1984 3.1 Water
1985 2.88 Water
1986 3.3 Water
1987 3.8 Water
1988 3.2 Water
1989 2.5 Water
;
run;

/* 
Calculating this for the html charttip (gbarline can automatically calculate
it for the bar height).
*/
proc sql; 
 create table my_data as select *, 
 sum(barrels) as sum_bar,
 avg(barrels) as avg_bar
 from my_data 
 group by year;
quit; run;

data my_data; set my_data;
length myhtml $200;
myhtml=
 'title='||quote( 
  'Year: '||trim(left(year))||'0D'x||
  'Oil+Gas+Water total: '||trim(left(put(sum_bar,comma5.2)))||'0D'x||
  '(Oil+Gas+Water)/3 avg: '||trim(left(put(avg_bar,comma5.2))))||
 ' href="purbar_info.htm"';
run;

goptions device=png;
goptions border cback=cxdad5c0;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm"
 (title="SAS/Graph 2d gbarline - Carpinteria Oil Fields plot") 
 style=d3d gtitle nogfootnote;
 
title1 ls=1.5 "Carpinteria Oil Fields";
title2 "Bar is sum of oil+gas+water, Line is annual mean";

footnote 
 link="http://www.visualmining.com/examples/serverexamples/combochart6.html"
 h=12pt c=magenta "Imitation of this 'visual mining inc' plot (click here to see)";

axis1 order=(0 to 10 by 2) minor=none offset=(0,0) label=(angle=90);
axis2 order=(0 to 10 by 2) minor=none offset=(0,0) label=none;
axis3 offset=(6,6) label=none;

goptions ftitle="albany amt/bold" ftext="albany amt" gunit=pct htitle=4.5 htext=2.5;

pattern1 v=s c=cx65479e;
pattern2 v=s c=cx989a30;
pattern3 v=s c=cx0083a0;

symbol i=join ci=cxffff4f w=4 v=dot cv=cxffff4f h=5; 

proc gbarline data=my_data;
bar year / type=sum sumvar=barrels discrete 
 axis=axis1 maxis=axis3 
 autoref clipref cref=white lref=1
 width=8 cframe=gray nolegend coutline=black 
 html=myhtml
 des='' name="&name";
plot / type=mean sumvar=barrels 
 axis=axis2;
run;

quit;
ODS HTML CLOSE;
ODS LISTING;
