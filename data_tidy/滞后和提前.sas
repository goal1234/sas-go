option user = work;

*---��ǰ�������---*;
data b;
  set sashelp.air;
   lag_1 = lag(air);
   lag_2 = lag2(air);
   dif_1 = dif(air);
   dif_2 = dif2(air);
   lead1 = air - dif_1;
   lead2 = air - dif_2;
run;

*---�۲�ѡȡ---*;
