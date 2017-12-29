
libname outlog "F:\减免日报\sas_data";

%let dtn=20171220;			/*外包明细时间*/
%let d="&sysdate9."d;		/*减免和工单文件时间*/
%let dd=%sysfunc(putn(&D,yymmddn8.));
 
%put &dd.;

options validvarname=any compress=yes user=outlog;
/**/
/*<<<<<<<<石鑫，外包批次委外明细*/
/*<<<<<<<<<<<<<<<<<<每月5,20号运行一次*/
/*导入日志需要更正;*/
/**/
/**/
/*proc import*/
/*out=os_city*/
/*datafile="F:\减免日报\input\&dtn.批次案件明细.xlsx"*/
/*dbms=excel replace;*/
/*sheet="案件明细";*/
/*run;*/
/**/
/**/
/**/
/**/
/*data os_his_log;*/
/*set os_city(keep=新客户号 合同号 客户姓名 公司 委案日期 结案日期 状态) */
/*os_notcity(keep=新客户号 合同号 客户姓名 公司 委案日期 结案日期 状态);*/
/*rename 	新客户号=client_id*/
/*		合同号=contractno*/
/*		客户姓名=client_name*/
/*		公司=company*/
/*		委案日期=out_assigndate*/
/*		结案日期=out_enddate*/
/*		状态=status*/
/*;		*/
/*run;*/
/**/
/*proc sort data=os_his_log;*/
/*by contractno descending out_assigndate;*/
/*run;*/
/**/
/*data os_recent_log;*/
/*set os_his_log;*/
/*by contractno;*/
/*if first.contractno;*/
/*run;*/



*----1.1非结清减免合同明细----*;
proc import 
  out=derate_notclear
    datafile="F:\减免日报\业务支持数据\减免历史列表_&dd..xls"
  dbms=excel replace;
run;
*--1.1.1减免未结清---*;
proc sql;
create table not_clear as
select 	distinct
		input(合同号,20.) format 20. as 合同号
		,客户姓名
		,城市地区,营业部
		,减免审核状态
		,申请人姓名
		,申请注记,审核人,审核时间,核心处理结果,"非结清" as 结清状态,业务模式
		,input(减免罚息金额,20.2)+input(减免违约金金额,20.2)+input(减免本息滞纳金金额,20.2)+input(减免服务费滞纳金金额,20.2) as 减免金额
		from derate_notclear
		where 审核人 in ("王宁","陈鸿飞") and 减免审核状态="通过" and 核心处理结果='成功'
;quit;


*----1.2结清减免合同明细-----*;
proc import 
  out=derate_clear
    datafile="F:\减免日报\业务支持数据\减免结清历史列表_&dd..xls"
  dbms=excel replace;
run;
*---1.2.1减免结清---*;
proc sql;
create table clear as 
select 	distinct
		input(合同号,20.) format 20. as 合同号
		,客户姓名
		,城市地区,营业部
		,减免结清审核状态 as 减免审核状态
		,申请人 as 申请人姓名
		,申请注记,审核人,审核时间,核心处理结果,"结清" as 结清状态,业务模式
		,input(减免结清金额,20.2) as 减免金额
		from derate_clear 
		where 审核人 in ("王宁","陈鸿飞","卢彩霞") and 减免结清审核状态='已完成' and 核心处理结果='成功'
;quit; 

*--------------result_1.结清和非结清减免合同汇总------------*;
data derate_log_&dd.;
  informat 客户姓名 $20.;
  informat 城市地区 $20.;
  informat 营业部 $40.;
  informat 核心处理结果 $80.;
  informat 结清状态 $6.;
  informat 申请注记 $80.;
  informat 审核人  $8.;
  format 审核人  $8.;
set  not_clear clear;
run;


*----2.工单系统减免----*;
proc import 
  out=derate_workorder
    datafile="F:\减免日报\业务支持数据\贷后减免工单报表&dd.sum.xlsx"
  dbms=excel replace;
run;
*---2.1.1时间筛选---*;
data derate_workorder_&dd.;
set derate_workorder
(keep=工单来源 工单创建时间 创建人姓名 客户姓名 合同编号 是否符合 分配时间 处理人姓名 处理时间 处理时长);
合同编号1=compress(合同编号);
rename 	工单来源=case_from
		工单创建时间=submit_time
		创建人姓名=submitted_by
		客户姓名=client_name
		合同编号1=contractno
		是否符合=if_satisfy
		分配时间=approved_time
		处理人姓名=approved_by
		处理时间=handle_time
		处理时长=handle_period;
if 是否符合="符合";
approved_time1=input(substr(compress(分配时间),1,10),yymmdd10.);
format approved_time1 yymmdd10.;

if weekday(&d.-2) in (1,2) or day(&d.-1) in (15,30) then range=10;   
/*&d.为今天，&d-1为日报时间，&d.-2是因为weekday=1是sunday.因此：周一、周二或者15、30账单日，则向前多取几天分配时间做参考*/
else range=3;

if approved_time1>=&d.-range or 处理时间=&d.-1;

drop range;
run;

*----减免记录匹配工单系统提交人----*;
proc sql;
create table derate_final&dd. as
select 	distinct
		b.submit_time as 提交时间
		,a.合同号
		,客户姓名
		,申请注记 as 减免类型
		,submitted_by as 催收员姓名
		,approved_by as 处理人姓名
		,审核人
		,input(substr(compress(审核时间),1,10),yymmdd10.) format yymmdd10. as 审核日期
		,结清状态
		,handle_time
		,handle_period
		,case_from as 进件渠道
		,城市地区
		,营业部
		,业务模式
		,减免金额
		from derate_log_&dd. as a
		left join derate_workorder_&dd. as b on a.合同号=input(b.contractno,24.)
;
quit;

proc delete data = clear not_clear;run;
/*proc export data=os_recent_log*/
/*  outfile="E:\CREDITEASE\需求数据\系统组外包案件需求\外包案件截止20170705"*/
/*  dbms=xlsx replace;*/
/*run;*/
