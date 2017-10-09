%let name=col1;
filename odsout '.';

data my_data;
input CATEGORY SERIES $ 3-11 AMOUNT;
datalines;
1 Series A  5
2 Series A  7.8
1 Series B  9.5
2 Series B  5.9
;
run;

data my_data; set my_data;
length htmlvar $500;
htmlvar=
 'title='||quote( 
  'Category: '|| trim(left(category)) ||'0D'x||
  'Series: '|| trim(left(series)) ||'0D'x||
  'Amount: '|| trim(left(amount))  
  )||
 ' href="col1_info.htm"';
run;


goptions device=png;
goptions noborder;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" (title="SAS/Graph gchart Clustered Column") style=sasweb;

goptions gunit=pct htitle=6 ftitle="albany amt/bold" htext=4.25 ftext="albany amt/bold";

axis1 label=none value=none;  
axis2 label=(a=90 'AMOUNT') order=(0 to 10 by 2) minor=(number=1) offset=(0,0);
axis3 label=('CATEGORY') offset=(5,5);

pattern1 v=solid color=cx9999ff;  /* light blue */
pattern2 v=solid color=cx993366;  /* purplish */
pattern3 v=solid color=cxffffcc;  /* pale yellow */

title1 ls=1.5 "Clustered Column";
title2 "Compares values across categories";

proc gchart data=my_data; 
vbar series / discrete type=sum sumvar=amount 
 group=category subgroup=series 
 space=0 gspace=5
 maxis=axis1 raxis=axis2 gaxis=axis3 
 autoref clipref cref=graycc
 nolegend coutline=black 
 html=htmlvar
 des='' name="&name";  
run;

quit;
ODS HTML CLOSE;
ODS LISTING;


*---3d column---*;
%let name=col2;
filename odsout '.';

data my_data;
input CATEGORY SERIES $ 3-11 AMOUNT;
datalines;
1 Series A  5
2 Series A  7.8
1 Series B  9.5
2 Series B  5.9
;
run;

data my_data; set my_data;
length htmlvar $500;
htmlvar=
 'title='||quote( 
  'Category: '||trim(left(category))||'0D'x||
  'Series: '||trim(left(series))||'0D'x||
  'Amount: '||trim(left(amount))  
  )||
 ' href="col2_info.htm"';
run;

run;


goptions device=png;
goptions noborder;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" (title="SAS/Graph gchart Clustered Column (3D)") style=sasweb;

goptions gunit=pct htitle=6 ftitle="albany amt/bold" htext=4.25 ftext="albany amt/bold";

axis1 label=none value=none;  
axis2 label=(a=90 'AMOUNT') order=(0 to 10 by 2) minor=(number=1) offset=(0,0);
axis3 label=('CATEGORY') offset=(7,5);

pattern1 v=solid color=cx9999ff;  /* light blue */
pattern2 v=solid color=cx993366;  /* purplish */
pattern3 v=solid color=cxffffcc;  /* pale yellow */

title1 ls=1.5 "Clustered Column";
title2 "With 3-D Visual Effect";

proc gchart data=my_data; 
vbar3d series / discrete type=sum sumvar=amount nolegend
 group=category subgroup=series 
 space=0 gspace=8
 maxis=axis1 raxis=axis2 gaxis=axis3 
 autoref clipref cref=graycc
 coutline=black cframe=white 
 html=htmlvar
 des='' name="&name";  
run;

quit;
ODS HTML CLOSE;
ODS LISTING;


*---stack column---*;
%let name=col3;
filename odsout '.';

data my_data;
input CATEGORY SERIES $ 3-11 AMOUNT;
datalines;
1 Series A  5
2 Series A  6.8
3 Series A  9.2
1 Series B  6.5
2 Series B  6.9
3 Series B  5.6
;
run;

data my_data; set my_data;
length htmlvar $500;
htmlvar=
 'title='||quote( 
  'Category: '||trim(left(category))||'0D'x||
  'Series: '||trim(left(series))||'0D'x||
  'Amount: '||trim(left(amount))  
  )||
 ' href="col3_info.htm"';
run;


goptions device=png;
goptions noborder;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" (title="SAS/Graph gchart Stacked Column") style=sasweb;

goptions gunit=pct htitle=6 ftitle="albany amt/bold" htext=4.25 ftext="albany amt/bold";

axis1 label=('CATEGORY') offset=(8,8);
axis2 label=(a=90 'AMOUNT') order=(0 to 16 by 4) minor=(number=3) offset=(0,0);

pattern1 v=solid color=cx9999ff;  /* light blue */
pattern2 v=solid color=cx993366;  /* purplish */
pattern3 v=solid color=cxffffcc;  /* pale yellow */

title1 ls=1.5 "Stacked Column";
title2 "Compares the contribution of each value";
title3 "to a total across categories";

proc gchart data=my_data; 
vbar category / discrete type=sum sumvar=amount nolegend
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


*---stacked column£¨3d)---*;
%let name=col4;
filename odsout '.';

data my_data;
input CATEGORY SERIES $ 3-11 AMOUNT;
datalines;
1 Series A  5
2 Series A  6.8
3 Series A  9.2
1 Series B  6.5
2 Series B  6.9
3 Series B  5.6
;
run;

data my_data; set my_data;
length htmlvar $500;
htmlvar=
 'title='||quote( 
  'Category: '||trim(left(category))||'0D'x||
  'Series: '||trim(left(series))||'0D'x||
  'Amount: '||trim(left(amount))  
  )||
 ' href="col4_info.htm"';
run;


goptions device=png;
goptions noborder;
 
ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" (title="SAS/Graph gchart Stacked Column (3D)") style=sasweb;

goptions gunit=pct htitle=6 ftitle="albany amt/bold" htext=4.25 ftext="albany amt/bold";

axis1 label=('CATEGORY') offset=(10,8);
axis2 label=(a=90 'AMOUNT') order=(0 to 16 by 4) minor=(number=3) offset=(0,0);

pattern1 v=solid color=cx9999ff;  /* light blue */
pattern2 v=solid color=cx993366;  /* purplish */
pattern3 v=solid color=cxffffcc;  /* pale yellow */

title1 ls=1.5 "Stacked Column";
title2 "With a 3D Visual Effect";

proc gchart data=my_data; 
vbar3d category / discrete type=sum sumvar=amount nolegend
 subgroup=series 
 autoref clipref cref=graycc
 maxis=axis1 raxis=axis2
 cframe=white coutline=black 
 width=8 space=6
 html=htmlvar
 des='' name="&name";  
run;

quit;
ODS HTML CLOSE;
ODS LISTING;


