option user = work;
%let start=%sysfunc(time());

data a;
do i= 0 to 100000000;
 b = i;
end;
run;

%let end=%sysfunc(time());
data _null_;
a = &end - &start;
put a "Seconds";
run;
