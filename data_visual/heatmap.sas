*-----------------------------------热力图---------------------------------------*;
%let name=elect08;
filename odsout '.';

/* Loosely based on ... http://fisher.lib.virginia.edu/elections/elect2000/election11by17.pdf */

/*
Obama & McCain image screen-captured from:
http://online.wsj.com/article/SB122581133077197035.html#articleTabs%3Dinteractive
*/

/*
Number of electoral votes per state gotten from:
http://www.votesmart.org/election_president_electoral_college.php
*/
data my_data;
length st $2 winner $10 myhtml $1000;
input st votes winner;
myhtml=
 'target="another_window"'||
 ' title='||quote(
  'State          : '||trim(left(fipnamel(stfips(st))))||'0D'x||
  'Winner         : '||trim(left(winner))||'0D'x||
  'Electoral Votes: '||trim(left(votes)))||
 ' href="http://www.usatoday.com/news/politics/election2008/'||trim(left(lowcase(st)))||'.htm"';
datalines;
 AK        3       McCain
 AL        9       McCain
 AR        6       McCain
 AZ       10       McCain
 CA       55       Obama
 CO        9       Obama 
 CT        7       Obama
 DC        3       Obama
 DE        3       Obama
 FL       27       Obama 
 GA       15       McCain
 HI        4       Obama
 IA        7       Obama
 ID        4       McCain
 IL       21       Obama
 IN       11       Obama
 KS        6       McCain
 KY        8       McCain
 LA        9       McCain
 MA       12       Obama
 MD       10       Obama
 ME        4       Obama
 MI       17       Obama
 MN       10       Obama
 MO       11       Undecided
 MS        7       McCain
 MT        3       McCain
 NC       15       Undecided
 ND        3       McCain
 NE        5       McCain
 NH        4       Obama
 NJ       15       Obama
 NM        5       Obama
 NV        5       Obama 
 NY       31       Obama
 OH       20       Obama
 OK        7       McCain
 OR        7       Obama
 PA       21       Obama
 RI        4       Obama
 SC        8       McCain
 SD        3       McCain
 TN       11       McCain
 TX       34       McCain
 UT        5       McCain
 VA       13       Obama
 VT        3       Obama
 WA       11       Obama
 WI       10       Obama
 WV        5       McCain
 WY        3       McCain
;
run;

/* Use the macro to creat the sas/graph map data set for this tree map */
libname here '.';
/*
*/
proc datasets lib=here nolist nowarn; delete elecmap; run;
%include 'treemap_inc.sas';
%mini_tree(a,st,votes,here.elecmap,0,0,180,100);

/* 100x100 is square - I do 180x100 to fit the available space better */


/*
Alternatively, here are some other ways to call this macro, if you
want to add a 2nd-level id variable ...
data my_data; set my_data; 
 country='US';
run;
%treemac(a,country,st,votes,here.elecmap,0,0,180,100);
or
%treemac2(a,country,st,country,st,'outer',votes,here.elecmap,0,0,180,100);
*/

/* Create annotate data set for state abbreviations */
%include 'treeanno2_inc.sas';
%treelabel2(here.elecmap,st,black,annolabel);



data pic_anno;
length function style color $8 html $300 text $50 imgpath $20 html $200;
xsys='3'; ysys='3'; hsys='3'; when='a';

html='title="McCain home page." href="http://johnmccain.com"';
color='red'; style='msolid';
function='poly'; x=5; y=78; output;
function='polycont'; 
x=x+14; output;
y=y+19; output;
x=x-14; output;
y=y-19; output;

function='move'; x=7; y=80; output;
function='image'; x=x+10; y=y+15; imgpath='mccain.jpg'; style='fit'; output;

html='title="Barak Obama home page." href="https://barackobama.com"';
color='cx3690c0'; style='msolid';
function='poly'; x=81; y=78; output;
function='polycont'; 
x=x+14; output;
y=y+19; output;
x=x-14; output;
y=y-19; output;

function='move'; x=83; y=80; output;
function='image'; x=x+10; y=y+15; imgpath='barak.jpg'; style='fit'; output;

run;


data us;
set maps.us;
st=fipstate(state);
run;


goptions device=png;
goptions border;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm"
 (title="2008 Election Results Treemap")
 style=htmlblue;

title1 h=4pct "   ";
title2 h=6pct f="albany amt" "Year 2008 Election Results";
title3 h=2.8pct f="albany amt" "color of box represents who won that state's votes";
title4 h=2.8pct f="albany amt" "size of box represents number of electoral votes";
title5 h=5pct "   ";
footnote h=2.8pct f="albany amt" " ";

pattern1 v=s c=red;
pattern2 v=s c=cx3690c0;
pattern3 v=s c=graydd;

goptions cback=graydd;
proc gmap data=my_data map=here.elecmap anno=pic_anno; 
id st; 
choro winner / 
anno=annolabel
html=myhtml coutline=grayaa woutline=2 nolegend
des="" name="&name"; 
run;


ods html anchor='map';

/* Now, do it using the geographical US map, for comparison */
title1 h=7pct "   ";
title2 h=6pct f="albany amt" "Year 2008 Election Results";
title3 h=7pct "   ";
footnote h=2.8pct f="albany amt" " ";

goptions cback=graydd;
proc gmap data=my_data map=us anno=pic_anno;
id st;
choro winner /
 coutline=grayaa woutline=2 
 html=myhtml nolegend
 des='' name="&name"; 
run;

quit;
ODS HTML CLOSE;
ODS LISTING;


*--------------------------------------------股票市场热力图----------------------------------------------*;
%let name=sp500;
filename odsout '.';

/* 
Similar to 
http://bip.pc.sas.com/projects/graphs/Java%20Rectangular%20Tree%20Map/html/Main.htm
*/

filename stkfile "sp500.dat";

data stocks;
length Sector    $50.;
length Symbol    $10.;
length Name      $80.;
length LastTrade $20.;
format volume    comma20.0;
informat volume    comma20.0;
/* skip the first 2 lines (firstobs=3), since it's vbl names & types. */
infile stkfile dlm=';' firstobs=3;
input Sector Symbol Name Weight LastTrade Change Volume;
run;

proc format;
   value rangfmt
   1='> 8'
   2='6 - 8'
   3='4 - 6'
   4='2 - 4'
   5='0 - 2'
   6='0 - -2'
   7='-2 - -4'
   8='-4 - -6'
   9='-6 - -8'
   10='< -8'
   ;
run;

data stocks; set stocks;
 format range rangfmt.;
 if change > 8 then range=1;
 else if change > 6 then range=2;
 else if change > 4 then range=3;
 else if change > 2 then range=4;
 else if change > 0 then range=5;
 else if change > -2 then range=6;
 else if change > -4 then range=7;
 else if change > -6 then range=8;
 else if change > -8 then range=9;
 else if change <= -8 then range=10;
run;

data stocks; set stocks;
length myhtml $1000;
myhtml=
 'title='||quote(
  'Sector         : '||trim(left(sector))||'0D'x||
  'Symbol         : '||trim(left(symbol))||'0D'x||
  'Company Name   : '||trim(left(name))||'0D'x||
  'Weight         : '||trim(left(weight))||'0D'x||
  'Last Trade     : '||trim(left(lasttrade))||'0D'x||
  'Date           :  some random date in 1999'||'0D'x||
  'Change         : '||trim(left(change))||'0D'x||
  'Volume         : '||trim(left(put(volume,comma20.))))||
 ' href='||quote('http://finance.yahoo.com/q?s='||trim(left(symbol)));
run;

/* Creat the sas/graph map data set */
/* It takes a couple minutes for the macro to create a 
   large sp500map, therefore you'll probably want to save
   the map dataset, and then just plot your new response
   color data on it.  This is ok/valid, as long as the 
   'size' values (in this case 'weight') don't change
   between runs. */
libname here '.';
/*
proc datasets lib=here nolist nowarn; delete sp500map; run;
%include 'treemap_inc.sas';
%treemac(stocks,sector,symbol,weight,here.sp500map,0,0,130,100);
*/


/* Create annotate data sets (outline & labels for sectors) */
%include 'treeanno_inc.sas';
%treelabel(here.sp500map,sector,cyan,annofram,annolabel);

/* make the cyan-colored border around the framed-in sectors
   a little thicker. */
data annofram; set annofram;
 size=.4;
run;

data tree_anno;
 set annofram annolabel;
run;


data pic_anno;
length function style color $8 html $300 text $50;
xsys='3'; ysys='3'; hsys='3'; when='a';
function='move'; x=0; y=88; output;
function='image'; x=x+18; y=y+11; imgpath='SP_logo.gif'; style='fit'; output;
run;


legend1 position=(left middle) across=1 shape=bar(.15in,.15in)
  label=(position=top j=c 'Price Change') frame;


goptions device=png;
goptions xpixels=900 ypixels=725;
goptions cback=white;
goptions noborder;

ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" (title='S&P 500 Stock Market Treemap') style=sasweb;

goptions ftitle="albany amt" ftext="albany amt" gunit=pct htitle=5 htext=2.5;

pattern1  v=s c=cx00ff00;
pattern2  v=s c=cx00cc00;
pattern3  v=s c=cx009900;
pattern4  v=s c=cx006600;
pattern5  v=s c=cx004400;

pattern6  v=s c=cx440000;
pattern7  v=s c=cx660000;
pattern8  v=s c=cx990000;
pattern9  v=s c=cxcc0000;
pattern10 v=s c=cxff0000;

title1 ls=1.5 'S&P 500 Stock Market Treemap';
title2 "size represents 'weight' of company";
title3 "color represents 'change' in stock price";

footnote "Mouse over tiles to see detailed info.  Click on tiles to see current price (NYSE)";

proc gmap data=stocks map=here.sp500map anno=tree_anno; 
id sector symbol; 
choro range / 
 /* play a little trick to make sure all color levels are in the legend */
 midpoints=1 2 3 4 5 6 7 8 9 10
 coutline=graydd woutline=1 
 anno=pic_anno legend=legend1
 html=myhtml 
 des='' name="&name"; 
run;

quit;
ODS HTML CLOSE;
ODS LISTING;

*====================================== Shoe Sales Chart  ========================================*;
%let name=shoes;
filename odsout '.';

/* *** Here is where you can easily change the variables *** */
%let dataset=sashelp.shoes;
%let idvar1=Region;
%let idvar2=Subsidiary;
%let sumvar=Sales;


/* Creat the sas/graph map data set */
libname here '.';
/*
*/
proc datasets lib=here nolist nowarn; delete shoemap; run;
%include 'treemap_inc.sas';
%treemac(&dataset,&idvar1,&idvar2,&sumvar,here.shoemap,0,0,100,100);


/* Create annotate data sets - outline (tree_fram) & labels (tree_labl) */
%include 'treeanno_inc.sas';
%treelabel(here.shoemap,&idvar1,white,tree_fram,tree_labl);

data tree_anno; 
 set tree_labl tree_fram;
run;


/* Create a response data set, to control the colors of the areas.
   You could use the same variable the you used to size the treemap
   rectangles (such as Sales, in this example).  */
proc sql;
create table mydata as
select unique &idvar1, &idvar2,
 sum(&sumvar) format=dollar20.0 as &sumvar
from sashelp.shoes
group by &idvar1, &idvar2;
quit; run;

/* Add some html title= mouseover/rollover/charttip text for the tiles */
data mydata; set mydata;
length myhtml $500;
myhtml=
 'title='||quote(
  "&idvar1: "||trim(left(&idvar1))||'0D'x||
  "&idvar2: "||trim(left(&idvar2))||'0D'x||
  "&sumvar: "||trim(left(put(&sumvar,dollar20.0))))||
 ' href="shoes_info.htm"';
run;


/* Got the shoe gif from the following website, then reduced the
   number of colors, and changed white background to gray, so it
   would blend in well with my gray cback.
   http://www.aperfectworld.org/household.htm
*/
data pic_anno;
   length function style color $ 8 html $ 300 text $ 50;
   xsys='3'; ysys='3'; hsys='3'; when='a';
   function='move'; x=78; y=5; output;
   function='image'; x=x+15; y=y+10; imgpath='shoeicon.gif'; style='fit'; output;
run;


goptions device=gif;
goptions cback=graycc;
goptions border;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm"
 (title="Shoe Sales Tree Map")
 style=htmlblue;

goptions ftitle="albany amt" ftext="albany amt" htitle=5.5pct htext=2.75pct;

legend1 position=(right middle) across=1 shape=bar(3,1)
  label=(position=top j=l font="albany amt/bold");

pattern1 v=s c=graycc;
pattern2 v=s c=cx00ff00;
pattern3 v=s c=cx92c5de;
pattern4 v=s c=cyan;
pattern5 v=s c=magenta;
pattern6 v=s c=red;
pattern7 v=s c=pink;
pattern8 v=s c=cx80cdc1;
pattern9 v=s c=burlywood;
pattern10 v=s c=vpapb;
pattern11 v=s c=yellow;
pattern12 v=s c=dag;

title1 ls=1.5 "Shoe Sales (using data from &dataset)";
title2 "size of blocks represents &sumvar";
title3 "color of blocks represents &idvar1";

proc gmap data=mydata map=here.shoemap all anno=tree_anno;
id &idvar1 &idvar2;
choro &idvar1 /
 coutline=black anno=pic_anno
 legend=legend1 html=myhtml
 des='' name="&name";
run;

/* ------------------------- */

pattern1 v=s c=white;
pattern2 v=s c=cxfee5d9;
pattern3 v=s c=cxfcae91;
pattern4 v=s c=cxfb6a4a;
pattern5 v=s c=cxde2d26;

/* change the annotated outline to black */
data tree_fram; set tree_fram; color='black'; run;

title3 "color of blocks represents &sumvar";

proc gmap data=mydata map=here.shoemap all anno=tree_anno;
id &idvar1 &idvar2;
choro &sumvar / levels=5 legend=legend1
 coutline=graycc anno=pic_anno
 html=myhtml
 des='' name="&name";
run;

quit;
ODS HTML CLOSE;
ODS LISTING;

*===============================================  Disk Space Usage ==============================================*;
%let name=disk;
filename odsout '.';

/* *** Here is where you can easily change the variables *** */
%let dataset=diskdata;
%let thismap=diskmap;
%let idvar1=topdir;
%let idvar2=filepath;
%let sumvar=space;

/*
I generated the disk space usage data as follows ...

cd /install/bob/sas9.1.3    (this was my !sasroot)
du -sk ?/? | expand > ~/disk.dat

(use a * where I use a '?' above - I couldn't use a '*'
here within a sas comment, or it would have prematurely
ended my sas comment ;)
*/

filename file1 'disk.dat';
data diskdata;
length filepath $50 topdir $20;
format space comma10.0;
infile file1 lrecl=80 pad;
input space 1-7 filepath $ 9-80;
topdir=scan(filepath,1,'/');
run;


/* Creat the sas/graph map data set - only do this the *first* time
   through, because it takes a long time to compute. */
libname here '.';
/*
proc datasets lib=here nolist nowarn; delete &thismap; run;
%include 'treemap_inc.sas';
%treemac(&dataset,&idvar1,&idvar2,&sumvar,here.&thismap,0,0,100,100);
*/


/* Create annotate data sets - outline (tree_fram) & labels (tree_labl) */
%include 'treeanno_inc.sas';
%treelabel(here.&thismap,&idvar1,cx00ff00,tree_fram,tree_labl);

data tree_anno; 
 set tree_labl tree_fram;
run;


/* Create a response data set, to control the colors of the areas.
   You could use the same variable the you used to size the treemap
   rectangles (such as Sales, in this example).  */
proc sql;
create table mydata as
select unique &idvar1, &idvar2,
 sum(&sumvar) format comma10.0 as &sumvar
from &dataset
group by &idvar1, &idvar2;
quit; run;

/* Add some html title= mouseover/rollover/charttip text for the tiles */
data mydata; set mydata;
length myhtml $500;
myhtml= 
 'title='||quote(
  "&idvar1: "||trim(left(&idvar1))||'0D'x||
  "&idvar2: "||trim(left(&idvar2))||'0D'x||
  "&sumvar: "||trim(left(put(&sumvar,comma10.0)))||' Kb  ')||
 ' href="disk_info.htm"';
run;



goptions device=gif;
goptions xpixels=650 ypixels=600;
goptions noborder;

ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" (title="Disk Usage of SAS v9.1.3 install") style=sasweb;

goptions ftitle="albany amt" ftext="albany amt" htitle=5.25pct htext=3pct;

legend1 position=(right middle) across=1 shape=bar(.15in,.15in)
  label=(position=top j=c) frame label=(position=top 'Space (Kb)');

pattern1 v=s c=white;
pattern2 v=s c=cxfee5d9;
pattern3 v=s c=cxfcae91;
pattern4 v=s c=cxfb6a4a;
pattern5 v=s c=cxde2d26;
pattern6 v=s c=cxb50000;
pattern7 v=s c=cx7f0000;
pattern8 v=s c=cx5f0000;
pattern9 v=s c=black;

title1 "Disk Space Usage of Unix sas v9.1.3 install";
title2 "size of blocks represents &sumvar";
title3 "color of blocks represents &sumvar";

proc gmap data=mydata map=here.&thismap all anno=tree_anno;
id &idvar1 &idvar2;
choro &sumvar / levels=8 legend=legend1
 coutline=graybb html=myhtml
 des='' name="&name";
run;

quit;
ODS HTML CLOSE;
ODS LISTING;

*==================================================Pfizer Drilldown Tree  ========================================*;
%let name=pfizer;
filename odsout '.';

/* *** Here is where you can easily change the variables *** */
%let mymap=here.pfizmap;
%let idvar1=category;
%let idvar2=drug;
%let sumvar=Revenue;
%let year=2003;

libname here '.';

filename pfifile "pfizer.dat";
data mydata;
infile pfifile;
input cat $ 1-3 Category $ 5-39 Drug $ 41-64 y2003 y2002 y2001;
run;

proc sort data=mydata out=mydata; 
by cat category drug;
run;

proc transpose data=mydata out=mydata;
by cat category drug;
run;
data mydata; set mydata;
year=substr(_name_,2,4);  /* note - year must be character, rather than numeric, for treemac macro */
Revenue=col1;
run;

proc sql;
create table mydata as
select * from mydata
where (year eq "&year") and (Revenue ne .)
order by Revenue descending;
quit; run;


/* Creat the sas/graph map data set */
/*
proc datasets lib=here nolist nowarn; delete pfizmap; run;
%include 'treemap_inc.sas';
%treemac(mydata,category,drug,Revenue,&mymap,0,0,130,65);
*/


/* Create annotate data sets - outline (tree_fram) & labels (tree_labl) */
%include 'treeanno_inc.sas';
%treelabel(&mymap,category,cx00ff00,tree_fram,tree_labl);

data tree_fram; set tree_fram;
color='cx1f61a9';
size=.5;
run;

data tree_anno; 
 set tree_labl tree_fram;
run;


/* Create a response data set, to control the colors of the areas.
   You could use the same variable the you used to size the treemap
   rectangles (such as Sales, in this example).  */
proc sql;
create table mydata as
select unique cat, category, drug,
 sum(Revenue) format=dollar20.0 as Revenue
from mydata
group by category, drug;
quit; run;

/* Add some html title= mouseover/rollover/charttip text for the tiles */
data mydata; set mydata;
length myhtml $500;
myhtml=
 'title='||quote(
  "Category: "||trim(left(category))||'0D'x||
  "Drug: "||trim(left(drug))||'0D'x||
  "Revenue: "||trim(left(put(revenue,dollar20.0))))||
 ' href="pfi_'||trim(left(lowcase(cat)))||'.htm"';
run;


data pic_anno;
length function style $8;
xsys='3'; ysys='3'; hsys='3'; when='a';
function='move'; x=5; y=89; output;
function='image'; x=x+11; y=y+10; imgpath='lg_pfizer.gif'; style='fit'; output;
run;


goptions device=png;
goptions xpixels=800 ypixels=550;
goptions cback=white;
goptions noborder;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm"
 (title="Pfizer Revenues Treemap")
 style=sasweb;
 
goptions ftitle="albany amt" ftext="albany amt" htitle=5pct htext=3pct;

legend1 position=(bottom) across=5 shape=bar(.12in,.12in)
  label=(position=top j=c 'Revenues ($Million) ');

title1
 link="http://www.pfizer.com/are/investors_reports/annual_2003/financial/p2003fr07c_09.htm" 
 "Pfizer Revenues (year &year)";

title2 "Major Pharmaceutical Products";
title3 a=90 h=3pct " ";
title4 a=-90 h=3pct " ";

pattern1 v=s c=cxfeebe2;
pattern2 v=s c=cxfa9fb5;
pattern3 v=s c=cxf768a1;
pattern4 v=s c=cxc51b8a;
pattern5 v=s c=cxb0017e;

proc gmap data=mydata map=&mymap all anno=tree_anno;
id category drug;
choro revenue / levels=5 legend=legend1
 coutline=graycc anno=pic_anno
 html=myhtml
 des='' name="&name";
run;

proc sort data=mydata out=mydata; by category drug; run;

title;
proc print data=mydata noobs label; 
format revenue dollar20.0;
label revenue='Revenue ($Million)';
var category drug revenue;
sum revenue;
run;

quit;
ODS HTML CLOSE;
ODS LISTING;

*==================================================================NASDAQ HeatMap  ===================================================*;
%let name=nasdaq;
filename odsout '.';

/* Loosely based on ... http://screening.nasdaq.com/heatmaps/heatmap_100.asp */

data mydata;
length company $5 myhtml $1000;
format updownpct percent7.2;
input company updown;

size=1;  /* want all block sizes to be the same */
updownpct=updown/100;
myhtml=
 'title='||quote(
  'Company        : '||trim(left(company))||'0D'x||
  'Up/Down Percent: '||trim(left(put(updownpct,percent7.2))))||
 ' href="http://quotes.nasdaq.com/quote.dll?page=multi&mode=stock&symbol='||trim(left(upcase(company)))||'"';
datalines;
ROST 8.12
CECO 4.02
FLEX 3.04
LVLT 2.96
KMRT 2.85
PCAR 2.54
GRMN 2.53
DLTR 2.04
CPWR 1.99
RIMM 1.98
INTU 1.82
BIIB 1.77
SYMC 1.71
RYAAY 1.71
EBAY 1.59
CHRW 1.57
YHOO 1.48
BMET 1.43
PSFT 1.34
CTAS 1.34
CEPH 1.30
BBBY 1.26
SSCC 1.18
PAYX 1.18
SUNW 1.17
SBUX 1.13
ADBE 1.11
QCOM 1.11
NVDA 1.10
PIXR 1.05
FAST 0.98
ORCL 0.90
XRAY 0.87
ERTS 0.86
SNPS 0.82
APOL 0.81
CHKP 0.80
SPLS 0.73
CDWC 0.66
TLAB 0.65
LLTC 0.64 
MEDI 0.63 
PDCO 0.57
HSIC 0.55
MRVL 0.55
VRTS 0.53
AMZN 0.52
LAMR 0.44
AMAT 0.37
APCC 0.36
FISC 0.35
IACI 0.31
SIAL 0.29
GENZ 0.27
MCHP 0.26
EXPD 0.20
DISH 0.20
FHCC 0.19
MSFT 0.19
MOLX 0.17
PTEN 0.17
NTAP 0.05
IVGN 0.04
ESRX 0.03
GILD 0.01
CHIR -0.16
NXTL -0.17
CMVT -0.23
SEBL -0.26
INTC -0.28
PETM -0.29
AMGN -0.29 
JNPR -0.30
LNCR -0.38
MLNM -0.41
KLAC -0.47
DELL -0.53
WFMI -0.56
QLGC -0.56
MERQ -0.58
JDSU -0.64
BEAS -0.75
NVLS -0.77
CSCO -0.79
SNDK -0.84
CTXS -0.86
VRSN -0.89
TEVA -0.98
CMCSA -1.00
SANM -1.03
LRCX -1.07
MXIM -1.08
GNTX -1.25
ATYT -1.63
COST -1.81
BRCM -1.87
XLNX -2.05
ALTR -2.20
AAPL -2.48
ISIL -5.36
;
run;

/* Use the macro to creat the sas/graph map data set for this tree map */
libname here '.';
/*
proc datasets lib=here nolist nowarn; delete nasmap; run;
%include 'treemap_inc.sas';
%mini_tree(mydata,company,size,here.nasmap,0,0,200,100);
*/


/* Create annotate data set for state abbreviations */
%include 'treeanno2_inc.sas';
%treelabel2(here.nasmap,company,black,annolabel);


/* 
Annotate the nasdaq logo, with blank blue space extending to the right.
Then you'll put the title1 and title2 in the blank blue space later.
*/
data pic_anno;
length function style $8 html $300;
xsys='3'; ysys='3'; hsys='3'; when='b';
html='title="NASDAQ" href="http://screening.nasdaq.com/heatmaps/heatmap_100.asp"';
function='move'; x=1.8; y=85; output;
function='image'; x=x+86; y=y+14; imgpath='nasdaq_logo.gif'; style='fit'; output;
run;


proc format;
   value rangfmt
   1='>=5%'
   2='4%-5%'
   3='3%-4%'
   4='2%-3%'
   5='1%-2%'
   6='0%-1%'
   7='-1%-0%'
   8='-2%--1%'
   9='-3%--2%'
   10='-4%--3%'
   11='-5%--4%'
   12='< -5%'
   ;
run;

data mydata; set mydata;
format colorval rangfmt.;
     if updownpct >=  .05 then colorval=1;
else if updownpct >=  .04 then colorval=2;
else if updownpct >=  .03 then colorval=3;
else if updownpct >=  .02 then colorval=4;
else if updownpct >=  .01 then colorval=5;
else if updownpct >=    0 then colorval=6;

else if updownpct >= -.01 then colorval=7;
else if updownpct >= -.02 then colorval=8;
else if updownpct >= -.03 then colorval=9;
else if updownpct >= -.04 then colorval=10;
else if updownpct >= -.05 then colorval=11;
else if updownpct <  -.05 then colorval=12;
run;


goptions device=png;
goptions cback=white;
goptions xpixels=870 ypixels=490;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" 
 (title="NASDAQ-100 Treemap") 
 style=sasweb;

goptions gunit=pct htitle=6 htext=3.5 ftitle="albany amt" ftext="albany amt";

title1 
 link="http://screening.nasdaq.com/heatmaps/heatmap_100.asp" 
 ls=1.5 c=white "NASDAQ-100 Treemap";

title2 c=white "(using a snapshot of data from mid-day 02sep2004)";

footnote h=2.8pct "Mouse over boxes to see detailed values (click on boxes to see current values)";

pattern1 v=s c=cx008400;
pattern2 v=s c=cx219c21;
pattern3 v=s c=cx4abd4a;
pattern4 v=s c=cx8cc68c;
pattern5 v=s c=cxbddebd;
pattern6 v=s c=cxe7efe7;

pattern7 v=s c=cxffe7e7;
pattern8 v=s c=cxffbdbd;
pattern9 v=s c=cxff7b7b;
pattern10 v=s c=cxff5a5a;
pattern11 v=s c=cxff2929;
pattern12 v=s c=cxff0000;

legend1 position=(right middle) across=1 shape=bar(.1in,.1in) value=(h=2)
 label=(position=top j=c) frame label=(position=top 'Up/Down');

proc gmap data=mydata map=here.nasmap anno=pic_anno; 
id company; 
choro colorval / midpoints = 1 2 3 4 5 6 7 8 9 10 11 12
 html=myhtml coutline=cx1D5296 woutline=2 
 legend=legend1 anno=annolabel
 des='' name="&name"; 
run;

quit;
ODS HTML CLOSE;
ODS LISTING;

*=================================================== Company Profile   ==========================================*;
%let name=company;
filename odsout '.';

/* 
Similar to 'treemap' graph in "Information Graphics - A Cpmprehensive Illustrated Reference"
p. 48
*/

data mydata;
length Category $50.;
length Subgroup $50.;
input wholeline $ 1-80;
Category=trim(left(scan(wholeline,1,'/')));
Subgroup=trim(left(scan(wholeline,2,'/')));
amount=0; amount=scan(wholeline,3,'/');
datalines;
Cost to Manufacture/ Overhead: Supervision/ 377
Cost to Manufacture/ Overhead: Indirect/ 290
Cost to Manufacture/ Overhead: Depreciation/ 522 
Cost to Manufacture/ Overhead: Benefits/ 261
Cost to Manufacture/ Labor: Straight Time/ 558
Cost to Manufacture/ Labor: Double Time/ 198
Cost to Manufacture/ Labor: Triple Time/ 144
Cost to Manufacture/ Material: Raw Material/ 972 
Cost to Manufacture/ Material: Fabricated parts/ 1026 
Cost to Manufacture/ Material: Small parts/ 702
R & D/ Leases: Facilities/ 200
R & D/ Leases: Equip./ 100
R & D/ Supplies: Paper/ 175
R & D/ Supplies: Other/ 350
R & D/ Payroll: Technical/ 225
R & D/ Payroll: Clerical/ 225
Marketing/ Promotion: Advertising/ 300
Marketing/ Promotion: Literature/ 300
Marketing/ Leases: Facilities/ 120
Marketing/ Leases: Cars/ 180
Marketing/ Travel: Airlines/ 260
Marketing/ Travel: Mileage/ 140
Marketing/ Payroll: Outside/ 525
Marketing/ Payroll: Inside/ 175
Admin./ Interest: L.T./ 68
Admin./ Interest: S.T./ 102
Admin./ Misc./ 330
Admin./ Payroll: Mgnt./ 250
Admin./ Payroll: Staff/ 250
Profit/ Profit: Total/ 500
run;

data mydata; set mydata;
length myhtml $1000;
myhtml=
 'title='||quote(
  'category : '||trim(left(category))||'0D'x||
  'subgroup : '||trim(left(subgroup))||'0D'x||
  'Amount   : '||trim(left(amount)))||
 ' href="company_info.htm"';
run;

/* Creat the sas/graph map data set */
libname here '.';
/*
proc datasets lib=here nolist nowarn; delete compmap; run;
%include 'treemap_inc.sas';
%treemac(mydata,category,subgroup,amount,here.compmap,0,0,130,100);
*/


/* Create annotate data sets (outline & labels for category) */
%include 'treeanno_inc.sas';
%treelabel(here.compmap,category,black,annofram,annolabel);

/* make the black-colored border around the framed-in category
   a little thicker. */
data annofram; set annofram;
 size=.6;
run;

/* Make the label font a little larger */
data annolabel; set annolabel;
 size=4;
run;

data tree_anno;
 set annofram annolabel;
run;


goptions device=gif;
goptions noborder;

ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm"
 (title="Economic Profile of a Hypothetical Company")
 style=sasweb;

goptions ftitle="albany amt" ftext="albany amt" htitle=6pct htext=3pct;
goptions cback=white;

legend1 position=(top) shape=bar(3,1) label=none frame;

title1 "Economic Profile of a Company";
title2 "(mouse over tiles to see detailed & subgroup info)";

pattern1  v=s c=white r=5;

proc gmap data=mydata map=here.compmap anno=tree_anno; 
id category subgroup; 
choro category / nolegend
 coutline=gray88 woutline=1 
 html=myhtml 
 des='' name="&name"; 
run;

quit;
ODS HTML CLOSE;
ODS LISTING;

*===========================================================sas sales date=========================================*;
%let name=sasrev;
filename odsout '.';

libname here '.';

proc sql;

create table matches as
select *
from here.sasrev
where (company eq "WIDGET MFG CO") and (date ge '01JAN2004'd) and (date le '12oct2004'd)
order by date;

create table summary as
select unique company, product, sum(amount) format=dollar20.0 as Amount
from matches
group by product;

quit; run;

data summary; set summary;
size=abs(amount);
if amount ge 0 then color=1;
else color=2;
length myhtml $1000;
myhtml=
 'title='||quote(
  'Company : '||trim(left(company))||'0D'x||
  'Product : '||trim(left(product))||'0D'x||
  'Amount  : '||trim(left(put(amount,dollar20.0))))||
 ' href="sasrev_info.htm"';
run;

/* Use the macro to creat the sas/graph map data set for this tree map */
libname here '.';
/*
*/
proc datasets lib=here nolist nowarn; delete revmap; run;
%include 'treemap_inc.sas';
%mini_tree(summary,product,size,here.revmap,0,0,130,100);

/*
Alternatively, here are some other ways to call this macro, if you
want to add a 2nd-level id variable ...
data a; set a;
 country='US';
run;
%treemac(a,country,st,votes,here.elecmap,0,0,120,100);
or
%treemac2(a,country,st,country,st,'outer',votes,here.elecmap,0,0,180,100);
*/

/* Create annotate data set for state abbreviations */
%include 'treeanno2_inc.sas';
%treelabel2(here.revmap,product,black,annolabel);



goptions device=gif;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm"
 (title="Sales to WIDGET MFG CO")
 style=sasweb;

goptions ftitle="albany amt/bold" ftext="albany amt" htitle=5pct htext=3pct;

title1 "SAS Sales Invoices to 'WIDGET MFG CO'";
title2 "01JAN2004 - 12OCT2004";

footnote "Mouse over blocks in chart above to see details";
footnote2 "[Proof-of-Concept using contrived data!]";

pattern1 v=s c=cx00ff00;
pattern2 v=s c=cxff0000;

proc gmap data=summary map=here.revmap;
id product;
choro color / midpoints=1 2 nolegend
 anno=annolabel html=myhtml 
 coutline=grayaa woutline=2 
 des='' name="&name"; 
run;

title "Summary data represented in the chart above";
footnote;
proc print data=summary; 
var company product amount;
sum amount;
run;

quit;
ODS HTML CLOSE;
ODS LISTING;

*===========================================================红酒销量的图============================================*;
%let name=scen4;
filename odsout '.';

PROC IMPORT DATAFILE= "scenario3.xls" DBMS=XLS OUT=rvr1 REPLACE;
 RANGE='Scenario3$A37:N37';
 GETNAMES=NO; MIXED=NO; RUN;
data rvr1 (drop=a b c d e f g h i j k l m n); set rvr1;
 F1=a; F2=b; F3=c; F4=d; F5=e; F6=f; F7=g; F8=h; F9=i; F10=j; F11=k; F12=l; F13=m; F14=n;
 run;
data rvr1; set rvr1 (drop=f2); run;
proc transpose data=rvr1 out=rvr1; by f1; run;
data rvr1 (keep=region month sales); set rvr1;
region=f1; sales=col1; month=0; month=(scan(_name_,1,'F')-2); run;

PROC IMPORT DATAFILE= "scenario3.xls" DBMS=XLS OUT=rvr2 REPLACE;
 RANGE='Scenario3$A38:N38';
 GETNAMES=NO; MIXED=NO; RUN;
data rvr2 (drop=a b c d e f g h i j k l m n); set rvr2;
 F1=a; F2=b; F3=c; F4=d; F5=e; F6=f; F7=g; F8=h; F9=i; F10=j; F11=k; F12=l; F13=m; F14=n;
 run;
data rvr2; set rvr2 (drop=f2); run;
proc transpose data=rvr2 out=rvr2; by f1; run;
data rvr2 (keep=region month sales); set rvr2;
region=f1; sales=col1; month=0; month=(scan(_name_,1,'F')-2); run;

PROC IMPORT DATAFILE= "scenario3.xls" DBMS=XLS OUT=rvr3 REPLACE;
 RANGE='Scenario3$A39:N39';
 GETNAMES=NO; MIXED=NO; RUN;
data rvr3 (drop=a b c d e f g h i j k l m n); set rvr3;
 F1=a; F2=b; F3=c; F4=d; F5=e; F6=f; F7=g; F8=h; F9=i; F10=j; F11=k; F12=l; F13=m; F14=n;
 run;
data rvr3; set rvr3 (drop=f2); run;
proc transpose data=rvr3 out=rvr3; by f1; run;
data rvr3 (keep=region month sales); set rvr3;
region=f1; sales=col1; month=0; month=(scan(_name_,1,'F')-2); run;

PROC IMPORT DATAFILE= "scenario3.xls" DBMS=XLS OUT=rvr4 REPLACE;
 RANGE='Scenario3$A40:N40';
 GETNAMES=NO; MIXED=NO; RUN;
data rvr4 (drop=a b c d e f g h i j k l m n); set rvr4;
 F1=a; F2=b; F3=c; F4=d; F5=e; F6=f; F7=g; F8=h; F9=i; F10=j; F11=k; F12=l; F13=m; F14=n;
 run;
data rvr4; set rvr4 (drop=f2); run;
proc transpose data=rvr4 out=rvr4; by f1; run;
data rvr4 (keep=region month sales); set rvr4;
region=f1; sales=col1; month=0; month=(scan(_name_,1,'F')-2); run;

PROC IMPORT DATAFILE= "scenario3.xls" DBMS=XLS OUT=rvr5 REPLACE;
 RANGE='Scenario3$A41:N41';
 GETNAMES=NO; MIXED=NO; RUN;
data rvr5 (drop=a b c d e f g h i j k l m n); set rvr5;
 F1=a; F2=b; F3=c; F4=d; F5=e; F6=f; F7=g; F8=h; F9=i; F10=j; F11=k; F12=l; F13=m; F14=n;
 run;
data rvr5; set rvr5 (drop=f2); run;
proc transpose data=rvr5 out=rvr5; by f1; run;
data rvr5 (keep=region month sales); set rvr5;
region=f1; sales=col1; month=0; month=(scan(_name_,1,'F')-2); run;

data rvr; set rvr1 rvr2 rvr3 rvr4 rvr5; 
run; 

proc sql; 
create table rvr_sum as 
select unique region, sum(sales) as region_sales
from rvr
group by region;
quit; run;

data rvr_sum; set rvr_sum;
length product $ 20;
if region eq 'North America' then do;
product='Cabernet';        sales=.1826*region_sales; output;
product='Zinfandel';       sales=.083534*region_sales; output;
product='Merlot';          sales=.129248*region_sales; output;
product='Chardonnay';      sales=.494798*region_sales; output;
product='Sauvignon Blanc'; sales=.1098*region_sales; output;
end;
else if region eq 'Europe' then do;
product='Cabernet';        sales=.0826*region_sales; output;
product='Zinfandel';       sales=.083534*region_sales; output;
product='Merlot';          sales=.149248*region_sales; output;
product='Chardonnay';      sales=.574798*region_sales; output;
product='Sauvignon Blanc'; sales=.1098*region_sales; output;
end;
else if region eq 'South America' then do;
product='Cabernet';        sales=.1826*region_sales; output;
product='Zinfandel';       sales=.083534*region_sales; output;
product='Merlot';          sales=.249248*region_sales; output;
product='Chardonnay';      sales=.274798*region_sales; output;
product='Sauvignon Blanc'; sales=.1098*region_sales; output;
end;
else if region eq 'Middle East' then do;
product='Cabernet';        sales=.0826*region_sales; output;
product='Zinfandel';       sales=.083534*region_sales; output;
product='Merlot';          sales=.019248*region_sales; output;
product='Chardonnay';      sales=.374798*region_sales; output;
product='Sauvignon Blanc'; sales=.4398*region_sales; output;
end;
else if region eq 'Asia' then do;
product='Cabernet';        sales=.0426*region_sales; output;
product='Zinfandel';       sales=.383534*region_sales; output;
product='Merlot';          sales=.189248*region_sales; output;
product='Chardonnay';      sales=.174798*region_sales; output;
product='Sauvignon Blanc'; sales=.2098*region_sales; output;
end;
run;

data rvr_sum; set rvr_sum;
length myhtml  $ 200;
myhtml=
 'title='||quote(
  'Region: '|| trim(left(region)) ||'0D'x||
  'Wine: '|| trim(left(product)) ||'0D'x||
  'Sales: '|| trim(left(put(sales,dollar20.2))))||
 ' href="scen4_info.htm"';
run;

/* Creat the sas/graph map data set */
libname here '.';
/*
proc datasets lib=here nolist nowarn; delete scen4map; run;
%include 'treemap_inc.sas';
%treemac(rvr_sum,region,product,sales,here.scen4map,0,0,150,100);
*/

%include 'treeanno_inc.sas';
%treelabel(here.scen4map,region,cyan,annofram,annolabel);

data annofram; set annofram;
 color='cx5c3317';
 size=.6;
run;

data annolabel; set annolabel;
 size=3; style="swissbe"; color='cx5c3317'; output;
run;

data tree_anno;
 set annofram annolabel;
run;

data titlanno;
length style $35 text $100;
xsys='3'; ysys='3'; hsys='3';
function='label'; position='5'; color="cx5c3317";
x=62; y=93; size=4.7; style="albany amt/bold"; text="Wine Sales by Region during 2004"; output;
x=62; y=87; size=3.2; style="albany amt/bold"; text="color of box represents wine type"; output;
x=62; y=83; size=3.2; style="albany amt/bold"; text="size of box represents sales"; output;
run;


goptions device=gif;
goptions xpixels=880 ypixels=720;
goptions cback=grayee;
goptions border;

ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm"
(title="Scenario 4 (Open Class)")
 style=htmlblue;

goptions gunit=pct htitle=5 ftitle="albany amt/bold" htext=2.5 ftext="albany amt";
goptions ctext=cx5c3317;

legend1 position=(top) offset=(-34,0)
 shape=bar(2.8,3.3) label=none across=1
 value=(font="albany amt");

title " ";

/*
Cabernet - maroon, ruby red, 
Chardonnay - straw-colored, pale straw yellow, light gold, greenish-yellow
Merlot
Sauvignan Blanc - light straw in color, brilliant lemon-lime, pale wheat, 
 golden yellow, greenish yellow to straw yellow
Zinfandel - Red Wine, medium ruby, deep purple, dark ruby, brilliant ruby
*/

pattern1 v=s c=cxff3030;
pattern2 v=s c=cxf7fcb9;
pattern3 v=s c=cxffc1c1;
pattern4 v=s c=cxdbdb70;
pattern5 v=s c=cxb6316c;

proc gmap data=rvr_sum map=here.scen4map anno=tree_anno;
id region product;
choro product / legend=legend1
 coutline=white woutline=1
 html=myhtml anno=titlanno
 des='' name="&name"; 
run;

quit;
ODS HTML CLOSE;
ODS LISTING;


*=========================================================== School Salary Data   ======================================*;
%let name=wake;
filename odsout '.';

/*
http://www.wral.com/news/public_records/?show_all=1
http://www.wral.com/news/public_records/page/1261595/
http://www.wral.com/news/public_records/page/1281122/
*/

filename myfile 'wake_schools_2008.csv';
data wake_data;
infile myfile firstobs=2 lrecl=100 pad termstr=CRLF;
  input whole_line $ 1-100;
run;

data wake_data (drop=whole_line second_half salary_char); set wake_data;
length salary_char $50;
salary_char=substr(whole_line,2,index(whole_line,'",')-2);
salary=input(salary_char, dollar20.2);
length second_half $100;
second_half=substr(whole_line,index(whole_line,'",')+2);
length job_title $100;
job_title=scan(second_half,1,',');
length school_name $100;
school_name=scan(second_half,2,',');
/* idnum and school_name are interchangeable (use idnum when you need a short id */
length idnum $5;
idnum=trim(left(scan(school_name,2,'-')));
school_name=substr(school_name,1,length(school_name)-6);
run;


/* Convert salary from character to numeric */
data wake_data; set wake_data;
if index(school_name,'School') ne 0 then output;
run;

data wake_data; set wake_data;
length school_type $50;
if index(school_name,'High School') ne 0 then school_type='High Schools';
if index(school_name,'Middle School') ne 0 then school_type='Middle Schools';
if index(school_name,'Elementary School') ne 0 then school_type='Elementary Schools';
if school_type ne '' and
 school_name not in ('Elementary School Education' 'High School Education' 'Middle School Programs')
 then output;
run;

data wake_data; set wake_data;
length drillname $50;
if school_type eq 'High Schools' then drillname='wake_high';
if school_type eq 'Middle Schools' then drillname='wake_middle';
if school_type eq 'Elementary Schools' then drillname='wake_elementary';
drillname=trim(left(drillname))||'.htm';
run;

proc sql;
create table mydata as
select unique school_type, school_name, idnum, drillname,
   count(*) as count,
   sum(salary) format=dollar20.0 as salary_sum,
   avg(salary) format=dollar20.0 as salary_avg
from wake_data
group by school_type, school_name, idnum;
quit; run;

data mydata; set mydata;
length myhtml $1000;
myhtml=
 'title='||quote(
  trim(left(school_name))||'0D'x||
  'Salaried employees = '||trim(left(count))||'0D'x||
  'Salary Average  : '||trim(left(put(salary_avg,dollar20.0)))||'0D'x||
  'Salary Sum  : '||trim(left(put(salary_sum,dollar20.0))))|| 
 ' href='||quote(drillname);
run;


/* Creat the sas/graph map data set */
libname here '.';
/*
proc datasets lib=here nolist nowarn; delete wakemap; run;
%include 'treemap_inc.sas';
%treemac(mydata,school_type,idnum,salary_sum,here.wakemap,0,0,130,100);
*/


/* Create annotate data sets (outline & labels for school_type) */
%include 'treeanno_inc.sas';
%treelabel(here.wakemap,school_type,black,annofram,annolabel);

/* make the black-colored border around the framed-in school_type
   a little thicker. */
data annofram; set annofram;
 size=.6;
run;

/* Make the label font a little larger */
data annolabel; set annolabel;
 size=4;
run;

data tree_anno;
 set annofram annolabel;
run;


/* V9.2 gradient, using ods template */
proc template;
 define style styles.mygradient;
   parent=styles.listing;
   style twocolorramp / startcolor=yellow endcolor=red;
end; run;


goptions device=gif;
goptions noborder;
goptions cback=white;

ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" 
 (title="Wake County NC Schools - Salary Data")
 style=sasweb;

goptions gunit=pct ftitle="albany amt" ftext="albany amt" htitle=5.5 htext=3;

title1 "Wake County NC Schools - Salary Data";
title2 "(mouse over tiles to see School Name & Salary Info)";

footnote "size = total salary      color = average salary";
footnote2 h=.5 " ";

legend1 position=(right middle) across=1 shape=bar(.2in,.2in) 
  label=(position=top 'Avg Salary') value=(h=2.75)
  order=descending /* new option */
  ;

proc format;
  value valfmt
  1='<=$25k'
  2='$25-30k'
  3='$30-35k'
  4='$35-40k'
  5='$40-50k'
  6='$50-75k'
  7='$75-100k'
  8='>$100k'
 ;
data mydata; set mydata;
 format rangeval valfmt.;
      if salary_avg<= 25000 then rangeval=1;
 else if salary_avg<= 30000 then rangeval=2;
 else if salary_avg<= 35000 then rangeval=3;
 else if salary_avg<= 40000 then rangeval=4;
 else if salary_avg<= 50000 then rangeval=5;
 else if salary_avg<= 75000 then rangeval=6;
 else if salary_avg<=100000 then rangeval=7;
 else rangeval=8;
run;

pattern1 v=solid color=cx1a9850;
pattern2 v=solid color=cx66bd63;
pattern3 v=solid color=cxa6d96a;
pattern4 v=solid color=cxd9ef8b;
pattern5 v=solid color=cxfee08b;
pattern6 v=solid color=cxfdae61;
pattern7 v=solid color=cxf46d43;
pattern8 v=solid color=cxd73027;

proc gmap data=mydata map=here.wakemap anno=tree_anno; 
id school_type idnum; 
choro rangeval / discrete midpoints = 1 2 3 4 5 6 7 8
 coutline=gray88 woutline=1 
 legend=legend1 html=myhtml 
 des='' name="&name"; 
run;

title;
footnote;

proc sort data=mydata out=mydata;
by school_type descending salary_avg;
run;

proc print data=mydata label noobs;
label count='Salaried Employees';
by school_type;
var school_name salary_avg count salary_sum;
sum salary_sum;
run;

quit;
ODS HTML CLOSE;
ODS LISTING;


*======================================================== Durham City Salary=======================================================*;
%let name=durham;
filename odsout '.';

filename myfile 'durham_salary_2008.csv';
data durham_data;
infile myfile firstobs=2 lrecl=100 pad termstr=CRLF;
  input whole_line $ 1-100;
run;

data durham_data (drop=whole_line second_half salary_char); set durham_data;
length salary_char $50;
salary_char=substr(whole_line,2,index(whole_line,'",')-2);
salary=input(salary_char, dollar20.2);
length second_half $100;
second_half=substr(whole_line,index(whole_line,'",')+2);
length job_title $100;
job_title=scan(second_half,1,',');
length department_name $100;
department_name=scan(second_half,2,',');
if salary ne . then output;
run;

/*
Unfortunately, department names are too long to use for the Tree Map id's, so I assign a unique id number
and use that instead...
*/
proc sql;
create table departments as 
select unique department_name 
from durham_data;
quit; run;
data departments; set departments;
length idnum $10;
idnum=trim(left(_n_));
run;
proc sql;
create table durham_data as 
select durham_data.*, departments.idnum
from durham_data left join departments
on durham_data.department_name = departments.department_name;
quit; run;

proc sql;
create table durham_data as 
select unique department_name, idnum, sum(salary) as salary_sum, avg(salary) as salary_avg, count(*) as count
from durham_data
group by department_name, idnum;
quit; run;


data durham_data; set durham_data;
length myhtml $1000;
myhtml=
 'title='||quote(
  'Department: '||trim(left(department_name))||'0D'x||
  'Salaried Employee Count: '||trim(left(count))||'0D'x||
  'Average Salary: '||trim(left(put(salary_avg,dollar20.0)))||'0D'x||
  'Total Salary: '||trim(left(put(salary_sum,dollar20.0))))||
 ' href="durham_'||translate(trim(left(department_name)),'___','/ &')||'.htm"';
run;


/* Use the macro to creat the sas/graph map data set for this tree map */
/* I'm sizing the blocks based on the total salary, and in the gmap I'll color them by avg salary */
libname here '.';
proc datasets lib=here nolist nowarn; delete durhammap; run;
%include 'treemap_inc.sas';
%mini_tree(durham_data,idnum,salary_sum,here.durhammap,0,0,160,100);

/* 100x100 is square - I do 180x100 to fit the available space better */


/* Create annotate data set for state abbreviations */
%include 'treeanno2_inc.sas';
%treelabel2(here.durhammap,idnum,black,annolabel);
/* 
Now, merge the actual department names back in, and use them as the annotated
text label, instead of the idnum.
*/
proc sql;
create table annolabel as 
select unique annolabel.*, departments.department_name
from annolabel left join departments
on annolabel.text = departments.idnum;
quit; run;
data annolabel; set annolabel;
length text $100;
text=propcase(department_name);
size=1.8;
run;



goptions device=png;
goptions xpixels=900 ypixels=600;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" 
 (title="City of Durham Salary Data (2008)") 
 style=sasweb;

goptions gunit=pct ftitle="albany amt/bold" ftext="albany amt" htitle=4 htext=3;

title1 "City of Durham Salary Data (2008)";
title2 "(mouse over tiles to see Department Name & Salary Info)";
title3 a=-90 h=5pct " ";

footnote "size = total salary      color = average salary";
footnote2 h=.5 " ";

legend1 position=(left middle) across=1 shape=bar(.2in,.2in)
  label=(position=top 'Avg Salary') value=(h=2.75)
  order=descending /* new option */
  ;

proc format;
  value valfmt
  1='<=$25k'
  2='$25-30k'
  3='$30-35k'
  4='$35-40k'
  5='$40-50k'
  6='$50-75k'
  7='$75-100k'
  8='>$100k'
 ;
data durham_data; set durham_data;
 format rangeval valfmt.;
      if salary_avg<= 25000 then rangeval=1;
 else if salary_avg<= 30000 then rangeval=2;
 else if salary_avg<= 35000 then rangeval=3;
 else if salary_avg<= 40000 then rangeval=4;
 else if salary_avg<= 50000 then rangeval=5;
 else if salary_avg<= 75000 then rangeval=6;
 else if salary_avg<=100000 then rangeval=7;
 else rangeval=8;
run;

pattern1 v=solid color=cx1a9850;
pattern2 v=solid color=cx66bd63;
pattern3 v=solid color=cxa6d96a;
pattern4 v=solid color=cxd9ef8b;
pattern5 v=solid color=cxfee08b;
pattern6 v=solid color=cxfdae61;
pattern7 v=solid color=cxf46d43;
pattern8 v=solid color=cxd73027;

proc gmap data=durham_data map=here.durhammap; 
id idnum; 
choro rangeval / discrete midpoints = 1 2 3 4 5 6 7 8
 anno=annolabel legend=legend1
 html=myhtml coutline=grayaa woutline=2 
 des='' name="&name"; 
run;

proc sort data=durham_data;
by descending salary_sum;
run;

title;
footnote;
proc print data=durham_data label; 
format salary_sum salary_avg dollar20.0;
format count comma10.0;
label count='Employees';
var department_name salary_sum count salary_avg;
sum salary_sum count;
run;

quit;
ODS HTML CLOSE;
ODS LISTING;

*==========================================================================================================================*;
%let name=gasoline;
filename odsout '.';

%include '../data_vault/proxy.sas';
/*
I %include a file that sets the my_proxy macro variable.
You won't be able to use my proxy, therefore set your own
macro variable, which will be something like the following:
%let my_proxy=http://yourproxy.com:80;
*/

filename datafile url "http://fuelgaugereport.aaa.com/import/display.php?lt=state&amp;ls="
 proxy="&my_proxy";

data mydata;
infile datafile pad;
input wholeline $ 1-200;
run;

data mydata; set mydata;
if substr(wholeline,1,9)='<td class' then output;
run;
data mydata (keep = statename regular_gas_price); set mydata;
retain statename;
length statename $50;
if scan(wholeline,2,'"')='state' then statename=scan(scan(wholeline,3,'>'),1,'<');
if scan(wholeline,2,'"')='price' then regular_gas_price=input(scan(scan(wholeline,2,'>'),1,'<'),dollar8.3);
run;
data mydata; set mydata;
if mod(_n_,5)=2 then output; /* this is the obsn for 'Regular' gas price */
run;

/* merge in the state abbreviations */
proc sql;
create table mydata as
select mydata.*, us_data.statecode
from mydata left join sashelp.us_data
on mydata.statename=us_data.statename;
quit; run;



/* Merge the population data in with the gasoline data */
proc sql;
create table mydata as 
select mydata.*, us_data.population_2010 as population
from mydata left join sashelp.us_data
on mydata.statename = us_data.statename;
quit; run;


data mydata; set mydata;
length myhtml $1000;
myhtml=
 'title='||quote(
  'State: '||trim(left(statename))||'0D'x||
  'Population: '||trim(left(put(population,comma20.0)))||'0D'x||
  trim(left(put(regular_gas_price,dollar7.2)))||' per gallon')||
 ' href='||quote('http://fuelgaugereport.aaa.com/states/'||trim(left(lowcase(statename)))||'/');
run;


/* Use the macro to creat the sas/graph map data set for this tree map */
/* I'm sizing the blocks based on the state population, and in the gmap I'll color them by gas price */
libname here '.';
proc datasets lib=here nolist nowarn; delete gasmap; run;
%include 'treemap_inc.sas';
%mini_tree(mydata,statecode,population,here.gasmap,0,0,160,100);

/* 100x100 is square - I do 160x100 to fit the available space better */


/* Create annotate data set for state abbreviations */
%include 'treeanno2_inc.sas';
%treelabel2(here.gasmap,statecode,black,annolabel);

goptions device=gif;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" 
 (title="Gas Prices") style=htmlblue;

goptions gunit=pct ftitle="albany amt/bold" ftext="albany amt" htitle=4 htext=2.5;

legend1 label=(position=left '$/gallon') shape=bar(.15in,.15in);

pattern1 v=s c=cx4dac26;
pattern2 v=s c=cxb8e186;
pattern3 v=s c=cxf7f7f7;
pattern4 v=s c=cxf1b6da;
pattern5 v=s c=cxd01c8b;

title1 "Regular Gasoline Prices";
title2 
 link="http://fuelgaugereport.aaa.com/todays-gas-prices/" 
 ls=1.2 "Data Source: AAA (&sysdate9)";

footnote1 "size=state population       color=gasoline price";
footnote2 h=.2 " ";

proc gmap data=mydata map=here.gasmap; 
format regular_gas_price comma8.2;
id statecode; 
choro regular_gas_price / levels=5 legend=legend1
 woutline=2 anno=annolabel 
 html=myhtml coutline=gray66 
 des='' name="&name"; 
run;

goptions border;
footnote;

proc gmap data=mydata map=maps.us;
format regular_gas_price comma8.2;
id statecode;
choro regular_gas_price / levels=5 legend=legend1
 html=myhtml coutline=gray66 
 des='' name="&name"; 
run;

proc sort data=mydata;
by regular_gas_price;
run;

proc print data=mydata; 
format regular_gas_price dollar8.2;
format population comma20.0;
var statename regular_gas_price population;
run;

quit;
ODS HTML CLOSE;
ODS LISTING;

*===============================================================mpg date========================================*;
%let name=mpgtree;
filename odsout '.';

libname mydata '../democd_mpg';

%let year=2016;

proc sql;
create table mydata as
select unique year, make, model, Transmission, Cylinders, Engine_Liters, Extra_info, mpg_cmb
from mydata.mpg_data
where 
 (year eq &year) 
 and index(class,'Sport Utility')^=0
 and (cylinders=8)
 ;
quit; run;

data mydata; set mydata;
length make2 $100 myhtml $500;
make2=translate(trim(left(make)),'_',' ');   /* convert spaces to underscore */
make2=translate(trim(left(make2)),'_','-');  /* convert minus-sign to underscore */
myhtml=
'title='||quote(
  trim(left(year))||' '||trim(left(make))||' '||trim(left(model))||'0d'x||
  trim(left(Transmission))||' transmission / '||trim(left(Cylinders))||' cyl / '||trim(left(Engine_Liters))||' liter'||' / '||trim(left(Extra_info))||'0d'x||
  trim(left(put(mpg_cmb,comma8.1)))||' mpg')||
  ' href='||quote('#'||trim(left(make2)));
length idnum $50;
idnum=trim(left(_n_));
run;


/* Creat the sas/graph map data set */
libname here '.';
proc datasets lib=here nolist nowarn; delete mpgtree; run;
%include 'treemap_inc.sas';
%treemac(mydata,make,idnum,mpg_cmb,here.mpgtree,0,0,130,100);


/* Create annotate data sets (outline & labels for school_type) */
%include 'treeanno_inc.sas';
%treelabel(here.mpgtree,make,black,annofram,annolabel);

/* make the black-colored border around the framed-in manufacturers a little thicker. */
data annofram; set annofram;
 size=.4;
run;

/* Make the label font a little larger */
data annolabel; set annolabel;
 size=2.0;
 position='b';
run;

data tree_anno;
 set annofram annolabel;
run;


goptions device=png;
goptions xpixels=900 ypixels=650;
goptions cback=white;
goptions noborder;

ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" 
 (title="8-cyl SUV MPG (&year)") style=htmlblue;

goptions gunit=pct ftitle="albany amt" ftext="albany amt" htitle=4 htext=2.5;

title1 "8-cylinder Sport Utility vehicle MPG (&year)";
title2 "mouse over tiles to see detailed info";
title3 "click tiles to drilldown to list";

legend1 position=(right middle) across=1 shape=bar(.2in,.2in) 
  label=(position=top j=center 'MPG')
  order=descending /* new option */
  ;

pattern1 v=s c=cxd7191c;
pattern2 v=s c=cxfdae61;
pattern3 v=s c=cxffffbf;
pattern4 v=s c=cx64d035;
pattern5 v=s c=cx00ff00;

proc gmap data=mydata map=here.mpgtree anno=tree_anno; 
id make idnum; 
choro mpg_cmb / levels=5
 coutline=gray88 woutline=1 
 legend=legend1 html=myhtml 
des='' name="&name"; 
run;

quit;
ODS HTML CLOSE;
ODS LISTING;
 

/* Then append a table after the graphs */
filename odsout "." mod;
ods listing close;
ODS HTML path=odsout body="&name..htm" gpath="graphs" style=minimal;

proc sort data=mydata out=mydata;
by make descending mpg_cmb;
run;

data mydata; set mydata;
length link $300 href $300;
 link='http://images.google.com/images?&q='||trim(left(year))||' '||trim(left(make))||' '||trim(left(model));
 label link='model';
 href = 'href="' || trim(left(link)) || '"';
 link = '<a ' || trim(href) || ' target="body">' || htmlencode(trim(model)) || '</a>';
run;

%macro do_table(make,make2);
ods html anchor="&make2";
title "&make";
proc print data=mydata (where=(make="&make")) noobs label;
var make make link mpg_cmb transmission engine_liters cylinders extra_info;
run;
%mend;

proc sql; create table foo as select unique make, make2 from mydata order by make; quit; run;
data _null_;
 set foo;
   call execute('%do_table('|| make ||', '|| make2 ||');');
   call execute('run;');
run;

quit;
ods html close;


*==============================================================选举结果对比===================================================*;
%let name=elect2k;
filename odsout '.';

/* Loosely based on ... http://fisher.lib.virginia.edu/elections/elect2000/election11by17.pdf */

/*
Bush and Gore pictures modified from royalty-free clipart ...
http://free-stock-photos.com/
http://free-stock-photos.com/president/gwbush-1.html
http://free-stock-photos.com/history/al-gore-1.html
*/

data my_data;
length st $2 winner $4 myhtml $1000;
input st votes winner;
myhtml=
 'title='||quote(
  'State          : '||trim(left(fipnamel(stfips(st))))||'0D'x||
  'Winner         : '||trim(left(winner))||'0D'x||
  'Electoral Votes: '||trim(left(votes)))||
 ' href="http://www.state.'||trim(left(lowcase(st)))||'.us"';
datalines;
 AK        3       Bush 
 AL        9       Bush 
 AR        6       Bush 
 AZ        8       Bush 
 CA       54       Gore 
 CO        8       Bush 
 CT        8       Gore 
 DC        3       Gore 
 DE        3       Gore 
 FL       25       Bush 
 GA       13       Bush 
 HI        3       Gore 
 IA        7       Gore 
 ID        4       Bush 
 IL       22       Gore 
 IN       12       Bush 
 KS        6       Bush 
 KY        8       Bush 
 LA        9       Bush 
 MA       12       Gore 
 MD       10       Gore 
 ME        4       Gore 
 MI       18       Gore 
 MN       10       Gore 
 MO       11       Bush 
 MS        7       Bush 
 MT        3       Bush 
 NC       14       Bush 
 ND        3       Bush 
 NE        5       Bush 
 NH        4       Bush 
 NJ       15       Gore 
 NM        5       Gore 
 NV        4       Bush 
 NY       33       Gore 
 OH       21       Bush 
 OK        8       Bush 
 OR        7       Gore 
 PA       23       Gore 
 RI        4       Gore 
 SC        8       Bush 
 SD        3       Bush 
 TN       11       Bush 
 TX       32       Bush 
 UT        5       Bush 
 VA       13       Bush 
 VT        3       Gore 
 WA       11       Gore 
 WI       11       Gore 
 WV        5       Bush 
 WY        3       Bush 
;
run;

/* Use the macro to creat the sas/graph map data set for this tree map */
libname here '.';
/*
proc datasets lib=here nolist nowarn; delete elecmap; run;
%include 'treemap_inc.sas';
%mini_tree(a,st,votes,here.elecmap,0,0,180,100);
*/

/* 100x100 is square - I do 180x100 to fit the available space better */


/*
Alternatively, here are some other ways to call this macro, if you
want to add a 2nd-level id variable ...
data my_data; set my_data; 
 country='US';
run;
%treemac(a,country,st,votes,here.elecmap,0,0,180,100);
or
%treemac2(a,country,st,country,st,'outer',votes,here.elecmap,0,0,180,100);
*/

/* Create annotate data set for state abbreviations */
%include 'treeanno2_inc.sas';
%treelabel2(here.elecmap,st,black,annolabel);



data pic_anno;
length function style color $8 html $300 text $50 html $200;
xsys='3'; ysys='3'; hsys='3'; when='a';

html='title="George W Bush home page." href="http://www.georgewbush.com"';
color='red'; style='msolid';
function='poly'; x=5; y=78; output;
function='polycont'; 
x=x+14; output;
y=y+19; output;
x=x-14; output;
y=y-19; output;

function='move'; x=7; y=80; output;
function='image'; x=x+10; y=y+15; imgpath='bush.jpg'; style='fit'; output;

html='title="Al Gore home page." href="http://clinton1.nara.gov/White_House/EOP/OVP/html/Bio.html"';
color='cx3690c0'; style='msolid';
function='poly'; x=81; y=78; output;
function='polycont'; 
x=x+14; output;
y=y+19; output;
x=x-14; output;
y=y-19; output;

function='move'; x=83; y=80; output;
function='image'; x=x+10; y=y+15; imgpath='gore.jpg'; style='fit'; output;

run;


data us; set maps.us;
st=fipstate(state);
run;


goptions device=png;
goptions border cback=graydd;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm"
 (title="2000 Election Results Treemap")
 style=htmlblue;
 
title1 h=4pct "   ";
title2 h=6pct f="albany amt" "Year 2000 Election Results";
title3 h=2.8pct f="albany amt" "color of box represents who won that state's votes";
title4 h=2.8pct f="albany amt" "size of box represents number of electoral votes";
title5 h=5pct "   ";
footnote h=2.8pct f="albany amt" " ";

pattern1 v=s c=red;
pattern2 v=s c=cx3690c0;
pattern3 v=s c=graydd;

proc gmap data=my_data map=here.elecmap anno=pic_anno; 
id st; 
choro winner / 
anno=annolabel
html=myhtml coutline=grayaa woutline=2 nolegend
des="" name="&name"; run;

/* Now, do it using the geographical US map, for comparison */
title1 h=7pct "   ";
title2 h=6pct f="albany amt" "Year 2000 Election Results";
title3 h=7pct "   ";
footnote h=2.8pct f="albany amt" " ";

proc gmap data=my_data map=us anno=pic_anno;
id st;
choro winner /
 coutline=grayaa woutline=2 
 nolegend html=myhtml 
 des='' name="&name"; 
run;

quit;
ODS HTML CLOSE;
ODS LISTING;

*==============================================================US Stimulus Package  ===============================================*;
%let name=stimulus;
filename odsout '.';

/*
This is a SAS/Graph version of the tree chart created by Michael Grabell of ProPublica.
I originally saw his chart here:
http://www.propublica.org/special/stimulus-bill-treemap
And then found another version on "ManyEyes":
http://manyeyes.alphaworks.ibm.com/manyeyes/visualizations/stimulus-bill-where-the-money-would--5

I File->Saved the data from ManyEyes
http://manyeyes.alphaworks.ibm.com/manyeyes/datasets/stimulus-bill-where-the-money-would--5/versions/1
I saved it as stimulus.txt (which is a tab-delimited data file),
and then Imported it into an Excel spreadsheet,
and then I use SAS/Access to PCFileFormats to import it into SAS.
*/

/* *** Here is where you can easily change the variables *** */
%let dataset=stimdata;
%let idvar1=Category;
%let idvar2=Project;
%let sumvar=Total_Cost;


PROC IMPORT OUT=&dataset DATAFILE="stimulus.xls" DBMS=XLS REPLACE;
 GETNAMES=YES;
 MIXED=NO;
RUN;

data &dataset; set &dataset (rename = (Total_Cost_FY2009_2019 = total_cost));
 format total_cost dollar20.0;
run;


/* Creat the sas/graph map data set */
libname here '.';
/*
proc datasets lib=here nolist nowarn; delete stimmap; run;
%include 'treemap_inc.sas';
%treemac(&dataset,&idvar1,&idvar2,&sumvar,here.stimmap,0,0,220,100);
*/


/* Create annotate data sets - outline (tree_fram) & labels (tree_labl) */
%include 'treeanno_inc.sas';
%treelabel(here.stimmap,&idvar1,black,tree_fram,tree_labl);

/* 
Change position='5' to position='b' to move labels up just a little,
so they'll fit better in the small boxes - otherwise, some labels 
look like they're in the wrong box.
*/
data tree_labl; set tree_labl;
position='b';
run;

/*
Jump through a bunch of hoops to calculate the percent-of-total for
each big box in the tree, so you can truncate the annotated text labels
for the small boxes.  Otherwise, the long labels on the small boxes 
will overlap badly...
*/
proc sql;
create table &dataset as 
select *, sum(&sumvar) as grandtotal
from &dataset;
create table &dataset as 
select *, sum(&sumvar) as id1total
from &dataset
group by &idvar1;
quit; run;
data &dataset; set &dataset;
format id1pct percent7.2;
id1pct=id1total/grandtotal;
run;
proc sql;
create table tree_labl as
select unique tree_labl.*, &dataset..id1pct
from tree_labl left join &dataset
on tree_labl.text = &dataset..&idvar1;
quit; 
run;


/* Shorten the long labels, so they won't overlap */
data tree_labl; set tree_labl;
if id1pct < .005 then text='...';
if id1pct < .01 and length(trim(left(text))) >  3 then text=trim(left(substr(text,1, 3)))||'...';
if id1pct < .03 and length(trim(left(text))) > 10 then text=trim(left(substr(text,1,10)))||'...';
if id1pct < .06 and length(trim(left(text))) > 16 then text=trim(left(substr(text,1,16)))||'...';
run;

data tree_anno; 
 set tree_labl tree_fram;
run;


/* Create a response data set, to control the colors of the areas.
   You could use the same variable the you used to size the treemap
   rectangles (such as Sales, in this example).  */
proc sql;
create table mydata as
select unique &idvar1, &idvar2,
 sum(&sumvar) format=dollar20.0 as &sumvar
from &dataset
group by &idvar1, &idvar2;
quit; run;

/* Add some html title= mouseover/rollover/charttip text for the tiles */
data mydata; set mydata;
length myhtml $500;
myhtml=
 'title='|| quote(
  "&idvar1: "||trim(left(&idvar1))||'0D'x||
  "&idvar2: "||trim(left(&idvar2))||'0D'x||
  "&sumvar: "||trim(left(put(&sumvar,dollar20.0))))||
 ' href="stimulus_info.htm"';
run;



goptions device=gif;
goptions xpixels=1400 ypixels=600;
goptions noborder;
/* Get rid of the ods style background image */
goptions iback=' ';

ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm"
 (title="Stimulus Package Proposal tree map (using 1/28/2009 data)")
 style=gears;

goptions ftitle="albany amt" ftext="albany amt" htitle=4.0pct htext=2.1pct;

title1 "Stimulus Package Proposal (28jan2009)";
title2 "size of blocks represents &sumvar $ / color of blocks represents &idvar1";
title3 "(mouse over blocks to see detail text)";

legend1 label=(position=top font="albany amt/bold" 'Category') position=(right middle) across=1 shape=bar(.15in,.15in) cborder=black;

proc gmap data=mydata map=here.stimmap all anno=tree_anno;
id &idvar1 &idvar2;
choro &idvar1 / coutline=grayee
 legend=legend1 html=myhtml
 des='' name="&name";
run;

 /* ------------------------- */

goptions xpixels=1100 ypixels=600;

pattern1 v=s c=white;
pattern2 v=s c=cxfee5d9;
pattern3 v=s c=cxfcae91;
pattern4 v=s c=cxfb6a4a;
pattern5 v=s c=cxde2d26;

/* change the annotated outline to black */
data tree_fram; set tree_fram; 
color='black'; 
run;

title2 "size of blocks represents &sumvar $ / color of blocks represents &sumvar $";
title3 "(mouse over blocks to see detail text)";

proc gmap data=mydata map=here.stimmap all anno=tree_anno;
id &idvar1 &idvar2;
choro &sumvar / levels=5 nolegend
 coutline=grayee html=myhtml
 des='' name="&name";
run;

proc sort data=&dataset out=&dataset; 
by &idvar1 &idvar2;
run;

title;
proc print data=&dataset noobs;
var &idvar1 &idvar2 &sumvar;
sum &sumvar;
run;

quit;
ODS HTML CLOSE;
ODS LISTING;
