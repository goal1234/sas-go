data sample;
  do ID = 1 to 10;
     x = ID + 100;
     output;
  end;
run;

proc sql;
    select x into : xvalues separated by ','
    from sample;
    select id, x, pctl(25, &xvalues) as xq1,
                  median(&xvalues) as xmedian,
                  pctl(75, &xvalues) as xq3
    from sample;
quit;


* - 各种百分位数 - *;
proc univariate data=sashelp.cars noprint;
        var invoice;
		class ;
    output out=pct pctlpts=25  pctlpre=p;
run;


proc print data=pct;
run;

* - 变标签- *;
proc datasets lib=work nolist;
	modify tablename;
	label varname1=labelname1
		  varname2=labelname2;
run;
