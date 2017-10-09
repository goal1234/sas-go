*---100%---*;
%let name=col5;
filename odsout '.';

data my_data;
input CATEGORY SERIES $ 3-11 AMOUNT;
datalines;
1 Series A  5.0
2 Series A  6.8
3 Series A  9.2
1 Series B  6.5
2 Series B  6.9
3 Series B  5.6
1 Series C  2.3
2 Series C  3.1
3 Series C  2.3
;
run;

proc sql;
 create table my_data as
 select *, sum(amount) as bartotal
 from my_data
 group by category;
quit; run;

data my_data; set my_data;
format catpct percent6.0;
catpct=amount/bartotal;
run;

data my_data; set my_data;
length htmlvar $500;
htmlvar=
 'title='||quote( 
  'Category: '||trim(left(category))||'0D'x||
  'Series: '||trim(left(series))||'0D'x||
  'Amount: '||trim(left(amount))||'0D'x||
  'Percent: '||trim(left(put(catpct,percent6.0)))||' of '||trim(left(bartotal)) 
  )||
 ' href="col5_info.htm"';
run;


goptions device=png;
goptions noborder;

ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" (title="SAS/Graph gchart 100% Stacked Column") style=sasweb;

goptions gunit=pct htitle=6 ftitle="albany amt/bold" htext=4.25 ftext="albany amt/bold";

axis1 label=('CATEGORY') offset=(8,8);
axis2 label=(a=90 'PERCENT') order=(0 to 1 by .2) minor=(number=1) offset=(0,0);

pattern1 v=solid color=cx9999ff;  /* light blue */
pattern2 v=solid color=cx993366;  /* purplish */
pattern3 v=solid color=cxffffcc;  /* pale yellow */

title1 ls=1.5 "100% Stacked Column";
title2 "Compares the percent each value contributes";
title3 "to a total across categories";

proc gchart data=my_data; 
vbar category / discrete type=sum sumvar=catpct nolegend
 subgroup=series 
 autoref clipref cref=graycc
 maxis=axis1 raxis=axis2
 coutline=black 
 width=8 space=3
 html=htmlvar
 des='' name="&name";  
run;

quit;
ODS HTML CLOSE;
ODS LISTING;

*---1003d---*;
%let name=col6;
filename odsout '.';

data my_data;
input CATEGORY SERIES $ 3-11 AMOUNT;
datalines;
1 Series A  5.0
2 Series A  6.8
3 Series A  9.2
1 Series B  6.5
2 Series B  6.9
3 Series B  5.6
1 Series C  2.3
2 Series C  3.1
3 Series C  2.3
;
run;

proc sql;
 create table my_data as
 select *, sum(amount) as bartotal
 from my_data
 group by category;
quit; run;

data my_data; set my_data;
format catpct percent6.0;
catpct=amount/bartotal;
run;

data my_data; set my_data;
length htmlvar $500;
htmlvar=
 'title='||quote( 
  'Category: '||trim(left(category))||'0D'x||
  'Series: '||trim(left(series))||'0D'x||
  'Amount: '||trim(left(amount))||'0D'x||
  'Percent: '||trim(left(put(catpct,percent6.0)))||' of '||trim(left(bartotal)) 
 )||
 ' href="col6_info.htm"';
run;


goptions device=png;
goptions noborder;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" (title="SAS/Graph gchart 100% Stacked Column (3D)") style=sasweb;

goptions gunit=pct htitle=6 ftitle="albany amt/bold" htext=4.25 ftext="albany amt/bold";

axis1 label=('CATEGORY') offset=(10,8);
axis2 label=(a=90 'PERCENT') order=(0 to 1 by .2) minor=(number=1) offset=(0,0);

pattern1 v=solid color=cx9999ff;  /* light blue */
pattern2 v=solid color=cx993366;  /* purplish */
pattern3 v=solid color=cxffffcc;  /* pale yellow */

title1 ls=1.5 "100% Stacked Column";
title2 "With 3D Visual Effect";

proc gchart data=my_data; 
vbar3d category / discrete type=sum sumvar=catpct 
 subgroup=series 
 autoref clipref cref=graycc
 maxis=axis1 raxis=axis2
 coutline=black cframe=white nolegend
 width=8 space=6
 html=htmlvar
 des='' name="&name";  
run;

quit;
ODS HTML CLOSE;
ODS LISTING;

*---100stacked---*;
%let name=bar5;
filename odsout '.';

data my_data;
input CATEGORY SERIES $ 3-11 AMOUNT;
datalines;
1 Series A  5.0
2 Series A  6.8
3 Series A  9.2
1 Series B  6.5
2 Series B  6.9
3 Series B  5.6
1 Series C  2.3
2 Series C  3.1
3 Series C  2.3
;
run;

proc sql;
 create table my_data as
 select *, sum(amount) as bartotal
 from my_data
 group by category;
quit; run;

data my_data; set my_data;
format catpct percent6.0;
catpct=amount/bartotal;
run;

data my_data; set my_data;
length htmlvar $500;
htmlvar=
 'title='||quote( 
  'Category: '|| trim(left(category)) ||'0D'x||
  'Series: '|| trim(left(series)) ||'0D'x||
  'Amount: '|| trim(left(amount)) ||'0D'x||
  'Percent: '|| trim(left(put(catpct,percent6.0)))||' of '||trim(left(bartotal)) 
  )||
 ' href="bar5_info.htm"';
run;


goptions device=png;
goptions noborder;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" (title="SAS/Graph gchart 100% Stacked Bar") style=sasweb;

goptions gunit=pct htitle=6 ftitle="albany amt/bold" htext=4.25 ftext="albany amt/bold";

axis1 label=('CATEGORY') offset=(11,11);
axis2 label=('PERCENT') order=(0 to 1 by .2) minor=(number=1) offset=(0,0);

pattern1 v=solid color=cx9999ff;  /* light blue */
pattern2 v=solid color=cx993366;  /* purplish */
pattern3 v=solid color=cxffffcc;  /* pale yellow */

title1 ls=1.5 "100% Stacked Bar";
title2 "Compares the percent each value contributes";
title3 "to a total across categories";

proc gchart data=my_data; 
hbar category / discrete type=sum sumvar=catpct nostats nolegend
 subgroup=series 
 autoref clipref cref=graycc
 maxis=axis1 raxis=axis2
 coutline=black space=2
 html=htmlvar
 des='' name="&name";  
run;

quit;
ODS HTML CLOSE;
ODS LISTING;

*---100%3d---*;
%let name=bar6;
filename odsout '.';

data my_data;
input CATEGORY SERIES $ 3-11 AMOUNT;
datalines;
1 Series A  5.0
2 Series A  6.8
3 Series A  9.2
1 Series B  6.5
2 Series B  6.9
3 Series B  5.6
1 Series C  2.3
2 Series C  3.1
3 Series C  2.3
;
run;

proc sql;
 create table my_data as
 select *, sum(amount) as bartotal
 from my_data
 group by category;
quit; run;

data my_data; set my_data;
format catpct percent6.0;
catpct=amount/bartotal;
run;

data my_data; set my_data;
length htmlvar $500;
htmlvar=
 'title='||quote( 
  'Category: '||trim(left(category))||'0D'x||
  'Series: '||trim(left(series))||'0D'x||
  'Amount: '||trim(left(amount))||'0D'x||
  'Percent: '||trim(left(put(catpct,percent6.0)))||' of '||trim(left(bartotal)) 
  )||
 ' href="bar6_info.htm"';
run;


goptions device=png;
goptions noborder;

ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" (title="SAS/Graph gchart 100% Stacked Bar") style=sasweb;

goptions gunit=pct htitle=6 ftitle="albany amt/bold" htext=4.25 ftext="albany amt/bold";

axis1 label=('CATEGORY') offset=(8,8);
axis2 label=('PERCENT') order=(0 to 1 by .2) minor=(number=1) offset=(0,0);

pattern1 v=solid color=cx9999ff;  /* light blue */
pattern2 v=solid color=cx993366;  /* purplish */
pattern3 v=solid color=cxffffcc;  /* pale yellow */

title1 ls=1.5 "100% Stacked Bar";
title2 "Compares the percent each value contributes";
title3 "to a total across categories";

proc gchart data=my_data; 
hbar3d category / discrete type=sum sumvar=catpct nostats nolegend
 subgroup=series /* this controls the coloring */
 autoref clipref cref=graycc space=4.0
 maxis=axis1 raxis=axis2
 cframe=white coutline=black 
 html=htmlvar
 des='' name="&name";  
run;

quit;
ODS HTML CLOSE;
ODS LISTING;

