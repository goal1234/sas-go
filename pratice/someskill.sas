
option user = work;

data have;
	set sashelp.bmt;
run;
data want;
	if _n_ =1 then set have_onerow;
	set have;
run;

data have;
input id   A1 $ A2 $ A3 $ A4 $ ;
datalines;
1    A  B  C  D
2    B  B  C  A
3    A  A  D  D
;;;;
run;

data key;
input a1 $ a2 $ a3 $ a4 $;
datalines;
A B C D
;;;;
run;

data key_allrows;
	if _n_ =1 then set key;
	set have(keep = id);
run;

proc compare base = key_allrows compare = have out = compare;
	by id;
run;

*---create data set and merge---*;
proc sort data=a; by a1 a2 a3 a4; run;
proc sort data=b; by a1 a2 a3 a4; run;

data c;
  merge a(in=ina) b(in=inb)
  by a1 a2 a3 a4;
  if inb then b='Y';
run;


*---通过数据集的名称进行操作---*;
%let a = have;
data try;
	set &a;
run;
*---通过数据集的名称进行操作---*;


*---复杂但是符合的写法---*;
data test;
set test1;
if ((the 100th percentile of X)-(99th percentile of X))>(SD of X) then delete;
run;


data tmp;
    do i=1 to 100;
        x=rannor(123);
        output;
    end;
run;

*---输出了某一列的统计量---*;
proc univariate data=tmp noprint;
    var x;
    output out=pctls max=max p99=p99 std=std;
run;

*---进行了双set的操作,首先将pctls的放在了前面，就好像是sql中一多对应的情况---*;
data tmp_1;
    if _n_=1 then do;
        set pctls;
    end;
    set tmp;

    /* Just making up a condition here */
    if x>p99 then delete;
run;


data have;
 input username $ stake betdate : datetime.;
dateOnly = datepart(betdate) ;
format betdate DATETIME.;
format dateOnly ddmmyy8.;
datalines; 
player1 90 12NOV2008:12:04:01
player1 -100 04NOV2008:09:03:44
player2 120 07NOV2008:14:03:33
player1 -50 05NOV2008:09:00:00
player1 -30 05NOV2008:09:05:00
player1 20 05NOV2008:09:00:05
player2 10 09NOV2008:10:05:10
player2 -35 15NOV2008:15:05:33
run;
PROC PRINT; RUN;
proc sort data=have;
by username betdate;
   run;
 data want;
set have;
by username dateOnly betdate;   
retain calendarTime eventTime cumulativeDailyProfit standardDeviationStake;
if first.username then calendarTime = 0;
if first.dateOnly then calendarTime + 1;
if first.username then eventTime = 0;
if first.betdate then eventTime + 1;
if first.username then cumulativeDailyProfit = 0;
if first.dateOnly then cumulativeDailyProfit = 0;
if first.betdate then cumulativeDailyProfit + stake;
run;
PROC PRINT; RUN;

proc means data=have;
class username;
var stake;
output out=want stddev=stake_stddev;
run;


*---使用SAS从一个表更新另一表---*;
    data table1;
            input client $6. paidclaims;
    cards;
    123456 1000
    234567 2000
    aaaaaa 3333
    ;
    data table2;
            input client $6. totpaidclaims;
    cards;
    123456 5000
    234567 9000
    bbbbbb 2222
    ;

    proc sql;
            update table1
                    set paidclaims = (
                            select totpaidclaims from table2
                                    where table1.client=table2.client
                    )
                    where client in (
                            select client from table2
                    );
    quit;


*---ifn(condition,1,0)---*;

proc means data=sashelp.class nway stackods median p25 p75;
    class sex;
    var weight;
    ods output summary=stats;
run;

proc sort data=sashelp.class out=class;
    by sex;

data want;
    merge class stats (keep=sex median p25 p75);
    by sex;
    flag_p75=ifn(weight>p75, 1, 0);
run;

*---前后的转换---*;
data have;
input id  q1a q2a q1b q2b q1c q2c;
datalines;
1   3   0   1   1   1   9
2   4   9   1   2   2   0
3   5   9   1   2   4   0
;
run;

proc transpose data=have out=temp1;
by id;
run;

data temp2;
set temp1;
length type $1;
type=substr(_NAME_,3);
_NAME_=substr(_NAME_,1,2);
run;

proc transpose data=temp2 out=want (drop=_:) ;
by id type;
id _NAME_;
var COL1;
run;

data want;
set have;
array qs q:;
do _t = 1 to dim(qs) by 2;
  q1=qs[_t];
  q2=qs[_t+1];
  type = substr(vname(qs[_t]),3,1);
  output;
end;
keep id q1 q2 type;
run;

a = intck('month', start_dt -1, end_dt);

