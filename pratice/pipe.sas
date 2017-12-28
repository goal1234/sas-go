

*获取文件夹下所有文件名同时生产一个数据集;

%MACRO GET_PC_FILES_IN_FOLDER(DIRNAME,TYP)     ;/*参数有两个：路径，文件类型后缀*/
    %PUT %STR(----------->DIRNAME=&DIRNAME)        ;
    %PUT %STR(----------->TYP=&TYP)                ;
    DATA WORK.DIRFILES                             ;    
    RC=FILENAME("DIR","&DIRNAME")             ;/*把&DIRNAME值传给文件引用符“DIR"*/   
    OPENFILE=DOPEN("DIR")                     ;/*得到路径标示符OPENFILE，DOPEN是打开directory的sas内置函数*/
    IF OPENFILE>0 THEN DO                     ;/*如果OPENFILE>0表示正确打开路径*/       
      NUMMEM=DNUM(OPENFILE)                   ;/*得到路径标示符OPENFILE中member的个数nummem*/       
      DO II=1 TO NUMMEM                       ;          
         NAME=DREAD(OPENFILE,II)              ;/*用DREAD依次读取每个文件的名字到NAME*/          
         OUTPUT                               ;/*依次输出*/       
      END                                     ;    
    END                                       ;    
    KEEP NAME                                 ;/*只保留NAME列*/
 RUN                                          ;
 PROC SORT                                    ;/*按照NAME排序*/    
     BY DESCENDING NAME                       ;
     %IF &TYP^=ALL %THEN %DO                  ;/*是否过滤特定的文件类型&TYP*/    
       WHERE  INDEX(UPCASE(NAME),UPCASE(".&TYP"));/*Y,则通过检索NAME是否包含&TYP的方式过滤文件类型*/
     %END                  
RUN                                            ;
 %MEND   GET_PC_FILES_IN_FOLDE;

%GET_PC_FILES_IN_FOLDER(F:\催收代码\201710催收代码\,csv );


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
