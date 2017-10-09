%put &path;

%let path = F:\�����ձ�\ҵ��֧������\;
%let filename = ��������&dd.sum.xlsx;

option user = work;

*---�����ļ�---*;
proc import 
  out = a
    datafile = "&path.&filename."
  dbms = excel replace;
run;

proc import out=ghm.balance1
  datafile = "d:/ghm/�ʲ���ծ��.xls"
  dbms = excel replace;
  getnames = yes;
  sheet = "sheet1";
run;

proc import 
  out = guessing_csv
  datafile = "F:/auto/input/20170718���˴�������������.csv" 
  dbms = csv replace;
  guessingrows = 10000;  *�����ʱ���ɿ�ͷ�ļ���ȷ�ϸ�ʽ;
run;

*---����ļ�---*;
proc export data = c
  outfile = "f:\"
  dbms = csv replac;
run;

*---����SAS��ȡ�ļ��б�ļ��ַ���---*;
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

  *---ͨ��pipe�����ܵ���ȡ�ļ��б�---*;
  filename loc_in pipe "dir ""&path"" /b";
  data filelist2;
    infile loc_in truncover;
    length name $ 200;
    input name;
  run;

*---�ϲ��ļ������������ݼ�---*;
proc sql;
  select distinct("a."!!memname) into:list separated by " " from dictionary.columns
  where libname="A";
quit;
data a;
  set &list;
run; 


*--����2--*;
%let libname=work;
data _null_;
    set sashelp.vtable end=last;
        where libname = upcase("&libname");
        if _n_=1 then call execute("data a; set ");
        call execute("&libname.."||strip(memname));
        if last then call execute("; run;");
run;

*--�귽��---*;

%macro cyc(i);
/*��������˳��*/
  proc sql;
    create table c like b;
  quit;

  %do i = 1 %to &i;
    data c;
	  set c&bi;;
	%put >>>>>>>>>>>>loop number i = &i;
  %end;
%mend cyc;

*---���ݼ�������---*;
proc datasets library = sashelp;
  sashelp.list;
run;

proc contents data = Sashelp.Aacomp out = a noprint;
run;

