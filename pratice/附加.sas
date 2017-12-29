


	libname newcore oracle schema=tcsvbs_sele_v user=lijiezhang1_sele password=Smki8uhDr6 path=xhxdg;
	libname amque oracle schema=amque_sele_v user=ws_sele password=Kfy8pPKL path=zjdb4dg;
	libname call "Q:\��������\call";
	libname link "Q:\��������\link";
	libname task "Q:\��������\task";
	libname ptp "Q:\��������\ptp";

	libname version "O:\order\������";
	option user = version compress = yes threads = yes cpucount = 2 validvarname = any;

	%let stat_dt = "&sysdate9."d; *'19sep2017'd "&sysdate9."d;
	%let format_date = %sysfunc(putn(&stat_dt, yymmddn8.));

	%let happen_dt = %qsysfunc(intnx(day, &stat_dt,-1)); *"&sysdate9."d;  
	%let happen_dt_format = %sysfunc(putn(&happen_dt, yymmddn8.));

	%let nf_date = %qsysfunc(intnx(day, &stat_dt,-2)); 	/*ǰ����������<<<<<<<<<<<<<<<<<*/                 *;
	%let nf_date_format = %sysfunc(putn(&nf_date,yymmddn8.));

*�󶨹�ϵ;
data fellow_maybe;		
	set task.Ding_remain_201508;
	where index(QUEUE_NAME,"����") = 0 and index(QUEUE_NAME,"city") > 0 and 
		  enter_date2 between "01OCT2017"D and "15DEC2017"D;
run;

data fellow_link;
	set link.link_user_201508;
	where oper_time between "01OCT2017"D and "15DEC2017"D;
run;

data fellow_link1;
	set fellow_link(keep =  LOAN_INFO_ID USER_NAME CUSTOMER_CODE CUST_ID OPERATION_DATE ID oper_time LOAN_INFO_CODE);
run;

data fellow_link2;
	set fellow_link1;
	where index(CUSTOMER_CODE, "YRD") = 0;
run;

proc sql;
	create table fellow as
	select distinct a.contract_id,
					b.OPERATION_DATE
	from fellow_maybe as a
	left join fellow_link2 as b on a.enter_date2 = b.oper_time and 									
									a.contract_id = b.LOAN_INFO_CODE
	;
quit;




%let date_star = "01OCT2017"d;


%let i = 1;

%macro stack(i);

%let dti=%qsysfunc(intnx(day,&date_star,%eval(&i)));
%put &dti;

%put i;	

data fellow_maybe_day;
	set fellow_maybe;
	where enter_date2 = &dti;
run;

data fellow_link_day;
	set fellow_link;
	where oper_time = &dti;
run;
proc sql;
	create table fellow_day as 
	select a.*,
		   b.OPERATION_DATE
	from fellow_maybe_day as a
	left join fellow_link_day as b on a.client_id = b.CUSTOMER_CODE and 
									  a.contract_id = b.LOAN_INFO_CODE and 
									  a.user_name = b.user_name
	;
quit;

data fellow_day;
	set fellow_day;
	if operation_date = "" then operation_date = "No operation here";
		else operation_date = operation_date;
run;

data f_result;
	set f_result fellow_day;
run;
%mend;

%macro cyc(i);
  %do i=0 %to &i.;
    %stack(&i.);
  %end;
%mend;

%cyc(75);


data a_fellow;
	set f_result;
run;



* --ȥ����������;
data count;
	set a_fellow;
	where operation_date ^= "No operation here";
run;

* --- �����˻��ܣ��˾��ģ�С��ģ����е�;
* --- �ǿͻ�ά�ȵ�����ȥ���ظ�������;

proc sql;
	create table count_unique as
	select a.*,
			min(a.OPERATION_DATE) as min_oper
	from count as a
	group by enter_date2,USER_NAME,client_id
	;
quit;

data count_unique;
	set count_unique(drop = OPERATION_DATE);
	mon = month(enter_date2);
run;

proc sql;
	create table count_unique as
	select distinct a.*
	from count_unique as a
	;
quit;



* --- ���ܽ�� --- *;
proc sql;
	create table count_p as
	select enter_date2,
			QUEUE_NAME,
			USER_LEVEL_FOUR,
			USER_LEVEL_FIVE,
			NICK_NAME,
			USER_NAME,
			count(min_oper) as fellow_count
	from count_unique
	group by enter_date2,QUEUE_NAME,USER_LEVEL_FOUR,
				USER_LEVEL_FIVE,NICK_NAME
				;
	quit;

proc sql;
	create table cout_level as
	select enter_date2,
			QUEUE_NAME,
			USER_LEVEL_FOUR,
			count(user_name) as number,
			count(min_oper) as fellow_count
	from count_unique
	group by enter_date2,QUEUE_NAME,USER_LEVEL_FOUR
	;
	quit;

proc sql;
	create table count_queue as
	select enter_date2,
			QUEUE_NAME,
			count(user_name) as number,
			count(min_oper) as fellow_count
	from count_unique
	group by enter_date2, queue_name
	;
quit;


* ---;
proc sql;
	create table count_time as
	select a.*,
			count(OPERATION_DATE�� as times
	from count
	group by enter_date2,QUEUE_NAME,USER_LEVEL_FOUR��
				USER_LEVEL_FIVE,NICK_NAME
				;
quit;

