*------------------------------------------水平条形图---------------------------------------*;
%let name=bar1;
filename odsout '.';

data my_data;
input ITEM $ 1-6 AMOUNT;
datalines;
ITEM A 11.8
ITEM B 10.5
ITEM C 8.8
ITEM D 6.8
ITEM E 4.2
ITEM F 2.3
;
run;

data my_data; set my_data;
length htmlvar $500;
htmlvar=
 'title='||quote(
  'Item: '||trim(left(item)) ||'0D'x||
  'Amount: '||trim(left(amount)))||
 ' href="bar1_info.htm"';
run;


goptions device=png;
goptions noborder;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" 
 (title="SAS/Graph - Simple gchart Bar Chart") style=sasweb;

goptions gunit=pct htitle=6 ftitle="albany amt/bold" htext=4.25 ftext="albany amt/bold";

axis1 label=none;
axis2 label=('AMOUNT') order=(0 to 12 by 2) minor=(number=1) offset=(0,0);

/* pattern v=solid color=red; */
pattern v=solid color=cx43a2ca;  /* this is the hex rgb color for mild blue */

title1 ls=1.5 "Simple Bar Chart";
proc gchart data=my_data; 
hbar item / discrete type=sum sumvar=amount nostats
 maxis=axis1 raxis=axis2 
 autoref clipref 
 cref=graycc coutline=black 
 html=htmlvar
 des='' name="&name";  
run;

quit;
ODS HTML CLOSE;
ODS LISTING;

*--------------------------------------分组条形图----------------------------*;
%let name=bar2;
filename odsout '.';

data my_data;
input ITEM $ 1-6 CLASS $ 8-16 AMOUNT;
datalines;
ITEM A 1st CLASS 11.8
ITEM B 1st CLASS 8.8 
ITEM C 1st CLASS 7.5
ITEM D 1st CLASS 3.2
ITEM A 2nd CLASS 10.5
ITEM B 2nd CLASS 9.3  
ITEM C 2nd CLASS 5.3
ITEM D 2nd CLASS 2.2
;
run;

data my_data; set my_data;
length htmlvar $500;
htmlvar=
 'title='||quote(
  'Item: '|| trim(left(item)) ||'0D'x||
  'Class: '|| trim(left(class)) ||'0D'x||
  'Amount: '|| trim(left(amount))
  )||
 ' href="bar2_info.htm"';
run;

goptions device=png;
goptions noborder;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" (title="SAS/Graph gchart Grouped Bar Chart") style=sasweb;

goptions gunit=pct htitle=6 ftitle="albany amt/bold" htext=4.25 ftext="albany amt/bold";

axis1 label=none value=none;  /* only use the group axis for value/bar text */
axis2 label=('AMOUNT') order=(0 to 12 by 2) minor=(number=1) offset=(0,0);
axis3 label=none offset=(4,4);

legend1 label=none position=(bottom right inside) cframe=white mode=protect 
 shape=bar(3,3) cborder=black across=1;

/* pattern v=solid color=red; */
pattern1 v=solid color=cxbd0026;  /* reddish color */
pattern2 v=solid color=cx43a2ca;  /* this is the hex rgb color for mild blue */

title1 ls=1.5 "Grouped Bar Chart";
proc gchart data=my_data; 
hbar class / discrete type=sum sumvar=amount nostats
 group=item
 subgroup=class 
 maxis=axis1 raxis=axis2 gaxis=axis3 
 space=0 gspace=2 coutline=black 
 autoref clipref cref=graycc
 legend=legend1
 html=htmlvar
 des="" name="&name";  
run;

quit;
ODS HTML CLOSE;
ODS LISTING;


*----------------------------------------------- Bar-And-Symbol Chart-------------------------------------*;
%let name=bar3;
filename odsout '.';

data my_data;
input ITEM $ 1-6 AMOUNT PREVIOUS;
datalines;
ITEM A 11.8 10.8
ITEM B 10.5 8.8
ITEM C 8.4  7.8
ITEM D 5.8  6.4
ITEM E 4.4  5.0
ITEM F 2.3  1.6
;
run;

data my_data; set my_data;
length htmlvar $500;
htmlvar=
 'title='||quote(
  'Item: '|| trim(left(item)) ||'0D'x||
  'Amount: '|| trim(left(amount))
  )||
 ' href="bar3_info.htm"';
run;


/* Annotate a symbol on the bars, showing previous year's value. */
data anno_mark; set my_data;
length function color $8 text $30;
xsys='2'; ysys='2'; hsys='3'; when='a';
midpoint=item; x=previous; 
function='label'; size=3.75; color='cxbd0026'; position='5';
style='marker'; /* sas/graph 'marker' software font */
text='P';  /* 'P' is a diamond-shape in the marker font */
length html $500;
html=
 'title='||quote(
  'Item: '|| trim(left(item)) ||'0D'x||
  'Previous Year Amount: '|| trim(left(previous))
  )||
 ' href="bar3_info.htm"';
output;
run;


goptions device=png;
goptions noborder;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" (title="SAS/Graph gchart Bar-And-Symbol Chart") style=sasweb;

goptions gunit=pct htitle=6 ftitle="albany amt/bold" htext=4.25 ftext="albany amt/bold";

axis1 label=none offset=(8,8);
axis2 label=('AMOUNT') order=(0 to 12 by 2) minor=(number=1) offset=(0,0);

pattern v=solid color=cx43a2ca;  /* this is the hex rgb color for mild blue */

title1 ls=1.5 "Bar-And-Symbol Chart";
title2 "(bar=current year, symbol=previous year's value)";

proc gchart data=my_data anno=anno_mark; 
hbar item / discrete type=sum sumvar=amount nostats
 maxis=axis1 raxis=axis2 
 autoref clipref space=2 cref=graycc
 coutline=black 
 html=htmlvar
 des='' name="&name";  
run;

quit;
ODS HTML CLOSE;
ODS LISTING;


*--------------------------------------------------------------- Paired-Bar Chart--------------------------------------------*;
%let name=bar4;
filename odsout '.';

/* You have to make some values 'negative' so they'll show up on
   the left side of the zero axis, but you want their labels to
   show the positive value.  Use a user-defined format to 
   accomplish this. */
proc format; picture posval low-high='000,009'; run;

data my_data;
input ITEM $ 1-6 left right;
format amount posval.;
illusion='Group 1'; amount=-1*left; output;
illusion='Group 2'; amount=right; output;
datalines;
ITEM A  41 58
ITEM B  53 51 
ITEM C  42 33 
ITEM D  23 28
ITEM E  12 17
ITEM F  18 13
;
run;

data my_data; set my_data;
length htmlvar $500;
htmlvar=
 'title='||quote(
  'Item: '|| trim(left(item))||'0D'x||
  'Group 1: '|| trim(left(left))||'0D'x||
  'Group 2: '|| trim(left(right))
  )||
 ' href="bar4_info.htm"';
run;


goptions device=png;
goptions noborder;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" (title="SAS/Graph gchart Paired-Bar Chart") style=sasweb;

goptions gunit=pct htitle=6 ftitle="albany amt/bold" htext=4.25 ftext="albany amt/bold";

axis1 label=none;  
axis2 label=none order=(-60 to 60 by 10) minor=none offset=(0,0) value=(h=3pct);

pattern1 v=solid color=cxbd0026;  /* reddish color */
pattern2 v=solid color=cx43a2ca;  /* this is the hex rgb color for mild blue */

legend1 label=none position=(bottom) cframe=white
 shape=bar(3,3) cborder=white across=2;

title1 ls=1.5 "Paired-Bar Chart";

proc gchart data=my_data; 
hbar item / discrete type=sum sumvar=amount nostats
 subgroup=illusion 
 maxis=axis1 raxis=axis2 
 autoref clipref cref=graycc
 legend=legend1 coutline=same
 html=htmlvar
 des="" name="&name";  
run;

quit;
ODS HTML CLOSE;
ODS LISTING;

*-----------------------------------------------------------------Subdivided Bar Chart----------------------------------------*;
%let name=bar5;
filename odsout '.';

data my_data;
input ITEM $ 1-6 CLASS $ 8-16 AMOUNT;
datalines;
ITEM A 1st CLASS 7.2
ITEM A 2nd CLASS 3.1
ITEM A 3rd CLASS 1.6
ITEM B 1st CLASS 6.2 
ITEM B 2nd CLASS 2.1  
ITEM B 3rd CLASS 2.3  
ITEM C 1st CLASS 4.8
ITEM C 2nd CLASS 1.9
ITEM C 3rd CLASS .9
ITEM D 1st CLASS 3.7
ITEM D 2nd CLASS 1.1
ITEM D 3rd CLASS 1.9
ITEM E 1st CLASS 2.8
ITEM E 2nd CLASS 2.3
ITEM E 3rd CLASS .9 
ITEM F 1st CLASS 1.5
ITEM F 2nd CLASS .9 
ITEM F 3rd CLASS .95
;
run;

data my_data; set my_data;
length htmlvar $500;
htmlvar=
 'title='||quote(
  'Item: '|| trim(left(item)) ||'0D'x||
  'Class: '|| trim(left(class)) ||'0D'x||
  'Amount: '|| trim(left(amount))
  )||
 ' href="bar5_info.htm"';
run;


goptions device=png;
goptions noborder;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" (title="SAS/Graph gchart Subdivided Bar Chart") style=sasweb;

goptions gunit=pct htitle=6 ftitle="albany amt/bold" htext=4.25 ftext="albany amt/bold";

axis1 label=none;  
axis2 label=('AMOUNT') order=(0 to 12 by 2) minor=(number=1) offset=(0,0);

legend1 label=none position=(bottom right inside) cframe=white mode=protect 
 shape=bar(3,3) cborder=black across=1;

/* pattern v=solid color=red; */
pattern1 v=solid color=cxbd0026;  /* reddish color */
pattern2 v=solid color=cx43a2ca;  /* this is the hex rgb color for mild blue */
pattern3 v=solid color=cxc7e9b4;  /* kind of a seafoam green */

title1 ls=1.5 "Subdivided Bar Chart";

proc gchart data=my_data; 
hbar item / discrete type=sum sumvar=amount nostats
 subgroup=class 
 maxis=axis1 raxis=axis2 
 autoref clipref cref=graycc
 legend=legend1 coutline=black 
 html=htmlvar
 des='' name="&name";  
run;

quit;
ODS HTML CLOSE;
ODS LISTING;


*---------------------------------------------------------------- Deviation Bar Chart----------------------------------------------------------*;
%let name=bar6;
filename odsout '.';

data my_data;
input ITEM $ 1-6 AMOUNT;
colorvar=amount/abs(amount);  /* 2 values ... one, or negative one */
datalines;
ITEM A 11.8
ITEM B -10.5
ITEM C -8.8
ITEM D 6.8
ITEM E 4.2
ITEM F -2.3
;
run;

data my_data; set my_data;
length htmlvar $500;
htmlvar=
 'title='||quote(
  'Item: '|| trim(left(Item)) ||'0D'x||
  'Amount: '|| trim(left(amount))
  )||
 ' href="bar6_info.htm"';
run;


goptions device=png;
goptions noborder;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" (title="SAS/Graph gchart Deviation Bar Chart") style=sasweb;

goptions gunit=pct htitle=6 ftitle="albany amt/bold" htext=4.25 ftext="albany amt/bold";

axis1 label=none;
axis2 label=('AMOUNT') order=(-12 to 12 by 4) minor=(number=1) offset=(0,0);

/* pattern v=solid color=red; */
pattern1 v=solid color=cxbd0026;  /* reddish color */
pattern2 v=solid color=cx43a2ca;  /* this is the hex rgb color for mild blue */

title1 ls=1.5 "Deviation Bar Chart";

proc gchart data=my_data; 
hbar item / discrete type=sum sumvar=amount nostats
 subgroup=colorvar  
 maxis=axis1 raxis=axis2 
 autoref clipref cref=graycc
 nolegend coutline=black 
 html=htmlvar
 des='' name="&name";  
run;

quit;
ODS HTML CLOSE;
ODS LISTING;

*---------------------------------------------- Subdivided 100% Chart -------------------------------------------------------*;
%let name=bar7;
filename odsout '.';

data my_data;
input ITEM $ 1-6 CLASS $ 8-16 AMOUNT;
format amount percent6.0;
amount=amount/100;
datalines;
ITEM A 1st CLASS 74
ITEM A 2nd CLASS 12
ITEM A 3rd CLASS 14
ITEM B 1st CLASS 62 
ITEM B 2nd CLASS 21  
ITEM B 3rd CLASS 17  
ITEM C 1st CLASS 43
ITEM C 2nd CLASS 20
ITEM C 3rd CLASS 37
ITEM D 1st CLASS 29
ITEM D 2nd CLASS 41
ITEM D 3rd CLASS 30
ITEM E 1st CLASS 22
ITEM E 2nd CLASS 32
ITEM E 3rd CLASS 46
;
run;

data my_data; set my_data;
length htmlvar $500;
htmlvar=
 'title='||quote(
  'Item: '|| trim(left(Item)) ||'0D'x||
  'Class: '|| trim(left(Class)) ||'0D'x||
  'Amount: '|| trim(left(amount))
  )||
 ' href="bar7_info.htm"';
run;


goptions device=png;
goptions noborder;

ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" (title="SAS/Graph gchart Subdivided 100% Bar Chart") style=sasweb;

goptions gunit=pct htitle=6 ftitle="albany amt/bold" htext=4.25 ftext="albany amt/bold";

axis1 label=none;  
axis2 label=none order=(0 to 1 by .1) minor=(number=1) offset=(0,0) value=(h=3pct);

legend1 label=none position=(bottom)  
 shape=bar(3,3) across=3;

/* pattern v=solid color=red; */
pattern1 v=solid color=cxbd0026;  /* reddish color */
pattern2 v=solid color=cx43a2ca;  /* this is the hex rgb color for mild blue */
pattern3 v=solid color=cxc7e9b4;  /* kind of a seafoam green */

title1 ls=1.5 "Subdivided 100% Bar Chart";

proc gchart data=my_data; 
hbar item / discrete type=sum sumvar=amount nostats
 subgroup=class 
 maxis=axis1 raxis=axis2 
 autoref cref=gray77 clipref
 coutline=same 
 legend=legend1
 html=htmlvar
 des='' name="&name";  
run;

quit;
ODS HTML CLOSE;
ODS LISTING;

*------------------------------------------------------------ Sliding-Bar Chart---------------------------------------------*;
%let name=bar8;
filename odsout '.';

data my_data;
input ITEM $ 1-6 amount;
format amount percent6.0;
amount=amount/100;
illusion='right'; output;
illusion='left'; amount=amount-1.00; output;
datalines;
ITEM A  100
ITEM B   68
ITEM C   83
ITEM D   53
ITEM E   92
ITEM F   70
;
run;

data my_data; set my_data;
length htmlvar $500;
htmlvar=
 'title='||quote(
  'Item: '||trim(left(item))||'0D'x||
  'Side: '||trim(left(illusion))||'0D'x||
  'Amount: '||trim(left(put(amount,percent6.0)))
  )||
 ' href="bar8_info.htm"';
run;


goptions device=png;
goptions noborder;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" (title="Sliding-Bar Chart") style=sasweb;

goptions gunit=pct htitle=6 ftitle="albany amt/bold" htext=4.25 ftext="albany amt/bold";

axis1 label=none;  
axis2 label=none order=(-.50 to 1.00 by .25) minor=(number=1) offset=(0,0) value=(h=3pct);

legend1 label=none position=(bottom right inside) cframe=white mode=protect 
 shape=bar(3,3) cborder=black across=1;

/* There's a bar segment to the left, and one to the right of the 0%-line.
   Make them both the same color, so they look like 1 continuous "sliding" bar. */
pattern1 v=solid color=cx43a2ca;    
pattern2 v=solid color=cx43a2ca;  

title1 ls=1.5 "Sliding-Bar Chart";

proc gchart data=my_data; 
hbar item / discrete type=sum sumvar=amount nostats
 subgroup=illusion 
 maxis=axis1 raxis=axis2 
 autoref clipref cref=graycc
 nolegend coutline=blue
 html=htmlvar
 des='' name="&name";  
run;

quit;
ODS HTML CLOSE;
ODS LISTING;

*-----------------------------------------------Basic Simple Column Chart --------------------------------------*;
%let name=col1;
filename odsout '.';

data my_data;
input TIME AMOUNT;
datalines;
1 9
2 13
3 22
4 24
5 28
6 32
7 37
8 41
9 42
10 49
11 45
;
run;

data my_data; set my_data;
length htmlvar $500;
htmlvar=
 'title='||quote(
  'Time: '|| trim(left(Time)) ||'0D'x||
  'Amount: '|| trim(left(amount))
  )||
 ' href="col1_info.htm"';
run;


goptions device=png;
goptions noborder;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" (title="SAS/Graph gchart Simple Column Chart") style=sasweb;

goptions gunit=pct htitle=6 ftitle="albany amt/bold" htext=4.25 ftext="albany amt/bold";

axis1 label=('TIME');
axis2 label=(a=90 'AMOUNT') order=(0 to 50 by 10) minor=none offset=(0,0);

/* pattern v=solid color=red; */
pattern v=solid color=cx43a2ca;  /* this is the hex rgb color for mild blue */

title1 ls=1.5 "Simple Column Chart";

proc gchart data=my_data; 
vbar time / discrete type=sum sumvar=amount 
 maxis=axis1 raxis=axis2 
 autoref clipref cref=graycc
 coutline=black width=6 
 html=htmlvar
 des='' name="&name";  
run;

quit;
ODS HTML CLOSE;
ODS LISTING;

*----------------------------------------------------------------- Net-Deviation Column---------------------------------------------*;
%let name=col2;
filename odsout '.';

data my_data;
input TIME AMOUNT;
colorvar=amount/abs(amount);  /* 2 values ... one, or negative one */
datalines;
1 -13
2 -9
3 -19
4 -26
5 -19
6 -6
7 12
8 21
9 29
10 24
11 27
12 24
;
run;

data my_data; set my_data;
length htmlvar $500;
htmlvar=
 'title='||quote(
  'Time: '|| trim(left(time)) ||'0D'x||
  'Amount: '|| trim(left(amount))
  )||
 ' href="col2_info.htm"';
run;


goptions device=png;
goptions noborder;

ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" (title="SAS/Graph gchart Net-Deviation Column Chart") style=sasweb;

goptions gunit=pct htitle=6 ftitle="albany amt/bold" htext=4.25 ftext="albany amt/bold";

axis1 label=('TIME');
axis2 label=(a=90 'AMOUNT') order=(-30 to 30 by 10) minor=none offset=(0,0);

pattern1 v=solid color=cxbd0026;  /* reddish color */
pattern2 v=solid color=cx43a2ca;  /* this is the hex rgb color for mild blue */

title1 ls=1.5 "Net-Deviation Column Chart";

proc gchart data=my_data; 
vbar time / discrete type=sum sumvar=amount 
 subgroup=colorvar nolegend
 maxis=axis1 raxis=axis2 
 autoref clipref cref=graycc
 coutline=black width=5 
 html=htmlvar
 des='' name="&name";  
run;

quit;
ODS HTML CLOSE;
ODS LISTING;

*------------------------------------------------------------ Connected Column Chart-----------------------------------------------*;
%let name=col3;
filename odsout '.';

data my_data;
input TIME AMOUNT;
datalines;
1 8
2 13
3 16
4 26
5 31
6 38
7 28
8 34
9 38
10 48
11 36
12 43
13 45
14 49
15 44
;
run;

data my_data; set my_data;
length htmlvar $500;
htmlvar=
 'title='||quote(
  'Time: '|| trim(left(Time)) ||'0D'x||
  'Amount: '|| trim(left(amount))
  )||
 ' href="col3_info.htm"';
run;


goptions device=png;
goptions noborder;

ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" (title="SAS/Graph gchart Connected Column Chart") style=sasweb;

goptions gunit=pct htitle=6 ftitle="albany amt/bold" htext=4.25 ftext="albany amt/bold";

axis1 label=('TIME') offset=(4,4) value=(h=4pct);
axis2 label=(a=90 'AMOUNT') order=(0 to 50 by 10) minor=none offset=(0,0);

pattern v=solid color=cxbd0026;  /* reddish color */

title1 ls=1.5 "Connected Column Chart";

proc gchart data=my_data; 
vbar time / discrete type=sum sumvar=amount 
 maxis=axis1 raxis=axis2
 autoref cref=gray77 coutline=graycc 
 width=5 space=0 
 html=htmlvar
 des='' name="&name";  
run;

quit;
ODS HTML CLOSE;
ODS LISTING;


*----------------------------------------------- Gross-Deviation Column---------------------------------------------*;
%let name=col4;
filename odsout '.';

data my_data;
input TIME sales expenses;
datalines;
1 3.6 4.4
2 5.1 7.0
3 3.0 5.0
4 5.0 7.5
5 7.0 8.1
6 9.5 11.0
7 9.0 7.0
8 11.0 9.0
9 10.2 7.3
10 9.1 6.8
11 10.1 8.8
12 10.0 9.3
;
run;

data my_data; set my_data;
length class $8;
amount=sales-expenses; 
if (sales ge expenses) then do;
 class='Profit';  output;  /* net profit */
 class='Sales'; amount=sales-(sales-expenses); output;
 class='Expenses'; amount=-1*expenses; output;
 end;
else do;
 class='Deficit'; output;  /* net loss */
 class='Sales'; amount=sales; output;
 class='Expenses'; amount=-1*(expenses-(expenses-sales)); output;
 end;
run;

data my_data; set my_data;
length htmlvar $500;
htmlvar=
 'title='||quote(
  'Time: '||trim(left(time))||'0D'x||
  'Class: '||trim(left(Class))||'0D'x||
  'Sales: '||trim(left(Sales))||'0D'x||
  'Expenses: '|| trim(left(Expenses))
  )||
 ' href="col4_info.htm"';
run;


goptions device=png;
goptions noborder;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" (title="SAS/Graph gchart Gross-Deviation Column Chart") style=sasweb;

goptions gunit=pct htitle=6 ftitle="albany amt/bold" htext=4.25 ftext="albany amt/bold";

axis1 label=('TIME');  
axis2 label=(a=90 'AMOUNT') order=(-12 to 12 by 4) 
 minor=(number=1) offset=(0,0);

pattern1 v=solid color=cxbd0026;  /* reddish - ie 'in the red' */ 
pattern2 v=solid color=cx43a2ca;  /* this is the hex rgb color for mild blue */
pattern3 v=solid color=gray55;    /* blackish - ie 'in the black' (profit) */
pattern4 v=solid color=cxc7e9b4;  /* kind of a seafoam green */

title1 ls=1.5 "Gross-Deviation Column Chart";

proc gchart data=my_data; 
vbar time / discrete type=sum sumvar=amount nolegend
 subgroup=class 
 maxis=axis1 raxis=axis2 
 autoref cref=graycc clipref 
 width=5 coutline=black 
 html=htmlvar
 des='' name="&name";  
run;

quit;
ODS HTML CLOSE;
ODS LISTING;

*------------------------------------------------------------Basic Grouped-Column Chart ----------------------------------------------*;
%let name=col5;
filename odsout '.';

data my_data;
input TIME CLASS $ 8-16 AMOUNT;
datalines;
1      1st CLASS 3.2
2      1st CLASS 7.5
3      1st CLASS 8.8 
4      1st CLASS 11.8
1      2nd CLASS 2.2
2      2nd CLASS 5.3
3      2nd CLASS 9.3  
4      2nd CLASS 10.5
;
run;

data my_data; set my_data;
length htmlvar $500;
htmlvar=
 'title='||quote(
  'Time: '||trim(left(Time))||'0D'x||
  'Class: '||trim(left(Class))||'0D'x||
  'Amount: '||trim(left(amount))
  )||
 ' href="col5_info.htm"';
run;


goptions device=png;
goptions noborder;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" (title="SAS/Graph gchart Grouped Column Chart") style=sasweb;

goptions gunit=pct htitle=6 ftitle="albany amt/bold" htext=4.25 ftext="albany amt/bold";

axis1 label=none value=none;  
axis2 label=(a=90 'AMOUNT') order=(0 to 12 by 2) minor=(number=1) offset=(0,0);
axis3 label=('TIME') offset=(4,4);

legend1 label=none position=(top left inside) cframe=white mode=protect 
 shape=bar(3,3) cborder=black across=1;

pattern1 v=solid color=cxbd0026;  /* reddish color */
pattern2 v=solid color=cx43a2ca;  /* this is the hex rgb color for mild blue */

title1 ls=1.5 "Grouped Column Chart";

proc gchart data=my_data; 
vbar class / discrete type=sum sumvar=amount 
 group=time subgroup=class 
 space=0 gspace=4
 maxis=axis1 raxis=axis2 gaxis=axis3 
 autoref clipref cref=graycc
 legend=legend1 coutline=black 
 html=htmlvar
 des='' name="&name";  
run;

quit;
ODS HTML CLOSE;
ODS LISTING;


*------------------------------------------------------------------- Floating-Column Chart------------------------------------------------*;
%let name=col6;
filename odsout '.';

data my_data;
input TIME CLASS $ 8-16 AMOUNT;
if class eq 'Bottom Pc' then amount=-1*amount;
datalines;
1      Top Piece 7.5
1      Bottom Pc 5.0
2      Top Piece 6.0
2      Bottom Pc 2.0
3      Top Piece 9.5
3      Bottom Pc 0.8
4      Top Piece 7.0
4      Bottom Pc 5.0
5      Top Piece 9.0 
5      Bottom Pc 4.5
6      Top Piece 8.8
6      Bottom Pc 6.0
7      Top Piece 10.2
7      Bottom Pc 7.0
8      Top Piece 11.1
8      Bottom Pc 5.0
9      Top Piece 8.6
9      Bottom Pc 3.1
10     Top Piece 6.9 
10     Bottom Pc 1.7
11     Top Piece 9.4
11     Bottom Pc 4.4
12     Top Piece 7.0 
12     Bottom Pc 6.1
;
run;

data my_data; set my_data;
length htmlvar $500;
htmlvar=
 'title='||quote(
  'Time: '||trim(left(time))||'0D'x||
  'Piece: '||trim(left(class))||'0D'x||
  'Amount: '||trim(left(amount))
  )||
 ' href="col6_info.htm"';
run;


goptions device=png;
goptions noborder;

ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" (title="SAS/Graph gchart Floating-Column Column Chart") style=sasweb;

goptions gunit=pct htitle=6 ftitle="albany amt/bold" htext=4.25 ftext="albany amt/bold";

axis1 label=('TIME') offset=(5,5);  
axis2 label=(a=90 'AMOUNT') order=(-8 to 12 by 4) minor=(number=1) offset=(0,0);

pattern1 v=solid color=cx43a2ca;  /* reddish color */
pattern2 v=solid color=cx43a2ca;  /* this is the hex rgb color for mild blue */

title1 ls=1.5 "Floating-Column Column Chart";

proc gchart data=my_data; 
vbar time / discrete type=sum sumvar=amount 
 subgroup=class 
 maxis=axis1 raxis=axis2 
 autoref clipref cref=graycc
 nolegend coutline=blue 
 width=5 space=2
 html=htmlvar
 des='' name="&name";  
run;

quit;
ODS HTML CLOSE;
ODS LISTING;


*-------------------------------------------- Subdivided-Column Chart--------------------------------------*;
%let name=col7;
filename odsout '.';

data my_data;
input TIME CLASS $ 8-16 AMOUNT;
datalines;
8      1st CLASS 4.6
8      2nd CLASS 1.2
8      3rd CLASS 2.3
7      1st CLASS 5.2
7      2nd CLASS 3.6
7      3rd CLASS 1.0
6      1st CLASS 7.2
6      2nd CLASS 3.1
6      3rd CLASS 1.6
5      1st CLASS 6.2 
5      2nd CLASS 2.1  
5      3rd CLASS 2.3  
4      1st CLASS 4.8
4      2nd CLASS 1.9
4      3rd CLASS .9
3      1st CLASS 3.7
3      2nd CLASS 1.1
3      3rd CLASS 1.9
2      1st CLASS 2.8
2      2nd CLASS 2.3
2      3rd CLASS .9 
1      1st CLASS 1.5
1      2nd CLASS .9 
1      3rd CLASS .95
;
run;

data my_data; set my_data;
length htmlvar $500;
htmlvar=
 'title='||quote(
  'Time: '|| trim(left(Time)) ||'0D'x||
  'Class: '|| trim(left(Class)) ||'0D'x||
  'Amount: '|| trim(left(amount))
  )||
 ' href="col7_info.htm"';
run;


goptions device=png;
goptions noborder;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" (title="SAS/Graph gchart Subdivided Column Chart") style=sasweb;

goptions gunit=pct htitle=6 ftitle="albany amt/bold" htext=4.25 ftext="albany amt/bold";

axis1 label=('TIME');  
axis2 label=(a=90 'AMOUNT') order=(0 to 12 by 2) minor=(number=1) offset=(0,0);

legend1 label=none position=(top left inside) cframe=white mode=protect 
 shape=bar(3,3) cborder=black across=1;

/* pattern v=solid color=red; */
pattern1 v=solid color=cxbd0026;  /* reddish color */
pattern2 v=solid color=cx43a2ca;  /* this is the hex rgb color for mild blue */
pattern3 v=solid color=cxc7e9b4;  /* kind of a seafoam green */

title1 ls=1.5 "Subdivided Column Chart";

proc gchart data=my_data; 
vbar time / discrete type=sum sumvar=amount 
 subgroup=class 
 maxis=axis1 raxis=axis2 
 autoref clipref cref=graycc
 legend=legend1 coutline=black width=7.5
 html=htmlvar
 des='' name="&name";  
run;

quit;
ODS HTML CLOSE;
ODS LISTING;

*------------------------------------------------------  Range Chart--------------------------------------------------*;
%let name=col8;
filename odsout '.';

data my_data;
input TIME LOWER UPPER AVERAGE;
illusion='bottom'; amount=lower; output;
illusion='top'; amount=upper-lower; output;
datalines;
1 6.5 9.5 7.0
2 6.8 8.7 7.2
3 8.2 10.9 8.3
4 6.4 10.6 8.2
5 6.0 9.7 8.8
6 5.2 9.8 8.1
7 3.2 7.9 6.9
8 5.5 8.0 7.0
9 6.3 10.7 9.1
10 9.3 11.2 10.0
11 8.0 10.0 9.9
12 8.3 10.9 8.4
;
run;

data my_data; set my_data;
length htmlvar $500;
if illusion eq 'top' then do;
htmlvar=
 'title='||quote(
  'Time: '||trim(left(Time))||'0D'x||
  'Max: '||trim(left(upper))||'0D'x||
  'Min: '||trim(left(lower))
  )||
 ' href="bar7_info.htm"';
end;
run;

/* Annotate a symbol on the bars, showing average value. */
data annomark; set my_data;
length function color $8 text $30;
xsys='2'; ysys='2'; hsys='3'; when='a';
midpoint=time; y=average; 
function='label'; size=3.75; color='cxbd0026'; position='5';
style='marker'; /* sas/graph 'marker' software font */
text='B';  /* 'B' is a triangle-shaped character in the marker font */
/* this is the mouse-over text for the annotated marker */
length html $500;
html=
 'title='||quote(
  'Time: '|| trim(left(Time)) ||'0D'x||
  'Average: '|| trim(left(average))
  )||
 ' href="bar7_info.htm"';
output;
run;


goptions device=png;
goptions noborder;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" (title="SAS/Graph gchart Range Chart") style=sasweb;

goptions gunit=pct htitle=6 ftitle="albany amt/bold" htext=4.25 ftext="albany amt/bold";

axis1 label=('TIME');  
axis2 label=(a=90 'AMOUNT') order=(0 to 12 by 2) minor=(number=1) offset=(0,0);

pattern1 v=solid color=white;  /* the white section of the bar creates the
 illusion that the blue section is 'floating' */
pattern2 v=solid color=cx43a2ca;  /* this is the hex rgb color for mild blue */

title1 ls=1.5 "Range Chart";
title2 "(bar=min/max, marker=avg)";

proc gchart data=my_data anno=annomark; 
vbar time / discrete 
 type=sum sumvar=amount 
 subgroup=illusion /* this controls the coloring */
 maxis=axis1 /* midpoint axis */
 raxis=axis2 /* response/numeric axis */
 autoref /* reflines at every major axis tickmark */
 cref=graycc
 nolegend
 coutline=same 
 space=3
 html=htmlvar
 des="" name="&name";  
run;

quit;
ODS HTML CLOSE;
ODS LISTING;
