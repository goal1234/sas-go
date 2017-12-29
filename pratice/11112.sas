
libname outlog "F:\�����ձ�\sas_data";

%let dtn=20171220;			/*�����ϸʱ��*/
%let d="&sysdate9."d;		/*����͹����ļ�ʱ��*/
%let dd=%sysfunc(putn(&D,yymmddn8.));
 
%put &dd.;

options validvarname=any compress=yes user=outlog;
/**/
/*<<<<<<<<ʯ�Σ��������ί����ϸ*/
/*<<<<<<<<<<<<<<<<<<ÿ��5,20������һ��*/
/*������־��Ҫ����;*/
/**/
/**/
/*proc import*/
/*out=os_city*/
/*datafile="F:\�����ձ�\input\&dtn.���ΰ�����ϸ.xlsx"*/
/*dbms=excel replace;*/
/*sheet="������ϸ";*/
/*run;*/
/**/
/**/
/**/
/**/
/*data os_his_log;*/
/*set os_city(keep=�¿ͻ��� ��ͬ�� �ͻ����� ��˾ ί������ �᰸���� ״̬) */
/*os_notcity(keep=�¿ͻ��� ��ͬ�� �ͻ����� ��˾ ί������ �᰸���� ״̬);*/
/*rename 	�¿ͻ���=client_id*/
/*		��ͬ��=contractno*/
/*		�ͻ�����=client_name*/
/*		��˾=company*/
/*		ί������=out_assigndate*/
/*		�᰸����=out_enddate*/
/*		״̬=status*/
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



*----1.1�ǽ�������ͬ��ϸ----*;
proc import 
  out=derate_notclear
    datafile="F:\�����ձ�\ҵ��֧������\������ʷ�б�_&dd..xls"
  dbms=excel replace;
run;
*--1.1.1����δ����---*;
proc sql;
create table not_clear as
select 	distinct
		input(��ͬ��,20.) format 20. as ��ͬ��
		,�ͻ�����
		,���е���,Ӫҵ��
		,�������״̬
		,����������
		,����ע��,�����,���ʱ��,���Ĵ�����,"�ǽ���" as ����״̬,ҵ��ģʽ
		,input(���ⷣϢ���,20.2)+input(����ΥԼ����,20.2)+input(���ⱾϢ���ɽ���,20.2)+input(�����������ɽ���,20.2) as ������
		from derate_notclear
		where ����� in ("����","�º��") and �������״̬="ͨ��" and ���Ĵ�����='�ɹ�'
;quit;


*----1.2��������ͬ��ϸ-----*;
proc import 
  out=derate_clear
    datafile="F:\�����ձ�\ҵ��֧������\���������ʷ�б�_&dd..xls"
  dbms=excel replace;
run;
*---1.2.1�������---*;
proc sql;
create table clear as 
select 	distinct
		input(��ͬ��,20.) format 20. as ��ͬ��
		,�ͻ�����
		,���е���,Ӫҵ��
		,����������״̬ as �������״̬
		,������ as ����������
		,����ע��,�����,���ʱ��,���Ĵ�����,"����" as ����״̬,ҵ��ģʽ
		,input(���������,20.2) as ������
		from derate_clear 
		where ����� in ("����","�º��","¬��ϼ") and ����������״̬='�����' and ���Ĵ�����='�ɹ�'
;quit; 

*--------------result_1.����ͷǽ�������ͬ����------------*;
data derate_log_&dd.;
  informat �ͻ����� $20.;
  informat ���е��� $20.;
  informat Ӫҵ�� $40.;
  informat ���Ĵ����� $80.;
  informat ����״̬ $6.;
  informat ����ע�� $80.;
  informat �����  $8.;
  format �����  $8.;
set  not_clear clear;
run;


*----2.����ϵͳ����----*;
proc import 
  out=derate_workorder
    datafile="F:\�����ձ�\ҵ��֧������\������⹤������&dd.sum.xlsx"
  dbms=excel replace;
run;
*---2.1.1ʱ��ɸѡ---*;
data derate_workorder_&dd.;
set derate_workorder
(keep=������Դ ��������ʱ�� ���������� �ͻ����� ��ͬ��� �Ƿ���� ����ʱ�� ���������� ����ʱ�� ����ʱ��);
��ͬ���1=compress(��ͬ���);
rename 	������Դ=case_from
		��������ʱ��=submit_time
		����������=submitted_by
		�ͻ�����=client_name
		��ͬ���1=contractno
		�Ƿ����=if_satisfy
		����ʱ��=approved_time
		����������=approved_by
		����ʱ��=handle_time
		����ʱ��=handle_period;
if �Ƿ����="����";
approved_time1=input(substr(compress(����ʱ��),1,10),yymmdd10.);
format approved_time1 yymmdd10.;

if weekday(&d.-2) in (1,2) or day(&d.-1) in (15,30) then range=10;   
/*&d.Ϊ���죬&d-1Ϊ�ձ�ʱ�䣬&d.-2����Ϊweekday=1��sunday.��ˣ���һ���ܶ�����15��30�˵��գ�����ǰ��ȡ�������ʱ�����ο�*/
else range=3;

if approved_time1>=&d.-range or ����ʱ��=&d.-1;

drop range;
run;

*----�����¼ƥ�乤��ϵͳ�ύ��----*;
proc sql;
create table derate_final&dd. as
select 	distinct
		b.submit_time as �ύʱ��
		,a.��ͬ��
		,�ͻ�����
		,����ע�� as ��������
		,submitted_by as ����Ա����
		,approved_by as ����������
		,�����
		,input(substr(compress(���ʱ��),1,10),yymmdd10.) format yymmdd10. as �������
		,����״̬
		,handle_time
		,handle_period
		,case_from as ��������
		,���е���
		,Ӫҵ��
		,ҵ��ģʽ
		,������
		from derate_log_&dd. as a
		left join derate_workorder_&dd. as b on a.��ͬ��=input(b.contractno,24.)
;
quit;

proc delete data = clear not_clear;run;
/*proc export data=os_recent_log*/
/*  outfile="E:\CREDITEASE\��������\ϵͳ�������������\���������ֹ20170705"*/
/*  dbms=xlsx replace;*/
/*run;*/
