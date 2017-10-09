*==================================================================================================================*;
*===                                               RANK ProcedureOverview                                       ===*;
*==================================================================================================================*;
proc rank data=golf out=rankings;
var strokes;
ranks Finish;
run;
proc print data=rankings;
run;

**---语法---**;
/*PROC RANK <option(s)>;*/
/*BY <DESCENDING> variable-1<<DESCENDING> variable-2 …><NOTSORTED>;*/
/*VAR data-set-variables(s);*/
/*RANKS new-variables(s);*/

*---Example 1: Ranking Values of Multiple Variables---*;
options nodate pageno=1 linesize=80 pagesize=60;
data cake;
input Name $ 1-10 Present 12-13 Taste 15-16;
datalines;
Davis 77 84
Orlando 93 80
Ramey 68 72
Roe 68 75
Sanders 56 79
Simms 68 77
Strickland 82 79
;
proc rank data=cake out=order descending ties=low;
var present taste;
ranks PresentRank TasteRank;  *create two var;
run;
proc print data=order;
title "Rankings of Participants' Scores";
run;

*---Example 2: Ranking Values within BY Groups---*;
*---分组排序感觉不错---*;
options nodate pageno=1 linesize=80 pagesize=60;
data elect;
input Candidate $ 1-11 District 13 Vote 15-18 Years 20;
datalines;
Cardella 1 1689 8
Latham 1 1005 2
Smith 1 1406 0
Walker 1 846 0
Hinkley 2 912 0
Kreitemeyer 2 1198 0
Lundell 2 2447 6
Thrash 2 912 2
;
proc rank data=elect out=results ties=low descending;
  by district;
  var vote years;
  ranks VoteRank YearsRank;
run;
proc print data=results n;
  by district;
  title 'Results of City Council Election';
run;

*---Example 3: Partitioning Observations into Groups Based on Ranks---*;
options nodate pageno=1 linesize=80 pagesize=60;
data swim;
input Name $ 1-7 Gender $ 9 Back 11-14 Free 16-19;
datalines;
Andrea F 28.6 30.3
Carole F 32.9 24.0
Clayton M 27.0 21.9
Curtis M 29.0 22.6
Doug M 27.3 22.4
Ellen F 27.8 27.0
Jan F 31.3 31.2
Jimmy M 26.3 22.5
Karin F 34.6 26.2
Mick M 29.0 25.4
Richard M 29.7 30.2
Sam M 27.2 24.1
Susan F 35.1 36.1
;
proc sort data=swim out=pairs;
by gender;
run;
proc rank data=pairs out=rankpair groups=3;
by gender;
var back free;
run;
proc print data=rankpair n;
by gender;
title 'Pairings of Swimmers for Backstroke and Freestyle';
run;


*================================================================================================================================================*;
*===                                                       SORT Procedure                                                                     ===*;
*================================================================================================================================================*;
proc sort data=employee;
by idnumber;
run;
proc print data=employee;
run;

*---Example 1: Sorting by the Values of Multiple Variables---*;
data account;
input Company $ 1-22 Debt 25-30 AccountNumber 33-36
Town $ 39-51;
datalines;
Paul's Pizza 83.00 1019 Apex
World Wide Electronics 119.95 1122 Garner
Strickland Industries 657.22 1675 Morrisville
Ice Cream Delight 299.98 2310 Holly Springs
Watson Tabor Travel 37.95 3131 Apex
Boyd & Sons Accounting 312.49 4762 Garner
Bob's Beds 119.95 4998 Morrisville
Tina's Pet Shop 37.95 5108 Apex
Elway Piano and Organ 65.79 5217 Garner
Tim's Burger Stand 119.95 6335 Holly Springs
Peter's Auto Parts 65.79 7288 Apex
Deluxe Hardware 467.12 8941 Garner
Pauline's Antiques 302.05 9112 Morrisville
Apex Catering 37.95 9923 Apex
;

proc sort data=account out=bytown;
by town company;
run;
proc print data=bytown;
var company town debt accountnumber;
title 'Customers with Past-Due Accounts';
title2 'Listed Alphabetically within Town';
run;

*---Example 2: Sorting in Descending Order---*;
proc sort data=account out=sorted;
by town descending debt accountnumber;
run;
proc print data=sorted;
var company town debt accountnumber;
title 'Customers with Past-Due Accounts';
title2 'Listed by Town, Amount, Account Number';
run;

*---Example 3: Maintaining the Relative Order of Observations in Each BY Group---*;
data insurance;
input YearsWorked 1 InsuranceID 3-5;
datalines;
5 421
5 336
1 209
1 564
3 711
3 343
4 212
4 616
;
proc sort data=insurance out=byyears1 equals;
by yearsworked;
run;
proc print data=byyears1;
var yearsworked insuranceid;
title 'Sort with EQUALS';
run;
proc sort data=insurance out=byyears2 noequals;
by yearsworked;
run;
proc print data=byyears2;
var yearsworked insuranceid;
title 'Sort with NOEQUALS';
run;

**---Example 4: Retaining the First Observation of Each BY Group---**;
proc sort data=account out=towns nodupkey;
by town;
run;
proc print data=towns;
var town company debt accountnumber;
title 'Towns of Customers with Past-Due Accounts';
run;

*---Example 5: Linguistic Sorting Using ALTERNATE_HANDLING=---*;
data a;
length x $ 10;
x='a-b'; output;
x='ab'; output;
x='a-b'; output;
x='aB'; output;
run;
proc sort data=a sortseq=linguistic( ALTERNATE_HANDLING=SHIFTED );
by x;
run;
title1 "Linguistic Collation with ALTERNATE_HANDLING=SHIFTED";
proc print data=a;
run;
title1 "Linguistic Collation with ALTERNATE_HANDLING=SHIFTED and BY Processing";
proc print data=a;
var x;
by x;
run;

**---Example 6: Linguistic Sorting Using ALTERNATE_HANDLING= and STRENGTH=---**;
data a;
length x $ 10;
x='a-b'; output;
x='ab'; output;
x='a-b'; output;
x='aB'; output;
run;
proc sort data=a sortseq=linguistic( ALTERNATE_HANDLING=SHIFTED STRENGTH=4);
by x;
run;
title1 "Linguistic Collation with STRENGTH=4";
proc print data=a;
run;
Title1 "Linguistic Coll
ation with STRENGTH=4 and BY Processing";
proc print data=a;
var x;
by x;
run;



