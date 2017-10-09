/* CISER COMPUTING CONSULTING */
/* SAMPLE SAS PROGRAM "AG_CEN.SAS" */
 
/* Program to pull data for the years 1982, 1987, and 1992 
   from the 1992 Census of Agriculture for NY State. */
/* Program reads the data file "cag92.usco" saved in
   folder "V:\cag\009\" */
/* Uses PROC TRANSPOSE in a macro to create a transposed dataset for 
   individual years. */


options ls=79;
libname ssd "U:\" ;
filename in "V:\cag\009\cag92.usco" lrecl=48;

data temp1;
  infile in;
length nitem 4;
    input st $ 2-3 nitem 7-12 @;

if st = "36" then do;

   if nitem in 
	(30029,40002,40003,40004,40005,40007,40008,
	40027,40028,50001,50002,60001,60002,60005,
	60020,60022,60024,60026,60028,60030,60032,
	60034,60036,60038,60040,60042,90002,110022,
	110049,110051,110053,110055,110057,130005,
	130006,130035,130036,130085,130086,130108,
	130109,130188,130189,140035,140036,140085,
	140086,140136,140137,150031,150032,160034,
	160035,370001,380001) then do;
             input fips $ 2-6 item $ 7-12
		f92 $ 13 d92  14-24;
		f87 $ 25 d87  26-36; 
                f82 $ 37 d82 38-48;  
     end;
     else delete;

end; else delete;

* modify item code to begin with a character;
* d is for data and f is for flag;
  d="D";
  ditem= d || item;
  f="F";
  fitem= f || item;

  drop st d f;

proc sort data=temp1;
  by fips item;

* define a macro to perform data transformations;
%macro trans (yr=);

* transpose data items for a single year;
proc transpose data=temp1 out=ssd.tran_d&yr;
  var d&yr;
    by fips;
      id ditem;

* transpose flag data for a single year;
proc transpose data=temp1 out=ssd.tran_f&yr;
   var f&yr;
     by fips;
       id fitem;

* merge transposed data and flags for a single year;
data ssd.ocag&yr;
   merge ssd.tran_d&yr ssd.tran_f&yr;
    by fips;
	rwid = input(fips,5.0);

data ssd.cag&yr;
   set ssd.ocag&yr;
	rename 
		d030029=fhw&yr
		d040002=tncr&yr
		d040003=ancr&yr
		d040004=fncg&yr
		d040005=vncg&yr
		d040007=fncl&yr
		d040008=vncl&yr
		d040027=fsdc&yr
		d040028=tvds&yr
		d050001=fhw&yr
		d050002=tnw&yr
		d060001=frms&yr
		d060002=acrs&yr
		d060005=vlb&yr
		d060020=f1a&yr
		d060022=f2a&yr
		d060024=f3a&yr
		d060026=f4a&yr
		d060028=f5a&yr
		d060030=f6a&yr
		d060032=f7a&yr
		d060034=f8a&yr
		d060036=f9a&yr
		d060038=f10a&yr
		d060040=f11a&yr
		d060042=f12a&yr
		d090002=vme&yr
		d110022=occf&yr
		d110049=ffo&yr
		d110051=ifof&yr
		d110053=part&yr
		d110055=fhc&yr
		d110057=nfhc&yr
		d130005=fscgs&yr
		d130006=tacgs&yr
		d130035=fswg&yr
		d130036=tawg&yr
		d130085=fscot&yr
		d130086=tacot&yr
		d130108=fssbb&yr
		d130109=tasbb&yr
		d130188=fsveg&yr
		d130189=taveg&yr
		d140035=fmc&yr
		d140036=tmc&yr
		d140085=fscc&yr
		d140086=qscc&yr
		d140136=fsfc&yr
		d140137=qsfc&yr
		d150031=fshp&yr
		d150032=qshp&yr
		d160034=fsbmc&yr
		d160035=qsbmc&yr
		d370001=bfo&yr
		d380001=hfo&yr;
	rename
		f030029=xfhw&yr
		f040002=xtncr&yr
		f040003=xancr&yr
		f040004=xfncg&yr
		f040005=xvncg&yr
		f040007=xfncl&yr
		f040008=xvncl&yr
		f040027=xfsdc&yr
		f040028=xtvds&yr
		f050001=xfhw&yr
		f050002=xtnw&yr
		f060001=xfrms&yr
		f060002=xacrs&yr
		f060005=xvlb&yr
		f060020=xf1a&yr
		f060022=xf2a&yr
		f060024=xf3a&yr
		f060026=xf4a&yr
		f060028=xf5a&yr
		f060030=xf6a&yr
		f060032=xf7a&yr
		f060034=xf8a&yr
		f060036=xf9a&yr
		f060038=xf10a&yr
		f060040=xf11a&yr
		f060042=xf12a&yr
		f090002=xvme&yr
		f110022=xoccf&yr
		f110049=xffo&yr
		f110051=xifof&yr
		f110053=xpart&yr
		f110055=xfhc&yr
		f110057=xnfhc&yr
		f130005=xfscgs&yr
		f130006=xtacgs&yr
		f130035=xfswg&yr
		f130036=xtawg&yr
		f130085=xfscot&yr
		f130086=xtacot&yr
		f130108=xfssbb&yr
		f130109=xtasbb&yr
		f130188=xfsveg&yr
		f130189=xtaveg&yr
		f140035=xfmc&yr
		f140036=xtmc&yr
		f140085=xfscc&yr
		f140086=xqscc&yr
		f140136=xfsfc&yr
		f140137=xqsfc&yr
		f150031=xfshp&yr
		f150032=xqshp&yr
		f160034=xfsbmc&yr
		f160035=xqsbmc&yr
		f370001=xbfo&yr
		f380001=xhfo&yr;
drop _name_;
proc contents;

* remove transposed data sets;
proc datasets library=ssd;
     delete tran_d&yr tran_f&yr cag&yr;

%mend;

* call macro for years 1992, 1987, and 1982;
%trans (yr=92);
%trans (yr=87);
%trans (yr=82);


