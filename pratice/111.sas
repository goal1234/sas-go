
********************************************************************;
*���г�ʼ����;
********************************************************************;
	libname newcore oracle schema=tcsvbs_sele_v user=lijiezhang1_sele password=Smki8uhDr6 path=xhxdg;
	libname amque oracle schema=amque_sele_v user=ws_sele password=Kfy8pPKL path=zjdb4dg;
	libname call "Q:\��������\call";
	libname link "Q:\��������\link";
	libname task "Q:\��������\task";
	libname ptp "Q:\��������\ptp";

	libname version "O:\order\������";
	option user = version compress = yes threads = yes cpucount = 2 validvarname = any;

	%let stat_dt = "14OCT2017"d; *'19sep2017'd "&sysdate9."d;
	%let format_date = %sysfunc(putn(&stat_dt, yymmddn8.));

	%let happen_dt = %qsysfunc(intnx(day, &stat_dt,-1)); *"&sysdate9."d;  
	%let happen_dt_format = %sysfunc(putn(&happen_dt, yymmddn8.));

	%let nf_date = %qsysfunc(intnx(day, &stat_dt,-2)); 	/*ǰ����������<<<<<<<<<<<<<<<<<*/                 *;
	%let nf_date_format = %sysfunc(putn(&nf_date,yymmddn8.));

*****************************************;
*���ذ󶨹�ϵ������δ��������nF_days;
*************************************;

data base_task;		*�󶨹�ϵ;
	set task.Ding_remain_201508;
	where index(QUEUE_NAME,"����") = 0 and index(QUEUE_NAME,"�����Ŵ�") > 0 and 
		  enter_date2 = &happen_dt.;
run;

proc sql;
	create table base_task as 
	select a.*,
			b.ID as user_id
	from base_task as a
	left join amque.V_zg_t_user as b on a.user_name = b.user_name
	;
quit;

proc sql;
	create table base_task as 
	select a.*,
	       b.id
	from base_task a
	left join amque.v_zg_t_customer b on a.client_id = b.CUSTOMER_CODE;
quit;

/*data nf_days_&format_date.;*/
/*	set amque.V_zg_t_customer_attach_info ;*/
/*run;*/

data a ;
	set  amque.V_zg_t_customer_attach_info;
	where ASSIGNED_USER_ID=1040728374;
	run;

proc sql;
	create table base_task_&happen_dt_format. as 
	select a.*,
		   b.nF_days
	from base_task a
	left join nf_days_&nf_date_format. b on a.id = b.customer_id and 
													 a.user_id = b.ASSIGNED_USER_ID and 
													 a.QUEUE_ID = b.ASSIGNED_QUEUE_ID
	;
quit;


*********************************************;
*��ͬ���ڣ��������ͬ 23һ�飬46һ��(����4-6);
***************************************;
data base_task;
	set base_task_&happen_dt_format.;
	select;
		when(index(queue_name, "M2") >0 ) period = 2;
		when(index(queue_name, "M3") >0 ) period = 3;
		when(index(queue_name, "M4") >0 ) period = 4;
	otherwise                             period = 0;
	end;

	if period in (2,3,4);

run;
data yrd_yes yrd_no;
	set base_task;
	if index(queue_name, "���˴�") > 0 then output yrd_yes;
		else output yrd_no;
run;


libname Core "Q:\�ִ�ΥԼ\���հ�\xhx";

proc sql;
	create table prindd_yrd_no as
	select a.*,
	       b.balance_corpus as bal_prin
	from yrd_no a
	left join Data_core_detail_&happen_dt_format. b on a.contract_id = b.contractno;
quit;


libname yrd "Q:\�ִ�ΥԼ\���հ�\yrd";
proc sql;
	create table prindd_yrd_yes as 
	select a.*,
		   b.balance_corpus as bal_prin
	from yrd_yes a
	left join yrd.Data_local_&format_date. b on a.client_id = b.ecif_id
	;
quit;

data prindd;
	set prindd_yrd_no prindd_yrd_yes;
	rename OVERDUE_PERIOD = overdue_days;
run;

data prindd_23 prindd_46;
	set prindd;
	if period in (2,3) then output prindd_23;
		else output prindd_46;
run;

********************************************;
*23:������֣������������46�������������;
***************************************;
data sort_23;
	set prindd_23;
	if period =  2 then do;
		if overdue_days >= 30 and overdue_days<= 35 then score = 5;
		  else if overdue_days >= 36 and overdue_days<= 55 then score = 2;
		  	else if overdue_days >= 56 and overdue_days<= 60 then score = 3;
			  else score = 4;
		end;
	else do;
		if overdue_days >= 60 and overdue_days<= 65 then score = 5;
		  else if overdue_days >= 66 and overdue_days<= 85 then score = 2;
		  	else if overdue_days >= 86 and overdue_days<= 90 then score = 3;
			  else score = 4;
		end;

run;
proc sql;
	create table sort_23 as
	select a.*
	from sort_23 a
	group by user_name,QUEUE_NAME,score,bal_prin
	order by user_name, QUEUE_NAME, score desc, bal_prin desc,LOAN_INFO_ID desc
;
quit;
data sort_23;
	set sort_23;
	retain rank;
    by user_name QUEUE_NAME;
	if first.user_name or first.QUEUE_NAME then rank_hat =1;
		else rank_hat + 1;
run;

*------><------*;
proc sql;
	create table sort_46 as
	select a.*
	from prindd_46 as a
	group by user_name, QUEUE_NAME
	order by user_name, QUEUE_NAME, nF_days desc,bal_prin desc, LOAN_INFO_ID desc
	;
quit;
data sort_46;
	set sort_46;
	retain rank;
    by user_name;
	if first.user_name or first.QUEUE_NAME then rank_hat =1;
		else rank_hat + 1;
run;


*****************************************************************************************************;
*
*				********* 								**********					   *------------;
  *                                                                                   * ----------; 
   *                                                                                 *-----------;
	*                          ******************									*-----------;					
     *                              ��ͨ��¼                                        *--------;
	  *****************************************************************************;

data base_link_&happen_dt_format.;
	set link.link_user_201508;
	where oper_time = &happen_dt.;
run;

data base_link_sort;
	set base_link_&happen_dt_format.(keep =  LOAN_INFO_ID USER_NAME CUSTOMER_CODE CUST_ID OPERATION_DATE ID oper_time LOAN_INFO_CODE);
run;


proc sql;
	create table base_link_sort as
	select distinct customer_code,
		   LOAN_INFO_CODE,
		   user_name,
		   CUST_ID,
		   min(OPERATION_DATE) as OPERATION_DATE
	from base_link_sort
	group by user_name, CUST_ID, LOAN_INFO_ID
	order by user_name, OPERATION_DATE
	;
quit;

*---�ַ���ȥ---*;
proc sql;
	create table result_23 as 
	select distinct a.*,
		   b.OPERATION_DATE
	from sort_23 as a
	left join base_link_sort as b on a.client_id = b.CUSTOMER_CODE and a.contract_id = b.LOAN_INFO_CODE and a.user_name = b.user_name
	;
quit;

data result_23;
	set result_23;
	if operation_date = "" then operation_date = "No operation here";
		else operation_date = operation_date;
	run;

proc sql;
	create table result_23 as
	select a.*
	from result_23 as a
	group by user_name,QUEUE_NAME,OPERATION_DATE
	order by user_name, QUEUE_NAME, OPERATION_DATE
;
quit;

data result_23;
	set result_23;
	retain rank_real;
    by user_name QUEUE_NAME;
	if first.user_name or first.QUEUE_NAME then rank_real =1;
		else rank_real + 1;
run;

data result_23;
	set result_23;
	if OPERATION_DATE = "No operation here" then rank_real = 9999;
		else rank_real = rank_real;
run;
proc sql;
	create table result_23_&happen_dt_format. as
	select a.*
	from result_23 a
	group by USER_NAME, QUEUE_NAME, rank_real
	order by USER_NAME, QUEUE_NAME, rank_real
;
quit;


*--2--*;
proc sql;
	create table result_46 as 
	select a.*,
		   b.OPERATION_DATE
	from sort_46 as a
	left join base_link_sort as b on a.client_id = b.CUSTOMER_CODE and a.contract_id = b.LOAN_INFO_CODE and a.user_name = b.user_name
	;
quit;

data result_46;
	set result_46;
	if operation_date = "" then operation_date = "No operation here";
		else operation_date = operation_date;
	run;

proc sql;
	create table result_46 as
	select a.*
	from result_46 as a
	group by user_name,QUEUE_NAME,OPERATION_DATE
	order by user_name, QUEUE_NAME, OPERATION_DATE
;
quit;

data result_46;
	set result_46;
	retain rank_real;
    by user_name QUEUE_NAME;
	if first.user_name or first.QUEUE_NAME then rank_real =1;
		else rank_real + 1;
run;

data result_46;
	set result_46;
	if OPERATION_DATE = "No operation here" then rank_real = 9999;
		else rank_real = rank_real;
run;

proc sql;
	create table result_46_&happen_dt_format. as
	select a.*
	from result_46 a
	group by USER_NAME, rank_real, OPERATION_DATE
	order by USER_NAME, rank_real, OPERATION_DATE
;
quit;


****-------------------------------;
****-----------------------------;
****--------------------------;
*д��һ���ļ�����;


*---ÿ������Ա��Ԥ�⸲��---*;
proc sql;
	create table a_a as
	select distinct
		   a.user_name,
		   a.QUEUE_NAME,
		   count(a.OPERATION_DATE) as max
	from result_23_&happen_dt_format. as a             /*<-----------------------------------����*/
	where a.OPERATION_DATE ^= "No operation here"
	group by a.user_name
	;
quit;
data a_b;
	merge result_23_&happen_dt_format.(keep = enter_date2 LOAN_INFO_ID QUEUE_NAME USER_NAME contract_id client_id NF_DAYS period  /*<-----------------------------------����*/
						bal_prin overdue_days score OPERATION_DATE rank_hat rank_real in = a) a_a(in =b);
	by user_name;
	if rank_hat - max <= 0 then inpredict = 1;
		else inpredict = "";

	if rank_real in (1,2,3,4,5,6,7,8,9,10) and rank_hat in (1,2,3,4,5,6,7,8,9,10) then top10 =1;
		else top10 =0;

	if rank_real in (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20) and rank_hat in (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20) then top20 =1;
		else top20 =0;
run;
data a_b;
	set a_b;
	where OPERATION_DATE ^= "No operation here";
run;
proc sql;
	create table a_d as
	select distinct
		   a.user_name,
		   a.QUEUE_NAME,
		   count(a.OPERATION_DATE) as max
	from result_23_&happen_dt_format. as a             /*<-----------------------------------����*/
	group by a.user_name
	;
quit;

proc sql;
	create table a_c as
	select distinct
			a.user_name,
			a.QUEUE_NAME,
			d.max as assign,
			a.max,
		    sum(b.inpredict) as inpredict,
			sum(b.top10) as top10,
			sum(b.top20) as top20
	from a_a as a
	left join a_b as b on a.user_name = b.user_name
	left join a_d as d on a.user_name = d.user_name
	group by a.user_name,a.queue_name, a.max, d.max
	;
quit;

data out_name_inpredict_23;  /*<----------------------------------�����*/
	set a_c;
	ppredict = inpredict/max;
run;

*------------*;
proc sql;
	create table a_a as
	select distinct
		   a.user_name,
		   a.QUEUE_NAME,
		   count(a.OPERATION_DATE) as max
	from result_46_&happen_dt_format. as a             /*<-----------------------------------����*/
	where a.OPERATION_DATE ^= "No operation here"
	group by a.user_name
	;
quit;
data a_b;
	merge result_46_&happen_dt_format.(keep = enter_date2 LOAN_INFO_ID QUEUE_NAME USER_NAME contract_id client_id NF_DAYS period  /*<-----------------------------------����*/
						bal_prin overdue_days OPERATION_DATE rank_hat rank_real in = a) a_a(in =b);
	by user_name;
	if rank_hat - max <= 0 then inpredict = 1;
		else inpredict = "";

	if rank_real in (1,2,3,4,5,6,7,8,9,10) and rank_hat in (1,2,3,4,5,6,7,8,9,10) then top10 =1;
		else top10 =0;

	if rank_real in (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20) and rank_hat in (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20) then top20 =1;
		else top20 =0;
run;
data a_b;
	set a_b;
	where OPERATION_DATE ^= "No operation here";
run;
proc sql;
	create table a_d as
	select distinct
		   a.user_name,
		   a.QUEUE_NAME,
		   count(a.OPERATION_DATE) as max
	from result_46_&happen_dt_format. as a             /*<-----------------------------------����*/
	group by a.user_name
	;
quit;

	
proc sql;
	create table a_c as
	select distinct
			a.user_name,
			a.QUEUE_NAME,
			d.max as assign,
			a.max,
		    sum(b.inpredict) as inpredict,
			sum(b.top10) as top10,
			sum(b.top20) as top20
	from a_a as a
	left join a_b as b on a.user_name = b.user_name
	left join a_d as d on a.user_name = d.user_name
	group by a.user_name,a.queue_name, a.max, d.max
	;
quit;
data out_name_inpredict_46;  /*<----------------------------------�����*/
	set a_c;
	ppredict = inpredict/max;
run;
*---ÿ������Ա��Ԥ�⸲��---*;



data out_result_23_&happen_dt_format.;
	set result_23_&happen_dt_format.(keep = enter_date2 LOAN_INFO_ID QUEUE_NAME USER_NAME contract_id client_id NF_DAYS period 
						bal_prin overdue_days score OPERATION_DATE rank_hat rank_real);
	where OPERATION_DATE ^= "No operation here";
	dif = rank_hat - rank_real;
	if rank_real in (1,2,3,4,5,6,7,8,9,10) and rank_hat in (1,2,3,4,5,6,7,8,9,10) then top10 =1;
		else top10 =0;

	if rank_real in (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20) and rank_hat in (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20) then top20 =1;
		else top20 =0;

run;

data out_result_46_&happen_dt_format.;
	set result_46_&happen_dt_format.(keep = enter_date2 LOAN_INFO_ID QUEUE_NAME USER_NAME contract_id client_id NF_DAYS period 
						bal_prin overdue_days OPERATION_DATE rank_hat rank_real);
	where OPERATION_DATE ^= "No operation here";
	dif = rank_hat - rank_real;
	if rank_real in (1,2,3,4,5,6,7,8,9,10) and rank_hat in (1,2,3,4,5,6,7,8,9,10) then top10 =1;
		else top10 =0;
	
	if rank_real in (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20) and rank_hat in (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20) then top20 =1;
		else top20 =0;
run;


*------------------------------ƥ��-------------------------------*;
proc sql;
	create table out_real_23 as
	select count(enter_date2) as all
	from out_result_23_&happen_dt_format.;
run;
proc sql;
	create table out_real_dif_23 as
	select count(enter_date2) as all
	from out_result_23_&happen_dt_format.
	where dif = 0
	;
run;
proc sql;
	create table out_real_top_23 as
	select count(top10) as all
	from out_result_23_&happen_dt_format.
	where top10 ^=0
	;
run;
proc sql;
	create table out_real_top20_23 as
	select count(top20) as all
	from out_result_23_&happen_dt_format.
	where top20 ^=0
	;
run;


proc sql;
	create table out_r_23 as
	select distinct 
		   queue_name,
		   count(enter_date2) as all
	from out_result_23_&happen_dt_format.
	group by QUEUE_NAME
;
quit;
proc sql;
	create table out_q_23 as
	select distinct 
		   queue_name,
		   count(enter_date2) as all
	from result_23_&happen_dt_format.
	group by QUEUE_NAME
;
quit;
proc sql;
	create table out_r_231 as
	select distinct 
		   queue_name,
		   count(enter_date2) as all
	from out_result_23_&happen_dt_format.
	where dif = 0
    group by QUEUE_NAME
;
quit;
proc sql;
	create table out_r_23 as 
	select a.*,
	b.all as real,
	c.all as all_que
	from out_r_23 as a
	left join out_r_231 as b on a.QUEUE_NAME = b.QUEUE_NAME
	left join out_q_23 as c on a.QUEUE_NAME = c.QUEUE_NAME
	;
quit;



*-----------------46------------------------------------*;
proc sql;
	create table out_real_46 as
	select count(enter_date2) as all
	from out_result_46_&happen_dt_format.;
run;

proc sql;
	create table out_real_dif_46 as
	select count(enter_date2) as all
	from out_result_46_&happen_dt_format.
	where dif = 0
	;
run;
proc sql;
	create table out_real_top_46 as
	select count(top10) as all
	from out_result_46_&happen_dt_format.
	where top10 ^=0
	;
run;

proc sql;
	create table out_real_top20_46 as
	select count(top20) as all
	from out_result_46_&happen_dt_format.
	where top20 ^=0
	;
run;

proc sql;
	create table out_r_46 as
	select distinct 
		   queue_name,
		   count(enter_date2) as all
	from out_result_46_&happen_dt_format.
	group by QUEUE_NAME
;
quit;
proc sql;
	create table out_q_46 as
	select distinct 
		   queue_name,
		   count(enter_date2) as all
	from result_46_&happen_dt_format.
	group by QUEUE_NAME
;
quit;
proc sql;
	create table out_r_461 as
	select distinct 
		   queue_name,
		   count(enter_date2) as all
	from out_result_46_&happen_dt_format.
	where dif = 0
    group by QUEUE_NAME
;
quit;
proc sql;
	create table out_r_46 as 
	select a.*,
	b.all as real,
	c.all as all_que
	from out_r_46 as a
	left join out_r_461 as b on a.QUEUE_NAME = b.QUEUE_NAME
	left join out_q_46 as c on a.QUEUE_NAME = c.QUEUE_NAME
	;
quit;


data out_real_23;
	set out_real_23 out_real_dif_23 out_real_top_23 out_real_top20_23;
run;
data out_real_46;
	set out_real_46 out_real_dif_46 out_real_top_46 out_real_top20_46;
run;
data name;
	input QUEUE_NAME $30.;
	cards;
	�����ܼ�
	�����Ӧ
	ǰ10��Ӧ
	ǰ20��Ӧ
;run;

data out_real_23;
	set name;
	set out_real_23;
run;

data out_real_46;
	set name;
	set out_real_46;
run;

data out_real_23;
	set out_real_23 out_r_23;
run;
data out_real_46;
	set out_real_46 out_r_46;
run;


libname excel "O:\order\������\output\out_&happen_dt_format..xls";

data excel.M2_M3detail;
	set result_23_&happen_dt_format.;
run;

data excel.M4_M6detail;
	set result_46_&happen_dt_format.;
run;

data excel.queue_M2_M3;
	set out_real_23;
run;

data excel.queue_M4_M6;
	set out_real_46;
run;

data excel.inpredict_user_23;
	set out_name_inpredict_23;
run;

data excel.inpredict_user_46;
	set Out_name_inpredict_46;
run;
libname excel clear;

