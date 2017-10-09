*自己建立一个公式*;
proc fcmp outlib=work.funcsol.conversion;
  function change(lb);
  kg=lb/2.2;
  return (kg);
  endsub;                   *function---endsub的结构;
  run;
options cmplib=(work.funcsol);  *公式引用的地址;
  data a;
set sashelp.class(keep=name age weight);
kilos=change(weight);
run;



proc fcmp outlib=work.funcsol.conversions;
        function lb2kgc(lb) $;                      *返回的是字符串对象;
                length kg $10;
                kg = catt(put((lb/2.2),6.2),'kg');
                return (kg);
        endsub;
run;

proc fcmp outlib=function.funcsol.conversions;
        function lb2kgc(lb) $;
                length kg $10;
                kg = catt(put((lb/2.2),6.2),'kg');
                return (kg);
        endsub;
run;

proc fcmp outlib=function.funcsol.conversions;
        function bmi(lb,ht);
                return((lb*703)/(ht*ht));
        endsub;
        run;

options cmplib=(function.funcsol);

data bmi;
set sashelp.class(keep=name age weight height);
bmi=bmi(weight,height);
run;

*---把自变量和参数放在一起---*;
proc fcmp outlib=function.funcsol.conversions;
        subroutine biomassindex(w,h,b);
                outargs b;
                b= ((w*703)/(h*h));
        endsub;
        run;

options cmplib=(function.funcsol);

data bmi;
        set sashelp.class(keep=name age weight height);
        bmindex=.;
        call biomassindex(weight,height,bmindex);
run;

proc fcmp outlib=function.funcsol.conversions;
        function fromto(code $,v);
                if upcase(code)='LB2KG' then r=V/2.2;
                else if upcase(code)='KG2LB' then r=v*2.2;
                else r=.;
                return (r);
        endsub;
        run;

option cmplib=(function.funcsol);

data conv;
        set sashelp.class(keep=name age weight);
        kilos=fromto('lb2kg',weight);
        pounds=fromto('kg2lb',kilos);
        run;

	%macro printit();
%put &lib &dsn;
        %let lib = %sysfunc(dequote(&lib));
        %let dsn = %sysfunc(dequote(&dsn));
        %let num = %sysfunc(dequote(&num));
        %if &num = %then %let num=max;
        title2 "&lib..&dsn";
        title3 "first &num observations";
        proc print data=&lib..&dsn(obs=&num);
                run;
%mend printit;

proc fcmp outlib=function.funcsol.utilities;
        subroutine printN(lib ,dsn, num);
                rc=run_macro('printit',lib,dsn,num);
        endsub;
        run;


proc format;
        value pounds2kg
                other=[change()];
        run;

options cmplib=(function.funcsol);

title2 'Weight in Kg';
proc print data=sashelp.class;
        var name age weight;
        format weight pounds2kg.;
        run;


options cmplib = (function.funcsol);

data multiple;
        set sashelp.class(keep=name age height weight);
        heightmeters=.;
        weightkilos=.;
        bmi=.;
        call metric_hwbmi(height,weight,heightmeters,weightkilos,bmi);
        run;

options cmplib=(function.funcsol);

%let ht = 69;
%let wt = 112.5;
%let bmi = %sysfunc(bmi(&wt,&ht));
%put &bmi;

*----去除函数---*;
proc fcmp outlib=function.funcsol.conversions;
        deletefunc lb2kgc;
        deletefunc biomassindex;
        run;


