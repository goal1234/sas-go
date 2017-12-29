libname libref<engine> 'sas-data-library'

libname a ('d:\resdb\','d:\resfin\')

data resdata.class1/view = resdata.class1;
    set resdata.class1;
run;

proc sql;
    title 'all tables and views in the sashelp library';
    select libname, memname, memtype, nobs
        from dictionary.tables
        where libname  = 'SASHELP';
    /*注意需要大写*/

data scores(keep = team game1 game2 game3);
proc print data = new(drop = year);
    set old(rename = (date = Start_date));

<$>format<w>.<d>

put name $ 8.;

options obs = 5;

'1jan2000'd
'9:25't;


a**2.5
a*b*3

= Eq
^= Ne
> gt
< lt
>= ge
<= le
in

if x<y then c =5;
else c = 12;

& and
| or
^ not

>< 取最小
<> 取最大
|| 连接 'stock' || code


x1~x10

x_numeric_a
x_character_a

_numeric_
_character_
_all_


*--- 字符变为数值 ---*；
input(数据源, 输入格式)
input('5688', 8.)

put(数据源, 输出格式)
put(clpr, 8.2)
put(y, 6.2)


* ---自动变量--- *；
_n_
_error_
_numeric_
_character_
_all_
first.variable
last.variable

data one;
    set sashelp.class;
    keep _numeric_;
run;


proc sort data = ...; by var;quit;

data ... if first.var1 = 1;


totx = x1 + x2 + ... x10;
sum(of(x1-x10));

sum((if x1 >0),(if x2 > 0))


datdif()
date()
datepart()
datetime()
day()
dhms()
hms()
intck('30',''d,''d)

intnx('intervale', start_frome, increment)


mean(of x1-xn);mean(x, y, z,...)
max(of x1-xn); max(x,y, ...)
min(of x1-xn); min(x, y, ...)
N(of x1-xn); N(x, y, ...)  *非缺失个数
NMISS(of x1-xn); NMISS(x1, x2, ...)
sum()
var()
std()
stderr()
cv()
range()
css()
uss()
skewness()
kurtosi()


proc import
datafile = 'filename'|table = 'tablename'
out = sas-data-set
dbms = <replace>;


proc import out = tb31
datafile = 'd:\\'
dbms = excel2000 replace;
range = "'3#1$'";
getnames = yes;
run;

proc import out = tb31
datafile = 'd:\\'
dbms = excel2000 replace;
range = "'3#1$'";
getnames = no;
datarow = 2;
delimiter = '&';
run;

data book(index =(author subject));

n = _N_;

if _n_ = 5 then stop;
if _n_ = 5 then abort;

data accounts;
    modify accounts;
        if acctnum = 1002 then remove;

* ---循环与转移--- *;
do
do until
do while
do over
end
select
if-then/else
goto|go to
link-return
return
continue
leave

data a;
    set resdat.class;
    if age > 14 then do;
        h_cm =30.5*height/12;
        put name = sex = age = h_cm =;
        end;
run;

do i = 1 to 1000;
do i = 1 to y+3 by -1;

do i = 2, 3,4,,6,8,123,414;
do i = 'saturday','sunday';
do i = '01jan99'd, '25feb99'd;


data a;
    input x y;
    if x < y then go to skip;
    y = log(y -x);
    yy = y - 20;

    skip: if y < 0 then do;
    put x = y =;
    z = log(x-y);
    end;

    cards;
    2 6
    5 3
    5 -1
    ;
run;


data a;
    do n = 1 to 100;
    output;
    end;
run;

data a;
    t = 0;
    do n = 1 to 100;
        t = t+ n;
    output;
    end;
run;

array day{7} d1 - d7;
do i = 1 to 7;
 if day(i) = 99 then day{i} = 100;
end;

data a;
    n = 0;
    do while (n lt 5);
      put n = ;
      n + 1;
    end;
run;

data a;
    n = 0;
    do until (n lt 5);
      put n = ;
      n + 1;
    end;
run;


data a; 
  set resdat.st_list;
  obs = _n_;
  x = uniform(0);
  select (obs);
  when(1) x = x*10;
  when(2, 4, 6);
  when(3, 5, 6, 7, 13, 15) x = x*100;
  otherwise x=1;
  end;
run;


if <> then <>;
    else <>;

if x then delete

if status = 'ok' and type = 3 then count + 1;

data a;
    se resdat.idx00001;
    if _n_ <100;
run;


data test;
  array test{3} $ test1-test3;
  input id test1-test3 $;
  do i = 1 to dim(test);
  if test{i} = 'E' then test{i} = 'F';
  end;
  cards;
  1 a b e
  2 e f c
  3 c d a
  4 a b a
  5 b e e 
  ;
run;

proc import 
datafile = "filename" | TABLE = "tablename"
out = sas-data-set
<dmbs = identifier><replace>;

proc import 
datafile = "d:\resdata\table.xls"
dmbs = excel2000 replace;
range = "'3#1$'"
getnames = yes;
run;

proce import out = b_share_1
datafile = "d:\resdat\b_share_1.txt"
dmbs = dlm replace;
getnames = no;
datarow = 2;
run;

*access*;
proc import out = work.dists
datatbale = "gp_lcflist"
dbms = access2000 replace;
database = "d:\resdata\dists.mdb";
run;

libname aaa clear;

data weigth;
    input patient1d $ week1 week8 week16;
    loss = week1 - week16;
    datalines;
    2477 195 177 163
    2431 220 213 198
    ;


data;
data a;
data resdata.a;
data data1 data2;
data _null_;

data new (drop = var1);
data new (keep = _numeric_)
data new (label = "");
data new (rename = (var1 = u var2 = v));
data book (index = (author subject))

data class/view = class;
set resdata.class;
run;



*储蓄的程序;
data resdat.class1(keep = name age weight)/pgm = resdat1.c1;
set resdata.class;
run;

data pgm = resdata.c1;
run;

data year1998 year1999 year2000;
set resdat.stk000001;
if year(date) = 1998 then output year1998;
if year(date) = 1999 then output year1999;
if year(date) = 2000 then output year2000;
run;

data year1998 year1999 year2000;
set resdat.stk000001;
if year(date) = 1998 then output year1998;
else if year(date) = 1999 then output year1999;
else if year(date) = 2000 then output year2000;
run;

data open(keep = data oppr) low (keep = data lopr) high(keep = data hipr) close (keep = date clpr);
set resdat.stk00001;
run;


data _null_;
put 132*'_';
put 100*'1';
run;

data _null_;
input x y z;
put _infile_;
cards;
1 7 5 9
0 3 7
10 2 8
;
run;


data _null_;
input x y z;
put _all_;
cards;
1 7 5 9
0 3 7
10 2 8
;
run;


by <Descending><Groupformat> Variable-1;


data a;
set resdata.stk10000;
month = month(year);
year = year(date);
proc sort data = a;
by year month;

data b;
set a;
by year month;
if last.month;
run;

set <data-set-name-1<data-set-option-1)>
    <point = var> <key = index-name>/UNIQUE
    <NOBS = var> <end = var>;

data a;
    set resdata.idx000001;
    obs = _n_;
data b ;
    do n = 3, 5, 7, 4;
    set a point = n;
    output;
    end;
    stop;
proc print;
run;

data three;
    set one;
    set two;
run;


data a;
    do obsnum = 1 to last by 20;
    set resdata.stk point =obsnum nobs = last;
    output;
    end;
    stop;
    run;

data a;
    a = nobs;
    set resdta.stl nobs = nobs;
    if _n_ = a;
run;


