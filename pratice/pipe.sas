

*��ȡ�ļ����������ļ���ͬʱ����һ�����ݼ�;

%MACRO GET_PC_FILES_IN_FOLDER(DIRNAME,TYP)     ;/*������������·�����ļ����ͺ�׺*/
    %PUT %STR(----------->DIRNAME=&DIRNAME)        ;
    %PUT %STR(----------->TYP=&TYP)                ;
    DATA WORK.DIRFILES                             ;    
    RC=FILENAME("DIR","&DIRNAME")             ;/*��&DIRNAMEֵ�����ļ����÷���DIR"*/   
    OPENFILE=DOPEN("DIR")                     ;/*�õ�·����ʾ��OPENFILE��DOPEN�Ǵ�directory��sas���ú���*/
    IF OPENFILE>0 THEN DO                     ;/*���OPENFILE>0��ʾ��ȷ��·��*/       
      NUMMEM=DNUM(OPENFILE)                   ;/*�õ�·����ʾ��OPENFILE��member�ĸ���nummem*/       
      DO II=1 TO NUMMEM                       ;          
         NAME=DREAD(OPENFILE,II)              ;/*��DREAD���ζ�ȡÿ���ļ������ֵ�NAME*/          
         OUTPUT                               ;/*�������*/       
      END                                     ;    
    END                                       ;    
    KEEP NAME                                 ;/*ֻ����NAME��*/
 RUN                                          ;
 PROC SORT                                    ;/*����NAME����*/    
     BY DESCENDING NAME                       ;
     %IF &TYP^=ALL %THEN %DO                  ;/*�Ƿ�����ض����ļ�����&TYP*/    
       WHERE  INDEX(UPCASE(NAME),UPCASE(".&TYP"));/*Y,��ͨ������NAME�Ƿ����&TYP�ķ�ʽ�����ļ�����*/
     %END                  
RUN                                            ;
 %MEND   GET_PC_FILES_IN_FOLDE;

%GET_PC_FILES_IN_FOLDER(F:\���մ���\201710���մ���\,csv );


filename dirpipe pipe "dir &path..";
data ReadPipe(drop = DataString);
    infile dirpipe firstobs=8 truncover;
    input DataString $1-10 @;
    if DataString = "" then stop;
    input @1 Date:yymmdd10. Time&:time.
    Bytes:comma. FileName:$64.;
    if Bytes ge 0;
    format Date mmddyy10. Time timeampm8. Bytes comma18.;
    if _n_ = 1 then call symput("ExcelName", strip(FileName));
run;
*%put &ExcelName.;
proc contents data=dirpipe;
run;
filename dirpipe clear;


    filename indata pipe "dir d:\sas\xml /b";

    data vname;
    length fname $20.;
    infile indata truncover;
    input fname $20.;
    call symput ('nvars',_n_);
    run;
    %macro want;
    %do i=1 %to &nvars.;
            data _null_;
                    set vname;
                    if _n_=&i;
                    call symput ('file',fname);
            run;
            data tmp;
                    infile "d:\sas\xml\&file." firstobs=2;
                    input x y z;
            run;
            proc datasets;
                    append base=want data=tmp;
            quit;
    %end;
    %mend;
    %want
