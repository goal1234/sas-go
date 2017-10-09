*------------------------------------------- PROC GMAP - Geographical Maps---------------------------------------*;
%let name=so4map;
filename odsout '.';

/*
Saw Robert Cohen showing an IML Workshop demo at NESUG where they  
took the SO4 readings from various parts of the US and then estimated
values for each county (using Loess), and then drew a US map shaded
by the SO4 concentration, using their IML workshop language's 
"drawpolygon" (I believe).  I got a copy of their dataset from Rick Wicklin.
It had the long/lat coordinates for each county, along with the final
estimated county values.  I plotted it using GMAP, and tried to 
hook-in many of the neat sas/graph & ods features. 
*/

goptions reset=global;

libname here '.' $mixed_case=yes;

/* or here's an alternate libname, if you're accessing the data over the network */
/*
libname here '\\sashq\root\u\realliso\public_html\democd1\' $mixed_case=yes;
*/

proc sql;
/* Select one data obs for each county, ignoring the long/lat county outlines */
 create table SO4_data as
  select unique state, county, LoessFitSO4 format=comma4.2 label='SO4 Concentration'
  from here.so4data;
/* and get the county name */
 create table SO4_data as
  select SO4_data.*, cntyname.countynm
  from SO4_data left join maps.cntyname
  on SO4_data.state=cntyname.state and SO4_data.county=cntyname.county;
quit; run;

/* Add html flyover chart tips, and set up a drilldown */
data SO4_data; set SO4_data;
length htmlvar $1024;
htmlvar= 
 'title='||quote( 
  trim(left(propcase(countynm)))||' county, '||trim(left(fipstate(state)))||'0D'x||
  trim(left(put(LoessFitSO4,comma7.3))) 
  )||
 /* This could be a drilldown to a county report, rather than state (if I had such a report available) */
 ' href='||quote('http://www.epa.gov/aboutepa/states/'||trim(left(lowcase(fipstate(state))))||'.html');
run;

/* Create state outlines (annotate dataset) from maps.uscounty map */
/* Just get the 48 continental states */
data uscounty;
   set maps.uscounty;
   where fipstate(state) not in ('AK' 'HI');
   run;

/* Remove all internal county boundaries, just keeping the state outline */
proc gremove data=uscounty out=outline;
   by STATE; id COUNTY;
   run;

/* Create the annotate dataset to outline the states on the county map */
data outline;
set outline; by STATE SEGMENT notsorted;
length function $8 color $8;
color='gray'; style='mempty'; when='a'; xsys='2'; ysys='2';
if first.SEGMENT then FUNCTION='Poly';
else function='Polycont';
run;



goptions device=png xpixels=800 ypixels=600;;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" (title="SO4 Concentration") style=statistical;

/* the ods style, combined with 'border' goption, produced 3d border */
goptions border cback=cx00BFFF gunit=pct htext=2.5 ftitle="albany amt" ftext="albany amt/bold";

title1 ls=1.5 h=5 
 link="http://en.wikipedia.org/wiki/Sulfate"
 "SO" move=(-0,-2) height=4 '4' move=(+0,+2) h=5 
 " Concentration (estimated using Loess)";

title2 h=2.75pct 
 link="http://support.sas.com/documentation/cdl/en/graphref/63022/HTML/default/viewer.htm#a000729027.htm"
 "Plotted using SAS/Graph PROC GMAP and ODS HTML Overlay";

title3 h=2.75pct 
 link="http://robslink.com/SAS/book/example12_info.htm"
 "County map, with annotated state outlines";

footnote h=2.75pct 
 link="http://robslink.com/SAS/democd23/aaaindex.htm"
 "Mouse over areas to see county name and SO4 value";

footnote2 h=2.75pct 
 link="http://www.epa.gov/airdata/"
 "Click on states to go to their EPA page";

/* colors from green->red (not 'exactly' continuous, but close enough */
/* v=s is for 'solid' color, the 'cx' values are hexadecimal rgb colors */
pattern1  v=s c=cx00ff00;
pattern2  v=s c=cx35ff00;
pattern3  v=s c=cx65ff00;
pattern4  v=s c=cx88ff00;
pattern5  v=s c=cx9aff00;
pattern6  v=s c=cxbaff00;
pattern7  v=s c=cxccff00;
pattern8  v=s c=cxd0ff00;
pattern9  v=s c=cxe0ff00;
pattern10 v=s c=cxffff00;
pattern11 v=s c=cxffee00;
pattern12 v=s c=cxffe000;
pattern13 v=s c=cxffdd00;
pattern14 v=s c=cxffdc00;
pattern15 v=s c=cxffd800;
pattern16 v=s c=cxffd100;
pattern17 v=s c=cxffcd00;
pattern18 v=s c=cxffc000;
pattern19 v=s c=cxffb700;
pattern20 v=s c=cxff9a00;
pattern21 v=s c=cxff8700;
pattern22 v=s c=cxff7700;
pattern23 v=s c=cxff5400;
pattern24 v=s c=cxff3400;
pattern25 v=s c=cxff0000;

/* Modify data county's county number, so it will match with the v9.2 maps.uscounty */
data SO4_data; set SO4_data;
if (state = stfips('FL')) and (county eq 25) then county=86;
run;

proc gmap data=SO4_data map=maps.uscounty anno=outline; 
 id state county;  
 choro LoessFitSO4 / levels=25  nolegend
  coutline=same
  html=htmlvar  
  des='' name="&name";
run;

quit;
ODS HTML CLOSE;
ODS LISTING;


*---------------------------------------------------------------------------------------------------*;
%let name=globe;
filename odsout '.';

%let long_min=-180; 
%let long_max=180; 
%let lat_min=-90;  
%let lat_max=90;  
/*
%let lat_min=-50;  
%let lat_max=50;  
*/
%let long_inc=10; 
%let lat_inc=10;  

%let rtd=57.296;  

/* this datastep will create a rectangular longitude/latitude grid. */
data globe;
length myid $16 function $8 html $300 color $8;
 do long= &long_min to (&long_max-&long_inc) by &long_inc; 
    do lat= &lat_min to (&lat_max-&lat_inc) by &lat_inc; 

      myid='long'||trim(left(long))||'_'||'lat'||trim(left(lat)); 
      segment=1;
      anno_flag=1;  /* use to separate from actual map, after gproject */

      /* extra stuff, to use as 'annotate' data set later */
      xsys='2';
      ysys='2';
      hsys='2';
      when='b';  /* a=draw after drawing map, b=draw before drawing map (ie, behind) */
      /* with solid-color annotated polygon, you must draw behind/before map */

      /* html mouse-over text, and drilldown to Google satellite image */
      html= 
       'title='||
       quote('long/lat center: '||
        trim(left(long+(&long_inc/2)))||' / '||
        trim(left(lat+(&lat_inc/2))) )|| 
       ' href='||quote('http://maps.google.com/maps?hl=en&ll='||
        trim(left(lat+(&lat_inc/2)))||','||
        trim(left(long+(&long_inc/2)))||'&z=7');


      function='poly';  /* function name to use in annotate */
      style='solid'; color='cx00bfff'; /* fill color */
      x=(long/&rtd); y=(lat/&rtd); output;  

      function='polycont';  /* function name to use in annotate */
      color='gray77';  /* outline color */
      x=x+(&long_inc/&rtd); output;  
      y=y+(&lat_inc/&rtd); output;   
      x=x-(&long_inc/&rtd); output;  
      y=y-(&lat_inc/&rtd); output;   

      end;
    end;
run;

/* Create character 'id' in world map, so it can be combined with long/lat grid */
proc sql;
create table world as
select id, segment, lat as y, long*-1 as x
from maps.world
where density <= 1;
quit; run;
data world; set world;
length myid $8.;
myid=trim(left(id));
run;


/* Combine map & long/lat grid, so they can be projected together */
data combined; set globe world; run;
%let project=Hammer;
proc gproject data=combined out=combined 
 project=&project eastlong dupok
  latmax=&lat_max latmin=&lat_min
  longmax=&long_max longmin=&long_min; 
 id myid; 
run;
data my_map my_anno;
  set combined;
  if anno_flag=1 then output my_anno;
  else output my_map;
run;


goptions device=png;
goptions cback=cxcccc99;
goptions border;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" (title="Globe Hammer Projection") style=d3d;

goptions ftitle="albany amt/bold" ftext="albany amt" htitle=2.5 htext=1.5;

pattern v=solid c=cx848421 r=500;

title1 ls=1.5 "SAS &project Projection";
title2 "(long/lat grid produced with annotate polygons)";

/* add some 'fake' titles on left & right to add more space for map */
title4 a=90 h=3pct " ";
title5 a=-90 h=3pct " ";

footnote1 "Hover over grid to see long/lat";
footnote2 "Click on grid to see mapquest map of that area";

proc gmap data=my_map map=my_map anno=my_anno; 
id myid; 
 choro segment / coutline=black nolegend 
 des='' name="&name"; 
run;

quit;
ODS HTML CLOSE;
ODS LISTING;

*---------------------------------------------some statistic----------------------------------*;
%let name=scot;
filename odsout '.';

/* SAS GMAP imitation of ...
   http://www.neighbourhood.statistics.gov.uk/scotland.asp
   This is just a quick mock-up/proof-of-concept.  The data values,
   and the names, are not really correct -- I have just estimated them
   to be 'somewhat' like the map I was trying to copy, but I didn't 
   have the actual data, nor the exact same map, so mine isn't an
   exact imitation, and the values and names are therefore not 
   actually correct.  (Robert Allison - Central Testing, Cary, NC USA)

   For the links, I link to the actual data server in the UK.
   The final map could be set up this way also, or a sas/intrnet server
   could be set up, which would accept similar url's which pass in 
   similar parameters in the URL, and generate tables on-the-fly.
*/

/* Create a data set with just the Scotland areas of the UK */
proc sql;
 create table scotdata as
 select * from maps.uk2
 where region='S';
quit; run;


/* Fake up some data, like the data in the example I'm trying to imitate */
data scotdata; set scotdata;
 /* Some numbers to resemble the ones on the real map */
 if (id eq 79) then rednum=17;
 if (id eq 78) then rednum=2;
 if (id eq 84) then rednum=24;
 if (id eq 83) then rednum=29;
 if (id eq 85) then rednum=13;
 if (id eq 75) then rednum=30;
 if (id eq 76) then rednum=6;
 if (id eq 80) then rednum=12;
 if (id eq 77) then rednum=15;
 if (id eq 74) then rednum=26;
 if (id eq 81) then rednum=23;
 if (id eq 82) then rednum=27;
 /* Some response values to resemble the real map */
 if (id eq 79) then density=50;
 if (id eq 78) then density=60;
 if (id eq 84) then density=90;
 if (id eq 83) then density=250;
 if (id eq 85) then density=50;
 if (id eq 75) then density=2600;
 if (id eq 76) then density=125;
 if (id eq 80) then density=250;
 if (id eq 77) then density=600;
 if (id eq 74) then density=55;
 if (id eq 81) then density=20;
 if (id eq 82) then density=30;
 /* Assign some text that will be used to build href */
 if (id eq 79) then la='QT';
 if (id eq 78) then la='QB';
 if (id eq 84) then la='RB';
 if (id eq 83) then la='RF';
 if (id eq 85) then la='RJ';
 if (id eq 75) then la='RG';
 if (id eq 76) then la='QH';
 if (id eq 80) then la='QP';
 if (id eq 77) then la='QR';
 if (id eq 74) then la='QE';
 if (id eq 81) then la='RA';
 if (id eq 82) then la='RD';
run;

/* the HREF is the drilldown, and the ALT is the flyover/charttip */
data scotdata; set scotdata;
length htmlvar $ 300;
/*
drillvar='HREF="http://www.neighbourhood.statistics.gov.uk/ward.asp?la='|| trim(left(la))||'"';
*/
/* The detailed pages went away, so linking to higher-level page */
drillvar='HREF="http://neighbourhood.statistics.gov.uk"';
altvar = 'title="Area Name: ' || trim(left(idname)) || '0D'x || 
              'Area Map ID number: ' || id || '0D'x ||
              'Population Density: ' || density || '"';
htmlvar = drillvar || ' ' || altvar;
run;

/* Now, create the annotate dataset, containing the red numbers */
proc sql;
/* Estimate the center of each map area (easier to use 'centroid' macro in v9) */
create table maplabel as
select unique id, avg(x) as x, avg(y) as y
from maps.uk
where id^=999
group by id;
/* Get the value for the red number of each map area */
create table maplabel as
select maplabel.*, scotdata.rednum
from maplabel inner join scotdata
on maplabel.id=scotdata.id;
quit; run;
/* Now, add the required variables for an annotate dataset */
data maplabel;
length text $ 50;
xsys='2'; ysys='2'; hsys='3'; when='a';
color='red'; function='label';
set maplabel;
size=3.5; style='albany amt/bold'; position='5';
text=trim(left(rednum));
run;

data other_anno;
   length  function style $8 html $300 text $50;
   xsys='3'; ysys='3'; hsys='3'; when='a';

   html='title="Ask Magnus for help on this page!" href="http://www.neighbourhood.statistics.gov.uk/howto.asp#Maps"';
   function='move'; x=65; y=8; output;
   function='image'; x=x+10; y=y+18; imgpath='help_click.gif'; style='fit'; output;

   html='';
   function='move'; x=91; y=0; output;
   function='image'; x=x+9; y=y+6; imgpath='bus.gif'; style='fit'; output;

   /* Add a text label centered above top/right corner of image */
   /* This part could be calculated from the data, but I'm just hard-coding it ... */
   function='label'; size=2.5; style=''; color='blue'; position='F'; 
   x=70; 
   y=95;
   html='title="Aberdeenshire" href="http://www.neighbourhood.statistics.gov.uk/ward.asp?la=QB"';
   text='2. Aberdeenshire'; output;
   y=y-2.5;
   html='title="Dumfries and Galloway" href="http://www.neighbourhood.statistics.gov.uk/ward.asp?la=QH"';
   text='6. Dumfries and Galloway';  output;
   y=y-2.5;
   html='title="Edinburgh" href="http://www.neighbourhood.statistics.gov.uk/ward.asp?la=QP"';
   text='12. Edinburgh';  output;
   y=y-2.5;
   html='title="Eilean Siar" href="http://www.neighbourhood.statistics.gov.uk/ward.asp?la=RJ"';
   text='13. Eilean Siar (Western Isles)';  output;
   y=y-2.5;
   html='title="Fife" href="http://www.neighbourhood.statistics.gov.uk/ward.asp?la=RQ"';
   text='15. Fife';  output;
   y=y-2.5;
   html='title="Highland" href="http://www.neighbourhood.statistics.gov.uk/ward.asp?la=QT"';
   text='17. Highland';  output;
   y=y-2.5;
   html='title="Orkney Islands" href="http://www.neighbourhood.statistics.gov.uk/ward.asp?la=RA"';
   text='23. Orkney Islands';  output;
   y=y-2.5;
   html='title="Perth and Kinross" href="http://www.neighbourhood.statistics.gov.uk/ward.asp?la=RB"';
   text='24. Perth and Kinross';  output;
   y=y-2.5;
   html='title="Scottish Borders, The" href="http://www.neighbourhood.statistics.gov.uk/ward.asp?la=QE"';
   text='26. Scottish Borders, The';  output;
   y=y-2.5;
   html='title="Shetland Islands" href="http://www.neighbourhood.statistics.gov.uk/ward.asp?la=RD"';
   text='27. Shetland Islands';  output;
   y=y-2.5;
   html='title="South Lanarkshire" href="http://www.neighbourhood.statistics.gov.uk/ward.asp?la=RF"';
   text='29. South Lanarkshire';  output;
   y=y-2.5;
   html='title="Stirling" href="http://www.neighbourhood.statistics.gov.uk/ward.asp?la=RG"';
   text='30. Stirling';  output;

   /* Draw the line at the bottom of the page */
   function='move';
   x=0; y=0;
   output;
   function='draw';
   line=1;  size=.25; color=cx04025F;
   x=100;
   output;
run;

/* Combine my 2 annotate datasets */
data maplabel; set maplabel other_anno; run;


/* I'm using a snapshot/jpg of the title banner here.  In real-life, the 
   user will probably want to create the banner using whatever method they
   are currently using, so that it will be 'clickable', instead of this
   ods template banner technique. 
   Also, I'm just doing a quick-n-dirty here - in real-life you'd want to
   fill in all the values for the template (otherwise you get warnings in
   the log).
*/
ods path template(update) sashelp.tmplmst;
proc template;
 define style styles.scotstyl;
   parent = styles.default;
   style  Body from Document /
     prehtml = "<table width=100%><td align=left>
      <img src=""./scotland_stat.jpg"">
      </table>"
   ;
   replace color_list /
     "white"  = cxffffff
     "black"  = cx000000
     "dblue"  = cx000067
   ;
   replace colors /
      "docbg"          = color_list("white")
      "link1"          = color_list("white")
      "link2"          = color_list("white")
   ;
   end;
run;


goptions device=png;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm"
 (title="Scotland Statistics Map")
 style=scotstyl;

goptions ftitle="albany amt" ftext="albany amt" htext=2.9pct /* hsize=7in vsize=5.5in */ ;
 
footnote1 h=2.5pct f="albany amt" c=cx04025F 
  link="http://www.neighbourhood.statistics.gov.uk/scotland.asp" 
  "Imitation of Scotland National Statistics map";

legend1 position=(bottom left) across=1 shape=bar(3.5,1) 
   value=(color=cx04025F)
   label=(color=cx04025F 
    position=(top) 
    j=l
    'population density, 1998' 
    j=l 
    font=marker 'QR '
    font="albany amt"
    '(persons per sq km)') 
   mode=share;

/* Set the shades of purple, using hexadecimal RGB colors */
pattern1 v=solid color=cxDDDDFF;
pattern2 v=solid color=cxBFBFE5;
pattern3 v=solid color=cx9E9EC7;
pattern4 v=solid color=cx6967A1;
pattern5 v=solid color=cx2A2A84;
pattern6 v=solid color=cx04025F;

proc gmap data=scotdata map=maps.uk annotate=maplabel; 
id id; 
choro density / levels=6 
 coutline=cx04025F 
 legend=legend1 
 html=htmlvar 
 des='' name="&name"; 
run;

quit;
ODS HTML CLOSE;
ODS LISTING;

*------------------------------------------------------------衣服销量地图--------------------------------*;
%let name=piemap;
filename odsout '.';

%let cmale=cx42C0FB;
%let cfemale=hotpink;

libname datalib '.' access=readonly ;

proc sql; 
create table my_data as 
select year, st as st_name, stfips(st) as state, 
 'dept stores' as store, 
 fem_dept/1000000 as female, 
 mal_dept/1000000 as male    
from datalib.smm 
where (year = 1990); 
quit; run; 

data my_data; set my_data; 
value=female+male; 
run; 

%let max_area=50; 
 
proc sql; 
 
/* Find the maximum value */ 
select max(value) format=comma8.2 into :max_val from my_data; 
 
/* Scale data values to dot areas */ 
create table my_data as 
select unique st_name, state, female, male, value, 
(value/&max_val)*&max_area as area 
from my_data 
order by value descending; /* so small dots are on top */ 
 
/* Calculate the radius (size) for the areas and 
   get coordinates for the center or each state */ 
create table my_data2 as 
select my_data.*, .2 + sqrt(my_data.area/3.14) as size, uscenter.* 
from my_data, maps.uscenter 
where my_data.state=uscenter.state; 
quit; run; 


/* Create dataset containing the dots */ 
data dots; 
length html $500 function color $8; 
set my_data2; 

mp=male/value;
fp=female/value;
html=
 'title='||quote(
  'State: '||trim(left(fipnamel(state)))||'0D'x||
  'Male Sales   (in billion $): '||put(male,comma10.2)||    '  ('||put(mp,percent6.0)||')'||'0D'x||
  'Female Sales (in billion $): '||put(female,comma10.2)||'  ('||put(fp,percent6.0)||')'||'0D'x||
  '------------------------------------------- '||'0D'x||
  'Total Sales  (in billion $): '||put(value,comma10.2)
  )||
 ' href='||quote('#'||trim(left(st_name)));

 xsys='2'; ysys='2'; hsys='3'; when='a'; 
 function='PIE'; line=0; 
 style='psolid'; percent=female/value*100; 
 rotate=percent*360/100; 
 color="&cfemale";  if ocean~='Y' then output; 
 percent=male/value*100; rotate=percent*360/100; 
 color="&cmale"; if ocean~='Y' then output; 
 line=0; style='pempty'; color='gray33'; 
 angle=0.0; rotate=360.0; 
 if ocean~='Y' then output; 
run; 
 
data legend; 
 length function text color $8; 
 xsys='2'; ysys='2'; hsys='3'; when='A'; 
 color="&cfemale";  line=0; angle=0.0; rotate=360.0; 
 function='pie'; size=1.5; 
 style='psolid'; x=.17; y=.23; output; 
 color="&cmale"; x=.17; y=.20; output; 
 color="black";
 function='LABEL'; size=3; style=''; position='6'; 
 text='female'; x=.19; y=.235; output; 
 text='male  '; x=.19; y=.205; output; 
run; 
 
data dots; 
 set dots legend; 
run; 



/* This is something I added in 2007 - it creates a bunch of tables below the map
   (one table for each state) with html anchor tags, so I can "drilldown" to them.
*/
%macro do_table(statecode);
%local data_name statecode;

 proc sql noprint;
 create table foo as select * from datalib.smm where st="&statecode";
 select unique state into :statename separated by ' ' from foo;
 quit; run;

 data foo; set foo;
 fem_dept=fem_dept*1000;
 mal_dept=mal_dept*1000;
 female_percent=fem_dept/(fem_dept+mal_dept);
 male_percent=mal_dept/(fem_dept+mal_dept);
 run;

 
 options nocenter;
 ods html anchor="&statecode";

 title1 ls=2.0 c=black
  "Clothing Sales in Department Stores in ... " f="albany amt/bold" "&statename";

 goptions xpixels=500 ypixels=200 htitle=8pct htext=6pct;

 symbol1 c=&cfemale i=join v=dot;
 symbol2 c=&cmale  i=join v=dot;

 axis1 label=none minor=none order=(0 to 1 by .25) offset=(0,0);
 axis2 label=none minor=none offset=(0,0);

 goptions noborder;
 proc gplot data=foo;
 format female_percent male_percent percent7.0;
 title2 c=&cfemale "----  Female     " c=&cmale "---- Male";
 footnote;

 plot female_percent*year=1 male_percent*year=2 / overlay
  vaxis=axis1 haxis=axis2 noframe
  vref=.5 cvref=graycc lvref=3
  des='' name="plt.&statecode";
 run;

 title2;
 proc print data=foo noobs label;
 format fem_dept mal_dept dollar25.0;
 format female_percent male_percent percent7.0;
 label fem_dept='Female';
 label mal_dept='Male';
 label female_percent='Female %';
 label male_percent='Male %';
 var year fem_dept mal_dept female_percent male_percent;
 run;

%mend do_table;

 
options ls=80 ps=1000 nocenter nodate; 
 
goptions device=png;
goptions noborder;

ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" 
 (title="Clothing Sales pie-chart Map")
 options(pagebreak='no') style=htmlblue;

goptions gunit=pct htitle=5.0 htext=3.0 ftitle="albany amt/bold" ftext="albany amt" ctext=black; 

title1 ls=1.5 'Clothing Sales in Department Stores';
title2 'Year = 1990';

footnote1 h=2.3 
 j=l link="http://www.salesandmarketing.com"
 '  Data Source: Sales & Marketing Mgmt. Magazine '
 j=r link="http://robslink.com/tabis/phd_1991_1996/chapter6.htm#6.2.4" 
 'NCSU Textile/Apparel Business Information System (TABIS)  '; 
footnote2 h=1 ' ';

/* Plot the dots on a US map */ 
pattern1 v=solid c=white; 
goptions border;
proc gmap data=maps.us map=maps.us (where=(state^=stfips('PR'))) anno=dots; 
id state; 
choro state / levels=1 nolegend 
coutline=gray55
des='' name="&name"; 
run; 


/*
Loop through all the states, and call the macro to generate the drilldown graph
*/
proc sql noprint;
create table states as select unique st from datalib.smm;
quit; run;

data _null_;
 set states;
   call execute('%do_table('||st||');');
 call execute('run;');
run;

quit;
ODS HTML CLOSE;
ODS LISTING;
