%put &path;

%let path = F:\减免日报\业务支持数据\;
%let filename = 工单报表&dd.sum.xlsx;

option user = work;

*---读入文件---*;
proc import 
  out = a
    datafile = "&path.&filename."
  dbms = excel replace;
run;

proc import out=ghm.balance1
  datafile = "d:/ghm/资产负债表.xls"
  dbms = excel replace;
  getnames = yes;
  sheet = "sheet1";
run;

proc import 
  out = guessing_csv
  datafile = "F:/auto/input/20170718宜人贷逾期天数反跑.csv" 
  dbms = csv replace;
  guessingrows = 10000;  *读入的时候由开头的几行确认格式;
run;

*---输出文件---*;
proc export data = c
  outfile = "f:\"
  dbms = csv replac;
run;

*---利用SAS获取文件列表的几种方法---*;
 %let path = F:\inbound;
 data filelist;
   rc = filename("mydir","&path");
     did = dopen("mydir");
     if did gt 0 then do;
      memcount = dnum(did);
      do i=1 to memcount;
         memname = dread(did,i);
        output;
        end;
       end;
      else put "ERROR: Can't find the path!";
     rc = dclose(did);
    keep memname;
  run;

  *---通过pipe匿名管道获取文件列表---*;
  filename loc_in pipe "dir ""&path"" /b";
  data filelist2;
    infile loc_in truncover;
    length name $ 200;
    input name;
  run;

*---合并文件夹下所有数据集---*;
proc sql;
  select distinct("a."!!memname) into:list separated by " " from dictionary.columns
  where libname="A";
quit;
data a;
  set &list;
run; 


*--方法2--*;
%let libname=work;
data _null_;
    set sashelp.vtable end=last;
        where libname = upcase("&libname");
        if _n_=1 then call execute("data a; set ");
        call execute("&libname.."||strip(memname));
        if last then call execute("; run;");
run;

*--宏方法---*;

%macro cyc(i);
/*命名中有顺序*/
  proc sql;
    create table c like b;
  quit;

  %do i = 1 %to &i;
    data c;
	  set c&bi;;
	%put >>>>>>>>>>>>loop number i = &i;
  %end;
%mend cyc;

*---数据集的内容---*;
proc datasets library = sashelp;
  sashelp.list;
run;

proc contents data = Sashelp.Aacomp out = a noprint;
run;

