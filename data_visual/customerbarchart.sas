*------漂亮的折线图-----*;
%let name=boys;
filename odsout '.';

data my_data;
format television percent5.0;
input year television;
datalines;
1991 .315
1992 .307
1993 .315
1994 .323
1995 .315
1996 .303
1997 .304
1998 .294
1999 .281
2000 .305
2001 .298
2002 .295
2003 .276
;
run;

/* 
Some shared code to create the 'anno_box' data set, which annotates 
the axis frame, with rounded corners.
*/
%let cornersize=5;
%include 'anno_box.sas';


goptions device=png;
goptions hsize=5in vsize=4.5in;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" 
 (title="SAS/Graph Imitation of American Demographics") style=sasweb 
 gtitle nogfootnote;

goptions gunit=pct htitle=6.5pct ftitle="albany amt/bold" htext=3.5pct ftext="albany amt/bold";
goptions ctitle=gray66 ctext=gray66;

footnote c=blue h=.17in "Imitating graphs from 'American Demographics'  feb/2004  p.36";

axis1 c=white value=(c=gray66) 
 label=(c=black a=90 'Men 18-34 using television %')
 order=(.27 to .33 by .01)
 minor=none major=(c=purple height=-2 cells) 
 offset=(3,3);

axis2 c=white label=none value=(a=90 c=gray66)  
 major=(c=purple height=-.5 cells) offset=(4,4);

title1 link="boys_info.htm" 
 color=black move=(+2,+0) "Where the Boys Aren't";

title2 j=l move=(7,+0) "There has been a steady decrease in the percentage of 18-";  
title3 j=l move=(7,+0) "to 34-year-old males tuning in during prime-time.  Below";
title4 j=l move=(7,+0) "is the PUT (Persons Using Television %) during the Sep-";
title5 j=l move=(7,+0) "tember sweeps period for the past 12 years.";

/* A simple red join line, overlaid with a simple linear regression line */
symbol1 ci=red i=join w=6 cv=red v=dot h=2.5;
symbol2 ci=cxfed98e i=r w=6 v=none;

proc gplot data=my_data anno=anno_box; 
plot television*year=2 television*year=1 / overlay
 vaxis=axis1 haxis=axis2
 des='' name="&name";  
run;

quit;
ODS HTML CLOSE;
ODS LISTING;

*-----------------------------------------左右的条形图----------------------------*;
%let name=media;
filename odsout '.';

data my_data;
format percentage percentn7.0;
input media $ 1-26 percentage;
datalines;
Total Broadcast Television -.15
Total Cable & Satellite TV .47
Total TV                   .10
Radio*                     .06
Box Office                 .17
Home Video*                .18
Recorded Music*            -.24
Video Games*               .97
Consumer Internet          4.92
Daily Newspapers*          -.05
Consumer Books*            -.06
Consumer Magazines*        -.08
Total Media**              .09
;
run;

data a_anno; set my_data;
length function color  $8 text $30;
xsys='2'; ysys='2'; hsys='3'; when='a';
function='label'; color='brown';
text=trim(left(put(percentage,percentn7.0)));
midpoint=media; 
if (percentage gt .50) then x=.50;
else x=percentage; 
if (percentage lt 0) then position='6';
else position='4';
output;
/* If % > 50, add a triangle/pointer to the end of the bar */
if (percentage gt .50) then do;
 style='marker'; size=3.5; text='B'; position='6';
 output;
 end;
run;


goptions device=png;
goptions hsize=8in vsize=5.25in;
goptions cback=cxffffb2;
goptions border; 
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" 
 (title="SAS/Graph Imitation of American Demographics") 
 style=htmlblue;

goptions gunit=pct htitle=4.5 htext=2.7 ftext="albany amt/bold" ftitle="albany amt/bold";

pattern1 v=s color=orange;   

axis1 order=(-.50 to .50 by .20) label=('% Change (1997-2002)') minor=none major=(height=-.5 cells);

axis2 c=cxffffb2 value=(c=black);

title1 j=l move=(+2,+0) ls=1.5 "MY MEDIA";
title2 j=l move=(+2,+0) c=gray55 "Consumers are spending more time on the Internet and playing video games and less with";
title3 j=l move=(+2,+0) c=gray55 "traditional media such as television and magazines.";
title4 " ";
title5 j=l move=(+6,+0) c=brown "PERCENT CHANGE IN HOURS PER PERSON PER YEAR USING CONSUMER MEDIA (1997-2002)";
title6 a=-90 h=5pct " "; /* add space on right side - this doesn't seem to work */
title7 a=90  h=3pct " ";  /* add space on left side */

footnote c=gray font="albany amt" ls=1.1
  "Imitating graphs from 'American Demographics'  feb/2004  p.41"; 

proc gchart data=my_data anno=a_anno; 
hbar media / discrete type=sum sumvar=percentage 
 /* This is one way to control the order of the bars */
 midpoints=
  'Total Broadcast Television'
  'Total Cable & Satellite TV'
  'Total TV'                
  'Radio*'                 
  'Box Office'            
  'Home Video*'          
  'Recorded Music*'     
  'Video Games*'       
  'Consumer Internet' 
  'Daily Newspapers*'
  'Consumer Books*' 
  'Consumer Magazines*'  
  'Total Media**'        
 raxis=axis1 maxis=axis2 ref=0
 autoref cref=grayee clipref
 nostats noframe 
 des='' name="&name";  
run;

quit;
ODS HTML CLOSE;
ODS LISTING;

*---------------------------------------对比的条形图------------------------------------------*;
%let name=higher;
filename odsout '.';

/* 
For strings that the order is important, but that you
don't want them in alphabetical order, you have to assign
numeric values in the desired order and then use a 
user-defined format to have the desired text message
print for each number. 
*/
proc format;
   value import_fmt
   1='Very Much'
   2='Not At All'
   ;
run;

proc format;
   value age_fmt
   1='18-24'
   2='25-34'
   3='35-54'
   4='55-69'
   5='70+'
   ;
run;


data my_data;
format agegroup age_fmt.;
format importance import_fmt.;
format percentage percent5.0;
input importance agegroup percentage;
datalines;
1 1 .17
1 2 .21
1 3 .26
1 4 .25
1 5 .21
2 1 .40
2 2 .40
2 3 .39
2 4 .47
2 5 .48
;
run;

data a_anno; set my_data;
length function color  $8 text $30;
xsys='2'; ysys='2'; when='a'; 
group=agegroup; 
midpoint=importance; 
x=percentage; 
function='label'; color='cxf2f2df'; position='4';
text=trim(left(put(percentage,percent5.0)));
run;


goptions device=png;
goptions hsize=5in vsize=6in;
goptions cback=grayfe;
goptions border; 
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" 
 (title="SAS/Graph Imitation of American Demographics")
 style=htmlblue gtitle nogfootnote;

goptions ftitle="albany amt/bold" ftext="albany amt/bold";
goptions gunit=pct htitle=3.6 htext=2.6;

footnote c=blue h=.15in "Imitating graphs from 'American Demographics'  feb/2004  p.19"; 

pattern1 v=s color=brown;   
pattern2 v=s color=cxd95f0e;   

axis1 label=none value=none;

axis2 label=none order=(0 to .5 by .1) value=(c=gray55)
 major=(height=-.5 cells) minor=none offset=(0,0);

axis3 label=none value=(c=gray55);

legend1 label=none across=1 position=(top right) mode=share shape=bar(.15in,.15in) value=(j=l) offset=(0,1);

title1 ls=1.5 c=gray55 "How Much do Your " c=black "Religious Beliefs";
title2 h=3.6 c=gray55 "Determine Your " c=black "Political Choices" c=gray55 "?";
title3 " ";
title4 a=90 h=3 "Age of Respondents";
title5 a=90 h=3 " ";

proc gchart data=my_data anno=a_anno; 
hbar importance / discrete type=sum sumvar=percentage legend=legend1
 group=agegroup subgroup=importance 
 maxis=axis1 raxis=axis2 gaxis=axis3
 nostats noframe space=0 coutline=gray77
 des='' name="&name";  
run;

quit;
ODS HTML CLOSE;
ODS LISTING;


*-------------------------------------大小排序后的条形图---------------------------------*；
%let name=hosts;
filename odsout '.';

data my_data;
input host $ 1-30 audience;
datalines;
Rush Limbaugh                  14.50
Sean Hannity                   11.80
Dr. Laura Schlessinger          8.51
Howard Stern                    8.50
Michael Savage                  7.00
Jim Bohannon                    4.04
Dr. Joy Brown                   4.03
Don Imus                        4.02
George Noory                    4.01
;
run;

data a_anno; set my_data;
length function color  $8 text $30;
xsys='2'; ysys='2'; hsys='3'; when='a'; 
midpoint=host; y=audience; 
function='label'; color='gray77'; size=2.2; position='E';
text=trim(left(put(audience,comma5.1)));
run;


goptions device=png;
goptions hsize=5.5in vsize=6.5in;
goptions cback=cxffffb2;
goptions border;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" 
 (title="SAS/Graph Imitation of American Demographics")
 style=htmlblue gtitle nogfootnote;

goptions gunit=pct htitle=3.5 ftitle="albany amt/bold" htext=2.8 ftext="albany amt/bold";
goptions ctext=black;

footnote c=blue h=.16in "Imitating graphs from 'American Demographics'  feb/2004  p.21";

pattern1 v=s color=cxfecc5c;   

axis1 c=black label=(angle=90 j=c 'Average Minimum' j=c 'Weekly Audience (Mil.)') 
 order=(0 to 15 by 3) minor=none major=(height=-2 cells) offset=(0,0);
axis2 c=black label=none value=(a=90) offset=(6,6);

title1 ls=1.5 "Top Five Radio Talk Shows";
title2 ls=1.0 h=3.5 "by Audience Size";

title3 a=90 h=1 ' ';
title4 a=-90 h=2 ' ';

proc gchart data=my_data; 
vbar host / discrete type=sum sumvar=audience descending
 coutline=graycc noframe
 raxis=axis1 maxis=axis2
 anno=a_anno
 des='' name="&name";  
run;

quit;
ODS HTML CLOSE;
ODS LISTING;


*----------------------------------------在很多的折线图中进行了突出---------------------------*;
%let name=men;
filename odsout '.';

data my_data;
input age population;
datalines;
0 1.60
1 1.80
2 2.1
3 2.0
4 2.0
5 1.9
6 1.9
7 1.95
8 1.9
9 2.0 
10 2.05
11 2.05
12 2.15
13 2.1
14 2.0
15 2.0
16 2.1
17 2.1
18 1.9
19 1.75
20 2.05
21 1.9
22 1.95
23 1.8
24 1.9
25 1.8
26 1.9
27 1.85
28 1.8
29 1.85
30 1.9
31 1.98
32 2.1
33 2.07
34 1.95
35 2.0
36 1.95
37 2.0 
38 2.1
39 2.1
40 2.3
41 2.1
42 2.2
43 2.15
44 2.2 
45 2.15
46 2.1 
47 2.05
48 1.95
49 1.95
50 2.0 
51 1.75
52 1.8
53 1.76
54 1.6 
55 1.7
56 1.65
57 1.3
58 1.32
59 1.28
60 1.32
61 1.1
62 1.17
63 1.1
64 1.05
65 1.0
;
run;

data my_data; set my_data;
target1='n'; target2='n';
if age ge 18 and age le 34 then target1='y';
if age ge 8 and age le 24 then target2='y';
run;


/* Annotate some labels */
data a_anno2003;
length function color $8 text $30;
xsys='2'; ysys='2'; when='a';
function='label'; size=2.2; color='black'; position='E';
x=0; y=0; text=trim(left(x)); output;
x=18; y=0; text=trim(left(x)); output;
x=34; y=0; text=trim(left(x)); output;
x=65; y=0; text=trim(left(x)); output;
x=18+((34-18)/2); y=2.5; color='red'; text='2003'; output;
run;

data a_anno2004;
length function color  $8 text $30;
xsys='2'; ysys='2'; when='a';
function='label'; size=2.2; color='black'; position='E';
x=0; y=0; text=trim(left(x)); output;
x=8; y=0; text=trim(left(x)); output;
x=24; y=0; text=trim(left(x)); output;
x=65; y=0; text=trim(left(x)); output;
x=8+((24-8)/2); y=2.5; color='blue'; text='2013'; output;
run;

/*
Some shared code to create the 'anno_box' data set, which annotates
the axis frame, with rounded corners.
*/
%let cornersize=5;
%include 'anno_box.sas';



goptions device=png;
goptions hsize=6in vsize=3.75in;
goptions cback=grayfe;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" 
 (title="SAS/Graph Imitation of American Demographics") 
 style=sasweb;

goptions gunit=pct htitle=6.5pct ftitle="albany amt/bold" htext=4.5pct ftext="albany amt/bold";

axis1 c=white value=(c=black) 
 minor=none major=(c=purple height=-2 cells) 
 offset=(0,3)
 label=(c=black a=90 'Male Population (in millions)')
 order=(0 to 2.5 by .5);

axis2 c=white label=none 
 order=(0 to 65 by 65)
 value=none major=none offset=(4,4);

title1 ls=1.5 "Growing Young Men";

footnote1 c=black "Age";
footnote2 " ";
footnote3 c=green h=.15in "SAS imitation/correction of graph from 'American Demographics'  feb/2004  p.37";

symbol1 c=cxfed98e i=needle w=4 v=none;
symbol2 c=red      i=needle w=4 v=none;

proc gplot data=my_data anno=anno_box; 
plot population*age=target1 / nolegend
 vaxis=axis1 haxis=axis2 cvref=purple 
 anno=a_anno2003
 des='' name="&name";  
run;

symbol1 c=vpapb i=needle w=3 v=none;
symbol2 c=blue  i=needle w=3 v=none;

proc gplot data=my_data anno=anno_box; 
plot population*age=target2 / nolegend
 vaxis=axis1 haxis=axis2 cvref=purple 
 anno=a_anno2004
 des='' name="&name";  
run;

quit;
ODS HTML CLOSE;
ODS LISTING;

*-----------------------------------------------------收入成分的条形图--------------------------------*;
%let name=money;
filename odsout '.';

/* For strings that the order is important, but that you
   don't want them in alphabetical order, you have to assign
   numeric values in the desired order and then use a 
   user-defined format to have the desired text message
   print for each number. */
proc format;
   value inc_fmt
   1='$40-$49k'
   2='$50-$59k'
   3='$60-$74k'
   4='$75-$99k'
   5='$100-$149k'
   ;
run;
proc format;
   value mag_fmt
   1='Black Enterprise'
   2='Ebony'
   3='Essence'
   4='Jet'
   5='The Source'
   6='Vibe'
   ;
run;


data my_data;
format magazine mag_fmt.;
format income inc_fmt.;
format percentage percent5.0;
input magazine income percentage;
length my_html $200;
my_html=
 'title='||quote(
  trim(left(put(magazine,mag_fmt.)))||' magazine'||'0d'x||
  'Income Level: '||trim(left(put(income,inc_fmt.)))||'0d'x||
  'Percent: '||trim(left(put(percentage,percent5.0))))||
 ' href="money_info.htm"';
datalines;
1 1 .140
1 2 .100
1 3 .120
1 4 .110
1 5 .090
2 1 .120
2 2 .090
2 3 .100
2 4 .080
2 5 .060
3 1 .130
3 2 .100
3 3 .110
3 4 .080
3 5 .050
4 1 .110
4 2 .100
4 3 .080
4 4 .070
4 5 .060
5 1 .110
5 2 .090
5 3 .140
5 4 .100
5 5 .070
6 1 .110
6 2 .090
6 3 .100
6 4 .095
6 5 .070
;
run;



goptions device=png;
goptions hsize=10in vsize=5.5in;
goptions cback=cxffffb2;
goptions border; 
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" 
 (title="SAS/Graph Imitation of American Demographics")
 style=htmlblue gtitle nogfootnote;

goptions gunit=pct htitle=4.0 htext=3 ftext="albany amt/bold" ftitle="albany amt/bold";
goptions ctext=black;

footnote c=blue h=.2in "Imitating graphs from 'American Demographics'  feb/2004  p.24"; 

pattern1 v=s color=cxfecc5c;   
pattern2 v=s color=cxfd8d3c;   
pattern3 v=s color=cxf03b20;   
pattern4 v=s color=cxbd0026;   
pattern5 v=s color=black;   

axis1 label=none value=none;

axis2 label=(a=90 j=c '% Household Income' j=c 'Demographic') 
 order=(0 to .15 by .03) value=(t=1 '0') major=(height=-.5 cells) minor=none offset=(0,0);

axis3 label=none offset=(3,3);

legend1 label=none across=1 position=(top right) mode=share offset=(-4,-2)
 shape=bar(.15in,.15in) value=(j=c c=gray55 h=2.75) order=descending;

title1 ls=1.5 "Percentage of Household Income Levels in the Average Audience of Selected Magazines";
title2 h=4pct a=-90 " ";

proc gchart data=my_data; 
vbar income / discrete type=sum sumvar=percentage 
 subgroup=income legend=legend1 group=magazine
 maxis=axis1 raxis=axis2 gaxis=axis3
 gspace=3 space=0 noframe 
 html=my_html
 des='' name="&name";  
run;

quit;
ODS HTML CLOSE;
ODS LISTING;

*-------------------------------------三个颜色不同的柱状图---------------------------------*;
%let name=morals;
filename odsout '.';

%let maincolor=black;

/* 
For strings that the order is important, but that you
don't want them in alphabetical order, you have to assign
numeric values in the desired order and then use a 
user-defined format to have the desired text message
print for each number. 
*/
proc format;
   value import_fmt
   1='Very Important'
   2='Somewhat Important'
   3='Not Important'
   ;
run;


data my_data;
format percentage percent5.0;
format importance import_fmt.;
input issue $ 1-20 importance percentage;
datalines;
Abortion            1 .51
School Vouchers     1 .43
Euthanasia          1 .33
Cloning             1 .39
Same-sex Marriage   1 .43
Abortion            2 .30
School Vouchers     2 .37
Euthanasia          2 .38
Cloning             2 .25
Same-sex Marriage   2 .23
Abortion            3 .17
School Vouchers     3 .14
Euthanasia          3 .20
Cloning             3 .33
Same-sex Marriage   3 .33
;
run;

/* Sort them, so I can use 'by' in the gchart */
proc sort data=my_data out=my_data; 
by issue; 
run;

data a_anno; set my_data;
length function color  $8 text $30;
xsys='2'; ysys='2'; when='a'; 
midpoint=importance; y=percentage; 
function='label'; position='e'; size=2; 
if importance eq 3 then color="&maincolor";
else color='cxf2f2df';
text=trim(left(put(percentage,percent5.0)));
run;


goptions device=png;
goptions hsize=5in vsize=4.5in;
goptions border;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" 
 (title="SAS/Graph Imitation of American Demographics") 
  nogfootnote style=htmlblue;

goptions gunit=pct htitle=5.5 ftitle="albany amt/bold" htext=4.25 ftext="albany amt/bold";

axis1 c=&maincolor label=('') value=none offset=(10,10);

axis2 c=&maincolor label=(a=90 c=&maincolor '% of Respondents') 
 order=(0 to .6 by .2) value=(c=&maincolor t=1 '0 ')
 major=(height=-2 cells) minor=none offset=(0,0);

legend1 label=none position=(bottom) offset=(8,0) across=1 
 shape=bar(3,3) value=(c=&maincolor j=l h=3.75pct);

pattern1 v=s color=cxf03b20;   
pattern2 v=s color=cxfd8d3c;   
pattern3 v=s color=cxfecc5c;   

footnote c=green h=.15in "Imitating graphs from 'American Demographics'  feb/2004  p.18";

options nobyline;
title1 ls=3.0 h=6pct c=&maincolor move=(+17,+0) "#byval(issue)";

proc gchart data=my_data; 
by issue;
vbar importance / discrete type=sum sumvar=percentage 
 subgroup=importance 
 coutline=same width=17
 maxis=axis1 raxis=axis2 noframe 
 autoref cref=graydd clipref 
 anno=a_anno legend=legend1
 des='' name="&name";  
run;

quit;
ODS HTML CLOSE;
ODS LISTING;

*---------------------------------------有数据标签的条形图-------------------------------*;
%let name=news;
filename odsout '.';

data my_data;
format audience percent5.0;
input source $ 1-30 audience;
datalines;
Fox News\Channel               .14
Internet-only\Web sites        .11
Local Daily\Newspaper          .09
CNN                            .08
ABC-TV                         .07
CBS-TV                         .06
;
run;


goptions device=png;
goptions hsize=5in vsize=4.5in;
goptions cback=cxffffb2;
goptions border;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" 
 (title="SAS/Graph Imitation of American Demographics")
 style=htmlblue gtitle nogfootnote;

goptions gunit=pct htitle=4.5 ftitle="albany amt/bold" htext=3.1 ftext="albany amt";

axis1 label=(a=90 font="albany amt/bold" '% of Talk Radio Audience')
 order=(0 to .15 by .03) value=(t=1 '0')
 minor=none major=(height=-2 cells) offset=(0,0);

axis2 label=(h=1 ' ') value=(a=90) split='\' offset=(9,7);

title1 ls=1.5 "Top 5 Non-Radio News";
title2 h=4.5 f="albany amt/bold" "Sources Among Talk Radio";
title3 h=4.5 f="albany amt/bold" "Listening Audience";

title4 h=3 a=90 " ";
title5 h=3 a=-90 " ";

footnote c=blue h=.14in "Imitating graphs from 'American Demographics'  feb/2004  p.22";

pattern1 v=s color=cxfecc5c;

proc gchart data=my_data; 
vbar source / discrete type=sum sumvar=audience 
 descending coutline=same noframe
 raxis=axis1 maxis=axis2 inside=sum
 des='' name="&name" ;  
run;

quit;
ODS HTML CLOSE;
ODS LISTING;

*----------------------------------------------有数据标签的条形图---------------------------------------*;
%let name=remote;
filename odsout '.';

data my_data;
input year households;
datalines;
2002 1.8
2004 5.8
2008 24.7
;
run;

/* Annotate the value labels on the bars, so you can have some
   inside, and some outside (if you took the automatic gchart 
   bar labeling, they would all be inside, or all be outside. */
data my_anno; set my_data;
length function color  $8 text $30;
xsys='2'; ysys='2'; hsys='2'; when='a';
function='label'; color='red'; position='2';
if year eq 2008 then position='E';
midpoint=year; y=households; 
text=trim(left(put(households,comma5.2)));
run;


/*
Some shared code to create the 'anno_box' data set, which annotates
the axis frame, with rounded corners.
*/
%let cornersize=5;
%include 'anno_box.sas';


goptions device=png;
goptions hsize=4.5in vsize=4in;
goptions cback=grayfe;
goptions noborder;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" 
 (title="SAS/Graph Imitation of American Demographics")
 style=htmlblue gtitle nogfootnote;

goptions gunit=pct htitle=5 ftitle="albany amt/bold" htext=3.75 ftext="albany amt/bold";
goptions ctext=black;

pattern1 v=s color=pink;   

axis1 c=white value=(c=black) label=(c=black a=90 "U.S. Households (in millions)") 
 order=(0 to 25 by 5) minor=none major=(c=purple height=-2 cells) offset=(0,3);

axis2 c=white label=none value=(c=black) offset=(17,17);

title1 j=l move=(+5,+0) ls=1.5 "Remote Control";
title2 j=l move=(+5,+0) c=gray55 "Few U.S. households have personal video";
title3 j=l move=(+5,+0) c=gray55 "recorders, such as TiVo and Replay TV, but";
title4 j=l move=(+5,+0) c=gray55 "that will change quickly.";
title5 h=2 " ";
title6 j=l move=(+5,+0) c=purple "U.S. HOMES WITH PVR";
title7 h=2 " ";

footnote c=blue h=.15in "Imitating graphs from 'American Demographics'  feb/2004  p.33";

proc gchart data=my_data anno=my_anno; 
vbar year / discrete type=sum sumvar=households 
 coutline=same anno=anno_box noframe
 width=30 space=10
 raxis=axis1 maxis=axis2
 des='' name="&name";  
run;

quit;
ODS HTML CLOSE;
ODS LISTING;

*-----------------------------------------------水平的有数据标签的条形图-----------------------------*;
%let name=non_tv;
filename odsout '.';

data my_data;
format mediapct percent5.0;
input media $ 1-17 mediapct;
datalines;
Magazines         .66
Loyalty Programs  .54
Email Marketing   .52
Web Ads           .47
Outdoor Ads       .41
Direct Mail       .38
Event Marketing   .37
Point-of-Sale     .36
Newspaper         .19
;
run;

/*
Annotate the values inside the hbars
(since you can't use the inside= option for hbars)
*/
data my_anno; set my_data;
length function color  $8 text $30;
xsys='2'; ysys='2'; hsys='3'; when='a';
function='label'; color='red'; position='4';
midpoint=media; x=mediapct; 
text=trim(left(put(mediapct,percent5.0)));
run;

/*
Some shared code to create the 'anno_box' data set, which annotates
the axis frame, with rounded corners.
*/
%let cornersize=5;
%include 'anno_box.sas';


goptions device=png;
goptions hsize=5.5in vsize=7in;
goptions cback=grayfe;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" 
 (title="SAS/Graph Imitation of American Demographics")
 style=htmlblue gtitle nogfootnote;

goptions gunit=pct htitle=4 ftitle="albany amt/bold" htext=2.5 ftext="albany amt/bold";

pattern1 v=s color=pink;   

axis1 c=white value=(c=black) label=none
 order=(0 to .7 by .1) value=(c=gray44 t=1 '0')
 minor=none major=(c=purple height=-.75 cells) 
 offset=(0,3);

axis2 c=white label=none value=(j=r c=black) offset=(6.5,6.5);

title1 ls=1.5 move=(+20,+0) "Other Media";

footnote c=blue h=.15in "Imitating graphs from 'American Demographics'  feb/2004  p.33";

proc gchart data=my_data anno=my_anno; 
hbar media / discrete type=sum sumvar=mediapct descending
 raxis=axis1 maxis=axis2
 anno=anno_box coutline=same 
 nostats noframe
 des='' name="&name";  
run;

quit;
ODS HTML CLOSE;
ODS LISTING;


*-----------------------------中间有一个突出的条形图-----------------------------*;
%let name=power;
filename odsout '.';

data my_data;
format income dollar10.0;
input country $ 1-30 income;
barcolor=1;
if country='African\Americans' then barcolor=2;
datalines;
Japan                          4519
Germany                        2063
United\Kingdom                 1459
Canada                          649
African\Americans               543
India                           454
Switzerland                     273
Sweden                          240
;
run;


goptions device=png;
goptions hsize=8in vsize=5in;
goptions cback=cxffffb2;
goptions border;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" 
 (title="SAS/Graph Imitation of American Demographics")
 style=htmlblue gtitle nogfootnote;

pattern1 v=s color=cxfecc5c;   
pattern2 v=s color=cxbd0026;   

goptions gunit=pct htitle=4.5 ftitle="albany amt/bold" htext=3.25 ftext="albany amt/bold";

axis1 label=none order=(0 to 5000 by 1000) value=(t=1 '0')
  minor=none major=(height=-1 cells) offset=(0,0);

axis2 label=none value=(a=90) split='\' offset=(6,6);

title1 ls=1.5 "2000 Gross National Income (in billions)";
title2 a=-90 h=2 ' ';

footnote c=blue h=.2in "Imitating graphs from 'American Demographics'  feb/2004  p.24";

proc gchart data=my_data; 
vbar country / discrete type=sum sumvar=income descending 
 subgroup=barcolor nolegend
 coutline=same outside=sum noframe 
 raxis=axis1 maxis=axis2 
 des='' name="&name";  
run;

quit;
ODS HTML CLOSE;
ODS LISTING;

*---------------------------------------条形图和折线图---------------------------*;
%let name=whammy;
filename odsout '.';

data my_data;
label mut='Men 18-34 Using Television (in millions)';
label nom='Number of Men 18-34 (in millions)';
input year mut nom;
datalines;
2003 9.4 32.6
2004 9.4 32.7
2005 9.3 32.8
2006 9.2 32.7
2007 9.1 32.7
2008 9.1 32.9
2009 9.1 33.2
2010 9.0 33.4
2011 9.0 33.6
2012 9.0 33.8
2013 8.9 33.9
;
run;

/* Annotate some labels for certain data values */
data a_anno1; set my_data;
length function color  $8 text $30;
xsys='2'; ysys='2'; hsys='3'; when='a';
function='label'; position='E'; color='red';
x=year; y=nom; text=trim(left(nom));
run;

data a_anno2; set my_data;
length function color  $8 text $30;
xsys='2'; ysys='2'; hsys='3'; when='a';
function='label'; position='2'; color='blue';
x=year; y=mut; text=trim(left(mut));
if (year eq 2003) or (year eq 2013) then output;
run;


/*
Some shared code to create the 'anno_box' data set, which annotates
the axis frame, with rounded corners.
*/
%let cornersize=5;
%include 'anno_box.sas';


goptions device=png;
goptions hsize=7in vsize=6in;
goptions cback=grayfe;
goptions noborder;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" 
 (title="SAS/Graph Imitation of American Demographics")
 style=htmlblue gtitle nogfootnote;

goptions ctext=black;
goptions gunit=pct htitle=5.75 ftitle="albany amt/bold" htext=2.5 ftext="albany amt/bold";

footnote c=blue h=.15in "Imitating graphs from 'American Demographics'  feb/2004  p.37";

axis1 c=white minor=none major=(c=purple height=-2 cells) 
 offset=(0,3) label=(c=black a=-90)
 order=(8 to 10 by 1) value=(c=black);

axis2 c=white label=none value=(c=black)  
 order=(2003 to 2013 by 1)
 major=(c=purple height=-.5 cells) offset=(4,4);

axis3 c=white minor=none major=(c=purple height=-2 cells) 
 offset=(0,3) label=(c=black a=90)
 order=(32 to 34 by 1) value=(c=black);

title1 ls=1.5 "The Double Whammy";
title2 " ";
title3 j=l move=(+10,+0) c=gray55 "As the size of the male 18 to 34 demographic grows in the next 10 years,";
title4 j=l move=(+10,+0) c=gray55 "the number of them watching television will decrease, and the share of";
title5 j=l move=(+10,+0) c=gray55 "non-users will grow bigger and bigger.";

symbol1 ci=blue i=join w=6 v='25cf'x font="albany amt/unicode" h=4.5;
symbol2 ci=cxfed98e i=needle w=30 v=none;

proc gplot data=my_data anno=anno_box; 
plot nom*year=2  / 
 haxis=axis2 vaxis=axis3 anno=a_anno1
 des='' name="&name";  
plot2 mut*year=1 / 
 vaxis=axis1 anno=a_anno2;  
run;

quit;
ODS HTML CLOSE;
ODS LISTING;

*------------------------------一个饼形图----------------------------*;
%let name=radio;
filename odsout '.';

/*
Since I want to control the order of the pie slices, so they're
exactly like the order used in the magazine, I'm using sequential
numbers for the political parties, and then using a user-defined
format to make these numbers show up as the desired text in
the pie chart.
*/
proc format;
   value prtyfmt
   1='Republican'
   2='Other'
   3='Independent'
   4='Libertarian'
   5='Democrat'
   ;
run;

data my_data;
format party prtyfmt.;
format percentage percent5.0;
input party percentage;
datalines;
1 .25
2 .04
3 .53
4 .06
5 .12
;
run;


goptions device=png;
goptions cback=cxffffb2;
goptions border;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" 
 (title="SAS/Graph Imitation of American Demographics")
 style=htmlblue gtitle nogfootnote;

goptions gunit=pct ftitle="albany amt/bold" htitle=5 htext=3.5 ftext="albany amt/bold";

pattern1 v=psolid color=cxbd0026;   
pattern2 v=psolid color=white;   
pattern3 v=psolid color=cxfecc5c;   
pattern4 v=psolid color=cxfd8d3c;   
pattern5 v=psolid color=cxf03b20;   

title1 c=black ls=2.5 "Break down of Talk Radio Listeners";
title2 c=black h=5 "By Political Party";

footnote c=blue h=.2in "Imitating graphs from 'American Demographics'  feb/2004  p.21";

proc gchart data=my_data; 
pie3d party / discrete type=sum sumvar=percentage
 noheading value=inside slice=outside coutline=same
 des='' name="&name";  
run;

goptions ctext=gray44;
proc gchart data=my_data; 
pie party / discrete type=sum sumvar=percentage
 noheading value=inside slice=outside coutline=grayaa
 des='' name="&name";  
run;

quit;
ODS HTML CLOSE;
ODS LISTING;

*-----------------------------------------颜色较多的饼图----------------------------*;
%let name=tivo;
filename odsout '.';

/*
Since I want to control the order of the pie slices, so they're
exactly like the order used in the magazine, I'm using sequential
numbers for the political parties, and then using a user-defined
format to make these numbers show up as the desired text in
the pie chart.
*/
proc format;
   value intrfmt
   1='Somewhat Interested'
   2='Very Interested'
   3='Not Interested'
   4='Ambivalent'
   5='Not at All Interested'
   ;
run;

data my_data;
format Interest intrfmt.;
format Percentage percent5.0;
input Interest Percentage;
datalines;
1 .12
2 .12
3 .14
4 .20
5 .42
;
run;


/* If I use a real 'title' it scrunches the pie chart down smaller.
   I need this 3d pie to be as big as possible to fit in the labels,
   therefore I'm going to annotate the titles so they can overlap
   with the pie's white-space. */
data my_anno;
length function style color $8 text $250;
xsys='3'; ysys='3'; hsys='3'; when='a';
position='6';
function='label'; 
x=3; 
style=''; color=''; size=6;
y=93; text='We Want Our TiVo!'; output;
style='albany amt'; color='gray55';
size=3;
y=y-3;
y=y-4; text='TV viewers may not know they want digital video recorders -- yet.  But as satellite TV and cable'; output;
y=y-4; text='TV companies make them available to their customers and as consumer electronic makers'; output;
y=y-4; text='include them in TV sets, they may wonder how they ever lived without them.'; output;
color='blue';
y=y-8; text='INTEREST IN DVRs'; output;
x=50; y=5; color='blue'; position='5';
text="Imitating graphs from 'American Demographics'  feb/2004  p.30"; output;
run;


goptions device=png;
goptions border;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" 
 (title="SAS/Graph Imitation of American Demographics - We Want Our Tivo")
 options(pagebreak='no') style=htmlblue;

pattern1 v=psolid color=cxfcae91;   
pattern2 v=psolid color=cxde2d26;   
pattern3 v=psolid color=cx74a9cf;   
pattern4 v=psolid color=cx2b8cbe;   
pattern5 v=psolid color=cx045a8d;   

goptions gunit=pct htitle=4.25 ftitle="albany amt/bold" htext=2.25 ftext="albany amt/bold";
goptions ctext=black;

title1 h=.5pct " ";

proc gchart data=my_data anno=my_anno; 
pie3d interest / discrete type=sum sumvar=percentage
 angle=90 explode=5
 value=inside slice=inside
 noheading coutline=same
 des='' name="&name";  
run;

title1 h=15pct " ";
proc gchart data=my_data anno=my_anno; 
pie interest / discrete type=sum sumvar=percentage
 angle=90 explode=5
 value=inside slice=inside
 noheading coutline=same
 des='' name="&name";  
run;

title;
footnote;
proc print data=a noobs; 
run;

quit;
ODS HTML CLOSE;
ODS LISTING;

