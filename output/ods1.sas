* --- SAS µÄODS --- *;

* -EPUB;

ods html close;
data drugtest;
   input Drug $ PreTreatment PostTreatment @@;
   datalines;
A 11  6   A  8  0   A  5  2   A 14  8   A 19 11
A  6  4   A 10 13   A  6  1   A 11  8   A  3  0
D  6  0   D  6  2   D  7  3   D  8  1   D 18 18
D  8  4   D 19 14   D  8  9   D  5  1   D 15  9
F 16 13   F 13 10   F 11 18   F  9  5   F 21 23
F 16 12   F 12  5   F 12 16   F  7  1   F 12 20
;
ods epub file="glm.epub" title="My First ODS EPUB E-book"
options(creator="SAS Programmer" description="My First ODS EPUB Book" 
subject="PROC GLM" type="ODS EPUB book");

ods graphics on;
proc glm data=DrugTest;
   class Drug;
   model PostTreatment = Drug|PreTreatment;
run;
quit;

ods epub close; 


* ---EXECL--- ;
ods html close;
title "Custom Excel Output";
proc sort data=sashelp.cars out=cars;
   by make;
run;

ods tagsets.excelxp file="bylines.xls" style=htmlBlue 
      options( suppress_bylines='yes'  Embedded_Titles="yes"
              Sheet_Label="By" Frozen_Headers="yes");

proc print data=cars;
   var make model msrp invoice;
   by make;
run;

ods tagsets.excelxp close;

* ---html---*;
options nocenter;
ods html style=barrettsblue; 
title;
data;
   input region $ citysize $ pop product $ saletype $
        quantity amount;
   datalines;
   Brazil S   25000 A100 R 150   3750.00
   Canada S   37000 A100 R 200   5000.00
   France S   48000 A100 R 410  10250.00
   Mexico S   32000 A100 R 180   4500.00
   Brazil M  125000 A100 R 350   8750.00
   Canada M  237000 A100 R 600  15000.00
   France M  348000 A100 R 710  17750.00
   Mexico M  432000 A100 R 780  19500.00
   Canada L  837000 A100 R 800  20000.00
   France L  748000 A100 R 760  19000.00
   Mexico L  932000 A100 R 880  22000.00
   Brazil S   25000 A100 W 150   3000.00
   Canada S   37000 A100 W 200   4000.00
   Mexico S   32000 A100 W 180   3600.00
   Brazil M  125000 A100 W 350   7000.00
   Canada M  237000 A100 W 600  12000.00
   France M  348000 A100 W 710  14200.00
   Mexico M  432000 A100 W 780  15600.00
   Brazil L  625000 A100 W 750  15000.00
   Canada L  837000 A100 W 800  16000.00
   France L  748000 A100 W 760  15200.00
   Mexico L  932000 A100 W 880  17600.00
   Brazil S   25000 A200 R 165   4125.00
   Canada S   37000 A200 R 215   5375.00
   France S   48000 A200 R 425  10425.00
   Mexico S   32000 A200 R 195   4875.00
   Brazil M  125000 A200 R 365   9125.00
   Canada M  237000 A200 R 615  15375.00
   France M  348000 A200 R 725  19125.00
   Mexico M  432000 A200 R 795  19875.00
   Canada L  837000 A200 R 815  20375.00
   France L  748000 A200 R 775  19375.00
   Mexico L  932000 A200 R 895  22375.00
   Brazil S   25000 A200 W 165   3300.00
   Canada S   37000 A200 W 215   4300.00
   Mexico S   32000 A200 W 195   3900.00
   Brazil M  125000 A200 W 365   7300.00
   Canada M  237000 A200 W 615  12300.00
   France M  348000 A200 W 725  14500.00
   Mexico M  432000 A200 W 795  15900.00
   Brazil L  625000 A200 W 765  15300.00
   Canada L  837000 A200 W 815  16300.00
   France L  748000 A200 W 775  15500.00
   Mexico L  932000 A200 W 895  17900.00
   Brazil S   25000 A300 R 157   3925.00
   Canada S   37000 A300 R 208   5200.00
   France S   48000 A300 R 419  10475.00
   Mexico S   32000 A300 R 186   4650.00
   Brazil M  125000 A300 R 351   8725.00
   Canada M  237000 A300 R 610  15250.00
   France M  348000 A300 R 714  17850.00
   Mexico M  432000 A300 R 785  19625.00
   Canada L  837000 A300 R 806  20150.00
   France L  748000 A300 R 768  19200.00
   Mexico L  932000 A300 R 880  22000.00
   Brazil S   25000 A300 W 157   3140.00
   Canada S   37000 A300 W 208   4160.00
   Mexico S   32000 A300 W 186   3720.00
   Brazil M  125000 A300 W 351   7020.00
   Canada M  237000 A300 W 610  12200.00
   France M  348000 A300 W 714  14280.00
   Mexico M  432000 A300 W 785  15700.00
   Brazil L  625000 A300 W 757  15140.00
   Canada L  837000 A300 W 806  16120.00
   France L  748000 A300 W 768  15360.00
   Mexico L  932000 A300 W 880  17600.00
;
proc format;
    value $salefmt 'R'='Retail'
                  'W'='Wholesale';

proc tabulate style={foreground=green background=white};
    class region citysize saletype     / style={foreground=black};
    classlev region citysize saletype  / style={foreground=red};
    var quantity amount                / style={foreground=black};
    keyword all sum                    / style={foreground=purple };
    format saletype $salefmt.;
    label region="Region" citysize="Citysize" saletype="Saletype";
    label quantity="Quantity" amount="Amount";
    keylabel all="Total";   
    table all={label = "All Products" style={foreground=orange font_weight=bold}},
         (region all )*(citysize all*{style={foreground=CX002288 font_weight=bold}}),
         (saletype all)*(quantity*f=COMMA6. amount*f=dollar10.) /
          style={background=red} misstext={label="Missing" 
          style={foreground=brown font_weight=bold }}
          box={label="Region by Citysize by Saletype" 
          style={foreground=brown background=cxebdded}};
run;
ods html close;


* --- PDF Output --- *;
options center nodate;
ods pdf file="b.pdf" style=barrettsblue; 
title1 'TABULATE With Custom ODS Styles';

data tabulate;
   input dept acct qtr mon expense @@;
datalines;
1 1345 1 1 12980  1 1674 1 3 13135  3 4138 1 1 29930
1 1345 1 1 9475   1 1674 1 3 21672  3 4138 1 2 22530
1 1345 1 1 15633  1 1674 1 3 3847   3 4138 1 2 16446
1 1345 1 2 14009  1 1674 1 3 2808   3 4138 1 2 27135
1 1345 1 2 10226  1 1674 1 3 4633   3 4138 1 3 24399
1 1345 1 2 16872  2 2134 1 1 34520  3 4138 1 3 17811
1 1345 1 2 17800  2 2134 1 1 25199  3 4138 1 3 29388
1 1345 1 2 12994  2 2134 1 1 41578  3 4138 1 3 16592
1 1345 1 2 21440  2 2134 1 2 26560  3 4138 1 3 12112
1 1345 1 3 35300  2 2134 1 2 19388  3 4138 1 3 19984
1 1345 1 3 25769  2 2134 1 2 31990  3 4279 1 1 9984
1 1345 1 3 42518  2 2134 1 3 24399  3 4279 1 1 7288
1 1578 1 1 8000   2 2134 1 3 17811  3 4279 1 1 12025
1 1578 1 1 5840   2 2134 1 3 29388  3 4279 1 2 14209
1 1578 1 1 9636   2 2403 1 1 25464  3 4279 1 2 10372
1 1578 1 2 7900   2 2403 1 1 18588  3 4279 1 2 17113
1 1578 1 2 5767   2 2403 1 1 30670  3 4279 1 3 13500
1 1578 1 2 9515   2 2403 1 2 15494  3 4279 1 3 9855
1 1578 1 3 4500   2 2403 1 2 11310  3 4279 1 3 16260
1 1578 1 3 3285   2 2403 1 2 18661  3 4290 1 1 10948
1 1578 1 3 5420   2 2403 1 2 1482   3 4290 1 1 7992
1 1674 1 1 11950  2 2403 1 2 1081   3 4290 1 1 13186
1 1674 1 1 8723   2 2403 1 2 1783   3 4290 1 2 14539
1 1674 1 1 14392  2 2403 1 3 10009  3 4290 1 2 10613
1 1674 1 2 13534  2 2403 1 3 7306   3 4290 1 2 17511
1 1674 1 2 9879   2 2403 1 3 12054  3 4290 1 3 11459
1 1674 1 2 16300  3 4138 1 1 24850  3 4290 1 3 8365
1 1674 1 3 17994  3 4138 1 1 18140  3 4290 1 3 13802
;

proc format;
   value qtrfmt 1 = 'FIRST QUARTER'
                2 = 'SECOND QUARTER'
                3 = 'THIRD QUARTER'
                4 = 'FOURTH QUARTER';

   value monfmt 1 = 'January'
                2 = 'February'
                3 = 'March'
                4 = 'April'
                5 = 'May'
                6 = 'June'
                7 = 'July'
                8 = 'August'
                9 = 'September'
               10 = 'October'
               11 = 'November'
               12 = 'December';

   value dept   1 = 'Accounting'
                2 = 'Human Resources'
                3 = 'Systems';

proc tabulate format=dollar11.2;
   class mon qtr acct dept;
   classlev mon qtr acct dept  / style={fontstyle=italic color=yellow};
   var   expense;
   format qtr qtrfmt.;
   format mon monfmt.;
   format dept dept.;
   label expense = "Expenses" dept = "Department";
   table dept (all="All Departments"
              *{style={background=red color=white}}),
         (mon=' ' (all="First Quarter"
              *{style={background=red color=white}}))
              *expense*sum=' ' /
         style={background=CX9aadc7}
         box={style={backgroundimage="your image"}};
run;

ods pdf close; 

* ---PostScript Output--- *;
data grocery;
   input Sector $ Manager $ Department $ Sales @@;
   datalines;
se 1 np1 50    se 1 p1 100   se 1 np2 120   se 1 p2 80
se 2 np1 40    se 2 p1 300   se 2 np2 220   se 2 p2 70
nw 3 np1 60    nw 3 p1 600   nw 3 np2 420   nw 3 p2 30
nw 4 np1 45    nw 4 p1 250   nw 4 np2 230   nw 4 p2 73
nw 9 np1 45    nw 9 p1 205   nw 9 np2 420   nw 9 p2 76
sw 5 np1 53    sw 5 p1 130   sw 5 np2 120   sw 5 p2 50
sw 6 np1 40    sw 6 p1 350   sw 6 np2 225   sw 6 p2 80
ne 7 np1 90    ne 7 p1 190   ne 7 np2 420   ne 7 p2 86
ne 8 np1 200   ne 8 p1 300   ne 8 np2 420   ne 8 p2 125
;
proc format;
   value $sctrfmt 'se' = 'Southeast'
                  'ne' = 'Northeast'
                  'nw' = 'Northwest'
                  'sw' = 'Southwest';

   value $mgrfmt '1' = 'Malik'   '2' = 'Chang'
                 '3' = 'Reveiz'  '4' = 'Brown'
                 '5' = 'Taylor'  '6' = 'Adams'
                 '7' = 'Alomar'  '8' = 'Andrews'
                 '9' = 'Pelfrey';

   value $deptfmt 'np1' = 'Paper'
                  'np2' = 'Canned'
                  'p1'  = 'Meat/Dairy'
                  'p2'  = 'Produce';
run;

title 'Sales for Malik and Chang';
libname proclib 'SAS-library'; 
options nodate pageno=1 fmtsearch=(proclib); 
ods ps file='sales-ps-file.ps';

proc report data=grocery nowd headline headskip 
  style(report)=[cellspacing=5 borderwidth=10 bordercolor=blue]  
  style(column)=[foreground=moderate brown  fontweight=bold
               fontface=helvetica fontsize=4] 
  style(lines)=[foreground=white background=black
              fontstyle=italic fontweight=bold fontsize=5] 
  style(summary)=[foreground=white background=cxaeadd9 
                fontstyle=bold fontface=helvetica fontsize=3 just=r]; 
  column manager department sales; 
  define manager / order
                    order=formatted
                    format=$mgrfmt.
                    'Manager'style(header)=[foreground=cyan
                     background=black];
 
  define department / order
                      order=internal
                      format=$deptfmt.
                     'Department'style(column)=[fontstyle=italic];
 
   break after manager / summarize; 
   compute after manager
           / style=[fontstyle=roman fontsize=3 fontweight=bold
             background=white foreground=black];
 
            line 'Subtotal for ' manager $mgrfmt. 'is ' 
            sales.sum dollar7.2 '.';
   endcomp; 
   compute sales;
      if sales.sum>100 and _break_=' ' then
      call define(_col_, "style", 
                  "style=[background=#CCFF00 
                          fontface=helvetica 
                          fontweight=bold]");
   endcomp; 
   compute after;
       line 'Total for all departments: '
            sales.sum dollar7.2 '.';
   endcomp; 
   where sector='se';
run;
 
  
ods ps close;

*---PowerPoint ;
ods html close;
title1 'PowerPoint - Various Layouts and Styles';
footnote 'The PowerPoint Destination';

proc template; 
   define style styles.test; 
      parent= styles.powerpointlight; 
      class body / 
         backgroundimage="radial-gradient(40%, lightblue 40%, 
         yellow 30%, blue)"; ; 
      style graphbackground / image='c:\Public\foldedblends.bmp';
   end; 
run;
ods escapechar = "^"; 
ods PowerPoint file="powerptOptions.ppt" layout=titleslide 
     style=styles.test nogtitle nogfootnote;
proc odstext; 
p "The ODS Destination for PowerPoint" / style=presentationtitle; 
p "9.4 - The Power to Know ^{super ^{unicode 00AE}} " / 
    style=presentationtitle2; 
run; 
ods powerpoint layout=_null_; 

ods text=
'^{style[fontsize=34pt color=#cd5b45 ] What   
^{style[font_style=italic fontweight=bold] Output} is Produced by 
  the ODS Destination for PowerPoint?}';
proc odstext;
p 'Graphics output' / style=[color=#191970];
p 'SAS procedure output' / style=[color=#191970];
p 'ODS procedure output' / style=[color=#191970];
p 'ODS TEXT= output' / style=[color=#191970];
p 'LAYOUT output' / style=[color=#191970];
run;
title1 "^{style [font_size=30pt] PowerPoint - Various Layouts 
    and Styles }";
proc odstext;
  p 'New features include:' / style=[color=#236b8e fontsize=24pt 
     textdecoration=underline];
  list / style=[fontsize=24pt];
    item 'Light and dark styles';
    item;
        p 'Gradients: ';
        list / style=[fontsize=24pt];
            item/style=[color=darkgreen];
                p 'Linear: '; 
                  list/style=[color=darkred fontsize=24pt];
                    item 'Angles';
                    item 'Opacity';
                end;
            end;
            item 'Radial'/style=[color=darkgreen];
        end;
    end;

    item;
        p 'Template layout: ' /style=[color=darkgreen fontsize=24pt];
        list/style=[color=darkgreen fontsize=24pt];
            item 'Titleslide';
            item 'TitleandContent';
            item 'TwoContent';
        end;
    end;
    item 'Graphics support';
    item 'Layout Support';
    item 'Images';
  end;
run;
title1 "^{style [font_size=36pt] Column Layout with 
   Proc and Graphics }";
ods powerpoint layout=twocontent; 
proc means data=sashelp.class min max ; 
run; 
 
goptions hsize=3in vsize=3in dev=png;
pattern color="#a78d84";

proc gchart data=sashelp.class;
  vbar age / name='pptall0'
  ctext="#fba16c"
  coutline="red";
run;
quit;

ods powerpoint close; 


