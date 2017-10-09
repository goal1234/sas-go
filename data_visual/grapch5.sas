*-----一堆表格图------*;
%let name=cardio;
filename odsout '.';

/* 
Imitation of graphic Mike Zdeb sent me - the original graphic appeared in 
"European Heart Journal (2003) 24, 987-1003
Estimation of ten-year risk of fatal cardiovascular disease in Europe: the sCORE project"

Here's a low-resolution picture (higher-resolution in the actual paper)...
http://www.dartmouth.edu/%7Echance/chance_news/current_news/current.html

The layout of this custom SAS/Graph is *very* hard-coded, and it would
be a big challenge to change the number of rows or columns (whereas it
would be easy to change the numbers & text and leave the layout the
way it is.
*/

%let textsize=2.0;

/*
Sex = F/M
Smoker=N (nonsmoker), S (smoker)
*/
data my_data;
input sex $ 1-1 smoker $ 3-3 agegroup bloodpressure cholesterol risk;
grid_id=
  sex||'_'||
  smoker||'_'||
  trim(left(agegroup))||'_'||
  trim(left(bloodpressure))||'_'||
  trim(left(cholesterol));
datalines;
F N 65 120 4 2
F N 65 120 5 2
F N 65 120 6 3
F N 65 120 7 3
F N 65 120 8 4
F N 65 140 4 3
F N 65 140 5 3
F N 65 140 6 4
F N 65 140 7 5
F N 65 140 8 6
F N 65 160 4 5
F N 65 160 5 5
F N 65 160 6 6
F N 65 160 7 7
F N 65 160 8 8
F N 65 180 4 7
F N 65 180 5 8
F N 65 180 6 9
F N 65 180 7 10
F N 65 180 8 12
F S 65 120 4 4
F S 65 120 5 5
F S 65 120 6 5
F S 65 120 7 6
F S 65 120 8 7
F S 65 140 4 6
F S 65 140 5 7
F S 65 140 6 8
F S 65 140 7 9
F S 65 140 8 11
F S 65 160 4 9
F S 65 160 5 10
F S 65 160 6 12
F S 65 160 7 13
F S 65 160 8 16
F S 65 180 4 13
F S 65 180 5 15
F S 65 180 6 17
F S 65 180 7 19
F S 65 180 8 22
M N 65 120 4 4
M N 65 120 5 5
M N 65 120 6 6
M N 65 120 7 7
M N 65 120 8 9
M N 65 140 4 6
M N 65 140 5 8
M N 65 140 6 9
M N 65 140 7 11
M N 65 140 8 13
M N 65 160 4 9
M N 65 160 5 11
M N 65 160 6 13
M N 65 160 7 15
M N 65 160 8 16
M N 65 180 4 14
M N 65 180 5 16
M N 65 180 6 19
M N 65 180 7 22
M N 65 180 8 26
M S 65 120 4 9
M S 65 120 5 10
M S 65 120 6 12
M S 65 120 7 14
M S 65 120 8 17
M S 65 140 4 13
M S 65 140 5 15
M S 65 140 6 17
M S 65 140 7 20
M S 65 140 8 24
M S 65 160 4 18
M S 65 160 5 21
M S 65 160 6 25
M S 65 160 7 29
M S 65 160 8 34
M S 65 180 4 26
M S 65 180 5 30
M S 65 180 6 35
M S 65 180 7 41
M S 65 180 8 47
F N 60 120 4 1
F N 60 120 5 1
F N 60 120 6 2
F N 60 120 7 2
F N 60 120 8 2
F N 60 140 4 2
F N 60 140 5 2
F N 60 140 6 2
F N 60 140 7 3
F N 60 140 8 3
F N 60 160 4 3
F N 60 160 5 3
F N 60 160 6 3
F N 60 160 7 4
F N 60 160 8 5
F N 60 180 4 4
F N 60 180 5 4
F N 60 180 6 5
F N 60 180 7 6
F N 60 180 8 7
F S 60 120 4 2
F S 60 120 5 3
F S 60 120 6 3
F S 60 120 7 4
F S 60 120 8 4
F S 60 140 4 3
F S 60 140 5 4
F S 60 140 6 5
F S 60 140 7 5
F S 60 140 8 6
F S 60 160 4 5
F S 60 160 5 6
F S 60 160 6 7
F S 60 160 7 8
F S 60 160 8 9
F S 60 180 4 8
F S 60 180 5 9
F S 60 180 6 10
F S 60 180 7 11
F S 60 180 8 13
M N 60 120 4 3
M N 60 120 5 3
M N 60 120 6 4
M N 60 120 7 5
M N 60 120 8 6
M N 60 140 4 4
M N 60 140 5 5
M N 60 140 6 6
M N 60 140 7 7
M N 60 140 8 9
M N 60 160 4 6
M N 60 160 5 7
M N 60 160 6 9
M N 60 160 7 10
M N 60 160 8 12
M N 60 180 4 9
M N 60 180 5 11
M N 60 180 6 13
M N 60 180 7 15
M N 60 180 8 18
M S 60 120 4 6
M S 60 120 5 7
M S 60 120 6 8
M S 60 120 7 10
M S 60 120 8 12
M S 60 140 4 8
M S 60 140 5 10
M S 60 140 6 12
M S 60 140 7 14
M S 60 140 8 17
M S 60 160 4 12
M S 60 160 5 14
M S 60 160 6 17
M S 60 160 7 20
M S 60 160 8 24
M S 60 180 4 18
M S 60 180 5 21
M S 60 180 6 24
M S 60 180 7 28
M S 60 180 8 33
F N 55 120 4 1
F N 55 120 5 1
F N 55 120 6 1
F N 55 120 7 1
F N 55 120 8 1
F N 55 140 4 1
F N 55 140 5 1
F N 55 140 6 1
F N 55 140 7 1
F N 55 140 8 2
F N 55 160 4 1
F N 55 160 5 2
F N 55 160 6 2
F N 55 160 7 2
F N 55 160 8 3
F N 55 180 4 2
F N 55 180 5 2
F N 55 180 6 3
F N 55 180 7 3
F N 55 180 8 4
F S 55 120 4 1
F S 55 120 5 1
F S 55 120 6 2
F S 55 120 7 2
F S 55 120 8 2
F S 55 140 4 2
F S 55 140 5 2
F S 55 140 6 2
F S 55 140 7 3
F S 55 140 8 3
F S 55 160 4 3
F S 55 160 5 3
F S 55 160 6 4
F S 55 160 7 4
F S 55 160 8 5
F S 55 180 4 4
F S 55 180 5 5
F S 55 180 6 5
F S 55 180 7 6
F S 55 180 8 7
M N 55 120 4 2
M N 55 120 5 2
M N 55 120 6 3
M N 55 120 7 3
M N 55 120 8 4
M N 55 140 4 3
M N 55 140 5 3
M N 55 140 6 4
M N 55 140 7 5
M N 55 140 8 6
M N 55 160 4 4
M N 55 160 5 5
M N 55 160 6 6
M N 55 160 7 7
M N 55 160 8 8
M N 55 180 4 6
M N 55 180 5 7
M N 55 180 6 8
M N 55 180 7 10
M N 55 180 8 12
M S 55 120 4 4
M S 55 120 5 4
M S 55 120 6 5
M S 55 120 7 6
M S 55 120 8 8
M S 55 140 4 5
M S 55 140 5 6
M S 55 140 6 8
M S 55 140 7 9
M S 55 140 8 11
M S 55 160 4 8
M S 55 160 5 9
M S 55 160 6 11
M S 55 160 7 13
M S 55 160 8 16
M S 55 180 4 12
M S 55 180 5 13
M S 55 180 6 16
M S 55 180 7 19
M S 55 180 8 22
F N 50 120 4 0
F N 50 120 5 0
F N 50 120 6 1
F N 50 120 7 1
F N 50 120 8 1
F N 50 140 4 0
F N 50 140 5 1
F N 50 140 6 1
F N 50 140 7 1
F N 50 140 8 1
F N 50 160 4 1
F N 50 160 5 1
F N 50 160 6 1
F N 50 160 7 1
F N 50 160 8 1
F N 50 180 4 1
F N 50 180 5 1
F N 50 180 6 1
F N 50 180 7 2
F N 50 180 8 2
F S 50 120 4 1
F S 50 120 5 1
F S 50 120 6 1
F S 50 120 7 1
F S 50 120 8 1
F S 50 140 4 1
F S 50 140 5 1
F S 50 140 6 1
F S 50 140 7 1
F S 50 140 8 2
F S 50 160 4 1
F S 50 160 5 2
F S 50 160 6 2
F S 50 160 7 2
F S 50 160 8 3
F S 50 180 4 2
F S 50 180 5 2
F S 50 180 6 3
F S 50 180 7 3
F S 50 180 8 4
M N 50 120 4 1
M N 50 120 5 1
M N 50 120 6 2
M N 50 120 7 2
M N 50 120 8 2
M N 50 140 4 2
M N 50 140 5 2
M N 50 140 6 2
M N 50 140 7 3
M N 50 140 8 3
M N 50 160 4 2
M N 50 160 5 3
M N 50 160 6 3
M N 50 160 7 4
M N 50 160 8 5
M N 50 180 4 4
M N 50 180 5 4
M N 50 180 6 5
M N 50 180 7 6
M N 50 180 8 7
M S 50 120 4 2
M S 50 120 5 3
M S 50 120 6 3
M S 50 120 7 4
M S 50 120 8 5
M S 50 140 4 3
M S 50 140 5 4
M S 50 140 6 5
M S 50 140 7 6
M S 50 140 8 7
M S 50 160 4 5
M S 50 160 5 6
M S 50 160 6 7
M S 50 160 7 8
M S 50 160 8 10
M S 50 180 4 7
M S 50 180 5 8
M S 50 180 6 10
M S 50 180 7 12
M S 50 180 8 14
F N 40 120 4 0
F N 40 120 5 0
F N 40 120 6 0
F N 40 120 7 0
F N 40 120 8 0
F N 40 140 4 0
F N 40 140 5 0
F N 40 140 6 0
F N 40 140 7 0
F N 40 140 8 0
F N 40 160 4 0
F N 40 160 5 0
F N 40 160 6 0
F N 40 160 7 0
F N 40 160 8 0
F N 40 180 4 0
F N 40 180 5 0
F N 40 180 6 0
F N 40 180 7 0
F N 40 180 8 0
F S 40 120 4 0
F S 40 120 5 0
F S 40 120 6 0
F S 40 120 7 0
F S 40 120 8 0
F S 40 140 4 0
F S 40 140 5 0
F S 40 140 6 0
F S 40 140 7 0
F S 40 140 8 0
F S 40 160 4 0
F S 40 160 5 0
F S 40 160 6 0
F S 40 160 7 0
F S 40 160 8 0
F S 40 180 4 0
F S 40 180 5 0
F S 40 180 6 0
F S 40 180 7 1
F S 40 180 8 1
M N 40 120 4 0
M N 40 120 5 0
M N 40 120 6 1
M N 40 120 7 1
M N 40 120 8 1
M N 40 140 4 0
M N 40 140 5 1
M N 40 140 6 1
M N 40 140 7 1
M N 40 140 8 1
M N 40 160 4 1
M N 40 160 5 1
M N 40 160 6 1
M N 40 160 7 1
M N 40 160 8 1
M N 40 180 4 1
M N 40 180 5 1
M N 40 180 6 1
M N 40 180 7 2
M N 40 180 8 2
M S 40 120 4 1
M S 40 120 5 1
M S 40 120 6 1
M S 40 120 7 1
M S 40 120 8 1
M S 40 140 4 1
M S 40 140 5 1
M S 40 140 6 1
M S 40 140 7 2
M S 40 140 8 2
M S 40 160 4 1
M S 40 160 5 2
M S 40 160 6 2
M S 40 160 7 2
M S 40 160 8 3
M S 40 180 4 2
M S 40 180 5 2
M S 40 180 6 3
M S 40 180 7 3
M S 40 180 8 4
;
run;

data my_data; set my_data;
length myhtml $500;
 myhtml=
 'title='|| quote(
  'Sex (M/F):      '||trim(left(sex))||'0D'x||
  'Smoker (S/N):   '||trim(left(smoker))||'0D'x||
  'Agegroup:       '||trim(left(agegroup))||'0D'x||
  'Blood Pressure: '||trim(left(bloodpressure))||'0D'x||
  'Cholesterol:    '||trim(left(cholesterol))||'0D'x||
  'Risk Score:     '||trim(left(risk))||'% ')||
 ' href='||quote('cardio_info.htm');
run;

data my_data; set my_data;
if risk eq 0 then risk_color=0;  /* green */
if risk eq 1 then risk_color=1;  /* lighter green */
if risk eq 2 then risk_color=2;  /* yellow/orange */
if risk ge 3 and risk le 4 then risk_color=3; /* orange */
if risk ge 5 and risk le 9 then risk_color=4; /* red */
if risk ge 10 and risk le 14 then risk_color=5; /* dark red */
if risk ge 15 then risk_color=6; /* very dark red */
run;

/* Create a sas/graph gmap map dataset, with 4 coordinates for each data obsn */
data my_map; set my_data;
x=cholesterol-4;
if smoker eq 'S' then x=x+6;
if sex eq 'M' then x=x+14;
y=((bloodpressure-120)/20);
if agegroup gt 40 then y=y + ((agegroup-45)/5 * 5);
       output;
x=x+1; output;
y=y+1; output;
x=x-1; output;
run;

/* These are the annotated numbers inside the colored boxes */
proc sql noprint;
create table my_anno as 
select unique grid_id, avg(x) as x, avg(y) as y, risk, risk_color
from my_map 
group by grid_id;
quit; run;

data my_anno; set my_anno;
length function style color $8 text $30 html $1024;                     
xsys='2'; ysys='2'; hsys='3'; when='a'; position='5';
length color $ 12;
if risk_color in (0 5 6) then color='yellow';
else color='black';
function='label';
style='';
size=&textsize;
text=trim(left(risk));
run;

proc sql noprint;
create table anno_left as
select unique 0 as x, avg(y) as y, bloodpressure, agegroup
from my_map 
group by bloodpressure, agegroup;
quit; run;
data anno_left; set anno_left;
length function style color $8 text $30 html $1024;                     
xsys='2'; ysys='2'; hsys='3'; when='a'; position='4';
color='black';
function='label';
style='';
size=&textsize;
text=trim(left(bloodpressure))||'a0'x;
run;

proc sql noprint;
create table anno_middle as
select unique 13 as x, avg(y) as y, agegroup
from my_map 
group by agegroup;
quit; run;
data anno_middle; set anno_middle;
length function style color $8 text $30 html $1024;                     
xsys='2'; ysys='2'; hsys='3'; when='a'; position='4';
color='cx7e0517';
function='label';
style='';
size=&textsize;
text=trim(left(agegroup));
run;

data anno_legendtitle;
length function style color $8 text $30 html $1024;                     
xsys='2'; ysys='2'; hsys='3'; when='a'; position='5';
x=29; y=16.6;
color='black';
function='label';
style='';
size=&textsize*1.5;
text='SCORE'; output;
/* Now, put a '+' in the middle of the 'O' in the legend title */
text='+'; output;
run;

data anno_comment;
length function style color $8 text $30 html $1024;                     
xsys='2'; ysys='2'; hsys='3'; when='a'; position='5';
color='black';
function='label';
style='';
size=&textsize;
x=29; y=6;
text='10-year risk of'; output;
y=y-.9;
text='fatal CVD in'; output;
y=y-.9;
text='populations at'; output;
y=y-.9;
text='high CVD risk'; output;
run;

data anno_mgdl;
length function style color $8 text $30 html $1024;                     
xsys='2'; ysys='2'; hsys='3'; when='a'; position='5';
color='cx7e0517';
size=.25;
y=-1.25; x=20; function='move'; output;
y=-1.25; x=25; function='draw'; output;
y=-1.25; x=21; function='move'; output;
y=-1.50; x=21; function='draw'; output;
y=-1.25; x=22; function='move'; output;
y=-1.50; x=22; function='draw'; output;
y=-1.25; x=23; function='move'; output;
y=-1.50; x=23; function='draw'; output;
y=-1.25; x=24; function='move'; output;
y=-1.50; x=24; function='draw'; output;
color='black';
function='label';
style='';
size=1.5;
position='5';
x=21; y=-1.75; text='150'; output;
x=22; y=-1.75; text='200'; output;
x=23; y=-1.75; text='250'; output;
x=24; y=-1.75; text='300'; output;
x=22.5; y=-2.5; text='mg/dl'; output;
run;

data anno_middle2;
length function style color $8 text $30 html $1024;                     
xsys='2'; ysys='2'; hsys='3'; when='a'; position='4';
x=13; y=25;
color='cx7e0517';
function='label';
style='';
size=&textsize;
text='Age';
run;

proc sql noprint;
create table anno_bottom as
select unique avg(x) as x, 0 as y, sex, smoker, cholesterol
from my_map group by sex, smoker, cholesterol;
quit; run;
data anno_bottom; set anno_bottom;
length function style color $8 text $30 html $1024;                     
xsys='2'; ysys='2'; hsys='3'; when='a'; position='E';
color='black';
function='label';
style='';
size=&textsize;
text=trim(left(cholesterol));
run;

data anno_left2;
length function style color cbox cborder $8 text $30 html $1024;
xsys='2'; ysys='2'; hsys='3'; when='a'; position='6';
x=-2.5;
y=0;
color='black';
cbox='cornsilk';
cborder='cx7e0517';
function='label';
style='';
size=&textsize;
/* unfortunately cbox doesn't honor the trailing blank (S0247701) */
text=' Systolic blood pressure'||'a0'x;
angle=90;
run;

proc sql noprint;
create table anno_bottom2 as
select unique avg(x) as x, -2 as y
from my_map;
quit; run;
data anno_bottom2; set anno_bottom2;
length function style color cbox cborder $8 text $30 html $1024;
xsys='2'; ysys='2'; hsys='3'; when='a'; position='5';
color='black';
cbox='cornsilk';
cborder='cx7e0517';
function='label';
style='';
size=&textsize;
text=' Cholesterol mmol'||'a0'x;
run;

proc sql noprint;
create table anno_top as
select unique avg(x) as x, 25 as y, sex, smoker
from my_map group by sex, smoker;
quit; run;
data anno_top; set anno_top;
length function style color cbox cborder $8 text $30 html $1024;
xsys='2'; ysys='2'; hsys='3'; when='a'; position='5';
color='black';
cbox='cornsilk';
cborder='cx7e0517';
function='label';
style='';
size=&textsize;
if smoker eq 'N' then text=' Non-Smoker'||'a0'x;
if smoker eq 'S' then text=' Smoker'||'a0'x;
run;

proc sql noprint;
create table anno_top2 as
select unique avg(x) as x, 26.5 as y, sex
from my_map group by sex;
quit; run;
data anno_top2; set anno_top2;
length function style color cbox cborder $8 text $30 html $1024;
xsys='2'; ysys='2'; hsys='3'; when='a'; position='5';
color='black';
cbox='cornsilk';
cborder='cx7e0517';
function='label';
style='';
size=&textsize;
size=size*1.3;
if sex eq 'M' then text=' Men'||'a0'x;
if sex eq 'F' then text=' Women'||'a0'x;
run;

/* Various annotation that goes around the main chart */
data around_anno; 
 set anno_left anno_left2 anno_middle anno_middle2 anno_bottom anno_bottom2 
     anno_top anno_top2 anno_legendtitle anno_comment anno_mgdl;
run;

/* Add a fake map area to the bottom/left, to guarantee some space */
data fake_space;
grid_id='foo1';
x=-3; y=-3; output;
x=x+.01; output;
y=y+.01; output;
grid_id='foo2';
x=26; y=26.5; output;
x=x+.01; output;
y=y+.01; output;
run;
data my_map; set my_map fake_space;
run;



goptions device=png;
goptions xpixels=1000 ypixels=1000;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" 
 (title="Cardiovascular Disease - Europe SCORE (SAS/Graph)") style=htmlblue;
 
goptions ftitle="albany amt" ftext="albany amt" gunit=pct htitle=3.25 htext=1.75;

title1 ls=1.5 "Estimation of ten-year risk of fatal cardiovascular";
title2 h=3.25 "disease in Europe: the SCORE project";
title3 a=-90 h=2 " ";

pattern1 v=s c=cx4cc417;
pattern2 v=s c=cxbce954;
pattern3 v=s c=cxfdd017;
pattern4 v=s c=cxfa9b17;
pattern5 v=s c=cxf63817;
pattern6 v=s c=cxc22817;
pattern7 v=s c=cx7e0517;

legend1 label=none
 value=(j=l '< 1%' '1%' '2%' '3%-4%' '5%-9%' '10%-14%' '15% and over  ')
 frame cframe=cornsilk cborder=cx7e0517
 position=(right middle) across=1 shape=bar(.2in,.2in);

proc gmap data=my_data map=my_map anno=around_anno all; 
id grid_id;
choro risk_color /
 legend=legend1
 coutline=gray
 cempty=white /* for the small 'fake' map areas in the corners */
 cdefault=white
 anno=my_anno
 html=myhtml
 des='' name="&name"; 
run;

quit;
ODS HTML CLOSE;
ODS LISTING;

*----------------------------------------------------学生旅行图--------------------------------------*;
%let name=class;
filename odsout '.';

/* Zipcodes with > threshold attendees going to a training center show up in red */
%let threshold=100;

/* This example uses some new v9.1.3 stuff, to do the "tiling" of the map and
   gchart side-by-side.  You could take that ods 'tagset' stuff out, and let
   the table go under the map in v8.2 or higher, if you don't have the v9.1.3
   or higher that has those ods tagsets.
*/

libname here '.';
data ends; set here.students;
anno_flag=1;
run;

/* Could use 'proc geocode' instead, for zipcode-level geocoding */
proc sql noprint;
create table ends as
select unique ends.*, zipcode.city, zipcode.x as long, zipcode.y as lat
from ends inner join sashelp.zipcode
on ends.zip=zipcode.zip;
quit; run;

data ends; set ends;
length zipcity $100;
st=zipstate(zip);
state=stfips(st);
zipcity=zipcity(zip);
begin_long=long;
begin_lat=lat;
run;

data ends; set ends (where=(st not in ('AK' 'HI' 'PR')));
run;


/* Drawing lines from every zipcode made the lines too dense, therefore
   I'm summarizing by city rather than zipcode (1 line from every city).
   I'll just use the long/lat of the 'first' zipcode from each city as
   the location of that city. */
proc sql noprint;
create table ends as 
select *, sum(myvalue) as citysum
from ends
group by zipcity; /* zipcity is the city & state */
quit; run;

proc sort data=ends out=ends; 
by zipcity;
run;

data ends; set ends;
by zipcity;
if first.zipcity then output;
run;


/* Now, get the info about the 'destinations' (ie, our training centers) */
proc sql noprint;
create table dest as 
select zip, locationcode 
from here.training_centers;
quit; run;

proc sql noprint;
create table dest as
select unique dest.*, zipcode.city as destcity, zipcode.x as long, zipcode.y as lat
from dest left join sashelp.zipcode
on dest.zip=zipcode.zip;
quit; run;

data dest; set dest;
st=zipstate(zip);
state=stfips(st);
dest_long=long;
dest_lat=lat;
run;

/* Now, add the destination information to each obsn of the ends dataset */
/* Note that this 'inner join'  leaves out any obsns that don't have a 
   matching locationcode  */
proc sql noprint;
create table myanno as
select unique ends.*, dest.destcity, dest.dest_long, dest.dest_lat
from ends inner join dest
on ends.locationcode=dest.locationcode;
quit; run;

/* Use this variable for the html title= chart-tips, in the annotate and
   also in the gchart pie slices and bars (to use in annotate, this
   variable *must* be named 'html').  */
data myanno; set myanno;
length endshtml $300;
endshtml=
 'title='||quote(
  'Students From: '||trim(left(zipcity))||'0D'x||
  'Attending Class in: '||trim(left(destcity))||'0D'x||
  'Count = '||trim(left(citysum)));
length desthtml $300;
desthtml=
 'title='||quote('Training Center: '||trim(left(destcity)));
run;

/* Now, turn the city & ends info into annotated lines & text and such */
data myanno; set myanno;
length html $300 function color $8;
xsys='2'; ysys='2'; hsys='3'; when='A';  
 if citysum >= &threshold then color='red';
 else color='gray';
 long=begin_long; lat=begin_lat; 
 html=endshtml;
 function='pie'; rotate=360; size=.3; style='psolid'; position='5'; 
 output;
 long=dest_long; lat=dest_lat; 
 function='draw'; size=.1;
 output;
 color='cx00ff00'; /* Make the training centers bright green */
 html=desthtml;
 traincenter=1;
 function='pie'; rotate=360; size=.3; style='psolid'; position='5'; 
 output;
run; 


/* Sort the annotate dataset, so the 'red' lines will be on top and 
   more likely to be visible in dense situations.  Also, sort the
   training center (green dots) so they are on the very top. */
proc sort data=myanno out=myanno; 
by traincenter citysum;
run;


data my_map; set mapsgfk.us_states (where=(statecode not in ('HI' 'AK' 'PR') and density<=2 ) drop=resolution);
run;

/* project the map & annotate data */
data combined; set my_map myanno; run;
proc gproject data=combined out=combined latlong eastlong degrees dupok;
id state;
run;
data my_map myanno; set combined;
if anno_flag=1 then output myanno;
else output my_map;
run;

/* You could let gchart summarize the values for the bars on-the-fly,
   but by pre-summarizing them, it gives me access to the final totals,
   and I can then "stuff" them into an html title= variable, for a charttip. */
proc sql noprint;
create table sumbar as
select unique st, sum(citysum) as statesum
from ends
group by st;
quit; run;

data sumbar; set sumbar;
length barhtml $300;
barhtml=
 'title='|| quote(
  'State: '||trim(left(fipnamel(stfips(st))))||'0D'x||
  'Count = '||trim(left(put(statesum,comma10.0))));
run;


ods listing close;

goptions dev=png;
goptions gunit=pct ftext="albany amt";

ods tagsets.htmlpanel path="." (url=none) file="&name..htm" style=sasweb;
ods usegopt; 

%let panelborder=1; /* outermost panel border width of 1 */


ods tagsets.htmlpanel event=row_panel(start);

/* Cell 1 (left graph) */
%let panelborder=0;  
ods tagsets.htmlpanel event=column_panel(start);

goptions xpixels=850 ypixels=650;
goptions htext=2.5 ftitle="albany amt/bold" htitle=4.5;

title1 ls=1.3 "SAS Training Center Attendee Travel 2";
title2 "Cities with >= &threshold attendees appear in " c=red "red";
title3 "SAS training centers appear in " c=cx00ff00 "green";

title4 h=2 a=90 " ";
title5 h=2 a=-90 " ";

footnote c=gray "(Mouse over cities/dots and bars to see detailed info)";

pattern1 v=s c=tan;

proc gmap data=my_map map=my_map anno=myanno;
id state;
choro state / levels=1 nolegend
 coutline=white
 des='' name="&name";
run;

/* Close the column panel */
ods tagsets.htmlpanel event=column_panel(finish);

/* Cell 2 (right graph) */
%let panelborder=0; 
ods tagsets.htmlpanel event=column_panel(start);

goptions xpixels=250 ypixels=650;
goptions htext=1.75 ftitle="albany amt" htitle=4;

title1 ls=1.3 "Summary by State";
footnote;

pattern1 v=s c=graycc;

axis1 label=none value=(j=c);
axis2 label=('Attendees from that state') major=none minor=none style=0 offset=(0,0);

proc gchart data=sumbar;
format statesum comma10.0;
hbar st / type=sum sumvar=statesum descending
 nostats nolegend noframe coutline=gray
 maxis=axis1 raxis=axis2 autoref cref=graycc clipref
 space=0
 html=barhtml
 des='' name="&name";
run;

/* Close the column panel */
ods tagsets.htmlpanel event=column_panel(finish);

/* Close the whole panel */
ods tagsets.htmlpanel event=row_panel(finish);

ods _all_ close;


*----------------------------------------------------------tornado diagram------------------------------------------*;
%let name=tornado;
filename odsout '.';

/* 
   Here is an example of how you can do a "tornado diagram"
   in sas/graph gplot.  
   To create the 'bars', I use a "thick" line segment (see the large w= 
   value in the symbol statement).  I insert 'missing' value
   between the line segments, and I use the 'skipmiss' gplot
   option to tell it to not connect the pieces of the line 
   where it encounters a 'missing' value.  To get the pieces
   in the correct order (larger on top, and smaller on bottom)
   I sort the data, and then assign an 'stack_order' variable.
   I want labels to show up along the left-hand side, rather
   than the 'order' number -- I use a user-defined format.

   In this example, I was imitating the following tornado diagram
   (just using approximated data, not the actual data):
   http://www.syncopationsoftware.com/images/tornado_798x433.png
   (now defunct page)

*/

%let refvalue=350;
%let x_min=-100;
%let x_max=700;

data tornado_data; 
input text_label $ 1-30 min max; 
length=max-min;
datalines; 
Share of at risk revenue lost  -50 690
Gross margin                   25 480
Trendline revenue growth rate  175 510
Share of revenue at risk       250 375
Other cost growth rate         290 425
Bad debt allowance             275 400
Interest rate on WC            300 375
Working capital                325 375
; 
run; 

/* determine the order, based on length of lines */
proc sort data=tornado_data out=tornado_data;
by length;
run;
data tornado_data; set tornado_data;
stack_order=_n_;
run;

/* create a user-defined-format, so stack_order prints as the text_label */
proc sql;
create table foo as
select unique stack_order as start, text_label as label
from tornado_data;
quit; run;
data control; set foo;
fmtname = 'torfmt';
type = 'N';
end = START;
run;
proc format lib=work cntlin=control;
run;


/* Insert missing value between each line segment, to use with 'skipmiss' */
data tornado_data; set tornado_data;
y=stack_order; x=min; output;
y=stack_order; x=max; output;
y=.; x=.; output;
run;


goptions device=png;
goptions noborder;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" 
  (title="SAS/Graph Tornado Diagram") style=htmlblue;

goptions gunit=pct ftitle="albany amt/bold" htitle=8 ftext="albany amt" htext=2.1;

symbol1 interpol=join color=cx00ff00 value=none width=25;

axis1 label=none major=none minor=none style=0 offset=(3,3);
axis2 c=black label=none minor=none order=(&x_min to &x_max by 100);

title1 ls=1.5 "Tornado Diagram";
title2 h=3.5 "For sensitivity & decision analyses";

proc gplot data=tornado_data; 
format stack_order torfmt.;
plot stack_order*x / skipmiss
 vaxis=axis1 haxis=axis2 noframe
 href=&refvalue
 des='' name="&name"; 
run; 

quit;
ODS HTML CLOSE;
ODS LISTING;

*---------------------------------------------------------一个大的直方图---------------------------------*;
%let name=spam;
filename odsout '.';

data my_data;
input DATE date7. BLOCKED PASSED;
datalines;
06jun04 863586 71404
05jun04 911758 86788
04jun04 916032 183813
03jun04 928621 156971
02jun04 924343 174701
01jun04 905648 159293
31may04 867309 88014
30may04 777196 64925
29may04 825498 74746
28may04 925292 125233
27may04 984453 138886
26may04 1019002 140981
25may04 915433 144775
24may04 857451 128389
23may04 786921 59018
22may04 847174 69578
21may04 852587 121093
20may04 859371 139120
19may04 801877 145892
18may04 798284 135745
17may04 783494 122768
16may04 742810 67163
15may04 770275 76959
14may04 788414 126836
13may04 732670 136343
12may04 756924 121585
11may04 802102 122494
10may04 707049 109813
09may04 680273 55437
08may04 747288 74061
;
run;

proc sort data=my_data out=my_data; 
by date; 
run;

proc transpose data=my_data out=tran_data (rename=(col1=amount)) name=mailtype;
by date;
run;

proc format;
   value mailfmt
   1='PASSED'
   2='BLOCKED'
   ;
run;

data tran_data; set tran_data;
format date date7.;
format amount comma10.0;
length my_html $500;
my_html=
 'title='||quote(
  'Date:  '||trim(left(put(date,date7.)))||'0D'x||
  'Type:  '||trim(left(mailtype))||'0D'x||
  'Count: '||trim(left(put(amount,comma10.0)))
  );
/* play with the data, and use a user-defined format,
   so the ordering of the bar segment/subgroups will be such that
   the 'passed' email will be at the bottom -- otherwise, the
   would be on the top because they would be ordered alphabetically.
*/
format mail_sub mailfmt.;
if mailtype eq 'PASSED' then mail_sub=1;
else if mailtype eq 'BLOCKED' then mail_sub=2;
run;

/* for the printed table... */
data my_data; set my_data;
format total passed blocked comma10.0;
format pctblk percent6.1;
format date date7.;
TOTAL=passed+blocked;
PCTBLK=blocked/total;
run;


goptions device=png;
goptions noborder;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" 
 (title="SAS/Graph bar chart showing percent of blocked SPAM mail") style=htmlblue;

goptions gunit=pct htitle=5.25 htext=2.25 ftitle="albany amt" ftext="albany amt";
 
title1 ls=1.5 "SPAM BLOCKING BY DAY";
title2 "FOR PREVIOUS 30 DAYS";
title3 a=-90 h=2 " ";

legend1 label=none shape=bar(.15in,.15in) value=(justify=l);

axis1 label=(a=90 'DAILY EMAIL COUNT') minor=none offset=(0,0);
axis2 label=none value=(a=90);

pattern1 v=s c=cx1E90FF; /* blue */
pattern2 v=s c=cxF08080; /* red */

proc gchart data=tran_data; 
vbar date / discrete type=sum sumvar=amount  
 subgroup=mail_sub 
 autoref clipref cref=graycc
 raxis=axis1 maxis=axis2
 legend=legend1 noframe
 html=my_html
 des='' name="&name"; 
run;

title;
proc print data=my_data noobs label; 
label date='Process Data';
label total='Total Emails Processed';
label blocked='Emails Blocked';
label pctblk='Percent Blocked';
var date total blocked pctblk;
sum total blocked;
run;

quit;
ODS HTML CLOSE;
ODS LISTING;

*-------------------------------------------------利润预测-------------------------------------*;
%let name=revenue;
filename odsout '.';

%let thedate=01mar2003;


/* 
This example is similar to a piece of the SAS Performance Management scorecard.
This example utilizes the new v9.1.3 html paneling to do the multiple charts laid 
out on the same page (see Eric Gebhart and Dan Heath for info on html paneling).
*/

data sites;
input st $ 1-2 revenue;
revenue=revenue*1000;  
date="&thedate"d;
format date date9.;
format revenue dollar15.0;
state=stfips(st);
length htmlvar $1020;
htmlvar=
 'title='||quote(
  trim(left(fipnamel(state)))||'0D'x||
  'Date = '||trim(left(put(date,date9.)))||'0D'x||
  'Revenue = '||trim(left(put(revenue,dollar15.0)))
  )||
 ' href="revenue.htm"';
datalines;
AK 72.82
AL 8.01
AR 4.71
AZ 42.76
CA 59.99
CO 74.21
CT 31.84
DC 117.65
DE 9.32
FL 35.95
GA 9.00
HI 53.24
IA 41.63
ID 54.11
IL 38.46
IN 33.28
KS 41.22
KY 9.64
LA 16.38
MA 51.99
MD 130.21
ME 3.76
MI 71.45
MN 86.64
MO 35.32
MS 3.47
MT 55.62
NC 8.60
ND 35.38
NE 26.43
NH 11.21
NJ 61.20
NM 25.22
NV 32.74
NY 151.90
OH 84.35
OK 21.25
OR 37.79
PA 76.21
RI 13.20
SC 11.10
SD 20.35
TN 18.83
TX 72.91
UT 48.33
VA 74.25
VT 6.48
WA 22.26
WI 62.26
WV 7.20
WY 23.99
run;

data sites; set sites;
length region $20;
if st in ('NC' 'SC' 'GA' 'FL' 'AL' 'MS' 'TN' 'KY' 'VA' 'WV' 'PA' 'MD' 'NJ' 'NY' 'MA' 'VT' 'CT' 'ME' 'DE' 'NH' 'DC') 
 then region='Big East';
else if st in ('CA' 'WA' 'AK' 'HI' 'OR' 'NM' 'NV' 'AZ' 'UT' 'CO' 'ID' 'MT' 'WY') 
 then region='West Coast';
else region='Central Region';
run;

data states1;
set maps.us;
st=fipstate(state);
length region $20;
if st in ('NC' 'SC' 'GA' 'FL' 'AL' 'MS' 'TN' 'KY' 'VA' 'WV' 'PA' 'MD' 'NJ' 'NY' 'MA' 'VT' 'CT' 'ME' 'DE' 'NH' 'DC') 
 then region='Big East';
else if st in ('CA' 'WA' 'AK' 'HI' 'OR' 'NM' 'NV' 'AZ' 'UT' 'CO' 'ID' 'MT' 'WY') 
 then region='West Coast';
else region='Central Region';
run;

   /* sort the new map data set */
/* This step must be done, or the regions will not be shaded as desired */
proc sort data=states1 out=states;
   by region state;
run;

/* pre-summarize data for the pie chart, so I can add title= charttips showing
   the summarized value */
proc sql;
create table piesum as
select unique date, region, sum(revenue) as revenue
from sites
group by date, region
having date = "&thedate"d
;
quit; run;
data piesum; set piesum;
format revenue dollar15.0;
length htmlvar $1020;
htmlvar=
 'title='||quote(
  trim(left(region))||'0D'x||
  'Date = '||trim(left(put(date,date9.)))||'0D'x||
  'Revenue = '||trim(left(put(revenue,dollar15.0))))||
 ' href="revenue.htm"';
run;

data series;
input date date9. revenue;
format date date9.;
format revenue dollar15.0;
datalines;
01jan2001 2800000
01feb2001 2780000
01mar2001 2766000
01apr2001 2752000
01may2001 2790000
01jun2001 2730000
01jul2001 2603700
01aug2001 2715000
01sep2001 2600480
01oct2001 2720080
01nov2001 2650000
01dec2001 2712345
01jan2002 2364160
01feb2002 2324160
01mar2002 2254192
01apr2002 2264160
01may2002 2264160
01jun2002 2274160
01jul2002 2276160
01aug2002 2396160
01sep2002 2296160
01oct2002 1600830
01nov2002 2306160
01dec2002 2296160
01jan2003 2230180
01feb2003 2176160
01mar2003 2146120
;
run;

proc forecast data=series out=outseries outfull outest=est
 interval=month method=stepar trend=2 lead=12;
 id date;
 var revenue;
run;
/* Now, merge the forecast results back into the series dataset,
   in a somewhat "tricky" way, such that I can plot it exactly 
   like I want to ... */
proc sql;
create table forecast as 
 select date, revenue as forecast
 from outseries 
 where _type_ eq 'FORECAST'
 and date gt "&thedate"d;
create table upper as 
 select date, revenue as upper
 from outseries 
 where _type_ eq 'U95'
 and date gt "&thedate"d;
create table lower as 
 select date, revenue as lower
 from outseries 
 where _type_ eq 'L95'
 and date gt "&thedate"d;
create table forecast as 
 select forecast.*, upper.upper
 from forecast left join upper
 on forecast.date=upper.date;
create table forecast as 
 select forecast.*, lower.lower
 from forecast left join lower
 on forecast.date=lower.date;
quit; run;

data series; 
 set series forecast;
length htmlvar $1020;
if revenue ne . then
htmlvar=
 'title='||quote(
  'Date = '||trim(left(put(date,date9.)))||'0D'x||
  'Revenue = '||trim(left(put(revenue,dollar15.0))))||
 ' href="revenue.htm"';
else
htmlvar=
 'title='||quote(
  'Date = '||trim(left(put(date,date9.)))||'0D'x||
  'Forecast = '||trim(left(put(forecast,dollar15.0))))|| 
 ' href="revenue.htm"';
run;


goptions dev=png;
 
/* -------------------------------------- */

%let panelborder=1; /* panel border width of 1 */
ods tagsets.htmlpanel path="." (url=none) file="&name..htm" 
 (title='SAS/Graph ODS htmlpanel multi-pane graph') style=htmlblue;

/* Top graph */
ods tagsets.htmlpanel event=column_panel(start);
%let panelborder=0; /* panel border width of 0 */
ods tagsets.htmlpanel event=row_panel(start);
goptions xpixels=804 ypixels=400;

goptions gunit=pct htitle=8 ftitle="albany amt/bold" htext=3.5 ftext="albany amt";
goptions ctext=gray55;

symbol1 c=cx33a02c i=join v=dot h=1;   /* Revenue */ 
symbol2 c=cxe31a1c i=join v=dot h=1;   /* FORECAST */ 
symbol3 c=cx1f77b4 i=join v=none l=3;  /* L95 */ 
symbol4 c=cx1f77b4 i=join v=none l=3;  /* U95 */ 

axis1 label=('Revenue') major=(number=7) minor=none offset=(0,0);
axis2 label=none minor=none value=(t=2 '' t=4 '' t=6 '' t=8 '') offset=(0,0);

title1 ls=1.3 "Total US Revenue Forecast";
title2 "Mouse over graphs to see data values";

proc gplot data=series;
plot revenue*date=1 forecast*date=2 lower*date=3 upper*date=4 / overlay
 vzero
 vaxis=axis1
 haxis=axis2
 autovref cvref=graydd
 href="01apr2003"d lhref=2 chref=gray
 html=htmlvar
 des='' name="&name";
run;

ods tagsets.htmlpanel event=row_panel(finish);

/* -------------------------------------- */

/* Two bottom graphs */
%let panelborder=0; /* panel border width of 0 */
ods tagsets.htmlpanel event=row_panel(start);
goptions xpixels=400 ypixels=330;

goptions gunit=pct htitle=8 ftitle="albany amt/bold" htext=4.0 ftext="albany amt";

/* pattern/colors for bars - the number of patterns here must match
   the number of "levels=" you specify in your gmap (or if you do a
   discrete gmap then you must have a pattern for every discrete value) */
pattern1 c=cxbbbddc value=solid;  /* light */
pattern2 c=cx6151a3 value=solid;  /* */
pattern3 c=cx3f007d value=solid;  /* dark */

/* pattern for map surface areas (what is normally the 'choro' map) */
pattern4 c=cx4e8975 value=msolid;    
pattern5 c=cxc7a317 value=msolid;
pattern6 c=cxc24641 value=msolid;

title1 ls=1.3 'Revenue By State';
/* 
I'm using "note" instead of "title2" to leave more room for the 
map and the pie
*/

proc gmap map=states data=sites;
note move=(40,85) "&thedate";
id region state;
block revenue / levels=3 nolegend area=1    
 coutline=grayee
 cblkout=same
 html=htmlvar
 des='' name="&name";
run;


pattern1 c=cx4e8975 value=psolid;    
pattern2 c=cxc7a317 value=psolid;
pattern3 c=cxc24641 value=psolid;

title1 ls=1.3 'Revenue By Region';

proc gchart data=piesum;
note move=(40,85) "&thedate";
/*
pie3d region / angle=-90
*/
pie region / angle=100 jstyle
 sumvar=revenue
 slice=outside
 value=outside
 percent=outside
 html=htmlvar
 noheading
 coutline=same
 des='' name="&name";
run;

ods tagsets.htmlpanel event=row_panel(finish);
ods tagsets.htmlpanel event=column_panel(finish);

/* -------------------------------------- */

ods _all_ close;

