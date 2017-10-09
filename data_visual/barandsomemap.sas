*-----------------------Korean MBCS Chars  -----------------------------*;
%let name=korea;
filename odsout '.';

data my_data;
input year population;
datalines;
1961 25.8
1970 32.2 
1980 38.1 
1990 42.9 
2000 47.0 
2002 47.6
;
run;

data my_data; set my_data;
length myhtml $ 100;
myhtml=
 'title='||quote(trim(left(population)))||
 ' href='||quote('korea_info.htm');
run;


goptions device=png;
goptions cback=grayee;
goptions border;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" 
 (title="SAS Example with Korean text") 
 style=htmlblue;

goptions ftitle="albany amt" htitle=5.25pct ftext="albany amt/bold" htext=2.7pct;

/*
This example uses Korean characters from the Kgothb1 SAS/Graph software font 
*/

title1 
  justify=left move=(+6,+0) ls=1.5 font=Kgothb1 'bfacbed3c3dfb0e8c0ceb1b8'x 
  justify=right ls=1.5 font="albany amt" "Estimates of Midyear Population         ";

title2 h=3pct ' ';

footnote ' ';

axis1 order=(0 to 60 by 10) minor=none offset=(0,0) 
 label=(j=r 'million persons' j=r f=Kgothb1 h=4pct 'b9e9b8b8b8ed'x);

axis2 label=none offset=(12,8);

pattern1 v=s c=cx00ff00;

proc gchart data=my_data; 
vbar3d year / discrete sumvar=population outside=sum
 raxis=axis1 maxis=axis2
 autoref cref=gray lref=2
 shape=cylinder cframe=white
 iframe='korea_flag.GIF' imagestyle=fit
 space=4 width=8 html=myhtml
 des='' name="&name"; 
run;

/*
Flag borrowed from http://fr.wikipedia.org/wiki/Utilisateur:Looxix/test0
and then color was lightened.
footnote2 link="http://www.nso.go.kr/newcms/images/graph/major/1.gif" 
  "Based on this graph from Korea National Statistical Office [click here]";
footnote3 link="http://www.nso.go.kr/eng/searchable/graph.shtml" "From this website [click here]";
*/

quit;
ODS HTML CLOSE;
ODS LISTING;

*---------------------------------------人口金字塔图-----------------------------*;
%let name=hebrew;
filename odsout '.';

/*
Using these options since I converted this from an older example
*/
options validvarname=v6 validvarname=upcase; 
goptions fontres=presentation;

data popdata; 
length age_grp $3 sex $10;
input totPOP arabPOP    AGE_GRP     SEX;
datalines;
 -10    -1     G01      Male  
 -20    -2     G02      Male  
 -40    -3     G03      Male  
 -60    -3     G04      Male  
 -71    -4     G05      Male  
 -90    -5     G06      Male  
 -95    -12    G07      Male  
-130    -16    G08      Male  
-171    -18    G09      Male  
-180    -22    G10      Male 
-188    -32    G11      Male  
-196    -40    G12      Male  
-231    -48    G13      Male  
-270    -56    G14      Male  
-275    -57    G15      Male  
-290    -61    G16      Male 
-297    -75    G17      Male  
-319    -89    G18      Male  
-350    -102   G19      Male  
  16     1     G01      Female
  27     2     G02      Female
  51     3     G03      Female
  85     5     G04      Female
  93     7     G05      Female
 103     9     G06      Female
 104     10    G07      Female
 141     15    G08      Female
 187     18    G09      Female
 192     22    G10      Female
 194     30    G11      Female
 200     39    G12      Female
 231     45    G13      Female
 266     52    G14      Female
 266     53    G15      Female
 275     59    G16      Female
 282     72    G17      Female
 302     85    G18      Female
 332     99    G19      Female
;
run;

data popdata; set popdata;
pop=arabpop; grouping=trim(left(sex))||'_arab'; output;
pop=totpop-arabpop; grouping=trim(left(sex))||'_jews'; output;
run;

data anno;
length function style color $8;
xsys='2'; ysys='2'; when='b'; style='solid';

function='move'; x=0; y=0; output;
function='bar'; x=350;  y=100;  color='cxf4e4e4'; output;

function='move'; x=0; y=0; output;
function='bar'; x=-350;  y=100;  color='cxd4ecfc'; output;

run;

 
proc format; picture posval low-high='000,009'; run; 

data popdata; set popdata;
age_range='     ';
if age_grp eq 'G19' then age_range='0-4';
if age_grp eq 'G18' then age_range='5-9';
if age_grp eq 'G17' then age_range='10-14';
if age_grp eq 'G16' then age_range='15-19';
if age_grp eq 'G15' then age_range='20-24';
if age_grp eq 'G14' then age_range='25-29';
if age_grp eq 'G13' then age_range='30-34';
if age_grp eq 'G12' then age_range='35-39';
if age_grp eq 'G11' then age_range='40-44';
if age_grp eq 'G00' then age_range='45-49';
if age_grp eq 'G09' then age_range='50-54';
if age_grp eq 'G08' then age_range='55-59';
if age_grp eq 'G07' then age_range='60-64';
if age_grp eq 'G06' then age_range='65-69';
if age_grp eq 'G05' then age_range='70-74';
if age_grp eq 'G04' then age_range='75-79';
if age_grp eq 'G03' then age_range='80-84';
if age_grp eq 'G02' then age_range='85-89';
if age_grp eq 'G01' then age_range='90+';
length myhtml $400;
myhtml=
 'title='||quote( 
  'Age Group: '||age_range||'0D'x||
  'Sex & Race: '||grouping||'0D'x||
  'Population for this age/sex/race: '||put(pop,posval.)||'0D'x||
  ' ------------------- '||'0D'x||
  ' Population for this age/sex: '||put(totpop,posval.)||'0D'x||
  ' Population for this age/sex (Jews & Other): '||put(totpop-arabpop,posval.)||'0D'x||
  ' Population for this age/sex (Arab Population): '||put(arabpop,posval.)||'0D'x)||
 ' href="hebrew_info.htm"';
run;


goptions device=png;
goptions noborder;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" 
 (title="SAS Hebrew graph example") 
 gtitle nogfootnote 
 style=htmlblue;

axis2 order=(-350 to 350 by 50) major=(c=cx989ea1) minor=none offset=(0,0)
 label=(f="albany amt/bold" "Thousands   " f=hebrew  'EDE9F4ECE0'x)
 value=( f="albany amt" h=2.5);

axis1 
 label=(h=3 f="albany amt/bold" j=c 'Age' f=hebrew j=c 'ECE9E2'x) 
 value=( f="albany amt" h=2.5 justify=center
' 90+ ' 
'85-89' 
'80-84' 
'75-79' 
'70-74' 
'65-69'  
'60-64' 
'55-59' 
'50-54' 
'45-49' 
'40-44' 
'35-39' 
'30-34' 
'25-29' 
'20-24'  
'15-19' 
'10-14' 
' 5-9 ' 
' 0-4 ') ; 

legend1 mode=protect position=(top left inside) across=1
  label=none offset=(2,-1) frame cframe=white shape=bar(2,2)
  value=(h=3
   'Arab population' 
   'Jews and others' 
   font=hebrew 
   'FAE9E1F8F620E4E9E9E8E5ECEBE5E0'x
   'EDE9F8E7E0E520EDE9E6E5E4E9'x
   );

pattern1 v=s c=cx64c48c; 
pattern2 v=s c=cx04acec;   
pattern3 v=s c=cx64c48c; 
pattern4 v=s c=cx04acec;   

goptions gunit=pct htitle=3 htext=3 ftext="albany amt/bold";

/* This example uses the hebrew SAS/Graph software font */

title1 ls=1.5 j=c font=hebrew 
  'ECE9E2E5'x
  '20EFE9EE'x
  '202CE4E9E9E8E5ECEBE5E0'x
  '20FAF6E5E1F7'x 
  '20E9F4EC'x 
  '202CE4E9E9E8E5ECEBE5E0'x
  '20202E31'x
  ;

title2 "1. Population, by Population Group, Sex and Age";
title3 h=2pct "31.12.2002";
title4 h=2pct " ";

title5 j=c font=hebrew 'E4E9E9E8E5ECEBE5E0E4'x 
                       '20ECEB'x;

title6 j=l "          Males    " 
       font=hebrew 'EDE9F8EBE6'x
       j=c font="albany amt/bold" "Total Population" 
       j=r "Females "  
       font=hebrew 'FAE5EBF7F020202020'x
       ;

footnote j=c "Using the new/changed v9.1 'hebrew' sas/graph software font";

proc gchart data=popdata; 
format pop posval.; 
label age_grp='00'x; 
hbar age_grp / discrete type=sum sumvar=pop nostats 
  subgroup=grouping legend=legend1
  maxis=axis1 raxis=axis2 
  autoref cref=graydd clipref
  space=0 frame 
  coutline=white 
  annotate=anno html=myhtml
  des='' name="&name"; 
run; 

quit;
ODS HTML CLOSE;
ODS LISTING;

*------------------------------------------------russian character-------------------------------*;
%let name=russian;
filename odsout '.';

/*
I use the new v9 nlnum15. format in conjunction with the
Russian_Russia LOCALE, to get numbers with spaces instead of
commas in the thousands places.
*/
options LOCALE=Russian_Russia;  

data my_data;
format y nlnum15.0;  
input x y color;
length my_html $200;
my_html=
 'title='||quote(
  'Y: '||trim(left(put(y,nlnum15.)))||'0D'x||
  'X: '||trim(left(x)))||
 ' href='||quote('russian_info.htm');
datalines;
-.022    400000 2
-.012  -6300000 1
-.006  -1450000 1
-.002   2200000 1
-.0045 -1000000 1
 .0010  1500000 1
 .0030  1100000 1
 .0025   960000 1
 .0035   950000 1
-.0045  -100000 1
-.0038   200000 1
-.0021   300000 1
-.0014  -600000 1
-.0020  -800000 1
-.0018  -300000 1
-.0024  -900000 1
-.0023  -400000 1
-.0008  -900000 1
 .0009   200000 1
 .0012  -100000 1
 .0021   300000 1
-.0005  -300000 1
-.0040        0 1
-.0030        0 1
-.0020        0 1
-.0010        0 1
 .0000        0 1
 .0010        0 1
 .0020        0 1
 .0025        0 1
 .0054  1300000 1
 .0065  6400000 1
;
run;


goptions device=png;
goptions border;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" 
 (title="SAS Russian graph example") 
 style=htmlblue;
 
symbol1 c=Aff000077 i=none v=dot h=3.0;  /* New v9.3 alpha-transparent color */
symbol2 c=blue i=none font=marker v=U h=1.3;

axis1 offset=(0,0) minor=none order=(-8000000 to 8000000 by 2000000)
 value=(tick=1 '' tick=9 '')
 label=(r=0 a=90 font=cyrillic h=1.5 "Pokupka - prodaha (rub.)");

axis2 offset=(0,0) minor=none order=(-.025 to .01 by .005)
 value=(tick=1 '' tick=8 '')
 label=(font=cyrillic h=1.5 "Funkcional (ed)");

goptions cback=cxF6C76B;
goptions htext=2.5pct ftext="albany amt";

title1 h=5pct f=cyrillic 'Raspredelenie Uuastnikov';
title2 h=5pct f=cyrillic 'Instrument: akcii ob. RAO ' 
     f=swiss '"' f=cyrillic 'E3S Rossii' f=swiss '"';

proc gplot data=my_data; 
plot y*x=color / nolegend
  autohref lhref=2 chref=gray
  autovref lvref=2 cvref=gray
  vaxis=axis1 haxis=axis2
  coutline=black cframe=cxABDDA8
  html=my_html
  des='' name="&name"; 
run;

quit;
ODS HTML CLOSE;
ODS LISTING;

*-----------------------------------------------a bar chart------------------------------*;
%let name=spanish;
filename odsout '.';

/* 
Imitation of bar chart on page 9 of the following doc:
http://usuarios.lycos.es/cursonavarra2/documentos/MODULO3/DIA1/DOCUMENTOS/Estadistica_Basica_ParteI.pdf
*/

/* I'm using the locale, to get the specail nlnumeric formatting for the response axis. */
options LOCALE=Spanish_Spain;

data my_data;
format accidents nlnum15.0;
label accidents='N鷐ero de AT';
input city $ 1-30 year accidents;
length my_haml $300;
my_haml=
 'title='||quote(
  'City: '||trim(left(city))||'0D'x||
  'Year: '||trim(left(year))||'0D'x||
  'Accidents: '||trim(left(put(accidents,nlnum15.0))))||
 ' href='||quote('spanish_info.htm');
datalines;
CATALU袮                       2000 182000
CATALU袮                       2001 142000
ANDALUCIA                      2000 139000
ANDALUCIA                      2001 110000
MADRID                         2000 120500
MADRID                         2001 99900 
COMUNIDAD VALENCIANA           2000 119200
COMUNIDAD VALENCIANA           2001 86500
PAIS VASCO                     2000 50000
PAIS VASCO                     2001 39800
;

/* Annotate the diagonal gray line behind the bar chart */
data anno;
length function color $8;
xsys='1'; ysys='1'; when='b';
color='gray';
function='move'; x=100; y=0; output;
function='draw'; x=0; y=100; output;
run;


goptions device=png;
goptions hsize=7in vsize=5in;
goptions cback=tan;
goptions border;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" 
 (title="SAS Spanish graph example") 
 style=htmlblue;
 
goptions gunit=pct ftitle="albany amt/bold" ftext="albany amt" htitle=4.5 htext=2.75;

/* 
I wrote this sas job on unix.  To get the special characters into 
the titles, I entered the Alt+numeric in an outlook email editor,
and then cut-n-pasted the special character into my unix vi editor
session in an xterm (via Hummingbird Exceed).  Here are the codes:
o with accent = Alt+162
a with accent = Alt+160
u with accent = Alt+163
n with tilde  = Alt+164
N with tilde  = Alt+165
*/

title1 f="albany amt/bold" h=3.5 ls=1.5 "Accidentes de Trabajo por Comunidad Aut髇oma, en las cinco que";
title2 f="albany amt/bold" h=3.5 "tienen frecuencia m醩 alta en n鷐ero absoluto.  Espa馻, a駉s 2000 y";
title3 f="albany amt/bold" h=3.5 "2001 (Enero-Septiembre).  Datos Fuente: INHST";

axis1 label=none value=none split='\';
axis2 minor=none order=(0 to 200000 by 20000) label=(a=90) offset=(0,0);
axis3 label=none value=(h=2.25 f="albany amt/bold") offset=(3,3) split=' '
  order=("CATALU袮" "ANDALUCIA" "MADRID" "COMUNIDAD VALENCIANA" "PAIS VASCO");

pattern1 v=solid c=CXffff9b;
pattern2 v=solid c=cyan;

/* Did a little customizing to add the (ENE-SEP) to the 2001 legend tickmark value */
legend1 mode=protect position=(top right inside) across=1
  label=none shape=bar(2,2) offset=(-5,-8)
  value=(j=l tick=2 '2001 (ENE-SEP)');

proc gchart data=my_data anno=anno; 
vbar year / discrete sumvar=accidents  
 group=city subgroup=year
 maxis=axis1 raxis=axis2 gaxis=axis3
 autoref cref=graydd clipref
 noframe space=0 gspace=9
 coutline=black legend=legend1
 html=my_haml
 des='' name="&name"; 
run;

quit;
ODS HTML CLOSE;
ODS LISTING;

*-------------------------------------有背景图片的bar chart-------------------------------*;
%let name=spanish;
filename odsout '.';

/* 
Imitation of bar chart on page 9 of the following doc:
http://usuarios.lycos.es/cursonavarra2/documentos/MODULO3/DIA1/DOCUMENTOS/Estadistica_Basica_ParteI.pdf
*/

/* I'm using the locale, to get the specail nlnumeric formatting for the response axis. */
options LOCALE=Spanish_Spain;

data my_data;
format accidents nlnum15.0;
label accidents='N鷐ero de AT';
input city $ 1-30 year accidents;
length my_haml $300;
my_haml=
 'title='||quote(
  'City: '||trim(left(city))||'0D'x||
  'Year: '||trim(left(year))||'0D'x||
  'Accidents: '||trim(left(put(accidents,nlnum15.0))))||
 ' href='||quote('spanish_info.htm');
datalines;
CATALU袮                       2000 182000
CATALU袮                       2001 142000
ANDALUCIA                      2000 139000
ANDALUCIA                      2001 110000
MADRID                         2000 120500
MADRID                         2001 99900 
COMUNIDAD VALENCIANA           2000 119200
COMUNIDAD VALENCIANA           2001 86500
PAIS VASCO                     2000 50000
PAIS VASCO                     2001 39800
;

/* Annotate the diagonal gray line behind the bar chart */
data anno;
length function color $8;
xsys='1'; ysys='1'; when='b';
color='gray';
function='move'; x=100; y=0; output;
function='draw'; x=0; y=100; output;
run;


goptions device=png;
goptions hsize=7in vsize=5in;
goptions cback=tan;
goptions border;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" 
 (title="SAS Spanish graph example") 
 style=htmlblue;
 
goptions gunit=pct ftitle="albany amt/bold" ftext="albany amt" htitle=4.5 htext=2.75;

/* 
I wrote this sas job on unix.  To get the special characters into 
the titles, I entered the Alt+numeric in an outlook email editor,
and then cut-n-pasted the special character into my unix vi editor
session in an xterm (via Hummingbird Exceed).  Here are the codes:
o with accent = Alt+162
a with accent = Alt+160
u with accent = Alt+163
n with tilde  = Alt+164
N with tilde  = Alt+165
*/

title1 f="albany amt/bold" h=3.5 ls=1.5 "Accidentes de Trabajo por Comunidad Aut髇oma, en las cinco que";
title2 f="albany amt/bold" h=3.5 "tienen frecuencia m醩 alta en n鷐ero absoluto.  Espa馻, a駉s 2000 y";
title3 f="albany amt/bold" h=3.5 "2001 (Enero-Septiembre).  Datos Fuente: INHST";

axis1 label=none value=none split='\';
axis2 minor=none order=(0 to 200000 by 20000) label=(a=90) offset=(0,0);
axis3 label=none value=(h=2.25 f="albany amt/bold") offset=(3,3) split=' '
  order=("CATALU袮" "ANDALUCIA" "MADRID" "COMUNIDAD VALENCIANA" "PAIS VASCO");

pattern1 v=solid c=CXffff9b;
pattern2 v=solid c=cyan;

/* Did a little customizing to add the (ENE-SEP) to the 2001 legend tickmark value */
legend1 mode=protect position=(top right inside) across=1
  label=none shape=bar(2,2) offset=(-5,-8)
  value=(j=l tick=2 '2001 (ENE-SEP)');

proc gchart data=my_data anno=anno; 
vbar year / discrete sumvar=accidents  
 group=city subgroup=year
 maxis=axis1 raxis=axis2 gaxis=axis3
 autoref cref=graydd clipref
 noframe space=0 gspace=9
 coutline=black legend=legend1
 html=my_haml
 des='' name="&name"; 
run;

quit;
ODS HTML CLOSE;
ODS LISTING;


*----------------------------------3D的BAR CHART---------------------*;
%let name=greek;
filename odsout '.';

/*
Based on graph from 
http://www.ase.gr/content/gr/marketdata/statistics/month/Monthly_Statistics.asp?month=9&year=2003#1
Saved in ./greekbar.jpg
*/

data my_data;
length market $10;
format number comma10.0;
input year number market;
datalines;
1997 40000 m1
1997 15000 m2
1997 15000 m3
1997 2000  m4
1998 70000 m1
1998 25000 m2
1998 25000 m3
1998 3000  m4
1999 80000 m1
1999 80000 m2
1999 80000 m3
1999 3000  m4
2000 80000 m1
2000 40000 m2
2000 40000 m3
2000 3000  m4
2001 80000 m1
2001 40000 m2
2001 30000 m3
2001 3000  m4
2002 90000 m1
2002 30000 m2
2002 30000 m3
2002 3000  m4
2003 130000 m1
2003 30000 m2
2003 30000 m3
2003 10000 m4
;
run;

data my_data; set my_data;
length myhtml $200;
myhtml=
 'title='||quote(
  'Year: '||trim(left(year))||'0D'x||
  'Market: '||trim(left(market))||'0D'x||
  'Number: '||trim(left(put(number,comma15.0))))||
 ' href='||quote('http://www.ase.gr/content/gr/marketdata/statistics/month/Monthly_Statistics.asp?month=9&year=2003#1');
run;


goptions device=png;
goptions hsize=9in vsize=3.5in;
goptions cback=grayf1;
goptions border;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" 
 (title="Greek SAS graph example") 
 style=htmlblue;

goptions gunit=pct htitle=6 htext=4 ftext="albany amt";

/* 
Maybe it would have been more flexible to create a 
user-defined format for these market names, rather
than hard-coding them here in the legend. 
(Be careful about using legend descending= option with hard-coded values! S0716784)
*/
legend1 position=(bottom right) across=1 label=none
 shape=bar(2,2)
 value=(
  tick=1 
  font=greek 'Nea Xrhmatisiakh Agora'
  font="albany amt" ' - New Market'
  tick=2
  font=greek 'Parallhlh Agora (Olh)'
  font="albany amt" ' - Parallel Market (All)'
  tick=3
  font=greek 'Metoxe> Kuria> Agora>'
  font="albany amt" ' - Main Market Shares'
  tick=4
  font=greek 'Daneia Kuria> Agora>'
  font="albany amt" ' - Main Market Bonds'
  )
 ;

pattern1 c=cx1d7b74;
pattern2 c=white;
pattern3 c=cxb5ffff;
pattern4 c=cx6cc5c0;

axis1 order=(0 to 280000 by 40000) label=none minor=none;
axis2 label=(j=r font=greek '(Sep ' font="albany amt" '- Sep.)') offset=(5,5);

title1 
 link="http://www.ase.gr/content/gr/marketdata/statistics/month/Monthly_Statistics.asp?month=9&year=2003#1"
 ls=1.5
 font=greek "Xrhmatisthriakh Acia (Ekat. Eurw)      " 
 font="albany amt" "Market Capitalization (Mil. Euro)";

proc gchart data=my_data; 
vbar3d year / type=sum sumvar=number discrete 
 subgroup=market legend=legend1
 cframe=cxc6fdff coutline=black
 raxis=axis1 maxis=axis2
 width=4 space=3
 html=myhtml
 des='' name="&name"; 
run;

quit;
ODS HTML CLOSE;
ODS LISTING;

*------------------------------------------一个生命什么图-----------------------------------*;
%let name=life;
Filename odsout '.';

/* 
I'm using numeric country & sex values so I can sort the
maxis the way I want.  I then use user-defined formats to
print the text value I want. 
*/

data my_data;
input country sex age;
datalines;
1 1 73
1 2 78
2 1 77 
2 2 84
3 1 75
3 2 80
4 1 74
4 2 80
5 1 76
5 2 80
6 1 71
6 2 78
7 1 64
7 2 70
;
run;

proc format;
   value countries
   1='Rep. of China'
   2='Japan'
   3='United Kingdom'
   4='United States'
   5='Singapore'
   6='South Korea'
   7='Philippines'
   ;
run;

proc format;
   value sexes
   1='Male'
   2='Female'
   ;
run;

data my_data; set my_data;
length myhtml $200;
myhtml=
 'title='||quote(
  'Country: '||trim(left(put(country,countries.)))||'0D'x||
  'Sex: '||trim(left(put(sex,sexes.)))||'0D'x||
  'Life Expectancy: '||trim(left(age)))||
 ' href='||quote('http://en.wikipedia.org/wiki/Life_expectancy');
run;

data my_anno; set my_data;
length function color $8 text $30;
xsys='2'; ysys='2'; when='a'; 
function='label'; position='5'; style='marker'; size=3;
if sex eq 1 then do;
 color='green';
 text='Q';
end;
else if sex eq 2 then do;
 color='orange';
 text='R';
end;
group=country; midpoint=sex; y=5; output;
run;


goptions device=png;
goptions hsize=8.5in vsize=5in;
goptions cback=cxCCCC99;
goptions border;

/* Maybe this will hypothetically make the stick-people look better */
goptions fontres=presentation;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" 
 (title="SAS graph - Life Expectancy comparison") 
 style=htmlblue;
 
goptions ftitle="albany amt/bold" ftext="albany amt" htitle=5 htext=3 gunit=pct;

title1 ls=1.5 "Figure 3-4 Life Expectancy of Selected Nations";
title2 font="albany amt/bold" h=4.5 "Year 2001";

/* Get rid of the midpoint axis, since that's redundant with the legend */
axis1 label=none value=none label=none;
axis2 minor=none order=(0 to 100 by 20) label=(f="albany amt/bold" 'Age') noplane;
axis3 label=none value=(h=2.25 f="albany amt/bold") label=none offset=(3,3) noplane;

pattern1 v=solid c=vlig;
pattern2 v=solid c=cornsilk;

legend1 mode=protect position=(top right inside) across=1
 label=none frame cframe=graydd shape=bar(2,2)
 value=(h=3 j=l f="albany amt" 'Male' 'Female')
 offset=(0,-5);

proc gchart data=my_data anno=my_anno; 
format country countries.;
format sex sexes.;
vbar3d sex / discrete type=sum sumvar=age  
 group=country subgroup=sex legend=legend1
 maxis=axis1 raxis=axis2 gaxis=axis3 noframe
 shape=cylinder coutline=gray99 outside=sum
 autoref cref=graydd clipref
 width=3 space=0 gspace=4.0
 html=myhtml
 des='' name="&name"; 
run;

quit;
ODS HTML CLOSE;
ODS LISTING;

*----------------------------------------------中国人口密度图--------------------------------------*;
%let name=china;
filename odsout '.';

%let nlsfont=fsong;

data my_data;
length value $1;
input id value;
datalines;
999 A
31 A
7  A
26 A
21 A
4  A
20 A
22 A
25 A
2  A
28 A
24 A
29 B
6  B
14 B
16 B
1  B
11 B
9  B
30 C
19 C
17 C
13 C
3  C
8  C
5  D
32 D
15 D
23 D
18 D
10 D
;
run;


/* I only used these charttips for debugging */
data my_data; set my_data;
length my_html $300;
my_html=
 'title='||quote('ID: '||trim(left(id)))||
 ' href='||quote('china_info.htm');
run;

/*
The China & Taiwan maps seem to change a lot from SAS version to version,
therefore I had to save a copy here (current directory) to use, so that
this map will always turn out the same.
*/

libname here '.';
/* Combine the unprojected coordinates from the CHINA */
/* and the TAIWAN map data sets. */
data china(rename=(long=x lat=y)); set here.china(drop=x y);
run;
data taiwan(rename=(long=x lat=y)); set here.taiwan(drop=x y);
 segment=id;
 id=999;
run;
data combine; set china taiwan;
run;
proc gproject data=combine out=chinataiwan;
  id id;
run;


goptions device=png;
goptions border;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" 
 (title="SAS/Graph Chinese example") 
 style=htmlblue;

pattern1 v=s c=cxff6666;
pattern2 v=s c=cxcccc00;
pattern3 v=s c=cxccff99;
pattern4 v=s c=cx00FF00;
 
goptions gunit=pct ftext="albany amt/bold" htext=2.5;

legend1 position=(bottom right) mode=share across=1 
 label=(position=top justify=center height=3.5pct font=&nlsfont 'CDBCC0FD'x) 
 shape=bar(.12in,.12in)
 value=(
 t=1 font=&nlsfont 'B4F3D3DA4040'x font="albany amt/bold" ' 2  (12)'
 t=2 '1.3-2  (8)'
 t=3 '0.7-1.3 (6)'
 t=4 '0.2-0.7 (6)'
 );

/* I'm using a 'note' instead of a title, so I can position it within the map area */
title1 h=.1pct " ";

proc gmap data=my_data map=chinataiwan; 
id id; 
note 
 link='china_info.htm'
 move=(22,90) height=5.5pct font=&nlsfont color=gray22
 'D6D0B9FAB7D6CAA1C7F8C8CBBFDAB3D0D4D8D7B4BFF6CDBC'x;
choro value / legend=legend1
 coutline=gray77
 html=my_html
 des='' name="&name"; 
run;

quit;
ODS HTML CLOSE;
ODS LISTING;


*------------------------------------------突然闪入的墨西哥地图----------------------*;
%let name=swine_flu;
filename odsout '.';

%let mult=2.5;

proc format;
  value legn_fmt
  1='Aseguran estar libres de contagios'
  2='Reportaron decesos en las 鷏timas 24 horas'
  3='Con brotes de influenza; algunos registran fallecimientos (*)'
  ;
run;

data fludata;
format colornum legn_fmt.;
input 
 num1 num2 colornum 
 /* x/y offsets for the 2 points of the line, and then the text label */
 x1 y1 x2 y2 x3 y3
 idname $ 32-80;
datalines;
 25   1  2   4  3  1  0  1  1  Baja California Norte
  0   0  1   .  .  .  .  .  .  Baja California Sur
  0   0  1   .  .  .  .  .  .  Sonora               
  0   0  1   .  .  .  .  .  .  Sinaloa              
 28   0  3   .  .  .  .  0  0  Chihuahua            
  0   0  1   .  .  .  .  .  .  Coahuila            
  7   1  2   0  5  0  0  0  3  Nuevo Leon
  3   1  2   0  4  1  0  1  1  Tamaulipas
 76  10  2   2  0  7  4  1  1  San Luis Potosi
  0   0  1   .  .  .  .  .  .  Zacatecas
  0   0  1   .  .  .  .  .  .  Durango
  0   0  1   .  .  .  .  .  .  Nayarit
 30   0  3   .  .  .  .  0  0  Jalisco
  0   0  1   .  .  .  .  .  .  Colima
  0   0  1   .  .  .  .  .  .  Michoacan
  0   0  1   .  .  .  .  .  .  Guerrero
  2   2  2  -7  0  .  . -1  1  Aguascalientes
  1   2  2  -4 -4 -3  0 -1  1  Guanajuato
  5   0  3  -5 -5  .  .  0  0  Queretaro
 24   0  3   0  0  3  0  1  1  Veracruz
 11   0  3   2  4  3  0  1  1  Hidalgo
 44   3  3  -5 -5  .  .  0  0  Mexico
 73  18  2   1 -1  2 -6  0  0  Distrito Federal
 35   0  3  1.5 3  3  0  1  1  Tlaxcala
  0   0  1   .  .  .  .  .  .  Puebla
 17   0  3  -2 -4  .  .  0  0  Morelos
  8   3  2   3 -3  0  0  0  0  Oaxaca
  0   0  1   .  .  .  .  .  .  Tabasco
  0   0  1   .  .  .  .  .  .  Chiapas
  0   0  1   .  .  .  .  .  .  Campeche
  0   0  1   .  .  .  .  .  .  Yucatan
  0   0  1   .  .  .  .  .  .  Quintana Roo
;
run;

/* Merge in the numeric id numbers, for the regions */
proc sql;
create table fludata as 
select fludata.*, mexico2.id
from fludata left join maps.mexico2
on fludata.idname eq mexico2.idname;
quit; run;

data fludata; set fludata;
length my_html $300;
my_html=
 'title='||quote(
  trim(left(idname))||'0d'x||
  'Influenza: '||trim(left(num1))||'0d'x||
  'Decesos: '||trim(left(num2)))||
 ' href='||quote('swine_flu_info.htm');
run;

data target_anno;
length function $8 style $35;
xsys='3'; ysys='3'; hsys='3'; when='b'; 
x=50; y=50; 
function='pie'; 
style='pempty';
color='grayed';
width=3;
rotate=360;
do size=4 to 49 by 3;
 output;
 end;
run;


/* Now, create a 'centers' dataset with the estimated centers. */
%annomac;
%centroid( maps.mexico, labels, id );
proc sql;
create table labels as select labels.*, fludata.*
from labels left join fludata
on labels.id=fludata.id;
quit; run;

data labels; set labels (where=(colornum^=1));
length function color $8 style $35;
xsys='2'; ysys='2'; hsys='3'; when='a';
function='move'; output;

if (x1 ^= .) then do;
 function='pie'; size=.15; rotate=360; style='psolid'; output;
 xsys='9'; ysys='9'; 
 function='draw'; x=x1*&mult; y=y1*&mult; output;
 function='draw'; x=x2*&mult; y=y2*&mult; output;
 end;

function="cntl2txt"; output;
function='label'; position='5'; size=.; style='';
xsys='9'; ysys='9'; x=x3*&mult; y=y3*&mult; 
text=trim(left(idname)); output;

function="cntl2txt"; output;
function='label'; position='5'; size=.; style='';
xsys='9'; ysys='9'; x=x3*&mult; y=(y3*&mult)-1*&mult;
text=trim(left(num1)); style="albany amt/bold"; output;

if num2 ^= 0 then do;
 function="cntl2txt"; output;
 function='label'; position='5'; size=.; style='';
 xsys='9'; ysys='9'; x=x3*&mult; y=(y3*&mult)-2*&mult;
 text='('||trim(left(num2))||'*)'; style=''; output;
 end;
run;

%let spacing=2.6;

data info;
length function $8 text $50 style $35;
xsys='3'; ysys='3'; hsys='3'; position='6'; when='a';

x=92; y=59.0; function='move'; output;
x=x+6; y=y+6; function='image'; imgpath='flu_phone.jpg'; style='fit'; output;

x=64; y=65; function='move'; output;
x=x+34; y=y+23; function='bar'; color='white'; style='solid'; line=0; output;
x=64; y=65; function='move'; output;
x=x+34; y=y+23; function='bar'; color='red'; style='empty'; line=0; output;
x=64; y=71.0; function='move'; output;
x=x+34; function='draw'; color='gray'; line=33; size=.1; output;

x=65; 
function='label'; style="albany amt/bold"; color=''; size=.;
y=86; text="Si pienso que tengo"; output;
y=y-&spacing; text="influenza, 縬u? debo hacer?"; output;
style='';
y=y-&spacing; text="Buscar atenci髇 m閐ica en"; output;
y=y-&spacing; text="forma inmediata. Para reporte"; output;
y=y-&spacing; text="de casos, comunicarse al"; output;
y=y-&spacing; text="tel閒ono"; output;
y=y-&spacing-.5; text="Locatel:"; output;
x=74.5; 
style="albany amt/bold";
y=72.8; text="01 800 123 10 10"; output;
x=73.5;
y=y-&spacing-.5; text="56 58 11 11"; output;
y=y-&spacing; text="55 33 55 33"; output;

run;

data labels; set labels info;
run;

/* 
Create an annotated 'shadow' to go behind the map.  It's ok to use the
already-projected map for this. 
*/
data anno_shadow; set maps.mexico; 
by id segment notsorted;
length COLOR FUNCTION $8;
xsys='2'; ysys='2'; when='B';
color='cxa3a7a6'; style='msolid';
if first.id or first.segment then function='poly';
else function='polycont';
run;

/* Give a little x & y offset, so it will look like a shadow */
data anno_shadow; set anno_shadow;
x=x-.0015; y=y-.0015;
run;


data anno_back; set target_anno anno_shadow;
run;



/* Define a template, to get the graphic above the map ... */
ods path work.template(update) sashelp.tmplmst;
proc template;
 define style styles.banner;
   parent = styles.minimal;

   /* Put the graphic above the title */
   style  Body from Document /
       prehtml         = "<table width=100%><td align=center><img src=""flu_banner.jpg""></table>"
   ;

 end;
run;



goptions device=png;
goptions xpixels=570 ypixels=570;
goptions noborder;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" 
 (title="Swine Flu in Mexico (SAS/Graph gmap)") 
 style=banner;

goptions gunit=pct htitle=5.00 ftitle="albany amt/bold" htext=2.2 ftext="albany amt";

legend1 label=none position=(bottom left) mode=share across=1 shape=bar(.15in,.15in) offset=(1,-12);

pattern1 v=s c=cxf5efdb;
pattern2 v=s c=cxf00016;
pattern3 v=s c=cxfe9200;

title1 j=l " SURGEN M罶 CASOS";
title2 j=l " Nuevo Le髇 declar? alerta, luego de que confirm? el caso de una mujer procedente";
title3 j=l " del Distrito Federal que muri? por influenza porcina.  En la capital se registraron";
title4 j=l " 5 decesos m醩.  Hay alerta en Veracruz y Baja California";
title5 h=2 ' ';

footnote1 h=10.2pct " ";

proc gmap map=maps.mexico data=fludata all anno=labels;
id id;
choro colornum / discrete legend=legend1
 coutline=cxa3a7a6 anno=anno_back
 html=my_html
 des='' name="&name";  
run;

quit;
ODS HTML CLOSE;
ODS LISTING;

*------------------------------------一个折线图--------------------*;
%let name=wheat;
filename odsout '.';

/*
Imitation of graph on p. 24 ...
http://europa.eu.int/comm/europeaid/projects/resal/Download/report/quarterly/bolper/0699qbol.pdf
*/

/* The original document/graph was european, and used a numeric format
   that used spaces in the thousand-place, but I'm setting up the graph
   to use the locale-specific numeric format native to Bolivia, since
   that makes the most sense for a map about Bolivia. (ie, my plot will
   have dots in the thousand-place, in the numbers along the y-axis. */
options locale=spanish_bolivia;

/* These data values are only rough approximations,
   based on looking at the original graph. */
data my_data;
label a='Trigo (Wheat)';
label b='Harina (Flour)';
label c='Trigo+harina';
format a b c nlnum7.0;
input year a b;
c=a+b;
datalines;
1985 300000 50000
1986 180000 70000
1987 301000 80000
1988 130000 50000
1989 150000 100000
1990 100000 50000
1991 153000 60000
1992 240000 80000
1993 190000 40000
1994 200000 35000
1995 110000 100000
1996 200000 30000
1997 180000 20000
1998 150000 30000
;
run;

data my_data; set my_data;
length myhtml $200;
myhtml=
 'title='||quote(
  'Trigo (Wheat):  '||put(a,nlnum7.0)||'0D'x||
  'Harina (Flour): '||put(b,nlnum7.0)||'0D'x||
  'Both:           '||put(c,nlnum7.0))||
 ' href="wheat_info.htm"';
run;


goptions device=png;
goptions border;
goptions hsize=8in vsize=4.5in;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" 
 (title="SAS/Graph - Spanish wheat example") 
 style=htmlblue;

goptions gunit=pct ftitle="albany amt/bold" htitle=5.25 ftext="albany amt" htext=3.5;

title1 ls=4.0 "Bolivia: Importaci髇 de trigo, harina de trigo y ambos. Serie 85-98";
title2 h=2.0 " ";
title3 h=2.0 a=-90 " ";

footnote1 h=1pct " ";
 
/* I'm slightly changing the markers from the original plot.
   I'm using a 'plus' sign for the "trigo+harina" line, since
   that will give a visual cue that it is the combination of
   the two. */
symbol1 i=join h=2.2 c=navy    font=marker v=C;
symbol2 i=join h=2.2 c=magenta font=marker v=U;
symbol3 i=join h=2.2 c=yellow  font=marker v=S;

axis1 label=(a=90 "TM") order=(0 to 450000 by 50000) minor=none offset=(0,0);
axis2 label=none minor=none value=(a=60) offset=(2,2) order=(1985 to 1998 by 1);

legend1 label=none frame cframe=tan cborder=gray99;

goptions iback="bolivia_flag.gif" imagestyle=fit;

proc gplot data=my_data; 
plot a*year=1 b*year=2 c*year=3 / overlay 
 vaxis=axis1 haxis=axis2 
 autovref cvref=gray99 cframe=tan 
 legend=legend1 html=myhtml
 des='' name="&name"; 
run;

quit;
ODS HTML CLOSE;
ODS LISTING;


*--------------------------------------一个比较绚丽的折线图------------------------------------*;
%let name=german;
filename odsout '.';

/* 
Imitation of german plot from...
http://www.imbe.med.uni-erlangen.de/lehre/Biomathematik/DeskriptiveStatistik.pdf
*/

data my_data;
input stichprobe $ 1 value;
datalines;
A 4.1
A 4.5
A 5.3
A 5.4
A 5.5
A 5.6
A 5.8
A 6.2
A 6.4
A 7.9
B 1.3
B 3.0
B 3.5
B 4.7
B 5.5
B 5.9
B 6.6
B 7.9
B 8.4
B 9.9
;
run;

data my_data; set my_data;
length my_html $200;
my_html=
 'title='||quote(
  'Stichprobe: '||trim(left(stichprobe))||'0D'x||
  'Value: '||trim(left(put(value,nlnum4.1))))||
 ' href="german_info.htm"';
run;


/* Calculate some simple statistics from the data, and store the 
   values as macro variables, so you can use them in the footnotes.
   Note the use of 'locale', so that we can use the nlnum format. */
options LOCALE=German_Germany;

proc sql;
select count(*) format comma3.0 into :n_a from my_data where stichprobe='A';
select count(*) format comma3.0 into :n_b from my_data where stichprobe='B';
select avg(value) format nlnum4.1 into :mean_a from my_data where stichprobe='A';
select avg(value) format nlnum4.1 into :mean_b from my_data where stichprobe='B';
quit; run;

proc sql;
 create table anno_text as
 select unique stichprobe 
 from my_data;
quit; run;

data anno_text; set anno_text;
xsys='2'; ysys='2'; hsys='3'; when='a';
x=8.3;
yc=stichprobe;
function='label'; position='2';
text='Stichprobe '||trim(left(stichprobe));
run;


goptions device=png;
goptions border;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" 
 (title="SAS/Graph German example") 
 style=htmlblue;

goptions gunit=pct htitle=4.2 htext=3.8 ftitle="albany amt/bold" ftext="albany amt";

axis1 label=none value=none order=('B' 'A') offset=(15,12) major=none;

axis2 label=none minor=none order=(0 to 10 by 2) offset=(0,0) major=(height=-.5 cells);

symbol v=circle i=none h=5.2 color=blue;

title1 j=l move=(+5,+0) ls=1.5 "6.2. Streuungsma遝";
title2 j=l move=(+5,+0) "Streuungsma遝 dienen der Quantifizierung des Grades";
title3 j=l move=(+5,+0) "der Variabilit鋞 der beobachteten Auspr鋑ungen in der";
title4 j=l move=(+5,+0) "Stichprobe.";
title5 h=5pct "  ";
title6 a=90 h=11pct " ";   /* left-hand border whitespace */
title7 a=-90 h=13pct " ";  /* right-hand border whitespace */

/* 
Have to get just a little 'tricky' to put the double-quote at the bottom,
in front of the word 'kleine', and also the '-' bar over the x, etc
*/
footnote1 j=l move=(+5,+0) "Stichprobe A:   n =&n_a;  x" move=(-1.1,+1.6) '-' move=(+1,-1.6) " = &mean_a;  " 
   move=(-0,-1) '"' move=(+0,+1) 'kleine Streuung"';

footnote2 j=l move=(+5,+0) "Stichprobe B:   n =&n_b;  x" move=(-1.1,+1.6) '-' move=(+1,-1.6) " = &mean_b;  " 
   move=(-0,-1) '"' move=(+0,+1) 'gro遝 Streuung"';

proc gplot data=my_data anno=anno_text; 
plot stichprobe*value / noframe
 vaxis=axis1 haxis=axis2
 html=my_html
 des='' name="&name"; 
run;

quit;
ODS HTML CLOSE;
ODS LISTING;


*-------------------------------折线和地图的结合情况---------------------------*;
%let name=bar_map;
filename odsout '.';

options mprint;

/* Reduce the size of the world map, and get rid of some of the islands */
proc sql;
create table world as
select *, cont as continent, id as country 
from maps.world
where density<=1 and segment<=3 and country^=143;
quit; run;

options fmtsearch=(sashelp.mapfmts);
data world; set world;
length  countryname $20;
countryname=put(country,glcnsm.);
run;

data mydata;
label Lost_Activity_Days='Activity Days Lost Due to Hospitalization';
label ADRs='Serious Adverse Drug Events';
format Lost_Activity_Days comma10.0;
format ADRs comma10.0;
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
length  myhtmlvar1 $400;
myhtmlvar1=
 'title='||quote( 
  trim(left(countryname))||'0D'x||
  'Lost Activity Days:'||trim(left(put(Lost_Activity_Days,comma15.0)))||'0D'x||
  'Serious Adverse Drug Events:'||trim(left(put(ADRs,comma15.0))))||
 ' href="http://www3.who.int/whosis/menu.cfm"';
run;


goptions device=png;

proc greplay  nofs; igout=gseg;  delete _all_;

goptions gunit=pct ftitle="albany amt/bold" ftext="albany amt/bold" htitle=5 htext=2.5;

goptions nodisplay; 

 /* 1st map & bar chart */

 title1 
  link="bar_map_info.htm"
  ls=1.5 "Activity Days Lost Due to Hospitalization";

 title2 a=90 h=13.5 " ";

 footnote1 c=gray99 link="http://www3.who.int/whosis/menu.cfm" "Based on World Health Organization Data";

 pattern1 v=s c=red;

 proc gmap data=mydata map=world all; 
  id countryname; 
  choro Lost_Activity_Days / levels=1 nolegend 
   cdefault=cxe9f0e5 coutline=gray55 
   html=myhtmlvar1 name='map';
  run;

 pattern1 v=s c=Adddddd77;  /* New SAS 9.3 alpha-transparency */
 axis1 label=none major=(number=5) minor=none;
 axis2 label=none;
 title h=10pct " ";  /* just to add some space at top of bar chart */
 footnote h=4pct " ";
 proc gchart data=mydata;
  vbar countryname / type=sum sumvar=Lost_Activity_Days descending
   raxis=axis1 maxis=axis2 noframe
   caxis=graydd coutline=gray77
   html=myhtmlvar1 name='bar';
 run;

 /* 2nd map & bar chart */

 title1 
  link="bar_map_info.htm"
  ls=1.5 "Serious Adverse Drug Events";
 title2 a=90 h=13.5 " ";
 footnote1 c=gray99 link="http://www3.who.int/whosis/menu.cfm" "Based on World Health Organization Data";
 pattern1 v=s c=red;
 proc gmap data=mydata map=world all; 
  id countryname; 
  choro ADRs / levels=1 nolegend 
   cdefault=cxe9f0e5 coutline=gray55 
   html=myhtmlvar1 name='map2';
  run;

 pattern1 v=s c=Adddddd77;  /* New SAS 9.3 alpha-transparency */
 axis1 label=none major=(number=5) minor=none;
 axis2 label=none;
 title h=10pct " ";  /* just to add some space at top of bar chart */
 footnote h=4pct " ";
 proc gchart data=mydata;
  vbar countryname / type=sum sumvar=ADRs descending
   raxis=axis1 maxis=axis2 noframe 
   caxis=graydd coutline=gray77
   html=myhtmlvar1 name='bar2';
 run;


goptions display;
goptions noborder;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" 
 (title="WHO Data - SAS/Graph bar chart and gmap") style=htmlblue;

/* Define your greplay template, with 1 area */
proc greplay tc=tempcat nofs igout=work.gseg;
  tdef one des='One'
  1/ llx =  0   lly = 0
     ulx =  0   uly = 100
     urx = 100  ury = 100
     lrx = 100  lry = 0
;
template = one;
/* Replay the map & bar chart into that 1 area, to overlay them */
treplay 1:map2 1:bar2 
 des='' name="&name";
treplay 1:map 1:bar 
 des='' name="&name";
run;

title " ";
proc print data=mydata label noobs;
 var countryname Lost_Activity_Days ADRs;
run;

quit;
ODS HTML CLOSE;
ODS LISTING;

*----------------------------kanji的折线图--------------------*;
%let name=japan;
filename odsout '.';

data my_data;
input x linetype y1;
datalines;
0  1 99.8
1  1 99.8
2  1 99.5 
3  1 99.2
4  1 99.4
5  1 99.6
6  1 99.3
7  1 99.0
8  1 99.4
9  1 99.2
10 1 99.2
11 1 98.8
12 1 98.7
0  2 98.4
1  2 98.2
2  2 97.8 
3  2 98.0
4  2 98.3
5  2 98.6
6  2 98.5
7  2 98.2
8  2 98.4
9  2 98.4
10 2 98.1
11 2 98.1
12 2 98.1
0  3 98.2
1  3 97.9
2  3 97.6 
3  3 97.9
4  3 98.2
5  3 98.4
6  3 98.1
7  3 98.0
8  3 98.1
;
run;

/* These are the japanese character values that get printed in the legend,
   in the top/left inside of the graph */
data my_data; set my_data;
if linetype eq 1 then jlinetype='95BD'x||'90AC'x||'8250'x||'8252'x||'944E'x;
if linetype eq 2 then jlinetype='95BD'x||'90AC'x||'8250'x||'8253'x||'944E'x;
if linetype eq 3 then jlinetype='95BD'x||'90AC'x||'8250'x||'8254'x||'944E'x;
run;


/* Define a template - Use brown 3d border rather than gray ... */
/*
I listed out the default d3d style template using the following code:
 proc template; 
  source styles.d3d;
 run;
And then I modified it using the following code:
*/
ods path work.template(update) sashelp.tmplmst;
proc template;
 define style styles.brown3d;
   parent = styles.d3d;

   replace Output from Container /
      borderstyle = outset
      background = colors('tablebg')
      bordercolordark = liolbr
      bordercolorlight = liybr
      borderwidth = 9
      rules = all
      frame = Box
      cellpadding = 5
      cellspacing = 1
      bordercolor = colors('tableborder');

 end;
run;


goptions device=png;
goptions hsize=6in vsize=5in;
goptions cback=lilg;
goptions border;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" 
 (title="SAS/Graph Japanese example") 
 style=brown3d;

goptions htitle=6pct htext=3.25pct ftext="albany amt";

title1 
 link="http://www.stat.go.jp/data/cpi/sokuhou/tsuki/index-z.htm" 
 j=l move=(+10,+0) 
 font=kanji '907D'x '8250'x '  ' '918D'x '8D87'x '8E77'x '9094'x  '82CC'x '93AE'x '82AB'x ;

title2 
 j=r move=(-7,+0)
 font=kanji '95BD'x '90AC'x '8250'x '8251'x '944E'x '8181'x '8250'x '824F'x '824F'x;

/* I add a blank/fake title on the left & right side of the graph to add more spacing */
title3 a=90 h=3pct " ";
title4 a=-90 h=3pct " ";

axis1 order=(0 to 12 by 1) minor=none label=(j=r font=kanji '8C8E'x) 
  value=(tick=1 ' ') offset=(0,0) 
  /* negative tickmark height makes them point in towards the graph */
  major=(height=-.5 cells);

axis2 order=(96 to 102 by 1) minor=none label=none offset=(0,0) major=(height=-.8 cells);

symbol1 c=black i=join v=none l=2;  /* dashed line */
symbol2 c=gray  i=join v=none;      /* solid gray line */
symbol3 c=black i=join v=none;      /* solid black line */

legend1 mode=share position=(top left inside) across=1 
  value=(font=kanji) label=none offset=(5,-1);
 
proc gplot data=my_data; 
plot y1*x=jlinetype / legend=legend1
 haxis=axis1 vaxis=axis2
 des='SAS/Graph using sas kanji software font characters' 
 cframe=lilg name="&name"; 
run;

quit;
ODS HTML CLOSE;
ODS LISTING;
	
